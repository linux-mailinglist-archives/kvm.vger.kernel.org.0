Return-Path: <kvm+bounces-70648-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CAtbGYFTimkVJgAAu9opvQ
	(envelope-from <kvm+bounces-70648-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 22:37:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DF44114D76
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 22:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BED723004D00
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 21:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D3130F94D;
	Mon,  9 Feb 2026 21:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="roPYW2Uu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F9B30ACE3
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 21:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770673021; cv=none; b=qeptz6q0PjFtPbJdcpIaqrH7xlejpGD5y7vU7CBuuWW/4OWgGBaQ9rLIlRiL3kK8xYJbmGT54cDSde0owra85qa4Ps8TywS9BYU8s6hWUrVSJdNpsMuG5eIjjAdMdgF+oKyRpXUs5xrBchA8p2KlELx+9LrvItpksfIoNAcwhcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770673021; c=relaxed/simple;
	bh=4vMrD1qtowWL1DOzFpHUbYkKx4V7YYCbE6s+0yjbYoM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zb+VM9LBrzpYCmmo+ltIC5sG7aKU2oVfpAcqPrc+t808dBtFzsKmicMosjjMI0Ut5BolhzDmKWAOYVuTVMjSqfYsksG30lZyk4RFjbm6VnbXXYLRkQh4eKc4sKpY23UB8FR12KexpEdYP+PGPnhnnqSIzEJe5OiuOO048wXNk6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=roPYW2Uu; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c0eb08ceso455380a91.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 13:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770673019; x=1771277819; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FA7IJyutkB47JiXV9V/fjE1MEG6+dQ48Jc6fRYn5OAo=;
        b=roPYW2UuZaW/+1dFTW9+YAz5MyBG11DEzG/FfmXBQchaAsepB2ea6RQTEAqoZpJUml
         7HdH5UQJ5bT59Lg/nmxgoNPOyczfwkAU1DZGt8i3sGq4FAWFuujd2UcjjRpDiQUddolm
         Iq9SNp1FKmJW2yg91q/8ahC+41EUQDcA3n71yOknefNw1A/qJjP1Bbm6hW0IPiCz/v97
         h6PpbGpCZQC7oaS6pPFE86CWqdGDns7uNjjKVh1HC5SgQYMouJ3uaJZDYY2WVxpNh9i1
         xB2q5swvuR7r+JMvZWM5bLMlKEech53chl/3mSvLpZqdWwZtBwyA09Lveau8ykA2Seln
         BU2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770673019; x=1771277819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FA7IJyutkB47JiXV9V/fjE1MEG6+dQ48Jc6fRYn5OAo=;
        b=P6ABV1cQIem6IeHo/pUsjSppNxdFjnBp45VM3W/JnvdKBWbTjMtpA6YOgZFa8QoJ6j
         0YJ+wbI+tsH5lXN0frzioEhxKh2NMC8KCsUHHq+mLjuD4VmXOyNUS7N5LNSyJgzkmk0I
         Tl4KOUGkbP9+y5B7isHaAEgVv9ZuXSDLZUqVFcuX6jLpdRUdXQ6eIkKXf/QNTiTkrSiH
         X2ArP4Y8Pqc1qgn16EQtkU922P7sAmTnolTtirveYp1j6nko8GtaHl86DVbjibAfW38i
         Od7pRqbgb6T9te0RLz3GLSexboN/Qotap8gE10Ce8idVT2IATbA+HrB2/+tM8jCbo55F
         7nTA==
X-Forwarded-Encrypted: i=1; AJvYcCUWIPpVsL0u0erXKRlFuJGwXpVoSaGz1/A0GkdvmBV1l2pqMMUKlA/kzbZIQ083tKPKRlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwRu7oOpf+kkhVh5snQI+nwm5Fw6E4ioT+ARcaX5yGpiuB6wYa
	6/96VdohpMFbjYK/30vA/Hdf5xF8kp8kqi5i8cvlU8y1Roonr6YTnWubBAqt8Zm7rQtRpBl2mJl
	iYlLMjw==
X-Received: from pjbch6.prod.google.com ([2002:a17:90a:f406:b0:355:1a0a:cf7f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2785:b0:356:3032:1d5e
 with SMTP id 98e67ed59e1d1-356303224c0mr4655205a91.22.1770673018603; Mon, 09
 Feb 2026 13:36:58 -0800 (PST)
Date: Mon, 9 Feb 2026 13:36:56 -0800
In-Reply-To: <aYmvWLjNaJ5fbOcO@blrnaveerao1>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203190711.458413-1-seanjc@google.com> <20260203190711.458413-2-seanjc@google.com>
 <aYXvp1S7lg2sq4AS@blrnaveerao1> <aYYwOTSIJsdafEvJ@google.com> <aYmvWLjNaJ5fbOcO@blrnaveerao1>
Message-ID: <aYpTeJK96r_fuFt4@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Initialize AVIC VMCB fields if AVIC is
 enabled with in-kernel APIC
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70648-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2DF44114D76
X-Rspamd-Action: no action

On Mon, Feb 09, 2026, Naveen N Rao wrote:
> On Fri, Feb 06, 2026 at 10:17:29AM -0800, Sean Christopherson wrote:
> > > >  arch/x86/kvm/svm/avic.c | 2 +-
> > > >  arch/x86/kvm/svm/svm.c  | 2 +-
> > > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > > index f92214b1a938..44e07c27b190 100644
> > > > --- a/arch/x86/kvm/svm/avic.c
> > > > +++ b/arch/x86/kvm/svm/avic.c
> > > > @@ -368,7 +368,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
> > > >  	vmcb->control.avic_physical_id = __sme_set(__pa(kvm_svm->avic_physical_id_table));
> > > >  	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
> > > >  
> > > > -	if (kvm_apicv_activated(svm->vcpu.kvm))
> > > > +	if (kvm_vcpu_apicv_active(&svm->vcpu))
> > > >  		avic_activate_vmcb(svm);
> > > >  	else
> > > >  		avic_deactivate_vmcb(svm);
> > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > index 5f0136dbdde6..e8313fdc5465 100644
> > > > --- a/arch/x86/kvm/svm/svm.c
> > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > @@ -1189,7 +1189,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
> > > >  	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
> > > >  		svm->vmcb->control.erap_ctl |= ERAP_CONTROL_ALLOW_LARGER_RAP;
> > > >  
> > > > -	if (kvm_vcpu_apicv_active(vcpu))
> > > > +	if (enable_apicv && irqchip_in_kernel(vcpu->kvm))
> > > >  		avic_init_vmcb(svm, vmcb);
> > > 
> > > Doesn't have to be done as part of this series, but I'm wondering if it 
> > > makes sense to turn this into a helper to clarify the intent and to make 
> > > it more obvious:
> > 
> > Hmm, yeah, though my only hesitation is the name.  For whatever reason, "possible"
> > makes me think "is APICv possible *right now*" (ignoring that I wrote exactly that
> > in the changelog).
> > 
> > What if we go with kvm_can_use_apicv()?  That would align with vmx_can_use_ipiv()
> > and vmx_can_use_vtd_pi(), which are pretty much identical in concept.
> 
> Yes, that's better. I'll use that and post it as a subsequent cleanup, 
> unless you want to pick it up rightaway.

Go ahead and post it separately, it's nice to have a proper paper trail.

