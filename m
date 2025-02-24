Return-Path: <kvm+bounces-39056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 245BDA43051
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 23:55:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94D5A3B4B19
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 22:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6313209F52;
	Mon, 24 Feb 2025 22:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bC2pUSy/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BF420A5E7
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 22:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740437728; cv=none; b=fqnmrUjehTivU2/dqWlU/HcilHu1m4TCEHPPtJmqplwanFRvFx5dhUKq55am//bsZYjlvYbh1aYn7rBJsKgH731wAo1JmNO5WgJLpifcpn7STrVdS5dboznMWw4FphMLLqQCU1hxliOtuSTpmNzE+fdbAeOokKqpijURJNHtHXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740437728; c=relaxed/simple;
	bh=PW+zmrFZc0xmy4cbIM/W6pvZWPstFN8MLjOpyYL4XcU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yb6MozI3tr5ds1TTF6v8tO7VRVCG3OqTcLTQWhOnp+cfHzZHO0OORcb/0Hci80ghIzUPXOQu55eWrXheF4XKhxenm3VtN/y29VJ+gsFJPjySfwDd6wtne3g6DgKrOvg5X8lfMy6EnnUnH2IND1YxfYBj5S2JbsbGhB9jSDP8XZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bC2pUSy/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc17c3eeb5so10182891a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 14:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740437726; x=1741042526; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JxqfxTQbTANuvL9z9xorFMM5AYhY65M7rtRmI5Zy3S0=;
        b=bC2pUSy/DMz2LJGyP7q3YYBNNs6aD7xQKvsSDbF8zaR/mp55vnjDWs9UXoxoRxBs0f
         lcdMs3aIKLcm3tyZV/HbSe1OXu92R678ameA0MlVPQkp2ojzEGD2TkyW1Zeq3GtwbGnm
         euiHBQm9p62Q/JPtaijmM2iWUzvvG5BxsKWVZHd+utP4hP4IJIovQ4hKhRkgptFVkkEP
         UsI22qusSztsD1R/5UKWsXTlgL4ZkUYudXYVfHmM7JhjoP4d89gGRVgusYecL2w/IN6Z
         10N7jIhD4O/e4ft7kx0ikOcQdhjw0RIThaKoy5qWv/fJ1i5qDLUZUFV37O9zNUYjnsbu
         YFpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740437726; x=1741042526;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JxqfxTQbTANuvL9z9xorFMM5AYhY65M7rtRmI5Zy3S0=;
        b=uu1g6kXwSGzQKK1nLxQCwIOztzWON8+1KBksTpxEF5fiMBH44LHQyhFLMhaTaw7C1p
         yoH+2774xK2YTw6WU+yYP0NKyLr75fqQF1gn2s4z6PevCeJ7pPjnfRuRsXRvS38OLYQF
         eaW3/kpuJgEeRqAa5gdd5oYHgAntRgsuvleScawAH+o9MtYqDPbnXlDIEFBnCvP9uPr6
         u+TY6+8A5/BT7VgNOV26hbO7yGPttsRHYEvAked2MDXxybORVVX5M9YKJaH7mGCWM+1c
         8KSbCBIb2Kn+tWBMLwqUtd8LVNSg2+cRH9GdMqo23jiUkxPF5IfM+TAKwfQPaUnv6yAv
         vJag==
X-Forwarded-Encrypted: i=1; AJvYcCXxvJwlPJIefMb0SG4TrjAWHTCUsW8RFI8eGrSlhvFHd2a1o1iCbrckS6YihlYOfR1C2qk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywryd6222l1RYjWQ1K8DkYz2NCkBywL4Pmyehn2eVz3UTfz0cJF
	AlQ9LoeSM+9LT16HXwBob+sB3mXdCPKneHgtC75z/xs348dubCeuS9NnWwtzSPJz25z8gqqlTEx
	jkA==
X-Google-Smtp-Source: AGHT+IGzD8VSjrx/DQTijY3ky+0sU7EN6ReQ/Pu8sLgMOW0+A4LEaVm7FOIYJCellYckx46Jpl7xgkCgpP0=
X-Received: from pjbhl14.prod.google.com ([2002:a17:90b:134e:b0:2fc:2828:dbca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c84:b0:2f9:bcd8:da33
 with SMTP id 98e67ed59e1d1-2fce86d4b2emr21113934a91.21.1740437725928; Mon, 24
 Feb 2025 14:55:25 -0800 (PST)
Date: Mon, 24 Feb 2025 14:55:24 -0800
In-Reply-To: <4e762d94-97d4-2822-4935-2f5ab409ab29@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219012705.1495231-1-seanjc@google.com> <20250219012705.1495231-4-seanjc@google.com>
 <4e762d94-97d4-2822-4935-2f5ab409ab29@amd.com>
Message-ID: <Z7z43JVe2C4a7ElJ@google.com>
Subject: Re: [PATCH 03/10] KVM: SVM: Terminate the VM if a SEV-ES+ guest is
 run with an invalid VMSA
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 24, 2025, Tom Lendacky wrote:
> On 2/18/25 19:26, Sean Christopherson wrote:
> > -void pre_sev_run(struct vcpu_svm *svm, int cpu)
> > +int pre_sev_run(struct vcpu_svm *svm, int cpu)
> >  {
> >  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
> > -	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
> > +	struct kvm *kvm = svm->vcpu.kvm;
> > +	unsigned int asid = sev_get_asid(kvm);
> > +
> > +	/*
> > +	 * Terminate the VM if userspace attempts to run the vCPU with an
> > +	 * invalid VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after
> > +	 * an SNP AP Destroy event.
> > +	 */
> > +	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa)) {
> > +		kvm_vm_dead(kvm);
> > +		return -EIO;
> > +	}
> 
> If a VMRUN is performed with the vmsa_pa value set to INVALID_PAGE, the
> VMRUN will fail and KVM will dump the VMCB and exit back to userspace

I haven't tested, but based on what the APM says, I'm pretty sure this would crash
the host due to a #GP on VMRUN, i.e. due to the resulting kvm_spurious_fault().

  IF (rAX contains an unsupported physical address)
    EXCEPTION [#GP]

> with KVM_EXIT_INTERNAL_ERROR.
> 
> Is doing this preferrable to that?

Even if AMD guaranteed that the absolute worst case scenario is a failed VMRUN
with zero side effects, doing VMRUN with a bad address should be treated as a
KVM bug.

> If so, should a vcpu_unimpl() message be issued, too, to better identify the
> reason for marking the VM dead?

My vote is no.  At some point we need to assume userspace possesess a reasonable
level of competency and sanity.

> >  static void svm_inject_nmi(struct kvm_vcpu *vcpu)
> > @@ -4231,7 +4233,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
> >  	if (force_immediate_exit)
> >  		smp_send_reschedule(vcpu->cpu);
> >  
> > -	pre_svm_run(vcpu);
> > +	if (pre_svm_run(vcpu))
> > +		return EXIT_FASTPATH_EXIT_USERSPACE;
> 
> Since the return code from pre_svm_run() is never used, should it just
> be a bool function, then?

Hard no.  I strongly dislike boolean returns for functions that aren't obviously
predicates, because it's impossible to determine the polarity of the return value
based solely on the prototype.  This leads to bugs that are easier to detect with
0/-errno return, e.g. returning -EINVAL in a happy path stands out more than
returning the wrong false/true value.

Case in point (because I just responded to another emain about this function),
what's the polarity of this helper?  :-)

  static bool sanity_check_entries(struct kvm_cpuid_entry2 __user *entries,
				   __u32 num_entries, unsigned int ioctl_type)

