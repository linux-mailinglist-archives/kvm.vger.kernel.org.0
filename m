Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0305A56C306
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239763AbiGHTjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 15:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239873AbiGHTjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 15:39:10 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C5887364
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 12:39:05 -0700 (PDT)
Date:   Fri, 8 Jul 2022 12:38:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657309143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5d+WLe+pPY6KD27qmvuAK3CNfwmt7KukfTGSfmdEEk0=;
        b=O+oE0vNQ4vaiyzdkCSa3zinQVkgkJGpPNH4goYM/n1VCvZVp0tbhLxGq0GGCXGWRA8pYm2
        y4jgINWRB5Fur+TSByewkHAAP2IYoqP5DhFVzGgav4qkm60izuYgZSuIQN/F7qFAxcTjjh
        x/wDgti3OfeHGRzaQjDyjQpyuGTmg9E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: Re: [PATCH 07/19] KVM: arm64: vgic-v3: Simplify
 vgic_v3_has_cpu_sysregs_attr()
Message-ID: <YsiH0lLs+wXX+rUU@google.com>
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-8-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706164304.1582687-8-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022 at 05:42:52PM +0100, Marc Zyngier wrote:
> Finding out whether a sysreg exists has little to do with that
> register being accessed, so drop the is_write parameter.
> 
> Also, the reg pointer is completely unused, and we're better off
> just passing the attr pointer to the function.
> 
> This result in a small cleanup of the calling site, with a new
> helper converting the vGIC view of a sysreg into the canonical
> one (this is purely cosmetic, as the encoding is the same).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/kvm/vgic-sys-reg-v3.c   | 14 ++++++++++----
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c |  8 ++------
>  arch/arm64/kvm/vgic/vgic.h         |  3 +--
>  3 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> index 644acda33c7c..85a5e1d15e9f 100644
> --- a/arch/arm64/kvm/vgic-sys-reg-v3.c
> +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> @@ -260,12 +260,18 @@ static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
>  	{ SYS_DESC(SYS_ICC_IGRPEN1_EL1), access_gic_grpen1 },
>  };
>  
> -int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> -				u64 *reg)
> +static u64 attr_to_id(u64 attr)
>  {
> -	u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
> +	return ARM64_SYS_REG(FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP0_MASK, attr),
> +			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP1_MASK, attr),
> +			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_CRN_MASK, attr),
> +			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_CRM_MASK, attr),
> +			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP2_MASK, attr));
> +}
>  
> -	if (get_reg_by_id(sysreg, gic_v3_icc_reg_descs,
> +int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +	if (get_reg_by_id(attr_to_id(attr->attr), gic_v3_icc_reg_descs,
>  			  ARRAY_SIZE(gic_v3_icc_reg_descs)))
>  		return 0;
>  
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index f15e29cc63ce..a2ff73899976 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -986,12 +986,8 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>  		iodev.base_addr = 0;
>  		break;
>  	}
> -	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
> -		u64 reg, id;
> -
> -		id = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
> -		return vgic_v3_has_cpu_sysregs_attr(vcpu, 0, id, &reg);
> -	}
> +	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
> +		return vgic_v3_has_cpu_sysregs_attr(vcpu, attr);
>  	default:
>  		return -ENXIO;
>  	}
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 4c6bdd321faa..ffc2d3c81b28 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -247,8 +247,7 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
>  int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 u64 id, u64 *val);
> -int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> -				u64 *reg);
> +int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  				    u32 intid, u64 *val);
>  int kvm_register_vgic_device(unsigned long type);
> -- 
> 2.34.1
> 
