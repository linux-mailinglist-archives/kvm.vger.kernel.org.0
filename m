Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4450E51B2D9
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379612AbiEDW4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379197AbiEDWxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:38 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C84D53E39
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:49:58 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h128-20020a636c86000000b003c574b3422aso1338833pgc.12
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=aJAg5113oAm3HRX0IgJjabbpguSIh0dT8Z8AWcNkJR8=;
        b=Ws3bgr+Hx7pKax9gR/rzMKsewPUs7LvnfucByqQbR6esrYeicOxPZBKQndmdhD2DJf
         aVe63HCNxxVrNY00NcPwTbGZNZiiIpGHh7ZnPSpYIloGltcwuhgZlVSRXpcYnPrAHUED
         tS8eQuOcoobm+cTtCK3Qyg5MPar6o4Da+u2EHqxGMxeY4JUNdha6yRY+k8NfRKxW7aMf
         P8ZowHNzorBBG4Yp2EjqPnX85miXXsjneX1QoJegE6BYthodvY6SkGdzR/423siyO52x
         Z8GUypnxg688nK86AjNfaVNJYXTzcBlAr3/FeABqSJGo4KjCCO7QnHJJhbU8rlMyISOT
         69Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=aJAg5113oAm3HRX0IgJjabbpguSIh0dT8Z8AWcNkJR8=;
        b=LhuoIi6HlYb3AkjQtdhmzAE2omRCLb3tbhff9ODC3WfaBsBOnsPtk97ccgJTQPjMp5
         8FnoL8jD9uV6QRa0mZV/qoX1fZKj1RZVdGfsgX5zXxZvXAAU3WGV+HwoWnwpxMUTKVrK
         wpEaidMzDX6RdEWcTrpJH3skPZ46n3y3ujuSjMJywLOfm7AOr8Oj12KG75AJmvLfM9Yp
         M1uh84lfhJH3NpHvQuMitkILJiQSHlGT+YKvGG08TEGlZ1NrJKZOj9EPC9EA8OiOd8la
         MCVWDgSr7H9X8MjBqcWGrPcDagrDASKCHt7av5MNwShgIyNFGT21megajRv0NTP91url
         01+A==
X-Gm-Message-State: AOAM532z81UzdrcWYYhTKUfiZbB9LuUp1UA/ht78PD+I3eiWtCrdckp8
        Ps+9JQwCGvVWhtoUVIXSZdnAveudtCY=
X-Google-Smtp-Source: ABdhPJxeYsv3l6+vvejW5d66wFMiOK3jUWKINMy5RpLeMDnbaWa7fBZtGu2pS2+SHM1um6W/VPtnRBHjXMM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1781:b0:50a:94f0:661d with SMTP id
 s1-20020a056a00178100b0050a94f0661dmr23109380pfg.10.1651704597967; Wed, 04
 May 2022 15:49:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:21 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-16-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 015/128] KVM: sefltests: Use vm_ioctl() and __vm_ioctl() helpers
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

Use the recently introduced VM-specific ioctl() helpers instead of open
coding calls to ioctl() just to pretty print the ioctl name.  Keep a few
open coded assertions that provide additional info.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  60 +++++++--
 .../selftests/kvm/kvm_binary_stats_test.c     |   6 +-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |   6 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 116 ++----------------
 .../selftests/kvm/set_memory_region_test.c    |   3 +-
 .../kvm/x86_64/pmu_event_filter_test.c        |   2 +-
 6 files changed, 67 insertions(+), 126 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 39e1971e5d65..1ccb91103e74 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -103,8 +103,6 @@ extern const struct vm_guest_mode_params vm_guest_mode_params[];
 int open_path_or_exit(const char *path, int flags);
 int open_kvm_dev_path_or_exit(void);
 int kvm_check_cap(long cap);
-int vm_check_cap(struct kvm_vm *vm, long cap);
-int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
 
 #define __KVM_SYSCALL_ERROR(_name, _ret) \
 	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
@@ -126,6 +124,23 @@ void _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long cmd,
 #define vcpu_ioctl(vm, vcpuid, cmd, arg) \
 	_vcpu_ioctl(vm, vcpuid, cmd, #cmd, arg)
 
+/*
+ * Looks up and returns the value corresponding to the capability
+ * (KVM_CAP_*) given by cap.
+ */
+static inline int vm_check_cap(struct kvm_vm *vm, long cap)
+{
+	int ret =  __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)cap);
+
+	TEST_ASSERT(ret >= 0, KVM_IOCTL_ERROR(KVM_CHECK_EXTENSION, ret));
+	return ret;
+}
+
+static inline void vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
+{
+	vm_ioctl(vm, KVM_ENABLE_CAP, cap);
+}
+
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 const char *vm_guest_mode_string(uint32_t i);
 
@@ -134,19 +149,46 @@ struct kvm_vm *vm_create(uint64_t phy_pages);
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp);
 void kvm_vm_release(struct kvm_vm *vmp);
-void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log);
-void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
-			    uint64_t first_page, uint32_t num_pages);
-uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm);
-
 int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
 		       size_t len);
-
 void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
 int kvm_memfd_alloc(size_t size, bool hugepages);
 
 void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
 
+static inline void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
+{
+	struct kvm_dirty_log args = { .dirty_bitmap = log, .slot = slot };
+
+	vm_ioctl(vm, KVM_GET_DIRTY_LOG, &args);
+}
+
+static inline void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
+					  uint64_t first_page, uint32_t num_pages)
+{
+	struct kvm_clear_dirty_log args = {
+		.dirty_bitmap = log,
+		.slot = slot,
+		.first_page = first_page,
+		.num_pages = num_pages
+	};
+
+	vm_ioctl(vm, KVM_CLEAR_DIRTY_LOG, &args);
+}
+
+static inline uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm)
+{
+	return __vm_ioctl(vm, KVM_RESET_DIRTY_RINGS, NULL);
+}
+
+static inline int vm_get_stats_fd(struct kvm_vm *vm)
+{
+	int fd = __vm_ioctl(vm, KVM_GET_STATS_FD, NULL);
+
+	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_GET_STATS_FD, fd));
+	return fd;
+}
+
 /*
  * VM VCPU Dump
  *
@@ -483,8 +525,6 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 
 void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 
-int vm_get_stats_fd(struct kvm_vm *vm);
-
 uint32_t guest_get_vcpuid(void);
 
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index bab8b49b52da..0a27b0f85009 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -165,11 +165,7 @@ static void stats_test(int stats_fd)
 
 static void vm_stats_test(struct kvm_vm *vm)
 {
-	int stats_fd;
-
-	/* Get fd for VM stats */
-	stats_fd = vm_get_stats_fd(vm);
-	TEST_ASSERT(stats_fd >= 0, "Get VM stats fd");
+	int stats_fd = vm_get_stats_fd(vm);
 
 	stats_test(stats_fd);
 	close(stats_fd);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 5d45046c1b80..25d1ec65621d 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -104,8 +104,7 @@ void kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level)
 {
 	int ret = _kvm_irq_set_level_info(gic_fd, intid, level);
 
-	TEST_ASSERT(ret == 0, "KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO failed, "
-			"rc: %i errno: %i", ret, errno);
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO, ret));
 }
 
 int _kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level)
@@ -127,8 +126,7 @@ void kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level)
 {
 	int ret = _kvm_arm_irq_line(vm, intid, level);
 
-	TEST_ASSERT(ret == 0, "KVM_IRQ_LINE failed, rc: %i errno: %i",
-			ret, errno);
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_IRQ_LINE, ret));
 }
 
 static void vgic_poke_irq(int gic_fd, uint32_t intid,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7eedd9ff20fa..339d524a0399 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -85,56 +85,6 @@ int kvm_check_cap(long cap)
 	return ret;
 }
 
-/* VM Check Capability
- *
- * Input Args:
- *   vm - Virtual Machine
- *   cap - Capability
- *
- * Output Args: None
- *
- * Return:
- *   On success, the Value corresponding to the capability (KVM_CAP_*)
- *   specified by the value of cap.  On failure a TEST_ASSERT failure
- *   is produced.
- *
- * Looks up and returns the value corresponding to the capability
- * (KVM_CAP_*) given by cap.
- */
-int vm_check_cap(struct kvm_vm *vm, long cap)
-{
-	int ret;
-
-	ret = ioctl(vm->fd, KVM_CHECK_EXTENSION, cap);
-	TEST_ASSERT(ret >= 0, "KVM_CHECK_EXTENSION VM IOCTL failed,\n"
-		"  rc: %i errno: %i", ret, errno);
-
-	return ret;
-}
-
-/* VM Enable Capability
- *
- * Input Args:
- *   vm - Virtual Machine
- *   cap - Capability
- *
- * Output Args: None
- *
- * Return: On success, 0. On failure a TEST_ASSERT failure is produced.
- *
- * Enables a capability (KVM_CAP_*) on the VM.
- */
-int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
-{
-	int ret;
-
-	ret = ioctl(vm->fd, KVM_ENABLE_CAP, cap);
-	TEST_ASSERT(ret == 0, "KVM_ENABLE_CAP IOCTL failed,\n"
-		"  rc: %i errno: %i", ret, errno);
-
-	return ret;
-}
-
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 {
 	struct kvm_enable_cap cap = { 0 };
@@ -460,36 +410,6 @@ void kvm_vm_restart(struct kvm_vm *vmp)
 	}
 }
 
-void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
-{
-	struct kvm_dirty_log args = { .dirty_bitmap = log, .slot = slot };
-	int ret;
-
-	ret = ioctl(vm->fd, KVM_GET_DIRTY_LOG, &args);
-	TEST_ASSERT(ret == 0, "%s: KVM_GET_DIRTY_LOG failed: %s",
-		    __func__, strerror(-ret));
-}
-
-void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
-			    uint64_t first_page, uint32_t num_pages)
-{
-	struct kvm_clear_dirty_log args = {
-		.dirty_bitmap = log, .slot = slot,
-		.first_page = first_page,
-		.num_pages = num_pages
-	};
-	int ret;
-
-	ret = ioctl(vm->fd, KVM_CLEAR_DIRTY_LOG, &args);
-	TEST_ASSERT(ret == 0, "%s: KVM_CLEAR_DIRTY_LOG failed: %s",
-		    __func__, strerror(-ret));
-}
-
-uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm)
-{
-	return ioctl(vm->fd, KVM_RESET_DIRTY_RINGS);
-}
-
 /*
  * Userspace Memory Region Find
  *
@@ -645,9 +565,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	}
 
 	region->region.memory_size = 0;
-	ret = ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
-	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed, "
-		    "rc: %i errno: %i", ret, errno);
+	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
 
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
@@ -993,7 +911,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	region->region.guest_phys_addr = guest_paddr;
 	region->region.memory_size = npages * vm->page_size;
 	region->region.userspace_addr = (uintptr_t) region->host_mem;
-	ret = ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
+	ret = __vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
 	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
 		"  rc: %i errno: %i\n"
 		"  slot: %u flags: 0x%x\n"
@@ -1076,7 +994,7 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
 
 	region->region.flags = flags;
 
-	ret = ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
+	ret = __vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
 
 	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
 		"  rc: %i errno: %i slot: %u flags: 0x%x",
@@ -1106,7 +1024,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
 
 	region->region.guest_phys_addr = new_gpa;
 
-	ret = ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
+	ret = __vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
 
 	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION failed\n"
 		    "ret: %i errno: %i slot: %u new_gpa: 0x%lx",
@@ -1190,10 +1108,10 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 	/* Allocate and initialize new vcpu structure. */
 	vcpu = calloc(1, sizeof(*vcpu));
 	TEST_ASSERT(vcpu != NULL, "Insufficient Memory");
+
 	vcpu->id = vcpuid;
-	vcpu->fd = ioctl(vm->fd, KVM_CREATE_VCPU, vcpuid);
-	TEST_ASSERT(vcpu->fd >= 0, "KVM_CREATE_VCPU failed, rc: %i errno: %i",
-		vcpu->fd, errno);
+	vcpu->fd = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)vcpuid);
+	TEST_ASSERT(vcpu->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu->fd));
 
 	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->state), "vcpu mmap size "
 		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",
@@ -1534,11 +1452,7 @@ void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
  */
 void vm_create_irqchip(struct kvm_vm *vm)
 {
-	int ret;
-
-	ret = ioctl(vm->fd, KVM_CREATE_IRQCHIP, 0);
-	TEST_ASSERT(ret == 0, "KVM_CREATE_IRQCHIP IOCTL failed, "
-		"rc: %i errno: %i", ret, errno);
+	vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
 
 	vm->has_irqchip = true;
 }
@@ -1759,7 +1673,7 @@ int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test, int *fd)
 	create_dev.type = type;
 	create_dev.fd = -1;
 	create_dev.flags = test ? KVM_CREATE_DEVICE_TEST : 0;
-	ret = ioctl(vm_get_fd(vm), KVM_CREATE_DEVICE, &create_dev);
+	ret = __vm_ioctl(vm, KVM_CREATE_DEVICE, &create_dev);
 	*fd = create_dev.fd;
 	return ret;
 }
@@ -1855,7 +1769,7 @@ void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level)
 {
 	int ret = _kvm_irq_line(vm, irq, level);
 
-	TEST_ASSERT(ret >= 0, "KVM_IRQ_LINE failed, rc: %i errno: %i", ret, errno);
+	TEST_ASSERT(ret >= 0, KVM_IOCTL_ERROR(KVM_IRQ_LINE, ret));
 }
 
 struct kvm_irq_routing *kvm_gsi_routing_create(void)
@@ -1894,7 +1808,7 @@ int _kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing)
 	int ret;
 
 	assert(routing);
-	ret = ioctl(vm_get_fd(vm), KVM_SET_GSI_ROUTING, routing);
+	ret = __vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
 	free(routing);
 
 	return ret;
@@ -1905,8 +1819,7 @@ void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing)
 	int ret;
 
 	ret = _kvm_gsi_routing_write(vm, routing);
-	TEST_ASSERT(ret == 0, "KVM_SET_GSI_ROUTING failed, rc: %i errno: %i",
-				ret, errno);
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_SET_GSI_ROUTING, ret));
 }
 
 /*
@@ -2205,8 +2118,3 @@ unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size)
 	n = DIV_ROUND_UP(size, vm_guest_mode_params[mode].page_size);
 	return vm_adjust_num_guest_pages(mode, n);
 }
-
-int vm_get_stats_fd(struct kvm_vm *vm)
-{
-	return ioctl(vm->fd, KVM_GET_STATS_FD, NULL);
-}
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 89b13f23c3ac..e66deb8ba7e0 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -317,8 +317,7 @@ static void test_zero_memory_regions(void)
 	vm = vm_create(0);
 	vm_vcpu_add(vm, VCPU_ID);
 
-	TEST_ASSERT(!ioctl(vm_get_fd(vm), KVM_SET_NR_MMU_PAGES, 64),
-		    "KVM_SET_NR_MMU_PAGES failed, errno = %d\n", errno);
+	vm_ioctl(vm, KVM_SET_NR_MMU_PAGES, (void *)64ul);
 	vcpu_run(vm, VCPU_ID);
 
 	run = vcpu_state(vm, VCPU_ID);
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 0d06ffa95d9d..269033af43ce 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -344,7 +344,7 @@ static void test_pmu_config_disable(void (*guest_code)(void))
 
 	cap.cap = KVM_CAP_PMU_CAPABILITY;
 	cap.args[0] = KVM_PMU_CAP_DISABLE;
-	TEST_ASSERT(!vm_enable_cap(vm, &cap), "Failed to set KVM_PMU_CAP_DISABLE.");
+	vm_enable_cap(vm, &cap);
 
 	vm_vcpu_add_default(vm, VCPU_ID, guest_code);
 	vm_init_descriptor_tables(vm);
-- 
2.36.0.464.gb9c8b46e94-goog

