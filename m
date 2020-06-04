Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC061EEA6E
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 20:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgFDSle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 14:41:34 -0400
Received: from mail-eopbgr130080.outbound.protection.outlook.com ([40.107.13.80]:50150
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726262AbgFDSld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 14:41:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWLs3O+VsxTwC3Ze1wHuWEl1c7Xge6CmuAalsp7DkEDKhcQyrzaaFK3/IXGqRBH1u+SS01kO6Q/GdKFGovg6rG0iHfXgAU1Qei6FvozPlRm8sqXTuJqMCOgwKyLZ5qFicO6p060SEbeDMa/sr1w+YBFH3j/YVzqoyxyVOlAAXfr4RwHswcNpKB+Rd8wNF6Js/B/6K3fCKYuwaelwzT9LEluEFRp3aRb8fVLXCrR+ZFDONcunwem3rF0T+8tJaHyXkFXp49FMoN+vP+6hZ43wwEWwdbnTxln9AeL9dx4AXIKCCD6C+zTmwG7iNMqRFdb9FyVVC51ienULRVjbA1KJ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssQHqLBkO0o5CXXdUKcJ3TIaYYGVPUgdNZElj3aRI2c=;
 b=cid038I4JNBisqQSGkfscTsf8NtiGomb42xVxIu95ucqiCwqrolM0P5fBp7TkROfS+uyeZrofJhE0D+VuHkNZJlpAvh6tudOEJZkKtOr0Krm7AktMS8zcpsO27BTRyMeiFMnZoMWpAQSyqO5FIWVD+0CLhWGuXImiGETRpa26QF1zfENQndsa10Aftzi2Ofde9mWeKiLh00fznWc3hA4kaftB+UT+wN76aEW2RdK3YcB8lFLKSb/9uqZK+MlaLhyKWwIVhWS44dsrvst1nfqkJZRgPoO0s0H+zhwDmcAn2FukxO54hqxp8+Gq6t3pM42P7kycURKx4Tu6I+gEH/wpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssQHqLBkO0o5CXXdUKcJ3TIaYYGVPUgdNZElj3aRI2c=;
 b=RQ4oVqyHITb0+0jcL/1naIt1vFij2w9kKEE6Wg2dVc9wAroqion6UXsMnFc7U5n6Ubtme83h+2jCZXKQISKRpTk8X2/ANaTVffcenBbg/L79IJYMyxtH/BQlKRwP83KVT5B3UJRDCOSQKcvgIpyoCWZwObFJBmjhkaaeI1HjlJg=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from HE1PR0402MB2809.eurprd04.prod.outlook.com (2603:10a6:3:da::17)
 by HE1PR0402MB2875.eurprd04.prod.outlook.com (2603:10a6:3:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.19; Thu, 4 Jun
 2020 18:41:28 +0000
Received: from HE1PR0402MB2809.eurprd04.prod.outlook.com
 ([fe80::c8b6:bdba:be68:289f]) by HE1PR0402MB2809.eurprd04.prod.outlook.com
 ([fe80::c8b6:bdba:be68:289f%8]) with mapi id 15.20.3045.024; Thu, 4 Jun 2020
 18:41:28 +0000
Subject: Re: [PATCH v2 5/9] vfio/fsl-mc: Allow userspace to MMAP fsl-mc device
 MMIO regions
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurentiu.tudor@nxp.com, bharatb.linux@gmail.com,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200508072039.18146-1-diana.craciun@oss.nxp.com>
 <20200508072039.18146-6-diana.craciun@oss.nxp.com>
 <20200601221244.5dadbb26@x1.home>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <98875181-4050-b90f-c299-435bfcdc7799@oss.nxp.com>
Date:   Thu, 4 Jun 2020 21:41:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200601221244.5dadbb26@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR01CA0130.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::35) To HE1PR0402MB2809.eurprd04.prod.outlook.com
 (2603:10a6:3:da::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.25.133.230) by AM0PR01CA0130.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Thu, 4 Jun 2020 18:41:27 +0000
X-Originating-IP: [188.25.133.230]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be6b51b1-37d7-412a-1cd3-08d808b6e473
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2875:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0402MB2875407E814CE5D7305CE106BE890@HE1PR0402MB2875.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04244E0DC5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1m9u+Y41BjsEfo+XxfDls6Ewk3yWuxccldNieEz7KQ5RiCHpHHTQtK9EE/dy3k+F3oBi9aPAdYn+ZLKBPiXGq8ZlWNDIZAViXGG1AlXs+PA15xUOVRCV1T+1qyu9D7aF0c345bxWj6ASUwrX6chSt31mYYwuaiyDqOCC5bsmbVRXJJYuA5fS28ZpgWIT6mWRqhKQ5ZRxQ/ta0OSzYpmCvfAVCCfUSsKGs3SwNihPle+kPe4o+VVQTeqndd32soUhTti2y2ON51a4U5N6MzMHa2VWbIcerltVgcYwA23kLledCxEdNAeJDG52ru9dbxJb+mxgJ1akguhjiLulLTjVu538PNuxhXv1tD61nykXt74zLTmVkbR9qBSEFvLj+PL7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2809.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(26005)(16526019)(186003)(66476007)(31686004)(86362001)(66946007)(66556008)(53546011)(52116002)(8676002)(83380400001)(31696002)(4326008)(8936002)(6916009)(6486002)(956004)(316002)(16576012)(5660300002)(2906002)(478600001)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BiFYVm6/kZXfpnkZ0gJcMdC9AGnnXtGgAWhfvfeIWvYJ344Kh6Y4Iqs2kl3Z8kMr9J0RkStAC7gur9YW0/hxQnlr8WokogfWjSxzX1mZQ72VpbgDDEKEPmn2zWIf2kzDY0bLr9LNCXVJO549aNp/1YDKdMW8SKQIbWn2FLa7NayAnjlymZp5Ig4L0SYNPcuch5cg2MbD6Z5JnSuF/JQssOv5Oh6ru9nJ/g/cM4QV0YQo7JdwLCT/l6s3p4QuCiHdPyKHMblurq7t67sZB6sUqkJYMu2HRUfIKcbSi2nWiLsjAzT9GBJMDRt7MplqKJa0ROreKHvL3anUjnmy02UGeSsMLuD/hg9wAEQq2s7FyHaxwRCvk5bmrH0Vw5lZ0S8LdH8t2tDq3WALTAKdtpBaLjBNL5AymJ3ep/dPMJyLM8gDeiXMgZCZbBWePpf55yBM43uIThQotQEesev8/Vt/7NN0FeMgwPfdNH56w0G1p+c=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be6b51b1-37d7-412a-1cd3-08d808b6e473
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2020 18:41:28.5343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UOOoVFme/+mE1HaueFh8Cc2UHljVg3hnS9/ClJ33uNL5rsRZt5WbGvfAzwzeOiWcVoegLx2QKq9mYyNA1Z4l0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2875
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/2020 7:12 AM, Alex Williamson wrote:
> On Fri,  8 May 2020 10:20:35 +0300
> Diana Craciun <diana.craciun@oss.nxp.com> wrote:
>
>> Allow userspace to mmap device regions for direct access of
>> fsl-mc devices.
>>
>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>> ---
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 60 ++++++++++++++++++++++-
>>   drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  2 +
>>   2 files changed, 60 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index c162fa27c02c..a92c6c97c29a 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -33,7 +33,11 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>>   
>>   		vdev->regions[i].addr = res->start;
>>   		vdev->regions[i].size = PAGE_ALIGN((resource_size(res)));
>> -		vdev->regions[i].flags = 0;
>> +		vdev->regions[i].flags = VFIO_REGION_INFO_FLAG_MMAP;
>> +		vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_READ;
>> +		if (!(mc_dev->regions[i].flags & IORESOURCE_READONLY))
>> +			vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_WRITE;
>
> I'm a little confused that we advertise read and write here, but it's
> only relative to the mmap

OK, I will fix that.

> and even later in the series where we add
> read and write callback support, it's only for the dprc and dpmcp
> devices.  Doesn't this leave dpaa2 accelerator devices with only mmap
> access?  vfio doesn't really have a way to specify that a device only
> has mmap access and the read/write interfaces can be quite useful when
> debugging or tracing.

I do not see any reason of not implementing read/write interface for all 
the dpaa2 accelerator devices. I will do that in the next version.

>
>> +		vdev->regions[i].type = mc_dev->regions[i].flags & IORESOURCE_BITS;
>>   	}
>>   
>>   	vdev->num_regions = mc_dev->obj_desc.region_count;
>> @@ -164,9 +168,61 @@ static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
>>   	return -EINVAL;
>>   }
>>   
>> +static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
>> +				 struct vm_area_struct *vma)
>> +{
>> +	u64 size = vma->vm_end - vma->vm_start;
>> +	u64 pgoff, base;
>> +
>> +	pgoff = vma->vm_pgoff &
>> +		((1U << (VFIO_FSL_MC_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>> +	base = pgoff << PAGE_SHIFT;
>> +
>> +	if (region.size < PAGE_SIZE || base + size > region.size)
> We've already aligned region.size up to PAGE_SIZE, so that test can't
> be true.  Whether it was a good idea to do that alignment, I'm not so

OK, I will come back with a resolution on this matter.

> sure.
>
>> +		return -EINVAL;
>> +
>> +	if (!(region.type & VFIO_DPRC_REGION_CACHEABLE))
>> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> +
>> +	vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
>> +
>> +	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>> +			       size, vma->vm_page_prot);
>> +}
>> +
>>   static int vfio_fsl_mc_mmap(void *device_data, struct vm_area_struct *vma)
>>   {
>> -	return -EINVAL;
>> +	struct vfio_fsl_mc_device *vdev = device_data;
>> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
>> +	int index;
>> +
>> +	index = vma->vm_pgoff >> (VFIO_FSL_MC_OFFSET_SHIFT - PAGE_SHIFT);
>> +
>> +	if (vma->vm_end < vma->vm_start)
>> +		return -EINVAL;
>> +	if (vma->vm_start & ~PAGE_MASK)
>> +		return -EINVAL;
>> +	if (vma->vm_end & ~PAGE_MASK)
>> +		return -EINVAL;
>> +	if (!(vma->vm_flags & VM_SHARED))
>> +		return -EINVAL;
>> +	if (index >= vdev->num_regions)
>> +		return -EINVAL;
>> +
>> +	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
>> +		return -EINVAL;
>> +
>> +	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ)
>> +			&& (vma->vm_flags & VM_READ))
>> +		return -EINVAL;
>> +
>> +	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)
>> +			&& (vma->vm_flags & VM_WRITE))
>> +		return -EINVAL;
>> +
>> +	vma->vm_private_data = mc_dev;
>> +
>> +	return vfio_fsl_mc_mmap_mmio(vdev->regions[index], vma);
>>   }
>>   
>>   static const struct vfio_device_ops vfio_fsl_mc_ops = {
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> index 818dfd3df4db..89d2e2a602d8 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> @@ -15,6 +15,8 @@
>>   #define VFIO_FSL_MC_INDEX_TO_OFFSET(index)	\
>>   	((u64)(index) << VFIO_FSL_MC_OFFSET_SHIFT)
>>   
>> +#define VFIO_DPRC_REGION_CACHEABLE	0x00000001
>
> There appears to be some sort of magic mapping of this to bus specific
> bits in the IORESOURCE_BITS range.  If the bus specific bits get
> shifted we'll be subtly broken here.  Can't we use the bus #define so
> that we can't get out of sync?  Thanks,

OK, I will use the bus define for these bits.

Thanks,
Diana

>
> Alex
>
>
>> +
>>   struct vfio_fsl_mc_region {
>>   	u32			flags;
>>   	u32			type;

