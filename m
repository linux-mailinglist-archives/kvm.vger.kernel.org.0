Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393623E7FD0
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 19:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhHJRnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 13:43:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233075AbhHJRlI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 13:41:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628617244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JwFw0vQ/b0YrNjyPB8CLRbPWCk9k3NQcOgojHIc/fik=;
        b=RtrNn/G2PT/Ptcnv8YyZuVlbZvspzDoJuBKfr3eeGdrZ4CEBw5uwO2xuNtOdC2IRQwqutP
        FrWCfjXTEfzx5kLy0gZy+/ZLoOv6iuLfbmmX7kQIZ6AqSPyXh6GEh33aAL96AtmFB9rCBH
        2tJEHFyGd6o4rGrHBjIThtIdbqiyb0s=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-cv_122KJNMeSGJoqybWMYQ-1; Tue, 10 Aug 2021 13:40:43 -0400
X-MC-Unique: cv_122KJNMeSGJoqybWMYQ-1
Received: by mail-ej1-f71.google.com with SMTP id ne21-20020a1709077b95b029057eb61c6fdfso5880794ejc.22
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:40:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JwFw0vQ/b0YrNjyPB8CLRbPWCk9k3NQcOgojHIc/fik=;
        b=mNc9mCGGkTVKoRoz1dOhtyUvDeFwySoAlVWpLzRHqQzE29Nv6v2sQAI1cigo8isqyy
         n/ys9xk2+TMPL7uuQG7Op6fGhHlt6i/5E5BIK1qqxL0HqkR5LocDjq8kHzTlzo/blBxD
         trrgrokgy2G8csIrS78zSm3Ec29Xn6yUpJZGeza1kIQxlTM66eMRwb56L/D6qBc3rxaP
         LkU3vaiVwpayelCWN+hL8+SI95f26eszYIhHVrZA6X/+q2zh7SaMlJ+lKtVPGZK5X+9E
         U0/ueZvwbmqOkuDzKKdDESO2+mew44pHLRqtLWkzdZOSMcX61F5VscRKhw3DjTeuidwV
         LkXA==
X-Gm-Message-State: AOAM533MF/250+YhWTpdy0NF2Fe9ek5P5Cgp7pkSwZVKkujHrRL29kE2
        T1W2mqullhUXD1Odl8gNpr5fOC/1pkSPLr4E0TF6yQqO4Tng6U6MDAQXL1LUOBCrPwriVDOXiCK
        cbRpH46ky42qt
X-Received: by 2002:a05:6402:4d:: with SMTP id f13mr6282179edu.275.1628617242092;
        Tue, 10 Aug 2021 10:40:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvsP/2Cpzsl+zrd39MLw+z0LxH32zxL8FL2Q1YVhE5zvDuswGyYn1nUJpMgkIWmikWh933Kw==
X-Received: by 2002:a05:6402:4d:: with SMTP id f13mr6282156edu.275.1628617241946;
        Tue, 10 Aug 2021 10:40:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id f12sm7132598ejz.99.2021.08.10.10.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 10:40:41 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] KVM: x86: Purge __ex() and __kvm_spurious_fault()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>,
        Like Xu <like.xu.linux@gmail.com>
References: <20210809173955.1710866-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <43409f31-1462-d046-4a1d-ee016970b050@redhat.com>
Date:   Tue, 10 Aug 2021 19:40:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809173955.1710866-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/21 19:39, Sean Christopherson wrote:
> Two patches to remove __ex() and __kvm_spurious_fault(), and hide
> kvm_spurious_fault() in x86.h.  These were part of a larger series that
> received the magic "Queued, thanks", but got lost at some point.
> 
> v1: https://lore.kernel.org/kvm/20201231002702.2223707-1-seanjc@google.com/
> 
> Sean Christopherson (1):
>    KVM: x86: Kill off __ex() and __kvm_handle_fault_on_reboot()
> 
> Uros Bizjak (1):
>    KVM: x86: Move declaration of kvm_spurious_fault() to x86.h
> 
>   arch/x86/include/asm/kvm_host.h | 25 -------------------------
>   arch/x86/kvm/svm/sev.c          |  2 --
>   arch/x86/kvm/svm/svm.c          |  2 --
>   arch/x86/kvm/svm/svm_ops.h      |  2 +-
>   arch/x86/kvm/vmx/vmx_ops.h      |  4 +---
>   arch/x86/kvm/x86.c              |  9 ++++++++-
>   arch/x86/kvm/x86.h              |  2 ++
>   7 files changed, 12 insertions(+), 34 deletions(-)
> 

Queued, thanks.

Paolo

