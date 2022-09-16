Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADE95BB368
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 22:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiIPUWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 16:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiIPUV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 16:21:59 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D55EA99F2;
        Fri, 16 Sep 2022 13:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663359719; x=1694895719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=QPu6vBGW7d8GoMFb/py0DCksk1SJKHRz0Nykt/+6h6o=;
  b=Q7wB9/q6UbXW1/QaGdjXyxlFvvMhUsed70zvWeCLmIIBsldOVrRFAApL
   QERcV0zzrojU0YQjld89uwihtPykEFHztzkpATU2XOO3X8OLPPEFYmgcv
   C25U8b5QKjM6dT6UK//E/75uXuWOWenl2zpnsiACw6he7Z1lsPrZsGoUF
   ifQF7FJLZlN9RTF+nHy/zvKOgiVjE76yYga1+gM8CwjUFHqxYJQR34b/U
   9Tlf9R6EwAsL8JLaoWUlymUhDXIcBpLFcXG24VMYwR7T01IgFpP6vBxa2
   n7Vyeq1PZP42wpQG4dOh7snukoDU1xl2W1YfdGyzWD00vLc9vpg1/I4+r
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10472"; a="278801384"
X-IronPort-AV: E=Sophos;i="5.93,321,1654585200"; 
   d="scan'208";a="278801384"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2022 13:21:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,321,1654585200"; 
   d="scan'208";a="680092296"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
  by fmsmga008.fm.intel.com with ESMTP; 16 Sep 2022 13:21:57 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, avagin@gmail.com,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH 3/4] x86/fpu: Clarify the XSTATE clearing only for extended components
Date:   Fri, 16 Sep 2022 13:11:57 -0700
Message-Id: <20220916201158.8072-4-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220916201158.8072-1-chang.seok.bae@intel.com>
References: <20220916201158.8072-1-chang.seok.bae@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 087df48c298c ("x86/fpu: Replace KVMs xstate component clearing")
refactored the MPX state clearing code.

But, legacy states are not warranted in this routine. Rename the function
to clarify that only extended components are acceptable.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/fpu/api.h | 2 +-
 arch/x86/kernel/fpu/xstate.c   | 7 +++++--
 arch/x86/kvm/x86.c             | 4 ++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 503a577814b2..c9d5dc85ca06 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -130,7 +130,7 @@ static inline void fpstate_free(struct fpu *fpu) { }
 #endif
 
 /* fpstate-related functions which are exported to KVM */
-extern void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfeature);
+extern void fpstate_clear_extended_xstate(struct fpstate *fps, unsigned int xfeature);
 
 extern u64 xstate_get_guest_group_perm(void);
 
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index d7676cfc32eb..a35f91360e3f 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1371,14 +1371,17 @@ void xrstors(struct xregs_state *xstate, u64 mask)
 }
 
 #if IS_ENABLED(CONFIG_KVM)
-void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfeature)
+void fpstate_clear_extended_xstate(struct fpstate *fps, unsigned int xfeature)
 {
 	void *addr = get_xsave_addr(&fps->regs.xsave, xfeature);
 
+	if (xfeature <= XFEATURE_SSE)
+		return;
+
 	if (addr)
 		memset(addr, 0, xstate_sizes[xfeature]);
 }
-EXPORT_SYMBOL_GPL(fpstate_clear_xstate_component);
+EXPORT_SYMBOL_GPL(fpstate_clear_extended_xstate);
 #endif
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..82ab270ea734 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11760,8 +11760,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		if (init_event)
 			kvm_put_guest_fpu(vcpu);
 
-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
+		fpstate_clear_extended_xstate(fpstate, XFEATURE_BNDREGS);
+		fpstate_clear_extended_xstate(fpstate, XFEATURE_BNDCSR);
 
 		if (init_event)
 			kvm_load_guest_fpu(vcpu);
-- 
2.17.1

