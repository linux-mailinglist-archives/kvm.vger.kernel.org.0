Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2217182E90
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 12:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgCLLFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 07:05:16 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34799 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgCLLFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 07:05:16 -0400
Received: by mail-ot1-f65.google.com with SMTP id j16so5690508otl.1;
        Thu, 12 Mar 2020 04:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vkI0RXK18iMFD+WEkmTMFMAqnjMIY04/P2USA2vzg7s=;
        b=VWbRNmiXrUhSoWjcPvdsvoogYmTRVBGPlcW0p+JW72oCy2hHsPU3hNVm9Cqj7e5rV0
         tBYZ0zxb8RHLfJ+qGgNePquhY2HzMDs3lcVqbOv7xwgAaynlIh2Nwe8zifjB2XQj+OSj
         Hp1U09aXYZz68bKbbd55Xj7nzAxf5jdsTmMjV6BE07Dbql60VFcpmuhaiaJAGrLsghG5
         4DaA2E/jqvGxopkF6v/U1Ijxpbex+EqN9Z9ndWBIGsAzZZqbMJ2UFZf76atL3fbcXQe/
         5Rb2LjknNyjJr1vPm1KIeW2xeQFktNZsTVMf4ZKZV+1RLOKUqUc5H5xma1Q8Mm7yUo6U
         BQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vkI0RXK18iMFD+WEkmTMFMAqnjMIY04/P2USA2vzg7s=;
        b=qZR8i+YTDKyNoDvWyIPVuPfaJDqaPMHYFOWwuwlZ4AxN64wToIkPQh8j4Ly+sGSw+G
         f9QCYTHm1H/Km76q1QlFe1zA/KzPhfCzAxqKT7HBvhuVYZjGSt+hVhT/FePr6qxqVD3L
         ouQ7EgSeUvYfJ6k2UGowjQsJCzjU2XfB0Np9jdZouA8ohPdx1rjMTABBXCNVvqEHyj7g
         BgOd+TDR8fpO30olDAcyQbduFwNyIuoqS/wjpIMjIOKch33H/ka5x2CxrZl8cT+EBNwX
         muD/x5NuCLw9fSSOfDdGswhgzx3QUv5a+GTYqM2rK53MeFW+8FQDpxAWW8QTuZywsUae
         Z9Yw==
X-Gm-Message-State: ANhLgQ31uKLclYgmtBfFSCMQw8PgbLwPP4jJKFLyidDEWvtT/O6qt7ta
        vut68ocn6T9oZ+zQZhPxV9XCmYMIsY3XJRzNr08=
X-Google-Smtp-Source: ADFU+vs+hrrcSWTrzLxTCiitYF4rxcfeytEduyiZCTVaC7PythcnoFjNVmq4sQSy2HPulylqp4BysmAYOuRb1pHpGE0=
X-Received: by 2002:a9d:4c15:: with SMTP id l21mr6036345otf.185.1584011115612;
 Thu, 12 Mar 2020 04:05:15 -0700 (PDT)
MIME-Version: 1.0
References: <1584007547-4802-1-git-send-email-wanpengli@tencent.com> <87r1xxrhb0.fsf@vitty.brq.redhat.com>
In-Reply-To: <87r1xxrhb0.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 12 Mar 2020 19:05:04 +0800
Message-ID: <CANRm+Cwawew=Xygxmzr2jmgPAKqDxvkqxxzjvoxnRRjC_Jx9Xw@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Micro-optimize vmexit time when not exposing PMU
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Mar 2020 at 18:36, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > PMU is not exposed to guest by most of cloud providers since the bad performance
> > of PMU emulation and security concern. However, it calls perf_guest_switch_get_msrs()
> > and clear_atomic_switch_msr() unconditionally even if PMU is not exposed to the
> > guest before each vmentry.
> >
> > ~1.28% vmexit time reduced can be observed by kvm-unit-tests/vmexit.flat on my
> > SKX server.
> >
> > Before patch:
> > vmcall 1559
> >
> > After patch:
> > vmcall 1539
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 40b1e61..fd526c8 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6441,6 +6441,9 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
> >       int i, nr_msrs;
> >       struct perf_guest_switch_msr *msrs;
> >
> > +     if (!vcpu_to_pmu(&vmx->vcpu)->version)
> > +             return;
> > +
> >       msrs = perf_guest_get_msrs(&nr_msrs);
> >
> >       if (!msrs)
>
> Personally, I'd prefer this to be expressed as
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 40b1e6138cd5..ace92076c90f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6567,7 +6567,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>
>         pt_guest_enter(vmx);
>
> -       atomic_switch_perf_msrs(vmx);
> +       if (vcpu_to_pmu(&vmx->vcpu)->version)
> +               atomic_switch_perf_msrs(vmx);
> +

I just hope the beautiful codes before, I testing this version before
sending out the patch, ~30 cycles can be saved which means that ~2%
vmexit time, will update in next version. Let's wait Paolo for other
opinions below.

    Wanpeng

>
> Also, (not knowing much about PMU), is
> "vcpu_to_pmu(&vmx->vcpu)->version" check correct?
>
> E.g. in intel_is_valid_msr() correct for Intel PMU or is it stated
> somewhere that it is generic rule?
>
> Also, speaking about cloud providers and the 'micro' nature of this
> optimization, would it rather make sense to introduce a static branch
> (the policy to disable vPMU is likely to be host wide, right)?
>
> --
> Vitaly
>
