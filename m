Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486BE1C7A6D
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 21:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgEFTmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 15:42:37 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18656 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgEFTmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 15:42:37 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb312e60000>; Wed, 06 May 2020 12:41:26 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 06 May 2020 12:42:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 06 May 2020 12:42:36 -0700
Received: from [10.40.101.152] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 6 May
 2020 19:42:28 +0000
Subject: Re: [PATCH Kernel v18 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1588607939-26441-1-git-send-email-kwankhede@nvidia.com>
 <1588607939-26441-5-git-send-email-kwankhede@nvidia.com>
 <20200506081510.GC19334@joy-OptiPlex-7040>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <24223faa-15ac-bd71-6c5d-9d0401fbd839@nvidia.com>
Date:   Thu, 7 May 2020 01:12:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506081510.GC19334@joy-OptiPlex-7040>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588794086; bh=2UucDHCcZRcqsK6rvz3RFBMb5/5vStjZrc4LPAOuYqE=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ciquREBwYTqEnOgMF6h8muwtFA5JvI8xgXh5Psaf3baRYVIga40jBWwoE4tlZYs6l
         5BnY5yFQviqcClSFihrCOtyMQlpkzqsnPvmHoJCE0pD1wYAOYjnH/nifBPa715HCyw
         wr1w1GkiDL3rgpcXgSD4dMhA9WZZXhWOQpFGUo74TLBJ5JZVSqPJ405NoLEHafEGar
         xAYSm1VVcXVQdFlk9qIRnkysNIqe6Kbo22DDJuHYzbqYzNa3b/x1tthCEv26u35LmD
         CJ/hqWOCaoe6bwy+y+O2PqO6RLsLje2PNAuxG6z3oHf1zn39ccUcOcS+vfMquKr0cy
         sVoGAHIY4wsFw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/6/2020 1:45 PM, Yan Zhao wrote:
> On Mon, May 04, 2020 at 11:58:56PM +0800, Kirti Wankhede wrote:

<snip>

>>   /*
>>    * Helper Functions for host iova-pfn list
>>    */
>> @@ -567,6 +654,18 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>   			vfio_unpin_page_external(dma, iova, do_accounting);
>>   			goto pin_unwind;
>>   		}
>> +
>> +		if (iommu->dirty_page_tracking) {
>> +			unsigned long pgshift =
>> +					 __ffs(vfio_pgsize_bitmap(iommu));
>> +
> hi Kirti,
> may I know if there's any vfio_pin_pages() happpening during NVidia's vGPU migration?
> the code would enter into deadlock as I reported in last version.
> 

Hm, you are right and same is the case in vfio_iommu_type1_dma_rw_chunk().

Instead of calling vfio_pgsize_bitmap() from lots of places, I'm 
thinking of saving pgsize_bitmap in struct vfio_iommu, which should be 
populated whenever domain_list is updated. Alex, will that be fine?

Thanks,
Kirti


> Thanks
> Yan
> 
