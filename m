Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F7527F142
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgI3SXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:23:44 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58588 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3SXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 14:23:44 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601490221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zv5Q1ba8TbOELbdMrEkMwGbKwuz8jmeM2ai9GDgQ4g4=;
        b=GCGx1kVYZarkqULAtHVwWVwnv0pl+M5q3t1Y1ARNVfKPRTLk3UFyJ55q95VPGg2D7fbhwd
        Qo8cMD8/u7FmEcQdTnW41WnXb0xWGKLc+bw6Nz4OilYJAhk0B55n4474eO3MG6l7Xlddlz
        LDHYHvnpTBfUWwUNWsBxmD7KxCwntJYggpftckj2eLf9Qugao0J1txzI7RrHwojbeycTYE
        uEmn+c1ups5j4qADXQ6fACRmBek6RnbGEAo7rBIhFwNCsOOcNPjr0JDpnlRJhPlexZB/kc
        bloBH5nyFveZmZkg3K1EMmpZ+YKFMgerJN1u8cdP2TmIsf/Xd1atmZxKaxzsGQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601490221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zv5Q1ba8TbOELbdMrEkMwGbKwuz8jmeM2ai9GDgQ4g4=;
        b=Q0kMIcA38boIwN2hq3Syg841q4Z2+uzcUk9bLGxhtqgNZ1nviKoFQzPUJMnZDjs2wXgmuG
        ahQ4C/EPXH5SgLBw==
To:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 01/18] irqchip: Add IMS (Interrupt Message Storage) driver
In-Reply-To: <160021246221.67751.16280230469654363209.stgit@djiang5-desk3.ch.intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com> <160021246221.67751.16280230469654363209.stgit@djiang5-desk3.ch.intel.com>
Date:   Wed, 30 Sep 2020 20:23:36 +0200
Message-ID: <87362zi0nr.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15 2020 at 16:27, Dave Jiang wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> +config IMS_MSI_ARRAY
> +	bool "IMS Interrupt Message Storm MSI controller for device memory storage arrays"

Hehe, you missed a Message Storm :)

> +	depends on PCI
> +	select IMS_MSI
> +	select GENERIC_MSI_IRQ_DOMAIN
> +	help
> +	  Support for IMS Interrupt Message Storm MSI controller

and another one.

> +	  with IMS slot storage in a slot array in device memory
> +
> +static void ims_array_mask_irq(struct irq_data *data)
> +{
> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
> +	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
> +	u32 __iomem *ctrl = &slot->ctrl;
> +
> +	iowrite32(ioread32(ctrl) | IMS_VECTOR_CTRL_MASK, ctrl);
> +	ioread32(ctrl); /* Flush write to device */

Bah, I fundamentaly hate tail comments. They are a distraction and
disturb the reading flow. Put it above the ioread32() please.

> +static void ims_array_unmask_irq(struct irq_data *data)
> +{
> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
> +	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
> +	u32 __iomem *ctrl = &slot->ctrl;
> +
> +	iowrite32(ioread32(ctrl) & ~IMS_VECTOR_CTRL_MASK, ctrl);

Why is this one not flushed?

> +}
> +
> +static void ims_array_write_msi_msg(struct irq_data *data, struct msi_msg *msg)
> +{
> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
> +	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
> +
> +	iowrite32(msg->address_lo, &slot->address_lo);
> +	iowrite32(msg->address_hi, &slot->address_hi);
> +	iowrite32(msg->data, &slot->data);
> +	ioread32(slot);

Yuck? slot points to the struct and just because ioread32() accepts a
void pointer does not make it any more readable.

> +static void ims_array_reset_slot(struct ims_slot __iomem *slot)
> +{
> +	iowrite32(0, &slot->address_lo);
> +	iowrite32(0, &slot->address_hi);
> +	iowrite32(0, &slot->data);
> +	iowrite32(0, &slot->ctrl);

Flush?

Thanks,

        tglx
