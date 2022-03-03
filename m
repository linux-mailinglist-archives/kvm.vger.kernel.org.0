Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19B14CC654
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbiCCTl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbiCCTkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:40:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCDF11A617D
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3S94nz0psd43uT5tjnVxrAMKMmNoTXAksjmb0Kl0LAY=;
        b=dZKl/rOcUDFJ6Y81TTXlB3mS60uzxWVEOdQst6HqHPoOBtb7aTp0WGcM8mbRO+YQF2hfWp
        GVQT1mJ1AMJd/6sy4aYl25QRA7ud3iFgpYrASVk5njzDXIk1LUZkk1EDN/7Y81HjhcZdyj
        iPZJDuIiKHu29lCCYVVYIazoe7tRSmM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-n1So81VfNoSEmDRHW6Em-w-1; Thu, 03 Mar 2022 14:39:21 -0500
X-MC-Unique: n1So81VfNoSEmDRHW6Em-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77DC11883526;
        Thu,  3 Mar 2022 19:39:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87D5B5C64D;
        Thu,  3 Mar 2022 19:39:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 28/30] KVM: selftests: Split out helper to allocate guest mem via memfd
Date:   Thu,  3 Mar 2022 14:38:40 -0500
Message-Id: <20220303193842.370645-29-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Extract the code for allocating guest memory via memfd out of
vm_userspace_mem_region_add() and into a new helper, kvm_memfd_alloc().
A future selftest to populate a guest with the maximum amount of guest
memory will abuse KVM's memslots to alias guest memory regions to a
single memfd-backed host region, i.e. needs to back a guest with memfd
memory without a 1:1 association between a memslot and a memfd instance.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220226001546.360188-27-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 42 +++++++++++--------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 573de0354175..92cef0ffb19e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -123,6 +123,7 @@ int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
 		       size_t len);
 
 void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
+int kvm_memfd_alloc(size_t size, bool hugepages);
 
 void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index dcb8e96c6a54..1665a220abcb 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -718,6 +718,27 @@ void kvm_vm_free(struct kvm_vm *vmp)
 	free(vmp);
 }
 
+int kvm_memfd_alloc(size_t size, bool hugepages)
+{
+	int memfd_flags = MFD_CLOEXEC;
+	int fd, r;
+
+	if (hugepages)
+		memfd_flags |= MFD_HUGETLB;
+
+	fd = memfd_create("kvm_selftest", memfd_flags);
+	TEST_ASSERT(fd != -1, "memfd_create() failed, errno: %i (%s)",
+		    errno, strerror(errno));
+
+	r = ftruncate(fd, size);
+	TEST_ASSERT(!r, "ftruncate() failed, errno: %i (%s)", errno, strerror(errno));
+
+	r = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, size);
+	TEST_ASSERT(!r, "fallocate() failed, errno: %i (%s)", errno, strerror(errno));
+
+	return fd;
+}
+
 /*
  * Memory Compare, host virtual to guest virtual
  *
@@ -970,24 +991,9 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 		region->mmap_size += alignment;
 
 	region->fd = -1;
-	if (backing_src_is_shared(src_type)) {
-		int memfd_flags = MFD_CLOEXEC;
-
-		if (src_type == VM_MEM_SRC_SHARED_HUGETLB)
-			memfd_flags |= MFD_HUGETLB;
-
-		region->fd = memfd_create("kvm_selftest", memfd_flags);
-		TEST_ASSERT(region->fd != -1,
-			    "memfd_create failed, errno: %i", errno);
-
-		ret = ftruncate(region->fd, region->mmap_size);
-		TEST_ASSERT(ret == 0, "ftruncate failed, errno: %i", errno);
-
-		ret = fallocate(region->fd,
-				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0,
-				region->mmap_size);
-		TEST_ASSERT(ret == 0, "fallocate failed, errno: %i", errno);
-	}
+	if (backing_src_is_shared(src_type))
+		region->fd = kvm_memfd_alloc(region->mmap_size,
+					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
 
 	region->mmap_start = mmap(NULL, region->mmap_size,
 				  PROT_READ | PROT_WRITE,
-- 
2.31.1


