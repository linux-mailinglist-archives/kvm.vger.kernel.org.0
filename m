Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA5D3DE989
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 11:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbhHCJMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 05:12:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234699AbhHCJMu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 05:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627981959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eCKm6da5+hhoG0rSAczFzIx0ZDsjnfG3RjfWntwjIfE=;
        b=UDPLBxXWRnVeHbRVVrYi3G7Uv5vLFvSaupRCjTElIdxSBfCX2hkwFb7QcwQAXkaLvWeGzm
        eTaIoyvH4ud9nyl1kcgEPSXmL7AQ5dtyXkNlTq7PWZN60gJsoCkDpR6fRlYz6Z1jT14/kA
        IHNbdUxWgxWG1Vq9L5MXEy04ZAFrETk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-fcYk0rmcOZ-vYCDTFS718w-1; Tue, 03 Aug 2021 05:12:37 -0400
X-MC-Unique: fcYk0rmcOZ-vYCDTFS718w-1
Received: by mail-wr1-f70.google.com with SMTP id z10-20020adfdf8a0000b02901536d17cd63so7347296wrl.21
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 02:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eCKm6da5+hhoG0rSAczFzIx0ZDsjnfG3RjfWntwjIfE=;
        b=P6r4f3c3xZRX7Dbe/aPZ4pFzzHH8E/YZV+JMRcvKT4woH4FxScWoQxOpoEEqkXNUAl
         rvj8gWkprj6+9u5HA5owAbuJkoN123IPhZgD3He9ZtL/8NxpCalhG5ICoqNN6+kHvDBp
         Gav/2sjoChgqH8DK3owBnRm6031vzdFrl7DeRxd9LV1UglK+qqyte313JUfnDcEzX/QO
         n+Hm7HKVBaIVhPwsdxwECYftasw6IyUz04eH7X6eq9oY8Gd7oH4mDJJyF23Dkv/01gbe
         7nBiqBVZOyfGZ2Se4C39tIoyDOVVU6Hw9rAdPMk5yxo8G53YFpKoN/IWAUiryZM7DVoz
         bRWA==
X-Gm-Message-State: AOAM533FZoA4O6fw1jEafhoYY1SPNyZdZy7didQHmuBntrxO0Y3/4MD5
        VRhuk4T0P7jGvKvH1mukwr8DeD3W/3BoP7A2fkTLCzIbx5trPS4b9bhfWLyrpuitviXnme0j2oj
        woaAbkajXv88R
X-Received: by 2002:a5d:500a:: with SMTP id e10mr8231502wrt.408.1627981956706;
        Tue, 03 Aug 2021 02:12:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4sV9KN3ghccHUUcC1Z25a/b+c2HxmSI9BHJqh17kYzma2BQ7RCPYSwyOWG6ol50Cr1aLdyw==
X-Received: by 2002:a5d:500a:: with SMTP id e10mr8231489wrt.408.1627981956546;
        Tue, 03 Aug 2021 02:12:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id x12sm14136910wrt.35.2021.08.03.02.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 02:12:35 -0700 (PDT)
Subject: Re: [PATCH v3 05/12] KVM: x86/mmu: allow APICv memslot to be
 partially enabled
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
 <20210802183329.2309921-6-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <596639a1-4df3-54e7-3f72-1bd292e592a2@redhat.com>
Date:   Tue, 3 Aug 2021 11:12:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802183329.2309921-6-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 20:33, Maxim Levitsky wrote:
> on AMD, APIC virtualization needs to dynamicaly inhibit the AVIC in a
> response to some events, and this is problematic and not efficient to do by
> enabling/disabling the memslot that covers APIC's mmio range.
> Plus due to SRCU locking, it makes it more complex to request AVIC inhibition.
> 
> Instead, the APIC memslot will be always enabled, but the MMU code
> will not install a SPTE for it, when arch.apic_access_memslot_enabled == false
> and instead jump straight to emulating the access.
> 
> When inhibiting the AVIC, this SPTE will be zapped.
> 
> This code is based on a suggestion from Sean Christopherson:
> https://lkml.org/lkml/2021/7/19/2970
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++++++++-----
>   1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f77f6efd43c..965b562da893 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3857,11 +3857,24 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>   	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
>   		goto out_retry;
>   
> -	/* Don't expose private memslots to L2. */
> -	if (is_guest_mode(vcpu) && !kvm_is_visible_memslot(slot)) {
> -		*pfn = KVM_PFN_NOSLOT;
> -		*writable = false;
> -		return false;
> +	if (!kvm_is_visible_memslot(slot)) {
> +		/* Don't expose private memslots to L2. */
> +		if (is_guest_mode(vcpu)) {
> +			*pfn = KVM_PFN_NOSLOT;
> +			*writable = false;
> +			return false;
> +		}
> +		/*
> +		 * If the APIC access page exists but is disabled, go directly
> +		 * to emulation without caching the MMIO access or creating a
> +		 * MMIO SPTE.  That way the cache doesn't need to be purged
> +		 * when the AVIC is re-enabled.
> +		 */
> +		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
> +		    !vcpu->kvm->arch.apic_access_memslot_enabled) {

In addition to using apicv_inhibit_reasons, I would change the subject 
to "allow APICv memslot to be enabled but invisible".  Otherwise looks good.

Paolo

> +			*r = RET_PF_EMULATE;
> +			return true;
> +		}
>   	}
>   
>   	async = false;
> 

