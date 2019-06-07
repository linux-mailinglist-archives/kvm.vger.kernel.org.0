Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA39538CA8
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 16:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbfFGOSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 10:18:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18503 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728442AbfFGOSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 10:18:45 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 878C2308339B;
        Fri,  7 Jun 2019 14:18:35 +0000 (UTC)
Received: from [10.36.116.67] (ovpn-116-67.ams2.redhat.com [10.36.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B60A57A4F5;
        Fri,  7 Jun 2019 14:18:23 +0000 (UTC)
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
To:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Robin Murphy <Robin.Murphy@arm.com>
Cc:     "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Vincent Stehle <Vincent.Stehle@arm.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-27-eric.auger@redhat.com>
 <63b37149-1f74-bca1-35ea-5e849c0c2bbb@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <76b9b3a8-28dc-8629-f3cc-23e42f869c3a@redhat.com>
Date:   Fri, 7 Jun 2019 16:18:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <63b37149-1f74-bca1-35ea-5e849c0c2bbb@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 07 Jun 2019 14:18:45 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

On 6/7/19 2:48 PM, Jean-Philippe Brucker wrote:
> On 26/05/2019 17:10, Eric Auger wrote:
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
> 
> Could you check fault.type and return an error if it's not UNRECOV here?
> If the fault is recoverable (very unlikely since the PRI capability is
> disabled, but allowed) and we return an error here, then the caller
> takes care of completing the fault. If we forward it to the guest
> instead, the producer will wait indefinitely for a response.
Sure I will add that check in the next version.

Thanks

Eric
> 
> Thanks,
> Jean
> 
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
