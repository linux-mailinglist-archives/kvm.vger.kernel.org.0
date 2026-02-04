Return-Path: <kvm+bounces-70136-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +IOyDUCogmk2XgMAu9opvQ
	(envelope-from <kvm+bounces-70136-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 03:00:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C285BE0A5C
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 03:00:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CEDA330BA97E
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 02:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15802153D8;
	Wed,  4 Feb 2026 02:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qFklVIYk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA4121CA03
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 02:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770170422; cv=none; b=ETQxyCKebaPvLPoPwWgxB1nrrlJDvBQvnuPmrm4xwhO9ir//ySdWEYEVR23a+GgYNhczzg5WaRR/OpOcqcpyjHHYqOWHTHky8YIvmNjH8V8Fx9HPeLFXhGaoNh8gS1lWagKK7U8gmYwNZLVx4/biQlLr/3oT+7DdteLJhT5zHpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770170422; c=relaxed/simple;
	bh=R2VWF/IdIhiZpVIUn0UgGtp4fwYsPyrTrIEhPOkpG9g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aKIJCSVqhKdqu0Ih9qzy4cuOnG/g2wX1FUC7x/ykJn6PA97Erh28HIlb5IAZE9XEgm3WOcToyW/jyH6ESmmHVyfltMAAxoMeJbh7ZDgyuQxoUYn5zOsBTT6d9+RQoAnxp1sVtJFfqc6gk9vkhN+QI5JYEQURqyP+OE7fGVSI+xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qFklVIYk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35449510446so4516914a91.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 18:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770170420; x=1770775220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6KArFjEOKEZJtmxt9pfWCTqIMmboD2cCUzS9I95uzNQ=;
        b=qFklVIYk2hfPIPKyA50rnIEBnv1DpNwNjsPQngulgNham1Ib/R1Erv1ZudjBAZSD7r
         +U2z3kDinZTXOdAf62O8PcDxdc30mV6kTZ98pWl350uRnUMNL6Cvbp68Dvi5LZEcoYWs
         N+Rua53LEmrhSJ7hH06WDPNtMyYc59H8fTZqXdSR8JnYv5bu3trvHQE50/nv5sjZnMZg
         kqUSpQuvzNk+OouOO4us2xptNuKgOJRJnUnjSYV7VWdCaERQ8tVvuIGtSI83/PP9lfJl
         A2u8ll8rt199Scgeadjgeu5a4OM13Id4+nVxgtDFQRzVQbga/V/NM2WwWOEl6aQVRWAL
         7zFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770170420; x=1770775220;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6KArFjEOKEZJtmxt9pfWCTqIMmboD2cCUzS9I95uzNQ=;
        b=ZiD7/C73gLKzJtEHhckf9CJ+o8hsAjFnbD+lc3BqHs2K32pwUCRIpLI5I7H1f5qrH6
         xVxCj81P0/8gZ1lgf5LVKA7bpqouziylgJmxQ8cROUE+fPmHL8RQ5ziQ0Ubs9Ray2rmD
         QhNHv2cNInijDQXTJ6fSPn4RmVEMkzcqc/M8BaveGmaMAJObZZtEGGSvVPfCnim5VitF
         YupwSPDN/SjFSpXQeT0NAm/EdGL+9A0269fKEqAtAq9Z4yVbalU9AN3Apwi6pIRqXKZQ
         sir+0MN0GfqWd+aRlEfGzopQT9QmOwFn9rOjc4EpJitWhK/NQaFoGptxiPhjVsXpeSV8
         8GTA==
X-Forwarded-Encrypted: i=1; AJvYcCXTog2v8c3ElIOdoRLTg2qSyxu7BY36UYGgp1s4PbrYHpdrJbdu5vKhtxmMzF8rnuu5lYI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx39kCZCd1B2og22xKgdUPKeJdAwcdB3+PJXOqvIf5lfZ6jA4e1
	BEu4SsL+PBmsr3uDzCVNFocqqAKN5EEwUXf+Q4SF8y4UmVWHlnzg4mywVUI/Ohp6lbUMJd8TDNP
	6P6Dshg==
X-Received: from pjuj13.prod.google.com ([2002:a17:90a:d00d:b0:340:c0e9:24b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2811:b0:34c:c866:81f2
 with SMTP id 98e67ed59e1d1-354870ae79dmr1018730a91.4.1770170419811; Tue, 03
 Feb 2026 18:00:19 -0800 (PST)
Date: Tue, 3 Feb 2026 18:00:07 -0800
In-Reply-To: <CALMp9eQx7EVim4iYGbAhoHrei2YmTra6oxtdmKaY7bw-M0PHbw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113225406.273373-1-jmattson@google.com> <aWbmXTJdZDO_tnvE@google.com>
 <CALMp9eTYakMk0Bogxa_GdGU5_h4PK-YOXcu-cSQ16m1QcusHxw@mail.gmail.com> <CALMp9eQx7EVim4iYGbAhoHrei2YmTra6oxtdmKaY7bw-M0PHbw@mail.gmail.com>
Message-ID: <aYKoJ74MWboBuE_M@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70136-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C285BE0A5C
X-Rspamd-Action: no action

On Thu, Jan 22, 2026, Jim Mattson wrote:
> On Tue, Jan 13, 2026 at 7:47=E2=80=AFPM Jim Mattson <jmattson@google.com>=
 wrote:
> > On Tue, Jan 13, 2026 at 4:42=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Tue, Jan 13, 2026, Jim Mattson wrote:
> > > > Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM to allow L1 to set
> > > > IA32_DEBUGCTL.FREEZE_IN_SMM in vmcs12 when using nested VMX.  Prior=
 to
> > > > commit 6b1dd26544d0 ("KVM: VMX: Preserve host's
> > > > DEBUGCTLMSR_FREEZE_IN_SMM while running the guest"), L1 could set
> > > > FREEZE_IN_SMM in vmcs12 to freeze PMCs during physical SMM coincide=
nt
> > > > with L2's execution.  The quirk is enabled by default for backwards
> > > > compatibility; userspace can disable it via KVM_CAP_DISABLE_QUIRKS2=
 if
> > > > consistency with WRMSR(IA32_DEBUGCTL) is desired.
> > >
> > > It's probably worth calling out that KVM will still drop FREEZE_IN_SM=
M in vmcs02
> > >
> > >         if (vmx->nested.nested_run_pending &&
> > >             (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS=
)) {
> > >                 kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> > >                 vmx_guest_debugctl_write(vcpu, vmcs12->guest_ia32_deb=
ugctl &
> > >                                                vmx_get_supported_debu=
gctl(vcpu, false)); <=3D=3D=3D=3D
> > >         } else {
> > >                 kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
> > >                 vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vmente=
r_debugctl);
> > >         }
> > >
> > > both from a correctness standpoint and so that users aren't mislead i=
nto thinking
> > > the quirk lets L1 control of FREEZE_IN_SMM while running L2.
> >
> > Yes, it's probably worth pointing out that the VM is now subject to
> > the whims of the L0 administrators.
> >
> > While that makes some sense for the legacy vPMU, where KVM is just
> > another client of host perf, perhaps the decision should be revisited
> > in the case of the MPT vPMU, where KVM owns the PMU while the vCPU is
> > in VMX non-root operation.

Eh, running guests with FREEZE_IN_SMM=3D0 seems absolutely crazy from a sec=
urity
perspective.  If an admin wants to disable FREEZE_IN_SMM, they get to keep =
the
pieces.  And KVM definitely isn't going to override the admin, e.g. to allo=
w the
guest to profile host SMM.

> > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > index 0521b55d47a5..bc8f0b3aa70b 100644
> > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > @@ -3298,10 +3298,24 @@ static int nested_vmx_check_guest_state(str=
uct kvm_vcpu *vcpu,
> > > >       if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0=
 & X86_CR0_WP)))
> > > >               return -EINVAL;
> > > >
> > > > -     if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS=
) &&
> > > > -         (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> > > > -          CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debug=
ctl, false))))
> > > > -             return -EINVAL;
> > > > +     if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)=
 {
> > > > +             u64 debugctl =3D vmcs12->guest_ia32_debugctl;
> > > > +
> > > > +             /*
> > > > +              * FREEZE_IN_SMM is not virtualized, but allow L1 to =
set it in
> > > > +              * L2's DEBUGCTL under a quirk for backwards compatib=
ility.
> > > > +              * Prior to KVM taking ownership of the bit to ensure=
 PMCs are
> > > > +              * frozen during physical SMM, L1 could set FREEZE_IN=
_SMM in
> > > > +              * vmcs12 to freeze PMCs during physical SMM coincide=
nt with
> > > > +              * L2's execution.
> > > > +              */
> > > > +             if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_VMCS=
12_FREEZE_IN_SMM))
> > > > +                     debugctl &=3D ~DEBUGCTLMSR_FREEZE_IN_SMM;
> > > > +
> > > > +             if (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> > > > +                 CC(!vmx_is_valid_debugctl(vcpu, debugctl, false))=
)
> > >
> > > I'm mildly tempted to say we should quirk the entire consistency chec=
k instead of
> > > limiting it to FREEZE_IN_SMM, purely so that we don't have to add yet=
 another quirk
> > > if a different setup breaks on a different bit.  I suppose we could l=
imit the quirk
> > > to bits that could have been plausibly set in hardware, because other=
wise VM-Entry
> > > using L2 would VM-Fail, but that's still quite a few bits.
> > >
> > > I'm definitely not opposed to a targeted quirk though.
> >
> > I have no preference.

After mulling over the options from time to time, I think our best be is to=
 quirk
only FREEZE_IN_SMM, but very explicity scope the quirk to just the consiste=
ncy
check.  E.g. maybe KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC?  That should help=
 alert
readers to the fact that the quirk bypasses the check, but L2 will still se=
e
FREEZE_IN_SMM=3D0 (e.g. in the unlikely scenario L1 disables interception o=
f
DEBUGCTL).

As for why just FREEZE_IN_SMM, in addition to the fact that FREEZE_IN_SMM i=
s the
only bit that broke anyone (as far as we know, /knock wood), it's also the =
only
bit that is host-owned.  I.e. unless the host admin likes SMM mucking with =
things,
skipping the consistency check isn't terrible from a functionality perspect=
ive
(KVM doesn't honor the bit for emulated SMM, but that's QEMU's problem :-D)=
.

> Would you like me to post a v2?

Yes please.

