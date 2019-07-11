Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5FDE657A0
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 15:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbfGKNH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 09:07:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbfGKNH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 09:07:29 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 188D930820C9;
        Thu, 11 Jul 2019 13:07:28 +0000 (UTC)
Received: from [10.36.116.46] (ovpn-116-46.ams2.redhat.com [10.36.116.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB7871001B0F;
        Thu, 11 Jul 2019 13:07:20 +0000 (UTC)
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
To:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc:     "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Vincent Stehle <Vincent.Stehle@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Robin Murphy <Robin.Murphy@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>
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
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b441c7aa-7aab-d816-f87f-7981dfeebc48@redhat.com>
Date:   Thu, 11 Jul 2019 15:07:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <77405d39-81a4-d9a8-5d35-27602199867a@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 11 Jul 2019 13:07:28 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean, Jacob,

On 6/18/19 4:04 PM, Jean-Philippe Brucker wrote:
> On 12/06/2019 19:53, Jacob Pan wrote:
>>>> You are right, the worst case of the spurious PS is to terminate the
>>>> group prematurely. Need to know the scope of the HW damage in case
>>>> of mdev where group IDs can be shared among mdevs belong to the
>>>> same PF.  
>>>
>>> But from the IOMMU fault API point of view, the full page request is
>>> identified by both PRGI and PASID. Given that each mdev has its own
>>> set of PASIDs, it should be easy to isolate page responses per mdev.
>>>
>> On Intel platform, devices sending page request with private data must
>> receive page response with matching private data. If we solely depend
>> on PRGI and PASID, we may send stale private data to the device in
>> those incorrect page response. Since private data may represent PF
>> device wide contexts, the consequence of sending page response with
>> wrong private data may affect other mdev/PASID.
>>
>> One solution we are thinking to do is to inject the sequence #(e.g.
>> ktime raw mono clock) as vIOMMU private data into to the guest. Guest
>> would return this fake private data in page response, then host will
>> send page response back to the device that matches PRG1 and PASID and
>> private_data.
>>
>> This solution does not expose HW context related private data to the
>> guest but need to extend page response in iommu uapi.
>>
>> /**
>>  * struct iommu_page_response - Generic page response information
>>  * @version: API version of this structure
>>  * @flags: encodes whether the corresponding fields are valid
>>  *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
>>  * @pasid: Process Address Space ID
>>  * @grpid: Page Request Group Index
>>  * @code: response code from &enum iommu_page_response_code
>>  * @private_data: private data for the matching page request
>>  */
>> struct iommu_page_response {
>> #define IOMMU_PAGE_RESP_VERSION_1	1
>> 	__u32	version;
>> #define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
>> #define IOMMU_PAGE_RESP_PRIVATE_DATA	(1 << 1)
>> 	__u32	flags;
>> 	__u32	pasid;
>> 	__u32	grpid;
>> 	__u32	code;
>> 	__u32	padding;
>> 	__u64	private_data[2];
>> };
>>
>> There is also the change needed for separating storage for the real and
>> fake private data.
>>
>> Sorry for the last minute change, did not realize the HW implications.
>>
>> I see this as a future extension due to limited testing, 
> 
> I'm wondering how we deal with:
> (1) old userspace that won't fill the new private_data field in
> page_response. A new kernel still has to support it.
> (2) old kernel that won't recognize the new PRIVATE_DATA flag. Currently
> iommu_page_response() rejects page responses with unknown flags.
> 
> I guess we'll need a two-way negotiation, where userspace queries
> whether the kernel supports the flag (2), and the kernel learns whether
> it should expect the private data to come back (1).
> 
>> perhaps for
>> now, can you add paddings similar to page request? Make it 64B as well.
> 
> I don't think padding is necessary, because iommu_page_response is sent
> by userspace to the kernel, unlike iommu_fault which is allocated by
> userspace and filled by the kernel.
> 
> Page response looks a lot more like existing VFIO mechanisms, so I
> suppose we'll wrap the iommu_page_response structure and include an
> argsz parameter at the top:
> 
> 	struct vfio_iommu_page_response {
> 		u32 argsz;
> 		struct iommu_page_response pr;
> 	};
> 
> 	struct vfio_iommu_page_response vpr = {
> 		.argsz = sizeof(vpr),
> 		.pr = ...
> 		...
> 	};
> 
> 	ioctl(devfd, VFIO_IOMMU_PAGE_RESPONSE, &vpr);
> 
> In that case supporting private data can be done by simply appending a
> field at the end (plus the negotiation above).

Sorry I did not quite follow the spurious response discussion but I just
noticed we still do have, upstream, in
iommu_unregister_device_fault_handler:

	/* we cannot unregister handler if there are pending faults */
	if (!list_empty(&param->fault_param->faults)) {
		ret = -EBUSY;
		goto unlock;
	}

So did you eventually decide to let
iommu_unregister_device_fault_handler fail or is an oversight?

Thanks

Eric


> 
> Thanks,
> Jean
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> 
