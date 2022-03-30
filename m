Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC964ECAF5
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 19:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349115AbiC3Rsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 13:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349600AbiC3RsU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 13:48:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4586136
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 10:46:34 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2e9eb7d669fso106443587b3.14
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 10:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GZrknO5c1vShjCMu+HvsPnQd3jdw10n6YZ6wxsTHM84=;
        b=BFfs2RlUHwH0BGt/rlKyUOOUArQhYGmgCeqXzizbcONMclOk1S7wJ6KLKfc+zxzQEZ
         /sGGV5CaOh2i361PG7lVFBedEakdY0R9p2OWhgWSYBqkT0wKluEqgFd6+YZxClE/SZ6S
         OW0kwrNgrmPm5meceO+kWloW2OfACIXv1dGbyO+gOy3URggpd8brKGVDTzDJFBa/8eBX
         5qYWFo+URSGuwglYwfFUPHBZ4q0vZtwrQARxmBsYT2xFISOv17suFVUtywY/yQ8lE6bo
         oyLoZzfEnk4ibHMx75lvAXpbfyU8hG6cDjMPtd6DY6Wf0bBsQY+ikAaJdItv7DjzWN+p
         yG8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GZrknO5c1vShjCMu+HvsPnQd3jdw10n6YZ6wxsTHM84=;
        b=0c73IZ23tCzsCKrChKfn15pjc8fRiuqx++/e7IYoLmxXWOt5dwp9Upw5sydpHOEmvy
         wUitijSM7ngPUvaPErJDbKqCWMUeZ8HT1+FlCsKqTrqjuTzDZyVJZImnYImm0g8roWTO
         UgsVl+p4JMh+2prKw3HQ+FXD0OkDtXe1Sln4Y7iJ3/uMwaewu4s8oltIDXd3sLBDwsaP
         5tV29KAEEXHq1o1cJAIVy8nzBk522tqck62/zRcxKJhey3qA7THJlDbFzBmr7qv7xZLw
         h6WKCS5PK+LB8UjzDgJ2V4DWUbwk08IP1jetNqje0v1Sx9/5eOfLDsZoDISgxODVi+sv
         RGwQ==
X-Gm-Message-State: AOAM5309LyKPRWH6xDv07X4BNU5N5/qlOUVlsOV37DHju3D71IU983wg
        9GEB+nXuGHV24k0kLeVAYAxeUgL1+Wej
X-Google-Smtp-Source: ABdhPJwdRnwrzh+/zJIDGQ8L6vTpBTpVc3Ey6oAQ38MtESgYK2Cz1DTmxecgrZzAkBo1MjhF/uCg2ZULD9an
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:7c53:ec2f:bd26:b69c])
 (user=bgardon job=sendgmr) by 2002:a25:cb8f:0:b0:633:90ac:a90e with SMTP id
 b137-20020a25cb8f000000b0063390aca90emr710239ybg.461.1648662393914; Wed, 30
 Mar 2022 10:46:33 -0700 (PDT)
Date:   Wed, 30 Mar 2022 10:46:14 -0700
In-Reply-To: <20220330174621.1567317-1-bgardon@google.com>
Message-Id: <20220330174621.1567317-5-bgardon@google.com>
Mime-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v3 04/11] KVM: selftests: Add memslot parameter to elf_load
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Currently elf_load loads code into memslot 0. Add a parameter to allow
loading code into any memslot. This will be useful for backing code
pages with huge pages in future commits.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../testing/selftests/kvm/include/kvm_util_base.h  |  5 +++++
 tools/testing/selftests/kvm/lib/elf.c              | 13 +++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c         | 14 ++++++++++----
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 78c4407f36b4..72163ba2f878 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -122,7 +122,10 @@ uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm);
 int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
 		       size_t len);
 
+void kvm_vm_elf_load_memslot(struct kvm_vm *vm, const char *filename,
+			     uint32_t memslot);
 void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
+
 int kvm_memfd_alloc(size_t size, bool hugepages);
 
 void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
@@ -169,6 +172,8 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
+vm_vaddr_t vm_vaddr_alloc_memslot(struct kvm_vm *vm, size_t sz,
+				  vm_vaddr_t vaddr_min, uint32_t memslot);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 13e8e3dcf984..899418e65f60 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -97,6 +97,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
  *
  * Input Args:
  *   filename - Path to ELF file
+ *   memslot - the memslot into which the elf should be loaded
  *
  * Output Args: None
  *
@@ -111,7 +112,8 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
  * by the image and it needs to have sufficient available physical pages, to
  * back the virtual pages used to load the image.
  */
-void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
+void kvm_vm_elf_load_memslot(struct kvm_vm *vm, const char *filename,
+			     uint32_t memslot)
 {
 	off_t offset, offset_rv;
 	Elf64_Ehdr hdr;
@@ -162,7 +164,9 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 		seg_vend |= vm->page_size - 1;
 		size_t seg_size = seg_vend - seg_vstart + 1;
 
-		vm_vaddr_t vaddr = vm_vaddr_alloc(vm, seg_size, seg_vstart);
+		vm_vaddr_t vaddr = vm_vaddr_alloc_memslot(vm, seg_size,
+							  seg_vstart,
+							  memslot);
 		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
 			"virtual memory for segment at requested min addr,\n"
 			"  segment idx: %u\n"
@@ -191,3 +195,8 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 		}
 	}
 }
+
+void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
+{
+	kvm_vm_elf_load_memslot(vm, filename, 0);
+}
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9c4574381daa..09742a787546 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1336,8 +1336,7 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
  *   vm - Virtual Machine
  *   sz - Size in bytes
  *   vaddr_min - Minimum starting virtual address
- *   data_memslot - Memory region slot for data pages
- *   pgd_memslot - Memory region slot for new virtual translation tables
+ *   memslot - Memory region slot for data pages
  *
  * Output Args: None
  *
@@ -1350,13 +1349,15 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
  * a unique set of pages, with the minimum real allocation being at least
  * a page.
  */
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+vm_vaddr_t vm_vaddr_alloc_memslot(struct kvm_vm *vm, size_t sz,
+				  vm_vaddr_t vaddr_min, uint32_t memslot)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
 	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
-					      KVM_UTIL_MIN_PFN * vm->page_size, 0);
+					      KVM_UTIL_MIN_PFN * vm->page_size,
+					      memslot);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1377,6 +1378,11 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
 	return vaddr_start;
 }
 
+vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+{
+	return vm_vaddr_alloc_memslot(vm, sz, vaddr_min, 0);
+}
+
 /*
  * VM Virtual Address Allocate Pages
  *
-- 
2.35.1.1021.g381101b075-goog

