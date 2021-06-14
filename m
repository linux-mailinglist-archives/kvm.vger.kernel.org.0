Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFC53A67D5
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhFNNaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbhFNNay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 09:30:54 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12BDC061766
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 06:28:40 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id r16so20155478ljk.9
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 06:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q5Z/aRJGZDJZL2EoNoPXOS7QUgj78LrAb9XaHxJadEA=;
        b=JiV08GosC2hu0mBkUDRXU/N884IpJJ34SBN+GRNPcDZ65ZIK3IlpEE+snOmDGdRceK
         tudF5VzHPI6svSmHaten143+9jq6T8AneF3vjk5jm6TokSrvzJRR+eF6OJpOVQBUvYT1
         9ZgGKOXkazUUV9TzXB6CrvcL9grdWhXTsvpH4wnjEsjBtT1E651Zg5KBC1IQQ5ONl8FY
         +qfgCELQ+ZU3YQy0jhDIBvIyerCR4IcHkRsx2vXw06ZDq4fS+xn+SMx1DMdeoVaJIi7J
         8CJfkJm5Dz4CksAOqr8NLGYnhhvejzLauWaVYAnUm9fzIR3Y3DWTdYjtDKVoKSP7oYdf
         Httg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q5Z/aRJGZDJZL2EoNoPXOS7QUgj78LrAb9XaHxJadEA=;
        b=JQCtCvsBmgorplCC+QGU/Lt4nTVioYgEwazgWjOBbJ2DclJouVnVQee+8QLyPtUBNk
         h3IxQj5P65wx8Xsfi1Da7BTjUhQjUcOOmsQU3M46qqoC321/LzC7Znk88SiWl02vXpJi
         1DbPD73Ekvsy1Z1YlzeklURCDbGz0Phe61aiw9RfAgfAm2IVtbl9G8uJ9rXl1DZIdz2u
         WsLJR6tmOSiNLqLm5Vvo01KDlcnGwE3eMQJbd1mu0TF1Wp+GEtqqScUOL2PkLLoSZKD1
         ovNFs5nYNjzJLHDPf0QX3QlpsowqCBY0O1FB+mep6Kvjl9T/hv8LUnmKwXZDSBuIC6JD
         qNNA==
X-Gm-Message-State: AOAM532MDYIL9qljp37JF8qb+/tFyAKKwmJz3H8V+JupHTejh97oubsE
        xUb22mA3OB3Wo5he64iB9t788WEBY/8e+/oXfKp1/A==
X-Google-Smtp-Source: ABdhPJzkTobUBO7OfrBdhTzHUcheq0UTf5Nx2DXYGm1qPTWlKyDMAcFAsG0mMq2AInD+nV0hjIJk0U4MuH67YXYy1fY=
X-Received: by 2002:a2e:8814:: with SMTP id x20mr13996006ljh.394.1623677318799;
 Mon, 14 Jun 2021 06:28:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210614025351.365284-1-jingzhangos@google.com>
 <20210614025351.365284-2-jingzhangos@google.com> <CA+EHjTybUkOVVByL5r_MwLfzc_aaPybY8AzdCLYmS8aiR-RkSA@mail.gmail.com>
In-Reply-To: <CA+EHjTybUkOVVByL5r_MwLfzc_aaPybY8AzdCLYmS8aiR-RkSA@mail.gmail.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 14 Jun 2021 08:28:26 -0500
Message-ID: <CAAdAUthx2Hpqx6nLg8JeAO5XwVyBL7Dr6Et244LDUv1=99NgrQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: stats: Make sure no missing or mismatched binary
 stats definition
To:     Fuad Tabba <tabba@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Fuad,

On Mon, Jun 14, 2021 at 4:50 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Jing,
>
> On Mon, Jun 14, 2021 at 3:53 AM Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Add static check to make sure the number of stats descriptors equals
> > the number of stats defined in vm/vcpu stats structures.
> > Add offset field in stats descriptor to let us define stats
> > descriptors freely, don't have to be in the same order as
> > stats in vm/vcpu stats structures.
> > Also fix some missing/mismatched stats from previous patch.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
>
> I tested this for arm64, and it does assert if there's a mismatch. I
> couldn't find any missing statistics under any of the architectures
> either.
>
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 5e77f32abef5..692af9177c9f 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1296,119 +1296,152 @@ struct _kvm_stats_desc {
> >         { n, offsetof(struct kvm_vcpu, stat.generic.x),                        \
> >           KVM_STAT_VCPU, ## __VA_ARGS__ }
> >
> > -#define STATS_DESC(stat, type, unit, base, exp)                               \
> > +#define STATS_DESC_COMMON(type, unit, base, exp)                              \
> > +       .flags = type | unit | base |                                          \
> > +           BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |                   \
> > +           BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |                   \
> > +           BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),                    \
> > +       .exponent = exp,                                                       \
> > +       .size = 1
> > +
>
> nit: you seem to be mixing tabs and spaces here
>
> > +#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp)                    \
> >         {                                                                      \
> >                 {                                                              \
> > -                       .flags = type | unit | base |                          \
> > -                           BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |   \
> > -                           BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |   \
> > -                           BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),    \
> > -                       .exponent = exp,                                       \
> > -                       .size = 1                                              \
> > +                       STATS_DESC_COMMON(type, unit, base, exp),              \
> > +                       .offset = offsetof(struct kvm_vm_stat, generic.stat)   \
> >                 },                                                             \
> > -               .name = stat,                                                  \
> > +               .name = #stat,                                                 \
> >         }
>
> nit: also here, mixing of tabs and spaces
>
> Tested-by: Fuad Tabba <tabba@google.com> #arm64
> Reviewed-by: Fuad Tabba <tabba@google.com>
>
> Thanks,
> /fuad
Thanks for the review and testing!

Jing
