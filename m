Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC6C462BFE
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 06:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238299AbhK3FZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 00:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhK3FZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 00:25:33 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8D6C061574
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 21:22:15 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s137so18525922pgs.5
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 21:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nMzdk7WdQ8L/HP0hzBLAG2QVUEAIjcUDryoTsnqwXLE=;
        b=j1EfdfUnVBej9nEQbRyBAto+p5BeBeWJB5e/BtcbuTktC5IOpismY9XzOhyKnFuW/G
         CwvztOqzmum15yJxT13kcTqhT4ia1tLNBmSMKuLRFCozTTrtMODetJAZBtw+fnBP/b6X
         NM3yo9jBcjgrtJoUeGv3TlE5GFjizOtXpkzwoEm98Gj6HKnENHmF7KxuU4TVJyTilia9
         H4VcjlkC3x0I4qAjgwJ09Ayiww35c8Lz+oYzSbOyoNwxUq/OePB2UrK7AZG3noeDAdQt
         1Rv0PbBAxE3NYTCCmtu6qmPeM5Uj+MJ/yzYYDwmiJe8D86fuXEOFKiGn+B+r/T3XwULn
         daww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nMzdk7WdQ8L/HP0hzBLAG2QVUEAIjcUDryoTsnqwXLE=;
        b=wDoMUw3z6ikhojxx0gB9c0Q9yuAFOmEURseoj3W70+C/6Nbl5fkOqUhp2xjueqZDUp
         T2573xbvy/hAGblNnNTCgUHqsLoQVLpSg7GQCE16bk82l6fTezDJSnaNriSJtdm7Clw2
         OEfKJBzjpAtEDtbm4SKok4lfzl3PHll0U1OgVjKbEJdDrYy2/H2DeTBVHnjmgQolazrx
         n4d0j/pyt7N5R+cTIkIJIDiPnkBMaUN/7Sq0NjNmkPriyCeXyq8on6yWF7MxfWQfp3gA
         Iycc4eigz5RrDNMFp1sa1B2vnRL39CRWSrecvNGIbJfHwSc32KWeDJZoFij1YgH/mXvl
         qyaA==
X-Gm-Message-State: AOAM533V1OAnoL+zFdAOntlImde1+BlYURA7v5tNyVFLiiaX1U9Lck/T
        kartJIsEvxV0z83FdQvf8vdFolRxKecSOQi6Si+5zw==
X-Google-Smtp-Source: ABdhPJxWZ/PB1tDWrTWrdQnIfBdcsVY7+Ir97BsmQlGLYsjIg2R5RFwEdXK4R9zRLS/FQk9SU8UmlTgMNk2bjt6aIMI=
X-Received: by 2002:aa7:9d9e:0:b0:4a0:25d0:a06f with SMTP id
 f30-20020aa79d9e000000b004a025d0a06fmr45090946pfq.82.1638249734570; Mon, 29
 Nov 2021 21:22:14 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-11-reijiw@google.com>
 <bb557b85-8d28-486e-d22c-b3021888bcf8@redhat.com>
In-Reply-To: <bb557b85-8d28-486e-d22c-b3021888bcf8@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 29 Nov 2021 21:21:58 -0800
Message-ID: <CAAeT=FwBpc0Ue=rUiCaL=7p7e_SmKPLG=74EK+GZN4kftdJJtA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 10/29] KVM: arm64: Make ID_AA64DFR0_EL1 writable
To:     Eric Auger <eauger@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > This patch adds id_reg_info for ID_AA64DFR0_EL1 to make it writable
> > by userspace.
> >
> > Return an error if userspace tries to set PMUVER field of the
> > register to a value that conflicts with the PMU configuration.
> >
> > Since number of context-aware breakpoints must be no more than number
> > of supported breakpoints according to Arm ARM, return an error
> > if userspace tries to set CTX_CMPS field to such value.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 84 ++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 73 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 772e3d3067b2..0faf458b0efb 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -626,6 +626,45 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
> >       return 0;
> >  }
> >
> > +static bool id_reg_has_pmu(u64 val, u64 shift, unsigned int min)
> I would rename the function as the name currently is misleading. The
> function validate the val filed @shift againt @min

Thank you for the comment.

The @min is the minimum value that indicates PMUv3 support.
So, if the field value is >= @min, it means PMUv3 is supported.
I want the function to check whether or not @val indicates PMUv3 support,
and that's how the function is used.
I can see what you meant focusing on the function though.
But, if we renaming it to xxx_validate, that would be misleading in the
codes that use the function.

> > +{
> > +     unsigned int pmu = cpuid_feature_extract_unsigned_field(val, shift);
> > +
> > +     /*
> > +      * Treat IMPLEMENTATION DEFINED functionality as unimplemented for
> > +      * ID_AA64DFR0_EL1.PMUVer/ID_DFR0_EL1.PerfMon.
> > +      */
> > +     if (pmu == 0xf)
> > +             pmu = 0;
> Shouldn't we simply forbid the userspace to set 0xF?

This function is to check whether or not the field value indicates PMUv3.
Setting the field to 0xf is forbidden by arm64_check_features().
Having said that, since arm64_check_features() will be implemented by
using arm64_ftr_bits, which treats AA64DFR0.PMUVER and DFR0.PERFMON
as signed fields.
So, it will be forbidden in a different way in the next version.

Thanks,
Reiji

> > +
> > +     return (pmu >= min);
> > +}
