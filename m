Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDC658EC4E
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiHJMw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiHJMwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:52:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D665E6B152
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 05:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660135935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mxzKnYjaUmv6ZFjQVx+ZI2pVdTIanjD5yEPOkCk5cuE=;
        b=QblGf9sqcDp2TTvxECdzyRcdUVDWPgHsdCk7GcbYW8D171K14LrAvmT5yS+KYSlY+S+MqU
        oFTt3h+GjiqQvjNyll+17eRlKtNW25/AZ+yLzSm6J/nGwSXxTF1ApwJ84D7z2pmAGOSRYF
        B3BxkDfRbRtt+VpmyzxmMmZJyftSjH0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-dXpfX2_dN2KnkNHR_WCyHQ-1; Wed, 10 Aug 2022 08:52:14 -0400
X-MC-Unique: dXpfX2_dN2KnkNHR_WCyHQ-1
Received: by mail-ej1-f69.google.com with SMTP id gs35-20020a1709072d2300b00730e14fd76eso4203526ejc.15
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 05:52:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=mxzKnYjaUmv6ZFjQVx+ZI2pVdTIanjD5yEPOkCk5cuE=;
        b=jJtxCcM8Do2p0koDKRgl4UcZbi8b9p934i5Nc5i3EGN6e0mWH+SXKIP/oRdCtljXOA
         M93Gd5KPdiZTXN+29hLIOBuw5l/rFrnl8Crwh9sNHLI8ow3zTiaTntW4z4aqF2q24YFB
         ndCgTidry+McTPZa5Y7kXhYetLzJJUT2erRFpnguix7bDaeSfQdeWesiCuxhXAoYDcMX
         P+7fOPu8bQTuNFLdcgyZTyuJCgiidvb8vhFhHb+5Jp7TCqPm419LDVYPUvqDJ6rkNzrM
         UApB0wbYHnMxxZMpvq/XoXkEbXRnqhtTugXvO2DQUz3QaLs1mvLhqLj8RjRpLI2en+wd
         iyog==
X-Gm-Message-State: ACgBeo1UR4ShcerBNj8hcxV0roKl1QG+g+sDKy1gsO2a9b3ezsQVv9Lz
        alxswyfIlwuavipEn4Xx2vF7zQEVEqRjrSRJRtP/uAFoGdR8ppbtGS3fIwr1hyM++bXglPKQtMI
        Le3ZN06U7Ahzx
X-Received: by 2002:a17:907:7619:b0:730:d709:a2f0 with SMTP id jx25-20020a170907761900b00730d709a2f0mr19986930ejc.673.1660135933395;
        Wed, 10 Aug 2022 05:52:13 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4xmt66vkJ5qejLyaP2jSUxErv2LIOjXW2rIz0lx4LPiGoAw/LHDaKxOM7meZy2kI01x1blyA==
X-Received: by 2002:a17:907:7619:b0:730:d709:a2f0 with SMTP id jx25-20020a170907761900b00730d709a2f0mr19986921ejc.673.1660135933229;
        Wed, 10 Aug 2022 05:52:13 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id a6-20020a1709063e8600b0072f42ca2934sm2321108ejj.148.2022.08.10.05.52.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 05:52:12 -0700 (PDT)
Message-ID: <29150d3f-36fb-516d-55d0-a9aebe23cdcf@redhat.com>
Date:   Wed, 10 Aug 2022 14:52:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH 2/3] KVM: x86: Generate set of VMX feature MSRs using
 first/last definitions
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20220805172945.35412-1-seanjc@google.com>
 <20220805172945.35412-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220805172945.35412-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/22 19:29, Sean Christopherson wrote:
>   
> +static void kvm_proble_feature_msr(u32 msr_index)
> +{
> +	struct kvm_msr_entry msr = {
> +		.index = msr_index,
> +	};
> +
> +	if (kvm_get_msr_feature(&msr))
> +		return;
> +
> +	msr_based_features[num_msr_based_features++] = msr_index;
> +}
> +
>   static void kvm_init_msr_list(void)
>   {
>   	u32 dummy[2];
> @@ -6954,15 +6949,11 @@ static void kvm_init_msr_list(void)
>   		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
>   	}
>   
> -	for (i = 0; i < ARRAY_SIZE(msr_based_features_all); i++) {
> -		struct kvm_msr_entry msr;
> +	for (i = KVM_FIRST_EMULATED_VMX_MSR; i <= KVM_LAST_EMULATED_VMX_MSR; i++)
> +		kvm_proble_feature_msr(i);
>   
> -		msr.index = msr_based_features_all[i];
> -		if (kvm_get_msr_feature(&msr))
> -			continue;
> -
> -		msr_based_features[num_msr_based_features++] = msr_based_features_all[i];
> -	}
> +	for (i = 0; i < ARRAY_SIZE(msr_based_features_all_except_vmx); i++)
> +		kvm_proble_feature_msr(msr_based_features_all_except_vmx[i]);

I'd rather move all the code to a new function 
kvm_init_feature_msr_list() instead, and call it from 
kvm_arch_hardware_setup().

Thanks,

paolo

