Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0483224952D
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 08:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgHSGrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 02:47:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:36140 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbgHSGrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 02:47:36 -0400
IronPort-SDR: x7Tdt1GcXKxE+0e2T17tK4RjXaGBpgurmqYUsUIx2NB0+A9Z/FIZpc+s6sLqgmI2C4UxLpvLs1
 HaabXkXAA5zA==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="142873190"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="142873190"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 23:47:26 -0700
IronPort-SDR: ORgDixJMGdr8e78QEjK7c2yr5RMTBuVnzyK47p7UyumuV+XAbCNmY9CtcoZbLVU/wIjGGBEhoX
 LEb6V5PyNaAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="310679286"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2020 23:47:23 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v10 4/9] x86/split_lock: Introduce split_lock_virt_switch() and two wrappers
Date:   Wed, 19 Aug 2020 14:47:02 +0800
Message-Id: <20200819064707.1033569-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200819064707.1033569-1-xiaoyao.li@intel.com>
References: <20200819064707.1033569-1-xiaoyao.li@intel.com>
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
 arch/x86/include/asm/cpu.h  | 34 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c | 20 ++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index da78ccbd493b..2971a29d5094 100644
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
@@ -57,7 +58,40 @@ static inline bool handle_guest_split_lock(unsigned long ip)
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
+
 #ifdef CONFIG_IA32_FEAT_CTL
 void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
 #else
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 06de03974e66..5f44e0de04b9 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1078,6 +1078,26 @@ static void split_lock_init(void)
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
2.18.4

