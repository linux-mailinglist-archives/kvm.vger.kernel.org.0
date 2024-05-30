Return-Path: <kvm+bounces-18371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D7AF8D4663
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 09:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 090511F22E51
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 07:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259C27407C;
	Thu, 30 May 2024 07:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fQMQjYAM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD247C12C
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 07:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717055239; cv=fail; b=PV+iTfIFXzIrnOf24fyS0RgxiaMv+Jwzliu4OAPMb5dJCdcZ/YkCA5ryHTxG+IJOwDsNblrSzLjgxxN5X2iMvAsJTl+LaIiDP8Hj2n3s4JBSGTCINZR9nP1IAZ36kq6EUM2qhKX8Su3qjgsxd4ni+a0j8fsTo7unSKLQp9soFdU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717055239; c=relaxed/simple;
	bh=v1gY4hQjsds7z6nWEbndVdZPtxcIdqwrPZxobiRe31Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ORXtFVabFzw2h9flUzVsE81gZR+zD6HfWmVvaVvQPD+s6E3c6rV8vnE1FMqhlajwPLB32W1jXso31/lm6KnEDe8dQpPbCmbjGcDgs7n0Mxle8veyhf6IgDw9KzmWZy1PnJY9iefGHpEhPY3N0EvKmqZ/X0ZDLQRIw+kwfuzFjdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fQMQjYAM; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717055238; x=1748591238;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=v1gY4hQjsds7z6nWEbndVdZPtxcIdqwrPZxobiRe31Y=;
  b=fQMQjYAMUffShA8F/xkYuP/t+Cw7/nuWEGI9kOy4ddxO84CvqTqo0DmX
   fVY/n6ABlqHk6ebxxaRi3Cz/2K/oMWA3/+OAQ53yQ8gJ2UaAVmnzVtBuO
   Qnw6Xb5fX8QSP8BagTmMURSIxOD3skixI9sw8Mbw0c0BJLoD+x4vcMX1v
   lI8CbK16OjDbo67ghAQOiGngRikD4yq4SArJr5/+IHYm/r32GhdCsbYyw
   cREdRZlhudAnW9+tg6ErMMvfQfW3JvwuYo+1f8IUszFr7eyYUpp6CIbND
   sNKzOGR/GTiyJuwGOEJWzQwed8V51g7y38e5L0ZrNLj7bGSkKbz4ptqTO
   A==;
X-CSE-ConnectionGUID: VuFbajEKQYyUDbVJqPo60Q==
X-CSE-MsgGUID: EfUT2IApTkqn8KnCbNF4jQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="24126193"
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="24126193"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 00:47:16 -0700
X-CSE-ConnectionGUID: hKQ8Jr+YQfGB0xvZ3nUvOQ==
X-CSE-MsgGUID: tfiuZv16QX2blyy9uyY1vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="36292260"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 00:47:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 00:47:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 00:47:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 00:47:16 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 00:47:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muiWyuFbB0NV5wnLBBUg2e4T9Hi5f8fmAUjDD/CsZxRGaogLSjmsVe7JLsSQX0d7LWr69YTktBw5v4zqToA1vP1rhhXfPi/8KFa3NonKp0oN5LG9fYagiYtWFLr99A/JUXInHOOnJGVEa8bMRzTxDudxcq8Je5m8O1zenXk4wOCrmQJtyXHspONLzyvLcPaLiao1ahDuMc+9gpuDIwNQ4XPm3dJ+Q3cYxRJ8CYusQg9mg/qm5CGQR7TG8oIeLJbcucaJ+UMNOFHBHOmF75U+V1LHoebggrn9thh1DcgwU7Z+fQv49bkzYlSq9/0k4GJJ2ac2BWjzj5dejFmGxABv2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qiBiAQuSNCH5wpwVHkyN5MMaFZkr33A4SJKOtFnsqkI=;
 b=m1V95siowmhcSwhPCJzsFppUuvagTihyzDUOvy1mk6aKFJTIGB0h4V3RsNQQcu7yBCgnAnnq/VLosC3Tf2tnG+cFr/or7nfTxczyDmoc6udqlLza7FfA3F2/b3lxSm3wxqKFrxUd33+p1YLaUquTqyGyjXkh/8NyYdvb3I4uHEgWj/uLf/j53YhQxnyF4hvuiEp43/A3r/N1g/+oEWx+1XRLktghHjBQzoopKjSeH/j9TxDww7I+0vtqVXCbeSTh3zUYEER/WvE9cA+407x0NyrVT30B4kDGYh18p/pckILD1cSAxW/w4ZUME4ImAvhKLfl6c9lIDZC4fHMp5CKh3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB5189.namprd11.prod.outlook.com (2603:10b6:510:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.19; Thu, 30 May 2024 07:47:13 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7611.030; Thu, 30 May 2024
 07:47:13 +0000
Date: Thu, 30 May 2024 15:46:22 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Peter Xu <peterx@redhat.com>, <kvm@vger.kernel.org>,
	<ajones@ventanamicro.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <Zlguzi/2sOeBTP4Q@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-3-alex.williamson@redhat.com>
 <Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com>
 <Zk_j_zVp_0j75Zxr@x1n>
 <Zk/xlxpsDTYvCSUK@yzhao56-desk.sh.intel.com>
 <20240528124251.3c3dcfe4.alex.williamson@redhat.com>
 <ZlaTDXc3Zjw9g3nG@yzhao56-desk.sh.intel.com>
 <20240528211200.1a5074e3.alex.williamson@redhat.com>
 <ZlbMb9F4+vNwTUDf@yzhao56-desk.sh.intel.com>
 <20240529105012.39756143.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240529105012.39756143.alex.williamson@redhat.com>
X-ClientProxiedBy: TYAPR01CA0051.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB5189:EE_
X-MS-Office365-Filtering-Correlation-Id: f5f3bc10-dd0b-49c0-2e12-08dc807cb863
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?j8Ny7gA0Mw+Fu8H9fps14S8hWOho820rD2qghy3GA3AYPOo+02MfbHCYi75Y?=
 =?us-ascii?Q?Ott52MOG0w+pOLaCTz00ISh59iCW56ifxAa7CZYcgbI8DCaHxwH4ZkCoGT/O?=
 =?us-ascii?Q?u1ITwVN8rBfHi3abbUd5xhkWWW6Dq4bQeUm8Qvii9fUCIGY22xTA6nrODHvd?=
 =?us-ascii?Q?hV4fTOzIV0h4hNRhDS3QJHA7XuVqYub/Y1tswOMMGlh+2B+OLkDrzFANGJ7H?=
 =?us-ascii?Q?Cb7A0HdUQEyNH68/MUwWmxBL7ofe3k2eTg/JVtzWVwmt2CHNwEelDVq2F30a?=
 =?us-ascii?Q?dzSkZnB9wRCvtAP8JyJdHIFuxt2nA7Fl1kb9bacQHKCaP/XYDT0z/tqhYkXW?=
 =?us-ascii?Q?PLnh5MhmYZC/IaHeDSygC1OI0fMsISS+FFzLIhtxtb6A4t7jv5aRryZyFjd2?=
 =?us-ascii?Q?kA7w2jnqpqGr7DQ9I0KoywUNmrt09YUd2I0zARSTZxeWaC1cxk2qixlPogTi?=
 =?us-ascii?Q?/iyi1rjghzG4qtpLtKWl1MuYW4dDilnJze5JQXY4P6kqddTEZc8iXR68501A?=
 =?us-ascii?Q?GjD5LSc1CZIBCLqVHgoh1S+S7CFMxlf8mGqDJ4kzttsX4B5/AwmApT+o6Hg2?=
 =?us-ascii?Q?QFYvgxZY9UjSnPgYkTkh8qqFCkoJSUKijqcvHc7soOAPz32SXHk3H1JKyWD5?=
 =?us-ascii?Q?pnsGnu6rMVJROlbUiRmgSzVcaGpPxkI8/lWhWwTTpvYPp/gGSPQS8PVnN7jo?=
 =?us-ascii?Q?BJkqiKLojo+mGLODFAmoPJCTBjEQJwGdugILjjFg3s8AgVhjL9DhCHksKyrS?=
 =?us-ascii?Q?1mYcu/c7U3sAqT9XH6Exkg9YbxtIp15gRPxAERIMe+C9/OJVJVBAdnMrlEyi?=
 =?us-ascii?Q?NHLJqzN4P0pFCHJA5TbjYbbJhojJM1KXzHKlcA7tlz8i2LwUgA7xDRd78xUt?=
 =?us-ascii?Q?zIynlZh67JEZg3Yom8HOw8YAEsuyODmviojwzRLKwlqSF03NuOzjG0gUSEvR?=
 =?us-ascii?Q?SMic+gUg0wU0FnMhJsULfyJ7BFJoENbXON8sQw+d+GqSuEgvh8vJqhD1jwn4?=
 =?us-ascii?Q?Rgin2PEOu1fQuVHh9XFV6SgPjl+rjy5oqSeXucriUFf/ZqFB93kpjJ3RBgkj?=
 =?us-ascii?Q?bqPnJpLDPJZ59hY8z4B1KX8chQJwx6qOE9IdjJnc0e5Bs+iuk/5hu8U5mL5Y?=
 =?us-ascii?Q?hAjiLTt+X0TZnuCnuvkNEdWmR9OAWofWphPyguKXvSYy8zUzbOUDfAif4znZ?=
 =?us-ascii?Q?+RVMpsmXwSU70q63gxEHny2kjPz4+CKg1oz53y7I9I54OIeLCK24CakyTms?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZTWUyiv/h737kpsmDFLUburTo/OryjzCAiHhzbKQLcK/K92yIdTANfzFuSHP?=
 =?us-ascii?Q?fVuvZ3zgAAyiLiarFfUKL1CsV084MEJjVpKHdSTsmOLt6wmBJtoqQxYkoIku?=
 =?us-ascii?Q?FTpdOud3ReAlA9xKBS8GHKodoo6C/mkug0lNKBl4kwI1J3TuqIOcnVDjKmGt?=
 =?us-ascii?Q?sZ8EN+glrsQB6XbtqW4E/CItKr1xamW66ACgmqIfeo+hYxkAB2sN3XbfyReA?=
 =?us-ascii?Q?rVKXBlRvadsgFARl8bgXR5Y3oPntF5MsJ7Rs0YHTug78Ur0pZrwElgsvYSee?=
 =?us-ascii?Q?EjdM/SK6G5u2V7eUt2u3gcztxuC853TDX4HcNdgLWnMN98eDsehLdmGEakGQ?=
 =?us-ascii?Q?EYXHCtP/9UlwHLoiI78JEGU+Z2FcbPUba9l5s2Wz8OY3k/Fy1SZHRO9tTQKB?=
 =?us-ascii?Q?EqxXUENn5Jn6ty86ftlvhT34DScdOVw9n6uey/K5ZRZzwv/cQC95PZwjNRj9?=
 =?us-ascii?Q?s6L0PScypQGysx/2y+Ijequ7Ai4nqpKIsEgmV+TVwHTs4x4b/C+wS72E2NEI?=
 =?us-ascii?Q?+UWex/p++dJvqmAMhu3k50coKmvBaEoF68E/7n8DXaS2IBJCICEthX36T8aa?=
 =?us-ascii?Q?cKHd99stngASMLfWuK/MzfDX4qdf4pHDx6pB9SlMtsZvRXnBfAmJP9U9ENsI?=
 =?us-ascii?Q?g+OxYYK6VAXMGPoyAfTOTO6LL/2ujEkS/lEALPRx5lhT90DqpY8ggpxo0DfS?=
 =?us-ascii?Q?gEypScOkWpCfahC0dJP9IiYkNfC5miBHSqO7gphVFb1HKs+ILjxtDsbNUrwT?=
 =?us-ascii?Q?W3L4PAE5/6Z1r9TnWIwer7C5iOtKrlsvTKYa7EmJZD7+V9tW52r3amClXVxE?=
 =?us-ascii?Q?cBkUKuzw7IHozy8oXTvxb/uLVxk+HKxEHV7LB7TDogVu2OHRFU+S969aXzlU?=
 =?us-ascii?Q?N1x3lw2H1sufLN/CyZ6gqVsPdPtGw05GpmtPOF182sKSg4vkWAbS+ZtKwY2X?=
 =?us-ascii?Q?JWYQ3rJkM/gWhVWY9RVONPanFoNUkLN/7ZO1TDp7rFf9NCpBsHQ8qqnciVEC?=
 =?us-ascii?Q?RROLkoPOPTfJ5X/mVGIMf8HOECA779zb6sTvDAM6qCdyFKySas0KAC3F3en4?=
 =?us-ascii?Q?URLpVHnJtWVKbGCUP0giTSAcpDmpsmCvvqyQXZ+IKejLN5F2kC5pFcjWNpbZ?=
 =?us-ascii?Q?iM6EKE+ztZv4mBXw11jJgAcUP1SR0664fQDO3YolCBn8dHQ28xbF4i3z6mzV?=
 =?us-ascii?Q?bku0jQ5lrWhrBFamiYY8JB8YRvwesUYDYGlzac3SrNxM9GbPuww0UAvg91z9?=
 =?us-ascii?Q?SDe8c1CoN7lh+/QZ+RRK/u/2Lni4qESFrGuTV5nkBG9zW3UrvptuGPOs0Epj?=
 =?us-ascii?Q?Umen1VlWiarrSx3+pQnHdlUqLp+fvdo2LZt0srI1ME1UJ94e8XULwezgYqW5?=
 =?us-ascii?Q?8jdYvZLq3dmp3u6WYwu6hB4aAqqpI/ej34MAxzM8CnttkPAVsQxQJFK5sdOC?=
 =?us-ascii?Q?4xmHaxU0IuOoRplZszgIqIAYUoNNKIP7qsQsann6shbC/7E8f/WEFlYCCWhP?=
 =?us-ascii?Q?cA2CaJtKs291BmmA9kHAvwC9CA47Z3uqBCqqtf+RrwnDGwQUCoH89FtqNIco?=
 =?us-ascii?Q?Kj/eXBXMFf/OlAC8qTi6Z+6G84gYsDUm3KC0fg3R?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f3bc10-dd0b-49c0-2e12-08dc807cb863
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 07:47:13.8613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TFHOnWFnSuzDp3wdgHuoq5nlX+xVF64XmCnot8tToSonGNldK044q4Lub6eOeUW/YrQf7mvpaJav4WMh1DBMkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5189
X-OriginatorOrg: intel.com

On Wed, May 29, 2024 at 10:50:12AM -0600, Alex Williamson wrote:
> On Wed, 29 May 2024 14:34:23 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Tue, May 28, 2024 at 09:12:00PM -0600, Alex Williamson wrote:
> > > On Wed, 29 May 2024 10:29:33 +0800
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >   
> > > > On Tue, May 28, 2024 at 12:42:51PM -0600, Alex Williamson wrote:  
> > > > > On Fri, 24 May 2024 09:47:03 +0800
> > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > >     
> > > > > > On Thu, May 23, 2024 at 08:49:03PM -0400, Peter Xu wrote:    
> > > > > > > Hi, Yan,
> > > > > > > 
> > > > > > > On Fri, May 24, 2024 at 08:39:37AM +0800, Yan Zhao wrote:      
> > > > > > > > On Thu, May 23, 2024 at 01:56:27PM -0600, Alex Williamson wrote:      
> > > > > > > > > With the vfio device fd tied to the address space of the pseudo fs
> > > > > > > > > inode, we can use the mm to track all vmas that might be mmap'ing
> > > > > > > > > device BARs, which removes our vma_list and all the complicated lock
> > > > > > > > > ordering necessary to manually zap each related vma.
> > > > > > > > > 
> > > > > > > > > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > > > > > > > > unmap_mapping_range() to zap a selective portion of the device fd
> > > > > > > > > corresponding to BAR mappings.
> > > > > > > > > 
> > > > > > > > > This also converts our mmap fault handler to use vmf_insert_pfn()      
> > > > > > > > Looks vmf_insert_pfn() does not call memtype_reserve() to reserve memory type
> > > > > > > > for the PFN on x86 as what's done in io_remap_pfn_range().
> > > > > > > > 
> > > > > > > > Instead, it just calls lookup_memtype() and determine the final prot based on
> > > > > > > > the result from this lookup, which might not prevent others from reserving the
> > > > > > > > PFN to other memory types.      
> > > > > > > 
> > > > > > > I didn't worry too much on others reserving the same pfn range, as that
> > > > > > > should be the mmio region for this device, and this device should be owned
> > > > > > > by vfio driver.
> > > > > > > 
> > > > > > > However I share the same question, see:
> > > > > > > 
> > > > > > > https://lore.kernel.org/r/20240523223745.395337-2-peterx@redhat.com
> > > > > > > 
> > > > > > > So far I think it's not a major issue as VFIO always use UC- mem type, and
> > > > > > > that's also the default.  But I do also feel like there's something we can      
> > > > > > Right, but I feel that it may lead to inconsistency in reserved mem type if VFIO
> > > > > > (or the variant driver) opts to use WC for certain BAR as mem type in future.
> > > > > > Not sure if it will be true though :)    
> > > > > 
> > > > > Does Kevin's comment[1] satisfy your concern?  vfio_pci_core_mmap()
> > > > > needs to make sure the PCI BAR region is requested before the mmap,
> > > > > which is tracked via the barmap.  Therefore the barmap is always setup
> > > > > via pci_iomap() which will call memtype_reserve() with UC- attribute.    
> > > > Just a question out of curiosity.
> > > > Is this a must to call pci_iomap() in vfio_pci_core_mmap()?
> > > > I don't see it or ioremap*() is called before nvgrace_gpu_mmap().  
> > > 
> > > nvgrace-gpu is exposing a non-PCI coherent memory region as a BAR, so
> > > it doesn't request the PCI BAR region and is on it's own for read/write
> > > access as well.  To mmap an actual PCI BAR it's required to request the  
> > Thanks for explanation!
> > So, if mmap happens before read/write, where is page memtype reserved?
> 
> For nvgrace-gpu?  The device for this variant driver only exists on ARM
> platforms.  memtype_reserve() only exists on x86.  Thanks,
> 
Oh. Thanks! 

