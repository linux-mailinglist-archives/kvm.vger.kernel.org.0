Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA60E249539
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 08:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgHSGsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 02:48:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:36213 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727837AbgHSGse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 02:48:34 -0400
IronPort-SDR: z1QfULGvEti6kxPLp08fG39mAIYs3epiX6XgLhQ3KDp0eCswPztW+fGq2oOOzYQpgSWRzUt8mM
 SoEfYsxA2U+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="142873227"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="142873227"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 23:47:43 -0700
IronPort-SDR: cV9yIn8CNzAuQ9dD4QKZGOyYfqpdNqUPWFDmjSJqBexS2Lej9J5x/4spPjNQ4C7uxPKbsM19KV
 WqO2S0RrsLEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="310679331"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2020 23:47:40 -0700
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
Subject: [PATCH v10 9/9] x86/split_lock: Enable split lock detection initialization when running as a guest on KVM
Date:   Wed, 19 Aug 2020 14:47:07 +0800
Message-Id: <20200819064707.1033569-10-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200819064707.1033569-1-xiaoyao.li@intel.com>
References: <20200819064707.1033569-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running as guest, enumerating feature split lock detection through
CPU model is not easy since CPU model is configurable by host VMM.

If running upon KVM, it can be enumerated through
KVM_FEATURE_SPLIT_LOCK_DETECT, and if KVM_HINTS_SLD_FATAL is set, it
needs to be set to sld_fatal mode.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpu.h  |  2 ++
 arch/x86/kernel/cpu/intel.c | 12 ++++++++++--
 arch/x86/kernel/kvm.c       |  3 +++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 2971a29d5094..5520cc1cbb68 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -42,12 +42,14 @@ unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
 #ifdef CONFIG_CPU_SUP_INTEL
 extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
+extern void __init split_lock_setup(bool fatal);
 extern void switch_to_sld(unsigned long tifn);
 extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
 extern bool handle_guest_split_lock(unsigned long ip);
 extern bool split_lock_virt_switch(bool on);
 #else
 static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
+static inline void __init split_lock_setup(bool fatal) {}
 static inline void switch_to_sld(unsigned long tifn) {}
 static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
 {
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index b16f3dd9b9c2..8cadd2fd8be6 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1011,12 +1011,18 @@ static bool split_lock_verify_msr(bool on)
 	return ctrl == tmp;
 }
 
-static void __init split_lock_setup(void)
+void __init split_lock_setup(bool fatal)
 {
 	enum split_lock_detect_state state = sld_warn;
 	char arg[20];
 	int i, ret;
 
+	if (fatal) {
+		state = sld_fatal;
+		pr_info("forced on, sending SIGBUS on user-space split_locks\n");
+		goto set_cap;
+	}
+
 	if (!split_lock_verify_msr(false)) {
 		pr_info("MSR access failed: Disabled\n");
 		return;
@@ -1052,6 +1058,7 @@ static void __init split_lock_setup(void)
 		return;
 	}
 
+set_cap:
 	cpu_model_supports_sld = true;
 	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
 	if (state == sld_fatal)
@@ -1183,6 +1190,7 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 	const struct x86_cpu_id *m;
 	u64 ia32_core_caps;
 
+	/* Note, paravirt support can enable SLD, e.g., see kvm_guest_init(). */
 	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return;
 
@@ -1204,5 +1212,5 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 		return;
 	}
 
-	split_lock_setup();
+	split_lock_setup(false);
 }
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 08320b0b2b27..25cd5d7f1e51 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -687,6 +687,9 @@ static void __init kvm_guest_init(void)
 	 * overcommitted.
 	 */
 	hardlockup_detector_disable();
+
+	if (kvm_para_has_feature(KVM_FEATURE_SPLIT_LOCK_DETECT))
+		split_lock_setup(kvm_para_has_hint(KVM_HINTS_SLD_FATAL));
 }
 
 static noinline uint32_t __kvm_cpuid_base(void)
-- 
2.18.4

