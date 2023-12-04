Return-Path: <kvm+bounces-3321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6532E8030EA
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 11:50:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D61F31F2102A
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 10:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39208224D2;
	Mon,  4 Dec 2023 10:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aa4RPAy1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4545595;
	Mon,  4 Dec 2023 02:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701687023; x=1733223023;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/7DeVahzaoedm1nO+R/3yhobYpMUxLNsmscCQ31VaDo=;
  b=aa4RPAy1/bK/02kj5aeOrgdwSX0wEq/yqEMN4FM05jnYj3pnNiDtf5cO
   2a5JrNvpeIVVGOHOWp2HYr9XUlF2f/TS+nMO0Sn/V4joHotTkCdXLqE83
   9i9kXPkyUBDc8QbD5GfiShAg8YIsUBd0D7L0uGHRXaFnJWcMLqkQ4J3Et
   rTJ7FtIfR87BEODyIboHdRbD02Xo8pb530mL039jCg3gWNoOxoDgwT6xd
   YzX0wxfKsDuxUqksC281HGzSVOwvwMuEPvkuoN9N+TieHI46ANDUvcq/L
   EKFu3ocajfG4ENARCbmaZJ9JA/7d4cpGDTKnB4c5Pb1MtQGypORElz53m
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="458038334"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="458038334"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 02:50:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="720281372"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="720281372"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 02:50:14 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 02:50:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 02:50:13 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 02:50:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQ/nJu2fokg4GnKTKDOdvToDW/0kKqhEE5bFKYSJSrh3xe84xp/6VhaLPCS7TpsQjbRxA6NmAvbLP7Y8K9dYGEtf2iTM7++mpyBKzHyDLPeKM85XQ/2TicycPeUBxjWrgNIprqxwAtVRYQmygqADaGdeZBiYwGjfgWcypJ/rlZtuEgpRYSCEA5raDjv/MpkUYy2nBTXBhPulYRmRyh00blSGf6sRHWdVuWf7f6D3IjTEqmY4p7WshNHxV6tafj5KPF7tK66IJYkAIkwY1n9PZfm8GkPeXKUJlkBJFwAgpUUTBUcs5LDinQueXMP5ke4uv9D9zwIjGoAUYglJk2aj+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OM4KkRbIZG1pp5zUlj/oYuz57XlilJsUVNGGv3pcVcI=;
 b=CJi4LfqDUNqsPfGNtadRl0bAxieUaSCTAG87DdKTeF/HRaivXcjtnkZoHTspbhU+pbXbGWDwBaHVVGXNCu6Py0U61MoV34fHufoZVNLB91MaSZFWDjzzudBwaTX20ZdVrXUIc6CmTG2utdblSO7mvcNzTAy/s1Kvu/RKvdI1qZx8ZWfpQH+jEva/kxJh/w61mbbDzfxEZjpWuS5I8SaPMVUGmHHxFjh3vc8mImsStt0T64Sj+s743VW+OKXPUeq1pUO+TK6FQgOZweuKzLWccbJ6mcdzoDioF17Uk+nV+HBugLzzLeQKqGO3VQPxC42KcvmcHKnupRmbcwlOhs5Dvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB5535.namprd11.prod.outlook.com (2603:10b6:5:398::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 10:50:11 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%5]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 10:50:10 +0000
Message-ID: <7a10c72e-33ef-4aa3-97eb-57073f316b04@intel.com>
Date: Mon, 4 Dec 2023 18:52:44 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/12] iommu: Move iommu fault data to linux/iommu.h
Content-Language: en-US
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Jean-Philippe
 Brucker" <jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao
	<yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-2-baolu.lu@linux.intel.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20231115030226.16700-2-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGXP274CA0012.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::24)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM4PR11MB5535:EE_
X-MS-Office365-Filtering-Correlation-Id: c89dd98c-11b2-472c-334c-08dbf4b6c960
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sZTph0Rwb7rd0FM1x2ykQHnJQ2SEHsCbIF8YGrNm5kiw7ExEHxvNkhexgr1rpyhlDthN5q11/7bOOCoPqyN0veyUXbWbtlX05ls1PAhO2sPuOAUxsZcSWqk87WZorJUpawGRc1YFj2PWwQ/Po63AbK6uoYyMyBX9/Ch8WEz9unC/AklD+RBJ/F7stFx4hMjR16LWSuWopHm1IupAjdH2yrKl7DApH2K4tZcU7A5GJ5SoH8sOASiTPRgxblsPpz9yUQmdx/1c2ffaRhHjLGL5TbQo0b9XZNkXIIOPZnGnjpLpzaWht59FDs17TqOWKubgaR8r2u4Ym7iAjc0mWD6NiGohi3HMf5bn4lrYFYRkZz1pwcd+M6zMYoobs5z5ML9tV8kSRRpsj3ML31VdEwdyC4Rl383ZefoGu9ijO1FTjUIx+1s4siBBxuR4nAjCWYm5zYXAmN+2MHI02gDvble7igE1t7qdDlOWtZMD+Z5Du/Pk2KjrXIfs2EcAwvds5zqARVL2R2Uz740hrz16qvSjL1wUDFhk27p9JUqVinbVXntKwzNuSxcUs/HBjUnpmDhEB991S8TbPvr56UaR/01JT7447AzOVRhN3rR4i5yTLIzEvOxFTwjwH1+lswmmISiCgfJttoMOqTNpo9+oPKMrmgHXKJRizHeO6UIfjs/wHsbcut74YpHL/uBSjAsElLG1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(136003)(39860400002)(396003)(230273577357003)(230173577357003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(478600001)(26005)(6486002)(83380400001)(6666004)(6506007)(6512007)(53546011)(82960400001)(36756003)(2616005)(316002)(110136005)(66476007)(54906003)(66946007)(66556008)(31686004)(38100700002)(5660300002)(86362001)(4326008)(2906002)(8936002)(8676002)(7416002)(31696002)(41300700001)(30864003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFg1OUw5QS9aT2NuOTlFZGRsS2xOdkJGMjV3Nk5Teno5ZnlNZ2pHazJlZWFq?=
 =?utf-8?B?RVIraG0wRUtEZ1RlczlnZDdweGE0MTRLaXZrRDNtS0J1bEdtY1VMbVNVbS9I?=
 =?utf-8?B?RU53a21ZTHlRSE5vNUczT3VEYll0dTNKQWQwRkpZdUpMYnQrbkNRSGtMa0lC?=
 =?utf-8?B?bzRkaXdCWnpQbDVlOFcvNXVEZ1EyVGtDZkMwa2hxOXZtWGl6OEpFUFdlT0t1?=
 =?utf-8?B?Y29LcURBMnhkWDBiNm1VbVV0UTF0em9HS3pLeTR2NEoyaFVaUDRtSmxXc0lz?=
 =?utf-8?B?N0UwTUFWKzdrWGl6VFd4WkJwZVhMSGx3U1dyMFJ6UFBmWlB1MlhwUFMwNkFO?=
 =?utf-8?B?TFA1ZWJodStSc2duOUtNbzlwQWhwYTRobGk4TXJaRVJQamk5ZldmNDhpT1dH?=
 =?utf-8?B?bVFVd0U4SFNYMFAxRXcyUitTUEkrTGJuZUNlQURKK3VGL2RXT2dNc1dYWUto?=
 =?utf-8?B?MFpFd1QyeGZ1ZUlHVVBic1hnMWNjTG9ZOVU1YjdQQmswTkd3SWFXdmwvWWZo?=
 =?utf-8?B?dytQckRnd0RtVEg2d3FFK1U1QjBVQlFLWS9MaDB4YlNIdzl2WndSZG9ZYWgw?=
 =?utf-8?B?eUhoMXpISlp4SUdaaFNTTGVZTUVISFl0aC91NjRuTno1ODZ5UVdrb2k4c0tC?=
 =?utf-8?B?WjZaNS9venRVQ2VWZ0NUTjhabUtzT2pIRGtQckhSRFpuV2llRVlrTkk1OUlM?=
 =?utf-8?B?QkRRMGZOMkRmOWFhUHg4dXB3R1FHakhVUCsxUUJoN0xicTAxV25RZWd4N1Uw?=
 =?utf-8?B?UWhtTHVCODlMMzhadFRYVnAvOVBtWlBoZ3BDdUdTNyswd3FUYWF0NGM5Tmhj?=
 =?utf-8?B?b1BseUh3aUxpOWJGbys0MlZQZ0laMmg4UUxVakpRSlUzaEUxR2xCUVVFa05G?=
 =?utf-8?B?WkxqUkN6bUVhZXNnblh0eFVmZjNFUGZpZTk3TjdESnZaenJmS1pIZ0hJL1Jq?=
 =?utf-8?B?ckdFWE5vRkROemhRVGRRTCtqN3YzVHZlM3BtbVYzc0IweExLLzEvM1gzSzBi?=
 =?utf-8?B?NlZKbzNWM2kxRVNxcXlIWFV5UHpSdXQ3WG5GOFZ0SzJ2K2lFZm42UnJvL29m?=
 =?utf-8?B?VnRLSnJqY0RSY2FQOXovV3pjSW4wemRtbHpZTWFCK2hncTdGQjFNTjFzOU16?=
 =?utf-8?B?VnRMRDE4a1dUSnJuTU83Uk1LQVhSL2xoN3IvTXd3bFhGdUxzZTNqTEExWHdF?=
 =?utf-8?B?bWRlb01vZzk4OXdBem1xZ3hNcHNsL2tMUldQblVqYnVobTR3UTczbXU3SkF0?=
 =?utf-8?B?NTlrUVdvaUJnTkM3d3Vkcm9qYkY0azFweE9rNzRJUjI3RTJpRzlrSytIbG8w?=
 =?utf-8?B?V20za3YvcmdWUlJUaDJQTG9KbStCaCtHd1d2d1FlVG1BdVI4S2o5NmM3VWVq?=
 =?utf-8?B?OFlySTNFUzVwbURjdUh2VC9NTERpSGJzSXIveTRINWFzd2o0bWxDUnFvWGtP?=
 =?utf-8?B?TTQ4NElIclJKM2lWWFRTc0JUWmU5cVZoMWdpUkh6Rmw5anhFT2lEYnY0dUtY?=
 =?utf-8?B?L1dHSWFPbjl3eFhaVlhEMjZOeU1iRU1mbHpFNFRZVTFYcUhvdm95RXBaNWdu?=
 =?utf-8?B?S0Q5YTdlNWIzNzRSUlBUL3lEUEc4R25JMUVkOTRrbFJ2NjZENHI3SGNyZ1du?=
 =?utf-8?B?NzBPaU94QU12RHBBRkhMWXBQbDVvTWJKT1oyMUo1YTdqaEpJUDhkRXhOT1J2?=
 =?utf-8?B?T21pQ2FPeUhTbEFmVTJFMHdieXFpUFl0UVhEa3pJY2k1SWVZdy9ibEE0WEIz?=
 =?utf-8?B?QVlBMTN0ZGN6d09lYVVIYXFPd2pYR1FGUXVZU3lJWmFMOHJnUlFSWkQwMlR1?=
 =?utf-8?B?Zk1TOVA1TlZqK0ZLZVlTYmU1em5DMm02dFhOcEJCZWtwWStIYkxuUjZOcmU0?=
 =?utf-8?B?blduaWh2cVk2QktaV01SQmpZcUdsMGNGMCs2T254TU1CaTVTQWtXSUp0U0R3?=
 =?utf-8?B?SENiRFF0TDNEQ0RHT3hRcWl0Zjd3V2hHdXdtT2FzelpaMndJc0puNHF4UWx3?=
 =?utf-8?B?NVRkeGVDT2tubnAveHpZY0l3Q1NUK3Y3QmdhK2sweGpDYUd1M2NCT1d5V2FF?=
 =?utf-8?B?SFQzVU5Xd0N4TEk0c2ZsWC9qSUpTcHJNMzd1cVc0K0lVeTBKS0pzNnk3ZjRt?=
 =?utf-8?Q?socJXI1knzunf3rtaZqoqvebp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c89dd98c-11b2-472c-334c-08dbf4b6c960
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 10:50:10.8167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GcSOwvPbFu2imJyC7MUEuO+fV5gAckiOYqIMfWlk+8tuCqFiR+f9XoD6xKMe7LcuCkAMSrhTaKHT3XhBgRx/8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5535
X-OriginatorOrg: intel.com

On 2023/11/15 11:02, Lu Baolu wrote:
> The iommu fault data is currently defined in uapi/linux/iommu.h, but is
> only used inside the iommu subsystem. Move it to linux/iommu.h, where it
> will be more accessible to kernel drivers.
> 
> With this done, uapi/linux/iommu.h becomes empty and can be removed from
> the tree.

It was supposed to be an uapi, but now the counterpart is going to be
defined in iommufd.h. :)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   include/linux/iommu.h      | 152 +++++++++++++++++++++++++++++++++-
>   include/uapi/linux/iommu.h | 161 -------------------------------------
>   MAINTAINERS                |   1 -
>   3 files changed, 151 insertions(+), 163 deletions(-)
>   delete mode 100644 include/uapi/linux/iommu.h
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index ec289c1016f5..c2e2225184cf 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -14,7 +14,6 @@
>   #include <linux/err.h>
>   #include <linux/of.h>
>   #include <linux/iova_bitmap.h>
> -#include <uapi/linux/iommu.h>
>   
>   #define IOMMU_READ	(1 << 0)
>   #define IOMMU_WRITE	(1 << 1)
> @@ -44,6 +43,157 @@ struct iommu_sva;
>   struct iommu_fault_event;
>   struct iommu_dma_cookie;
>   
> +#define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
> +#define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
> +#define IOMMU_FAULT_PERM_EXEC	(1 << 2) /* exec */
> +#define IOMMU_FAULT_PERM_PRIV	(1 << 3) /* privileged */
> +
> +/* Generic fault types, can be expanded IRQ remapping fault */
> +enum iommu_fault_type {
> +	IOMMU_FAULT_DMA_UNRECOV = 1,	/* unrecoverable fault */
> +	IOMMU_FAULT_PAGE_REQ,		/* page request fault */
> +};
> +
> +enum iommu_fault_reason {
> +	IOMMU_FAULT_REASON_UNKNOWN = 0,
> +
> +	/* Could not access the PASID table (fetch caused external abort) */
> +	IOMMU_FAULT_REASON_PASID_FETCH,
> +
> +	/* PASID entry is invalid or has configuration errors */
> +	IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
> +
> +	/*
> +	 * PASID is out of range (e.g. exceeds the maximum PASID
> +	 * supported by the IOMMU) or disabled.
> +	 */
> +	IOMMU_FAULT_REASON_PASID_INVALID,
> +
> +	/*
> +	 * An external abort occurred fetching (or updating) a translation
> +	 * table descriptor
> +	 */
> +	IOMMU_FAULT_REASON_WALK_EABT,
> +
> +	/*
> +	 * Could not access the page table entry (Bad address),
> +	 * actual translation fault
> +	 */
> +	IOMMU_FAULT_REASON_PTE_FETCH,
> +
> +	/* Protection flag check failed */
> +	IOMMU_FAULT_REASON_PERMISSION,
> +
> +	/* access flag check failed */
> +	IOMMU_FAULT_REASON_ACCESS,
> +
> +	/* Output address of a translation stage caused Address Size fault */
> +	IOMMU_FAULT_REASON_OOR_ADDRESS,
> +};
> +
> +/**
> + * struct iommu_fault_unrecoverable - Unrecoverable fault data
> + * @reason: reason of the fault, from &enum iommu_fault_reason
> + * @flags: parameters of this fault (IOMMU_FAULT_UNRECOV_* values)
> + * @pasid: Process Address Space ID
> + * @perm: requested permission access using by the incoming transaction
> + *        (IOMMU_FAULT_PERM_* values)
> + * @addr: offending page address
> + * @fetch_addr: address that caused a fetch abort, if any
> + */
> +struct iommu_fault_unrecoverable {
> +	__u32	reason;
> +#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
> +#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 1)
> +#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 2)
> +	__u32	flags;
> +	__u32	pasid;
> +	__u32	perm;
> +	__u64	addr;
> +	__u64	fetch_addr;
> +};
> +
> +/**
> + * struct iommu_fault_page_request - Page Request data
> + * @flags: encodes whether the corresponding fields are valid and whether this
> + *         is the last page in group (IOMMU_FAULT_PAGE_REQUEST_* values).
> + *         When IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID is set, the page response
> + *         must have the same PASID value as the page request. When it is clear,
> + *         the page response should not have a PASID.
> + * @pasid: Process Address Space ID
> + * @grpid: Page Request Group Index
> + * @perm: requested page permissions (IOMMU_FAULT_PERM_* values)
> + * @addr: page address
> + * @private_data: device-specific private information
> + */
> +struct iommu_fault_page_request {
> +#define IOMMU_FAULT_PAGE_REQUEST_PASID_VALID	(1 << 0)
> +#define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
> +#define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
> +#define IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID	(1 << 3)
> +	__u32	flags;
> +	__u32	pasid;
> +	__u32	grpid;
> +	__u32	perm;
> +	__u64	addr;
> +	__u64	private_data[2];
> +};
> +
> +/**
> + * struct iommu_fault - Generic fault data
> + * @type: fault type from &enum iommu_fault_type
> + * @padding: reserved for future use (should be zero)
> + * @event: fault event, when @type is %IOMMU_FAULT_DMA_UNRECOV
> + * @prm: Page Request message, when @type is %IOMMU_FAULT_PAGE_REQ
> + * @padding2: sets the fault size to allow for future extensions
> + */
> +struct iommu_fault {
> +	__u32	type;
> +	__u32	padding;
> +	union {
> +		struct iommu_fault_unrecoverable event;
> +		struct iommu_fault_page_request prm;
> +		__u8 padding2[56];
> +	};
> +};
> +
> +/**
> + * enum iommu_page_response_code - Return status of fault handlers
> + * @IOMMU_PAGE_RESP_SUCCESS: Fault has been handled and the page tables
> + *	populated, retry the access. This is "Success" in PCI PRI.
> + * @IOMMU_PAGE_RESP_FAILURE: General error. Drop all subsequent faults from
> + *	this device if possible. This is "Response Failure" in PCI PRI.
> + * @IOMMU_PAGE_RESP_INVALID: Could not handle this fault, don't retry the
> + *	access. This is "Invalid Request" in PCI PRI.
> + */
> +enum iommu_page_response_code {
> +	IOMMU_PAGE_RESP_SUCCESS = 0,
> +	IOMMU_PAGE_RESP_INVALID,
> +	IOMMU_PAGE_RESP_FAILURE,
> +};
> +
> +/**
> + * struct iommu_page_response - Generic page response information
> + * @argsz: User filled size of this data
> + * @version: API version of this structure
> + * @flags: encodes whether the corresponding fields are valid
> + *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
> + * @pasid: Process Address Space ID
> + * @grpid: Page Request Group Index
> + * @code: response code from &enum iommu_page_response_code
> + */
> +struct iommu_page_response {
> +	__u32	argsz;
> +#define IOMMU_PAGE_RESP_VERSION_1	1
> +	__u32	version;
> +#define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
> +	__u32	flags;
> +	__u32	pasid;
> +	__u32	grpid;
> +	__u32	code;
> +};
> +
> +
>   /* iommu fault flags */
>   #define IOMMU_FAULT_READ	0x0
>   #define IOMMU_FAULT_WRITE	0x1
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> deleted file mode 100644
> index 65d8b0234f69..000000000000
> --- a/include/uapi/linux/iommu.h
> +++ /dev/null
> @@ -1,161 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -/*
> - * IOMMU user API definitions
> - */
> -
> -#ifndef _UAPI_IOMMU_H
> -#define _UAPI_IOMMU_H
> -
> -#include <linux/types.h>
> -
> -#define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
> -#define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
> -#define IOMMU_FAULT_PERM_EXEC	(1 << 2) /* exec */
> -#define IOMMU_FAULT_PERM_PRIV	(1 << 3) /* privileged */
> -
> -/* Generic fault types, can be expanded IRQ remapping fault */
> -enum iommu_fault_type {
> -	IOMMU_FAULT_DMA_UNRECOV = 1,	/* unrecoverable fault */
> -	IOMMU_FAULT_PAGE_REQ,		/* page request fault */
> -};
> -
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
> -/**
> - * struct iommu_fault_page_request - Page Request data
> - * @flags: encodes whether the corresponding fields are valid and whether this
> - *         is the last page in group (IOMMU_FAULT_PAGE_REQUEST_* values).
> - *         When IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID is set, the page response
> - *         must have the same PASID value as the page request. When it is clear,
> - *         the page response should not have a PASID.
> - * @pasid: Process Address Space ID
> - * @grpid: Page Request Group Index
> - * @perm: requested page permissions (IOMMU_FAULT_PERM_* values)
> - * @addr: page address
> - * @private_data: device-specific private information
> - */
> -struct iommu_fault_page_request {
> -#define IOMMU_FAULT_PAGE_REQUEST_PASID_VALID	(1 << 0)
> -#define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
> -#define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
> -#define IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID	(1 << 3)
> -	__u32	flags;
> -	__u32	pasid;
> -	__u32	grpid;
> -	__u32	perm;
> -	__u64	addr;
> -	__u64	private_data[2];
> -};
> -
> -/**
> - * struct iommu_fault - Generic fault data
> - * @type: fault type from &enum iommu_fault_type
> - * @padding: reserved for future use (should be zero)
> - * @event: fault event, when @type is %IOMMU_FAULT_DMA_UNRECOV
> - * @prm: Page Request message, when @type is %IOMMU_FAULT_PAGE_REQ
> - * @padding2: sets the fault size to allow for future extensions
> - */
> -struct iommu_fault {
> -	__u32	type;
> -	__u32	padding;
> -	union {
> -		struct iommu_fault_unrecoverable event;
> -		struct iommu_fault_page_request prm;
> -		__u8 padding2[56];
> -	};
> -};
> -
> -/**
> - * enum iommu_page_response_code - Return status of fault handlers
> - * @IOMMU_PAGE_RESP_SUCCESS: Fault has been handled and the page tables
> - *	populated, retry the access. This is "Success" in PCI PRI.
> - * @IOMMU_PAGE_RESP_FAILURE: General error. Drop all subsequent faults from
> - *	this device if possible. This is "Response Failure" in PCI PRI.
> - * @IOMMU_PAGE_RESP_INVALID: Could not handle this fault, don't retry the
> - *	access. This is "Invalid Request" in PCI PRI.
> - */
> -enum iommu_page_response_code {
> -	IOMMU_PAGE_RESP_SUCCESS = 0,
> -	IOMMU_PAGE_RESP_INVALID,
> -	IOMMU_PAGE_RESP_FAILURE,
> -};
> -
> -/**
> - * struct iommu_page_response - Generic page response information
> - * @argsz: User filled size of this data
> - * @version: API version of this structure
> - * @flags: encodes whether the corresponding fields are valid
> - *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
> - * @pasid: Process Address Space ID
> - * @grpid: Page Request Group Index
> - * @code: response code from &enum iommu_page_response_code
> - */
> -struct iommu_page_response {
> -	__u32	argsz;
> -#define IOMMU_PAGE_RESP_VERSION_1	1
> -	__u32	version;
> -#define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
> -	__u32	flags;
> -	__u32	pasid;
> -	__u32	grpid;
> -	__u32	code;
> -};
> -
> -#endif /* _UAPI_IOMMU_H */
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 97f51d5ec1cf..bfd97aaeb01d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11129,7 +11129,6 @@ F:	drivers/iommu/
>   F:	include/linux/iommu.h
>   F:	include/linux/iova.h
>   F:	include/linux/of_iommu.h
> -F:	include/uapi/linux/iommu.h
>   
>   IOMMUFD
>   M:	Jason Gunthorpe <jgg@nvidia.com>

-- 
Regards,
Yi Liu

