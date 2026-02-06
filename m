Return-Path: <kvm+bounces-70505-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CEoBB5U/hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70505-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:23:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6734E102AAE
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:23:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 34DEF313E145
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6295642983D;
	Fri,  6 Feb 2026 19:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ecmcRVLp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AD5428847
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770405158; cv=none; b=HneI31Ck3L5BhoxmqzzP1Ti33Bwo2ECY7ur+Hz5CRc/AIfwByFwIyNC3NsatjeJPNITCkoHTIChTUIA11A2GBqE7YolPVYjdxpE0QtFdKjnlYhzw6OVs8Mb1xgXGAG34Vbu6YrKNglwFYPnlcq4pF9knrecWZJdd0XYQaOLmYjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770405158; c=relaxed/simple;
	bh=of8K6ejpu+XJMXxrIviDrqLsKPRSz9a8vDscib5fB7U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OX8cwpeFV88xMyM1MzgcoFRtWvRPa4IJWlqrfqISsGBeay9qmUylhbiLGHE+cqifDryeCQT+CChp7UlL/psBi+1e2zBrzlvT4z1M3oSEjwzwjxRiFxPeCecF5LuSjju/kpe8BsHsU/rNpBmHi0JUcwKhYtXi+1zXaEC+uNMDWL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ecmcRVLp; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a755a780caso26444745ad.0
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 11:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770405158; x=1771009958; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i27Nzfm3RL6DQio35Z5q34bGb0u+X0D2p6VgK1vc8UU=;
        b=ecmcRVLpkoVVnvUhxmolNEi9m6z/aSR5P7Vfg+h7SNrlCKhYMrZ3zhB6L8JsCDZmPp
         l+ENcXelJJEnSU4RYjMkav2rEIW+lU0O4GbTdkV1AcPjMBAz1/UQPW9YxDrInrA2xiJ2
         wwxYqHYclmm+KhMSxrSkkI6R6tqaUeyS7MV9g/srYdoV6xZOBn6WT3QZVeNw8+EM6OtY
         zIbmTx0v3wEnjhGhu4MkU+0IAWTBwJzMnHcdQkPuFNBIBWgPDS/56X79c/YnnGUPA0Xv
         waNg2XsUve7HA9VdoVsYL2pWKB/XOFL+hZpSSabL1GWEsYctBBtMeVleqUlAk6sSVY1R
         8ZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770405158; x=1771009958;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i27Nzfm3RL6DQio35Z5q34bGb0u+X0D2p6VgK1vc8UU=;
        b=wanQGztr+m68uRYgo9tmafUCOzXjANg4+/nNdvhPY38Fjbk5GtoZaTw8JCEi8+rPkW
         6P6nfUXc5ne2woP1P09LuVJTXI/ku53j1q0cWsHREA5ed2+kOGz9VZSlK2+Nzo0GDpCD
         kwH/+pT92HEwV+K2bujhPDGTvJTAvybJFfaUJoWKrRjhxWhy5G+y7XT9kLcIYItsS1Qk
         SgsGqJJdHrU6P2WZWDkckkz/9Qm5+xlfccsMoDXMSrLv1hJDFZQ7H9nlTqKzYE06kdJF
         PA3iTlWsmP16sJkhkz2ukLDuByNXxOmRMriCxUHgYaI+rKjpyCJ1IwDkkG6EF9A8ezGU
         crzg==
X-Forwarded-Encrypted: i=1; AJvYcCXCx+rVgVImwzT4r7ucBWnfH2aD3j3O6p5wckQeUKsojQ71kUq7N0BHB6z2n/ikl1y2Aig=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMyALhINx1ol8ybRLKMAETYJG5GL/IyNqdV/HPsoFpjoKkCRCA
	dSyMwRmSuCaYuJEJfXNYeQReq1h6LUtnoqTyRqGrtlfCcOnJHYTVvNI9qRio2R3ghmDeEkpCf7r
	08H3QXA==
X-Received: from plbky6.prod.google.com ([2002:a17:902:f986:b0:2a7:7341:6f57])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b4e:b0:2a7:90f2:2ded
 with SMTP id d9443c01a7336-2a951948e52mr40133305ad.16.1770405157781; Fri, 06
 Feb 2026 11:12:37 -0800 (PST)
Date: Fri, 6 Feb 2026 11:12:36 -0800
In-Reply-To: <CALMp9eTJAD4Dc88egovSjV-N2YHd8G80ZP-dL5wXFDAC+WR6fA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com> <20260205214326.1029278-3-jmattson@google.com>
 <aYYwwWjMDJQh6uDd@google.com> <fb750b1bb21bd47f85eb133d69b2c059188f4c05@linux.dev>
 <CALMp9eTJAD4Dc88egovSjV-N2YHd8G80ZP-dL5wXFDAC+WR6fA@mail.gmail.com>
Message-ID: <aYY9JOMDBPDY48lA@google.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70505-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: 6734E102AAE
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Jim Mattson wrote:
> On Fri, Feb 6, 2026 at 10:23=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.de=
v> wrote:
> >
> > February 6, 2026 at 10:19 AM, "Sean Christopherson" <seanjc@google.com>=
 wrote:
> >
> >
> > >
> > > On Thu, Feb 05, 2026, Jim Mattson wrote:
> > >
> > > >
> > > > Cache g_pat from vmcb12 in svm->nested.gpat to avoid TOCTTOU issues=
, and
> > > >  add a validity check so that when nested paging is enabled for vmc=
b12, an
> > > >  invalid g_pat causes an immediate VMEXIT with exit code VMEXIT_INV=
ALID, as
> > > >  specified in the APM, volume 2: "Nested Paging and VMRUN/VMEXIT."
> > > >
> > > >  Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
> > > >  Signed-off-by: Jim Mattson <jmattson@google.com>
> > > >  ---
> > > >  arch/x86/kvm/svm/nested.c | 4 +++-
> > > >  arch/x86/kvm/svm/svm.h | 3 +++
> > > >  2 files changed, 6 insertions(+), 1 deletion(-)
> > > >
> > > >  diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > >  index f72dbd10dcad..1d4ff6408b34 100644
> > > >  --- a/arch/x86/kvm/svm/nested.c
> > > >  +++ b/arch/x86/kvm/svm/nested.c
> > > >  @@ -1027,9 +1027,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> > > >
> > > >  nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
> > > >  nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> > > >  + svm->nested.gpat =3D vmcb12->save.g_pat;
> > > >
> > > >  if (!nested_vmcb_check_save(vcpu) ||
> > > >  - !nested_vmcb_check_controls(vcpu)) {
> > > >  + !nested_vmcb_check_controls(vcpu) ||
> > > >  + (nested_npt_enabled(svm) && !kvm_pat_valid(svm->nested.gpat))) {
> > > >  vmcb12->control.exit_code =3D SVM_EXIT_ERR;
> > > >  vmcb12->control.exit_info_1 =3D 0;
> > > >  vmcb12->control.exit_info_2 =3D 0;
> > > >  diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > >  index 986d90f2d4ca..42a4bf83b3aa 100644
> > > >  --- a/arch/x86/kvm/svm/svm.h
> > > >  +++ b/arch/x86/kvm/svm/svm.h
> > > >  @@ -208,6 +208,9 @@ struct svm_nested_state {
> > > >  */
> > > >  struct vmcb_save_area_cached save;
> > > >
> > > >  + /* Cached guest PAT from vmcb12.save.g_pat */
> > > >  + u64 gpat;
> > > >
> > > Shouldn't this go in vmcb_save_area_cached?
> >
> > I believe Jim changed it after this discussion on v2: https://lore.kern=
el.org/kvm/20260115232154.3021475-4-jmattson@google.com/.

LOL, oh the irony:

  I'm going to cache it on its own to avoid confusion.

> Right. The two issues with putting it in vmcb_save_area_cached were:
>=20
> 1. Checking all of vmcb_save_area_cached requires access to the
> corresponding control area (or at least the boolean, "NTP enabled.")

Checking the control area seems like the right answer (I went down that pat=
h
before reading this).

> 2. In the nested state serialization payload, everything else in the
> vmcb_save_area_cached comes from L1 (host state to be restored at
> emulated #VMEXIT.)

Hmm, right, but *because* it's ignored, that gives us carte blanche to clob=
ber it.
More below.

> The first issue was a little messy, but not that distasteful.

I actually find it the opposite of distasteful.  KVM definitely _should_ be
checking the controls, not the vCPU state.  If it weren't for needing to ge=
t at
MAXPHYADDR in CPUID, I'd push to drop @vcpu entirely.

> The second issue was really a mess.

I'd rather have the mess contained and document though.  Caching g_pat outs=
ide
of vmcb_save_area_cached bleeds the mess into all of the relevant nSVM code=
, and
doesn't leave any breadcrumbs in the code/comments to explain that it "need=
s" to
be kept separate.

AFAICT, the only "problem" is that g_pat in the serialization payload will =
be
garbage when restoring state from an older KVM.  But that's totally fine, p=
recisely
because L1's PAT isn't restored from vmcb01 on nested #VMEXIT, it's always =
resident
in vcpu->arch.pat.  So can't we just do this to avoid a spurious -EINVAL?

	/*
	 * Validate host state saved from before VMRUN (see
	 * nested_svm_check_permissions).
	 */
	__nested_copy_vmcb_save_to_cache(&save_cached, save);

	/*
	 * Stuff gPAT in L1's save state, as older KVM may not have saved L1's
	 * gPAT.  L1's PAT, i.e. hPAT for the vCPU, is *always* tracked in
	 * vcpu->arch.pat, i.e. gPAT is a reflection of vcpu->arch.pat, not the
	 * other way around.
	 */
	save_cached.g_pat =3D vcpu->arch.pat;

	if (!(save->cr0 & X86_CR0_PG) ||
	    !(save->cr0 & X86_CR0_PE) ||
	    (save->rflags & X86_EFLAGS_VM) ||
	    !nested_vmcb_check_save(vcpu, &ctl_cached, &save_cached))
		goto out_free;

Oh, and if we do plumb in @ctrl to __nested_vmcb_check_save(), I vote to
opportunistically drop the useless single-use wrappers (probably in a stand=
alone
patch to plumb in @ctrl).  E.g. (completely untested)

---
 arch/x86/kvm/svm/nested.c | 71 ++++++++++++++++++---------------------
 arch/x86/kvm/svm/svm.c    |  2 +-
 arch/x86/kvm/svm/svm.h    |  6 ++--
 3 files changed, 35 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a7d6fc1382a7..a429947c8966 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -339,8 +339,8 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu =
*vcpu, u64 pa, u32 size)
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
=20
-static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
-					 struct vmcb_ctrl_area_cached *control)
+static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
+				       struct vmcb_ctrl_area_cached *control)
 {
 	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
 		return false;
@@ -367,8 +367,9 @@ static bool __nested_vmcb_check_controls(struct kvm_vcp=
u *vcpu,
 }
=20
 /* Common checks that apply to both L1 and L2 state.  */
-static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
-				     struct vmcb_save_area_cached *save)
+static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
+				   struct vmcb_ctrl_area_cached *ctrl,
+				   struct vmcb_save_area_cached *save)
 {
 	if (CC(!(save->efer & EFER_SVME)))
 		return false;
@@ -399,25 +400,13 @@ static bool __nested_vmcb_check_save(struct kvm_vcpu =
*vcpu,
 	if (CC(!kvm_valid_efer(vcpu, save->efer)))
 		return false;
=20
+	if (CC(ctrl->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
+	       !kvm_pat_valid(save->g_pat))
+		return false;
+
 	return true;
 }
=20
-static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm =3D to_svm(vcpu);
-	struct vmcb_save_area_cached *save =3D &svm->nested.save;
-
-	return __nested_vmcb_check_save(vcpu, save);
-}
-
-static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm =3D to_svm(vcpu);
-	struct vmcb_ctrl_area_cached *ctl =3D &svm->nested.ctl;
-
-	return __nested_vmcb_check_controls(vcpu, ctl);
-}
-
 /*
  * If a feature is not advertised to L1, clear the corresponding vmcb12
  * intercept.
@@ -504,6 +493,9 @@ static void __nested_copy_vmcb_save_to_cache(struct vmc=
b_save_area_cached *to,
=20
 	to->dr6 =3D from->dr6;
 	to->dr7 =3D from->dr7;
+
+	to->g_pat =3D from->g_pat;
+
 }
=20
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
@@ -644,17 +636,14 @@ static void nested_vmcb02_prepare_save(struct vcpu_sv=
m *svm, struct vmcb *vmcb12
 		svm->nested.force_msr_bitmap_recalc =3D true;
 	}
=20
-	if (npt_enabled) {
-		if (nested_npt_enabled(svm)) {
-			if (unlikely(new_vmcb12 ||
-				     vmcb_is_dirty(vmcb12, VMCB_NPT))) {
-				vmcb02->save.g_pat =3D svm->nested.gpat;
-				vmcb_mark_dirty(vmcb02, VMCB_NPT);
-			}
-		} else {
-			vmcb02->save.g_pat =3D vcpu->arch.pat;
+	if (nested_npt_enabled(svm)) {
+		if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_NPT))) {
+			vmcb02->save.g_pat =3D svm->nested.save.g_pat;
 			vmcb_mark_dirty(vmcb02, VMCB_NPT);
 		}
+	} else if (npt_enabled) {
+		vmcb02->save.g_pat =3D vcpu->arch.pat;
+		vmcb_mark_dirty(vmcb02, VMCB_NPT);
 	}
=20
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
@@ -1028,11 +1017,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
=20
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
-	svm->nested.gpat =3D vmcb12->save.g_pat;
=20
-	if (!nested_vmcb_check_save(vcpu) ||
-	    !nested_vmcb_check_controls(vcpu) ||
-	    (nested_npt_enabled(svm) && !kvm_pat_valid(svm->nested.gpat))) {
+	if (!nested_vmcb_check_save(vcpu, &svm->nested.ctl, &svm->nested.save) ||
+	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
 		vmcb12->control.exit_code    =3D SVM_EXIT_ERR;
 		vmcb12->control.exit_info_1  =3D 0;
 		vmcb12->control.exit_info_2  =3D 0;
@@ -1766,7 +1753,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu=
,
 		kvm_state.hdr.svm.vmcb_pa =3D svm->nested.vmcb12_gpa;
 		if (nested_npt_enabled(svm)) {
 			kvm_state.hdr.svm.flags |=3D KVM_STATE_SVM_VALID_GPAT;
-			kvm_state.hdr.svm.gpat =3D svm->nested.gpat;
+			kvm_state.hdr.svm.gpat =3D svm->nested.save.g_pat;
 		}
 		kvm_state.size +=3D KVM_STATE_NESTED_SVM_VMCB_SIZE;
 		kvm_state.flags |=3D KVM_STATE_NESTED_GUEST_MODE;
@@ -1871,7 +1858,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu=
,
=20
 	ret =3D -EINVAL;
 	__nested_copy_vmcb_control_to_cache(vcpu, &ctl_cached, ctl);
-	if (!__nested_vmcb_check_controls(vcpu, &ctl_cached))
+	if (!nested_vmcb_check_controls(vcpu, &ctl_cached))
 		goto out_free;
=20
 	/*
@@ -1887,15 +1874,21 @@ static int svm_set_nested_state(struct kvm_vcpu *vc=
pu,
 	 * nested_svm_check_permissions).
 	 */
 	__nested_copy_vmcb_save_to_cache(&save_cached, save);
+
+	/*
+	 * Stuff gPAT in L1's save state, as older KVM may not have saved L1's
+	 * gPAT.  L1's PAT, i.e. hPAT for the vCPU, is *always* tracked in
+	 * vcpu->arch.pat, i.e. hPAT is a reflection of vcpu->arch.pat, not the
+	 * other way around.
+	 */
+	save_cached.g_pat =3D vcpu->arch.pat;
+
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
-	    !__nested_vmcb_check_save(vcpu, &save_cached))
+	    !nested_vmcb_check_save(vcpu, &ctl_cached, &save_cached))
 		goto out_free;
=20
-	/*
-	 * Validate gPAT, if provided.
-	 */
 	if ((kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT) &&
 	    !kvm_pat_valid(kvm_state->hdr.svm.gpat))
 		goto out_free;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a6a44deec82b..bf8562a5f655 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2862,7 +2862,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct =
msr_data *msr_info)
 		WARN_ON_ONCE(msr_info->host_initiated && vcpu->wants_to_run);
 		if (!msr_info->host_initiated && is_guest_mode(vcpu) &&
 		    nested_npt_enabled(svm))
-			msr_info->data =3D svm->nested.gpat;
+			msr_info->data =3D svm->nested.save.g_pat;
 		else
 			msr_info->data =3D vcpu->arch.pat;
 		break;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a559cd45c8a9..6f07d8e3f06e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -146,6 +146,7 @@ struct vmcb_save_area_cached {
 	u64 cr0;
 	u64 dr7;
 	u64 dr6;
+	u64 g_pat;
 };
=20
 struct vmcb_ctrl_area_cached {
@@ -208,9 +209,6 @@ struct svm_nested_state {
 	 */
 	struct vmcb_save_area_cached save;
=20
-	/* Cached guest PAT from vmcb12.save.g_pat */
-	u64 gpat;
-
 	bool initialized;
=20
 	/*
@@ -599,7 +597,7 @@ static inline bool nested_npt_enabled(struct vcpu_svm *=
svm)
=20
 static inline void svm_set_gpat(struct vcpu_svm *svm, u64 data)
 {
-	svm->nested.gpat =3D data;
+	svm->nested.save.g_pat =3D data;
 	svm_set_vmcb_gpat(svm->nested.vmcb02.ptr, data);
 }
=20

base-commit: 6461c50e232d6f81d5b9604236f7ee3df870e932
--=20

