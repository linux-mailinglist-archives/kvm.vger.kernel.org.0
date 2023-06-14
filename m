Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFC772F680
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 09:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243417AbjFNHhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 03:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243294AbjFNHhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 03:37:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDE2212F
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 00:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686728156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=75lHM4GTlQyT6PH14rlaS9YkHZjtMeh42gty71BsVI4=;
        b=iLpn668CiRgH1DNBlMuwiwDMLwZWgp+FGdbOH5mhRJKvfzrQfzM9FmyhVSNe+l6/NXk6lc
        T0Yxua3mJDczxm2Hnz7TlS8QxI36O8pPqVdkKfoA23tWNbOfXnom5zeLm2TD6j7sqB4uhV
        najNKwBKpKDcbXbB1gsyGGRLly7aqQg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-Ih1CsYnZPq2xY3avxux1Gg-1; Wed, 14 Jun 2023 03:35:22 -0400
X-MC-Unique: Ih1CsYnZPq2xY3avxux1Gg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f7ba550b12so13695855e9.0
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 00:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686728122; x=1689320122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=75lHM4GTlQyT6PH14rlaS9YkHZjtMeh42gty71BsVI4=;
        b=i0w0IIm4i7ecNZ0GrA3PxpDw9WA9enMdnWeUrzmNrAOWj6O2K5z/sS3QkokI4Pw3SK
         BdyAEllUsZYjA33hn4SCpyl47CBNO0Y9KGcVNuAoNkBAPdrKhucGCY/Ed30CteAOZI9c
         VzitIbVTYOTTKCnQ9HLrNKHtC6n1zy4ZoB3+iBC04wlG4U5c8tpX0+u/rKkn4jnspEWA
         Pirb7AggoEHzfVSWWOoIuFv03bMQMUMUjcV+h3C5UkFqsuPxHa1fY7NLDQreh1lEjZA3
         2JpfV+nPMwGm4XPaMr8xkFpeAuT5KUB9BIdVweztBEOiaOIREboYCvTesUK7MjhqcbIz
         UZyw==
X-Gm-Message-State: AC+VfDyyVSK/ElxEGf8vgQBZo8QA9B+uPMw2DQxvKDsPOuSrGlmN+6UP
        K1dsVoiHhyxZul5r+LoqRAP0xIMj7U85/m/ngEdeD+PlemzEUyatCXqjLsFaq2cBotZVyvv+sY/
        xlYxQfBGybbSs
X-Received: by 2002:a05:600c:3501:b0:3f5:927:2b35 with SMTP id h1-20020a05600c350100b003f509272b35mr11947537wmq.1.1686728121724;
        Wed, 14 Jun 2023 00:35:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4QVilCcTZ6ApVLLadrtzz0koSoKya8xZLjW06cd9QIPrbYz6pd0H2K++ymwwVqv0aTyXOXhA==
X-Received: by 2002:a05:600c:3501:b0:3f5:927:2b35 with SMTP id h1-20020a05600c350100b003f509272b35mr11947517wmq.1.1686728121405;
        Wed, 14 Jun 2023 00:35:21 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 10-20020a05600c22ca00b003f427687ba7sm16477969wmg.41.2023.06.14.00.35.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 00:35:20 -0700 (PDT)
Message-ID: <8f7d7285-b21d-23b0-793b-70ee008cb45b@redhat.com>
Date:   Wed, 14 Jun 2023 15:35:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 04/17] arm64: Add KVM_HVHE capability and has_hvhe()
 predicate
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
 <20230609162200.2024064-5-maz@kernel.org>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230609162200.2024064-5-maz@kernel.org>
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

Hi Marc,

Should we have a document about the hVHE? Because it's a sw feature, 
there is no spec about it. And later people may need to read the code 
itself to understand what is hVHE.

On 6/10/23 00:21, Marc Zyngier wrote:
> Expose a capability keying the hVHE feature as well as a new
> predicate testing it. Nothing is so far using it, and nothing
> is enabling it yet.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Besides that, the code itself LGTM.

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/cpufeature.h |  1 +
>   arch/arm64/include/asm/virt.h       |  8 ++++++++
>   arch/arm64/kernel/cpufeature.c      | 19 +++++++++++++++++++
>   arch/arm64/tools/cpucaps            |  1 +
>   4 files changed, 29 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index bc1009890180..3d4b547ae312 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -16,6 +16,7 @@
>   #define cpu_feature(x)		KERNEL_HWCAP_ ## x
>   
>   #define ARM64_SW_FEATURE_OVERRIDE_NOKASLR	0
> +#define ARM64_SW_FEATURE_OVERRIDE_HVHE		4
>   
>   #ifndef __ASSEMBLY__
>   
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index 21e94068804d..5227db7640c8 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -142,6 +142,14 @@ static __always_inline bool is_protected_kvm_enabled(void)
>   		return cpus_have_final_cap(ARM64_KVM_PROTECTED_MODE);
>   }
>   
> +static __always_inline bool has_hvhe(void)
> +{
> +	if (is_vhe_hyp_code())
> +		return false;
> +
> +	return cpus_have_final_cap(ARM64_KVM_HVHE);
> +}
> +
>   static inline bool is_hyp_nvhe(void)
>   {
>   	return is_hyp_mode_available() && !is_kernel_in_hyp_mode();
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 2d2b7bb5fa0c..c743b1a5ae31 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1998,6 +1998,19 @@ static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
>   	return true;
>   }
>   
> +static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
> +			  int __unused)
> +{
> +	u64 val;
> +
> +	val = read_sysreg(id_aa64mmfr1_el1);
> +	if (!cpuid_feature_extract_unsigned_field(val, ID_AA64MMFR1_EL1_VH_SHIFT))
> +		return false;
> +
> +	val = arm64_sw_feature_override.val & arm64_sw_feature_override.mask;
> +	return cpuid_feature_extract_unsigned_field(val, ARM64_SW_FEATURE_OVERRIDE_HVHE);
> +}
> +
>   #ifdef CONFIG_ARM64_PAN
>   static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
>   {
> @@ -2643,6 +2656,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   		.cpu_enable = cpu_enable_dit,
>   		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, DIT, IMP)
>   	},
> +	{
> +		.desc = "VHE for hypervisor only",
> +		.capability = ARM64_KVM_HVHE,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = hvhe_possible,
> +	},
>   	{},
>   };
>   
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 40ba95472594..3c23a55d7c2f 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -47,6 +47,7 @@ HAS_TLB_RANGE
>   HAS_VIRT_HOST_EXTN
>   HAS_WFXT
>   HW_DBM
> +KVM_HVHE
>   KVM_PROTECTED_MODE
>   MISMATCHED_CACHE_TYPE
>   MTE

-- 
Shaoqin

