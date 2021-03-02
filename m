Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152DE32B5BA
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449259AbhCCHTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1839797AbhCBToU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:44:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614714166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HPMC22GbUg3ZONkj89cKsu7qkPMKOaKG8LetMaPE1Yc=;
        b=ACvzrdbk88LTGKKB6Kjv+5m4Uyj7wjxYvuSgsqOD3WQktdodl+6jNJaq6UMFjY7bEk6Iam
        KD7+BrsCALrdPrp4WThcJVa1yUJZArzK66oiCyjU3xnzPPJy8nnbTQ1Xxri3DmzLb9s/h/
        9ARDX3AZnaUJpJZfphtzxp290OEZSuA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-Rd1d6cpZPFCtRPHmaq_g7w-1; Tue, 02 Mar 2021 14:42:45 -0500
X-MC-Unique: Rd1d6cpZPFCtRPHmaq_g7w-1
Received: by mail-wm1-f72.google.com with SMTP id v5so1690109wml.9
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 11:42:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HPMC22GbUg3ZONkj89cKsu7qkPMKOaKG8LetMaPE1Yc=;
        b=dAwhMrftScQIkIRByxKaqZIXFOHj9o28Ay12TmsZ7aXFv/NwyQofJ9Tm9Ta2EabwP2
         s2q+d6zehvRZ0AXAXyvIb5KvFnAsTnNdE4NWnf2k3kb2Wy67ACnPWJrjhdtE0ZG3jiS+
         Wn/c/LpyEHC41I3hUN6tQjAPHrv15fNBswU03wWIlfUcY9MlBnk4BDQW428HLCAeuTKH
         o24IDjX6q1u83JHNXAW+kCm4c61LbQCU9naFPDfQgqziZdVwaC15PQl9HlIcigtPwcLa
         9tS/BAcKabMMVecIBWztrHslAuo7zRzjuFSSrI3XoIzzeMJcvFfHn2GbJc0z1BVyMzDa
         ycyA==
X-Gm-Message-State: AOAM5320N0VNp1lUwwoxA16+HUPaP5mvZsXUUmjna6UYyxkkaGmMZRzH
        lFK8mYF/HfmpJXEqGIibQjHHuuSp63QscaSP4bUzq1NpONBVgAPhfye/QqDb1qTS7mOOtDYhK6Q
        SpNPHVcLzvHzE
X-Received: by 2002:a05:600c:358d:: with SMTP id p13mr5669407wmq.152.1614714163569;
        Tue, 02 Mar 2021 11:42:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxr2O7v4+v2xNtUKu4ghCl09WbXpteX+EqtDzUfD203Js//prK+rD2FyqDL0qAoqSEplVFfwQ==
X-Received: by 2002:a05:600c:358d:: with SMTP id p13mr5669403wmq.152.1614714163399;
        Tue, 02 Mar 2021 11:42:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c9sm3585690wmb.33.2021.03.02.11.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 11:42:42 -0800 (PST)
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
Message-ID: <2390f11d-892c-11d3-b71b-3dee531152d9@redhat.com>
Date:   Tue, 2 Mar 2021 20:42:42 +0100
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
> 
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

Queued, thanks.

Paolo

