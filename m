Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA01E72DE9D
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 11:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241964AbjFMJ7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 05:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241999AbjFMJ6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 05:58:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8232C19B6
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 02:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686650251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d24qNgsK4YI73pNJSGPXOXGrlkTr7CIQRglIpszf5fE=;
        b=S1jywrRWcBVubMBmY3pcXSoPkuLi2kS3pgHgCsKsaGWabuVD02ZWnzb87TtVadEWVD0Eg0
        Y6X2ywtLDik+zlihUCpNXoCvNo67HqxGo43Jt8o7RBp/LHw0WtBk52aH5kMeUSX16il5z2
        5ymZGaOy8151qBIxkERphyRpw9cKcX4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-SLIQwljZM8un4fBwkNGW5w-1; Tue, 13 Jun 2023 05:57:30 -0400
X-MC-Unique: SLIQwljZM8un4fBwkNGW5w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f73936c258so7043895e9.1
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 02:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686650249; x=1689242249;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d24qNgsK4YI73pNJSGPXOXGrlkTr7CIQRglIpszf5fE=;
        b=PMEg8a+ACA80mksD631bhxZEup/HfgHSx7+uzZF0DFi6HxJv/n0/o6F9rjeiwaMgRM
         u+kloC9LdmqSDK1O9CvvzysRdDJ8IaqOfi1h1iLIv4FQbvmxf7TP3seOlwPJ9MlF5rwS
         ZwUAsuoCWqqbzrppWrL/Pk1foOMmcDk1x7eImXUjk4bRVa9lA3j1BJ0KOyWz+gkRA1Rc
         7C2rQ0LJv4YJhFwYt9Fz4rNkoxBcIu0XSBvQqYFYBs2oi5X64guX5S2aDVTruj0NE0+K
         RXgp08n1CRD/5hyEGLhxnbky7nTLaL5P7t5/yjhtTNHzJuHIbpuAqmmqoINgtAzwrlwy
         3RCw==
X-Gm-Message-State: AC+VfDwORRtuGtEEnnIiS2aDInMR8HL1UFeZuxgO7jBA8sb8B29mo/m2
        mm822jjJkoXZsS3PFTGe2RgrVDVlOpP/g5jvdWsgpF3jk0j8dow4tbTsbKItv4zU6ivFG3NOLGR
        PlF9FJEWFjC8Y
X-Received: by 2002:a05:600c:3843:b0:3f7:1483:b229 with SMTP id s3-20020a05600c384300b003f71483b229mr9712649wmr.3.1686650249190;
        Tue, 13 Jun 2023 02:57:29 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5DWlGtfOHfyQjcabrgMLJ7MLmCh6LzHVrUWcE9P78XidO1dSdo0iXISnggfacCEipbLVgi+A==
X-Received: by 2002:a05:600c:3843:b0:3f7:1483:b229 with SMTP id s3-20020a05600c384300b003f71483b229mr9712637wmr.3.1686650248918;
        Tue, 13 Jun 2023 02:57:28 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z10-20020a05600c114a00b003f7e60622f0sm13922898wmz.6.2023.06.13.02.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 02:57:28 -0700 (PDT)
Message-ID: <92b65190-b39b-e410-1831-31d63a6aa129@redhat.com>
Date:   Tue, 13 Jun 2023 17:57:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 09/17] KVM: arm64: Key use of VHE instructions in nVHE
 code off ARM64_KVM_HVHE
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
 <20230609162200.2024064-10-maz@kernel.org>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230609162200.2024064-10-maz@kernel.org>
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

On 6/10/23 00:21, Marc Zyngier wrote:
> We can now start with the fun stuff: if we enable VHE *only* for
> the hypervisor, we need to generate the VHE instructions when
> accessing the system registers.
> 
> For this, reporpose the alternative sequence to be keyed off
s/reporpose/repropose or s/reporpose/repurpose ?
> ARM64_KVM_HVHE in the nVHE hypervisor code, and only there.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_hyp.h | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index fea04eb25cb4..b7238c72a04c 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -33,12 +33,18 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
>   
>   #else // !__KVM_VHE_HYPERVISOR__
>   
> +#if defined(__KVM_NVHE_HYPERVISOR__)
> +#define VHE_ALT_KEY	ARM64_KVM_HVHE
> +#else
> +#define VHE_ALT_KEY	ARM64_HAS_VIRT_HOST_EXTN
> +#endif
> +
>   #define read_sysreg_elx(r,nvh,vh)					\
>   	({								\
>   		u64 reg;						\
> -		asm volatile(ALTERNATIVE(__mrs_s("%0", r##nvh),	\
> +		asm volatile(ALTERNATIVE(__mrs_s("%0", r##nvh),		\
>   					 __mrs_s("%0", r##vh),		\
> -					 ARM64_HAS_VIRT_HOST_EXTN)	\
> +					 VHE_ALT_KEY)			\
>   			     : "=r" (reg));				\
>   		reg;							\
>   	})
> @@ -48,7 +54,7 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
>   		u64 __val = (u64)(v);					\
>   		asm volatile(ALTERNATIVE(__msr_s(r##nvh, "%x0"),	\
>   					 __msr_s(r##vh, "%x0"),		\
> -					 ARM64_HAS_VIRT_HOST_EXTN)	\
> +					 VHE_ALT_KEY)			\
>   					 : : "rZ" (__val));		\
>   	} while (0)
>   

-- 
Shaoqin

