Return-Path: <kvm+bounces-3168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7170A801488
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 21:35:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DEF11C20C4A
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 20:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB5651C3E;
	Fri,  1 Dec 2023 20:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="OJLt+j7K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E771DF1
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 12:35:38 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-67a2661560dso12557126d6.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 12:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1701462938; x=1702067738; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4AzPgky7GHZqZVCrwDwJ2TCTQsO5U4mu1ovBdK9ibFQ=;
        b=OJLt+j7KnzmXZYy4ahD9VssbMGizUrYukvwM6gQ4LfJdLWK8XleQgkWmRCgnc+c7v/
         8op0RxqTq9FaxWtyYB5Cy2gpaiBU4D+zCdqaTjgAXrHOlTb40ODJ51p7jvIi6vyeNYoq
         XBHr+4FeMDs79xV/hxW8fvLhQV3zyTUyT0XKrSKsBZ1AjRxTGVPjnB1ip8jdP0B1+XSV
         nyFU/90ZkZ/4xkig3Zc8X3oemfZMjRIhGR+rd5ocAFhRPrAcXNZaol8Er83+yV7Hwhx3
         x1NRmo7gngHOjiRhRzqsfXTlTZnuj2VC1EeX3RmJz1UfgEY27ZcLIvsIUg8H04xYM1vS
         cCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701462938; x=1702067738;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4AzPgky7GHZqZVCrwDwJ2TCTQsO5U4mu1ovBdK9ibFQ=;
        b=f7CXzTrz7v0ezuuYVE9gsYl8C1gjmEKIBMzmN4J3oSpsT0X12w7GviUvPfLQ9kDz6R
         YEBujsyt4Tk5Lok2RZTavLm+8eq8kyq6P/LPnArnkC50iiW4ozX3AgmlZMFJfE+3a1fF
         rfTDZxXVCDxbNprIYyJgZHpcI+htN5BHscTIzt3J+ZbG22NfZ5gL/okwSYLcAOKws5Da
         JIyE6/O2gA9ooO+Z/6lmIFxU+4461zbm1nKaI/ZjIbN4g930DyBLIFYQqdxuQvMcWNZU
         iHrDUe9A5eHoFK20WbcBKwavzpPcwZu49iWL+di3ZyQKG9eoFlVp8EVVjb9wmWw/yRbX
         BYDg==
X-Gm-Message-State: AOJu0YxGTWKXot/9MKLCenTROB3iQrXNx56AwGlA0MEG2yhG/KtTxa41
	p827xv9SyPNFnW0i161/VRigtQ==
X-Google-Smtp-Source: AGHT+IHOT0XKRw6+rggkJrfEQdv7Iu/MLVn36qFEZE0IsLTSurWkvGpPAL2i4HLowbNDECNd3sEozQ==
X-Received: by 2002:a0c:efc1:0:b0:67a:a721:d761 with SMTP id a1-20020a0cefc1000000b0067aa721d761mr48951qvt.71.1701462937778;
        Fri, 01 Dec 2023 12:35:37 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id y16-20020ac85250000000b00423f1a4f4e9sm1782170qtn.91.2023.12.01.12.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 12:35:37 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1r9AEa-006NSu-JR;
	Fri, 01 Dec 2023 16:35:36 -0400
Date: Fri, 1 Dec 2023 16:35:36 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 12/12] iommu: Improve iopf_queue_flush_dev()
Message-ID: <20231201203536.GG1489931@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-13-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115030226.16700-13-baolu.lu@linux.intel.com>

On Wed, Nov 15, 2023 at 11:02:26AM +0800, Lu Baolu wrote:
> The iopf_queue_flush_dev() is called by the iommu driver before releasing
> a PASID. It ensures that all pending faults for this PASID have been
> handled or cancelled, and won't hit the address space that reuses this
> PASID. The driver must make sure that no new fault is added to the queue.

This needs more explanation, why should anyone care?

More importantly, why is *discarding* the right thing to do?
Especially why would we discard a partial page request group?

After we change a translation we may have PRI requests in a
queue. They need to be acknowledged, not discarded. The DMA in the
device should be restarted and the device should observe the new
translation - if it is blocking then it should take a DMA error.

More broadly, we should just let things run their normal course. The
domain to deliver the fault to should be determined very early. If we
get a fault and there is no fault domain currently assigned then just
restart it.

The main reason to fence would be to allow the domain to become freed
as the faults should be holding pointers to it. But I feel there are
simpler options for that then this..

> The SMMUv3 driver doesn't use it because it only implements the
> Arm-specific stall fault model where DMA transactions are held in the SMMU
> while waiting for the OS to handle iopf's. Since a device driver must
> complete all DMA transactions before detaching domain, there are no
> pending iopf's with the stall model. PRI support requires adding a call to
> iopf_queue_flush_dev() after flushing the hardware page fault queue.

This explanation doesn't make much sense, from a device driver
perspective both PRI and stall cause the device to not complete DMAs.

The difference between stall and PRI is fairly small, stall causes an
internal bus to lock up while PRI does not.

> -int iopf_queue_flush_dev(struct device *dev)
> +int iopf_queue_discard_dev_pasid(struct device *dev, ioasid_t pasid)
>  {
>  	struct iommu_fault_param *iopf_param = iopf_get_dev_fault_param(dev);
> +	const struct iommu_ops *ops = dev_iommu_ops(dev);
> +	struct iommu_page_response resp;
> +	struct iopf_fault *iopf, *next;
> +	int ret = 0;
>  
>  	if (!iopf_param)
>  		return -ENODEV;
>  
>  	flush_workqueue(iopf_param->queue->wq);
> +

A naked flush_workqueue like this is really suspicious, it needs a
comment explaining why the queue can't get more work queued at this
point. 

I suppose the driver is expected to stop calling
iommu_report_device_fault() before calling this function, but that
doesn't seem like it is going to be possible. Drivers should be
implementing atomic replace for the PASID updates and in that case
there is no momement when it can say the HW will stop generating PRI.

I'm looking at this code after these patches are applied and it still
seems quite bonkers to me :(

Why do we allocate two copies of the memory on all fault paths?

Why do we have fault->type still that only has one value?

What is serializing iommu_get_domain_for_dev_pasid() in the fault
path? It looks sort of like the plan is to use iopf_param->lock and
ensure domain removal grabs that lock at least after the xarray is
changed - but does that actually happen?

I would suggest, broadly, a flow for iommu_report_device_fault() sort
of:

1) Allocate memory for the evt. Every path except errors needs this,
   so just do it
2) iopf_get_dev_fault_param() should not have locks in it! This is
   fast path now. Use a refcount, atomic compare exchange to allocate,
   and RCU free.
3) Everything runs under the fault_param->lock
4) Check if !IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE, set it aside and then
   exit! This logic is really tortured and confusing
5) Allocate memory and assemble the group
6) Obtain the domain for this group and incr a per-domain counter that a
   fault is pending on that domain
7) Put the *group* into the WQ. Put the *group* on a list in fault_param
   instead of the individual faults
8) Don't linear search a linked list in iommu_page_response()! Pass
   the group in that we got from the WQ that we *know* is still
   active. Ack that passed group.

When freeing a domain wait for the per-domain counter to go to
zero. This ensures that the WQ is flushed out and all the outside
domain references are gone.

When wanting to turn off PRI make sure a non-PRI domain is
attached to everything. Fence against the HW's event queue. No new
iommu_report_device_fault() is possible.

Lock the fault_param->lock and go through every pending group and
respond it. Mark the group memory as invalid so iommu_page_response()
NOP's it. Unlock, fence the HW against queued responses, and turn off
PRI.

An *optimization* would be to lightly flush the domain when changing
the translation. Lock the fault_param->lock and look for groups in the
list with old_domain.  Do the same as for PRI-off: respond to the
group, mark it as NOP. The WQ may still be chewing on something so the
domain free still has to check and wait.

Did I get it right??

Jason

