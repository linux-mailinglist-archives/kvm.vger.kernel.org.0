Return-Path: <kvm+bounces-3323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B0D628030FF
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 11:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 402DB1F2103B
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 10:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51E2D224DB;
	Mon,  4 Dec 2023 10:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e3pSmOJx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA0719F;
	Mon,  4 Dec 2023 02:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701687371; x=1733223371;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UhTMWJTu1RDQsw/rTnMr9ZY1ZM9bat7u3V63izIqan0=;
  b=e3pSmOJxcd0m/UPNx1N5QkritT2dRvaNKCAbmqF27kFKqcWViqnHXo8Q
   GtSxP0UgDFf6kqc+7QllJOwE9F7Z2YNAZkX6MI7sHJ3FHIfGhRfA+ywO3
   3kPgdN7rw+DXDhqXk+wqrSAJ6Y4A+dKaPl9TqoY8HbvJH69GLaSYfl1VW
   a+dLyVYXq1wtknrU+90mi0NtMF07YxizkrrbhRRu+a95LeCg1UynQsFIW
   CVXP/8sA381eUAnwO9EL3dmh+h9E2EM1gMBv9y/cyIjqIWcQbQzLGf6Co
   jb38kRIsuPWFp5E7N+baxC+uwsw8oBOC4R8oVvvRRbyt5VRx0P9AzGNLn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="566652"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="566652"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 02:56:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="774216334"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="774216334"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 02:56:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 02:56:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 02:56:08 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 02:56:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WbcDHeG7pIPii+AWigg3kl7bfXDsYh79Re9JYl6EW/J0N1WJnOwtKQZk9UCzamM+zUe9X3xaI1JPVYL6Wv6gWZsWm4yxF83P8p7DYBM6RFcSUQAuu26yky7ne0iaEFTPQKaFOqzdFrdsMnKQDXarZwssXNwhgvZVhVMoqFcgraSP/vtfb4PVFj1DrrP8rtBQty0+pOiaeplj/aPIVvqpU9ANZ1od5RdfOay7tvHPs3baB8TaCZFgglNqQN2wrQ8iaSQJnf7vjkY8p4BRyR4uiPIJX4xKOie/evyxMDt6ZnIePST4BMXXPuPAj0fhBxWDSEHVfC3bO81Y6gErPyYJdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ws14NEzp1AjVeufDRTUcpAXPSftzQEMFbbL508O4Fw=;
 b=BUV1q5PQW/QabXvjvNm2dnAdrrEoyhzPYRKtH4BmJYDISx2SZjgUowctY2V4u0LV8+QL5MvA4RsBDvcqqqepogzJTxQpYpTWtqE9ghszs07UCqkR4Tqra4YfITVR0rNxkb+3zF+EEeWRI3H8nwzVPIGONE7EefWsSr1vz+L2wOKBNGiKQmEe5cSDHlwFhP4jWFrTcG5jTZQMxH+dsCaahgwLGtdqf8POMoEyfIs4zzDR8efDljdrRiMnJNxdjH7VZhnPXKH96qC5Be3JRUfwFfdUgfjpGMp95iRnGEoQma0kgE9OFw9L957EE3/uwvEfLVIV6YSq3QrRm7UYGNYgIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO6PR11MB5635.namprd11.prod.outlook.com (2603:10b6:5:35f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Mon, 4 Dec
 2023 10:56:06 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%5]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 10:56:06 +0000
Message-ID: <50b9684c-e018-4e1c-9aac-67e0ffd9bc27@intel.com>
Date: Mon, 4 Dec 2023 18:58:40 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/12] iommu: Remove unrecoverable fault data
Content-Language: en-US
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Jean-Philippe
 Brucker" <jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao
	<yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-4-baolu.lu@linux.intel.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20231115030226.16700-4-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CO6PR11MB5635:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f5a8f7e-58fb-4765-37a3-08dbf4b79d99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uB3Ehz357cdsBrxA4djae/xmjVAHIjIy9PYIdUcoJobJxYE9OVZvD1ZKVOg6ct6PDI9ntfBPw5hTlwV6x0LACmLw+56eIpdGXRftWIawgzET4eJnrakXoMH6zr4EtA3gsCe7en7elIxAyvtlJlx7ORyzG6J0Dz9ZJ7FDqW2Ac0O0ewexrj/m6vPTNKHZ6YcEZ2RkaWxsgGIjbSr+RnrMbfrAk0lEGguCZzr1dIrs+a75cYkatYNCNcuAEq3fBV0F4OlugfEvC7lHQUBCg7onRDbNf5OArTri/7kcRbhjH6oC9e2VFjg3odfpTkUKYePJo13EKUKxsgcv7gYHdyb1abK2LXIpj2AFO416MxGff4YoZ5UhJ+0SdO1Odqa21OY5RFhxh0ndmfUQ25iZ2ZoCQ/WDUgZsS17Gebc5cbsW6WPuLzEWK41uH+1MrW6ZHZFKnqpHAjvk82+l70wXVazdgHacoV7Y20yeeYW3H9jNsrkMByr52f0MqpbSJf2CJ19yLo3bLHyLI2SgfcDajZCTr23vi8ZtfUQ/0j/JkT85JoXWtsJdKOPkmUEKeZLYJXvg9xCSSEMRMKepokDdvHznVUSgOdMCaZPQaGoxdyHsgZp7yGWu1pwfI7jIclLT71csHWq2iXQeW/B5ZcL/XPyImbyGtEV1Vwuph+pO7HaLXAjBtAD5PiH+wK5iTuEL4lrS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(376002)(366004)(346002)(230922051799003)(230273577357003)(230173577357003)(186009)(64100799003)(451199024)(1800799012)(31696002)(5660300002)(7416002)(86362001)(4326008)(8676002)(8936002)(2906002)(41300700001)(36756003)(2616005)(6512007)(6506007)(82960400001)(53546011)(83380400001)(6486002)(478600001)(26005)(6666004)(38100700002)(31686004)(110136005)(316002)(54906003)(66476007)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2JteGlQbUJnTFdZTWJYb21MNk1WckFwbk9Wd1lUWHNqQzVZbGJVcmVvWW1x?=
 =?utf-8?B?c0pwZ0V3ZmZNR2VBMlJkZDRTV2h2ZFo0RHJPK2RPT0wyMmV1VncvbUYrTVZB?=
 =?utf-8?B?WFhKUlFCZSsrOUlwMkZNNE5jaWVNaXNjbm5wU0NLWlFmUHArcCsyNWlGTkli?=
 =?utf-8?B?UWt4NUJ4eEE2MGpyaFh0dU9TRjQrZXF4Ri8reGovVWtld1A0dzFPckNMejRM?=
 =?utf-8?B?NVpSWWFXZllLaG1ySkZ6ZWFXSUZTK1dYbTZRU3hPdzJIQlJHRnQzWjRybElW?=
 =?utf-8?B?TkdMVnFMN0pETStPazZvYm9ZM2E3WnFaU1FkdS9hWTNZZ2liVU1rQzBmanBv?=
 =?utf-8?B?L041eHlTU1V0bHlTejNYdGJUeTYyRzRkUUZpWGIyT0NyYnp0QTg2RlBlSnRw?=
 =?utf-8?B?TEY2b1NwMnh1MkhVbnNrZnBibWRRUFZIV0V0RXRKUGllYUhIMzlvT1hOQXdJ?=
 =?utf-8?B?eTloODFPazN6by8rUmhnQVlnRllTbWhlUEp3MXZ0QUpvN0VYQjVoUWQvSkJ4?=
 =?utf-8?B?dTJaVHpGRWVZYWVzdUZON1UvcUM2ODNKbksxTUVzWUliUDI5T2JFTU9ZT2dy?=
 =?utf-8?B?UzlqSzF1TGVsSXBLY3VSem5aUncrSFpkYnpzdUYrRWNsTVhOZmVsK3dnTWRk?=
 =?utf-8?B?MkdUUWJidU5xcW5pRjNwdmhCejREcFR6SWpRd0g2cVZCVXZadzFFbFdqS3gz?=
 =?utf-8?B?VThDVEVnUUlFK3d5eEVuYWh3Wk81a0tjWlNPbTh0ZjFYeTJJVENFemhlU21n?=
 =?utf-8?B?ZjBoSjBZRU9DNzNUNzRBZ0NkOUNwQm1Sc3U0dHF1Si9mazdsdjdoZHRCcGlY?=
 =?utf-8?B?c1pySUgzclgyVlNUdHFYb2oxdmlwVjV3S2llUFBoS0dXV3hNZkk1S2VjYnJo?=
 =?utf-8?B?YVNrL0piRDh1Zk8wSHBhZFBaMS95NXRUUUtKMThaeFZLUmhta1VHdi9mZVVj?=
 =?utf-8?B?SVVxc0dnckdJbVdJQkJuUDBPSGRYa1hMTmNPeUZPZXR6ODNXTDZ5NXpKNGJ3?=
 =?utf-8?B?UDJWWWF5L3VzUDNqT1hCLzZaaXhDN2h2amtzMVFKeWJWRzRIakhxU0NLYlV6?=
 =?utf-8?B?TllDekNoVnFwMHlGdWNTanpPRWlSVzdLNjN5WDlDQ0tya29lM0NCQWJtRG1p?=
 =?utf-8?B?aWNuSGFzcFAwNDhBZHNiVHltRTh1VWZyTWcyL0JocEZxOGZveVBDNysrSm5K?=
 =?utf-8?B?SkJTTmlBR2xmV3RJV2g2Q2JyeU5mOWhhNWpaWkRUcWNLc24xNGZ0UXdIVzdL?=
 =?utf-8?B?K2dDVE94RmF3NmZ4WVBzTmtIcTBWYjd1S1NOakp0ME9GWTNWOGJFam5iemFX?=
 =?utf-8?B?M3k4YWhkSm1RdkJCVUE3TE9pS1N1WHRjUDV2ZC9yeHdieUI5MDZ5Q1VvOSt0?=
 =?utf-8?B?T2hiRlF1R2ZuZEZ2UVU0YzZSc1Z5TVJyc0cwaERKVVZ3cEd1N2VHc0lTMkJB?=
 =?utf-8?B?emNMZGprbE5teG5zNUQ3RVc4Y1F1ZVdUY3EzWGFETmlaNjN1cW8rcVpSSlo0?=
 =?utf-8?B?MGROV3YxeHVmOFpFSHcwdjNhWWVMWUFRSVVXWVBGQVJWUkJGby9TaGhqdUlI?=
 =?utf-8?B?Y01zdERvdm9KZGF5Rk04SnFIb20wQmR2WVo1WG5yZXdCQWFLTnVFblhDNXNq?=
 =?utf-8?B?MlJaVnFhWHBGdkkrMHNCdWNEc0EwblR5bVhhVjZwU080dzFSTFhNUXNYekV0?=
 =?utf-8?B?TStkY0FwTlNOVzBVemJzK2ZxR003eSsxcVphZDcrU3VVVTYvL3Fjc2l5WnRV?=
 =?utf-8?B?LzhGUjM0RFFBQTNhdGRYVzhESlF5ZndmQnlkd1RjOGovTU5yYm84SEpCMis1?=
 =?utf-8?B?YUk2cTZBdlJKM3Btd01mYktzcG5KSTZaVFowZGp5Y3k3YjBCOU9GME1yYVhK?=
 =?utf-8?B?dm9KSWxURUxBVnlYTG5nMWZMK2xaYzF3TG5WNURmMisvbU8xcUJna3RkU1Jo?=
 =?utf-8?B?bXdoRUdBMEhSUmd5NkhVN0loMjdRS3lpRTlwci9OZnpTWExoZU5xY3luMGo4?=
 =?utf-8?B?bkdxWW5KUGVvWG0ySGszc0pYMmFPcUIyNnJTSjlFTG5GbmlaL0YxREFXa09S?=
 =?utf-8?B?akZlL1lrOUdQMytJSlBuaTdHcGFMemgyMnpxWHBCT3J6dCtGakd2WWNjYVNh?=
 =?utf-8?Q?j5H4ZCA0RWpy27yfipc0O5ZA4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5a8f7e-58fb-4765-37a3-08dbf4b79d99
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 10:56:06.6311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 54klkG4HIa9UQJhYcU+7pa7NrQ9XfBoR+L7L8NWPyS9uO0txVuZPvlAYUgVLxvQ75NLBNaIytjxzJbCComBhvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5635
X-OriginatorOrg: intel.com

On 2023/11/15 11:02, Lu Baolu wrote:
> The unrecoverable fault data is not used anywhere. Remove it to avoid
> dead code.
> 
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   include/linux/iommu.h | 70 +------------------------------------------
>   1 file changed, 1 insertion(+), 69 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index c2e2225184cf..81eee1afec72 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -50,69 +50,9 @@ struct iommu_dma_cookie;
>   
>   /* Generic fault types, can be expanded IRQ remapping fault */
>   enum iommu_fault_type {
> -	IOMMU_FAULT_DMA_UNRECOV = 1,	/* unrecoverable fault */
>   	IOMMU_FAULT_PAGE_REQ,		/* page request fault */

a nit, do you kno why this enum was starting from 1? Should it still
start from 1 after deleting UNRECOV?

>   };
>   
> -enum iommu_fault_reason {
> -	IOMMU_FAULT_REASON_UNKNOWN = 0,
> -
> -	/* Could not access the PASID table (fetch caused external abort) */
> -	IOMMU_FAULT_REASON_PASID_FETCH,
> -
> -	/* PASID entry is invalid or has configuration errors */
> -	IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
> -
> -	/*
> -	 * PASID is out of range (e.g. exceeds the maximum PASID
> -	 * supported by the IOMMU) or disabled.
> -	 */
> -	IOMMU_FAULT_REASON_PASID_INVALID,
> -
> -	/*
> -	 * An external abort occurred fetching (or updating) a translation
> -	 * table descriptor
> -	 */
> -	IOMMU_FAULT_REASON_WALK_EABT,
> -
> -	/*
> -	 * Could not access the page table entry (Bad address),
> -	 * actual translation fault
> -	 */
> -	IOMMU_FAULT_REASON_PTE_FETCH,
> -
> -	/* Protection flag check failed */
> -	IOMMU_FAULT_REASON_PERMISSION,
> -
> -	/* access flag check failed */
> -	IOMMU_FAULT_REASON_ACCESS,
> -
> -	/* Output address of a translation stage caused Address Size fault */
> -	IOMMU_FAULT_REASON_OOR_ADDRESS,
> -};
> -
> -/**
> - * struct iommu_fault_unrecoverable - Unrecoverable fault data
> - * @reason: reason of the fault, from &enum iommu_fault_reason
> - * @flags: parameters of this fault (IOMMU_FAULT_UNRECOV_* values)
> - * @pasid: Process Address Space ID
> - * @perm: requested permission access using by the incoming transaction
> - *        (IOMMU_FAULT_PERM_* values)
> - * @addr: offending page address
> - * @fetch_addr: address that caused a fetch abort, if any
> - */
> -struct iommu_fault_unrecoverable {
> -	__u32	reason;
> -#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
> -#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 1)
> -#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 2)
> -	__u32	flags;
> -	__u32	pasid;
> -	__u32	perm;
> -	__u64	addr;
> -	__u64	fetch_addr;
> -};
> -
>   /**
>    * struct iommu_fault_page_request - Page Request data
>    * @flags: encodes whether the corresponding fields are valid and whether this
> @@ -142,19 +82,11 @@ struct iommu_fault_page_request {
>   /**
>    * struct iommu_fault - Generic fault data
>    * @type: fault type from &enum iommu_fault_type
> - * @padding: reserved for future use (should be zero)
> - * @event: fault event, when @type is %IOMMU_FAULT_DMA_UNRECOV
>    * @prm: Page Request message, when @type is %IOMMU_FAULT_PAGE_REQ
> - * @padding2: sets the fault size to allow for future extensions
>    */
>   struct iommu_fault {
>   	__u32	type;
> -	__u32	padding;
> -	union {
> -		struct iommu_fault_unrecoverable event;
> -		struct iommu_fault_page_request prm;
> -		__u8 padding2[56];
> -	};
> +	struct iommu_fault_page_request prm;
>   };
>   
>   /**

-- 
Regards,
Yi Liu

