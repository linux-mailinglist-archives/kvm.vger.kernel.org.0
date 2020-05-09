Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695A01CBCBA
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 05:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgEIDEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 23:04:10 -0400
Received: from mga12.intel.com ([192.55.52.136]:55138 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbgEIDEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 23:04:09 -0400
IronPort-SDR: ZKr9Wk68/Pl3/Opp8VOpwDalsIlqjiWG3+g9zheNQnvSXXrE+BQajGgkZgyavLXced71Q4d5rS
 M/iNyRzH9pIw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 20:04:08 -0700
IronPort-SDR: o2QC/4o0beIrhW/7RJufTIdgMZFUc4WpQSPUDvwdSOz33dN//gpE/k1PcxXCvrgXQejN7GRWQ1
 DUktOluMBc0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,370,1583222400"; 
   d="scan'208";a="408311125"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga004.jf.intel.com with ESMTP; 08 May 2020 20:04:03 -0700
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
Subject: [PATCH v9 8/8] x86/split_lock: Enable split lock detection initialization when running as an guest on KVM
Date:   Sat,  9 May 2020 19:05:42 +0800
Message-Id: <20200509110542.8159-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200509110542.8159-1-xiaoyao.li@intel.com>
References: <20200509110542.8159-1-xiaoyao.li@intel.com>
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
index a57f00f1d5b5..5d5b488b4b45 100644
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
index 1e2a74e8c592..02e24134b9b5 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -996,12 +996,18 @@ static bool split_lock_verify_msr(bool on)
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
@@ -1037,6 +1043,7 @@ static void __init split_lock_setup(void)
 		return;
 	}
 
+set_cap:
 	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
 	if (state == sld_fatal)
 		setup_force_cpu_cap(X86_FEATURE_SLD_FATAL);
@@ -1161,6 +1168,7 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 	const struct x86_cpu_id *m;
 	u64 ia32_core_caps;
 
+	/* Note, paravirt support can enable SLD, e.g., see kvm_guest_init(). */
 	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return;
 
@@ -1182,5 +1190,5 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 		return;
 	}
 
-	split_lock_setup();
+	split_lock_setup(false);
 }
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6efe0410fb72..489ea89e2e8e 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -670,6 +670,9 @@ static void __init kvm_guest_init(void)
 	 * overcommitted.
 	 */
 	hardlockup_detector_disable();
+
+	if (kvm_para_has_feature(KVM_FEATURE_SPLIT_LOCK_DETECT))
+		split_lock_setup(kvm_para_has_hint(KVM_HINTS_SLD_FATAL));
 }
 
 static noinline uint32_t __kvm_cpuid_base(void)
-- 
2.18.2

