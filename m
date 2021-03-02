Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E24532B571
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356149AbhCCHQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:16:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351910AbhCBRug (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 12:50:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614707349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YeyLYdmnE3JDn8ZEyTkh3s1uDKDvfkDsTKUO5iOf6eg=;
        b=V+GXTtE+uiaYJR4Af7yplqHt53Uj90zwue7JiBaKSY69RpgN4LIioihmIS4oN2wuLwGhFb
        1ctuzPPFNqOohtL2sUmBJWenYOiNnK7UgX6Jb5jSxPRoREisdR9lIrMGorS8kfEnIzAc8s
        rTteJcoLvMtNF2eASpEgmnm58iTU5p0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-pn70BmD8OiewiQqZJ_vWdA-1; Tue, 02 Mar 2021 12:49:08 -0500
X-MC-Unique: pn70BmD8OiewiQqZJ_vWdA-1
Received: by mail-ej1-f71.google.com with SMTP id p15so800386eju.3
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 09:49:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YeyLYdmnE3JDn8ZEyTkh3s1uDKDvfkDsTKUO5iOf6eg=;
        b=WOTv1MLxPnQbLQsFtDvhHCwWKWU4vFC0/NV1yWllsAXejUkB9MafbqexDylpgLhjM2
         G3Zr6cgElLlvcR0wZR0QWVYSlSOSe8Q0mJVhWhCo1skHUZhQxOJ5jCswhDWANyx+PrM7
         48Et4WPLXFL47y3Wg+GUAM8IzwYfCV+4hZoSQjAww3tAQdxP552fmBackA6dCUvVFgDZ
         tKA6BEAS1xLAbMglKljCjTUFAmL8ePjgdcI5XHq8336isw0cnRCIXCSRCt2FuM9s4m7x
         +Dp0PoJIu0WoSzGo46jHWM8w3b68IXKUj71rbd8N0GLvRnaQBrYy/eGYCwsdSrCYLFy2
         liuA==
X-Gm-Message-State: AOAM532LJwdrjPQjMylelvGBGlrG6P2cKYE02TV+pU1hhZ/c6Ur9Qfbq
        vPdHqEqUYTSm4gDK/wP9q6gPvuzaIXo8MkewFdHAZcODQnp2Nvz+94z2F0d9+mTuqdm+K5vGzOA
        L47OFi/Ilwn3T
X-Received: by 2002:a17:906:c08f:: with SMTP id f15mr4644883ejz.318.1614707346463;
        Tue, 02 Mar 2021 09:49:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzws/iVtEFy1xQdjyKJaPsRc/sxSq1neOORF52GduQNh/r2LVe8eB5ZCyelpN0H5aDUVYbS5A==
X-Received: by 2002:a17:906:c08f:: with SMTP id f15mr4644865ejz.318.1614707346310;
        Tue, 02 Mar 2021 09:49:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m10sm578988ejx.10.2021.03.02.09.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 09:49:05 -0800 (PST)
Subject: Re: [PATCH 0/2] KVM: x86: Emulate L2 triple fault without killing L1
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20210302174515.2812275-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <04aa253c-9708-d707-3ee9-7595da4029ad@redhat.com>
Date:   Tue, 2 Mar 2021 18:49:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210302174515.2812275-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/21 18:45, Sean Christopherson wrote:
> If KVM (L0) intercepts #GP, but L1 does not, then L2 can kill L1 by
> triggering triple fault.  On both VMX and SVM, if the CPU hits a fault
> while vectoring an injected #DF (or I supposed any #DF), any intercept
> from the hypervisor takes priority over triple fault.  #PF is unlikely to
> be intercepted by L0 but not L1.  The bigger problem is #GP, which is
> intercepted on both VMX and SVM if enable_vmware_backdoor=1, and is also
> now intercepted for the lovely VMRUN/VMLOAD/VMSAVE errata.
> 
> Based on kvm/queue, commit fe5f0041c026 ("KVM/SVM: Move vmenter.S exception
> fixups out of line").  x86.c and svm/nested.c conflict with kvm/master.
> They are minor and straighforward, but let me know if you want me to post
> a version based on kvm/master for easier inclusion into 5.12.

I think it would be too intrusive.  Let's stick this in 5.13 only.

Paolo

> Sean Christopherson (2):
>    KVM: x86: Handle triple fault in L2 without killing L1
>    KVM: nSVM: Add helper to synthesize nested VM-Exit without collateral
> 
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/lapic.c            |  2 +-
>   arch/x86/kvm/svm/nested.c       | 57 ++++++++-------------------------
>   arch/x86/kvm/svm/svm.c          |  6 +---
>   arch/x86/kvm/svm/svm.h          |  9 ++++++
>   arch/x86/kvm/vmx/nested.c       |  9 ++++++
>   arch/x86/kvm/x86.c              | 29 +++++++++++++----
>   arch/x86/kvm/x86.h              |  2 ++
>   8 files changed, 60 insertions(+), 55 deletions(-)
> 

