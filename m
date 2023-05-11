Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D826FEC9D
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237624AbjEKHQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237627AbjEKHQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:16:09 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748CD9EED;
        Thu, 11 May 2023 00:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683789304; x=1715325304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hl4XchB3DZgjf8rPLE6ukS73VjGwRhFWU+vSkAdj3h4=;
  b=SywSI2wxMVop8yRdbBrlXlfNLRkVNLAlBse+IsiDwbld/KBWnhVO6LMB
   99ZYqclvGt9tLF2JUxaFnSCtiwWKSj4VUTMsvmysXq11FVENIkNNxbnfX
   f2tbenZ1MG+/NqpLVd0oyw2/lUAiDeMXYP4Nl15ng5b0KT2rvw4vpMD32
   S9sIKlfifapi1Kc587LMpaH+XXPbWSTO61SzIoEEj9YWI3fMrfao9pJW7
   CUygQIXvrPMhNO1xV6dX5e0jlLxhc1QXSBbkPSWfUGOd5DzzN92SNflEF
   od1FvgzFWCpcYjcgBvCF8vEvenyI45x6KYamiZHExk2J+akzqktz+gVRI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334896678"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334896678"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="1029512358"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="1029512358"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:23 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Kees Cook <keescook@chromium.org>,
        Pengfei Xu <pengfei.xu@intel.com>
Subject: [PATCH v3 05/21] x86/fpu: Add helper for modifying xstate
Date:   Thu, 11 May 2023 00:08:41 -0400
Message-Id: <20230511040857.6094-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230511040857.6094-1-weijiang.yang@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
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

