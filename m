Return-Path: <kvm+bounces-71199-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sF4hKob5lGktJgIAu9opvQ
	(envelope-from <kvm+bounces-71199-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 00:28:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A5BB151ECF
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 00:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 27841304AC13
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 23:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187C83090EE;
	Tue, 17 Feb 2026 23:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UozcoO6g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEE22EDD50
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 23:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370879; cv=none; b=sXBMEMPe4FKmxn0vqW3qtNzfoewWQitpPgF1ragHUmszP/qiJWfKRFDxgvFRD05VmPcIgF6iZfvTQssuoAwiKrYJqt34bQNtF4u+OYCpMCzWYnrxZlz4tRubLuUL57flL8dYDpqGGmQpFKZ70SgeEEvgAaToK7/myml8YmhRsyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370879; c=relaxed/simple;
	bh=j+XzuPdbmTm5dTJykXMljs1HvLFtccXg5tafPS5P3bY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pZMLVUqRgPYg3Bn1Ck0M9NdD8e+n8KJt8kAoY1a6W1nDlyiqF4leC5pDSphcxYO0JGXTkH549OpFMCKA5ty9xievx8VtjD9fZj/UnDdSFpczfO02zaCda1x2/2Xgtp16Ud8SsH9JjkRAaY0fuT5l0XQvWnYVEd+rVeQTKcbLRB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UozcoO6g; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6de0bd0896so16028418a12.1
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 15:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771370876; x=1771975676; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5X5KS6rCju+8fHQdzpBX7hCsqBgb5Dp642p6kUU+O1c=;
        b=UozcoO6gVvD2wzqjO9ETcbTgnBgBxdD2FNBcIkOIqh7G4nCnAJWMQmJkNj+IZZnzcL
         EEOFygbHFPvR9q0vHrqFmN56EQDkWHdaavC5USPXPNBrHTZXbSO09YhCwv+sFRgsowB0
         aKn5aUyH1AvVXIzroeo4yuMCPk7opyZNU6TLJmbrogoNI4TJWD5Z+nGaTXUactoRvtDP
         Mz4sN7kMqJLbZhyz3x9H5NN/hw5MYwkPSxTspvDRPpixl81wPX7Qby9VOiKI36XWJaCR
         gQUxy2KAjwYrLahroCj/QkIgwlBbRgDM1orNW/SsGcoa48ly9/UWmB5a7uxAvodXfks+
         oqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771370876; x=1771975676;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5X5KS6rCju+8fHQdzpBX7hCsqBgb5Dp642p6kUU+O1c=;
        b=dBXidqWOgIk1TfydCqMoYsCUY7oCGNkL8aLpjc0vve+fnB31dEipp9iauLX7bzJqW8
         5tC3VR3432PAFOYK4FZN0u3Ql22sb9VLXAtRz2xXnhwDcJioQR9nvyqRm01F8Nt2QLN5
         9lNOekksriWP3NlNh8/bJNpFKS0VDmrVg+tVrMUagRhkD42PAn/dcAzYsUTCe5QL6/nc
         H35JPGxZpa6cziN4hOk8TE1x30isixDMsTyrwbV4xyjSq4K5yLt67II0DYbVbJXjivfE
         UB9NXZGJk9l0Cj598vuF6i74586x/1rRcCz25zfqu739GoKfaD2RW4wY1I3IesI42uUj
         DwHA==
X-Forwarded-Encrypted: i=1; AJvYcCVnIAUNABL+K3bB3cg18D8VVJSKZbIvkjkb10szspYsd/8DKOJ9hco0cTNSxWLEEAeDxXY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgyM8A3n48M/oDU6HNKOfNn54a8R5Iz9i1XoaIOVq4rIhuogc2
	QB/R65pB6BhSGmSp4lBg2RD2y1/oRfs0x6hwx0kgF8vNNwp2t5rHYheOPGWCQeHKH65SALAAwyA
	IHkEOig==
X-Received: from pgc10.prod.google.com ([2002:a05:6a02:2f8a:b0:c6e:1a85:93a6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:6702:b0:38e:90ca:5a2b
 with SMTP id adf61e73a8af0-39483940fb7mr11214658637.17.1771370876144; Tue, 17
 Feb 2026 15:27:56 -0800 (PST)
Date: Tue, 17 Feb 2026 15:27:54 -0800
In-Reply-To: <CALMp9eTnXW9=0=+RxQjeXfA++UP3MX0LzXo5qwUP-dCCQjOLVQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com> <20260212155905.3448571-5-jmattson@google.com>
 <gqj4y6awen5dfxy32lbskcxw6xdv4xiiouycyftjacndjinhvp@7p4dtgdh6tjw>
 <aY9BPKhzgxo4UuHB@google.com> <CALMp9eR4ayj_gwsDQVH8pQvzqgEYVB6ExWp3aFgJXRWikLEikw@mail.gmail.com>
 <aY-jViitsLQm9B83@google.com> <CALMp9eTnXW9=0=+RxQjeXfA++UP3MX0LzXo5qwUP-dCCQjOLVQ@mail.gmail.com>
Message-ID: <aZT5eldlkLpRm7OD@google.com>
Subject: Re: [PATCH v4 4/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
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
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71199-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6A5BB151ECF
X-Rspamd-Action: no action

On Fri, Feb 13, 2026, Jim Mattson wrote:
> On Fri, Feb 13, 2026 at 2:19=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > > > > +           vmcb_set_gpat(svm->vmcb01.ptr, data);
> > > > > > +           if (is_guest_mode(&svm->vcpu) && !nested_npt_enable=
d(svm))
> > > > > > +                   vmcb_set_gpat(svm->nested.vmcb02.ptr, data)=
;
> > > > > > +   }
> > > > > > +}
> > > > >
> > > > > Is it me, or is it a bit confusing that svm_set_gpat() sets L2's =
gPAT
> > > > > not L1's, and svm_set_hpat() calls vmcb_set_gpat()?
> > > >
> > > > It's not just you.  I don't find it confusing per se, more that it'=
s really
> > > > subtle.
> > > >
> > > > > "gpat" means different things in the context of the VMCB or other=
wise,
> > > > > which kinda makes sense but is also not super clear. Maybe
> > > > > svm_set_l1_gpat() and svm_set_l2_gpat() is more clear?
> > > >
> > > > I think just svm_set_l1_pat() and svm_set_l2_pat(), because gpat st=
raight up
> > > > doesn't exist when NPT is disabled/unsupported.
> > >
> > > My intention was that "gpat" and "hpat" were from the perspective of =
the vCPU.
> > >
> > > I dislike svm_set_l1_pat() and svm_set_l2_pat(). As you point out
> > > above, there is no independent L2 PAT when nested NPT is disabled. I
> > > think that's less obvious than the fact that there is no gPAT from th=
e
> > > vCPU's perspective. My preference is to follow the APM terminology
> > > when possible. Making up our own terms just leads to confusion.
> >
> > How about svm_set_pat() and svm_get_gpat()?  Because hPAT doesn't exist=
 when NPT
> > is unsupported/disabled, but KVM still needs to set the vCPU's emulated=
 PAT value.
>=20
> What if we don't break it up this way at all? Instead of distributing
> the logic between svm_[gs]set_msr() and a few helper functions, we
> could just have svm_[gs]et_msr() call svm_[gs]et_pat(), and all of the
> logic can go in these two functions.

I like it.  And AFAICT it largely Just Works, because the calls from
svm_set_nested_state() will always be routed to gpat since the calls are al=
ready
guarded with is_guest_mode() + nested_npt_enabled().

Side topic, either as a prep patch (to duplicate code) or as a follow-up pa=
tch
(to move the PAT handling in x86.c to vmx.c), the "common" handling of PAT =
should
be fully forked between VMX and SVM.  As of this patch, it's not just misle=
ading,
it's actively dangerous since calling kvm_get_msr_common() for SVM would ge=
t the
wrong value.

FWIW, this is what I ended up with when hacking on top of your patches to s=
ee how
this played out.

---
 arch/x86/kvm/svm/nested.c |  4 +--
 arch/x86/kvm/svm/svm.c    | 64 +++++++++++++++++++++++++--------------
 arch/x86/kvm/svm/svm.h    | 19 +-----------
 arch/x86/kvm/vmx/vmx.c    | 10 ++++--
 arch/x86/kvm/x86.c        |  9 ------
 5 files changed, 51 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d854d29b0bd8..361f189d3967 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -2075,9 +2075,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu=
,
=20
 	if (nested_npt_enabled(svm)) {
 		if (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT) {
-			svm_set_gpat(svm, kvm_state->hdr.svm.gpat);
+			svm_set_pat(vcpu, kvm_state->hdr.svm.gpat, true);
 		} else {
-			svm_set_gpat(svm, vcpu->arch.pat);
+			svm_set_pat(vcpu, vcpu->arch.pat, true);
 			svm->nested.legacy_gpat_semantics =3D true;
 		}
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 93ce0c3232c6..94c3b3cadd54 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -251,6 +251,44 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	return 0;
 }
=20
+static bool svm_is_access_to_gpat(struct kvm_vcpu *vcpu, bool host_initiat=
ed)
+{
+	/*
+	 * When nested NPT is enabled, L2 has a separate PAT from L1.  Guest
+	 * accesses to IA32_PAT while running L2 target L2's gPAT;
+	 * host-initiated accesses always target L1's hPAT for backward and
+	 * forward KVM_SET_MSRS compatibility with older kernels.
+	 */
+	WARN_ON_ONCE(host_initiated && vcpu->wants_to_run);
+
+	return !host_initiated && is_guest_mode(vcpu) &&
+	       nested_npt_enabled(to_svm(vcpu));
+}
+
+void svm_set_pat(struct kvm_vcpu *vcpu, u64 pat, bool host_initiated)
+{
+	struct vcpu_svm *svm =3D to_svm(vcpu);
+
+	if (svm_is_access_to_gpat(vcpu, host_initiated)) {
+		vmcb_set_gpat(svm->nested.vmcb02.ptr, pat);
+		return;
+	}
+
+	svm->vcpu.arch.pat =3D pat;
+
+	if (!npt_enabled)
+		return;
+
+	vmcb_set_gpat(svm->vmcb01.ptr, pat);
+
+	if (svm->nested.legacy_gpat_semantics) {
+		svm->nested.save.g_pat =3D pat;
+		vmcb_set_gpat(svm->nested.vmcb02.ptr, pat);
+	} else if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm)) {
+		vmcb_set_gpat(svm->nested.vmcb02.ptr, pat);
+	}
+}
+
 static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
@@ -2838,16 +2876,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct=
 msr_data *msr_info)
 		msr_info->data =3D svm->msr_decfg;
 		break;
 	case MSR_IA32_CR_PAT:
-		/*
-		 * When nested NPT is enabled, L2 has a separate PAT from
-		 * L1.  Guest accesses to IA32_PAT while running L2 target
-		 * L2's gPAT; host-initiated accesses always target L1's
-		 * hPAT for backward and forward KVM_GET_MSRS compatibility
-		 * with older kernels.
-		 */
-		WARN_ON_ONCE(msr_info->host_initiated && vcpu->wants_to_run);
-		if (!msr_info->host_initiated && is_guest_mode(vcpu) &&
-		    nested_npt_enabled(svm))
+		if (svm_is_access_to_gpat(vcpu, msr_info->host_initiated))
 			msr_info->data =3D svm->nested.save.g_pat;
 		else
 			msr_info->data =3D vcpu->arch.pat;
@@ -2937,19 +2966,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct=
 msr_data *msr)
 	case MSR_IA32_CR_PAT:
 		if (!kvm_pat_valid(data))
 			return 1;
-		/*
-		 * When nested NPT is enabled, L2 has a separate PAT from
-		 * L1.  Guest accesses to IA32_PAT while running L2 target
-		 * L2's gPAT; host-initiated accesses always target L1's
-		 * hPAT for backward and forward KVM_SET_MSRS compatibility
-		 * with older kernels.
-		 */
-		WARN_ON_ONCE(msr->host_initiated && vcpu->wants_to_run);
-		if (!msr->host_initiated && is_guest_mode(vcpu) &&
-		    nested_npt_enabled(svm))
-			svm_set_gpat(svm, data);
-		else
-			svm_set_hpat(svm, data);
+
+		svm_set_pat(vcpu, data, msr->host_initiated);
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0bb9fdcb489d..71502db3f679 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -616,24 +616,6 @@ static inline bool nested_npt_enabled(struct vcpu_svm =
*svm)
 	return svm->nested.ctl.misc_ctl & SVM_MISC_ENABLE_NP;
 }
=20
-static inline void svm_set_gpat(struct vcpu_svm *svm, u64 data)
-{
-	svm->nested.save.g_pat =3D data;
-	vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
-}
-
-static inline void svm_set_hpat(struct vcpu_svm *svm, u64 data)
-{
-	svm->vcpu.arch.pat =3D data;
-	if (npt_enabled) {
-		vmcb_set_gpat(svm->vmcb01.ptr, data);
-		if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm))
-			vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
-	}
-	if (svm->nested.legacy_gpat_semantics)
-		svm_set_gpat(svm, data);
-}
-
 static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
 {
 	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_VNMI) &&
@@ -780,6 +762,7 @@ void svm_enable_lbrv(struct kvm_vcpu *vcpu);
 void svm_update_lbrv(struct kvm_vcpu *vcpu);
=20
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
+void svm_set_pat(struct kvm_vcpu *vcpu, u64 pat, bool host_initiated);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void disable_nmi_singlestep(struct vcpu_svm *svm);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 967b58a8ab9d..546056e690eb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2141,6 +2141,9 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_dat=
a *msr_info)
 #endif
 	case MSR_EFER:
 		return kvm_get_msr_common(vcpu, msr_info);
+	case MSR_IA32_CR_PAT:
+		msr_info->data =3D vcpu->arch.pat;
+		break;
 	case MSR_IA32_TSX_CTRL:
 		if (!msr_info->host_initiated &&
 		    !(vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR))
@@ -2468,9 +2471,10 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_da=
ta *msr_info)
 			return 1;
 		goto find_uret_msr;
 	case MSR_IA32_CR_PAT:
-		ret =3D kvm_set_msr_common(vcpu, msr_info);
-		if (ret)
-			break;
+		if (!kvm_pat_valid(data))
+			return 1;
+
+		vcpu->arch.pat =3D data;
=20
 		if (is_guest_mode(vcpu) &&
 		    get_vmcs12(vcpu)->vm_exit_controls & VM_EXIT_SAVE_IA32_PAT)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 416899b5dbe4..41936f83a17f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4025,12 +4025,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct=
 msr_data *msr_info)
 			return 1;
 		}
 		break;
-	case MSR_IA32_CR_PAT:
-		if (!kvm_pat_valid(data))
-			return 1;
-
-		vcpu->arch.pat =3D data;
-		break;
 	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
 	case MSR_MTRRdefType:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
@@ -4436,9 +4430,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct =
msr_data *msr_info)
 		msr_info->data =3D kvm_scale_tsc(rdtsc(), ratio) + offset;
 		break;
 	}
-	case MSR_IA32_CR_PAT:
-		msr_info->data =3D vcpu->arch.pat;
-		break;
 	case MSR_MTRRcap:
 	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
 	case MSR_MTRRdefType:

base-commit: 7539434a6984ba5accfdd8e296fb834558f95df4
--

