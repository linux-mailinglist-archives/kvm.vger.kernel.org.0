Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D48252F565
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 23:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353792AbiETV5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 17:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353790AbiETV5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 17:57:34 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1524A18C073
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:34 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id cd6-20020a056a00420600b00510a99055e2so4737771pfb.17
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/3btooTUxYy4rjHmRouQUpf5jOli5cRswOzHLZ9mznY=;
        b=k7Rtx8bLLCQghDV/l5jEO7aW1i5WYkytI786Fl27Jks39z16UXQdFxKaA3MjBaT693
         4xS7S96vZ90Cfn2RGzFblgLgKnswqp8QiwNvr890xCkZBykxtDMArilakdowyAEPQzZx
         lIKBW3ZhLH2kui5fEPeSbz5obFo0V/vNZzX3EEYHoWM2jn45sYety4ocWVzRk7u4iS7C
         t7rMHVDpqDk5EMTUZg3LxztwzFLUjbcN88AwtGygrgbefHOeKW6N2GZqCl9k7ssXeCsP
         w/j5Q9TVrQPA/NCxzTW7FqUK7w+8jbeIMUFAWOp8DMAjfBWV6GWSNzFCzeZwH5c5zQxG
         1eFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/3btooTUxYy4rjHmRouQUpf5jOli5cRswOzHLZ9mznY=;
        b=5oFnMBT56uIph/2/gaW4jxeYoAdLAe+eyWVWRIzFzCUG2z1e0Yz2CKueTW1kRO/8sU
         cMr9WzyNgaclhkeA1xU4M6xhtFBHs41aKxCYVs5ycYLCh4n4RXxGDU1fZ9IO4DEN3IeZ
         IJYm0MNHn5Hv0zr6JF0KciOruMoR46OUuaWZYF7uD+FymGWv67FtqLz4iJgObMZo/ebe
         4xNnPlgz4NDvjsbE7QRGQqjczdcwo+mChG6bbplsDlV3QFyC0o05y3X2fTog1KrllBtE
         kOMFv5NSw3WqgJwo35RoHOWESjj9oz5OCZl1t3vnErEm7IdCIO9pJkmlSxcr/l7mDSGi
         J6ng==
X-Gm-Message-State: AOAM5335P5bgSZjeAZYSJANgqKQZriC3vZlRNF0KrNs9VOFNhHz2XzT8
        vy+umt1Ow7zD0SxaPge737PU55+PcpzDuQ==
X-Google-Smtp-Source: ABdhPJxvdD7xN8mPGQkL95kn3dLL455bc/VWf+69K42ROi78thKp4oHWGw/F57O4PFXLMY/iWYrARiQAMoDZFw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:1cd:b0:161:f93d:7bd9 with SMTP id
 e13-20020a17090301cd00b00161f93d7bd9mr3516556plh.76.1653083853532; Fri, 20
 May 2022 14:57:33 -0700 (PDT)
Date:   Fri, 20 May 2022 21:57:17 +0000
In-Reply-To: <20220520215723.3270205-1-dmatlack@google.com>
Message-Id: <20220520215723.3270205-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520215723.3270205-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v3 04/10] KVM: selftests: Refactor nested_map() to specify
 target level
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index baeaa35de113..b8cfe4914a3a 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -486,6 +486,7 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  *   nested_paddr - Nested guest physical address to map
  *   paddr - VM Physical Address
  *   size - The size of the range to map
+ *   level - The level at which to map the range
  *
  * Output Args: None
  *
@@ -494,22 +495,29 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
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
2.36.1.124.g0e6072fb45-goog

