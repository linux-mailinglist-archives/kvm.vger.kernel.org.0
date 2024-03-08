Return-Path: <kvm+bounces-11392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19FA6876C00
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 21:46:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50ED3B22242
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 20:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933FB5F85B;
	Fri,  8 Mar 2024 20:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XkH+Fx//"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134E85F84B;
	Fri,  8 Mar 2024 20:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709930776; cv=fail; b=V0pwvItjC1WF9VjuQKAKQWans1uyoaU2vh7o1vJWLPHQUf4LkPwBLbNqjAgP3DyZkZgWitCmE1a2bNL8e3gyu8B34dC6WnN2M4U7I7ss7QNa2rgU9EEH7nn3XCJuk1XK8CVPaqYR5erqoGZhOh28pI9UCxWbx1ay7bJpK0FqcFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709930776; c=relaxed/simple;
	bh=K4k1fw0ggRc2QwLZkAxq8yKzAanRbLjwBZ+44YGhKEY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hjyqAZRnPZVbC5MynG99N6BFyN5ofP7rMg4jli97MJzZvdwZDXmcSo8gWfOfSgxhYG/K1cUz7nIYAnIvw58rFOrrZmqD9sN3JghrYsiX0OJjOAZ62jnG+5+7Yx1jTZUWNdMo72He8vfLOSW/oEGUvpWapnNnr69ztFWsXhDlyrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XkH+Fx//; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709930775; x=1741466775;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K4k1fw0ggRc2QwLZkAxq8yKzAanRbLjwBZ+44YGhKEY=;
  b=XkH+Fx//6FbEo6MsiM4La+8qjjUhKUvSvEGzJxa9Bj9UKEv/duhcbpqK
   yXUt+KLK5R1fgZ0EMN3fxatC7mORWdN5iW1W4v5TfUvcJmbDCMzmFx5SA
   1rPeBExeG5bUkBx0ZdQIb5C1svRIaur9v/OTztyxDCqLd55PWbD+iEVDc
   LvtmMpiRa9fzXMdBJkpBjMK0EESBA9AxkbjpssK2azEFCAsuQ6Sstf1bQ
   quf29gHkrFCwxzfArLPpILK5yWzdroKHwjEs1XeYSEqk7vlHiA3WUwlWX
   v7ceOsqeUXlwi+WLZgps+UhXzt6cGkYNPRto3gJSbfN4F5ArJQ63K5jXM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11007"; a="8483757"
X-IronPort-AV: E=Sophos;i="6.07,110,1708416000"; 
   d="scan'208";a="8483757"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 12:46:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,110,1708416000"; 
   d="scan'208";a="15064720"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Mar 2024 12:46:14 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 8 Mar 2024 12:46:13 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 8 Mar 2024 12:46:13 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 8 Mar 2024 12:46:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnUebs1xkc+7tacelgWdWzJXwpZ1CpsnYqA4mRjqYQysWkTzVIC0Wrkd87XHpqQSWOvYU8DtZWG/HtnC2NhnORZQl9n0APycD1PU1RnGvbKvwris140Hgc/tcFOxAZMP1FMwEZHlF7qa+u4VWXC8j3fA6UV34vglWy0jQ9azChTZTym2hLzoJvTUMr1aCJ1Q0ZEouQBcgLRbAQEJT6bWb5UKh1JzhDiUhwyWLXXxd+K9yE+PKLk7PNMCpmW5TcXe1vwaGqKs3I0q1vXeaKmBaZ1EHn2a1D1u3yqrUmfE94gbH02FD1r1GbcVCpdIZOrUb/vtDB++XdJt+CWW/2Em3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bAtahP0yM4748qmpRPisorbtBY1zGRzP4A5ddvLuiPg=;
 b=eJZkkW8dkHUxWGv0y1Fx64tnH3ViZNyBxL+K1QOFobp4UF+kmfZZEQ34hNzdM1BTF6kGxnnx3hF925bEWLtMdxk/e3fRGUulJuBxNKhIe1HXsn0JD5ILqtVCDIAmy8nvNV18g+/w+S/niEEMX5Cv5Ujhj4Rf0kWmSUuo+uXAFVSYQMJ7islKFQKNRguLMrc43rruRMfU27pldcQzeUuCN6knDb+f8gABMmr8YbrxE8Jk2kfy7zXgehvcYYjBRMyYZiP4qdA28p623Ju4XO1ofEK+HhUCBWlnhS3AOiThIpHqO3TeqOBY7RzgvLmvsKC41TMH9tO81Z+q6TaaFa+vEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.10; Fri, 8 Mar
 2024 20:46:11 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7386.006; Fri, 8 Mar 2024
 20:46:11 +0000
Message-ID: <346188f0-5f87-4ee7-971b-a6832dfbd5eb@intel.com>
Date: Fri, 8 Mar 2024 12:46:10 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] vfio: Introduce interface to flush virqfd inject
 workqueue
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <eric.auger@redhat.com>, <clg@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kevin.tian@intel.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
 <20240306211445.1856768-4-alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240306211445.1856768-4-alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0316.namprd04.prod.outlook.com
 (2603:10b6:303:82::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: d875efbc-5bdd-4763-9841-08dc3fb0c9bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7JEQK9EX9QzJM1iavcSD1yTh0NvMBnntRa87m78Z26P+xZkwO28nNW5ZyI0TBeeqm0AGeGJZrQ+rpx6XPzIOx39tQduyVggqSZGcQvEIh5daEA8yXpedRxZGgLIkbGR+kJQkfeJpvjx7KXxaPTlzXoy3oyvQaFOymIsx8JpcJMs09IuWNtWEYr4/5FTn8QvprzFM+fQUE9RJR4hcU0UoQc2nIAY9xKJyeH6t5fVTZhesPIeHmSFFYcRQT6wW4ArszJEyrQtJ0cfRhjDk/Fsl3yqLZBYE7lay2Ib/cYkaByZAs1b8eYOcXAWRosEIyfRgjGfgLTjqmIHsJAPqxgBWYNBiWumcpnebnqdzza16emSHocyepkwBnIN/6NuMHEk0B0ZY1ax2qXd1u6GIu/xZIqXOu94E5/LOjv5rxudW30uKUCBf7T8umt8Il510D7dNDnC65Nf/+SXPH81hqmhSRVeJV68y6G/Fihy43TCs2zJWIOr7xW+56TssdIwuv8qVji8Wl8RQMDwKJgj+34mqM5JggIcqdg+jl6JU2qYAKyDFpUXTnvzuDAEI2t4Gqia8y7ZkxIyNSh9173pBWXY+avnx1mx2AEAdeaalANVkIzQBeyl4gb2LQFudh+qa6IhOnEhThYMp6niXhToD79P8o2ZROicziQCU645dl93xBds=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmJJalpQS1M5dW84aTZvdHNQZ2dhMjh1S2VMTlA2WDlMczMrZGk0MHNRV0Q0?=
 =?utf-8?B?MEVKK2JqQzVSRzFCQjhjNTByQTQya085aHRpcndXZVl3bWs5K1NXUjBaR0F6?=
 =?utf-8?B?RkpsYy9VN0tXMmxlTUU4KzE4NnFheXhFdzNXem51TzVzTWhHSVpnc2hOUnFl?=
 =?utf-8?B?SVRTTGNNOHp3YVdxZG5DSklmQkZLR3pQcXlnL2JMcWtURzJVM2s1NUFYOGNE?=
 =?utf-8?B?UC8zdm9rdVlNbTZtYUNiLzVESENtcEoxUnNGSEpUVnkyeTk0RndIWERLcHgz?=
 =?utf-8?B?ajh6ZjREc1l0VkZxTVNuN0RNdjlzVXM0U3JOSzVGSlVWL0ZKVmFwT3ErYWtD?=
 =?utf-8?B?OG5Nb1FlTGp2YTVJRUNzbGQybzBDSW5yeVVEdlpvVkFMSGhEZmtibHVvaVlY?=
 =?utf-8?B?Y09uV3NwMG5BN2hpTjBVOFdFWEtLWmZscks3NnZQaW95MG5BQ285NW9acGs4?=
 =?utf-8?B?a1RieHlTc1k5QncxSmZQMEsrYmsxNnM5aTcyTHpqRkI2K0JRditGUklMSVYv?=
 =?utf-8?B?djk2dXpsV000OXRqQzBBeGlVRTMyTU55R1NJN0hBMlVmb2wraFArSmptYUEz?=
 =?utf-8?B?NWJiVG5BWVRqekNsTk1hcFpTWm9HSGFDQURtOWpXQnYxRzBnQUhNTEJRWjF4?=
 =?utf-8?B?UDZmUUVUeFlOV2VCbEc4ZWJBWFNHK2FadWFxM1JXbVRXTVVodXY1UGpJTkNW?=
 =?utf-8?B?WldVdzdJeDFiQktud2pGMjMwRUt4OFZYZG5WVzZqVkJQYmtGVk45eGVuV3BU?=
 =?utf-8?B?TThhUzlYb0JEZ0tBV2s2K0JhZkl4YVRwalFPOXBnSWVLbS9DdU90SWhkbXhj?=
 =?utf-8?B?Z3pvMGZMZ3RNdEVvVWxHY1F5RllYbUVnTzNjVm5NUzhGMkRBdFlSYjhDdDZV?=
 =?utf-8?B?VEdKSDhsUVVrTEZMQjNvRzFGS1JNU0pKQ1oveHBOYUZIcWpoWTY3YytOeTN3?=
 =?utf-8?B?Y1RCb1NQYVJzQUt1a01zNVM2RGowN21laXpLQ0sycnNNUUpxMWtiTkpSSWNR?=
 =?utf-8?B?WXBrOTE5bWJsRldpMDU0UlBkZ2wybGRlb1BIc1Z4dUZsbWFzZ1RCU1pEZ0Qz?=
 =?utf-8?B?eEN3TFp1Unc1ZEtQZy90RnBWaEN1SlQ1UHY1bE13dUZYck5PZ1FsaXRIeEpH?=
 =?utf-8?B?bmdrbGtpMk41a2Z2WnNoWi9aNS81ODgvZld5NkF0ZmpLWENhUXRWNlIrYUJw?=
 =?utf-8?B?cStGTWxMVHJWdTkyVWFDV0dWQjhoK3h2UjJDMFhoQkorVm40aVpoNnV6TmN1?=
 =?utf-8?B?ZnUwcDJ2NG1qMEpSd2p1NGRnRE8xZml5eDdLZE9GdVVCWTBJMWZaVms0M2g3?=
 =?utf-8?B?eHVsb0VhRnl6dHRMcUVBK1g3TnhiQmFES0JPWnZqa0tEYlRQTDFKUm5mWFY0?=
 =?utf-8?B?RlRPNG00UHNHWEpROU1jZWYxTE5lekRPdVBkSStPa3EyU1NoMDZQKzFZWXps?=
 =?utf-8?B?MXJVQ282MmJEMEpJblhpaDZNRlZvWi9mTXFocHUzZmplWEc1VUNmUlNhdUcz?=
 =?utf-8?B?MC9mR083WU42YjFHbUhCeXVUbmdWVUpSTFlZRSszalhPeHQyR2lqcUxMUG1E?=
 =?utf-8?B?Q2hPSi9uZUdiTHFPWTVHQWpkY3F0clllejdmMnlBSUVOcDE5S0RIWnp0QnIx?=
 =?utf-8?B?R0NaemZrSWNQQW16bkZGOE9sUzNYSmdoQk5ja0NOcG9TWXFFaXBUM25kSkNQ?=
 =?utf-8?B?Q21UOXA4RFNMd05Tb3pFcWVTWTF2U0N5MmVTdGVyL1psK0UzYXRwRkdUMFk0?=
 =?utf-8?B?R0FuejBjTFJZVGZPWFpqSUI1ZjlyTUV0ZnZjMk5yazlZTURPK25BSUFvM1k2?=
 =?utf-8?B?RjlQOFB6YmZmTXVJZDhaU3FhbW9QV05sNDROemVHUkx1bDlOdUd6bDR2OU5X?=
 =?utf-8?B?Qk1vYU93SXpGUmNtQXUxSklDbXozSGozcE5RVGd5K3g5OGlIRG5UdFIrbm10?=
 =?utf-8?B?RnpLWUNoYkprV1JhR2FTRmlTaHBrUE5lcHNVaEVhbFpWOVdTNGZ5dW1URWt4?=
 =?utf-8?B?bkloRkVMWnZrTjdFV3BvMDRoSWp4MUhoQ3Vqb21UOUxpcjZ1NUJqUW1aYWN1?=
 =?utf-8?B?dVJuRzZMb1o3c3F1YzVsQi80MzB6bHk3dzRPcS8wWFladCtaMWEwREE5emRG?=
 =?utf-8?B?SW1TRWJYZE1CZTJzOUtzNXlVeFVucDVqWUI5eU1GUDdoUUU2emVlVmJnNGRU?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d875efbc-5bdd-4763-9841-08dc3fb0c9bb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 20:46:11.2362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kaZO565ifcHY/90WlUkJJkynJbC42vU6MpY2JDkIZtC8S+XUCRxfHS3f1NcHBokYUZWo6lVpW0L1F1VGQ6dNwqovMu/KOkXhcc9mliXkM4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-OriginatorOrg: intel.com

Hi Alex,

On 3/6/2024 1:14 PM, Alex Williamson wrote:
> In order to synchronize changes that can affect the thread callback,
> introduce an interface to force a flush of the inject workqueue.  The
> irqfd pointer is only valid under spinlock, but the workqueue cannot
> be flushed under spinlock.  Therefore the flush work for the irqfd is
> queued under spinlock.  The vfio_irqfd_cleanup_wq workqueue is re-used
> for queuing this work such that flushing the workqueue is also ordered
> relative to shutdown.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

Thank you very much.

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

