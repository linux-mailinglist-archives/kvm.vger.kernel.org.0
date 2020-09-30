Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C1527F18C
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgI3SrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgI3SrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 14:47:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5971BC061755;
        Wed, 30 Sep 2020 11:47:02 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601491620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kiz7/SWQLMON7gelenhbRoI004ot0P3TXeRig/vUtf8=;
        b=FnBUQwSBNvrI0nokrDqg6i8UJatcEh036RkTZftkYPnd2WIKqBzrsdUP1wORktBjNMDR2o
        YrTGjAGBipUeFG06yagvJu9lP+aMvez434GltolhXeWVrGIAzLaCAEcLBs9m8KxcKQ3l7A
        fEEXY3Ikr3vxVKzOZbYkOaRNLLYbv79OmzDmAnz2CAZMJkRFOW/PaJk5/3lXvUX40yIH5g
        Ne9by9mNNv3HLF+djsUjj0Gjns82LIZ2QSlw2S1GEl/07VTkmA56t2ObMfGpQUNgHUcbNV
        00tBd1nmnPvhPoXPMCFbeTD2amaijF4tv/Iu1IzW943AKVvNBOrjo5naso1VCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601491620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kiz7/SWQLMON7gelenhbRoI004ot0P3TXeRig/vUtf8=;
        b=t7u3wtm+0S4OfXWOLfbXFH8pT3Q3dCWAWR0ow5pLJjaiqxW/1k0yT6cjYpzur6UxGibU2x
        Aa+28214OubJyNAA==
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
Subject: Re: [PATCH v3 05/18] dmaengine: idxd: add IMS support in base driver
In-Reply-To: <160021248979.67751.3799965857372703876.stgit@djiang5-desk3.ch.intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com> <160021248979.67751.3799965857372703876.stgit@djiang5-desk3.ch.intel.com>
Date:   Wed, 30 Sep 2020 20:47:00 +0200
Message-ID: <87sgazgl0b.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15 2020 at 16:28, Dave Jiang wrote:
>  struct idxd_device {
> @@ -170,6 +171,7 @@ struct idxd_device {
>  
>  	int num_groups;
>  
> +	u32 ims_offset;
>  	u32 msix_perm_offset;
>  	u32 wqcfg_offset;
>  	u32 grpcfg_offset;
> @@ -177,6 +179,7 @@ struct idxd_device {
>  
>  	u64 max_xfer_bytes;
>  	u32 max_batch_size;
> +	int ims_size;
>  	int max_groups;
>  	int max_engines;
>  	int max_tokens;
> @@ -196,6 +199,7 @@ struct idxd_device {
>  	struct work_struct work;
>  
>  	int *int_handles;
> +	struct sbitmap ims_sbmap;

This bitmap is needed for what?

> --- a/drivers/dma/idxd/init.c
> +++ b/drivers/dma/idxd/init.c
> @@ -231,10 +231,51 @@ static void idxd_read_table_offsets(struct idxd_device *idxd)
>  	idxd->msix_perm_offset = offsets.msix_perm * 0x100;
>  	dev_dbg(dev, "IDXD MSIX Permission Offset: %#x\n",
>  		idxd->msix_perm_offset);
> +	idxd->ims_offset = offsets.ims * 0x100;

Magic constant pulled out of thin air. #define ....

> +	dev_dbg(dev, "IDXD IMS Offset: %#x\n", idxd->ims_offset);
>  	idxd->perfmon_offset = offsets.perfmon * 0x100;
>  	dev_dbg(dev, "IDXD Perfmon Offset: %#x\n", idxd->perfmon_offset);
>  }
>  
> +#define PCI_DEVSEC_CAP		0x23
> +#define SIOVDVSEC1(offset)	((offset) + 0x4)
> +#define SIOVDVSEC2(offset)	((offset) + 0x8)
> +#define DVSECID			0x5
> +#define SIOVCAP(offset)		((offset) + 0x14)
> +
> +static void idxd_check_siov(struct idxd_device *idxd)
> +{
> +	struct pci_dev *pdev = idxd->pdev;
> +	struct device *dev = &pdev->dev;
> +	int dvsec;
> +	u16 val16;
> +	u32 val32;
> +
> +	dvsec = pci_find_ext_capability(pdev, PCI_DEVSEC_CAP);
> +	pci_read_config_word(pdev, SIOVDVSEC1(dvsec), &val16);
> +	if (val16 != PCI_VENDOR_ID_INTEL) {
> +		dev_dbg(&pdev->dev, "DVSEC vendor id is not Intel\n");
> +		return;
> +	}
> +
> +	pci_read_config_word(pdev, SIOVDVSEC2(dvsec), &val16);
> +	if (val16 != DVSECID) {
> +		dev_dbg(&pdev->dev, "DVSEC ID is not SIOV\n");
> +		return;
> +	}
> +
> +	pci_read_config_dword(pdev, SIOVCAP(dvsec), &val32);
> +	if ((val32 & 0x1) && idxd->hw.gen_cap.max_ims_mult) {
> +		idxd->ims_size = idxd->hw.gen_cap.max_ims_mult * 256ULL;
> +		dev_dbg(dev, "IMS size: %u\n", idxd->ims_size);
> +		set_bit(IDXD_FLAG_SIOV_SUPPORTED, &idxd->flags);
> +		dev_dbg(&pdev->dev, "IMS supported for device\n");
> +		return;
> +	}
> +
> +	dev_dbg(&pdev->dev, "SIOV unsupported for device\n");

It's really hard to find the code inside all of this dev_dbg()
noise. But why is this capability check done in this driver? Is this
capability stuff really IDXD specific or is the next device which
supports this going to copy and pasta the above?

>  static void idxd_read_caps(struct idxd_device *idxd)
>  {
>  	struct device *dev = &idxd->pdev->dev;
> @@ -253,6 +294,7 @@ static void idxd_read_caps(struct idxd_device *idxd)
>  	dev_dbg(dev, "max xfer size: %llu bytes\n", idxd->max_xfer_bytes);
>  	idxd->max_batch_size = 1U << idxd->hw.gen_cap.max_batch_shift;
>  	dev_dbg(dev, "max batch size: %u\n", idxd->max_batch_size);
> +	idxd_check_siov(idxd);
>  	if (idxd->hw.gen_cap.config_en)
>  		set_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags);
>  
> @@ -347,9 +389,19 @@ static int idxd_probe(struct idxd_device *idxd)
>  
>  	idxd->major = idxd_cdev_get_major(idxd);
>  
> +	if (idxd->ims_size) {
> +		rc = sbitmap_init_node(&idxd->ims_sbmap, idxd->ims_size, -1,
> +				       GFP_KERNEL, dev_to_node(dev));
> +		if (rc < 0)
> +			goto sbitmap_fail;
> +	}

Ah, here the bitmap is allocated, but it's still completely unclear what
it is used for.

The subject line is misleading as hell. This does not add support, it's
doing some magic capability checks and allocates stuff which nobody
knows what it is used for.

Thanks,

        tglx


