Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480B3610720
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 03:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbiJ1BOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 21:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbiJ1BOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 21:14:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654D23055D;
        Thu, 27 Oct 2022 18:14:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjMMEUivKnVTARASLBIh3aJDvbLSc805NEyei5qLd50vzdN/94sWY0AzXwjF1YfiX0w+kWg7vNu+fZ2csbBIcG6VSFaBZiOo+OrzFpxS9xDbFfo3g3FUW7gskc7IUQWoI4jbT07Vv/jsRgk8g5TNMyuUim0IdDAUWAV5U9Xy+7OoRzRp21oHOUwidApDHz471HZZ5gWzu/xsudeX6TqA7PxuqWj0yAIQ9REFoCeBQUOMwt0+fbuWB0M6oReZ2YZXBqdctGrs/6XMIzOA1t2Hux9uCZkZyB/sy41DMxVyucDY/sQ7Eqqgc2/j/91ROodJAk+1dK/gSsYDRGdyM+s0Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=icABoU7XIQOHobpB8jDu+bivCMoHhoknOX54e6d91Sk=;
 b=g3C30XPTUZfAH6Of/P/slPKa3ehJ46Q2EJyLU4iSaS1QkLADDHGnRvX94bedcCPbbmVnEh6aZcEDeebJ0CyvNzmnjb+z7gHYGRKg2EigeqhplRhNFKPlhxrIhcCcEbxmGZ2jh7zxroaGCr/uqq0lpu3q76ld2w2ZNHxvodSBXGZTA13R9VjHLJkdCyMwhewtT22WecXF4x6znGIBdGrTYLrx+vs2fpbryw/GJKJ7z3ZPDUXk99QHEWg78Zgro6SMhYkyZYmjWvdFFwHRriOi81vMCqznJTTqOOP0XwD6KqZG65CIjJjxiePXE5EBLHmfZ2qkBASwMdIRKq41L1orAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=icABoU7XIQOHobpB8jDu+bivCMoHhoknOX54e6d91Sk=;
 b=meOXy/cKYBLw7jRxR/j3SjKJzQ7vQslFU2txCFew+efkNNXRSSdOuf3xP3FQNfmn9qhNYttp0uiVWM/hvYUtKuM1fpaB/Xhp5wkr99aWnKWqvn0B6rtnd62Z9KBIuB1mn90TD4v2bvQjETradzHYt0f1UnLRXu2nBKHqlTW68+M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 DM6PR12MB4909.namprd12.prod.outlook.com (2603:10b6:5:1ba::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.15; Fri, 28 Oct 2022 01:14:37 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::4fa1:e98d:1cb5:e63e]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::4fa1:e98d:1cb5:e63e%3]) with mapi id 15.20.5746.028; Fri, 28 Oct 2022
 01:14:36 +0000
Message-ID: <05f04218-7ebd-1ce3-9e0c-8bc65e5e937a@amd.com>
Date:   Fri, 28 Oct 2022 12:14:27 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH kernel] x86/swiotlb/amd: Half the size if allocation
 failed
Content-Language: en-US
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, Ashish Kalra <ashish.kalra@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Christoph Hellwig <hch@lst.de>
References: <20221027052607.260234-1-aik@amd.com>
 <Y1q16MQvzP8LobHx@quatroqueijos.cascardo.eti.br>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y1q16MQvzP8LobHx@quatroqueijos.cascardo.eti.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0069.ausprd01.prod.outlook.com
 (2603:10c6:10:1f4::20) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|DM6PR12MB4909:EE_
X-MS-Office365-Filtering-Correlation-Id: 2151ce55-d34d-48fc-0d5a-08dab881c728
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7zY8etEzAo/FkMWpwHwLFmSJXLnfo+i8+40DXAaUWz35r17NswTuQONOkLsV9OjHn6BJy0JCBQ+vFn4d6a0/OsiS0SNC+/l7sCLq2gL3rBB3neLWPE/ZW4HHcHKEAi4Cm7faoFHR3HTowWRse/PF0+bVIKNbHpf/oiUG3U8LfKB9pd35GS3lIa0I9SQKnlyXRQ4ZzJRP71JXP8j58OAcUrbhDGXAFwI+Xl7VzCWg/IOngEkV0y4spLZBpCP9YZN4qab9wK7vHaEw45l8nvXyVBYjilrd1Vr2FChIM9nm53EfIwoB+KXe6jI1r8esRYNE5B9mbTUNg0AoQS/0WfjcjCYwr7aOxAb2rzR2zU7Dj8FoVUYEFetMr/yfymPAa92c2tP+vspnuoN7rZSwNQL2PxU2vHHun5KrfRgqJiULjP71nXbk6ZUsvaqEDCTpLnI6AnlGO1qoSFAKy2wLBMOSBG18rd1O57Yc8758FbYiyMucbaZhx5cSbd7+cmdIe31sYUC+dgCqK/AEXBzYX2s/PDPuq9595j0cZmTSzNafn1sNmMl5FTtLRww/wpc7rzqSuM9Ap78skUQdZR0ve7iUSV7M5vdIo3xFzwtB07aeiEg3cb4djUrOClJ2ZJbul0GSH90dAaFdn9zeg8ZTmxf56toMRvYRBDUfDFG/O+6jWvWyUiYxQ9Rhjy3ql/mg6sfOWMTL5Qk63D57GF2eNAN3B7/gT6vVaxK2VMMelCjmisjP15mkRYArftO83s9Aol7CftTAjc0ySkv6NBfIl9nfiyMq5bg8/iEXJEa9g2zUGoo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199015)(6666004)(316002)(6916009)(186003)(54906003)(8936002)(66946007)(2616005)(5660300002)(2906002)(66556008)(6506007)(53546011)(36756003)(8676002)(4326008)(6512007)(26005)(83380400001)(66476007)(31696002)(41300700001)(478600001)(38100700002)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alpENXpCTlJWc2R0WXFHODd0dHgxRGkyYzJZZ0pQTXhSUWU2SnJVdzVlQ1E0?=
 =?utf-8?B?U3V4YlZkZHpqdy9EMWtiTjJuKzBtRzdWRUFCNExlUDF5K3cxMVdscFhVVGlD?=
 =?utf-8?B?VTBjbXdFNEM5QmR6QVc3MnZ1ZU9hUG9DRTlSdXJveDJZYXFJOWw0NjNJWkVl?=
 =?utf-8?B?WVQvOTFoUXB3WHNHZFBxaDhDSTdieGNvZ21GdldCREZROWMvbmpQbUJGbENP?=
 =?utf-8?B?SDl2M1I3MVFZN3gxRjZXdDBmSUg2TWdFZTl3WXVyaURhdG1mSi9WVTRSS1hr?=
 =?utf-8?B?eVlMVHlDalJLdFM3YXUrR29qTkk3SXF1OTY1Q3hoWTVkVDhNWUdjR1N5WU5M?=
 =?utf-8?B?L1hmWkp1cCtRZjM0VjBsaFV4KzE2T1pEVVNEViswZEpZQVo5ZUJCVmNXTU5B?=
 =?utf-8?B?VDZPcDJWVmgzMmJOaFdNTVpuaHNwQnNZaVpCZ0VHcTlmQUkwRHp5VG0rdXlG?=
 =?utf-8?B?WnhuZEJ4c3UrYkNOYXBZaDVWOStHOXBlaGJFZmU0STlPRzQyTGFaQWp2aFVL?=
 =?utf-8?B?YWFJV0x3WGNSZ1hsSThvM0pYTVpQajNmNTNOU0JqdjROdlI5dUFuamxvTlhZ?=
 =?utf-8?B?TlduWkZXZmlGQWlhQlVLbG5wYXA5SlZ0RmxjVjBzdis3WXhWaERuY1lUcTlt?=
 =?utf-8?B?b3l6bG44cStINkthY2dQREFYd0xpTkNkZm8zbG8wNnROTjVlNnc2dS9zN3NQ?=
 =?utf-8?B?U3BvYUNhQ3o0L2dnRnRIbzVvNk14eGlBd09lUEE4UHJXOHYrajZXbVF5UzZm?=
 =?utf-8?B?dUk3WXhVVmRCbXdhZVh1WnM5bDdMOTZRSStJNURFT2Q4eWQxd3BEWXNPODYw?=
 =?utf-8?B?czVBRU1LVzA4ZnFNRmEyeVVURXNQNGRyWDFXWVBybXh0MWVrOGpUUno2K1pq?=
 =?utf-8?B?UDhDVXl5VTFJOTRPNkpoR2haN1RveTh2L2h1c1B1dmFZeGNSekZTMG5Hdmxt?=
 =?utf-8?B?dU1qTStRVjBGa3FmbXo5ZmJ5cEFESms5aUNaZWUxTEc0b2xHcWo0Yk8xNVZV?=
 =?utf-8?B?OW44RWlIMkhVMVdoVi9SMWt3ejZZMWtKbzFTSEZDSFBlaXl2bUt4eStoVVBF?=
 =?utf-8?B?RjV5WUVlTEtmMndqUEJtTHBYMEZDNWQ3cFJzL0prRG5wbGp1RUZsUWtOSVNi?=
 =?utf-8?B?WnM1TVE4UVJNa3ZLblczRDBNbnQvZnpSa0E2anp2aUdnNzVtampOMjdidk52?=
 =?utf-8?B?Qk9lRWRFWDVQbVJOODhwTVo5aGJ3U1FUMCtmVkd6TGZNa0M0cnlvQ2VONnN4?=
 =?utf-8?B?dS8zUFJWZ0VTcXEzaXpVYzA0OXdrVlpUL0RTYk82U1lBR2lWNkc1a3VUcXpp?=
 =?utf-8?B?b1ljQ3RFejlXTElFbStVMDF0V202RmdtcWFhL2lvbG5oUVNaemFad2ZwaU5E?=
 =?utf-8?B?cXhjUzJ2RTVFb2VURlVwMGxMRGhWU0pFbDhxMUZjUFhFd2ovbnNyOXkvdVdu?=
 =?utf-8?B?ZURCSGE0RUxERTV3OGVQSlhhYWhaZmNaRkJHdGJXaXhEeERNSU1OeDBBekIy?=
 =?utf-8?B?TWprL0hScjNETEY1VFlCZDJGUFR3MnZac24zNmZFWThoQnR3M05IUUFIRWd1?=
 =?utf-8?B?MGFYRFZieFNvSThscFYyMG91WlUvZXhnQ0ttbnVTOFlQcEZ5ME10Y2pGRHk4?=
 =?utf-8?B?ZU5NR2d3Y20yamVpMUlxSlBkQ2RVRmppenowekJWNDhiMXV5S2hEWjFXcFFn?=
 =?utf-8?B?YnB1QjhKZWVaZ01wWUZZMDBqaUc4MWZhc2gwZGx0eCtaSWhxbllHeHVvdWRK?=
 =?utf-8?B?aFM1ZDRDSkREL21xN0xRc2YrbXBrWUhyaDhGWGlBTmQxOEhUZG92SDFoM0NY?=
 =?utf-8?B?QktJeUFRNFo0aE9iZ0dLUzBEZ0RnQm40eUxSZzJlSzlXb2NNWmVIbGJXUzhk?=
 =?utf-8?B?aTdhZlRySWtXK3ZKdXk5Y2hKdk1hdk9IQXUvMVNwSndJd2ZGMUdJUTFxSyt3?=
 =?utf-8?B?QzA5NHpYWFdOSzZjM01MY1J5UDBVZDFycUNEc2YvZHhhSWE1QTBLWWNOWHlq?=
 =?utf-8?B?VHZjK3ArQU8rVnBTVUNuVzZlSDNCNXlTcFZEWkh1WjYxb0hva1FCV3dadVZZ?=
 =?utf-8?B?aWxjdjJPVUQrYSt6a0ZmTWMrUEM4dFRqTmJIUUFVZnFxeFM5NjlKM09mYjNQ?=
 =?utf-8?Q?xXdkGDlJ8w8km/FHt4tY6C5ri?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2151ce55-d34d-48fc-0d5a-08dab881c728
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 01:14:36.1054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1nx0uDy+8712SDVALrz78RxSDRJnhO6vjHqoJWazQwUljNLqddHvDH2KmzWhL+dCjICaIcWWPtIl/iMYsU2Ifg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4909
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28/10/22 03:46, Thadeu Lima de Souza Cascardo wrote:
> On Thu, Oct 27, 2022 at 04:26:07PM +1100, Alexey Kardashevskiy wrote:
>> At the moment the AMD encrypted platform reserves 6% of RAM for SWIOTLB
>> or 1GB, whichever is less. However it is possible that there is no block
>> big enough in the low memory which make SWIOTLB allocation fail and
>> the kernel continues without DMA. In such case a VM hangs on DMA.
>>
>> This divides the size in half and tries again reusing the existing
>> remapping logic.
>>
>> This updates default_nslabs on successful allocation which looks like
>> an oversight as not doing so should have broken callers of
>> swiotlb_size_or_default().
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> 
> Should this have a
> Fixes: e998879d4fb7 ("x86,swiotlb: Adjust SWIOTLB bounce buffer size for SEV guests")
> ?


Well, the problem was there before that patch, the allocation failure 
was not handled while remap failure was. e998879d4fb7 just made it 
easier to see. But still worth mentioning I guess... Thanks,


> 
> Cascardo.
> 
>> --
>>
>> I hit the problem with
>> QEMU's "-m 16819M" where SWIOTLB was adjusted to
>> 0x7e200 == 1,058,013,184 (slightly less than 1GB) while
>> 0x7e180 still worked.
>>
>> With guest errors enabled, there are many unassigned accesses from
>> virtio.
>>
>> ---
>>   kernel/dma/swiotlb.c | 20 +++++++++++++-------
>>   1 file changed, 13 insertions(+), 7 deletions(-)
>>
>> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
>> index 339a990554e7..d28c294320fd 100644
>> --- a/kernel/dma/swiotlb.c
>> +++ b/kernel/dma/swiotlb.c
>> @@ -338,21 +338,27 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
>>   	else
>>   		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
>>   	if (!tlb) {
>> -		pr_warn("%s: failed to allocate tlb structure\n", __func__);
>> -		return;
>> -	}
>> -
>> -	if (remap && remap(tlb, nslabs) < 0) {
>> +		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n",
>> +			__func__, bytes);
>> +	} else if (remap && remap(tlb, nslabs) < 0) {
>>   		memblock_free(tlb, PAGE_ALIGN(bytes));
>> +		tlb = NULL;
>> +		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
>> +	}
>>   
>> +	if (!tlb) {
>>   		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
>>   		if (nslabs >= IO_TLB_MIN_SLABS)
>>   			goto retry;
>> -
>> -		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
>>   		return;
>>   	}
>>   
>> +	if (default_nslabs != nslabs) {
>> +		pr_info("SWIOTLB bounce buffer size adjusted %lu -> %lu slabs",
>> +			default_nslabs, nslabs);
>> +		default_nslabs = nslabs;
>> +	}
>> +
>>   	alloc_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), nslabs));
>>   	mem->slots = memblock_alloc(alloc_size, PAGE_SIZE);
>>   	if (!mem->slots) {
>> -- 
>> 2.37.3
>>

-- 
Alexey
