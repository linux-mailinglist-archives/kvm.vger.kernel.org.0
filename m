Return-Path: <kvm+bounces-63644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BFC47C6C3D5
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 02:25:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C16014EBBA1
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DFF924111D;
	Wed, 19 Nov 2025 01:23:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A54923C513;
	Wed, 19 Nov 2025 01:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763515404; cv=none; b=KweO06CXaRflgOJIHmqU/XcHTJpZDkgKM1aY9UFWFcGpS8ACsGOE2VBXxE3YsOpWhdAEofTBSyxoYos03ZBgf6wREes5OCYnKfg/PokhWgnVw8rbVwL56HnoRdfaY/DjVrt/PAkz6P7SLX/RheWsByoIW46ZyhJj7kBYsqZVYis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763515404; c=relaxed/simple;
	bh=N7nO7rejQQkKmp2+i1NlmyNPNxUaUfv/RGpzzvliWV0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=nnNo5qfgJwX7DtvSpJKL4ISVaYgGn/Zpz336aM5yX23Bfe4brz3NtbqTBiQSML9qwLMLpHRXq2fc6epE3xQcLuzdyUbMro2QT5EPNCNkjkfegr3yvPd0ro08CKPXcu0g1Pj6EXAz494zTpVcLbdbUpW1Hyl0w1zoKfKPOriANDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cxrr8DHB1pfkwlAA--.13318S3;
	Wed, 19 Nov 2025 09:23:15 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxfcH_Gx1p1vI3AQ--.34531S3;
	Wed, 19 Nov 2025 09:23:13 +0800 (CST)
Subject: Re: [PATCH 1/3] LoongArch: KVM: Add preempt hint feature in
 hypervisor side
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20251118080656.2012805-1-maobibo@loongson.cn>
 <20251118080656.2012805-2-maobibo@loongson.cn>
 <CAAhV-H5qZ3_KTvkZ-zQni6Lg-6W5y9oBXDb9+2VAeFV82BEzhA@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <3e36f507-a907-7143-41a7-58dbefb73fb5@loongson.cn>
Date: Wed, 19 Nov 2025 09:20:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5qZ3_KTvkZ-zQni6Lg-6W5y9oBXDb9+2VAeFV82BEzhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxfcH_Gx1p1vI3AQ--.34531S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxKr4DGrWfZr47GFW7Gr48uFX_yoW3GFyrpF
	97AF4kGF4xGr1fCwn7trZI9rW5Wrs7Kr1Iga47KayYyFsFvrykAr10kr98CF98Jw48XayI
	vF1Fqw4avFs0q3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zwZ7UU
	UUU==



On 2025/11/18 下午8:46, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Tue, Nov 18, 2025 at 4:07 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Feature KVM_FEATURE_PREEMPT_HINT is added to show whether vCPU is
>> preempted or not. It is to help guest OS scheduling or lock checking
>> etc. Here add KVM_FEATURE_PREEMPT_HINT feature and use one byte as
>> preempted flag in steal time structure.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_host.h      |  2 +
>>   arch/loongarch/include/asm/kvm_para.h      |  5 +-
>>   arch/loongarch/include/uapi/asm/kvm.h      |  1 +
>>   arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
>>   arch/loongarch/kvm/vcpu.c                  | 54 +++++++++++++++++++++-
>>   arch/loongarch/kvm/vm.c                    |  5 +-
>>   6 files changed, 65 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>> index 0cecbd038bb3..04c6dd171877 100644
>> --- a/arch/loongarch/include/asm/kvm_host.h
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -163,6 +163,7 @@ enum emulation_result {
>>   #define LOONGARCH_PV_FEAT_UPDATED      BIT_ULL(63)
>>   #define LOONGARCH_PV_FEAT_MASK         (BIT(KVM_FEATURE_IPI) |         \
>>                                           BIT(KVM_FEATURE_STEAL_TIME) |  \
>> +                                        BIT(KVM_FEATURE_PREEMPT_HINT) |\
>>                                           BIT(KVM_FEATURE_USER_HCALL) |  \
>>                                           BIT(KVM_FEATURE_VIRT_EXTIOI))
>>
>> @@ -250,6 +251,7 @@ struct kvm_vcpu_arch {
>>                  u64 guest_addr;
>>                  u64 last_steal;
>>                  struct gfn_to_hva_cache cache;
>> +               u8  preempted;
>>          } st;
>>   };
>>
>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
>> index 3e4b397f423f..d8592a7f5922 100644
>> --- a/arch/loongarch/include/asm/kvm_para.h
>> +++ b/arch/loongarch/include/asm/kvm_para.h
>> @@ -37,8 +37,11 @@ struct kvm_steal_time {
>>          __u64 steal;
>>          __u32 version;
>>          __u32 flags;
>> -       __u32 pad[12];
>> +       __u8  preempted;
>> +       __u8  u8_pad[3];
>> +       __u32 pad[11];
> Maybe a single __u8 pad[47] is enough?
yes, pad[47] seems better unless there is definitely __u32 type 
requirement in future.

Will do in next version.
> 
>>   };
>> +#define KVM_VCPU_PREEMPTED             (1 << 0)
>>
>>   /*
>>    * Hypercall interface for KVM hypervisor
>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
>> index 57ba1a563bb1..bca7154aa651 100644
>> --- a/arch/loongarch/include/uapi/asm/kvm.h
>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>> @@ -104,6 +104,7 @@ struct kvm_fpu {
>>   #define  KVM_LOONGARCH_VM_FEAT_PV_IPI          6
>>   #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME    7
>>   #define  KVM_LOONGARCH_VM_FEAT_PTW             8
>> +#define KVM_LOONGARCH_VM_FEAT_PV_PREEMPT_HINT  10
>  From the name it is a "hint", from include/linux/kvm_para.h we know
> features and hints are different. If preempt is really a feature,
> rename it?
It is a feature. yes, in generic hint is suggestion for VM and VM can 
selectively do or not.

Will rename it with KVM_LOONGARCH_VM_FEAT_PV_PREEMPT.
> 
>>
>>   /* Device Control API on vcpu fd */
>>   #define KVM_LOONGARCH_VCPU_CPUCFG      0
>> diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongarch/include/uapi/asm/kvm_para.h
>> index 76d802ef01ce..fe4107869ce6 100644
>> --- a/arch/loongarch/include/uapi/asm/kvm_para.h
>> +++ b/arch/loongarch/include/uapi/asm/kvm_para.h
>> @@ -15,6 +15,7 @@
>>   #define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
>>   #define  KVM_FEATURE_IPI               1
>>   #define  KVM_FEATURE_STEAL_TIME                2
>> +#define  KVM_FEATURE_PREEMPT_HINT      3
>>   /* BIT 24 - 31 are features configurable by user space vmm */
>>   #define  KVM_FEATURE_VIRT_EXTIOI       24
>>   #define  KVM_FEATURE_USER_HCALL                25
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 1245a6b35896..33a94b191b5d 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -180,6 +180,11 @@ static void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
>>          }
>>
>>          st = (struct kvm_steal_time __user *)ghc->hva;
>> +       if (kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_PREEMPT_HINT)) {
>> +               unsafe_put_user(0, &st->preempted, out);
>> +               vcpu->arch.st.preempted = 0;
>> +       }
>> +
>>          unsafe_get_user(version, &st->version, out);
>>          if (version & 1)
>>                  version += 1; /* first time write, random junk */
>> @@ -1757,11 +1762,58 @@ static int _kvm_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
>>          return 0;
>>   }
>>
>> +static void _kvm_set_vcpu_preempted(struct kvm_vcpu *vcpu)
> Just using kvm_set_vcpu_preempted() is enough, no "_".
> 
>> +{
>> +       struct gfn_to_hva_cache *ghc;
>> +       struct kvm_steal_time __user *st;
>> +       struct kvm_memslots *slots;
>> +       static const u8 preempted = KVM_VCPU_PREEMPTED;
> I'm not sure whether "static" is right, it's not reentrant.
I think static is better here, it saves one cycle with assignment here.

Regards
Bibo Mao
> 
> 
> Huacai
> 
>> +       gpa_t gpa;
>> +
>> +       gpa = vcpu->arch.st.guest_addr;
>> +       if (!(gpa & KVM_STEAL_PHYS_VALID))
>> +               return;
>> +
>> +       /* vCPU may be preempted for many times */
>> +       if (vcpu->arch.st.preempted)
>> +               return;
>> +
>> +       /* This happens on process exit */
>> +       if (unlikely(current->mm != vcpu->kvm->mm))
>> +               return;
>> +
>> +       gpa &= KVM_STEAL_PHYS_MASK;
>> +       ghc = &vcpu->arch.st.cache;
>> +       slots = kvm_memslots(vcpu->kvm);
>> +       if (slots->generation != ghc->generation || gpa != ghc->gpa) {
>> +               if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, sizeof(*st))) {
>> +                       ghc->gpa = INVALID_GPA;
>> +                       return;
>> +               }
>> +       }
>> +
>> +       st = (struct kvm_steal_time __user *)ghc->hva;
>> +       unsafe_put_user(preempted, &st->preempted, out);
>> +       vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
>> +out:
>> +       mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
>> +}
>> +
>>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>   {
>> -       int cpu;
>> +       int cpu, idx;
>>          unsigned long flags;
>>
>> +       if (vcpu->preempted && kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_PREEMPT_HINT)) {
>> +               /*
>> +                * Take the srcu lock as memslots will be accessed to check the gfn
>> +                * cache generation against the memslots generation.
>> +                */
>> +               idx = srcu_read_lock(&vcpu->kvm->srcu);
>> +               _kvm_set_vcpu_preempted(vcpu);
>> +               srcu_read_unlock(&vcpu->kvm->srcu, idx);
>> +       }
>> +
>>          local_irq_save(flags);
>>          cpu = smp_processor_id();
>>          vcpu->arch.last_sched_cpu = cpu;
>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
>> index a49b1c1a3dd1..b8879110a0a1 100644
>> --- a/arch/loongarch/kvm/vm.c
>> +++ b/arch/loongarch/kvm/vm.c
>> @@ -45,8 +45,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>
>>          /* Enable all PV features by default */
>>          kvm->arch.pv_features = BIT(KVM_FEATURE_IPI);
>> -       if (kvm_pvtime_supported())
>> +       if (kvm_pvtime_supported()) {
>>                  kvm->arch.pv_features |= BIT(KVM_FEATURE_STEAL_TIME);
>> +               kvm->arch.pv_features |= BIT(KVM_FEATURE_PREEMPT_HINT);
>> +       }
>>
>>          /*
>>           * cpu_vabits means user address space only (a half of total).
>> @@ -143,6 +145,7 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
>>          case KVM_LOONGARCH_VM_FEAT_PV_IPI:
>>                  return 0;
>>          case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
>> +       case KVM_LOONGARCH_VM_FEAT_PV_PREEMPT_HINT:
>>                  if (kvm_pvtime_supported())
>>                          return 0;
>>                  return -ENXIO;
>> --
>> 2.39.3
>>
>>


