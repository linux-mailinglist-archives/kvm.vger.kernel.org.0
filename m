Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB58287F05
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 01:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbgJHXRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 19:17:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53524 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbgJHXRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 19:17:43 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602199059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T7apZwGHYCTEDNSPiTkzSbbIXwX8iIGpZEuOQe4bpNU=;
        b=0pvtE5qWMUCSidIMbMBal6F3MY8HayVW6Kqmwj+3Jew6K/zgRZwBw1N63/7Xh7aGvhpWrn
        ygPnki/HLljXj+Oye+KiIe8w6Qe/iomPgTiWjLyW8n9RZu25jcHAtqpTKP1tU41IKx8374
        IwRF+/ch1/CEKSc7Lwlsu1Sgk28Fi6h+pwAdl2fqm1uTU9pHjwSOvixV2yRsGEtM5w+jtz
        z7rikjHUs5FVlLwhCUqEUSpKWiHUus7XtYxVALMfijlDTgSY70373v8U8WHo4CER//7dOW
        BLOI/zFcK3n65MneSl1In6nzEpvSr5zuyhy+FdNmZLLrl2EXEM7BO5J1hxMUcg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602199059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T7apZwGHYCTEDNSPiTkzSbbIXwX8iIGpZEuOQe4bpNU=;
        b=YVvxbcs5PStoUIk4hwuoxYfFb32Ad4+RRpd975rk5cF2MVkppLoCj4EEq6bVrDhJT/eaZk
        fdKxAwJysv2BYkBw==
To:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
In-Reply-To: <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com> <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com> <87mu17ghr1.fsf@nanos.tec.linutronix.de> <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com> <87r1q92mkx.fsf@nanos.tec.linutronix.de> <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
Date:   Fri, 09 Oct 2020 01:17:38 +0200
Message-ID: <87y2kgux2l.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dave,

On Thu, Oct 08 2020 at 09:51, Dave Jiang wrote:
> On 10/8/2020 12:39 AM, Thomas Gleixner wrote:
>> On Wed, Oct 07 2020 at 14:54, Dave Jiang wrote:
>>> On 9/30/2020 12:57 PM, Thomas Gleixner wrote:
>>>> Aside of that this is fiddling in the IMS storage array behind the irq
>>>> chips back without any comment here and a big fat comment about the
>>>> shared usage of ims_slot::ctrl in the irq chip driver.
>>>>
>>> This is to program the pasid fields in the IMS table entry. Was
>>> thinking the pasid fields may be considered device specific so didn't
>>> attempt to add the support to the core code.
>> 
>> Well, the problem is that this is not really irq chip functionality.
>> 
>> But the PASID programming needs to touch the IMS storage which is also
>> touched by the irq chip.
>> 
>> This might be correct as is, but without a big fat comment explaining
>> WHY it is safe to do so without any form of serialization this is just
>> voodoo and unreviewable.
>> 
>> Can you please explain when the PASID is programmed and what the state
>> of the interrupt is at that point? Is this a one off setup operation or
>> does this happen dynamically at random points during runtime?
>
> I will put in comments for the function to explain why and when we modify the 
> pasid field for the IMS entry. Programming of the pasid is done right before we 
> request irq. And the clearing is done after we free the irq. We will not be 
> touching the IMS field at runtime. So the touching of the entry should be safe.

Thanks for clarifying that.

Thinking more about it, that very same thing will be needed for any
other IMS device and of course this is not going to end well because
some driver will fiddle with the PASID at the wrong time.

Find below an infrastructure patch which adds ASID support to the core
and a delta patch for the IMS irq chip. All of it neither compiled nor
tested.

Setting IMS_PASID_ENABLE might have other conditions which I don't know
of, so the IMS part might be completely wrong, but you get the idea.

Thanks,

        tglx

8<-----------
Subject: genirq: Provide irq_set_asid()
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 08 Oct 2020 23:32:16 +0200

Provide storage and a setter for an Address Space IDentifier.

The identifier is stored in the top level irq_data and it only can be
modified when the interrupt is not requested.

Add the necessary storage and helper functions and validate that interrupts
which require an ASID have one assigned.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    8 ++++++++
 kernel/irq/internals.h |   10 ++++++++++
 kernel/irq/irqdesc.c   |    1 +
 kernel/irq/manage.c    |   40 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+)

--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -161,6 +161,7 @@ struct irq_common_data {
  * @mask:		precomputed bitmask for accessing the chip registers
  * @irq:		interrupt number
  * @hwirq:		hardware interrupt number, local to the interrupt domain
+ * @asid:		Optional address space ID for this interrupt.
  * @common:		point to data shared by all irqchips
  * @chip:		low level interrupt hardware access
  * @domain:		Interrupt translation domain; responsible for mapping
@@ -174,6 +175,7 @@ struct irq_data {
 	u32			mask;
 	unsigned int		irq;
 	unsigned long		hwirq;
+	u32			asid;
 	struct irq_common_data	*common;
 	struct irq_chip		*chip;
 	struct irq_domain	*domain;
@@ -183,6 +185,8 @@ struct irq_data {
 	void			*chip_data;
 };
 
+#define IRQ_INVALID_ASID	U32_MAX
+
 /*
  * Bit masks for irq_common_data.state_use_accessors
  *
@@ -555,6 +559,8 @@ struct irq_chip {
  * IRQCHIP_EOI_THREADED:	Chip requires eoi() on unmask in threaded mode
  * IRQCHIP_SUPPORTS_LEVEL_MSI	Chip can provide two doorbells for Level MSIs
  * IRQCHIP_SUPPORTS_NMI:	Chip can deliver NMIs, only for root irqchips
+ * IRQCHIP_REQUIRES_ASID:	Interrupt chip requires a valid Address Space
+ *				IDentifier
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
@@ -566,6 +572,7 @@ enum {
 	IRQCHIP_EOI_THREADED		= (1 <<  6),
 	IRQCHIP_SUPPORTS_LEVEL_MSI	= (1 <<  7),
 	IRQCHIP_SUPPORTS_NMI		= (1 <<  8),
+	IRQCHIP_REQUIRES_ASID		= (1 <<  9),
 };
 
 #include <linux/irqdesc.h>
@@ -792,6 +799,7 @@ extern int irq_set_irq_type(unsigned int
 extern int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry);
 extern int irq_set_msi_desc_off(unsigned int irq_base, unsigned int irq_offset,
 				struct msi_desc *entry);
+extern int irq_set_asid(unsigned int irq, u32 asid);
 extern struct irq_data *irq_get_irq_data(unsigned int irq);
 
 static inline struct irq_chip *irq_get_chip(unsigned int irq)
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -281,6 +281,16 @@ static inline void
 irq_pm_remove_action(struct irq_desc *desc, struct irqaction *action) { }
 #endif
 
+static inline bool irq_requires_asid(struct irq_desc *desc)
+{
+	return desc->irq_data.chip->flags & IRQCHIP_REQUIRES_ASID;
+}
+
+static inline bool irq_invalid_asid(struct irq_desc *desc)
+{
+	return desc->irq_data.asid == IRQ_INVALID_ASID;
+}
+
 #ifdef CONFIG_IRQ_TIMINGS
 
 #define IRQ_TIMINGS_SHIFT	5
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -115,6 +115,7 @@ static void desc_set_defaults(unsigned i
 	irq_settings_clr_and_set(desc, ~0, _IRQ_DEFAULT_INIT_FLAGS);
 	irqd_set(&desc->irq_data, IRQD_IRQ_DISABLED);
 	irqd_set(&desc->irq_data, IRQD_IRQ_MASKED);
+	desc->irq_data.asid = IRQ_INVALID_ASID;
 	desc->handle_irq = handle_bad_irq;
 	desc->depth = 1;
 	desc->irq_count = 0;
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1520,6 +1520,22 @@ static int
 	}
 
 	/*
+	 * If the topmost interrupt chip requires that a valid Address
+	 * Space IDentifier is set, validate that the interrupt is not
+	 * shared and that a valid ASID is set.
+	 */
+	if (irq_requires_asid(desc)) {
+		if (shared || irq_invalid_asid(desc)) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+		/*
+		 * CHECKME: Is there a way to figure out that the ASID
+		 * makes sense in the context of the caller?
+		 */
+	}
+
+	/*
 	 * Setup the thread mask for this irqaction for ONESHOT. For
 	 * !ONESHOT irqs the thread mask is 0 so we can avoid a
 	 * conditional in irq_wake_thread().
@@ -1848,6 +1864,8 @@ static struct irqaction *__free_irq(stru
 		 */
 		raw_spin_lock_irqsave(&desc->lock, flags);
 		irq_domain_deactivate_irq(&desc->irq_data);
+		/* Invalidate the ASID associated to this interrupt */
+		desc->irq_data.asid = IRQ_INVALID_ASID;
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 		irq_release_resources(desc);
@@ -2752,3 +2770,25 @@ int irq_set_irqchip_state(unsigned int i
 	return err;
 }
 EXPORT_SYMBOL_GPL(irq_set_irqchip_state);
+
+int irq_set_asid(unsigned int irq, u32 asid)
+{
+	struct irq_desc *desc;
+	struct irq_data *data;
+	unsigned long flags;
+	int err = -EBUSY;
+
+	desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+	if (!desc)
+		return -EINVAL;
+
+	/* If the interrupt is active changig ASID is a NONO */
+	if (!desc->action) {
+		data = irq_desc_get_irq_data(desc);
+		data->asid = asid;
+	}
+
+	irq_put_desc_busunlock(desc, flags);
+	return err;
+}
+EXPORT_SYMBOL_GPL(irq_set_asid);

8<------------------

Subject: irqchip/ims: PASID support
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 09 Oct 2020 01:02:09 +0200

NOT-Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-ims-msi.c       |   29 ++++++++++++++++++++++-------
 include/linux/irqchip/irq-ims-msi.h |    2 ++
 2 files changed, 24 insertions(+), 7 deletions(-)

--- a/drivers/irqchip/irq-ims-msi.c
+++ b/drivers/irqchip/irq-ims-msi.c
@@ -18,14 +18,26 @@ struct ims_array_data {
 	unsigned long		map[0];
 };
 
+#define IMS_ASID_SHIFT		12
+
+static inline u32 ims_ctrl_val(struct irq_data *data, u32 ctrl)
+{
+	return ctrl | (data->asid) << 12 | IMS_PASID_ENABLE;
+}
+
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
+	iowrite32_and_flush(ims_ctrl_val(data, IMS_VECTOR_CTRL_MASK), ctrl);
 }
 
 static void ims_array_unmask_irq(struct irq_data *data)
@@ -34,7 +46,10 @@ static void ims_array_unmask_irq(struct
 	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
 	u32 __iomem *ctrl = &slot->ctrl;
 
-	iowrite32(ioread32(ctrl) & ~IMS_VECTOR_CTRL_MASK, ctrl);
+	if (!WARN_ON_ONCE(data->asid == IRQ_INVALID_ASID))
+		return;
+
+	iowrite32_and_flush(ims_ctrl_val(data, 0), ctrl);
 }
 
 static void ims_array_write_msi_msg(struct irq_data *data, struct msi_msg *msg)
@@ -44,8 +59,7 @@ static void ims_array_write_msi_msg(stru
 
 	iowrite32(msg->address_lo, &slot->address_lo);
 	iowrite32(msg->address_hi, &slot->address_hi);
-	iowrite32(msg->data, &slot->data);
-	ioread32(slot);
+	iowrite32_and_flush(msg->data, &slot->data);
 }
 
 static const struct irq_chip ims_array_msi_controller = {
@@ -54,7 +68,8 @@ static const struct irq_chip ims_array_m
 	.irq_unmask		= ims_array_unmask_irq,
 	.irq_write_msi_msg	= ims_array_write_msi_msg,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_REQUIRES_ASID,
 };
 
 static void ims_array_reset_slot(struct ims_slot __iomem *slot)
@@ -62,7 +77,7 @@ static void ims_array_reset_slot(struct
 	iowrite32(0, &slot->address_lo);
 	iowrite32(0, &slot->address_hi);
 	iowrite32(0, &slot->data);
-	iowrite32(0, &slot->ctrl);
+	iowrite32_and_flush(IMS_VECTOR_CTRL_MASK, &slot->ctrl);
 }
 
 static void ims_array_free_msi_store(struct irq_domain *domain,
--- a/include/linux/irqchip/irq-ims-msi.h
+++ b/include/linux/irqchip/irq-ims-msi.h
@@ -25,6 +25,8 @@ struct ims_slot {
 
 /* Bit to mask the interrupt in ims_hw_slot::ctrl */
 #define IMS_VECTOR_CTRL_MASK	0x01
+/* Bit to enable PASID in ims_hw_slot::ctrl */
+#define IMS_PASID_ENABLE	0x08
 
 /**
  * struct ims_array_info - Information to create an IMS array domain
