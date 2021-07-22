Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CE43D26DC
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhGVPAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 11:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbhGVPAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 11:00:01 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456AFC061757
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 08:40:36 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 8so9140849lfp.9
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 08:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SEhg4S6nFbf1uARdrzetepOUBYKfp4wLBDEW5V4gz1U=;
        b=I6Qz/AO+KjpQSoLm6Jn7rg3CaUXlghY++G0hbFLOSjk+0Cc9XJWyJAQ7v+PY9JJpFB
         85R/hZTSRR9i32C7x+bcX8ISFZwUPP4W9wS4ujrwAEvdhwjaoq1P+quNjVx+w8zp5ySs
         be9kHeZO5LgHLEA0OQyFJ2Z5rsKEDkvkpottTo6p04ZmOOFFS8OJ7Efw7AhBoTKkFNx8
         TUcDFQSYETMc+JYGhxpwO22RJzIts8/P9Rzdf77do5y6S0FmekzCzLrLQbs6wMHAkBK/
         0oHgyGW3ulWIkm4uEI+3hZO6EjW0JjQYSaAz3rFmSvZbz0Zz+8M3FmhSHQ7nD/72QM6d
         hwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SEhg4S6nFbf1uARdrzetepOUBYKfp4wLBDEW5V4gz1U=;
        b=qxLcjc8hdgt3HZo7z06ei3xU7grYR2+4Zb0aFB8lcULMDe0a4oTJjwlfaIp9Lr6ly4
         f+dHJqtyZR3IUjoM1G3qOlt8Tl1BW4GvZJw9zlJEeTSwFp44YTPZy5ucOarTYLLi0TVd
         kCKvIb0OhlcWGuvTEOtpNpRuIpi9Ez6yzjXzW/OBmunQfe13OAFA3fumbEvGo5dfaj3T
         GY52n/arD1RUa0wWuOqAN887u6ZWvilssDgPXmmTDaqIvEcL4371FRJE+ThKYi+D5wpm
         BM9w/Wmd3FZ3QfQ85Dl7Ha+r0ZSU/D1wW+LG/3mI+3je1HMQIUgSX3bVE63ssBExKPZX
         ZOnw==
X-Gm-Message-State: AOAM531ipeRYBNstKy5KHxXHuVVG+tKbKuTdw7XerNNbE39gm57b/zjK
        nCErGeXdKyjhvT+0uuwL/Fr5KhBOByBa5DTZxJ+ulQ==
X-Google-Smtp-Source: ABdhPJyjSUljeQ3wSSF362Hy1Bm5k9CStnx+vKiFNi7rwUjNWcAyKjgIEnbXtpTwgTGSbX3NJPFAb/v2qBwjVN8dDiM=
X-Received: by 2002:a19:ae0f:: with SMTP id f15mr82349lfc.117.1626968434179;
 Thu, 22 Jul 2021 08:40:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210722123018.260035-1-vkuznets@redhat.com> <e2aa50650b118b877d4fc10cd832bd1c05271f8b.camel@redhat.com>
In-Reply-To: <e2aa50650b118b877d4fc10cd832bd1c05271f8b.camel@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 22 Jul 2021 08:40:23 -0700
Message-ID: <CAOQ_QsjeyyyKVaTWTWyLUBAJcnxJbzj1ULRPUP_0nxtmbwKsGQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Check the right feature bit for
 MSR_KVM_ASYNC_PF_ACK access
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 22, 2021 at 5:39 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Thu, 2021-07-22 at 14:30 +0200, Vitaly Kuznetsov wrote:
> > MSR_KVM_ASYNC_PF_ACK MSR is part of interrupt based asynchronous page fault
> > interface and not the original (deprecated) KVM_FEATURE_ASYNC_PF. This is
> > stated in Documentation/virt/kvm/msr.rst.
> >
> > Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index d715ae9f9108..88ff7a1af198 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3406,7 +3406,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >                       return 1;
> >               break;
> >       case MSR_KVM_ASYNC_PF_ACK:
> > -             if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
> > +             if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
> >                       return 1;
> >               if (data & 0x1) {
> >                       vcpu->arch.apf.pageready_pending = false;
> > @@ -3745,7 +3745,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >               msr_info->data = vcpu->arch.apf.msr_int_val;
> >               break;
> >       case MSR_KVM_ASYNC_PF_ACK:
> > -             if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
> > +             if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
> >                       return 1;
> >
> >               msr_info->data = 0;
>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>
> Best regards,
>         Maxim Levitsky
>

Reviewed-by: Oliver Upton <oupton@google.com>

--
Thanks,
Oliver
