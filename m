Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B1858EF43
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 17:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiHJPUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 11:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbiHJPUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 11:20:39 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8142409A
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:38 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id kb4-20020a17090ae7c400b001f783657496so1328540pjb.6
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=pTM3VLICBKkRJLIraoN2yuH4ndpvQ9iDrH4IB8fss5I=;
        b=lCGx5tQ+dKIhHpZkyE+MZbxrlQvpioxRjZ7bmh7+2m+A0y8AOoy+W0jF7eMd1jtOxG
         EPwXD8JyVuI39oh8FkykSP6/0ABy9z9fM6g8JewNekobOp8MC3aLOcho/pZhpuDjrn6w
         ptsFU/fy+YOt5n7VbGx7o0YHKZNcIvBFj2RjaOklj8awdiEYiygkBJFs0tZ7Z0cp9Fz3
         R65Ki0oRTXX7HsmlSUJ29CAOwgwzGNKzEu8s1F+Who4sHJH2OVf1+1WW5ndUY/TKUf5s
         CPkGIOeV/O5QjBIkAOtA6zHVYnwqmAztNVVTLaYwDFjI00pJ+celv8dtE4aMadvd3r2t
         NAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=pTM3VLICBKkRJLIraoN2yuH4ndpvQ9iDrH4IB8fss5I=;
        b=6N72OVHZGbPFammDopPB8iM9IvW3wCAfoefgtS+lcgF+i8wWE4rsqSuGPX0JfV1csN
         4wJ3JoUlzxhqH2dMwL0+J0EPjUiCvelxl9lwkn4VAQ1h8Ut1SStaW6U5uyWq5h9NkLJO
         Rg6k2+Yh1rtKDHT5RkaYgwuzaOkL9ZvMnfMRd1d1VybKFpIoETPxcj3U72McNGmujmyS
         YXqo/6J9XbCQiDH7PABDMyOfuW4WrFuk6Up+wYtEct76laF3Bh64lea5y5tkw3f2arZs
         mdYaGNZ+OoeQRARW6+8UVxAs5UWHM8vDa3pcUX12WFn4cRJe6w1nkZL6S3TFyHRagayk
         f6yQ==
X-Gm-Message-State: ACgBeo3P6ot4MHijlSUwXDyCvq5jeRPVIOGie1DZJxZ2+ceL+fi7g9qJ
        FpFIZaERBAoIBX6yvAiCRvTQNlWN3/a5Ym4RFRi+7ev9eUbZkH7LRTqNtvTRzfNXm+rg4tKeWaZ
        SdtwfKGpfoBvLNkHTjTRGQxZB1t6mHEEB5/U+C5EFTjAwEsxyHZf4HDycFA==
X-Google-Smtp-Source: AA6agR5u7bmiuslS/TLDZgTUSpRz4B0WdpLYWlxKyrIDhaQ9QjML9QMkKIBFIKhsAyG6j9iqiUlyAhJl8fk=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:b185:1827:5b23:bbe2])
 (user=pgonda job=sendgmr) by 2002:a17:902:ccd0:b0:16c:5d4f:99f3 with SMTP id
 z16-20020a170902ccd000b0016c5d4f99f3mr27993747ple.139.1660144838210; Wed, 10
 Aug 2022 08:20:38 -0700 (PDT)
Date:   Wed, 10 Aug 2022 08:20:23 -0700
In-Reply-To: <20220810152033.946942-1-pgonda@google.com>
Message-Id: <20220810152033.946942-2-pgonda@google.com>
Mime-Version: 1.0
References: <20220810152033.946942-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [V3 01/11] KVM: selftests: move vm_phy_pages_alloc() earlier in file
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, vannapurve@google.com,
        Peter Gonda <pgonda@google.com>
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
index 9889fe0d8919..cb3a5f8a53b7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1089,6 +1089,78 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
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
@@ -1735,79 +1807,6 @@ const char *exit_reason_str(unsigned int exit_reason)
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
2.37.1.559.g78731f0fdb-goog

