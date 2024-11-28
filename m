Return-Path: <kvm+bounces-32754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A36A9DBA43
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 16:13:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4BD8280DB1
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 15:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B953A1BD017;
	Thu, 28 Nov 2024 15:13:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DDD1B85D1
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732806785; cv=none; b=Cbr7HRM7o26mGLnewaydtGpBJ/bfr397pDQSW/zMTIrC63agjFdH0rrpVnLR463SJAQSoh7plM/l1ZHnh3g9rbdURmSJMWA0m+Ijm1ppjt0yyb5ewpNka4TqUUt6VTqTlSEfRGMb4m6QNM3s2JozdYKX5cWfn4ODJsxsPV0akC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732806785; c=relaxed/simple;
	bh=dbMuuKJJU1bCqHlaL0UVjvAN7kojyjUkT2IObE8rFq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOm3SA4K6YTLocyHE273GZ5CJ71kOFTpWrS48zs31xzUD2fq/ZVpRtQUWuwAlKEqY1DoDOUuepPfwDFfq6FFqrEAK4U5ClYBmkUH9SrhPv8yA0Qtum4QNCPObKN6x5bbLdpGwS2r7sJ8rfgf5ZZZ59yWwjXxKuSbcjlxgpSmWvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A32211476;
	Thu, 28 Nov 2024 07:13:31 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 001953F66E;
	Thu, 28 Nov 2024 07:12:59 -0800 (PST)
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
Subject: [PATCH kvmtool 1/4] arm: Fix off-by-one errors when computing payload memory layout
Date: Thu, 28 Nov 2024 15:12:43 +0000
Message-ID: <20241128151246.10858-2-alexandru.elisei@arm.com>
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

In kvm__arch_load_kernel_image(), 'limit' is computed to be the topmost
byte address where the payload can reside.

In all the read_file() calls, the maximum size of the file being read is
computed as limit - pos, which is incorrect: either limit is inclusive, and
it should be limit - pos + 1, or the maximum size is correct and limit is
incorrectly computed as inclusive.

After reserving space for the DTB, 'limit' is updated to point at the first
byte of the DTB. Which is in contradiction with the way it is initially
calculated, because in theory this makes it possible for the initrd (which
is copied below the DTB) to overwrite the first byte of the DTB. That's
only avoided by accident, and not by design, because, as explained above,
the size of the initrd is smaller by 1 byte (read_file() has the size
parameter limit - pos, instead of limit - pos + 1).

Let's get rid of this confusion and compute 'limit' as exclusive from the
start.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index 9f9582326401..da0430c40c36 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -109,7 +109,7 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	 * Linux requires the initrd and dtb to be mapped inside lowmem,
 	 * so we can't just place them at the top of memory.
 	 */
-	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
+	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M);
 
 	pos = kvm->ram_start + kvm__arch_get_kern_offset(kvm, fd_kernel);
 	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
@@ -139,7 +139,7 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	kvm->arch.dtb_guest_start = guest_addr;
 	pr_debug("Placing fdt at 0x%llx - 0x%llx",
 		 kvm->arch.dtb_guest_start,
-		 host_to_guest_flat(kvm, limit));
+		 host_to_guest_flat(kvm, limit - 1));
 	limit = pos;
 
 	/* ... and finally the initrd, if we have one. */
-- 
2.47.0


