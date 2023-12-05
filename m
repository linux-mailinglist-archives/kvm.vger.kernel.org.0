Return-Path: <kvm+bounces-3461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B298B804AE4
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 08:08:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 238F9B20D90
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C6BE15EAC;
	Tue,  5 Dec 2023 07:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YlNv+v97"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A04AA0;
	Mon,  4 Dec 2023 23:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701760089; x=1733296089;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OrXYveZbh+hx366VevZ2yf/njvBuMyhn4M0x23zImYU=;
  b=YlNv+v97hwF8Dr4ylma++RyWklGXmMkFWxdSK052iWvP0poEQSnVwsfu
   xT5FUhzKg9PIHDrAFPwYxeB0mBw4E2Xx+cnQhIFjunaHJYyQu9nw7LGC4
   Cv8V+JtmQk24u8SyogDFI3qCN2Tc22UfbAhMlkZC/MGvfDTvx3+VDkJtz
   MUj9Rqp/aBIICTyIAVqwqyZfudTmKG+YD/0xogsd9qmoZ0G5QWNnEiU48
   gkHeVSsmrcq5bjJcLPCa4SSJS2mrkC0gINep3Wb14lI69tpEf0DXm99O6
   UWB/rtmc+bm2G2QIqTB4vucHgmJlLV8niIwo8EhtmkZXQPtk6swAJN5+y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="391014145"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="391014145"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 23:08:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="799858189"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="799858189"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 23:08:07 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 23:08:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 23:08:06 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 23:08:06 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 23:08:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RS0zWOLxYSDDKeeHgHQtXYYd1JR7RgNNQ4MOkGR6gZyTyMzBVs3BI6z/jtr9dNxUY9G/RUn4ZKNPLpKFKCO3Ezx/KDVZWFVTGeC8YvhaqpLBIngzQuBS9QrkYLP2fOQOhFijfQIRtUKSuhW9IRFqqPcISVFUPZ9MvPdTbhFyomrE+hECX6N0ul7kk0fE7q6uPe5Ng3dGFUr3Y0dipExr8rVjOz08P7eMSlV7IIEAMEvmceJmysrhzfCJLCi/Uj2YWOorqKoi4FcBrKs4EtDoROHCDokqo+c5ANR/v935b09OuXUmCkwlGi1rtJ5PJElDe+WaNKqm0Mmhxqk/Nd6i+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J54NYfQFbgW3cxtvB8HDLK7qV2JqzPFi/dydCYpUMkw=;
 b=JcWxPv01kcmHwTibkDCzkj0Thh7vGRXepEZkM/Ig5o1mzv95r3phsMJuf59hw0a6I6FRkuo4QOxJmUaFLUIcrrQG4vc2WMOjPMZ6wwwEd9a3aDvdtErq9ABuxp0KB4gRgc6YVmLBJelKwwohJyLihzTKEx1xh+BURCMDb2RArAfMMCPnK4OtC/Ub65rMY5WMHxJHnLlvmc6riYfMXq7DzjySQYLS77+8OqhLJIC18YpS3H22mH6Rio0LGc/ctoRPtxyMD5L/AQrwM3zJ3jQ7eNY2GxJgbnvxsF0lMf4rVxoPDJEfT9RlYV2J1Q7n7nserrWIM01UEjBNEbHWNfsfkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB6101.namprd11.prod.outlook.com (2603:10b6:8:86::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 07:08:04 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%5]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 07:08:04 +0000
Message-ID: <b0606a7c-3520-4a26-b113-40531f6d0fae@intel.com>
Date: Tue, 5 Dec 2023 15:10:37 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/12] iommu: Prepare for separating SVA and IOPF
Content-Language: en-US
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Jean-Philippe
 Brucker" <jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao
	<yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-9-baolu.lu@linux.intel.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20231115030226.16700-9-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0119.apcprd03.prod.outlook.com
 (2603:1096:4:91::23) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS7PR11MB6101:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f5b292d-5f08-4f31-f99c-08dbf560ec4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ydEaUo5/7trv6jDJV+LSEHLjb3+Mk244ts5Zwz3sHcdbGoxlGrp4jb8UFHHNKZhk6Kox42jpHESlNdv6mJIKuiQ48eBGVl8BRHCducringj0Yfi9Oi6pTVEt4ePiYInq7Vm1nqgsqHcAFKLllIh+Pau7ja+B3rzu5r+refUy407JyjuPCAYqqvBNXcWcwsCvYt8jORYRDrAJCQVIZhjZ1vbRTyI6wkM4fvLNmhdgEEvoDFCq187VDiXr6wxxNnfAnsTyiy+gnxuSw8fuNzxaiYZVR9/fCytUdRkSKPoSXGbEq+CqkhL4zm4qSFW7+87iJJb198v09A/yeeMLH8O6LpYPR2vo6XUTXkvwYxtX2Una7czjTHOOYFXePt6f2DxHw1uStToWJpc/68kpOEj2IvEY3e9iTal90UFUxDovJzdt+dugtIdEcK+MURrPcDpyzzWS8Z1NRAyaNyWGG8wimp59MUcCTpGMS7xLGUGCFtZG1vFtAwihM0mqPprKK5tcYorYStLtFPztqg/zKhQVi9CpZJjx4W9tP4YpKB3LTokVZQwUGdOD9MzhRYJZ/2Q0Qrhx3Y5VpkUAN78vhJrxdes3tyXDm9RgyFG57/lzQV7YBe9MHldclQfExqCpITF9HhHT5H1RkeLxdEKapP4BuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(376002)(396003)(366004)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(7416002)(2906002)(6666004)(6486002)(478600001)(8936002)(8676002)(4326008)(86362001)(31696002)(110136005)(54906003)(66476007)(66556008)(66946007)(316002)(5660300002)(26005)(82960400001)(83380400001)(36756003)(41300700001)(31686004)(38100700002)(2616005)(6512007)(53546011)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjRBVGk0bUdwWDUwTjlObFA5TW13Q0dKamlocnJnNEdKdnVpYktUa1ZDTEhU?=
 =?utf-8?B?YTJFdFU0cTJqVStIaWlWUitEOHV3UlkrbE52eHF3V3JPNmk2NWJacGd0Y0hK?=
 =?utf-8?B?N2N5ajZVNFhjK0htc1NFK2xuMjZFeHZ1Z01lTzhyR1VTdDV6TjQwanByTUxw?=
 =?utf-8?B?bnBOVC84MEpPR3BzY2V6U2xFcWNlcytIY0xmb25oZ1dhUEw2TlE2ckN4N0di?=
 =?utf-8?B?TDFSdDVzbklUL2FEVmVtTklkcjc1dVpxZnJaWHptN2FXTytrK0Ywd1hUU2pU?=
 =?utf-8?B?TTNjM1FxTjdYT3J0aCtPL21lWUNNV3czSmh6a1ZaZnkxamRPYTYvT2owdVgv?=
 =?utf-8?B?T3o0djNsOVF5cWpwS1RpR2dZcUtRaG9ramQzbzNuVEtzb1g1RkZFSE5SeTRo?=
 =?utf-8?B?M1ZzbGc3RVpkaEZZMlhpME44b2lsZzB5L0h4SkZ2Q1F2YWZsQUpHdHNCdUpo?=
 =?utf-8?B?K0FuRGJDY0RFWVlRZmxmbUZ2Q0Vqb2p2am9XL25VNUQzQVo1dWg2R0hyOCs2?=
 =?utf-8?B?YThxRUdNQWlkU1hXYjdML1o2ZTJSZDhtaEg3Z0J5MFR1YTNGczNaTkdENEJ5?=
 =?utf-8?B?N0Y0K1hEVVM1Nm96emE4ZC94VXFnOHJqV0RnOGJYdGJjY3NONmg5R3BvSm8y?=
 =?utf-8?B?Y2VheE1ZUUtSVDlSdGsrc1VhcDQvcGxWMTFQNGxXd2JKUFlCZE51Nml3VjNl?=
 =?utf-8?B?U3ZoUmJWVm5GalQyQkY1WThnQ0ttZ0lLV1JuSGVTOW0yZ1ovdXBBeFpxOFYr?=
 =?utf-8?B?K1Y5bmVyRWxpS1NGdWkzTGhWelIzMHUwYVJ1bmlEVU5ZU1BQVlV3UHdXVXFV?=
 =?utf-8?B?cExuUjZpVUhBVEFKNjBuT3MwMTY1UHNXMVEwbjVJK0dTRzNUd21yQnE3dFZ2?=
 =?utf-8?B?VnJvaStTRlh4Nzd0SHk2SUl2dy9YVDhDZHFsTUN5T2YzSy8yZjlBT01VaGRZ?=
 =?utf-8?B?OU8zc3owd3dQeC9tTE9mNUtObGJHSnRWcExQUUZsVlVYMHR5Yk9kNVM3S1RU?=
 =?utf-8?B?RnZHVm55NlNRTXI0cWR0T2lHL1FjMHd3TDlHYTFsWjZza1VUWGlOaVc1YnFa?=
 =?utf-8?B?SDJXTXJubEZJWmtmN3oyTmhNdXA0VDJBUnJPKzB2c1ordEVUWklmU0dWNmto?=
 =?utf-8?B?Nk1XZDJmSCtUdUVHbzF1L3NjNWZqTXVwN0pxVWhUeWx2UEVMWXhoMWp1TkRT?=
 =?utf-8?B?Qk4yWDM0eE5Iem5vODNKZVYxZmVGVU1say96WEZ4OWxXOHNlblA4dlRMMENG?=
 =?utf-8?B?M3k5UjYxSXJDcm80bkpDVk9BUTZTem9BZHlta2tCN2V6Y1N3RUFvaCtjM3p2?=
 =?utf-8?B?UkpoSVV6WCs0bFlqN1l4QlFJbFJQTlJkaGpkT05LZDVzdnl4cTBRd2dKTFFz?=
 =?utf-8?B?eG9Eb2xVcjhaOEZaSEFYTGZDdmduZFdJTUIwcXdoUlN3YXBvZkFYaittWCta?=
 =?utf-8?B?b3lvTy9WbUpIV3BmRkI0Wi9pNU5ibnE4akJibTIrVDhrbGxvT1krR2Q4eThx?=
 =?utf-8?B?dEFBQ053UHFHZG1VTEM0YnZROC91cVQyczFMWnByWWw3T2V2UDcvSmdTSjFZ?=
 =?utf-8?B?WS9UVDJPSFpKcmhaR2tWNkpza244RWd1NUZyVURGSzlGMDVVSm1WeUZJUmdy?=
 =?utf-8?B?UkZyY0NlZEYvb1BjUnBVaEU5OG5ycFRmQlJnQ2MzWUxlNEMvUlFRWW5XKzQz?=
 =?utf-8?B?dVNYK3pZZTRlR0lhK1NrSW9sQ0ExOUR3ampHMkxNZXI4SmpRSG5uZVlKUlZW?=
 =?utf-8?B?N3pRcGtDZWhRWWNmdHpIUVhDcnc3VFR5bXlZbFd4UmNwMDBkL0VlbDlRZmJi?=
 =?utf-8?B?NjN1V25naWFCY1VvS1JmRmZpZlRuQUVaYkFaa1c5VUhtQWNvTzFzaFU5U2xH?=
 =?utf-8?B?RVVRcG5TMWRkUWZWS2pkdzhpTEpuM2ZWbXd0Y0xvMUJoZWxlS3pIRXVZamxj?=
 =?utf-8?B?TFpMUnN4Q2hEczZTRlRqT0Q2Y3RXQmNsZEtHTzBGTXBhZFB2MlFTOVhsbWow?=
 =?utf-8?B?OVV0bEZjZDBlWjZCMFFrSXJmc3hyelRHbWV5UVZKdU9USUViNWNpK0JJRlFB?=
 =?utf-8?B?U3JQWENud0dBK09PRkRKenlsaTVBN0IvMnhFRWlhbDBielFOMXJrMVJVaVMr?=
 =?utf-8?Q?VbxM4dh9Ez8ty8J9rj/KCQarK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5b292d-5f08-4f31-f99c-08dbf560ec4c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 07:08:03.6782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xCg4akLQQxg65hhvnPnImEOskNp9XgxwrO5KbHWrOtsdRady5s8GTqEFMnR28DJ6ZW4YHkkyKBAXCCcca/pFHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6101
X-OriginatorOrg: intel.com

On 2023/11/15 11:02, Lu Baolu wrote:
> Move iopf_group data structure to iommu.h to make it a minimal set of
> faults that a domain's page fault handler should handle.
> 
> Add a new function, iopf_free_group(), to free a fault group after all
> faults in the group are handled. This function will be made global so
> that it can be called from other files, such as iommu-sva.c.
> 
> Move iopf_queue data structure to iommu.h to allow the workqueue to be
> scheduled out of this file.
> 
> This will simplify the sequential patches.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   include/linux/iommu.h      | 20 +++++++++++++++++++-
>   drivers/iommu/io-pgfault.c | 37 +++++++++++++------------------------
>   2 files changed, 32 insertions(+), 25 deletions(-)

Reviewed-by:Yi Liu <yi.l.liu@intel.com>

> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 42b62bc8737a..0d3c5a56b078 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -41,7 +41,6 @@ struct iommu_dirty_ops;
>   struct notifier_block;
>   struct iommu_sva;
>   struct iommu_dma_cookie;
> -struct iopf_queue;
>   
>   #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
>   #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
> @@ -126,6 +125,25 @@ struct iopf_fault {
>   	struct list_head list;
>   };
>   
> +struct iopf_group {
> +	struct iopf_fault last_fault;
> +	struct list_head faults;
> +	struct work_struct work;
> +	struct device *dev;
> +};
> +
> +/**
> + * struct iopf_queue - IO Page Fault queue
> + * @wq: the fault workqueue
> + * @devices: devices attached to this queue
> + * @lock: protects the device list
> + */
> +struct iopf_queue {
> +	struct workqueue_struct *wq;
> +	struct list_head devices;
> +	struct mutex lock;
> +};
> +
>   /* iommu fault flags */
>   #define IOMMU_FAULT_READ	0x0
>   #define IOMMU_FAULT_WRITE	0x1
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index c45977bb7da3..09e05f483b4f 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -13,24 +13,17 @@
>   
>   #include "iommu-sva.h"
>   
> -/**
> - * struct iopf_queue - IO Page Fault queue
> - * @wq: the fault workqueue
> - * @devices: devices attached to this queue
> - * @lock: protects the device list
> - */
> -struct iopf_queue {
> -	struct workqueue_struct		*wq;
> -	struct list_head		devices;
> -	struct mutex			lock;
> -};
> +static void iopf_free_group(struct iopf_group *group)
> +{
> +	struct iopf_fault *iopf, *next;
>   
> -struct iopf_group {
> -	struct iopf_fault		last_fault;
> -	struct list_head		faults;
> -	struct work_struct		work;
> -	struct device			*dev;
> -};
> +	list_for_each_entry_safe(iopf, next, &group->faults, list) {
> +		if (!(iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE))
> +			kfree(iopf);
> +	}
> +
> +	kfree(group);
> +}
>   
>   static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
>   			       enum iommu_page_response_code status)
> @@ -50,9 +43,9 @@ static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
>   
>   static void iopf_handler(struct work_struct *work)
>   {
> +	struct iopf_fault *iopf;
>   	struct iopf_group *group;
>   	struct iommu_domain *domain;
> -	struct iopf_fault *iopf, *next;
>   	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
>   
>   	group = container_of(work, struct iopf_group, work);
> @@ -61,7 +54,7 @@ static void iopf_handler(struct work_struct *work)
>   	if (!domain || !domain->iopf_handler)
>   		status = IOMMU_PAGE_RESP_INVALID;
>   
> -	list_for_each_entry_safe(iopf, next, &group->faults, list) {
> +	list_for_each_entry(iopf, &group->faults, list) {
>   		/*
>   		 * For the moment, errors are sticky: don't handle subsequent
>   		 * faults in the group if there is an error.
> @@ -69,14 +62,10 @@ static void iopf_handler(struct work_struct *work)
>   		if (status == IOMMU_PAGE_RESP_SUCCESS)
>   			status = domain->iopf_handler(&iopf->fault,
>   						      domain->fault_data);
> -
> -		if (!(iopf->fault.prm.flags &
> -		      IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE))
> -			kfree(iopf);
>   	}
>   
>   	iopf_complete_group(group->dev, &group->last_fault, status);
> -	kfree(group);
> +	iopf_free_group(group);
>   }
>   
>   /**

-- 
Regards,
Yi Liu

