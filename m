Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD4860073A
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 09:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiJQHFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 03:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiJQHF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 03:05:28 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CFD2E6AC
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 00:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665990326; x=1697526326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zrt18il+PKnuY2T446RChBFIqI76pHMOFWN+kr/7deg=;
  b=UFnVKyYKssDlu/GSIrNUgluitKAXcHvNQgtIe7NkirNN4duIaHsELX6N
   /R53AN9qbY058m9aAsE8qza+ILrRBaCALTZET4osO8Rj3kSL/nS5xz7cY
   7CpmOI8JByZEk3/fj+sy8RqOrezxkDzDfWaLJ4PvxdpBJlPE4fa2/Yf8c
   k2cBIEQt2IdHWSDvtOoGpUTXZWX4WxfVFRpFK+rFWM3VCxqeX8H+swpuh
   qyWMeE/aOqRmlaPSuNEpbrPS/TFnswJOuz+k6jmO5q5swA2hDT0cmVaNq
   zGhshPmd8J6F2nkDUKX0rfBlmzxCxb7SdaA+QKtpoz4dCT3icy6swFkDV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="306805987"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="306805987"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 00:05:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="579271396"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="579271396"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 17 Oct 2022 00:05:17 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH 3/9] KVM: x86: MMU: Rename get_cr3() --> get_pgd() and clear high bits for pgd
Date:   Mon, 17 Oct 2022 15:04:44 +0800
Message-Id: <20221017070450.23031-4-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221017070450.23031-1-robert.hu@linux.intel.com>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/mmu.c                 | 10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

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
index eccddb136954..385a1a9b1ac4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4473,9 +4473,9 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
-static unsigned long get_cr3(struct kvm_vcpu *vcpu)
+static unsigned long get_pgd(struct kvm_vcpu *vcpu)
 {
-	return kvm_read_cr3(vcpu);
+	return kvm_read_cr3(vcpu) & ~CR3_HIGH_RSVD_MASK;
 }
 
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
@@ -5028,7 +5028,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->get_guest_pgd = get_cr3;
+	context->get_guest_pgd = get_pgd;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 
@@ -5178,7 +5178,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 
 	kvm_init_shadow_mmu(vcpu, cpu_role);
 
-	context->get_guest_pgd     = get_cr3;
+	context->get_guest_pgd     = get_pgd;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 }
@@ -5192,7 +5192,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 		return;
 
 	g_context->cpu_role.as_u64   = new_mode.as_u64;
-	g_context->get_guest_pgd     = get_cr3;
+	g_context->get_guest_pgd     = get_pgd;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
 
-- 
2.31.1

