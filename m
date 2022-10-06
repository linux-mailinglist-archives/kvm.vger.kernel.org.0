Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7EA5F5DF4
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiJFApY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJFApV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:45:21 -0400
Received: from mail-oa1-x49.google.com (mail-oa1-x49.google.com [IPv6:2001:4860:4864:20::49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46D53204E
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:45:19 -0700 (PDT)
Received: by mail-oa1-x49.google.com with SMTP id 586e51a60fabf-132dad3013fso233602fac.11
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=z9mswc/u+w4ZF781S0knZldgPkrTUkTtJS37mopeutI=;
        b=cTS8cjr6i5jPFhSdYm/aNdA5zFwiacG6dhgzkLDCkfgLPv1z2Mi0+AzXKAvXdtmw6V
         Pb8RPzJQW8S7ZmVb4hT9+2MQQKJU2povaajsiLuv1IYfFPZRUgYaXyGDU3/oGfpntpMr
         QLDz09YlsEqdtiA8PcGdrisiyqqiHsbr5tw/ZKtn//1n/+7WeE0bHf8TQ5tkUhDXKRzX
         S9yxM6H802kv27tQbfjuL6hR+7+G6D4VhakNFGJfQXVdEjHNaUizftQC87LfWX6454s/
         oSpsLK8MEmyaGPvKSlYSqQCbCXIsEbjggPUAobuccJrOn7yR3eMieOC66plMijJ/O53P
         Fp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z9mswc/u+w4ZF781S0knZldgPkrTUkTtJS37mopeutI=;
        b=Joc2StZPHmkK4I7Zr/Quuc7m+W1y1xIoaXQ5h9fsQ0+yJRQC2BOUH7CxYPVMCm9cSi
         ICJqFgyiqhEsw694k6TL5d59DjQcNujCtprIGC6SusaFVcACyA7LvzZxlrSznXbQbZIg
         aRnvatcv1YdZy+/wDuj+HRSUNawDl6MstSLWqgJA6GzccpZkDN1kvN0QGYckJriNEFFv
         fOkpQ4gH5w4uUnQ3MM3/YRLl0Y6b5rfwe8sqM7oAwFwP1Tu9VmRhRpCADaJqpLBO3yM4
         7VsANEnV+H6IKPGDDvdMt9ioUMP+sE9ubsIP68tCFBSYAnCuDbi/JekRStm9aUjZ+Zk6
         TmMA==
X-Gm-Message-State: ACrzQf2tDa+fUqfbbljVwjK8DwnQDwuklymLPr+EbsTqxbe1MWHKTx+H
        8ajmm7fgtb7udlD19frbfrnwcB/Skeo=
X-Google-Smtp-Source: AMsMyM4pUrPgoR1RSyYK7pk1XOcz6v7n7xTY8l7HMeR8YFo1UspmuRAmFXB/Gk/a+tIynMM3lWdbygqRMDI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6808:bd6:b0:350:e5f7:544b with SMTP id
 o22-20020a0568080bd600b00350e5f7544bmr3636110oik.206.1665017118987; Wed, 05
 Oct 2022 17:45:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:45:07 +0000
In-Reply-To: <20221006004512.666529-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006004512.666529-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006004512.666529-3-seanjc@google.com>
Subject: [PATCH 2/7] KVM: selftests: Drop reserved bit checks from PTE accessor
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the reserved bit checks from the helper to retrieve a PTE, there's
very little value in sanity checking the constructed page tables as any
will quickly be noticed in the form of an unexpected #PF.  The checks
also place unnecessary restrictions on the usage of the helpers, e.g. if
a test _wanted_ to set reserved bits for whatever reason.

Removing the NX check in particular allows for the removal of the @vcpu
param, which will in turn allow the helper to be reused nearly verbatim
for addr_gva2gpa().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  3 +--
 .../selftests/kvm/lib/x86_64/processor.c      | 26 +------------------
 .../kvm/x86_64/emulator_error_test.c          |  2 +-
 3 files changed, 3 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 30d5df1ebaad..53d52a5ace48 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -827,8 +827,7 @@ static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 
 bool kvm_is_tdp_enabled(void);
 
-uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-				  uint64_t vaddr);
+uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 90b35998b0f3..9e196837a794 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -241,29 +241,11 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 }
 
-uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-				  uint64_t vaddr)
+uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
 {
 	uint16_t index[4];
 	uint64_t *pml4e, *pdpe, *pde;
 	uint64_t *pte;
-	struct kvm_sregs sregs;
-	uint64_t rsvd_mask = 0;
-
-	/* Set the high bits in the reserved mask. */
-	if (vm->pa_bits < 52)
-		rsvd_mask = GENMASK_ULL(51, vm->pa_bits);
-
-	/*
-	 * SDM vol 3, fig 4-11 "Formats of CR3 and Paging-Structure Entries
-	 * with 4-Level Paging and 5-Level Paging".
-	 * If IA32_EFER.NXE = 0 and the P flag of a paging-structure entry is 1,
-	 * the XD flag (bit 63) is reserved.
-	 */
-	vcpu_sregs_get(vcpu, &sregs);
-	if ((sregs.efer & EFER_NX) == 0) {
-		rsvd_mask |= PTE_NX_MASK;
-	}
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
@@ -286,24 +268,18 @@ uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 	pml4e = addr_gpa2hva(vm, vm->pgd);
 	TEST_ASSERT(pml4e[index[3]] & PTE_PRESENT_MASK,
 		"Expected pml4e to be present for gva: 0x%08lx", vaddr);
-	TEST_ASSERT((pml4e[index[3]] & (rsvd_mask | PTE_LARGE_MASK)) == 0,
-		"Unexpected reserved bits set.");
 
 	pdpe = addr_gpa2hva(vm, PTE_GET_PFN(pml4e[index[3]]) * vm->page_size);
 	TEST_ASSERT(pdpe[index[2]] & PTE_PRESENT_MASK,
 		"Expected pdpe to be present for gva: 0x%08lx", vaddr);
 	TEST_ASSERT(!(pdpe[index[2]] & PTE_LARGE_MASK),
 		"Expected pdpe to map a pde not a 1-GByte page.");
-	TEST_ASSERT((pdpe[index[2]] & rsvd_mask) == 0,
-		"Unexpected reserved bits set.");
 
 	pde = addr_gpa2hva(vm, PTE_GET_PFN(pdpe[index[2]]) * vm->page_size);
 	TEST_ASSERT(pde[index[1]] & PTE_PRESENT_MASK,
 		"Expected pde to be present for gva: 0x%08lx", vaddr);
 	TEST_ASSERT(!(pde[index[1]] & PTE_LARGE_MASK),
 		"Expected pde to map a pte not a 2-MByte page.");
-	TEST_ASSERT((pde[index[1]] & rsvd_mask) == 0,
-		"Unexpected reserved bits set.");
 
 	pte = addr_gpa2hva(vm, PTE_GET_PFN(pde[index[1]]) * vm->page_size);
 	TEST_ASSERT(pte[index[0]] & PTE_PRESENT_MASK,
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index bde247f3c8a1..1abb34735754 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -180,7 +180,7 @@ int main(int argc, char *argv[])
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 	memset(hva, 0, PAGE_SIZE);
 
-	pte = vm_get_page_table_entry(vm, vcpu, MEM_REGION_GVA);
+	pte = vm_get_page_table_entry(vm, MEM_REGION_GVA);
 	*pte |= BIT_ULL(MAXPHYADDR);
 
 	vcpu_run(vcpu);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

