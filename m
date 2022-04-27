Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465CD511DEF
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242834AbiD0QU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 12:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243965AbiD0QUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 12:20:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBC8931344
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lnbYpT3n4B6RsMs/mx0BEjUPavBjzVBVGqKnbmYGpK8=;
        b=CnaUT1bq+Ho92y54tAoIPww1RCLQBy4g0oLedSKY+usueG2qeqbBBUo1ruNo6l6wBeKtud
        FRgxQC82KXDQsmxXEg355cXSb6JL0zpfdY0YxlhT5vNUf6Plp4xeG98fdy5E4AtxX+btdW
        9Ef6rmNLG45qR3LMkplWw72oixeHu34=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-dTjIX2soPp61_K-lUJ4NAQ-1; Wed, 27 Apr 2022 12:16:48 -0400
X-MC-Unique: dTjIX2soPp61_K-lUJ4NAQ-1
Received: by mail-ej1-f70.google.com with SMTP id dt18-20020a170907729200b006f377ebe5cbso1418532ejc.22
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:16:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lnbYpT3n4B6RsMs/mx0BEjUPavBjzVBVGqKnbmYGpK8=;
        b=Q2N8KDXO7EYPDgHvY8Kr0Tqb0j0BzJEQPVXA2D0InCuxouqkeD9Az/EoT9a6ssXYEO
         Q2BKO4zl4+aC5+RN2gAfVbLL1rghVq0XL7+Se6SFMP2ayYPCVl90aynULfulLXLvRX8o
         3Dn0/PQ7rOemySI1TWLHTiE8X/W1hAfU8gOlKxDC4lGBfAkRD+liIGtL2q0gKX9BL/yE
         bfcAmV1i2bR4mitsR0n6MTyQbl0tzLLHT+Lv1f8z5h2BG/o3iYDidT0sLC2dpFOZZjFe
         aVKGbFWOcJy5V6+5YfO9PQnVz1getVX/6E5hdky09kuCh49lIh2Vq61eIfdpPnEHhocL
         oAXQ==
X-Gm-Message-State: AOAM532XP6LDfHS5PemlETdb8QXlxiRBm5p4EQeq0QV2hgxjKJ2qHKiR
        BXF0YOj9Emm0kebQMkCwCDHqPgc3+lZmCTJHYcPXwt3z27yOXFwrOExXgKU+fly0/gKYKTB4M6y
        rdO6iKoxcaR70
X-Received: by 2002:a05:6402:1385:b0:413:2bc6:4400 with SMTP id b5-20020a056402138500b004132bc64400mr31644133edv.94.1651076206797;
        Wed, 27 Apr 2022 09:16:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwN04JdY7dXcDoRLxwm8dz33jXMrEZAL6VpDpEQyqIpRZoNCQH0xB7s555bdSekIj0FSocVQg==
X-Received: by 2002:a05:6402:1385:b0:413:2bc6:4400 with SMTP id b5-20020a056402138500b004132bc64400mr31644110edv.94.1651076206540;
        Wed, 27 Apr 2022 09:16:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id kx5-20020a170907774500b006e1382b8192sm7299037ejc.147.2022.04.27.09.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:16:45 -0700 (PDT)
Message-ID: <99b2369b-9433-641f-053e-f1f5b7fe8717@redhat.com>
Date:   Wed, 27 Apr 2022 18:16:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.17 4/7] KVM: x86: Do not change ICR on write
 to APIC_SELF_IPI
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155408.19352-1-sashal@kernel.org>
 <20220427155408.19352-4-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155408.19352-4-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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
> index 2a10d0033c96..6b6f9359d29e 100644
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

