Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183035F5DFE
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiJFAp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJFAph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:45:37 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1104D3CBF7
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:45:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n6-20020a5b0486000000b006aff8dc9865so395276ybp.11
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6IkMmGIg9MQ5djbHBiVro6aZvJGAhf8LXVNwqo4c+G4=;
        b=hz4l2trqKkIjVbtBALG7qdomzdVFxGvtBbfJsNvbq+dtoCc+YJULPMHrIOZdWu2Lgo
         kaADAHhNYYcI/oWIVMqqlPLFJF7DB4hRD7uRIRiuKt6GD7xW4BV9CLV2qsPC3xKzXIfY
         dFJo035f7j7A529THbyAeAp9/tyzQ1xBV/R5okWMnExZJr/stn5m5jT/4HCmnptPwp19
         k4z83ohCAbNg6RDlfHOkh08INZpyIruANp7G7cLNX2WagP1gscPR0HcKCgJ1Lo8Hh07V
         4Cti9TUag7EBXR0rATjTAjPhuCBaEJYr/aA2yYyB5UYIJm2ttBD+Zw+pUcGVfMT2y+B+
         VPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6IkMmGIg9MQ5djbHBiVro6aZvJGAhf8LXVNwqo4c+G4=;
        b=x2kbwMMMgzDIPTZEpkBPaVspT2o7vLqaK7hp+8CRRj7PbCxFYXdiPPqAZnSeIkPDkd
         OA8uxAxbg/hWoUqyAkwKKzVUey5pI77j9cH96iRP298q/Tf9rc1eq2kNzNW5+EPQHaRM
         aIjmhfR3iy2bHuK5EF/nhwir3wndFwEg2RUtTzEAYFal3+FfO7MYSvD/2tXpVxG/Supn
         VydhcDXJBYw1i/sARajTL2M9YDX07tPggWFmP6uNk/pMDx36xPt9FfPQ3BPILPPg62IV
         UUgIQTsemRMG8cBxJveAIHKbrrGRtktcF6jUQMlSt44j19ZAaXRZ+dOklosomCtS+pu7
         HbEA==
X-Gm-Message-State: ACrzQf1qbXOjyFrE2WpKLIkgjNkgvhD8ESLqQy+1NZIwVdZtIBlIwaYP
        gxF9p1s9x+6RUNUKMzHELBqEUDuY61w=
X-Google-Smtp-Source: AMsMyM4p2P+0YWUvW9VS3IBiYW019KU/DlHupUSsW1GuQxFY98F3RfwlzrxcEE3YNCPDrnp7L4lwSpaMvCo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bb90:0:b0:6bd:bbfd:794e with SMTP id
 y16-20020a25bb90000000b006bdbbfd794emr2525169ybg.546.1665017125744; Wed, 05
 Oct 2022 17:45:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:45:11 +0000
In-Reply-To: <20221006004512.666529-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006004512.666529-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006004512.666529-7-seanjc@google.com>
Subject: [PATCH 6/7] KVM: selftests: Use vm_get_page_table_entry() in addr_arch_gva2gpa()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
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

Use vm_get_page_table_entry() in addr_arch_gva2gpa() to get the leaf PTE
instead of manually walking page tables.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 38 ++-----------------
 1 file changed, 4 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 09b550fd8815..053f64191122 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -458,41 +458,11 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t selector,
 
 vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
-	uint16_t index[4];
-	uint64_t *pml4e, *pdpe, *pde;
-	uint64_t *pte;
+	uint64_t *pte = vm_get_page_table_entry(vm, gva);
 
-	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
-		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
-
-	index[0] = (gva >> 12) & 0x1ffu;
-	index[1] = (gva >> 21) & 0x1ffu;
-	index[2] = (gva >> 30) & 0x1ffu;
-	index[3] = (gva >> 39) & 0x1ffu;
-
-	if (!vm->pgd_created)
-		goto unmapped_gva;
-	pml4e = addr_gpa2hva(vm, vm->pgd);
-	if (!(pml4e[index[3]] & PTE_PRESENT_MASK))
-		goto unmapped_gva;
-
-	pdpe = addr_gpa2hva(vm, PTE_GET_PFN(pml4e[index[3]]) * vm->page_size);
-	if (!(pdpe[index[2]] & PTE_PRESENT_MASK))
-		goto unmapped_gva;
-
-	pde = addr_gpa2hva(vm, PTE_GET_PFN(pdpe[index[2]]) * vm->page_size);
-	if (!(pde[index[1]] & PTE_PRESENT_MASK))
-		goto unmapped_gva;
-
-	pte = addr_gpa2hva(vm, PTE_GET_PFN(pde[index[1]]) * vm->page_size);
-	if (!(pte[index[0]] & PTE_PRESENT_MASK))
-		goto unmapped_gva;
-
-	return (PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & ~PAGE_MASK);
-
-unmapped_gva:
-	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
-	exit(EXIT_FAILURE);
+	TEST_ASSERT(*pte & PTE_PRESENT_MASK,
+		    "Leaf PTE not PRESENT for gva: 0x%08lx", gva);
+	return PTE_GET_PA(*pte) | (gva & ~PAGE_MASK);
 }
 
 static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
-- 
2.38.0.rc1.362.ged0d419d3c-goog

