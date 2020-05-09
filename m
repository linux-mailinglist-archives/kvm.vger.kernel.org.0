Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7B81CBCB3
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 05:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgEIDDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 23:03:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:55120 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbgEIDDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 23:03:52 -0400
IronPort-SDR: U9l+Iq81pNEVyB5k8csACETrXBqnYFWSbA+sWzf9+YzS5IgrP7HZzGLUYgjeJnB+xSaxyicstU
 2UBgfPzbZ3TQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 20:03:52 -0700
IronPort-SDR: XnVfzQjeJ2drVnSfFyargOrUUqXVWmNQRzk+Vucny6ZydagwnsP8bRWSVS+Ilnsfg1/MU8DSz3
 qolzq8oKEq7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,370,1583222400"; 
   d="scan'208";a="408311062"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga004.jf.intel.com with ESMTP; 08 May 2020 20:03:48 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 4/8] x86/split_lock: Introduce split_lock_virt_switch() and two wrappers
Date:   Sat,  9 May 2020 19:05:38 +0800
Message-Id: <20200509110542.8159-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200509110542.8159-1-xiaoyao.li@intel.com>
References: <20200509110542.8159-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce split_lock_virt_switch(), which is used for toggling split
lock detection setting as well as updating TIF_SLD_DISABLED flag to make
them consistent. Note, it can only be used in sld warn mode, i.e.,
X86_FEATURE_SPLIT_LOCK_DETECT && !X86_FEATURE_SLD_FATAL.

The FATAL check is handled by wrappers, split_lock_set_guest() and
split_lock_restore_host(), that will be used by KVM when virtualizing
split lock detection for guest in the future.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpu.h  | 33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c | 20 ++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index dd17c2da1af5..a57f00f1d5b5 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -45,6 +45,7 @@ extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
 extern void switch_to_sld(unsigned long tifn);
 extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
 extern bool handle_guest_split_lock(unsigned long ip);
+extern bool split_lock_virt_switch(bool on);
 #else
 static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
 static inline void switch_to_sld(unsigned long tifn) {}
@@ -57,5 +58,37 @@ static inline bool handle_guest_split_lock(unsigned long ip)
 {
 	return false;
 }
+
+static inline bool split_lock_virt_switch(bool on) { return false; }
 #endif
+
+/**
+ * split_lock_set_guest - Set SLD state for a guest
+ * @guest_sld_on:	If SLD is on in the guest
+ *
+ * returns:		%true if SLD was enabled in the task
+ *
+ * Must be called when X86_FEATURE_SPLIT_LOCK_DETECT is available.
+ */
+static inline bool split_lock_set_guest(bool guest_sld_on)
+{
+	if (static_cpu_has(X86_FEATURE_SLD_FATAL))
+		return true;
+
+	return split_lock_virt_switch(guest_sld_on);
+}
+
+/**
+ * split_lock_restore_host - Restore host SLD state
+ * @host_sld_on:		If SLD is on in the host
+ *
+ * Must be called when X86_FEATURE_SPLIT_LOCK_DETECT is available.
+ */
+static inline void split_lock_restore_host(bool host_sld_on)
+{
+	if (static_cpu_has(X86_FEATURE_SLD_FATAL))
+		return;
+
+	split_lock_virt_switch(host_sld_on);
+}
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 93b8ccf2fa11..1e2a74e8c592 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1062,6 +1062,26 @@ static void split_lock_init(void)
 	split_lock_verify_msr(boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT));
 }
 
+/*
+ * It should never be called directly but should use split_lock_set_guest()
+ * and split_lock_restore_host() instead.
+ *
+ * The caller needs to be in preemption disabled context to ensure
+ * MSR state and TIF_SLD_DISABLED state consistent.
+ */
+bool split_lock_virt_switch(bool on)
+{
+	bool was_on = !test_thread_flag(TIF_SLD_DISABLED);
+
+	if (on != was_on) {
+		sld_update_msr(on);
+		update_thread_flag(TIF_SLD_DISABLED, !on);
+	}
+
+	return was_on;
+}
+EXPORT_SYMBOL_GPL(split_lock_virt_switch);
+
 static void split_lock_warn(unsigned long ip)
 {
 	pr_warn_ratelimited("#AC: %s/%d took a split_lock trap at address: 0x%lx\n",
-- 
2.18.2

