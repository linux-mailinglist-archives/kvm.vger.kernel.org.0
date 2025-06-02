Return-Path: <kvm+bounces-48218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1095FACBD4B
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 00:27:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22D2E1894537
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 22:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1502F25333F;
	Mon,  2 Jun 2025 22:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TbbCX4ti"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1E1182D0
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 22:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748903211; cv=none; b=ntuiKeanonoExjy1sbe5YnxvMfWQQp3DLvH12ptGK8HD2Mwu2gK6KPY2H2veISgLHcNmYE/W3efRC+cSMamrfDrhBXBW+B2OCcVURtQcKL3oMZU2Aj1EP9TDXOQAS6vw/GXUagYv6qajYRp055Gggu43Zt/GHpKGPhiyoHciW5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748903211; c=relaxed/simple;
	bh=c+BDr4P7jNalnDKIP6u0X6a/Cl+H/puu3xwpkfVmgA8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zit2yvxK/dmK6eccaPLLhZkYFLhLfxNKJUWEjT0DegFpuYMwlVRcA2SvOYy7UWNaRjSwAQOZP1GyUU1XVMHm6p+r6qSJQA4rzTD9LV9OCgvrQTnPcmcrYq7cDhSGg5oEO3woBE4JMTtK+oNaypeK0Jaa2Ah5jpqWtOkpAnjyG/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TbbCX4ti; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-742d077bdfaso6080991b3a.2
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 15:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748903209; x=1749508009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RdJnF0896Ypx9eyH3mHj+rVd2VxznzYekZ5A4PKpgUE=;
        b=TbbCX4tiML1Zoy1lD0LMm8KI9Itvx6gAFSyWTs9kN83Uiqc+myuYJ8JBc0OL8PpXZS
         fyfzEnC+7Vszu5W5/5lh9Uw9YRtBxt6CWMDj+uOhB3t4YN0ixRzAnF3ofKekZYyllrBN
         e7Wrf522YdM6D7MaZUHU4ApA0IFSarEcD850IU0zPH00/2xo76DZ7cC5GYAVn08jOQry
         ptXjS4HMsuws761WU74Q2S0heEGOWJVQVciUNo5bSpmKzBzFiN1YmrgP/CGKU4HbnWCU
         QiPXLnWdunHp23BqHavJr+JCl7InJI5hpt8tWPzIQ0z1SvHptfMrpZsJtD2KS2w7f+Vv
         YIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748903209; x=1749508009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RdJnF0896Ypx9eyH3mHj+rVd2VxznzYekZ5A4PKpgUE=;
        b=UpvYmy4dnIE+G2qE17Uragp6sNpmO1cuk1m95HMJZvheswgdvZLULUn1266z/GzC6K
         rxmWDjOsbfbgw1flI8xwpK0m06QjsGDCAHPwRG+2I8PbYXalV5k8Tv7npjHbtWVeo+K5
         6s4peqF0CgxHktb835qss3n0r9G7hYLZ93Y6XLUxcLHJWr3qUSsUjHVuOF/mDWTMqs1e
         rLHvg99m0m1qA2Y2xgN6MPsjOizwUvMpGi63dmY/AWdo+MWQ1Lec+tJ7eyaBtt7BMv53
         RWW2vtGLFweCTewjJ0lvdHQXrm921g9BECIN7xBsdvTsoI9cU2SVl9dRZJCoWa+S9EI/
         kFeg==
X-Forwarded-Encrypted: i=1; AJvYcCWwd06/Wfc/4iowIUsdt0dvPLwHEyGf78D/x6BIh2PQiOe0Q4DQoAuIbLYBLJBFsJOQt2g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPOSBE2RVA9z4WAX/Kn7D4Zfakw6Qz0omzpw9+hOt/CBAHrQ3p
	e5qQ6J5AAoDglrW5hbXFGKL4U4ySp3xdEC+8KeM1nCXdJVj8h8kA5JZAoiQUZhdY4IMmLaue29V
	BB9IaKw==
X-Google-Smtp-Source: AGHT+IFuNo5ZnwTVE6yOLsfBnqP+WjCy7EMLzRmm6zfdCY+/FJKXvUUZBo59GAd71qcOacDTj+nt+tjQ1PY=
X-Received: from pfbit20.prod.google.com ([2002:a05:6a00:4594:b0:746:21fd:3f7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:23d1:b0:746:3200:5f8
 with SMTP id d2e1a72fcca58-747d1afd58emr12433194b3a.22.1748903208790; Mon, 02
 Jun 2025 15:26:48 -0700 (PDT)
Date: Mon, 2 Jun 2025 15:26:47 -0700
In-Reply-To: <a30dd520-b6d2-4ae8-86f8-d4f71ef3e0e0@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com> <20250523010004.3240643-42-seanjc@google.com>
 <a30dd520-b6d2-4ae8-86f8-d4f71ef3e0e0@amd.com>
Message-ID: <aD4lJyqHswt-Mofy@google.com>
Subject: Re: [PATCH v2 41/59] iommu/amd: KVM: SVM: Add IRTE metadata to
 affined vCPU's list if AVIC is inhibited
From: Sean Christopherson <seanjc@google.com>
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 30, 2025, Sairaj Kodilkar wrote:
> On 5/23/2025 6:29 AM, Sean Christopherson wrote:
> 
> > diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> > index 718bd9604f71..becef69a306d 100644
> > --- a/drivers/iommu/amd/iommu.c
> > +++ b/drivers/iommu/amd/iommu.c
> > @@ -3939,7 +3939,10 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *info)
> >   		ir_data->ga_root_ptr = (pi_data->vapic_addr >> 12);
> >   		ir_data->ga_vector = pi_data->vector;
> >   		ir_data->ga_tag = pi_data->ga_tag;
> > -		ret = amd_iommu_activate_guest_mode(ir_data, pi_data->cpu);
> > +		if (pi_data->is_guest_mode)
> > +			ret = amd_iommu_activate_guest_mode(ir_data, pi_data->cpu);
> > +		else
> > +			ret = amd_iommu_deactivate_guest_mode(ir_data);
> 
> Hi Sean,
> Why the extra nesting here ?
> Its much more cleaner to do..
> 
> if (pi_data && pi_data->is_guest_mode) {
> 	ir_data->ga_root_ptr = (pi_data->vapic_addr >> 12);
>    	ir_data->ga_vector = pi_data->vector;
>    	ir_data->ga_tag = pi_data->ga_tag;
> 	ret = amd_iommu_activate_guest_mode(ir_data, pi_data->cpu);
> } else {
> 	ret = amd_iommu_deactivate_guest_mode(ir_data);
> }

Because the intent of the change (and the long-term code) is to affine/bind the
vCPU to the IRTE metadata, while leaving the actual IRTE in remapped mode.  I.e.
connect the passed in pi_data (@info) to the the chip data:

	pi_data->ir_data = ir_data;

and set the GA root, vector and tag in the chip data.

		ir_data->ga_root_ptr = (pi_data->vapic_addr >> 12);
		ir_data->ga_vector = pi_data->vector;
		ir_data->ga_tag = pi_data->ga_tag;

That way if KVM enables AVIC, KVM can call amd_iommu_activate_guest_mode() to
switch the IRTE to vAPIC mode.

If KVM doesn't bind to the IRTE, KVM would need to track all host IRQs (Linux's
"virtual" IRQ numbers) that can be posted to the vCPU in order to active vAPIC
mode.  It would also require taking VM-wide locks in KVM in order to guarantee
accurate IRQ routing information.

FWIW, I don't love that KVM essentially backdoors into the AMD IOMMU via
amd_iommu_(de)activate_guest_mode(), but I also don't see a better alternative.
E.g. on Intel, KVM just leaves the IRTE in posted mode, and relies on the notification
vector IRQ to kick the vCPU into host mode so that KVM can manually process the
PIR.

But that trick doesn't work as well on AMD, because the "guest isn't running" IRQ
will hit whatever CPU is handling the IOMMU interrupts, not the CPU that's running
the vCPU.  I.e. it _could_ functionally be made to work, but it would likely yield
pretty poor performance (and would require a decent amount of new KVM code).

