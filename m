Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778E332A6C1
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 17:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348556AbhCBPpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:45:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:28280 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238266AbhCBAYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 19:24:45 -0500
IronPort-SDR: iN3hYikNJIOSX3u7mrI/drGhaxtKaanPDUGiOIYz0YI24wyzP1XBWtbc8WtAe2B3FHnM+dtz9P
 NZmXfRqL47mw==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="184200619"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="184200619"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:23:49 -0800
IronPort-SDR: Om+hs81dnl54ZKsRsn+DsJSHwC6HUChzPGlYt8f2xbAeGL6jI8NFR68jCMYWwF8DSPWIbaV8Nt
 MgXbA0z6jRaw==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="517624851"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.197.33]) ([10.212.197.33])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:23:48 -0800
Subject: Re: [PATCH v5 05/14] vfio/mdev: idxd: add basic mdev registration and
 helper functions
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, parav@mellanox.com, netanelg@mellanox.com,
        shahafs@mellanox.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255840486.339900.5478922203128287192.stgit@djiang5-desk3.ch.intel.com>
 <20210210235924.GJ4247@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <b41828e1-ab67-856b-f2c0-6215106ba813@intel.com>
Date:   Mon, 1 Mar 2021 17:23:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210235924.GJ4247@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/10/2021 4:59 PM, Jason Gunthorpe wrote:
> On Fri, Feb 05, 2021 at 01:53:24PM -0700, Dave Jiang wrote:

<-- cut for brevity -->


> +static int vdcm_idxd_set_msix_trigger(struct vdcm_idxd *vidxd,
> +				      unsigned int index, unsigned int start,
> +				      unsigned int count, uint32_t flags,
> +				      void *data)
> +{
> +	int i, rc = 0;
> +
> +	if (count > VIDXD_MAX_MSIX_ENTRIES - 1)
> +		count = VIDXD_MAX_MSIX_ENTRIES - 1;
> +
> +	if (count == 0 && (flags & VFIO_IRQ_SET_DATA_NONE)) {
> +		/* Disable all MSIX entries */
> +		for (i = 0; i < VIDXD_MAX_MSIX_ENTRIES; i++) {
> +			rc = msix_trigger_unregister(vidxd, i);
> +			if (rc < 0)
> +				return rc;
> +		}
> +		return 0;
> +	}
> +
> +	for (i = 0; i < count; i++) {
> +		if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> +			u32 fd = *(u32 *)(data + i * sizeof(u32));
> +
> +			rc = msix_trigger_register(vidxd, fd, i);
> +			if (rc < 0)
> +				return rc;
> +		} else if (flags & VFIO_IRQ_SET_DATA_NONE) {
> +			rc = msix_trigger_unregister(vidxd, i);
> +			if (rc < 0)
> +				return rc;
> +		}
> +	}
> +	return rc;
> +}
> +
> +static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags,
> +			      unsigned int index, unsigned int start,
> +			      unsigned int count, void *data)
> +{
> +	int (*func)(struct vdcm_idxd *vidxd, unsigned int index,
> +		    unsigned int start, unsigned int count, uint32_t flags,
> +		    void *data) = NULL;
> +	struct mdev_device *mdev = vidxd->vdev.mdev;
> +	struct device *dev = mdev_dev(mdev);
> +
> +	switch (index) {
> +	case VFIO_PCI_INTX_IRQ_INDEX:
> +		dev_warn(dev, "intx interrupts not supported.\n");
> +		break;
> +	case VFIO_PCI_MSI_IRQ_INDEX:
> +		dev_dbg(dev, "msi interrupt.\n");
> +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> +		case VFIO_IRQ_SET_ACTION_MASK:
> +		case VFIO_IRQ_SET_ACTION_UNMASK:
> +			break;
> +		case VFIO_IRQ_SET_ACTION_TRIGGER:
> +			func = vdcm_idxd_set_msix_trigger;
> This would be a good place to insert a common VFIO helper library to
> take care of the MSI-X emulation for IMS.

Hi Jason,

So after looking at the code in vfio_pci_intrs.c, I agree that the 
set_irqs code between VFIO_PCI and this driver can be made in common. 
Given that Alex doesn't want a vfio_pci device embedded in the driver, I 
think we'll need some sort of generic VFIO device that can be used from 
the vfio_pci side and vfio_mdev side to pass down in order to have 
common support library functions. Do you have any thoughts on how to do 
this cleanly architecturally? Also, with vfio_pci common split [1] still 
being worked on, do you think we can defer the work on making the 
interrupt setup code common until the vfio_pci split work settles? Thanks!

[1]: https://lore.kernel.org/kvm/20210201162828.5938-1-mgurtovoy@nvidia.com/


