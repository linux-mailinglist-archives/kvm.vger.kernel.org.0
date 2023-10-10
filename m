Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEF27BF61C
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443027AbjJJIgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442929AbjJJIfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9EBB0;
        Tue, 10 Oct 2023 01:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696926939; x=1728462939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GQCMPF9yOreHoZSYiAwwtuGF3KN8BZQ7hfFsQ7RV6BI=;
  b=bXtY4xmIXZHQOZCQV0x2TwrkFm/HEB+plRFOae2y9eARWcxiVOO0SfaR
   y/cYrF9IniF9MAlZCC5JXVjdVLDTIXz5D1Eczc9RoO40AtJPmBKmSIA7w
   m0wyW6acZta3qV5+gCM0Ycg1K3AmqTezHn4effwEmr2JCEuuE+Rixqsel
   hLnyBUEXyo5OCGI0dHMHMVEpAw2D5uMHMRZWLKu9eNDEtzom++6R4oFDz
   zTAsUQxDp6mSnl5L+AFZRnREXpWKNGDJorcEmjh9JFEmSXxrnJSWbG+FD
   NRIQT4Nb+8hyhQh1CWpMlOHXoB+mZa94wR7JUUNajY1YA64EFv7N+KYNz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="363689842"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="363689842"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="1084687206"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="1084687206"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:35 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH 10/12] KVM: selftests: Allow mapping guest memory without host alias
Date:   Tue, 10 Oct 2023 01:35:18 -0700
Message-Id: <9e970731a61711acd38b1819ab5d2eaf326e0f0f.1696926843.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1696926843.git.isaku.yamahata@intel.com>
References: <cover.1696926843.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

For test the KVM hwpoison of memory, the recovery path unmaps the virtual
memory and send SIGBUS with its address.  If the poisoned page is mapped at
twice or more in the virtual memory, the address in SIGBUS siginfo isn't
deterministic.

To make the hwpoison test cases deterministic, allow to avoid guest memory
alias.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 23 ++++++++++++++-----
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a18db6a7b3cf..e980776a2c94 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -435,6 +435,10 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 			       uint64_t gpa, uint64_t size, void *hva);
 int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 				uint64_t gpa, uint64_t size, void *hva);
+void __vm_userspace_mem_region_add(struct kvm_vm *vm,
+	enum vm_mem_backing_src_type src_type,
+	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
+	uint32_t flags, bool alias);
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	enum vm_mem_backing_src_type src_type,
 	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7a8af1821f5d..310c3a760cb8 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -691,12 +691,14 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
-	if (region->fd >= 0) {
-		/* There's an extra map when using shared memory. */
+
+	/* There's an extra map when using shared memory. */
+	if (region->mmap_alias) {
 		ret = munmap(region->mmap_alias, region->mmap_size);
 		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
-		close(region->fd);
 	}
+	if (region->fd >= 0)
+		close(region->fd);
 
 	free(region);
 }
@@ -920,10 +922,10 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
  * given by slot, which must be unique and < KVM_MEM_SLOTS_NUM.  The
  * region is created with the flags given by flags.
  */
-void vm_userspace_mem_region_add(struct kvm_vm *vm,
+void __vm_userspace_mem_region_add(struct kvm_vm *vm,
 	enum vm_mem_backing_src_type src_type,
 	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
-	uint32_t flags)
+	uint32_t flags, bool create_alias)
 {
 	int ret;
 	struct userspace_mem_region *region;
@@ -1057,7 +1059,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	hash_add(vm->regions.slot_hash, &region->slot_node, slot);
 
 	/* If shared memory, create an alias. */
-	if (region->fd >= 0) {
+	if (region->fd >= 0 && create_alias) {
 		region->mmap_alias = mmap(NULL, region->mmap_size,
 					  PROT_READ | PROT_WRITE,
 					  vm_mem_backing_src_alias(src_type)->flag,
@@ -1070,6 +1072,15 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	}
 }
 
+void vm_userspace_mem_region_add(struct kvm_vm *vm,
+	enum vm_mem_backing_src_type src_type,
+	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
+	uint32_t flags)
+{
+	__vm_userspace_mem_region_add(vm, src_type, guest_paddr, slot, npages,
+				      flags, true);
+}
+
 /*
  * Memslot to region
  *
-- 
2.25.1

