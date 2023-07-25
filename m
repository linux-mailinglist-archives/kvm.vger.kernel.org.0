Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9FFF762565
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjGYWCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbjGYWCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:02:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1872682
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 15:02:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-cf4cb742715so6779678276.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 15:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690322514; x=1690927314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l8eGH3ygkEuOZ47kPtRCFJ0Al+rLHkYn4Wu/qaGwYZM=;
        b=oWQVsf2hHp/RwHjoKxnpR4SZrxj+rOnThYu9FS/jYxi5XEbeFnzYG7NMqLjxRL2lrA
         4C2tpylAk/xvBxDKrmWOS6gs/zdhwq5kgSWEW41GCSbc9ROJsuB0Z2gwJOIgTpoZw8/K
         Atk1vTkBiUXHM5xMzHWHIk9Y7oAPdBPKz1AgKbuXpEAlEUqihSia2Tlb+SztD3o1fUWX
         g7iho/BTaUlxiTmJKzge0op/unGLVjv2X67ONnz9qyHPCuN257mhvDOT/2dkduB0vee4
         wztnViOxci0b3Jz7exmZy1CcFZApchSk6eyJmeHU2LykxhVfj279vWbV1E3VBjFyU5Bv
         Vu8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690322514; x=1690927314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l8eGH3ygkEuOZ47kPtRCFJ0Al+rLHkYn4Wu/qaGwYZM=;
        b=FK++hiybOJjzqmBFjsuJUdwL78MmWqbKKskLewreBSdjRBIB2WV0zqMYzlX7NR7yLD
         gvg0OVCqKOayWlrUrYwqXTHrv1L9LUnKtpJP6AZr8zmMj8F4Nu4xl+QvrfP22HVEAKiF
         cPrKdYGyIViB6A5LU+Fsr+ao766I8PlA3AN/7ofb8X1ndvts3lAIBurNftoF6v84XOcE
         oaQKAjFaWxhzghsmjuy8ZR+OImhOEwX2TlgLZ1TV2w3WSl28evuV91w40RnBdg11WynE
         v84jTN93Qwo40LpxUBMrvrQd9ILZ6FhOW9LeCSNUl6/tPdYF03HGmASBqA7t/v+swJnQ
         Se8g==
X-Gm-Message-State: ABy/qLZnFD8yk244FMPNwPpXyLdOlcHhVM7mfssMmSvjBquoVdhwBCmW
        Z+AOdqFAhL5TtLvZGieFyEKnkkTdWGDJ
X-Google-Smtp-Source: APBJJlFegGohqWqOdSnA6IS8sXWJ8VHwoCGraN7Fw++Y6c88kB55gpqKOQlvPxRwGPoMkWW8QyxDbkskqqQz
X-Received: from afranji.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:47f1])
 (user=afranji job=sendgmr) by 2002:a25:abd2:0:b0:d05:e080:63c6 with SMTP id
 v76-20020a25abd2000000b00d05e08063c6mr2231ybi.9.1690322514251; Tue, 25 Jul
 2023 15:01:54 -0700 (PDT)
Date:   Tue, 25 Jul 2023 22:00:57 +0000
In-Reply-To: <20230725220132.2310657-1-afranji@google.com>
Mime-Version: 1.0
References: <20230725220132.2310657-1-afranji@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230725220132.2310657-5-afranji@google.com>
Subject: [PATCH v4 04/28] KVM: selftests: Refactor steps in vCPU descriptor
 table initialization
From:   Ryan Afranji <afranji@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
        sagis@google.com, erdemaktas@google.com, afranji@google.com,
        runanwang@google.com, shuah@kernel.org, drjones@redhat.com,
        maz@kernel.org, bgardon@google.com, jmattson@google.com,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        ricarkol@google.com, yang.zhong@intel.com, wei.w.wang@intel.com,
        xiaoyao.li@intel.com, pgonda@google.com, eesposit@redhat.com,
        borntraeger@de.ibm.com, eric.auger@redhat.com,
        wangyanan55@huawei.com, aaronlewis@google.com, vkuznets@redhat.com,
        pshier@google.com, axelrasmussen@google.com,
        zhenzhong.duan@intel.com, maciej.szmigiero@oracle.com,
        like.xu@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ackerleytng@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ackerley Tng <ackerleytng@google.com>

Split the vCPU descriptor table initialization process into a few
steps and expose them:

+ Setting up the IDT
+ Syncing exception handlers into the guest

In kvm_setup_idt(), we conditionally allocate guest memory for vm->idt
to avoid double allocation when kvm_setup_idt() is used after
vm_init_descriptor_tables().

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Change-Id: I4a1229173a4e09d6a3770d4b67edc8cdfe83f868
Signed-off-by: Ryan Afranji <afranji@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  2 ++
 .../selftests/kvm/lib/x86_64/processor.c      | 19 ++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index a4923f92460d..2a83a23801b0 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1060,6 +1060,8 @@ struct idt_entry {
 	uint32_t offset2; uint32_t reserved;
 };
 
+void kvm_setup_idt(struct kvm_vm *vm, struct kvm_dtable *dt);
+void sync_exception_handlers_to_guest(struct kvm_vm *vm);
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu);
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 78dd918b9a92..4893a778fff5 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1124,19 +1124,32 @@ void vm_init_descriptor_tables(struct kvm_vm *vm)
 			DEFAULT_CODE_SELECTOR);
 }
 
+void kvm_setup_idt(struct kvm_vm *vm, struct kvm_dtable *dt)
+{
+	if (!vm->idt)
+		vm->idt = vm_vaddr_alloc_page(vm);
+
+	dt->base = vm->idt;
+	dt->limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
+}
+
+void sync_exception_handlers_to_guest(struct kvm_vm *vm)
+{
+	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+}
+
 void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vm *vm = vcpu->vm;
 	struct kvm_sregs sregs;
 
 	vcpu_sregs_get(vcpu, &sregs);
-	sregs.idt.base = vm->idt;
-	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
+	kvm_setup_idt(vcpu->vm, &sregs.idt);
 	sregs.gdt.base = vm->gdt;
 	sregs.gdt.limit = getpagesize() - 1;
 	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
 	vcpu_sregs_set(vcpu, &sregs);
-	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+	sync_exception_handlers_to_guest(vm);
 }
 
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
-- 
2.41.0.487.g6d72f3e995-goog

