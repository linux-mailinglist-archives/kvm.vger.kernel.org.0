Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F953194ADC
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 22:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCZVqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 17:46:09 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12994 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgCZVqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 17:46:09 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7d22930000>; Thu, 26 Mar 2020 14:45:55 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 26 Mar 2020 14:46:08 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 26 Mar 2020 14:46:08 -0700
Received: from [10.40.103.35] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 26 Mar
 2020 21:45:47 +0000
Subject: Re: [PATCH v16 Kernel 2/7] vfio iommu: Remove atomicity of ref_count
 of pinned pages
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
 <1585078359-20124-3-git-send-email-kwankhede@nvidia.com>
 <20200326114935.4e729fba.cohuck@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <257a0b2e-129d-f606-99b8-09a24dc9f648@nvidia.com>
Date:   Fri, 27 Mar 2020 03:15:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326114935.4e729fba.cohuck@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585259155; bh=dUDTJr9BkEIVgCIMHumoa3TnFE5OADEV1EFCEb6yiwY=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=hUfGSDjTb40vS+CFjtSoQaXk4qInEsw5DtPB+P7YRx6JTR+znWooqLzZ4lqQaWFkA
         1Q99IPVkDLh0pXBG4ePB80lOc7LxfObT7JtCcCr8ho8Bhpu4gCskj1dlTglgwWRVXj
         H1IvV2VhI9JI7FWuOkiXhDtPW6CzMj1VIbJ8HMG7kcW/ENkeq+7btRJOVj5WZWCJ3R
         sSw4N2YNkNiSIW2cWS5Fx5UUOVFUfjVxqh2JKF6qEdT4shaLV0VbnblHZ7R4+eHKU8
         zuULbXJ7k7KTZX08XDrL0QrdTj9EQ2ziEypVBm9lrEnglN83VHpB4FhpZ9QXoEtd8b
         kz4vi/9j3e6nQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/26/2020 4:19 PM, Cornelia Huck wrote:
> On Wed, 25 Mar 2020 01:02:34 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> vfio_pfn.ref_count is always updated by holding iommu->lock, using atomic
> 
> s/by/while/
> 

Ok.

>> variable is overkill.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Kirti
