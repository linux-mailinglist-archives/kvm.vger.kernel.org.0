Return-Path: <kvm+bounces-7239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7831383E6EE
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:27:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB8BA1C2305E
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CBF457869;
	Fri, 26 Jan 2024 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cIDa0FZb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35F756473;
	Fri, 26 Jan 2024 23:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706311531; cv=none; b=WqMLGZD2ai380SCqmbYmG3IIeSZEBq5g9RcB/zpEimH5gxxgBsAJDotjiPF/49NzvwbQv7N2yxc8wUiSnn5afrrCIcLsMOfJSTmQRPzEeWx6+5xo+GkO1BRLIt+CgH5qpQ27XDu1aGGhr3XhsAyLzpPt6D8w3Xx2Ac8pxbB6jm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706311531; c=relaxed/simple;
	bh=kMFx64NyVo89pOPt8/Nbt5gcEmGFIJLK+tf/jeK7Gjw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GE1BoQM7fCTHbuLvEStGeHug6CCtNktACwiQ5GqnLNE2w76ZvIKgGv/1+gKuiINQaCuz+ecnl5zxc5wX9Dp0MXFER3J9FY3yP6q3P4QV3jlKaTzlGRJouEc19olNJI+/cyaqx1wDOGxjoJP66fqUPASWGKcDDyQ0sK+520QSamE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cIDa0FZb; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706311529; x=1737847529;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kMFx64NyVo89pOPt8/Nbt5gcEmGFIJLK+tf/jeK7Gjw=;
  b=cIDa0FZbbRqIAejkd8C5NhI+Nqc2IqNR2jPZ0WV0xdumvH4HShgfJfNw
   xOhealDOGLReky3lKvcN5oW/LA9ZcoQiYWyRDgWh2l6j98KofTduT1vnw
   3b4U7YKIrl5+EldFlszL5jwoFiteqnMEQs0a5zZdjsG0AhmBqoC4CYsOt
   PmghdwHj/AQCFYIKikJ2O55DoHnEBSny1jN6VaAdxpOwth4tq/dLaFNlJ
   VUWHfxfDwFmLExmqMuhPdRnOw8VeYh9XnZRduhHOihMwmsUIKxwKpwOKe
   aRImZgpm8PdtKIdr7gwHMNHLrKAGFGNO3t0ZiiaQdH1yLniElTsgboSw/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="433757807"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="433757807"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:25:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="910489711"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="910489711"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:25:28 -0800
Date: Fri, 26 Jan 2024 15:30:47 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, peterz@infradead.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH RFC 12/13] iommu/vt-d: Add a helper to retrieve PID
 address
Message-ID: <20240126153047.5e42e5d0@jacob-builder>
In-Reply-To: <874jgvuls0.ffs@tglx>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
 <20231112041643.2868316-13-jacob.jun.pan@linux.intel.com>
 <874jgvuls0.ffs@tglx>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Thomas,

On Wed, 06 Dec 2023 21:19:11 +0100, Thomas Gleixner <tglx@linutronix.de>
wrote:

> On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> >
> > When programming IRTE for posted mode, we need to retrieve the
> > physical  
> 
> we need .... I surely did not write this changelog.
> 
Will delete this.

> > address of the posted interrupt descriptor (PID) that belongs to it's
> > target CPU.
> >
> > This per CPU PID has already been set up during cpu_init().  
> 
> This information is useful because?
ditto.

> > +static u64 get_pi_desc_addr(struct irq_data *irqd)
> > +{
> > +	int cpu =
> > cpumask_first(irq_data_get_effective_affinity_mask(irqd));  
> 
> The effective affinity mask is magically correct when this is called?
> 
My understanding is that remappable device MSIs have the following
hierarchy,e.g.

parent:                              
    domain:  INTEL-IR-5-13            
     hwirq:   0x20000                 
     chip:    INTEL-IR-POST           
      flags:   0x0                    
     parent:                          
        domain:  VECTOR            
         hwirq:   0x3c             
         chip:    APIC         

When irqs are allocated and activated, parents domain op is always called
first. Effective affinity mask is set up by the parent domain, i.e. VECTOR.
Example call stack for alloc:
	irq_data_update_effective_affinity
	apic_update_irq_cfg
	x86_vector_alloc_irqs
	intel_irq_remapping_alloc
	msi_domain_alloc

x86_vector_activate also changes the effective affinity mask before calling
intel_irq_remapping_activate() where a posted interrupt is configured for
its destination CPU.

At runtime, when IRQ affinity is changed by userspace Intel interrupt
remapping code also calls parent data/chip to update the effective affinity
map before changing IRTE.

intel_ir_set_affinity(struct irq_data *data, const struct cpumask *mask,
		      bool force)
{
	ret = parent->chip->irq_set_affinity(parent, mask, force);

...
}
Here the parent APIC chip does apic_set_affinity() which will set up
effective mask before posted MSI affinity change.

Maybe I missed some cases?

I will also add a check if the effective affinity mask is not set up.

static phys_addr_t get_pi_desc_addr(struct irq_data *irqd)
{
	int cpu = cpumask_first(irq_data_get_effective_affinity_mask(irqd));

	if (WARN_ON(cpu >= nr_cpu_ids))
		return 0;

	return __pa(per_cpu_ptr(&posted_interrupt_desc, cpu));
}


Thanks,

Jacob

