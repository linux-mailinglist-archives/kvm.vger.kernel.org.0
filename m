Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD73B54DD78
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359672AbiFPItP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359798AbiFPIs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:57 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7966D424B3;
        Thu, 16 Jun 2022 01:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369272; x=1686905272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GeWyVkmGWKHPsJgw/B+NoLBgTSesUAxxZOkxfdZhD8M=;
  b=M9Lb0UZYW77ejhpzJ3WIAy0cr79DmW+jn8PdKyDn+RLjC/9JSFkslhA6
   Fy8gDw3wK0UnEzUhhhKv+1s/wb0Xb/zMZiyo31QUeepsLM0zp9SQcZOAZ
   w9oSHaPkflT9Ae5LYhWoJd1MP6aWja5lZQ5v9id7a2ptU1hbxRL0HZsBb
   01NCGX8PH4U1VG6m8WZ34TwDfR6LBddo7FoqDXCJJ2wkZbkrJOkJ4J4p/
   gK+Eg2XQBkRUB3hiKW6GViREKBcHVf6XW4gyVCFdn3fvUcvEHUXrUFr+6
   lolK3EDXFrUNNPfLpHfjUSS3wLwv10a2maX29W5wXWP+V+J4KcmogLLPj
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259664559"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259664559"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083140"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 05/19] x86/fpu: Add helper for modifying xstate
Date:   Thu, 16 Jun 2022 04:46:29 -0400
Message-Id: <20220616084643.19564-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Just like user xfeatures, supervisor xfeatures can be active in the
registers or present in the task FPU buffer. If the registers are
active, the registers can be modified directly. If the registers are
not active, the modification must be performed on the task FPU buffer.

When the state is not active, the kernel could perform modifications
directly to the buffer. But in order for it to do that, it needs
to know where in the buffer the specific state it wants to modify is
located. Doing this is not robust against optimizations that compact
the FPU buffer, as each access would require computing where in the
buffer it is.

The easiest way to modify supervisor xfeature data is to force restore
the registers and write directly to the MSRs. Often times this is just fine
anyway as the registers need to be restored before returning to userspace.
Do this for now, leaving buffer writing optimizations for the future.

Add a new function fpregs_lock_and_load() that can simultaneously call
fpregs_lock() and do this restore. Also perform some extra sanity
checks in this function since this will be used in non-fpu focused code.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

---
v2:
 - Drop optimization of writing directly the buffer, and change API
   accordingly.
 - fpregs_lock_and_load() suggested by tglx
 - Some commit log verbiage from dhansen

v1:
 - New patch.

 arch/x86/include/asm/fpu/api.h |  7 ++++++-
 arch/x86/kernel/fpu/core.c     | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 6b0f31fb53f7..4f34812b4dd5 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -82,6 +82,12 @@ static inline void fpregs_unlock(void)
 		preempt_enable();
 }
 
+/*
+ * Lock and load the fpu state into the registers, if they are not already
+ * loaded.
+ */
+void fpu_lock_and_load(void);
+
 #ifdef CONFIG_X86_DEBUG_FPU
 extern void fpregs_assert_state_consistent(void);
 #else
@@ -163,5 +169,4 @@ static inline bool fpstate_is_confidential(struct fpu_guest *gfpu)
 
 /* prctl */
 extern long fpu_xstate_prctl(int option, unsigned long arg2);
-
 #endif /* _ASM_X86_FPU_API_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 0531d6a06df5..4d250dba1619 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -756,6 +756,25 @@ void switch_fpu_return(void)
 }
 EXPORT_SYMBOL_GPL(switch_fpu_return);
 
+void fpu_lock_and_load(void)
+{
+	/*
+	 * fpregs_lock() only disables preemption (mostly). So modifing state
+	 * in an interrupt could screw up some in progress fpregs operation,
+	 * but appear to work. Warn about it.
+	 */
+	WARN_ON_ONCE(!irq_fpu_usable());
+	WARN_ON_ONCE(current->flags & PF_KTHREAD);
+
+	fpregs_lock();
+
+	fpregs_assert_state_consistent();
+
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		fpregs_restore_userregs();
+}
+EXPORT_SYMBOL_GPL(fpu_lock_and_load);
+
 #ifdef CONFIG_X86_DEBUG_FPU
 /*
  * If current FPU state according to its tracking (loaded FPU context on this
-- 
2.27.0

