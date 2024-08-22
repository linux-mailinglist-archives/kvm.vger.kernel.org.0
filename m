Return-Path: <kvm+bounces-24830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33D5E95B9CB
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 17:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9BDB287DED
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 15:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B981CCB37;
	Thu, 22 Aug 2024 15:14:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D471CB31B;
	Thu, 22 Aug 2024 15:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724339666; cv=none; b=ZgKvT8hf1c6dQEqftfFPibH7V8g2kKlPGdkBYEaCAWfmT8ioaWgTRN8aZ8RbzrPoEr8welU22OMMsPt9thhc6CM80T61yuz7JIH4OkPiSWUm2pTxSA24ZTjKP4ZsGmO6lqP0IS+IHuL7VdRjTou8iqOJHugo6tBYW1dhRcWcWZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724339666; c=relaxed/simple;
	bh=Z0x+iQbZGRupwKlqBCAsGrzbaayYp2vs4jBrbc+BHTI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JLuWTz7M/AUMSM5kQDyeisdZsXE/dSa7EOJWYZ+HwpiD7MbsN7noVWuxY3+ASZadiJuLq0uo65LOyB45yf2W5bx81bg8Ce0mUJYkWFlmapROmwT6KX+6K/HQ45FL7Np5QJH7WdbGmqNWJZAk1p+pAY/s7IAYlkzTqFyoz6kv38Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB36F169E;
	Thu, 22 Aug 2024 08:14:50 -0700 (PDT)
Received: from [10.57.85.214] (unknown [10.57.85.214])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 58C693F58B;
	Thu, 22 Aug 2024 08:14:20 -0700 (PDT)
Message-ID: <8c0f787c-35d4-4cb1-84d3-ff3f2e3f003a@arm.com>
Date: Thu, 22 Aug 2024 16:14:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 21/43] arm64: RME: Runtime faulting of memory
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
 <20240821153844.60084-22-steven.price@arm.com> <yq5afrqx2pxr.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5afrqx2pxr.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/08/2024 04:32, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> At runtime if the realm guest accesses memory which hasn't yet been
>> mapped then KVM needs to either populate the region or fault the guest.
>>
>> For memory in the lower (protected) region of IPA a fresh page is
>> provided to the RMM which will zero the contents. For memory in the
>> upper (shared) region of IPA, the memory from the memslot is mapped
>> into the realm VM non secure.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v2:
>>  * Avoid leaking memory if failing to map it in the realm.
>>  * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>>  * Adapt to changes in previous patches.
>>
> 
> ....
> 
>> -	gfn = ipa >> PAGE_SHIFT;
>> +	gfn = (ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>>  	memslot = gfn_to_memslot(vcpu->kvm, gfn);
>> +
>> +	if (kvm_slot_can_be_private(memslot)) {
>> +		ret = private_memslot_fault(vcpu, fault_ipa, memslot);
>> +		if (ret != -EAGAIN)
>> +			goto out;
>> +	}
>>
> 
> Shouldn't this be s/fault_ipa/ipa ?

Well they should both be the same unless we're in some scary parallel
universe where we have nested virtualisation *and* realms at the same
time (shudder!). But yes "ipa" would be more consistent so I'll change it!

Steve

> 	ret = private_memslot_fault(vcpu, ipa, memslot);
> 
> -aneesh


