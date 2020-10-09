Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72CC288BC3
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 16:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388819AbgJIOob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 10:44:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58408 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387662AbgJIOob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 10:44:31 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602254668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JygW1fCWN1B+DwaBqcLYhEsiyZH5SP6AAs9rfTd3su0=;
        b=IXP9Bq+XJCru4c+TmNDYcpotU9xYdweV7P4HKzcUFW8l8uKMmH4PBSYXL8GiAUdp4NPEPg
        1LNUSxnsIca5EP3SSmNPfkJS2gVVS7MlKTyag66pHtI2Ag4JYwxpap61eZ18PJ5dw/oTa6
        iUdyQ6SZ+N7EO5l4LLZE81h3iwAYXMXC/z6cTABQJrOqr9/lYeAtedyfRsoOMl+UcMENK/
        u/SpRdo8zZH9werNQHKhd+KpYMcdGyW/L8voH5vydSmqcmT01R7f/ijY2LBtqvSYG7YCyD
        ktV/aDj47BtoOon4u3+rzRVBBIn61ssQ5A41RcbS9xhepiOEnKPUj7OGCMDWMQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602254668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JygW1fCWN1B+DwaBqcLYhEsiyZH5SP6AAs9rfTd3su0=;
        b=zhtSqPew150Ep9bbnKUmKd9W9OOWz0QN69IbEu72rBCcXK6xSv+9TAGN2s8s8/9D40mUCG
        sLul7won06nYCUDQ==
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
In-Reply-To: <20201008233210.GH4734@nvidia.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com> <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com> <87mu17ghr1.fsf@nanos.tec.linutronix.de> <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com> <87r1q92mkx.fsf@nanos.tec.linutronix.de> <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com> <87y2kgux2l.fsf@nanos.tec.linutronix.de> <20201008233210.GH4734@nvidia.com>
Date:   Fri, 09 Oct 2020 16:44:27 +0200
Message-ID: <87v9fjtq5w.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 08 2020 at 20:32, Jason Gunthorpe wrote:
> On Fri, Oct 09, 2020 at 01:17:38AM +0200, Thomas Gleixner wrote:
>> Thinking more about it, that very same thing will be needed for any
>> other IMS device and of course this is not going to end well because
>> some driver will fiddle with the PASID at the wrong time.
>
> Why? This looks like some quirk of the IDXD HW where it just randomly
> put PASID along with the IRQ mask register. Probably because PASID is
> not the full 32 bits.
>
> AFAIK the PASID is not tagged on the MemWr TLP triggering the
> interrupt, so it really is unrelated to the irq.

Right you are. With brain awake this does not make sense.

> I think the ioread to get the PASID is rather ugly, it should pluck
> the PASID out of some driver specific data structure with proper
> locking, and thus use the sleepable version of the irqchip?
>
> This is really not that different from what I was describing for queue
> contexts - the queue context needs to be assigned to the irq # before
> it can be used in the irq chip other wise there is no idea where to
> write the msg to. Just like pasid here.

Not really. In the IDXD case the storage is known when the host device
and the irq domain is initialized which is not the case for your variant
and it neither needs to send a magic command to the device to update the
data.

Due to the already explained racy behaviour of MSI affinity changes when
interrupt remapping is disabled, that async update would just not work
and I really don't want to see the resulting tinkering to paper over the
problem. TBH, even if that problem would not exist, my faith in driver
writers getting any of this correct is close to zero and I rather spend
a few brain cycles now than staring at the creative mess later.

So putting the brainfart of yesterday aside, we can simply treat this as
auxiliary data.

The patch below implements an interface for that and adds support to the
IMS driver. That interface is properly serialized and does not put any
restrictions on when this is called. (I know another interrupt chip
which could be simplified that way).

All the IDXD driver has to do is:

   auxval = ims_ctrl_pasid_aux(pasid, enabled);
   irq_set_auxdata(irqnr, IMS_AUXDATA_CONTROL_WORD, auxval);

I agree that irq_set_auxdata() is not the most elegant thing, but the
alternative solutions I looked at are just worse.

For now I just kept the data in the IMS storage which still requires an
ioread(), but these interrupts are not frequently masked and unmasked
during normal operation so performance is not a concern and caching that
value is an orthogonal optimization if someone cares.

Thanks,

        tglx

8<-------------

 drivers/irqchip/irq-ims-msi.c       |   35 +++++++++++++++++++++++++++++------
 include/linux/interrupt.h           |    2 ++
 include/linux/irq.h                 |    4 ++++
 include/linux/irqchip/irq-ims-msi.h |   25 ++++++++++++++++++++++++-
 kernel/irq/manage.c                 |   32 ++++++++++++++++++++++++++++++++
 5 files changed, 91 insertions(+), 7 deletions(-)

--- a/drivers/irqchip/irq-ims-msi.c
+++ b/drivers/irqchip/irq-ims-msi.c
@@ -18,14 +18,19 @@ struct ims_array_data {
 	unsigned long		map[0];
 };
 
+static inline void iowrite32_and_flush(u32 value, void __iomem *addr)
+{
+	iowrite32(value, addr);
+	ioread32(addr);
+}
+
 static void ims_array_mask_irq(struct irq_data *data)
 {
 	struct msi_desc *desc = irq_data_get_msi_desc(data);
 	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
 	u32 __iomem *ctrl = &slot->ctrl;
 
-	iowrite32(ioread32(ctrl) | IMS_VECTOR_CTRL_MASK, ctrl);
-	ioread32(ctrl); /* Flush write to device */
+	iowrite32_and_flush(ioread32(ctrl) | IMS_CTRL_VECTOR_MASKBIT, ctrl);
 }
 
 static void ims_array_unmask_irq(struct irq_data *data)
@@ -34,7 +39,7 @@ static void ims_array_unmask_irq(struct
 	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
 	u32 __iomem *ctrl = &slot->ctrl;
 
-	iowrite32(ioread32(ctrl) & ~IMS_VECTOR_CTRL_MASK, ctrl);
+	iowrite32_and_flush(ioread32(ctrl) & ~IMS_CTRL_VECTOR_MASKBIT, ctrl);
 }
 
 static void ims_array_write_msi_msg(struct irq_data *data, struct msi_msg *msg)
@@ -44,8 +49,24 @@ static void ims_array_write_msi_msg(stru
 
 	iowrite32(msg->address_lo, &slot->address_lo);
 	iowrite32(msg->address_hi, &slot->address_hi);
-	iowrite32(msg->data, &slot->data);
-	ioread32(slot);
+	iowrite32_and_flush(msg->data, &slot->data);
+}
+
+static int ims_array_set_auxdata(struct irq_data *data, unsigned int which,
+				 u64 auxval)
+{
+	struct msi_desc *desc = irq_data_get_msi_desc(data);
+	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
+	u32 val, __iomem *ctrl = &slot->ctrl;
+
+	if (which != IMS_AUXDATA_CONTROL_WORD)
+		return -EINVAL;
+	if (auxval & ~(u64)IMS_CONTROL_WORD_AUXMASK)
+		return -EINVAL;
+
+	val = ioread32(ctrl) & IMS_CONTROL_WORD_IRQMASK;
+	iowrite32_and_flush(val | (u32) auxval, ctrl);
+	return 0;
 }
 
 static const struct irq_chip ims_array_msi_controller = {
@@ -53,6 +74,7 @@ static const struct irq_chip ims_array_m
 	.irq_mask		= ims_array_mask_irq,
 	.irq_unmask		= ims_array_unmask_irq,
 	.irq_write_msi_msg	= ims_array_write_msi_msg,
+	.irq_set_auxdata	= ims_array_set_auxdata,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
@@ -62,7 +84,7 @@ static void ims_array_reset_slot(struct
 	iowrite32(0, &slot->address_lo);
 	iowrite32(0, &slot->address_hi);
 	iowrite32(0, &slot->data);
-	iowrite32(0, &slot->ctrl);
+	iowrite32_and_flush(IMS_CTRL_VECTOR_MASKBIT, &slot->ctrl);
 }
 
 static void ims_array_free_msi_store(struct irq_domain *domain,
@@ -97,6 +119,7 @@ static int ims_array_alloc_msi_store(str
 			goto fail;
 		set_bit(idx, ims->map);
 		entry->device_msi.priv_iomem = &ims->info.slots[idx];
+		ims_array_reset_slot(entry->device_msi.priv_iomem);
 		entry->device_msi.hwirq = idx;
 	}
 	return 0;
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -487,6 +487,8 @@ extern int irq_get_irqchip_state(unsigne
 extern int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 				 bool state);
 
+int irq_set_auxdata(unsigned int irq, unsigned int which, u64 val);
+
 #ifdef CONFIG_IRQ_FORCED_THREADING
 # ifdef CONFIG_PREEMPT_RT
 #  define force_irqthreads	(true)
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -481,6 +481,8 @@ static inline irq_hw_number_t irqd_to_hw
  *				irq_request_resources
  * @irq_compose_msi_msg:	optional to compose message content for MSI
  * @irq_write_msi_msg:	optional to write message content for MSI
+ * @irq_set_auxdata:	Optional function to update auxiliary data e.g. in
+ *			shared registers
  * @irq_get_irqchip_state:	return the internal state of an interrupt
  * @irq_set_irqchip_state:	set the internal state of a interrupt
  * @irq_set_vcpu_affinity:	optional to target a vCPU in a virtual machine
@@ -528,6 +530,8 @@ struct irq_chip {
 	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 
+	int		(*irq_set_auxdata)(struct irq_data *data, unsigned int which, u64 auxval);
+
 	int		(*irq_get_irqchip_state)(struct irq_data *data, enum irqchip_irq_state which, bool *state);
 	int		(*irq_set_irqchip_state)(struct irq_data *data, enum irqchip_irq_state which, bool state);
 
--- a/include/linux/irqchip/irq-ims-msi.h
+++ b/include/linux/irqchip/irq-ims-msi.h
@@ -5,6 +5,7 @@
 #define _LINUX_IRQCHIP_IRQ_IMS_MSI_H
 
 #include <linux/types.h>
+#include <linux/bits.h>
 
 /**
  * ims_hw_slot - The hardware layout of an IMS based MSI message
@@ -23,8 +24,30 @@ struct ims_slot {
 	u32	ctrl;
 } __packed;
 
+/*
+ * The IMS control word utilizes bit 0-2 for interrupt control. The remaining
+ * bits can contain auxiliary data.
+ */
+#define IMS_CONTROL_WORD_IRQMASK	GENMASK(2, 0)
+#define IMS_CONTROL_WORD_AUXMASK	GENMASK(31, 3)
+
 /* Bit to mask the interrupt in ims_hw_slot::ctrl */
-#define IMS_VECTOR_CTRL_MASK	0x01
+#define IMS_CTRL_VECTOR_MASKBIT		BIT(0)
+
+/* Auxiliary control word data related defines */
+enum {
+	IMS_AUXDATA_CONTROL_WORD,
+};
+
+#define IMS_CTRL_PASID_ENABLE		BIT(3)
+#define IMS_CTRL_PASID_SHIFT		12
+
+static inline u32 ims_ctrl_pasid_aux(unsigned int pasid, bool enable)
+{
+	u32 auxval = pasid << IMS_CTRL_PASID_SHIFT;
+
+	return enable ? auxval | IMS_CTRL_PASID_ENABLE : auxval;
+}
 
 /**
  * struct ims_array_info - Information to create an IMS array domain
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -2752,3 +2752,35 @@ int irq_set_irqchip_state(unsigned int i
 	return err;
 }
 EXPORT_SYMBOL_GPL(irq_set_irqchip_state);
+
+/**
+ * irq_set_auxdata - Set auxiliary data
+ * @irq:	Interrupt to update
+ * @which:	Selector which data to update
+ * @auxval:	Auxiliary data value
+ *
+ * Function to update auxiliary data for an interrupt, e.g. to update data
+ * which is stored in a shared register or data storage (e.g. IMS).
+ */
+int irq_set_auxdata(unsigned int irq, unsigned int which, u64 val)
+{
+	struct irq_desc *desc;
+	struct irq_data *data;
+	unsigned long flags;
+	int res = -ENODEV;
+
+	desc = irq_get_desc_buslock(irq, &flags, 0);
+	if (!desc)
+		return -EINVAL;
+
+	for (data = &desc->irq_data; data; data = irqd_get_parent_data(data)) {
+		if (data->chip->irq_set_auxdata) {
+			res = data->chip->irq_set_auxdata(data, which, val);
+			break;
+		}
+	}
+
+	irq_put_desc_busunlock(desc, flags);
+	return res;
+}
+EXPORT_SYMBOL_GPL(irq_set_auxdata);
