Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BA43BD8C4
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhGFOqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:46:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233028AbhGFOqY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:46:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ns4TUY5RO+JX4wfj0vy5qifMdax9cNA6M3GBSIkoFEM=;
        b=HnneoBsw1hbOu7cR8MKAE/HEa/XOF2tGI26kPrAnfyrB5EhV3UheRWnIbzDTeSHa9e1rxc
        mPciaSkLD7EhOOZGW1YrfVr6DUXJ8RFOXY6y2JTSGnuAsMrNmR22nWeId/TIvcV49ULAZp
        c5lIwbNnHXbdWgpfOlf4OUoMOoKJ1AI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-bsroWH6iMkqh0evOEhBMIg-1; Tue, 06 Jul 2021 10:43:40 -0400
X-MC-Unique: bsroWH6iMkqh0evOEhBMIg-1
Received: by mail-ej1-f70.google.com with SMTP id jl8-20020a17090775c8b02904db50c87233so1751057ejc.16
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ns4TUY5RO+JX4wfj0vy5qifMdax9cNA6M3GBSIkoFEM=;
        b=E5w4s8LGJtgPBMmCOBiscmUAvsGrrC5EPzOlwct1Awwp3s2zKCCwEJAoUkMp0611H3
         uXCoGPVv5rdVP7COG+t3xo88QNreOH8L1uyKa5w06vpzHmhSyKS+oJW3KUQS/Lvd6/n8
         ggoIWK2RFb5h8oQ7U2d2SLsXj+w1wvsrpguDXCnB7obGbgXZI5qNDbUNqfuqYhxuyXOz
         tJ6vYVUnUSfj03syaU8UwMH+0yVY2sQIbuMac1F8kt1T4R4k/6uDH/0OwX16ZLw4Y+Qk
         U4OcaOtEp12JqFn1i8dAxy0kdtUnV5Oz7AMwjKFdWyZO9LCaE69QmiiiY0iQjwxKZ8ot
         j9Nw==
X-Gm-Message-State: AOAM53148fVbijnyy6X3KQXV25AilRgiYAIttlpj2dWID2vmtioELqyb
        k4j1zo+IRyiq7/Oi/gU7V4THgnQJbop6x+CQFRkdhTE1Z5xi+H2/Yni5GNm9titCUCIyD/KZxfh
        FABC8V6Fk+eul
X-Received: by 2002:a05:6402:796:: with SMTP id d22mr23658830edy.64.1625582619820;
        Tue, 06 Jul 2021 07:43:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSSNMGGlg6GIilGiscCpEFKf2dSG/bfkm6NBsS+otzsw2jItjDuqovoJWdlrFftwo+iPPPAQ==
X-Received: by 2002:a05:6402:796:: with SMTP id d22mr23658798edy.64.1625582619689;
        Tue, 06 Jul 2021 07:43:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q5sm5807904ejc.117.2021.07.06.07.43.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:43:38 -0700 (PDT)
Subject: Re: [RFC PATCH v2 56/69] KVM: VMX: Move setting of EPT MMU masks to
 common VT-x code
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <a1b2906ef5264c1a1bdaeca238da9d24028ab61d.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <02dd301a-c15f-08d3-3f69-4cf501979a49@redhat.com>
Date:   Tue, 6 Jul 2021 16:43:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a1b2906ef5264c1a1bdaeca238da9d24028ab61d.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c | 4 ++++
>   arch/x86/kvm/vmx/vmx.c  | 4 ----
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index c3fefa0e5a63..0d8d2a0a2979 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -34,6 +34,10 @@ static __init int vt_hardware_setup(void)
>   	if (ret)
>   		return ret;
>   
> +	if (enable_ept)
> +		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> +				      cpu_has_vmx_ept_execute_only());
> +
>   	return 0;
>   }
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 77b2b2cf76db..e315a46d1566 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7644,10 +7644,6 @@ static __init int hardware_setup(void)
>   
>   	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
>   
> -	if (enable_ept)
> -		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> -				      cpu_has_vmx_ept_execute_only());
> -
>   	if (!enable_ept)
>   		ept_lpage_level = 0;
>   	else if (cpu_has_vmx_ept_1g_page())
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

