Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17868624336
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 14:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiKJN3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 08:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiKJN3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 08:29:08 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9257C1FCDA
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 05:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668086947; x=1699622947;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aGIu5Eij+QRJOhqsOmflpRmcgZZeo4ZXTJjMKDuPV1s=;
  b=ijgQtZ8b45xIbN42egti8jb6xVilMjhEIvrBkS8qTktv8JJvLKQhxRdB
   cZMWljIWxU+vG3ri9Na0znD7yuJez9ivKVTfR4fdwT2M9XQ5FvsBHgJpq
   EUwZ0HgBqSqYdUrmR1f721uail6JchHVvAaLOeHiaiBV612wxeMSV/5vB
   MrKR7boIGhlk6g4SBAmYdDJgdGzFbDmBIPN3EKc7jEkKuFrrBZs4wmBTu
   G0EOZQdwW+UUebQi2A8dLEbtGnKKVGuOU/J1w1UG0WsjtgBMNAoqxMI1k
   O65WdFUnhgvtZc3sr/V1OpWN+rziONwDcFKYRzpjsaFhSce6gBQLhoZpK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="311306325"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="311306325"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 05:29:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="812038332"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="812038332"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga005.jf.intel.com with ESMTP; 10 Nov 2022 05:29:05 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH v2 3/9] KVM: x86: MMU: Rename get_cr3() --> get_pgd() and clear high bits for pgd
Date:   Thu, 10 Nov 2022 21:28:42 +0800
Message-Id: <20221110132848.330793-4-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221110132848.330793-1-robert.hu@linux.intel.com>
References: <20221110132848.330793-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The get_cr3() is the implementation of kvm_mmu::get_guest_pgd(), well, CR3
cannot be naturally equivalent to pgd, SDM says CR3 high bits are reserved,
must be zero.
And now, with LAM feature's introduction, bit 61 ~ 62 are used.
So, rename get_cr3() --> get_pgd() to better indicate function purpose and
in it, filtered out CR3 high bits.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
---
 arch/x86/include/asm/processor-flags.h |  1 +
 arch/x86/kvm/mmu/mmu.c                 | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/processor-flags.h b/arch/x86/include/asm/processor-flags.h
index d8cccadc83a6..bb0f8dd16956 100644
--- a/arch/x86/include/asm/processor-flags.h
+++ b/arch/x86/include/asm/processor-flags.h
@@ -38,6 +38,7 @@
 #ifdef CONFIG_X86_64
 /* Mask off the address space ID and SME encryption bits. */
 #define CR3_ADDR_MASK	__sme_clr(PHYSICAL_PAGE_MASK)
+#define CR3_HIGH_RSVD_MASK	GENMASK_ULL(63, 52)
 #define CR3_PCID_MASK	0xFFFull
 #define CR3_NOFLUSH	BIT_ULL(63)
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f81539061d6..04e4b38fe73a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4487,9 +4487,13 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
-static unsigned long get_cr3(struct kvm_vcpu *vcpu)
+static unsigned long get_pgd(struct kvm_vcpu *vcpu)
 {
+#ifdef CONFIG_X86_64
+	return kvm_read_cr3(vcpu) & ~CR3_HIGH_RSVD_MASK;
+#else
 	return kvm_read_cr3(vcpu);
+#endif
 }
 
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
@@ -5042,7 +5046,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->get_guest_pgd = get_cr3;
+	context->get_guest_pgd = get_pgd;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 
@@ -5192,7 +5196,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 
 	kvm_init_shadow_mmu(vcpu, cpu_role);
 
-	context->get_guest_pgd     = get_cr3;
+	context->get_guest_pgd     = get_pgd;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 }
@@ -5206,7 +5210,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 		return;
 
 	g_context->cpu_role.as_u64   = new_mode.as_u64;
-	g_context->get_guest_pgd     = get_cr3;
+	g_context->get_guest_pgd     = get_pgd;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
 
-- 
2.31.1

