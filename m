Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1FD183FC2
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 04:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgCMDkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 23:40:10 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38193 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgCMDkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 23:40:10 -0400
Received: by mail-ot1-f67.google.com with SMTP id t28so6060819ott.5;
        Thu, 12 Mar 2020 20:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WIRkI2CYvoKsq9itPKuwu+XPusfRhrw6nx2JHGpkf1E=;
        b=s/kUJ8XE8j1XYaR6BBWpebhMtpPzhdQckJ3Ju30W08kJ2xQx9Cxz+Mco9AXgXuBrHC
         Waz4rIBxwEm3In3P7F0tM1c636ASFlUfrTQqmNEQEOlyWbj1GZq8pQnzofLnbuXCPzy3
         PyUfQ3gpDZxw0x7BDGGKY4kq6J3xJMkOC4aZ9FypuP4xnhCdibYeGVLaBURAT1EmJGcK
         1Q0q1q8spcrO01cZc1ZPTay39onJ3b2R8XHN8HYO7f5BJjbUDH/nBKnQT3FaleZzkC0y
         ztHqqF7TdsNuh+/iJLHEi1Mq6oAFDqtoTC4U1JNCOTG+UkFEU/Q46IBKrRdDwdINQZFT
         nsFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WIRkI2CYvoKsq9itPKuwu+XPusfRhrw6nx2JHGpkf1E=;
        b=ESGsxrYsYr0tvUxG+c8Y5r+v6rB3Q4g2TQca8u0i7hxj5M+SYaV9O1tl2fqNVWUNJK
         ffbLy3+4gEf2iBi6CU0/CJYRd56kmbauIytvYzi8bZT4t2RcTVuy8yAKEpM7XBHG43t9
         iIvBo7PFW8GljZ7xQTMI7sVjz9tKqQgANXTvUG4/UKMs6J9R2WPxpdHfeb+FKmCWog8v
         SmrpMYoWBU7I2Q+CktJ5q8xGNgflC8qeryPQbgoVRKkMjK1xb4UxxNZFXWQYwDNeMxQs
         5c1U3T0DmqKpdXYsRI3Y3qj88KHVt5v+pChHZxOGVCxrFjhe3O7NowYlrLYqmp47B+tQ
         Rx7A==
X-Gm-Message-State: ANhLgQ29FKA5/625A+gsG+Oi2VgzO6vrdsSPXZjb/t79XBRQS5ik3h2Y
        +R9bMzcrrBNAdFNp/gSM7Zeqq0qERqcZ2PSDcoLQhlzM
X-Google-Smtp-Source: ADFU+vt6hs8lhOGWw8jufq1I9KHJ+9mX0sD06x1fgIeR72ObclEhhEE5yw//2AdtH0SykZpfNjftQQmalg9itST0Y+A=
X-Received: by 2002:a9d:3a62:: with SMTP id j89mr2922525otc.45.1584070809078;
 Thu, 12 Mar 2020 20:40:09 -0700 (PDT)
MIME-Version: 1.0
References: <1584007547-4802-1-git-send-email-wanpengli@tencent.com>
 <87r1xxrhb0.fsf@vitty.brq.redhat.com> <CANRm+Cwawew=Xygxmzr2jmgPAKqDxvkqxxzjvoxnRRjC_Jx9Xw@mail.gmail.com>
 <79141339-3506-1fe4-2e69-8430f4c202bd@intel.com>
In-Reply-To: <79141339-3506-1fe4-2e69-8430f4c202bd@intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 13 Mar 2020 11:39:58 +0800
Message-ID: <CANRm+Cw-t2GXnHjOTPEV6BjwZPDZpwvK4QrUNz+AU21UL4rEww@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Micro-optimize vmexit time when not exposing PMU
To:     like.xu@intel.com
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
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

On Fri, 13 Mar 2020 at 11:23, Xu, Like <like.xu@intel.com> wrote:
>
> Hi Wanpeng,
>
> On 2020/3/12 19:05, Wanpeng Li wrote:
> > On Thu, 12 Mar 2020 at 18:36, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >> Wanpeng Li <kernellwp@gmail.com> writes:
> >>
> >>> From: Wanpeng Li <wanpengli@tencent.com>
> >>>
> >>> PMU is not exposed to guest by most of cloud providers since the bad performance
> >>> of PMU emulation and security concern. However, it calls perf_guest_switch_get_msrs()
> >>> and clear_atomic_switch_msr() unconditionally even if PMU is not exposed to the
> >>> guest before each vmentry.
> >>>
> >>> ~1.28% vmexit time reduced can be observed by kvm-unit-tests/vmexit.flat on my
> >>> SKX server.
> >>>
> >>> Before patch:
> >>> vmcall 1559
> >>>
> >>> After patch:
> >>> vmcall 1539
> >>>
> >>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> >>> ---
> >>>   arch/x86/kvm/vmx/vmx.c | 3 +++
> >>>   1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >>> index 40b1e61..fd526c8 100644
> >>> --- a/arch/x86/kvm/vmx/vmx.c
> >>> +++ b/arch/x86/kvm/vmx/vmx.c
> >>> @@ -6441,6 +6441,9 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
> >>>        int i, nr_msrs;
> >>>        struct perf_guest_switch_msr *msrs;
> >>>
> >>> +     if (!vcpu_to_pmu(&vmx->vcpu)->version)
> >>> +             return;
> >>> +
> >>>        msrs = perf_guest_get_msrs(&nr_msrs);
> >>>
> >>>        if (!msrs)
> >> Personally, I'd prefer this to be expressed as
> >>
> >> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >> index 40b1e6138cd5..ace92076c90f 100644
> >> --- a/arch/x86/kvm/vmx/vmx.c
> >> +++ b/arch/x86/kvm/vmx/vmx.c
> >> @@ -6567,7 +6567,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >>
> >>          pt_guest_enter(vmx);
> >>
> >> -       atomic_switch_perf_msrs(vmx);
> >> +       if (vcpu_to_pmu(&vmx->vcpu)->version)
> We may use 'vmx->vcpu.arch.pmu.version'.

Thanks for confirm this. Maybe this is better:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40b1e61..b20423c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6567,7 +6567,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)

        pt_guest_enter(vmx);

-       atomic_switch_perf_msrs(vmx);
+       if (vcpu_to_pmu(vcpu)->version)
+               atomic_switch_perf_msrs(vmx);
        atomic_switch_umwait_control_msr(vmx);

        if (enable_preemption_timer)

>
> I would vote in favor of adding the "unlikely (vmx->vcpu.arch.pmu.version)"
> check to the atomic_switch_perf_msrs(), which follows pt_guest_enter(vmx).

This is hotpath, let's save the cost of function call.

    Wanpeng

>
> >> +               atomic_switch_perf_msrs(vmx);
> >> +
> > I just hope the beautiful codes before, I testing this version before
> > sending out the patch, ~30 cycles can be saved which means that ~2%
> > vmexit time, will update in next version. Let's wait Paolo for other
> > opinions below.
>
> You may factor the cost of the "pmu-> version check' itself (~10 cycles)
> into your overall 'micro-optimize' revenue.
>
> Thanks,
> Like Xu
> >
> >      Wanpeng
> >
> >> Also, (not knowing much about PMU), is
> >> "vcpu_to_pmu(&vmx->vcpu)->version" check correct?
> >>
> >> E.g. in intel_is_valid_msr() correct for Intel PMU or is it stated
> >> somewhere that it is generic rule?
> >>
> >> Also, speaking about cloud providers and the 'micro' nature of this
> >> optimization, would it rather make sense to introduce a static branch
> >> (the policy to disable vPMU is likely to be host wide, right)?
> >>
> >> --
> >> Vitaly
> >>
>
