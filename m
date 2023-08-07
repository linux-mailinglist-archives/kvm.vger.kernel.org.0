Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EB3772539
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 15:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjHGNPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 09:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjHGNPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 09:15:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796B7B3
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 06:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691414053;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dv2Nfm9aNkY4uLvGrSmBJ4eTnNJ17/ZlzGmDOwKHMUQ=;
        b=fQfmh3jcFsi4LfWpQp+R2TB+TxIksHnsT93bWP0HMMlAXB4CaYuPft1U1BFyluWedqAwTC
        SsjTSIwCJJY4jTZTmpWAaWk68cQSyrbVoHUYxhIYyJRHhned/SbNwzQB5QaVv+NmfTkW8r
        UE4npVIi1tPPYzv1e2NO4osdVvPsb5I=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-9mu73-TCNO-BOKuv4ZpldQ-1; Mon, 07 Aug 2023 09:14:12 -0400
X-MC-Unique: 9mu73-TCNO-BOKuv4ZpldQ-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b9fa64dba8so42632851fa.0
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 06:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691414051; x=1692018851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dv2Nfm9aNkY4uLvGrSmBJ4eTnNJ17/ZlzGmDOwKHMUQ=;
        b=Uy+jMQ7cRdkrMa94/nvCn6fVG60XVfbBv9fZxhSLreJhuoS1V5CoXn76ThZAzLOaoE
         UySDY1VcayjFP4SfN+wFPJ8Ktjs0tUQlvPZZmQxmR8gaf7HoXnSSCA70nZjYeHN5xnjY
         i7fjGt7Mblgh5aLoLb0C1SsOi0ioh+d2HWAKRhgsdC0w61P0g9w0ZWcxuAjj4OSSEEvv
         52+k3QJm2jbDD4IdYDA8iqxl0SRkQ3TjMKO4UMUXsIOUXgJr/8OkVb7RF2uSwsjRBmFK
         KOPyBG7zpLx5396sVTcjkB/dpFA+9r+DPWS8Yihlr9fZZXhY44MSO0MxvoUPVXEDEFbX
         gJxA==
X-Gm-Message-State: AOJu0YxqzmZdgCmSHcWgfjoyi8W/k1Eh4zcZUDi2szdphft3hdEEPCBM
        PLmH2fCdVqLHWWK72sbuZwDhEMrEW+qbRLnB4f+OuCKurtYfdWkrSKjfsqWZmUhwIVy+0rxGllQ
        vJP9rj3qhgEq4
X-Received: by 2002:a05:651c:14c:b0:2b9:e053:7a07 with SMTP id c12-20020a05651c014c00b002b9e0537a07mr5981102ljd.45.1691414050936;
        Mon, 07 Aug 2023 06:14:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEt6kv6AQv90Pg+ohq034x/nkNV4LHFX3zG/F2vylittWcIpLWvLnLIqFpeWbVeNgH/keCt6Q==
X-Received: by 2002:a05:651c:14c:b0:2b9:e053:7a07 with SMTP id c12-20020a05651c014c00b002b9e0537a07mr5981077ljd.45.1691414050581;
        Mon, 07 Aug 2023 06:14:10 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 23-20020a05600c229700b003fbdd5d0758sm10742100wmf.22.2023.08.07.06.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Aug 2023 06:14:09 -0700 (PDT)
Message-ID: <d7a3e173-f66c-8885-9550-8d0d9768111f@redhat.com>
Date:   Mon, 7 Aug 2023 15:14:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 19/26] KVM: arm64: nv: Add trap forwarding for
 HFGxTR_EL2
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
 <20230728082952.959212-20-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230728082952.959212-20-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/28/23 10:29, Marc Zyngier wrote:
> Fine Grained Traps are fun. Not.
>
> Implement the trap forwarding for traps describer by HFGxTR_EL2,
described
> reusing the Coarse Grained Traps infrastructure previously implemented.
>
> Each sysreg/instruction inserted in the xarray gets a FGT group
> (vaguely equivalent to a register number), a bit number in that register,
> and a polarity.
>
> It is then pretty easy to check the FGT state at handling time, just
> like we do for the coarse version (it is just faster).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 133 +++++++++++++++++++++++++++++++-
>  1 file changed, 132 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 74b67895c791..5f4cf824eadc 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -922,6 +922,88 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
>  
>  static DEFINE_XARRAY(sr_forward_xa);
>  
> +enum fgt_group_id {
> +	__NO_FGT_GROUP__,
> +	HFGxTR_GROUP,
> +};
> +
> +#define SR_FGT(sr, g, b, p)					\
> +	{							\
> +		.encoding	= sr,				\
> +		.end		= sr,				\
> +		.tc		= {				\
> +			.fgt = g ## _GROUP,			\
> +			.bit = g ## _EL2_ ## b ## _SHIFT,	\
> +			.pol = p,				\
> +		},						\
> +	}
> +
> +static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
> +	/* HFGTR_EL2, HFGWTR_EL2 */
HFGRTR_EL2
> +	SR_FGT(SYS_TPIDR2_EL0,		HFGxTR, nTPIDR2_EL0, 0),
> +	SR_FGT(SYS_SMPRI_EL1,		HFGxTR, nSMPRI_EL1, 0),
> +	SR_FGT(SYS_ACCDATA_EL1,		HFGxTR, nACCDATA_EL1, 0),
> +	SR_FGT(SYS_ERXADDR_EL1,		HFGxTR, ERXADDR_EL1, 1),
> +	SR_FGT(SYS_ERXPFGCDN_EL1,	HFGxTR, ERXPFGCDN_EL1, 1),
> +	SR_FGT(SYS_ERXPFGCTL_EL1,	HFGxTR, ERXPFGCTL_EL1, 1),
> +	SR_FGT(SYS_ERXPFGF_EL1,		HFGxTR, ERXPFGF_EL1, 1),
> +	SR_FGT(SYS_ERXMISC0_EL1,	HFGxTR, ERXMISCn_EL1, 1),
> +	SR_FGT(SYS_ERXMISC1_EL1,	HFGxTR, ERXMISCn_EL1, 1),
> +	SR_FGT(SYS_ERXMISC2_EL1,	HFGxTR, ERXMISCn_EL1, 1),
> +	SR_FGT(SYS_ERXMISC3_EL1,	HFGxTR, ERXMISCn_EL1, 1),
> +	SR_FGT(SYS_ERXSTATUS_EL1,	HFGxTR, ERXSTATUS_EL1, 1),
> +	SR_FGT(SYS_ERXCTLR_EL1,		HFGxTR, ERXCTLR_EL1, 1),
> +	SR_FGT(SYS_ERXFR_EL1,		HFGxTR, ERXFR_EL1, 1),
> +	SR_FGT(SYS_ERRSELR_EL1,		HFGxTR, ERRSELR_EL1, 1),
> +	SR_FGT(SYS_ERRIDR_EL1,		HFGxTR, ERRIDR_EL1, 1),
> +	SR_FGT(SYS_ICC_IGRPEN0_EL1,	HFGxTR, ICC_IGRPENn_EL1, 1),
> +	SR_FGT(SYS_ICC_IGRPEN1_EL1,	HFGxTR, ICC_IGRPENn_EL1, 1),
> +	SR_FGT(SYS_VBAR_EL1,		HFGxTR, VBAR_EL1, 1),
> +	SR_FGT(SYS_TTBR1_EL1,		HFGxTR, TTBR1_EL1, 1),
> +	SR_FGT(SYS_TTBR0_EL1,		HFGxTR, TTBR0_EL1, 1),
> +	SR_FGT(SYS_TPIDR_EL0,		HFGxTR, TPIDR_EL0, 1),
> +	SR_FGT(SYS_TPIDRRO_EL0,		HFGxTR, TPIDRRO_EL0, 1),
> +	SR_FGT(SYS_TPIDR_EL1,		HFGxTR, TPIDR_EL1, 1),
> +	SR_FGT(SYS_TCR_EL1,		HFGxTR, TCR_EL1, 1),
> +	SR_FGT(SYS_SCXTNUM_EL0,		HFGxTR, SCXTNUM_EL0, 1),
> +	SR_FGT(SYS_SCXTNUM_EL1, 	HFGxTR, SCXTNUM_EL1, 1),
> +	SR_FGT(SYS_SCTLR_EL1, 		HFGxTR, SCTLR_EL1, 1),
> +	SR_FGT(SYS_REVIDR_EL1, 		HFGxTR, REVIDR_EL1, 1),
> +	SR_FGT(SYS_PAR_EL1, 		HFGxTR, PAR_EL1, 1),
> +	SR_FGT(SYS_MPIDR_EL1, 		HFGxTR, MPIDR_EL1, 1),
> +	SR_FGT(SYS_MIDR_EL1, 		HFGxTR, MIDR_EL1, 1),
> +	SR_FGT(SYS_MAIR_EL1, 		HFGxTR, MAIR_EL1, 1),
> +	SR_FGT(SYS_LORSA_EL1, 		HFGxTR, LORSA_EL1, 1),
> +	SR_FGT(SYS_LORN_EL1, 		HFGxTR, LORN_EL1, 1),
> +	SR_FGT(SYS_LORID_EL1, 		HFGxTR, LORID_EL1, 1),
> +	SR_FGT(SYS_LOREA_EL1, 		HFGxTR, LOREA_EL1, 1),
> +	SR_FGT(SYS_LORC_EL1, 		HFGxTR, LORC_EL1, 1),
> +	SR_FGT(SYS_ISR_EL1, 		HFGxTR, ISR_EL1, 1),
> +	SR_FGT(SYS_FAR_EL1, 		HFGxTR, FAR_EL1, 1),
> +	SR_FGT(SYS_ESR_EL1, 		HFGxTR, ESR_EL1, 1),
> +	SR_FGT(SYS_DCZID_EL0, 		HFGxTR, DCZID_EL0, 1),
> +	SR_FGT(SYS_CTR_EL0, 		HFGxTR, CTR_EL0, 1),
> +	SR_FGT(SYS_CSSELR_EL1, 		HFGxTR, CSSELR_EL1, 1),
> +	SR_FGT(SYS_CPACR_EL1, 		HFGxTR, CPACR_EL1, 1),
> +	SR_FGT(SYS_CONTEXTIDR_EL1, 	HFGxTR, CONTEXTIDR_EL1, 1),
> +	SR_FGT(SYS_CLIDR_EL1, 		HFGxTR, CLIDR_EL1, 1),
> +	SR_FGT(SYS_CCSIDR_EL1, 		HFGxTR, CCSIDR_EL1, 1),
> +	SR_FGT(SYS_APIBKEYLO_EL1, 	HFGxTR, APIBKey, 1),
> +	SR_FGT(SYS_APIBKEYHI_EL1, 	HFGxTR, APIBKey, 1),
> +	SR_FGT(SYS_APIAKEYLO_EL1, 	HFGxTR, APIAKey, 1),
> +	SR_FGT(SYS_APIAKEYHI_EL1, 	HFGxTR, APIAKey, 1),
> +	SR_FGT(SYS_APGAKEYLO_EL1, 	HFGxTR, APGAKey, 1),
> +	SR_FGT(SYS_APGAKEYHI_EL1, 	HFGxTR, APGAKey, 1),
> +	SR_FGT(SYS_APDBKEYLO_EL1, 	HFGxTR, APDBKey, 1),
> +	SR_FGT(SYS_APDBKEYHI_EL1, 	HFGxTR, APDBKey, 1),
> +	SR_FGT(SYS_APDAKEYLO_EL1, 	HFGxTR, APDAKey, 1),
> +	SR_FGT(SYS_APDAKEYHI_EL1, 	HFGxTR, APDAKey, 1),
> +	SR_FGT(SYS_AMAIR_EL1, 		HFGxTR, AMAIR_EL1, 1),
> +	SR_FGT(SYS_AIDR_EL1, 		HFGxTR, AIDR_EL1, 1),
> +	SR_FGT(SYS_AFSR1_EL1, 		HFGxTR, AFSR1_EL1, 1),
> +	SR_FGT(SYS_AFSR0_EL1, 		HFGxTR, AFSR0_EL1, 1),
> +};
> +
>  static union trap_config get_trap_config(u32 sysreg)
>  {
>  	return (union trap_config) {
> @@ -943,6 +1025,27 @@ void __init populate_nv_trap_config(void)
>  	kvm_info("nv: %ld coarse grained trap handlers\n",
>  		 ARRAY_SIZE(encoding_to_cgt));
>  
> +	for (int i = 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
> +		const struct encoding_to_trap_config *fgt = &encoding_to_fgt[i];
> +		union trap_config tc;
> +
> +		tc = get_trap_config(fgt->encoding);
> +
> +		WARN(tc.fgt,
> +		     "Duplicate FGT for sys_reg(%d, %d, %d, %d, %d)\n",
> +		     sys_reg_Op0(fgt->encoding),
> +		     sys_reg_Op1(fgt->encoding),
> +		     sys_reg_CRn(fgt->encoding),
> +		     sys_reg_CRm(fgt->encoding),
> +		     sys_reg_Op2(fgt->encoding));
> +
> +		tc.val |= fgt->tc.val;
> +		xa_store(&sr_forward_xa, fgt->encoding,
> +			 xa_mk_value(tc.val), GFP_KERNEL);
> +	}
> +
> +	kvm_info("nv: %ld fine grained trap handlers\n",
> +		 ARRAY_SIZE(encoding_to_fgt));
>  }
>  
>  static enum trap_behaviour get_behaviour(struct kvm_vcpu *vcpu,
> @@ -992,13 +1095,26 @@ static enum trap_behaviour compute_trap_behaviour(struct kvm_vcpu *vcpu,
>  	return __do_compute_trap_behaviour(vcpu, tc.cgt, b);
>  }
>  
> +static bool check_fgt_bit(u64 val, const union trap_config tc)
> +{
> +	return ((val >> tc.bit) & 1) == tc.pol;
> +}
> +
> +#define sanitised_sys_reg(vcpu, reg)			\
> +	({						\
> +		u64 __val;				\
> +		__val = __vcpu_sys_reg(vcpu, reg);	\
> +		__val &= ~__ ## reg ## _RES0;		\
> +		(__val);				\
> +	})
> +
>  bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  {
>  	union trap_config tc;
>  	enum trap_behaviour b;
>  	bool is_read;
>  	u32 sysreg;
> -	u64 esr;
> +	u64 esr, val;
>  
>  	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
>  		return false;
> @@ -1009,6 +1125,21 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  
>  	tc = get_trap_config(sysreg);
>  
> +	switch ((enum fgt_group_id)tc.fgt) {
> +	case __NO_FGT_GROUP__:
> +		break;
> +
> +	case HFGxTR_GROUP:
> +		if (is_read)
> +			val = sanitised_sys_reg(vcpu, HFGRTR_EL2);
> +		else
> +			val = sanitised_sys_reg(vcpu, HFGWTR_EL2);
> +		break;
> +	}
> +
> +	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(val, tc))
> +		goto inject;
> +
>  	b = compute_trap_behaviour(vcpu, tc);
>  
>  	if (((b & BEHAVE_FORWARD_READ) && is_read) ||
With Oliver's comments
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

