Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8491F1E8A
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 19:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgFHRts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 13:49:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:11150 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730247AbgFHRts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 13:49:48 -0400
IronPort-SDR: v62WnqnW/CNcsjzCc9QHAvI9TpTWk+je1kVzaCUA47AuXms0bY1oJc1ghoBt0hiPKXapZXIYfU
 Eew0dxRKRusg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 10:49:45 -0700
IronPort-SDR: plH9hL/3uaiz4LrI869hiDPlJo9zwuQekZQbWDqHmJq3YVsL3tRjGOPHnyUBU1u01b1h6neVw0
 9hO14zg240mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="418133308"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 08 Jun 2020 10:49:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Brad Campbell <lists2009@fnarfbargle.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2] x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during wakeup
Date:   Mon,  8 Jun 2020 10:41:34 -0700
Message-Id: <20200608174134.11157-1-sean.j.christopherson@intel.com>
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
Tested-by: Brad Campbell <lists2009@fnarfbargle.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org # v5.6
Fixes: 21bd3467a58e ("KVM: VMX: Drop initialization of IA32_FEAT_CTL MSR")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

v2:
  - Collect Reviewed/Tested tags. [Brad, Liam, Maxim].
  - Include asm/cpu.h to fix Zhaoxin and Centaur builds. [Brad, LKP]
  - Add Cc to stable. [Liam]

 arch/x86/include/asm/cpu.h    | 5 +++++
 arch/x86/kernel/cpu/centaur.c | 1 +
 arch/x86/kernel/cpu/cpu.h     | 4 ----
 arch/x86/kernel/cpu/zhaoxin.c | 1 +
 arch/x86/power/cpu.c          | 6 ++++++
 5 files changed, 13 insertions(+), 4 deletions(-)

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
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 426792565d86..c5cf336e5077 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -3,6 +3,7 @@
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
 
+#include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/e820/api.h>
 #include <asm/mtrr.h>
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
diff --git a/arch/x86/kernel/cpu/zhaoxin.c b/arch/x86/kernel/cpu/zhaoxin.c
index df1358ba622b..05fa4ef63490 100644
--- a/arch/x86/kernel/cpu/zhaoxin.c
+++ b/arch/x86/kernel/cpu/zhaoxin.c
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
 
+#include <asm/cpu.h>
 #include <asm/cpufeature.h>
 
 #include "cpu.h"
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

