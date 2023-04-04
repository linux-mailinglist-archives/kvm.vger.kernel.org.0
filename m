Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4436D65CA
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 16:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjDDOws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 10:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbjDDOwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:52:44 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422D546A3;
        Tue,  4 Apr 2023 07:52:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJtxHqRZh9Cu6dXPg8dAs+I8QMBKt+32pnPacuZNqhrmppEHwtz+BlEqCtFgZllYnyzc5o7MYpkwJPA/scSuR9yluy5AsTz5ft3nW75jp/HJ7ZZp0PJWm9trgEYUwHUZg08kuO3VrRfzyaDItwfSD6MVQPGZZLSJHx/fqNV2lpmzG8BgIg4Fc9wDdGhBOsIWiFgYKtjcf+XuYKAManzV2H+hzEhnF7y2j/AXjL9FwvsfXbyt3moGtWxToMkAcmL/ClDA+q9/ktUqKUgjsQ5sMdJdKeikih/ymVK9k3gx1DLzt6e5umAeFC16bdN+STUWZ0aWIGDlRnVH8Te9oa9qPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OikdBzgA9yJI/rW34QzjiFc7BCw1yt1xXFus7ISgNPg=;
 b=c8B0JOz/c6dTYT3luFFTzDBAv0Dd3qUFX3bzUqnMJSmUU5zbQaXlV2VStpjc50NFiAPsvxHUoacYLRBnPEVfWaPC9357Vphiat7kRnw933tllkJ3u+4cekhA/swkLVJxLMzYbS06uZGbHRK6ZTVvPVBD/H1/LWUyeZ0Vo34DMApEnEJmdsyFYuS7WQIvlsIVbK2kPyYsqmEUYoD9baYHyvCDPUrPDxQFayNCjfIXQXIMJvc3oQcExy7wWiTo+stsTqbFEDNhUy98IBglboPrIaCtynZu0bCmkfsNo89+PWMD/EbqTe7q3e4sLhMTDKCIQoxvsE+iQ7bxabbNeHCgdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OikdBzgA9yJI/rW34QzjiFc7BCw1yt1xXFus7ISgNPg=;
 b=blZIl3ZAAU6IQRRW5S8SaMyjDVv0f3Oe29WZUc8IBoEssBzByJc0jj1TeI6U0YIWKPRRWL3NAyGCKs3Q/AgF1v4uCz1XgmXZSvLIyXdaRx7df3rwWq3DbujCOspS2mJtGR0UsCKrgrPGt9toDGRmWB5bfMhV6yY9Ru596j0c6Bo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by DM8PR12MB5462.namprd12.prod.outlook.com (2603:10b6:8:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Tue, 4 Apr
 2023 14:52:38 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::72ca:e9ef:88e5:26d0]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::72ca:e9ef:88e5:26d0%4]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 14:52:38 +0000
Message-ID: <b81a4f2d-735d-b514-6768-75a88c9a1945@amd.com>
Date:   Tue, 4 Apr 2023 20:21:21 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] vfio/cdx: add support for CDX bus
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, git@amd.com,
        harpreet.anand@amd.com, michal.simek@amd.com,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>, okaya@kernel.org,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
References: <20230403142525.29494-1-nipun.gupta@amd.com>
 <20230403152809.239a4988.alex.williamson@redhat.com>
Content-Language: en-US
From:   Nipun Gupta <nipun.gupta@amd.com>
In-Reply-To: <20230403152809.239a4988.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0147.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::32) To DM6PR12MB3082.namprd12.prod.outlook.com
 (2603:10b6:5:11b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3082:EE_|DM8PR12MB5462:EE_
X-MS-Office365-Filtering-Correlation-Id: c90708e3-2511-4d8a-5455-08db351c3bbb
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IY9eP5F+L+SLkuG7hhPAkmezyCp5wR9v0BzRydvecsOul9rtwW30QN+cPqyN60GDbHXWwcz13jTbLhp79FmsrO2/YWHoelLOE1lCPQtca7iAm8Vz4hDeUd/6pg44uRUyGt/BhwDH0XS+Qx2fPR6FkFru+FJoce8+kyPSgbhXWTqOV0bwGXEsHMq6YSxk0fF92yHD6Byo8BsfmWS35pJxzG4wLL9xS7w7VpUkGNrdBCeUBuaDNQyQOmVEjEF6/KNBvd4efIiTQNceb+e65/XhcaKL5ruf/DS8YK+LT9Wp4cujRoX8VrLagGyQbG75dEqxZaQt1LQF0iNGnsjKrF/9Z0iTF0OyH7Jq3J4q/76S63Zrf9xWcsN0pIg9SOZZ97Y6XMUUSpxuHVNlo6kCF30F5TvNNYmuhRxRV5dQvabITMrxqsljIZxScJQEYIwSOrBWNg8ci8fdiHUpZU+yAW64D3wIOmu07njMDJ79WaLctRiAB0GGMDJB1k4XWuZ3qxQVZlZidXgrcvu59tTftzoMoKb5fKBvDNCcvCB8TRAFXiNAS5Y6/KjAyilLaRy8GoZ/jg49FuOxbf3xMzRD8H9SxAMbf1snsYua0+YwZusjZDcVGKS/6kPMfQwVT0wv88XjJYtgSN0RQja4SxtgsyQEsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(451199021)(26005)(478600001)(2906002)(186003)(2616005)(6512007)(6506007)(53546011)(36756003)(6666004)(83380400001)(6486002)(6916009)(38100700002)(86362001)(316002)(31696002)(5660300002)(41300700001)(4326008)(8936002)(31686004)(66476007)(66556008)(54906003)(66946007)(8676002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHVsWnVGUHNzOFE0TWV6M1loYlgxbkNZL29JOThTVFRlWFJ0NUQrY0dWMWVk?=
 =?utf-8?B?aDRaMnZhM21ZbDdVWi90dFJmRXlJc3lBcUZiRGp1R0JLbXhZTGJYbjN0VXNr?=
 =?utf-8?B?UCs1dGtaZS9FY2w3Y2ZKQko0TElxbS9ENGFRY00yODVPSnNwalpqN1lBdEZp?=
 =?utf-8?B?WUJCc2kvdzNicnBEQkwrRTR2L0RqbExRejRNUWJrYjBZQW1YeGoyR3UxQUdX?=
 =?utf-8?B?NGljNTZ1OVlOV2FQSFk1OVRRaGpiUlFkSTdpK2cxTW1JL0I5MEY0QWhkVFpM?=
 =?utf-8?B?c3JTbGVycmFYM2NlTzJ6NElvZHo2NHJCYXBrcVRZM1hld0wvRy9CUVlQakVz?=
 =?utf-8?B?S3RvU2ljUUduSExSLzB0ay9qNEk5aE9lbjdmZitWcnFZY0dQNlhXdzJJMFB4?=
 =?utf-8?B?N1JMYkpWQ1lEU25MQVlmb3U5WU9HS3g4emZlWjZMK2NZVzZsWUlQU2x0aEkw?=
 =?utf-8?B?ZzFMQnRHdmxxSm1qUXAwSHdFS0NKR1pPcUlYTlBXUDIycGdnWHMvbzk5Y1pM?=
 =?utf-8?B?anliSzNucW53RHVoYzZsNmwzYnhNZFFHNi9iNXpic0g3bnMyV2ZQT29vajhK?=
 =?utf-8?B?UERQRzNPaG1LeVBTaERqQXdxWWNncWtHMUJNQTZSL0hmSUx0Wi95VkVvVDd5?=
 =?utf-8?B?S0h6OGY2RDVNbDFFWXYvWGJhZUUvNDVVN2gvU2xkWDFxUm5kTFNDUVN3NGl4?=
 =?utf-8?B?aEkxeDNOUWV1UmNtUHJuL1Vmandza1MxbDNZL0EwcmJ0QlNKWGwwekZyb1dH?=
 =?utf-8?B?VXpyZzRtN2JSNWdyaEtFUVdJVWZVb2RYRlM4RTBiNlpoWlhlOXlxTC9lRzZO?=
 =?utf-8?B?eUdNSlpseHE1a3B3dUxuY1hBaHkwTlc3TEhuSlFIYkpTc0hMWXByRG9peGEy?=
 =?utf-8?B?di9Mc1VXamVNdXlvcEQyQUNlZ3ViQ2FRcjlKS014UldoanViZzNOOHBob1B0?=
 =?utf-8?B?aytxUjRuMm13c1BaU2pPaVp6NTFONkRXZlo1Mmh1eGdIcGh5eVh6L3FhTFVo?=
 =?utf-8?B?dzJzM2FNSVBaaEJhd0RkTnhnd21wY1RZaUo4OUErVW53YSt2WW93R1M1WmNP?=
 =?utf-8?B?cFM1dGZuZDNxUEZYRVNDQjJMdnFtZ1ZlNW5ZcnYrZ2ErWmcxUSt2Qk9jYWo1?=
 =?utf-8?B?YWRJazBpSnJlR25RNEVtRDNqNkJuQmlEV2dlUTZYRkV6SmdyU0FhSmFZYW1x?=
 =?utf-8?B?bDdjaXRwdUpNWGtEcGZUUThSTHN1SUk3Z1IrcUdiRVQrMW5CM1YwanRWZTQw?=
 =?utf-8?B?TC8ydUVwL2VRMkgwNDBzVzFRNXF2RTNZb0hYb3lDTTVGU3RmY0ZnNHcyT1lz?=
 =?utf-8?B?Y1ZiRjNnWHdkcjN1M1JRRVRiSG81bWFjbUhIKy9FL2NhUDlZMkttNDNuQmRT?=
 =?utf-8?B?VzlRRHdpYUkyMFBzVFIvMGFrbDNad292WGJuTVpYcHhoaDJ6WFplalU1dHFU?=
 =?utf-8?B?YnpBMmN5aWI1VXg2Z2laSEVUdzI5M0lNM2YveVRqMkEySW9BSlIrbUg2OEJ5?=
 =?utf-8?B?OTFlTktnakVkUGQ1L0Q4QzRESkdUdVJUNkl6N2pzbzVETWJIbktWVU5GakhH?=
 =?utf-8?B?NDFpSWQvb2IxdTNJbDk1S0YwSzVZYmhZVDlhOG5KK1l3Y2h2cnhaKzJLU2RN?=
 =?utf-8?B?SXFQOUM3T2sraWZCZUoxUFVGSVBPN0g5M1hOd3hyci90ajVueEFYQ1RkVmFq?=
 =?utf-8?B?T1lPWTZYQWNTa0Z6aXVTMlpMeEdQRDRMK2ViNXR4N2dkWFhPblAwZnNrL1Vs?=
 =?utf-8?B?SFpGNDZSZ0hjazNmdkdQYnpnRTFmT2hONWlvRXZ2bU9PcFFqUzdpa00rdXBp?=
 =?utf-8?B?ZDlpbHBGZHE2cm5KL0drWXVFLzRkZmhmTEZ2aUU1alN0Z2hIallyeEcrV1hm?=
 =?utf-8?B?Z0xoNU1wOFMzQ0RoYzZldWlibGlKVXIyNVltamdXUTJoTThnVWRreXRKNW45?=
 =?utf-8?B?Y2RtUkhtQUxvWkFjQ0pUcWlGSDVpOGZ6cUJKNzJ5V0VuSmZodDNiZ3pLYkNQ?=
 =?utf-8?B?VGFONmNDY3JpOFRWU0xqaExERXh3UnhNYm9EZFVXNTFtN1pNNjE5YjJkcHZV?=
 =?utf-8?B?RWVJaUVvSWZQV2Z2cWUyUG85SUh2eVEzMmZBZFp5a0JONWlTejFhUW9kU0lD?=
 =?utf-8?Q?szoKFzfg6LEBdfcVylJcQ5WRl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c90708e3-2511-4d8a-5455-08db351c3bbb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 14:52:38.2428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNwpC27/PleuUCQXPx1YvPic6n5uUOqIwXSiwCKxwSY4aRp+6LeSXC/Q6yfyE4GM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5462
X-Spam-Status: No, score=-1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/2023 2:58 AM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Mon, 3 Apr 2023 19:55:25 +0530
> Nipun Gupta <nipun.gupta@amd.com> wrote:
>> diff --git a/drivers/vfio/cdx/Makefile b/drivers/vfio/cdx/Makefile
>> new file mode 100644
>> index 000000000000..82e4ef412c0f
>> --- /dev/null
>> +++ b/drivers/vfio/cdx/Makefile
> ...
>> +static int vfio_cdx_mmap_mmio(struct vfio_cdx_region region,
>> +                           struct vm_area_struct *vma)
>> +{
>> +     u64 size = vma->vm_end - vma->vm_start;
>> +     u64 pgoff, base;
>> +
>> +     pgoff = vma->vm_pgoff &
>> +             ((1U << (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>> +     base = pgoff << PAGE_SHIFT;
>> +
>> +     if (region.size < PAGE_SIZE || base + size > region.size)
>> +             return -EINVAL;
>> +
>> +     vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
>> +     vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> +
>> +     return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>> +                            size, vma->vm_page_prot);
>> +}
>> +
>> +static int vfio_cdx_mmap(struct vfio_device *core_vdev,
>> +                      struct vm_area_struct *vma)
>> +{
>> +     struct vfio_cdx_device *vdev =
>> +             container_of(core_vdev, struct vfio_cdx_device, vdev);
>> +     struct cdx_device *cdx_dev = vdev->cdx_dev;
>> +     unsigned int index;
>> +
>> +     index = vma->vm_pgoff >> (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT);
>> +
>> +     if (vma->vm_end < vma->vm_start)
>> +             return -EINVAL;
>> +     if (vma->vm_start & ~PAGE_MASK)
>> +             return -EINVAL;
>> +     if (vma->vm_end & ~PAGE_MASK)
>> +             return -EINVAL;
>> +     if (!(vma->vm_flags & VM_SHARED))
>> +             return -EINVAL;
>> +     if (index >= cdx_dev->res_count)
>> +             return -EINVAL;
>> +
>> +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
>> +             return -EINVAL;
>> +
>> +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ) &&
>> +         (vma->vm_flags & VM_READ))
>> +             return -EINVAL;
>> +
>> +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE) &&
>> +         (vma->vm_flags & VM_WRITE))
>> +             return -EINVAL;
>> +
>> +     vma->vm_private_data = cdx_dev;
>> +
>> +     return vfio_cdx_mmap_mmio(vdev->regions[index], vma);
>> +}
> 
> I see discussion of MMIO_REGIONS_ENABLE controlling host access to the
> device in mc_cdx_pcol.h.  Is a user of vfio-cdx able to manipulate
> whether MMIO space of the device is enabled?  If so, what's the system
> response to accessing MMIO through the mmap while disabled?

The MMIO enable/disable has been added in mc_cdx_pcol.h from the future 
support perspective, but it is not currently supported, as all the CDX 
devices have the MMIO enable flag permanently set which cannot be 
disabled. Due to this we have not added any interface/API in the CDX bus 
to disable MMIO for the device. This is still under discussion and 
future patches will add complete support for this.

That said, if required we can add a flag currently in the "cdx_device" 
which will be set when for MMIO enabled (it would be by default enabled 
for now), and depending on this flag VFIO can return error during mmap, 
but we would prefer to defer it to be added along with the complete 
support for MMIO enable/disable in the CDX bus.

> Is MMIO
> space accessible even through calling the RESET ioctl?

Yes, MMIO region would be accessible even through calling reset, but 
user may not see the correct values as the device is being reset.


> Is there a
> public specification somewhere for CDX?  Thanks,

I am afraid there is no public specification for CDX as of now.

Thanks,
Nipun

> 
> Alex
> 
