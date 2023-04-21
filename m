Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701A36EAFB1
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbjDUQvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbjDUQut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:50:49 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8484C13FAB;
        Fri, 21 Apr 2023 09:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095848; x=1713631848;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hl4XchB3DZgjf8rPLE6ukS73VjGwRhFWU+vSkAdj3h4=;
  b=Vujuw011C2tO2o+Zcx5FXfGDKWkUX+5G+bxUXTr9bWTX5Hf19vMkTHDA
   CMFEUECD91IDzrLao1H3YD0rgD1QFTej8jk5as3EXX1DdhciiofunbymT
   5m3FKg4QSZK4QycyFQF/ZbZa7K3cm8x6F+WgWRpVaoue6KwnLh9kHr6Mi
   AFBkJbB/0MFLwm18l0VZgjQLFP+8xIEO8SOL9JA8Zd0Ia3oqj4HYCFtzP
   lNvDGSMKSMloURjLNQ4ed8kuwVV7eyhlCX9dg4fSt3NCx+qQeM+iti0JZ
   rh4KoldshKK/YC+KkxvRaotGn73VsbAZ/vnHlR7T/6nSqdS5Tqf1fO0o2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344786980"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344786980"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817368"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817368"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:42 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Kees Cook <keescook@chromium.org>,
        Mike Rapoport <rppt@kernel.org>,
        Pengfei Xu <pengfei.xu@intel.com>
Subject: [PATCH v2 05/21] x86/fpu: Add helper for modifying xstate
Date:   Fri, 21 Apr 2023 09:45:59 -0400
Message-Id: <20230421134615.62539-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/all/20230319001535.23210-7-rick.p.edgecombe%40intel.com
---
 arch/x86/include/asm/fpu/api.h |  9 +++++++++
 arch/x86/kernel/fpu/core.c     | 18 ++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 503a577814b2..aadc6893dcaa 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -82,6 +82,15 @@ static inline void fpregs_unlock(void)
 		preempt_enable();
 }
 
+/*
+ * FPU state gets lazily restored before returning to userspace. So when in the
+ * kernel, the valid FPU state may be kept in the buffer. This function will force
+ * restore all the fpu state to the registers early if needed, and lock them from
+ * being automatically saved/restored. Then FPU state can be modified safely in the
+ * registers, before unlocking with fpregs_unlock().
+ */
+void fpregs_lock_and_load(void);
+
 #ifdef CONFIG_X86_DEBUG_FPU
 extern void fpregs_assert_state_consistent(void);
 #else
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index caf33486dc5e..f851558b673f 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -753,6 +753,24 @@ void switch_fpu_return(void)
 }
 EXPORT_SYMBOL_GPL(switch_fpu_return);
 
+void fpregs_lock_and_load(void)
+{
+	/*
+	 * fpregs_lock() only disables preemption (mostly). So modifying state
+	 * in an interrupt could screw up some in progress fpregs operation.
+	 * Warn about it.
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
+
 #ifdef CONFIG_X86_DEBUG_FPU
 /*
  * If current FPU state according to its tracking (loaded FPU context on this
-- 
2.27.0

