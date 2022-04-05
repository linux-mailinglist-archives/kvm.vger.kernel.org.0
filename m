Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83EAA4F4980
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391552AbiDEWSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451871AbiDEPyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:54:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 210C612E769
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 07:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649170136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gLnQrP3xPWs2TZHtPngsxvbbh35oj514ez2KutsOFxM=;
        b=QZKbGykioQGSfmLoQR2zcqEqD947GhufDocQ/LqSMmX0Ldwy+lpo6er7LBqM+nU9MfgwOp
        AJu0jrxjjTMuzGrIGCyKUreePI91y7i8VOnTKa2p//OqAdayu+puFNnn1QW1N78xIYkGJC
        fS72yGtkM3dVKIoAp2crVD5Bu+NZ8vE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-5ZA21I4qPeSB9nYdz8Zk2A-1; Tue, 05 Apr 2022 10:48:50 -0400
X-MC-Unique: 5ZA21I4qPeSB9nYdz8Zk2A-1
Received: by mail-wm1-f71.google.com with SMTP id r19-20020a7bc093000000b0038e706da7c0so1353153wmh.1
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 07:48:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gLnQrP3xPWs2TZHtPngsxvbbh35oj514ez2KutsOFxM=;
        b=TDeQgDY+aIwgoFRBcU8ygBQHoTKa2OISoKaDsXQ5aA/TyHPHAPgFJob8dkrKYuv5hU
         cARfSW6u9JDOtCqKS8N3FbTi/7wUEEoqIqCl2hX44ipQNIIgRRiel2K4zeZCtqVBuecc
         k9lshCImGVgkd+sARUqiOnxZvF3tx9xOD3vpq+Nq3xynumWzSvHrw8P/iBOWPi9gGSmi
         2ixoAcOWeR4/sPdklUL3i7owKUOkWZgnzeaPH0ojngogSk8SwoEYyhh5jwsmL2KId7Y1
         VVL/p54sPiXVqviHnPygOjYUiaECG2AnnmHWEh9bYREHhDGLfqFhIlPTaDxtyis2py3P
         cQnw==
X-Gm-Message-State: AOAM532/Qs3P2YLdNpd772U5lvAuBCgWm1Sbn7dVgW7lng4rLW9sP2oi
        LgQTGkLyOCIyqvstIBBhYoiU79rvnfCVJy9waHMvYyZeDeArzRHWDK600ZiA1DwWQr9T/Syy3iG
        a0ZeEXfxK9zcl
X-Received: by 2002:a05:600c:27d1:b0:38e:72c2:5727 with SMTP id l17-20020a05600c27d100b0038e72c25727mr3474707wmb.123.1649170128821;
        Tue, 05 Apr 2022 07:48:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAm12iI6JoUmR7+6Czqj9MkJh71Zisi7Pf7OUy+0V6YUCaihNcSzxM1Dgv8W4AodPjbvVuXg==
X-Received: by 2002:a05:600c:27d1:b0:38e:72c2:5727 with SMTP id l17-20020a05600c27d100b0038e72c25727mr3474685wmb.123.1649170128568;
        Tue, 05 Apr 2022 07:48:48 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id az19-20020a05600c601300b0038cadf3aa69sm3722043wmb.36.2022.04.05.07.48.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:48:47 -0700 (PDT)
Message-ID: <b543e92d-0a98-26f6-105b-5c3bbf74f79f@redhat.com>
Date:   Tue, 5 Apr 2022 16:48:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 041/104] KVM: VMX: Move setting of EPT MMU masks to
 common VT-x code
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <4dbe2defb66835ac414cdb2dc5974fa4a6820101.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4dbe2defb66835ac414cdb2dc5974fa4a6820101.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> EPT MMU masks are used commonly for VMX and TDX.  The value needs to be
> initialized in common code before both VMX/TDX-specific initialization
> code.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c | 5 +++++
>   arch/x86/kvm/vmx/vmx.c  | 4 ----
>   2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 3eb9db6d83ac..51aaafe6b432 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -4,6 +4,7 @@
>   #include "x86_ops.h"
>   #include "vmx.h"
>   #include "nested.h"
> +#include "mmu.h"
>   #include "pmu.h"
>   #include "tdx.h"
>   
> @@ -22,6 +23,10 @@ static __init int vt_hardware_setup(void)
>   
>   	tdx_hardware_setup(&vt_x86_ops);
>   
> +	if (enable_ept)
> +		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> +				      cpu_has_vmx_ept_execute_only());
> +
>   	return 0;
>   }
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0edeeed0b4c8..07fd892768be 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7817,10 +7817,6 @@ __init int vmx_hardware_setup(void)
>   
>   	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
>   
> -	if (enable_ept)
> -		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> -				      cpu_has_vmx_ept_execute_only());
> -
>   	kvm_configure_mmu(enable_ept, 0, vmx_get_max_tdp_level(),
>   			  ept_caps_to_lpage_level(vmx_capability.ept));
>   

RB

