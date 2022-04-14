Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968D85017E1
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 18:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbiDNPvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 11:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359161AbiDNPmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 11:42:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84FC713E18
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 08:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649950121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AznoU5JPVUK2tlvR9fU3oFCYDoJwS4fKkDjVBXTU/c0=;
        b=g1YvuE1bYCZzdqYzohwq6J2i3ib1cMRpydHumQ3JFMSp/9fup+izFZA0/9vAieYJ1QYi8T
        QHG63GI/R3AmbneYWWEl5BJvnjKJ4lJtjEGqP2hWp4R2uVC1CCme1+AyuZSNnbxlXwKJjO
        hTzp3nZ8V0l1SWfxpgdZpj+71pFZeSc=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-6fbWtc_MMieMnvDbrtgnrg-1; Thu, 14 Apr 2022 11:28:40 -0400
X-MC-Unique: 6fbWtc_MMieMnvDbrtgnrg-1
Received: by mail-io1-f71.google.com with SMTP id k20-20020a5e9314000000b00649d55ffa67so3192196iom.20
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 08:28:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AznoU5JPVUK2tlvR9fU3oFCYDoJwS4fKkDjVBXTU/c0=;
        b=VVlQ/O3zassfBxwrgUr28eLBQet6sHGKKn+cvRSxWdYgaRXJcdfAXLj7+siueKHj54
         6f11jXy8P3op7ZgZETqwb+SGHg6TwH4CgX9gg5kk2YmPfMFFZDo3xZ+hUtEYy+1qExlT
         8DbunAHouJkxfsu1/gDdGL+KQ01dX9fcL2RiBVWy/R0wfj9XF/5KAB1weH14hoStxD14
         cHwlwNmwpamULw1UXB2MgnkkHpJkOOhx3cVEuZtxBAa77/qXfjlsIsiVE+5sg0TrUxRh
         kYJssBzPKhwnGx9N4zU3+01vm327qiyTyZx7OOxtDaqVlNC5mFerjaX/bmwUFxt2aGa7
         ptFA==
X-Gm-Message-State: AOAM532TYi8I5jouymEsWQr5vvExsZxuQED/HpPikF/Ay1RygHdmlVKK
        M4Nhy0HyqlkDSS1jz7lOjQzveD3HTSWU2eKCGhD5/Lu1uZW2VVkfa9nvj1C6FmoalDCW0d4qlH3
        aW224fUsADtoM
X-Received: by 2002:a05:6638:1682:b0:323:6b82:462c with SMTP id f2-20020a056638168200b003236b82462cmr1384468jat.51.1649950119631;
        Thu, 14 Apr 2022 08:28:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ2tFi9fIYu99oZWnzZqpTjI19HE1BJz+91dM4flMSDY5iIH+Wiale8seireyE8OGnYPbpAA==
X-Received: by 2002:a05:6638:1682:b0:323:6b82:462c with SMTP id f2-20020a056638168200b003236b82462cmr1384458jat.51.1649950119321;
        Thu, 14 Apr 2022 08:28:39 -0700 (PDT)
Received: from localhost.localdomain (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id y6-20020a056e02174600b002c7f247b3a7sm1308626ill.54.2022.04.14.08.28.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 14 Apr 2022 08:28:39 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, peterx@redhat.com,
        David Matlack <dmatlack@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>
Subject: [PATCH v2] kvm: selftests: Fix cut-off of addr_gva2gpa lookup
Date:   Thu, 14 Apr 2022 11:28:37 -0400
Message-Id: <20220414152837.83320-1-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Our QE team reported test failure on access_tracking_perf_test:

Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory offset: 0x3fffbffff000

Populating memory             : 0.684014577s
Writing to populated memory   : 0.006230175s
Reading from populated memory : 0.004557805s
==== Test Assertion Failure ====
  lib/kvm_util.c:1411: false
  pid=125806 tid=125809 errno=4 - Interrupted system call
     1  0x0000000000402f7c: addr_gpa2hva at kvm_util.c:1411
     2   (inlined by) addr_gpa2hva at kvm_util.c:1405
     3  0x0000000000401f52: lookup_pfn at access_tracking_perf_test.c:98
     4   (inlined by) mark_vcpu_memory_idle at access_tracking_perf_test.c:152
     5   (inlined by) vcpu_thread_main at access_tracking_perf_test.c:232
     6  0x00007fefe9ff81ce: ?? ??:0
     7  0x00007fefe9c64d82: ?? ??:0
  No vm physical memory at 0xffbffff000

I can easily reproduce it with a Intel(R) Xeon(R) CPU E5-2630 with 46 bits
PA.

It turns out that the address translation for clearing idle page tracking
returned wrong result, in which addr_gva2gpa()'s last step (upon
"pte[index[0]].pfn") did the calculation with 40 bits length so the
overflowed bits got cut off.  In above case the GPA address to be returned
should be 0x3fffbffff000 for GVA 0xc0000000, but it got cut-off into
0xffbffff000, then it caused further lookup failure in the gpa2hva mapping.

Fix it by forcing all ->pfn fetching for all layers of pgtables with force
cast to uint64_t.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2075036
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 26 ++++++++++++++-----
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9f000dfb5594..32832d1f9acb 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -51,6 +51,18 @@ struct pageTableEntry {
 	uint64_t execute_disable:1;
 };
 
+/*
+ * Let's always remember to reference PFN within pgtables using this macro.
+ * It's complier's choice to decide whether further calculation upon the
+ * pfn field will also be limited to 40 bits (which is the bit length
+ * defined for .pfn in either pageUpperEntry or pageTableEntry) so the
+ * output could overflow.  For example, gcc version 11.1.1 20210428 will do
+ * the cut-off, while clang version 12.0.1 does not.
+ *
+ * To make it always work, force a cast.
+ */
+#define  __get_pfn(entry)  ((uint64_t)(entry.pfn))
+
 void regs_dump(FILE *stream, struct kvm_regs *regs,
 	       uint8_t indent)
 {
@@ -335,7 +347,7 @@ static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vc
 		(rsvd_mask | (1ull << 7))) == 0,
 		"Unexpected reserved bits set.");
 
-	pdpe = addr_gpa2hva(vm, pml4e[index[3]].pfn * vm->page_size);
+	pdpe = addr_gpa2hva(vm, __get_pfn(pml4e[index[3]]) * vm->page_size);
 	TEST_ASSERT(pdpe[index[2]].present,
 		"Expected pdpe to be present for gva: 0x%08lx", vaddr);
 	TEST_ASSERT(pdpe[index[2]].page_size == 0,
@@ -343,7 +355,7 @@ static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vc
 	TEST_ASSERT((*(uint64_t*)(&pdpe[index[2]]) & rsvd_mask) == 0,
 		"Unexpected reserved bits set.");
 
-	pde = addr_gpa2hva(vm, pdpe[index[2]].pfn * vm->page_size);
+	pde = addr_gpa2hva(vm, __get_pfn(pdpe[index[2]]) * vm->page_size);
 	TEST_ASSERT(pde[index[1]].present,
 		"Expected pde to be present for gva: 0x%08lx", vaddr);
 	TEST_ASSERT(pde[index[1]].page_size == 0,
@@ -351,7 +363,7 @@ static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vc
 	TEST_ASSERT((*(uint64_t*)(&pde[index[1]]) & rsvd_mask) == 0,
 		"Unexpected reserved bits set.");
 
-	pte = addr_gpa2hva(vm, pde[index[1]].pfn * vm->page_size);
+	pte = addr_gpa2hva(vm, __get_pfn(pde[index[1]]) * vm->page_size);
 	TEST_ASSERT(pte[index[0]].present,
 		"Expected pte to be present for gva: 0x%08lx", vaddr);
 
@@ -575,19 +587,19 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	if (!pml4e[index[3]].present)
 		goto unmapped_gva;
 
-	pdpe = addr_gpa2hva(vm, pml4e[index[3]].pfn * vm->page_size);
+	pdpe = addr_gpa2hva(vm, __get_pfn(pml4e[index[3]]) * vm->page_size);
 	if (!pdpe[index[2]].present)
 		goto unmapped_gva;
 
-	pde = addr_gpa2hva(vm, pdpe[index[2]].pfn * vm->page_size);
+	pde = addr_gpa2hva(vm, __get_pfn(pdpe[index[2]]) * vm->page_size);
 	if (!pde[index[1]].present)
 		goto unmapped_gva;
 
-	pte = addr_gpa2hva(vm, pde[index[1]].pfn * vm->page_size);
+	pte = addr_gpa2hva(vm, __get_pfn(pde[index[1]]) * vm->page_size);
 	if (!pte[index[0]].present)
 		goto unmapped_gva;
 
-	return (pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
+	return (__get_pfn(pte[index[0]]) * vm->page_size) + (gva & 0xfffu);
 
 unmapped_gva:
 	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
-- 
2.32.0

