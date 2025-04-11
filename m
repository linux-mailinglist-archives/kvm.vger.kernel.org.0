Return-Path: <kvm+bounces-43165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2032DA86030
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 16:14:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1560445EC2
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 14:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABBA01F37D8;
	Fri, 11 Apr 2025 14:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TzFOfGUE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF4B1F237A
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 14:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744380629; cv=none; b=NpuiP21WE5CziR+x0RJcAuyEsQdCz5HhUf2PoTM4xEKU4yAjmGdcHTQVZ3aP9qGurejCfjAK+zqw0wQOSPSWyYqL8HHl2WaPgLvFGWw6tTbhdvaE2QBJKsoS/WY+gq5CQxvFfiZVh09r7Mc0eOJn8sTWm6ePX6Z8FkFakxp/KTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744380629; c=relaxed/simple;
	bh=IN/+c393zV8GLe2RZvcJ5D/UQHgVQBfnFKT0jSH76NQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B0clnky0gm0B1c6pvvB8bI7Sr8k0y5/R5x+Wx1luyMcAgx0EGquCvkWTx5jcFK9+w1P4PO9NCYLH5viulNrD0+GmhPtMC5j/ErcROV1jUPl6QleePbQEulaCayVgCqjCqQAMXC6CEnI1atyACzdSHOnI7vkTQ/Id+yGqSqdh27Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TzFOfGUE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-225505d1ca5so18939165ad.2
        for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 07:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744380628; x=1744985428; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qHKInpn+xU6ux5UPqfyiTHJx6fsp5WeMoLWQfB1NP+8=;
        b=TzFOfGUE8Ihlp/kU316YQNJC16lFYVJQzokGQJ+bEc6gHFgFOaWHdvH+Jwxdgs0K1H
         0QHcyaImtB6H21leLTG7X64iBU0OanJLoQfdGkTP7m/CSXaaz7ZYklWtFNBNpm44EMr9
         /cBDaw0yVWnF5RkRcNfgq2GQ8BFl4rOYKcbPhjvwfBqeh+sU1+/V8OHmQn4pgKV9HrIq
         vZvlc/zkHzCMlI+wGkZawUNJGvjjxYiQbWvziPm6SjiUA9ZLbAwUEq6/dL/6JcsTmvOC
         Zmh1XPgomQAPWSxMQZl0UkKQrkS/1x/A3rWI3nwXfZfcvdtELYQsku+FLB62eqCiNYAh
         4aHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744380628; x=1744985428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qHKInpn+xU6ux5UPqfyiTHJx6fsp5WeMoLWQfB1NP+8=;
        b=nhsZfAUwMLV+2sO4xv4rQN7v7Hjdm0HZqnfG0X9d9hiFxMgqJV+AQrEuSL/8AzLMPf
         DUdQXznV6JyrNUw0qIIzkmEgk0z1NRLswVlCGrfA58voTuNUKNXfsu66ksV4YfAO/qRs
         QLuor8cbpRtbRLMcsNZhAkbvUy0swWIrciOvJMDcH8NsBrK0J5fws4l852dXDufqvRum
         i5bjBI7Ff181CIGQDbo7SlR2Hh8Ud5Z/bZORfn4yoAGAPPEvdOAeK3InNB8MLsA2C8W5
         vPqNfb1WrvEV5qV/s0SCX/tBTtp4rwBdux27NvMg2dSi+qob4A+tA5iAQv7Xk3NafeBR
         LJaQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/9oIUmcThdauU7mKfw2uhkKCcHdIJNdiGpfkISK8E9fozvc5d3iUxSVtbsgMTwJKpWxU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPjGT8MZxKEBNkS4lM/C6U6JRgIkD0+/FzrXLygUdma+W4lzC7
	43TKenSewoWR5im699LCCOGDYaDv919t0WgJdvJNUTWOGFs6xPAZbUUS3/A5PqZf9FBTUsMwEUz
	j4w==
X-Google-Smtp-Source: AGHT+IGc8VAEmdu1RE7oH9FrOwfX7qVcVEStmOGwcbBo53IVWdDDkx8s11OnWyHGn0RRA5FtWaNzoX9rHXg=
X-Received: from plda17.prod.google.com ([2002:a17:902:ee91:b0:221:8568:bfe3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cec9:b0:227:e980:9190
 with SMTP id d9443c01a7336-22bea4fcad1mr47422905ad.44.1744380627769; Fri, 11
 Apr 2025 07:10:27 -0700 (PDT)
Date: Fri, 11 Apr 2025 07:10:26 -0700
In-Reply-To: <0895007e-95d9-410e-8b24-d17172b0b908@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <20250404193923.1413163-7-seanjc@google.com>
 <0895007e-95d9-410e-8b24-d17172b0b908@amd.com>
Message-ID: <Z_ki0uZ9Rp3Fkrh1@google.com>
Subject: Re: [PATCH 06/67] iommu/amd: WARN if KVM attempts to set vCPU
 affinity without posted intrrupts
From: Sean Christopherson <seanjc@google.com>
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>, Naveen N Rao <naveen.rao@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 11, 2025, Sairaj Kodilkar wrote:
> On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> > WARN if KVM attempts to set vCPU affinity when posted interrupts aren't
> > enabled, as KVM shouldn't try to enable posting when they're unsupported,
> > and the IOMMU driver darn well should only advertise posting support when
> > AMD_IOMMU_GUEST_IR_VAPIC() is true.
> > 
> > Note, KVM consumes is_guest_mode only on success.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   drivers/iommu/amd/iommu.c | 13 +++----------
> >   1 file changed, 3 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> > index b3a01b7757ee..4f69a37cf143 100644
> > --- a/drivers/iommu/amd/iommu.c
> > +++ b/drivers/iommu/amd/iommu.c
> > @@ -3852,19 +3852,12 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
> >   	if (!dev_data || !dev_data->use_vapic)
> >   		return -EINVAL;
> > +	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
> > +		return -EINVAL;
> > +
> 
> Hi Sean,
> 'dev_data->use_vapic' is always zero when AMD IOMMU uses legacy
> interrupts i.e. when AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) is 0.
> Hence you can remove this additional check.

Hmm, or move it above?  KVM should never call amd_ir_set_vcpu_affinity() if
IRQ posting is unsupported, and that would make this consistent with the end
behavior of amd_iommu_update_ga() and amd_iommu_{de,}activate_guest_mode().

	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
		return -EINVAL;

	if (ir_data->iommu == NULL)
		return -EINVAL;

	dev_data = search_dev_data(ir_data->iommu, irte_info->devid);

	/* Note:
	 * This device has never been set up for guest mode.
	 * we should not modify the IRTE
	 */
	if (!dev_data || !dev_data->use_vapic)
		return -EINVAL;

I'd like to keep the WARN so that someone will notice if KVM screws up.

