Return-Path: <kvm+bounces-48653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E734AD003D
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 12:17:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1460A16F8DB
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 10:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BEA12874F5;
	Fri,  6 Jun 2025 10:17:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20DC2286416
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 10:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749205054; cv=none; b=cd80j4OKVgXEdWjNGh0wQBCK5ItCv/kCtnEqVvsuWsLYykukk1V/ZEYPTC0sW9wKzMXVHzAbV9iDVOu7tDkOWYG64VfeCSCKqGiY+nm9PxaqeQzHtqOzOmtmJGp+r1hr3BGOc/7g4sR4hYdGcQ3UbM2+VRBUVEl3Xp/a2iB1w2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749205054; c=relaxed/simple;
	bh=HvZ3st1eSAe4qQ4PYDvR0i4s2aynIXGqIl9oaBmrwB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TFWegbb3/vLt4uXNSNVyHp+HOXpG9yolxqfbxTLT9KKaRfDUv8Mp1xBp39qFgzNy9CtRRJmakvNNHR+jpa/87X5TLFo4hLz66UPYbeVbVq8AlwD0yCOSMoVGQI8H0M+vpUMnnziqgoRpf5K8DO7WWa3LPLVQSFJEDvbOXXvjQbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E978153B;
	Fri,  6 Jun 2025 03:17:12 -0700 (PDT)
Received: from [10.57.49.177] (unknown [10.57.49.177])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8A4E33F673;
	Fri,  6 Jun 2025 03:17:23 -0700 (PDT)
Message-ID: <4fb8327f-a3e7-4127-9fa7-754c4e6cbdcc@arm.com>
Date: Fri, 6 Jun 2025 11:17:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 2/9] arm64: efi: initialise SCTLR_ELx
 fully
Content-Language: en-GB
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250529135557.2439500-1-joey.gouly@arm.com>
 <20250529135557.2439500-3-joey.gouly@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250529135557.2439500-3-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/05/2025 14:55, Joey Gouly wrote:
> Don't rely on the value of SCTLR_ELx when booting via EFI.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   lib/arm/setup.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 67b5db07..0a22dbab 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -349,6 +349,11 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>   {
>   	efi_status_t status;
>   
> +
> +	// EFI exits boot services with SCTLR_ELx.M=1, so keep
> +	// the MMU enabled.
> +	write_sysreg(INIT_SCTLR_EL1_MMU_OFF | SCTLR_EL1_M, sctlr_el1);

minor nit: Given this is in a common file for arm/arm64, may be worth 
adding a helper function that does this on arm64. I understand EFI
cannot enabled for arm32, still keeping this file generic would be
cleaner. e.g.,

mmu_on(); or even  setup_sctlr();

Suzuki


