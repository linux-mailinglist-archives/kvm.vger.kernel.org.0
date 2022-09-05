Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E5A5ADB01
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 23:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiIEV7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 17:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIEV7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 17:59:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B21961D50
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 14:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662415142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RAY3gQ8Xv5sgZ9Zo0Mx1i+IU51VPCmp6wQjEDksHoMc=;
        b=GC6PB2tRXoMynWSvyB0bmBKWa9YhISIAH8SU02n72CD5mBjzX8f7Zkdce6d4GzPik1ENrh
        3VvzaVRQZsZquLO8r0MIxcCp68t+LLkpg1uEozCkxOjPubq9rDn9kMZgl7IEHtIIW3vrAP
        xtdZAKa0VAL1aM1czi13yaak/cThB+8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-WdnqQ89SNp28iLNXSKvRww-1; Mon, 05 Sep 2022 17:59:01 -0400
X-MC-Unique: WdnqQ89SNp28iLNXSKvRww-1
Received: by mail-ed1-f72.google.com with SMTP id z7-20020a05640235c700b0044eca667f71so285176edc.11
        for <kvm@vger.kernel.org>; Mon, 05 Sep 2022 14:59:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=RAY3gQ8Xv5sgZ9Zo0Mx1i+IU51VPCmp6wQjEDksHoMc=;
        b=luu59PMXv/84Kkvt81NeifPmDdUKlt69tcNNhHOUGzR1vGaaJU7Nycs3BfrJipIthZ
         qUuoiG4Zzpndt7pNFNO56SJk22gL9VM5ipGigcY2Fs/EfqxkxLn87kHczYCpXSr6nJ5C
         58D9PQYq2gdKzLyUAF9DKZOO8idRJGmdWaOE50jAx7T00t+Yo6VRTD/IPNZO9J4cla48
         LyZHMEn5pZXhmY0N8psjeAXJp+K2twYWCrIog2r4DVYI7KqbXYZ4LCkGl+eidVBD6412
         xFzptRmVIrBJfAQknVPNLX8k9RsOhztBbT14UxgU7xnh7HO4gv0Ah4TJcLY1aS+t7Ny2
         IRyw==
X-Gm-Message-State: ACgBeo1yk5pgVWqxpGRHmwLbVUtO5cJTrOCXwmu9DotVvmZTsSSz2INQ
        v5PebtwJRgNNTcU9OVphHREV3iU77S6DSacSrUF8GpTqLjtKgTdLPJCwwxp7kTyhNXXYYKKdH7M
        rEasvZ0sKxxFv
X-Received: by 2002:a05:6402:2816:b0:434:ed38:16f3 with SMTP id h22-20020a056402281600b00434ed3816f3mr44755463ede.116.1662415139841;
        Mon, 05 Sep 2022 14:58:59 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5KgZDF4x6XT0w7r5MDWoJvTRUxPcc4FRQa30H8/IqkhQenleXBRD3hn/0uDfCOm7hr1dy84Q==
X-Received: by 2002:a05:6402:2816:b0:434:ed38:16f3 with SMTP id h22-20020a056402281600b00434ed3816f3mr44755447ede.116.1662415139658;
        Mon, 05 Sep 2022 14:58:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id s4-20020a50d484000000b004479cec6496sm7206128edi.75.2022.09.05.14.58.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 14:58:59 -0700 (PDT)
Message-ID: <975d615b-8eb1-1d95-c753-7585c7aa9fac@redhat.com>
Date:   Mon, 5 Sep 2022 23:58:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 02/23] KVM: SVM: Flush the "current" TLB when
 activating AVIC
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20220903002254.2411750-1-seanjc@google.com>
 <20220903002254.2411750-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220903002254.2411750-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/22 02:22, Sean Christopherson wrote:
> Flush the TLB when activating AVIC as the CPU can insert into the TLB
> while AVIC is "locally" disabled.  KVM doesn't treat "APIC hardware
> disabled" as VM-wide AVIC inhibition, and so when a vCPU has its APIC
> hardware disabled, AVIC is not guaranteed to be inhibited.  As a result,
> KVM may create a valid NPT mapping for the APIC base, which the CPU can
> cache as a non-AVIC translation.
> 
> Note, Intel handles this in vmx_set_virtual_apic_mode().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/avic.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6919dee69f18..4fbef2af1efc 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -86,6 +86,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>   		/* Disabling MSR intercept for x2APIC registers */
>   		svm_set_x2apic_msr_interception(svm, false);
>   	} else {
> +		/*
> +		 * Flush the TLB, the guest may have inserted a non-APIC
> +		 * mappings into the TLB while AVIC was disabled.

mapping

Otherwise,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> +		 */
> +		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
> +
>   		/* For xAVIC and hybrid-xAVIC modes */
>   		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
>   		/* Enabling MSR intercept for x2APIC registers */

