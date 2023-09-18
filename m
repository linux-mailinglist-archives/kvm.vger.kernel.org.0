Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D167A503E
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjIRRCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjIRRCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:02:38 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886BB9C
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:02:32 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-34fcc39fae1so3625ab.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695056552; x=1695661352; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UAIfwvZ+63Hgn0zk0yrYnb3ogYKWcNYJOySoDjwnNsI=;
        b=lGZ6+5Tv3bFq2sxiYKnEHQ27wAK0lSkPh+93NjFZPex139bJNe6jFLwJ5flfliF+/i
         HBx4VqaeEtFVR/BbTN7454JthT8OsjMVBGz0hCEaaXGte9ZGrjia/FnoIOTbIlHuSiwv
         eBJfqhsjOClMD5e+U4UBFCFbizdbi+PGgna/vuecfEYF3QkCINu42sdE6r+aDoqYxU/3
         cbM0b1VzVIigQxwzL4+1XcB8fw7VzH1Y6UXl3WCoHOWJ1EPKwJZuzPTK4W8Ctpa0j9gp
         0yyfTXx88pwlLT2y4c5Rr9Bh/0DU0XzromfHMNwhNkiHdnXWlVv158AyHgdmX6ddCC6x
         fQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056552; x=1695661352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UAIfwvZ+63Hgn0zk0yrYnb3ogYKWcNYJOySoDjwnNsI=;
        b=LOTHg3hP28cl6wnSEz4RTDbOJamzDmmP9Nplu9z9ZBD1Dmn8meeJNDE1SSh6tQFP3R
         Jrv6m5a40DKzsx2iASHh2l3QxyNBHYo5pr7aYgYoQO0gDzFIoQIggLFAkNprp1F0pI2k
         QX46L+aaTknbGKkZ6mYaTm2k6s+JNpQ4uM97w0VqjYEyuKQEHLB7r+/mPVT/D8xQ2cvo
         0aTPq0bM6dlvkh3wT8mwFY+UFhNDEsaiUyHjHS+YVRn1DVJCpRJj+S6b8N7tvYVh5sFc
         f2aJ8kAPkumcaNYjv1jUto0/NUNypadFzxx+KO9ElRKyN+s8eg5tNLcpnpIeUxIt3xOv
         H4aw==
X-Gm-Message-State: AOJu0Yy+UThVR6Ruv2KFSUcoTRpGZqyHcdWqXqM3fwCfKBkJ8ri0Peiu
        KerDnxJiFKo8X3TYfgt1L0GBcjMu2ieIX4u3jNwXfSaO3SGBQsdJoY4=
X-Google-Smtp-Source: AGHT+IGbG5HCAHrf21JXiJ2VopMjnmhcCdJ+ID6HHTdX+uCNc+yb9AJgBSzDPxGjHJugKAvODmx8+FJZW+RvRyCe3Kw=
X-Received: by 2002:a05:6e02:144e:b0:34c:acb5:11bd with SMTP id
 p14-20020a056e02144e00b0034cacb511bdmr598183ilo.16.1695056551832; Mon, 18 Sep
 2023 10:02:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-9-rananta@google.com>
 <6dc460d2-c7fb-e299-b0a3-55b43de31555@redhat.com> <CAJHc60whpvOHYCFueqh0Q=SbmmeRBG_x90QOvX+vOun73ttjPA@mail.gmail.com>
 <e479914b-7ba2-3a9a-2b07-9965532cbcfa@redhat.com> <ZQTAOcTsGPos/mBD@linux.dev>
In-Reply-To: <ZQTAOcTsGPos/mBD@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 18 Sep 2023 10:02:20 -0700
Message-ID: <CAJHc60zNaCOckeBdqfq1Ac8p7TTRFK6j7bMGMA49Twa763NTkA@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Shaoqin Huang <shahuang@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 15, 2023 at 1:36=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Tue, Aug 22, 2023 at 11:26:23AM +0800, Shaoqin Huang wrote:
>
> [...]
>
> > > > > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r,
> > > > > +                 u64 val)
> > > > > +{
> > > > > +     struct kvm *kvm =3D vcpu->kvm;
> > > > > +     u64 new_n, mutable_mask;
> > > > > +     int ret =3D 0;
> > > > > +
> > > > > +     new_n =3D FIELD_GET(ARMV8_PMU_PMCR_N, val);
> > > > > +
> > > > > +     mutex_lock(&kvm->arch.config_lock);
> > > > > +     if (unlikely(new_n !=3D kvm->arch.pmcr_n)) {
> > > > > +             /*
> > > > > +              * The vCPU can't have more counters than the PMU
> > > > > +              * hardware implements.
> > > > > +              */
> > > > > +             if (new_n <=3D kvm->arch.pmcr_n_limit)
> > > > > +                     kvm->arch.pmcr_n =3D new_n;
> > > > > +             else
> > > > > +                     ret =3D -EINVAL;
> > > > > +     }
> > > >
> > > > Since we have set the default value of pmcr_n, if we want to set a =
new
> > > > pmcr_n, shouldn't it be a different value?
> > > >
> > > > So how about change the checking to:
> > > >
> > > > if (likely(new_n <=3D kvm->arch.pmcr_n_limit)
> > > >          kvm->arch.pmcr_n =3D new_n;
> > > > else
> > > >          ret =3D -EINVAL;
> > > >
> > > > what do you think?
> > > >
> > > Sorry, I guess I didn't fully understand your suggestion. Are you
> > > saying that it's 'likely' that userspace would configure the correct
> > > value?
> > >
> > It depends on how userspace use this api to limit the number of pmcr. I
> > think what you mean in the code is that userspace need to set every vcp=
u's
> > pmcr to the same value, so the `unlikely` here is right, only one vcpu =
can
> > change the kvm->arch.pmcr.n, it saves the cpu cycles.
> >
> > What suggest above might be wrong. Since I think when userspace want to
> > limit the number of pmcr, it may just set the new_n on one vcpu, since =
the
> > kvm->arch.pmcr_n is a VM-local value, every vcpu can see it, so it's
> > `likely` the (new_n <=3D kvm->arch.pmcr_n_limit), it can decrease one c=
hecking
> > statement.
>
> How about we just do away with branch hints in the first place? This is
> _not_ a hot path.
>
Sounds good to me.

Thank you.
Raghavendra
> --
> Thanks,
> Oliver
