Return-Path: <kvm+bounces-14608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 629148A4687
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 03:21:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93BF61C217AC
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 01:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A42F79E3;
	Mon, 15 Apr 2024 01:21:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E5B03FDB
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 01:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713144079; cv=none; b=WP0zD9ccksMr38BcdMUaY3Jck46c+zUWub2QOTGAJXJVTszPl8mJBfX8aXapJKqIndoQm/fbS5dFYHvudIHyXaOtBC9/mzb2A4GTvFrcP6U43COJaKinI01z/ccHR+cQVswykovNOfz4K+QpiCJWACiIHIrh/6Dw4QyFSKqE6PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713144079; c=relaxed/simple;
	bh=1R+mh8Jv1sFRmepZ7PHJk9678yy43jTJSkLExzJu+pE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KZjMUAeclze7Bwc3bMCqUIUI7zY+6zd+1dihwG2cS5fzNRMVBEkbX6BltMShQyMDwust23DSrsymf2KA01OdL86nrQpkxj9XJNCrzL8AI6B0WWNRFaOeloXs2hKraJuGBjoO+pKoknjSIRwlrI3C3ojCkdjAPiiNs5exkoiB9qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8AxiroCgRxmlIUnAA--.8657S3;
	Mon, 15 Apr 2024 09:21:06 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx_c79gBxmhQt7AA--.38940S3;
	Mon, 15 Apr 2024 09:21:03 +0800 (CST)
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during
 CLEAR_DIRTY_LOG
To: David Matlack <dmatlack@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20240402213656.3068504-1-dmatlack@google.com>
 <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
 <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com>
 <Zg7fAr7uYMiw_pc3@google.com>
 <be8f55c6-dd28-ba94-b64f-ed86de680902@loongson.cn>
 <CALzav=d=tZaa4rf67NQ0kYDs9R7wbCO-G0QeUvcLM+RUdPfAzg@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <1ef4344d-3653-c448-d75a-ea76798bee85@loongson.cn>
Date: Mon, 15 Apr 2024 09:21:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALzav=d=tZaa4rf67NQ0kYDs9R7wbCO-G0QeUvcLM+RUdPfAzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cx_c79gBxmhQt7AA--.38940S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJFWkJF13Jr15CFyUArWDtrc_yoWrury5pF
	Wrua4akFWYqryfZrnFq34kuw1F9w4xKrZ8Xr98KryxC390qr1fta17t3W09F93Jrn7W3Wj
	vF4Ut347u3WDAwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2-VyUUUUU



On 2024/4/13 上午12:12, David Matlack wrote:
> On Sat, Apr 6, 2024 at 7:26 PM maobibo <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2024/4/5 上午1:10, Sean Christopherson wrote:
>>> On Thu, Apr 04, 2024, David Matlack wrote:
>>>> On Tue, Apr 2, 2024 at 6:50 PM maobibo <maobibo@loongson.cn> wrote:
>>>>>> This change eliminates dips in guest performance during live migration
>>>>>> in a 160 vCPU VM when userspace is issuing CLEAR ioctls (tested with
>>>>>> 1GiB and 8GiB CLEARs). Userspace could issue finer-grained CLEARs, which
>>>>> Frequently drop/reacquire mmu_lock will cause userspace migration
>>>>> process issuing CLEAR ioctls to contend with 160 vCPU, migration speed
>>>>> maybe become slower.
>>>>
>>>> In practice we have not found this to be the case. With this patch
>>>> applied we see a significant improvement in guest workload throughput
>>>> while userspace is issuing CLEAR ioctls without any change to the
>>>> overall migration duration.
>>>
>>> ...
>>>
>>>> In the case of this patch, there doesn't seem to be a trade-off. We
>>>> see an improvement to vCPU performance without any regression in
>>>> migration duration or other metrics.
>>>
>>> For x86.  We need to keep in mind that not all architectures have x86's optimization
>>> around dirty logging faults, or around faults in general. E.g. LoongArch's (which
>>> I assume is Bibo Mao's primary interest) kvm_map_page_fast() still acquires mmu_lock.
>>> And if the fault can't be handled in the fast path, KVM will actually acquire
>>> mmu_lock twice (mmu_lock is dropped after the fast-path, then reacquired after
>>> the mmu_seq and fault-in pfn stuff).
>> yes, there is no lock in function fast_page_fault on x86, however mmu
>> spinlock is held on fast path on LoongArch. I do not notice this,
>> originally I think that there is read_lock on x86 fast path for pte
>> modification, write lock about page table modification.
> 
> Most[*] vCPU faults on KVM/x86 are handled as follows:
> 
> - vCPU write-protection and access-tracking faults are handled
> locklessly (fast_page_fault()).
> - All other vCPU faults are handled under read_lock(&kvm->mmu_lock).
> 
> [*] The locking is different when nested virtualization is in use, TDP
> (i.e. stage-2 hardware) is disabled, and/or kvm.tdp_mmu=N.
> 
>>>
>>> So for x86, I think we can comfortably state that this change is a net positive
>>> for all scenarios.  But for other architectures, that might not be the case.
>>> I'm not saying this isn't a good change for other architectures, just that we
>>> don't have relevant data to really know for sure.
>>   From the code there is contention between migration assistant thread
>> and vcpu thread in slow path where huge page need be split if memslot is
>> dirty log enabled, however there is no contention between migration
>> assistant thread and vcpu fault fast path. If it is right, negative
>> effect is small on x86.
> 
> Right there is no contention between CLEAR_DIRTY_LOG and vCPU
> write-protection faults on KVM/x86. KVM/arm64 does write-protection
> faults under the read-lock.
> 
> KVM/x86 and KVM/arm64 also both have eager page splitting, where the
> huge pages are split during CLEAR_DIRTY_LOG, so there are also no vCPU
> faults to split huge pages.
> 
>>
>>>
>>> Absent performance data for other architectures, which is likely going to be
>>> difficult/slow to get, it might make sense to have this be opt-in to start.  We
>>> could even do it with minimal #ifdeffery, e.g. something like the below would allow
>>> x86 to do whatever locking it wants in kvm_arch_mmu_enable_log_dirty_pt_masked()
>>> (I assume we want to give kvm_get_dirty_log_protect() similar treatment?).
>>>
>>> I don't love the idea of adding more arch specific MMU behavior (going the wrong
>>> direction), but it doesn't seem like an unreasonable approach in this case.
>> No special modification for this, it is a little strange. LoongArch page
>> fault fast path can improve later.
> 
> Sorry, I don't follow exactly what you mean here. Are you saying
> Sean's patch is not required for LoongArch and, instead, LoongArch
> should/will avoid acquiring the mmu_lock when handling
> write-protection faults?
> 
yes, LoongArch need some optimization in secondary mmu fast path, such 
as rcu lock, read lock on mmu_lock, or page table spin lock on pte table 
page. It is not decided now. If the patch works on x86 platform, just go 
ahead; LoongArch KVM will improve later.

Regards
Bibo Mao


