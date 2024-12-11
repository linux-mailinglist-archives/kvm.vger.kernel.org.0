Return-Path: <kvm+bounces-33533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E22A9EDC2F
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 00:47:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A703165EBF
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9C11F8667;
	Wed, 11 Dec 2024 23:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Loz5Dw5d"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B6D1F4E3D;
	Wed, 11 Dec 2024 23:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733960668; cv=none; b=d35+hLkyKFHrG4tODsswPV+5llsTlJOK/jAE0byBLRbeGZEJO/N0d7EJ6cnOsePBG1WbpH3OH58RN/4L25iTZ2MQ7hbUj7FGpAo06K26aWbRh2TmEA25kTvIK4o2cTfF79cyOIU/eyiDizdYc/IrFb3gTG/9Bq6I6ZNUp99W1kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733960668; c=relaxed/simple;
	bh=NhjoOwOjzquX2bXnZzEYItVz/He94fvuHxQEX3N9G6E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UwTiOrt24GKzOEw0GBP4VJ7drS0qZUUpDdDIOwL9iC8uaMQjdaEHqWPZE6SzynLuFcM/PdEbl7ms2L89T6/0ejMA8YdoefyaIQSV14xcb8Ea8OUicz5HUQxLKq2QtrrxCoTVOiphvml5dl/JJyVinyYqkFxdrPd/Odknr2IAPTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Loz5Dw5d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F2BC4AF0B;
	Wed, 11 Dec 2024 23:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733960665;
	bh=NhjoOwOjzquX2bXnZzEYItVz/He94fvuHxQEX3N9G6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Loz5Dw5dkLz7Jykt2rrpTouLZH3Gs2C/w+EJHtak+Jf5fXazB1SbzLsbJpNdDRJy0
	 7WNZGb8AsPd0kZ9xWfJOiq6kBzVsce3R76h6EYpxnbBt46GBBm7d/qKfzrWc5i6PT6
	 nxt0d3Omjq38QqbVNnIHZCTx8Ui3jJRd39GMZqHAshT/eX95+Uah3Ic4i7ZvQD1Wwo
	 RMdpx+SAc/VfXWt0VOB1dq8466Ijf9B5iV4xalUTxZA58O4w12gZgdGnHBmEOuvaK4
	 16pOWO7IF3lLGYIr5pZ8YvDT6ifmOIH05g7L2tTzD8Bk22cVbvNn9TMXzkaHxCs7wi
	 pFoRm8rUUl95g==
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	maz@kernel.org,
	oliver.upton@linux.dev,
	apatel@ventanamicro.com,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	s.abdollahi22@imperial.ac.uk
Subject: Re: [PATCH RESEND kvmtool 0/4] arm: Payload memory layout change
Date: Wed, 11 Dec 2024 23:44:14 +0000
Message-Id: <173395873873.2737640.3783988676491071650.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241128151246.10858-1-alexandru.elisei@arm.com>
References: <20241128151246.10858-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 28 Nov 2024 15:12:42 +0000, Alexandru Elisei wrote:
> (resending because I accidently only sent the cover letter, sorry for that)
> 
> The first 3 patches are fixes to kvm__arch_load_kernel_image(). I've CC'ed
> the riscv maintainer because it looks to me like riscv is similarly
> affected.
> 
> Patch #4 ("arm64: Increase the payload memory region size to 512MB") might
> be controversial. Follows a bug report I received from Abdollahi Sina in
> private. Details in the commit message, but the gist of the patch is that
> the memory region where kernel + initrd + DTB are copied to are changed
> from 256MB to 512MB.  As a result, the DTB and initrd are moved from below
> ram_start + 256MB to ram_start + 512MB to accomodate a larger initrd.  If
> users rely on finding the DTB and initrd at the current addresses, then I'm
> not sure the patch is justified - after all, if someone really wants to use
> such a large initrd instead of a disk image with virtio, then replacing
> SZ_256M with SZ_512M locally doesn't look like a big ask.
> 
> [...]

Applied to arm64 (sina), thanks!

[1/4] arm: Fix off-by-one errors when computing payload memory layout
      https://git.kernel.org/arm64/c/167aa1e
[2/4] arm: Check return value for host_to_guest_flat()
      https://git.kernel.org/arm64/c/ca57fb6
[3/4] arm64: Use the kernel header image_size when loading into memory
      https://git.kernel.org/arm64/c/32345de
[4/4] arm64: Increase the payload memory region size to 512MB
      https://git.kernel.org/arm64/c/9b26a8e

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

