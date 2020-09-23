Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A44275E6A
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 19:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIWRPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 13:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWRPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 13:15:24 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC42EC0613CE
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 10:15:24 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id n2so671949oij.1
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 10:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aSM6VNxIk/hW9b7HWRMM8Fz1NvuMmVL13BGTLFDNXLg=;
        b=Eqpxfmr1+HzFZcPMoUomkh+DeAjajz3940PD1iEWFN/1p2M3ZSerxdCGjjJS97NM0J
         QiJXDQgMt1SNiUQEaO7MvKJhD71RCVQKMlrBbER7F4Vi5kC7lVfjyQLZ1oi+ZQS00k21
         w7Nu6e+h+1Jtdfwz3Q5g1uZsa5oTyWofxMG+IKWC9i5ninl4+T70bsc6ELLLzbemG2ar
         gYBTdt8q9wO6CEwiSkVyO+zrWze9RCkI7/hzu8MC+wyAF3U2IBCX1UcT1jP1mBHhmGKh
         5ANRuFXXR/s1xoQWJakyGokWzYScnwOSyhSC0yAEQm+ebqilVjwnQzTiLoT7sV25iGkQ
         wX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aSM6VNxIk/hW9b7HWRMM8Fz1NvuMmVL13BGTLFDNXLg=;
        b=lGoaL+yR4zQcvFehJB8jz9BQtAnG0JHHvNrqCd/njkoYnmcCiJLsXGuowIj0ccWy+1
         Dkyqg1lTODrJDFZPwoPTs1A7lgP1N4ZMjCiluyETXfiqN6NZuyX25q047X9Ru04ZC1XC
         o1P5VWAFUoL2+YulqM37lmJiQaTua0tO5LtNgmF8Ohapq7NISVduPd+zsnsewx/ymUuN
         OZ+xfnC6IzH5xJfSUfto6FC4A5REvap5JCQiC++T494AuBedtR/D5GQiHJxOcPLSa1+U
         7E+1U66qOH3ymS9ZGTpwSzPpXso1dWh5p17EPsY+gdHD4Kg8WWh1QZ70ov33lrqb3K4I
         UPWw==
X-Gm-Message-State: AOAM533g6W5uqMUXSw+L2bahOwcdEWt0VpWnivPqY2jaoF5xtE9eyQn2
        X3njGkYsHiFf6r1Ee7uGzfEdthn1l8qeXi6pfSD5Tg==
X-Google-Smtp-Source: ABdhPJy1AKrZZ8Zfv0p6tedm40ARQ3FcaZOrgSEDcfYLTKpDv2MU6nbD47crkAbYYy5lGoBSQQg9neiZTt3rRtERhgU=
X-Received: by 2002:aca:4a4d:: with SMTP id x74mr317522oia.6.1600881323905;
 Wed, 23 Sep 2020 10:15:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200923165048.20486-1-sean.j.christopherson@intel.com> <20200923165048.20486-3-sean.j.christopherson@intel.com>
In-Reply-To: <20200923165048.20486-3-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 23 Sep 2020 10:15:11 -0700
Message-ID: <CALMp9eTPG14Mwd_NcMf-f86U5GyfcOAVHk=ugydyJj0PybiRMA@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: VMX: Unconditionally clear CPUID.INVPCID if !CPUID.PCID
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 9:51 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> If PCID is not exposed to the guest, clear INVPCID in the guest's CPUID
> even if the VMCS INVPCID enable is not supported.  This will allow
> consolidating the secondary execution control adjustment code without
> having to special case INVPCID.
>
> Technically, this fixes a bug where !CPUID.PCID && CPUID.INVCPID would
> result in unexpected guest behavior (#UD instead of #GP/#PF), but KVM
> doesn't support exposing INVPCID if it's not supported in the VMCS, i.e.
> such a config is broken/bogus no matter what.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cfed29329e4f..57e48c5a1e91 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4149,16 +4149,22 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>                 }
>         }
>
> +       /*
> +        * Expose INVPCID if and only if PCID is also exposed to the guest.
> +        * INVPCID takes a #UD when it's disabled in the VMCS, but a #GP or #PF
> +        * if CR4.PCIDE=0.  Enumerating CPUID.INVPCID=1 would lead to incorrect
> +        * behavior from the guest perspective (it would expect #GP or #PF).
> +        */
> +       if (!guest_cpuid_has(vcpu, X86_FEATURE_PCID))
> +               guest_cpuid_clear(vcpu, X86_FEATURE_INVPCID);
> +

I thought the general rule for userspace provided CPUID bits was that
kvm only made any adjustments necessary to prevent bad things from
happening at the host level. Proper guest semantics are entirely the
responsibility of userspace. Or did I misunderstand?
