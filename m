Return-Path: <kvm+bounces-32756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91DB29DBA45
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 16:13:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D68E4B23972
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 15:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99AB51B6CE1;
	Thu, 28 Nov 2024 15:13:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855F31B5ED1
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 15:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732806788; cv=none; b=cLQwVluBfn04GwnBSSDMTc714pKR1Q2A6hW5NLagcO8Qt2EPKKybLj1dccJtwFCUSqzCq/6x/oebQlzcO4AwwDtlKCaQiUju3EmsLx6PxH+plpM+3AKxyUGLtpEK6ZTW4Y0G0+q/cQtoNVIu28jO06my/cigIR9MilUGxh87bSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732806788; c=relaxed/simple;
	bh=KGJhzBu6JUIX+vaqDEP+fXFw+NzHwA8Rdy2DqOGFkxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1phy9SymcxroyVkzk93UJNBSXGw5g7kxXyFVBu0hxJAr3YW5f5YhahUhmqDM7Ggt8J6Xsar/b5iggrszIkqYKkcnvTGhFW/Tclql3s+X0O3qWMA0OC/0zLZ8oZzEnjCSXFEUkWfbim4UFwlfz2ggQbeQekR/7p3nSN4Ie2YI7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0405F1476;
	Thu, 28 Nov 2024 07:13:36 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 583663F66E;
	Thu, 28 Nov 2024 07:13:04 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	apatel@ventanamicro.com,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	s.abdollahi22@imperial.ac.uk
Subject: [PATCH kvmtool 3/4] arm64: Use the kernel header image_size when loading into memory
Date: Thu, 28 Nov 2024 15:12:45 +0000
Message-ID: <20241128151246.10858-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241128151246.10858-1-alexandru.elisei@arm.com>
References: <20241128151246.10858-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The field 'image_size' from the kernel header encodes the kernel size when
loaded in memory. This includes the BSS section which gets zeroed early
during boot (for example, in early_map_kernel() in Linux v6.12), section
which is not reflected in the file size.

kvmtool, after loading the kernel image into memory, uses the file size,
not the image size, to compute the end of the kernel to check for overlaps.
As a result, kvmtool doesn't detect when the DTB or initrd overlap with the
in memory kernel image as long as they don't overlap with the file, and
this leads to Linux silently overwriting the DTB or the initrd with zeroes
during boot.

This kind of issue, when it happens, is not trivial to debug. kvmtool
already reads the image header to get the kernel offset, so expand on that
to also read the image size, and use it instead of the file size for memory
layout calculations.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch32/include/kvm/kvm-arch.h |  2 +
 arm/aarch64/include/kvm/kvm-arch.h |  5 +-
 arm/aarch64/kvm.c                  | 80 +++++++++++++++++++++++-------
 arm/kvm.c                          | 15 ++++--
 4 files changed, 78 insertions(+), 24 deletions(-)

diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
index 467fb09175b8..07d711e2f4c1 100644
--- a/arm/aarch32/include/kvm/kvm-arch.h
+++ b/arm/aarch32/include/kvm/kvm-arch.h
@@ -4,8 +4,10 @@
 #include <linux/sizes.h>
 
 #define kvm__arch_get_kern_offset(...)	0x8000
+#define kvm__arch_get_kernel_size(...)	0
 
 struct kvm;
+static inline void kvm__arch_read_kernel_header(struct kvm *kvm, int fd) {}
 static inline void kvm__arch_enable_mte(struct kvm *kvm) {}
 
 #define MAX_PAGE_SIZE	SZ_4K
diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 02d09a413831..97ab42485158 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -4,7 +4,10 @@
 #include <linux/sizes.h>
 
 struct kvm;
-unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
+void kvm__arch_read_kernel_header(struct kvm *kvm, int fd);
+unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm);
+u64 kvm__arch_get_kernel_size(struct kvm *kvm);
+
 int kvm__arch_get_ipa_limit(struct kvm *kvm);
 void kvm__arch_enable_mte(struct kvm *kvm);
 
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 54200c9eec9d..6fcc828cbe01 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -8,6 +8,8 @@
 
 #include <kvm/util.h>
 
+static struct arm64_image_header *kernel_header;
+
 int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
 {
 	struct kvm *kvm = opt->ptr;
@@ -57,50 +59,82 @@ u64 kvm__arch_default_ram_address(void)
 	return ARM_MEMORY_AREA;
 }
 
+void kvm__arch_read_kernel_header(struct kvm *kvm, int fd)
+{
+	const char *debug_str;
+	off_t cur_offset;
+	ssize_t size;
+
+	if (kvm->cfg.arch.aarch32_guest)
+		return;
+
+	kernel_header = malloc(sizeof(*kernel_header));
+	if (!kernel_header)
+		return;
+
+	cur_offset = lseek(fd, 0, SEEK_CUR);
+	if (cur_offset == (off_t)-1 || lseek(fd, 0, SEEK_SET) == (off_t)-1) {
+		debug_str = "Failed to seek in kernel image file";
+		goto fail;
+	}
+
+	size = xread(fd, kernel_header, sizeof(*kernel_header));
+	if (size < 0 || (size_t)size < sizeof(*kernel_header))
+		die("Failed to read kernel image header");
+
+	lseek(fd, cur_offset, SEEK_SET);
+
+	if (memcmp(&kernel_header->magic, ARM64_IMAGE_MAGIC, sizeof(kernel_header->magic))) {
+		debug_str = "Kernel image magic not matching";
+		kernel_header = NULL;
+		goto fail;
+	}
+
+	return;
+
+fail:
+	pr_debug("%s, using defaults", debug_str);
+}
+
 /*
  * Return the TEXT_OFFSET value that the guest kernel expects. Note
  * that pre-3.17 kernels expose this value using the native endianness
  * instead of Little-Endian. BE kernels of this vintage may fail to
  * boot. See Documentation/arm64/booting.rst in your local kernel tree.
  */
-unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd)
+unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm)
 {
-	struct arm64_image_header header;
-	off_t cur_offset;
-	ssize_t size;
 	const char *debug_str;
 
 	/* the 32bit kernel offset is a well known value */
 	if (kvm->cfg.arch.aarch32_guest)
 		return 0x8000;
 
-	cur_offset = lseek(fd, 0, SEEK_CUR);
-	if (cur_offset == (off_t)-1 ||
-	    lseek(fd, 0, SEEK_SET) == (off_t)-1) {
-		debug_str = "Failed to seek in kernel image file";
+	if (!kernel_header) {
+		debug_str = "Kernel header is missing";
 		goto default_offset;
 	}
 
-	size = xread(fd, &header, sizeof(header));
-	if (size < 0 || (size_t)size < sizeof(header))
-		die("Failed to read kernel image header");
-
-	lseek(fd, cur_offset, SEEK_SET);
-
-	if (memcmp(&header.magic, ARM64_IMAGE_MAGIC, sizeof(header.magic))) {
-		debug_str = "Kernel image magic not matching";
+	if (!le64_to_cpu(kernel_header->image_size)) {
+		debug_str = "Image size is 0";
 		goto default_offset;
 	}
 
-	if (le64_to_cpu(header.image_size))
-		return le64_to_cpu(header.text_offset);
+	return le64_to_cpu(kernel_header->text_offset);
 
-	debug_str = "Image size is 0";
 default_offset:
 	pr_debug("%s, assuming TEXT_OFFSET to be 0x80000", debug_str);
 	return 0x80000;
 }
 
+u64 kvm__arch_get_kernel_size(struct kvm *kvm)
+{
+	if (kvm->cfg.arch.aarch32_guest || !kernel_header)
+		return 0;
+
+	return le64_to_cpu(kernel_header->image_size);
+}
+
 int kvm__arch_get_ipa_limit(struct kvm *kvm)
 {
 	int ret;
@@ -160,3 +194,11 @@ void kvm__arch_enable_mte(struct kvm *kvm)
 
 	pr_debug("MTE capability enabled");
 }
+
+static int kvm__arch_free_kernel_header(struct kvm *kvm)
+{
+	free(kernel_header);
+
+	return 0;
+}
+late_exit(kvm__arch_free_kernel_header);
diff --git a/arm/kvm.c b/arm/kvm.c
index 4beae69e1fb3..9013be489aff 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -104,6 +104,7 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	void *pos, *kernel_end, *limit;
 	unsigned long guest_addr;
 	ssize_t file_size;
+	u64 kernel_size;
 
 	/*
 	 * Linux requires the initrd and dtb to be mapped inside lowmem,
@@ -111,7 +112,9 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	 */
 	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M);
 
-	pos = kvm->ram_start + kvm__arch_get_kern_offset(kvm, fd_kernel);
+	kvm__arch_read_kernel_header(kvm, fd_kernel);
+
+	pos = kvm->ram_start + kvm__arch_get_kern_offset(kvm);
 	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
 	if (!kvm->arch.kern_guest_start)
 			die("guest memory too small to contain the kernel");
@@ -122,9 +125,13 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 
 		die_perror("kernel read");
 	}
-	kernel_end = pos + file_size;
-	pr_debug("Loaded kernel to 0x%llx (%zd bytes)",
-		 kvm->arch.kern_guest_start, file_size);
+
+	kernel_size = kvm__arch_get_kernel_size(kvm);
+	if (!kernel_size || kernel_size < (u64)file_size)
+		kernel_size = file_size;
+	kernel_end = pos + kernel_size;
+	pr_debug("Loaded kernel to 0x%llx (%llu bytes)",
+		 kvm->arch.kern_guest_start, kernel_size);
 
 	/*
 	 * Now load backwards from the end of memory so the kernel
-- 
2.47.0


