Return-Path: <kvm+bounces-25432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EF05965561
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 466E91C22631
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 02:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E84136326;
	Fri, 30 Aug 2024 02:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gCsanCMN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413EA134B6;
	Fri, 30 Aug 2024 02:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724985942; cv=fail; b=n1jWHSOHhEdIXvFnJCVoiMWS4tzpcyYRF1E6HxOvz6vpoeYs1HxbeuxFsW8SVEXUDXeWLBhZcd9S9tj6OqQCNekaeCeTgkhADQIlNVsrfUnkKiIfff4mniiJNB6/hVUzID4O10hFbrjG4YZZK67Ob1dNMM+etX9qjV0S20L0dJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724985942; c=relaxed/simple;
	bh=gWhm2h02rG7mlLcE9q/2AFj+BdKcueRQpg9ErWHwYs0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u556Vn7k+nvVnYiPVlkZz6oExS35EX99igVXOtdrvYxShNWk/zPGA0I4gyxTFcQVGBYuFnwm4j8TtYHoiz2nt47cyMf0AWA0F7JePvi8N+DwwSzQb+oCG9iUd0miI2uAt4x97xjPAX/F7Xe4UtcYyaHU/zTNW/OoVQjoPF+PhYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gCsanCMN; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724985940; x=1756521940;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gWhm2h02rG7mlLcE9q/2AFj+BdKcueRQpg9ErWHwYs0=;
  b=gCsanCMNGMeFIWYqHWx0s8RE7uTNajqAA/WVBEsQIm83GZVnRBvFOd/d
   DRLM9kbVeC93AKBYf5lV32OJCqyoT/XZ+cwH4sk+Vq/GypeBJZApJM81F
   XU7B6qJUQASdcSd9JRECSmT3UVMuQbp5N9D/BMmRubMm0xlwieepyAgMo
   WGzXLEzNpssx+joOVikjc2HqjfKzGOOl6GV4VVvvWc38skcOZ+8Gs4VKz
   niE23kKL8K5LGnTKoUAypd7F8lMrdQnSiHUhD9bChdSYb/uq9fHG4hFTo
   dk2phTdvU8XIA09o1+MeAeLM4OltaEDCSCtNgqfNhnmDfq7IbuMKiJImY
   w==;
X-CSE-ConnectionGUID: mJqqRxwDTRqN7ZH7m0LaBQ==
X-CSE-MsgGUID: w4UyY9dPQDekf75QbJZMLA==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="48997319"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="48997319"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 19:45:39 -0700
X-CSE-ConnectionGUID: P5vz4uBoSwWt4S7TvL19Iw==
X-CSE-MsgGUID: IpY4KSukSNSiwqD/o12SXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="68432371"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 19:45:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 19:45:38 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 19:45:38 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 19:45:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IZC93HYG3DLQUiGkJAIqEvt8E+pdZH8BKOCPVVFQvFS7QRi/rhQr4mj3gpTWq0+7DEfPd1lv4sFzYkHz7xO3IJICPt4Nw3OgvykfcsstNR0jxDlziUetXx+7CiHqVG1Fug6J41Aj9M1opvBoC+2WPLUsNsG9rM3Nh8TTsea8gmzBmVi6bsMK6Hy07G/zxSGilMRAKRTV4iaQCuSLNgPmHG+7XQ3qsYi17/s4Lkwt8FPKPR4tzOOgspIQIH7zPFMDmdlQpE+R6mhTlpWO7VXCA++w+2Z6ezHWpK7i4pVtBX4mcIpw9Cz5pi9I6Wrc9FQEiajxxNXr+Z7j7KyMKzjGpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWhm2h02rG7mlLcE9q/2AFj+BdKcueRQpg9ErWHwYs0=;
 b=EZkx37rWheZWgAnkydilQHWoko5+D2BLrug6+jmYaklyovKHhAKklYCgWvSr9SKrZ+1xvb+iAWDarnd0DzlNzToVDdZDDbewDQubYLprt2fNe2gdgjjggY+BtztnUHsHUEkkZGw9/nRehYIRGmvjicxpRK8DgFpIhL9Lr+qqHsSvzYhzOpsQmzztU/4/kY4ettFVB3Wgmqzky63nzJ4OOTTZDD65ZH5vAtvveRRbGtohdD0pDluhwtn46KGTPldW/+wZDQct9s6+7GCpVqJ8WYFRAHyo0SUAiFffcTmLjKVKYIL8QPjIqUwJhSiGhLi2ejYqrjke+vNu6hPVW+H2JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB8041.namprd11.prod.outlook.com (2603:10b6:806:2ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Fri, 30 Aug
 2024 02:45:35 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 02:45:35 +0000
Date: Thu, 29 Aug 2024 19:45:31 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: Re: [RFC PATCH 05/21] crypto/ccp: Make some SEV helpers public
Message-ID: <66d1324bd2044_31daf29458@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-6-aik@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-6-aik@amd.com>
X-ClientProxiedBy: MW4PR04CA0111.namprd04.prod.outlook.com
 (2603:10b6:303:83::26) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB8041:EE_
X-MS-Office365-Filtering-Correlation-Id: 879a3616-8b28-46d6-4361-08dcc89dd296
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Mr69urVDsTcFmpzE33rh6vPaSxlouBLgHiYZeZxfI43ROOhAv2Qr27DbADsB?=
 =?us-ascii?Q?vGYoaUsr1o5YinV/EG2xwJsye0FLE6lZhtslVOBJJqnm04Fuv9ZfIP+Dy7tJ?=
 =?us-ascii?Q?HgkcrozVmVzuPKn/TqvCRw1q1RxgzFjtRV/NOYEUuFl/TxGKg/NFYK2X6dx9?=
 =?us-ascii?Q?qI8rop1qNvebxagdiSRW5QA2e0EOHZXffak8/kgzbTppA4bryEZJHVJuMCUr?=
 =?us-ascii?Q?RqzfpaBjqhExsd+O65aFT9NYvMaXlFYoRvbZewHVPasbmzQv1gUbkzY7D+Od?=
 =?us-ascii?Q?GVpRDMtUn227cU1d/gBKpQG735azDk7IctDLgmPK5dIrZpkMtjYmbUKlrggm?=
 =?us-ascii?Q?eJZ5uthXG2PoYBOAZR+uDmkGKFgu5JJCgHv8NRdsuUMkan/0xeL0YseF0wFS?=
 =?us-ascii?Q?hUIPeNlyDFTKc9LEkvpjxoAKqobOX+SMTtjFb4Id17hGDpu8KAYtNo5uaNWd?=
 =?us-ascii?Q?ciqudCsCnWMrRZ4CkU6F1dGV98eJJb1lqMCkY1kcseJgkArcw5YoVpvnXT7l?=
 =?us-ascii?Q?4E2HBePfyrrUxh3Ke3KK5dRl5jKcQFki6PJ+QZaHp+CMvqJLpXO3JQwQnz4X?=
 =?us-ascii?Q?BxiNEbe/kXjAU7Enqv1nyhi7Ob6wz4c+mCPoot4ZZXXYc4CarTI9uOvl+Nfv?=
 =?us-ascii?Q?dcwW4bj7gkAyfMxXREEAXgR7LJ2ysIUvQfty2TDrYW/b199z2JDQHXvFXuWA?=
 =?us-ascii?Q?+UTw2s7P6+AdSnPMuvsxDxcBDEbVV3t3CaV57ulVGy2dheCmgF44cS0WUvrE?=
 =?us-ascii?Q?kTs8LTR0wcrIzOb7VESloJFR/BrEiOgm0JZyeLQVNTLOGoRZuNUfnYuhh2Qr?=
 =?us-ascii?Q?Xr9zryJL3JE9OCnAHjG9VDZ8M4jgqOp700VnxkiaGxSDET5hStdNQxXfoS3p?=
 =?us-ascii?Q?FUctUIkMy7xCJP6PJeBF/IbANhMYh8Dp9y6RPx3W7i8Qr/XXyhuRIPOSMXHm?=
 =?us-ascii?Q?l7PHVzTc/ciaOxBpQZth7dJNTpyIMqoR1qPPZ3lgkCdm93he5zWuD+1UEVDN?=
 =?us-ascii?Q?/dk3fcwq66GQiq1w0Sv9IqBEBdmOIjESltaVtgIkqhkG2OcM6rPoReZkBPfp?=
 =?us-ascii?Q?WZWqC0i98M7VIYln8cN9uNM0oYmjyY1o4lixaq9cRZt5HoE+8drzPvabzCsQ?=
 =?us-ascii?Q?+zwCIKwn4a4+8/ZsLeyysETr5GuRL3N0QUjl9/AsW0vt1iYeTFJvRwCjzFI9?=
 =?us-ascii?Q?rAsZO610SSDYXDOq28IHckUprjj8IWSiXW4VLN+AItd66cyGby/3LLYH60zU?=
 =?us-ascii?Q?XQ8FCzQNARAMmgoo/1rJPDlBrq07htxj4ItjJVBNEd1/smcV0hXLJC/5MvH7?=
 =?us-ascii?Q?ZAvA54khbjfTQYC1jj86yONCEAIzhWCDbcafS5QswTSLyA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TXLFac/WG5hbeqkvRXXx77+AbsgEFHluAzhmc14ImqWPSM/mrmgNkhZeMaaY?=
 =?us-ascii?Q?ip6HKl/hG20gXtmqnl4D6v0W3D8a+3hkOPq/H+tigpVjOdBAkVeIWJpz9WP5?=
 =?us-ascii?Q?cZam+f/qZlxk3pRCltJwbxNXm3KIyrgadxZVVqnEx/qjWsmO3Hejq2QGmLHX?=
 =?us-ascii?Q?+7Vjf7JuNFy6wajKCkT0POoQMbhyRTHKYs9/E4ueM9Gsxgd1uQk6vtkxsX72?=
 =?us-ascii?Q?X5EsDmGHOYYmMttTZxHq0KFttXcASrXg7vVYzYB1URj7HQNz5QYmqtsQjASt?=
 =?us-ascii?Q?lPznNlWF5ohibw7+3HPKBwqt/Yt/vke5k22yWfriNV2V8jNnrpc9ofBJamUy?=
 =?us-ascii?Q?RR8rwEkPbca4wQLE0R0lP8SkmKwRSCpvsdmxV1kan3fu5r2oKzWbd8LCNdi9?=
 =?us-ascii?Q?qsxmxyCsVYW0ubfHTiFB3iLOZYAaL43qdx7Us4wFpGJe/5fLvC7AL4AdC2um?=
 =?us-ascii?Q?02HT4g36Xu4BtcKc0b+t+4N4Pbr8S3pULKiWfkOY+pjoEFrkOv088ou1WGnH?=
 =?us-ascii?Q?6kwToAOceSXQsYCq63vMYELECLXPsdKkK+5pR22GHYi+c3RGvDE0v5wUjRiF?=
 =?us-ascii?Q?jTnuNSiJWoXlfIU0PqW+Uff3ysm9n0Fp9XjgtN6FioGsQL1EW2L8xuiXMB8x?=
 =?us-ascii?Q?d1DCZNOoXYd3db8SXtSjJgHrAXITdxzx7BOcfH/Cq1wpDes679EjN+o3NAOe?=
 =?us-ascii?Q?VAolqCNtWlytu09uMsw+D5CWVQytvxxVEewj2Isj8DigRgrnfl37b7ojVgGl?=
 =?us-ascii?Q?WflAiL/i6p2LglBGOvNoZ6du3JeZmDEbpyXzUZ7r1SW6tOv1B1l54h0jh+Hf?=
 =?us-ascii?Q?26/Xxk7O5P7BkqtotPy0zpvX1OTzjqnjz0/Dg9EVasIR07V+USPKBGQKCWnN?=
 =?us-ascii?Q?kf0iwPcTLzob9pjXlMtl/mWVMmWj/7gwCH9zxEj2tyKNGzXz6TVCB4K0tBYM?=
 =?us-ascii?Q?ukdW3pb4qhZKggzS3dkFfNZbCcsnobcqeSWQlmCA1838NZFB1vDIJL9RMX8x?=
 =?us-ascii?Q?RN6lXTkiU7ndKsDbp8B3K9x9Iez305PnoCijgMP8JNj4vvaswXdUs0WLfhlG?=
 =?us-ascii?Q?BAB2aTro3oBxUlad2EZeXKyWI5rQC3jaP054GCbvPFn3M86fGagEQ7vGuLA7?=
 =?us-ascii?Q?mNyTRWpxylkznFwArv9zOjRZakAoI6CUifcCcmh/IenA8MpB69rzOfYfFWrb?=
 =?us-ascii?Q?4Tz4Tw2lc4HBHNack7Y5qUujE3Uwl3YP8HZXjT7HT3lCuogsrF2+lagh3h98?=
 =?us-ascii?Q?TFBzizknQoFQGukOomLud8NFZOUGIDXiGwe/c5Xwj6NecrCwX33eNhN7Lrza?=
 =?us-ascii?Q?wCMoG84dy4yT3QF+lEsTiSvFU7G2FdU0QPWaP0HNiAe401zhgwCbhkEZKIPS?=
 =?us-ascii?Q?1tN/cKxRPsg/6uwjT1Mu+AumduTvPnRzwlv+LIxFvIfe3QThM29o3PCON8Rl?=
 =?us-ascii?Q?ZlbAhe5hbz95402v+QaicndytOuDAvyysYQDXgnvsw003PXWwAFwQ5CzFdgj?=
 =?us-ascii?Q?XaiDaoETwcU7djNgwcMd+CMBI+fSao24j5+7uL1GB8NDJFDB7Hcp5zWC6NRp?=
 =?us-ascii?Q?j3C1jaRfoa9yaIZi7XkNBT0urzJU2Rr2KD2MJSShLzkDDce+ghVjcfl26sGQ?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 879a3616-8b28-46d6-4361-08dcc89dd296
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 02:45:34.9173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1AUKYR1fAdOGh14lZY6FzN8NK8pMtej33ThV2yhJ+NqbYqBjtDg9VXKdsBySk2n0zgt+zw2STd4AK83eTDsIyNhoME6aqt2kNgdcm7ZBUVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8041
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> For SEV TIO.

I would exepct even an RFC to have reasonable change logs.

