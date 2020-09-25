Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C02427889F
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 14:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgIYM4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 08:56:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729426AbgIYM4x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 08:56:53 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601038611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tLaN6wNxAJedTAEARZR2wzt9J+KwCcgGOOE1+Pn6oqA=;
        b=Ux1gEOHXy5voP5WAJ6SyrqzA76xFDJ5oukNgExgDNrFHWIr2Bqn/TeE5yy9eDX9EV3/yKI
        dC3CWxpKrfTH6FmscG8mHv1zc6feDwnTvwT3EGcIzWligFrrNMFkX8ZqjQ/+i0yl/m4/B6
        f1xhLKTHhVKzKuCJgvjX1Xn3rlDfWgs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-_xQLfJ4PNXqc-_mTimnZGg-1; Fri, 25 Sep 2020 08:56:49 -0400
X-MC-Unique: _xQLfJ4PNXqc-_mTimnZGg-1
Received: by mail-wm1-f70.google.com with SMTP id l26so800268wmg.7
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 05:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tLaN6wNxAJedTAEARZR2wzt9J+KwCcgGOOE1+Pn6oqA=;
        b=BqczwTs+kGsHenFy5RaTwDM8RErNsxssIodMHU/e8/3IDE182Z33KNDoCcwVCETc0j
         c7y5vMiUVvdqdybvrNoIRoxiFZ06b/hr5scNMSGbCMOQe5iwtPFxoDmMgVSbDlb4Lz8V
         ZRrJ/puERrDlAHe+cBjNerqzXFy2dz+OCgMQIqLTlFzkfJAOpzZnkCjRJAMx22ZoOCAM
         X55C+uBIkAp60iciZCw49yyr9Ox7tHAqjofSrsb3ldKpMZdcaPtIRKm+5T6qj+E9vZTz
         Zh0oU9AdHtBdmnInr5kR7TxvvJLGA8K6jDwUR8jU2QJG4n+wXJa2XYMnFG/G6g+3mhMv
         u/fw==
X-Gm-Message-State: AOAM531ruF2r0P3EGRNSY2NgSYpmGm1smPyrOs1ZZpqpXzvKCGbUKOil
        ZNY7WlcVU3w2+CIE5oJJTK3cPJMsaLIWFFW3jPyA0F2WY+1ZRdd1IM1hW1DzoSjZPP45BFQ4ZDC
        ieQrr44zT8Vsa
X-Received: by 2002:a5d:5090:: with SMTP id a16mr4635123wrt.247.1601038608617;
        Fri, 25 Sep 2020 05:56:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJtjH6ww8wa5mn9vN9H73nVPxRf/FCgiLluhD+ECewFmA2i0pOH6ZEKBGjQYNMyw4apNrObQ==
X-Received: by 2002:a5d:5090:: with SMTP id a16mr4635103wrt.247.1601038608413;
        Fri, 25 Sep 2020 05:56:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id y6sm2862442wrn.41.2020.09.25.05.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 05:56:47 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Reset MMU context if guest toggles CR4.SMAP or
 CR4.PKE
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
References: <20200923215352.17756-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <52f35035-94cd-9a4e-263a-6b3641e5d44c@redhat.com>
Date:   Fri, 25 Sep 2020 14:56:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923215352.17756-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 23:53, Sean Christopherson wrote:
> Reset the MMU context during kvm_set_cr4() if SMAP or PKE is toggled.
> Recent commits to (correctly) not reload PDPTRs when SMAP/PKE are
> toggled inadvertantly skipped the MMU context reset due to the mask
> of bits that triggers PDPTR loads also being used to trigger MMU context
> resets.
> 
> Fixes: 427890aff855 ("kvm: x86: Toggling CR4.SMAP does not load PDPTEs in PAE mode")
> Fixes: cb957adb4ea4 ("kvm: x86: Toggling CR4.PKE does not load PDPTEs in PAE mode")
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Peter Shier <pshier@google.com>
> Cc: Oliver Upton <oupton@google.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 17f4995e80a7..fd0da41bc149 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -977,6 +977,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  	unsigned long old_cr4 = kvm_read_cr4(vcpu);
>  	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
>  				   X86_CR4_SMEP;
> +	unsigned long mmu_role_bits = pdptr_bits | X86_CR4_SMAP | X86_CR4_PKE;
>  
>  	if (kvm_valid_cr4(vcpu, cr4))
>  		return 1;
> @@ -1004,7 +1005,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  	if (kvm_x86_ops.set_cr4(vcpu, cr4))
>  		return 1;
>  
> -	if (((cr4 ^ old_cr4) & pdptr_bits) ||
> +	if (((cr4 ^ old_cr4) & mmu_role_bits) ||
>  	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
>  		kvm_mmu_reset_context(vcpu);
>  
> 

Queued, thanks.

Paolo

