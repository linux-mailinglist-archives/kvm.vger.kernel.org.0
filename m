Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D194AE3E
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731153AbfFRWwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:52:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:51708 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730898AbfFRWvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:51:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 15:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,390,1557212400"; 
   d="scan'208";a="358009384"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jun 2019 15:51:12 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Radim Krcmar" <rkrcmar@redhat.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Sai Praneeth Prakhya" <sai.praneeth.prakhya@intel.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v9 14/17] x86/split_lock: Add a debugfs interface to enable/disable split lock detection during run time
Date:   Tue, 18 Jun 2019 15:41:16 -0700
Message-Id: <1560897679-228028-15-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To workaround or debug a split lock issue, the administrator may need to
disable or enable split lock detection during run time without rebooting
the system.

The interface /sys/kernel/debug/x86/split_lock_detect is added to allow
the administrator to disable or enable split lock detection and show
current split lock detection setting during run time.

Writing [yY1] or [oO][nN] to the file enables split lock detection and
writing [nN0] or [oO][fF] disables split lock detection. Split lock
detection is enabled or disabled on all CPUs.

Reading the file returns current global split lock detection setting:
0: disabled
1: enabled

To simplify the code, Ingo suggests to use the global atomic
split_lock_debug flag both for warning split lock in WARN_ONCE() and for
writing the debugfs interface.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 121 +++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/traps.c     |   3 +-
 2 files changed, 121 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 4a854f051cf4..4005342dfdd0 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -9,6 +9,8 @@
 #include <linux/thread_info.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
+#include <linux/syscore_ops.h>
+#include <linux/debugfs.h>
 
 #include <asm/cpufeature.h>
 #include <asm/pgtable.h>
@@ -630,8 +632,19 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
 	wrmsrl(MSR_MISC_FEATURES_ENABLES, msr);
 }
 
-static void split_lock_update_msr(void)
+static void split_lock_update_msr(void *__unused)
 {
+	unsigned long flags;
+
+	/*
+	 * Need to prevent msr_test_ctl_cached from being changed *and*
+	 * completing its WRMSR between our read and our WRMSR. By turning
+	 * IRQs off here, ensure that no split lock debugfs write happens
+	 * on this CPU and that any concurrent debugfs write from a different
+	 * CPU will not finish updating us via IPI until we're done.
+	 */
+	local_irq_save(flags);
+
 	if (split_lock_detect_enabled) {
 		/* Enable split lock detection */
 		this_cpu_or(msr_test_ctl_cached, MSR_TEST_CTL_SPLIT_LOCK_DETECT);
@@ -640,6 +653,8 @@ static void split_lock_update_msr(void)
 		this_cpu_and(msr_test_ctl_cached, ~MSR_TEST_CTL_SPLIT_LOCK_DETECT);
 	}
 	wrmsrl(MSR_TEST_CTL, this_cpu_read(msr_test_ctl_cached));
+
+	local_irq_restore(flags);
 }
 
 static void split_lock_init(struct cpuinfo_x86 *c)
@@ -651,7 +666,7 @@ static void split_lock_init(struct cpuinfo_x86 *c)
 		rdmsrl(MSR_TEST_CTL, test_ctl_val);
 		this_cpu_write(msr_test_ctl_cached, test_ctl_val);
 
-		split_lock_update_msr();
+		split_lock_update_msr(NULL);
 	}
 }
 
@@ -1077,10 +1092,23 @@ static atomic_t split_lock_debug;
 
 void split_lock_disable(void)
 {
+	unsigned long flags;
+
+	/*
+	 * Need to prevent msr_test_ctl_cached from being changed *and*
+	 * completing its WRMSR between our read and our WRMSR. By turning
+	 * IRQs off here, ensure that no split lock debugfs write happens
+	 * on this CPU and that any concurrent debugfs write from a different
+	 * CPU will not finish updating us via IPI until we're done.
+	 */
+	local_irq_save(flags);
+
 	/* Disable split lock detection on this CPU */
 	this_cpu_and(msr_test_ctl_cached, ~MSR_TEST_CTL_SPLIT_LOCK_DETECT);
 	wrmsrl(MSR_TEST_CTL, this_cpu_read(msr_test_ctl_cached));
 
+	local_irq_restore(flags);
+
 	/*
 	 * Use the atomic variable split_lock_debug to ensure only the
 	 * first CPU hitting split lock issue prints one single complete
@@ -1094,3 +1122,92 @@ void split_lock_disable(void)
 		atomic_set(&split_lock_debug, 0);
 	}
 }
+
+static ssize_t split_lock_detect_rd(struct file *f, char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	unsigned int len;
+	char buf[8];
+
+	len = sprintf(buf, "%u\n", split_lock_detect_enabled);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t split_lock_detect_wr(struct file *f, const char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	unsigned int len;
+	char buf[8];
+	bool val;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtobool(buf, &val))
+		return -EINVAL;
+
+	while (atomic_cmpxchg(&split_lock_debug, 1, 0))
+		cpu_relax();
+
+	if (split_lock_detect_enabled == val)
+		goto out_unlock;
+
+	split_lock_detect_enabled = val;
+
+	/* Update the split lock detection setting in MSR on all online CPUs. */
+	on_each_cpu(split_lock_update_msr, NULL, 1);
+
+	if (split_lock_detect_enabled)
+		pr_info("enabled\n");
+	else
+		pr_info("disabled\n");
+
+out_unlock:
+	atomic_set(&split_lock_debug, 0);
+
+	return count;
+}
+
+static const struct file_operations split_lock_detect_fops = {
+	.read = split_lock_detect_rd,
+	.write = split_lock_detect_wr,
+	.llseek = default_llseek,
+};
+
+/*
+ * Before resume from hibernation, TEST_CTL MSR has been initialized to
+ * default value in split_lock_init() on BP. On resume, restore the MSR
+ * on BP to previous value which could be changed by debugfs and thus could
+ * be different from the default value.
+ *
+ * The MSR on BP is supposed not to be changed during suspend and thus it's
+ * unnecessary to set it again during resume from suspend. But at this point
+ * we don't know resume is from suspend or hibernation. To simplify the
+ * situation, just set up the MSR on resume from suspend.
+ *
+ * Set up the MSR on APs when they are re-added later.
+ */
+static void split_lock_syscore_resume(void)
+{
+	split_lock_update_msr(NULL);
+}
+
+static struct syscore_ops split_lock_syscore_ops = {
+	.resume = split_lock_syscore_resume,
+};
+
+static int __init split_lock_detect_initcall(void)
+{
+	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
+		debugfs_create_file("split_lock_detect", 0600, arch_debugfs_dir,
+				    NULL, &split_lock_detect_fops);
+
+		register_syscore_ops(&split_lock_syscore_ops);
+	}
+
+	return 0;
+}
+late_initcall(split_lock_detect_initcall);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 38143c028f5a..691e34828bdf 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -324,7 +324,8 @@ dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code)
 		 * execution context.
 		 *
 		 * Split-lock detection will remain disabled after this,
-		 * until the next reboot.
+		 * until the next reboot or until it is re-enabled by
+		 * debugfs interface /sys/kernel/debug/x86/split_lock_detect.
 		 */
 		split_lock_disable();
 
-- 
2.19.1

