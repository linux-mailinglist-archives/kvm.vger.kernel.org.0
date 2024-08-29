Return-Path: <kvm+bounces-25332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9255C963BCD
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 08:44:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 165321F22527
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 06:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458BA15A864;
	Thu, 29 Aug 2024 06:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PuDVJbiJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C095647;
	Thu, 29 Aug 2024 06:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724913833; cv=fail; b=GPV8Wvb9zsp+VqwH3V5wRmq/YWLfTxKzPzWXviIe1GqKrsJd8Cx01ntnijFs6u6tlAh1vKJaFghqI+5WaaDLMWJSzJrSLZuQ9BJWoOz8pfb9qd4hfWUah4qM9ylsK4ZbOSL/Hyw7YGgVy5dhLtsBsMhqzribwImdQF2H+j/KO7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724913833; c=relaxed/simple;
	bh=xIZ2Y9ctaRuRsaTdZwH1k/fqJZj7X7lWNXZ5IOmCm7M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cs+8sBssHGQ6HaQ4xwokpTBSNNMax4jWNdjWSHVfdJY+Ugd6UqWCTkB6M6VGWM9z+2fjAkaKZCj1qFmEmzpuAL78La9nEEG4o6UDs3um5XEUuYCDLqhbROvEkg6bXwXpl7U/XCPTGP6lqTp6JI2ebseK/JtSoS/wNDxv9US9I3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PuDVJbiJ; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724913831; x=1756449831;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=xIZ2Y9ctaRuRsaTdZwH1k/fqJZj7X7lWNXZ5IOmCm7M=;
  b=PuDVJbiJlVByRCnsSn8cTgmX50c6oqeulJn0U+PtFx83vK2uACJ825lD
   AAPEmgM0KQ87FoWFFezjNMEuTMJDyaDcaETxfkd/jHnqcUiAPWjbfPzct
   eL7ULnlYc234rIIu4N+Dd8xGaC0JtGJUDB+fWZAiP6MMDEQNBv2FQ1bZd
   MARDDklr26cJPOEUi+MriN/IW6y2223qMO+p+nIZY+efPT5xYyvkUgerk
   5J6bgGs1uDPMiXC7L4/lTp5ygnJhxRWMkGAmU1cEWw1hpbUPgSGZEfthf
   RI81BsfdwOg0Ixu+IR3KEIMkGy7/N71rjgBMLJSF4P3KHvoPNVtx+p9WS
   A==;
X-CSE-ConnectionGUID: ItLCagG0QcCZKArKcHVeiA==
X-CSE-MsgGUID: XU5CkJ0sSF2vIUE/rU1Prw==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="34864263"
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="34864263"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 23:43:50 -0700
X-CSE-ConnectionGUID: rjWLteFZQ9yziSsoV2Q7Sw==
X-CSE-MsgGUID: /JzYILYlRyC+cAQThskdJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="63665072"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Aug 2024 23:43:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 23:43:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 23:43:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 28 Aug 2024 23:43:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 28 Aug 2024 23:43:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nVM3ii30I9KPL3gKXWvTbiAAOGH5REozKZz3mgpJHYYwPxBP9dTsG1YQFzK72GcQvMoZdMAqI6zAt9tNCDF80gxFH6O5r9ubnDX7gw2rnGvPDRgno8eT8FGLHJX4DUSfWiNj50XV4m5uljFI6FYNtn6F5cKYNrkWMQ6Dg+/D4lUr0O9FFC5llcdvKr1ADG9Hq3nH25hRgzz2k4AAtP8jmSBv+3ZNz/R8OZ2YxNKp6baonRTPcHyUd+tFHTqnC/BAL7GK9ID0VZ0vu+MtmJwGoZaIIm2Zfh8FpCVMNyCJYaARwQnldSpUgD2cY7Q60I8nOlb+Ru7LAytiH7/t0FKEfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8p9YT0vzTkXoXGB2NR+YIDqbIX1g7j6IpldjDY99G2w=;
 b=GBLZ5EYMyh4fwZi3iIG2PsFDJiM/0ZffD9etActeXO9Zq/QtJ+oNn8Au1SpOSoMK8wG0zq02j3pq0GdzCbhfg30kFpbVC9YUzeYD4UttuxssNCBAMgjn5Pv55SXCHmBOQ0EV/L/Q7Zq8ftp00vJ1zuHMBv1Q1L2a7mjXH+vrsxBaEU4dtJ01ckDkRVllT1JMO1uQ6tTFk/qfBgZh6tUKwTCtaa3BeQouOZvfNQ5cf0vSM5B8D5GrIVTaUQoGN3qlzK2xet7encQ/RC3eYK5La7xTIpxeLcj1BvLRfjMjZxh8Qdbyxx0EDarXAEcU6ZtpvwqY/1/gCBFuHOl7q/YDOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB8158.namprd11.prod.outlook.com (2603:10b6:8:18b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.27; Thu, 29 Aug 2024 06:43:47 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 06:43:47 +0000
Date: Thu, 29 Aug 2024 14:41:58 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <isaku.yamahata@gmail.com>,
	<tony.lindgren@linux.intel.com>, <xiaoyao.li@intel.com>,
	<linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 17/25] KVM: TDX: create/free TDX vcpu structure
Message-ID: <ZtAYNrB4Ef+VcbI8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-18-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-18-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SI1PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: c4e4a3f0-45fb-4347-1cab-08dcc7f5ef50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GI1cTLyREh4m/Y83ms37StxZwK66d5nNVVvlrHpUe/QhidWnEM+b01mQrNQu?=
 =?us-ascii?Q?VJiwsQKZ+O42Q3WRM7MZaIcqSGIOvYD4Pu4CfrWc2tAgiGfvAmVpmBSMeZHw?=
 =?us-ascii?Q?vJ6tJrStETmLmi3pJOHv1JhuZTKBwxeRMtRGLTi17d+Fns623Gfrtw2gBGSe?=
 =?us-ascii?Q?lqWctVhaDcr4dOvOdED4NBXALzlbV3NkSjE0RkeDv1iffOWcqDT81jdDxht7?=
 =?us-ascii?Q?DdUsYLXoz2eLbl58TCiJhjXXqKHiZNJk2NlyIkctOpf0qPFmdh1q7lMea6Cj?=
 =?us-ascii?Q?Vhm1fA/uKToMMXWUdPSYEeYl9ISPGhKX+fGk+P0CpTczxeTXlN3WeNnemJEU?=
 =?us-ascii?Q?n5Lu9CggkPemAmsYCII527NCexus0OT8QT1bdDX34QoEJD8z3OA6RuKBJtfQ?=
 =?us-ascii?Q?O6+FTDb/T0Pvm9SFKUcEXJ5vanEkJwZN8xEBdNO8pTYp3UTxW4eHM+QIn/Ns?=
 =?us-ascii?Q?SYAqTjxbmQt7Dm3aDW97q0w48wTXw553T1N3rtW4VoP7jzUTqDetKlqDi+Fz?=
 =?us-ascii?Q?nPSc7mKxosgWumhav+AzNbAXo/UgCrmdwFAs0gVB89QHvyx9VrvTLchc3Pdi?=
 =?us-ascii?Q?3H2ETmoL2wLMfOITQNrgzYOEHXaPigMXXYSG9zSeTYUAZAkQ52JipnI8hcYA?=
 =?us-ascii?Q?xOUp5dlauCu3K2xVmGvigEnDv9qyVZl1hZyjRW+hkRgOj+o++IJ4ooIONcoj?=
 =?us-ascii?Q?WbOjKumA1c3ys2mMTlpkDgVTLK0O4601Y+z4dv98qP2yKJSmxlUQegYnWvzN?=
 =?us-ascii?Q?2zdHXQXvYlW0JFWUWoBwh/Ls9l7kj38usPKEp44pyA6JOnmpw4uLqx+qB12n?=
 =?us-ascii?Q?YFJmh9Mr0IPYmv050n8w7BRJkFkD5qfkl1QqwU4jHFLujvKe9mcfDXOOS6Wl?=
 =?us-ascii?Q?sVLKaJ5eW+S3c7o3oPreu5zBBpglV+dIxDXBFauhUlJTw7MDvmyK5f3aM4uG?=
 =?us-ascii?Q?Iw+7byxxNU03bfel2cnpgnMhl8KEhWMTRlXnwCcD2u5+vVw+Gg32jqRdnS9Z?=
 =?us-ascii?Q?QI3iIMCSJLN6DzTiVEVOafFiuB9nqpEGh2kucxJ7C8MPnyR/hSZQiNS9cfI/?=
 =?us-ascii?Q?IliVLY3k3PfKALXXfA0frWIsgZhTJV7Zb8Pcf8qtR6sRua4I/0d/VakYpe9U?=
 =?us-ascii?Q?QxiRXfKaX/jgo+crleTwqqc2JLn+32CFsxt4vK2C2E50lrdLNefZMBCDzMnW?=
 =?us-ascii?Q?6mKEG9GNBmmdeqzfxUv8E0QVu0sJSWq207hwHRfduioE8wJeULO0W5yqsMWe?=
 =?us-ascii?Q?5dmoO1Ae5c+JbEuvsITP5po7oXEgTN6r9OW7LPPBUXVFeC8zLu3hB+Ukmhz4?=
 =?us-ascii?Q?p6CfwD7sNy8vQodjmxthh4dmsrNeO+YDS5/WwVvvyIi8yE3NfI/AdO9sLyD+?=
 =?us-ascii?Q?XmbSQr4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r5vCSU69BDItrfqOhMETiBN3AqLiZxRTpJN8EgH5Ycwg5cg3Z0LaUvQMGomN?=
 =?us-ascii?Q?uxtyZqxXs87vtcp/jFwp/6w7AQKekkYca/4aLsdjBMvnWZMAvQOgHHkbdRB1?=
 =?us-ascii?Q?7bHMzx6PSfhJHFAkIQC07HMARUMJMoqKeizvjvmeD3WrWKt5xCgkM4uxG3Lb?=
 =?us-ascii?Q?y1k4JMKL3hkOda+xtQ/ttJmhQHcTFg3U3gCu4mrQ/eE4S5bFm3maDg0v3NRC?=
 =?us-ascii?Q?B3avmShRYLk7USardF1koUbPeNVy21KLSfJ+72HpFBPU8IjHXasb2ETQ1WmV?=
 =?us-ascii?Q?ZBTXaaqbZBsdBHOeV0jGjl/CL3CJtcxH2PzdSMmpfLb35syA3q/p3HGUm8E3?=
 =?us-ascii?Q?tJbt9LNEReqNE4ZCnKIjttPTZp8t8FUaZ5ylIO+Uo2dUfw1EBrJZlLq/FFjC?=
 =?us-ascii?Q?uFQt2ycsWqcpmLGOHcK40bkhI1n3UYT1qiHwORnhsfRHYCWJafx/E21rIQmD?=
 =?us-ascii?Q?brlzYhayYQlXkpt3izXnOjAdMYTah8lyQZ6Q5LA9l4fk5CaFQJ1Fh6VJcsgC?=
 =?us-ascii?Q?C/2loUv801jyJKgGoV4nNLUpKsfysfM43JjwQ1lQvidnUgMYoSyFC4wwy2ZT?=
 =?us-ascii?Q?hJCBNkdj16zK7OgM6dunLVKEIPOa7yRi7KPnIEfWBqjbrxgxOAzQjSIi+DGF?=
 =?us-ascii?Q?8z7WY04nZ/SLU8qnmCHhu8ofIKzW8jVpQEtr1iTwI473UbBpGfDDv0YtPHJp?=
 =?us-ascii?Q?BEQCyFKuRhExGuea/TrVLYKEi5MLLtx3C1/3mx08EzNGUftMKVRbSk704wGj?=
 =?us-ascii?Q?i5MtAJ7IwQ77pYZ+IBPsYDRgBX9Pn5XcGgXFbcZIblt9AcxkCDLwQiGRLhZs?=
 =?us-ascii?Q?hThYhi38wT1le3GpcVhDL35Iu4tzKiiqWRmD8PcqbkJJvV0pJd/ZV35K7McU?=
 =?us-ascii?Q?7McDly7b/3SHF+X8RcZDvHkiY5W/8fCVtGUFeWx3ipQwEk+G9xl+kAymZpVD?=
 =?us-ascii?Q?tmDFHgLW1K2baAVCyIqG1DYwwO/Vf+8xDoKLrUfhoLHvlG6dZqG1eROZOvBD?=
 =?us-ascii?Q?F77nv9ELBY9DYm0OoF3koWattOrvIZbNLZ9tRgvsco69ASVR9o4c6953zAkT?=
 =?us-ascii?Q?BJTdxCxDNmnZfPuYdsHXkEwFoUzaEATpDs9cFZFUpET2B1fwnL7tuy63jx+/?=
 =?us-ascii?Q?1CbsbqBcqmgrDsQfFaw1k2WbtofT+2CGKkthBRa16TW16P3T24gnVot+U/Wu?=
 =?us-ascii?Q?6FWMqPIv4cZykT3VjJ9QkFtWluGCqOewpFAu6Vw/ax694CTF3MAS7wqPOBeB?=
 =?us-ascii?Q?8TfeX62jjmREG/IJR6RXPFnOnWz5bHVYGUv5EKk/TvNmcaJFvMD/x1rCUQsr?=
 =?us-ascii?Q?VBW5prlxblxkMwAZzEREzptsiZ7ctXdcjE0kQj5EX6hBdiYungHuN6c7v6zb?=
 =?us-ascii?Q?oZ4O92JAfS6y7edcsipWhPKGOmGOHo2298RYLkvfav3obYGKcVOSWshd6PRg?=
 =?us-ascii?Q?6V6hHnWtJMJobOkKZdVhNogYqtl5oBOxqkyJHDnEZiUZDdFPIpC0pYaQIXKx?=
 =?us-ascii?Q?c2KtFK7GHYh6oi4opn8DmL4wSVljmJiWou3b+ADm5DuZY/EMnuU6IqBx/K03?=
 =?us-ascii?Q?oLJ29MKkgMqQ5PEocY/hJb0oFVzQn3ni7pMJyU6t?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4e4a3f0-45fb-4347-1cab-08dcc7f5ef50
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 06:43:47.6609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CdZxWkPJqZGxowYgfP1J3XvsllFP7howxEeO1QARjb+u/aXA/KPGEdSBIppbsqOstlPkGZaOPFr0Qm0VpSUSdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8158
X-OriginatorOrg: intel.com

On Mon, Aug 12, 2024 at 03:48:12PM -0700, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> +int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
As explained in [1], could we add a check of TD initialization status here?

+       if (!kvm_tdx->initialized)
+               return -EIO;
+

[1] https://lore.kernel.org/kvm/ZtAU7FIV2Xkw+L3O@yzhao56-desk.sh.intel.com/

> +
> +	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> +	if (!vcpu->arch.apic)
> +		return -EINVAL;
> +
> +	fpstate_set_confidential(&vcpu->arch.guest_fpu);
> +
> +	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
> +
> +	vcpu->arch.cr0_guest_owned_bits = -1ul;
> +	vcpu->arch.cr4_guest_owned_bits = -1ul;
> +
> +	vcpu->arch.tsc_offset = kvm_tdx->tsc_offset;
> +	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
> +	vcpu->arch.guest_state_protected =
> +		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTR_DEBUG);
> +
> +	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
> +		vcpu->arch.xfd_no_write_intercept = true;
> +
> +	return 0;
> +}
> +

