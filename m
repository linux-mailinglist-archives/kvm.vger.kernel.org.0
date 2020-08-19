Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76DF24953C
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 08:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHSGrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 02:47:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:36074 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgHSGrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 02:47:16 -0400
IronPort-SDR: H+jCP1FCpMPb+FfVOVmMeTEPfggoKVRA/GN/mWOgmmr2qziOBndNDQ92K3XJUeLRQoQ15eLw9i
 MerlpQqYWHfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="142873170"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="142873170"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 23:47:15 -0700
IronPort-SDR: nDtdpQEtjW6bR6NbnhJShYKoWr8/YTIylohsfGMpZfvj0J7JyKo7zlBcN1Ts3a7hvxtlH1LgZo
 HihV6B2x7OwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="310679252"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2020 23:47:12 -0700
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
Subject: [PATCH v10 1/9] x86/split_lock: Rename TIF_SLD to TIF_SLD_DISABLED
Date:   Wed, 19 Aug 2020 14:46:59 +0800
Message-Id: <20200819064707.1033569-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200819064707.1033569-1-xiaoyao.li@intel.com>
References: <20200819064707.1033569-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TIF_SLD can only be set if a user space thread hits split lock and
sld_state == sld_warn. This flag is set to indicate SLD (split lock
detection) is turned off for the thread, so rename it to
TIF_SLD_DISABLED, which is pretty self explaining.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/thread_info.h | 6 +++---
 arch/x86/kernel/cpu/intel.c        | 6 +++---
 arch/x86/kernel/process.c          | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 267701ae3d86..fdb458a74557 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -92,7 +92,7 @@ struct thread_info {
 #define TIF_NOCPUID		15	/* CPUID is not accessible in userland */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* IA32 compatibility process */
-#define TIF_SLD			18	/* Restore split lock detection on context switch */
+#define TIF_SLD_DISABLED	18	/* split lock detection is turned off */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
 #define TIF_POLLING_NRFLAG	21	/* idle is polling for TIF_NEED_RESCHED */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
@@ -122,7 +122,7 @@ struct thread_info {
 #define _TIF_NOCPUID		(1 << TIF_NOCPUID)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
-#define _TIF_SLD		(1 << TIF_SLD)
+#define _TIF_SLD_DISABLED	(1 << TIF_SLD_DISABLED)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
@@ -136,7 +136,7 @@ struct thread_info {
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW_BASE					\
 	(_TIF_NOCPUID | _TIF_NOTSC | _TIF_BLOCKSTEP |		\
-	 _TIF_SSBD | _TIF_SPEC_FORCE_UPDATE | _TIF_SLD)
+	 _TIF_SSBD | _TIF_SPEC_FORCE_UPDATE | _TIF_SLD_DISABLED)
 
 /*
  * Avoid calls to __switch_to_xtra() on UP as STIBP is not evaluated.
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 59a1e3ce3f14..c48b3267c141 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1090,11 +1090,11 @@ static void split_lock_warn(unsigned long ip)
 
 	/*
 	 * Disable the split lock detection for this task so it can make
-	 * progress and set TIF_SLD so the detection is re-enabled via
+	 * progress and set TIF_SLD_DISABLED so the detection is re-enabled via
 	 * switch_to_sld() when the task is scheduled out.
 	 */
 	sld_update_msr(false);
-	set_tsk_thread_flag(current, TIF_SLD);
+	set_tsk_thread_flag(current, TIF_SLD_DISABLED);
 }
 
 bool handle_guest_split_lock(unsigned long ip)
@@ -1132,7 +1132,7 @@ bool handle_user_split_lock(struct pt_regs *regs, long error_code)
  */
 void switch_to_sld(unsigned long tifn)
 {
-	sld_update_msr(!(tifn & _TIF_SLD));
+	sld_update_msr(!(tifn & _TIF_SLD_DISABLED));
 }
 
 /*
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 994d8393f2f7..e9265c6b9256 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -641,7 +641,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p)
 		__speculation_ctrl_update(~tifn, tifn);
 	}
 
-	if ((tifp ^ tifn) & _TIF_SLD)
+	if ((tifp ^ tifn) & _TIF_SLD_DISABLED)
 		switch_to_sld(tifn);
 }
 
-- 
2.18.4

