Return-Path: <kvm+bounces-29997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B6239B5D3A
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 08:52:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 116C52846E7
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 07:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685021E0B6D;
	Wed, 30 Oct 2024 07:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyf0LMJf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFF533E1;
	Wed, 30 Oct 2024 07:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730274729; cv=none; b=U8mb9Azx10J5smgYGoPA6r+rQdg4dowGLKELwIHZq9JJ54dTJHwhthc7xShNxowBV9/uMIyvSPM7eiyaFkzYAYJOdXDC6sEXCXE7WWYxq+6FXEhe9kyQJK1rqiff5LVCqz3i5rhmYYtOH7R8PA+YX4CpVLs1jMhG0EHOkSr45yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730274729; c=relaxed/simple;
	bh=vrq3Hj0eASMy2KLVd52CUc8legLz7mDW/VncF6IQKRk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HPTbywzR5PMqGoblaXgzILbqOOsPGjYeMeSN7/vpw3QIJIwJZ7OJZIphyX+uIFGD0BmFI1eALNoV+hz5uRVuoHHOTpToPRP6fMvc6UaZFouo41DoE2pQUIcU1QYBAAR5/oVO5jKHIoH6u5CzrK0GhiPI2cH0w7HWu/qLrsINbKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyf0LMJf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBD3C4CEE4;
	Wed, 30 Oct 2024 07:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730274729;
	bh=vrq3Hj0eASMy2KLVd52CUc8legLz7mDW/VncF6IQKRk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=fyf0LMJf7Dtu1xwovWtcG6BfS649d4d36jLDwt+BeNQyBUsWZQ/X0tcmIebTw/E9U
	 aVV6KA+GAnRHC10my9qHaHTRstRTBSD8dW6oLM1GoPMFE2BhLQBO5vyPCezZzQ2dnZ
	 +oDU45jvPEjKOX5qC77au6BuHcBFxOH7cNEDQIboSQbRKzACVfaJKensFd8+PzY6Z3
	 bD2+bzGtuFPaTXfmMiJXEtpXafSuwz1KoCLyUgJNkPH7DiwWDFJ9uz/IkGg8gpf4ta
	 g7Q+Mnthdgki4eFXTeWepnFh4HvsyZ/yYE8EG2Uij/iTGTHjMMoL9qSrfwU2vRA1R0
	 J6Xt04LlfhfPA==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 17/43] arm64: RME: Allow VMM to set RIPAS
In-Reply-To: <4075a8bc-2f1e-441d-815e-aaf83e88d3d0@arm.com>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-18-steven.price@arm.com>
 <4075a8bc-2f1e-441d-815e-aaf83e88d3d0@arm.com>
Date: Wed, 30 Oct 2024 13:22:00 +0530
Message-ID: <yq5afroec9jz.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> Hi Steven
>
>
>> +	if (WARN_ON(rmi_granule_undelegate(phys))) {
>> +		/* Undelegate failed: leak the page */
>> +		return;
>> +	}
>> +
>> +	free_page((unsigned long)phys_to_virt(phys));
>
> The above pattern of undelegate and reclaim a granule or leak appears 
> elsewhere in the KVM support code. Is it worth having a common helper to
> do the same ?
>
> something like: reclaim_delegated_granule()
>

free_delegated_page() which should really be renamed to
free_delegated_granule() essentially does that.

IMHO we should convert all the delgated allocation and free to
alloc_delegated_granule() and free_delegated_granule(). This will also
help in switching to a slab for granule allocation. 

>
>
>> +}
>> +
>> +static int realm_rtt_create(struct realm *realm,
>> +			    unsigned long addr,
>> +			    int level,
>> +			    phys_addr_t phys)
>> +{
>> +	addr = ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
>> +	return rmi_rtt_create(virt_to_phys(realm->rd), phys, addr, level);
>> +}

.......

>> +static void realm_unmap_range_private(struct kvm *kvm,
>> +				      unsigned long start,
>> +				      unsigned long end)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	ssize_t map_size = RME_PAGE_SIZE;
>> +	unsigned long next_addr, addr;
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		int ret;
>> +
>> +		next_addr = ALIGN(addr + 1, map_size);
>> +

Is that next_addr update needed? 


>> +		ret = realm_destroy_protected(realm, addr, &next_addr);
>> +
>> +		if (WARN_ON(ret))
>> +			break;
>

