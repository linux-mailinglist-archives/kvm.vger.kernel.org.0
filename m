Return-Path: <kvm+bounces-25686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B16C968B21
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 17:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F414E1F22E12
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 15:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68281A304F;
	Mon,  2 Sep 2024 15:34:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BE51A3036;
	Mon,  2 Sep 2024 15:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725291268; cv=none; b=LuMw+R+RANcOi9i6bvXsYbX7+otRcu6mBYC7nTJww23HTvDkbJ4rCIwNEPuXqorWTKh1pu8fh49QkeDSjpHS49mYe5Kzr4mIUXgvsc07szvJVO3bqDgJ2wIo0Ea4PJ0laB1OLgmoL/idzPiXprC2JyQERiRy6+aC4wumeK0hQU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725291268; c=relaxed/simple;
	bh=Iq6BZepIjitU0fA1+TlY/XI2FSZ7xGvsxpctHbhevlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lFR4HoRp1tIySpuSQXeV2dxFrMUrrsSGAdAiBx7bXvlrKJET73p3xvRe1PLh4thPQU/vHwPKFDiuWDM2fHESe6EXsyPaHJ9vJuWNxHLOM0gsX62aAikdkCDm+DeKWV1oLqyfm0k+GBMWUb82qJW7Pe+Eg+fLLXFh2D7SWBCQpqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65DC4FEC;
	Mon,  2 Sep 2024 08:34:52 -0700 (PDT)
Received: from [10.57.74.147] (unknown [10.57.74.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E373B3F66E;
	Mon,  2 Sep 2024 08:34:21 -0700 (PDT)
Message-ID: <bdeb29af-b833-402d-b0b2-0db02335a0c3@arm.com>
Date: Mon, 2 Sep 2024 16:34:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 21/43] arm64: RME: Runtime faulting of memory
To: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <20240821153844.60084-22-steven.price@arm.com> <ZtW8rNIdpd1wTx7w@fedora>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ZtW8rNIdpd1wTx7w@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 02/09/2024 14:25, Matias Ezequiel Vara Larsen wrote:
> Hello Steven, 
> 
> On Wed, Aug 21, 2024 at 04:38:22PM +0100, Steven Price wrote:

...

>> +static int private_memslot_fault(struct kvm_vcpu *vcpu,
>> +				 phys_addr_t fault_ipa,
>> +				 struct kvm_memory_slot *memslot)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(kvm);
>> +	gfn_t gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>> +	bool is_priv_gfn = !((fault_ipa & gpa_stolen_mask) == gpa_stolen_mask);
>> +	bool priv_exists = kvm_mem_is_private(kvm, gfn);
>> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>> +	kvm_pfn_t pfn;
>> +	int ret;
>> +
>> +	if (priv_exists != is_priv_gfn) {
>> +		kvm_prepare_memory_fault_exit(vcpu,
>> +					      fault_ipa & ~gpa_stolen_mask,
>> +					      PAGE_SIZE,
>> +					      kvm_is_write_fault(vcpu),
>> +					      false, is_priv_gfn);
>> +
>> +		return 0;
>> +	}
> 
> If I understand correctly, `kvm_prepare_memory_fault_exit()` ends up
> returning to the VMM with the KVM_EXIT_MEMORY_FAULT exit reason. The
> documentation says (https://docs.kernel.org/virt/kvm/api.html#kvm-run):
> 
> "Note! KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that
> it accompanies a return code of ‘-1’, not ‘0’! errno will always be set
> to EFAULT or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT,
> userspace should assume kvm_run.exit_reason is stale/undefined for all
> other error numbers."
> 
> Shall the return code be different for KVM_EXIT_MEMORY_FAULT?
> 
> Thanks, Matias.

Ah, good spot - I've no idea why KVM_EXIT_MEMORY_FAULT is special in
this regard, but yes I guess we should be returning -EFAULT here.

Thanks,
Steve


