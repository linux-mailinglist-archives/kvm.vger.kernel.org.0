Return-Path: <kvm+bounces-4400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E15A18120FD
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 22:55:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B70C1F219DC
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 21:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99A5E7FBBC;
	Wed, 13 Dec 2023 21:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QG1ufpIW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D3810C;
	Wed, 13 Dec 2023 13:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702504527; x=1734040527;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o2lEbwHxUNP/lL0Zv5x84LTlhNESluWyXeo3F7KR8cs=;
  b=QG1ufpIWnyLB6Up/SG/2/l0SBsGxKtIXVr9pqrSIXikgVjTw7BH93F5V
   3K3N2STz19gAQGHcapG1HsRgcSz4nwHKgKBG5bOBWJhZAroMqy54coHb1
   H8sAIUJED7wa84abxrJH1xKF+zAoRhlrGcO+G2Z3WOs1KiNNkqoIhQ/Sp
   B2J/eLnKdkLYuD80ER/h/2oDnz9oQqBROtanRtMjHw3dQ/+t4R13TbW5o
   PsWfTEKYve1sPwIIZwR7QNC/ca3auSOAszXHKLt+6puaNGU562MpIc3fs
   RHybNZTKqE3wUeERDn4xaxcbejNnU6A9ySpXe/+IzMP2TopElH8LjLBfd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="2176917"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="2176917"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 13:55:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="808320353"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="808320353"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 13:55:26 -0800
Date: Wed, 13 Dec 2023 14:00:21 -0800
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
Subject: Re: [PATCH RFC 13/13] iommu/vt-d: Enable posted mode for device
 MSIs
Message-ID: <20231213140021.4cc84bb2@jacob-builder>
In-Reply-To: <87zfynt6uo.ffs@tglx>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
	<20231112041643.2868316-14-jacob.jun.pan@linux.intel.com>
	<87zfynt6uo.ffs@tglx>
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

On Wed, 06 Dec 2023 21:26:55 +0100, Thomas Gleixner <tglx@linutronix.de>
wrote:

> On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:
> >  #ifdef CONFIG_X86_POSTED_MSI
> >  
> >  static u64 get_pi_desc_addr(struct irq_data *irqd)
> > @@ -1133,6 +1144,29 @@ static u64 get_pi_desc_addr(struct irq_data
> > *irqd) 
> >  	return __pa(per_cpu_ptr(&posted_interrupt_desc, cpu));
> >  }
> > +
> > +static void intel_ir_reconfigure_irte_posted(struct irq_data *irqd)
> > +{
> > +	struct intel_ir_data *ir_data = irqd->chip_data;
> > +	struct irte *irte = &ir_data->irte_entry;
> > +	struct irte irte_pi;
> > +	u64 pid_addr;
> > +
> > +	pid_addr = get_pi_desc_addr(irqd);
> > +
> > +	memset(&irte_pi, 0, sizeof(irte_pi));
> > +
> > +	/* The shared IRTE already be set up as posted during
> > alloc_irte */  
> 
> -ENOPARSE
Will delete this. What I meant was that the shared IRTE has already been
setup as posted mode instead of remappable mode. So when we make a copy,
there is no need to change the mode.

> > +	dmar_copy_shared_irte(&irte_pi, irte);
> > +
> > +	irte_pi.pda_l = (pid_addr >> (32 - PDA_LOW_BIT)) & ~(-1UL <<
> > PDA_LOW_BIT);
> > +	irte_pi.pda_h = (pid_addr >> 32) & ~(-1UL << PDA_HIGH_BIT);
> > +
> > +	modify_irte(&ir_data->irq_2_iommu, &irte_pi);
> > +}
> > +
> > +#else
> > +static inline void intel_ir_reconfigure_irte_posted(struct irq_data
> > *irqd) {} #endif
> >  
> >  static void intel_ir_reconfigure_irte(struct irq_data *irqd, bool
> > force) @@ -1148,8 +1182,9 @@ static void
> > intel_ir_reconfigure_irte(struct irq_data *irqd, bool force)
> > irte->vector = cfg->vector; irte->dest_id = IRTE_DEST(cfg->dest_apicid);
> >  
> > -	/* Update the hardware only if the interrupt is in remapped
> > mode. */
> > -	if (force || ir_data->irq_2_iommu.mode == IRQ_REMAPPING)
> > +	if (ir_data->irq_2_iommu.posted_msi)
> > +		intel_ir_reconfigure_irte_posted(irqd);
> > +	else if (force || ir_data->irq_2_iommu.mode == IRQ_REMAPPING)
> >  		modify_irte(&ir_data->irq_2_iommu, irte);
> >  }
> >  
> > @@ -1203,7 +1238,7 @@ static int intel_ir_set_vcpu_affinity(struct
> > irq_data *data, void *info) struct intel_ir_data *ir_data =
> > data->chip_data; struct vcpu_data *vcpu_pi_info = info;
> >  
> > -	/* stop posting interrupts, back to remapping mode */
> > +	/* stop posting interrupts, back to the default mode */
> >  	if (!vcpu_pi_info) {
> >  		modify_irte(&ir_data->irq_2_iommu,
> > &ir_data->irte_entry); } else {
> > @@ -1300,10 +1335,14 @@ static void
> > intel_irq_remapping_prepare_irte(struct intel_ir_data *data, {
> >  	struct irte *irte = &data->irte_entry;
> >  
> > -	prepare_irte(irte, irq_cfg->vector, irq_cfg->dest_apicid);
> > +	if (data->irq_2_iommu.mode == IRQ_POSTING)
> > +		prepare_irte_posted(irte);
> > +	else
> > +		prepare_irte(irte, irq_cfg->vector,
> > irq_cfg->dest_apicid); 
> >  	switch (info->type) {
> >  	case X86_IRQ_ALLOC_TYPE_IOAPIC:
> > +		prepare_irte(irte, irq_cfg->vector,
> > irq_cfg->dest_apicid);  
> 
> What? This is just wrong. Above you have:
> 
> > +	if (data->irq_2_iommu.mode == IRQ_POSTING)
> > +		prepare_irte_posted(irte);
> > +	else
> > +		prepare_irte(irte, irq_cfg->vector,
> > irq_cfg->dest_apicid);  
> 
> Can you spot the fail?
My bad, I forgot to delete this.

It is probably easier just override the IRTE for the posted MSI case.
@@ -1274,6 +1354,11 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data 
*data,
                break;
        case X86_IRQ_ALLOC_TYPE_PCI_MSI:
        case X86_IRQ_ALLOC_TYPE_PCI_MSIX:
+               if (posted_msi_supported()) {
+                       prepare_irte_posted(irte);
+                       data->irq_2_iommu.posted_msi = 1;
+               }
+

> 
> >  		/* Set source-id of interrupt request */
> >  		set_ioapic_sid(irte, info->devid);
> >  		apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: Set
> > IRTE entry (P:%d FPD:%d Dst_Mode:%d Redir_hint:%d Trig_Mode:%d
> > Dlvry_Mode:%X Avail:%X Vector:%02X Dest:%08X SID:%04X SQ:%X SVT:%X)\n",
> > @@ -1315,10 +1354,18 @@ static void
> > intel_irq_remapping_prepare_irte(struct intel_ir_data *data, sub_handle
> > = info->ioapic.pin; break; case X86_IRQ_ALLOC_TYPE_HPET:
> > +		prepare_irte(irte, irq_cfg->vector,
> > irq_cfg->dest_apicid); set_hpet_sid(irte, info->devid);
> >  		break;
> >  	case X86_IRQ_ALLOC_TYPE_PCI_MSI:
> >  	case X86_IRQ_ALLOC_TYPE_PCI_MSIX:
> > +		if (posted_msi_supported()) {
> > +			prepare_irte_posted(irte);
> > +			data->irq_2_iommu.posted_msi = 1;
> > +		} else {
> > +			prepare_irte(irte, irq_cfg->vector,
> > irq_cfg->dest_apicid);
> > +		}  
> 
> Here it gets even more hilarious.


Thanks,

Jacob

