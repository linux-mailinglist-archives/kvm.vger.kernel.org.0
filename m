Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984BF52AB77
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 21:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352491AbiEQTFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 15:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352482AbiEQTFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 15:05:33 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325413F30C
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:33 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id nl9-20020a17090b384900b001df338b4b72so1900907pjb.6
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sx2V9VDm+ObdOOVN3aV0qnc2LPNZWBAseaQ3ZqDsyOA=;
        b=tTom5wHz6fvvfT6thkpCs43c8FgQngPnlAbZ+g6cycG7aIma/81AZwxPJ3/givqdSR
         9wgdEuqzPdDGPsoYoPc7o0uI5yaqsjGmIm5L/KOmrKgzQzivRnbcLVqlXQ+JHC42DzRk
         nWirZuzV52IQOQh86L53GdgT3Aq/oH0CK49tLs0+VeNAn/nxBdDKJoGbAvgCUJVt/KqX
         c5Vn1afn8b+F190y5wNDADOE5fnZGf807reTAzCF5sK8CMCG0lM+c4gp8ktROxSfDFyN
         P/tDgYkI9WRf/zXSDJC0v6mR5Q7jQAjT4QRrbGLy8g91unNxn16WthHbA6YpZJQ4zpIV
         hmmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sx2V9VDm+ObdOOVN3aV0qnc2LPNZWBAseaQ3ZqDsyOA=;
        b=jqY9KMFrc/7oCr3JEYNhy6sF3dFamoXjInpmbXwalMD5oMNyl2pFNuB6OgkmI4JkD9
         2htGqKQt0VtjgE5O8AqE6RK6PX8B91SZnpAwC59lp4OJWzuwRqCd6TUjJTV8l+jtnHWp
         2DKg0hiYyuRWP51PYWxgaY3wWRA9W3lR01rVDmq6looiNV1OFUyte7ApNngrhtFOb7kD
         YdWFajK7t0yhXUFy8jOg1PmsGzhVPlkPDtoc5u8kq5j3RZ77ZJS45za07yKU6Y5SuRxA
         rVgT7lZFHm7+mRIN7pM8YK2dRNr5SZ+sU/D9uM/c2Wwm6BtGYZd1jPAcduoN+gKZCNxd
         MlrQ==
X-Gm-Message-State: AOAM530ZLXmjoNKTxev9JaX3dPtdefEQwDY3frbhZst1EvtlycxdLGqf
        K/kt1cYaepkAgPXlwvhA+dPm6XaI4QSSoA==
X-Google-Smtp-Source: ABdhPJzH7JiHGHxEBatLfy5d2vdCYrHAgsnn4bE/BLw8ku7NyxZJ163M2bTjqdM2MlEKAYi5TqonCiYDA6UExw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:2402:b0:4e1:46ca:68bd with SMTP
 id z2-20020a056a00240200b004e146ca68bdmr23825636pfh.70.1652814332652; Tue, 17
 May 2022 12:05:32 -0700 (PDT)
Date:   Tue, 17 May 2022 19:05:18 +0000
In-Reply-To: <20220517190524.2202762-1-dmatlack@google.com>
Message-Id: <20220517190524.2202762-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v2 04/10] KVM: selftests: Refactor nested_map() to specify
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
2.36.0.550.gb090851708-goog

