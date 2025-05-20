Return-Path: <kvm+bounces-47181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 583ACABE4E5
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 22:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2644D7B1433
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 20:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A832C28E619;
	Tue, 20 May 2025 20:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eJ0BMXIo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBD428E605
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 20:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747773392; cv=none; b=qENtlJ8KQo6obolUTpwr4RLkdNpYcTjVR1uIg7WcEuCZgRDaakD/S9nygdvM8GHnaz2LPRj7GNesyjzgqDMUq4U5b1rkiOnbe8o+q9/VMI+sCCGf4WNEjauegJqYC4KzgRlCERT75m8BB6Rvx8uGRD8hFJE+zf3bSmZDKRE6t14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747773392; c=relaxed/simple;
	bh=ZKfsnzKjHWRvUGjeYrgiENx6pawfGlJOEUf65hQxSqs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bn7FJYD7EHgFQuo/D8fHOy1A+TI9X1yw7Ov0v5qTMqS3vcgwDxYl2zHbsSbMbvTOPL7Lmk+namE6JaBIpjWzwvySZh+4XlM6Jj3k6DMqFvWKDjfLva0C1knb12dYKmQj6F+TT6V2NEQ9lfCvE8L+nJdx0vvefWAqolDvkTp8VJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eJ0BMXIo; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26e33ae9d5so6392965a12.1
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 13:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747773390; x=1748378190; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NikUqd8YUJYJZVQ9NNWuumuHYhTthKmVTkOJEDEId4g=;
        b=eJ0BMXIoRkkjyt9enk90GhZdOAd60XB7FknBFhErmP28/fKyBCrdsP3V0HvRDZL+6P
         W+eYep8StJ51XP6xLNekeht8MSkDqd3L4z0SEzHqgddIkAgQiR0kRgt+ERRbVsHfTH+R
         KfhCWrhEuTygkJ+LmC/q+pPby/jxNs1PRd6cDbNjJEcettnNb7CmrxbJODi9p9XBK8lZ
         aXWcBKRoaz32gQm4MCIS3jjZWMhI66Sj/ItL2/xG3ErUDyRhF/OE8Ih79R4njhgnmYKG
         M2e6V3xKVXUMMOPnFiBLLuEQ4/uEsMM1+JIMSqBxwjx0RZrwXb7u6J9Nf79A91OJuGwU
         uQ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747773390; x=1748378190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NikUqd8YUJYJZVQ9NNWuumuHYhTthKmVTkOJEDEId4g=;
        b=ioLILvBi9hvw0VG43zFBXIjs5Rj9mqUWGuUnxi8z867lNM053iARqX2rJTMNW94yrM
         OnXdWyuELrzhRO51LUaujzCvNzk+XDfmTa0p44BY9Eh1VvfTWmo3i92aq7XUS1A9bqR7
         9LArhBgMubOydUfQiRfw0p8rFA0SSNDfhe7pTx6HKK+Wx8r8Wzla8HJfnDuFmvDveoPI
         5V53O8NfQqeidsFdzadxEUddDHp/ui2uy4tNbkplgVb0I6rLHQDXBgBrSO25nnjW9WMD
         TeKvsi4QO2+HXr4lEXiIeKMFGruywlyMiko2b7vcLi+0FvRQaRJOvXuWVMkSD/RD0s5d
         n8Dw==
X-Forwarded-Encrypted: i=1; AJvYcCWU61ymj0IAOhCuxVCfH2fVAKrkyCuOhiB81LSLe1vjQmkyjmU+rpEBxVGwLJ4mrZVqwyE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/Nmdz2agRVdiZBhGxJUrBKRm/e+mcXB0CWz63qUI0mHOhfeIh
	b1u4iyMr9c8Klch02044j+2+Oo2m3+8H/hU2Fx+4fU6eqW9a+ibVNr+U4El1GpL9oqWJeI/BzeF
	jViX7ug==
X-Google-Smtp-Source: AGHT+IHP6rysVOKSkISEgr29agj9TpppemjJvlT6UOUwgsn7uAspuzrIU/dBu0EIRPFTBgRjNvR+rZRe+h0=
X-Received: from pjbph15.prod.google.com ([2002:a17:90b:3bcf:b0:2f9:dc36:b11])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d44:b0:30e:7d09:2a7
 with SMTP id 98e67ed59e1d1-30e83107ed7mr28064460a91.14.1747773390587; Tue, 20
 May 2025 13:36:30 -0700 (PDT)
Date: Tue, 20 May 2025 13:36:29 -0700
In-Reply-To: <d270ff32-7763-40d5-a4dc-3970383571dc@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <20250404193923.1413163-31-seanjc@google.com>
 <d270ff32-7763-40d5-a4dc-3970383571dc@redhat.com>
Message-ID: <aCznzZ-SN4Pf_htE@google.com>
Subject: Re: [PATCH 30/67] KVM: VMX: Stop walking list of routing table
 entries when updating IRTE
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 08, 2025, Paolo Bonzini wrote:
> On 4/4/25 21:38, Sean Christopherson wrote:
> > Now that KVM provides the to-be-updated routing entry, stop walking the
> > routing table to find that entry.  KVM, via setup_routing_entry() and
> > sanity checked by kvm_get_msi_route(), disallows having a GSI configured
> > to trigger multiple MSIs, i.e. the for-loop can only process one entry.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/vmx/posted_intr.c | 100 +++++++++++----------------------
> >   1 file changed, 33 insertions(+), 67 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > index 00818ca30ee0..786912cee3f8 100644
> > --- a/arch/x86/kvm/vmx/posted_intr.c
> > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > @@ -268,78 +268,44 @@ int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
> >   		       unsigned int host_irq, uint32_t guest_irq,
> >   		       struct kvm_kernel_irq_routing_entry *new)
> >   {
> > -	struct kvm_kernel_irq_routing_entry *e;
> > -	struct kvm_irq_routing_table *irq_rt;
> > -	bool enable_remapped_mode = true;
> >   	struct kvm_lapic_irq irq;
> >   	struct kvm_vcpu *vcpu;
> >   	struct vcpu_data vcpu_info;
> > -	bool set = !!new;
> > -	int idx, ret = 0;
> >   	if (!vmx_can_use_vtd_pi(kvm))
> >   		return 0;
> > -	idx = srcu_read_lock(&kvm->irq_srcu);
> > -	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
> > -	if (guest_irq >= irq_rt->nr_rt_entries ||
> > -	    hlist_empty(&irq_rt->map[guest_irq])) {
> > -		pr_warn_once("no route for guest_irq %u/%u (broken user space?)\n",
> > -			     guest_irq, irq_rt->nr_rt_entries);
> > -		goto out;
> > -	}
> > -
> > -	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
> > -		if (e->type != KVM_IRQ_ROUTING_MSI)
> > -			continue;
> > -
> > -		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
> 
> Alternatively, if you want to keep patches 28/29 separate, you could add
> this WARN_ON_ONCE to avic.c in the exact same place after checking e->type
> -- not so much for asserting purposes, but more to document what's going on
> for the reviewer.

FWIW, AVIC already has the same WARN, they were both added by "KVM: x86: Pass new
routing entries and irqfd when updating IRTEs".

That said, I agree that squashing 28/29 is the way to go, especially since I didn't
isolate the changes for VMX (I've no idea why I did for SVM but not VMX).

