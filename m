Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A085E722EA6
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 20:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbjFESZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 14:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbjFESZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 14:25:06 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFDFD9
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 11:25:04 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-65592a7cb54so2124512b3a.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 11:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685989504; x=1688581504;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=58+aVmOVD+wub8Tm+nODowvPJNNI9g1PnmLoCltiP60=;
        b=CeEPTNwVTbVwJwgAdG6Bf6FDG7hN/p8BzU8W7gM2C/v315wUy4xYI4Lhj+mDqR3P/r
         peewCLTMj6GezuZsMt5ks+UOJ6IZp6TDrYx8H2RWeYhI1EOHFLmT9QagzK5SWdWrQUcG
         5nyRgCzdwV/tx/TEceUP80815uvkYrWHmdF0Yi0VMhFo296xpKSLJQBvkSibye6BFZ1M
         SJWnUKeWNJY6ruvH78SU4qy6N3iNG2BnqsH002h0SPsRdiFvfkwGQWAiAe96kf2amLSE
         Zz4GiFxKMO80JtKfLmUsvg1i8LLkx/I7LyosD/hpEJsV0bhobcKB1NuAutboove/FOn5
         qmVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685989504; x=1688581504;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=58+aVmOVD+wub8Tm+nODowvPJNNI9g1PnmLoCltiP60=;
        b=bdbb7YbKjPlav8I0rYqOO1rxjh667NDPNX6hBCYAGvO84bdLORLgtXJkFaH72pdX2z
         Egt6dLDiSZXWDlnQAE/ijJbxMkYBMjiR/EM+r8/f+tx28T079VY+VMFOAHwHV7RUIKV8
         0RvtiN6CiCus448rtRidu84ZYs+TImEbasMl+m0MBDRX3dJfhjI4W0tEq95ht7yQuBxN
         H2S8g/qqOR3j9gQ4a/4QnsszsTpz5jRv9YHgj5yLJonHczIURuYQPhAyBuadI4jeKO/f
         lOUjuMhLrjBP2R6d6IXPgZm5LSwy4sh94jPyffSGpRQR3xiDLT0DBG+anbbKWBYNkNqs
         JFUQ==
X-Gm-Message-State: AC+VfDxl4N0902kaIRef5CVbfJbpMs25LuBdVLfdBpY/+qs3nWhqOQUk
        8dYpCaGBwtnUD3XIWfDgM7Hb1rzADBI=
X-Google-Smtp-Source: ACHHUZ6uoTMjfi3w+IvrgwnC0J4YTw6TKvAaIIkx4F3LPDbI3tQJiuALd/QitH59lyNjErp8u6hY6tK2J6E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a4a:b0:653:9883:40ec with SMTP id
 h10-20020a056a001a4a00b00653988340ecmr221279pfv.5.1685989503836; Mon, 05 Jun
 2023 11:25:03 -0700 (PDT)
Date:   Mon, 5 Jun 2023 11:25:02 -0700
In-Reply-To: <CAL715WJowYL=W40SWmtPoz1F9WVBFDG7TQwbsV2Bwf9-cS77=Q@mail.gmail.com>
Mime-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com> <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
 <CAL715WJowYL=W40SWmtPoz1F9WVBFDG7TQwbsV2Bwf9-cS77=Q@mail.gmail.com>
Message-ID: <ZH4ofuj0qvKNO9Bz@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023, Mingwei Zhang wrote:
> On Mon, Jun 5, 2023 at 9:55=E2=80=AFAM Jim Mattson <jmattson@google.com> =
wrote:
> >
> > On Sun, Jun 4, 2023 at 5:43=E2=80=AFPM Mingwei Zhang <mizhang@google.co=
m> wrote:
> > >
> > > Remove KVM MMU write lock when accessing indirect_shadow_pages counte=
r when
> > > page role is direct because this counter value is used as a coarse-gr=
ained
> > > heuristics to check if there is nested guest active. Racing with this
> > > heuristics without mmu lock will be harmless because the correspondin=
g
> > > indirect shadow sptes for the GPA will either be zapped by this threa=
d or
> > > some other thread who has previously zapped all indirect shadow pages=
 and
> > > makes the value to 0.
> > >
> > > Because of that, remove the KVM MMU write lock pair to potentially re=
duce
> > > the lock contension and improve the performance of nested VM. In addi=
tion
> > > opportunistically change the comment of 'direct mmu' to make the
> > > description consistent with other places.
> > >
> > > Reported-by: Jim Mattson <jmattson@google.com>
> > > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > > ---
> > >  arch/x86/kvm/x86.c | 10 ++--------
> > >  1 file changed, 2 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 5ad55ef71433..97cfa5a00ff2 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -8585,15 +8585,9 @@ static bool reexecute_instruction(struct kvm_v=
cpu *vcpu, gpa_t cr2_or_gpa,
> > >
> > >         kvm_release_pfn_clean(pfn);
> > >
> > > -       /* The instructions are well-emulated on direct mmu. */
> > > +       /* The instructions are well-emulated on Direct MMUs. */
> > >         if (vcpu->arch.mmu->root_role.direct) {
> > > -               unsigned int indirect_shadow_pages;
> > > -
> > > -               write_lock(&vcpu->kvm->mmu_lock);
> > > -               indirect_shadow_pages =3D vcpu->kvm->arch.indirect_sh=
adow_pages;
> > > -               write_unlock(&vcpu->kvm->mmu_lock);
> > > -
> > > -               if (indirect_shadow_pages)
> > > +               if (READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
> >
> > I don't understand the need for READ_ONCE() here. That implies that
> > there is something tricky going on, and I don't think that's the case.
>=20
> READ_ONCE() is just telling the compiler not to remove the read. Since
> this is reading a global variable,  the compiler might just read a
> previous copy if the value has already been read into a local
> variable. But that is not the case here...
>=20
> Note I see there is another READ_ONCE for
> kvm->arch.indirect_shadow_pages, so I am reusing the same thing.

I agree with Jim, using READ_ONCE() doesn't make any sense.  I suspect it m=
ay have
been a misguided attempt to force the memory read to be as close to the wri=
te_lock()
as possible, e.g. to minimize the chance of a false negative.

> I did check the reordering issue but it should be fine because when
> 'we' see indirect_shadow_pages as 0, the shadow pages must have
> already been zapped. Not only because of the locking, but also the
> program order in __kvm_mmu_prepare_zap_page() shows that it will zap
> shadow pages first before updating the stats.

I don't think zapping, i.e. the 1=3D>0 transition, is a concern.  KVM is dr=
opping
the SPTE, so racing with kvm_mmu_pte_write() is a non-issue because the gue=
st
will either see the old value, or will fault after the SPTE is zapped, i.e.=
 KVM
won't run with a stale even if kvm_mmu_pte_write() sees '0' before TLBs are
flushed.

I believe the 0=3D>1 transition on the other hand doesn't have a *very* the=
oretical
bug.  KVM needs to ensure that either kvm_mmu_pte_write() sees an elevated =
count,
or that a page fault task sees the updated guest PTE, i.e. the emulated wri=
te.
The READ_ONCE() likely serves this purpose in practice, though technically =
it's
insufficient.

So I think this?

---
 arch/x86/kvm/mmu.h     | 14 ++++++++++++++
 arch/x86/kvm/mmu/mmu.c | 13 ++++++++++++-
 arch/x86/kvm/x86.c     |  8 +-------
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 92d5a1924fc1..9cd105ccb1d4 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -264,6 +264,20 @@ static inline bool kvm_memslots_have_rmaps(struct kvm =
*kvm)
 	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
 }
=20
+static inline bool kvm_mmu_has_indirect_shadow_pages(struct kvm *kvm)
+{
+	/*
+	 * When emulating guest writes, ensure the written value is visible to
+	 * any task that is handling page faults before checking whether or not
+	 * KVM is shadowing a guest PTE.  This ensures either KVM will create
+	 * the correct SPTE in the page fault handler, or this task will see
+	 * a non-zero indirect_shadow_pages.  Pairs with the smp_mb() in
+	 * account_shadowed() and unaccount_shadowed().
+	 */
+	smp_mb();
+	return kvm->arch.indirect_shadow_pages;
+}
+
 static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 {
 	/* KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K) must be 0. */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8961f45e3b1..1735bee3f653 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -830,6 +830,17 @@ static void account_shadowed(struct kvm *kvm, struct k=
vm_mmu_page *sp)
 	gfn_t gfn;
=20
 	kvm->arch.indirect_shadow_pages++;
+
+	/*
+	 * Ensure indirect_shadow_pages is elevated prior to re-reading guest
+	 * child PTEs in FNAME(gpte_changed), i.e. guarantee either in-flight
+	 * emulated writes are visible before re-reading guest PTEs, or that
+	 * an emulated write will see the elevated count and acquire mmu_lock
+	 * to update SPTEs.  Pairs with the smp_mb() in
+	 * kvm_mmu_has_indirect_shadow_pages().
+	 */
+	smp_mb();
+
 	gfn =3D sp->gfn;
 	slots =3D kvm_memslots_for_spte_role(kvm, sp->role);
 	slot =3D __gfn_to_memslot(slots, gfn);
@@ -5692,7 +5703,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, =
gpa_t gpa,
 	 * If we don't have indirect shadow pages, it means no page is
 	 * write-protected, so we can exit simply.
 	 */
-	if (!READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
+	if (!kvm_mmu_has_indirect_shadow_pages(vcpu->kvm))
 		return;
=20
 	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index abfba3cae0ba..22c226f5f4f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8588,13 +8588,7 @@ static bool reexecute_instruction(struct kvm_vcpu *v=
cpu, gpa_t cr2_or_gpa,
=20
 	/* The instructions are well-emulated on direct mmu. */
 	if (vcpu->arch.mmu->root_role.direct) {
-		unsigned int indirect_shadow_pages;
-
-		write_lock(&vcpu->kvm->mmu_lock);
-		indirect_shadow_pages =3D vcpu->kvm->arch.indirect_shadow_pages;
-		write_unlock(&vcpu->kvm->mmu_lock);
-
-		if (indirect_shadow_pages)
+		if (kvm_mmu_has_indirect_shadow_pages(vcpu->kvm))
 			kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
=20
 		return true;

base-commit: 69b4e5b82fec7195c79c939ce25789b16a133f3a
--=20

