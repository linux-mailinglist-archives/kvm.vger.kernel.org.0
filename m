Return-Path: <kvm+bounces-11711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F1DC87A159
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 03:07:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DECD8283793
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 02:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E7D6101C1;
	Wed, 13 Mar 2024 02:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="zXj8LJnX"
X-Original-To: kvm@vger.kernel.org
Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F58D51B;
	Wed, 13 Mar 2024 02:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295653; cv=none; b=Dj9HnS4lJF2jQVPhhb+DgbS5UJfY5b6WXdGlnxGj3YpV78sxK8MAECIarjsO/Ll2KDjy3mY8jYjsLrt4ztKJu1s/rd3EVSr/VfPSrVKaynNoGA87Ug8LWK5GrIG0T2pnm4RgBxRSzzNw9B71NHGCY9bp/8RmBjWxj+J9C0S9+/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295653; c=relaxed/simple;
	bh=gKwwcvUxoUfiRZgtmQ2NL3a3X4Bit9aEPZb/w5hi4Kw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iXjw/IGniN/dfg0u3hEZ8ABRphBBiYBShmCqrSSiGOAFdIiweeZ9oTNFWdkmV3pUG5g9Yqd/gHUL1sNEh8XCc6bfh57xKZFqzodP3NOEsng/scTOV1pYjeVaubBjx8lULS5nyFkiuwpyOJx1hIuINuJWo2uLZoNpaRyEAKx2e0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=zXj8LJnX; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1710295640;
	bh=XFmy5qLFjf2ks+5NUTUH+n2hvFSsq9w+oqbAfXiCgEw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=zXj8LJnXvd7ntd71Jpb0DG83WNa85l/b9bdtyvYwPGWQfkL3b+sVRrwXPTEO6fRIW
	 xayHJ2CCAJrek33vCXv2G89vK0+XjQQmn+K6SNXuU/bhSYZM2gZGBHsaHGdoAbPayw
	 6o95DlD9eCV1fDeT+n4EdFtjaoHmwBb4XN09e9/I=
Received: from [172.17.78.110] ([58.208.182.212])
	by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
	id 4F08A3D; Wed, 13 Mar 2024 10:01:15 +0800
X-QQ-mid: xmsmtpt1710295275t00qd39pu
Message-ID: <tencent_DDDFB09AF2B2DC73F9570E5A02D929004609@qq.com>
X-QQ-XMAILINFO: MR/iVh5QLeieDm8r7gyCqMZkbJNGCHLkFir2u0+j1lEOROSGz/03/07Lvs3KuN
	 y4tscX5UYggiqcgKQvpdkDjQPyz0mcMw+aqjms661Ixbki+Gb3UN+6+bLMNWTuj8/UhzFjgZr3XK
	 OKiCjfLsiwJqjneHLY8fwexbH9EjT2PeCNa7Qawv3gxsJW/zSimhWCikZOsFzk3r+8W3OIbKR8ko
	 TjjeiOoQJHnzSbdU4jfs7DkiyPN6kP4xB2yI24YU0+JX6qB9ej6nWDx+WE4v51o4/fH0Vq0814be
	 01GfIfffZmio5y65cvQK6Rre/Uklns0/bRJafZcbkWR1lkMZ5f8TYgoLZTxsw5x8PC/mzAyVRv2T
	 RtXPVu1nUMfvtGiRRDMn9D/bieUgyuLkCPLeJgo5kno7Ugx0ol7jh7FSh9s1MtWYvn9YDO4vayW0
	 G1qRq6T4coN6hwfP5/OXy+SG81eD5E3AwMl5GPDXV+tfYKri9mB7Y3HNBq1rfhWzGa8f/3WJFnh6
	 QglGrQ3lP7prXkd2iPKbLmqLdPBdN0ncPIrSoC2hw4P5hTnURryw7G8OOIyNg/KF18GKMoOw3o81
	 F/HSTfdJ+3USvIMYvosUaN7BlivdvSH/aX+5HUJnIRjE5+SXEF7zI7YgmxWAwrp6JJag5xKuLH22
	 n1wpwx/6A8WMUAL8pOM0ZPKZ+3OnxzUVGkGN6WjxbdlO0A8h22WVXQaI6aTLXyh3EoNf/UxiwkF4
	 bdhSNTEY/bnqkvKX/V0U1+RCpQUxyYbF15YGgTkA4N/HLzzKJhig3UN6obX/e1REz1X/FIgaEny4
	 mx6Dj/sC2uM1NVEDT9J08A7DF0K3TLd99m8jVacqT3F3fjSfsnIMrBNlhrVLK0RJ+Ri1NuIHuEsD
	 rRT7CK5JR206JdN3DU66xVrLcyZTkjRr/sAenV5rGU91uHXu9FlrNRn5epe9CMi8Hf2pPq/dbZH/
	 pS/A6Jbox9QXpBZMnUjEio1AT3DPpL6rFcGG1iuXQ=
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-OQ-MSGID: <1cffd0fd-c8a1-4e12-b2c9-42ace78c44ed@foxmail.com>
Date: Wed, 13 Mar 2024 10:01:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/mmu: treat WC memory as MMIO
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, rdunlap@infradead.org, akpm@linux-foundation.org,
 bhelgaas@google.com, mawupeng1@huawei.com, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com, kvm@vger.kernel.org
References: <tencent_4B50D08D2E6211E4F9B867F0531F2C05BA0A@qq.com>
 <Ze8vM6HcU4vnXVSS@google.com>
 <tencent_AA5D14EAA36D58807959EE9AFC9E07548108@qq.com>
 <ZfBzBUbxpF9MpII-@google.com>
From: francisco flynn <francisco_flynn@foxmail.com>
In-Reply-To: <ZfBzBUbxpF9MpII-@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/3/12 23:21, Sean Christopherson wrote:
> On Tue, Mar 12, 2024, francisco flynn wrote:
>> On 2024/3/12 00:20, Sean Christopherson wrote:
>>> On Mon, Mar 11, 2024, francisco_flynn wrote:
>>>> when doing kvm_tdp_mmu_map for WC memory, such as pages
>>>> allocated by amdgpu ttm driver for ttm_write_combined
>>>> caching mode(e.g. host coherent in vulkan),
>>>> the spte would be set to WB, in this case, vcpu write
>>>> to these pages would goes to cache first, and never
>>>> be write-combined and host-coherent anymore. so
>>>> WC memory should be treated as MMIO, and the effective
>>>> memory type is depending on guest PAT.
>>>
>>> No, the effective memtype is not fully guest controlled.  By forcing the EPT memtype
>>> to UC, the guest can only use UC or WC.  I don't know if there's a use case for
>>
>> Well,it's actually the host mapping memory WC and guest uses WC,
> 
> No, when the guest is running, the host, i.e. KVM, sets the EPT memory type to UC
> 
>   static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>   {
> 	if (is_mmio)
> 		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
> 
> which effectively makes the guest "MTRR" memtype UC, and thus restricts the guest
> to using UC or WC.
> 
> Your use case wants to map the memory as WC in the guest, but there are zero
> guarantees that *every* use case wants to access such memory as WC (or UC),
> i.e. forcing UC could cause performance regressions for existing use cases.
> 

yes, this may cause performance regressions in some cases.

> Ideally, KVM would force the EPT memtype to match the host PAT memtype while still
> honoring guest PAT, but if we wanted to go that route, then KVM should (a) stuff
> the exact memtype, (b) stuff the memtype for all of guest memory, and (c) do so
> for all flavors of KVM on x86, not just EPT on VMX.
> 

it's true.

> Unfortunatley, making that change now risks breaking 15+ years of KVM ABI.  And
> there's also the whole "unsafe on Intel CPUs without self-snoop" problem.
> 
>> one use case is virtio-gpu host blob, which is to map physical GPU buffers into guest
>>
>>> the host mapping memory WC while the guest uses WB, but it should be a moot point,
>>> because this this series should do what you want (allow guest to map GPU buffers
>>> as WC).
>>>
>>> https://lore.kernel.org/all/20240309010929.1403984-1-seanjc@google.com
>>>
>>
>> yes, this is what i want, but for virtio-gpu device, if we mapping WC typed 
>> GPU buffer into guest, kvm_arch_has_noncoherent_dma would return false, 
>> so on cpu without self-snoop support, guest PAT will be ignored, the effective
>> memory type would be set to WB, causing data inconsistency.
> 
> My understanding is that every Intel CPU released in the last 8+ years supports
> self-snoop.  See check_memory_type_self_snoop_errata().
> 
> IMO, that's a perfectly reasonable line to draw: if you want virtio-gpu support,
> upgrade to Ivy Bridge or later.

it make sense.


