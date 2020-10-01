Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9D1280AB0
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 01:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733302AbgJAW76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 18:59:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:38207 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733120AbgJAW7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 18:59:51 -0400
IronPort-SDR: 34ZgJ1/y6fnww//6M5oiKgLkrN/0qJHQunzM4V/9KD558XF+U1f1e9IgCKHFdhREULWkzGT0iT
 cfetxGo2is4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="163714844"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="163714844"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 15:59:46 -0700
IronPort-SDR: eUvBViyftsQa/0xJxQj4EJlPKRJ8DGtAozX87INObox97mcHiMdB5toNI8i7m6kwTzfAvf3cjF
 4PIZBk7XJKMA==
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="514951687"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.209.13.228]) ([10.209.13.228])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 15:59:44 -0700
Subject: Re: [PATCH v3 01/18] irqchip: Add IMS (Interrupt Message Storage)
 driver
To:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, rafael@kernel.org,
        netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021246221.67751.16280230469654363209.stgit@djiang5-desk3.ch.intel.com>
 <87362zi0nr.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <dd1c34c5-e2c0-25fc-b668-a5bbb7869397@intel.com>
Date:   Thu, 1 Oct 2020 15:59:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87362zi0nr.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 9/30/2020 11:23 AM, Thomas Gleixner wrote:
> On Tue, Sep 15 2020 at 16:27, Dave Jiang wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>> +config IMS_MSI_ARRAY
>> +	bool "IMS Interrupt Message Storm MSI controller for device memory storage arrays"
> Hehe, you missed a Message Storm :)
i will change this in the next version
>> +	depends on PCI
>> +	select IMS_MSI
>> +	select GENERIC_MSI_IRQ_DOMAIN
>> +	help
>> +	  Support for IMS Interrupt Message Storm MSI controller
> and another one.
ok :)
>
>> +	  with IMS slot storage in a slot array in device memory
>> +
>> +static void ims_array_mask_irq(struct irq_data *data)
>> +{
>> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
>> +	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
>> +	u32 __iomem *ctrl = &slot->ctrl;
>> +
>> +	iowrite32(ioread32(ctrl) | IMS_VECTOR_CTRL_MASK, ctrl);
>> +	ioread32(ctrl); /* Flush write to device */
> Bah, I fundamentaly hate tail comments. They are a distraction and
> disturb the reading flow. Put it above the ioread32() please.
Will do.
>
>> +static void ims_array_unmask_irq(struct irq_data *data)
>> +{
>> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
>> +	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
>> +	u32 __iomem *ctrl = &slot->ctrl;
>> +
>> +	iowrite32(ioread32(ctrl) & ~IMS_VECTOR_CTRL_MASK, ctrl);
> Why is this one not flushed?
I will add it.
>
>> +}
>> +
>> +static void ims_array_write_msi_msg(struct irq_data *data, struct msi_msg *msg)
>> +{
>> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
>> +	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
>> +
>> +	iowrite32(msg->address_lo, &slot->address_lo);
>> +	iowrite32(msg->address_hi, &slot->address_hi);
>> +	iowrite32(msg->data, &slot->data);
>> +	ioread32(slot);
> Yuck? slot points to the struct and just because ioread32() accepts a
> void pointer does not make it any more readable.
hmm ok , will change this.
>
>> +static void ims_array_reset_slot(struct ims_slot __iomem *slot)
>> +{
>> +	iowrite32(0, &slot->address_lo);
>> +	iowrite32(0, &slot->address_hi);
>> +	iowrite32(0, &slot->data);
>> +	iowrite32(0, &slot->ctrl);
> Flush?

ok!

-Megha

>
> Thanks,
>
>          tglx
