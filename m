Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAF31F00BA
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 22:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgFEUHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 16:07:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:29603 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727863AbgFEUHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 16:07:31 -0400
IronPort-SDR: 9+/foVPL4zKWpLFPjcMZ5jOulC2NGrrkaSmrW0fmrRkxCSZDxFduUa77/GlPCsfV9GwjecvihX
 ZFVqsJkSugug==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 13:07:30 -0700
IronPort-SDR: isHsEJJwy5bDEQA3VzN4WLRvdBKo8wguUddVPlTivtJSK5oLw205TZHHBA1nmxfFh3FXYe6Yxy
 6rJTfRuXs+0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="305171032"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jun 2020 13:07:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Brad Campbell <lists2009@fnarfbargle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during wakeup
Date:   Fri,  5 Jun 2020 13:07:28 -0700
Message-Id: <20200605200728.10145-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reinitialize IA32_FEAT_CTL on the BSP during wakeup to handle the case
where firmware doesn't initialize or save/restore across S3.  This fixes
a bug where IA32_FEAT_CTL is left uninitialized and results in VMXON
taking a #GP due to VMX not being fully enabled, i.e. breaks KVM.

Use init_ia32_feat_ctl() to "restore" IA32_FEAT_CTL as it already deals
with the case where the MSR is locked, and because APs already redo
init_ia32_feat_ctl() during suspend by virtue of the SMP boot flow being
used to reinitialize APs upon wakeup.  Do the call in the early wakeup
flow to avoid dependencies in the syscore_ops chain, e.g. simply adding
a resume hook is not guaranteed to work, as KVM does VMXON in its own
resume hook, kvm_resume(), when KVM has active guests.

Reported-by: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Fixes: 21bd3467a58e ("KVM: VMX: Drop initialization of IA32_FEAT_CTL MSR")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/cpu.h | 5 +++++
 arch/x86/kernel/cpu/cpu.h  | 4 ----
 arch/x86/power/cpu.c       | 6 ++++++
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index dd17c2da1af5..da78ccbd493b 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -58,4 +58,9 @@ static inline bool handle_guest_split_lock(unsigned long ip)
 	return false;
 }
 #endif
+#ifdef CONFIG_IA32_FEAT_CTL
+void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
+#else
+static inline void init_ia32_feat_ctl(struct cpuinfo_x86 *c) {}
+#endif
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 37fdefd14f28..38ab6e115eac 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -80,8 +80,4 @@ extern void x86_spec_ctrl_setup_ap(void);
 
 extern u64 x86_read_arch_cap_msr(void);
 
-#ifdef CONFIG_IA32_FEAT_CTL
-void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
-#endif
-
 #endif /* ARCH_X86_CPU_H */
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index aaff9ed7ff45..b0d3c5ca6d80 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -193,6 +193,8 @@ static void fix_processor_context(void)
  */
 static void notrace __restore_processor_state(struct saved_context *ctxt)
 {
+	struct cpuinfo_x86 *c;
+
 	if (ctxt->misc_enable_saved)
 		wrmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
 	/*
@@ -263,6 +265,10 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	mtrr_bp_restore();
 	perf_restore_debug_store();
 	msr_restore_context(ctxt);
+
+	c = &cpu_data(smp_processor_id());
+	if (cpu_has(c, X86_FEATURE_MSR_IA32_FEAT_CTL))
+		init_ia32_feat_ctl(c);
 }
 
 /* Needed by apm.c */
-- 
2.26.0

