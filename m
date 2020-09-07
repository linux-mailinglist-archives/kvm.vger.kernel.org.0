Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E96125FAED
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 15:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgIGMua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 08:50:30 -0400
Received: from mail-eopbgr60073.outbound.protection.outlook.com ([40.107.6.73]:3357
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729324AbgIGMtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 08:49:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQU2g1Psn/WiCMKzd0/lb0nt7u0wK9cURi1XmYnfcX5C6Mcp+5oImrdQ2jbHA6CK2l7v5ICyL6aEl/9xWAvsAqPOQ0cz6Ls6heokhgyeDUybCEmS54uPFoIDd1jdxFaqQBBg7cB86KpaonuVg1807TABIbFavXgNkuJME4TsqQcQ0XDDayBv/jd13Vuk31QUMTD8q6eRYUxYvEudSMGPpZKWEEouCPP/gfEuWp2EzxmkYmbvJEObzo9tJKRGqd5I/zVtBWdtaZLgcZ84/3jteAziN1MS35EkPlO/aoqhSHEylmP1EnLoNcOlu2QqN4cvuekTfsdMb8pVgQQKoMtgiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbQbiQw8FhNEy2IUhZtw1wIszGEqywlPhmUgbeIsNxI=;
 b=GRdIX3V6VXczaWt72GMGwJKAOpWS/fwnw4vrgDAy8WPhXQbVojTcHV1i/v0kSujDvL+z9fRsoI9havq4W3O5p3bpqgCIfh6wxj7ahcNWk8KHHTAuLUS6DrUjNpC3YmhW5gUaMFRW+ADXnux948pTkfS4+tHA8M4cUMlevIomGCPPpP85wE1C15MVrwd8fR+8cbouESu4dUgR3TspLVSeyE5QAsa1l0CY7JuJ13OBD1s1S8VAYfWFsMDiYyWZjAndpUjxQXzMEXuwn0fYml6yVmxcxuQMw+KyWckXp6wQZTWynZFD7T0Uj7BA+wYgdw1H7dBWeYMR3iyOamPVf4qr1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbQbiQw8FhNEy2IUhZtw1wIszGEqywlPhmUgbeIsNxI=;
 b=l3s9w2AJ1pI6sPQnhCQxIrguvHtlHlxv3/xXOtKHl1nLBxMID2Kw4xZlga561UqnvCn+GFh6Jqle2pVXutwyFknS//RStqPy0K4qn+wUOp4UGbyHGDkSQDhcpO8YhWjdcXVDIgcyfJhOXA6PG1TbmjtSktp10Bn8ozK8y86/4lY=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR04MB4237.eurprd04.prod.outlook.com
 (2603:10a6:803:3e::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 12:49:19 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607%9]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 12:49:19 +0000
Subject: Re: [PATCH v4 05/10] vfio/fsl-mc: Allow userspace to MMAP fsl-mc
 device MMIO regions
To:     Auger Eric <eric.auger@redhat.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-6-diana.craciun@oss.nxp.com>
 <ee1e9d74-5be6-6c92-5362-bff06539f21f@redhat.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <b581562d-176b-46b4-b682-a11f530e6b55@oss.nxp.com>
Date:   Mon, 7 Sep 2020 15:49:14 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <ee1e9d74-5be6-6c92-5362-bff06539f21f@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR07CA0026.eurprd07.prod.outlook.com
 (2603:10a6:205:1::39) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM4PR07CA0026.eurprd07.prod.outlook.com (2603:10a6:205:1::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.9 via Frontend Transport; Mon, 7 Sep 2020 12:49:17 +0000
X-Originating-IP: [188.27.189.94]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 62277fd6-85e2-47da-a321-08d8532c6f5f
X-MS-TrafficTypeDiagnostic: VI1PR04MB4237:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4237F50750400E328E7731D4BE280@VI1PR04MB4237.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cwH/d5wdu5yMp7+nuus75cWLJ63pjvnVPwiFOxfDJ/DmKzPNfevrkQRVjh5P5vGNl3O1/rw+9PMPcWG/0yx3SG+rBLLE1hPkKKpo+Lvw7L7q/BFNsHBH3LgrgX7YCUtUrAUeeOTV8GyWh0GgAweEC45epxOaGOrb2cWDNMhgD45P4fGw7GsfSoJvKCJk88v2qiWpJs6yMJ2XoOCIk/sozVwqzAsrYuu73faD9J/LsQfsnDwMsOcuoMOLPhjIQ6THLy7asiS/OQnF9B26PK9//dakv4dNrbTWT8G0mtqd53vpbHbTdIYxX7id4+VFqaSGQttM65xv4cfWeZ9tfZakAmWueH7l/F6bKa9TWqnf7KssdwwsSm6MC9/mHPkvfTFx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(6486002)(66556008)(52116002)(66476007)(8936002)(66946007)(8676002)(16576012)(5660300002)(16526019)(31696002)(4326008)(2906002)(83380400001)(956004)(26005)(31686004)(6666004)(86362001)(478600001)(186003)(2616005)(53546011)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I8dZzeqsWc3SN7eUZn3n8u4kmu4BgyLQPfEd8KExmdPxTbcFb+Mk8AH1thySWxV+KRKCQhXaicYbgJgXVG7FYM5Wh3FXcdInrELNWY5DdYq1EExIfPxgFbMl44Iz9D0haZhI+7zLe7eJnqErWSMDupQ+eXxlThtZaiB+dz2p+nArEfK2Db2zGd2IIVr/W0oD/rpY2XMgWPi7eRix+LBA8qerIhbNdpp/WkhuGQm3X/3pjhWUj4mdoiutCJj85AJ+90yQDuQ2HqqlIGrJ2vnwPwU1YUEjtACi4lfIHzjJSP4xjr2d4oV1n0ZALHSmrdV2Zys8gA00GNz+dKemxtib6ye9OKslnj9AVbp1Tt44fj+K4b5Uir61fUGHArOUZGjJKxw4GxqW4A4TInnJ2g841In3XIz9YVgGwJvxJ/Nb+GaIbzjqq7n6z7SXQK5pnnD2Idjd4j0sKYoHBYhRaQD9kszU4nDR0B1V8DtKcpYawFX5IHqkDV5VJIgZM+DzaEymzIBKY75PlJg3MRZv3BARl2Gdou/S+vzXK5qGFAckQZYFc0fNIO3Q2UZ+xNTg33hcv9hJ1jmtmYyKC7iG/7WIdQ9xb4lxo/OiRH8Z1Y0lC9/E6j11IjQsQiQ1kd2NjjJYzuLg5pUZmu4FfasHQxhy8Q==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62277fd6-85e2-47da-a321-08d8532c6f5f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 12:49:18.9138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M5N2kuQS0ZxZKMor7tmqqhKUAulcmwyTjAC5VJU142k1rzh8J8W9xWvIpbxsSz9Mdqb9jrTdXt/HWtXctJSKLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4237
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 9/3/2020 7:05 PM, Auger Eric wrote:
> Hi Diana,
> 
> On 8/26/20 11:33 AM, Diana Craciun wrote:
>> Allow userspace to mmap device regions for direct access of
>> fsl-mc devices.
>>
>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>> ---
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 60 +++++++++++++++++++++++++++++--
>>   1 file changed, 58 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index 093b8d68496c..64d5c1fff51f 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -33,7 +33,8 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>>   
>>   		vdev->regions[i].addr = res->start;
>>   		vdev->regions[i].size = resource_size(res);
>> -		vdev->regions[i].flags = 0;
>> +		vdev->regions[i].flags = VFIO_REGION_INFO_FLAG_MMAP;
> Is the region always mmappable or does it depend on the
> mc_dev->regions[i].flags. Also on VFIO platform we checked some
> alignment addr/size constraints.

The region is mmappable regardless of the region flags. However, I see 
that there are some questions regarding the fact that the regions are 
always mmappable in the following patches, so I'll try to clarify here.

The way the userspace communicates with the hardware is through some 
commands (special data written in the device region). The commands can 
be issued using special channels (devices): dprc and dpmcp. Most of the 
commands can be passthrough, the command that configures the interrupts 
is the most important example. In order to reduce the complexity, the 
command which configures the interrupts was restricted from the firmware 
to be issued only on a single type of device (dprc). However, in the 
current implementation the memory region corresponding to the dpcr can 
be passthorugh as well. The reason is that it can be used (for example) 
by a DPDK application in the userspace. The DPDK application configures 
the interrupts using the VFIO_DEVICE_SET_IRQS system call. When it comes 
to virtual machines the dprc and the dpmc will be emulated in QEMU.

Regarding the alignemnet/size constraints I agree, I will add some checks.

>> +		vdev->regions[i].type = mc_dev->regions[i].flags & IORESOURCE_BITS;
>>   	}
>>   
>>   	vdev->num_regions = mc_dev->obj_desc.region_count;
>> @@ -164,9 +165,64 @@ static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
>>   	return -EINVAL;
>>   }
>>   
>> +static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
>> +				 struct vm_area_struct *vma)
>> +{
>> +	u64 size = vma->vm_end - vma->vm_start;
>> +	u64 pgoff, base;
>> +	u8 region_cacheable;
>> +
>> +	pgoff = vma->vm_pgoff &
>> +		((1U << (VFIO_FSL_MC_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>> +	base = pgoff << PAGE_SHIFT;
>> +
>> +	if (region.size < PAGE_SIZE || base + size > region.size)
>> +		return -EINVAL;
>> +
>> +	region_cacheable = (region.type & FSL_MC_REGION_CACHEABLE) &&
>> +			   (region.type & FSL_MC_REGION_SHAREABLE);
> I see in fsl-mc-bus.c that IORESOURCE_CACHEABLE and IORESOURCE_MEM are
> set on the regions flag?

Yes, initially the two flags were set (IORESOURCE_CACHEABLE and 
IORESOURCE_MEM). However, I have changed the behaviour a little bit (it 
was wrong in the past) and IORESOURCE_MEM is still present, but also 
FSL_MC_REGION_CACHEABLE and FSL_MC_REGION_SHAREABLE which are retrieved 
from the firmware through commands.

>> +	if (!region_cacheable)
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
>>
> Thanks
> 
> Eric
> 

Thanks,
Diana

