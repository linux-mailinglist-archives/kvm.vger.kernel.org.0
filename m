Return-Path: <kvm+bounces-23609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5719594BA23
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 11:55:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A0291F2274B
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 09:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B1618A6AF;
	Thu,  8 Aug 2024 09:54:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC6B146A93;
	Thu,  8 Aug 2024 09:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723110878; cv=none; b=fBKK+tXv17zcBPpDrsPUpcX+mWzI8KZ2lMMDrSWCelukeYOqBSGwbrcsWcCC1ZdIB9OGL68YgiiGx2OxwUd6YXrwzYECT3Ytz1NkgifZbGOu/v3o+3W374cPO327p81n8SMU9HZjgvmy4t6CdQHRqAccin4FgC+0HgFyOQW2Mc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723110878; c=relaxed/simple;
	bh=kYdZ12KYr52wq3EuDfSIsj0fkppY2ClttYsU/ZJzhBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ELqOt1eih26snA3vEITDbpgzl6/Wt38Yd38YqCLj9BPvgUMKQDMOCJbJOBEi98s1+eXBb5qLlv56LqLunwZnkOYpfRuS5iAsLVfWzgxGhx7kLgqHE8qkoLO6aSrrpPWUDICR+UXkS7DqOHkDia8a5xqt78ECjJX0VLmdvqgVAxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA0441042;
	Thu,  8 Aug 2024 02:55:01 -0700 (PDT)
Received: from [10.1.26.21] (e122027.cambridge.arm.com [10.1.26.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A95173F6A8;
	Thu,  8 Aug 2024 02:54:29 -0700 (PDT)
Message-ID: <fbcbd4da-cab5-420e-b8b6-bf04e27bf69c@arm.com>
Date: Thu, 8 Aug 2024 10:54:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 02/84] KVM: arm64: Disallow copying MTE to guest
 memory while KVM is dirty logging
To: Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-3-seanjc@google.com> <ZrOfB8bOdSJVcWFr@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ZrOfB8bOdSJVcWFr@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 07/08/2024 17:21, Catalin Marinas wrote:
> On Fri, Jul 26, 2024 at 04:51:11PM -0700, Sean Christopherson wrote:
>> Disallow copying MTE tags to guest memory while KVM is dirty logging, as
>> writing guest memory without marking the gfn as dirty in the memslot could
>> result in userspace failing to migrate the updated page.  Ideally (maybe?),
>> KVM would simply mark the gfn as dirty, but there is no vCPU to work with,
>> and presumably the only use case for copy MTE tags _to_ the guest is when
>> restoring state on the target.
>>
>> Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>  arch/arm64/kvm/guest.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index e1f0ff08836a..962f985977c2 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -1045,6 +1045,11 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>>  
>>  	mutex_lock(&kvm->slots_lock);
>>  
>> +	if (write && atomic_read(&kvm->nr_memslots_dirty_logging)) {
>> +		ret = -EBUSY;
>> +		goto out;
>> +	}
> 
> There are ways to actually log the page dirtying but I don't think
> it's worth it. AFAICT, reading the tags still works and that's what's
> used during migration (on the VM where dirty tracking takes place).
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 

Looks sensible to me - my initial thought was "why would a VMM do
that?". But it would make sense to actually return a failure rather than
letting the VMM shoot itself in the foot.

If there's actually a use-case then we could look at making the dirty
tracking work, but I'm not convinced there is a good reason.

Reviewed-by: Steven Price <steven.price@arm.com>

Thanks,

Steve

