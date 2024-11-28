Return-Path: <kvm+bounces-32757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CAA9DBA46
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 16:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 698E41604A1
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 15:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E244E1BD9CF;
	Thu, 28 Nov 2024 15:13:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E165B1BD9D0
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 15:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732806790; cv=none; b=L99tfHjR4BVP0mHHBeyGU0purzMcHdZLGjGI9AogwdaNnv6nnQho5GbX6+BGAZL2T2zKFyxWbJ2Uib7tYvgVhhmS99HAvgmu1Au+n+MNj/iIZQuMxYTFX1Pwdm01xXqiz0niJKVF9c5u0SsmdiirMISCTbBF6IFvf41eHMb7bKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732806790; c=relaxed/simple;
	bh=CYN3mvUwBhRwdxWEt1klHIbvh/+u8xOtBoRxCuDzEZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaYZNLTe5j2EUr4Gwffog1inh0T7OI9Au58xPSL8LS2nhDMI68q0o2+z//6gylczJrksuPk+PMrOotynD4KKS7CkaoyeJyfh0HH3JHlN5Xpbg3sb2xb5ZKtdcPoB+E2ocQWxtg7CKZ7iHErjJ59YxD1bpPzyiJEWavmgdTPyHhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 397BD1474;
	Thu, 28 Nov 2024 07:13:38 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88DF13F66E;
	Thu, 28 Nov 2024 07:13:06 -0800 (PST)
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
Subject: [RFC PATCH kvmtool 4/4] arm64: Increase the payload memory region size to 512MB
Date: Thu, 28 Nov 2024 15:12:46 +0000
Message-ID: <20241128151246.10858-5-alexandru.elisei@arm.com>
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

kvmtool uses the same memory map for 64bit and 32bit guests, where it
copies the kernel, the initrd and DTB in the bottom 256MB.

The restriction on placing everything in the bottom 256MB comes from the
aarch32 boot protocol, where the kernel, DTB and initrd must be placed in a
region covered by the low-memory mapping. The size of the lowmem region
varies based on the kernel-userspace split, which is a Kconfig option, and
on the vmalloc area size, which can be specified by the user on the kernel
command line. Hence kvmtool's choice of using the bottom 256MB as a
reasonable compromise which has worked well so far.

Sina has reported in private that they were unable to create a 64bit
virtual machine with a 351MB initrd, and that's due to the 256MB
restriction placed on the arm64 payload layout.

This restriction is not found in the arm64 boot protocol: booting.rst in
the Linux v6.12 source tree specifies that the kernel and initrd must be
placed in the same 32GB window. There is also a mention of kernels prior
to v4.2 requiring the DTB to be placed within a 512MB region starting at
the kernel image minus the kernel offset.

Increase the payload region size to 512MB for arm64, which will provide
maximum compatibility with Linux guests, while allowing for larger initrds
or kernel images. This means that the gap between the DTB (or initrd, if
present) and the kernel is larger now.

For 32 bit guests, the payload region size has been kept unchanged, because
it has proven adequate so far.

Reported-by: Abdollahi Sina <s.abdollahi22@imperial.ac.uk>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch32/include/kvm/kvm-arch.h | 5 +++--
 arm/aarch64/include/kvm/kvm-arch.h | 2 ++
 arm/aarch64/kvm.c                  | 8 ++++++++
 arm/kvm.c                          | 6 ++++--
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
index 07d711e2f4c1..0333cf4355ac 100644
--- a/arm/aarch32/include/kvm/kvm-arch.h
+++ b/arm/aarch32/include/kvm/kvm-arch.h
@@ -3,8 +3,9 @@
 
 #include <linux/sizes.h>
 
-#define kvm__arch_get_kern_offset(...)	0x8000
-#define kvm__arch_get_kernel_size(...)	0
+#define kvm__arch_get_kern_offset(...)		0x8000
+#define kvm__arch_get_kernel_size(...)		0
+#define kvm__arch_get_payload_region_size(...)	SZ_256M
 
 struct kvm;
 static inline void kvm__arch_read_kernel_header(struct kvm *kvm, int fd) {}
diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 97ab42485158..2d1a4ed8cea4 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -8,6 +8,8 @@ void kvm__arch_read_kernel_header(struct kvm *kvm, int fd);
 unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm);
 u64 kvm__arch_get_kernel_size(struct kvm *kvm);
 
+u64 kvm__arch_get_payload_region_size(struct kvm *kvm);
+
 int kvm__arch_get_ipa_limit(struct kvm *kvm);
 void kvm__arch_enable_mte(struct kvm *kvm);
 
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 6fcc828cbe01..98b24375ee98 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -135,6 +135,14 @@ u64 kvm__arch_get_kernel_size(struct kvm *kvm)
 	return le64_to_cpu(kernel_header->image_size);
 }
 
+u64 kvm__arch_get_payload_region_size(struct kvm *kvm)
+{
+	if (kvm->cfg.arch.aarch32_guest)
+		return SZ_256M;
+
+	return SZ_512M;
+}
+
 int kvm__arch_get_ipa_limit(struct kvm *kvm)
 {
 	int ret;
diff --git a/arm/kvm.c b/arm/kvm.c
index 9013be489aff..7b2b49e21498 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -103,14 +103,16 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 {
 	void *pos, *kernel_end, *limit;
 	unsigned long guest_addr;
+	u64 payload_region_size;
 	ssize_t file_size;
 	u64 kernel_size;
 
+	payload_region_size = kvm__arch_get_payload_region_size(kvm);
 	/*
-	 * Linux requires the initrd and dtb to be mapped inside lowmem,
+	 * Linux for arm requires the initrd and dtb to be mapped inside lowmem,
 	 * so we can't just place them at the top of memory.
 	 */
-	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M);
+	limit = kvm->ram_start + min(kvm->ram_size, payload_region_size);
 
 	kvm__arch_read_kernel_header(kvm, fd_kernel);
 
-- 
2.47.0


