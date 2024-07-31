Return-Path: <kvm+bounces-22795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F5659433AA
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9958281FDE
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE7B71BBBE4;
	Wed, 31 Jul 2024 15:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="a3OQejXc"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9CC1AB52E
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722440968; cv=none; b=M3XdEC4llHMrEfVwxatfNBNFfoTeF6heY+J68QNAWwXWgyBhunHwZXOn9Okzj9ksK1uvnEm80QfdkV9UmBxOgeQVBvE8RL6knaA5dzp4o3nHKDfGai77ZIAQiaW8e0tf529OeRWqPLYwS9uF9uDHBhamxiinL4OGrmksAFeN4o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722440968; c=relaxed/simple;
	bh=dML7zIR/iIrrvce3R5fLZkpzcyFaCTlB1LwYBvCdmxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B6rz2rSvvmiv2rLmqdU0mje9VEQq4OH0ZswpNOzwc9Ep5J87lAg67l59vGQOqjvJvDccjoivuCpsWwFoJ6X+kIBgGz0vFCZEtUA2sRgpe3PXAjhRcvcazXhpFQwgFG7uIh4Kpg0Aj/vEACEKeOcLnqWyw57cHLFINZwqWmP6E8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=a3OQejXc; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1sZBZk-009vnu-NM; Wed, 31 Jul 2024 17:49:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=LDF8SRpiYX+WkqTCMqtuLenSjw3Fxaj9kZobz5wYA/E=; b=a3OQejXc1E2KOBOirp7mnSi60+
	VDSxuwnV/1kmKtK9qqoZi4S2qWHyzWKA9i34fHKsN1NZWHoEfiGd6PpfNm0WV3prcGv4GMw+lWq2h
	3b6DuAekT0mXBdPaLXCowMECPfR/QaPyZVGrufj7I8JvLTzreRJkUbNjPrW+pM3UJ8eUrG/27kYrk
	UerL//yZbDrX3bDglRxve5a0bRLnfQTaz7tg4P6hXnZjYzIgpnlnXO62YY2gH1bzpJkCvJXxLQROc
	gqsIWvhYs8oLCDz8t+s5J4fJGbLaZ1zzTjPspWDzA3RZ1PKfbvfok/yxRw0ZzMVdcwZLFUX6m6yUt
	ViGQsSYw==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1sZBZk-0007OP-81; Wed, 31 Jul 2024 17:49:16 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1sZBZX-004Gdh-W4; Wed, 31 Jul 2024 17:49:04 +0200
Message-ID: <3e5f7422-43ce-44d4-bff7-cc02165f08c0@rbox.co>
Date: Wed, 31 Jul 2024 17:49:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Fix error path in kvm_vm_ioctl_create_vcpu() on
 xa_store() failure
To: Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko
 <glider@google.com>, Marc Zyngier <maz@kernel.org>
References: <20240730155646.1687-1-will@kernel.org>
 <ccd40ae1-14aa-454e-9620-b34154f03e53@rbox.co> <Zql3vMnR86mMvX2w@google.com>
 <20240731133118.GA2946@willie-the-truck>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <20240731133118.GA2946@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/24 15:31, Will Deacon wrote:
> On Tue, Jul 30, 2024 at 04:31:08PM -0700, Sean Christopherson wrote:
>> On Tue, Jul 30, 2024, Michal Luczaj wrote:
>>> On 7/30/24 17:56, Will Deacon wrote:
>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>> index d0788d0a72cc..b80dd8cead8c 100644
>>>> --- a/virt/kvm/kvm_main.c
>>>> +++ b/virt/kvm/kvm_main.c
>>>> @@ -4293,7 +4293,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>>>>  
>>>>  	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
>>>>  		r = -EINVAL;
>>>> -		goto kvm_put_xa_release;
>>>> +		goto err_xa_release;
>>>>  	}
>>>>  
>>>>  	/*
>>>> @@ -4310,6 +4310,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>>>>  
>>>>  kvm_put_xa_release:
>>>>  	kvm_put_kvm_no_destroy(kvm);
>>>> +err_xa_release:
>>>>  	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
>>>>  unlock_vcpu_destroy:
>>>>  	mutex_unlock(&kvm->lock);
>>>
>>> My bad for neglecting the "impossible" path. Thanks for the fix.
>>>
>>> I wonder if it's complete. If we really want to consider the possibility of
>>> this xa_store() failing, then keeping vCPU fd installed and calling
>>> kmem_cache_free(kvm_vcpu_cache, vcpu) on the error path looks wrong.
>>
>> Yeah, the vCPU is exposed to userspace, freeing its assets will just cause
>> different problems.  KVM_BUG_ON() will prevent _new_ vCPU ioctl() calls (and kick
>> running vCPUs out of the guest), but it doesn't interrupt other CPUs, e.g. if
>> userspace is being sneaking and has already invoked a vCPU ioctl(), KVM will hit
>> a use-after-free (several of them).
> 
> Damn, yes. Just because we haven't returned the fd yet, doesn't mean
> userspace can't make use of it.
>
>> As Michal alluded to, it should be impossible for xa_store() to fail since KVM
>> pre-allocates/reserves memory.  Given that, deliberately leaking the vCPU seems
>> like the least awful "solution".
> 
> Could we actually just move the xa_store() before the fd creation? I
> can't immediately see any issues with that...

Hah, please see commit afb2acb2e3a3 :) Long story short: create_vcpu_fd()
can legally fail, which must be handled gracefully, which would involve
destruction of an already xa_store()ed vCPU, which is racy.


