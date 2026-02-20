Return-Path: <kvm+bounces-71411-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBs0JtSUmGlaJwMAu9opvQ
	(envelope-from <kvm+bounces-71411-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 18:07:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FEA1169951
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 18:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0DC2030117C4
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 17:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8957330F540;
	Fri, 20 Feb 2026 17:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kcJclAJ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF723033EC
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 17:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771607240; cv=none; b=auSuisSoZvKcElI3hOW7tS3mqZM0Z8S717uJFdyircHnBT8C+fWq2SFTrKd/bibPU2BgclnFIy6Wt25kGtHOfrnNafN7y8F+BpY1nqgDbrx+9MIUB4isNCfNE81S8qj3exFunjEwiSuTImCU6AgqXxW22yWaoCaqhaTzGtTsXQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771607240; c=relaxed/simple;
	bh=nTvKG2bYwt4WXjBgVLKMsVCflgzXNBIIVlM0LeA9T5k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aATxLOCSMGwsjCL7zLkx8oCQHjUvE3cOusjMmJyhFQVkiiTrZjss1wrKJvkTFnc6dm59hNlzr0nk40rVJfftWxNQIbuN0NBuLYurwTlKzjSHRRz2DxApexr54mSkLfC7hlgkJFxL89UHZGsSxHINGf2m0hyfbNtPewsKfV7W/z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kcJclAJ8; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a943e214daso128471075ad.3
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 09:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771607238; x=1772212038; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FQ61+EII6jhjSoVXf1SpvV9qDNdO2h+UXN+UPcHPg4I=;
        b=kcJclAJ89LbyDGHgJ4QfuBm43MbfCrIIFZbZhoAETJUGDnP9YuUWl2rDosh8iHRixX
         fBYE9RPQRmDRjLpC+klju/2IPojuwDiP1KZckgOB6hTv1VMdz1b0yYa6noo5kS00vEzQ
         JIpvjy4ysKWOWjwQKO4RMQqS5KIszFUcAzgNtqXOMPosTr1agn8jPehLSgQMzR+t72Aj
         lqRzq23VTAiPZSTVM3+V6oNDtNptZLLAv5YN5guhQWt8RrbOV/So2i2cfPFiG06tuW5n
         m+9nW0FbpieTVWtnndNB0ePpOjsV+elj+cVLtznsUCHXYMobUTkA45bmvQT8XZ19OJOo
         XDQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771607238; x=1772212038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FQ61+EII6jhjSoVXf1SpvV9qDNdO2h+UXN+UPcHPg4I=;
        b=s0HLFUJgsmTwH13OR4kOGAUHDV/G8LpruNe0ASxgTYCQ9BPnK4aDICghp4NoGx3S/Q
         4209fPJPHTiBPldcbsWqBVQV2kqUghm75BzctKBFRbEF5MvYoD6helKprSQQTmAyjr79
         KaSo5HLeYaQx8deLR19c0rAWu3d2Vt3c1F6WCtLc3BkPLfvXEBOkZAq7ilfskj1wkOUn
         2WzKO21JT1DSfL2VZYeeCusqNQjIIXd3oGYntxjZsWa7++U2tBx+/FPcYKmAhrq2N8cd
         H2B87z8YVxlVlBIlii/3UyVj3QlXn7Q0/OafaHhd1npl14ms9JI2KQ1sz5c11qJ3cifj
         oEHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUO5LLgcvzxOQtJF5yCYideyg+bTa55djSpXGJWZBsfybHrFrHAL55Il3kGzDxd1AGXEo8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQaXz0G7/QQZK/0iBw43YRJCKeefnnMPS95F6c6PMxidOi6TwL
	Pg5FiGuqtjV6/3YZZ1FaKVTGXewAa8FCkgcrb2vmI76OlBP5TcbZYkWZalv9askjy0YHEAuOXfQ
	jh37fNA==
X-Received: from plbks16.prod.google.com ([2002:a17:903:850:b0:2ab:348e:7201])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e949:b0:2aa:d65f:47a2
 with SMTP id d9443c01a7336-2ad7451cad0mr2076595ad.41.1771607237557; Fri, 20
 Feb 2026 09:07:17 -0800 (PST)
Date: Fri, 20 Feb 2026 09:07:16 -0800
In-Reply-To: <wwa2h5gcb7gfxgmsh3jdwa4d4xurkmgd26dnkwupgzcln3khfu@v3w2w6nf4tq7>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212230751.1871720-1-yosry.ahmed@linux.dev>
 <20260212230751.1871720-5-yosry.ahmed@linux.dev> <aZZVqQrQ1iCNJhJJ@google.com>
 <wwa2h5gcb7gfxgmsh3jdwa4d4xurkmgd26dnkwupgzcln3khfu@v3w2w6nf4tq7>
Message-ID: <aZiUxBRPovFd4nDd@google.com>
Subject: Re: [RFC PATCH 4/5] KVM: SVM: Recalculate nested RIPs after restoring REGS/SREGS
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71411-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3FEA1169951
X-Rspamd-Action: no action

On Thu, Feb 19, 2026, Yosry Ahmed wrote:
> > E.g. after patch 2, completely untested...
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index aec17c80ed73..6fc1b2e212d2 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -863,12 +863,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> 
> Above the context lines we have:
> 
>         /*
>          * next_rip is consumed on VMRUN as the return address pushed on the
>          * stack for injected soft exceptions/interrupts.  If nrips is exposed
>          * to L1, take it verbatim from vmcb12.  If nrips is supported in
>          * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
>          * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
>          * prior to injecting the event).
>          */
>         if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>                 vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
>         else if (boot_cpu_has(X86_FEATURE_NRIPS))
>                 vmcb02->control.next_rip    = vmcb12_rip;
> 
> The same bug affects vmcb02->control.next_rip when the guest doesn't
> have NRIPS. I think we don't want to move part of the vmcb02
> initialization before VMRUN too. We can keep the initialization here and
> overwrite it before VMRUN if needed, but that's just also ugh..

Aha!  I knew I was missing something, but I couldn't quite get my brain to figure
out what.

I don't have a super strong preference as to copying the code or moving it
wholesale.  Though I would say if the pre-VMRUN logic is _identical_ (and I think
it is?), then we move it, and simply update the comment in
nested_vmcb02_prepare_control() to call that out.

> >         svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
> >         if (is_evtinj_soft(vmcb02->control.event_inj)) {
> >                 svm->soft_int_injected = true;
> > -               svm->soft_int_csbase = vmcb12_csbase;
> > -               svm->soft_int_old_rip = vmcb12_rip;
> > +
> >                 if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> >                         svm->soft_int_next_rip = svm->nested.ctl.next_rip;
> 
> Why not move this too?

For the same reason I think we should keep 

	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;

where it is.  When NRIPS is exposed to the guest, the incoming nested state is
the one and only source of truth.  By keeping the code different, we'd effectively
be documenting that the host.NRIPS+!guest.NRIPS case is the anomaly.

> > -               else
> > -                       svm->soft_int_next_rip = vmcb12_rip;
> >         }
> >  
> >         /* LBR_CTL_ENABLE_MASK is controlled by svm_update_lbrv() */
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 8f8bc863e214..358ec940ffc9 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4322,6 +4322,14 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
> >                 return EXIT_FASTPATH_EXIT_USERSPACE;
> >         }
> >  
> > +       if (is_guest_mode(vcpu) && svm->nested.nested_run_pending &&
> > +           svm->soft_int_injected) {
> > +               svm->soft_int_csbase = svm->vmcb->save.cs.base;
> > +               svm->soft_int_old_rip = kvm_rip_read(vcpu);
> > +               if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> > +                       svm->soft_int_next_rip = kvm_rip_read(vcpu);
> > +       }
> > +
> 
> I generally dislike adding more is_guest_mode() stuff in svm_vcpu_run(),
> maybe we can refactor them later to pre-run and post-run nested
> callbacks? Anyway, not a big deal, definitely an improvement over the
> current patch assuming we can figure out how to fix next_rip.

I don't love it either, but I want to (a) avoid unnecessarily overwriting the
fields, e.g. if KVM never actually does VMRUN and (b) minimize the probability
of consuming a bad RIP.

In practice, I would expect the nested_run_pending check to be correctly predicted
the overwhelming majority of the time, i.e. I don't anticipate performance issues
due to putting the code in the hot path.

If we want to try and move the update out of svm_vcpu_run(), then we shouldn't
need generic pre/post callbacks for nested, svm_prepare_switch_to_guest() is the
right fit.


