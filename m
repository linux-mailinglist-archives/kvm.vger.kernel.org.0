Return-Path: <kvm+bounces-29173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 433139A3FA4
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 15:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C2EA1C23449
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 13:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56491D9665;
	Fri, 18 Oct 2024 13:30:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549FCF9F8;
	Fri, 18 Oct 2024 13:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729258220; cv=none; b=YwV8dmHcH0wakD8S9HDWHoV0tJUgFGWOEwB+ulw0BYSkwc8OWmU0woo4dsA3CG3FS0f5rr4Cq4pef4o1SZsXYSsYu76WCQIp6Lds1bSmHljP5te/tt4leTatOL5liFbxul6GMvRFLZWplvKRs9V2rYlrIE7GFvC3oQgmB/Zc6xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729258220; c=relaxed/simple;
	bh=4cb3B3QHewrPYGrjaGWu1ULVYo4OSiASJENbHyPgKyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vF18A2+TNcxu8t99dV2FwtcnWGUlgGhjNCxrVF65wt1NXufvtbaMx9Yucpp7ARfG2ASnCEfdXpZr5Lnayv6AupXBO1smnHIWt8/EwPrIGPTT+82tWzu/BPbWd2b5QHV4MI6LI1A5uEGXIlZOW4Ki7VS/Z09lJU7j2Q4DiZMieRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 332DFFEC;
	Fri, 18 Oct 2024 06:30:47 -0700 (PDT)
Received: from [10.57.64.219] (unknown [10.57.64.219])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AAD373F528;
	Fri, 18 Oct 2024 06:30:14 -0700 (PDT)
Message-ID: <7ca207aa-4433-4e9b-8cd2-e025bb265796@arm.com>
Date: Fri, 18 Oct 2024 14:30:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 31/43] arm64: rme: Prevent Device mappings for Realms
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-32-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004152804.72508-32-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/10/2024 16:27, Steven Price wrote:
> Physical device assignment is not yet supported by the RMM, so it
> doesn't make much sense to allow device mappings within the realm.
> Prevent them when the guest is a realm.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/mmu.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 4f0403059c91..602c49eae90d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1142,6 +1142,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   	if (is_protected_kvm_enabled())
>   		return -EPERM;
>   
> +	/* We don't support mapping special pages into a Realm */
> +	if (kvm_is_realm(kvm))
> +		return -EINVAL;
> +

I believe this is not sufficient. This is only called for GICv2 today.
But we also need to check in  user_mem_abort() and only allow the
mapping if it targeting an unprotected IPA.

Something like:

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 26d550ad8393..e433bf8376f2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1710,6 +1710,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, 
phys_addr_t fault_ipa,
         if (exec_fault && device)
                 return -ENOEXEC;

+       if (device && kvm_gpa_from_fault(fault_ipa) != fault_ipa)
+               return -EINVAL;
+
         /*
          * Potentially reduce shadow S2 permissions to match the 
guest's own
          * S2. For exec faults, we'd only reach this point if the guest



Suzuki


>   	size += offset_in_page(guest_ipa);
>   	guest_ipa &= PAGE_MASK;
>   


