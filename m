Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3F2BB56F
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408098AbfIWNfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:38 -0400
Received: from foss.arm.com ([217.140.110.172]:42284 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404581AbfIWNfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36AE81576;
        Mon, 23 Sep 2019 06:35:38 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F0E783F694;
        Mon, 23 Sep 2019 06:35:36 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH kvmtool 01/16] arm: Allow use of hugepage with 16K pagesize host
Date:   Mon, 23 Sep 2019 14:35:07 +0100
Message-Id: <1569245722-23375-2-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

With 16K pagesize, the hugepage size is 32M. Align the guest
memory to the hugepagesize for 16K.

To query the host page size, we use sysconf(_SC_PAGESIZE) instead of
getpagesize, as suggested by man 2 getpagesize for portable applications.
Also use the sysconf function instead of getpagesize when setting
kvm->ram_pagesize.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Julien Grall <julien.grall@arm.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm.c     | 36 +++++++++++++++++++++++++++++-------
 builtin-run.c |  4 ++--
 util/util.c   |  2 +-
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index 1f85fc60588f..1c5bdb8026bf 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -59,14 +59,33 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 
 void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 {
+	unsigned long alignment;
+
 	/*
-	 * Allocate guest memory. We must align our buffer to 64K to
-	 * correlate with the maximum guest page size for virtio-mmio.
-	 * If using THP, then our minimal alignment becomes 2M.
-	 * 2M trumps 64K, so let's go with that.
+	 * Allocate guest memory. If the user wants to use hugetlbfs, then the
+	 * specified guest memory size must be a multiple of the host huge page
+	 * size in order for the allocation to succeed. The mmap return adress
+	 * is naturally aligned to the huge page size, so in this case we don't
+	 * need to perform any alignment.
+	 *
+	 * Otherwise, we must align our buffer to 64K to correlate with the
+	 * maximum guest page size for virtio-mmio. If using THP, then our
+	 * minimal alignment becomes 2M with a 4K page size. With a 16K page
+	 * size, the alignment becomes 32M. 32M and 2M trump 64K, so let's go
+	 * with the largest alignment supported by the host.
 	 */
+	if (hugetlbfs_path) {
+		/* Don't do any alignment. */
+		alignment = 0;
+	} else {
+		if (sysconf(_SC_PAGESIZE) == SZ_16K)
+			alignment = SZ_32M;
+		else
+			alignment = SZ_2M;
+	}
+
 	kvm->ram_size = min(ram_size, (u64)ARM_MAX_MEMORY(kvm));
-	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
+	kvm->arch.ram_alloc_size = kvm->ram_size + alignment;
 	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path,
 						kvm->arch.ram_alloc_size);
 
@@ -74,8 +93,11 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 		die("Failed to map %lld bytes for guest memory (%d)",
 		    kvm->arch.ram_alloc_size, errno);
 
-	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
-					SZ_2M);
+	kvm->ram_start = kvm->arch.ram_alloc_start;
+	/* The result of aligning to 0 is 0. Let's avoid that. */
+	if (alignment)
+		kvm->ram_start = (void *)ALIGN((unsigned long)kvm->ram_start,
+					       alignment);
 
 	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
 		MADV_MERGEABLE);
diff --git a/builtin-run.c b/builtin-run.c
index f8dc6c7229b0..c867c8ba0892 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -127,8 +127,8 @@ void kvm_run_set_wrapper_sandbox(void)
 			"Run this script when booting into custom"	\
 			" rootfs"),					\
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
-			"Hugetlbfs path"),				\
-									\
+			"Hugetlbfs path. Memory size must be a multiple"\
+			" of the huge page size"),			\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
 			"Kernel to boot in virtual machine"),		\
diff --git a/util/util.c b/util/util.c
index 1877105e3c08..217addd75e6f 100644
--- a/util/util.c
+++ b/util/util.c
@@ -127,7 +127,7 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 si
 		 */
 		return mmap_hugetlbfs(kvm, hugetlbfs_path, size);
 	else {
-		kvm->ram_pagesize = getpagesize();
+		kvm->ram_pagesize = sysconf(_SC_PAGESIZE);
 		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
 	}
 }
-- 
2.7.4

