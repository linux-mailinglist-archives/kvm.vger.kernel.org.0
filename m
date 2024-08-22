Return-Path: <kvm+bounces-24828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68AC695B94D
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 17:07:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 982341C20B52
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 15:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 912A51CCB3C;
	Thu, 22 Aug 2024 15:06:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B506C1CC89B;
	Thu, 22 Aug 2024 15:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724339185; cv=none; b=lFVpbtUohBcPy+Tc5D9lsTuWkLn2eGwFSuNXowWi4jGtiyg7zGpGjJVBjjS6HxXrFEh2Ut/yrMMYlNBQHJhlo+dwg4wqFZVwP5n9FFSic7u0zpUNsBJu1pTaxbwk8y7EE91qiqy1hD5C9lfCzRr9uaL0y6pXNuIyvzW06ZD4k5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724339185; c=relaxed/simple;
	bh=QCgSudnWYAHAbhwqPzcmGR64pvLJdT3jGrGJ7AS7PPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BDe3WhN4OJw3dt0tDh2YRow0tXrHIW2yUfJ6XP47MHBrhrEYi2gNwckRpg95oS8bghGyumaGFBAF90Zwj5TN0d8SpUwoofgFcSCu9vp4fdEgvlKDJpFFeGGQ/tXy6JGOoGhjtdwPoZO4g4n+cWNNJh1E4ThqaekTrQJMvGcykDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51FF5DA7;
	Thu, 22 Aug 2024 08:06:49 -0700 (PDT)
Received: from [10.57.85.214] (unknown [10.57.85.214])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 608E83F58B;
	Thu, 22 Aug 2024 08:06:18 -0700 (PDT)
Message-ID: <282a765a-3b42-4175-8d9f-58456d13a37d@arm.com>
Date: Thu, 22 Aug 2024 16:06:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/43] arm64: RME: Handle realm enter/exit
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-19-steven.price@arm.com> <yq5a34mx2of7.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5a34mx2of7.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/08/2024 05:04, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
> ....
> 
>> +static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct realm *realm = &kvm->arch.realm;
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +	unsigned long base = rec->run->exit.ripas_base;
>> +	unsigned long top = rec->run->exit.ripas_top;
>> +	unsigned long ripas = rec->run->exit.ripas_value & 1;
>> +	unsigned long top_ipa;
>> +	int ret = -EINVAL;
>> +
>> +	if (realm_is_addr_protected(realm, base) &&
>> +	    realm_is_addr_protected(realm, top - 1)) {
>> +		kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
>> +					   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
>> +		write_lock(&kvm->mmu_lock);
>> +		ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
>> +		write_unlock(&kvm->mmu_lock);
>> +	}
>> +
>> +	WARN(ret && ret != -ENOMEM,
>> +	     "Unable to satisfy SET_IPAS for %#lx - %#lx, ripas: %#lx\n",
>> +	     base, top, ripas);
>> +
>> +	/* Exit to VMM to complete the change */
>> +	kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false, false,
>> +				      ripas == 1);
>> +
>> +	return 0;
>> +}
>> +
> 
> arch/arm64/kvm/rme-exit.c:100:6: warning: variable 'top_ipa' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
>         if (realm_is_addr_protected(realm, base) &&
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/arm64/kvm/rme-exit.c:114:44: note: uninitialized use occurs here
>         kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false, false,
>                                                   ^~~~~~~

I'm not sure why I didn't notice this before, if the condition is false
then we're hitting the WARN (i.e. this shouldn't happen), but I should
fix that up to handle the situation better.

Steve


