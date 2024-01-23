Return-Path: <kvm+bounces-6737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 770D38396FA
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 18:53:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26CF92853B8
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 17:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99EF781ACC;
	Tue, 23 Jan 2024 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="snMkUsAw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88418005F;
	Tue, 23 Jan 2024 17:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706032381; cv=fail; b=Y3kWGVTGhyxeVzXOUhbO2GFz8yo2oWEVhSz7Jn7W/A9XIt5MES9eH5QH7YPMuXQTRozwgO/AKaov6hiGNc24vtqVC84DtAxJj5ENhTbr5X5Z0Ki06H8pta0OqaQntg7+vv9vTb270+7Jj4XbZsbXc+Ru97cgN1CwzttJg9QSb5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706032381; c=relaxed/simple;
	bh=2/xxE+533etNvc0Q8yJupFOXKz8rLv1dFC2cSzETWFM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jSnWOvioOy46AR8lcP+BlfSqS84L1u4NEEcmq81G3RHrt0aOJkXgv9eAmtkmLCqrlJAMWm7F7BA9S8ItElgZLhgpcu31M2gcP0q92VYsZ83riZHtW+jNki6naEwYyxLqSgeTc/DNtJsp5rO96iq5tj91xaGFrHBofYLsy1dyAcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=snMkUsAw; arc=fail smtp.client-ip=40.107.94.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEDCpUhOIWYGr8pozSEIhUcwBlcBx3dvmq/KrAqRcz0jbGP+9eZxe96X1hLtg4/CLSxBHQuinsm6HWj73dTs12AFRGmsUMm3rgJYTdn0dK361t80aar/bgpoOqdZmsYAdLqhLtR6Ymo/2J06eVL8wHmWDonj+4bvqWkI9ZbMtI66AC1Tj2WV3xk8cmMM49uDYlFadK65vfNHM+eBFPCj0/rOko1Pd/zwoGQJgnujgoT2ZUvGnaM7nGsgVh/niXC8lKCsgWQv5X7QJT9q7Jqsmkik7g11//d1m1yc1ooSJLZiTv4ZE8QUhVu5jeczidL6JGRcdyBnFU5N8EMIbvJWXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KjSrSzYQdu5+BqfbP+MRpritVvN1089wrWeDxFO7d4Q=;
 b=B9j48L6y3fkDObKHiDrVjTPjLjYxhHoXQkH/poZ5FuaWzCjVNKqL6fO5UJLCldItMmOZzVeyZjrC69ZR9Q8PasurYmS6aCIYDvttgfrU2w5gL3VcCVdMOMMl/tH4lJ3jkKV/u+xtmxEgm29YnvxwopGLRjFxL+eXk05m+IVJemJoEiNIx9D2lOVkLr2rixiqXlchyo+dra787sxfAWKB633HG0H2QhCBNHlDn8nlvib4psHg3th9x1dRMeAesXDAbPu49kzBC2P95xkq6KENiBdmvj+hkEZEUL8GblMHGPw6n0sbv8ioCvOGeb31m4yAKl6wHLTl3O1nBDVGC5YW9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KjSrSzYQdu5+BqfbP+MRpritVvN1089wrWeDxFO7d4Q=;
 b=snMkUsAwXLDFyB8SvLMkyrQO/PHVGchu3lwcGpV6GiztfYAhtgLEr5SaNQwhVfBLJuB2ygLdz/FUKJ/6AaFL60tDYdK+8MlhqFpytYqH/aB2y/wmbqg5uZraSpFBaPQEhlLjui2n0E2Y+1l/DnkjSW4G4qS8Rvhdu7rOrhZH4jM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by CY5PR12MB6252.namprd12.prod.outlook.com (2603:10b6:930:20::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 17:52:53 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e9c7:35dd:23f8:74a1]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e9c7:35dd:23f8:74a1%4]) with mapi id 15.20.7202.035; Tue, 23 Jan 2024
 17:52:53 +0000
Message-ID: <2f8c0dfd-5d3a-4135-9d8e-09091fdf87eb@amd.com>
Date: Tue, 23 Jan 2024 09:52:51 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/pds: Potential memory leak in
 pds_vfio_dirty_enable()
To: Cong Liu <liucong2@kylinos.cn>, Brett Creeley <brett.creeley@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240123011319.6954-1-liucong2@kylinos.cn>
Content-Language: en-US
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20240123011319.6954-1-liucong2@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0179.namprd03.prod.outlook.com
 (2603:10b6:a03:338::34) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|CY5PR12MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: 56cf62bf-d95b-4357-fdac-08dc1c3c1fc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tK7DPzJy1a9BjFLt2usstxBP14zBaz6eYq1BfoEywxS+LN0nmgEcHkrWbLHCBmdp8XosPZIJe0qOE/053+8Ymt3dJWprONPQf+NMTk50WG+aVSTn+j0kO74kSZbUmeCfiPeBk7YnO9Xc3deNWVRS0elZeo3tsRIRzrn1plsDlSPKL9DDuZ6+GJVsbNT9mSbb2MFCy098defQQl5SLLQ3mU+U/N8wHhlMznILTykfmHlCwCWZ1J/eJn2g8Ld3Gyi0uOMoa3QjSJPx0Iree2oGOP/oLSCqLHpTvXgi43n8pBMVt39+8SuWHwXgxUGode8XJZ4MiW8MKoH0lWPDOImVYWE9SpOpNG4fVshb6cFGFS5Ekag9JVpOQcDPfG7fHlJLN0vvnb7kQOS9xNirz8Q8Ag8k2JtURpXb9tudcM0FTS7KfE7DSfY0Ufc1Rs14iJwP8Fb/EO4jNDBPZ8saNS51Ljopeyo9YWDKAfnSp71hGYzWz5yMUgIPbiiQV8F2n7mlkFTXTR6zY5K4b5NaiRkhokF3qUXXg7ToFCHD2aEuLirqrKElkO9ZUu8F3SBYWwvogSFmQOQQu5xA2tYxOnDHX9IObYtfjRZA2Vb2xN+cVVGPnTv7qt2K97pigC3RxMV5aUHS3MtssMSwl3VHCHNM+5gNGptG7w+M+0vPb1nV2eEKhGULXTdFmSQ/y+ySZY4JG3IRQ2yrKCLh2qhc5PolYQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(366004)(396003)(376002)(230273577357003)(230173577357003)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(41300700001)(2906002)(38100700002)(36756003)(31696002)(4326008)(8676002)(31686004)(8936002)(6486002)(83380400001)(6512007)(53546011)(26005)(66476007)(6506007)(66556008)(110136005)(316002)(2616005)(5660300002)(66946007)(478600001)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWovYktRTlZXMDJGbVpqdkR2NEQxY2M1RTVzaDRPYnQxc0VjSTZEbFdMaEdu?=
 =?utf-8?B?MWh1c1VxUHpKU09KZmUvcEl2WDNpdTZxblVRWXJBdHU2Tk9SRmo5bkVMN2Ny?=
 =?utf-8?B?dE5EYVVKK1RnVzRSdURWN1loNlFwZks3TmI4cDR6bzg1NklKZXRqejgxSXVp?=
 =?utf-8?B?aTZVMi9ieWJEUHZEOUJiTUlVNFJEQ0didXFWUTdIYVFoU2VWa3hCZ3A2Vmpu?=
 =?utf-8?B?RUlXUDFIdEI2OHI1YUlUQUlBcm9zY1lQYnRZQUtEY0pVUWRpdERJWlJqQlB6?=
 =?utf-8?B?VnhGekRtSzlSL0RHczdIclYycHBkakg4Wkk4WTRBbUZOcWVxdnFRaVFFWXB5?=
 =?utf-8?B?MWVGMVJKSzgvNHp1VVdWUU1BYTN2U0pSSXd4cndyR2FTMEZqRzR5TGJmUTBR?=
 =?utf-8?B?ZExQLytyNHM5WEs0aGg5ZW0rQ2hHakk2T3VBRXR5cGlXendDWHpiYkpFQlZR?=
 =?utf-8?B?enJwWE40VUlFRXVTZFFaVTJwRkpQcTZ1UWJZblBWaE5jaVQ3MzdJWjlYZzFi?=
 =?utf-8?B?SUR0emlSU3R0dTE2cHdvOUs4UHFYcHN4dTgvUFRGQm1IQ0tFY1hVYlEwTU5F?=
 =?utf-8?B?YjNBZFlZRURkZGM3U2lLZlhGT0NaYjJ1SFV3VGpEalZlU1BMRCtxdFpIdSty?=
 =?utf-8?B?OW0zbmZaK2lKTDJwekpOMGJla3MvODRzbXdjejFMaVZyWll4eGdqN01EeEly?=
 =?utf-8?B?V2wwUWc3b2FuNUh5OE1jcmxLY1k1M1JpaXlrbVdqZFQ5RXJ5NXNVS3UwaThR?=
 =?utf-8?B?WmJla3hLTXc4dCtPalBHZklFN3lKdU54YUJubzJFTUI5OWF4eDZPVW4xQW84?=
 =?utf-8?B?QUdqWkkwU2pLbjdDMzNwVWFWRVZRNFBiMGpXV3RiSXYwQ2dVOEZLemlieEtO?=
 =?utf-8?B?bDd0dmU2S2hidUw5bVhVS2FUd0w3QVhPanNXdXJlV0N0ZmUrdERLZTVvMTFl?=
 =?utf-8?B?UEpiLzRocnNjNnJJYStLZHdzZkMyNnJ3UkVZTWIwS25kTDFsc3pUUE5SOVZv?=
 =?utf-8?B?ZVY3MjF2Vk1na0VDa2tmN0txR1duM1VuWEtrRGVRalc5cW9NWGxBTzhwb2Ix?=
 =?utf-8?B?eFdnaC8vWDFQdUFRVzdVOXhleHpZdEpsT0NoaTFnUERKSmowQ2NUN0ppeG9I?=
 =?utf-8?B?aXVycTZtOWZnS0J6aTI2KzIyM2JaZGlZTkF6TW1EVlNsMW9CTXNoOTBIeEkr?=
 =?utf-8?B?M3FCTmhBN3pLejJsUmt5WU1XTExZT0Vxd0JSQTNQck52bXVCRTNWSlNaV1lz?=
 =?utf-8?B?a1R5R2FXNFRlTEI0b3pTbzZHR1JkOE5LdEQ2ZGtBZkJuci9EZlIxUmdBUHJl?=
 =?utf-8?B?KytpcUVnVGJGR1ZtOE4rMjFRd3E0dDl4SmgxNE9JNllqcThsQ2FQSUs0N2ow?=
 =?utf-8?B?aTZmdUY2M0I3eG1VT3diSW5DL0hZK05PZHRlVzdUOEE1Q3c0UEpGdkl1Wnd0?=
 =?utf-8?B?ZDNYeVhrTE84ZTZIdDFtM21vZVVnOFRWUFNMUTZBVEUvOU01aGtlYU1lQy85?=
 =?utf-8?B?L2tjTlpvRXVRNHdKR0oyNDlBWmhLaTNvWjhxdksxT2RtcWdtbUQvL0ZIS0lS?=
 =?utf-8?B?UmxNT0JLOG44MGg5STB2bU9IeWFEdnhFRU10amVQZ2kzdVJ5bU9rY0UwdUVD?=
 =?utf-8?B?Nlk3TTZHbk5PUzlQQWFyZCtCbW9FUTRackFFZEZhcGpscHhOWVVLTFBROU1v?=
 =?utf-8?B?cGpRUS9wVzM3UjJZWW5CZ3VVd2hXK2NKb2srOTNmWUNSbkZTNXpyT0JSVFRE?=
 =?utf-8?B?citqWkJnUWI1eEZIYlpQMkpwZHRVWXhCaytYRzRJZ2s0d1QxVU95Mi95NXAv?=
 =?utf-8?B?NEtGbFZkWnpzdlp3b3dQRjdJSFRaZDJhOWV4MkgzVEJtdXVaNmI1b1JKcElK?=
 =?utf-8?B?ckFYbWhFTzJLV2NHNng3ZzN3S2NkVy83WU1EQWJid0k0b1NSV29MZmd0aHhG?=
 =?utf-8?B?eGJxbTI4d3dCK21aS3lxSVBuUVBtaWpETWlJRnMrNWZLeFBmUEsxZnlQcEtq?=
 =?utf-8?B?NlhSMVpUQ3dObEFMMitkT0pqMm82ZTVVSEE0MXZ0MG8vbXZ4MnRObjdmQmtX?=
 =?utf-8?B?UVdkaVJsNFhaU0Y0aW12V0NXUkhvYjBrZEpiRDUzbHZ2bStFYzFrMHhyQjFX?=
 =?utf-8?Q?Hv9ZDaoYXlNkptt97p0Rs3gCW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56cf62bf-d95b-4357-fdac-08dc1c3c1fc1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 17:52:53.7251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4w76/zohv+Rj0+onkO/HHtEAbSAZcYV/1FqAEMnIP9mhs7TxS61+UXpiabK+YIsOv+OtXcm2ARCfCo91jUf7TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6252

On 1/22/2024 5:13 PM, Cong Liu wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> the patch releases the region_info memory if the interval_tree_iter_first()
> function fails.
> 
> Signed-off-by: Cong Liu <liucong2@kylinos.cn>
> ---
>   drivers/vfio/pci/pds/dirty.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
> index 8ddf4346fcd5..67919b5db127 100644
> --- a/drivers/vfio/pci/pds/dirty.c
> +++ b/drivers/vfio/pci/pds/dirty.c
> @@ -291,8 +291,11 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
>          len = num_ranges * sizeof(*region_info);
> 
>          node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
> -       if (!node)
> -               return -EINVAL;
> +       if (!node) {
> +               err = -EINVAL;
> +               goto out_free_region_info;
> +       }
> +

LGTM! Thanks for fixing this.

Reviewed-by: <brett.creeley@amd.com>

>          for (int i = 0; i < num_ranges; i++) {
>                  struct pds_lm_dirty_region_info *ri = &region_info[i];
>                  u64 region_size = node->last - node->start + 1;
> --
> 2.34.1
> 

