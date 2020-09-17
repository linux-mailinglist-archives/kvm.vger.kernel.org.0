Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9501F26DAC6
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 13:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgIQLv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 07:51:57 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39920 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726764AbgIQLvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 07:51:49 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6EBB7B9CD01997F6A4FA;
        Thu, 17 Sep 2020 19:51:47 +0800 (CST)
Received: from [10.174.185.104] (10.174.185.104) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 19:51:40 +0800
Subject: Re: [PATCH 2/2] kvm/arm: Add mp_affinity for arm vcpu
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <drjones@redhat.com>, <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <suzuki.poulose@arm.com>,
        <zhang.zhanghailiang@huawei.com>, <alex.chen@huawei.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-3-fangying1@huawei.com>
 <7a924b0fb27505a0d8b00389fe2f02df@kernel.org>
From:   Ying Fang <fangying1@huawei.com>
Message-ID: <0772755c-d337-a994-5a85-11e168038e7e@huawei.com>
Date:   Thu, 17 Sep 2020 19:51:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <7a924b0fb27505a0d8b00389fe2f02df@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.185.104]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/17/2020 3:47 PM, Marc Zyngier wrote:
> On 2020-09-17 03:30, Ying Fang wrote:
>> Allow userspace to set MPIDR using vcpu ioctl KVM_ARM_SET_MP_AFFINITY,
>> so that we can support cpu topology for arm.
> 
> MPIDR has *nothing* to do with CPU topology in the ARM architecture.
> I encourage you to have a look at the ARM ARM and find out how often
> the word "topology" is used in conjunction with the MPIDR_EL1 register.
> 
>>
>> Signed-off-by: Ying Fang <fangying1@huawei.com>
>> ---
>>  arch/arm64/include/asm/kvm_host.h |  5 +++++
>>  arch/arm64/kvm/arm.c              |  8 ++++++++
>>  arch/arm64/kvm/reset.c            | 11 +++++++++++
>>  arch/arm64/kvm/sys_regs.c         | 30 +++++++++++++++++++-----------
>>  include/uapi/linux/kvm.h          |  2 ++
>>  5 files changed, 45 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h
>> b/arch/arm64/include/asm/kvm_host.h
>> index e52c927aade5..7adc351ee70a 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -372,6 +372,9 @@ struct kvm_vcpu_arch {
>>          u64 last_steal;
>>          gpa_t base;
>>      } steal;
>> +
>> +    /* vCPU MP Affinity */
>> +    u64 mp_affinity;
> 
> No. We already have a per-CPU MPIDR_EL1 register, we don't need another
> piece of state.
I am also not sure if it is needed here.
> 
>>  };
>>
>>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>> @@ -685,6 +688,8 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned
>> long type);
>>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>>
>> +int kvm_arm_vcpu_set_mp_affinity(struct kvm_vcpu *vcpu, uint64_t mpidr);
>> +
>>  #define kvm_arm_vcpu_sve_finalized(vcpu) \
>>      ((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 913c8da539b3..5f1fa625dc11 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1178,6 +1178,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>
>>          return kvm_arm_vcpu_finalize(vcpu, what);
>>      }
>> +    case KVM_ARM_SET_MP_AFFINITY: {
>> +        u64 mpidr;
>> +
>> +        if (get_user(mpidr, (const unsigned int __user *)argp))
>> +            return -EFAULT;
>> +
>> +        return kvm_arm_vcpu_set_mp_affinity(vcpu, mpidr);
>> +    }
> 
> That's not the way we access system registers from userspace.

I know that we already had the KVM_SET_ONE_REG api and well designed
sys_regs subsystem.

However when I tried to set MPIDR using the KVM_SET_ONE_REG api in 
kvm_arch_init_vcpu, the value may get erased by cpu_reset called within 
arm_cpu_realizefn. Maybe we should make change on qemu instead of adding
this redundant ioctl.

> 
>>      default:
>>          r = -EINVAL;
>>      }
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index ee33875c5c2a..4918c967b0c9 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -188,6 +188,17 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu,
>> int feature)
>>      return -EINVAL;
>>  }
>>
>> +int kvm_arm_vcpu_set_mp_affinity(struct kvm_vcpu *vcpu, uint64_t mpidr)
>> +{
>> +    if (!(mpidr & (1ULL << 31))) {
>> +        pr_warn("invalid mp_affinity format\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    vcpu->arch.mp_affinity = mpidr;
> 
> This doesn't match the definition of the MPIDR_EL1 register. It also
> doesn't take into account any of the existing restrictions for the
> supported affinity levels and number of PEs at the lowest affinity
> level.
Yes, we should do sanity check here and we must keep the format of MPIDR
following the Spec definition.

> 
>> +    return 0;
>> +}
>> +
>>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>>  {
>>      if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 077293b5115f..e76f483475ad 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -646,17 +646,25 @@ static void reset_mpidr(struct kvm_vcpu *vcpu,
>> const struct sys_reg_desc *r)
>>  {
>>      u64 mpidr;
>>
>> -    /*
>> -     * Map the vcpu_id into the first three affinity level fields of
>> -     * the MPIDR. We limit the number of VCPUs in level 0 due to a
>> -     * limitation to 16 CPUs in that level in the ICC_SGIxR registers
>> -     * of the GICv3 to be able to address each CPU directly when
>> -     * sending IPIs.
>> -     */
>> -    mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
>> -    mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
>> -    mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
>> -    vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
>> +    if (vcpu->arch.mp_affinity) {
>> +        /* If mp_affinity is set by userspace, it means an customized 
>> cpu
>> +         * topology is defined. Let it be MPIDR of the vcpu
>> +         */
>> +        mpidr = vcpu->arch.mp_affinity;
>> +    } else {
>> +        /*
>> +         * Map the vcpu_id into the first three affinity level fields of
>> +         * the MPIDR. We limit the number of VCPUs in level 0 due to a
>> +         * limitation to 16 CPUs in that level in the ICC_SGIxR 
>> registers
>> +         * of the GICv3 to be able to address each CPU directly when
>> +         * sending IPIs.
>> +         */
>> +        mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
>> +        mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
>> +        mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
>> +        mpidr |= (1ULL << 31);
>> +    }
>> +    vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
>>  }
>>
>>  static void reset_pmcr(struct kvm_vcpu *vcpu, const struct 
>> sys_reg_desc *r)
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index c4874905cd9c..ae45876a689d 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1475,6 +1475,8 @@ struct kvm_s390_ucas_mapping {
>>  #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct 
>> kvm_s390_cmma_log)
>>  /* Memory Encryption Commands */
>>  #define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, unsigned long)
>> +/* Available with KVM_CAP_ARM_MP_AFFINITY */
>> +#define KVM_ARM_SET_MP_AFFINITY    _IOWR(KVMIO, 0xbb, unsigned long)
>>
>>  struct kvm_enc_region {
>>      __u64 addr;
> 
> As it is, this patch is unacceptable. It ignores the requirements of the
> architecture, as well as those of imposed by KVM as a platform.
> It also pointlessly creates additional state and invents unnecessary
> userspace interfaces. In short, it requires some *major* rework.

Yes, thanks for your comments.

We should set MPIDR from userspace in another elegant way.
I'll drop this and figure it out.
> 
>          M.
