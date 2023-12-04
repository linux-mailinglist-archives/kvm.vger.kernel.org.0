Return-Path: <kvm+bounces-3331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B5FD8032A6
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 13:30:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD74A1C20A90
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 12:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7846B1EB42;
	Mon,  4 Dec 2023 12:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FCv68p7l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D4DC0;
	Mon,  4 Dec 2023 04:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701692998; x=1733228998;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0XJyQ5CXDh+dVfGK/3QUaArg3Vsah6buhHzGlH0VBK0=;
  b=FCv68p7lbIIU49uNbzMnMaR4AeZyhr5Ew3NZ+dfxuhGepV3VzdT8djjK
   XanAbBGeEgO4w3PA4dn3ysKf2oFrUcZCAZhL8OUTkjWTpE2HQIU1+UN8z
   MBoJDI7UaIc/K+dM7n5wLiygvS/jTsvCjq+0EmxlL7d0EGCE0MUJjL3mN
   g7Jyh3MIOmRQoKwKIYMnzt+rizk/71YEVZin3SL0wBoxcQO4xnBKT8cZ/
   hifwpxIj+kpUWU4TAK/F1YygQ1GoGwDyOHiyvbix4bwsJgtW7gHOWgXYO
   tIrBhp2WAyvl139BtCX55ZqhtLs/70zgjQe9HQ6xSoHFV+1lxtIC8Bo21
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="770205"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="770205"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 04:29:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="861364041"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="861364041"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 04:29:57 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 04:29:56 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 4 Dec 2023 04:29:56 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 04:29:56 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 04:29:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNKH7PTC/UwSdYr6Ihktd69GEwxg6aGO5dw7hjzraIL7RIBk+rTWdewh9wZaOb2xwjJkaKkCqlRc6X9tXk6gmnymLOl4jl4P5qSzQw3Bq8b3gU4clZ9H57/0VOxinfLSsC5pXAJaq1/hh5arCV5LOjtpqePbTvL9qMCqsBVE6aaiWKbnmkiHVZiEVRLd0nEQV2k6H7FNq+tn0FPwbscWHp6xhCUscyTCRXkLiieiINNkgtWv7X3NHm7p/tDZqoFArwe9ioW6qugYXG2Tnb4iuFuBh3lyCBhRDn6ATnlPcr84wym2QsJyf2SgnV5t/yrF1nNrAx5l1dChzw4A7lLRgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMSqIRCTc5hJfTfHVYSv98jeIOTWncDpOpbQlMMw/gc=;
 b=hyZx0/6B6KfgJ8AlkDn8/wLUZmUPd3Cln9AYbtHPrp5K/wUYUorvKf6iaw8Ea+6gBRrhlP3CKwAKzmA1zmBvqiMy7+GTaqBAjq3u9Sr8j96VpcYs30rpOg19+4+yDirhdqFRCRyprCGtg3y93ZCk9WDRblCPUixtvWguBDF/6JCkTCDTCUme5zKKGWbJnuGNcwM+fMeRDkceqLP3VX4oNRxE81LRhXHGmOyz/C3a+xoNvcYDI1iknBUyeDg7tdfphYqmBOd+ZNEsPuWPWxS7DulLXWDZjIjh+ssTigxwg9fKAErvJ1YeKZg/kkbBeySWn9NQbT+4W0/nOSPDzZlNBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by LV8PR11MB8605.namprd11.prod.outlook.com (2603:10b6:408:1e5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 12:29:53 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%5]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 12:29:53 +0000
Message-ID: <d7978fbf-af12-4787-832f-366b0fddc399@intel.com>
Date: Mon, 4 Dec 2023 20:32:28 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/12] iommu: Merge iopf_device_param into
 iommu_fault_param
Content-Language: en-US
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Jean-Philippe
 Brucker" <jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao
	<yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-6-baolu.lu@linux.intel.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20231115030226.16700-6-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|LV8PR11MB8605:EE_
X-MS-Office365-Filtering-Correlation-Id: de38ed51-a801-4340-4476-08dbf4c4b726
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xPpZRCbhi02DVh3OUOAJ+YLjfJhGsOw12DH6NEyQB9LCNEYfQP6Hg9+NpQuzMNsLwkLcIcKH7AtM4NpKH4ZMbLz2iFlaUQusJaKCB3q3dUyH4VPxON1DCHwZc3vlALS9qwb8ID0KYXJt5ErcSLL65gDE3px01LIrLBh/3Dj2//lVOM1EA8oQWvBVkUaoyNDlRxbbi11mIIpEvXVOZyZU5vPRZ/IjcoMI+H74EIxk1Atz2ik++zlsHJAo9CWgQ1196wXLpSSmuRRO23BgODVCh+SSfUQAdzDAyLg+n3t00St1MGgTfPjDg8dgjXYYG1q5Id+53I6q+RVngNYJKxnfyQVQoZWaY6dqDVIcSi2lsremgCYVf8duXQTjYw047XCdM0WZJMRL1LQf23ipKmJSruUQeot799Qwt1liow/CM2JJ6x4PSPmAdCJjconccBmV6/zBsPd7VY+CZh3O9HJjogOAErZyuRcVr9X0P7RJuLQOmiv39hG1Tga4kiQFfs3Y4UEE3Wudg2w9M0LWJ038qwtJYbyXQPdju/9+Z5BojCorlqdxXHv4BT5Tc6UQb6YfVffA7My5XiGqY5dHuZivPOwXg5Ac1kjJD/yfY6Tx9x3uYJtzMN11oPGHSzVri22h/lInM6nXkCgGWTBi7S5HdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(376002)(346002)(136003)(39860400002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(41300700001)(36756003)(31696002)(86362001)(5660300002)(7416002)(30864003)(2906002)(2616005)(26005)(53546011)(6512007)(82960400001)(83380400001)(6666004)(6506007)(6486002)(478600001)(38100700002)(31686004)(4326008)(316002)(110136005)(8936002)(8676002)(54906003)(66556008)(66476007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGZqVE1uK3NwTFlIa0dVVWZPdUszRmU3MjBiclRHMVJNZ1EwOHFZT2NDZC9H?=
 =?utf-8?B?UnNCcGNseTZ4WC9wSlEyNE5LbUFFV3lqQ3VFQkI3dUJ0cGFVVlVwdGxUcFcx?=
 =?utf-8?B?QUp4Y1BzVGxwRkptam5lNytwMTQ3U09DakVneWNuUUFvNUNuNkVtVUhNYzZD?=
 =?utf-8?B?eGxPZ21JYUtPd1JSYlFObTNJRStkSk1HbEtyNE5vcGdRL2k3QUxUMjlMQ29G?=
 =?utf-8?B?UjFoQVlTajQrdU1xVHFYV3RFSmlydDhHbnl1ZXdwVE1PRjdWcUpxL0hkOHpE?=
 =?utf-8?B?cDNLUjVpSGxuOTkzOHROOFBscFZLWnA3YXZlRm1oeitSd0QyOWFGSzdhNG1i?=
 =?utf-8?B?dEF5VnllS0VGRDZiVEdKTlZuTkoxK0tpaFZZS1ErRFRndEVRV0gvbmprUUNx?=
 =?utf-8?B?eWZicEVEb1hsRytZMlV6U3Q0d1JaTkFoMGcvU2ZNU3pwQ1lqL0xodWhSUWQv?=
 =?utf-8?B?dU1hS3JlTkQwS3VadWJnV2FKN3pvMVMreW1qYkx2NHFBbHlhWll1KzNnL3Ir?=
 =?utf-8?B?QXRKUmRpQjI1M2xGOTNKTG15c3ZORThPa0k4M1JXcDZpMzFBMzU5dEprdUZN?=
 =?utf-8?B?SURUWmdSdkZtUFlxcGdYMmdTSmJ5OHcrYTRPaHFuY05jK25TZ2N1b0tCbXBv?=
 =?utf-8?B?M0pMRXRvSXFqWUN4akVqUzhZOWhGMHZ3RjBRUURBTkJuUUVhVHZMWXhxeWpK?=
 =?utf-8?B?VGZKamNxa1FTRDVIYnNucnhtdGxvc2wvQ3BvblNPUkFjN1lsMzBhZkE4Tjd3?=
 =?utf-8?B?NUI1QzFmUTRUVEJxaURpVEFXWkp1bmZzU2FpZURLdUE2bk93VlIzQWFRYTJH?=
 =?utf-8?B?MnZlT25HN3BGdXl0WnR6OWtNaERkdlhDZ0gyb1VJVXlHRXhNSUlrNnRUVlht?=
 =?utf-8?B?Mm9CQ0V4RVdSRzN1T0VRTjRaOTh5OERrREFudEQvNXpPbWRpYnd2cHZKUmp5?=
 =?utf-8?B?NG1RaTdNZjNaU2JnUmMwNS9HYkJKUFJ5TkE0Y1MxSnk4OWxTWmN5V2tnOGw5?=
 =?utf-8?B?SWhKWkR1OUIyRWVCM002eWhIK0R1QmthaDZITWpNY1BFT1E0VDlzM2J6RnBQ?=
 =?utf-8?B?TDE1UitHeUl4V29IeTFOOUVCckxsenJBWVY4cWozQkEvbjE4M3BsdTBaT0cr?=
 =?utf-8?B?YlZOTXRHcitkQVArai9UR0VsUGc2aEZpK044V2YxeVFSb2tlVjE4QjM0ZDhs?=
 =?utf-8?B?RmZBVll6djQxdElNdXN6TTBaU3pIZDBMNkZyR00yUXJxUVRxUHMyQlFtYk01?=
 =?utf-8?B?Ykp4enhhWDlBaFNVeWVzWjlzcWJKRjl4dzhidTJWVFg5dlJ2UC9WWm9yL21z?=
 =?utf-8?B?YlJ3bW9QTmI5b2xlT0tyNm9URUNJdUdQeTUzQ2NTMHpGR2wrUGYzdHozcjJk?=
 =?utf-8?B?RFM4dC9KVnN6TVVITTBjMGg1d1BlNC83T2pNYVJzYS85Rytwa1hVeDFGdkZI?=
 =?utf-8?B?NHBUcURqbVN2T0N5QlhpVmxpem4rOEVidFZ4THNnM0IxZTBKNjY2YisrSFRK?=
 =?utf-8?B?VmdKa3ltM0FpQnNVRTMxKzM5dVVhYlZ2R29FdTI0WUtOVUoxRXZTY0ZCNkJh?=
 =?utf-8?B?Q2dXS1BxQ3QrS2lTWTdQZnZGSUs4SmVxb0k3UGhOOXNRbUYyVTdnM0JtYWYx?=
 =?utf-8?B?eVUwNUdyM3pPb3p0cGo1emMwdml5MmswVDNlRTJnYmFBOWxvVnJBQVVUNUtk?=
 =?utf-8?B?Mm45SXlLSHBJS3FydXB1cU5pSHl1Z2xtbUY5UjdTNHFQVXFVRGJNMHM1YUN5?=
 =?utf-8?B?bzlqQ0RIcklHMzJKazJjYThQVmhZR3hLd0xxVTl0aGt6Tno5R2ZNOFVvZUU0?=
 =?utf-8?B?WXh5OGdyQVNJRkFhUVJUaGlJV3ZqZEpXdlNFeW56SWR6cFFjMVRVS0pMbVFE?=
 =?utf-8?B?WXFTbHYxNEhzL1JlM2I4SHNzZFlpay80OXp4aG13WU10TTgxS0ZuUHhjdnVM?=
 =?utf-8?B?K0tWUnZYbzg3NU5idkQzSjk4SS9mbzVKZWwwKzVXc29vUjZZR3FiN2dyNzht?=
 =?utf-8?B?SkhsMTNGa3BXbk9PYVJwNE13UXExWThRSHMxMHRubk1yOXhHZXNISzJPbkY2?=
 =?utf-8?B?QkhXTGlLWWRSN2N5NStiWHpFMngvcGQxQjJycFdURU81cG51eXRrbFcyYmhZ?=
 =?utf-8?Q?qHkKcYmXxyYrm/+iA66oXtI9f?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de38ed51-a801-4340-4476-08dbf4c4b726
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 12:29:53.4674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: um6YNn8k87fsWhYXw1BGtpyR5ISWRC9GsMJjoXPjFYlfapdJ4bwqZDUzy66o8s66YHhBHaLl3rK/Vz8nmeU0vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8605
X-OriginatorOrg: intel.com

On 2023/11/15 11:02, Lu Baolu wrote:
> The struct dev_iommu contains two pointers, fault_param and iopf_param.
> The fault_param pointer points to a data structure that is used to store
> pending faults that are awaiting responses. The iopf_param pointer points
> to a data structure that is used to store partial faults that are part of
> a Page Request Group.
> 
> The fault_param and iopf_param pointers are essentially duplicate. This
> causes memory waste. Merge the iopf_device_param pointer into the
> iommu_fault_param pointer to consolidate the code and save memory. The
> consolidated pointer would be allocated on demand when the device driver
> enables the iopf on device, and would be freed after iopf is disabled.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   include/linux/iommu.h      |  18 ++++--
>   drivers/iommu/io-pgfault.c | 113 ++++++++++++++++++-------------------
>   drivers/iommu/iommu.c      |  34 ++---------
>   3 files changed, 75 insertions(+), 90 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 79775859af42..108ab50da1ad 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -42,6 +42,7 @@ struct notifier_block;
>   struct iommu_sva;
>   struct iommu_fault_event;
>   struct iommu_dma_cookie;
> +struct iopf_queue;
>   
>   #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
>   #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
> @@ -590,21 +591,31 @@ struct iommu_fault_event {
>    * struct iommu_fault_param - per-device IOMMU fault data
>    * @handler: Callback function to handle IOMMU faults at device level
>    * @data: handler private data
> - * @faults: holds the pending faults which needs response
>    * @lock: protect pending faults list
> + * @dev: the device that owns this param
> + * @queue: IOPF queue
> + * @queue_list: index into queue->devices
> + * @partial: faults that are part of a Page Request Group for which the last
> + *           request hasn't been submitted yet.
> + * @faults: holds the pending faults which needs response

since you already moved this line, maybe fix this typo as well.
s/needs/need/

>    */
>   struct iommu_fault_param {
>   	iommu_dev_fault_handler_t handler;
>   	void *data;
> +	struct mutex lock;

can you share why move this line up? It results in a line move as well
in the above kdoc.

> +
> +	struct device *dev;
> +	struct iopf_queue *queue;
> +	struct list_head queue_list;
> +
> +	struct list_head partial;
>   	struct list_head faults;
> -	struct mutex lock;
>   };
>   
>   /**
>    * struct dev_iommu - Collection of per-device IOMMU data
>    *
>    * @fault_param: IOMMU detected device fault reporting data
> - * @iopf_param:	 I/O Page Fault queue and data
>    * @fwspec:	 IOMMU fwspec data
>    * @iommu_dev:	 IOMMU device this device is linked to
>    * @priv:	 IOMMU Driver private data
> @@ -620,7 +631,6 @@ struct iommu_fault_param {
>   struct dev_iommu {
>   	struct mutex lock;
>   	struct iommu_fault_param	*fault_param;
> -	struct iopf_device_param	*iopf_param;
>   	struct iommu_fwspec		*fwspec;
>   	struct iommu_device		*iommu_dev;
>   	void				*priv;
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index 24b5545352ae..b1cf28055525 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -25,21 +25,6 @@ struct iopf_queue {
>   	struct mutex			lock;
>   };
>   
> -/**
> - * struct iopf_device_param - IO Page Fault data attached to a device
> - * @dev: the device that owns this param
> - * @queue: IOPF queue
> - * @queue_list: index into queue->devices
> - * @partial: faults that are part of a Page Request Group for which the last
> - *           request hasn't been submitted yet.
> - */
> -struct iopf_device_param {
> -	struct device			*dev;
> -	struct iopf_queue		*queue;
> -	struct list_head		queue_list;
> -	struct list_head		partial;
> -};
> -
>   struct iopf_fault {
>   	struct iommu_fault		fault;
>   	struct list_head		list;
> @@ -144,7 +129,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
>   	int ret;
>   	struct iopf_group *group;
>   	struct iopf_fault *iopf, *next;
> -	struct iopf_device_param *iopf_param;
> +	struct iommu_fault_param *iopf_param;
>   
>   	struct device *dev = cookie;
>   	struct dev_iommu *param = dev->iommu;
> @@ -159,7 +144,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
>   	 * As long as we're holding param->lock, the queue can't be unlinked
>   	 * from the device and therefore cannot disappear.
>   	 */
> -	iopf_param = param->iopf_param;
> +	iopf_param = param->fault_param;
>   	if (!iopf_param)
>   		return -ENODEV;
>   
> @@ -229,14 +214,14 @@ EXPORT_SYMBOL_GPL(iommu_queue_iopf);
>   int iopf_queue_flush_dev(struct device *dev)
>   {
>   	int ret = 0;
> -	struct iopf_device_param *iopf_param;
> +	struct iommu_fault_param *iopf_param;
>   	struct dev_iommu *param = dev->iommu;
>   
>   	if (!param)
>   		return -ENODEV;
>   
>   	mutex_lock(&param->lock);
> -	iopf_param = param->iopf_param;
> +	iopf_param = param->fault_param;
>   	if (iopf_param)
>   		flush_workqueue(iopf_param->queue->wq);
>   	else
> @@ -260,7 +245,7 @@ EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
>   int iopf_queue_discard_partial(struct iopf_queue *queue)
>   {
>   	struct iopf_fault *iopf, *next;
> -	struct iopf_device_param *iopf_param;
> +	struct iommu_fault_param *iopf_param;
>   
>   	if (!queue)
>   		return -EINVAL;
> @@ -287,34 +272,38 @@ EXPORT_SYMBOL_GPL(iopf_queue_discard_partial);
>    */
>   int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
>   {
> -	int ret = -EBUSY;
> -	struct iopf_device_param *iopf_param;
> +	int ret = 0;
>   	struct dev_iommu *param = dev->iommu;
> -
> -	if (!param)
> -		return -ENODEV;
> -
> -	iopf_param = kzalloc(sizeof(*iopf_param), GFP_KERNEL);
> -	if (!iopf_param)
> -		return -ENOMEM;
> -
> -	INIT_LIST_HEAD(&iopf_param->partial);
> -	iopf_param->queue = queue;
> -	iopf_param->dev = dev;
> +	struct iommu_fault_param *fault_param;
>   
>   	mutex_lock(&queue->lock);
>   	mutex_lock(&param->lock);
> -	if (!param->iopf_param) {
> -		list_add(&iopf_param->queue_list, &queue->devices);
> -		param->iopf_param = iopf_param;
> -		ret = 0;
> +	if (param->fault_param) {
> +		ret = -EBUSY;
> +		goto done_unlock;
>   	}
> +
> +	get_device(dev);

noticed the old code has this get as well. :) but still want to ask if
it is really need.

> +	fault_param = kzalloc(sizeof(*fault_param), GFP_KERNEL);
> +	if (!fault_param) {
> +		put_device(dev);
> +		ret = -ENOMEM;
> +		goto done_unlock;
> +	}
> +
> +	mutex_init(&fault_param->lock);
> +	INIT_LIST_HEAD(&fault_param->faults);
> +	INIT_LIST_HEAD(&fault_param->partial);
> +	fault_param->dev = dev;
> +	list_add(&fault_param->queue_list, &queue->devices);
> +	fault_param->queue = queue;
> +
> +	param->fault_param = fault_param;
> +
> +done_unlock:
>   	mutex_unlock(&param->lock);
>   	mutex_unlock(&queue->lock);
>   
> -	if (ret)
> -		kfree(iopf_param);
> -
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(iopf_queue_add_device);
> @@ -330,34 +319,42 @@ EXPORT_SYMBOL_GPL(iopf_queue_add_device);
>    */
>   int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
>   {
> -	int ret = -EINVAL;
> +	int ret = 0;
>   	struct iopf_fault *iopf, *next;
> -	struct iopf_device_param *iopf_param;
>   	struct dev_iommu *param = dev->iommu;
> -
> -	if (!param || !queue)
> -		return -EINVAL;
> +	struct iommu_fault_param *fault_param = param->fault_param;
>   
>   	mutex_lock(&queue->lock);
>   	mutex_lock(&param->lock);
> -	iopf_param = param->iopf_param;
> -	if (iopf_param && iopf_param->queue == queue) {
> -		list_del(&iopf_param->queue_list);
> -		param->iopf_param = NULL;
> -		ret = 0;
> +	if (!fault_param) {
> +		ret = -ENODEV;
> +		goto unlock;
>   	}
> -	mutex_unlock(&param->lock);
> -	mutex_unlock(&queue->lock);
> -	if (ret)
> -		return ret;
> +
> +	if (fault_param->queue != queue) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	if (!list_empty(&fault_param->faults)) {
> +		ret = -EBUSY;
> +		goto unlock;
> +	}
> +
> +	list_del(&fault_param->queue_list);
>   
>   	/* Just in case some faults are still stuck */
> -	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list)
> +	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
>   		kfree(iopf);
>   
> -	kfree(iopf_param);
> +	param->fault_param = NULL;
> +	kfree(fault_param);
> +	put_device(dev);
> +unlock:
> +	mutex_unlock(&param->lock);
> +	mutex_unlock(&queue->lock);
>   
> -	return 0;
> +	return ret;
>   }
>   EXPORT_SYMBOL_GPL(iopf_queue_remove_device);
>   
> @@ -403,7 +400,7 @@ EXPORT_SYMBOL_GPL(iopf_queue_alloc);
>    */
>   void iopf_queue_free(struct iopf_queue *queue)
>   {
> -	struct iopf_device_param *iopf_param, *next;
> +	struct iommu_fault_param *iopf_param, *next;
>   
>   	if (!queue)
>   		return;
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index f24513e2b025..9c9eacfa6761 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1326,27 +1326,18 @@ int iommu_register_device_fault_handler(struct device *dev,
>   	struct dev_iommu *param = dev->iommu;
>   	int ret = 0;
>   
> -	if (!param)
> +	if (!param || !param->fault_param)
>   		return -EINVAL;
>   
>   	mutex_lock(&param->lock);
>   	/* Only allow one fault handler registered for each device */
> -	if (param->fault_param) {
> +	if (param->fault_param->handler) {
>   		ret = -EBUSY;
>   		goto done_unlock;
>   	}
>   
> -	get_device(dev);
> -	param->fault_param = kzalloc(sizeof(*param->fault_param), GFP_KERNEL);
> -	if (!param->fault_param) {
> -		put_device(dev);
> -		ret = -ENOMEM;
> -		goto done_unlock;
> -	}
>   	param->fault_param->handler = handler;
>   	param->fault_param->data = data;
> -	mutex_init(&param->fault_param->lock);
> -	INIT_LIST_HEAD(&param->fault_param->faults);
>   
>   done_unlock:
>   	mutex_unlock(&param->lock);
> @@ -1367,29 +1358,16 @@ EXPORT_SYMBOL_GPL(iommu_register_device_fault_handler);
>   int iommu_unregister_device_fault_handler(struct device *dev)
>   {
>   	struct dev_iommu *param = dev->iommu;
> -	int ret = 0;
>   
> -	if (!param)
> +	if (!param || !param->fault_param)
>   		return -EINVAL;
>   
>   	mutex_lock(&param->lock);
> -
> -	if (!param->fault_param)
> -		goto unlock;
> -
> -	/* we cannot unregister handler if there are pending faults */
> -	if (!list_empty(&param->fault_param->faults)) {
> -		ret = -EBUSY;
> -		goto unlock;
> -	}
> -
> -	kfree(param->fault_param);
> -	param->fault_param = NULL;
> -	put_device(dev);
> -unlock:
> +	param->fault_param->handler = NULL;
> +	param->fault_param->data = NULL;
>   	mutex_unlock(&param->lock);
>   
> -	return ret;
> +	return 0;
>   }
>   EXPORT_SYMBOL_GPL(iommu_unregister_device_fault_handler);
>   

-- 
Regards,
Yi Liu

