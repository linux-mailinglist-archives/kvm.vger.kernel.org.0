Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A1517BACD
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 11:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgCFKyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 05:54:50 -0500
Received: from foss.arm.com ([217.140.110.172]:59570 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbgCFKyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 05:54:49 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13F5231B;
        Fri,  6 Mar 2020 02:54:49 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BAA93F6C4;
        Fri,  6 Mar 2020 02:54:48 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 14/30] vfio/pci: Don't access potentially
 unallocated regions
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-15-alexandru.elisei@arm.com>
 <20200129181708.0c360d71@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <14f4ee8d-f6b5-c54d-5d81-169d1fd427e5@arm.com>
Date:   Fri, 6 Mar 2020 10:54:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200129181708.0c360d71@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/29/20 6:17 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:47:49 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> Don't try to configure a BAR if there is no region associated with it.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  vfio/pci.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/vfio/pci.c b/vfio/pci.c
>> index 1f38f90c3ae9..f86a7d9b7032 100644
>> --- a/vfio/pci.c
>> +++ b/vfio/pci.c
>> @@ -652,6 +652,8 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
>>  
>>  	/* Initialise the BARs */
>>  	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
>> +		if ((u32)i == vdev->info.num_regions)
>> +			break;
> My inner check-patch complains that we should not have code before declarations.
> Can we solve this the same way as below?

Sure, I'll change it and update the commit message accordingly.

Thanks, Alex

>
> Cheers,
> Andre
>
>
>>  		u64 base;
>>  		struct vfio_region *region = &vdev->regions[i];
>>  
>> @@ -853,11 +855,12 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
>>  	u32 bar;
>>  	size_t map_size;
>>  	struct vfio_pci_device *pdev = &vdev->pci;
>> -	struct vfio_region *region = &vdev->regions[nr];
>> +	struct vfio_region *region;
>>  
>>  	if (nr >= vdev->info.num_regions)
>>  		return 0;
>>  
>> +	region = &vdev->regions[nr];
>>  	bar = pdev->hdr.bar[nr];
>>  
>>  	region->vdev = vdev;
