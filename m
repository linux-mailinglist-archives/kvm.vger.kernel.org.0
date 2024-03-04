Return-Path: <kvm+bounces-10769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3042086FB8A
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:19:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FB87B21B7A
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56FB0175BF;
	Mon,  4 Mar 2024 08:18:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C98C17583
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 08:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709540319; cv=none; b=a9GyXcwjMPQ84q4KzqGj13qtEKTBuqt42koCfqgrt2TP8g33VqwXv01KinIoNkgFO+GMN7PZc6N4ErBgL9vT3eGdOt/s3zlkuPmXaWy8l5D3aLIReLbnBTQShn+5FI7vs1iKulacKK8Ue+O276VE0myWqemP3BYW3dZ3/EFi1iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709540319; c=relaxed/simple;
	bh=aT60ShKKsHSluRbSIYZOejJGLrozJvKDb3D6y3GMzL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B4CN0J6ur9tjmrZcPxQlWpsKgvhO+JsadvbVHH/PaylDTc3LL68KZE0WY9BHaWxWVZumoygr+6rimC0F3X52Qrf262faEoW5n0xCzkjMBS74tIy1PJNjnw5kzXzYP/ye37tmXc42/nsZD1KIKj5GA6Y/lWmQLXO/6Yv9k7ebSM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2C171FB;
	Mon,  4 Mar 2024 00:19:13 -0800 (PST)
Received: from [192.168.5.30] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFCD93F762;
	Mon,  4 Mar 2024 00:18:35 -0800 (PST)
Message-ID: <7e8d819d-2a33-47f2-81c4-23950586afb7@arm.com>
Date: Mon, 4 Mar 2024 08:18:34 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 15/18] arm64: efi: Don't map reserved
 regions
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-35-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-35-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> We shouldn't need to map all the regions that the EFI memory map
> contains. Just map EFI_LOADER_CODE and EFI_LOADER_DATA, since
> those are for the loaded unit test, and any region types which
> could be used by the unit test for its own memory allocations. We
> still map EFI_BOOT_SERVICES_DATA since the primary stack is on a
> region of that type. In a later patch we'll switch to a stack we
> allocate ourselves to drop that one too.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> ---
>   lib/arm/mmu.c    | 6 +-----
>   lib/arm/setup.c  | 4 ++--
>   lib/memregions.c | 8 ++++++++
>   3 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index eb5e82a95f06..9dce7da85709 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -221,12 +221,8 @@ void *setup_mmu(phys_addr_t phys_end, void *unused)
>   		mmu_idmap = alloc_page();
>   
>   	for (r = mem_regions; r->end; ++r) {
> -		if (r->flags & MR_F_IO) {
> +		if (r->flags & (MR_F_IO | MR_F_RESERVED)) {
>   			continue;
> -		} else if (r->flags & MR_F_RESERVED) {
> -			/* Reserved pages need to be writable for whatever reserved them */
> -			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
> -					   __pgprot(PTE_WBWA));
>   		} else if (r->flags & MR_F_CODE) {
>   			/* armv8 requires code shared between EL1 and EL0 to be read-only */
>   			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 521928186fb0..08658b9a222b 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -309,8 +309,8 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>   		data->flags &= ~MR_F_CODE;
>   
>   	for (struct mem_region *m = mem_regions; m->end; ++m) {
> -		if (m != code && (m->flags & MR_F_CODE))
> -			m->flags = MR_F_RESERVED;
> +		if (m != code)
> +			assert(!(m->flags & MR_F_CODE));
>   
>   		if (!(m->flags & MR_F_IO)) {
>   			if (m->start < __phys_offset)
> diff --git a/lib/memregions.c b/lib/memregions.c
> index 9cdbb639ab62..3c6f751eb4f2 100644
> --- a/lib/memregions.c
> +++ b/lib/memregions.c
> @@ -112,6 +112,14 @@ void memregions_efi_init(struct efi_boot_memmap *mem_map,
>   		case EFI_LOADER_CODE:
>   			r.flags = MR_F_CODE;
>   			break;
> +		case EFI_LOADER_DATA:
> +			break;
> +		case EFI_BOOT_SERVICES_DATA:
> +			/*
> +			 * FIXME: This would ideally be MR_F_RESERVED, but the
> +			 * primary stack is in a region of this EFI type.
> +			 */
> +			break;
>   		case EFI_PERSISTENT_MEMORY:
>   			r.flags = MR_F_PERSISTENT;
>   			break;

