Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3C078F46A
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 23:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347509AbjHaVSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 17:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346710AbjHaVSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 17:18:23 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE786107
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 14:18:20 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58d428d4956so15444437b3.0
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 14:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693516700; x=1694121500; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YO6r55IA8eElX5w/+X8zOZmT73jh5i8DqE52ZxJWYQc=;
        b=hguwOPHMZfKtisF5e+gBBaqL6WbtLkRcf2jMAyVAdY8HAcwb2w2zJkAdSOOvRbGjbA
         kMN271Y/Bg4nTxMzuRKRdwO59El6BiwSpOaVXhtVFIxsnRq2o1EgiIdlOaJLHcZ5/+k4
         zT03hvFqNg6A7blr+MN/SPn9RJlLr8QOOqafiHMsKOX0syTih8CdWTr3oPvqKIei53ld
         Q6ih0C81J1DF+qKiSGaGw+1VVQ6FTYGqDTSS71pLg0Pq5ZiecLtMJxfhnXr2oGa4E8xg
         +rmK7ofH6iqpL1cxdWvRzjKKFpe+8ki74vJ5zd1hHmtD4w9iLyUWpXVY7Or3rttxT4oA
         gIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693516700; x=1694121500;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YO6r55IA8eElX5w/+X8zOZmT73jh5i8DqE52ZxJWYQc=;
        b=as/0T2HU2UooVJMD7NuxEROC+LMX0iCu2PEJ+Q+Z81rFC93dcLrNlDRQaAdJoaRS0g
         xWKiU/lmWUAfiMaxhZUx9+4XOD8OvHNIXgyTME2tkF5R03QVErCBwQAwhdFzkFiZfoY3
         hLJWCfiXYKNH9jpVNiiYaCEPnZg2f4S0Hh6W8YxzBVyMe7rwapijXKentT4gi5YqVpyx
         Xg4EP0ftXxbDyKckfHd1tsym2DkKnN4gjossemajB2IGgeYSIJaQm6BGIzPTDMTcoR99
         pPtxpOGlacWcaH5aCLbgrjrRJ+WKa/Orl8WjQ3b7zcHmPiZ6mcW5YJceQPPMoHs8Yk8G
         uslQ==
X-Gm-Message-State: AOJu0YwCoSSULnXpqy/HqgKw9qamwzAQYX4GdKoGChdY8GN6l6eTJNPC
        DZewiCEONJR5YsPYFcRmWOoINueVugc=
X-Google-Smtp-Source: AGHT+IEZwzQUuTI7C6FFX7BSq8V52BjhaRfu7MbpFPM/CoSsWVx5jFl7L8T8aMfs6TbWHc+jUHpp1k/u52U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:721:b0:586:5d03:67c8 with SMTP id
 bt1-20020a05690c072100b005865d0367c8mr16211ywb.3.1693516700041; Thu, 31 Aug
 2023 14:18:20 -0700 (PDT)
Date:   Thu, 31 Aug 2023 14:18:18 -0700
In-Reply-To: <CAD=HUj6XYKGgRLb2VWBnYEEH9YQUMROBf2YBXaTOvWZS5ejhmg@mail.gmail.com>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <20230705102547.hr2zxkdkecdxp5tf@linux.intel.com> <CAD=HUj7F6CUNt_9txEu0upB=PBwJzkL5dBhNs_BVHX1cicqBgw@mail.gmail.com>
 <ZOd0IMeKSkBwGIer@google.com> <CAD=HUj6XYKGgRLb2VWBnYEEH9YQUMROBf2YBXaTOvWZS5ejhmg@mail.gmail.com>
Message-ID: <ZPEDmnloiOs/HNr+@google.com>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023, David Stevens wrote:
> On Fri, Aug 25, 2023 at 12:15=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Aug 24, 2023, David Stevens wrote:
> > > On Wed, Jul 5, 2023 at 7:25=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.int=
el.com> wrote:
> > > >
> > > > On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> > > > > @@ -4529,7 +4540,8 @@ static int kvm_tdp_mmu_page_fault(struct kv=
m_vcpu *vcpu,
> > > > >
> > > > >  out_unlock:
> > > > >       read_unlock(&vcpu->kvm->mmu_lock);
> > > > > -     kvm_release_pfn_clean(fault->pfn);
> > > >
> > > > Yet kvm_release_pfn() can still be triggered for the kvm_vcpu_maped=
 gfns.
> > > > What if guest uses a non-referenced page(e.g., as a vmcs12)? Althou=
gh I
> > > > believe this is not gonna happen in real world...
> > >
> > > kvm_vcpu_map still uses gfn_to_pfn, which eventually passes FOLL_GET
> > > to __kvm_follow_pfn. So if a guest tries to use a non-refcounted page
> > > like that, then kvm_vcpu_map will fail and the guest will probably
> > > crash. It won't trigger any bugs in the host, though.
> > >
> > > It is unfortunate that the guest will be able to use certain types of
> > > memory for some purposes but not for others. However, while it is
> > > theoretically fixable, it's an unreasonable amount of work for
> > > something that, as you say, nobody really cares about in practice [1]=
.
> > >
> > > [1] https://lore.kernel.org/all/ZBEEQtmtNPaEqU1i@google.com/
> >
> > There are use cases that care, which is why I suggested allow_unsafe_km=
ap.
> > Specifically, AWS manages their pool of guest memory in userspace and m=
aps it all
> > via /dev/mem.  Without that module param to let userspace opt-in, this =
series will
> > break such setups.  It still arguably is a breaking change since it req=
uires
> > userspace to opt-in, but allowing such behavior by default is simply no=
t a viable
> > option, and I don't have much sympathy since so much of this mess has i=
ts origins
> > in commit e45adf665a53 ("KVM: Introduce a new guest mapping API").
> >
> > The use cases that no one cares about (AFAIK) is allowing _untrusted_ u=
serspace
> > to back guest RAM with arbitrary memory.  In other words, I want KVM to=
 allow
> > (by default) mapping device memory into the guest for things like vGPUs=
, without
> > having to do the massive and invasive overhaul needed to safely allow b=
acking guest
> > RAM with completely arbitrary memory.
>=20
> Do you specifically want the allow_unsafe_kmap breaking change? v7 of
> this series should have supported everything that is currently
> supported by KVM, but you're right that the v8 version of
> hva_to_pfn_remapped doesn't support mapping
> !kvm_pfn_to_refcounted_page() pages. That could be supported
> explicitly with allow_unsafe_kmap as you suggested,

I think it needs to be explicit, i.e. needs the admin to opt-in to the unsa=
fe
behavior.
