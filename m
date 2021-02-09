Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FB6314B71
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 10:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBIJXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 04:23:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230380AbhBIJSs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 04:18:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612862241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kR4sfJQwPWMNwNuj+DnkuEqp3smRfq3+g8cDBmgUXoA=;
        b=AMKXNCMmv/WGUv7+37oC6HtIkHiDTtZJsrcNIjbYZSC/juw/sx8uo705SMinndjVap2RWX
        hQ3otmkKBjd3gtI8Rb+yRQxi4DPIC6tZrxW0aVKVlv3rxqaaTTjZgbhtAbz6MEDkK69vEu
        IYWane9GqzswZ8mgwEoRBlDoNNazHxA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-mbJwJl05Nnmo8B6_QSyX9w-1; Tue, 09 Feb 2021 04:17:18 -0500
X-MC-Unique: mbJwJl05Nnmo8B6_QSyX9w-1
Received: by mail-wr1-f69.google.com with SMTP id u15so16450756wrn.3
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 01:17:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kR4sfJQwPWMNwNuj+DnkuEqp3smRfq3+g8cDBmgUXoA=;
        b=oTLvlCT7pUijWgR2SD13Y0WNHi8SlMEXHOUzx8UHCuMSf4176zUiEDaQ5INiDYQf3J
         KsESVPGqzcZQyaV/k+7Tr3aF3Je5Jb/sYj1ZO16zLCBlRPy2gz9PsuGbl7mYdZwXUiZC
         GRhkAg4JExjKuRxFZcv4zD+kSVRmNH/6wRk8X6H7lWOyYSetMjNLqtOQW6UBuw/quhB8
         wkM6UB/y7BnhfqDctBrwkTIR3UjIAm4gzeh5MuywTHxVQKULMvdsr+aGefsaykREWE8z
         gpho4DPYGcEMHDeBWihgo/x8cBMnLmLncS5+JBuVLEkwpXonWQexfZO7Yex4A4lw+NoM
         GdtA==
X-Gm-Message-State: AOAM5318L/dBfmzL5MKbvAYND5uzNqpc0rfMMn4wLj7BnBMLvIW4UydC
        iymOJjE1cFL1Z1ORDc6CPzKKqfMu2A+/1AqvsIaV90DaZ02z8KLCUMH0FnkIeoXTy7/qyozXyX/
        OYCE+GDqHaw3k
X-Received: by 2002:a1c:6487:: with SMTP id y129mr2492730wmb.106.1612862237464;
        Tue, 09 Feb 2021 01:17:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmwWCDV49tFTXVIYPvZaeseHOM7ABgseFOX6gJD/bn3tbrRsCVdjIey4yCLXII8UjBT2t/Xg==
X-Received: by 2002:a1c:6487:: with SMTP id y129mr2492713wmb.106.1612862237289;
        Tue, 09 Feb 2021 01:17:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j7sm37174348wrp.72.2021.02.09.01.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 01:17:16 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: hyper-v: Fix erroneous 'current_vcpu' usage in
 kvm_hv_flush_tlb()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210209090448.378472-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a6dc2d08-32b6-6fdb-95e3-ab5dd89981d0@redhat.com>
Date:   Tue, 9 Feb 2021 10:17:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210209090448.378472-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/21 10:04, Vitaly Kuznetsov wrote:
> Previously, we used to use 'current_vcpu' instead of 'vcpu' in
> kvm_hv_flush_tlb() but this is no longer the case, it should clearly
> be 'vcpu' here, a mistake was made during rebase.
> 
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Fixes: d210b1e5b685 ("KVM: x86: hyper-v: Always use to_hv_vcpu() accessor to get to 'struct kvm_vcpu_hv'"
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> The broken patch is only in kvm/queue atm, we may as well want
> to squash the change.
> ---
>   arch/x86/kvm/hyperv.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 880ba3c678db..7d2dae92d638 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1555,7 +1555,7 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
>   static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool ex)
>   {
>   	struct kvm *kvm = vcpu->kvm;
> -	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(current_vcpu);
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>   	struct hv_tlb_flush_ex flush_ex;
>   	struct hv_tlb_flush flush;
>   	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
> 

Squashed, thanks.

Paolo

