Return-Path: <kvm+bounces-3463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E24B804AEC
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 08:11:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81C7A1C20DB6
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7984E15EB9;
	Tue,  5 Dec 2023 07:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mFDtH0Iz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7334127;
	Mon,  4 Dec 2023 23:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701760250; x=1733296250;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WUoXV3LiA1AX+Mdy1iD19dss22c4yYCj9JL9vFJ22S0=;
  b=mFDtH0Izfj+1Guo4N1ierLQ7oqkuV3G0pMn52vlAEoFCzB1tL65ZTECo
   BygKx048oQb6DI/sV+8kAK0Qxrm68AY/ZPbouUbpN+/nwMfwWRpevY/u3
   9L60ISeIFENvoEi1GgRDH9qf66K+BjF8iRDQGid9L0ywKXftjR7+UNc9g
   ZewYM6QhpgV7wQJRmAyU+eD/wh68ADXfNTSuKeA6w6y1UYw8fHl5u9Qqg
   sydp3kpnzI1QI6w3lHc+W1A6dFI0fvXey2dBr8WrrUjOI3epe5XwO028s
   Nd/N+AyE6Mq7Tb2N03nGSH4wrMBvsIyhxyB8wB7K6C1U/1oAnaKOITQ2x
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="15402744"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="15402744"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 23:10:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="764233430"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="764233430"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 23:10:48 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 23:10:48 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 23:10:48 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 23:10:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHoBTwM3V6SpxYq+wzmS101XustZQE97bMb1QGuL6/eql6+3A3yMrA7XNvHpDxknE7w976KgVNl2o4ircjcHmZ/gQwyIIKDaHs84IyNBRRhFeMPP6t1HrqPVDNIr4CJ6gAEgO7bZDhkgeKp3DGUaEqwo3Ty+Xq5/sK4aCimLVIVHxGiohpfGnJjIrSwHjXAXzFjCkCp1yacfaNUIeh1lQKOUTZ4zzxu/T0eBm/G9783DbDpPn9H5zkCnkFebD19wi0XCc0jatoc0otHa/Ljr9GKQJNJQxeCsWQ1+vOUC9yyXN6k7O3DZOk1CqcYRAjZQa9t49QK4qWjq9WFp26x5tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTeD0l1NVVpYA0TACnUNI6uxkFzeCYWyo14I9jAkIPM=;
 b=kgHYgh21HML1USxsZ8kfoNivvMlCCFs61HcNy+equGGySub3FL5nnIcz3e9Stq0G1rji7wvyHD6uJES6hWp5Pw+NOfqUpVqt2ylbAp8caUZKA4v7GgDufIVh1KtjLSAU3S8X9jD+4mvlE7EE/1MAf3BpVeT2q2E4ZyhF1f0MFm1jb2l3YCu7kEy0KMrEKRdZA8DzT9FfKZfJwm3LmxEUIc5QYQEfuxnv0Tm/+t+0p7m+kcxiCY6BvbPGoC8Qj4QIiaaQnJ9C4ohJWe0kINfkiJ2lpZSaXeEXBzybKMESiA/8yd8SInWROM7YhTSgTZLAH/7wIRKJVwdugUYGKZQWpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB6142.namprd11.prod.outlook.com (2603:10b6:8:b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 07:10:46 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%5]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 07:10:46 +0000
Message-ID: <e18c7c93-7184-4bbc-97cd-61fc0bc0aa3d@intel.com>
Date: Tue, 5 Dec 2023 15:13:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/12] iommu: Make iommu_queue_iopf() more generic
Content-Language: en-US
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Jean-Philippe
 Brucker" <jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao
	<yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-10-baolu.lu@linux.intel.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20231115030226.16700-10-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0027.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::7) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM4PR11MB6142:EE_
X-MS-Office365-Filtering-Correlation-Id: 4740c670-7ecb-447a-b33e-08dbf5614d72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: As7UvnZ6fI7SyKE/ujSm93EMJE4i4dYDMxVN3aJA6Py2WVbe5gbRpFCqwuHYxoRVKwl+o0J8Wphr4cVq697F2i7I/L+sx8lTgM2MiO7sl3ZzEudI8qC0ZRmmrfyQWnjQzdfgzm9hx+5/T11gW7BpnhJGPOlBCRb2V7+l9cnvdc6xNaaXXWADNg9vepvrvholcNTRAsLTKPtW7pU/UlWwAYi9xjsSMC5uZchCNiuzkd4ROg2NzoRQlUjGJ5y0wOBfmoLcYwtwZeS5xIkoc+qyRjZ6sLJpjcMOntmXgHdVHkqvsBarsYpEjEdfviiZJRo/8syr+vQ7trM6Zo1InOizwljae8LCnsFlZWM3/RFP8qzjaAPqwKEwgMZ1AVjgMPDIlpAuy33JVAIN137nqSN0Q14s64ffGwQAvBA6TFEMVtjwU5OtfuWZp0K47QdtQe5VY4WoYudhFjqiIXSCQGi7myNQQc7StXhGKcUtvo/O+PzLPWngLWTcj9TNnOJ7HhQLyW1VLbc6bovesskQHkDpkiv5OH9QoB3ktfp+jrD+QKrCELlg6JbMcpMXER/kxGlXGey8K69rVZmCwYD0M8aeUKU53nNs/zznHPSsu1Wa0Q4L+xBNMeHoGsddfPA39JOlA3yevmOU250yWf0czImYZ/CDZVfdFk6IJ9DNCQfMwC4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(376002)(346002)(39860400002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(6486002)(83380400001)(478600001)(6512007)(2616005)(53546011)(6506007)(26005)(6666004)(316002)(110136005)(66476007)(54906003)(66556008)(66946007)(86362001)(8676002)(41300700001)(36756003)(4326008)(8936002)(7416002)(2906002)(31696002)(5660300002)(38100700002)(31686004)(82960400001)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emVhei9PYWZQTkFSUlJRZG5ISVRETFE0SC9XRzBZd2Z5V0xNUzBzSEdLdmlZ?=
 =?utf-8?B?N21xTmIxRFo3R3l1WlJmUmJEOGd1RllJbzN1N3phTlljMWdVSDdoelF5K1JN?=
 =?utf-8?B?ZnptUGdUVzlZL2hIeGRxakppYVRJcGF2Q3NEcWMxYytwdS90MFowa1BOREVx?=
 =?utf-8?B?ZFllNlAvcGZzdkhFV0ptd2JTREFtcUhWU2NLZ0VjZHdwVklEUEliaDI2S3pZ?=
 =?utf-8?B?N1hWMW5qNlRqNW8wS1VscTU5UzhZL0JjSUZYd1NGcXR3SytOVTEwUDE4Z2ln?=
 =?utf-8?B?VG5la25ENHpFUGFaWk1yem00ZDFuWHZVdFYwMVlkd1ZKTHBDalBLM2xwd3pD?=
 =?utf-8?B?RWhaMlQ3OXFET3FFNXZzMEhsUlpCQTBFUFhaQVVBdVQ1aHNYbnQreTU1cXNj?=
 =?utf-8?B?eElpclE3bURtYVI1QjFFNG9Zb0JKNjJwenFVbzhlYlEvZkVRVm44Z2NJaXgy?=
 =?utf-8?B?eTFIeXNueEp3NHlVTVNzdVF1WWJ1Mm5mdS9zdXBhUW1WU3pMTEM3NjR1aHRz?=
 =?utf-8?B?bW5aSmNrR0lCdHR3MXBDb3d6a0IzSnBzdUd6NXFENTQxQk41ZG9veU1hSW1u?=
 =?utf-8?B?R2tlL0g3Mzg3WjNObWt1dnl0bTdpTGx6Tzd4NzdlMkh6QnlQRUtId1I2T3Yy?=
 =?utf-8?B?YkY4Z09sc05lTENUUllqOVNuTXJweWlMQ2FXdE85ZGVDeEF1alJ6dGVBcnJ1?=
 =?utf-8?B?S3lnWndTbkttTFdnNEZGeUpuNkFGNS84T2IrVU52KzdMdkFaUVdoc015QkdL?=
 =?utf-8?B?MFdmK25JS3g0VEk5VG5ObURLbzVhRmg2Q25UOHhoaE92NXV5dkxPbGZqOWtV?=
 =?utf-8?B?QXVueS9OekZOMGxIU3JyQVFjWXFMcSsxT1g2Y0RwQk0zVVlwVTd2end0dkRi?=
 =?utf-8?B?OFZxdXhkeHBxQlV6WXFEUjhCK3YzZDdsbzZ2RDN4RGVJY0xLNkUvNUFMcGRp?=
 =?utf-8?B?WE8wSTUrWEdaaE4rRWJnSzMyc0EwYVYzQnhmTEUxUW1GS1RaTUEzb1NxcUo1?=
 =?utf-8?B?VUNucDQ5c2cwOVBrNlVFQXVpQXpqWGdWZTFQL2hmRnVKNWVyUlhoYXZITEtE?=
 =?utf-8?B?SFlyZGpTUEJPZHR3RlFuWDZuekxUTERTTXYrV2VGeGxrd0R5aDczQ25FT2VG?=
 =?utf-8?B?anp0cURKNjJzdnZXOXVkSkR5ekU1ejJkaVBKZDNLUy9rdzlYanJnV2w4TW5y?=
 =?utf-8?B?ZGxUMFZUWE52TWF2MWRKQnhKQlkxbDZobXI5cndrNnFmQkRXQmREaHM2WGl6?=
 =?utf-8?B?NGgvZG04RW9SUVF1MGpDNDNYRjNQUjZNeTRoSWswVGZ5Q2JnRkJIZ0svQ29Z?=
 =?utf-8?B?QmlxMksrTXM3SFZTR2loSmhWQnJ2Z2tLRkNYNFNvMXlBeStvVTBodVNjUk5N?=
 =?utf-8?B?dys1QTJBdVAySzkzYWdjdkx4UGRpRUtDcmk3RUtMT2lxenRha0NHR2kxZE5y?=
 =?utf-8?B?WVZxSVZMRmc1SEpxRHNQNG44UVh4VjFYOW4xOHpYZWdWaFB2c204dkZKRHNZ?=
 =?utf-8?B?VUQ4Wk81OEdiMGZvUVlwWUtJZmVIN0Z1dW9IdmRMei90V2ZJOVNBTEN3VW5i?=
 =?utf-8?B?OFR2Z1ZBUnZxc0dRU0VxTk92RElWbnJ2cVoyZno2SHJ1Z3lsTHo1bnN4MHo3?=
 =?utf-8?B?Zm5oZW5xNWhMQ1ZNT3hZMWRnM25sZHkrQ1plcGhCTis1UFFnMlJzeCtwLy8v?=
 =?utf-8?B?ckJhVndXc1k3Z2NSdnRPOXBvbUJMREs5NUJSSTBJcmtpZFlmRzdvVVUxcjNq?=
 =?utf-8?B?MUVUQ0xvci96T011a1RSdzZCRmJjMlZsVFVaOVQvaGx0dnYreTBoS0FCdFBx?=
 =?utf-8?B?MFZJNlprMWJGMnJQMWVKN0NuazVqc3JKMUd6bWU3RVlCYWpiR3pUNkkrRHpY?=
 =?utf-8?B?RmY3NUxDbkJ2RHZTanFpclZkM0lRS2FlN1IxR1JwSjBLRDFndHU3b3BGRzM4?=
 =?utf-8?B?bkc0OWpJenBOTCtKRzFicnE5U0E5NDIvL2hzSXJQbEVMMk9ZSjdRNzdQUmpk?=
 =?utf-8?B?Z0JoWitPQTA1OHJBb1kzSHZhWE9VMzRVdGZDQnQ0Ty9vWUd6L0EyVXlyY2Y4?=
 =?utf-8?B?bGcxWURZMmZHMmhWTVF1M0x0S0ZjaTdBdnpZcFh2bGVLWFBtZ1dLUjlIZ1JG?=
 =?utf-8?Q?IwzmggE/x1zrUiRDONJDnwfXa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4740c670-7ecb-447a-b33e-08dbf5614d72
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 07:10:46.4180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhMfg6mzJMVs2IZMFumDJ34h49vLHYfVppc6vk0Mi7Rlt11/4Ws3uUzuHasGHIEs9V7ROc1JeKCWba/gtJ6GWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6142
X-OriginatorOrg: intel.com

On 2023/11/15 11:02, Lu Baolu wrote:
> Make iommu_queue_iopf() more generic by making the iopf_group a minimal
> set of iopf's that an iopf handler of domain should handle and respond
> to. Add domain parameter to struct iopf_group so that the handler can
> retrieve and use it directly.
> 
> Change iommu_queue_iopf() to forward groups of iopf's to the domain's
> iopf handler. This is also a necessary step to decouple the sva iopf
> handling code from this interface.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   include/linux/iommu.h      |  4 +--
>   drivers/iommu/iommu-sva.h  |  6 ++---
>   drivers/iommu/io-pgfault.c | 55 +++++++++++++++++++++++++++++---------
>   drivers/iommu/iommu-sva.c  |  3 +--
>   4 files changed, 48 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 0d3c5a56b078..96f6f210093e 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -130,6 +130,7 @@ struct iopf_group {
>   	struct list_head faults;
>   	struct work_struct work;
>   	struct device *dev;
> +	struct iommu_domain *domain;
>   };
>   
>   /**
> @@ -209,8 +210,7 @@ struct iommu_domain {
>   	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
>   	struct iommu_domain_geometry geometry;
>   	struct iommu_dma_cookie *iova_cookie;
> -	enum iommu_page_response_code (*iopf_handler)(struct iommu_fault *fault,
> -						      void *data);
> +	int (*iopf_handler)(struct iopf_group *group);
>   	void *fault_data;
>   	union {
>   		struct {
> diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
> index de7819c796ce..27c8da115b41 100644
> --- a/drivers/iommu/iommu-sva.h
> +++ b/drivers/iommu/iommu-sva.h
> @@ -22,8 +22,7 @@ int iopf_queue_flush_dev(struct device *dev);
>   struct iopf_queue *iopf_queue_alloc(const char *name);
>   void iopf_queue_free(struct iopf_queue *queue);
>   int iopf_queue_discard_partial(struct iopf_queue *queue);
> -enum iommu_page_response_code
> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data);
> +int iommu_sva_handle_iopf(struct iopf_group *group);
>   
>   #else /* CONFIG_IOMMU_SVA */
>   static inline int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
> @@ -62,8 +61,7 @@ static inline int iopf_queue_discard_partial(struct iopf_queue *queue)
>   	return -ENODEV;
>   }
>   
> -static inline enum iommu_page_response_code
> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
> +static inline int iommu_sva_handle_iopf(struct iopf_group *group)
>   {
>   	return IOMMU_PAGE_RESP_INVALID;
>   }
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index 09e05f483b4f..544653de0d45 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -13,6 +13,9 @@
>   
>   #include "iommu-sva.h"
>   
> +enum iommu_page_response_code
> +iommu_sva_handle_mm(struct iommu_fault *fault, struct mm_struct *mm);
> +
>   static void iopf_free_group(struct iopf_group *group)
>   {
>   	struct iopf_fault *iopf, *next;
> @@ -45,23 +48,18 @@ static void iopf_handler(struct work_struct *work)
>   {
>   	struct iopf_fault *iopf;
>   	struct iopf_group *group;
> -	struct iommu_domain *domain;
>   	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
>   
>   	group = container_of(work, struct iopf_group, work);
> -	domain = iommu_get_domain_for_dev_pasid(group->dev,
> -				group->last_fault.fault.prm.pasid, 0);
> -	if (!domain || !domain->iopf_handler)
> -		status = IOMMU_PAGE_RESP_INVALID;
> -
>   	list_for_each_entry(iopf, &group->faults, list) {
>   		/*
>   		 * For the moment, errors are sticky: don't handle subsequent
>   		 * faults in the group if there is an error.
>   		 */
> -		if (status == IOMMU_PAGE_RESP_SUCCESS)
> -			status = domain->iopf_handler(&iopf->fault,
> -						      domain->fault_data);
> +		if (status != IOMMU_PAGE_RESP_SUCCESS)
> +			break;
> +
> +		status = iommu_sva_handle_mm(&iopf->fault, group->domain->mm);
>   	}
>   
>   	iopf_complete_group(group->dev, &group->last_fault, status);
> @@ -113,6 +111,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>   	int ret;
>   	struct iopf_group *group;
>   	struct iopf_fault *iopf, *next;
> +	struct iommu_domain *domain = NULL;
>   	struct iommu_fault_param *iopf_param;
>   	struct dev_iommu *param = dev->iommu;
>   
> @@ -143,6 +142,23 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>   		return 0;
>   	}
>   
> +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) {
> +		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
> +		if (IS_ERR(domain))
> +			domain = NULL;
> +	}
> +
> +	if (!domain)
> +		domain = iommu_get_domain_for_dev(dev);
> +
> +	if (!domain || !domain->iopf_handler) {
> +		dev_warn_ratelimited(dev,
> +			"iopf (pasid %d) without domain attached or handler installed\n",
> +			 fault->prm.pasid);
> +		ret = -ENODEV;
> +		goto cleanup_partial;
> +	}
> +
>   	group = kzalloc(sizeof(*group), GFP_KERNEL);
>   	if (!group) {
>   		/*
> @@ -157,8 +173,8 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>   	group->dev = dev;
>   	group->last_fault.fault = *fault;
>   	INIT_LIST_HEAD(&group->faults);
> +	group->domain = domain;
>   	list_add(&group->last_fault.list, &group->faults);
> -	INIT_WORK(&group->work, iopf_handler);
>   
>   	/* See if we have partial faults for this group */
>   	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
> @@ -167,9 +183,13 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>   			list_move(&iopf->list, &group->faults);
>   	}
>   
> -	queue_work(iopf_param->queue->wq, &group->work);
> -	return 0;
> +	mutex_unlock(&iopf_param->lock);
> +	ret = domain->iopf_handler(group);
> +	mutex_lock(&iopf_param->lock);

After this change, this function (iommu_queue_iopf) does not queue
anything. Should this function be renamed? Except this, I didn't see
other problem.

Reviewed-by:Yi Liu <yi.l.liu@intel.com>

> +	if (ret)
> +		iopf_free_group(group);
>   
> +	return ret;
>   cleanup_partial:
>   	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
>   		if (iopf->fault.prm.grpid == fault->prm.grpid) {
> @@ -181,6 +201,17 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>   }
>   EXPORT_SYMBOL_GPL(iommu_queue_iopf);
>   
> +int iommu_sva_handle_iopf(struct iopf_group *group)
> +{
> +	struct iommu_fault_param *fault_param = group->dev->iommu->fault_param;
> +
> +	INIT_WORK(&group->work, iopf_handler);
> +	if (!queue_work(fault_param->queue->wq, &group->work))
> +		return -EBUSY;
> +
> +	return 0;
> +}
> +
>   /**
>    * iopf_queue_flush_dev - Ensure that all queued faults have been processed
>    * @dev: the endpoint whose faults need to be flushed.
> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
> index b78671a8a914..ba0d5b7e106a 100644
> --- a/drivers/iommu/iommu-sva.c
> +++ b/drivers/iommu/iommu-sva.c
> @@ -149,11 +149,10 @@ EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
>    * I/O page fault handler for SVA
>    */
>   enum iommu_page_response_code
> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
> +iommu_sva_handle_mm(struct iommu_fault *fault, struct mm_struct *mm)
>   {
>   	vm_fault_t ret;
>   	struct vm_area_struct *vma;
> -	struct mm_struct *mm = data;
>   	unsigned int access_flags = 0;
>   	unsigned int fault_flags = FAULT_FLAG_REMOTE;
>   	struct iommu_fault_page_request *prm = &fault->prm;

-- 
Regards,
Yi Liu

