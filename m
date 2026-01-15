Return-Path: <kvm+bounces-68201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED563D26145
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:07:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4184730ECA6A
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014832D3733;
	Thu, 15 Jan 2026 17:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NAGIC/IL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF2D3BF2F9
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496411; cv=none; b=N/whjraCFyJMM8tKfrdhuhvHxCpKQBmYLr5kSyad3m5VEREcgwYIpSYhQYVQyN7PvxJs59VoLVXcRoNWrh2lbKdVmKxBu0Ep0ZIjZ2m+Sy8WgFBrLca50c7BdpoZ22dJQmBxHeeC9tVHIEw2W8O1vd4/MoeJHlfV8VO1wuFZs9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496411; c=relaxed/simple;
	bh=y/UZKJlcoHp4jeUw0iKbnytOgaks1tCK+PbIg9+qdrI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NCQ32y3pZ9Cm6hr7eBbeP77GNjKJ3zNjArHrlBiISDJAkLwYYEONJBpAR/kTdSyxhvoC8R62hkzsBU+nhzcty42MaYIpgaWkyzGNxqS2GFw8/YVZTqhWroWNMfFoHm35h7BX2I8zfh4PP68LhmV0U4PphkWilT+o7HuRbqMhWuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NAGIC/IL; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-81c43a20b32so952662b3a.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 09:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768496409; x=1769101209; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5mQ0el9FMTjuqaLYqUyU5jUp2N8RNMuXFe5aEjguczE=;
        b=NAGIC/ILy9JGzdUE85cpfKxn0nzIx8Q3UT7TXNQfPpCc4Wb18hJyyTKZmgrCf6FGiQ
         X86vfxZ5PoJHwK2b7Pa99l2YWnuPh39o6l+gqdBu+NwWi6FZkCJBGSDsbLLdcAYampE/
         6LfhASz3TZDTYYGmwKsOJ63FTmIMR+56/+CRXopKhsEAn1T6Xb1Wg17VvtvfcCSPz1tZ
         R9lbBjLdUyo9kfyz4X1p57padX7nyIQaex9qgC3cf1Rnt8L+hJ11OBNamv/YmzjDRhlj
         7uzDV69HEMn/h22YFtIxsju2PFD6FoWn45vKeaBNEIXed6cJiDhjX5ExAFv3xe9V/IdQ
         UZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768496409; x=1769101209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5mQ0el9FMTjuqaLYqUyU5jUp2N8RNMuXFe5aEjguczE=;
        b=cRqT3i4pIqpG/aW5S0/01Kmmg1AsRSrll97P1Kex2bVMKuO9aRC2XuC12BX1LIxj9x
         A3iODBv4fPV9iA8CkObmje28kwXQfc/wxJpm/WDyyYnGVrndRXD/teb52TCDP1kEqFFI
         DGW0v2n07LHe7wRDeCInnYEQmb0fbBQjg57nFza4KiOF+YO55GzwNbw3T1s3dpilPSmO
         UxWHOn+ORH6Kxr8WntRn58CPo5LSi3RZ9P9opMql6anl6trbtK+90jQvJ/ypZOPuveT4
         lX4B2/OgyL5GrzZy2gNA22//b1AMispuMPKnDEeAhZ/TeF/9jLgCcOy6P8AvcWURn5Y+
         SbZA==
X-Forwarded-Encrypted: i=1; AJvYcCVBfVJBDvNhiYZAhkEYmieIy2ldAzC4QhmDQ8RATybY9J8qzYn6k/dJvGDCXnlF8R8mN8A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzO6Ny+/JE3rlmfR/hDz5kKaja8hJNWt5+qDHLWPaMgkYSwWR2E
	mjenCdKl1j/sNgt2dpETj2wMyfPfWp2+3nqy6o1UHgPk2qSpvryVAZoo2hjWWR3QZodK4hkuCTL
	26dEp9w==
X-Received: from pgg16.prod.google.com ([2002:a05:6a02:4d90:b0:c51:8b09:2a32])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a122:b0:38b:d9b0:a93f
 with SMTP id adf61e73a8af0-38dfe5e2550mr387866637.21.1768496408900; Thu, 15
 Jan 2026 09:00:08 -0800 (PST)
Date: Thu, 15 Jan 2026 09:00:07 -0800
In-Reply-To: <xndoethnkd2djh5zkemvgmuj6gc4hsnxur2uo5frl57ugxa2ql@c3k7cadxmr4u>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112174535.3132800-1-chengkev@google.com> <20260112174535.3132800-2-chengkev@google.com>
 <jmacawbcdorwi2y5ulh2l2mdpeulx5sj7qvjehvnhaa5cgdcs3@2tljlprwtl27>
 <aWhFQcNa8SKd679a@google.com> <xndoethnkd2djh5zkemvgmuj6gc4hsnxur2uo5frl57ugxa2ql@c3k7cadxmr4u>
Message-ID: <aWkdF8gz1IDssQOd@google.com>
Subject: Re: [PATCH V2 1/5] KVM: SVM: Move STGI and CLGI intercept handling
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> On Wed, Jan 14, 2026 at 05:39:13PM -0800, Sean Christopherson wrote:
> > On Mon, Jan 12, 2026, Yosry Ahmed wrote:
> > As for how to fix this, a few ideas:
> > 
> >  1. Set KVM_REQ_EVENT to force KVM to re-evulate all events.  kvm_check_and_inject_events()
> >     will see the pending NMI and/or SMI, that the NMI/SMI is not allowed, and
> >     re-call enable_{nmi,smi}_window().
> > 
> >  2. Manually check for pending+blocked NMI/SMIs.
> > 
> >  3. Combine parts of #1 and #2.  Set KVM_REQ_EVENT, but only if there's a pending
> >     NMI or SMI.
> > 
> >  4. Add flags to vcpu_svm to explicitly track if a vCPU has an NMI/SMI window,
> >     similar to what we're planning on doing for IRQs[*], and use that to more
> >     confidently do the right thing when recomputing intercepts.
> > 
> > I don't love any of those ideas.  Ah, at least not until I poke around KVM.  In
> > svm_set_gif() there's already this:
> > 
> > 		if (svm->vcpu.arch.smi_pending ||
> > 		    svm->vcpu.arch.nmi_pending ||
> > 		    kvm_cpu_has_injectable_intr(&svm->vcpu) ||
> > 		    kvm_apic_has_pending_init_or_sipi(&svm->vcpu))
> > 			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> > 
> > So I think it makes sense to bundle that into a helper, e.g. (no idea what to
> > call it)
> > 
> > static bool svm_think_of_a_good_name(struct kvm_vcpu *vcpu)
> > {
> > 	if (svm->vcpu.arch.smi_pending ||
> > 	    svm->vcpu.arch.nmi_pending ||
> > 	    kvm_cpu_has_injectable_intr(&svm->vcpu) ||
> > 	    kvm_apic_has_pending_init_or_sipi(&svm->vcpu))
> > 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> > }
> 
> Maybe svm_check_gif_events() or svm_check_gif_interrupts()?
> 
> Or maybe it's clearer if we just put the checks in a helper like
> svm_waiting_for_gif() or svm_pending_gif_interrupt().

This was my first idea as well, though I would name it svm_has_pending_gif_event()
to better align with kvm_vcpu_has_events().

I suggested a single helper because I don't love that how to react to the pending
event is duplicated.  But I definitely don't object to open coding the request if
the consensus is that it's more readable overall.

> Then in svm_recalc_instruction_intercepts() we do:
> 
> 	/*
> 	 * If there is a pending interrupt controlled by GIF, set
> 	 * KVM_REQ_EVENT to re-evaluate if the intercept needs to be set
> 	 * again to track when GIF is re-enabled (e.g. for NMI
> 	 * injection).
> 	 */
> 	svm_clr_intercept(svm, INTERCEPT_STGI);	
> 	if (svm_pending_gif_interrupt())
> 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> 
> and in svm_set_gif() it reads well semantically:
> 	
> 	enable_gif(svm);
> 	if (svm_pending_gif_interrupt())
> 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);

