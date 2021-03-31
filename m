Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B493502FA
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 17:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbhCaPJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 11:09:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236243AbhCaPIr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 11:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617203327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A/QE8tuUwF3/9UG7nfFS4bNTclmFVRAAjghkmKZ6ca4=;
        b=dRrW3mY1K6e85LI7eazhut3zD6ZnAwK4ucPfQ46ueeUfvanSCAT+xnV/ZttGZWXKLHgc8M
        NUc+NtiY4VmNWdRohp5SUUT2B9psOiM5FKAwELrP9ndZyJ3rnsdOUVfCV5n3L7rDUkr6uZ
        9/MPRu6c13VK4XTc2QQWxH1Ld8irZI4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-svsYUALJOc6ScCXupnzv7g-1; Wed, 31 Mar 2021 11:08:44 -0400
X-MC-Unique: svsYUALJOc6ScCXupnzv7g-1
Received: by mail-wr1-f71.google.com with SMTP id x9so1149709wro.9
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 08:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A/QE8tuUwF3/9UG7nfFS4bNTclmFVRAAjghkmKZ6ca4=;
        b=nl+cDynayVvf/SnJKjvdZRm6oRO8eZyR7hf+o7o++NGo4IGLBCbrqbytb7OOnzpT70
         xJerx7IN215hr9vF2T74MeW1raCGfbq54TKXfNOjNEhZTZU6CWDOF5hZk0cCBMS75Grn
         FpimYTx/tk4zRnBvwvt2y8qfNRaaabtcTSukust6a7Dp6HbaycMQoTjkCu/t0ZVTxznl
         T+mkLe/YJ5MnVPQLr2KmLmRxvwmovKxvUcRQiw6kEUMz6m+bJflk1Eh2YOUgJ75NPEMG
         rXNsY/iqJyWcpQPHbTdpmGIaENeQUJvw6QMbPQiEYOU+woSeOhodhpSiDnvkwuHpIIMu
         2kCg==
X-Gm-Message-State: AOAM530iboxj4tjjRNrcz9XPgf7DbKqLjF2ZwIMQkgNGUmFluSABr2aC
        NdDntwbOZ1IUEH92mcYFYK++VR/Qp+lXr5sIPxdLX5cdyTuXtpK1QrZbAbmyB006ESWrYy4SJHE
        O2AOeZwVYOmIz
X-Received: by 2002:adf:d1c5:: with SMTP id b5mr4239835wrd.126.1617203323551;
        Wed, 31 Mar 2021 08:08:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBkZdQOSyP0wfJpEJ/0RVQ91TnwGDMX5iv06fUFsp5bXFQ/A/sgCOP8epfRCPLQhWJUgT55Q==
X-Received: by 2002:adf:d1c5:: with SMTP id b5mr4239816wrd.126.1617203323381;
        Wed, 31 Mar 2021 08:08:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h25sm5837358wml.32.2021.03.31.08.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 08:08:42 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] KVM: x86: hyper-v: Fix TSC page update after
 KVM_SET_CLOCK(0) call
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210331124130.337992-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dd1b6f3e-273a-8162-9937-428ae2237254@redhat.com>
Date:   Wed, 31 Mar 2021 17:08:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210331124130.337992-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 14:41, Vitaly Kuznetsov wrote:
> Changes since v2:
> - Fix the issue by using master_kernel_ns/get_kvmclock_base_ns() instead of
>   get_kvmclock_ns() when handling KVM_SET_CLOCK.
> - Rebase on Paolo's "KVM: x86: fix lockdep splat due to Xen runstate
>   update" series and use spin_lock_irq()/spin_unlock_irq() [Paolo]
> 
> Original description:
> 
> I discovered that after KVM_SET_CLOCK(0) TSC page value in the guest can
> go through the roof and apparently we have a signedness issue when the
> update is performed. Fix the issue and add a selftest.
> 
> Vitaly Kuznetsov (2):
>    KVM: x86: Prevent 'hv_clock->system_time' from going negative in
>      kvm_guest_time_update()
>    selftests: kvm: Check that TSC page value is small after
>      KVM_SET_CLOCK(0)
> 
>   arch/x86/kvm/x86.c                            | 19 +++++++++++++++++--
>   .../selftests/kvm/x86_64/hyperv_clock.c       | 13 +++++++++++--
>   2 files changed, 28 insertions(+), 4 deletions(-)
> 

Queued, thanks.

Paolo

