Return-Path: <kvm+bounces-15052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BE98A9181
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 05:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D9F11F225F6
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 03:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E474F8B1;
	Thu, 18 Apr 2024 03:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LWR6Bfz/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1FE1EB46;
	Thu, 18 Apr 2024 03:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713410332; cv=fail; b=iWy1E68LiNPn/PBalddPbDdIBHaCFNelTNPWNKMM3BLfY98Mky9Bi9tYPQgu9xtSGCSiVoYYQRPGQoNdY+M98mbt162/xZKiKCvlYYoAcpZ8SNoF6LIobDyTys8l+AwOq17nsh2HDcG7xzbW2Kq5Phc7fK9UVUqjfvPrhmvrK4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713410332; c=relaxed/simple;
	bh=0b3qDY01n6djr0T2tgkSzS79l16uRhXB0uehEfOez44=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R4teMa/lvGgOqUeL0sr6YKEXp7lifLhcE26VMQ7k490MSBWlelBfD7bmh/QuAspKoc0qZFlWaAqNL5Wyp82PXXFrRLbgKwLkKpvN1bXn8wu49sb0o1tir/OnbFvJsp21hvhdYPiWhSDJSRP3cCzQ2g6B+cCPp7RpFpdL2kNp0zI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LWR6Bfz/; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713410331; x=1744946331;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0b3qDY01n6djr0T2tgkSzS79l16uRhXB0uehEfOez44=;
  b=LWR6Bfz/bH00Y2DUeSMGkOFlfTOQhxmFr6iZ3VsMb/GdujEdcmxex4W7
   qj+jS9m6b/vfJ2L04HNhHt+/LgO/hZxBSZwr2ldPFIquN2DNxLX+aKYqb
   edgmyQW1azAAfbeCkQLyTlYm1js51Zh4Ed4GpTFIL8++CpNeln67SoRrn
   xK+SpzSF0B/0hg6YD1+H4UCeo4Xchah/o9Vvnww3oposiID3oNhKJz86H
   i/JlKqj3+NYv9JUE170Ox2BVhAT8Fwjz3TyZC77zkvgSg9YHhbbbzoBWs
   8OlAcG8zFDRW/XChl/LtANu4I8xZHngItqkmu+N9YtQR6WcSwoYSqC52O
   w==;
X-CSE-ConnectionGUID: YoZOT/o7TC2UkwggCNKfjg==
X-CSE-MsgGUID: hSE0XrM4StKNrHxC7VbzcQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8797883"
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="8797883"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 20:18:50 -0700
X-CSE-ConnectionGUID: HjroCpaCQPOrvP1yQ0A7tw==
X-CSE-MsgGUID: jgXrCGCURS+1YyAi9xmEzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="27465428"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 20:18:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 20:18:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 20:17:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 20:17:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 20:17:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwD2uQjk8Slsu6sYCrzeWi4zI/XNs/BlFvLP6vvccmYQcLqVIyUCtESY4RIc4nHoRZKQyfv2XwN/7VWLq+aqY5kR75Dg/VYL9kQRIQtuSRD3TDdj2N1TEOKd1s75zFCEiCvS+89YtErjvNd451yE17fhBru3q+76VFa9Ao7VSEMIGa02EdbzlOO6iap/vFgLtYcRnIhYysn5CuQoVR61tS9w1fqu9cLnMUkT+0EStUHfPRSn4fbuRq2P5iARmHqLzzMPvNynTGoMr4/OyKZLZh5G62lduL3+iXxhzGq/2wiPP7nKvsUQJAjaND/5gc79QhY1dUp+utLatce7824fVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4vG5hIJDAm4LaERd0FKhMI1S7EzeTLcm9LTfq4Z9Xw=;
 b=kObeeviKuB262BtKkhzZWppkDlIKF+2f8PNXl0Ov5Ke4IoZK/czhfzb1NBPWm4mJkMmTQDsjIzXXxamnKaC3JVO3QR4roJl6pqbVg80OAT5QitsCsAa+IcReYnJXqHd27A2qAJ1gb5a1bmYzdcvmOZmslglut9PksUS2HWMdwFhp1VzF6sz+G+0r60kR+27gSs/LFxG4vtOBxNyUX0ZWon3A2tcFkhESmA2C8rL0ZKkl3ODKrPzmK/Gya6d3444b6RxQOOC9rRJ9ssPGVcnAcNIC6+8kOO7NxpCk4xufYG5OtVd7XTsJiVP494ZVdyPRa3CQ1bbuopCNUeZ6i+Mi9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH0PR11MB5300.namprd11.prod.outlook.com (2603:10b6:610:bf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Thu, 18 Apr
 2024 03:17:45 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7452.049; Thu, 18 Apr 2024
 03:17:45 +0000
Message-ID: <b8cef0a5-b9fd-48a2-b23d-2bbcd793e2f8@intel.com>
Date: Wed, 17 Apr 2024 20:17:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/pci: fix potential memory leak in vfio_intx_enable()
To: Ye Bin <yebin10@huawei.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <tglx@linutronix.de>, <brauner@kernel.org>,
	<kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
References: <20240415015029.3699844-1-yebin10@huawei.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240415015029.3699844-1-yebin10@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:a03:333::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH0PR11MB5300:EE_
X-MS-Office365-Filtering-Correlation-Id: db2ab49f-3521-4192-395d-08dc5f561e1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5e9YHej0OMeE8ufflGLB1m+/WU78j4Z5UwBTtX73PnyiwLf7EmiFzMZrZP2wm051B3uBjWfLXm6vFMNWDkQAmSh2UvjYshAkA8viEvll+gcLimBCUKostQyZ/tFdbNqHtTAE5BtDg++SsKfhlEcMqBlT0Aks2PaN0sDbDS4Ejc1ytgoyY4YcF4i26z82syNOyxQN5xsxCu3xzYXe5j0YSo+39Yny87BgDkk2smvH6mM2BdZLSLw4FG9ykmfu7huS4H4u6Rx3ZJynC25e7alfSFfxns4EI3Khrv7B0udkhbHCOMelIX0oDPNiDUEGWJJgQ5VwFQM5fxJt5MFR/CE1zt1duUdcd3F/if6Iq/aU7nu6bXEQJFCFRCmRPJO1BApQgG9h9Rhj/20TlRmd2SKlkLIWdDQXzVDc5Ubs4oYW4dIuAEjJoF1azFlbQ9+bdV17kXl1R17SHkOiudNvz9hjqcdJ2JKENYlEi9wucK89VWIVJH3cEuusBaQ8RfR86lkwjufsYerrbP40FgHPOr65Fj/XHuPd+5JnRud2uFVVvIQpY3FOl5hPDwEUcGsCNg8tA3/WTd9jSmYyfjR8sWVkcoBgsD89C41/muiujnIztkJgkWSRrvCHuKxa7xyK7lkFWg8nI3ZitTv0BimX0+lcUil0xtHFRsvp0Eyvm90Ivbs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWRCZW8rMDM2U2FVQXVSdjlUTmtSM0pVYkRMaVRWZnZ0U1BHVDlxVjhHdmo2?=
 =?utf-8?B?UG9lYTBNWEFkVnpkUFlwa0JqR1lvQUtXSXRmSVE5OElkejlWU0RyZ2tySDRq?=
 =?utf-8?B?TDFSdHd6Y1pNOGZmZnlDQlY4MjZzdmdkNmpLbmF6ellKRFZtdlozNk4rMEdZ?=
 =?utf-8?B?cUMwOTJndElhVXBCc2paYnIxMnh0MFFKVWxIZmE2RWhpNW5hd2JYZDRIeko3?=
 =?utf-8?B?bElDUVFxZEtzcUNkZWQvVmc3V1BxVytBSmtOaU14eDF2S2p2dnlxRmRoZ294?=
 =?utf-8?B?UzQzbFRKNXZYWFVkbzU1aU9SOXoxS3lGR3M4ZmRvemh1RDNnRk4reFFhNzVT?=
 =?utf-8?B?N1piUTdFYzZiNU9XakRvaGdiY1NWT2YwUjNtcFVrUWJmQXNNRWdGdmpnaWF4?=
 =?utf-8?B?QlB3OGhBQTRaOXp6bTZHOWVoUHNIZm5rU2d3TXBNV1l6YXhSTnc2M3IwYngw?=
 =?utf-8?B?UWp6QTluWWNXYXYrQm56VmFJbWoxN1hRU1NKeVBYd2tnUUUxYnRGMXdhZ1M1?=
 =?utf-8?B?Wi9zc0JySm9MNktMdDZycEhmN0ZsbXUwYlF0TUVxWE1BVlJGNXN0VzBmN1du?=
 =?utf-8?B?cXZMVmFnTFVnSk5lZG9DVUhUaDMvdWRoRGdQMWFUd05YTVF0dVJVSDVNNnVX?=
 =?utf-8?B?YThFRW40eDMvZi8rejNkczZ6UEpESTI1VENDTDR4T0p5alJ2RHVzanNQUlRU?=
 =?utf-8?B?ZFpVK3VmVUZpUk1KdXc2Y0ZpNlFSaTZUaVJDSzRkaHZzL3FyYml5ODVwbFN5?=
 =?utf-8?B?WjlOc1J4MHhXY1Jtdk9ZcVFlZDdMdUVhQmZMQ05iQlMyUDNWaTF4Y3Vkbm9i?=
 =?utf-8?B?NlFwTlhPNG4xRnVHUUlkSVpXL3RsSStsUVc2dUhWcEljeHlmVE5tQ0luZy9B?=
 =?utf-8?B?K1VGaXMrbnI3SDQyVDMxS2hCODNBanMzM1FCTUk5a1N0N3J3amxGL2NORktm?=
 =?utf-8?B?Qkd4TnhJTTZ2QUx6eEorUWJ1bzk4UGpCMUNIcUU0clpyVjlOdGdHRXRqUHJL?=
 =?utf-8?B?ai81QUw2YlJjUzgyQjVsUUVCbzRTTDJhQndxS2ovamlxZ29rc0I3UEgzaFlp?=
 =?utf-8?B?Qk13L005L29qVzFYMUlxOE15RnZzQkNBcjRZd2ZybWZ5TGl5T3BLZUtVaXZw?=
 =?utf-8?B?cU9qQzRXVFdTTmpFRk9TOWhzaGYwQkx1TjlTZVExUW1kcFovb1R4M2cvNlE4?=
 =?utf-8?B?c05HdjVGSVByeEk4Vk9UMys1dGZ2QzhhdktqZ0RyR3I0SmRTTkkxRUMwN2tl?=
 =?utf-8?B?VkNYYzFzTjF5dXhFaDFmVTJnNTdhR0hoUTgyVkVJWm5sZDFBQ1FtUjgvbGxK?=
 =?utf-8?B?MHVjVDhYQ1kvcWVrdm9IMmUrdjdpUTJ5THlFSzROS1N1TjNmYkVlcFNqRjVY?=
 =?utf-8?B?WFJ0MFRtVDdkMG1MM0JObHdVWG5MTlk2OGg0TFRBek9LcU94VWFzRFFpcmZL?=
 =?utf-8?B?ekExVU1ndklTRndsWnNvSXJYNWh3cDFVSFJmZktuOHQvZ2w5ckw2eUZHUmsw?=
 =?utf-8?B?bTByMHZVM25kTjA2OFJnMWtISkxvVzJWUDF4MGRxNkJ0ekNqcGM2WkxyVkxJ?=
 =?utf-8?B?azlUbXIvalZ0Y1NuUDlvYWppbEZyczhxc09IVVQvd1ZpSVhhcWpuV3E4WFhy?=
 =?utf-8?B?L2NvMWJzMTBlZy9UZ29YYUhoeG1PQjdncjArVWZ6eW11VTRaQUowRnpJUGFB?=
 =?utf-8?B?Mk1NY0EySE1XSXY5Y3ZIbEhBaEtpcnNWaC80eDFjY3NrQzZaOXpDdy9DN1hn?=
 =?utf-8?B?cndNRkJ2aXhUVm5zdHloYm5pMHE0WmdFSlZmaE56Rkg0VWlEcG03NStGdzYr?=
 =?utf-8?B?TFcwSEhyaDA1Z0tjRHU5YVhoV0hSd2I5ZGhvNVl6KzdiN0ZFOHk2SUdrZkJZ?=
 =?utf-8?B?d2l6OUIwK2Z6NFRVS09rellQNklibGxQdWhBMVdSeVM1bnpWM3RuOHdzTkVj?=
 =?utf-8?B?NVRjOTcwVFRJYjBYQVQ3YlliN1daeWxqa3FRdkNSTnlaZk1zamNDbkxjL0Y2?=
 =?utf-8?B?L3NmY3IyQWU1emVRWmlEMkVzK1I2bFFHdXk2a0tWU2dCT1JSZTkyK1dOT1VZ?=
 =?utf-8?B?MndrZnBVb0t2R0V1QmxDKzNsNkhDWW91c2tBcWgwMWJCcTRaOXphL00xTXRs?=
 =?utf-8?B?N01UV1k4RmJWMnhhMEFJcU9RU2pNSEw2eWlpMWViNDBZOWI3QnFsbDFJZk82?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db2ab49f-3521-4192-395d-08dc5f561e1b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 03:17:45.7881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EhrEt7uhMv+kZNRNB3/t3bZnkP19bzq6E9FFr9M3ssFShz38K9wKcR7Dygb1yswjatJstviAB0wMYWnyWA2iXoZne1dVuvAUFKcdmmFBAt0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5300
X-OriginatorOrg: intel.com



On 4/14/2024 6:50 PM, Ye Bin wrote:
> If vfio_irq_ctx_alloc() failed will lead to 'name' memory leak.
> 
> Fixes: 18c198c96a81 ("vfio/pci: Create persistent INTx handler")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---

Thank you for catching this.

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

