Return-Path: <kvm+bounces-70282-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6H5XN9nvg2mtvwMAu9opvQ
	(envelope-from <kvm+bounces-70282-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:18:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C68ED9CF
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:18:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4DE483006833
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 01:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9382877D4;
	Thu,  5 Feb 2026 01:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s8gVOT6c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDBE18CC13
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 01:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770254282; cv=none; b=uLCkDzes5IZ8h5JenmMLWQkxm7rYkHjx8E4ZVGFFmwssmWG4gK1kWovRjMm89pjQbG4r6AB/ouV8RHS0oz/us+hWPlKkZQLNH7YgjCj//VG9/J10e6m1APQ3cHHEPRKt//L+8ElvPTj0EjQ88Eh8dUXdSzXQwRpsmYAucYXcZkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770254282; c=relaxed/simple;
	bh=weq0fqo2tPGc5lpeGNhlb77TCji/77VOUp62fcKvqNw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rpixtcddCqN//ygzn44H1mtKc8BdWSoDF8sBGgqIMjU1QceN9yZscB1NReS8cr/1YX526K5fOzUc+0hv/i9vmKvYY6JpM97LxvbNorZHfIf6PP7pJcvr1ZQXJHqX+PCtBHT20qrDll7W1RFUHlSfEz3y7eokavIX+NtHkkkRlmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s8gVOT6c; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6c45a843b6so507535a12.2
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 17:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770254282; x=1770859082; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pyiDI7VPKF7gTzcDOmb56BEbcPVZQnYwftAUhlr4O+0=;
        b=s8gVOT6ck0bPDE/tbb8L/MwBtZMIMjxWAULn00IJa9BplzYLQDAGklmUDZtpw4n90j
         VIxN1rxGheF76p0kHf33zdDDknuqGZMHqOJvAKT8tipnFZNj+1ZB7bRu8f2ysIPP8oQp
         jYbKLBNOS2U84NUL+mfhPY98CUyPHaBGXzK7+1cr4pMXt1f0xbbZqhmUT9/Q3oCKNjF+
         kXu7ljvm55nJ03lJCaOZkQk+5MluC/ZWr7vsMeGvmx9Et77LYcW4cdM3XIjct3yWfWuJ
         Q5jGfSmjbdrDVk+dh1n97/8XBF4iHk9N8lXw5gP5QSiq+dUlP75e9I6Xy6btx6RqJFWw
         dsAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770254282; x=1770859082;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pyiDI7VPKF7gTzcDOmb56BEbcPVZQnYwftAUhlr4O+0=;
        b=ez362TaigdOKWnxR+531nN+WaiI8Ax0mTWsVAP48k3+1MedekUDxGwD9RDJfqmuFb3
         iol7YbhTojhhrh14M/xfxVFrRwxY036gyyoIkI5d336iicPmVE+2tlIgs4fpeSai6W9a
         iPVUPgpjl66GaQj8zHfpSYmm7ZDr4eR4t2bvNL2Xmq4qE64coq1zNxSlMrV0JbClc/4T
         go5ufeKAZk4Wk5xQKZdVywkha5ndOIXjgO87iMd0FRDK5bS6Ns+7tRn0IMjIrzbbif9O
         DYWF2HEh/eL7dOiG1MFvAGhKWkBdxD1tiE652qrvFCI/T20mO5PNO0WeoSV87UJQWpZP
         vfpw==
X-Forwarded-Encrypted: i=1; AJvYcCVasNuSFe0sTiyu7dEKQ77zeeO2ulPo72RR4GRQVOrX9zDZLqNh26mCsWYLVZpbDZdNjYk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+LjYIpd69chlfvQeUDI7vC25aFe44VEeavNJSgZ2KdfkZGXkW
	MbAM3zSDT3YvIjXrXp4nslF7us3OhQJ+q6RGNucm2/RKHeQpnitz6vaW/PDBIQqOfSio5VignTu
	VA57EVA==
X-Received: from pjva13.prod.google.com ([2002:a17:90a:d80d:b0:352:d931:fa5b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a108:b0:393:7575:a8be
 with SMTP id adf61e73a8af0-3937575c9d5mr3614095637.68.1770254281643; Wed, 04
 Feb 2026 17:18:01 -0800 (PST)
Date: Wed, 4 Feb 2026 17:18:00 -0800
In-Reply-To: <CALMp9eSc=0zS+6Rk-c_0P-Q1Y8_9Xv58G5BYxieKpv_XaSj0wg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113225406.273373-1-jmattson@google.com> <aWbmXTJdZDO_tnvE@google.com>
 <CALMp9eTYakMk0Bogxa_GdGU5_h4PK-YOXcu-cSQ16m1QcusHxw@mail.gmail.com>
 <CALMp9eQx7EVim4iYGbAhoHrei2YmTra6oxtdmKaY7bw-M0PHbw@mail.gmail.com>
 <aYKoJ74MWboBuE_M@google.com> <CALMp9eSc=0zS+6Rk-c_0P-Q1Y8_9Xv58G5BYxieKpv_XaSj0wg@mail.gmail.com>
Message-ID: <aYPvyMDipM9Z9Z7t@google.com>
Subject: Re: [PATCH] KVM: VMX: Add quirk to allow L1 to set FREEZE_IN_SMM in vmcs12
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70282-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 17C68ED9CF
X-Rspamd-Action: no action

On Wed, Feb 04, 2026, Jim Mattson wrote:
> On Tue, Feb 3, 2026 at 6:00=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Thu, Jan 22, 2026, Jim Mattson wrote:
> > > On Tue, Jan 13, 2026 at 7:47=E2=80=AFPM Jim Mattson <jmattson@google.=
com> wrote:
> > > > On Tue, Jan 13, 2026 at 4:42=E2=80=AFPM Sean Christopherson <seanjc=
@google.com> wrote:
> > > > >
> > > > > On Tue, Jan 13, 2026, Jim Mattson wrote:
> > > > > > Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM to allow L1 to set
> > > > > > IA32_DEBUGCTL.FREEZE_IN_SMM in vmcs12 when using nested VMX.  P=
rior to
> > > > > > commit 6b1dd26544d0 ("KVM: VMX: Preserve host's
> > > > > > DEBUGCTLMSR_FREEZE_IN_SMM while running the guest"), L1 could s=
et
> > > > > > FREEZE_IN_SMM in vmcs12 to freeze PMCs during physical SMM coin=
cident
> > > > > > with L2's execution.  The quirk is enabled by default for backw=
ards
> > > > > > compatibility; userspace can disable it via KVM_CAP_DISABLE_QUI=
RKS2 if
> > > > > > consistency with WRMSR(IA32_DEBUGCTL) is desired.
> > > > >
> > > > > It's probably worth calling out that KVM will still drop FREEZE_I=
N_SMM in vmcs02
> > > > >
> > > > >         if (vmx->nested.nested_run_pending &&
> > > > >             (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONT=
ROLS)) {
> > > > >                 kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> > > > >                 vmx_guest_debugctl_write(vcpu, vmcs12->guest_ia32=
_debugctl &
> > > > >                                                vmx_get_supported_=
debugctl(vcpu, false)); <=3D=3D=3D=3D
> > > > >         } else {
> > > > >                 kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
> > > > >                 vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vm=
enter_debugctl);
> > > > >         }
> > > > >
> > > > > both from a correctness standpoint and so that users aren't misle=
ad into thinking
> > > > > the quirk lets L1 control of FREEZE_IN_SMM while running L2.
> > > >
> > > > Yes, it's probably worth pointing out that the VM is now subject to
> > > > the whims of the L0 administrators.
> > > >
> > > > While that makes some sense for the legacy vPMU, where KVM is just
> > > > another client of host perf, perhaps the decision should be revisit=
ed
> > > > in the case of the MPT vPMU, where KVM owns the PMU while the vCPU =
is
> > > > in VMX non-root operation.
> >
> > Eh, running guests with FREEZE_IN_SMM=3D0 seems absolutely crazy from a=
 security
> > perspective.  If an admin wants to disable FREEZE_IN_SMM, they get to k=
eep the
> > pieces.  And KVM definitely isn't going to override the admin, e.g. to =
allow the
> > guest to profile host SMM.
>=20
> I'm not sure what you mean by "they get to keep the pieces." What is
> the security problem with allowing L1 to freeze *guest-owned* PMCs
> during SMM?

To give L1 the option to freeze PMCs, KVM would also need to give L1 the op=
tion
to *not* freeze PMCs.  At that point, the guest can use its PMCs to profile=
 host
SMM code.  Maybe even leverage a PMI to attack a poorly written SMM handler=
.

In other words, unless I'm missing something, the only reasonable option is=
 to
run the guest with FREEZE_IN_SMM=3D1, which means ignoring the guest's wish=
es.
Or I guess another way to look at it: you can have any color car you want, =
as
long as it's black :-)=20

