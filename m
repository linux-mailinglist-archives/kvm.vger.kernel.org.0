Return-Path: <kvm+bounces-71362-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wKy+LsFSl2kzxAIAu9opvQ
	(envelope-from <kvm+bounces-71362-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 19:13:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C4AD161826
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 19:13:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9DBB5303F040
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 18:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9302352F9E;
	Thu, 19 Feb 2026 18:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jiGLWjUr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44824352942;
	Thu, 19 Feb 2026 18:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771524737; cv=fail; b=Z3YyP5l551md5Hj5YqJKQ6hqbzE8OMi4S3Tjsd1Ajhkdf09QuwEEowtIo5wDBuoIUi9d+Oy52LSTXSIiXQK3eyTS2ecXY7/mpglc7eLuZtbGQmYajLCHl18VcLoTJOElO/vzVwJp8/408uuqaEgziEUxTQ5GT25MZntJUoWGR48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771524737; c=relaxed/simple;
	bh=so3Q+dY8SOFEcz2cnf+AipfdAbizKvGIQD1A50u/D3I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QZJmY8itOuf9fodpK8z249PxC4xnHQAD4OyniNcejBfLL/vpEqKjPUqvMB/FL7zofAH9C/F77m1mL2X1xfMk7j3PtMui/LuKUz9sDZIjgS1/DwT1cZB0eOqyexUoud1HN9/DZ/ibzLpOdQAITT3+y6Ns99Btcjeug3clr2FUQfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jiGLWjUr; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771524735; x=1803060735;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=so3Q+dY8SOFEcz2cnf+AipfdAbizKvGIQD1A50u/D3I=;
  b=jiGLWjUrHm/wBVwUVv3LD820EDgo2CSaKU8KgrXJZ7tCExDmaEkeqEmV
   AzGQjTWPyiKO2FZh9LL6RKiht49+2zfPtNGVm35nQQtCwCoh9/kfntYcG
   KTB01GF0v0YW6e2Qh7yNrK1cmCxVKtvy3wDkU1u3It02yUHozlRZn4CPW
   KyFu4U+NjQKG4wN/Avo7pQEcZBu/g8najglwASuBM16Fsn9GBJgIabtIm
   +c1IoAGlgXu6UBtW1py1HmrWpDoHRGek1f/pjJcZ5Z3FDT33FJV0dMFcg
   7JgREbKuNR1rVtZR4+ruypsy9+bHvGtEgwiwl041Z3FTI5aXBUs57X2WN
   A==;
X-CSE-ConnectionGUID: T7Q/sQtXT56J8DXIqCsvyA==
X-CSE-MsgGUID: mCl/l0xdQMuZVNONfIf0mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="71824106"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="71824106"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 10:12:14 -0800
X-CSE-ConnectionGUID: wmrqjsYbTh6SVDv8I/Zukw==
X-CSE-MsgGUID: gb4refA+R8qbKdUQlJAE7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="218758110"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 10:12:14 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 10:12:13 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 19 Feb 2026 10:12:13 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.38)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 10:12:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PjmMAqSHY+oLim655P89kPc8jcTpcwqWzhIi6dA85PrQURXSPy7RdfSidwMe83u4nzXvGguBczrJuj7kdhfgWw0etlSfX70J+eEWX40Cd17gT6KQdyaeB5UmN2zCraCQrwvZVG5CI9ylhyzMQjmJnfIK08IxWiWFkKd+Dph5rVe+7NSgBBEAh7QpGJO3y8lvT9jVbVd82s168p+o6g5gdBAs+GXd/OtULtqgHDCmbzsF+Lh9cO1/j0Sx2i/rG6x8h7M4c1ik8bZOIxcsbKXtVjd4Wa4yyeB8avOekekadEvYV3ZyL9sdpxtf9bpVsNcCnD3ui85nv5LDXZQc9nNE/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yY1Tvy6TrbFTcjyWimkQciLh5oBxlyBbrqXjW0UDbsM=;
 b=FwiuPgmVJLG9Fy8xVHQVVUVscTsGZgJEEo93QcRMTqsKx23j9PZRxbiptUFk36hytjsd40ptrWbXCidi2rEWkKSCvUJxUQjxrb93jrznOQV5p5oW1KqfOQZTZrlXLMydqiruAGzWdgcCjGJIxFFlH5UjrTToMIoMC1bR1W/u1ZpZmO8tScmSy+d1oVLc58/o8586C7rs12BTP6S7u1MNmnWRqgkGAAxHogBAm/d12VzfNYxLsYnLPY4m00FaAnY1jiPD7o4yea+W0+HiDPajj/0pxfv3M9jZKX4IIF/5VkPWShHgxMNm+Mzkd05JFbxnLl+yCzXMp35m9BE6QPkP6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BY1PR11MB8079.namprd11.prod.outlook.com (2603:10b6:a03:52e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 19 Feb
 2026 18:12:09 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9632.010; Thu, 19 Feb 2026
 18:12:07 +0000
Date: Thu, 19 Feb 2026 10:12:05 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Ben Horgan <ben.horgan@arm.com>
CC: Reinette Chatre <reinette.chatre@intel.com>, "Moger, Babu"
	<bmoger@amd.com>, "Moger, Babu" <Babu.Moger@amd.com>, Drew Fustini
	<fustini@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
	"Dave.Martin@arm.com" <Dave.Martin@arm.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>, "vschneid@redhat.com"
	<vschneid@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"Shukla, Manali" <Manali.Shukla@amd.com>, "dapeng1.mi@linux.intel.com"
	<dapeng1.mi@linux.intel.com>, "chang.seok.bae@intel.com"
	<chang.seok.bae@intel.com>, "Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"naveen@kernel.org" <naveen@kernel.org>, "elena.reshetova@intel.com"
	<elena.reshetova@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "eranian@google.com" <eranian@google.com>, "Shenoy,
 Gautham Ranjal" <gautham.shenoy@amd.com>, Zeng Heng <zengheng4@huawei.com>
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Message-ID: <aZdSdXi0KtEf8Mqj@agluck-desk3>
References: <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
 <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
 <d995e00d-2b90-4df4-a067-c4c76979e499@arm.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d995e00d-2b90-4df4-a067-c4c76979e499@arm.com>
X-ClientProxiedBy: SJ0PR05CA0086.namprd05.prod.outlook.com
 (2603:10b6:a03:332::31) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|BY1PR11MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: fa3a01bd-83a8-422f-2ef0-08de6fe264b0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/9sONL7KeVMCpMKScVWPcBBvWVjN+Q/dG8YMbEqluQUD9M3PWLFUYaIyNQ+c?=
 =?us-ascii?Q?eGZvBQpGXOe8pxR/Pbh7NANN+SS3uitYEFnHlM/N9i0ilONER6/9ZH+CR9dR?=
 =?us-ascii?Q?1G5CO6YfjmT/1Y8J1qTA0R4xve9GwPLkHRQoES9tcVGSHMhFREj5492zRdQG?=
 =?us-ascii?Q?yDf8zYzfQXknajuVm0eQ8nfxOKQgVUhR8DGtVJE9GqaaOiJ/JTteSgco80VZ?=
 =?us-ascii?Q?03rSmUc3MWDfF7GHrEsmAajnB9yo8U1CU/F/atreWxWndYH6VgvxtETIcSEU?=
 =?us-ascii?Q?IobMnQCBc8gfCQK/kb+YHzBZcA18pw98rcGV08djuAYcfwD7yAS15mz7zShP?=
 =?us-ascii?Q?LXrbm0rSIigzX6aUlNBYKxhQNm5rvy962EpTicEIS3pRo7pd9Pbm0vjIVza4?=
 =?us-ascii?Q?vshoeWn5yfO3P76Dhvhxr/N53blaPhLCw0H/qt6Nye1lqVdr1IpkallytQRi?=
 =?us-ascii?Q?e88foRRe1jSWZU2hcxCbcAlR00ZXvhXpbxH6VI6xwJz9d70oxUGPyjB5T1wC?=
 =?us-ascii?Q?7kcHrcfDx+neIhBCuUNnj4sOz/ltrc7qb57vnjW3irzshZzeJF5IU6BHO/I9?=
 =?us-ascii?Q?WBMqgJgi8BiMRFAEToxvrKfGIJmw9F+8Gn/sQJovYWkdsCMGYgtLGfXoMeoS?=
 =?us-ascii?Q?WTeyeAeF/JQ1Sjt+YnByXHa14VMaT4Z7HzE/3FE/4yKcZ1cckBKy0J1K/mdG?=
 =?us-ascii?Q?Z+pTbEv3jWIjobv/JjmoJVGIuGuTCQJ5S3l5zbVvTiRtgu67eQy9QyC6Fnbp?=
 =?us-ascii?Q?C6Qag53BRF2RtViQuVDyY/XWE7nKvagYuC8EeRSwAQBiBe4mWR8cnS3o/ImY?=
 =?us-ascii?Q?4RPHg6tylG941/5HFmjl+6KVk9P5gjmbKicvsyTIVovLMx6qUlwf8JDXEiEs?=
 =?us-ascii?Q?VMcdwI2nwLZko6UjE3c5Ep/7YymM/mjLrOjXlPqBJkDhA6cVHxB9B6euk5RL?=
 =?us-ascii?Q?6tIUYErePHvUsXVdqXTeL4+eAHBwX48O0mS/HRAcyDhlI//2vB8Maa5KUDGI?=
 =?us-ascii?Q?eAkdBstVVYGCAjyrY+elBEg/J4ySgCN7CsOGT0Ywixpj6ORewwwM6tnPGKRi?=
 =?us-ascii?Q?nDRGuSOUZkeo09j/RkCgngGzhyGy2u0RQAUeUySHyMDRbJaVHwOLHxoXjSl/?=
 =?us-ascii?Q?Wg/R8NdUmN7qm+uvJ00idGPG/yxuf6pUB9/Vv3XKjG1tUzhRFxk3reSqRA8w?=
 =?us-ascii?Q?6oWwajjtslSqfpPiuNjurNL0GLjwkTuYDgR7dCdKAi8xx9ZTccOIbbJfYceZ?=
 =?us-ascii?Q?zqkbdpxaTrC/pOX1PX8+7OvQbofNGk+759n6zOqyJN+qx11rksjrkgjNe8ks?=
 =?us-ascii?Q?gyWD/oR2m6q0axECxK2DB5V5La9BJBG/DtvBhPeszaeXX+1Ouv5WV47z50sM?=
 =?us-ascii?Q?LyTc41i+v282ovlJm8tP1pfEvPVkQOEcFpXboeMQYgm6a9JB7iajvwlW7phD?=
 =?us-ascii?Q?lwt4QHlr7s+UTeidGR0rvc8fwTyWVjEQVKIZm3rRNbq4fVu85WWiu37JOgsF?=
 =?us-ascii?Q?16s2fz3f90ErdZqmk0dJvNwojl2Pts5QIjQeEixuCaSFSAVr4d7NX0wedkne?=
 =?us-ascii?Q?XWziman3FoG3ZQvOyk0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j3pHrVDbzRk9bqRvS+I3VnJtA8mPs9IvO33ZkVdORWBiEZNW37gH8UR4x8VK?=
 =?us-ascii?Q?XHWHR+4M3EydiUXDNRctkXiTD0J4j4gfTPSJVh+m1jlqcN/43mWIfcmRkGjj?=
 =?us-ascii?Q?yPFjeJqbtGGBH1aD102nD9FCoexIgQa/ZbQnxa0m7qXbOCwcKyjWpwKteGKF?=
 =?us-ascii?Q?Yb4+WxYLvkUnSkE9nLU+bO0mKGnFgKHR1vFhAxqxQDXOlhF5yZo4JItZ8hRO?=
 =?us-ascii?Q?WwCOvjYWahv0SasxabtpAr91649gczWxBcoHdHp87q1+fPuBzuzxIMqgBrTp?=
 =?us-ascii?Q?i2IEBY6b+eYIWdCc8GiJHROcxxAB/ZO7a5H220f5Wd62w4ECqXTg94u90WYi?=
 =?us-ascii?Q?mKV6NWAVxxsefcVipSqQgZabWzoyM0RqaKLgHLeAReuTf5GrySzfXkqSzTpO?=
 =?us-ascii?Q?3Rt00g6Fge9Izwoy2I7U3mwQFpMEKxrTj5AZab5YSdzP08ezdaF8dsP5bJgc?=
 =?us-ascii?Q?8b41/LbqPuk1JMZMkF0TmYX1LfoFKbJLOAN6Tam0Toa5FQgRmk/3o9Xr4ZXL?=
 =?us-ascii?Q?YmXt8cWzNQFdayONaWS07XkrRUzXbVA4IGoQjuio2WIV1I7JEOyRS7DPyNpu?=
 =?us-ascii?Q?XUdCSjDNaHQ7f2odvWVYvkcNEwW4EbvUX4u9xrNkaGGYlkdUw+/0zGL8Mw73?=
 =?us-ascii?Q?/NvZnuOrga5gmM3aYWCTHsVBCrqF5YnPa6aqrw7/Wj8JaRdQT6zJGpB2hye3?=
 =?us-ascii?Q?o653Uzivi1a8w0frl53ZiNJKxkajG5SLbEA7jBB+vFpNUNZejUKhXY+H7eBh?=
 =?us-ascii?Q?kj5pj3Wwy+/VlZKMHkOxB3UXckjlE4PAoy0wWNcYB9+WTn1pCd1WFzv1krLt?=
 =?us-ascii?Q?T2Zp+KkHbW9vy5IznEh/t+VOhIKIn6EXQ7OCABTn1N170tPyLen7fhzoWFxr?=
 =?us-ascii?Q?Ut3WG3s/a8L+NT+jSGxRslsN91S4nEmcylItHU5xdfv2xXUEceB0fmyJ2Qa5?=
 =?us-ascii?Q?S8oQave+1is1KMUa3mJma8Bg5EZtPDSlG5UTIYDr0GBx2zeWwX1/a0rUWUOC?=
 =?us-ascii?Q?GPpXZJg6oFIYItqj2jEXNZM3MMBhsrfi0G9pxDZq3/LyfZRulhL5HVLytLaw?=
 =?us-ascii?Q?08i9xMXNl1kTy/SyADeFFwJhN6wkkr0vzhpEXEosnkZXprGdidWJavv33ZdH?=
 =?us-ascii?Q?uQt6bK5WuQUMaIBNcgJ3puN69gdLDWMFyh18lJxZXfLGPd70/bTklY/9+IeQ?=
 =?us-ascii?Q?Fz9UWDO5TbZ3LnKQRXWBdpmXp2UKUIoX5JSStcb+lg0wYbrc5KaX1Hd5ImFm?=
 =?us-ascii?Q?lJO3zBk8qjuWg0e9AfpiytvTWdQBKqZJGBW/6wrUUI9NIrDJrgFoh18nevPF?=
 =?us-ascii?Q?sjYmvPdP93C8lWjueqrNgEzO67NvXeeaXmZ6p2sH0dWep4r5RA+dsPvbt9vq?=
 =?us-ascii?Q?8UQ2B7N74AKDlKHVC9YIUEJdGxQKqXsZuiSFrEDh96PhYcD6StSUgPZrxjWi?=
 =?us-ascii?Q?B6zDVlE4q6X2aQlWvU+mW7gXsumMZVcsk3m6p1oktoPjH9uX+ia4k1p3gxTW?=
 =?us-ascii?Q?+KErbp9Ti9/4i/NxiIw9nR6zRp8FeBB37uWCYFzOq/gHrfsA4lB/sCj4lOgV?=
 =?us-ascii?Q?BHTePVKjwZlT22wbT2bliBGtOspjyzxVg9naHPrMiEjDwn6wjAwkMCUe6y20?=
 =?us-ascii?Q?CS+rerq2O1CwjJx3+fC5IefqWa8xL5d9xQ7Y2oS3krTjqbbZ6MUxkZ7PLsiG?=
 =?us-ascii?Q?DPZTZPBwhPPjQe6e57DI/0oqsHt/oeNrlikzTl2J6hdsYXna/GthbqIrJR4N?=
 =?us-ascii?Q?TnyRjzTtwg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa3a01bd-83a8-422f-2ef0-08de6fe264b0
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 18:12:07.7752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ASP+U2/rhcObC1JSzWCqeX8Sm/ekmlA5sfVnlm7VhsQStZXFzjovvzoNDscPeEsSrg87ONb9udnU2H0MLpEMzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8079
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71362-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[47];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 2C4AD161826
X-Rspamd-Action: no action

On Thu, Feb 19, 2026 at 11:06:14AM +0000, Ben Horgan wrote:
> If we are going to add more files to resctrl we should perhaps think of
> a reserved prefix so they won't conflict with the names of user created
> CTRL_MON groups.

Good idea. Since these new files/directories are associated with some
resctrl internals, perhaps the reserved prefix could be "resctrl_".

Plausibly someone might be naming their CTRL_MON groups with this
prefix, I'd hope that the redundancy in full pathnames like:

	/sys/fs/resctrl/resctrl_xxx

would have deterred them from such a choice.

But I'm generally bad at naming things, so other suggestions welcome
(as long as this doesn't turn into a protracted bike-shedding event :-)

-Tony

