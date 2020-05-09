Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE901CBCAF
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 05:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgEIDDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 23:03:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:55091 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728717AbgEIDDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 23:03:41 -0400
IronPort-SDR: 6IdfPla3FRkc4FPFOD0QtnxxSJl30OeBEwGedyHKryGypgKS7La4MDhVSGEIJPIYEX+YdIbF/R
 xWktQxW1ieQg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 20:03:41 -0700
IronPort-SDR: Te3FU+RtqOez0or2hntj7545tNBrvWOGgVG24krYgjWFaGqy7B0EK7TZtJO51Z7r9x5oijbjOI
 DyiahqZURsTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,370,1583222400"; 
   d="scan'208";a="408310990"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga004.jf.intel.com with ESMTP; 08 May 2020 20:03:35 -0700
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
Subject: [PATCH v9 1/8] x86/split_lock: Rename TIF_SLD to TIF_SLD_DISABLED
Date:   Sat,  9 May 2020 19:05:35 +0800
Message-Id: <20200509110542.8159-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200509110542.8159-1-xiaoyao.li@intel.com>
References: <20200509110542.8159-1-xiaoyao.li@intel.com>
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
index 8de8ceccb8bc..451a930de1c0 100644
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
@@ -141,7 +141,7 @@ struct thread_info {
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW_BASE					\
 	(_TIF_NOCPUID | _TIF_NOTSC | _TIF_BLOCKSTEP |		\
-	 _TIF_SSBD | _TIF_SPEC_FORCE_UPDATE | _TIF_SLD)
+	 _TIF_SSBD | _TIF_SPEC_FORCE_UPDATE | _TIF_SLD_DISABLED)
 
 /*
  * Avoid calls to __switch_to_xtra() on UP as STIBP is not evaluated.
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index a19a680542ce..0e6aee6ef1e8 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1074,11 +1074,11 @@ static void split_lock_warn(unsigned long ip)
 
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
@@ -1116,7 +1116,7 @@ bool handle_user_split_lock(struct pt_regs *regs, long error_code)
  */
 void switch_to_sld(unsigned long tifn)
 {
-	sld_update_msr(!(tifn & _TIF_SLD));
+	sld_update_msr(!(tifn & _TIF_SLD_DISABLED));
 }
 
 /*
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 9da70b279dad..e7693a283489 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -650,7 +650,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p)
 		__speculation_ctrl_update(~tifn, tifn);
 	}
 
-	if ((tifp ^ tifn) & _TIF_SLD)
+	if ((tifp ^ tifn) & _TIF_SLD_DISABLED)
 		switch_to_sld(tifn);
 }
 
-- 
2.18.2

