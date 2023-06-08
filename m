Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DAD7275AE
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 05:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbjFHDZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 23:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbjFHDYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 23:24:45 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBDB210A
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 20:24:44 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-39a9b16b37bso130890b6e.1
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 20:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686194682; x=1688786682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=amk+85rcFOEG0VcwuC0GEJTQvC7gKI7CfBL/n9y3Wjk=;
        b=KoW2Cai7O57Pl3gqJ9zgbc22dpLlVb7iGVHoWl5Z8VXh082/fIfw3dubwBorOs33IQ
         4ZCqSaIt8cQJtOOSvoYpIq2TThd6bR0sVQkNy5WQZJWVGo4P1nPuDY5YxPlObTQ9jXsa
         WAq3ku+12nxQomVObqlFCWMwrsuySN589sjuFj+0VjDH5LRNTLoECGq5Ba4OcP70NfUi
         5NSq5VJrVLPbxzfxDZhHfjBX5gh5eCzTTqNHQGZtRHb/FW5zNTv6KZ+8CpzDlFfPPXzG
         vFrN3/WXaK2NdzHWZXROg59TOz0RGZkY4EMtbJjcH5JyKoUuiyKGkaYdMusMAr5jkvKN
         LI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686194682; x=1688786682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=amk+85rcFOEG0VcwuC0GEJTQvC7gKI7CfBL/n9y3Wjk=;
        b=ikF7adNFkDnfXIwWMh7nGsoc4tuljaYqV3H99QRJEe06z25YXWDSr4hfS4+/M/Tecx
         df5K2RR6jCmBStV1lZp1YPcdexNJWxmd5gk7yETHctsJgQn4vbpMWfUcxk/xYqS+n/vh
         ONIiUMS2itcQvavM3Ku4LLN7BWIwHfVx241QXqk+92NpYlcbhMjsZNf89jPrE5LyNw0E
         KuhGIdxJSdOCgvqkSKbnKwmDBZ5+tBGDdwKfvwTtrHGRNqGBYGik1XJU9uWXMH5cOpit
         zrRoyebBr574t1u98c2u1xVr0cBDPxTyqsZ6ZAqEPyuPPAz+zd61OM9JYPwASu1R8DbH
         VdUw==
X-Gm-Message-State: AC+VfDwxRwgCH4eRqsc95FI7DPDYw84KyrM69cO/to0Xo4VADEuMEhux
        oArDA7EFO8ngCc8hL8GAF0dHEw3Ycy8=
X-Google-Smtp-Source: ACHHUZ52jpFSNcSJqFuHZeU6QrpkZcVwzp1YQoGV2ph/MtJ+gQ0dqW58LzXNOK9Zb3AWfX1DlRKnmg==
X-Received: by 2002:a05:6808:496:b0:394:45ad:3ea7 with SMTP id z22-20020a056808049600b0039445ad3ea7mr7593080oid.5.1686194681878;
        Wed, 07 Jun 2023 20:24:41 -0700 (PDT)
Received: from wheely.local0.net (58-6-224-112.tpgi.com.au. [58.6.224.112])
        by smtp.gmail.com with ESMTPSA id s12-20020a17090a5d0c00b0025930e50e28sm2015629pji.41.2023.06.07.20.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 20:24:41 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 2/6] KVM: selftests: Add aligned guest physical page allocator
Date:   Thu,  8 Jun 2023 13:24:21 +1000
Message-Id: <20230608032425.59796-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608032425.59796-1-npiggin@gmail.com>
References: <20230608032425.59796-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

powerpc will require this to allocate MMU tables in guest memory that
are larger than guest base page size.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 44 ++++++++++++-------
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index d630a0a1877c..42d03ae08ecb 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -680,6 +680,8 @@ const char *exit_reason_str(unsigned int exit_reason);
 
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot);
+vm_paddr_t vm_phy_pages_alloc_align(struct kvm_vm *vm, size_t num, size_t align,
+			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 298c4372fb1a..68558d60f949 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1903,6 +1903,7 @@ const char *exit_reason_str(unsigned int exit_reason)
  * Input Args:
  *   vm - Virtual Machine
  *   num - number of pages
+ *   align - pages alignment
  *   paddr_min - Physical address minimum
  *   memslot - Memory region to allocate page from
  *
@@ -1916,7 +1917,7 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+vm_paddr_t vm_phy_pages_alloc_align(struct kvm_vm *vm, size_t num, size_t align,
 			      vm_paddr_t paddr_min, uint32_t memslot)
 {
 	struct userspace_mem_region *region;
@@ -1930,24 +1931,27 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		paddr_min, vm->page_size);
 
 	region = memslot2region(vm, memslot);
-	base = pg = paddr_min >> vm->page_shift;
-
-	do {
-		for (; pg < base + num; ++pg) {
-			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
-				base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
-				break;
+	base = paddr_min >> vm->page_shift;
+
+again:
+	base = (base + align - 1) & ~(align - 1);
+	for (pg = base; pg < base + num; ++pg) {
+		if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
+			base = sparsebit_next_set(region->unused_phy_pages, pg);
+			if (!base) {
+				fprintf(stderr, "No guest physical pages "
+					"available, paddr_min: 0x%lx "
+					"page_size: 0x%x memslot: %u "
+					"num_pages: %lu align: %lu\n",
+					paddr_min, vm->page_size, memslot,
+					num, align);
+				fputs("---- vm dump ----\n", stderr);
+				vm_dump(stderr, vm, 2);
+				TEST_ASSERT(false, "false");
+				abort();
 			}
+			goto again;
 		}
-	} while (pg && pg != base + num);
-
-	if (pg == 0) {
-		fprintf(stderr, "No guest physical page available, "
-			"paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
-			paddr_min, vm->page_size, memslot);
-		fputs("---- vm dump ----\n", stderr);
-		vm_dump(stderr, vm, 2);
-		abort();
 	}
 
 	for (pg = base; pg < base + num; ++pg)
@@ -1956,6 +1960,12 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	return base * vm->page_size;
 }
 
+vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			      vm_paddr_t paddr_min, uint32_t memslot)
+{
+	return vm_phy_pages_alloc_align(vm, num, 1, paddr_min, memslot);
+}
+
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot)
 {
-- 
2.40.1

