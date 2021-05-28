Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0093945F4
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 18:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbhE1Qjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 12:39:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:56761 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229768AbhE1Qje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 12:39:34 -0400
IronPort-SDR: GPE9xYbcxpjl1Rp1doAT6AXMNa43L8h7FOpGpn1iu8jREE+svNqDjnowe+OygFXSIsvzxBT+QR
 EwoP/PxpYXPg==
X-IronPort-AV: E=McAfee;i="6200,9189,9998"; a="202990024"
X-IronPort-AV: E=Sophos;i="5.83,229,1616482800"; 
   d="scan'208";a="202990024"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2021 09:37:59 -0700
IronPort-SDR: nuprb2pRUyvSOcpQNsBLmhDvS3EkTuTjQqMQIkVZhwz0/P/zOJUm0tPg+guCxZfOzw4cL/j45f
 rAeLqRpsmU7g==
X-IronPort-AV: E=Sophos;i="5.83,229,1616482800"; 
   d="scan'208";a="473140693"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.251.147.238]) ([10.251.147.238])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2021 09:37:57 -0700
Subject: Re: [PATCH v6 05/20] vfio: mdev: common lib code for setting up
 Interrupt Message Store
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com>
 <20210524000257.GN1002214@nvidia.com>
 <44ba4c5f-aa40-3149-85a5-3e382f9c2eae@intel.com>
 <20210528122145.GK1002214@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <b0932f3a-4337-cb69-242d-b91e8aba9196@intel.com>
Date:   Fri, 28 May 2021 09:37:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210528122145.GK1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/28/2021 5:21 AM, Jason Gunthorpe wrote:
> On Thu, May 27, 2021 at 06:49:59PM -0700, Dave Jiang wrote:
>>>> +static int mdev_msix_enable(struct mdev_irq *mdev_irq, int nvec)
>>>> +{
>>>> +	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
>>>> +	struct device *dev;
>>>> +	int rc;
>>>> +
>>>> +	if (nvec != mdev_irq->num)
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (mdev_irq->ims_num) {
>>>> +		dev = &mdev->dev;
>>>> +		rc = msi_domain_alloc_irqs(dev_get_msi_domain(dev), dev, mdev_irq->ims_num);
>>> Huh? The PCI device should be the only device touching IRQ stuff. I'm
>>> nervous to see you mix in the mdev struct device into this function.
>> As we talked about in the other thread. We have a single IMS domain per
>> device. The domain is set to the mdev 'struct device' and we allocate the
>> vectors to each mdev 'struct device' so we can manage those IMS vectors
>> specifically for that mdev.
> That is not the point, I'm asking if you should be calling
> dev_set_msi_domain(mdev) at all

I'm not familiar with the standard way of doing this. Should I not set 
the domain to the mdev 'struct device' because I can have multiple mdev 
using the same domain? With the domain set, I am able to retrieve it and 
call the msi_domain_alloc_irqs() in common code. Alternatively we can 
pass in the domain during init and not rely on dev->msi_domain.


>
> Jason
