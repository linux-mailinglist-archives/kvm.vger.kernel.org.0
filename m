Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB95292AF1
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 17:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbgJSP7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 11:59:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730259AbgJSP7f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 11:59:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603123174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oOEy9aT9NtMMFJrshH7arUKD1nGqLIA4h6tvbyg+cCQ=;
        b=L0fJ6d0zbNEbdQ26E+dc6QJf5CfwuKmMxwnQ0L71cAG00cUwAP9nskzrYmCWgbODqWoo4c
        mKXRHF18kQSuwsrn8/QIsEpBk89fFBrv7pV/X/X4CHAt/9yMULlodi2aDPeIb+V3TOYzEi
        ZLnrKOTlBPF20U9SlRKAlcIueBAaoJU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-536wBrYMN267igg8n1eeew-1; Mon, 19 Oct 2020 11:59:32 -0400
X-MC-Unique: 536wBrYMN267igg8n1eeew-1
Received: by mail-wr1-f71.google.com with SMTP id q15so52269wrw.8
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 08:59:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oOEy9aT9NtMMFJrshH7arUKD1nGqLIA4h6tvbyg+cCQ=;
        b=MJ/oSu35tOf4Cz20UIO4jqP8crIbOj4VmPKoRU7OIoy0r35xjwYHEWSUQCDcWOVxEy
         Jz2JttYztp6v+QLx37l8h5lrub/cIijvy6TOa1QqsrCziKA3A19tpp5jCnILXWsix2py
         cEj8dCN51i8jca3UoyMTKAWVXdFMr3Mt+1Vq356huvS2J4nJFNwc9y90VgLfkO6z5Szq
         ksRkOezyk5IU7JzOKde41OKe834FkFsEcYDr1RrLmJq/VdhcNknOcaAZeKpyMWm6i3Jr
         rJ4BYoKFjtAOMWeukiEmgyPM80eWEFrP1biabP/0bCiiYKj2eM2esq3QJkhjChHQz7r3
         oWbg==
X-Gm-Message-State: AOAM533h8f5noLcDfi10GQMEx29sYPa4+vfGRqwe65meK4hnjfIT9CTJ
        xwJo6hdQkssiKgIZgYQCl0UAMAhw+4fdlBtnDI9acsVlNyB77zRu5nXJqDv5hJAqyF2wB7+zGIn
        uLRQe+YIdCU61
X-Received: by 2002:adf:a455:: with SMTP id e21mr286568wra.158.1603123171545;
        Mon, 19 Oct 2020 08:59:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEGOfQUJy5OxMjIop2OyfD2MyEgGIseNWdmiEzUvFGnE9jJvyiXxLsD4/rUhivbOaFwu1s2w==
X-Received: by 2002:adf:a455:: with SMTP id e21mr286529wra.158.1603123171196;
        Mon, 19 Oct 2020 08:59:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o129sm11143wmb.25.2020.10.19.08.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 08:59:30 -0700 (PDT)
Subject: Re: [PATCH 0/5] KVM: x86: Handle reserved CR4 bit interception in VMX
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
References: <20200930041659.28181-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <361d91aa-6900-12f3-d5bb-654ab4f9879f@redhat.com>
Date:   Mon, 19 Oct 2020 17:59:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200930041659.28181-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/20 06:16, Sean Christopherson wrote:
> This series stems from Lai's RFC patches to intercept LA57 and let the
> guest own FSGSBASE[*].  Discussion and inspection revealed that KVM does
> not handle the case where LA57 is supported in hardware but not exposed to
> the guest.  This is actually true for all CR4 bits, but LA57 is currently
> the only bit that can be reserved and also owned by the guest.  I have
> a unit test for this that I'll post separately.
> 
> Intercepting LA57 was by far the easiest fix for the immedidate bug, and
> is likely the right change in the long term as there's no justification
> for letting the guest own LA57.
> 
> The middle three patches adjust VMX's CR4 guest/host mask to intercept
> reserved bits.  This required reworking CPUID updates to also refresh said
> mask at the correct time.
> 
> The last past is Lai's, which let's the guest own FSGSBASE.  This depends
> on the reserved bit handling being in place.
> 
> Ran everything through unit tests, and ran the kernel's FSGSBASE selftests
> in a VM.
> 
> [*] https://lkml.kernel.org/r/20200928083047.3349-1-jiangshanlai@gmail.com
> 
> Lai Jiangshan (2):
>   KVM: x86: Intercept LA57 to inject #GP fault when it's reserved
>   KVM: x86: Let the guest own CR4.FSGSBASE
> 
> Sean Christopherson (3):
>   KVM: x86: Invoke vendor's vcpu_after_set_cpuid() after all common
>     updates
>   KVM: x86: Move call to update_exception_bitmap() into VMX code
>   KVM: VMX: Intercept guest reserved CR4 bits to inject #GP fault
> 
>  arch/x86/kvm/cpuid.c          |  6 +++---
>  arch/x86/kvm/kvm_cache_regs.h |  2 +-
>  arch/x86/kvm/vmx/vmx.c        | 18 +++++++++++++-----
>  3 files changed, 17 insertions(+), 9 deletions(-)
> 

Queued, thanks.

Paolo

