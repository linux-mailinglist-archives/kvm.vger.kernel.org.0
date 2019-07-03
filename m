Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 949975E62E
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 16:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfGCONL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 10:13:11 -0400
Received: from foss.arm.com ([217.140.110.172]:49006 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbfGCONL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 10:13:11 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AED2B2B;
        Wed,  3 Jul 2019 07:13:10 -0700 (PDT)
Received: from [10.1.31.185] (unknown [10.1.31.185])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F9943F718;
        Wed,  3 Jul 2019 07:13:09 -0700 (PDT)
Subject: Re: [PATCH 33/59] KVM: arm64: nv: Pretend we only support
 larger-than-host page sizes
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-34-marc.zyngier@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f99c2f11-a59c-485f-a264-69848e1e40c7@arm.com>
Date:   Wed, 3 Jul 2019 15:13:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-34-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/21/19 10:38 AM, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
>
> Exposing memory management support to the virtual EL2 as is exposed to
> the host hypervisor would make the implementation too complex and
> inefficient. Therefore expose limited memory management support for the
> following two cases.
>
> We expose same or larger page granules than the one host uses.  We can
> theoretically support a guest hypervisor having smaller-than-host
> granularities but it is not worth it since it makes the implementation
> complicated and it would waste memory.
>
> We expose 40 bits of physical address range to the virtual EL2, because
> we only support a 40bit IPA for the guest. Eventually, this will change.
>
>   [ This was only trapping on the 32-bit encoding, also using the
>     current target register value as a base for the sanitisation.
>
>     Use as the handler for the 64-bit sysreg as well, also load the
>     sanitised version of the sysreg before clearing and setting bits.
>
>     -- Andre Przywara ]
>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 50 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 49 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ec34b81da936..cc994ec3c121 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1710,6 +1710,54 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool access_id_aa64mmfr0_el1(struct kvm_vcpu *v,
> +				    struct sys_reg_params *p,
> +				    const struct sys_reg_desc *r)
> +{
> +	u64 val;
> +
> +	if (p->is_write)
> +		return write_to_read_only(v, p, r);
> +
> +	val = read_id_reg(v, r, false);
> +
> +	if (!nested_virt_in_use(v))
> +		goto out;
> +
> +	/*
> +	 * Don't expose granules smaller than the host's granule to the guest.
> +	 * We can theoretically support a guest hypervisor having
> +	 * smaller-than-host granularities but it is not worth it since it
> +	 * makes the implementation complicated and it would waste memory.
> +	 */
> +	switch (PAGE_SIZE) {
> +	case SZ_64K:
> +		/* 16KB granule not supported */
> +		val &= ~(0xf << ID_AA64MMFR0_TGRAN16_SHIFT);
> +		val |= (ID_AA64MMFR0_TGRAN16_NI << ID_AA64MMFR0_TGRAN16_SHIFT);
> +		/* fall through */
> +	case SZ_16K:
> +		/* 4KB granule not supported */
> +		val &= ~(0xf << ID_AA64MMFR0_TGRAN4_SHIFT);
> +		val |= (ID_AA64MMFR0_TGRAN4_NI << ID_AA64MMFR0_TGRAN4_SHIFT);
> +		break;
> +	case SZ_4K:
> +		/* All granule sizes are supported */
> +		break;
> +	default:
> +		unreachable();
> +	}
> +
> +	/* Expose only 40 bits physical address range to the guest hypervisor */
> +	val &= ~(0xf << ID_AA64MMFR0_PARANGE_SHIFT);
> +	val |= (0x2 << ID_AA64MMFR0_PARANGE_SHIFT); /* 40 bits */

There are already defines for ID_AA64MMFR0_PARANGE_48 and
ID_AA64MMFR0_PARANGE_52 in sysreg.h, perhaps a similar define for
ID_AA64MMFR0_PARANGE_40 would be appropriate?

> +
> +out:
> +	p->regval = val;
> +
> +	return true;
> +}
> +
>  static bool access_id_aa64pfr0_el1(struct kvm_vcpu *v,
>  				   struct sys_reg_params *p,
>  				   const struct sys_reg_desc *r)
> @@ -1846,7 +1894,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	ID_UNALLOCATED(6,7),
>  
>  	/* CRm=7 */
> -	ID_SANITISED(ID_AA64MMFR0_EL1),
> +	ID_SANITISED_FN(ID_AA64MMFR0_EL1, access_id_aa64mmfr0_el1),
>  	ID_SANITISED(ID_AA64MMFR1_EL1),
>  	ID_SANITISED(ID_AA64MMFR2_EL1),
>  	ID_UNALLOCATED(7,3),
