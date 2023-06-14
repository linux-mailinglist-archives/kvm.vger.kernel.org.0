Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FEE72F648
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 09:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243439AbjFNH2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 03:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243436AbjFNH1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 03:27:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B081BEF
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 00:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686727604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iem6/Y/G24M3j/w67JcmVGZ1CH55Q1aVX/29CD3WyXc=;
        b=fkGqKheTY1fQc3jLNMA1gaKaY55nKyFSqRcUFr7ADrRMq0DeDRPNRW8YlBiSWauuWyqc+U
        mio5uvW7gm/bf2sS0lB0rmT9pqHEhxEpXgA2iaF9/FAIhyvHWgEfs5JSIiexKdx+C5R+3o
        VagVs+NRedd3yElsffKwnVxhTSH2S1w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-s6eMLzF-M2y0Kype3G-6GA-1; Wed, 14 Jun 2023 03:26:43 -0400
X-MC-Unique: s6eMLzF-M2y0Kype3G-6GA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30fc1c14972so296922f8f.1
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 00:26:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686727602; x=1689319602;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iem6/Y/G24M3j/w67JcmVGZ1CH55Q1aVX/29CD3WyXc=;
        b=IRkwMbjQo2XeFRD1Wi32blvJ3oOKAwJj9DNLbJS4DG4wcEylbDk/LVA71f1rEyiHfL
         0/so8ASDQ9UUkmZjh4NPRpfmetfedOdNQUORXHokytqFBylMnBdv7x2zJY3mK+MpSXw2
         zr7SkIUP2Jg1FWpOzrhjoeIhN9Qk6SSHXfHIU2WxELp9frubmMYbER8EzTVc0D3sGZzA
         a917yopTmo8sj6CBmNMqJ+XMN9NJe4ptdMDKL22Hvl0wMfVD/FXiVeu1DO0p493C/xTY
         A2e2IcwmkbXqkKSXUpH5ONFUFjv+CcDaz6P1YdQNJwp8IUgLQFDAwgNBwOFsH8gTpeXz
         mGkQ==
X-Gm-Message-State: AC+VfDxXWNG7XvHYmsGa6jsgqU/CyaJP/ZlLeSAoM6YIaofoadeWj/Qd
        vboUNOSavjsm7DUdTYvKK7eGFlrF73Ej80nc/kAypq1apNR3TbrBcoCuf4GFgOJS718SGyN+2XG
        yUnw94NpXkTOo
X-Received: by 2002:a5d:5958:0:b0:30e:3d8d:723a with SMTP id e24-20020a5d5958000000b0030e3d8d723amr10078942wri.3.1686727602645;
        Wed, 14 Jun 2023 00:26:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5ZGjfYnwtC2uWfcM6lEVKN+Te0ghzhMrOwVxZtB133X5BaOxOgwzTr4k0gs2CjtqyNPE6iyg==
X-Received: by 2002:a5d:5958:0:b0:30e:3d8d:723a with SMTP id e24-20020a5d5958000000b0030e3d8d723amr10078922wri.3.1686727602327;
        Wed, 14 Jun 2023 00:26:42 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e8-20020adff348000000b00304adbeeabbsm17385675wrp.99.2023.06.14.00.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 00:26:41 -0700 (PDT)
Message-ID: <bdb7e94b-2145-5f74-fc44-0f5790562881@redhat.com>
Date:   Wed, 14 Jun 2023 15:26:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 03/17] arm64: Turn kaslr_feature_override into a
 generic SW feature override
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-4-maz@kernel.org>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230609162200.2024064-4-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/10/23 00:21, Marc Zyngier wrote:
> Disabling KASLR from the command line is implemented as a feature
> override. Repaint it slightly so that it can further be used as
> more generic infrastructure for SW override purposes.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/cpufeature.h |  4 ++++
>   arch/arm64/kernel/cpufeature.c      |  2 ++
>   arch/arm64/kernel/idreg-override.c  | 16 ++++++----------
>   arch/arm64/kernel/kaslr.c           |  6 +++---
>   4 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 6bf013fb110d..bc1009890180 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -15,6 +15,8 @@
>   #define MAX_CPU_FEATURES	128
>   #define cpu_feature(x)		KERNEL_HWCAP_ ## x
>   
> +#define ARM64_SW_FEATURE_OVERRIDE_NOKASLR	0
> +
>   #ifndef __ASSEMBLY__
>   
>   #include <linux/bug.h>
> @@ -925,6 +927,8 @@ extern struct arm64_ftr_override id_aa64smfr0_override;
>   extern struct arm64_ftr_override id_aa64isar1_override;
>   extern struct arm64_ftr_override id_aa64isar2_override;
>   
> +extern struct arm64_ftr_override arm64_sw_feature_override;
> +
>   u32 get_kvm_ipa_limit(void);
>   void dump_cpu_features(void);
>   
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 7d7128c65161..2d2b7bb5fa0c 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -664,6 +664,8 @@ struct arm64_ftr_override __ro_after_init id_aa64smfr0_override;
>   struct arm64_ftr_override __ro_after_init id_aa64isar1_override;
>   struct arm64_ftr_override __ro_after_init id_aa64isar2_override;
>   
> +struct arm64_ftr_override arm64_sw_feature_override;
> +
>   static const struct __ftr_reg_entry {
>   	u32			sys_id;
>   	struct arm64_ftr_reg 	*reg;
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index 370ab84fd06e..8c93b6198bf5 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -138,15 +138,11 @@ static const struct ftr_set_desc smfr0 __initconst = {
>   	},
>   };
>   
> -extern struct arm64_ftr_override kaslr_feature_override;
> -
> -static const struct ftr_set_desc kaslr __initconst = {
> -	.name		= "kaslr",
> -#ifdef CONFIG_RANDOMIZE_BASE
> -	.override	= &kaslr_feature_override,
> -#endif
> +static const struct ftr_set_desc sw_features __initconst = {
> +	.name		= "arm64_sw",
> +	.override	= &arm64_sw_feature_override,
>   	.fields		= {
> -		FIELD("disabled", 0, NULL),
> +		FIELD("nokaslr", ARM64_SW_FEATURE_OVERRIDE_NOKASLR, NULL),
>   		{}
>   	},
>   };
> @@ -158,7 +154,7 @@ static const struct ftr_set_desc * const regs[] __initconst = {
>   	&isar1,
>   	&isar2,
>   	&smfr0,
> -	&kaslr,
> +	&sw_features,
>   };
>   
>   static const struct {
> @@ -175,7 +171,7 @@ static const struct {
>   	  "id_aa64isar1.api=0 id_aa64isar1.apa=0 "
>   	  "id_aa64isar2.gpa3=0 id_aa64isar2.apa3=0"	   },
>   	{ "arm64.nomte",		"id_aa64pfr1.mte=0" },
> -	{ "nokaslr",			"kaslr.disabled=1" },
> +	{ "nokaslr",			"arm64_sw.nokaslr=1" },
>   };
>   
>   static int __init parse_nokaslr(char *unused)
> diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
> index e7477f21a4c9..5d4ce7f5f157 100644
> --- a/arch/arm64/kernel/kaslr.c
> +++ b/arch/arm64/kernel/kaslr.c
> @@ -23,8 +23,6 @@
>   u64 __ro_after_init module_alloc_base;
>   u16 __initdata memstart_offset_seed;
>   
> -struct arm64_ftr_override kaslr_feature_override __initdata;
> -
>   static int __init kaslr_init(void)
>   {
>   	u64 module_range;
> @@ -36,7 +34,9 @@ static int __init kaslr_init(void)
>   	 */
>   	module_alloc_base = (u64)_etext - MODULES_VSIZE;
>   
> -	if (kaslr_feature_override.val & kaslr_feature_override.mask & 0xf) {
> +	if (cpuid_feature_extract_unsigned_field(arm64_sw_feature_override.val &
> +						 arm64_sw_feature_override.mask,
> +						 ARM64_SW_FEATURE_OVERRIDE_NOKASLR)) {
>   		pr_info("KASLR disabled on command line\n");
>   		return 0;
>   	}

-- 
Shaoqin

