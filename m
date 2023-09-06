Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C027945E5
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 00:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244975AbjIFWDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 18:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjIFWDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 18:03:51 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FA81BF2
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 15:03:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7e880af201so352883276.0
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 15:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694037805; x=1694642605; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jGjz0wwIvGFqvXEmPizGTlbv+e1jyl/6EbitI2f252Y=;
        b=nb1dy9m006Xk0johkIcc5bWImXSs1SaxCeDu4VVWVW3rJnmwwG4mTPv3AOzWMU68Ec
         PmkDRd3C0y9LDW0zs8UDz4XsUizceWuokDhK5gdIvEmTA7WcN0hmHQT1ylmJDOBI/Rux
         4+wcY2QZLqAw5hztxWYEn8Lea9zZiZ3Kv56EMQCAWyTXswyPK39bqF2O56nzA/tK31y6
         2q2Evk10EwpPS/uPSV6n8fiN4zhWctIO0T+IsAJFSkhV3WcNzbAB7A6C6laY1YM1tF+S
         JCd8+atThHPzphKFZyb2PZNWhUc90uPFFe7TJjJ+wezheRaBdNgbryj4xor8GXOn/7Vv
         UorQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694037805; x=1694642605;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jGjz0wwIvGFqvXEmPizGTlbv+e1jyl/6EbitI2f252Y=;
        b=bR76WUem67LRmTQrEF4ERhM5BQZRc1cv18/2o+jyQEDr/mUADv5UJJGKbsSg8HMvfY
         AN2u48Ez/mOKknwRIsIJ4f1KMcEOntLH7KQNd0VB3G4XFVupWnDxr5bVO5BYCWygSafY
         oMFVdfCvYbLlewgwj0EbXof+2Ofm6Al29t273GeH0lJGN2GhXVVZzRR+WKZ44G1Wj7GP
         qo0ufHwu6ELutalZSIVzeATsw1Zzk+l+6dfyEn9A3Qnt47W27kt4WquJn1oNTmovc8Yt
         9dABdI2jUPCJQnZOaX90qxesqRzfoG164M99D8AY+FcklR9vUF9wkIQp+BkSBB1yjYzs
         oe9Q==
X-Gm-Message-State: AOJu0YyIbbkzsH3951CTfc7X/MdT3i0Jepr1Appje2rsRAnrFWMYA4vt
        KT8mI2O2zw2oByIxHj3pqOTOVfb1HYI=
X-Google-Smtp-Source: AGHT+IGOMcVTpbC+lxuJRrEEC94mRP+gmjhMRarxpVWopTpRuNtLEn0yjfIpL45dRKz4q3Wh4Fcwje8c9EI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:40d0:0:b0:d7b:9902:fb3d with SMTP id
 n199-20020a2540d0000000b00d7b9902fb3dmr421967yba.0.1694037805327; Wed, 06 Sep
 2023 15:03:25 -0700 (PDT)
Date:   Wed, 6 Sep 2023 15:03:23 -0700
In-Reply-To: <CAD=HUj4W4PF3O9oLZx-3Rd_W51x1z30hQ36m_fcWUpw=mxUpSA@mail.gmail.com>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-4-stevensd@google.com>
 <20230705161914.00004070.zhi.wang.linux@gmail.com> <CAD=HUj5cbzjrc0KD7xcibtRMRCzoJRJAzt7jTHSXUSpzyAYbdg@mail.gmail.com>
 <20230711203348.00000fb8.zhi.wang.linux@gmail.com> <ZK3Q34WNLjGVQQw+@google.com>
 <CAD=HUj6SoKHhA02oNpCt--ofE_n1wjdY1ddBURXDiS5Rwu=Q-g@mail.gmail.com>
 <ZPfLjnG8b9LJV4p7@google.com> <CAD=HUj4W4PF3O9oLZx-3Rd_W51x1z30hQ36m_fcWUpw=mxUpSA@mail.gmail.com>
Message-ID: <ZPj3KyvCa4GM0RJ2@google.com>
Subject: Re: [PATCH v7 3/8] KVM: Make __kvm_follow_pfn not imply FOLL_GET
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023, David Stevens wrote:
> On Wed, Sep 6, 2023 at 9:45=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Tue, Sep 05, 2023, David Stevens wrote:
> > > For property 2, FOLL_GET is also important. If guarded_by_mmu_notifie=
r
> > > is set, then we're all good here. If guarded_by_mmu_notifier is not
> > > set, then the check in __kvm_follow_pfn guarantees that FOLL_GET is
> > > set. For struct page memory, we're safe because KVM will hold a
> > > reference as long as it's still using the page. For non struct page
> > > memory, we're not safe - this is where the breaking change of
> > > allow_unsafe_mappings would go. Note that for non-refcounted struct
> > > page, we can't use the allow_unsafe_mappings escape hatch. Since
> > > FOLL_GET was requested, if we returned such a page, then the caller
> > > would eventually corrupt the page refcount via kvm_release_pfn.
> >
> > Yes we can.  The caller simply needs to be made aware of is_refcounted_=
page.   I
> > didn't include that in the snippet below because I didn't want to write=
 the entire
> > patch.  The whole point of adding is_refcounted_page is so that callers=
 can
> > identify exactly what type of page was at the end of the trail that was=
 followed.
>=20
> Are you asking me to completely migrate every caller of any gfn_to_pfn
> variant to __kvm_follow_pfn, so that they can respect
> is_refcounted_page? That's the only way to make it safe for
> allow_unsafe_mappings to apply to non-refcounted pages. That is
> decidedly not simple. Or is kvm_vcpu_map the specific call site you
> care about? At best, I can try to migrate x86, and then just add some
> sort of compatibility shim for other architectures that rejects
> non-refcounted pages.

Ah, I see your conundrum.  No, I don't think it's reasonable to require you=
 to
convert all users in every architecture.  I'll still ask, just in case you'=
re
feeling generous, but it's not a requirement :-)

The easiest way forward I can think of is to add yet another flag to kvm_fo=
llow_pfn,
e.g. allow_non_refcounted_struct_page, to communicate whether or not the ca=
ller
has been enlightened to play nice with non-refcounted struct page memory.  =
We'll
need that flag no matter what, otherwise we'd have to convert all users in =
a single
patch (LOL).  Then your series can simply stop at a reasonable point, e.g. =
convert
all x86 usage (including kvm_vcpu_map(), and leave converting everything el=
se to
future work.

E.g. I think this would be the outro of hva_to_pfn_remapped():

        if (!page)
                goto out;

        if (get_page_unless_zero(page))
                WARN_ON_ONCE(kvm_follow_refcounted_pfn(foll, page) !=3D pfn=
);
 out:
        pte_unmap_unlock(ptep, ptl);

	/*
	 * TODO: Drop allow_non_refcounted_struct_page once all callers have
	 * been taught to play nice with non-refcounted tail pages.
	 */
	if (page && !foll->is_refcounted_page &&
	    !foll->allow_non_refcounted_struct_page)
		r =3D -EFAULT
        else if (!foll->is_refcounted_page && !foll->guarded_by_mmu_notifie=
r &&
        	 !allow_unsafe_mappings)
        	r =3D -EFAULT;
        else
               *p_pfn =3D pfn;

        return r;

> > > Property 3 would be nice, but we've already concluded that guarding
> > > all translations with mmu notifiers is infeasible. So maintaining
> > > property 2 is the best we can hope for.
> >
> > No, #3 is just a variant of #2.  Unless you're talking about not making=
 guarantees
> > about guest accesses being ordered with respect to VMA/memslot updates,=
 but I
> > don't think that's the case.
>=20
> I'm talking about the fact that kvm_vcpu_map is busted with respect to
> updates to VMA updates. It won't corrupt host memory because the
> mapping keeps a reference to the page, but it will continue to use
> stale translations.

True.  But barring some crazy paravirt use case, userspace modifying a mapp=
ing
that is in active use is inherently broken, the guest will have no idea tha=
t memory
just got yanked away.

Hmm, though I suppose userspace could theoretically mprotect() a mapping to=
 be
read-only, which would "work" for mmu_notifier paths but not kvm_vcpu_map()=
.  But
KVM doesn't provide enough information on -EFAULT for userspace to do anyth=
ing in
response to a write to read-only memory, so in practice that's likely inher=
ently
broken too.

> From [1], it sounds like you've granted that fixing that is not feasible,=
 so
> I just wanted to make sure that this isn't the "unsafe" referred to by
> allow_unsafe_mappings.

Right, this is not the "unsafe" I'm referring to.

> [1] https://lore.kernel.org/all/ZBEEQtmtNPaEqU1i@google.com/
