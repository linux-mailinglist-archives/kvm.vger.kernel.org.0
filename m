Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C2C292AE4
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 17:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgJSPwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 11:52:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730051AbgJSPwf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 11:52:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603122754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XC8R3HHY11M/hrrbkifbLXLUcYHIAgrXDf8csH9a4/c=;
        b=CPOf9f2G5vkY4dJMi+6voPoT4RxrqloMfa1gHJ1HPLCwHg/7aEIrJZzMfcQBwmuHlzjuAj
        u4CmKbiJVV92OhYmbboePVp21nxLTb7jEgEmBXHVhPYnDvkQRXrSJ8BWugMSPQI8fJMKca
        r1g0zZ1ZRtqYAxzqIGBLSJL1/f8zUWo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-fXHy414SNwmcVtCxwchmGQ-1; Mon, 19 Oct 2020 11:52:30 -0400
X-MC-Unique: fXHy414SNwmcVtCxwchmGQ-1
Received: by mail-wr1-f71.google.com with SMTP id t3so52868wrq.2
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 08:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XC8R3HHY11M/hrrbkifbLXLUcYHIAgrXDf8csH9a4/c=;
        b=msK3GkWjjT2xI+t/wadCDACfEOEx6ud6CZnT30DjOaaBoc12B9LRrrSCrixJOD3sfe
         0GDRa2cpjJajxzmGgFW8+e7hR/PGXb2Lrx2Ry7OTZH11PIRAbGiGtXLftZFJHfeQ0aDS
         e/9okqLD3XzxENSFMNfaJ7FEuE3Vi3hbmsCTBOuJQnR8nx/KcBcJQUHMS/sdzN7pMokP
         f6wNRX8IzWQE4Yjaj5PEHe4I0f9s6D4Q5+tky6fGvCtQ5j9DQnAosGIVJ69pRhKkvE3q
         UuTaeYPKBLr7ykiG9y0NjEE6+aXkGJBU1s/2C+xPpFA+TZ0pss3MnOHsPt7GZtZRYiLX
         W6Pg==
X-Gm-Message-State: AOAM531vMtf7CArL7sYzQH/73a454t4rxhWcm1abJxlENTbri6yj+XEH
        uBV98fXem1DCZdwii+lnk1uXK3qqMdW3OC0NjHwoI2/zYGDkzlFKCR4fUjX0NFz6y/lIy1ioIlo
        YugT/GghVGLuI
X-Received: by 2002:a1c:2108:: with SMTP id h8mr26420wmh.63.1603122749204;
        Mon, 19 Oct 2020 08:52:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2AwSIV8crVhtGFxc2jh3WIKCAGDXH1rOOylH1uDp8JeVmB4VsCq9Uxr0spo00NdxsC9Mtcw==
X-Received: by 2002:a1c:2108:: with SMTP id h8mr26394wmh.63.1603122748931;
        Mon, 19 Oct 2020 08:52:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t10sm455946wmf.46.2020.10.19.08.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 08:52:28 -0700 (PDT)
Subject: Re: [PATCH v7 0/4] KVM: nSVM: ondemand nested state allocation
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20201001112954.6258-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2c7ad393-9a7e-359e-a076-0d9ed702fe23@redhat.com>
Date:   Mon, 19 Oct 2020 17:52:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201001112954.6258-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/20 13:29, Maxim Levitsky wrote:
> This is the next version of this patch series.
> 
> In V5 I adopted Sean Christopherson's suggestion to make .set_efer return
> a negative error (-ENOMEM in this case) which in most cases in kvm
> propagates to the userspace.
> 
> I noticed though that wrmsr emulation code doesn't do this and instead
> it injects #GP to the guest on _any_ error.
> 
> So I fixed the wrmsr code to behave in a similar way to the rest
> of the kvm code.
> (#GP only on a positive error value, and forward the negative error to
> the userspace)
> 
> I had to adjust one wrmsr handler (xen_hvm_config) to stop it from returning
> negative values	so that new WRMSR emulation behavior doesn't break it.
> This patch was only compile tested.
> 
> The memory allocation failure was tested by always returning -ENOMEM
> from svm_allocate_nested.
> 
> The nested allocation itself was tested by countless attempts to run
> nested guests, do nested migration on both my AMD and Intel machines.
> I wasn't able to break it.
> 
> Changes from V5: addressed Sean Christopherson's review feedback.
> Changes from V6: rebased the code on latest kvm/queue
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (4):
>   KVM: x86: xen_hvm_config: cleanup return values
>   KVM: x86: report negative values from wrmsr emulation to userspace
>   KVM: x86: allow kvm_x86_ops.set_efer to return an error value
>   KVM: nSVM: implement on demand allocation of the nested state
> 
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/emulate.c          |  4 +--
>  arch/x86/kvm/svm/nested.c       | 42 ++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c          | 64 ++++++++++++++++++---------------
>  arch/x86/kvm/svm/svm.h          | 10 +++++-
>  arch/x86/kvm/vmx/vmx.c          |  6 ++--
>  arch/x86/kvm/x86.c              | 39 ++++++++++----------
>  7 files changed, 114 insertions(+), 53 deletions(-)
> 

Queued, thanks.

Paolo

