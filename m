Return-Path: <kvm+bounces-3333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22659803300
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 13:38:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 453F11C209E9
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 12:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FEDE241FE;
	Mon,  4 Dec 2023 12:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FrU/WiAO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D85A7;
	Mon,  4 Dec 2023 04:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701693481; x=1733229481;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TZrVBVYHyMnaUFgD9Dz65E//PVH6mwgAZHswEzueOr4=;
  b=FrU/WiAOu7wxNHaZ2i1xm1KOvGT0pzVlQXNU9dQijE1kjdtb1UMuxhc2
   Mvg2cx1yX8l+ubkA0Jxl1eT/NEoc31gXq4/1GIDs4DK3Mj6tnaqPz9EHe
   yETc9TgzEHXSLWx/dCwoRSGal+DygC/wH5NMJoxjsVu6MhyMvHdKCbdWj
   1SceTdorrIRBri7nOTOsZSJaHr0sVoRTWRPsuG8vbABhaJuPmvqGITKBQ
   afSzbN9UgH6EXrPXrH7+bTm8e000csMzIkuRuXh0hEH3p8bJsTWeDvSoH
   xyTmxT39/cMAs7z0pgTbXv3LYXXw58DBpT7SXWIlXkfJXbCu0gE7Vkoe/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="7016041"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="7016041"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 04:38:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="893991056"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="893991056"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 04:38:00 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 04:38:00 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 4 Dec 2023 04:37:59 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 04:37:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 04:37:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYDsUA3+VLtTR18m9B7pk4V1EoOPxk6ru5zeyHqlhTmk55DTuxExY9uvrbkYcCh/hYIMmqxJ/pT0QU91IeMa3Y2OFeb14drX6JItGbScOjqTG7PRihJI39yLbRSePrPs6ML/s6z3DAes6rqaFYRgtA/tpLNSMXKqYRYn1UwGDU4kzAoU5X159oSuw10oS1KQzdVAk2cTBaxZyjJFjwHoBCaq1pZ5/05psj9dVukq0Ns3TjMiLIAHTSlqWvcOK1uhfJj9l4zYAPKjdSHNInBE/q4t15jabKFxCvA+gR4UNWrSvrpP5NbJfwiS2TGv3MBLlRCl/PRqVwSNu6sqcjIUNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSss1bREvyO33QhOIN2EObEDBcJ/t7XfRRsY1vBhJQY=;
 b=AzfdJWR5Kt6yzwg/TJv2rRWKjFW98O+oJvNUhOixylt4/8BtsrlBac4ZVEGbtGX4HIb7CUuvtBACGHx3k2Pv1SqaoCFIgRxAc32A6ifUE6iyVfiHUyowu7wR6sYtpLaHoadQ2BdwEtVWMhzxK06y2Qc9pzJvLCHPHeCFUrnJFbcHRsCSMKH/Y2HE/Vm0TVVlDNM8bJHztTTnWinuSmVx1up5725OSPqdiR5VuVzdtgorgBqZmvFjSzxPHkev8ZXDGDxcf1354mmACG604mVPhAQjjXeWenjj3ERO8mZ9GDh416qrAIbeQ6ycOxdT1YmuCeJiUeLA9462xNx6gw47Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB6851.namprd11.prod.outlook.com (2603:10b6:806:2a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 12:37:57 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%5]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 12:37:57 +0000
Message-ID: <7e088129-866a-499d-8105-ba245c744f14@intel.com>
Date: Mon, 4 Dec 2023 20:40:32 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/12] iommu: Merge iommu_fault_event and iopf_fault
Content-Language: en-US
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Jean-Philippe
 Brucker" <jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao
	<yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-8-baolu.lu@linux.intel.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20231115030226.16700-8-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0052.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::21)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SN7PR11MB6851:EE_
X-MS-Office365-Filtering-Correlation-Id: 9748f84e-c82c-4564-890d-08dbf4c5d800
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJqQmk2pyUn9AJudASnRr2PbtZUk7of+MSEz5rvL4aiPANORYLItRcKv3jvmDYYXxuyflNNw5K/2EhpIcpMOelfJ32oRsETE2gQmRNzJTH0H5nDjdO3opoNZpJBJ7PVntwY5f1fDyxERBavYcsiA56J9VXlMEQhR7dyMAJRtsOY1r3KK6C/zCaiZExqa/J9wNsSDlaq0tIDHxAbm+NpwKSeecjp7prNoklUlJk9VBGJUPpUj4Mamo1yooMrQZRLwR6fGjBFDcNX2028YCIKNk27yJ2nDyP3/DLB2Kkv2lXDyXtYD2mg40C0CDHqoVCQvFacmrtjdeNi1VG4ZRpjhzst4uj4ORhW7MkAJ5asnuFjjZpnQw35z6XcywX/lSNss1P+lMxAqHNugjwrGecWq6+N4KMSTdXTcrXJeMcXaAuIq65aNIB6Ezv8ggLGbEpFOtwH0PNfgeubJWIgGFMwXcB9hRMYo8cpXOXd7Gyz4sZRRCK5aI9Or/PXpzUMLgXak2Dpbu/4hMAAWF1gxn6KqYl/bzLs7Q83WxMVN80gVQoVEzq7B1FxTfepKQQ/wgt7J8CP91A67tXcRal+dMCZnUbnH5wuxKEJdU687zSHTLIfWKtjsfS4WsdK+h7SQ2Ya7wnxa5yXFzG81xm0bHfEmpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(396003)(376002)(346002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(478600001)(6512007)(2616005)(8936002)(8676002)(4326008)(38100700002)(66556008)(66476007)(66946007)(54906003)(110136005)(316002)(31686004)(26005)(83380400001)(6486002)(6666004)(53546011)(82960400001)(6506007)(31696002)(86362001)(5660300002)(7416002)(2906002)(41300700001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm8rZFl0YjY4bzhWcnp5LzB5Y05aUUxraXY5c2ZpZUxOK3BhT2VNL0JnWVhk?=
 =?utf-8?B?cUV1UThQNktXWDQ2VlFNR1V4Tkhrd1pZejFEeWliem42MWVNNmVkZDZ3L1Bu?=
 =?utf-8?B?UUwvM2NtZ09CbktTZXNoai9mT2k0ZWNOTHhvYTN0ZjVzS3czMTZaYjJCOERo?=
 =?utf-8?B?cXJxZ3JLaU5WdjU1RGl6VkRPYU16aDZ4K2hPMmxDZVErTzNHdzBRWklIQ3Fh?=
 =?utf-8?B?bjllNlBRREFRaUovaXJVWEFTVmsyVGtXUkZWN0oxdEtYN21DZ2RrY1A2Mktj?=
 =?utf-8?B?ajVRVzQyeExjNXpmUzFrWUljM1gyNVhDV1pQOHdPZzVsMTJXbWdWWGJ3RUp3?=
 =?utf-8?B?M1pkVkM4N1lLV0dETkR1elNTUEZsaEg2WEFWSm9OVzFMZkg2bWJDMlVtM3ho?=
 =?utf-8?B?S1hsZTRST1drSDlIa2puRWVqakRtVVIwRUhhMGQ5RVRCYzdSS25kaVloNHVq?=
 =?utf-8?B?ZlJkRlVab0JBa2JndlcvUmRWbWJRUGxucE9WRFJLSmhGdXNQNW9FaHc2aE10?=
 =?utf-8?B?dENwVnZEOGpRcWhyUFVBVTZMaEwzYzJPVGVtclFnd1NPZ1E5aG1jemZSNTBv?=
 =?utf-8?B?K2Y1YjlkYVZpaUpZR3pMaElZWGg0Q1NyYWlNcEQvUlZhUU5kY2ZaU0wxa2Vw?=
 =?utf-8?B?SWN3d2swSHhFWmVNSUxZeHBaV3J6QTFlMlVTcVpZaDByKzRJY3g3c1hhbFJR?=
 =?utf-8?B?NUMyVitRbHJwQUR3c2RQRDdmeWwwWFhOVFJWUGhxUFBiRUYrRDJDZDVraUxZ?=
 =?utf-8?B?WmRvclBEZ2hBYnhlcFUyM1R3KzNNTkJLNkUyRnBpMHF1bHk2Q2ZRem40R3NO?=
 =?utf-8?B?OGhmdUc4NEFKb1ZXODZvNy9QMlV1bXIyUUw4cHRRRVpLL0lscGp3STR1SUhT?=
 =?utf-8?B?NnNxMzJHZFNpbWpySFZodDZ3Z1hITk1IYUExSGhiOThiRWpjVjNtVTFDU1Jt?=
 =?utf-8?B?RWRtYjllM3RQNFVqTG93TFArcW1EOHl0OFFldnk3WE5FeE5vcGxVWFVYUUdS?=
 =?utf-8?B?OVVraDJOa1ZENENsQy90c1A4MzJnbFhSWGpoRTd0THNPeWFCL250U1hqWHdR?=
 =?utf-8?B?NlRsS1ljY0o3NkRpbG1takorbjJ2L3lQam40YVZKUGtVamR5TXdyNDV0OWRX?=
 =?utf-8?B?M2xHbUhXai9GM2lDdHc0N25uam5MYWpGdk12aUFONDBFNmRKUklFUEFETGti?=
 =?utf-8?B?L0ZRWU9SS3pFOHdpYk4xOGhsYlU0dWNyQjdLeGc4amc1K2JwZ2Z3ZXQwbU5h?=
 =?utf-8?B?b2VrbTJ4WVFlMFlvZXpScTJxbW5xU2hOb1kyMzhRdjdYaUNWdUZYTUtrdStw?=
 =?utf-8?B?SEJCUFpVWDJSSStMZFdsclQycllrL3JrTWcwQkM1WkM3WXoveGRUdS85eXNK?=
 =?utf-8?B?SHNBeEw5bTZYSGJEQmdKOFdGTmc5RFZRdFNBT3ZlTC9jTlJvWENEdHFxU2ZS?=
 =?utf-8?B?UE9WSWluNi81WVFrZnZsbWl1UzVrNDZzS0YwUWIrZnFQSWVCa2JYSlFWZ2VY?=
 =?utf-8?B?SUxoeUdDT1BNVk1GWTJ0TU10OTM4NjBpUUFONmdkMHZlYytickt2bDgrTTAw?=
 =?utf-8?B?cHYrNjk5YjRXU3ROWDFKVkdsQnF6b1lQZ2kwKzIzVEg5RGYyTXJweHJtQVlZ?=
 =?utf-8?B?R3RqOS93N2MxNnpEMllBUkMvVmpBYzFKVjRDWGtDUXVFWHNmQ0xtVGRJdGJY?=
 =?utf-8?B?QVBYbEp2Mlp5N1UwQnBvMTN0RUJleXdONDBHMlBpSzdPY1dKZFhZNTM4VDY4?=
 =?utf-8?B?U1JvRXI3SXhWZkxuVXdGUEUzVjlMeGpPZnpyd0FJVXkvVDVLMkw0R3NNM0p5?=
 =?utf-8?B?aHRUTG91ZFRDNFZxWWQ1emQ1T3hJcmtTZU9oODhFblIyczVSNTVHcW91Tlgz?=
 =?utf-8?B?U2NiRzk0K0pkblY3OHNFRnJpWUFic2lXTGxCdGZOdWlQVGQrbFpUVDlWc083?=
 =?utf-8?B?KzVMV2s1WXUzNVROVyt3SXVOOEcrNmdiNm4vYkVkTW0yTEJVMHpMclgvRVNN?=
 =?utf-8?B?MUZOSlRoZXpjN0xSaXY1ak9qUTZRbmlqUTZDRS9uMkZXR3AvTTNHUllyMDRS?=
 =?utf-8?B?RzVtRkZTaVk5bEg0WVY3QmpVcHNSYnB3UW13cG13SWFYZk00T01iczlLOG44?=
 =?utf-8?Q?E1qqR1rSGYOz5pk2dqzhZ4F2k?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9748f84e-c82c-4564-890d-08dbf4c5d800
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 12:37:57.3771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ly4V0R2hY0Nr2LKl90xmL7lx0d8zC6R/BuSzwCZssSSWUPBpp37Jf189tiyf+jOZUY+yDdV5C6kVOL0MrOOKRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6851
X-OriginatorOrg: intel.com

On 2023/11/15 11:02, Lu Baolu wrote:
> The iommu_fault_event and iopf_fault data structures store the same
> information about an iopf fault. They are also used in the same way.
> Merge these two data structures into a single one to make the code
> more concise and easier to maintain.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   include/linux/iommu.h                       | 27 ++++++---------------
>   drivers/iommu/intel/iommu.h                 |  2 +-
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  4 +--
>   drivers/iommu/intel/svm.c                   |  5 ++--
>   drivers/iommu/io-pgfault.c                  |  5 ----
>   drivers/iommu/iommu.c                       |  8 +++---
>   6 files changed, 17 insertions(+), 34 deletions(-)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index a45d92cc31ec..42b62bc8737a 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -40,7 +40,6 @@ struct iommu_domain_ops;
>   struct iommu_dirty_ops;
>   struct notifier_block;
>   struct iommu_sva;
> -struct iommu_fault_event;
>   struct iommu_dma_cookie;
>   struct iopf_queue;
>   
> @@ -121,6 +120,11 @@ struct iommu_page_response {
>   	u32	code;
>   };
>   
> +struct iopf_fault {
> +	struct iommu_fault fault;
> +	/* node for pending lists */
> +	struct list_head list;
> +};
>   
>   /* iommu fault flags */
>   #define IOMMU_FAULT_READ	0x0
> @@ -480,7 +484,7 @@ struct iommu_ops {
>   	int (*dev_disable_feat)(struct device *dev, enum iommu_dev_features f);
>   
>   	int (*page_response)(struct device *dev,
> -			     struct iommu_fault_event *evt,
> +			     struct iopf_fault *evt,
>   			     struct iommu_page_response *msg);
>   
>   	int (*def_domain_type)(struct device *dev);
> @@ -572,20 +576,6 @@ struct iommu_device {
>   	u32 max_pasids;
>   };
>   
> -/**
> - * struct iommu_fault_event - Generic fault event
> - *
> - * Can represent recoverable faults such as a page requests or
> - * unrecoverable faults such as DMA or IRQ remapping faults.
> - *
> - * @fault: fault descriptor
> - * @list: pending fault event list, used for tracking responses
> - */
> -struct iommu_fault_event {
> -	struct iommu_fault fault;
> -	struct list_head list;
> -};
> -
>   /**
>    * struct iommu_fault_param - per-device IOMMU fault data
>    * @lock: protect pending faults list
> @@ -720,8 +710,7 @@ extern struct iommu_group *iommu_group_get(struct device *dev);
>   extern struct iommu_group *iommu_group_ref_get(struct iommu_group *group);
>   extern void iommu_group_put(struct iommu_group *group);
>   
> -extern int iommu_report_device_fault(struct device *dev,
> -				     struct iommu_fault_event *evt);
> +extern int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
>   extern int iommu_page_response(struct device *dev,
>   			       struct iommu_page_response *msg);
>   
> @@ -1128,7 +1117,7 @@ static inline void iommu_group_put(struct iommu_group *group)
>   }
>   
>   static inline
> -int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
> +int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
>   {
>   	return -ENODEV;
>   }
> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
> index 65d37a138c75..a1ddd5132aae 100644
> --- a/drivers/iommu/intel/iommu.h
> +++ b/drivers/iommu/intel/iommu.h
> @@ -905,7 +905,7 @@ struct iommu_domain *intel_nested_domain_alloc(struct iommu_domain *parent,
>   void intel_svm_check(struct intel_iommu *iommu);
>   int intel_svm_enable_prq(struct intel_iommu *iommu);
>   int intel_svm_finish_prq(struct intel_iommu *iommu);
> -int intel_svm_page_response(struct device *dev, struct iommu_fault_event *evt,
> +int intel_svm_page_response(struct device *dev, struct iopf_fault *evt,
>   			    struct iommu_page_response *msg);
>   struct iommu_domain *intel_svm_domain_alloc(void);
>   void intel_svm_remove_dev_pasid(struct device *dev, ioasid_t pasid);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 505400538a2e..46780793b743 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -922,7 +922,7 @@ static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
>   }
>   
>   static int arm_smmu_page_response(struct device *dev,
> -				  struct iommu_fault_event *unused,
> +				  struct iopf_fault *unused,
>   				  struct iommu_page_response *resp)
>   {
>   	struct arm_smmu_cmdq_ent cmd = {0};
> @@ -1467,7 +1467,7 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
>   	struct arm_smmu_master *master;
>   	bool ssid_valid = evt[0] & EVTQ_0_SSV;
>   	u32 sid = FIELD_GET(EVTQ_0_SID, evt[0]);
> -	struct iommu_fault_event fault_evt = { };
> +	struct iopf_fault fault_evt = { };
>   	struct iommu_fault *flt = &fault_evt.fault;
>   
>   	switch (FIELD_GET(EVTQ_0_ID, evt[0])) {
> diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
> index 50a481c895b8..9de349ea215c 100644
> --- a/drivers/iommu/intel/svm.c
> +++ b/drivers/iommu/intel/svm.c
> @@ -543,13 +543,12 @@ static int prq_to_iommu_prot(struct page_req_dsc *req)
>   static int intel_svm_prq_report(struct intel_iommu *iommu, struct device *dev,
>   				struct page_req_dsc *desc)
>   {
> -	struct iommu_fault_event event;
> +	struct iopf_fault event = { };
>   
>   	if (!dev || !dev_is_pci(dev))
>   		return -ENODEV;
>   
>   	/* Fill in event data for device specific processing */
> -	memset(&event, 0, sizeof(struct iommu_fault_event));
>   	event.fault.type = IOMMU_FAULT_PAGE_REQ;
>   	event.fault.prm.addr = (u64)desc->addr << VTD_PAGE_SHIFT;
>   	event.fault.prm.pasid = desc->pasid;
> @@ -721,7 +720,7 @@ static irqreturn_t prq_event_thread(int irq, void *d)
>   }
>   
>   int intel_svm_page_response(struct device *dev,
> -			    struct iommu_fault_event *evt,
> +			    struct iopf_fault *evt,
>   			    struct iommu_page_response *msg)
>   {
>   	struct iommu_fault_page_request *prm;
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index 31832aeacdba..c45977bb7da3 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -25,11 +25,6 @@ struct iopf_queue {
>   	struct mutex			lock;
>   };
>   
> -struct iopf_fault {
> -	struct iommu_fault		fault;
> -	struct list_head		list;
> -};
> -
>   struct iopf_group {
>   	struct iopf_fault		last_fault;
>   	struct list_head		faults;
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 0c6700b6659a..36b597bb8a09 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1312,10 +1312,10 @@ EXPORT_SYMBOL_GPL(iommu_group_put);
>    *
>    * Return 0 on success, or an error.
>    */
> -int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
> +int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
>   {
>   	struct dev_iommu *param = dev->iommu;
> -	struct iommu_fault_event *evt_pending = NULL;
> +	struct iopf_fault *evt_pending = NULL;
>   	struct iommu_fault_param *fparam;
>   	int ret = 0;
>   
> @@ -1328,7 +1328,7 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
>   
>   	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
>   	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
> -		evt_pending = kmemdup(evt, sizeof(struct iommu_fault_event),
> +		evt_pending = kmemdup(evt, sizeof(struct iopf_fault),
>   				      GFP_KERNEL);
>   		if (!evt_pending) {
>   			ret = -ENOMEM;
> @@ -1357,7 +1357,7 @@ int iommu_page_response(struct device *dev,
>   {
>   	bool needs_pasid;
>   	int ret = -EINVAL;
> -	struct iommu_fault_event *evt;
> +	struct iopf_fault *evt;
>   	struct iommu_fault_page_request *prm;
>   	struct dev_iommu *param = dev->iommu;
>   	const struct iommu_ops *ops = dev_iommu_ops(dev);

-- 
Regards,
Yi Liu

