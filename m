Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BB8767330
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 19:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbjG1RYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 13:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbjG1RYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 13:24:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C952135
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 10:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690565001;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k9ue5+M0UVHXIqHrg18PcoY1AWSYqrOPTntH0TZlhww=;
        b=QJKSQrQKCxk/SxCkdL7SXYiaY+D8NFOgjfunqZyRW+4wxBhIfOGuR9PFlKHCnFCCEOuJ66
        /z+NmFk9HO0/NGrHO7ccHKcCdRq5+G9YrMTYQF4ZY68gsmkJ/NAmdR0Lt8bh3OcHxBJLcG
        F3nxUSVoogm6azNCLU1P/eaxYvr39mg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-r3wbnA_RM5m_0nfveUwRlQ-1; Fri, 28 Jul 2023 13:23:19 -0400
X-MC-Unique: r3wbnA_RM5m_0nfveUwRlQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-31455dcc30eso1463025f8f.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 10:23:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690564998; x=1691169798;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k9ue5+M0UVHXIqHrg18PcoY1AWSYqrOPTntH0TZlhww=;
        b=es3iWMRvtNz1ajszIBe/2avIg0PYQ/vj3CylRfJhfJ8jrnvh99+pvp/1T+4+vtt7ah
         cNntL62P7ov0FkA96U/atXI5otyLDaXmjr4sOeaqyXDOIJEdz40cnyYCd7QWaAUDSn4G
         1h+pM5lR9guZhUDSbWMzN4caqU8DdIzm28ekVj7P1SEc94dQ4Wp13w8ieTVLmybIP4q8
         jpALbdf69LEmKCUNiYT5zXFyIHxbYYbmX5sJ21jingPiGQGQit887deNomZlzvmwvN1k
         RdR2wt89qgCJN+zW/bUzeakwsrkTDf6JctdW6teS4pMGT/cedRSSPnOi4pwThvYJxLcm
         7MxQ==
X-Gm-Message-State: ABy/qLZPUsmbbk909XcfaJjy/Sbmm6znUwmFQDkqh8o5ASY5WIXwdg+G
        EIU536Ypj4RYZo/BOBMaeUX+bo6ZE8kNSA5W/fIRX0MlaJE/dLbXjSF7Mn3e9qK1sgxFU+aBCBJ
        /MAQ2lBzgrDyx
X-Received: by 2002:adf:f185:0:b0:314:385d:6099 with SMTP id h5-20020adff185000000b00314385d6099mr2399773wro.35.1690564998606;
        Fri, 28 Jul 2023 10:23:18 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEGYZu2QxtsVACS/TgzPm/CNlbXj/IMRbAR3jgW5sDBE72pnAxOkqrrKamNY1Bz2ghpieI2EQ==
X-Received: by 2002:adf:f185:0:b0:314:385d:6099 with SMTP id h5-20020adff185000000b00314385d6099mr2399766wro.35.1690564998395;
        Fri, 28 Jul 2023 10:23:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id l6-20020a5d4806000000b003143ac73fd0sm5412046wrq.1.2023.07.28.10.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jul 2023 10:23:17 -0700 (PDT)
Message-ID: <074dc49f-438d-b842-2120-a3bdc1b978cf@redhat.com>
Date:   Fri, 28 Jul 2023 19:23:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 13/26] KVM: arm64: Restructure FGT register switching
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-14-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230728082952.959212-14-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/28/23 10:29, Marc Zyngier wrote:
> As we're about to majorly extend the handling of FGT registers,
> restructure the code to actually save/restore the registers
> as required. This is made easy thanks to the previous addition
> of the EL2 registers, allowing us to use the host context for
> this purpose.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h        | 21 ++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 56 +++++++++++++------------
>  2 files changed, 50 insertions(+), 27 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 028049b147df..85908aa18908 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -333,6 +333,27 @@
>  				 BIT(18) |		\
>  				 GENMASK(16, 15))
>  
> +/*
> + * FGT register definitions
> + *
> + * RES0 and polarity masks as of DDI0487J.a, to be updated as needed.
> + * We're not using the generated masks as they are usually ahead of
> + * the published ARM ARM, which we use as a reference.
> + *
> + * Once we get to a point where the two describe the same thing, we'll
> + * merge the definitions. One day.
> + */
> +#define __HFGRTR_EL2_RES0	(GENMASK(63, 56) | GENMASK(53, 51))
> +#define __HFGRTR_EL2_MASK	GENMASK(49, 0)
> +#define __HFGRTR_EL2_nMASK	(GENMASK(55, 54) | BIT(50))
> +
> +#define __HFGWTR_EL2_RES0	(GENMASK(63, 56) | GENMASK(53, 51) |	\
> +				 BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
> +				 GENMASK(26, 25) | BIT(21) | BIT(18) |	\
> +				 GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
> +#define __HFGWTR_EL2_MASK	GENMASK(49, 0)
> +#define __HFGWTR_EL2_nMASK	(GENMASK(55, 54) | BIT(50))
> +
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK	(~UL(0xf))
>  /*
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 4bddb8541bec..966295178aee 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -70,20 +70,19 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -static inline bool __hfgxtr_traps_required(void)
> -{
> -	if (cpus_have_final_cap(ARM64_SME))
> -		return true;
> -
> -	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> -		return true;
>  
> -	return false;
> -}
>  
> -static inline void __activate_traps_hfgxtr(void)
> +static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
>  	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
> +	u64 r_val, w_val;
> +
> +	if (!cpus_have_final_cap(ARM64_HAS_FGT))
> +		return;
> +
> +	ctxt_sys_reg(hctxt, HFGRTR_EL2) = read_sysreg_s(SYS_HFGRTR_EL2);
> +	ctxt_sys_reg(hctxt, HFGWTR_EL2) = read_sysreg_s(SYS_HFGWTR_EL2);
>  
>  	if (cpus_have_final_cap(ARM64_SME)) {
>  		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
> @@ -98,26 +97,31 @@ static inline void __activate_traps_hfgxtr(void)
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
>  		w_set |= HFGxTR_EL2_TCR_EL1_MASK;
>  
> -	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
> -	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
> +
> +	/* The default is not to trap amything but ACCDATA_EL1 */
> +	r_val = __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
> +	r_val |= r_set;
> +	r_val &= ~r_clr;
> +
> +	w_val = __HFGWTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
> +	w_val |= w_set;
> +	w_val &= ~w_clr;
> +
> +	write_sysreg_s(r_val, SYS_HFGRTR_EL2);
> +	write_sysreg_s(w_val, SYS_HFGWTR_EL2);
>  }
>  
> -static inline void __deactivate_traps_hfgxtr(void)
> +static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  {
> -	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
> +	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
>  
> -	if (cpus_have_final_cap(ARM64_SME)) {
> -		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
> +	if (!cpus_have_final_cap(ARM64_HAS_FGT))
> +		return;
>  
> -		r_set |= tmp;
> -		w_set |= tmp;
> -	}
> +	write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
> +	write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
>  
> -	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> -		w_clr |= HFGxTR_EL2_TCR_EL1_MASK;
>  
> -	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
> -	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
>  }
>  
>  static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> @@ -145,8 +149,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>  
> -	if (__hfgxtr_traps_required())
> -		__activate_traps_hfgxtr();
> +	__activate_traps_hfgxtr(vcpu);
>  }
>  
>  static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
> @@ -162,8 +165,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
>  		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
>  	}
>  
> -	if (__hfgxtr_traps_required())
> -		__deactivate_traps_hfgxtr();
> +	__deactivate_traps_hfgxtr(vcpu);
>  }
>  
>  static inline void ___activate_traps(struct kvm_vcpu *vcpu)

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

