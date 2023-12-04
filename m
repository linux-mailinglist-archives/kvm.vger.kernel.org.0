Return-Path: <kvm+bounces-3324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7209803129
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 12:01:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4377A1F20DD9
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 11:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE3F225A6;
	Mon,  4 Dec 2023 11:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hMCb3iNU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93825B9;
	Mon,  4 Dec 2023 03:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701687695; x=1733223695;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lsTTdbgNzI4lwIaJLYMZjoVBcm0P5ol/BncjAHNhGVk=;
  b=hMCb3iNUdc7n+atATwi4NI4kRaqU9+w/WbxcDepCnhmzryfYkiozIAQv
   3rTzh3dPq8Lty7Sdu9W2dFZ18ml7QMmGn4jaLop2hb+9tcw3/fb62hvL5
   EAIArIxgbv1Okiu/K9qriGXlMblbWjv61X6IZ11FlHgbsXFxK3BQtwZJS
   FXaaKO5Yjm6za62GZel3rGc5EIFExmLel2pN/kz9mAymE7KxMuBdUHwmu
   BgtaBVZGZSwLL29nsF+4rUJIQRI7HBwux3c52yXTbOua2wx7ERe1QxZad
   DIO1D9ikv443rJgflPL2oPeH7boiTGFfyL2NwCTmY1HXT03mbhVGMpV0Y
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="458039408"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="458039408"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 03:01:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="804866489"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="804866489"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 03:01:28 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 03:01:27 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 03:01:27 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 03:01:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrTGKKZByhOr0pRL27N8OaOPDE8jRl3OKtdTGxZt09fluqj1AtPoqm3r7bhWGAtsRt42IATpIO3YTDSvfH4nUm0sQFMV/OzepLXaZ35Gp97mNB/bGZp11biO90e89rq0m7hIz5qabRmKgfiszftwqTh86veWUdhbUGBrfHt38pPrqFOGLX87FwIC9ZZ9NWMBSfIQdy2tDX3OpOLFzNGJUdxmckzYdlnf23+kOQjCzJEJRTIe1LWCcypc96l5FR7EWffxe6jbOe21gZ+3IqIgBa4HA3EzG82l75YcDMJG7RPKw7dGLU5tlxwHBx9ptmPvv3hV7kfri3K6Jyt9StlYrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PkZmIy7/tyAIMU0Gw5bGx0W6EsDMTkhUIRdEaN8fNGk=;
 b=bX96/zjzdoE/XeD+MTy5x1pI+exU3uXMAofi50xl4bPdTSFxVfkWKq2dtkmiWobddFOWPs/A9HkLh2HBCYD3/AZN/+K1vpHxF0Y6Nv+yLfDr0mI303LZZWnid77aDcv7Mm3pBEe096nOi0cEYnddUuZe4lYp8NsO5C4fRNo/JJ1P+/hbuldykZq73xoKnCfypobnNgGaJba2LuQWeOOisAaRu7oD0Vwqj16XNWGV18y3VKE9h3yabBwYCkaWdRVBp6YBsJtN3CEzmWireBMV6kThzIPkcRBbdM/GmmhWiAYftUoeR/40rZS7X3Gq2S5S1uedIThmqvnAxk9diW/9tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB4878.namprd11.prod.outlook.com (2603:10b6:a03:2d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 11:01:25 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%5]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 11:01:25 +0000
Message-ID: <46f1e3dc-62f7-489e-9b7b-0398c32a279c@intel.com>
Date: Mon, 4 Dec 2023 19:03:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/12] iommu: Cleanup iopf data structure definitions
Content-Language: en-US
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Jean-Philippe
 Brucker" <jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao
	<yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-5-baolu.lu@linux.intel.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20231115030226.16700-5-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::10) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ0PR11MB4878:EE_
X-MS-Office365-Filtering-Correlation-Id: 34b5c369-c86d-49c5-72f2-08dbf4b85b29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+wBC9/wnelLk0ytBXZrNqsMLLPa7gw0kz1pr4vbPipaRUMAAyQE+UtveYflGUQU9Z2bEtDdAPCW1vrMbuycFNykRrmrkss191qO7F56WItxvQuvfy2kRk5beFfrJE9Gc2FNO8uIkaHhw/CUVtFPZ16hyZgWX/cJAilcMRZQUeos8LbiGebkMzrYLrgQ+72yultIR3XyDzCdJpVPhNZvgyH1s/I3H6olhdIGb759W1RLOx7hQIUabFvYC01s3YlcjG36SAl7rDyZ4WsUZKSa3GQgryZcOGjA/bqSHbmpV1f9P1rfHu8oaCnvVHvyFi/TvoAGD4sQTeao3TEqY2wMvX3PrYm5M//zIGU/Ro4MJljQZCBi08+QpR22OGzd8X0ipOwLYcC6aIqap/8gP9XUdiqeBdla8sZgIIWrwpQP+AFKMw6ITxi/7jln9oJPr+KnHzc/3q+Ki/KoDoDl+gV9o/WsCE5quYTusT1k1sfa93Snoy50tx2uFZFy2cIWMkm4fzSXrnW0aLV14N4HDEjHwsagdJrOjTV2HDpF2cLJ4utyeN/gwp/fGRCt7VLNjMHOzWuNNOepKKcZwgDDiSsOkv4mk5sI5NOLHQ94++w73sWOJLqmdEonWGFX1BA3tTS2r5N8YLidGVtagmufTebjCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(136003)(39860400002)(396003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(478600001)(26005)(6486002)(83380400001)(6666004)(6506007)(6512007)(53546011)(82960400001)(36756003)(2616005)(316002)(110136005)(66476007)(54906003)(66946007)(66556008)(31686004)(38100700002)(5660300002)(86362001)(4326008)(2906002)(8936002)(8676002)(7416002)(31696002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTBSZEI1dkFTaWx6YXJjSHBobjdNMHNQMTlmTFNmTHJ0amZkVkxNa0NuTDFZ?=
 =?utf-8?B?YkRIWVBtSS8ySjgvTGkyaFdHcG9nRWI5d2l2cWZXcU5JTVJBM0F3UXA0ME96?=
 =?utf-8?B?enpxaFFGZmFVZ0xzaU5QRU9OZFgrNVdDaWlTWkZFL1BBRnFTNm5VTVdyN0xY?=
 =?utf-8?B?czQxYWFFSTFVTUJvbHpDS0R3SGtzc2JzcWlKdWE0WkczNUFGWXBsWGU1K052?=
 =?utf-8?B?Um8xLzV4Rit5QjVnSU1hSnU0NkhNN0ZnUUFOdTB6TXRZa1BhQzdIaituT0VQ?=
 =?utf-8?B?YTNlTjYvOUpDVEc1K29La2IyMzkzditURXc0TURwT0x6dHUxRlFyMnBpd3RR?=
 =?utf-8?B?TU5TWU5yNWY3NGtReHlmVUE4RkJFWVVlR3pPWEozVExXWDF0VFVDOWNmeTlY?=
 =?utf-8?B?OWt1ZXJSS3VNV0dMbkdDanZmUEliS01GaXdkcnJMdWZESkdWNXdaWFpKTDBv?=
 =?utf-8?B?a2NWL3d5Y0FzZHFObUEvR3pRUHZ3WGl5UzNnZHRvQXBzT3pEQXpQWVdVTUJU?=
 =?utf-8?B?dTBpODBwdC9YbVp0aFNsRFpHL1JwVFIxNU0vUTFLeWdBaXkrdWZaYWNsUlFV?=
 =?utf-8?B?MnF1dmRvanhwOHRyNThvODUzclVBRGdiWVpyUUtLazUwbWN3OU9lWWppVGNR?=
 =?utf-8?B?dWticFJ2Z0lwQlpFY0g0VmJVR3JCYnhvNno2Y3Bta1lzSVE2aDdXQXlZTFlR?=
 =?utf-8?B?aGRvakZqNG5yM0VDek40N2hycXNJUElMT1ZDM1pCK1ZFeldaNFlYUUZZVVI0?=
 =?utf-8?B?RFo1T2g3bXF6L2RROWVFN2NJd0pLVGRBeHNVTWl4K0FlR0ZVVDFkaTVjdGpR?=
 =?utf-8?B?dVR4SWxNVTR5b0d1SmRrNWlLcDROWVYrN1hFODRxWGUzb2tLYTN6K1M3UE8z?=
 =?utf-8?B?Vk92RXNSWWdmc2R4TXlxTEFQdit4UlIwSDdXSER3RXVBalA3SlVJWm02Nmcz?=
 =?utf-8?B?UEt2S3Fid21qbnduajQrVjFKVk0wWU5tb0VJaUVOdEJQSW5JZEsyS3Byamxt?=
 =?utf-8?B?b2NCb3VJVXBZQkZiLzFZK1JDUDA5L3VwU2xkS2RPbS92dWlBTXdmNEtsVTl5?=
 =?utf-8?B?eXF3Y1ZBMUJPZUV5TUJNOUJhN0tSeWdYZlIvQlYxNUFKOGQ4bHp1aExPM0dW?=
 =?utf-8?B?cGZEdjNnUE5jVDlTQVpRMUg2VktCNERkSXE1TjhKUUFFeDdZQ2lic3Bvbkdl?=
 =?utf-8?B?Yk5yQlVJK0Fid0dMOEJoNkFpTE1hK1RYTVRjbjQ5Ui94Y3BzWkxoRUhtMUVO?=
 =?utf-8?B?cUFvZ3gra1JkM0N2MG0vV3NXWDU0TVhQQmttdUtJOFhOL2hZMDBLa1hFbHpp?=
 =?utf-8?B?SEs3MW1kYUM2UUpjOVRaSnlscmFIQTVqYVlhYjJLTWhCODV0Z0ljQUJTOXhz?=
 =?utf-8?B?OUtWZmpkUkZRN1RMOWF5T0VZS3hBNWhpVnVqd2gzUjZheGxFVlFJM0wrWU0w?=
 =?utf-8?B?SENmZnY1b0VtY3JLYlRMMlBNS29RbUdGTFU4QTE2dDJWbVZSd3R5SE13MXkv?=
 =?utf-8?B?ajRvRHRvTXBtdkMyYXU1UVN4Z3kxcGt5M1lTTUpISThNYVp2WjVJUjBiaXpO?=
 =?utf-8?B?U0E2NDE3dE14Y01TdmNZVTluU0o5d2NMOTIvVytVWlc0TXVOdmxranhHdWd3?=
 =?utf-8?B?RnZyakd6Zm8zRGsxN295cmxXQVlyNTlrUWRNZmtrOGZPNTF5dmE3dkhtcXVj?=
 =?utf-8?B?MWRlSkFtMFMzamdSWFRCRzI5bllrS2FLUk84N2R4VzZxQ0xDeEQ0QzVDODZy?=
 =?utf-8?B?QmpmTFlBajNQcktLbzFEeWkyaWxhdU4vb05HQzFLSnZNYVVTL2VwYng1Sisr?=
 =?utf-8?B?RzdNMEJPY2lUZzZQckw4QnRhdjd1eTdOZDEwQnJHeEhMTHdPSmY5ZEYxL3Ez?=
 =?utf-8?B?STUzRm9ZS2JkU2duN0tWZk5pWldWUGVJdXlVZXBhNzBBakxKUzhkbE05UWNk?=
 =?utf-8?B?eUU1NHlnK1FnTzk5bW5icjZEYzZueGx1Y1puTXVFNnFtS1Z4VytFV2dqWGRG?=
 =?utf-8?B?SDErbjg1VVdsaUtoZGw5dEgraG8vRndkbnkwSHFzQ2FBUXZNMU5QM1htYy9m?=
 =?utf-8?B?N0tKZ0x4bTk1emNyTTkxRXJveE1mU2pva2ErUFlVQ1RXZzQ3V1RMeGlOc3lk?=
 =?utf-8?Q?YWPVmFs83S7QY3dxFckw4tblU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b5c369-c86d-49c5-72f2-08dbf4b85b29
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 11:01:24.6721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rceaKMWhpOBDaAJfu62qPO23NmBEOqCMsYSk2VLQoC9wLmcG7T5zLdE0cYNccBNRoYobApxXIPwUbKvt22CkIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4878
X-OriginatorOrg: intel.com

On 2023/11/15 11:02, Lu Baolu wrote:
> struct iommu_fault_page_request and struct iommu_page_response are not
> part of uAPI anymore. Convert them to data structures for kAPI.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   include/linux/iommu.h      | 27 +++++++++++----------------
>   drivers/iommu/io-pgfault.c |  1 -
>   drivers/iommu/iommu.c      |  4 ----
>   3 files changed, 11 insertions(+), 21 deletions(-)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 81eee1afec72..79775859af42 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -71,12 +71,12 @@ struct iommu_fault_page_request {
>   #define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
>   #define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
>   #define IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID	(1 << 3)
> -	__u32	flags;
> -	__u32	pasid;
> -	__u32	grpid;
> -	__u32	perm;
> -	__u64	addr;
> -	__u64	private_data[2];
> +	u32	flags;
> +	u32	pasid;
> +	u32	grpid;
> +	u32	perm;
> +	u64	addr;
> +	u64	private_data[2];
>   };
>   
>   /**
> @@ -85,7 +85,7 @@ struct iommu_fault_page_request {
>    * @prm: Page Request message, when @type is %IOMMU_FAULT_PAGE_REQ
>    */
>   struct iommu_fault {
> -	__u32	type;
> +	u32 type;
>   	struct iommu_fault_page_request prm;
>   };
>   
> @@ -106,8 +106,6 @@ enum iommu_page_response_code {
>   
>   /**
>    * struct iommu_page_response - Generic page response information
> - * @argsz: User filled size of this data
> - * @version: API version of this structure
>    * @flags: encodes whether the corresponding fields are valid
>    *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
>    * @pasid: Process Address Space ID
> @@ -115,14 +113,11 @@ enum iommu_page_response_code {
>    * @code: response code from &enum iommu_page_response_code
>    */
>   struct iommu_page_response {
> -	__u32	argsz;
> -#define IOMMU_PAGE_RESP_VERSION_1	1
> -	__u32	version;
>   #define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
> -	__u32	flags;
> -	__u32	pasid;
> -	__u32	grpid;
> -	__u32	code;
> +	u32	flags;
> +	u32	pasid;
> +	u32	grpid;
> +	u32	code;
>   };
>   
>   
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index e5b8b9110c13..24b5545352ae 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -56,7 +56,6 @@ static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
>   			       enum iommu_page_response_code status)
>   {
>   	struct iommu_page_response resp = {
> -		.version		= IOMMU_PAGE_RESP_VERSION_1,
>   		.pasid			= iopf->fault.prm.pasid,
>   		.grpid			= iopf->fault.prm.grpid,
>   		.code			= status,
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index f17a1113f3d6..f24513e2b025 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1465,10 +1465,6 @@ int iommu_page_response(struct device *dev,
>   	if (!param || !param->fault_param)
>   		return -EINVAL;
>   
> -	if (msg->version != IOMMU_PAGE_RESP_VERSION_1 ||
> -	    msg->flags & ~IOMMU_PAGE_RESP_PASID_VALID)
> -		return -EINVAL;
> -
>   	/* Only send response if there is a fault report pending */
>   	mutex_lock(&param->fault_param->lock);
>   	if (list_empty(&param->fault_param->faults)) {

-- 
Regards,
Yi Liu

