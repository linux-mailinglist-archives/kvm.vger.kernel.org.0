Return-Path: <kvm+bounces-32755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D734D9DBA44
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 16:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A307F160863
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 15:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD4681B6CF3;
	Thu, 28 Nov 2024 15:13:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AB0F1BBBFC
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 15:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732806787; cv=none; b=Ps74N/Epv0zgIaba7TEJT35dhKL39Zbp9wW59fIuovIuFTlxQlC9b6dX3iigYCGWYqyPeEM+tXN1CzI+k29csUVrvcs39N3wsC4Usv6mXsK+nJW5Xec5LnMRrowt1S4o8gasJgUXo6zizfxjRDfMHrQDyqojKdhgddZg72ptCGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732806787; c=relaxed/simple;
	bh=PN6kHRyzwvl4QmPGF+ycOvYNOkxzWvmrpf90A76Bup0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GziKskTt2t6U1jHd0O8WF13wTkvFjRAHdtWlbwnGyCV7OnObvb3w0yKCXbgXwSChsLaYsGMKpwQrmpfdKr0kuT7kfSzVq33KIaadtzj9L1/IGa3ZyRajVy3LopIerpLBnqDxUQypxqRvyfeBg/rna2ShOt1gNtdNgXDKb6Bydv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF0201474;
	Thu, 28 Nov 2024 07:13:33 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EC743F66E;
	Thu, 28 Nov 2024 07:13:02 -0800 (PST)
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
Subject: [PATCH kvmtool 2/4] arm: Check return value for host_to_guest_flat()
Date: Thu, 28 Nov 2024 15:12:44 +0000
Message-ID: <20241128151246.10858-3-alexandru.elisei@arm.com>
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

kvmtool, on arm and arm64, puts the kernel, DTB and initrd (if present) in
a 256MB memory region that starts at the bottom of RAM.
kvm__arch_load_kernel_image() copies the kernel at the start of RAM, the
DTB is placed at the top of the region, and immediately below it the
initrd.

When the initrd is specified by the user, kvmtool checks that it doesn't
overlap with the kernel by computing the start address in the host's
address space:

	fstat(fd_initrd, &sb);
	pos = pos - (sb.st_size + INITRD_ALIGN);
	guest_addr = ALIGN(host_to_guest_flat(kvm, pos), INITRD_ALIGN); (a)
	pos = guest_flat_to_host(kvm, guest_addr); (b)

If the initrd is large enough to completely overwrite the kernel and start
below the guest RAM (pos < kvm->ram_start), then kvmtool will omit the
following errors:

  Warning: unable to translate host address 0xfffe849ffffc to guest (1)
  Warning: unable to translate guest address 0x0 to host (2)
  Fatal: initrd overlaps with kernel image. (3)

(1) is because (a) calls host_to_guest_flat(kvm, pos) with a 'pos'
outside any of the memslots.

(2) is because guest_flat_to_host() is called at (b) with guest_addr=0,
which is what host_to_guest_flat() returns if the supplied address is not
found in any of the memslots. This warning is eliminated by this patch.

And finally, (3) is the most useful message, because it tells the user what
the error is.

The issue is a more general pattern in kvm__arch_load_kernel_image():
kvmtool doesn't check if host_to_guest_flat() returns 0, which means that
the host address is not within any of the memslots. Add a check for that,
which will at the very least remove the second warning.

This also fixes the following edge cases:

1. The same warnings being emitted in a similar scenario with the DTB, when
the RAM is smaller than FDT_MAX_SIZE + FDT_ALIGN.

2. When copying the kernel, if the RAM size is smaller than the kernel
offset, the start of the kernel (represented by the variable 'pos') will be
outside the VA space allocated for the guest RAM.  limit - pos will wrap
around, because gcc 14.1.1 wraps the pointers (void pointer arithmetic is
undefined in C99). Then read_file()->..->read() will return -EFAULT because
the destination address is unallocated (as per man 2 read, also reproduced
during testing).

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index da0430c40c36..4beae69e1fb3 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -113,6 +113,8 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 
 	pos = kvm->ram_start + kvm__arch_get_kern_offset(kvm, fd_kernel);
 	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
+	if (!kvm->arch.kern_guest_start)
+			die("guest memory too small to contain the kernel");
 	file_size = read_file(fd_kernel, pos, limit - pos);
 	if (file_size < 0) {
 		if (errno == ENOMEM)
@@ -131,7 +133,10 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	 */
 	pos = limit;
 	pos -= (FDT_MAX_SIZE + FDT_ALIGN);
-	guest_addr = ALIGN(host_to_guest_flat(kvm, pos), FDT_ALIGN);
+	guest_addr = host_to_guest_flat(kvm, pos);
+	if (!guest_addr)
+		die("fdt too big to contain in guest memory");
+	guest_addr = ALIGN(guest_addr, FDT_ALIGN);
 	pos = guest_flat_to_host(kvm, guest_addr);
 	if (pos < kernel_end)
 		die("fdt overlaps with kernel image.");
@@ -151,7 +156,10 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 			die_perror("fstat");
 
 		pos -= (sb.st_size + INITRD_ALIGN);
-		guest_addr = ALIGN(host_to_guest_flat(kvm, pos), INITRD_ALIGN);
+		guest_addr = host_to_guest_flat(kvm, pos);
+		if (!guest_addr)
+			die("initrd too big to fit in the payload memory region");
+		guest_addr = ALIGN(guest_addr, INITRD_ALIGN);
 		pos = guest_flat_to_host(kvm, guest_addr);
 		if (pos < kernel_end)
 			die("initrd overlaps with kernel image.");
-- 
2.47.0


