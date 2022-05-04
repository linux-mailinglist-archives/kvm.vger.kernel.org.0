Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29EB051B265
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379286AbiEDWye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379287AbiEDWxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:49 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE46E53B49
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:02 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l4-20020a170903244400b0015ebe12a192so1361541pls.16
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=QG7d90BBcOCbRixG4Hyzinx/QW3w13YQQMCvmPKcdNM=;
        b=nMrn/47aE6PkAfWsf+AWKs2bCFW4YtZRPWI2kO7vjC9X/DbE36QWdUKztdib4CSgVq
         3omtaNyUg0dfS5prARfqMDqamGdWWCZso3AIXP/OoVid6NUKAyMmA1eV2riyS7yZkUr5
         CqVxyd/A+XdeMrsFl6xrL5k57bbH/TxQoRwTfOL1QnoJQQ2AXoteKqsl/I8dkMxhuYZz
         lrJJyg3axX65n1UyA1M7GxZQcxBZUkejVDGY8ikYGVOIApQUmLBPNLRq90zG+cxp7wli
         9NFdhk3p6rGdtzeFRWxstqkM1GRApTV3BbN3KrXp+s98BkRoI/uZabZz2u5oHqGZRUXd
         Ne1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=QG7d90BBcOCbRixG4Hyzinx/QW3w13YQQMCvmPKcdNM=;
        b=nf6HQXpYzx2wLTNzECsGels8B0omYtzhxzL7JZYWcZl35LCGClkLu9W/G0l2qBTZjv
         KLWZt10dNH8EZmwlZ1xtpiLVFyMYJb7Wrzkq3C5OaQpyEJnGqYsxoyFHzPcbGIU9T0Jj
         1w19L89fS2wImxQhxkqq8TugaeY9LKhq37jElgAyuaScSHbS4y1ryVN039bb3Fr6/gQY
         2d1/6mZpnV2FNnYASut+zmIPXSb+HDaLTcCDZkhmgqavRgbhqq8SFdl9ynkWaxIawksa
         SCpFkexfBgypdB/pum9Pv0yvx3JgJRwTDnPDYdqEEggE51907qlCcODRHNOCUEVJMPew
         4YbA==
X-Gm-Message-State: AOAM5302toBWJICJxo4lGNaEkMNWpRAEcPrGBQts38L3Pf+xdmxHkl4d
        fWEgufAeTL4XWXLHpyRuK9ucys3A3M8=
X-Google-Smtp-Source: ABdhPJzbIZGFr6r4Au99FBrIyvNU/qURhcm3v0Z2XJZ+/3h5p1Zoefh4AUCJO2HPtxPL+Fx22OapwmrLaIs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:244b:b0:15e:8844:1578 with SMTP id
 l11-20020a170903244b00b0015e88441578mr23589128pls.13.1651704602558; Wed, 04
 May 2022 15:50:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:24 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-19-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 018/128] KVM: selftests: Use __KVM_SYSCALL_ERROR() to handle
 non-KVM syscall errors
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Use __KVM_SYSCALL_ERROR() to report and pretty print non-KVM syscall and
ioctl errors, e.g. for mmap(), munmap(), uffd ioctls, etc...

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  5 ++-
 .../selftests/kvm/demand_paging_test.c        | 12 +++----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 34 ++++++++-----------
 3 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 554ca649d470..87e41895b385 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -630,8 +630,7 @@ static void kvm_routing_and_irqfd_check(struct kvm_vm *vm,
 
 	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
 		fd[f] = eventfd(0, 0);
-		TEST_ASSERT(fd[f] != -1,
-			"eventfd failed, errno: %i\n", errno);
+		TEST_ASSERT(fd[f] != -1, __KVM_SYSCALL_ERROR("eventfd()", fd[f]));
 	}
 
 	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
@@ -647,7 +646,7 @@ static void kvm_routing_and_irqfd_check(struct kvm_vm *vm,
 		val = 1;
 		ret = write(fd[f], &val, sizeof(uint64_t));
 		TEST_ASSERT(ret == sizeof(uint64_t),
-			"Write to KVM_IRQFD failed with ret: %d\n", ret);
+			    __KVM_SYSCALL_ERROR("write()", ret));
 	}
 
 	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++)
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 6a719d065599..d8db0a37e973 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -223,6 +223,7 @@ static void setup_demand_paging(struct kvm_vm *vm,
 	struct uffdio_api uffdio_api;
 	struct uffdio_register uffdio_register;
 	uint64_t expected_ioctls = ((uint64_t) 1) << _UFFDIO_COPY;
+	int ret;
 
 	PER_PAGE_DEBUG("Userfaultfd %s mode, faults resolved with %s\n",
 		       is_minor ? "MINOR" : "MISSING",
@@ -242,19 +243,18 @@ static void setup_demand_paging(struct kvm_vm *vm,
 	}
 
 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
-	TEST_ASSERT(uffd >= 0, "uffd creation failed, errno: %d", errno);
+	TEST_ASSERT(uffd >= 0, __KVM_SYSCALL_ERROR("userfaultfd()", uffd));
 
 	uffdio_api.api = UFFD_API;
 	uffdio_api.features = 0;
-	TEST_ASSERT(ioctl(uffd, UFFDIO_API, &uffdio_api) != -1,
-		    "ioctl UFFDIO_API failed: %" PRIu64,
-		    (uint64_t)uffdio_api.api);
+	ret = ioctl(uffd, UFFDIO_API, &uffdio_api);
+	TEST_ASSERT(ret != -1, __KVM_SYSCALL_ERROR("UFFDIO_API", ret));
 
 	uffdio_register.range.start = (uint64_t)hva;
 	uffdio_register.range.len = len;
 	uffdio_register.mode = uffd_mode;
-	TEST_ASSERT(ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) != -1,
-		    "ioctl UFFDIO_REGISTER failed");
+	ret = ioctl(uffd, UFFDIO_REGISTER, &uffdio_register);
+	TEST_ASSERT(ret != -1, __KVM_SYSCALL_ERROR("UFFDIO_REGISTER", ret));
 	TEST_ASSERT((uffdio_register.ioctls & expected_ioctls) ==
 		    expected_ioctls, "missing userfaultfd ioctls");
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4d2748e8428a..c7df8ba04ec5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -517,17 +517,15 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
 
 	if (vcpu->dirty_gfns) {
 		ret = munmap(vcpu->dirty_gfns, vm->dirty_ring_size);
-		TEST_ASSERT(ret == 0, "munmap of VCPU dirty ring failed, "
-			    "rc: %i errno: %i", ret, errno);
+		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
 		vcpu->dirty_gfns = NULL;
 	}
 
 	ret = munmap(vcpu->state, vcpu_mmap_sz());
-	TEST_ASSERT(ret == 0, "munmap of VCPU fd failed, rc: %i "
-		"errno: %i", ret, errno);
+	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+
 	ret = close(vcpu->fd);
-	TEST_ASSERT(ret == 0, "Close of VCPU fd failed, rc: %i "
-		"errno: %i", ret, errno);
+	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
 
 	list_del(&vcpu->list);
 	free(vcpu);
@@ -542,12 +540,10 @@ void kvm_vm_release(struct kvm_vm *vmp)
 		vm_vcpu_rm(vmp, vcpu);
 
 	ret = close(vmp->fd);
-	TEST_ASSERT(ret == 0, "Close of vm fd failed,\n"
-		"  vmp->fd: %i rc: %i errno: %i", vmp->fd, ret, errno);
+	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
 
 	ret = close(vmp->kvm_fd);
-	TEST_ASSERT(ret == 0, "Close of /dev/kvm fd failed,\n"
-		"  vmp->kvm_fd: %i rc: %i errno: %i", vmp->kvm_fd, ret, errno);
+	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
 }
 
 static void __vm_mem_region_delete(struct kvm_vm *vm,
@@ -567,7 +563,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
-	TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
 
 	free(region);
 }
@@ -607,14 +603,13 @@ int kvm_memfd_alloc(size_t size, bool hugepages)
 		memfd_flags |= MFD_HUGETLB;
 
 	fd = memfd_create("kvm_selftest", memfd_flags);
-	TEST_ASSERT(fd != -1, "memfd_create() failed, errno: %i (%s)",
-		    errno, strerror(errno));
+	TEST_ASSERT(fd != -1, __KVM_SYSCALL_ERROR("memfd_create()", fd));
 
 	r = ftruncate(fd, size);
-	TEST_ASSERT(!r, "ftruncate() failed, errno: %i (%s)", errno, strerror(errno));
+	TEST_ASSERT(!r, __KVM_SYSCALL_ERROR("ftruncate()", r));
 
 	r = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, size);
-	TEST_ASSERT(!r, "fallocate() failed, errno: %i (%s)", errno, strerror(errno));
+	TEST_ASSERT(!r, __KVM_SYSCALL_ERROR("fallocate()", r));
 
 	return fd;
 }
@@ -880,8 +875,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				  vm_mem_backing_src_alias(src_type)->flag,
 				  region->fd, 0);
 	TEST_ASSERT(region->mmap_start != MAP_FAILED,
-		    "test_malloc failed, mmap_start: %p errno: %i",
-		    region->mmap_start, errno);
+		    __KVM_SYSCALL_ERROR("mmap()", (int)(unsigned long)MAP_FAILED));
 
 	TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
 		    region->mmap_start == align_ptr_up(region->mmap_start, backing_src_pagesz),
@@ -929,7 +923,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 					  vm_mem_backing_src_alias(src_type)->flag,
 					  region->fd, 0);
 		TEST_ASSERT(region->mmap_alias != MAP_FAILED,
-			    "mmap of alias failed, errno: %i", errno);
+			    __KVM_SYSCALL_ERROR("mmap()",  (int)(unsigned long)MAP_FAILED));
 
 		/* Align host alias address */
 		region->host_alias = align_ptr_up(region->mmap_alias, alignment);
@@ -1115,8 +1109,8 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 		vcpu_mmap_sz(), sizeof(*vcpu->state));
 	vcpu->state = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
 		PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd, 0);
-	TEST_ASSERT(vcpu->state != MAP_FAILED, "mmap vcpu_state failed, "
-		"vcpu id: %u errno: %i", vcpuid, errno);
+	TEST_ASSERT(vcpu->state != MAP_FAILED,
+		    __KVM_SYSCALL_ERROR("mmap()", (int)(unsigned long)MAP_FAILED));
 
 	/* Add to linked-list of VCPUs. */
 	list_add(&vcpu->list, &vm->vcpus);
-- 
2.36.0.464.gb9c8b46e94-goog

