Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E6758EF45
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 17:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbiHJPUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 11:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiHJPUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 11:20:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2594227149
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j11-20020a05690212cb00b006454988d225so12472423ybu.10
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=gpjaSxcl3Da89SJa9UoDRS3ZGGXqWVjkkBkYPyI+780=;
        b=XJoI09594WaiQ53jiHyTNQfPp9yp8DnWtffWrcDrOQnqNS/FpuLusgXXnuuqHUMzfi
         R82gi5Z6cHm9AlElWeE3cDiol/0mo2jTSghCKfxRsPtvaW+GygWsquUM6k1QrsfQ89R8
         lgN4lDGpGdDdZjlbc7Dxi25fNoEHOBF5Xmo2HUalXctwpric/ajLprnX3slghqWcHSOD
         xgt3Hthe5iY8VySqFRnaH511Usno2FbB730cytQELyjUUN7Ja5orcooBFeehIfJrJigm
         TpfzjPR0/1vUPuXKV+hGts9g/ZynWz7mpl/lx/CImvWN/MifeRzBnUBBSA5J5bNEB7+y
         mR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=gpjaSxcl3Da89SJa9UoDRS3ZGGXqWVjkkBkYPyI+780=;
        b=a8yAS846iLN239cJmks0A9lf6um4OP3ypZTFuxzqOUCXol5XBVi+/oMjfS5mfB/Ueq
         9Rb2UzOrhE5RAQr6FrzUs0Vd4oipOvG3Owyv95JphJF8TLkDOLTbbogqmSHHRkFGM7J7
         Cz/7aSLuV1pmT9x4BI7Kt5gP/L6kQHSUqkRj0ThaN/ujYsaZ9+ir4QZYVCpj0Fa7sf59
         oKqPb67jAY3RxQR138MtcTbxM9qhbTKo0Ahxb3CiU+TKrluzUJ/A59lceE9AfBOWBc+C
         D2t70kq7ln2sQfNDlc1p2QBvQDbIDIeiMz4/HMaOZILh7jhaTYcm03XgCsUhcGO+NIIB
         NukA==
X-Gm-Message-State: ACgBeo0vWQySVrIYX7Oy7qsRwkSL45lLyFn+crS4CAZQbl2mLVaNujUj
        AXw/QQfH3uFUaijwEWKzToUOMxwKtC0YWVuzjCXSBQ88HwVVk/JmTcZdSxf/DO+0MIjy0dfojiw
        dKHC2nv7ASYZaiHgja8HMT1z8PVovdLi1JLiYzT/BPwvEv+LlocOhb72R+g==
X-Google-Smtp-Source: AA6agR5fUTj03bLY58ZNaat8U+xhcpjGEo7XLVmz9Eo7sO6V0+JjCLuRNpxPlGVvP6TPvR7+8HIRCrnX8mk=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:b185:1827:5b23:bbe2])
 (user=pgonda job=sendgmr) by 2002:a5b:745:0:b0:670:8cf9:3a92 with SMTP id
 s5-20020a5b0745000000b006708cf93a92mr23346562ybq.503.1660144842375; Wed, 10
 Aug 2022 08:20:42 -0700 (PDT)
Date:   Wed, 10 Aug 2022 08:20:25 -0700
In-Reply-To: <20220810152033.946942-1-pgonda@google.com>
Message-Id: <20220810152033.946942-4-pgonda@google.com>
Mime-Version: 1.0
References: <20220810152033.946942-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [V3 03/11] KVM: selftests: add hooks for managing encrypted guest memory
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
index 24fde97f6121..3928351e497e 100644
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
@@ -64,6 +65,14 @@ struct userspace_mem_regions {
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
@@ -87,6 +96,7 @@ struct kvm_vm {
 	vm_vaddr_t idt;
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
+	struct vm_memcrypt memcrypt;
 
 	/* Cache of information for binary stats interface */
 	int stats_fd;
@@ -834,4 +844,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
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
index cb3a5f8a53b7..c6b87b411186 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -542,6 +542,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
 
 	sparsebit_free(&region->unused_phy_pages);
+	sparsebit_free(&region->encrypted_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
 
@@ -882,6 +883,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	}
 
 	region->unused_phy_pages = sparsebit_alloc();
+	region->encrypted_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
 	region->region.slot = slot;
@@ -1097,6 +1099,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
  *   num - number of pages
  *   paddr_min - Physical address minimum
  *   memslot - Memory region to allocate page from
+ *   encrypt - Whether to treat the pages as encrypted
  *
  * Output Args: None
  *
@@ -1108,8 +1111,9 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
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
@@ -1141,12 +1145,22 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
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
@@ -1730,6 +1744,10 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
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
@@ -1978,3 +1996,31 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
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
2.37.1.559.g78731f0fdb-goog

