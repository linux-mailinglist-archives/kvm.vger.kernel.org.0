Return-Path: <kvm+bounces-16968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5128BF5EC
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:10:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6DC0B22CB8
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF4920B3D;
	Wed,  8 May 2024 06:10:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8685C1863C;
	Wed,  8 May 2024 06:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715148619; cv=none; b=bbYKbVaLEEgOP/Fi/az/jqZ1kgY97mIyFEtUOFXFDiT+BCKw2BKnPUBPH1cBTUIluTlfT0OZnA2o9neZqSoCmt+I/0+7q3F/LcIUH2HFk47u3WZn5ns3ll2V/bw0keqbH+ds2pEnFwDK3meF1L4q8ZjlImK1sGrtF8fouNhH+Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715148619; c=relaxed/simple;
	bh=G9By4HZg/6i1Gbh9u+QmWnNJM8cy4JNvOmHRO2jAP7c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=m1gqFTsaeV3LphMg6Qo1hpHJoYVMOq6JSRGdgnxe2fzCBWulPIzrR91XQQYMYsJkmaJh6zlAo5f6dPiTpdZLipOyeMuirPN1nxxIQBbmbig+b50vUHOJxO5nie4nIswnkvM4wGaU3cWKtqPcwmiGAuJyPjrdWWguk6VFboHYz9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8BxeOlGFztmWDgJAA--.12480S3;
	Wed, 08 May 2024 14:10:14 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxndxBFztmC0EVAA--.41556S3;
	Wed, 08 May 2024 14:10:11 +0800 (CST)
Subject: Re: [PATCH v8 4/6] LoongArch: KVM: Add vcpu search support from
 physical cpuid
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240428100518.1642324-1-maobibo@loongson.cn>
 <20240428100518.1642324-5-maobibo@loongson.cn>
 <CAAhV-H6kBO_RTTHoLfKdAtLO1Aqb0KmAJ6wn0wZrvbCkzMszDQ@mail.gmail.com>
 <7335dcde-1b3a-1260-ac62-d2d9fcbd6a78@loongson.cn>
 <CAAhV-H5WJ0o3bJZBq2zx7ejjFkFwYVTyVJEzJuAHEs+uMg-sxw@mail.gmail.com>
 <b10b46ce-8219-8863-470f-9bfa173b22b0@loongson.cn>
 <CAAhV-H7fbrOXTtSwBmR3kyTW7yhsifycjynky4HPrUJiS9s=cg@mail.gmail.com>
 <540aa8dd-eada-1f77-0a20-38196fb5472a@loongson.cn>
 <CAAhV-H7o3oG2KXc2Ou0aWXTLPSNiM3evSB5Z-5dH4bLRd_P_0Q@mail.gmail.com>
 <61670353-90c6-6d0c-4430-7655b5251e17@loongson.cn>
 <CAAhV-H5wNmgxGincGE7cJ8WvrpKFauAJvMHrPttW-LrKB4UeHg@mail.gmail.com>
 <a6d49710-1580-809d-5dcf-ea4207257ae7@loongson.cn>
 <CAAhV-H4ir++y+46-g43-9bLvY8cv79fB6bKbWgkhDzDV7QQg9g@mail.gmail.com>
 <7f16cac7-c712-40d4-a3f4-cc761e0dea93@loongson.cn>
 <CAAhV-H7ZwhrBma0mwFnuWBHXqH5gsJSz2hPL3jxHqfQVakh+SQ@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <2c55f0cb-c3b7-5d03-d14b-516e1fd087e3@loongson.cn>
Date: Wed, 8 May 2024 14:10:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7ZwhrBma0mwFnuWBHXqH5gsJSz2hPL3jxHqfQVakh+SQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxndxBFztmC0EVAA--.41556S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3ZFyDuFy7tw15Cry3JrW7KFX_yoW8CF47Wo
	WUJr17Jr18Jr1UJr1UJ34Dtryjyw1UJr1UJryUJr15Jr1Utw1UAr18Jr1UJF4UJr1UJr17
	JryUJr1UAFWUXr15l-sFpf9Il3svdjkaLaAFLSUrUUUU1b8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUYA7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUGVWUXwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Jrv_JF1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
	xGrwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8X_-PUUUUU==



On 2024/5/8 下午1:00, Huacai Chen wrote:
> On Tue, May 7, 2024 at 11:06 AM maobibo <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2024/5/7 上午10:05, Huacai Chen wrote:
>>> On Tue, May 7, 2024 at 9:40 AM maobibo <maobibo@loongson.cn> wrote:
>>>>
>>>>
>>>>
>>>> On 2024/5/6 下午10:17, Huacai Chen wrote:
>>>>> On Mon, May 6, 2024 at 6:05 PM maobibo <maobibo@loongson.cn> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 2024/5/6 下午5:40, Huacai Chen wrote:
>>>>>>> On Mon, May 6, 2024 at 5:35 PM maobibo <maobibo@loongson.cn> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On 2024/5/6 下午4:59, Huacai Chen wrote:
>>>>>>>>> On Mon, May 6, 2024 at 4:18 PM maobibo <maobibo@loongson.cn> wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 2024/5/6 下午3:06, Huacai Chen wrote:
>>>>>>>>>>> Hi, Bibo,
>>>>>>>>>>>
>>>>>>>>>>> On Mon, May 6, 2024 at 2:36 PM maobibo <maobibo@loongson.cn> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> On 2024/5/6 上午9:49, Huacai Chen wrote:
>>>>>>>>>>>>> Hi, Bibo,
>>>>>>>>>>>>>
>>>>>>>>>>>>> On Sun, Apr 28, 2024 at 6:05 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Physical cpuid is used for interrupt routing for irqchips such as
>>>>>>>>>>>>>> ipi/msi/extioi interrupt controller. And physical cpuid is stored
>>>>>>>>>>>>>> at CSR register LOONGARCH_CSR_CPUID, it can not be changed once vcpu
>>>>>>>>>>>>>> is created and physical cpuid of two vcpus cannot be the same.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Different irqchips have different size declaration about physical cpuid,
>>>>>>>>>>>>>> max cpuid value for CSR LOONGARCH_CSR_CPUID on 3A5000 is 512, max cpuid
>>>>>>>>>>>>>> supported by IPI hardware is 1024, 256 for extioi irqchip, and 65536
>>>>>>>>>>>>>> for MSI irqchip.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> The smallest value from all interrupt controllers is selected now,
>>>>>>>>>>>>>> and the max cpuid size is defines as 256 by KVM which comes from
>>>>>>>>>>>>>> extioi irqchip.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>         arch/loongarch/include/asm/kvm_host.h | 26 ++++++++
>>>>>>>>>>>>>>         arch/loongarch/include/asm/kvm_vcpu.h |  1 +
>>>>>>>>>>>>>>         arch/loongarch/kvm/vcpu.c             | 93 ++++++++++++++++++++++++++-
>>>>>>>>>>>>>>         arch/loongarch/kvm/vm.c               | 11 ++++
>>>>>>>>>>>>>>         4 files changed, 130 insertions(+), 1 deletion(-)
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>>>>>>>>>>>>>> index 2d62f7b0d377..3ba16ef1fe69 100644
>>>>>>>>>>>>>> --- a/arch/loongarch/include/asm/kvm_host.h
>>>>>>>>>>>>>> +++ b/arch/loongarch/include/asm/kvm_host.h
>>>>>>>>>>>>>> @@ -64,6 +64,30 @@ struct kvm_world_switch {
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>         #define MAX_PGTABLE_LEVELS     4
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> +/*
>>>>>>>>>>>>>> + * Physical cpu id is used for interrupt routing, there are different
>>>>>>>>>>>>>> + * definitions about physical cpuid on different hardwares.
>>>>>>>>>>>>>> + *  For LOONGARCH_CSR_CPUID register, max cpuid size if 512
>>>>>>>>>>>>>> + *  For IPI HW, max dest CPUID size 1024
>>>>>>>>>>>>>> + *  For extioi interrupt controller, max dest CPUID size is 256
>>>>>>>>>>>>>> + *  For MSI interrupt controller, max supported CPUID size is 65536
>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>> + * Currently max CPUID is defined as 256 for KVM hypervisor, in future
>>>>>>>>>>>>>> + * it will be expanded to 4096, including 16 packages at most. And every
>>>>>>>>>>>>>> + * package supports at most 256 vcpus
>>>>>>>>>>>>>> + */
>>>>>>>>>>>>>> +#define KVM_MAX_PHYID          256
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +struct kvm_phyid_info {
>>>>>>>>>>>>>> +       struct kvm_vcpu *vcpu;
>>>>>>>>>>>>>> +       bool            enabled;
>>>>>>>>>>>>>> +};
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +struct kvm_phyid_map {
>>>>>>>>>>>>>> +       int max_phyid;
>>>>>>>>>>>>>> +       struct kvm_phyid_info phys_map[KVM_MAX_PHYID];
>>>>>>>>>>>>>> +};
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>         struct kvm_arch {
>>>>>>>>>>>>>>                /* Guest physical mm */
>>>>>>>>>>>>>>                kvm_pte_t *pgd;
>>>>>>>>>>>>>> @@ -71,6 +95,8 @@ struct kvm_arch {
>>>>>>>>>>>>>>                unsigned long invalid_ptes[MAX_PGTABLE_LEVELS];
>>>>>>>>>>>>>>                unsigned int  pte_shifts[MAX_PGTABLE_LEVELS];
>>>>>>>>>>>>>>                unsigned int  root_level;
>>>>>>>>>>>>>> +       spinlock_t    phyid_map_lock;
>>>>>>>>>>>>>> +       struct kvm_phyid_map  *phyid_map;
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>                s64 time_offset;
>>>>>>>>>>>>>>                struct kvm_context __percpu *vmcs;
>>>>>>>>>>>>>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
>>>>>>>>>>>>>> index 0cb4fdb8a9b5..9f53950959da 100644
>>>>>>>>>>>>>> --- a/arch/loongarch/include/asm/kvm_vcpu.h
>>>>>>>>>>>>>> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
>>>>>>>>>>>>>> @@ -81,6 +81,7 @@ void kvm_save_timer(struct kvm_vcpu *vcpu);
>>>>>>>>>>>>>>         void kvm_restore_timer(struct kvm_vcpu *vcpu);
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>         int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt *irq);
>>>>>>>>>>>>>> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int cpuid);
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>         /*
>>>>>>>>>>>>>>          * Loongarch KVM guest interrupt handling
>>>>>>>>>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>>>>>>>>>>>> index 3a8779065f73..b633fd28b8db 100644
>>>>>>>>>>>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>>>>>>>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>>>>>>>>>>>> @@ -274,6 +274,95 @@ static int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *val)
>>>>>>>>>>>>>>                return 0;
>>>>>>>>>>>>>>         }
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> +static inline int kvm_set_cpuid(struct kvm_vcpu *vcpu, u64 val)
>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>> +       int cpuid;
>>>>>>>>>>>>>> +       struct loongarch_csrs *csr = vcpu->arch.csr;
>>>>>>>>>>>>>> +       struct kvm_phyid_map  *map;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +       if (val >= KVM_MAX_PHYID)
>>>>>>>>>>>>>> +               return -EINVAL;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +       cpuid = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
>>>>>>>>>>>>>> +       map = vcpu->kvm->arch.phyid_map;
>>>>>>>>>>>>>> +       spin_lock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>>>>>>>>>> +       if (map->phys_map[cpuid].enabled) {
>>>>>>>>>>>>>> +               /*
>>>>>>>>>>>>>> +                * Cpuid is already set before
>>>>>>>>>>>>>> +                * Forbid changing different cpuid at runtime
>>>>>>>>>>>>>> +                */
>>>>>>>>>>>>>> +               if (cpuid != val) {
>>>>>>>>>>>>>> +                       /*
>>>>>>>>>>>>>> +                        * Cpuid 0 is initial value for vcpu, maybe invalid
>>>>>>>>>>>>>> +                        * unset value for vcpu
>>>>>>>>>>>>>> +                        */
>>>>>>>>>>>>>> +                       if (cpuid) {
>>>>>>>>>>>>>> +                               spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>>>>>>>>>> +                               return -EINVAL;
>>>>>>>>>>>>>> +                       }
>>>>>>>>>>>>>> +               } else {
>>>>>>>>>>>>>> +                        /* Discard duplicated cpuid set */
>>>>>>>>>>>>>> +                       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>>>>>>>>>> +                       return 0;
>>>>>>>>>>>>>> +               }
>>>>>>>>>>>>>> +       }
>>>>>>>>>>>>> I have changed the logic and comments when I apply, you can double
>>>>>>>>>>>>> check whether it is correct.
>>>>>>>>>>>> I checkout the latest version, the modification in function
>>>>>>>>>>>> kvm_set_cpuid() is good for me.
>>>>>>>>>>> Now the modified version is like this:
>>>>>>>>>>>
>>>>>>>>>>> + if (map->phys_map[cpuid].enabled) {
>>>>>>>>>>> + /* Discard duplicated CPUID set operation */
>>>>>>>>>>> + if (cpuid == val) {
>>>>>>>>>>> + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>>>>>>> + return 0;
>>>>>>>>>>> + }
>>>>>>>>>>> +
>>>>>>>>>>> + /*
>>>>>>>>>>> + * CPUID is already set before
>>>>>>>>>>> + * Forbid changing different CPUID at runtime
>>>>>>>>>>> + * But CPUID 0 is the initial value for vcpu, so allow
>>>>>>>>>>> + * changing from 0 to others
>>>>>>>>>>> + */
>>>>>>>>>>> + if (cpuid) {
>>>>>>>>>>> + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>>>>>>> + return -EINVAL;
>>>>>>>>>>> + }
>>>>>>>>>>> + }
>>>>>>>>>>> But I still doubt whether we should allow changing from 0 to others
>>>>>>>>>>> while map->phys_map[cpuid].enabled is 1.
>>>>>>>>>> It is necessary since the default sw cpuid is zero :-( And we can
>>>>>>>>>> optimize it in later, such as set INVALID cpuid in function
>>>>>>>>>> kvm_arch_vcpu_create() and logic will be simple in function kvm_set_cpuid().
>>>>>>>>> In my opinion, if a vcpu with a uninitialized default physid=0, then
>>>>>>>>> map->phys_map[cpuid].enabled should be 0, then code won't come here.
>>>>>>>>> And if a vcpu with a real physid=0, then map->phys_map[cpuid].enabled
>>>>>>>>> is 1, but we shouldn't allow it to change physid in this case.
>>>>>>>> yes, that is actually a problem.
>>>>>>>>
>>>>>>>> vcpu0 firstly set physid=0, and vcpu0 set physid=1 again is not allowed.
>>>>>>>> vcpu0 firstly set physid=0, and vcpu1 set physid=1 is allowed.
>>>>>>>
>>>>>>> So can we simply drop the if (cpuid) checking? That means:
>>>>>>> + if (map->phys_map[cpuid].enabled) {
>>>>>>> + /* Discard duplicated CPUID set operation */
>>>>>>> + if (cpuid == val) {
>>>>>>> + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>>> + return 0;
>>>>>>> + }
>>>>>>> +
>>>>>>> + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>>> + return -EINVAL;
>>>>>>> + }
>>>>>> yes, the similar modification such as following, since the secondary
>>>>>> scenario should be allowed.
>>>>>>      "vcpu0 firstly set physid=0, and vcpu1 set physid=1 is allowed though
>>>>>> default sw cpuid is zero"
>>>>>>
>>>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>>>> @@ -272,7 +272,7 @@ static inline int kvm_set_cpuid(struct kvm_vcpu
>>>>>> *vcpu, u64 val)
>>>>>>             cpuid = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_CPUID);
>>>>>>
>>>>>>             spin_lock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>> -       if (map->phys_map[cpuid].enabled) {
>>>>>> +       if ((cpuid != KVM_MAX_PHYID) && map->phys_map[cpuid].enabled) {
>>>>>>                     /* Discard duplicated CPUID set operation */
>>>>>>                     if (cpuid == val) {
>>>>>>                             spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>> @@ -282,13 +282,9 @@ static inline int kvm_set_cpuid(struct kvm_vcpu
>>>>>> *vcpu, u64 val)
>>>>>>                     /*
>>>>>>                      * CPUID is already set before
>>>>>>                      * Forbid changing different CPUID at runtime
>>>>>> -                * But CPUID 0 is the initial value for vcpu, so allow
>>>>>> -                * changing from 0 to others
>>>>>>                      */
>>>>>> -               if (cpuid) {
>>>>>> -                       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>> -                       return -EINVAL;
>>>>>> -               }
>>>>>> +               spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>> +               return -EINVAL;
>>>>>>             }
>>>>>>
>>>>>>             if (map->phys_map[val].enabled) {
>>>>>> @@ -1029,6 +1025,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>>>>>
>>>>>>             /* Set cpuid */
>>>>>>             kvm_write_sw_gcsr(csr, LOONGARCH_CSR_TMID, vcpu->vcpu_id);
>>>>>> +       kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, KVM_MAX_PHYID);
>>>>>>
>>>>>>             /* Start with no pending virtual guest interrupts */
>>>>>>             csr->csrs[LOONGARCH_CSR_GINTC] = 0;
>>>>> Very nice, but I think kvm_drop_cpuid() should also set to KVM_MAX_PHYID.
>>>>> Now I update my loongarch-kvm branch, you can test it again, and hope
>>>>> it is in the perfect status.
>>>> I sync and test the latest code from loongarch-kvm, pv ipi works well
>>>> with 256 vcpus. And the code looks good to me, thanks for your review in
>>>> short time.
>>> OK, if SWDBG also works well, I will send PR to Paolo tomorrow.
>> yes, sw debug works well with patch from qemu. And I will refresh patch
>> to qemu after it is merged.
>>
>> https://lore.kernel.org/all/20240218070025.218680-1-maobibo@loongson.cn/
>>
>> --- a/configs/targets/loongarch64-softmmu.mak
>> +++ b/configs/targets/loongarch64-softmmu.mak
>> @@ -1,5 +1,6 @@
>>    TARGET_ARCH=loongarch64
>>    TARGET_BASE_ARCH=loongarch
>>    TARGET_SUPPORTS_MTTCG=y
>> +TARGET_KVM_HAVE_GUEST_DEBUG=y
>>    TARGET_XML_FILES= gdb-xml/loongarch-base32.xml
>> gdb-xml/loongarch-base64.xml gdb-xml/loongarch-fpu.xml
>>    TARGET_NEED_FDT=y
> Not enough, we need kvm_arch_update_guest_debug() and some other functions.
yes, the RFC patch on qemu side is posted at website:
https://lore.kernel.org/all/20240218070025.218680-1-maobibo@loongson.cn/

> 
> Huacai
> 
>>
>> Regards
>> Bibo Mao
>>>
>>> Huacai
>>>
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>>
>>>>> Huacai
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> Huacai
>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Huacai
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Regards
>>>>>>>>>> Bibo Mao
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Huacai
>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +       if (map->phys_map[val].enabled) {
>>>>>>>>>>>>>> +               /*
>>>>>>>>>>>>>> +                * New cpuid is already set with other vcpu
>>>>>>>>>>>>>> +                * Forbid sharing the same cpuid between different vcpus
>>>>>>>>>>>>>> +                */
>>>>>>>>>>>>>> +               if (map->phys_map[val].vcpu != vcpu) {
>>>>>>>>>>>>>> +                       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>>>>>>>>>> +                       return -EINVAL;
>>>>>>>>>>>>>> +               }
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +               /* Discard duplicated cpuid set operation*/
>>>>>>>>>>>>>> +               spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>>>>>>>>>> +               return 0;
>>>>>>>>>>>>>> +       }
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +       kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, val);
>>>>>>>>>>>>>> +       map->phys_map[val].enabled      = true;
>>>>>>>>>>>>>> +       map->phys_map[val].vcpu         = vcpu;
>>>>>>>>>>>>>> +       if (map->max_phyid < val)
>>>>>>>>>>>>>> +               map->max_phyid = val;
>>>>>>>>>>>>>> +       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>>>>>>>>>>>>>> +       return 0;
>>>>>>>>>>>>>> +}
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int cpuid)
>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>> +       struct kvm_phyid_map  *map;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +       if (cpuid >= KVM_MAX_PHYID)
>>>>>>>>>>>>>> +               return NULL;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +       map = kvm->arch.phyid_map;
>>>>>>>>>>>>>> +       if (map->phys_map[cpuid].enabled)
>>>>>>>>>>>>>> +               return map->phys_map[cpuid].vcpu;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +       return NULL;
>>>>>>>>>>>>>> +}
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +static inline void kvm_drop_cpuid(struct kvm_vcpu *vcpu)
>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>> +       int cpuid;
>>>>>>>>>>>>>> +       struct loongarch_csrs *csr = vcpu->arch.csr;
>>>>>>>>>>>>>> +       struct kvm_phyid_map  *map;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +       map = vcpu->kvm->arch.phyid_map;
>>>>>>>>>>>>>> +       cpuid = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
>>>>>>>>>>>>>> +       if (cpuid >= KVM_MAX_PHYID)
>>>>>>>>>>>>>> +               return;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +       if (map->phys_map[cpuid].enabled) {
>>>>>>>>>>>>>> +               map->phys_map[cpuid].vcpu = NULL;
>>>>>>>>>>>>>> +               map->phys_map[cpuid].enabled = false;
>>>>>>>>>>>>>> +               kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, 0);
>>>>>>>>>>>>>> +       }
>>>>>>>>>>>>>> +}
>>>>>>>>>>>>> While kvm_set_cpuid() is protected by a spinlock, do kvm_drop_cpuid()
>>>>>>>>>>>>> and kvm_get_vcpu_by_cpuid() also need it?
>>>>>>>>>>>>>
>>>>>>>>>>>> It is good to me that spinlock is added in function kvm_drop_cpuid().
>>>>>>>>>>>> And thinks for the efforts.
>>>>>>>>>>>>
>>>>>>>>>>>> Regards
>>>>>>>>>>>> Bibo Mao
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>         static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>>>>>>>>>>>>>>         {
>>>>>>>>>>>>>>                int ret = 0, gintc;
>>>>>>>>>>>>>> @@ -291,7 +380,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>>>>>>>>>>>>>>                        kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT, gintc);
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>                        return ret;
>>>>>>>>>>>>>> -       }
>>>>>>>>>>>>>> +       } else if (id == LOONGARCH_CSR_CPUID)
>>>>>>>>>>>>>> +               return kvm_set_cpuid(vcpu, val);
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>                kvm_write_sw_gcsr(csr, id, val);
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> @@ -943,6 +1033,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>>>>>>>>>>>>>>                hrtimer_cancel(&vcpu->arch.swtimer);
>>>>>>>>>>>>>>                kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>>>>>>>>>>>>>>                kfree(vcpu->arch.csr);
>>>>>>>>>>>>>> +       kvm_drop_cpuid(vcpu);
>>>>>>>>>>>>> I think this line should be before the above kfree(), otherwise you
>>>>>>>>>>>>> get a "use after free".
>>>>>>>>>>>>>
>>>>>>>>>>>>> Huacai
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>                /*
>>>>>>>>>>>>>>                 * If the vCPU is freed and reused as another vCPU, we don't want the
>>>>>>>>>>>>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
>>>>>>>>>>>>>> index 0a37f6fa8f2d..6006a28653ad 100644
>>>>>>>>>>>>>> --- a/arch/loongarch/kvm/vm.c
>>>>>>>>>>>>>> +++ b/arch/loongarch/kvm/vm.c
>>>>>>>>>>>>>> @@ -30,6 +30,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>>>>>>>>>>>>>                if (!kvm->arch.pgd)
>>>>>>>>>>>>>>                        return -ENOMEM;
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> +       kvm->arch.phyid_map = kvzalloc(sizeof(struct kvm_phyid_map),
>>>>>>>>>>>>>> +                               GFP_KERNEL_ACCOUNT);
>>>>>>>>>>>>>> +       if (!kvm->arch.phyid_map) {
>>>>>>>>>>>>>> +               free_page((unsigned long)kvm->arch.pgd);
>>>>>>>>>>>>>> +               kvm->arch.pgd = NULL;
>>>>>>>>>>>>>> +               return -ENOMEM;
>>>>>>>>>>>>>> +       }
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>                kvm_init_vmcs(kvm);
>>>>>>>>>>>>>>                kvm->arch.gpa_size = BIT(cpu_vabits - 1);
>>>>>>>>>>>>>>                kvm->arch.root_level = CONFIG_PGTABLE_LEVELS - 1;
>>>>>>>>>>>>>> @@ -44,6 +52,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>>>>>>>>>>>>>                for (i = 0; i <= kvm->arch.root_level; i++)
>>>>>>>>>>>>>>                        kvm->arch.pte_shifts[i] = PAGE_SHIFT + i * (PAGE_SHIFT - 3);
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> +       spin_lock_init(&kvm->arch.phyid_map_lock);
>>>>>>>>>>>>>>                return 0;
>>>>>>>>>>>>>>         }
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> @@ -51,7 +60,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>>>>>>>>>>>>>>         {
>>>>>>>>>>>>>>                kvm_destroy_vcpus(kvm);
>>>>>>>>>>>>>>                free_page((unsigned long)kvm->arch.pgd);
>>>>>>>>>>>>>> +       kvfree(kvm->arch.phyid_map);
>>>>>>>>>>>>>>                kvm->arch.pgd = NULL;
>>>>>>>>>>>>>> +       kvm->arch.phyid_map = NULL;
>>>>>>>>>>>>>>         }
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>         int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>>>>>>>>>>>> --
>>>>>>>>>>>>>> 2.39.3
>>>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>
>>>>>>
>>>>
>>>>
>>
>>


