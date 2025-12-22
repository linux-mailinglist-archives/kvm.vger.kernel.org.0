Return-Path: <kvm+bounces-66524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D50BCD73E3
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 23:10:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5C9F73019E0A
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 22:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F9B232D42A;
	Mon, 22 Dec 2025 22:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JJ1v2TXX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E2630FC03
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 22:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766441441; cv=none; b=tpVKIiy9fMPzAQEqOs2WXcnmuOVPoLl9Rl7oevUW2kMBVdP++CqyOCFQBk4feLcpdV50/btqaSaK57AVcI5QGh6W8whvQ7RIB+RdAi/rYJwpPgA9uV7ZDh2NnfCN8K4qctY9u5u4fcp8z+/tcWFUqgp0HGam5+1YLUzYG4luuNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766441441; c=relaxed/simple;
	bh=RqSH6KbcENeCSoSTIIQWud4cWqtCxOnMMEn5Odibjgk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LTJxpzPz1mZpaLTCpIiYkCPaMO70OGanePzsRnGkuEo6M2vGlpVBIw4I/YAVGtEa7k83WfzzYFc9IPbHCr9gX9cA3v33zWz/VhYdPjFw1l5G5vJvA2b6xgzsMfj74ovTdcT4Xjkb0VgMdv4FSBt55BMhWuXeitoLam5s4IIsfww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JJ1v2TXX; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0f0c7a06eso85191665ad.2
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 14:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766441439; x=1767046239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9715HtTznOFduyWRjJ/RpqR7EdieRfbBPMra7nL6iYs=;
        b=JJ1v2TXXTRzhHPxxTTjwY3RsqJrfH3tdsNizZKC4jVVNlWfVFkQWDtNVouuRmRXaej
         a9ii+4vUp7uZL0gGtI/dJGCQ9WW2WzdO05pW0kjzwsgICE4PKRaieWeUtUGRj1wt0Blk
         3sl5522Zf51npJw8QRkrKz3XYth7gdV8aPa5y4/OB3HOjzlgSBp8dRyxCxM1HjXK2Eqs
         57cFKzq16ZMj15euLICO+KNpaGzo8vZYJMgafTvER+JGA/3DxXKGmw39p3cP19JIOwJd
         Ow/0/iBAv69A+4iOJlS0Dhgh/uwYUNp0a3ynO70xeIi3bARWfxmiQ7rGuqdrvXdP2iw3
         yOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766441439; x=1767046239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9715HtTznOFduyWRjJ/RpqR7EdieRfbBPMra7nL6iYs=;
        b=t8bmitgWGH8R6b1a0Rp6ElIKd4JyLfFhz9ZR7Cj/NdJudo5qyz3NU3RilF8EMinE94
         Tq4hsHudJCCokYEehdLR5+n4MIj31EBxhfhRvmaxbV7OFrRFo9Ld5ow7WrLzPMGomQDy
         1z1E/g58UCcTtY0DYlSoUrkrX0/mPDEOZmaDhCbJS0FQCFtE2B2sFiHkw4w6k07Tt2d6
         PtLWBUqfnMzwPAeYsPh62ZIEiRN9t547eQXMobzRBT7ODVFEIySyYxmDJcMHyrFgbkmD
         JRUEV4uCTTbOeCiWt93JfmPo+4dzLB4rlnEgfZxVUAI7repucsaiBOhCDg6Y/wr+Yox2
         sqBg==
X-Forwarded-Encrypted: i=1; AJvYcCUQj8QGBgj9bOOsT4Z4lvYX2aVP6KyWsCSdSOvB5W3HfWazcpP3dVPKdFpINlz4TaSe/AA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlxrYSXsTZPMcutGo/G4R1xoolg8eUb6VQlY2Fp4NS7T43/1/1
	L3CmUDbZNbJTrDwjAVDuLjEenBIQS2a/RmJrzl7n+anp6lSguZfAQ+rnSfgc7MyMlo3PZaun/gO
	7fCmfAA==
X-Google-Smtp-Source: AGHT+IElsJc59hwdn+BH0pp7IxsX2bM6BeSQ8eCoKXCAmrz5eNfcwC6En114KJ5EJbbxgh/j09hzULxKtUg=
X-Received: from plry8.prod.google.com ([2002:a17:902:b488:b0:269:8ca7:6998])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d50a:b0:295:290d:4afa
 with SMTP id d9443c01a7336-2a2f242aaa6mr132352445ad.23.1766441439191; Mon, 22
 Dec 2025 14:10:39 -0800 (PST)
Date: Mon, 22 Dec 2025 14:10:37 -0800
In-Reply-To: <9218dafc-c6ad-4ef3-b869-2d6d4a308181@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-40-seanjc@google.com>
 <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
 <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com> <aUmdSb3d7Z5REMLk@google.com>
 <9218dafc-c6ad-4ef3-b869-2d6d4a308181@redhat.com>
Message-ID: <aUnB3WNLYape2Nap@google.com>
Subject: Re: possible deadlock due to irq_set_thread_affinity() calling into
 the scheduler (was Re: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock
 across IRTE updates in IOMMU)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Soni <Ankit.Soni@amd.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>, 
	Naveen Rao <Naveen.Rao@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 22, 2025, Paolo Bonzini wrote:
> On 12/22/25 20:34, Sean Christopherson wrote:
> > On Mon, Dec 22, 2025, Paolo Bonzini wrote:
> > > notably, __setup_irq() calls wake_up_process outside desc->lock.  Therefore
> > > I'd like so much to treat it as a kernel/irq/ bug; and the simplest (perhaps
> > > too simple...) fix is to drop the wake_up_process().  The only cost is extra
> > > latency on the next interrupt after an affinity change.
> > 
> > Alternatively, what if we rework the KVM<=>IOMMU exchange to decouple updating
> > the IRTE from binding the metadata to the vCPU?  KVM already has the necessary
> > exports to do "out-of-band" updates due to the AVIC architecture requiring IRTE
> > updates on scheduling changes.
> 
> In fact this was actually my first idea, exactly because it makes
> svm->ir_list_lock a leaf lock!
> 
> I threw it away because it makes amd_ir_set_vcpu_affinity() weird, passing
> back the ir_data but not really doing anything else.  Basically its role
> becomes little more than violate abstractions, which seemed wrong.  On the
> other hand, drivers/iommu is already very much tied to the KVM vendor
> modules (in particular avic.c already calls
> amd_iommu_{,de}activate_guest_mode), so who am I to judge what the IOMMU
> driver does.

Yeah, I 100% agree the whole thing is a bit gross, but practically speaking it's
just not feasible to properly abstract the interaction, because in reality the
IOMMU implementation is tightly coupled to the CPU implementation.  E.g. passing
in the address of a PID isn't going to work well with an AMD IOMMU, and passing
in the address of a vCPI isn't going to work well with an Intel IOMMU.

And FWIW, the lack of true abstraction isn't limited to x86.  ARM's GIGv4 passes
around "struct its_cmd_info" and PPC uses "struct kvmppc_xive_irq_state".

I mean, we could do what GICv4 does and use irq_set_vcpu_affinity() to pass
different commands to the IOMMU, e.g. by formalizing "enum avic_vcpu_action"
between KVM and IOMMU so that avic_update_iommu_vcpu_affinity() wouldn't need to
_directly_ call AMD IOMMU code.  But IMO that would be a net negative because in
practice all it would do is make it harder to understand what's going on.  And
it would more directly create this potential deadlock.

Huh.  Which begs the question of whether or not ARM is also affected by this
deadlock, without the extra hop through svm->ir_list_lock:

  (a) irq_set_thread_affinity() triggers the scheduler via wake_up_process(),
      while irq_desc->lock is taken

  (b) the scheduler calls into KVM with rq_lock taken, and KVM uses
      irq_set_vcpu_affinity() via vgic_v4_{load,put}()

If ARM is affected, then maybe fixing this in irq_set_thread_affinity() is indeed
better than fudging around the deadlock in avic.c.

