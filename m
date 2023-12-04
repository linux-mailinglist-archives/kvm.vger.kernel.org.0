Return-Path: <kvm+bounces-3332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B5B78032E4
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 13:34:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EB5E1C20A76
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 12:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854992420A;
	Mon,  4 Dec 2023 12:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OzBfqnRc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205261AE;
	Mon,  4 Dec 2023 04:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701693264; x=1733229264;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tWWDOaabP3U4LIBAUOfLj6WxgwjyaUAehqw5t1a7tIE=;
  b=OzBfqnRcNzJiPo76ChWg/O4GFmUXYg3PpEO3qYloVoepNPoroFj000vh
   8nbLq9Q4HKnxtCRLhHq4NM8TN7UmrsAZ9bqU/zxB5hrE7DTM6oYxr3vUK
   NMoDa8w0Vr6gXUoPHEMTzsfW8B38hvc43UEavBbPHCCyKPMH/WlOzoggU
   j3uhR/nGhq0+4QPlUJG82Vn5NdhhuITZBOjMxZ0SqgfG47ERvXIGa5v/0
   kCqAnzY0ftfgyb0NaEQ8ds+IsRd3mGJNWv010i5mGXRbz7aXjDiYo4k14
   zg6BUxCPGOPVVh1l0vlYWYZWYVDcRBu0itlphY16Es9fBq4pEx2twFS5t
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="384128082"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="384128082"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 04:34:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="720304920"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="720304920"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 04:34:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 04:34:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 4 Dec 2023 04:34:22 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 04:34:22 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 04:34:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Guo0zDF9OxyLv/Rmk5tbhQ8JJEbQiEM7oYbHqwQNN5A153o51UT+onRtS3dyviOrFwGp9W5PGcX87L6K3qLZqhGzbuWo6VwUNZ0cBNV+c6deS2W/S1TJxneGbA+jRJVhFS60yrcriyTbeDEV4eEDmhsH2RD03ix5ozYLanQWGRXbEjg9VoHnZ/ghTJ4XINi5pDmtvbmG8kIPQe0jzKy3FhweBZ32lUbdDp4xtgt9g1SnxwjGkUxOrEMQ7Pjza4dIeaKfPFHRcvvUdYe8rcOMv9KYBacrIjxRU64SH2rPDYWbQVz80vJf54LShfFPJuyvDkX7a1SHXtKHc0DObZgftw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61VYaUfrHwKmo3ZcaWO1XCNtD8IFPyLldzsHEn5JVHA=;
 b=LSBjCKyp6sZbbB9a2G4B9zLA62uuKI/7jVTJr3Pymmb5619Aepw4uoUv+kLHbhzi2gKr2j+TefkcArTmHWgJ+8/Njq6nJEeavbINQW7ybJk2W3j5tkYtMbCa18ZsZ35Z4LjBZibc6FKLN/eCddeooP5NHn2pqxi5aVULujXizeyCxcjdVeC0zuagoEb9/TKjeDvFbDLHDH6L2+6CBQCL7fHL6B+RXYOPX6NsXyaYSwBva2HfwHt4i1uGjF8xwXe3DMwvfrGLMVqDDTaehk+ll3aaZSqGQNZ2p2JR68bU7HJ/uEFcjbQl6Kz1t7J1IjDySxybJ31pMdDzTlnSUsnx2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB6851.namprd11.prod.outlook.com (2603:10b6:806:2a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 12:34:20 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%5]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 12:34:19 +0000
Message-ID: <2516df8c-6d2a-49f7-bbea-123d0763bc00@intel.com>
Date: Mon, 4 Dec 2023 20:36:54 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/12] iommu: Remove
 iommu_[un]register_device_fault_handler()
Content-Language: en-US
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Jean-Philippe
 Brucker" <jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao
	<yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-7-baolu.lu@linux.intel.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20231115030226.16700-7-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:194::8) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SN7PR11MB6851:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a663908-b239-4e74-1c04-08dbf4c55642
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kXgp7q40aHuSGqh3tA5rmwoHEHoZVwRT/mW5l0syT0Zvcjl2ZG1Mm6bc2PWZf0NOZctd+equHxJXkQbkNzKYezmQ/rAdo8Qu4OvRUvgqqLxjZaNNWqy75pKPJjUdY9WemNd/rEJoVKPUywz6AgSrHjjlzSDD5GCz8uRlYTMr4+RU56+zVMU8Y4Jd/TtvwGQ0MiOPc0d02BPj2OaqEJ97W6zF9ik/ZXzcwOVevVL1Lz7wQCoNiW6SLG8wD+iUk/FTOgSLgv6hvHpXW3T5Iw0x+Ua+oZKQEEGRgvPwPhKCL4cEB6FDfcz2ZZi0tKHnE8RSvtqnhhNBz65KszutyWYdWNmWlsrpp3c+tUNc9mwIFc0o39iVPBCionvSmgTy0+9MoivgvsldDYPqqicnG80HXsPOmNrtCj/Tu9Ep2zKIgxMGDQ4IgnFvBNr5KPBOYR5x0L9j1Ft/Gd7+bd9lo2nSNy4uI/FnAgGaEBRvIWOUDAK9QRYpRzhdqpnEI8aT6EVQU5x51u8qoldcODU4TS4+LqRaPCUXPMuUZVxRdNvDpn+J/rWxoKi/ab4lbqoiWPmbInnqSmAiRyQuLklTcEp3mKoiasZWN4ambeeVe8vzZuWJnSn/dbWEyUMJ7vw39SMJjot737f0lXr5CuO+WMSo3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(396003)(376002)(346002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(478600001)(6512007)(2616005)(8936002)(8676002)(4326008)(38100700002)(66556008)(66476007)(66946007)(54906003)(110136005)(316002)(31686004)(26005)(83380400001)(6486002)(6666004)(53546011)(82960400001)(6506007)(31696002)(86362001)(5660300002)(7416002)(30864003)(2906002)(41300700001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UC9FbUl0L1hwaWhUVlNSTE9vMDRTT0VuNTloNXAxblBLK28zUUY4YVlNM1h3?=
 =?utf-8?B?L3VBam9GTjVqQ2JuSjdWN1lESEFzNGM0Mk5mUk5KbXNXWlZlSU9FOFZrMDBO?=
 =?utf-8?B?YjArQUhBN0kyTnlJQzRtaHBkbXpnQU4yMVQ4VWdvM1FzcUk2TTZvaTJGVUdS?=
 =?utf-8?B?VmNxT042dWlLb0x6eGJJQXFQYWhZVHd4VnhUYXRZQkxFUGlDeGpyWm9VK1Qw?=
 =?utf-8?B?SFlVZFoxMkdURStSZm9PWXdMQ0Zuam5ZMUNJUmhKRTBUZDJFWFp1MFlxN2hJ?=
 =?utf-8?B?UXltQWtRNW9QNWZoVWlYb3I3aVVhTVRBL2RxanRTWFh0TExaaXdOL2tsNUll?=
 =?utf-8?B?cmppU1dQdERhOUN6STJUakF0am1aN0FTVzJobStDQUk2azBEVWRTUWRHMWVO?=
 =?utf-8?B?NWdtZVZLWEZzWDRFTXp3OFg3MUIyZ2Jud0lEeFFYQndOem51Zzk5TS9wanpQ?=
 =?utf-8?B?Z1lpUytIQjhiRVRJNGpWekZ3QzJrVEFIUGNLZHRjc3BacjV4NVJYQm1FOTNy?=
 =?utf-8?B?K09kWk5HS2JTTlMvYUFsRDZaWXdkL3VKY0RzaHBKbWtYZnp5My9uaGhRcG8r?=
 =?utf-8?B?Y0NRMkNaMjQ2b1FJUmgyYmxzbWFxa1U3MytKcnVnYTZxeDRVZ0JoZk8rT0ZR?=
 =?utf-8?B?eTlESmdWbDFxMjZ4dWdkLy9UbnV3SUk1M3NmUUVHNm9KNFZoMjV3OVFBU1Vs?=
 =?utf-8?B?UzJndmJXQjdBd1hLdWExSTQ4djFzdU9YdlZpcHFBK1FuRmdFODVyaFduNkJx?=
 =?utf-8?B?dzlMb0U3SXB3Zm40OFN2UUtVYlhCb2RhTWUvUWptVEY1YXcyNGI3TEtRc1Bj?=
 =?utf-8?B?SkpYaGtWbjkvM2YxbVNaZE1YU0tMeXlram94TjNpOEVjcFRIVVVhWGE5Wm93?=
 =?utf-8?B?eVg1U2M3ejJ2TE1vQUJyTndhNWNrSzNxVEl0YmFJVVlzMHBhL2JMa0NxR0tG?=
 =?utf-8?B?blI5VWwzRmFhbWJISG12ZWhVdHZFVkl5NnZsZUppYWlWb0dqaVJtSzV2cCtE?=
 =?utf-8?B?d3duWHp2V3VXb3pBSzhzd3BPOXQ5M2VwVHczR1RFS3ZqTlQ3RDlNeWRMMWVJ?=
 =?utf-8?B?UDZjaFNpYno4UmNZUDNoQWgyMXdHVUUyWkVNYVAwMTN3NTc5S25YSkhZQ2Nm?=
 =?utf-8?B?Q0pGUVdiSGM5UHhyTmluVVpTcHlSKzFucUpnSHQvNVhDUEpnTVFoMWU0QXds?=
 =?utf-8?B?OGRFZUZHVy9TOTBEUnE0bzgxeDJpRDU3eFJVVmZGNGQ2V05XTEVkeExqejdm?=
 =?utf-8?B?blQ1VEhESEg2OGt6ZjV5cE5Tc09SVnp2UnpYNnUvKzJBQnQxdUR2ZEVUMjZZ?=
 =?utf-8?B?a284Q1lac3JBK0NsK2NEUmQ2RU8rVC8ra3ozVFEvWHIxUThJZ2pFdjgwNzk3?=
 =?utf-8?B?S3kwVVprTUFZcHpFMzZPQnJ6VC9ON2xaeVFZWTN2RWFab3dnMUNPVGxuVlly?=
 =?utf-8?B?Q0JFZDd1QnlOaVhYYnpZTmpYOUJuV2NvMnZERm5zZ3NFMmVNMUJJbHFreUVS?=
 =?utf-8?B?RXpKbGJ5THRocUordEFJWlNoMlRNb3pXUDZjT2pmVm5FTDhlM0lTZHJ6RmVI?=
 =?utf-8?B?Z2hySVc1N3pRTVoxVUVYR2ZLbGluWi84UG5jN0J2Wnc0T05NejFOT0N4SFYy?=
 =?utf-8?B?bkkvRm5kRVZRaUdadlJvRVEzZ3Ird2pIV2dqam5lL2V1TlJPOXovMFlObm1n?=
 =?utf-8?B?b21zczBBaFU5Mng5VVRxM0RDYTM5b2dkaEUvOXNqQk16bDdNUnNzYUY3eWJo?=
 =?utf-8?B?N2pUNjZDRHVpMG9wRlRYTGZyMEdDQU91NitGYTkrbmFqWEZWTk9mTm10WDYr?=
 =?utf-8?B?ekFUNWlZU1I5SlV6NUhNZkVCeXRLTUVJZDhFdVNYYzZyWWF5T24rTkJlVW82?=
 =?utf-8?B?UkhTeGpybU84OWx1WHVsb1h5MlVtelNpWXJPVzZRcUMrY08wRDNITWlJdmRQ?=
 =?utf-8?B?bmdTdndiU3dMRVZ4OXNXQkNReWRoRkdBdnhTS3VLOG5BN0dMNnVaUHlpdzJ4?=
 =?utf-8?B?djdGREtZSnh2VHdpYVdZQnBmZkhTSmt2cmNhN1cxdnllemJWVUF6MHl5eTRz?=
 =?utf-8?B?UFQ5UE9PMlNsOTl6UnNtQ0pWUm9MSnp3Mk10RDhsN1VyditMaitmUVp5MDZj?=
 =?utf-8?Q?8v6JvXl+qxmZ/308rqh92Va92?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a663908-b239-4e74-1c04-08dbf4c55642
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 12:34:19.9186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IhGD0bQadHFyOiZNQ26RxreWFChhO6b02wjjA4d4rPpqrQ12fGHR5bqbGrpK21ljC8yxabCUd/mChTqGNJAAfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6851
X-OriginatorOrg: intel.com

On 2023/11/15 11:02, Lu Baolu wrote:
> The individual iommu driver reports the iommu page faults by calling
> iommu_report_device_fault(), where a pre-registered device fault handler
> is called to route the fault to another fault handler installed on the
> corresponding iommu domain.
> 
> The pre-registered device fault handler is static and won't be dynamic
> as the fault handler is eventually per iommu domain. Replace calling
> device fault handler with iommu_queue_iopf().
> 
> After this replacement, the registering and unregistering fault handler
> interfaces are not needed anywhere. Remove the interfaces and the related
> data structures to avoid dead code.
> 
> Convert cookie parameter of iommu_queue_iopf() into a device pointer that
> is really passed.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   include/linux/iommu.h                         | 23 ------
>   drivers/iommu/iommu-sva.h                     |  4 +-
>   .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 13 +---
>   drivers/iommu/intel/iommu.c                   | 24 ++----
>   drivers/iommu/io-pgfault.c                    |  6 +-
>   drivers/iommu/iommu.c                         | 76 +------------------
>   6 files changed, 13 insertions(+), 133 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 108ab50da1ad..a45d92cc31ec 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -128,7 +128,6 @@ struct iommu_page_response {
>   
>   typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
>   			struct device *, unsigned long, int, void *);
> -typedef int (*iommu_dev_fault_handler_t)(struct iommu_fault *, void *);
>   
>   struct iommu_domain_geometry {
>   	dma_addr_t aperture_start; /* First address that can be mapped    */
> @@ -589,8 +588,6 @@ struct iommu_fault_event {
>   
>   /**
>    * struct iommu_fault_param - per-device IOMMU fault data
> - * @handler: Callback function to handle IOMMU faults at device level
> - * @data: handler private data
>    * @lock: protect pending faults list
>    * @dev: the device that owns this param
>    * @queue: IOPF queue
> @@ -600,8 +597,6 @@ struct iommu_fault_event {
>    * @faults: holds the pending faults which needs response
>    */
>   struct iommu_fault_param {
> -	iommu_dev_fault_handler_t handler;
> -	void *data;
>   	struct mutex lock;
>   
>   	struct device *dev;
> @@ -724,11 +719,6 @@ extern int iommu_group_for_each_dev(struct iommu_group *group, void *data,
>   extern struct iommu_group *iommu_group_get(struct device *dev);
>   extern struct iommu_group *iommu_group_ref_get(struct iommu_group *group);
>   extern void iommu_group_put(struct iommu_group *group);
> -extern int iommu_register_device_fault_handler(struct device *dev,
> -					iommu_dev_fault_handler_t handler,
> -					void *data);
> -
> -extern int iommu_unregister_device_fault_handler(struct device *dev);
>   
>   extern int iommu_report_device_fault(struct device *dev,
>   				     struct iommu_fault_event *evt);
> @@ -1137,19 +1127,6 @@ static inline void iommu_group_put(struct iommu_group *group)
>   {
>   }
>   
> -static inline
> -int iommu_register_device_fault_handler(struct device *dev,
> -					iommu_dev_fault_handler_t handler,
> -					void *data)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline int iommu_unregister_device_fault_handler(struct device *dev)
> -{
> -	return 0;
> -}
> -
>   static inline
>   int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
>   {
> diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
> index 54946b5a7caf..de7819c796ce 100644
> --- a/drivers/iommu/iommu-sva.h
> +++ b/drivers/iommu/iommu-sva.h
> @@ -13,7 +13,7 @@ struct iommu_fault;
>   struct iopf_queue;
>   
>   #ifdef CONFIG_IOMMU_SVA
> -int iommu_queue_iopf(struct iommu_fault *fault, void *cookie);
> +int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev);
>   
>   int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev);
>   int iopf_queue_remove_device(struct iopf_queue *queue,
> @@ -26,7 +26,7 @@ enum iommu_page_response_code
>   iommu_sva_handle_iopf(struct iommu_fault *fault, void *data);
>   
>   #else /* CONFIG_IOMMU_SVA */
> -static inline int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
> +static inline int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>   {
>   	return -ENODEV;
>   }
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 353248ab18e7..84c9554144cb 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -480,7 +480,6 @@ bool arm_smmu_master_sva_enabled(struct arm_smmu_master *master)
>   
>   static int arm_smmu_master_sva_enable_iopf(struct arm_smmu_master *master)
>   {
> -	int ret;
>   	struct device *dev = master->dev;
>   
>   	/*
> @@ -493,16 +492,7 @@ static int arm_smmu_master_sva_enable_iopf(struct arm_smmu_master *master)
>   	if (!master->iopf_enabled)
>   		return -EINVAL;
>   
> -	ret = iopf_queue_add_device(master->smmu->evtq.iopf, dev);
> -	if (ret)
> -		return ret;
> -
> -	ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf, dev);
> -	if (ret) {
> -		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
> -		return ret;
> -	}
> -	return 0;
> +	return iopf_queue_add_device(master->smmu->evtq.iopf, dev);
>   }
>   
>   static void arm_smmu_master_sva_disable_iopf(struct arm_smmu_master *master)
> @@ -512,7 +502,6 @@ static void arm_smmu_master_sva_disable_iopf(struct arm_smmu_master *master)
>   	if (!master->iopf_enabled)
>   		return;
>   
> -	iommu_unregister_device_fault_handler(dev);
>   	iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
>   }
>   
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 3531b956556c..cbe65827730d 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4616,23 +4616,15 @@ static int intel_iommu_enable_iopf(struct device *dev)
>   	if (ret)
>   		return ret;
>   
> -	ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf, dev);
> -	if (ret)
> -		goto iopf_remove_device;
> -
>   	ret = pci_enable_pri(pdev, PRQ_DEPTH);
> -	if (ret)
> -		goto iopf_unregister_handler;
> +	if (ret) {
> +		iopf_queue_remove_device(iommu->iopf_queue, dev);
> +		return ret;
> +	}
> +
>   	info->pri_enabled = 1;
>   
>   	return 0;
> -
> -iopf_unregister_handler:
> -	iommu_unregister_device_fault_handler(dev);
> -iopf_remove_device:
> -	iopf_queue_remove_device(iommu->iopf_queue, dev);
> -
> -	return ret;
>   }
>   
>   static int intel_iommu_disable_iopf(struct device *dev)
> @@ -4655,11 +4647,9 @@ static int intel_iommu_disable_iopf(struct device *dev)
>   	info->pri_enabled = 0;
>   
>   	/*
> -	 * With PRI disabled and outstanding PRQs drained, unregistering
> -	 * fault handler and removing device from iopf queue should never
> -	 * fail.
> +	 * With PRI disabled and outstanding PRQs drained, removing device
> +	 * from iopf queue should never fail.
>   	 */
> -	WARN_ON(iommu_unregister_device_fault_handler(dev));
>   	WARN_ON(iopf_queue_remove_device(iommu->iopf_queue, dev));
>   
>   	return 0;
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index b1cf28055525..31832aeacdba 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -87,7 +87,7 @@ static void iopf_handler(struct work_struct *work)
>   /**
>    * iommu_queue_iopf - IO Page Fault handler
>    * @fault: fault event
> - * @cookie: struct device, passed to iommu_register_device_fault_handler.
> + * @dev: struct device.
>    *
>    * Add a fault to the device workqueue, to be handled by mm.
>    *
> @@ -124,14 +124,12 @@ static void iopf_handler(struct work_struct *work)
>    *
>    * Return: 0 on success and <0 on error.
>    */
> -int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
> +int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>   {
>   	int ret;
>   	struct iopf_group *group;
>   	struct iopf_fault *iopf, *next;
>   	struct iommu_fault_param *iopf_param;
> -
> -	struct device *dev = cookie;
>   	struct dev_iommu *param = dev->iommu;
>   
>   	lockdep_assert_held(&param->lock);
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 9c9eacfa6761..0c6700b6659a 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1301,76 +1301,6 @@ void iommu_group_put(struct iommu_group *group)
>   }
>   EXPORT_SYMBOL_GPL(iommu_group_put);
>   
> -/**
> - * iommu_register_device_fault_handler() - Register a device fault handler
> - * @dev: the device
> - * @handler: the fault handler
> - * @data: private data passed as argument to the handler
> - *
> - * When an IOMMU fault event is received, this handler gets called with the
> - * fault event and data as argument. The handler should return 0 on success. If
> - * the fault is recoverable (IOMMU_FAULT_PAGE_REQ), the consumer should also
> - * complete the fault by calling iommu_page_response() with one of the following
> - * response code:
> - * - IOMMU_PAGE_RESP_SUCCESS: retry the translation
> - * - IOMMU_PAGE_RESP_INVALID: terminate the fault
> - * - IOMMU_PAGE_RESP_FAILURE: terminate the fault and stop reporting
> - *   page faults if possible.
> - *
> - * Return 0 if the fault handler was installed successfully, or an error.
> - */
> -int iommu_register_device_fault_handler(struct device *dev,
> -					iommu_dev_fault_handler_t handler,
> -					void *data)
> -{
> -	struct dev_iommu *param = dev->iommu;
> -	int ret = 0;
> -
> -	if (!param || !param->fault_param)
> -		return -EINVAL;
> -
> -	mutex_lock(&param->lock);
> -	/* Only allow one fault handler registered for each device */
> -	if (param->fault_param->handler) {
> -		ret = -EBUSY;
> -		goto done_unlock;
> -	}
> -
> -	param->fault_param->handler = handler;
> -	param->fault_param->data = data;
> -
> -done_unlock:
> -	mutex_unlock(&param->lock);
> -
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(iommu_register_device_fault_handler);
> -
> -/**
> - * iommu_unregister_device_fault_handler() - Unregister the device fault handler
> - * @dev: the device
> - *
> - * Remove the device fault handler installed with
> - * iommu_register_device_fault_handler().
> - *
> - * Return 0 on success, or an error.
> - */
> -int iommu_unregister_device_fault_handler(struct device *dev)
> -{
> -	struct dev_iommu *param = dev->iommu;
> -
> -	if (!param || !param->fault_param)
> -		return -EINVAL;
> -
> -	mutex_lock(&param->lock);
> -	param->fault_param->handler = NULL;
> -	param->fault_param->data = NULL;
> -	mutex_unlock(&param->lock);
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(iommu_unregister_device_fault_handler);
> -
>   /**
>    * iommu_report_device_fault() - Report fault event to device driver
>    * @dev: the device
> @@ -1395,10 +1325,6 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
>   	/* we only report device fault if there is a handler registered */
>   	mutex_lock(&param->lock);
>   	fparam = param->fault_param;
> -	if (!fparam || !fparam->handler) {

should it still check the fparam?

> -		ret = -EINVAL;
> -		goto done_unlock;
> -	}
>   
>   	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
>   	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
> @@ -1413,7 +1339,7 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
>   		mutex_unlock(&fparam->lock);
>   	}
>   
> -	ret = fparam->handler(&evt->fault, fparam->data);
> +	ret = iommu_queue_iopf(&evt->fault, dev);
>   	if (ret && evt_pending) {
>   		mutex_lock(&fparam->lock);
>   		list_del(&evt_pending->list);

-- 
Regards,
Yi Liu

