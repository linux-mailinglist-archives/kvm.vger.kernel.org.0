Return-Path: <kvm+bounces-72440-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBkpLOQbpmmeKQAAu9opvQ
	(envelope-from <kvm+bounces-72440-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:23:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B059B1E68E9
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:23:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4F1F13034B11
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 23:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 825B133557D;
	Mon,  2 Mar 2026 23:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sCniXRCB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8066A33065B
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 23:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772493471; cv=none; b=qI/QRcI8uxOhgSPz1HuPD9Ecibwt8HH690xeOZ53a6bVGgktFhxquWGULHAUF9NhD2k2Qok/TOpsYxyF5gAqAFE4eicufoUeN2wSFzRvXhsCS6Qi0b2RMRgMMkRyYgTi6sSt0PEHo5kKbQsHT0bg0yt02/QSEXzLPxwT96LRIv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772493471; c=relaxed/simple;
	bh=ocAtI1kZGa+/ktPCczNLQa57U50S+zwqLdt1httVV9E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ok390Mmbtco+dzc1HTgjV25YUlaXnMHj+4rBQZvFzn6b3LEt3WJIO2febVBJoRuM+4Z1VWRMGGv2FYtA81irx2eiVe+OdvoId8SqYuiPMde113o1drtVk6SHsycaXkMc0czxmwDT0Rk+bm22c4Hta3Gm4SDe7dhwJ0Qa0UpL2eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sCniXRCB; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae4cdfc468so16137585ad.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 15:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772493470; x=1773098270; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tkge+t3JLt0D6N9vfdbJAndADT3GFnOTbaLC6A3Y5eI=;
        b=sCniXRCBgDUWdScLrKSaBGTLdqS8spr+dACFF8afl1G6+uD10DTGIqbU7vm5w6rT9d
         0lVr4ukNPjf60dyxjPO/bli/HxiIWBqNceClDHwpn8fQTo4jR6dULROQU/QqZIU0JoZb
         ArPxwgWLGBgBBrtP5grzQ6PiOZiYotGY3q+lIZ6KNBLdO7CNCB8QLn+sUmXkaXdixdpf
         FsdHdH5rVx2wtYf4fBjJveu6YJzS8YT3OxDgo0B+kEZHmVhOppP5cvSOjYks1K/JsiLs
         W6pJ2Mhffz+0mpCM/wxwPHlXmOSUQOSEQS8l9TDHA8Bl/f1Fa6NtVlAWduACJc47OMaL
         SDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772493470; x=1773098270;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tkge+t3JLt0D6N9vfdbJAndADT3GFnOTbaLC6A3Y5eI=;
        b=TMt+tIdRES6qtqaKSfvwp0YYE7nVHQeOATrzIlF9Sul4gqpFQwIx/QbGCXPLd8/287
         mMNb1mdazJZHQC+qIzr/Z2Nw6U2FTHPsUitzHqszQ8s0hSY/ZUUmFmH+kvlG8FUwwkeL
         q0AfLJvrDg9XNCNLPaKwpPnHRQxsAKI/SrHnEG7+R/r9If2VJF9j/96x3jlU8mBoYILK
         y+xTiA3J0jq7gtB/8/2sD5BFCpsgGr2Po4dp+YAFHwRPi76Ht8mjtKLjeif7/Y80FkOl
         ewI9c3SKEedGeA8uPBUSVrRllcTGo327drSXcPAxn3l5LrBhCQj3bYXGoZ1Tiv2k021c
         kLrg==
X-Forwarded-Encrypted: i=1; AJvYcCW4HbwfT9EiVHhh6oeK6AhLEFCI6J0vzttVQFRL/cz0seK7w0EU4jr+Pf/OgLs2osr2zPE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx5kqAfIewxU8vlpMPD2kCRr+sAp9uf1pSik3gLm4QFbRjAgKh
	m12QIDdBiWTXkIPk6ZR7Gj1B1pZZSwESHuVRaVGx4f3QPfz1DJLJIvAnOePxBhq7INbLWzSWyty
	Ah9G0pg==
X-Received: from pgh14.prod.google.com ([2002:a05:6a02:4e0e:b0:c66:6f4:1028])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d492:b0:392:e6c3:7426
 with SMTP id adf61e73a8af0-395c3b3de45mr13412191637.62.1772493469493; Mon, 02
 Mar 2026 15:17:49 -0800 (PST)
Date: Mon, 2 Mar 2026 15:17:48 -0800
In-Reply-To: <aaXXs4ubgmxf_E1O@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com> <CAO9r8zODn_ZGHsftsj0B6dJe9jy8sVZwdOgFi=ebZoHfGrWxXw@mail.gmail.com>
 <aaXXs4ubgmxf_E1O@google.com>
Message-ID: <aaYanA9WBSZWjQ8Y@google.com>
Subject: Re: [PATCH V4 0/4] Align SVM with APM defined behaviors
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B059B1E68E9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72440-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026, Sean Christopherson wrote:
> On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> > On Fri, Feb 27, 2026 at 7:33=E2=80=AFPM Kevin Cheng <chengkev@google.co=
m> wrote:
> > >
> > > The APM lists the following behaviors
> > >   - The VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and INVLPGA instruction=
s
> > >     can be used when the EFER.SVME is set to 1; otherwise, these
> > >     instructions generate a #UD exception.
> > >   - If VMMCALL instruction is not intercepted, the instruction raises=
 a
> > >     #UD exception.
> > >
> > > The patches in this series fix current SVM bugs that do not adhere to
> > > the APM listed behaviors.
> > >
> > > v3 -> v4:
> > >   - Dropped "KVM: SVM: Inject #UD for STGI if EFER.SVME=3D0 and SVM L=
ock
> > >     and DEV are not available" as per Sean
> > >   - Added back STGI and CLGI intercept clearing in init_vmcb to maint=
ain
> > >     previous behavior on intel guests. Previously intel guests always
> > >     had STGI and CLGI intercepts cleared if vgif was enabled. In V3,
> > >     because the clearing of the intercepts was moved from init_vmcb()=
 to
> > >     the !guest_cpuid_is_intel_compatible() case in
> > >     svm_recalc_instruction_intercepts(), the CLGI intercept would be
> > >     indefinitely set on intel guests. I added back the clearing to
> > >     init_vmcb() to retain intel guest behavior before this patch.
> >=20
> > I am a bit confused by this. v4 kept initializing the intercepts as
> > cleared for all guests, but we still set the CLGI/STGI intercepts for
> > Intel-compatible guests in svm_recalc_instruction_intercepts() patch
> > 3. So what difference did this make?
> >=20
> > Also taking a step back, I am not really sure what's the right thing
> > to do for Intel-compatible guests here. It also seems like even if we
> > set the intercept, svm_set_gif() will clear the STGI intercept, even
> > on Intel-compatible guests.
> >=20
> > Maybe we should leave that can of worms alone, go back to removing
> > initializing the CLGI/STGI intercepts in init_vmcb(), and in
> > svm_recalc_instruction_intercepts() set/clear these intercepts based
> > on EFER.SVME alone, irrespective of Intel-compatibility?
>=20
> Ya, guest_cpuid_is_intel_compatible() should only be applied to VMLOAD/VM=
SAVE.
> KVM intercepts VMLOAD/VMSAVE to fixup SYSENTER MSRs, not to inject #UD.  =
I.e. KVM
> is handling (the absoutely absurd) case that FMS reports an Intel CPU, bu=
t the
> guest enables and uses SVM.
>=20
> 	/*
> 	 * Intercept VMLOAD if the vCPU model is Intel in order to emulate that
> 	 * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that exposing
> 	 * SVM on Intel is bonkers and extremely unlikely to work).
> 	 */
> 	if (guest_cpuid_is_intel_compatible(vcpu))
> 		guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
>=20
> Sorry for not catching this in previous versions.

Because I got all kinds of confused trying to recall what was different bet=
ween
v3 and v4, I went ahead and spliced them together.

Does the below look right?  If so, I'll formally post just patches 1 and 3 =
as v5.
I'll take 2 and 4 directly from here; I want to switch the ordering anyways=
 so
that the vgif movement immediately precedes the Recalc "instructions" patch=
.

	/*
	 * Intercept instructions that #UD if EFER.SVME=3D0, as SVME must be set
	 * even when running the guest, i.e. hardware will only ever see
	 * EFER.SVME=3D1.
	 *
	 * No need to toggle any of the vgif/vls/etc. enable bits here, as they
	 * are set when the VMCB is initialized and never cleared (if the
	 * relevant intercepts are set, the enablements are meaningless anyway).
	 */
	if (!(vcpu->arch.efer & EFER_SVME)) {
		svm_set_intercept(svm, INTERCEPT_VMLOAD);
		svm_set_intercept(svm, INTERCEPT_VMSAVE);
		svm_set_intercept(svm, INTERCEPT_CLGI);
		svm_set_intercept(svm, INTERCEPT_STGI);
	} else {
		/*
		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
		 * in VMCB and clear intercepts to avoid #VMEXIT.
		 */
		if (guest_cpuid_is_intel_compatible(vcpu)) {
			svm_set_intercept(svm, INTERCEPT_VMLOAD);
			svm_set_intercept(svm, INTERCEPT_VMSAVE);
		} else if (vls) {
			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
		}

		/*
		 * Process pending events when clearing STGI/CLGI intercepts if
		 * there's at least one pending event that is masked by GIF, so
		 * that KVM re-evaluates if the intercept needs to be set again
		 * to track when GIF is re-enabled (e.g. for NMI injection).
		 */
		if (vgif) {
			svm_clr_intercept(svm, INTERCEPT_CLGI);
			svm_clr_intercept(svm, INTERCEPT_STGI);

			if (svm_has_pending_gif_event(svm))
				kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
		}
	}

where init_vmcb() is (like v3):

	if (vnmi)
		svm->vmcb->control.int_ctl |=3D V_NMI_ENABLE_MASK;

	if (vgif)
		svm->vmcb->control.int_ctl |=3D V_GIF_ENABLE_MASK;

	if (vls)
		svm->vmcb->control.virt_ext |=3D VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;

