Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8CD511D33
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241649AbiD0Q1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 12:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243289AbiD0Q0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 12:26:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC116260A91
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dwJo7dHXaSN40obK+h5qf6IQpWA1meQmVUMooAWsmyA=;
        b=XvfO6OcqyI+vuwj+dZ//QbzGQ3zjutrjjmLEOwccWqJ8hejAiF+Eh1IikeY2rqW+WOwkd0
        t4PjAegR0Mu4CrHklwhSfTbEAC5CwMgHlrbtm4Rpjq925cpXRcHHXCUxsP43AgUQCpxS16
        6N77Y6GNI3b7H0FBH/wRqAJgH9idrY0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-W6WRjWvmOnuGxvVzFbZbZg-1; Wed, 27 Apr 2022 12:19:39 -0400
X-MC-Unique: W6WRjWvmOnuGxvVzFbZbZg-1
Received: by mail-ed1-f72.google.com with SMTP id s24-20020a05640217d800b00425e19e7deaso1265272edy.3
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dwJo7dHXaSN40obK+h5qf6IQpWA1meQmVUMooAWsmyA=;
        b=lbr6QnUOS+vHLryp2uGwG0c2fXlHFf7YmpvzrU+V91q1T8tSDYuyi+EzNN/tg6WHvD
         4IhMZPU5mCupMSVgWd5HYMKUX6PQT1Uibk7deQDLisWwEsueOmrbfgAj5vqew/ScaAsT
         CdOvz0bCp/uSYPf2vU5LdHuuyfUBE9gii3Hd0RYZloC1+mlpXSirRBMQi4oMSkVYGWlb
         347A3fTuDIZJSSG9W7XX8d4rLlbwhUQr2ZtoZtnQMYjQemHFPLPnvc8o//y3uumO9A4C
         DYOuMcJFHj99CxufQo2ygt/ujo/pE/+mmTnSwq2S39iL+rUnfTpN5PWJSzVS/umohhIh
         o3Hg==
X-Gm-Message-State: AOAM531pBlFTjfStX/KmVJ0UAIvOhcBXrCCiWz4EAHF2gsC2iLL5Wy3D
        6ex7uBq9vVFppDysuuNgJ/a0cVUlwxKHY2ouErFvIqeQEScpmQCaU96wT0T6Fk2kD50s1YcMLRc
        gSbeZ5NiEaMLi
X-Received: by 2002:a05:6402:2709:b0:423:e570:c2b3 with SMTP id y9-20020a056402270900b00423e570c2b3mr30965944edd.413.1651076378309;
        Wed, 27 Apr 2022 09:19:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/G/P1GKQJhQyARBpCFS7e08qmFGV9gidMwAK324c+HDd3kPz+isuxHXJM0aiOQmTIGlBVPw==
X-Received: by 2002:a05:6402:2709:b0:423:e570:c2b3 with SMTP id y9-20020a056402270900b00423e570c2b3mr30965913edd.413.1651076378069;
        Wed, 27 Apr 2022 09:19:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id cr10-20020a056402222a00b0041d918fdf99sm8817933edb.85.2022.04.27.09.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:19:37 -0700 (PDT)
Message-ID: <ccbd5ad5-efc4-0eef-4c2c-b6cbe730e266@redhat.com>
Date:   Wed, 27 Apr 2022 18:19:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.15 5/7] KVM: x86: Do not change ICR on write
 to APIC_SELF_IPI
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155431.19458-1-sashal@kernel.org>
 <20220427155431.19458-5-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155431.19458-5-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 17:54, Sasha Levin wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> [ Upstream commit d22a81b304a27fca6124174a8e842e826c193466 ]
> 
> Emulating writes to SELF_IPI with a write to ICR has an unwanted side effect:
> the value of ICR in vAPIC page gets changed.  The lists SELF_IPI as write-only,
> with no associated MMIO offset, so any write should have no visible side
> effect in the vAPIC page.
> 
> Reported-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/lapic.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 4d92fb4fdf69..83d1743a1dd0 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2125,10 +2125,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>   		break;
>   
>   	case APIC_SELF_IPI:
> -		if (apic_x2apic_mode(apic)) {
> -			kvm_lapic_reg_write(apic, APIC_ICR,
> -					    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
> -		} else
> +		if (apic_x2apic_mode(apic))
> +			kvm_apic_send_ipi(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK), 0);
> +		else
>   			ret = 1;
>   		break;
>   	default:

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

