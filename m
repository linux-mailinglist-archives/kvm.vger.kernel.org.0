Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD6B287467
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 14:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgJHMlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 08:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729824AbgJHMlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 08:41:00 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EAEC061755;
        Thu,  8 Oct 2020 05:41:00 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602160858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kxroEkMT5O65MYaakoHs0S8A9ZmiZNNxOQXIf8c8848=;
        b=JLDQ1enhdPqwwGJ5u5iLQdncHS+AbvmH1KrMD2IlYekyh7j9CW12Hv2CPrmTOQsB1gbd7W
        WWCLTLCJNROx4TH73Ruqxh6TtIy+TjG6YEMz5J+oq09SAgqb/8IqGKwh6DBMRqPTKuc4IC
        GzCvN0BymNNn0pA8i80JsUVHKcuvNfNOOFXtDjUiOmkPWm6Y+gl6ZCImvNepV+zMyEFUOc
        QvuIJtXHF/tw3qCpqv5eYl/lqoQjjkQAeQEE5+P/VVyhYIZYun4GZvMhFuapuxp8Kt1GDb
        cLiTdIWfxLH+8uXndFnW5nBRR9HGYAjUxPYQr5v/SmL6d94vv8+72Eo+P3+nBw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602160858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kxroEkMT5O65MYaakoHs0S8A9ZmiZNNxOQXIf8c8848=;
        b=sPUfW/DhvQqEeWAtPcFjW5eFspwuXzH2Lv6Nnhu3oJHl0XOqEDHX9HxfDANeYaLgerp4hl
        MCMG1lir+ZiOT6Bg==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/13] irqdomain: Add max_affinity argument to irq_domain_alloc_descs()
In-Reply-To: <2c0712352812ab114cb711236703fd7c308a5bf2.camel@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-7-dwmw2@infradead.org> <87lfgj59mp.fsf@nanos.tec.linutronix.de> <75d79c50d586c18f0b1509423ed673670fc76431.camel@infradead.org> <87tuv640nw.fsf@nanos.tec.linutronix.de> <336029ca32524147a61b6fa1eb734debc9d51a00.camel@infradead.org> <87a6wy3u6n.fsf@nanos.tec.linutronix.de> <119c2f993cac5d57c54d4720addc9f32bf1daadd.camel@infradead.org> <87k0w12h8u.fsf@nanos.tec.linutronix.de> <2c0712352812ab114cb711236703fd7c308a5bf2.camel@infradead.org>
Date:   Thu, 08 Oct 2020 14:40:57 +0200
Message-ID: <878scgx546.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 08 2020 at 12:10, David Woodhouse wrote:
> On Thu, 2020-10-08 at 11:34 +0200, Thomas Gleixner wrote:
>> The overall conclusion for this is:
>> 
>>  1) X2APIC support on bare metal w/o irq remapping is not going to
>>     happen unless you:
>> 
>>       - added support in multi-queue devices which utilize managed
>>         interrupts
>>         
>>       - audited the whole tree for other assumptions related to the
>>         reachability of possible CPUs.
>> 
>>     I'm not expecting you to be done with that before I retire so for
>>     me it's just not going to happen :)
>
> Makes sense. It probably does mean we should a BUG_ON for the case
> where IRQ remapping *is* enabled but any device is found which isn't
> behind it. But that's OK.

We can kinda gracefully handle that. See the completely untested and
incomplete patch below.

>>  2) X2APIC support on VIRT is possible if the extended ID magic is
>>     supported by the hypervisor because that does not make any CPU
>>     unreachable for MSI and therefore the multi-queue muck and
>>     everything else just works.
>> 
>>     This requires to have either the domain affinity limitation for HPET
>>     in place or just to force disable HPET or at least HPET-MSI which is
>>     a reasonable tradeoff.
>> 
>>     HPET is not required for guests which have kvmclock and
>>     APIC/deadline timer and known (hypervisor provided) frequencies.
>
> HPET-MSI should work fine. Like the IOAPIC, it's just a child of the
> *actual* MSI domain. The address/data in the MSI message are completely
> opaque to it, and if the parent domain happens to put meaningful
> information into bits 11-5 of the MSI address, the HPET won't even
> notice.
>
> The HPET's Tn_FSB_INT_ADDR register does have a full 32 bits of the MSI
> address; it's not doing bit-swizzling like the IOAPIC does, which might
> potentially *not* have been able to set certain bits in the MSI.

Indeed. I thought it was crippled in some way, but you're right it has
all the bits.

Thanks,

        tglx
---
Subject: x86/iommu: Make interrupt remapping more robust
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 08 Oct 2020 14:09:44 +0200

Needs to be split into pieces and cover PCI proper. Right now PCI gets a
NULL pointer assigned which makes it explode at the wrong place
later. Also hyperv iommu wants some love.

NOT-Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c      |    4 +++-
 arch/x86/kernel/apic/msi.c          |   24 ++++++++++++++----------
 drivers/iommu/amd/iommu.c           |    6 +++---
 drivers/iommu/intel/irq_remapping.c |    4 ++--
 4 files changed, 22 insertions(+), 16 deletions(-)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2300,7 +2300,9 @@ static int mp_irqdomain_create(int ioapi
 	info.type = X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT;
 	info.devid = mpc_ioapic_id(ioapic);
 	parent = irq_remapping_get_irq_domain(&info);
-	if (!parent)
+	if (IS_ERR(parent))
+		return PTR_ERR(parent);
+	else if (!parent)
 		parent = x86_vector_domain;
 	else
 		name = "IO-APIC-IR";
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -415,9 +415,9 @@ static struct msi_domain_info hpet_msi_d
 struct irq_domain *hpet_create_irq_domain(int hpet_id)
 {
 	struct msi_domain_info *domain_info;
+	struct fwnode_handle *fn = NULL;
 	struct irq_domain *parent, *d;
 	struct irq_alloc_info info;
-	struct fwnode_handle *fn;
 
 	if (x86_vector_domain == NULL)
 		return NULL;
@@ -432,25 +432,29 @@ struct irq_domain *hpet_create_irq_domai
 	init_irq_alloc_info(&info, NULL);
 	info.type = X86_IRQ_ALLOC_TYPE_HPET_GET_PARENT;
 	info.devid = hpet_id;
+
 	parent = irq_remapping_get_irq_domain(&info);
-	if (parent == NULL)
+	if (IS_ERR(parent))
+		goto fail;
+	else if (!parent)
 		parent = x86_vector_domain;
 	else
 		hpet_msi_controller.name = "IR-HPET-MSI";
 
 	fn = irq_domain_alloc_named_id_fwnode(hpet_msi_controller.name,
 					      hpet_id);
-	if (!fn) {
-		kfree(domain_info);
-		return NULL;
-	}
+	if (!fn)
+		goto fail;
 
 	d = msi_create_irq_domain(fn, domain_info, parent);
-	if (!d) {
-		irq_domain_free_fwnode(fn);
-		kfree(domain_info);
-	}
+	if (!d)
+		goto fail;
 	return d;
+
+fail:
+	irq_domain_free_fwnode(fn);
+	kfree(domain_info);
+	return NULL;
 }
 
 int hpet_assign_irq(struct irq_domain *domain, struct hpet_channel *hc,
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3557,7 +3557,7 @@ static struct irq_domain *get_irq_domain
 	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
 
 	if (!iommu)
-		return NULL;
+		return ERR_PTR(-ENODEV);
 
 	switch (info->type) {
 	case X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT:
@@ -3565,7 +3565,7 @@ static struct irq_domain *get_irq_domain
 		return iommu->ir_domain;
 	default:
 		WARN_ON_ONCE(1);
-		return NULL;
+		return ERR_PTR(-ENODEV);
 	}
 }
 
@@ -3578,7 +3578,7 @@ static struct irq_domain *get_irq_domain
 
 	devid = get_devid(info);
 	if (devid < 0)
-		return NULL;
+		return ERR_PTR(-ENODEV);
 	return get_irq_domain_for_devid(info, devid);
 }
 
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -212,7 +212,7 @@ static struct irq_domain *map_hpet_to_ir
 		if (ir_hpet[i].id == hpet_id && ir_hpet[i].iommu)
 			return ir_hpet[i].iommu->ir_domain;
 	}
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static struct intel_iommu *map_ioapic_to_iommu(int apic)
@@ -230,7 +230,7 @@ static struct irq_domain *map_ioapic_to_
 {
 	struct intel_iommu *iommu = map_ioapic_to_iommu(apic);
 
-	return iommu ? iommu->ir_domain : NULL;
+	return iommu ? iommu->ir_domain : ERR_PTR(-ENODEV);
 }
 
 static struct irq_domain *map_dev_to_ir(struct pci_dev *dev)
