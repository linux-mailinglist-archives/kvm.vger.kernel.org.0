Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46DD5153D9
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380082AbiD2SnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380079AbiD2SnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:43:09 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B87D64CD
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:50 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i19-20020aa79093000000b0050d44b83506so4552072pfa.22
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gMz0hMrjdbXDHTQ8RW43oHBBrWZy5mDRZcH9wKZIsjA=;
        b=H3CBdqdsB9ntXoC+QEn+ptAhZ+1NnPUx0WGPaFsHmv/czxEoiyg+osRLoq2eKToeUy
         Eg0shDnk/juZr6IE7KAW+8aIB5VKjAsA5Ds2msL7dnB5iC3OdaJN+5zyBBQkpe3xnCRi
         gITTd2CW90g18ePySX/T8/CS8aW5rfBQOuuZEJulkuEgJM/D9uPYLMHzzYKTYURRvxem
         dybUUP3VjmiVFqv5041ZzLvHrkIybPGyJZtYg4TnDGZHcD48HiYGFQ1hOuwqcmqTpCOK
         Kfr2Z2rQobqmB/B/Mw/ey6l3JfrcmRzzwSySxgewsW8TD5sbstDF3veb2aO3VCUh5nHR
         KlHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gMz0hMrjdbXDHTQ8RW43oHBBrWZy5mDRZcH9wKZIsjA=;
        b=dNE+7uEVPD+j63lqB/zCRqxcHzrVCNUSCP8gqToFFvrEpbxjXEGqlghpBhy386QKhW
         52SkMfX+pmaSvS0ytlJHBhR5zetBtjjY4xewq8NpzpQRbR+PQ5Hof1FCeoq1Bdm1cfEv
         SuKLTMJOv0iHdm6bv3fBCAFWQsGyfqkzgZ8t2tDYUqs+06RvaHGwc/3KcVnM6fC9yJSj
         CoN2nQI9z7tRG+qrkAb7+Po8YmN6V3TzVivmn7wfkFRoLNG0Tk7c2U54WnQJsIKX3lz3
         eo4Cv3mlLl7pfMxD/v3clQCe3uOAnxEQ79YiOaQYhe+5Z1aP3xEml7WrWvpoYpgZ12dd
         3Rww==
X-Gm-Message-State: AOAM5311DAZjbGfj2/LDQ3qNIG4YPE6rxgRdX+0gYQWmszphA/LcezEc
        u94hmmaAXhaHXDHj61SBXnRU3drQtFdaMg==
X-Google-Smtp-Source: ABdhPJznv9O8EXzm+YUnM0sJ0lmY5JEYOpv4OTXTjoQYBumPzDAz/5rO+0vENUvbhJ4vqlq2tEXTHhfNMr5PtQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:aa7:8385:0:b0:4f6:ef47:e943 with SMTP id
 u5-20020aa78385000000b004f6ef47e943mr619660pfm.38.1651257589945; Fri, 29 Apr
 2022 11:39:49 -0700 (PDT)
Date:   Fri, 29 Apr 2022 18:39:30 +0000
In-Reply-To: <20220429183935.1094599-1-dmatlack@google.com>
Message-Id: <20220429183935.1094599-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220429183935.1094599-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 4/9] KVM: selftests: Refactor nested_map() to specify target level
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor nested_map() to specify that it explicityl wants 4K mappings
(the existing behavior) and push the implementation down into
__nested_map(), which can be used in subsequent commits to create huge
page mappings.

No function change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index ac432e064fcd..715b58f1f7bc 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -485,6 +485,7 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  *   nested_paddr - Nested guest physical address to map
  *   paddr - VM Physical Address
  *   size - The size of the range to map
+ *   level - The level at which to map the range
  *
  * Output Args: None
  *
@@ -493,22 +494,29 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  * Within the VM given by vm, creates a nested guest translation for the
  * page range starting at nested_paddr to the page range starting at paddr.
  */
-void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		uint64_t nested_paddr, uint64_t paddr, uint64_t size)
+void __nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+		  uint64_t nested_paddr, uint64_t paddr, uint64_t size,
+		  int level)
 {
-	size_t page_size = vm->page_size;
+	size_t page_size = PG_LEVEL_SIZE(level);
 	size_t npages = size / page_size;
 
 	TEST_ASSERT(nested_paddr + size > nested_paddr, "Vaddr overflow");
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
 	while (npages--) {
-		nested_pg_map(vmx, vm, nested_paddr, paddr);
+		__nested_pg_map(vmx, vm, nested_paddr, paddr, level);
 		nested_paddr += page_size;
 		paddr += page_size;
 	}
 }
 
+void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+		uint64_t nested_paddr, uint64_t paddr, uint64_t size)
+{
+	__nested_map(vmx, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
+}
+
 /* Prepare an identity extended page table that maps all the
  * physical pages in VM.
  */
-- 
2.36.0.464.gb9c8b46e94-goog

