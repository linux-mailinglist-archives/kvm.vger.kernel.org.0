Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0C545DD88
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 16:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356031AbhKYPhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 10:37:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231860AbhKYPfL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Nov 2021 10:35:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637854319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cnVCzP5Ph3HfcaXljAj+4m7ThxDrMRTU+FYGU/FtLpo=;
        b=HaMh7jlF89n98oof/uxkf0o1w1YjjwM6Mz19GCIO9uHNa33ggaeb5qDihkpE4SzlaZguUB
        c3jfVSGfv+nD9WRxEs/VCKx8OYzQHiz5S/wldcVY62XPhcTw4z8HFiQitI7xxbgtOtjwnk
        fVNK9BCK8rPnnyCcjrpRQ+bwiOa8VuA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-snrR-1AaOVmIbhBLMYJrtg-1; Thu, 25 Nov 2021 10:31:58 -0500
X-MC-Unique: snrR-1AaOVmIbhBLMYJrtg-1
Received: by mail-wm1-f72.google.com with SMTP id 69-20020a1c0148000000b0033214e5b021so3417206wmb.3
        for <kvm@vger.kernel.org>; Thu, 25 Nov 2021 07:31:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cnVCzP5Ph3HfcaXljAj+4m7ThxDrMRTU+FYGU/FtLpo=;
        b=PQ3IqfGeZbO67Cmp/27JSVWNzuLZbnc3NwXlrNjAuLaXUh+GIUVWxvTpfKCD7m5x6P
         Fge1tZfUmDI5o429NGApS0LpOlEBNf4mT2iow0BW31KCL2StiKJVF6Y6vGpMVVFcalkQ
         /lRuBzOtaiCvSxb6KWQncowsMiVnm7ThBDnhu8a0QIByaH5/OXoxk+mZALEkVdXd/wBs
         h2YgT764SLVAUqthxCCZOCOuSu9+K+4BqS8JHhdseLa4n465DZvvSHMNXnMkDvJV2w/P
         tPNWeanBLfh9SJ7Jk4A/xNUbswnXDRkZxAqrfnJSN9Sao29ZMuhEWCKo26ex/kDlD4kH
         jBGg==
X-Gm-Message-State: AOAM531EVmT20tEoKTpItNkyZwL7Jw/5uU+rqNe4ETLNFZw5iiD/sdEi
        QI3RJFutQSM6hsAyd0nzEYktxy50zQ9mzlY654Ioq2gFQrvwBQvx9bsIuV+1HQtkVIfzpxW8A1U
        7JqIGOVoC+WBm
X-Received: by 2002:a1c:1b15:: with SMTP id b21mr8153045wmb.174.1637854316721;
        Thu, 25 Nov 2021 07:31:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwemXoFmNVjJcaWjKBX8bFRZCHriCtd5cmiBgm8uZbMA6g/Y4cpCrDzQpBcKt3wIs6WdTxneQ==
X-Received: by 2002:a1c:1b15:: with SMTP id b21mr8153007wmb.174.1637854316436;
        Thu, 25 Nov 2021 07:31:56 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id j17sm4677748wmq.41.2021.11.25.07.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 07:31:55 -0800 (PST)
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
Message-ID: <cef4fecc-b2c0-6f1b-b61d-68b830ae0bcd@redhat.com>
Date:   Thu, 25 Nov 2021 16:31:54 +0100
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
I would suggest: relies on the fact TGranX fields are validated before
through the arm64_check_features lookup
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
I don't get the is_signed setting. Don't the TGRAN_x have the same
format? Beside you can get the shift by substracting 12 to @field.

can't you directly compute if the granule is supported

> +		break;
> +	default:
> +		/* Should never happen */
> +		WARN_ONCE(1, "Unexpected stage2 granule field (%d)\n", field);
> +		return 0;
> +	}
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

shouldn't you forbid reserved values for TGran4, 64?
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
the default?
> +			   U_FCT(ID_AA64MMFR0_TGRAN4_2_SHIFT, FCT_IGNORE) |
> +			   U_FCT(ID_AA64MMFR0_TGRAN64_2_SHIFT, FCT_IGNORE) |
> +			   U_FCT(ID_AA64MMFR0_TGRAN16_2_SHIFT, FCT_IGNORE),
maybe add comment telling the actual check is handled in the validate cb
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

