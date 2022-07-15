Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B2E57677A
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 21:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiGOTaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 15:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiGOTaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 15:30:17 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09205FACB
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:13 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31ce88f9ab8so46696997b3.16
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bIijZklVh4BErKC7Xk3qAcNI5ZtgnzrMkDdijeXT1dg=;
        b=J55ZDewgDhhwMXux806HT61m2y/vP24Ri69c4jBiaDP9crsHAMRLCUwVtjggDePyHU
         WLMkhmSEVK9mW5IBCTRTQnX+/gkL9kpy77RvWNvgerSEMKKvpKIcMPPzOnvR7l7MCJu8
         t2r1RR4899RMhyVQuKvt9GL9QQCHItPFu5cF1nDn+o0OxEc3oqWjXesM7Z0Se7PJAWbE
         HHiqkC5c1Qzp3MyyIXgBWXJdix8oKG3VBFNdbVm5Sb8WJ5+ZqflDJpFwD8Fr6J4J8Pdo
         +NCd/0YZrjAWLsQIiG7UHkPboM9cGzOcvHPdBcPKuwHVRT4MHrhsJybcvMb8JT8XyvVK
         y8cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bIijZklVh4BErKC7Xk3qAcNI5ZtgnzrMkDdijeXT1dg=;
        b=7BhHNo/sJD+8EzRSTETxbOCKWN+e7JlVn06Re/tq3rao8EWlcloWpPFSmXz61BH/t2
         sMxMQsURsssjJX5lEaTAhnBLq8OPOJB5NcPjox7IW4NAMQF+bioewn+efOA3EbORMCBH
         pTZF0nM2TLJIK0zO+CePCl2Nrf/tWNDPahQ67ygG0T8imfnUXHc5iXHDjCTu0Ylgb2zx
         ChNr3HFtoAbKU9uZTge81eL+xCI0GshLQZbjrQWSSyH/zarcbu8p1rU1YgZ5+CcehdDZ
         Yr6Ya46sxxEk0fl3F+Vja3jMeDSCvYPqpnZk9KZAjPQXsfEWYc54Z8PGJgl9FEtH1U/e
         Hv4w==
X-Gm-Message-State: AJIora+yao5JWWPX9/KvChCAxjPfa8pZYdL9ld+ywh4HvUGBpYDYzmsu
        UMG3VMmYjsp3iXb07+MlBr/768B78eI+0T62xC6Pj1GE/mnVzaudGNiKS8m7uWKxqIrsWc3EH34
        8WUoJI2O01l3LSa+VrPdftoRfHiBIb3E4Qm9TVw2trBljvquzqjjWfX2kBg==
X-Google-Smtp-Source: AGRyM1tV7Yq0WJ/pj2dbKQVAvb1sxi48Uimb+yF3RJXIeDq53I6R1rXun5mmgDrNVbT6RfjH4dGx1U7tU+Q=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:bd4e:b81d:4780:497d])
 (user=pgonda job=sendgmr) by 2002:a81:f82:0:b0:31c:f1ae:1ed6 with SMTP id
 124-20020a810f82000000b0031cf1ae1ed6mr17477996ywp.249.1657913412751; Fri, 15
 Jul 2022 12:30:12 -0700 (PDT)
Date:   Fri, 15 Jul 2022 12:29:49 -0700
In-Reply-To: <20220715192956.1873315-1-pgonda@google.com>
Message-Id: <20220715192956.1873315-5-pgonda@google.com>
Mime-Version: 1.0
References: <20220715192956.1873315-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [RFC V1 03/10] KVM: selftests: add hooks for managing encrypted guest memory
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        Peter Gonda <pgonda@google.com>
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

From: Michael Roth <michael.roth@amd.com>

VM implementations that make use of encrypted memory need a way to
configure things like the encryption/shared bit position for page
table handling, the default encryption policy for internal allocations
made by the core library, and a way to fetch the list/bitmap of
encrypted pages to do the actual memory encryption. Add an interface to
configure these parameters. Also introduce a sparsebit map to track
allocations/mappings that should be treated as encrypted, and provide
a way for VM implementations to retrieve it to handle operations
related memory encryption.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>

---
 .../selftests/kvm/include/kvm_util_base.h     | 17 ++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 52 +++++++++++++++++--
 2 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index b78e3c7a2566..3acb1552942b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -32,6 +32,7 @@ typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region region;
 	struct sparsebit *unused_phy_pages;
+	struct sparsebit *encrypted_phy_pages;
 	int fd;
 	off_t offset;
 	void *host_mem;
@@ -61,6 +62,14 @@ struct userspace_mem_regions {
 	DECLARE_HASHTABLE(slot_hash, 9);
 };
 
+/* Memory encryption policy/configuration. */
+struct vm_memcrypt {
+	bool enabled;
+	int8_t enc_by_default;
+	bool has_enc_bit;
+	int8_t enc_bit;
+};
+
 struct kvm_vm {
 	int mode;
 	unsigned long type;
@@ -84,6 +93,7 @@ struct kvm_vm {
 	vm_vaddr_t idt;
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
+	struct vm_memcrypt memcrypt;
 
 	/* Cache of information for binary stats interface */
 	int stats_fd;
@@ -820,4 +830,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
 	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
 }
 
+void vm_set_memory_encryption(struct kvm_vm *vm, bool enc_by_default, bool has_enc_bit,
+			      uint8_t enc_bit);
+
+const struct sparsebit *vm_get_encrypted_phy_pages(struct kvm_vm *vm, int slot,
+						   vm_paddr_t *gpa_start,
+						   uint64_t *size);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b07c372b9b37..6f96d1c51f75 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -529,6 +529,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
 
 	sparsebit_free(&region->unused_phy_pages);
+	sparsebit_free(&region->encrypted_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
 
@@ -869,6 +870,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	}
 
 	region->unused_phy_pages = sparsebit_alloc();
+	region->encrypted_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
 	region->region.slot = slot;
@@ -1084,6 +1086,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
  *   num - number of pages
  *   paddr_min - Physical address minimum
  *   memslot - Memory region to allocate page from
+ *   encrypt - Whether to treat the pages as encrypted
  *
  * Output Args: None
  *
@@ -1095,8 +1098,9 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot)
+static vm_paddr_t
+_vm_phy_pages_alloc(struct kvm_vm *vm, size_t num, vm_paddr_t paddr_min,
+		    uint32_t memslot, bool encrypt)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -1129,12 +1133,22 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		abort();
 	}
 
-	for (pg = base; pg < base + num; ++pg)
+	for (pg = base; pg < base + num; ++pg) {
 		sparsebit_clear(region->unused_phy_pages, pg);
+		if (encrypt)
+			sparsebit_set(region->encrypted_phy_pages, pg);
+	}
 
 	return base * vm->page_size;
 }
 
+vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			      vm_paddr_t paddr_min, uint32_t memslot)
+{
+	return _vm_phy_pages_alloc(vm, num, paddr_min, memslot,
+				   vm->memcrypt.enc_by_default);
+}
+
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot)
 {
@@ -1718,6 +1732,10 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 			region->host_mem);
 		fprintf(stream, "%*sunused_phy_pages: ", indent + 2, "");
 		sparsebit_dump(stream, region->unused_phy_pages, 0);
+		if (vm->memcrypt.enabled) {
+			fprintf(stream, "%*sencrypted_phy_pages: ", indent + 2, "");
+			sparsebit_dump(stream, region->encrypted_phy_pages, 0);
+		}
 	}
 	fprintf(stream, "%*sMapped Virtual Pages:\n", indent, "");
 	sparsebit_dump(stream, vm->vpages_mapped, indent + 2);
@@ -1966,3 +1984,31 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 		break;
 	}
 }
+
+void vm_set_memory_encryption(struct kvm_vm *vm, bool enc_by_default, bool has_enc_bit,
+			      uint8_t enc_bit)
+{
+	vm->memcrypt.enabled = true;
+	vm->memcrypt.enc_by_default = enc_by_default;
+	vm->memcrypt.has_enc_bit = has_enc_bit;
+	vm->memcrypt.enc_bit = enc_bit;
+}
+
+const struct sparsebit *
+vm_get_encrypted_phy_pages(struct kvm_vm *vm, int slot, vm_paddr_t *gpa_start,
+			   uint64_t *size)
+{
+	struct userspace_mem_region *region;
+
+	if (!vm->memcrypt.enabled)
+		return NULL;
+
+	region = memslot2region(vm, slot);
+	if (!region)
+		return NULL;
+
+	*size = region->region.memory_size;
+	*gpa_start = region->region.guest_phys_addr;
+
+	return region->encrypted_phy_pages;
+}
-- 
2.37.0.170.g444d1eabd0-goog

