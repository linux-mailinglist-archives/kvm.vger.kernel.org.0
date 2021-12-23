Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378EF47E97D
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350928AbhLWW0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350678AbhLWWZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:25:49 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DF1C061761
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:27 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id c6-20020aa781c6000000b004a4fcdf1d6dso4022373pfn.4
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SnbDD+EzeD9BP5nY71kpd1r6ATELuCUqfA5xKo++7G8=;
        b=qkJkWHJ3G2s/zKVhQ8uR/fZou/cYZTvXfkiCyMXWcchCHYF9pWHaMYTMFikBkYZMMM
         CafOg1sGqSPJ1Far8Uj6JGi5FQGZzvgg3xqQBMi2bdfIsPUNCufQ4S9Y2qLWKzbFm99y
         6zjdRHwBmIeIwkWM1xT5pJMVc4GCB9l2kb+GCq7NJh7oU1DFaczYHqZFD+amwIv3Ep1g
         BmpS9v20IOhTgB1sqo2JQaja+VHj1OzwulQhSfmkDoEWCQVQp4vuI4peYJT6DCA+bt75
         zLHzGMBoRITuUALu7/sK1HtgwaphUTokJFtglyvqu+pA1OSuaMtUIUUuuN/ucQtMmgTR
         7Ubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SnbDD+EzeD9BP5nY71kpd1r6ATELuCUqfA5xKo++7G8=;
        b=QB42F6Vp7oiqjswSLo27HcZj6a/Ak8mJ1prFjtwtYMTMJRZIozO5rDV+K1nMUeH1kY
         XzkYoKSNie3Me+nNUXhOo2xTh+/CH26tvOI5/WLmxmp2poz4tgO746Ap0oIKVF5s4aa7
         iCxoNuXX7WOhMMTCgY6NgIDZET0SHfR63vMO5gMeh3Rmu2dcDebxJTv/NkLsTUikPE8H
         02VmwBvh3h5Uk8Jv8x4PUDWQw9gyI1c5or8IyKy8/s6ytdB4HgYM9mHeKcx7QfpV2y83
         HX83JZAcIOi09JKDYHJUtVYXwGau18+a6mZMJ75MR3fA3XEqGKSzLp5fk3kQOLxcE045
         3Rrw==
X-Gm-Message-State: AOAM5324Ia0xwcgohz1+gsRpNYkAFZt49BkXoYrpZ5eabTfxevEhR9RT
        +ZvcAQg23SyNn1WUcelmAOzq31B8w8s=
X-Google-Smtp-Source: ABdhPJwOQj/KrL8mxnlbl5L3LG8nyLgGl8HKJ6JDrgETpddqBapjsGehx4x4j5sGHZaH4agS/k5rQTUQM/Y=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:8210:0:b0:4ba:f05c:8ae9 with SMTP id
 k16-20020aa78210000000b004baf05c8ae9mr4188612pfi.64.1640298267418; Thu, 23
 Dec 2021 14:24:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:16 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-29-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 28/30] KVM: selftests: Split out helper to allocate guest
 mem via memfd
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the code for allocating guest memory via memfd out of
vm_userspace_mem_region_add() and into a new helper, kvm_memfd_alloc().
A future selftest to populate a guest with the maximum amount of guest
memory will abuse KVM's memslots to alias guest memory regions to a
single memfd-backed host region, i.e. needs to back a guest with memfd
memory without a 1:1 association between a memslot and a memfd instance.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 42 +++++++++++--------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index fba971189390..ee4a7fafb442 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -104,6 +104,7 @@ int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
 		       size_t len);
 
 void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
+int kvm_memfd_alloc(size_t size, bool hugepages);
 
 void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 45f39dd9b4da..97514ece798f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -658,6 +658,27 @@ void kvm_vm_free(struct kvm_vm *vmp)
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
@@ -910,24 +931,9 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
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
2.34.1.448.ga2b2bfdf31-goog

