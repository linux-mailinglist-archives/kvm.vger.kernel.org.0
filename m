Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F072B77D537
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 23:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240302AbjHOVgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 17:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240300AbjHOVfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 17:35:54 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85961FC3
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:44 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58c6564646aso6877107b3.2
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692135344; x=1692740144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/PvDkYU7pub77IFsZZiQMv91FRnqIzJSJjC/8q+MYGc=;
        b=oSgseZt86wOzM6XbvxcoKwzE9JqjHNoKLVYniiWvDo9//Z99SbHzwV1kCKmMJb7jyb
         /KKsQDeS/ouvKqjA81omMCunJ1t8ioevf4rM7TFeZ5swcs/C9dxOC0mnHpAZeLK/VYiZ
         lklz1En2ZrCx4Cs5N6ZtsMDApZTn97E1+qBN1C3rvAlFShcFavHxOFWwtWKN3w9Jltwu
         rorsnqd+5JmQgKRO1p6N1yGSlbq7sgl5rCmzSXS+lkdQqZps24CXZb4XwtiMQGvwf+/a
         S3ZdeFHXksmbvYQ4snDjFBMWt1zRt8Sra8Sp6SL+KfKcu9cGUBntyLlDpMbET+760pvL
         vzSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692135344; x=1692740144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/PvDkYU7pub77IFsZZiQMv91FRnqIzJSJjC/8q+MYGc=;
        b=kStkMQGz5sPTcyWSJGwdCsw9rBacVZdkUDalQELkXgg9XUeCiBp72oMQ31q98+MB/O
         Lb0hyEyRY2b3AlT5WsTIo+DxKJofxWJEsZuy5bF4EtEFAynkgtKvouLF955rHOcE5JSo
         ABI6+5ioGCAnhyNXMUkBmCz8EQSH2jptN8sDrRKjVHR8oiqHXh2Fe2pUgKiEujN8KFRb
         wnM5H7gW2zz2QH5rUN2ULA370Ea5SXhWxLAdYv9PD7VFLPaNIxUO7F/seHGdas9EHx2m
         1lLVQW2rmyO6APj+Bg1oxJxXpv330E+NKWdBJs61JmwHVMGsKdiWEr+ZrqhqO03KvVz5
         I1vA==
X-Gm-Message-State: AOJu0YyHUauXOKd/zS2nstVtffDkH2xxarrO1ZctgDkW8M+cETJQobtb
        AwQp2W+oALWN6aUiYsqzQYRsVSAUYKg=
X-Google-Smtp-Source: AGHT+IEZFDsXm9stnifzZSAuqvVw0msILihz96PnJBxpFjupmiJnnJYjLfZp3vldSCKfc9/0T4IECdwkeoc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:bc41:0:b0:58c:8c9f:c05a with SMTP id
 b1-20020a81bc41000000b0058c8c9fc05amr3247ywl.9.1692135344061; Tue, 15 Aug
 2023 14:35:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 14:35:26 -0700
In-Reply-To: <20230815213533.548732-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815213533.548732-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815213533.548732-4-seanjc@google.com>
Subject: [PATCH 03/10] KVM: SVM: Drop pointless masking of kernel page pa's
 with "AVIC's" HPA mask
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop AVIC_HPA_MASK and all its users, the mask is just the 4KiB-aligned
maximum theoretical physical address for x86-64 CPUs.  All usage in KVM
masks the result of page_to_phys(), which on x86-64 is guaranteed to be
4KiB aligned and a legal physical address; if either of those requirements
doesn't hold true, KVM has far bigger problems.

The unnecessarily masking in avic_init_vmcb() also incorrectly assumes
that SME's C-bit resides between bits 51:11; that holds true for current
CPUs, but isn't required by AMD's architecture:

  In some implementations, the bit used may be a physical address bit

Key word being "may".

Opportunistically use the GENMASK_ULL() version for
AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK, which is far more readable
than a set of repeating Fs.  Keep the macro even though it's unused, and
will likely never be used, as it helps visualize the layout of an entry.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/svm.h |  6 +-----
 arch/x86/kvm/svm/avic.c    | 11 +++++------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 609c9b596399..df644ca3febe 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -250,7 +250,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
 #define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
-#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
+#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	GENMASK_ULL(51, 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
 #define AVIC_PHYSICAL_ID_TABLE_SIZE_MASK		(0xFFULL)
@@ -284,10 +284,6 @@ enum avic_ipi_failure_cause {
 static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_PHYSICAL_ID);
 static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
 
-#define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
-static_assert(AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK == AVIC_HPA_MASK);
-static_assert(AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK == GENMASK_ULL(51, 12));
-
 #define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
 
 struct vmcb_seg {
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 442c58ef8158..b8313f2d88fa 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -248,9 +248,9 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
 	phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic_physical_id_table_page));
 
-	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
-	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
+	vmcb->control.avic_backing_page = bpa;
+	vmcb->control.avic_logical_id = lpa;
+	vmcb->control.avic_physical_id = ppa;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
@@ -308,7 +308,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	if (!entry)
 		return -EINVAL;
 
-	new_entry = __sme_set(page_to_phys(svm->avic_backing_page) & AVIC_HPA_MASK) |
+	new_entry = __sme_set(page_to_phys(svm->avic_backing_page)) |
 		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
 	WRITE_ONCE(*entry, new_entry);
 
@@ -917,8 +917,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 			struct amd_iommu_pi_data pi;
 
 			/* Try to enable guest_mode in IRTE */
-			pi.base = __sme_set(page_to_phys(svm->avic_backing_page) &
-					    AVIC_HPA_MASK);
+			pi.base = __sme_set(page_to_phys(svm->avic_backing_page));
 			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
 						     svm->vcpu.vcpu_id);
 			pi.is_guest_mode = true;
-- 
2.41.0.694.ge786442a9b-goog

