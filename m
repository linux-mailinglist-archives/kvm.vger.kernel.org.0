Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F165A52C9
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 19:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiH2RK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 13:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiH2RKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 13:10:55 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D595466E
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:10:53 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l16-20020a170902f69000b00175138bcd25so65735plg.2
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=d7ZiMUB7LT41+2/O/fscI6FlTx2h5Za4q8M0Amcc3B4=;
        b=ZhI8GIrMnTkdrvVsyH9Db+OCesFOtjP3YC959CITathFqifVfvqSQbd5FM76Olwvsb
         QIZ63/MpVM7Ygz3srB8Iu4f/q5RR+l4/IzBQBcGb9y0jIMHyS16Q3uZv63EWIGjtP0Ut
         Up5yfbY/kEQsT14gbcfxP0gcGUPtqOBs51u/bSKOUqgxmJfUAggczWvk/MdVhF8sZmCJ
         dRpCsG5+mGiILKF/BDKHyt08ehXh3fO6IwGSkpR3dn92CFwk6QK/0iN0d17XLHKlHlE3
         171TwZaVopJP2hReB2DS9Qbf+JRFzc0MzPHzGvqZx/kz0vIy6ysBYkb8p8UVm5YmAt9A
         npWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=d7ZiMUB7LT41+2/O/fscI6FlTx2h5Za4q8M0Amcc3B4=;
        b=xuWasotc0zfmfYrmsrhhpG3zxLkfor4zyvKqMOX7hJftjem5MuhkUe8F/zJflXyGm2
         EyV79vukuWxIkMfGpGhAacWSYeb0crun8yUabuZt/YQb5MTcf2gmzKDcyyA3Ih5h1x8J
         wl3H/7fDj1lBiAnDs9GzsNOAF6f6D6KD8L5ZDuk4tn/JbFIZGQn9NHIACzu1gpBsoeVb
         nBMgFpSuJ2O48IN3qxjCln1fcRbj/7k3qXh8wYJjWwme8WvDSHzNzSblPwzOom747z/r
         +3Mvj6Vj4kvgZCJKCeCq6a35j9u10jMGY8Q28WG0z1RtmInIzbmJApu4q1PrmnRSRtye
         lg9Q==
X-Gm-Message-State: ACgBeo1vyQ5JKjo4V+2qOb0mGbzS3VhER/X2uo6T+b0c7lTdqGqrBd3U
        XNX9PYxLW82FIs5/Xs/MiQoaX5SPyAsAFF89DaMTlWraLI4o2cq4N+89xCXofVv4omC3bHSmdee
        Fix6OY9A2HLjngCx6Nr08//iyw/LJLQ0BrlaGu2qSlH2/pFIMRBYFCsZWyA==
X-Google-Smtp-Source: AA6agR61sjj8KgjJQ7+tGZSdi+MrfGFJVVy/DwyyXR3ptKKf3tFUJkU3TWwbxGMaGS/oKDXM2GYG6uI3gTo=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:cddb:77a7:c55e:a7a2])
 (user=pgonda job=sendgmr) by 2002:a17:90b:4a01:b0:1fb:5583:578a with SMTP id
 kk1-20020a17090b4a0100b001fb5583578amr19849612pjb.216.1661793052405; Mon, 29
 Aug 2022 10:10:52 -0700 (PDT)
Date:   Mon, 29 Aug 2022 10:10:14 -0700
In-Reply-To: <20220829171021.701198-1-pgonda@google.com>
Message-Id: <20220829171021.701198-2-pgonda@google.com>
Mime-Version: 1.0
References: <20220829171021.701198-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Subject: [V4 1/8] KVM: selftests: move vm_phy_pages_alloc() earlier in file
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, Peter Gonda <pgonda@google.com>
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

From: Michael Roth <michael.roth@amd.com>

Subsequent patches will break some of this code out into file-local
helper functions, which will be used by functions like vm_vaddr_alloc(),
which currently are defined earlier in the file, so a forward
declaration would be needed.

Instead, move it earlier in the file, just above vm_vaddr_alloc() and
and friends, which are the main users.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 145 ++++++++++-----------
 1 file changed, 72 insertions(+), 73 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 846f9f6c5a17..06559994711e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1100,6 +1100,78 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	return vcpu;
 }
 
+/*
+ * Physical Contiguous Page Allocator
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   num - number of pages
+ *   paddr_min - Physical address minimum
+ *   memslot - Memory region to allocate page from
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Starting physical address
+ *
+ * Within the VM specified by vm, locates a range of available physical
+ * pages at or above paddr_min. If found, the pages are marked as in use
+ * and their base address is returned. A TEST_ASSERT failure occurs if
+ * not enough pages are available at or above paddr_min.
+ */
+vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			      vm_paddr_t paddr_min, uint32_t memslot)
+{
+	struct userspace_mem_region *region;
+	sparsebit_idx_t pg, base;
+
+	TEST_ASSERT(num > 0, "Must allocate at least one page");
+
+	TEST_ASSERT((paddr_min % vm->page_size) == 0,
+		"Min physical address not divisible by page size.\n paddr_min: 0x%lx page_size: 0x%x",
+		paddr_min, vm->page_size);
+
+	region = memslot2region(vm, memslot);
+	base = pg = paddr_min >> vm->page_shift;
+
+	do {
+		for (; pg < base + num; ++pg) {
+			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
+				base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
+				break;
+			}
+		}
+	} while (pg && pg != base + num);
+
+	if (pg == 0) {
+		fprintf(stderr,
+			"No guest physical page available, paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
+			paddr_min, vm->page_size, memslot);
+		fputs("---- vm dump ----\n", stderr);
+		vm_dump(stderr, vm, 2);
+		abort();
+	}
+
+	for (pg = base; pg < base + num; ++pg)
+		sparsebit_clear(region->unused_phy_pages, pg);
+
+	return base * vm->page_size;
+}
+
+vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
+			     uint32_t memslot)
+{
+	return vm_phy_pages_alloc(vm, 1, paddr_min, memslot);
+}
+
+/* Arbitrary minimum physical address used for virtual translation tables. */
+#define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
+
+vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
+{
+	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+}
+
 /*
  * VM Virtual Address Unused Gap
  *
@@ -1746,79 +1818,6 @@ const char *exit_reason_str(unsigned int exit_reason)
 	return "Unknown";
 }
 
-/*
- * Physical Contiguous Page Allocator
- *
- * Input Args:
- *   vm - Virtual Machine
- *   num - number of pages
- *   paddr_min - Physical address minimum
- *   memslot - Memory region to allocate page from
- *
- * Output Args: None
- *
- * Return:
- *   Starting physical address
- *
- * Within the VM specified by vm, locates a range of available physical
- * pages at or above paddr_min. If found, the pages are marked as in use
- * and their base address is returned. A TEST_ASSERT failure occurs if
- * not enough pages are available at or above paddr_min.
- */
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot)
-{
-	struct userspace_mem_region *region;
-	sparsebit_idx_t pg, base;
-
-	TEST_ASSERT(num > 0, "Must allocate at least one page");
-
-	TEST_ASSERT((paddr_min % vm->page_size) == 0, "Min physical address "
-		"not divisible by page size.\n"
-		"  paddr_min: 0x%lx page_size: 0x%x",
-		paddr_min, vm->page_size);
-
-	region = memslot2region(vm, memslot);
-	base = pg = paddr_min >> vm->page_shift;
-
-	do {
-		for (; pg < base + num; ++pg) {
-			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
-				base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
-				break;
-			}
-		}
-	} while (pg && pg != base + num);
-
-	if (pg == 0) {
-		fprintf(stderr, "No guest physical page available, "
-			"paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
-			paddr_min, vm->page_size, memslot);
-		fputs("---- vm dump ----\n", stderr);
-		vm_dump(stderr, vm, 2);
-		abort();
-	}
-
-	for (pg = base; pg < base + num; ++pg)
-		sparsebit_clear(region->unused_phy_pages, pg);
-
-	return base * vm->page_size;
-}
-
-vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
-			     uint32_t memslot)
-{
-	return vm_phy_pages_alloc(vm, 1, paddr_min, memslot);
-}
-
-/* Arbitrary minimum physical address used for virtual translation tables. */
-#define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
-
-vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
-{
-	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
-}
-
 /*
  * Address Guest Virtual to Host Virtual
  *
-- 
2.37.2.672.g94769d06f0-goog

