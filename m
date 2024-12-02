Return-Path: <kvm+bounces-32844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 327A59E0B43
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 19:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC4082827EC
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:44:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7DA1DE2AD;
	Mon,  2 Dec 2024 18:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1tsRKX4g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FB17E0E8
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 18:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733165068; cv=none; b=aORBwLQ65vAE8k71atdfYcGVoeVaRDlILlgk1f+zjj5seAriFjzJtAryStBZDLENCp16tLBsp2RSxgHgVT7gUt4LuKc94lZ4s6Z3ZWfDpbgUfAoovAPgguEmPbvJhDJv6ptqrkuDQjyvGg0uiVbywSC+0asxM7n+1hdHxNG5ZNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733165068; c=relaxed/simple;
	bh=XMiiPXZTYZeEpJBk8U9EnSPpjw/bdDBl+/T3JKR0A3M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gpO7ANTD+fy30gyqXC2inEeD/97I8ebVUB+5Jef1Cup0cKCFRzo0riYlcRBNoX3f09QHh6y48390VF53BbjVrK04ELZgOjAX3IARvowESIlG4AC3LxWWH2Lsg3NNzhAXS3Ip4SF2Kw+v2XCGSfU/cTrhW6LgZSkgtRs1Os5GTAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1tsRKX4g; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee5668e09bso3506269a91.3
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 10:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733165066; x=1733769866; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EvvKZTjXnx9iZrBeE4PJ9zcvpwtrkWJI0eWnaDHr26c=;
        b=1tsRKX4gsz81xZWF8Rd4T1LISMWDknrrebgP42fUUNxwPWCs+ItM8v1gOcS3VYGjqI
         6T2gW72fC6Veq/ukpqzccKpicEQPVP64kBU0cInNX23nvoyBg8PbGTZ/PB+haewB3rnl
         Det8eSXfQuSXdqF1ao1fGepIIDRVxboym+YQBvrYymr/hP0QUd0G81uNORetIro5ymhP
         puUiqemJj0Zs/Upb4lUZs7tmiNNhtxsCkpUnsdcHQc36ZQqdbugD6q6/tMLgmdISORL8
         IZSc5kj06+wzKa6x9yL/oO5S01qBSxnMYS8CLIumPegVlkh1aklfHrCzQoKJWh3d5eC3
         TuGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733165066; x=1733769866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EvvKZTjXnx9iZrBeE4PJ9zcvpwtrkWJI0eWnaDHr26c=;
        b=Cx0NxiIpm/gZ05LoMR+OgukPRhDhvihOTAgkqicdbf3PXmj0IDySiL2/Kb1M+J9MuI
         C0N1PxgpqYf85omm7KUUM4PF9IVY0GECSAmKn7XPcqFVRORxVXfOSnViPsjJPc4mesOz
         3gWnoZToWP2GaBqOFLWPACmIItLcDkq+u2Vlgrm1MYyr0m+dSx5C2rBepawwBgv5VJtx
         gLd/p3fEsK6XqEQjJrDFCm8ww51UcotUDcz0PbOgl3fecEUhIEkryzZ5QRkSQtN+L27W
         oVmH0BYawEzZVpy3HKKtmW0paNwnmsP/odv+vavzyqEcAyI8T1KwoJpmF9eMhmk3XF3Q
         bVkA==
X-Forwarded-Encrypted: i=1; AJvYcCXs0VXD9ucm5KjOSsiPJx0zC1Enz3sthE1EzphCwNgqxabTPSFxCI77N9ETSbRrPybB7hs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk0cejl/ofEV4GuhLf97wvohHigs7HJa9uTPfhYDPoGWQCwM7M
	ptRMlA6DR8b5AUpiW0fvmM17yBZh7f/cbeeQjJggmrfcCvigAkCRMq2dyumtiiiBBpgLKaR5EQx
	qNQ==
X-Google-Smtp-Source: AGHT+IGY/pWE/JvM1zeCaiXWWtmArKkTSnFTXrJ8bYSxAS/RlH7PaacfBmlD9LvJsCAXHrFgB51idE3WnAQ=
X-Received: from pjbli9.prod.google.com ([2002:a17:90b:48c9:b0:2e9:38ea:ca0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:388b:b0:2ee:f80c:6884
 with SMTP id 98e67ed59e1d1-2eef80c6ae0mr1153622a91.33.1733165066275; Mon, 02
 Dec 2024 10:44:26 -0800 (PST)
Date: Mon, 2 Dec 2024 10:44:24 -0800
In-Reply-To: <ce45a9cb-44a4-4a3d-bc81-608a0871ae6d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128004344.4072099-1-seanjc@google.com> <20241128004344.4072099-6-seanjc@google.com>
 <ce45a9cb-44a4-4a3d-bc81-608a0871ae6d@intel.com>
Message-ID: <Z04ACJSrBSPlyqY4@google.com>
Subject: Re: [PATCH v4 5/6] KVM: x86: Always complete hypercall via function callback
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 28, 2024, Xiaoyao Li wrote:
> On 11/28/2024 8:43 AM, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 11434752b467..39be2a891ab4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9982,10 +9982,11 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
> >   	return kvm_skip_emulated_instruction(vcpu);
> >   }
> > -unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> > -				      unsigned long a0, unsigned long a1,
> > -				      unsigned long a2, unsigned long a3,
> > -				      int op_64_bit, int cpl)
> > +int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> > +			    unsigned long a0, unsigned long a1,
> > +			    unsigned long a2, unsigned long a3,
> > +			    int op_64_bit, int cpl,
> > +			    int (*complete_hypercall)(struct kvm_vcpu *))
> >   {
> >   	unsigned long ret;
> > @@ -10061,7 +10062,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> >   			vcpu->run->hypercall.flags |= KVM_EXIT_HYPERCALL_LONG_MODE;
> >   		WARN_ON_ONCE(vcpu->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);
> > -		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
> > +		vcpu->arch.complete_userspace_io = complete_hypercall;
> >   		/* stat is incremented on completion. */
> >   		return 0;
> >   	}
> > @@ -10071,13 +10072,15 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> >   	}
> >   out:
> > -	return ret;
> > +	vcpu->run->hypercall.ret = ret;
> > +	complete_hypercall(vcpu);
> > +	return 1;
> 
> shouldn't it be
> 
> 	return complete_hypercall(vcpu);
> 
> ?

Ouch.  Yes, it most definitely should be.

> Originally, kvm_emulate_hypercall() returns kvm_skip_emulated_instruction().
> Now it becomes
> 
> 	kvm_skip_emulated_instruction();
> 	return 1;
> 
> I don't go deep to see if kvm_skip_emulated_instruction() always return 1
> for this case.

It doesn't.  KVM needs to exit to userspace if userspace is single-stepping, or
in the extremely unlikely scenario that KVM can't skip the emulated instruction
(which can very theoretically happen on older AMD CPUs).

