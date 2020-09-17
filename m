Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826B226D508
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 09:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgIQHr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 03:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgIQHrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 03:47:45 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668A421D41;
        Thu, 17 Sep 2020 07:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600328864;
        bh=AHcC2uC5+PTsZJr+K0lmo8Zm03PStoV6uvu8b/RI32g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MyGv89mNdA2r/eaiDomAUde4Bv6w21F/7UbMt6QEMQPvLQLwaYp7QeMx9Nco/TgmY
         X5rIB6ZyHbqScnG24iUT0s5Uuu7iIsGsDJZJJu7LxnHpC4UkgnOiwC9TYbX6TSMMn3
         o5bsK7mDRv5e4h/hpE8yRurK5VTVLxQQxM6F2FIA=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kIodq-00CZ7w-IE; Thu, 17 Sep 2020 08:47:42 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 17 Sep 2020 08:47:42 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Ying Fang <fangying1@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        zhang.zhanghailiang@huawei.com, alex.chen@huawei.com
Subject: Re: [PATCH 2/2] kvm/arm: Add mp_affinity for arm vcpu
In-Reply-To: <20200917023033.1337-3-fangying1@huawei.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-3-fangying1@huawei.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <7a924b0fb27505a0d8b00389fe2f02df@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: fangying1@huawei.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, zhang.zhanghailiang@huawei.com, alex.chen@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-09-17 03:30, Ying Fang wrote:
> Allow userspace to set MPIDR using vcpu ioctl KVM_ARM_SET_MP_AFFINITY,
> so that we can support cpu topology for arm.

MPIDR has *nothing* to do with CPU topology in the ARM architecture.
I encourage you to have a look at the ARM ARM and find out how often
the word "topology" is used in conjunction with the MPIDR_EL1 register.

> 
> Signed-off-by: Ying Fang <fangying1@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  5 +++++
>  arch/arm64/kvm/arm.c              |  8 ++++++++
>  arch/arm64/kvm/reset.c            | 11 +++++++++++
>  arch/arm64/kvm/sys_regs.c         | 30 +++++++++++++++++++-----------
>  include/uapi/linux/kvm.h          |  2 ++
>  5 files changed, 45 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index e52c927aade5..7adc351ee70a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -372,6 +372,9 @@ struct kvm_vcpu_arch {
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> +
> +	/* vCPU MP Affinity */
> +	u64 mp_affinity;

No. We already have a per-CPU MPIDR_EL1 register, we don't need another
piece of state.

>  };
> 
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> @@ -685,6 +688,8 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned
> long type);
>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
> 
> +int kvm_arm_vcpu_set_mp_affinity(struct kvm_vcpu *vcpu, uint64_t 
> mpidr);
> +
>  #define kvm_arm_vcpu_sve_finalized(vcpu) \
>  	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 913c8da539b3..5f1fa625dc11 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1178,6 +1178,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> 
>  		return kvm_arm_vcpu_finalize(vcpu, what);
>  	}
> +	case KVM_ARM_SET_MP_AFFINITY: {
> +		u64 mpidr;
> +
> +		if (get_user(mpidr, (const unsigned int __user *)argp))
> +			return -EFAULT;
> +
> +		return kvm_arm_vcpu_set_mp_affinity(vcpu, mpidr);
> +	}

That's not the way we access system registers from userspace.

>  	default:
>  		r = -EINVAL;
>  	}
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index ee33875c5c2a..4918c967b0c9 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -188,6 +188,17 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu,
> int feature)
>  	return -EINVAL;
>  }
> 
> +int kvm_arm_vcpu_set_mp_affinity(struct kvm_vcpu *vcpu, uint64_t 
> mpidr)
> +{
> +	if (!(mpidr & (1ULL << 31))) {
> +		pr_warn("invalid mp_affinity format\n");
> +		return -EINVAL;
> +	}
> +
> +	vcpu->arch.mp_affinity = mpidr;

This doesn't match the definition of the MPIDR_EL1 register. It also
doesn't take into account any of the existing restrictions for the
supported affinity levels and number of PEs at the lowest affinity
level.

> +	return 0;
> +}
> +
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 077293b5115f..e76f483475ad 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -646,17 +646,25 @@ static void reset_mpidr(struct kvm_vcpu *vcpu,
> const struct sys_reg_desc *r)
>  {
>  	u64 mpidr;
> 
> -	/*
> -	 * Map the vcpu_id into the first three affinity level fields of
> -	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
> -	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
> -	 * of the GICv3 to be able to address each CPU directly when
> -	 * sending IPIs.
> -	 */
> -	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
> -	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
> -	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
> -	vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
> +	if (vcpu->arch.mp_affinity) {
> +		/* If mp_affinity is set by userspace, it means an customized cpu
> +		 * topology is defined. Let it be MPIDR of the vcpu
> +		 */
> +		mpidr = vcpu->arch.mp_affinity;
> +	} else {
> +		/*
> +		 * Map the vcpu_id into the first three affinity level fields of
> +		 * the MPIDR. We limit the number of VCPUs in level 0 due to a
> +		 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
> +		 * of the GICv3 to be able to address each CPU directly when
> +		 * sending IPIs.
> +		 */
> +		mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
> +		mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
> +		mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
> +		mpidr |= (1ULL << 31);
> +	}
> +	vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
>  }
> 
>  static void reset_pmcr(struct kvm_vcpu *vcpu, const struct 
> sys_reg_desc *r)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index c4874905cd9c..ae45876a689d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1475,6 +1475,8 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct 
> kvm_s390_cmma_log)
>  /* Memory Encryption Commands */
>  #define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, unsigned long)
> +/* Available with KVM_CAP_ARM_MP_AFFINITY */
> +#define KVM_ARM_SET_MP_AFFINITY    _IOWR(KVMIO, 0xbb, unsigned long)
> 
>  struct kvm_enc_region {
>  	__u64 addr;

As it is, this patch is unacceptable. It ignores the requirements of the
architecture, as well as those of imposed by KVM as a platform.
It also pointlessly creates additional state and invents unnecessary
userspace interfaces. In short, it requires some *major* rework.

         M.
-- 
Jazz is not dead. It just smells funny...
