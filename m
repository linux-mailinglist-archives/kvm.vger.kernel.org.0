Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8793D395EF3
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 16:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhEaOFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 10:05:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54596 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbhEaODo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 10:03:44 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622469722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cpFaLYty/y3nJdZHyW0WlhfFo+8SFDdRk+PJoQsL8DI=;
        b=eh7MMipFT19nuwJTmIdDQAqeiYXG5PMmFPkBtC4ZUlSdN5jOJDPxXhp94yqdDOoBqgHluo
        /LPpA80HwlzzRlR/fszqxk8+DGeQsrI+yb5YPNGMM39qqDC2HeWxWqpq9O/xFMOGW5kfvN
        PjqOabKDF346Ap6yqOBubOxiR6OmKOqPz8LxV1ZHzGAV3Eca4m7aDaAM9/dUg7UqE6i3ya
        YFGYSSdAiEF6RbhsZ9CuK/JSBc1ZaYOJJ4GZtPxLyDKUrDAGWDDE2nAoYOJshaVnzgOHBR
        +zF9FaYtM8AbxYT0/wB/eItZR+n8kH+KjT3L3u1T3Hnp31FX6vP8s9ahRmFf+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622469722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cpFaLYty/y3nJdZHyW0WlhfFo+8SFDdRk+PJoQsL8DI=;
        b=RABPXd8q8P4Q0xjfHnTiSpvDg7dvHBarCEFQGb8Xy54U76o6WIkHjk9f3DyG7vAPof6FnD
        xOZ/EV7Ljt+I0wAg==
To:     Jason Gunthorpe <jgg@nvidia.com>, Dave Jiang <dave.jiang@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com, vkoul@kernel.org,
        megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 15/20] vfio/mdev: idxd: ims domain setup for the vdcm
In-Reply-To: <20210523235023.GL1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com> <162164283796.261970.11020270418798826121.stgit@djiang5-desk3.ch.intel.com> <20210523235023.GL1002214@nvidia.com>
Date:   Mon, 31 May 2021 16:02:02 +0200
Message-ID: <87mtsb3sth.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 23 2021 at 20:50, Jason Gunthorpe wrote:
> On Fri, May 21, 2021 at 05:20:37PM -0700, Dave Jiang wrote:
>> @@ -77,8 +80,18 @@ int idxd_mdev_host_init(struct idxd_device *idxd, struct mdev_driver *drv)
>>  		return rc;
>>  	}
>>  
>> +	ims_info.max_slots = idxd->ims_size;
>> +	ims_info.slots = idxd->reg_base + idxd->ims_offset;
>> +	idxd->ims_domain = pci_ims_array_create_msi_irq_domain(idxd->pdev, &ims_info);
>> +	if (!idxd->ims_domain) {
>> +		dev_warn(dev, "Fail to acquire IMS domain\n");
>> +		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
>> +		return -ENODEV;
>> +	}
>
> I'm quite surprised that every mdev doesn't create its own ims_domain
> in its probe function.

What for?

> This places a global total limit on the # of vectors which makes me
> ask what was the point of using IMS in the first place ?

That depends on how IMS is implemented. The IDXD variant has a fixed
sized message store which is shared between all subdevices, so yet
another domain would not provide any value.

For the case where the IMS store is seperate, you still have one central
irqdomain per physical device. The domain allocation function can then
create storage on demand or reuse existing storage and just fill in the
pointers.

Thanks,

        tglx


