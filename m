Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2334C45DE50
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 17:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbhKYQLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 11:11:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356163AbhKYQJS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Nov 2021 11:09:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637856367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z7v5LkznOHba3ktVnhjZF1P8VI+6ofhfR3vcT+eZqR4=;
        b=SW1jazeTH7NQRHIqR1VQ1J71LN6G0QECnH4+z5So15HVO2QllQu7CRwswJWTofwW5JH5nA
        RyQoTpG+LWLBq4naq3eD9RKfHDS4lRZnm6kogJrFQawSQI6s6AGNt8vNrheF8j+cxo7QbW
        5qhtkXbvKemQQrD2gELTphpEuOBjy8k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-vq_gs0juOyCybrMgV3r1Ug-1; Thu, 25 Nov 2021 11:06:06 -0500
X-MC-Unique: vq_gs0juOyCybrMgV3r1Ug-1
Received: by mail-wm1-f70.google.com with SMTP id i131-20020a1c3b89000000b00337f92384e0so5193993wma.5
        for <kvm@vger.kernel.org>; Thu, 25 Nov 2021 08:06:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z7v5LkznOHba3ktVnhjZF1P8VI+6ofhfR3vcT+eZqR4=;
        b=I3+1fc73z0mDGP8fSZpTbpebVv/YHIUNof6NEN+URBHpSttqEn1aIGNTgAPLLokMAF
         7o2FM87hKGv6zphVu6fgx1NdjpaBv3h/couM9OdiEdbRPhI0t6USZDcNM3Bt5trfLTLZ
         xayXCnKEbSUR1d5rdJuq8m3oFp5YthyQBqvk9SQCtVxixSu+2myRbNIjD4mYSbBtd17J
         Vuzo+MBuSZjh1+kUlbo/MrdVcGH6QxKzEpfj7A4cjV2X+1s12PdiXsM3+1uq5muqQt1R
         EysgGCD22ZbsmUoqQS2NLWlO7SPe76L9SSPXB0q+0FmMBrSy3Fozjr9DmZYQVKwd0HFe
         KsdA==
X-Gm-Message-State: AOAM5308EHJ3vgm1MkbKlvf3yg6bX7/yl2cfUctBUf/t/Qwt/U+B2RWU
        VfYpITGA/ClYSrxMb3V6QFUM2UKm8LzKcRlQPGFtF7HsVOiA3rlUUieUTZAre0rQxmgD4AKmmpX
        TgVOnrAaQXa8W
X-Received: by 2002:a5d:42cc:: with SMTP id t12mr7715763wrr.129.1637856364558;
        Thu, 25 Nov 2021 08:06:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXSd8x7Zltdq8vas15ZASgM2LsIyw7HgLASJ8vVhlr+0+9JdEvOTEQgRsEOup2nZVsmSgO8Q==
X-Received: by 2002:a5d:42cc:: with SMTP id t12mr7715713wrr.129.1637856364263;
        Thu, 25 Nov 2021 08:06:04 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id z18sm3171710wrq.11.2021.11.25.08.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 08:06:03 -0800 (PST)
Subject: Re: [RFC PATCH v3 08/29] KVM: arm64: Make ID_AA64MMFR0_EL1 writable
To:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-9-reijiw@google.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <107f1a3e-2f1a-4810-0a54-eb9998c513cf@redhat.com>
Date:   Thu, 25 Nov 2021 17:06:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211117064359.2362060-9-reijiw@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,
On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> This patch adds id_reg_info for ID_AA64MMFR0_EL1 to make it
> writable by userspace.
> 
> Since ID_AA64MMFR0_EL1 stage 2 granule size fields don't follow the
> standard ID scheme, we need a special handling to validate those fields.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 118 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 118 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5812e39602fe..772e3d3067b2 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -519,6 +519,113 @@ static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +/*
> + * Check if the requested stage2 translation granule size indicated in
> + * @mmfr0 is also indicated in @mmfr0_lim.  This function assumes that
> + * the stage1 granule size indicated in @mmfr0 has been validated already.
> + */
> +static int aa64mmfr0_tgran2_check(int field, u64 mmfr0, u64 mmfr0_lim)
> +{
> +	s64 tgran2, lim_tgran2, rtgran1;
> +	int f1;
> +	bool is_signed = true;
> +
> +	tgran2 = cpuid_feature_extract_unsigned_field(mmfr0, field);
> +	lim_tgran2 = cpuid_feature_extract_unsigned_field(mmfr0_lim, field);
> +	if (tgran2 == lim_tgran2)
> +		return 0;
> +
> +	if (tgran2 && lim_tgran2)
> +		return (tgran2 > lim_tgran2) ? -E2BIG : 0;
> +
> +	/*
> +	 * Either tgran2 or lim_tgran2 is zero.
> +	 * Need stage1 granule size to validate tgran2.
> +	 */
> +	switch (field) {
> +	case ID_AA64MMFR0_TGRAN4_2_SHIFT:
> +		f1 = ID_AA64MMFR0_TGRAN4_SHIFT;
> +		break;
> +	case ID_AA64MMFR0_TGRAN64_2_SHIFT:
> +		f1 = ID_AA64MMFR0_TGRAN64_SHIFT;
> +		break;
> +	case ID_AA64MMFR0_TGRAN16_2_SHIFT:
> +		f1 = ID_AA64MMFR0_TGRAN16_SHIFT;
> +		is_signed = false;
> +		break;
> +	default:
> +		/* Should never happen */
> +		WARN_ONCE(1, "Unexpected stage2 granule field (%d)\n", field);
> +		return 0;
> +	}

sorry my previous message was sent while I haven't finished :-(

if I understand correctly you forbid setting a granule that is not set
in the lim. So I would first compute whether the granule is set, would
it be through the TGranX (if _2 == 0) or though TGranX_2 if this latter
is not not. Do those computations both on val and lim and eventually
check if gran_val > gran_lim. The current code looks overly complicated
but maybe I miss the actual reason.

Eric
> +
> +	/*
> +	 * If tgran2 == 0 (&& lim_tgran2 != 0), the requested stage2 granule
> +	 * size is indicated in the stage1 granule size field of @mmfr0.
> +	 * So, validate the stage1 granule size against the stage2 limit
> +	 * granule size.
> +	 * If lim_tgran2 == 0 (&& tgran2 != 0), the stage2 limit granule size
> +	 * is indicated in the stage1 granule size field of @mmfr0_lim.
> +	 * So, validate the requested stage2 granule size against the stage1
> +	 * limit granule size.
> +	 */
> +
> +	 /* Get the relevant stage1 granule size to validate tgran2 */
> +	if (tgran2 == 0)
> +		/* The requested stage1 granule size */
> +		rtgran1 = cpuid_feature_extract_field(mmfr0, f1, is_signed);
> +	else /* lim_tgran2 == 0 */
> +		/* The stage1 limit granule size */
> +		rtgran1 = cpuid_feature_extract_field(mmfr0_lim, f1, is_signed);
> +
> +	/*
> +	 * Adjust the value of rtgran1 to compare with stage2 granule size,
> +	 * which indicates: 1: Not supported, 2: Supported, etc.
> +	 */
> +	if (is_signed)
> +		/* For signed, -1: Not supported, 0: Supported, etc. */
> +		rtgran1 += 0x2;
> +	else
> +		/* For unsigned, 0: Not supported, 1: Supported, etc. */
> +		rtgran1 += 0x1;
> +
> +	if ((tgran2 == 0) && (rtgran1 > lim_tgran2))
> +		/*
> +		 * The requested stage1 granule size (== the requested stage2
> +		 * granule size) is larger than the stage2 limit granule size.
> +		 */
> +		return -E2BIG;
> +	else if ((lim_tgran2 == 0) && (tgran2 > rtgran1))
> +		/*
> +		 * The requested stage2 granule size is larger than the stage1
> +		 * limit granulze size (== the stage2 limit granule size).
> +		 */
> +		return -E2BIG;
> +
> +	return 0;
> +}
> +
> +static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
> +				     const struct id_reg_info *id_reg, u64 val)
> +{
> +	u64 limit = id_reg->vcpu_limit_val;
> +	int ret;
> +
> +	ret = aa64mmfr0_tgran2_check(ID_AA64MMFR0_TGRAN4_2_SHIFT, val, limit);
> +	if (ret)
> +		return ret;
> +
> +	ret = aa64mmfr0_tgran2_check(ID_AA64MMFR0_TGRAN64_2_SHIFT, val, limit);
> +	if (ret)
> +		return ret;
> +
> +	ret = aa64mmfr0_tgran2_check(ID_AA64MMFR0_TGRAN16_2_SHIFT, val, limit);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
>  static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
>  {
>  	u64 limit = id_reg->vcpu_limit_val;
> @@ -625,6 +732,16 @@ static struct id_reg_info id_aa64isar1_el1_info = {
>  	.get_reset_val = get_reset_id_aa64isar1_el1,
>  };
>  
> +static struct id_reg_info id_aa64mmfr0_el1_info = {
> +	.sys_reg = SYS_ID_AA64MMFR0_EL1,
> +	.ftr_check_types = S_FCT(ID_AA64MMFR0_TGRAN4_SHIFT, FCT_LOWER_SAFE) |
> +			   S_FCT(ID_AA64MMFR0_TGRAN64_SHIFT, FCT_LOWER_SAFE) |
> +			   U_FCT(ID_AA64MMFR0_TGRAN4_2_SHIFT, FCT_IGNORE) |
> +			   U_FCT(ID_AA64MMFR0_TGRAN64_2_SHIFT, FCT_IGNORE) |
> +			   U_FCT(ID_AA64MMFR0_TGRAN16_2_SHIFT, FCT_IGNORE),
> +	.validate = validate_id_aa64mmfr0_el1,
> +};
> +
>  /*
>   * An ID register that needs special handling to control the value for the
>   * guest must have its own id_reg_info in id_reg_info_table.
> @@ -638,6 +755,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
>  	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
> +	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
>  };
>  
>  static int validate_id_reg(struct kvm_vcpu *vcpu,
> 

