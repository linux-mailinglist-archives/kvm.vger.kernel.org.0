Return-Path: <kvm+bounces-49102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA41AD5F23
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:38:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA595189ED2C
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 19:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42A74289350;
	Wed, 11 Jun 2025 19:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ObvP1Gpa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35202E6102
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 19:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749670675; cv=none; b=vA1J0KxTdk6rXO9IM9DFdKdatL2ntmjGhfWJJF9ZSXp5EzlOyVPjVRMPFlMEEIRAAMHQydmWOPQL9Cwh2seSN7F281sYriVFMA/B5SlvawGdf2SBaS3xoKzEGK7VamA73aKh9Eskpy8s5PIZumABIOv+5e/ulH9llyUV9yy+POg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749670675; c=relaxed/simple;
	bh=tMAoDht5z4t6rY2hzYFIF569a3Uqdm/sVnCxlCHgZBc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i5fEZ0ndmsDl9NI6I/4bis+ub/HFm0BSITuVGjbRodqf/jGwI0Q87ve2fgvSbHhohGkiVXjGb8iHt2IriXfkv4Oc68mrjZ/DqbAIDeQELg+yEppouy3Q7TIJkZSeoOL9Yg7hgdnFHgOa/jyyxC/C4OO5bKejNiPP6OiEVl7VRO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ObvP1Gpa; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311d067b3faso294640a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 12:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749670673; x=1750275473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XK9lqRMcWAUTITJdYLggpl8SfH/tOpT9RcjWLw+AB2Q=;
        b=ObvP1GpaEi33odre/qgjefZnWCfwl7drY/e0Aoq9/jZqhUKISn7m7cye97xWuC8nZq
         LrS5RkND1V8WFI5Sy8vU/yvdu2LkH6r37+ZjPJmbBl9LquOQChfmpDz/+bn/FpIAFSY1
         qnGxd5KqXAZ3TxHkFX8dG9+KOMX+ZY8106Gxgcd3QT6xAFVlWEen2oVsRMGYRBeYehMm
         z+3Gy80UAdH/udCeoZuYZlsMbobF3PMvFV6gej5LBHBhxZt4X/q5lWFJDSeq6lnwK6nf
         KsUQo9NHiNTvjN+mDxM8lujnJfKaheoEqYL+5Klp6h/IHhzOeLjKtaBOyL3bBXP/P8p6
         E0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749670673; x=1750275473;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XK9lqRMcWAUTITJdYLggpl8SfH/tOpT9RcjWLw+AB2Q=;
        b=bFy5hdgA3uA0lb4Bgu7IrHCKwiTAjuCVgKFanxeGItTZ/s9tw5cJMkXAl8Wx2Ie5CW
         /heCccJD04m7Dbvp9no66w4ena38DSrtDckbzPJo/6lu5pBUksc+3XShd7+ZLlYg4XCW
         xUKyIgFeYtbEoFnMnN9oTQ7ny8SEDkovylhDDTMifa/IrqNSfpTniznZo/Yc5KviWR06
         tADTSrEwbMzT5pKYQKqZP+doH/pPcpewkHCDwR36dLZGGDejfcvqy+cXo6JvlOBYl7mC
         ZFOHujam0qAaXLlqlfZ+l5TjwJ7PWV6YDgtzp2kY9TfP89ETjYuj0fY9A8lk0riG0MER
         1p6A==
X-Forwarded-Encrypted: i=1; AJvYcCUeHsOf5dwSBFd644CjhP3XJN2WBuiWQiU3140vgB/Kkdt1yFmC9wT9rkNzciosTpvm1W4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPvvP6NuIZZd55YcT6vkkW58aAxZ7oCcLzlI7UwmyRaCqubE05
	DXjAZFjjuRXAOya1n3DsHUTcknWQs+saSrj8RriIpx5qGSTpEXdyO+RJoUTKRUjspMfZSzGiiF0
	ucklu+w==
X-Google-Smtp-Source: AGHT+IFyOcDkrlCmf2wied79kN38rbCK3Hf3h7YdTs4dsyPIQs1bPUiiPwsRPA4+oQMF1pQQSH/rZhX1K6M=
X-Received: from pjbeu6.prod.google.com ([2002:a17:90a:f946:b0:311:c20d:676d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d647:b0:311:ad7f:329f
 with SMTP id 98e67ed59e1d1-313af231f38mr5899772a91.31.1749670673167; Wed, 11
 Jun 2025 12:37:53 -0700 (PDT)
Date: Wed, 11 Jun 2025 12:37:51 -0700
In-Reply-To: <5fee2f3b-03de-442b-acaf-4591638c8bb5@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
 <aEnGjQE3AmPB3wxk@google.com> <5fee2f3b-03de-442b-acaf-4591638c8bb5@redhat.com>
Message-ID: <aEnbDya7OOXdO85q@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for KVM_PRE_FAULT_MEMORY
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, rick.p.edgecombe@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, reinette.chatre@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, isaku.yamahata@intel.com, 
	Binbin Wu <binbin.wu@linux.intel.com>, tony.lindgren@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025, Paolo Bonzini wrote:
> On Wed, Jun 11, 2025 at 8:10=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > +     direct_bits =3D 0;
> > >       if (kvm_arch_has_private_mem(vcpu->kvm) &&
> > >           kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
> > >               error_code |=3D PFERR_PRIVATE_ACCESS;
> > > +     else
> > > +             direct_bits =3D gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kv=
m));
> >=20
> > Eww.  It's bad enough that TDX bleeds it's mirror needs into common MMU=
 code,
> > but stuffing vendor specific GPA bits in common code goes too far.  Act=
ually,
> > all of this goes too far.  There's zero reason any code outside of TDX =
needs to
> > *explicitly* care whether mirrors or "direct" MMUs have mandatory gfn b=
its.
> >=20
> > Back to the main topic, KVM needs to have a single source of truth when=
 it comes
> > to whether a fault is private and thus mirrored (or not).  Common KVM n=
eeds to be
> > aware of aliased GFN bits, but absolute nothing outside of TDX (includi=
ng common
> > VMX code) should be aware the mirror vs. "direct" (I hate that terminol=
ogy; KVM
> > has far, far too much history and baggage with "direct") is tied to the=
 existence
> > and polarity of aliased GFN bits.
> >=20
> > To detect a mirror fault:
> >=20
> >   static inline bool kvm_is_mirror_fault(struct kvm *kvm, u64 error_cod=
e)
> >   {
> >         return kvm_has_mirrored_tdp(kvm) &&
> >                error_code & PFERR_PRIVATE_ACCESS;
> >   }
> >=20
> > And for TDX, it should darn well explicitly track the shared GPA mask:
> >=20
> >   static bool tdx_is_private_gpa(struct kvm *kvm, gpa_t gpa)
> >   {
> >         /* For TDX the direct mask is the shared mask. */
> >         return !(gpa & to_kvm_tdx(kvm)->shared_gpa_mask);
> >   }
>=20
> My fault - this is more similar, at least in spirit, to what
> Yan and Xiaoyao had tested earlier:
>=20
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 52acf99d40a0..209103bf0f30 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -48,7 +48,7 @@ static inline enum kvm_tdp_mmu_root_types
>  static inline struct kvm_mmu_page *tdp_mmu_get_root_for_fault(struct kvm=
_vcpu *vcpu,
>  							      struct kvm_page_fault *fault)
>  {
> -	if (unlikely(!kvm_is_addr_direct(vcpu->kvm, fault->addr)))
> +	if (unlikely(fault->is_private))
>  		return root_to_sp(vcpu->arch.mmu->mirror_root_hpa);
>=20
> and I instead proposed the version that you hate with such ardor.
>=20
> My reasoning was that I preferred to have the pre-fault scenario "look li=
ke"
> what you get while the VM runs.

Yes, 100% agreed.  I forgot fault->addr has the unmodified GPA, whereas fau=
lt->gfn
has the unaliased GFN. :-/

> > Outside of TDX, detecting mirrors, and anti-aliasing logic, the only us=
e of
> > kvm_gfn_direct_bits() is to constrain TDP MMU walks to the appropriate =
gfn range.
> > And for that, we can simply use kvm_mmu_page.gfn, with a kvm_x86_ops ho=
ok to get
> > the TDP MMU root GFN (root allocation is a slow path, the CALL+RET is a=
 non-issue).
> >=20
> > Compile tested only, and obviously needs to be split into multiple patc=
hes.
>=20
> Also obviously needs to be delayed to 6.17, since a working fix can be a
> one line change. :)

Ya, definitely.

> (Plus your kvm_is_gfn_alias() test which should be
> included anyway and independently).
>=20
> What do you hate less between Yan's idea above and this patch? Just tell =
me
> and I'll handle posting v2.

As much as it pains me, this version :-(

There are other things that rely on the GPA being "correct", e.g. walking t=
he
SPTEs in fast_page_fault().  So for a 6.16 fix, this is the safer and more =
complete
option.

Ugh, and the whole tdp_mmu_get_root_for_fault() handling is broken.
is_page_fault_stale() only looks at mmu->root.hpa, i.e. could theoretically=
 blow
up if the shared root is somehow valid but the mirror root is not.  Probabl=
y can't
happen in practice, but it's ugly.

Oof, and I've no idea what kvm_tdp_mmu_fast_pf_get_last_sptep() is doing.  =
It
says:

	/* Fast pf is not supported for mirrored roots  */

but I don't see anything that actually enforces that.

So tdp_mmu_get_root_for_fault() should be a generic kvm_mmu_get_root_for_fa=
ult(),
and tdp_mmu_get_root() simply shouldn't exist.

As for stuffing the correct GPA, with kvm_mmu_get_root_for_fault() being ge=
neric
and the root holding its gfn modifier, kvm_tdp_map_page() can simply OR in =
the
appropriate gfn (and maybe WARN if there's overlap?).

Something like so (on top of the other untested blob):

-----
 arch/x86/kvm/mmu/mmu.c     |  8 ++++++--
 arch/x86/kvm/mmu/spte.h    | 15 +++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++-----
 arch/x86/kvm/mmu/tdp_mmu.h | 21 ++-------------------
 4 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0228d49ac363..3bcc8d4848bd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3589,7 +3589,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, str=
uct kvm_page_fault *fault)
 		u64 new_spte;
=20
 		if (tdp_mmu_enabled)
-			sptep =3D kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, fault->gfn, &spte);
+			sptep =3D kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, fault, &spte);
 		else
 			sptep =3D fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
=20
@@ -4682,7 +4682,7 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 				struct kvm_page_fault *fault)
 {
-	struct kvm_mmu_page *sp =3D root_to_sp(vcpu->arch.mmu->root.hpa);
+	struct kvm_mmu_page *sp =3D kvm_mmu_get_root_for_fault(vcpu, fault);
=20
 	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
 	if (sp && is_obsolete_sp(vcpu->kvm, sp))
@@ -4849,6 +4849,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct =
kvm_page_fault *fault)
=20
 int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 =
*level)
 {
+	struct kvm_mmu_page *root =3D __kvm_mmu_get_root_for_fault(vcpu, error_co=
de);
 	int r;
=20
 	/*
@@ -4858,6 +4859,9 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa=
, u64 error_code, u8 *level
 	if (vcpu->arch.mmu->page_fault !=3D kvm_tdp_page_fault)
 		return -EOPNOTSUPP;
=20
+	/* Comment goes here. */
+	gpa |=3D gfn_to_gpa(root->gfn);
+
 	do {
 		if (signal_pending(current))
 			return -EINTR;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1e94f081bdaf..68e7979ac1fe 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -280,6 +280,21 @@ static inline bool is_mirror_sptep(tdp_ptep_t sptep)
 	return is_mirror_sp(sptep_to_sp(rcu_dereference(sptep)));
 }
=20
+static inline struct kvm_mmu_page *__kvm_mmu_get_root_for_fault(struct kvm=
_vcpu *vcpu,
+								u64 error_code)
+{
+	if (unlikely(kvm_is_mirror_fault(vcpu->kvm, error_code)))
+		return root_to_sp(vcpu->arch.mmu->mirror_root_hpa);
+
+	return root_to_sp(vcpu->arch.mmu->root.hpa);
+}
+
+static inline struct kvm_mmu_page *kvm_mmu_get_root_for_fault(struct kvm_v=
cpu *vcpu,
+							      struct kvm_page_fault *fault)
+{
+	return __kvm_mmu_get_root_for_fault(vcpu, fault->error_code);
+}
+
 static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
 	return (spte & shadow_mmio_mask) =3D=3D kvm->arch.shadow_mmio_value &&
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 15daf4353ccc..ecfffc6fbb73 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1240,7 +1240,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, s=
truct tdp_iter *iter,
  */
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	struct kvm_mmu_page *root =3D tdp_mmu_get_root_for_fault(vcpu, fault);
+	struct kvm_mmu_page *root =3D kvm_mmu_get_root_for_fault(vcpu, fault);
 	struct kvm *kvm =3D vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
@@ -1967,15 +1967,15 @@ EXPORT_SYMBOL_GPL(kvm_tdp_mmu_gpa_is_mapped);
  *
  * WARNING: This function is only intended to be called during fast_page_f=
ault.
  */
-u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
+u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu,
+					struct kvm_page_fault *fault,
 					u64 *spte)
 {
-	/* Fast pf is not supported for mirrored roots  */
-	struct kvm_mmu_page *root =3D tdp_mmu_get_root(vcpu, KVM_DIRECT_ROOTS);
+	struct kvm_mmu_page *root =3D kvm_mmu_get_root_for_fault(vcpu, fault);
 	struct tdp_iter iter;
 	tdp_ptep_t sptep =3D NULL;
=20
-	for_each_tdp_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
+	for_each_tdp_pte(iter, vcpu->kvm, root, fault->gfn, fault->gfn + 1) {
 		*spte =3D iter.old_spte;
 		sptep =3D iter.sptep;
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 397309dfc73f..f75888474b73 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -45,24 +45,6 @@ static inline enum kvm_tdp_mmu_root_types kvm_gfn_range_=
filter_to_root_types(str
 	return ret;
 }
=20
-static inline struct kvm_mmu_page *tdp_mmu_get_root_for_fault(struct kvm_v=
cpu *vcpu,
-							      struct kvm_page_fault *fault)
-{
-	if (unlikely(kvm_is_mirror_fault(vcpu->kvm, fault->error_code)))
-		return root_to_sp(vcpu->arch.mmu->mirror_root_hpa);
-
-	return root_to_sp(vcpu->arch.mmu->root.hpa);
-}
-
-static inline struct kvm_mmu_page *tdp_mmu_get_root(struct kvm_vcpu *vcpu,
-						    enum kvm_tdp_mmu_root_types type)
-{
-	if (unlikely(type =3D=3D KVM_MIRROR_ROOTS))
-		return root_to_sp(vcpu->arch.mmu->mirror_root_hpa);
-
-	return root_to_sp(vcpu->arch.mmu->root.hpa);
-}
-
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool f=
lush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
@@ -109,7 +91,8 @@ static inline void kvm_tdp_mmu_walk_lockless_end(void)
=20
 int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level);
-u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
+u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu,
+					struct kvm_page_fault *fault,
 					u64 *spte);
=20
 #ifdef CONFIG_X86_64

base-commit: 1abe48190d919c44e69aae17beb9e55d83db2303
--=20

