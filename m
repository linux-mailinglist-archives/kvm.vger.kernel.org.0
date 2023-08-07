Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4A87725D0
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 15:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbjHGNdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 09:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbjHGNdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 09:33:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCE7170B
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 06:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691415054;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5hK8kz26GjpdjzujUSybacpdOJ3+BX7RjUS82AalACc=;
        b=GUcQnmRHNZwVW6O3XxUtb9xghf3eNjGrRTWGAphpIPF4wc4fquNETySGcirCXz7bmwHVtm
        M1tEZP+SV7/lE6vpkBSiDi2KjjYJFNQk41KOn2m9FUepQ2y8/cey+0WS/p+tFfzWHH/J4M
        HqLhqom927R8zoDOGuIpxj174hZcj9M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-wXTDspP5NXaHsBugRL323w-1; Mon, 07 Aug 2023 09:30:53 -0400
X-MC-Unique: wXTDspP5NXaHsBugRL323w-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-31792080fdeso1872956f8f.2
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 06:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691415052; x=1692019852;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5hK8kz26GjpdjzujUSybacpdOJ3+BX7RjUS82AalACc=;
        b=YNLKuzSLaH+EWYIC0j9690j887Z664J5WRHZOiu2XD9twdJ5jJrDe88j4T4XX8LUhc
         /KUGJaRYAwu+E7xYIZbUP2yP8sSCAOmO5Scu0BVXjzBGVRjRGmtsKaQp1bW45zA6QosR
         HgkvxO65u8R8rKENMSXIcWE1kHgbyLCUS4Ug+c/qQXph2UxTi/oYMcEDqkkd6HgqfKSv
         og47kN/FUbfv5+nLs5su4hkZE9c+eZsWF4g+9mD+FEHk0w0cY1+xX+7l05m7JFBEodQG
         C3b/51R+eTfTgg1nvvknQ2JxEAKdvl05e9EmijU9rjYHVP2iv9YVrQpd9+t+y94CHFwU
         du7Q==
X-Gm-Message-State: AOJu0YwZjrO3awvRAo4yqjYiDbaq1hjsDMldlp/1aY9Oy8PyoITsv6Kr
        c+jc5+ehmxB+3zDzFC2k+4gXYH6WnPAS6+k4IJPZV5EUIv7jS+2YRNe+Tex92DNIQRAqEai7cKg
        CqiRlqyXLWCZh
X-Received: by 2002:adf:f491:0:b0:313:f0ef:1e55 with SMTP id l17-20020adff491000000b00313f0ef1e55mr5925150wro.37.1691415052184;
        Mon, 07 Aug 2023 06:30:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH17R+XNLgtY05mfA07P6WXFRIwMFReWI0TTFg1yfRSIjTNm6lDYaVoJY0IREkirzsIfp+A2A==
X-Received: by 2002:adf:f491:0:b0:313:f0ef:1e55 with SMTP id l17-20020adff491000000b00313f0ef1e55mr5925124wro.37.1691415051846;
        Mon, 07 Aug 2023 06:30:51 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id i12-20020a05600c290c00b003fbb618f7adsm10725122wmd.15.2023.08.07.06.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Aug 2023 06:30:51 -0700 (PDT)
Message-ID: <b06cd9c0-980a-6b6a-e163-1846173ec5ec@redhat.com>
Date:   Mon, 7 Aug 2023 15:30:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 20/26] KVM: arm64: nv: Add trap forwarding for
 HFGITR_EL2
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
 <20230728082952.959212-21-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230728082952.959212-21-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/28/23 10:29, Marc Zyngier wrote:
> Similarly, implement the trap forwarding for instructions affected
> by HFGITR_EL2.
>
> Note that the TLBI*nXS instructions should be affected by HCRX_EL2,
> which will be dealt with down the line.

I think you should also add a comment about the fact SVC_EL1/0 and ERET
are not dealt with in this patch.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h |   4 ++
>  arch/arm64/kvm/emulate-nested.c  | 109 +++++++++++++++++++++++++++++++
>  2 files changed, 113 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 85908aa18908..809bc86acefd 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -354,6 +354,10 @@
>  #define __HFGWTR_EL2_MASK	GENMASK(49, 0)
>  #define __HFGWTR_EL2_nMASK	(GENMASK(55, 54) | BIT(50))
>  
> +#define __HFGITR_EL2_RES0	GENMASK(63, 57)
> +#define __HFGITR_EL2_MASK	GENMASK(54, 0)
> +#define __HFGITR_EL2_nMASK	GENMASK(56, 55)
> +
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK	(~UL(0xf))
>  /*
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 5f4cf824eadc..72619d845cc8 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -925,6 +925,7 @@ static DEFINE_XARRAY(sr_forward_xa);
>  enum fgt_group_id {
>  	__NO_FGT_GROUP__,
>  	HFGxTR_GROUP,
> +	HFGITR_GROUP,
>  };
>  
>  #define SR_FGT(sr, g, b, p)					\
> @@ -1002,6 +1003,110 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
>  	SR_FGT(SYS_AIDR_EL1, 		HFGxTR, AIDR_EL1, 1),
>  	SR_FGT(SYS_AFSR1_EL1, 		HFGxTR, AFSR1_EL1, 1),
>  	SR_FGT(SYS_AFSR0_EL1, 		HFGxTR, AFSR0_EL1, 1),
> +	/* HFGITR_EL2 */
> +	SR_FGT(OP_BRB_IALL, 		HFGITR, nBRBIALL, 0),
> +	SR_FGT(OP_BRB_INJ, 		HFGITR, nBRBINJ, 0),
> +	SR_FGT(SYS_DC_CVAC, 		HFGITR, DCCVAC, 1),
> +	SR_FGT(SYS_DC_CGVAC, 		HFGITR, DCCVAC, 1),
> +	SR_FGT(SYS_DC_CGDVAC, 		HFGITR, DCCVAC, 1),
> +	SR_FGT(OP_CPP_RCTX, 		HFGITR, CPPRCTX, 1),
> +	SR_FGT(OP_DVP_RCTX, 		HFGITR, DVPRCTX, 1),
> +	SR_FGT(OP_CFP_RCTX, 		HFGITR, CFPRCTX, 1),
> +	SR_FGT(OP_TLBI_VAALE1, 		HFGITR, TLBIVAALE1, 1),y
> +	SR_FGT(OP_TLBI_VALE1, 		HFGITR, TLBIVALE1, 1),y
> +	SR_FGT(OP_TLBI_VAAE1, 		HFGITR, TLBIVAAE1, 1),y
> +	SR_FGT(OP_TLBI_ASIDE1, 		HFGITR, TLBIASIDE1, 1),y
> +	SR_FGT(OP_TLBI_VAE1, 		HFGITR, TLBIVAE1, 1),y
> +	SR_FGT(OP_TLBI_VMALLE1, 	HFGITR, TLBIVMALLE1, 1),y
> +	SR_FGT(OP_TLBI_RVAALE1, 	HFGITR, TLBIRVAALE1, 1),y
> +	SR_FGT(OP_TLBI_RVALE1, 		HFGITR, TLBIRVALE1, 1),y
> +	SR_FGT(OP_TLBI_RVAAE1, 		HFGITR, TLBIRVAAE1, 1),y
> +	SR_FGT(OP_TLBI_RVAE1, 		HFGITR, TLBIRVAE1, 1),y
> +	SR_FGT(OP_TLBI_RVAALE1IS, 	HFGITR, TLBIRVAALE1IS, 1),y
> +	SR_FGT(OP_TLBI_RVALE1IS, 	HFGITR, TLBIRVALE1IS, 1),y
> +	SR_FGT(OP_TLBI_RVAAE1IS, 	HFGITR, TLBIRVAAE1IS, 1),y
> +	SR_FGT(OP_TLBI_RVAE1IS, 	HFGITR, TLBIRVAE1IS, 1),y
> +	SR_FGT(OP_TLBI_VAALE1IS, 	HFGITR, TLBIVAALE1IS, 1),y
> +	SR_FGT(OP_TLBI_VALE1IS, 	HFGITR, TLBIVALE1IS, 1),y
> +	SR_FGT(OP_TLBI_VAAE1IS, 	HFGITR, TLBIVAAE1IS, 1),y
> +	SR_FGT(OP_TLBI_ASIDE1IS, 	HFGITR, TLBIASIDE1IS, 1),y
> +	SR_FGT(OP_TLBI_VAE1IS, 		HFGITR, TLBIVAE1IS, 1),y
> +	SR_FGT(OP_TLBI_VMALLE1IS, 	HFGITR, TLBIVMALLE1IS, 1),y
> +	SR_FGT(OP_TLBI_RVAALE1OS, 	HFGITR, TLBIRVAALE1OS, 1),y
> +	SR_FGT(OP_TLBI_RVALE1OS, 	HFGITR, TLBIRVALE1OS, 1),y
> +	SR_FGT(OP_TLBI_RVAAE1OS, 	HFGITR, TLBIRVAAE1OS, 1),y
> +	SR_FGT(OP_TLBI_RVAE1OS, 	HFGITR, TLBIRVAE1OS, 1),y
> +	SR_FGT(OP_TLBI_VAALE1OS, 	HFGITR, TLBIVAALE1OS, 1),y
> +	SR_FGT(OP_TLBI_VALE1OS, 	HFGITR, TLBIVALE1OS, 1),y
> +	SR_FGT(OP_TLBI_VAAE1OS, 	HFGITR, TLBIVAAE1OS, 1),y
> +	SR_FGT(OP_TLBI_ASIDE1OS, 	HFGITR, TLBIASIDE1OS, 1),y
> +	SR_FGT(OP_TLBI_VAE1OS, 		HFGITR, TLBIVAE1OS, 1),y
> +	SR_FGT(OP_TLBI_VMALLE1OS, 	HFGITR, TLBIVMALLE1OS, 1),y
> +	/* FIXME: nXS variants must be checked against HCRX_EL2.FGTnXS */
> +	SR_FGT(OP_TLBI_VAALE1NXS, 	HFGITR, TLBIVAALE1, 1),y
> +	SR_FGT(OP_TLBI_VALE1NXS, 	HFGITR, TLBIVALE1, 1),y
> +	SR_FGT(OP_TLBI_VAAE1NXS, 	HFGITR, TLBIVAAE1, 1),y
> +	SR_FGT(OP_TLBI_ASIDE1NXS, 	HFGITR, TLBIASIDE1, 1),y
> +	SR_FGT(OP_TLBI_VAE1NXS, 	HFGITR, TLBIVAE1, 1),y
> +	SR_FGT(OP_TLBI_VMALLE1NXS, 	HFGITR, TLBIVMALLE1, 1),y
> +	SR_FGT(OP_TLBI_RVAALE1NXS, 	HFGITR, TLBIRVAALE1, 1),y
> +	SR_FGT(OP_TLBI_RVALE1NXS, 	HFGITR, TLBIRVALE1, 1),y
> +	SR_FGT(OP_TLBI_RVAAE1NXS, 	HFGITR, TLBIRVAAE1, 1),y
> +	SR_FGT(OP_TLBI_RVAE1NXS, 	HFGITR, TLBIRVAE1, 1),y
> +	SR_FGT(OP_TLBI_RVAALE1ISNXS, 	HFGITR, TLBIRVAALE1IS, 1),y
> +	SR_FGT(OP_TLBI_RVALE1ISNXS, 	HFGITR, TLBIRVALE1IS, 1),y
> +	SR_FGT(OP_TLBI_RVAAE1ISNXS, 	HFGITR, TLBIRVAAE1IS, 1),y
> +	SR_FGT(OP_TLBI_RVAE1ISNXS, 	HFGITR, TLBIRVAE1IS, 1),y
> +	SR_FGT(OP_TLBI_VAALE1ISNXS, 	HFGITR, TLBIVAALE1IS, 1),y
> +	SR_FGT(OP_TLBI_VALE1ISNXS, 	HFGITR, TLBIVALE1IS, 1),y
> +	SR_FGT(OP_TLBI_VAAE1ISNXS, 	HFGITR, TLBIVAAE1IS, 1),
> +	SR_FGT(OP_TLBI_ASIDE1ISNXS, 	HFGITR, TLBIASIDE1IS, 1),y
> +	SR_FGT(OP_TLBI_VAE1ISNXS, 	HFGITR, TLBIVAE1IS, 1),y
> +	SR_FGT(OP_TLBI_VMALLE1ISNXS, 	HFGITR, TLBIVMALLE1IS, 1),y
> +	SR_FGT(OP_TLBI_RVAALE1OSNXS, 	HFGITR, TLBIRVAALE1OS, 1),y
> +	SR_FGT(OP_TLBI_RVALE1OSNXS, 	HFGITR, TLBIRVALE1OS, 1),y
> +	SR_FGT(OP_TLBI_RVAAE1OSNXS, 	HFGITR, TLBIRVAAE1OS, 1),y
> +	SR_FGT(OP_TLBI_RVAE1OSNXS, 	HFGITR, TLBIRVAE1OS, 1),y
> +	SR_FGT(OP_TLBI_VAALE1OSNXS, 	HFGITR, TLBIVAALE1OS, 1),y
> +	SR_FGT(OP_TLBI_VALE1OSNXS, 	HFGITR, TLBIVALE1OS, 1),y
> +	SR_FGT(OP_TLBI_VAAE1OSNXS, 	HFGITR, TLBIVAAE1OS, 1),y
> +	SR_FGT(OP_TLBI_ASIDE1OSNXS, 	HFGITR, TLBIASIDE1OS, 1),y
> +	SR_FGT(OP_TLBI_VAE1OSNXS, 	HFGITR, TLBIVAE1OS, 1),y
> +	SR_FGT(OP_TLBI_VMALLE1OSNXS, 	HFGITR, TLBIVMALLE1OS, 1),y
> +	SR_FGT(OP_AT_S1E1WP, 		HFGITR, ATS1E1WP, 1),
> +	SR_FGT(OP_AT_S1E1RP, 		HFGITR, ATS1E1RP, 1),
> +	SR_FGT(OP_AT_S1E0W, 		HFGITR, ATS1E0W, 1),
> +	SR_FGT(OP_AT_S1E0R, 		HFGITR, ATS1E0R, 1),
> +	SR_FGT(OP_AT_S1E1W, 		HFGITR, ATS1E1W, 1),
> +	SR_FGT(OP_AT_S1E1R, 		HFGITR, ATS1E1R, 1),
> +	SR_FGT(SYS_DC_ZVA, 		HFGITR, DCZVA, 1),
> +	SR_FGT(SYS_DC_GVA, 		HFGITR, DCZVA, 1),
> +	SR_FGT(SYS_DC_GZVA, 		HFGITR, DCZVA, 1),
> +	SR_FGT(SYS_DC_CIVAC, 		HFGITR, DCCIVAC, 1),
> +	SR_FGT(SYS_DC_CIGVAC, 		HFGITR, DCCIVAC, 1),
> +	SR_FGT(SYS_DC_CIGDVAC, 		HFGITR, DCCIVAC, 1),
> +	SR_FGT(SYS_DC_CVADP, 		HFGITR, DCCVADP, 1),
> +	SR_FGT(SYS_DC_CGVADP, 		HFGITR, DCCVADP, 1),
> +	SR_FGT(SYS_DC_CGDVADP, 		HFGITR, DCCVADP, 1),
> +	SR_FGT(SYS_DC_CVAP, 		HFGITR, DCCVAP, 1),
> +	SR_FGT(SYS_DC_CGVAP, 		HFGITR, DCCVAP, 1),
> +	SR_FGT(SYS_DC_CGDVAP, 		HFGITR, DCCVAP, 1),
> +	SR_FGT(SYS_DC_CVAU, 		HFGITR, DCCVAU, 1),
> +	SR_FGT(SYS_DC_CISW, 		HFGITR, DCCISW, 1),
> +	SR_FGT(SYS_DC_CIGSW, 		HFGITR, DCCISW, 1),
> +	SR_FGT(SYS_DC_CIGDSW, 		HFGITR, DCCISW, 1),
> +	SR_FGT(SYS_DC_CSW, 		HFGITR, DCCSW, 1),
> +	SR_FGT(SYS_DC_CGSW, 		HFGITR, DCCSW, 1),
> +	SR_FGT(SYS_DC_CGDSW, 		HFGITR, DCCSW, 1),
> +	SR_FGT(SYS_DC_ISW, 		HFGITR, DCISW, 1),
> +	SR_FGT(SYS_DC_IGSW, 		HFGITR, DCISW, 1),
> +	SR_FGT(SYS_DC_IGDSW, 		HFGITR, DCISW, 1),
> +	SR_FGT(SYS_DC_IVAC, 		HFGITR, DCIVAC, 1),
> +	SR_FGT(SYS_DC_IGVAC, 		HFGITR, DCIVAC, 1),
> +	SR_FGT(SYS_DC_IGDVAC, 		HFGITR, DCIVAC, 1),
> +	SR_FGT(SYS_IC_IVAU, 		HFGITR, ICIVAU, 1),
> +	SR_FGT(SYS_IC_IALLU, 		HFGITR, ICIALLU, 1),
> +	SR_FGT(SYS_IC_IALLUIS, 		HFGITR, ICIALLUIS, 1),
>  };
>  
>  static union trap_config get_trap_config(u32 sysreg)
> @@ -1135,6 +1240,10 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  		else
>  			val = sanitised_sys_reg(vcpu, HFGWTR_EL2);
>  		break;
> +
> +	case HFGITR_GROUP:
> +		val = sanitised_sys_reg(vcpu, HFGITR_EL2);
> +		break;
>  	}
>  
>  	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(val, tc))
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

