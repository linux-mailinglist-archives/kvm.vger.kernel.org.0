Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D995A46B120
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 03:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhLGDBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 22:01:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:7991 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhLGDBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 22:01:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="217503763"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="217503763"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 18:57:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="515065510"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 06 Dec 2021 18:57:32 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/18] driver core: platform: Add driver dma ownership
 management
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-5-baolu.lu@linux.intel.com>
 <Ya4f662Af+8kE2F/@infradead.org> <20211206150647.GE4670@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <56a63776-48ca-0d6e-c25c-016dc016e0d5@linux.intel.com>
Date:   Tue, 7 Dec 2021 10:57:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211206150647.GE4670@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/21 11:06 PM, Jason Gunthorpe wrote:
> On Mon, Dec 06, 2021 at 06:36:27AM -0800, Christoph Hellwig wrote:
>> I really hate the amount of boilerplate code that having this in each
>> bus type causes.
> +1
> 
> I liked the first version of this series better with the code near
> really_probe().
> 
> Can we go back to that with some device_configure_dma() wrapper
> condtionally called by really_probe as we discussed?
> 

Are you talking about below change?

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 68ea1f949daa..368f9e530515 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -577,7 +577,13 @@ static int really_probe(struct device *dev, struct 
device_driver *drv)
  	if (dev->bus->dma_configure) {
  		ret = dev->bus->dma_configure(dev);
  		if (ret)
-			goto probe_failed;
+			goto pinctrl_bind_failed;
+
+		if (!drv->no_kernel_dma) {
+			ret = iommu_device_set_dma_owner(dev, DMA_OWNER_DMA_API, NULL);
+			if (ret)
+				goto pinctrl_bind_failed;
+                }
  	}

  	ret = driver_sysfs_add(dev);
@@ -660,6 +666,9 @@ static int really_probe(struct device *dev, struct 
device_driver *drv)
  	if (dev->bus)
  		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
  					     BUS_NOTIFY_DRIVER_NOT_BOUND, dev);
+
+	if (dev->bus->dma_configure && !drv->no_kernel_dma)
+		iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
  pinctrl_bind_failed:
  	device_links_no_driver(dev);
  	devres_release_all(dev);
@@ -1204,6 +1213,9 @@ static void __device_release_driver(struct device 
*dev, struct device *parent)
  		else if (drv->remove)
  			drv->remove(dev);

+		if (dev->bus->dma_configure && !drv->no_kernel_dma)
+			iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
+
  		device_links_driver_cleanup(dev);

  		devres_release_all(dev);
diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
index a498ebcf4993..2cf7b757b28e 100644
--- a/include/linux/device/driver.h
+++ b/include/linux/device/driver.h
@@ -100,6 +100,7 @@ struct device_driver {
  	const char		*mod_name;	/* used for built-in modules */

  	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
+	bool no_kernel_dma;
  	enum probe_type probe_type;

  	const struct of_device_id	*of_match_table;

Best regards,
baolu
