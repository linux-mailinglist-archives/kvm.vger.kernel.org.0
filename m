Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C33024B74E
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 13:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfFSLo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 07:44:56 -0400
Received: from foss.arm.com ([217.140.110.172]:35194 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbfFSLo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 07:44:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 284C7360;
        Wed, 19 Jun 2019 04:44:55 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A30193F738;
        Wed, 19 Jun 2019 04:46:39 -0700 (PDT)
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc:     "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vincent Stehle <Vincent.Stehle@arm.com>,
        Robin Murphy <Robin.Murphy@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-27-eric.auger@redhat.com>
 <20190603163139.70fe8839@x1.home>
 <10dd60d9-4af0-c0eb-08c9-a0db7ee1925e@redhat.com>
 <20190605154553.0d00ad8d@jacob-builder>
 <2753d192-1c46-d78e-c425-0c828e48cde2@arm.com>
 <20190606132903.064f7ac4@jacob-builder>
 <dc051424-67d7-02ff-9b8e-0d7a8a4e59eb@arm.com>
 <20190607104301.6b1bbd74@jacob-builder>
 <e02b024f-6ebc-e8fa-c30c-5bf3f4b164d6@arm.com>
 <20190610143134.7bff96e9@jacob-builder>
 <905f130b-02dc-6971-8d5b-ce87d9bc96a4@arm.com>
 <20190612115358.0d90b322@jacob-builder>
 <77405d39-81a4-d9a8-5d35-27602199867a@arm.com>
 <20190618171908.76284cd7@jacob-builder>
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <138f6a16-d2ee-d7b8-7bfb-ac08b6cfb9da@arm.com>
Date:   Wed, 19 Jun 2019 12:44:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190618171908.76284cd7@jacob-builder>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/2019 01:19, Jacob Pan wrote:
>>> I see this as a future extension due to limited testing,   
>>
>> I'm wondering how we deal with:
>> (1) old userspace that won't fill the new private_data field in
>> page_response. A new kernel still has to support it.
>> (2) old kernel that won't recognize the new PRIVATE_DATA flag.
>> Currently iommu_page_response() rejects page responses with unknown
>> flags.
>>
>> I guess we'll need a two-way negotiation, where userspace queries
>> whether the kernel supports the flag (2), and the kernel learns
>> whether it should expect the private data to come back (1).
>>
> I am not sure case (1) exist in that there is no existing user space
> supports PRQ w/o private data. Am I missing something?
> 
> For VT-d emulation, private data is always part of the scalable mode
> PASID capability. If vIOMMU query host supports PASID and scalable
> mode, it will always support private data once PRQ is enabled.

Right if VT-d won't ever support page_response without private data then
I don't think we have to worry about (1).

> So I think we only need to negotiate (2) which should be covered by
> VT-d PASID cap.
> 
>>> perhaps for
>>> now, can you add paddings similar to page request? Make it 64B as
>>> well.  
>>
>> I don't think padding is necessary, because iommu_page_response is
>> sent by userspace to the kernel, unlike iommu_fault which is
>> allocated by userspace and filled by the kernel.
>>
>> Page response looks a lot more like existing VFIO mechanisms, so I
>> suppose we'll wrap the iommu_page_response structure and include an
>> argsz parameter at the top:
>>
>> 	struct vfio_iommu_page_response {
>> 		u32 argsz;
>> 		struct iommu_page_response pr;
>> 	};
>>
>> 	struct vfio_iommu_page_response vpr = {
>> 		.argsz = sizeof(vpr),
>> 		.pr = ...
>> 		...
>> 	};
>>
>> 	ioctl(devfd, VFIO_IOMMU_PAGE_RESPONSE, &vpr);
>>
>> In that case supporting private data can be done by simply appending a
>> field at the end (plus the negotiation above).
>>
> Do you mean at the end of struct vfio_iommu_page_response{}? or at
> the end of that seems struct iommu_page_response{}?
> 
> The consumer of the private data is iommu driver not vfio. So I think
> you want to add the new field at the end of struct iommu_page_response,
> right?

Yes that's what I meant

Thanks,
Jean
