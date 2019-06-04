Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD59334CF0
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 18:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbfFDQLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 12:11:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbfFDQLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 12:11:45 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E301D2F8BDD;
        Tue,  4 Jun 2019 16:11:21 +0000 (UTC)
Received: from [10.36.116.67] (ovpn-116-67.ams2.redhat.com [10.36.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5C836064C;
        Tue,  4 Jun 2019 16:11:09 +0000 (UTC)
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        jean-philippe.brucker@arm.com, will.deacon@arm.com,
        robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com,
        marc.zyngier@arm.com, peter.maydell@linaro.org,
        vincent.stehle@arm.com
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-27-eric.auger@redhat.com>
 <20190603163139.70fe8839@x1.home>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <10dd60d9-4af0-c0eb-08c9-a0db7ee1925e@redhat.com>
Date:   Tue, 4 Jun 2019 18:11:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190603163139.70fe8839@x1.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 04 Jun 2019 16:11:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 6/4/19 12:31 AM, Alex Williamson wrote:
> On Sun, 26 May 2019 18:10:01 +0200
> Eric Auger <eric.auger@redhat.com> wrote:
> 
>> This patch registers a fault handler which records faults in
>> a circular buffer and then signals an eventfd. This buffer is
>> exposed within the fault region.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v3 -> v4:
>> - move iommu_unregister_device_fault_handler to vfio_pci_release
>> ---
>>  drivers/vfio/pci/vfio_pci.c         | 49 +++++++++++++++++++++++++++++
>>  drivers/vfio/pci/vfio_pci_private.h |  1 +
>>  2 files changed, 50 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index f75f61127277..520999994ba8 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -30,6 +30,7 @@
>>  #include <linux/vfio.h>
>>  #include <linux/vgaarb.h>
>>  #include <linux/nospec.h>
>> +#include <linux/circ_buf.h>
>>  
>>  #include "vfio_pci_private.h"
>>  
>> @@ -296,6 +297,46 @@ static const struct vfio_pci_regops vfio_pci_fault_prod_regops = {
>>  	.add_capability = vfio_pci_fault_prod_add_capability,
>>  };
>>  
>> +int vfio_pci_iommu_dev_fault_handler(struct iommu_fault_event *evt, void *data)
>> +{
>> +	struct vfio_pci_device *vdev = (struct vfio_pci_device *) data;
>> +	struct vfio_region_fault_prod *prod_region =
>> +		(struct vfio_region_fault_prod *)vdev->fault_pages;
>> +	struct vfio_region_fault_cons *cons_region =
>> +		(struct vfio_region_fault_cons *)(vdev->fault_pages + 2 * PAGE_SIZE);
>> +	struct iommu_fault *new =
>> +		(struct iommu_fault *)(vdev->fault_pages + prod_region->offset +
>> +			prod_region->prod * prod_region->entry_size);
>> +	int prod, cons, size;
>> +
>> +	mutex_lock(&vdev->fault_queue_lock);
>> +
>> +	if (!vdev->fault_abi)
>> +		goto unlock;
>> +
>> +	prod = prod_region->prod;
>> +	cons = cons_region->cons;
>> +	size = prod_region->nb_entries;
>> +
>> +	if (CIRC_SPACE(prod, cons, size) < 1)
>> +		goto unlock;
>> +
>> +	*new = evt->fault;
>> +	prod = (prod + 1) % size;
>> +	prod_region->prod = prod;
>> +	mutex_unlock(&vdev->fault_queue_lock);
>> +
>> +	mutex_lock(&vdev->igate);
>> +	if (vdev->dma_fault_trigger)
>> +		eventfd_signal(vdev->dma_fault_trigger, 1);
>> +	mutex_unlock(&vdev->igate);
>> +	return 0;
>> +
>> +unlock:
>> +	mutex_unlock(&vdev->fault_queue_lock);
>> +	return -EINVAL;
>> +}
>> +
>>  static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
>>  {
>>  	struct vfio_region_fault_prod *header;
>> @@ -328,6 +369,13 @@ static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
>>  	header = (struct vfio_region_fault_prod *)vdev->fault_pages;
>>  	header->version = -1;
>>  	header->offset = PAGE_SIZE;
>> +
>> +	ret = iommu_register_device_fault_handler(&vdev->pdev->dev,
>> +					vfio_pci_iommu_dev_fault_handler,
>> +					vdev);
>> +	if (ret)
>> +		goto out;
>> +
>>  	return 0;
>>  out:
>>  	kfree(vdev->fault_pages);
>> @@ -570,6 +618,7 @@ static void vfio_pci_release(void *device_data)
>>  	if (!(--vdev->refcnt)) {
>>  		vfio_spapr_pci_eeh_release(vdev->pdev);
>>  		vfio_pci_disable(vdev);
>> +		iommu_unregister_device_fault_handler(&vdev->pdev->dev);
> 
> 
> But this can fail if there are pending faults which leaves a device
> reference and then the system is broken :(
This series only features unrecoverable errors and for those the
unregistration cannot fail. Now unrecoverable errors were added I admit
this is confusing. We need to sort this out or clean the dependencies.

Thanks

Eric
> 
>>  	}
>>  
>>  	mutex_unlock(&vdev->reflck->lock);
>> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
>> index 8e0a55682d3f..a9276926f008 100644
>> --- a/drivers/vfio/pci/vfio_pci_private.h
>> +++ b/drivers/vfio/pci/vfio_pci_private.h
>> @@ -122,6 +122,7 @@ struct vfio_pci_device {
>>  	int			ioeventfds_nr;
>>  	struct eventfd_ctx	*err_trigger;
>>  	struct eventfd_ctx	*req_trigger;
>> +	struct eventfd_ctx	*dma_fault_trigger;
>>  	struct mutex		fault_queue_lock;
>>  	int			fault_abi;
>>  	struct list_head	dummy_resources_list;
> 
