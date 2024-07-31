Return-Path: <kvm+bounces-22804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2E79943666
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 21:28:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 669711F277E2
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB0F14A0AE;
	Wed, 31 Jul 2024 19:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="QihTxrdq"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5E9149C51;
	Wed, 31 Jul 2024 19:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454068; cv=none; b=R5n2o2ACAZqLUHS2V3R/XjqGmLg+K/13ogOjuN0XN9GH61SofSWk2Mg5fBr9RPYzAPBrfYelSx9SV+naboeaEQ8zRFq0ODk0uusEkBls17rfAvTVc2fQDqpsQS9Cw6i9FwrXTDhl4eZdaLdmf2buQVAHeyj1IXESo5OhaJjCBSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454068; c=relaxed/simple;
	bh=Mhx8E0fT9obAxJYSTGJ2xXP2P1OHW/oSmyU+JnM5NMI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=mDlBjFBWzABfcexKUgcS1n402IImIqQMat9mRfm0yV6/nHAcF1pOvSSlPp9yfGQb+a5f+TvT0nHHE6Db87pzAsdW87/INx2nOPJ5NztEAsi6KG2+Ez/oImZPlszvq3rIIr1EBJCZh31jCSTHi2PNcQ3YluXbMJbkSLjLmlGi0kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=QihTxrdq; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1sZEz2-008LM1-1t; Wed, 31 Jul 2024 21:27:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
	Cc:To:Subject:From:MIME-Version:Date:Message-ID;
	bh=5cZZTTx5MpJgwdaoTjtIaSNaIM4FcBhy+Kr0FE1iKtU=; b=QihTxrdqEswI3MLvYwAESwnzUX
	jI9p+Z15WK/vcr4r0tVB3W+ejqL80bbMyrIlGLL90Uw9BVR9tgV3acAkPXyLsH8S8354Izgw5Knc2
	8k3fDR3N5MSaxcTeFoKF9uLBbJ3h5rW06BThrMvrUBRQ+7qGCQlawvxcXm61ROfSSDIb4GZxyJqyk
	MtYKJEheuwNKg6wo5Vr03SvT+ogdL9dXn9ZPRl6Q0ss26/RiQB+ef0GuEUPN/kitutvbkCKcaAmgu
	vz+nvONjMVcSFBlmgvXKpWPD4zVbqOrgcKE01nnk/+H4EA65QQg16sr1mLAQ5k2LUQmcH4laK/g9d
	BU3iPZ7w==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1sZEz1-0005EC-Ju; Wed, 31 Jul 2024 21:27:35 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1sZEyj-004luM-V7; Wed, 31 Jul 2024 21:27:18 +0200
Message-ID: <9c77a7f7-4932-498a-ac51-65a5e755c926@rbox.co>
Date: Wed, 31 Jul 2024 21:27:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH] KVM: Fix error path in kvm_vm_ioctl_create_vcpu() on
 xa_store() failure
To: Sean Christopherson <seanjc@google.com>
Cc: Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>
References: <20240730155646.1687-1-will@kernel.org>
 <ccd40ae1-14aa-454e-9620-b34154f03e53@rbox.co> <Zql3vMnR86mMvX2w@google.com>
 <20240731133118.GA2946@willie-the-truck>
 <3e5f7422-43ce-44d4-bff7-cc02165f08c0@rbox.co> <Zqpj8M3xhPwSVYHY@google.com>
Content-Language: pl-PL, en-GB
In-Reply-To: <Zqpj8M3xhPwSVYHY@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/24 18:18, Sean Christopherson wrote:
> On Wed, Jul 31, 2024, Michal Luczaj wrote:
>> On 7/31/24 15:31, Will Deacon wrote:
>>> On Tue, Jul 30, 2024 at 04:31:08PM -0700, Sean Christopherson wrote:
>>>> On Tue, Jul 30, 2024, Michal Luczaj wrote:
>>>>> On 7/30/24 17:56, Will Deacon wrote:
>>>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>>>> index d0788d0a72cc..b80dd8cead8c 100644
>>>>>> --- a/virt/kvm/kvm_main.c
>>>>>> +++ b/virt/kvm/kvm_main.c
>>>>>> @@ -4293,7 +4293,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>>>>>>  
>>>>>>  	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
>>>>>>  		r = -EINVAL;
>>>>>> -		goto kvm_put_xa_release;
>>>>>> +		goto err_xa_release;
>>>>>>  	}
>>>>>>  
>>>>>>  	/*
>>>>>> @@ -4310,6 +4310,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>>>>>>  
>>>>>>  kvm_put_xa_release:
>>>>>>  	kvm_put_kvm_no_destroy(kvm);
>>>>>> +err_xa_release:
>>>>>>  	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
>>>>>>  unlock_vcpu_destroy:
>>>>>>  	mutex_unlock(&kvm->lock);
>>>>>
>>>>> My bad for neglecting the "impossible" path. Thanks for the fix.
>>>>>
>>>>> I wonder if it's complete. If we really want to consider the possibility of
>>>>> this xa_store() failing, then keeping vCPU fd installed and calling
>>>>> kmem_cache_free(kvm_vcpu_cache, vcpu) on the error path looks wrong.
>>>>
>>>> Yeah, the vCPU is exposed to userspace, freeing its assets will just cause
>>>> different problems.  KVM_BUG_ON() will prevent _new_ vCPU ioctl() calls (and kick
>>>> running vCPUs out of the guest), but it doesn't interrupt other CPUs, e.g. if
>>>> userspace is being sneaking and has already invoked a vCPU ioctl(), KVM will hit
>>>> a use-after-free (several of them).
>>>
>>> Damn, yes. Just because we haven't returned the fd yet, doesn't mean
>>> userspace can't make use of it.
>>>
>>>> As Michal alluded to, it should be impossible for xa_store() to fail since KVM
>>>> pre-allocates/reserves memory.  Given that, deliberately leaking the vCPU seems
>>>> like the least awful "solution".
>>>
>>> Could we actually just move the xa_store() before the fd creation? I
>>> can't immediately see any issues with that...
>>
>> Hah, please see commit afb2acb2e3a3 :) Long story short: create_vcpu_fd()
>> can legally fail, which must be handled gracefully, which would involve
>> destruction of an already xa_store()ed vCPU, which is racy.
> 
> Ya, the basic problem is that we have two ways of publishing the vCPU, fd and
> vcpu_array, with no way of setting both atomically.  Given that xa_store() should
> never fail, I vote we do the simple thing and deliberately leak the memory.

I agree it's a good idea. So for a failed xa_store(), just drop the goto?

