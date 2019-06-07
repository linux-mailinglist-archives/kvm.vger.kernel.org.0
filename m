Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1B838A99
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 14:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbfFGMse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 08:48:34 -0400
Received: from foss.arm.com ([217.140.110.172]:39564 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbfFGMse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 08:48:34 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77A82499;
        Fri,  7 Jun 2019 05:48:33 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 734AA40151;
        Fri,  7 Jun 2019 05:48:31 -0700 (PDT)
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
To:     Eric Auger <eric.auger@redhat.com>,
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
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <63b37149-1f74-bca1-35ea-5e849c0c2bbb@arm.com>
Date:   Fri, 7 Jun 2019 13:48:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190526161004.25232-27-eric.auger@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/2019 17:10, Eric Auger wrote:
> +int vfio_pci_iommu_dev_fault_handler(struct iommu_fault_event *evt, void *data)
> +{
> +	struct vfio_pci_device *vdev = (struct vfio_pci_device *) data;
> +	struct vfio_region_fault_prod *prod_region =
> +		(struct vfio_region_fault_prod *)vdev->fault_pages;
> +	struct vfio_region_fault_cons *cons_region =
> +		(struct vfio_region_fault_cons *)(vdev->fault_pages + 2 * PAGE_SIZE);
> +	struct iommu_fault *new =
> +		(struct iommu_fault *)(vdev->fault_pages + prod_region->offset +
> +			prod_region->prod * prod_region->entry_size);
> +	int prod, cons, size;
> +
> +	mutex_lock(&vdev->fault_queue_lock);
> +
> +	if (!vdev->fault_abi)
> +		goto unlock;
> +
> +	prod = prod_region->prod;
> +	cons = cons_region->cons;
> +	size = prod_region->nb_entries;
> +
> +	if (CIRC_SPACE(prod, cons, size) < 1)
> +		goto unlock;
> +
> +	*new = evt->fault;

Could you check fault.type and return an error if it's not UNRECOV here?
If the fault is recoverable (very unlikely since the PRI capability is
disabled, but allowed) and we return an error here, then the caller
takes care of completing the fault. If we forward it to the guest
instead, the producer will wait indefinitely for a response.

Thanks,
Jean

> +	prod = (prod + 1) % size;
> +	prod_region->prod = prod;
> +	mutex_unlock(&vdev->fault_queue_lock);
> +
> +	mutex_lock(&vdev->igate);
> +	if (vdev->dma_fault_trigger)
> +		eventfd_signal(vdev->dma_fault_trigger, 1);
> +	mutex_unlock(&vdev->igate);
> +	return 0;
> +
> +unlock:
> +	mutex_unlock(&vdev->fault_queue_lock);
> +	return -EINVAL;
> +}
