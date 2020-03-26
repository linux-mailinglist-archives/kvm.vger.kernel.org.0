Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF15194AC7
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 22:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgCZVkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 17:40:19 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15231 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbgCZVkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 17:40:19 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7d21140002>; Thu, 26 Mar 2020 14:39:32 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 26 Mar 2020 14:40:18 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 26 Mar 2020 14:40:18 -0700
Received: from [10.40.103.35] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 26 Mar
 2020 21:39:59 +0000
Subject: Re: [PATCH v16 Kernel 1/7] vfio: KABI for migration interface for
 device state
To:     Cornelia Huck <cohuck@redhat.com>
CC:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1585078359-20124-1-git-send-email-kwankhede@nvidia.com>
 <1585078359-20124-2-git-send-email-kwankhede@nvidia.com>
 <20200326114150.2b5430b9.cohuck@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <acfa7027-123f-6acf-769d-59c5991dd331@nvidia.com>
Date:   Fri, 27 Mar 2020 03:09:52 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326114150.2b5430b9.cohuck@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585258772; bh=HTfsOH15X1fJ2ccj2OyOcpNOtjiQiB35/SR79O3J9Zg=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=rEil14Lwu3fQv0lbGxyyBCWfnLbWI5FfdKS9HtGkLntqhFy205GOwkFJSL1VZtzLN
         Lz/m6tK8SMOUfbH+EbUfwNFJlBq0tRstKEBMIoX4lLk9tvyqWXisxJncn2bNoQKIze
         isN9hYrWU6RRkKcaxtf83W0qTDQRAUC3aPhauOmbZ2MY/CGn0iAzWNtEDV9yPyxm82
         f6cpbG/67pa4J2zUKqBMVXXhQw7pg+TiF0TFgUQEPb7W4/zW+axPPGBxCbE31nefRu
         QDXBlfGaFQtE7Fg60PEchkbpA7r8ymkXoNGqdFEjkiA/kXyct1NWO37btEDeNpplyY
         K0s9bfjm0PUIQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/26/2020 4:11 PM, Cornelia Huck wrote:
> On Wed, 25 Mar 2020 01:02:33 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> - Defined MIGRATION region type and sub-type.
>>
>> - Defined vfio_device_migration_info structure which will be placed at the
>>    0th offset of migration region to get/set VFIO device related
>>    information. Defined members of structure and usage on read/write access.
>>
>> - Defined device states and state transition details.
>>
>> - Defined sequence to be followed while saving and resuming VFIO device.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> ---
>>   include/uapi/linux/vfio.h | 228 ++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 228 insertions(+)
> 
> (...)
> 
>> +struct vfio_device_migration_info {
>> +	__u32 device_state;         /* VFIO device state */
>> +#define VFIO_DEVICE_STATE_STOP      (0)
>> +#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
>> +#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
>> +#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
>> +#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
>> +				     VFIO_DEVICE_STATE_SAVING |  \
>> +				     VFIO_DEVICE_STATE_RESUMING)
>> +
>> +#define VFIO_DEVICE_STATE_VALID(state) \
>> +	(state & VFIO_DEVICE_STATE_RESUMING ? \
>> +	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
>> +
>> +#define VFIO_DEVICE_STATE_IS_ERROR(state) \
>> +	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
>> +					      VFIO_DEVICE_STATE_RESUMING))
>> +
>> +#define VFIO_DEVICE_STATE_SET_ERROR(state) \
>> +	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
>> +					     VFIO_DEVICE_STATE_RESUMING)
>> +
>> +	__u32 reserved;
>> +	__u64 pending_bytes;
>> +	__u64 data_offset;
>> +	__u64 data_size;
>> +} __attribute__((packed));
> 
> The 'packed' should not even be needed, I think?
> 

Right, Above structure is padded properly. Removing it.

>> +
>>   /*
>>    * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
>>    * which allows direct access to non-MSIX registers which happened to be within
> 
> Generally, this looks sane to me; however, we should really have
> something under Documentation/ in the long run that describes how this
> works, so that you can find out about the protocol without having to
> dig through headers.
> 

But the documentation will have almost the same text as in this comment. 
Should we replicate it?

Thanks,
Kirti

