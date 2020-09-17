Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7692B26D4D4
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 09:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgIQHiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 03:38:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726216AbgIQHiF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 03:38:05 -0400
X-Greylist: delayed 781 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 03:38:04 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600328281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3rlyAdPxuDDdYl6D+KuRAOOnbWwfRjh+5D1CNq4eG4k=;
        b=NBikgR7tZXxhG7SRo2Q6v65y4LB0QgSVu7+Er9P/dQF/mdTgf7ZyLPU1S1R/Pw5mBO7QSV
        23su0TjSMc43gJe410LJSaLmxesItiaD7gmAAnVJ6/DALNlhQlYy9K8EdBa+AgOHmWC5uI
        xjI9oP5Als1k/yCFtCDtCcLvgcJy9MM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-7wc_RQFJMu-8OGuZyN-5Ng-1; Thu, 17 Sep 2020 03:36:47 -0400
X-MC-Unique: 7wc_RQFJMu-8OGuZyN-5Ng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 989451084D6E;
        Thu, 17 Sep 2020 07:36:45 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.179])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EA1D67600;
        Thu, 17 Sep 2020 07:36:42 +0000 (UTC)
Date:   Thu, 17 Sep 2020 09:36:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ying Fang <fangying1@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, zhang.zhanghailiang@huawei.com,
        alex.chen@huawei.com
Subject: Re: [PATCH 2/2] kvm/arm: Add mp_affinity for arm vcpu
Message-ID: <20200917073639.zjwae3izyyxl6p6w@kamzik.brq.redhat.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-3-fangying1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917023033.1337-3-fangying1@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 10:30:33AM +0800, Ying Fang wrote:
> Allow userspace to set MPIDR using vcpu ioctl KVM_ARM_SET_MP_AFFINITY,
> so that we can support cpu topology for arm.
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
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
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

We probably don't need to introduce new state since we already have a
place for it in the sys_regs array.

>  };
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> @@ -685,6 +688,8 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>  
> +int kvm_arm_vcpu_set_mp_affinity(struct kvm_vcpu *vcpu, uint64_t mpidr);
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

Why introduce a new ioctl? We already have SET_ONE_REG.

>  	default:
>  		r = -EINVAL;
>  	}
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index ee33875c5c2a..4918c967b0c9 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -188,6 +188,17 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
>  	return -EINVAL;
>  }
>  
> +int kvm_arm_vcpu_set_mp_affinity(struct kvm_vcpu *vcpu, uint64_t mpidr)
> +{
> +	if (!(mpidr & (1ULL << 31))) {
> +		pr_warn("invalid mp_affinity format\n");
> +		return -EINVAL;
> +	}
> +
> +	vcpu->arch.mp_affinity = mpidr;

No sanity checks? If you look at what I once posted [*] you'll see that I
checked reserved bits, flags consistency, and ID uniqueness.

[*] https://www.spinics.net/lists/kvm-arm/msg23879.html

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
> @@ -646,17 +646,25 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
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
>  static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index c4874905cd9c..ae45876a689d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1475,6 +1475,8 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
>  /* Memory Encryption Commands */
>  #define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, unsigned long)
> +/* Available with KVM_CAP_ARM_MP_AFFINITY */
> +#define KVM_ARM_SET_MP_AFFINITY    _IOWR(KVMIO, 0xbb, unsigned long)
>  
>  struct kvm_enc_region {
>  	__u64 addr;
> -- 
> 2.23.0
> 

I suggest approaching this the same way Alex Graf approached PMCR in
https://www.spinics.net/lists/arm-kernel/msg837016.html but also add
sanity checks. The previous patch can also be squashed into this patch.

Thanks,
drew

