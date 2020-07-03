Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93993213D62
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 18:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgGCQQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 12:16:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22104 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgGCQQI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 12:16:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593792967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9x0KnYFgOS8wTlKm8R3U+OuqdM4zspdu1o2f2BkBM4Q=;
        b=JyAyQVClUFjfnjp1TBEOPaHNz8sGxa35/tsx9+E6X3GY2CrAUYBWCBpq7GMqpzoUm73UU6
        SzjXfB0eyeFCaEvfyUVGx7LERFSc8uOyCmDkMCp5vjEXu6wMf9SHjfrcUSk0J2QGiMfpf/
        fvgIsh6ises5m+BJI0rle7zvGBEZoek=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-vDb8qF5JMva3ifu4qHAdpw-1; Fri, 03 Jul 2020 12:16:05 -0400
X-MC-Unique: vDb8qF5JMva3ifu4qHAdpw-1
Received: by mail-wr1-f72.google.com with SMTP id s16so19014672wrv.1
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 09:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9x0KnYFgOS8wTlKm8R3U+OuqdM4zspdu1o2f2BkBM4Q=;
        b=QEBp5r97JWnXCyGKK16wH5gZAi0vA95Hu8xfc83DzWK8A5qcEDcKVtA+dn6X5UVv8o
         lRtyR5d4amrxAdbfjPfUJANhXnxTV2d2jB9fip+ceFLbhrPy8f9Mg0eFnKbgsBnRlHQL
         RdIvQqfswK8+SnGJZeRWzmPSOqs7RoumNZgpoxUtxshHKQvhJHQCR+LDCfHYU0+dMJz3
         nl3OvZxDwBnTXMYe2RyYexe2UdZfsEgGSBJTEB8XVSBzfrQ8uAuJjVYYqKKo7S6A5Dq9
         R8WCw9HGs+tihcexQVUD5IO+XFAzupp3LDHPfGH7sH/xbdcsWNgkaKpxFACjWEE2nGho
         Aolg==
X-Gm-Message-State: AOAM53206UsdowFquKWltkDuPu8TI/35QSvW5oz3jSDbvnwThn+JOwWh
        4gmHCp6/sNCSQVOSIxa5coyXJb4myesG5J3J04uIcj+OxgQCwl4MygYZWBDSou9jk2h6ZWti0cs
        szWDA6RI2tmBD
X-Received: by 2002:a1c:6805:: with SMTP id d5mr36223279wmc.19.1593792964569;
        Fri, 03 Jul 2020 09:16:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxF7sz6s55DLX49I14d4eV+RdhjFqv1/WIzuATUgvriPxw2BXexTSC4Gb5nLm2R7p3LnnTVcA==
X-Received: by 2002:a1c:6805:: with SMTP id d5mr36223255wmc.19.1593792964365;
        Fri, 03 Jul 2020 09:16:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5cf9:fc14:deb7:51fc? ([2001:b07:6468:f312:5cf9:fc14:deb7:51fc])
        by smtp.gmail.com with ESMTPSA id a3sm13510841wmb.7.2020.07.03.09.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 09:16:03 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Inject #GP if guest attempts to toggle CR4.LA57
 in 64-bit mode
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastien Boeuf <sebastien.boeuf@intel.com>
References: <20200703021714.5549-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b5d05192-08ea-1915-03b2-e2c7b6337b74@redhat.com>
Date:   Fri, 3 Jul 2020 18:16:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200703021714.5549-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/20 04:17, Sean Christopherson wrote:
> Inject a #GP on MOV CR4 if CR4.LA57 is toggled in 64-bit mode, which is
> illegal per Intel's SDM:
> 
>   CR4.LA57
>     57-bit linear addresses (bit 12 of CR4) ... blah blah blah ...
>     This bit cannot be modified in IA-32e mode.
> 
> Note, the pseudocode for MOV CR doesn't call out the fault condition,
> which is likely why the check was missed during initial development.
> This is arguably an SDM bug and will hopefully be fixed in future
> release of the SDM.
> 
> Fixes: fd8cb433734ee ("KVM: MMU: Expose the LA57 feature to VM.")
> Cc: stable@vger.kernel.org
> Reported-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00c88c2f34e4..2bb48896dbdc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -975,6 +975,8 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  	if (is_long_mode(vcpu)) {
>  		if (!(cr4 & X86_CR4_PAE))
>  			return 1;
> +		if ((cr4 ^ old_cr4) & X86_CR4_LA57)
> +			return 1;
>  	} else if (is_paging(vcpu) && (cr4 & X86_CR4_PAE)
>  		   && ((cr4 ^ old_cr4) & pdptr_bits)
>  		   && !load_pdptrs(vcpu, vcpu->arch.walk_mmu,
> 

Queued, thanks.

Paolo

