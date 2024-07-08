Return-Path: <kvm+bounces-21076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E627929A7B
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 03:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81E9D1C20B57
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 01:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB411879;
	Mon,  8 Jul 2024 01:16:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC9D386;
	Mon,  8 Jul 2024 01:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720401380; cv=none; b=AhR8BUuJJ1QH+d/aqnyKJ2fWPYtxEvxU3jrw331I6hykf3UmqAW4CyVws3sMDrFiMBka5Ph8kCGoAxW9CigiA6xVaskpiVxP+GR9E91bPedLVfNT0NFSCYxUx8HYnulSFhYOSbFfWKj/1y65VBw9xXJJhs8lT1EpzuyuKnMoeFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720401380; c=relaxed/simple;
	bh=YxGKNOt+bYKwtB8aSr+XryXqvFkmAo8egk8yltaeaJ4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TImvPcDALg13WAvhWVUN/9t1sYHJSXoJUuF/cfg8ydiKg+ksTOc/IWESaW5InH0XvDkvLw7G051c2LURiKZv73PdDQZ8tw8lv54ZSOpmPz4MebphRiimeeE02GC2irY2vE6dKd4U0gBrWATA4UT3llDNCBCTPz3D88FMb/45tgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cx7+vYPYtm1d8BAA--.5578S3;
	Mon, 08 Jul 2024 09:16:08 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxqsbUPYtm7wk_AA--.13719S3;
	Mon, 08 Jul 2024 09:16:06 +0800 (CST)
Subject: Re: [PATCH v4 1/2] LoongArch: KVM: Add steal time support in kvm side
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux.dev
References: <20240524073812.731032-1-maobibo@loongson.cn>
 <20240524073812.731032-2-maobibo@loongson.cn>
 <CAAhV-H5G7O7tbwzyaoO4iEXuN+_xbVFJDEyv1HH7GqOH24639Q@mail.gmail.com>
 <1aa110a8-28b9-d1d0-4b39-bc894b31f26c@loongson.cn>
 <CAAhV-H5oS+KrcGH+1wJCGKCjs2VKHkWyZ5QnorPjFMuE_eBb3g@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <ae21f9ef-e043-0f8c-b088-6645fc1f3c30@loongson.cn>
Date: Mon, 8 Jul 2024 09:16:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5oS+KrcGH+1wJCGKCjs2VKHkWyZ5QnorPjFMuE_eBb3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxqsbUPYtm7wk_AA--.13719S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3KFy7WF43Kr18GFWfXFWrWFX_yoW8Xr4fZo
	W5AF1xtw48Gr45uF1DJ3s0q3yjv34Fkw4UA3y3Ars3XF4Uta47Ar15Gw4YqF43Wr1kGr13
	Ca42gw40vFWfXwn5l-sFpf9Il3svdjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUY27kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUGVWUXwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
	CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j1YL9U
	UUUU=



On 2024/7/6 下午5:41, Huacai Chen wrote:
> On Sat, Jul 6, 2024 at 2:59 PM maobibo <maobibo@loongson.cn> wrote:
>>
>> Huacai,
>>
>> On 2024/7/6 上午11:00, Huacai Chen wrote:
>>> Hi, Bibo,
>>>
>>> On Fri, May 24, 2024 at 3:38 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>> Steal time feature is added here in kvm side, VM can search supported
>>>> features provided by KVM hypervisor, feature KVM_FEATURE_STEAL_TIME
>>>> is added here. Like x86, steal time structure is saved in guest memory,
>>>> one hypercall function KVM_HCALL_FUNC_NOTIFY is added to notify KVM to
>>>> enable the feature.
>>>>
>>>> One cpu attr ioctl command KVM_LOONGARCH_VCPU_PVTIME_CTRL is added to
>>>> save and restore base address of steal time structure when VM is migrated.
>>>>
>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>> ---
>>>>    arch/loongarch/include/asm/kvm_host.h  |   7 ++
>>>>    arch/loongarch/include/asm/kvm_para.h  |  10 ++
>>>>    arch/loongarch/include/asm/kvm_vcpu.h  |   4 +
>>>>    arch/loongarch/include/asm/loongarch.h |   1 +
>>>>    arch/loongarch/include/uapi/asm/kvm.h  |   4 +
>>>>    arch/loongarch/kvm/Kconfig             |   1 +
>>>>    arch/loongarch/kvm/exit.c              |  38 +++++++-
>>>>    arch/loongarch/kvm/vcpu.c              | 124 +++++++++++++++++++++++++
>>>>    8 files changed, 187 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>>>> index c87b6ea0ec47..2eb2f7572023 100644
>>>> --- a/arch/loongarch/include/asm/kvm_host.h
>>>> +++ b/arch/loongarch/include/asm/kvm_host.h
>>>> @@ -30,6 +30,7 @@
>>>>    #define KVM_PRIVATE_MEM_SLOTS          0
>>>>
>>>>    #define KVM_HALT_POLL_NS_DEFAULT       500000
>>>> +#define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(1)
>>>>
>>>>    #define KVM_GUESTDBG_SW_BP_MASK                \
>>>>           (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
>>>> @@ -201,6 +202,12 @@ struct kvm_vcpu_arch {
>>>>           struct kvm_mp_state mp_state;
>>>>           /* cpucfg */
>>>>           u32 cpucfg[KVM_MAX_CPUCFG_REGS];
>>>> +       /* paravirt steal time */
>>>> +       struct {
>>>> +               u64 guest_addr;
>>>> +               u64 last_steal;
>>>> +               struct gfn_to_hva_cache cache;
>>>> +       } st;
>>>>    };
>>>>
>>>>    static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
>>>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
>>>> index 4ba2312e5f8c..a9ba8185d4af 100644
>>>> --- a/arch/loongarch/include/asm/kvm_para.h
>>>> +++ b/arch/loongarch/include/asm/kvm_para.h
>>>> @@ -14,6 +14,7 @@
>>>>
>>>>    #define KVM_HCALL_SERVICE              HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_SERVICE)
>>>>    #define  KVM_HCALL_FUNC_IPI            1
>>>> +#define  KVM_HCALL_FUNC_NOTIFY         2
>>>>
>>>>    #define KVM_HCALL_SWDBG                        HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_SWDBG)
>>>>
>>>> @@ -24,6 +25,15 @@
>>>>    #define KVM_HCALL_INVALID_CODE         -1UL
>>>>    #define KVM_HCALL_INVALID_PARAMETER    -2UL
>>>>
>>>> +#define KVM_STEAL_PHYS_VALID           BIT_ULL(0)
>>>> +#define KVM_STEAL_PHYS_MASK            GENMASK_ULL(63, 6)
>>>> +struct kvm_steal_time {
>>>> +       __u64 steal;
>>>> +       __u32 version;
>>>> +       __u32 flags;
>>> I found that x86 has a preempted field here, in our internal repo the
>>> LoongArch version also has this field. Moreover,
>>> kvm_steal_time_set_preempted() and kvm_steal_time_clear_preempted()
>>> seems needed.
>> By my understanding, macro vcpu_is_preempted() is used together with pv
>> spinlock, and pv spinlock depends on pv stealtime. So I think preempted
>> flag is not part of pv stealtime, it is part of pv spinlock.
>>
>> We are going to add preempted field if pv spinlock is added.
>>>
>>>> +       __u32 pad[12];
>>>> +};
>>>> +
>>>>    /*
>>>>     * Hypercall interface for KVM hypervisor
>>>>     *
>>>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
>>>> index 590a92cb5416..d7e51300a89f 100644
>>>> --- a/arch/loongarch/include/asm/kvm_vcpu.h
>>>> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
>>>> @@ -120,4 +120,8 @@ static inline void kvm_write_reg(struct kvm_vcpu *vcpu, int num, unsigned long v
>>>>           vcpu->arch.gprs[num] = val;
>>>>    }
>>>>
>>>> +static inline bool kvm_pvtime_supported(void)
>>>> +{
>>>> +       return !!sched_info_on();
>>>> +}
>>>>    #endif /* __ASM_LOONGARCH_KVM_VCPU_H__ */
>>>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
>>>> index eb09adda54b7..7a4633ef284b 100644
>>>> --- a/arch/loongarch/include/asm/loongarch.h
>>>> +++ b/arch/loongarch/include/asm/loongarch.h
>>>> @@ -169,6 +169,7 @@
>>>>    #define  KVM_SIGNATURE                 "KVM\0"
>>>>    #define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
>>>>    #define  KVM_FEATURE_IPI               BIT(1)
>>>> +#define  KVM_FEATURE_STEAL_TIME                BIT(2)
>>>>
>>>>    #ifndef __ASSEMBLY__
>>>>
>>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
>>>> index f9abef382317..ddc5cab0ffd0 100644
>>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
>>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>>>> @@ -81,7 +81,11 @@ struct kvm_fpu {
>>>>    #define LOONGARCH_REG_64(TYPE, REG)    (TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
>>>>    #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
>>>>    #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
>>>> +
>>>> +/* Device Control API on vcpu fd */
>>>>    #define KVM_LOONGARCH_VCPU_CPUCFG      0
>>>> +#define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
>>>> +#define  KVM_LOONGARCH_VCPU_PVTIME_GPA 0
>>>>
>>>>    struct kvm_debug_exit_arch {
>>>>    };
>>>> diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
>>>> index c4ef2b4d9797..248744b4d086 100644
>>>> --- a/arch/loongarch/kvm/Kconfig
>>>> +++ b/arch/loongarch/kvm/Kconfig
>>>> @@ -29,6 +29,7 @@ config KVM
>>>>           select KVM_MMIO
>>>>           select HAVE_KVM_READONLY_MEM
>>>>           select KVM_XFER_TO_GUEST_WORK
>>>> +       select SCHED_INFO
>>>>           help
>>>>             Support hosting virtualized guest machines using
>>>>             hardware virtualization extensions. You will need
>>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>>>> index c86e099af5ca..e2abd97fb13f 100644
>>>> --- a/arch/loongarch/kvm/exit.c
>>>> +++ b/arch/loongarch/kvm/exit.c
>>>> @@ -24,7 +24,7 @@
>>>>    static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
>>>>    {
>>>>           int rd, rj;
>>>> -       unsigned int index;
>>>> +       unsigned int index, ret;
>>>>
>>>>           if (inst.reg2_format.opcode != cpucfg_op)
>>>>                   return EMULATE_FAIL;
>>>> @@ -50,7 +50,10 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
>>>>                   vcpu->arch.gprs[rd] = *(unsigned int *)KVM_SIGNATURE;
>>>>                   break;
>>>>           case CPUCFG_KVM_FEATURE:
>>>> -               vcpu->arch.gprs[rd] = KVM_FEATURE_IPI;
>>>> +               ret = KVM_FEATURE_IPI;
>>>> +               if (sched_info_on())
>>> What about replacing it with your helper function kvm_pvtime_supported()?
>> Sure, will replace it with helper function kvm_pvtime_supported().
> If you are sure this is the only issue, then needn't submit a new version.
OK, thanks.

By searching orginal submit of vcpu_is_preempt(), it can be located at
https://lore.kernel.org/lkml/1477642287-24104-1-git-send-email-xinhui.pan@linux.vnet.ibm.com/

It is separated one, only that is depends on pv-spinlock and 
pv-stealtime. And there is no capability indicator for guest kernel, it 
is enabled by default.

Regards
Bibo Mao

> 
> Huacai
> 
>>
>> Regards
>> Bibo Mao
>>>
>>> Huacai
>>>
>>>> +                       ret |= KVM_FEATURE_STEAL_TIME;
>>>> +               vcpu->arch.gprs[rd] = ret;
>>>>                   break;
>>>>           default:
>>>>                   vcpu->arch.gprs[rd] = 0;
>>>> @@ -687,6 +690,34 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
>>>>           return RESUME_GUEST;
>>>>    }
>>>>
>>>> +static long kvm_save_notify(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +       unsigned long id, data;
>>>> +
>>>> +       id   = kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
>>>> +       data = kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
>>>> +       switch (id) {
>>>> +       case KVM_FEATURE_STEAL_TIME:
>>>> +               if (!kvm_pvtime_supported())
>>>> +                       return KVM_HCALL_INVALID_CODE;
>>>> +
>>>> +               if (data & ~(KVM_STEAL_PHYS_MASK | KVM_STEAL_PHYS_VALID))
>>>> +                       return KVM_HCALL_INVALID_PARAMETER;
>>>> +
>>>> +               vcpu->arch.st.guest_addr = data;
>>>> +               if (!(data & KVM_STEAL_PHYS_VALID))
>>>> +                       break;
>>>> +
>>>> +               vcpu->arch.st.last_steal = current->sched_info.run_delay;
>>>> +               kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>>>> +               break;
>>>> +       default:
>>>> +               break;
>>>> +       };
>>>> +
>>>> +       return 0;
>>>> +};
>>>> +
>>>>    /*
>>>>     * kvm_handle_lsx_disabled() - Guest used LSX while disabled in root.
>>>>     * @vcpu:      Virtual CPU context.
>>>> @@ -758,6 +789,9 @@ static void kvm_handle_service(struct kvm_vcpu *vcpu)
>>>>                   kvm_send_pv_ipi(vcpu);
>>>>                   ret = KVM_HCALL_SUCCESS;
>>>>                   break;
>>>> +       case KVM_HCALL_FUNC_NOTIFY:
>>>> +               ret = kvm_save_notify(vcpu);
>>>> +               break;
>>>>           default:
>>>>                   ret = KVM_HCALL_INVALID_CODE;
>>>>                   break;
>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>> index 9e8030d45129..382796f1d3e6 100644
>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>> @@ -31,6 +31,117 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
>>>>                          sizeof(kvm_vcpu_stats_desc),
>>>>    };
>>>>
>>>> +static void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +       struct kvm_steal_time __user *st;
>>>> +       struct gfn_to_hva_cache *ghc;
>>>> +       struct kvm_memslots *slots;
>>>> +       gpa_t gpa;
>>>> +       u64 steal;
>>>> +       u32 version;
>>>> +
>>>> +       ghc = &vcpu->arch.st.cache;
>>>> +       gpa = vcpu->arch.st.guest_addr;
>>>> +       if (!(gpa & KVM_STEAL_PHYS_VALID))
>>>> +               return;
>>>> +
>>>> +       gpa &= KVM_STEAL_PHYS_MASK;
>>>> +       slots = kvm_memslots(vcpu->kvm);
>>>> +       if (slots->generation != ghc->generation || gpa != ghc->gpa) {
>>>> +               if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa,
>>>> +                                       sizeof(*st))) {
>>>> +                       ghc->gpa = INVALID_GPA;
>>>> +                       return;
>>>> +               }
>>>> +       }
>>>> +
>>>> +       st = (struct kvm_steal_time __user *)ghc->hva;
>>>> +       unsafe_get_user(version, &st->version, out);
>>>> +       if (version & 1)
>>>> +               version += 1;
>>>> +       version += 1;
>>>> +       unsafe_put_user(version, &st->version, out);
>>>> +       smp_wmb();
>>>> +
>>>> +       unsafe_get_user(steal, &st->steal, out);
>>>> +       steal += current->sched_info.run_delay -
>>>> +               vcpu->arch.st.last_steal;
>>>> +       vcpu->arch.st.last_steal = current->sched_info.run_delay;
>>>> +       unsafe_put_user(steal, &st->steal, out);
>>>> +
>>>> +       smp_wmb();
>>>> +       version += 1;
>>>> +       unsafe_put_user(version, &st->version, out);
>>>> +out:
>>>> +       mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
>>>> +}
>>>> +
>>>> +static int kvm_loongarch_pvtime_has_attr(struct kvm_vcpu *vcpu,
>>>> +                                       struct kvm_device_attr *attr)
>>>> +{
>>>> +       if (!kvm_pvtime_supported() ||
>>>> +                       attr->attr != KVM_LOONGARCH_VCPU_PVTIME_GPA)
>>>> +               return -ENXIO;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int kvm_loongarch_pvtime_get_attr(struct kvm_vcpu *vcpu,
>>>> +                                       struct kvm_device_attr *attr)
>>>> +{
>>>> +       u64 __user *user = (u64 __user *)attr->addr;
>>>> +       u64 gpa;
>>>> +
>>>> +       if (!kvm_pvtime_supported() ||
>>>> +                       attr->attr != KVM_LOONGARCH_VCPU_PVTIME_GPA)
>>>> +               return -ENXIO;
>>>> +
>>>> +       gpa = vcpu->arch.st.guest_addr;
>>>> +       if (put_user(gpa, user))
>>>> +               return -EFAULT;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int kvm_loongarch_pvtime_set_attr(struct kvm_vcpu *vcpu,
>>>> +                                       struct kvm_device_attr *attr)
>>>> +{
>>>> +       u64 __user *user = (u64 __user *)attr->addr;
>>>> +       struct kvm *kvm = vcpu->kvm;
>>>> +       u64 gpa;
>>>> +       int ret = 0;
>>>> +       int idx;
>>>> +
>>>> +       if (!kvm_pvtime_supported() ||
>>>> +                       attr->attr != KVM_LOONGARCH_VCPU_PVTIME_GPA)
>>>> +               return -ENXIO;
>>>> +
>>>> +       if (get_user(gpa, user))
>>>> +               return -EFAULT;
>>>> +
>>>> +       if (gpa & ~(KVM_STEAL_PHYS_MASK | KVM_STEAL_PHYS_VALID))
>>>> +               return -EINVAL;
>>>> +
>>>> +       if (!(gpa & KVM_STEAL_PHYS_VALID)) {
>>>> +               vcpu->arch.st.guest_addr = gpa;
>>>> +               return 0;
>>>> +       }
>>>> +
>>>> +       /* Check the address is in a valid memslot */
>>>> +       idx = srcu_read_lock(&kvm->srcu);
>>>> +       if (kvm_is_error_hva(gfn_to_hva(kvm, gpa >> PAGE_SHIFT)))
>>>> +               ret = -EINVAL;
>>>> +       srcu_read_unlock(&kvm->srcu, idx);
>>>> +
>>>> +       if (!ret) {
>>>> +               vcpu->arch.st.guest_addr = gpa;
>>>> +               vcpu->arch.st.last_steal = current->sched_info.run_delay;
>>>> +               kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>>>> +       }
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>>    /*
>>>>     * kvm_check_requests - check and handle pending vCPU requests
>>>>     *
>>>> @@ -48,6 +159,9 @@ static int kvm_check_requests(struct kvm_vcpu *vcpu)
>>>>           if (kvm_dirty_ring_check_request(vcpu))
>>>>                   return RESUME_HOST;
>>>>
>>>> +       if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
>>>> +               kvm_update_stolen_time(vcpu);
>>>> +
>>>>           return RESUME_GUEST;
>>>>    }
>>>>
>>>> @@ -671,6 +785,9 @@ static int kvm_loongarch_vcpu_has_attr(struct kvm_vcpu *vcpu,
>>>>           case KVM_LOONGARCH_VCPU_CPUCFG:
>>>>                   ret = kvm_loongarch_cpucfg_has_attr(vcpu, attr);
>>>>                   break;
>>>> +       case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
>>>> +               ret = kvm_loongarch_pvtime_has_attr(vcpu, attr);
>>>> +               break;
>>>>           default:
>>>>                   break;
>>>>           }
>>>> @@ -703,6 +820,9 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm_vcpu *vcpu,
>>>>           case KVM_LOONGARCH_VCPU_CPUCFG:
>>>>                   ret = kvm_loongarch_get_cpucfg_attr(vcpu, attr);
>>>>                   break;
>>>> +       case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
>>>> +               ret = kvm_loongarch_pvtime_get_attr(vcpu, attr);
>>>> +               break;
>>>>           default:
>>>>                   break;
>>>>           }
>>>> @@ -725,6 +845,9 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
>>>>           case KVM_LOONGARCH_VCPU_CPUCFG:
>>>>                   ret = kvm_loongarch_cpucfg_set_attr(vcpu, attr);
>>>>                   break;
>>>> +       case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
>>>> +               ret = kvm_loongarch_pvtime_set_attr(vcpu, attr);
>>>> +               break;
>>>>           default:
>>>>                   break;
>>>>           }
>>>> @@ -1084,6 +1207,7 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>>>
>>>>           /* Control guest page CCA attribute */
>>>>           change_csr_gcfg(CSR_GCFG_MATC_MASK, CSR_GCFG_MATC_ROOT);
>>>> +       kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>>>>
>>>>           /* Don't bother restoring registers multiple times unless necessary */
>>>>           if (vcpu->arch.aux_inuse & KVM_LARCH_HWCSR_USABLE)
>>>> --
>>>> 2.39.3
>>>>
>>


