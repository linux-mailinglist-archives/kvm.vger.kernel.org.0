Return-Path: <kvm+bounces-72700-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qKNfGC9iqGk3uQAAu9opvQ
	(envelope-from <kvm+bounces-72700-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:47:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C5656204903
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:47:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D6BFF30A1E3A
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 16:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054B336F41B;
	Wed,  4 Mar 2026 16:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ewe1IPmo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A57436D507
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 16:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772642561; cv=none; b=dB4eWLaFAuKlen9rNu+X+usnRZqikZssLq8c+CtpZH+fvtHhUPgHStkvmYRIPMg7+wsWFSlsEKMOylPyikEnJZz2L+kbtBwZtGm/vKKYGGknBDx9d3FWFtk1R7MiKNl/0L7gzTBkhqwT/n3hGiPOSz4PbrbyeIX3u5gg1MBLvVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772642561; c=relaxed/simple;
	bh=EXdvy/X2qckXmE4Fn4pxUupwjsevzcJ8qc5ZO33j78o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VrPDE+TrAK4xgace3pU7k9P6Cw3G/0DA3EEg5txMvyRl1h5kuPG9MBqD0xTs/eM96iqT5nphPihuZmEQTRHpJR6WqW42WUc0qWZugBFcYAXuZj5CKYSzxWw31EBT+YXyhR/egyKvVTZmDWVCuYb6iSM4Mkxs0MdTzzuCyZA6lj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ewe1IPmo; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c503d6be76fso28290860a12.0
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 08:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772642558; x=1773247358; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LKOTPS+x5qyyOBePt2E7Wo7x4Cp+H26djNH9mCsw8A8=;
        b=ewe1IPmo8NfNn85vq3td323umUZgOzwxSyXxc4Q/SQhssL2JZLmy5JjnRDW1pkTZwM
         nAX6uUGqkLDaqUt/M2mwLu8wN7ueKRZUHvI8cKe4Zr4tUWK3bu330U7x0S3dgGC9wsIE
         E0CVNo5NZzeUXVmw6q8guWpM/2iicWNs8uwGHy2BvT5AHAaaoc+krL9wWwf2oJI2uGB4
         xcUsCSJp+F1J1cynoBnGpwAyu7NogIYf/Ak2vutV0KFpR2RnRikKcFzzS3Ft0LM+EmHu
         lcSgM1Fv8+aMOullztu8yVWrhn+4TWG+/AtcuBnevaQ8RieiQ9/dTz+JTNwXen4HJ+Bg
         EIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772642558; x=1773247358;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LKOTPS+x5qyyOBePt2E7Wo7x4Cp+H26djNH9mCsw8A8=;
        b=gn3acaLMSap/GiWDqe3/32a50RYkBmX9epBfypZScU14sjl0jhgdVcTeHTLPu6J8Iz
         zdDZj+szY1rhy4XPSWjMmevDTMprWT5k7TXylRwrdQv3CvRfS7+GhDo3SYvltusMYbCU
         VPXLB7WXWf64Zi9/Rz/rRHWOasQpQ97j5lfc2oXRsa3S7Q4UQzkIeCEg9+AWao43upnP
         6pP0GryGqfGbUVu/Kdljw53xz1B0mDce5LwTuteSQsvn/GxCo8uvhA+B6WojW5q6Jdvr
         Cvi6ZeczOLaVAPl0wGXlAFUjYHMaWkiB0AFK+ZsgZxfx9Q9dwz8vtz6TBmpPhEROQUIE
         ZFCg==
X-Forwarded-Encrypted: i=1; AJvYcCUMteVKwAQBMipu/nNHFyikRVKlWdBG0bN4iH015y9TZFDBKFuCCD6Bd6Pwo+sX4M9dZ90=@vger.kernel.org
X-Gm-Message-State: AOJu0YzquBCZOpZUOGMiP0j+p0JVPNC3pdGFXfF8nkik9dQrMTHArQ2j
	aCh90lru4yYwjfSfjDpBFu8lpeSKLCFE4U3E/zg+91tNLXrD6vuO6v0Hk8zAbWh8N2imA3i6sUH
	GBHHJKQ==
X-Received: from pggq20.prod.google.com ([2002:a63:d614:0:b0:c73:8741:7555])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d703:b0:38e:90ca:5a2b
 with SMTP id adf61e73a8af0-3982deb4e22mr2628840637.17.1772642557478; Wed, 04
 Mar 2026 08:42:37 -0800 (PST)
Date: Wed, 4 Mar 2026 08:42:36 -0800
In-Reply-To: <A7B34157-A5CA-430C-A459-E8E142951ECB@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-13-xin@zytor.com>
 <aR04V4VVg+p4RsdT@intel.com> <60C180BF-AD13-48EF-9BA8-CEACF57965EF@zytor.com>
 <1EA97017-82D2-4C43-B617-D39C68D7BC6F@zytor.com> <A7B34157-A5CA-430C-A459-E8E142951ECB@zytor.com>
Message-ID: <aahg_PgO5mwjArZ6@google.com>
Subject: Re: [PATCH v9 12/22] KVM: VMX: Virtualize FRED event_data
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com, 
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, hch@infradead.org, 
	sohil.mehta@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C5656204903
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72700-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,zytor.com:email]
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Xin Li wrote:
> > On Jan 29, 2026, at 9:21=E2=80=AFAM, H. Peter Anvin <hpa@zytor.com> wro=
te:
> >=20
> >> Just to confirm, you are referring to requeueing an original event
> >> via vmx_complete_interrupts(), right?
> >>=20
> >> Regardless of whether FRED or IDT is in use, the event payload is deli=
vered
> >> into the appropriate guest state and then invalidated in
> >> kvm_deliver_exception_payload():
> >>=20
> >>       1) CR2 for #PF
> >>=20
> >>       2) DR6 for #DB
> >>=20
> >>       3) guest_fpu.xfd_err for #NM (in handle_nm_fault_irqoff())
> >>=20
> >> We should be able to recover the FRED event data from there.
> >>=20
> >> Alternatively, we could drop the original event and allow the hardware=
 to
> >> regenerate it upon resuming the guest.  However, this breaks #DB deliv=
ery,
> >> as debug exceptions sometimes are triggered post-instruction.
> >>=20
> >> Sean, does it make sense to recover the FRED event data from guest CPU=
 state?

No?  As Peter points out, the payload is tied to the exception and shouldn'=
t
change.

> > I think some bits in DR6 are "sticky", and so unless the guest has
> > explicitly cleared DR6 the event data isn't necessarily derivable from =
DR6.
> > However, the FRED event data for #DB is directly based on the data alre=
ady
> > reported by VTx (for exactly the same reason =E2=80=93 knowing what the=
 *currently
> > taken* trap represents.)
>=20
> Yeah, it's important to keep in mind that DR6 bits are 'sticky'.
>=20
> Regarding vmx_complete_interrupts(), when a VM migration occurs immediate=
ly
> following a VM exit with a valid original event saved in the VMCS, we can
> safely assume the guest DR6 state remains consistent with the original ev=
ent
> data because there is no chance for guest OS to modify DR6.

There's a different problem though.  If there's a re-injected exception at =
the
time of save/restore, the destination vCPU won't see a valid payload and th=
us
won't set the appropriate FRED VMCS fields.

We _could_ extend KVM's uAPI to save/restore event_data, but ugh.  Rather t=
han
add event_data, what if we reuse payload, and then simply skip updating reg=
ister
state on re-injection?  E.g.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 967b58a8ab9d..b79d545d69c7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1941,6 +1941,9 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
        u32 intr_info =3D ex->vector | INTR_INFO_VALID_MASK;
        struct vcpu_vmx *vmx =3D to_vmx(vcpu);
=20
+       if (ex->has_payload)
+               <do fred>;
+
        kvm_deliver_exception_payload(vcpu, ex);
=20
        if (ex->has_error_code) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d9..485eec337203 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -773,6 +773,9 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcp=
u,
        if (!ex->has_payload)
                return;
=20
+       if (ex->injected)
+               goto clear_payload;
+
        switch (ex->vector) {
        case DB_VECTOR:
                /*
@@ -814,6 +817,7 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcp=
u,
                break;
        }
=20
+clear_payload:
        ex->has_payload =3D false;
        ex->payload =3D 0;
 }

