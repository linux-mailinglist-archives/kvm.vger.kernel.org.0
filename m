Return-Path: <kvm+bounces-43163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A96A85FE1
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 16:02:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABAAC9A09C4
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 14:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F651F2377;
	Fri, 11 Apr 2025 14:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1hFC9UUb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0471F8635A
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 14:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744380094; cv=none; b=JowyieFxu6Rrc21Xp4AA+mwRiZsHmNtRuxXGM10z7sJrhqOflFq3J4jZuqn6Oc33E5jTl57I2GbOxVcq3fYKjiqnrEeFFbFpOEl4YvOK/QGtjzdQZoPFY+mLAoNrDZ4XYbyv4+OWw5yITpujzNocqzNL6QFZaYxxvxb48f6wTAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744380094; c=relaxed/simple;
	bh=pDyKbO56Ddz2WZ550CfuDnQcBTRpV4zOKeY8l0cY+wQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zr+6OBt4SpqkX4j9wt8Yf3bJvPS1Vmh/kmBoz83TsOqYUAeftPrBKV+jPqrWGihNTZsoIVs2d6S/gEhZOKuIUhqBpSIVO+PVqHvVon95N8Sl/OG9CdztdOrad4QgbYOP5QjwinBMaTc03aNgEO04AvWHxDj9iVZFgXgD+Zivhqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1hFC9UUb; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736c7d0d35aso2548022b3a.1
        for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 07:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744380092; x=1744984892; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XcPVK4CSR1aU1haxpBUR9PW1y+UHdkqysUSf0PjchSg=;
        b=1hFC9UUbFhsEd/V37F87mXNsMykMQLD+SY5/oFINRk5kwxEq7wv5tk6rF0YRcCyaLQ
         yNuyh2x4Q5XsBQPCWOMxVAXMa9RPGW259lWgIgDFmBR4OYmb9QNUX/Lvs7E5EXyIwaA7
         xjxxtq+zSOgYW4QIKHpjZI1nvC9kPFl1Ti5ZD1PHeucuxEf1a/7CzIhVnOEh1yX/FrO2
         yyUwnkYJuXRRgN+BvLEqNDMx0NVpeb68cG/l4EguvT5AobKYDfm64gDeKvsYfZkxywJO
         jvMa3dx8er8ew0lybor8E9nk/Go0fKf9UDwwyV7B1x5cXObmU8cN1Ni9SdfG12cMTx/K
         i9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744380092; x=1744984892;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XcPVK4CSR1aU1haxpBUR9PW1y+UHdkqysUSf0PjchSg=;
        b=ZKxExymerDngQirr+NnuQsXbrRdO+t+tB6kkBfy4oo/ZgmPefqdwyq18uamxerxTs9
         8oXOUT5aNCEu8BmoVEOEk3nnLNtZRf85V9YaGoOfqTrxzBIvezkYyMErjVKpvgGcS+6R
         SvdiMTnYn8yQWjFYLXxgI8mWTghZ1lofhZAFBwqtuyTMgcP1D3Xf2QD1rWUMrYFGdPJf
         bAf8y3sfRRShOtJCnVesjhFnJVHXTjHG7pq/XpsTWwSww+d0bFwRe4jY0bNYrJokVv+6
         Xr2hOtXxi0gaDkxLwgTGnFsUYCpMi12RvJVdiv+343zBcWtdjmFuyiZG+l880jKGZ6Np
         S9pA==
X-Forwarded-Encrypted: i=1; AJvYcCXZ0udwU8gVI6QqtBwJ6awi6NWwJoEqIbV+v+Oq3WuRNwynOktrLjbqcAhSkfrlEfDey30=@vger.kernel.org
X-Gm-Message-State: AOJu0YywpznbvoEQFU0wOGzkGv3ZXnO5/TwWCLI9yQKDt2dOii+iG4cQ
	HB/D8Z2OXLstCRUTa18j5SO7obV3DQv/ld78heNPSFhidHyAOx9be5H75uwZPqx2W65y0BAa5N1
	z3A==
X-Google-Smtp-Source: AGHT+IGZRfCJBvkjvkPw1lUwltol4QErnPiBwQVl7jFbl+mdLZpKnJ7rCvLlx42UvY0fGa+iXwvt2U/eiSs=
X-Received: from pfbln21.prod.google.com ([2002:a05:6a00:3cd5:b0:730:743a:f2b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3cc2:b0:736:bfc4:ef2c
 with SMTP id d2e1a72fcca58-73bd0e8f5b1mr3705655b3a.0.1744380090507; Fri, 11
 Apr 2025 07:01:30 -0700 (PDT)
Date: Fri, 11 Apr 2025 07:01:29 -0700
In-Reply-To: <6f76183f-a903-47fd-8c84-0d9892632fca@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <20250404193923.1413163-9-seanjc@google.com>
 <6f76183f-a903-47fd-8c84-0d9892632fca@amd.com>
Message-ID: <Z_kgbna7grb833Fy@google.com>
Subject: Re: [PATCH 08/67] KVM: x86: Pass new routing entries and irqfd when
 updating IRTEs
From: Sean Christopherson <seanjc@google.com>
To: Sairaj Arun Kodilkar <sarunkod@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>, Naveen N Rao <naveen.rao@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 11, 2025, Arun Kodilkar, Sairaj wrote:
> On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> > +int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
> > +			unsigned int host_irq, uint32_t guest_irq,
> > +			struct kvm_kernel_irq_routing_entry *new)
> >   {
> >   	struct kvm_kernel_irq_routing_entry *e;
> >   	struct kvm_irq_routing_table *irq_rt;
> >   	bool enable_remapped_mode = true;
> > +	bool set = !!new;
> >   	int idx, ret = 0;
> >   	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
> > @@ -925,6 +919,8 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
> >   		if (e->type != KVM_IRQ_ROUTING_MSI)
> >   			continue;
> > +		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
> > +
> > 
> 
> Hi Sean,
> 
> In kvm_irq_routing_update() function, its possible that there are
> multiple entries in the `kvm_irq_routing_table`,

Not if one of them is an MSI.  In setup_routing_entry():

	/*
	 * Do not allow GSI to be mapped to the same irqchip more than once.
	 * Allow only one to one mapping between GSI and non-irqchip routing.
	 */
	hlist_for_each_entry(ei, &rt->map[gsi], link)
		if (ei->type != KVM_IRQ_ROUTING_IRQCHIP ||
		    ue->type != KVM_IRQ_ROUTING_IRQCHIP ||
		    ue->u.irqchip.irqchip == ei->irqchip.irqchip)
			return -EINVAL;

> and `irqfd_update()` ends up setting up the new entry type to 0 instead of
> copying the entry.
> 
> if (n_entries == 1)
>     irqfd->irq_entry = *e;
> else
>     irqfd->irq_entry.type = 0;
> 
> Since irqfd_update() did not copy the entry to irqfd->entries, the "new"
> will not match entry "e" obtained from irq_rt, which can trigger a false
> WARN_ON.

And since there can only be one MSI, if there are multiple routing entries, then
the WARN won't be reached thanks to the continue that's just above:

		if (e->type != KVM_IRQ_ROUTING_MSI)
			continue;

