Return-Path: <kvm+bounces-19700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F36908FBF
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 18:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD78D1C213A7
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C792216C696;
	Fri, 14 Jun 2024 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JshK+I1U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6481AD512
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 16:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381583; cv=none; b=GRPX7/iNe4fqpeiPMy8out71DSlNyjaZEgAAd01vJSyL7l5fX0bjUv2NcsmGEOCkFIO997SLNq9U0Vo7rfX38Qw3aOMILjfH1MN311tmhIXtigPqGHh4SsQYAHwh5OWDf31/tPkmHs4uT9p9Uzqugu3CnhbFXDPSLVfv5QqY+3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381583; c=relaxed/simple;
	bh=LgYcFufJoudAo/kd1BCZymlGqrmupX//kefrk1Xqs/8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NdpEYxEg1mPB80tA6Uqr7YQDqZ3boJPh7e89ER4MQcG61U+QH2pG3OmnBmaX8knYFUlVLLSb7UOqCnLIRAfT6nZ1r93TA0qpirGupaq6SnMk4cyi25joDMxyRPX2DyLvmdl9yRXTHSRvKsEzBi8PF+rHU1nR8QI6IR4FZKC4haA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JshK+I1U; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c2d6e09e62so2166704a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 09:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718381581; x=1718986381; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7gUwZpSkwFU+FWUT8qGAdEg7M+9bZN02qOvPWnijOmA=;
        b=JshK+I1UgdSV/H+n97loPtXf0HjpozqJ5LcHlIcADkPszGiftLamByPqQg0OkBYm/6
         BI79mFR4nHIDCcTlQsQQxKbzxlNRKwzZEYN1o9avpfcz5273g4z67jlsTmaKi/1mfzVg
         805mbJmRhMMsMDRrWKVnMhHrjKIbWyyyBXopm+2q6kEeoOVW2hXCGRAfnoffWyqH2zwT
         3kBcgUkY2TKeWWN0fnyntPd7YRApd4k+2POk0PqPDye+G+oudvPYzFbP5AZlGKV8s34K
         XnCifU/x4xN0Vc+GKn1V9V+1HsYP9aS3TZTNlmz1tXFniowz0aKwR0Sf6LqJL2AWMlIZ
         B+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718381581; x=1718986381;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7gUwZpSkwFU+FWUT8qGAdEg7M+9bZN02qOvPWnijOmA=;
        b=Oo/LnqSB6g3mKfDmE6GHzpNqzpQ48XBnk5c9hgegq3+lanaHCMLxsGPH5+mCbKR5ns
         gLwqi43hdAWxL0BGdlbTUb+TIy8wzsqSN0iFYs9aGJ4er4a6XueiYzciq2wmVbEUwXbL
         tB+uemoFrQ3VXHcd9hPW6a/PIAepr6Z2srJeWmkymqyDtrTlxQ0kQP9Jn352/DSx23gZ
         417F4b8Y+Vq+Gfmnl5vW3byNO2AUWG18vz4ebNkGIScNnK5E8RsKxNyA/V8YWa2fs70q
         FxDGxcYlHQjZHiAa2Tpm2WhwFfEqy5ophDg030a5/JEr1K4AJWLJpq4i7hdW6iv6fpCH
         ON3A==
X-Forwarded-Encrypted: i=1; AJvYcCVh9U57jOZLe95PmzHV+t34mB4Lem2xXklPqytW4IhEMzohXLHMu5IJY+G9KG676IVOH14WkSWto2Ps4L+jKZv/xD+4
X-Gm-Message-State: AOJu0YypDldhjb5uW4jtBlrWpQ2q6VRps3kVfoxqDK7V+WMDxPxonr3m
	ad9ThIlIXc/A/VlDomtZOIqwGxd4jxMJ72BtAb1AtsTvON5juK9CucO35RLPFPFFcBMzmtHVbyl
	5aA==
X-Google-Smtp-Source: AGHT+IGlVfs98G7fCfwtsxB7s1pHGkpT0a32/JmIPXufrERUYhHEg26qK2yxEIeC4poHP/k7VOCg4R/uWRE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4294:b0:2c2:c6fa:c05d with SMTP id
 98e67ed59e1d1-2c4dbf336famr123419a91.9.1718381580584; Fri, 14 Jun 2024
 09:13:00 -0700 (PDT)
Date: Fri, 14 Jun 2024 09:12:59 -0700
In-Reply-To: <CADrL8HUW2q79F0FsEjhGW0ujij6+FfCqas5UpQp27Epfjc94Nw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com> <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
 <ZmioedgEBptNoz91@google.com> <CADrL8HU_FKHTz_6d=xhVLZFDQ_zQo-zdB2rqdpa2CKusa1uo+A@mail.gmail.com>
 <ZmjtEBH42u7NUWRc@google.com> <CADrL8HUW2q79F0FsEjhGW0ujij6+FfCqas5UpQp27Epfjc94Nw@mail.gmail.com>
Message-ID: <ZmxsCwu4uP1lGsWz@google.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2024, James Houghton wrote:
> On Tue, Jun 11, 2024 at 5:34=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > A flag would also avoid an indirect call and thus a RETPOLINE when CONF=
IG_RETPOLINE=3Dy,
> > i.e. would be a minor optimization when KVM doesn't suppport fast aging=
.  But that's
> > probably a pretty unlikely combination, so it's probably not a valid ar=
gument.
> >
> > So, I guess I don't have a strong opinion?
>=20
> (Sorry for the somewhat delayed response... spent some time actually
> writing what this would look like.)
>=20
> I see what you mean, thanks! So has_fast_aging might be set by KVM if
> the architecture sets a Kconfig saying that it understands the concept
> of fast aging, basically what the presence of this v5's
> test_clear_young_fast_only() indicates.

It would need to be a runtime setting, because KVM x86-64 with tdp_mmu_enab=
led=3Dfalse
doesn't support fast aging (uses the shadow MMU even for TDP).

> > I don't understand where the "must check shadow MMU" in #4 comes from. =
 I also
> > don't think it's necessary; see below.
>=20
> I just meant `kvm_has_shadow_mmu_sptes()` or
> `kvm_memslots_have_rmaps()`. I like the logic you suggest below. :)
>=20
> > > Some of this reordering (and maybe a change from
> > > kvm_shadow_root_allocated() to checking indirect_shadow_pages or
> > > something else) can be done in its own patch.
>=20
> So just to be clear, for test_young(), I intend to have a patch in v6
> to elide the shadow MMU check if the TDP MMU indicates Accessed. Seems
> like a pure win; no reason not to include it if we're making logic
> changes here anyway.

I don't think that's correct.  The initial fast_only=3Dfalse aging should p=
rocess
shadow MMUs (nested TDP) and TDP MMUs, otherwise a future fast_only=3Dfalse=
 would
get a false positive on young due to failing to clear the Accessed bit in t=
he
shadow MMU.  E.g. if page X is accessed by both L1 and L2, then aged, and n=
ever
accessed again, the Accessed bit would still be set in the page tables for =
L2.

My thought for MMU_NOTIFY_WAS_FAST below (which again is a bad name) is to
communicate to MGLRU that the page was found to be young in an MMU that sup=
ports
fast aging, i.e. that looking around at other SPTEs is worth doing.

> > > > So rather than failing the fast aging, I think what we want is to k=
now if an
> > > > mmu_notifier found a young SPTE during a fast lookup.  E.g. somethi=
ng like this
> > > > in KVM, where using kvm_has_shadow_mmu_sptes() instead of kvm_memsl=
ots_have_rmaps()
> > > > is an optional optimization to avoid taking mmu_lock for write in p=
aths where a
> > > > (very rare) false negative is acceptable.
> > > >
> > > >   static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)
> > > >   {
> > > >         return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_sha=
dow_pages);
> > > >   }
> > > >
> > > >   static int __kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *r=
ange,
> > > >                          bool fast_only)
> > > >   {
> > > >         int young =3D 0;
> > > >
> > > >         if (!fast_only && kvm_has_shadow_mmu_sptes(kvm)) {
> > > >                 write_lock(&kvm->mmu_lock);
> > > >                 young =3D kvm_handle_gfn_range(kvm, range, kvm_age_=
rmap);
> > > >                 write_unlock(&kvm->mmu_lock);
> > > >         }
> > > >
> > > >         if (tdp_mmu_enabled && kvm_tdp_mmu_age_gfn_range(kvm, range=
))
> > > >                 young =3D 1 | MMU_NOTIFY_WAS_FAST;
>=20
> The most straightforward way (IMHO) to return something like `1 |
> MMU_NOTIFY_WAS_FAST` up to the MMU notifier itself is to make
> gfn_handler_t return int instead of bool.

Hrm, all the options are unpleasant.  Modifying gfn_handler_t to return an =
int
will require an absurd amount of churn (all implementations in all archictu=
res),
and I don't love that the APIs that return true/false to indicate "flush" w=
ould
lose their boolean-ness.

One idea would be to add kvm_mmu_notifier_arg.aging_was_fast or so, and the=
n
refactor kvm_handle_hva_range_no_flush() into a dedicated aging helper, and=
 have
it morph the KVM-internal flag into an MMU_NOTIFIER flag.  It's not perect =
either,
but it requires far less churn and keeps some of the KVM<=3D>mmu_notifer de=
tails in
common KVM code.

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7b9d2633a931..c11a359b6ff5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -258,6 +258,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 union kvm_mmu_notifier_arg {
        unsigned long attributes;
+       bool aging_was_fast;
 };
=20
 struct kvm_gfn_range {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 436ca41f61e5..a936f6bedd97 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -685,10 +685,10 @@ static __always_inline int kvm_handle_hva_range(struc=
t mmu_notifier *mn,
        return __kvm_handle_hva_range(kvm, &range).ret;
 }
=20
-static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifi=
er *mn,
-                                                        unsigned long star=
t,
-                                                        unsigned long end,
-                                                        gfn_handler_t hand=
ler)
+static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
+                                            unsigned long start,
+                                            unsigned long end,
+                                            bool flush_if_young)
 {
        struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
        const struct kvm_mmu_notifier_range range =3D {
@@ -696,11 +696,14 @@ static __always_inline int kvm_handle_hva_range_no_fl=
ush(struct mmu_notifier *mn
                .end            =3D end,
                .handler        =3D handler,
                .on_lock        =3D (void *)kvm_null_fn,
-               .flush_on_ret   =3D false,
+               .flush_on_ret   =3D flush_if_young,
                .may_block      =3D false,
+               .aging_was_fast =3D false,
        };
=20
-       return __kvm_handle_hva_range(kvm, &range).ret;
+       bool young =3D __kvm_handle_hva_range(kvm, &range).ret;
+
+       return (int)young | (range.aging_was_fast ? MMU_NOTIFIER_FAST_AGING=
 : 0);
 }
=20
 void kvm_mmu_invalidate_begin(struct kvm *kvm)
@@ -865,7 +868,7 @@ static int kvm_mmu_notifier_clear_flush_young(struct mm=
u_notifier *mn,
 {
        trace_kvm_age_hva(start, end);
=20
-       return kvm_handle_hva_range(mn, start, end, kvm_age_gfn);
+       return kvm_age_hva_range(mn, start, end, true);
 }
=20
 static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
@@ -875,20 +878,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_not=
ifier *mn,
 {
        trace_kvm_age_hva(start, end);
=20
-       /*
-        * Even though we do not flush TLB, this will still adversely
-        * affect performance on pre-Haswell Intel EPT, where there is
-        * no EPT Access Bit to clear so that we have to tear down EPT
-        * tables instead. If we find this unacceptable, we can always
-        * add a parameter to kvm_age_hva so that it effectively doesn't
-        * do anything on clear_young.
-        *
-        * Also note that currently we never issue secondary TLB flushes
-        * from clear_young, leaving this job up to the regular system
-        * cadence. If we find this inaccurate, we might come up with a
-        * more sophisticated heuristic later.
-        */
-       return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
+       return kvm_age_hva_range(mn, start, end, false);
 }
=20
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
@@ -897,8 +887,7 @@ static int kvm_mmu_notifier_test_young(struct mmu_notif=
ier *mn,
 {
        trace_kvm_test_age_hva(address);
=20
-       return kvm_handle_hva_range_no_flush(mn, address, address + 1,
-                                            kvm_test_age_gfn);
+       return kvm_age_hva_range(mn, address, address + 1, false);
 }
=20
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,


> > The change, relative to v5, that I am proposing is that MGLRU looks aro=
und if
> > the page was young in _a_ "fast" secondary MMU, whereas v5 looks around=
 if and
> > only if _all_ secondary MMUs are fast.
> >
> > In other words, if a fast MMU had a young SPTE, look around _that_ MMU,=
 via the
> > fast_only flag.
>=20
> Oh, yeah, that's a lot more intelligent than what I had. I think I
> fully understand your suggestion; I guess we'll see in v6. :)
>=20
> I wonder if this still makes sense if whether or not an MMU is "fast"
> is determined by how contended some lock(s) are at the time.

No.  Just because a lock wasn't contended on the initial aging doesn't mean=
 it
won't be contended on the next round.  E.g. when using KVM x86's shadow MMU=
, which
takes mmu_lock for write for all operations, an aging operation could get l=
ucky
and sneak in while mmu_lock happened to be free, but then get stuck behind =
a large
queue of operations.

The fast-ness needs to be predictable and all but guaranteed, i.e. lockless=
 or in
an MMU that takes mmu_lock for read in all but the most rare paths.

