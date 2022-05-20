Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3705552F637
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354128AbiETXdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354155AbiETXdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:33:02 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CC3199B36
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:01 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id v10-20020a17090a0c8a00b001c7a548e4f7so7700612pja.2
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/3btooTUxYy4rjHmRouQUpf5jOli5cRswOzHLZ9mznY=;
        b=RnEK4JnPyOne6dW0krgCNXbOT79gho9DtZKLFxdePYyxhoRzWz7LLvZrAB3sLEvUCH
         AEb4rEeWnTOj34Lt+T556HbMT1pa3Pk8yIeF/MaRXK+fX72qPj5h5SR81MBz+CC0unZl
         dgBrqclN8xw99T/cJYeFTP59Py5OgNQl/nL87a+/f/vZnVMXou1or2UU7xUFUVgkDgVO
         3tD2/tJGvx+VSyXbanScf70xAW66DT6utgIG4/+fVhgihTJck5LXVNDUEqPpRvL35Gba
         hx8gVOKV2N2ck85AQMZBV/ws3XBVPeS6q2Qw2SBdV99txOmvR3Ab0VTa2Zq/mJSqvheY
         PyaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/3btooTUxYy4rjHmRouQUpf5jOli5cRswOzHLZ9mznY=;
        b=TwwZSP29wjn24cEwwac96hsZFRCH7QrptJ4XWC0slR4BH1tkTgcb0hvz7bgSsmy8gO
         9dTqWad+9rmmJbCX2An2UiOWi76NoodwIROToDdpPJiDOOczcbW8Xv+/5v2sUKpf7cqg
         FAi1uKIDRyaOV0y1uLoUiweIQhZA+Q9UwqKZLseOgfMmmYOC88DJmoSC72YfOhYnYjyT
         DiSB2YHNCwYLGw1/E/kBk3lcFUfQ8qUl1IkNg+4c0s9YjiSus1NJxb4xhIghx5ln7AqV
         v1dwE39qddpv0SPI0Dopd+cxFYd22KyiKWNMnwPF1wzq6bGNz/uc1FwFXkTybAXCgJCm
         Ltbg==
X-Gm-Message-State: AOAM533TTqraItQL9/wyDk+x9lFAxha8p9wziNwqj1G5/vOw4WRX6oLv
        +4J2gS5I3XtnXA70E/E1AAV9T0SXnAKZGw==
X-Google-Smtp-Source: ABdhPJxyK4cFos6d9rdUzehmscsjEdajy2MKLgAXlhRp3lKrgdQaCN2ori2cYXWO9cHOonenQP06f0Uk7ZZJsg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:4cc2:b0:1dd:1010:d10d with SMTP
 id k60-20020a17090a4cc200b001dd1010d10dmr13848304pjh.205.1653089580529; Fri,
 20 May 2022 16:33:00 -0700 (PDT)
Date:   Fri, 20 May 2022 23:32:42 +0000
In-Reply-To: <20220520233249.3776001-1-dmatlack@google.com>
Message-Id: <20220520233249.3776001-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520233249.3776001-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 04/11] KVM: selftests: Refactor nested_map() to specify
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

