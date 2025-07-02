Return-Path: <kvm+bounces-51268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C13FAAF0DEC
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 10:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96FE51C2060A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 08:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA025238149;
	Wed,  2 Jul 2025 08:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K17zCRdQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571DE1D63F0;
	Wed,  2 Jul 2025 08:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751444797; cv=fail; b=LU2mztniOAJ4ZOJoMPWe9RhbHmmaIXlZCuJmbAV3ynad+FoidZDjZodK31JyMTcN4LXJFHQNEmvoRYItQ0ulFrXfdmbeVcNqf4WbiNlBrplGq7VnWdJn4jKTv9pqB7gZVWHoZSOBoKFrd71gJBGyv+cchtopSmGh9hJIcTPAa7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751444797; c=relaxed/simple;
	bh=Wv7XvEP/1o3NluIHDQQqHZyZ6gnClb1PZOEEGELkKCI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KaDgDrKIz1ip+XZcMoMDaB4NXoEhQM9mqdsjA1eCmpoHhnDm9M8Jn572s9woNGoFJFikr5flRb0bKz+VXiy/wMVf6sDJGrEuNLbh0LKuZUzPL+FMRCCXxKT4MjkpmxNRsaVtDayzZ9kpriPFy1exVA+R+RAzZP7iNMR4qWWQbW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K17zCRdQ; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751444796; x=1782980796;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Wv7XvEP/1o3NluIHDQQqHZyZ6gnClb1PZOEEGELkKCI=;
  b=K17zCRdQYEK9ehhZX1fc7jx8CBi836vMb42X8Tw6ein+SySnufqpZ81C
   bUOcVekflUv2HZd/QkSLHp3umaQcoFMyv3Y172iFUhS+Dm5/Pqdqg2t05
   9FkrDhG53U/HFyE/5pDKgMBsy32XPuv6eFjappDAfkjl3NekTY3NibvNX
   E6MXCQ7XABZnVXGjPBnIYZqQyAyO+Jgi8I3KO3KHPlm7lZbBC0rBddA84
   +5ZbERxmapyR1etRl1DutbVVrKXncGZjUvSfwsVn6VCV11gYrmM827MiQ
   XvBmokLFvPxhY+Y6sS3LrYTmjEZlWIfedVD7Y5vL14o2HJtsuUWoriUkb
   g==;
X-CSE-ConnectionGUID: 3u5yfprCTICpvl8g5c8E6g==
X-CSE-MsgGUID: F15OxAIDQtKYnusSqliO+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="56350925"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="56350925"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 01:26:35 -0700
X-CSE-ConnectionGUID: Ykaj43gcSp2hJ1ZR866AcA==
X-CSE-MsgGUID: Z49rdofsRzqwgvXA6w/A/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="158568048"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 01:26:34 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 01:26:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 01:26:33 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.42)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 01:26:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J9Jg21tk0t9llcH4GhRolOTL17RneY2KJUaZYDDyHUjIqIyBkqQvnbKSwyFNvcPoXGd2k4swaj+ZyEGoGgL3F7WlR6uglYUFgbRGx8wopyD17F+bNsGnrOQ8NqOQ/+YgN8YPn2qYcjkQdrVXZIp/JZgzIISHtHJMQtLcKXm12TBHz3pPhdqNGDyyMLmDlgmPPIffoL0VgASPUBKNVi32xUgwKV0pz2FlQ2tA/ocaZxjFbw0CjW4BWzRr5tIDA6CF3Gh3JJMX7niIKC9Obyi+9ytR+DxPvTOhSEpNTkAyc5Rcj4/4md+qNKW1KEqKt7VNveT5eyDGMPlB8RIlYIPCvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++Kb2TBdMSxSC7jP0Uj7oe5Uo19dVlLto9o6gRtPgpQ=;
 b=Y8VZfwwFqKo+tSFv7kUICrWGBnWpyEXle2j4fm8s7EHTIre4D80UNOl75/xhPHj4kVVLsE1ZyTfC7sSPuJrlCKb2R49DVV+OTF6voIEuDmQUC/hF2zuXyklsh2/U1VtiBa4eHwh4ITd47jt/MlYLGqInJVKMRIBv1Tgzfuw0UZzNm6ig0FSTQPGG8YwoiFXb4FM/zvJtrmNnI3IOpGHuBAqKqBp/3PtWPvemIz0rJdk4r39qvenk/jczErqD7i67MBmXCE6mu++O/1W/4HLNmj/PsAftScOfS58uW4xYUDg0S8lRpr7YMFoqjQPIXtctYmnU/ysW7ab5ktNJle6dNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW6PR11MB8337.namprd11.prod.outlook.com (2603:10b6:303:248::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Wed, 2 Jul
 2025 08:25:59 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Wed, 2 Jul 2025
 08:25:59 +0000
Date: Wed, 2 Jul 2025 16:25:46 +0800
From: Chao Gao <chao.gao@intel.com>
To: Kai Huang <kai.huang@intel.com>
CC: <dave.hansen@intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <x86@kernel.org>,
	<kirill.shutemov@linux.intel.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<kvm@vger.kernel.org>, <reinette.chatre@intel.com>,
	<isaku.yamahata@intel.com>, <dan.j.williams@intel.com>,
	<ashish.kalra@amd.com>, <nik.borisov@suse.com>, <sagis@google.com>, "Farrah
 Chen" <farrah.chen@intel.com>
Subject: Re: [PATCH v3 3/6] x86/kexec: Disable kexec/kdump on platforms with
 TDX partial write erratum
Message-ID: <aGTtCml5ycfoMUJc@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
 <412a62c52449182e392ab359dabd3328eae72990.1750934177.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <412a62c52449182e392ab359dabd3328eae72990.1750934177.git.kai.huang@intel.com>
X-ClientProxiedBy: SG2PR03CA0089.apcprd03.prod.outlook.com
 (2603:1096:4:7c::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW6PR11MB8337:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fb6243d-039a-44be-8a3e-08ddb94212d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0H4JVm1axelYLRzwmHpJt2aTRP/Gx02s4hOOhzeC6rGef6mJ6awYxIc3zugR?=
 =?us-ascii?Q?uc47ppUKKC87nF0Rlewm/Az85WvWk8kTFKIcxmWnLhFE9Af90XgTLh/ScHJJ?=
 =?us-ascii?Q?O9sQmz6wdT5w6rzMZEWChisS6AJVePRak0uTqa7T1o6ORS4bY7j9lm7Cu69w?=
 =?us-ascii?Q?BbjkvIDcbcEtytU/isWoa4+LKYfx21cShdDWNR8JpskupcGLrakHFAMSIYid?=
 =?us-ascii?Q?TCKAgKvclTkdiH5LVptAMq3eC1OxsW6i+kwg0xW1EOatbfbQY0PtDzybUSv+?=
 =?us-ascii?Q?pazsr5IDBh3gcqkERQIiP8ZEkwR8JOGuexG0647rmUe6XFJmbRfVKBMp0imj?=
 =?us-ascii?Q?GQWwsBUrHzmvFHarKc0lsqnP6sXVKCSzXAN4rSManRfv1vozrofS7N2bi+Ih?=
 =?us-ascii?Q?KLcz87Ov3UJPN5Zmf3lNG4xnYW5SbJjg6H6CwWBvcnbQtHXU0DUmr5tzlXV3?=
 =?us-ascii?Q?nn5I0oKO5ctPyK07a3aNTr1yUDTb+dYKIIw54CKk84x51Gy0SCXwrP+6acgo?=
 =?us-ascii?Q?7ePB5+Q4elJs2xRo2Aiz2VsNW0YQW6hlyndSun2T95/jr9OrNQe+Jw3yDx6d?=
 =?us-ascii?Q?VITw5M/+/Q+Auon8Rqa676GBS9I8MVhVvJ28gTIt8WII+GERMi77RvZaQiEW?=
 =?us-ascii?Q?KVLf0jxdkGm5XUar0bVGHPLyLwYn1i8phRQHsVsPdIYQxSfyIRIkAxnl1qie?=
 =?us-ascii?Q?icgiqCqd05YzXGJZEEfR+/Lkhz2ABxP6v0MetagFtO2dNb2Y/9Cy839pwt8s?=
 =?us-ascii?Q?5iWdHxYB3XOceqdLsUFshUmlOccO8ur/gMDlX1B+VkWTvVIbC42b2BZ1jZfl?=
 =?us-ascii?Q?B7sgXEfy0xtibCHjIlmFAvSZBY0n5E19n9ID2ACkvVGW72ExydMNR38cOoVz?=
 =?us-ascii?Q?IEuKu8pISl/k+QH2EeZrlBSsFRq/1f7q3gF3NtqMKxqADSAuPEKxl1U63/s/?=
 =?us-ascii?Q?lipjczRlO0tIBrd5JbKZ3blTk0rtoAJTZuMJxt3zkcNeNwtg2h+tvEFeBclO?=
 =?us-ascii?Q?2J8RYWBjtvi8cC5mVdqzuHVJVqxAz8CoecjcLF4QMyMXckcJ63QOxBUA+Hu/?=
 =?us-ascii?Q?Tlhdb7Ve+N21HLB+3DcNNdnCfBVTmpaBK6tKu73Cn2sBdKTds4d/42YNawpJ?=
 =?us-ascii?Q?dnUKFuaDeP7rcc5MscilKPKlTtutqQ3osN+W7EB1qmeatTG3avFbWQtVX5/D?=
 =?us-ascii?Q?8qMVx+oJs9Q21NJ/22koP8GI5R/XhjCIXs3fC4FCQPiOBUFtnz7tN6ivj46P?=
 =?us-ascii?Q?QWQoL4f3glTthigfjbT5lVBjpf3gUvGU0zpSwCJxV9hrqwlCIbupadD+y0YY?=
 =?us-ascii?Q?4z+v9uf2MhZMXrukfVrKzIlfePDXTiP1UHTBgzxvw4zZoHgsefpred7o3uGq?=
 =?us-ascii?Q?soT+lce9jCW8nsHMWv/+UfzO2l9HfI7WjsMaGTPLZbDYzDtrM2T3dX061Tjd?=
 =?us-ascii?Q?DHCdbqTqhVQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x9L2mY72Dge9sFsAozCIlo0a+fjy4Ci6/WybSNeFlKQr6E7pYudVYTNergEp?=
 =?us-ascii?Q?6L61CruojzcmGL7sP4QYPJlVfahhvNS9fB8szdHw4z4FJbMcR8pfaKqb/hSt?=
 =?us-ascii?Q?1BjBfuCXC2aAmhelB3CvqJaAOEW0g/fNJo3qN+MK+HCLdVCBplBR1Rv1kMjS?=
 =?us-ascii?Q?Xdf6p/0SYSNff1EikZizHmuGP9SGh5eoXyLwVE/YaIEa8C9IxIPye5oFhBBW?=
 =?us-ascii?Q?8zcsrCAyJxt6CgS7Wvcn9YmzD/DkcvaNy/KRUXphwWIbkRiP162IgTeIja1z?=
 =?us-ascii?Q?A8ueFa0PNYdA/sYO1tsb0BS+nSei5u5026THiYd4DzBNPkSAYiFarHflGyzJ?=
 =?us-ascii?Q?kHxkiDXtAfmZOj1e9VbJ2ChKEzv2YTwk3hMlICiMpNwBffaZ4X+FJNCv41kk?=
 =?us-ascii?Q?Q6ANTM+QFt0LwAN5aAYR93ouL7jyODiD6FFzD2M9mK/7Lpli+LI8Hmh3wxW8?=
 =?us-ascii?Q?bwsjtajfZIEjr+d7XH/TKwL6bBE71Cg36hoeGIj66K8rv4vpqML1LMghoHWg?=
 =?us-ascii?Q?cwH75dtZYweaMwWiziylv2n7FPVvE0NMvcAlkbvrWdTCeva6MFP9N162RVck?=
 =?us-ascii?Q?pfaCke7KRTMmGwVwXT5PySO7uvTOAL9EC/ujRVWORbkeIHE65dRKI3jxH8D9?=
 =?us-ascii?Q?t8ByiWtS6TJAh8OBZqqag3ESOrsvBSAnJu6eJqmAl3ddaCiHHGhbDx3NHV0+?=
 =?us-ascii?Q?vUHwUk3Xwh65xe6HoAarrsdrELIKBAPGejB+AT/9iANHx1M1r/xM8rUcTdez?=
 =?us-ascii?Q?IJ1diFsEANZrXIEEYt2nk2bIeRyXtPUdGRKxvRzOKcYwuSoP7aGX3DqX8Vvq?=
 =?us-ascii?Q?N7ypAT4SzXcfa3NohwnHDV1bp77QZawmJY3+ATvk6QaIIRCuY6F/ubBOFtRn?=
 =?us-ascii?Q?rxQ9WJTCoTaXwReAd+yXMDrPZZoWMby6hkXzOgBG1uaTL8yf+W7OryX0AvTZ?=
 =?us-ascii?Q?Mx2Q6Vp4d3SSG7bvc+ijQCqiIQ5EBZLlscXl3twmLR/jCE3/nEMFFqzW2Xuk?=
 =?us-ascii?Q?cr6BRdEwrAyuFFWeSA+7AW5hXFVatRcX0ODqyTXWQBorHoOV+A8ArnTtd5FL?=
 =?us-ascii?Q?UOJswAmgz8RJeiLiFukYQ2uIsfzW7x8LmOUWKLS4iA+7VCYbxQWngi2d2n8P?=
 =?us-ascii?Q?YsE6lRtR8Fi5BsKiSEMmoHWldLYmUCBoezb5/Y11Q5Ut0X3v5vO8t3Miq9+s?=
 =?us-ascii?Q?L7lwuOLG3K6sDa8cEC1rVYCJAnkIMw55ZZGqBmeM/46OoTRgY4AmUFiGQVuq?=
 =?us-ascii?Q?CUUVDkzXE5cLwqNiwPC1KoH93j/LvihnAq891c7+QaDwHm2wrYhazEO8Ja3G?=
 =?us-ascii?Q?5AHTqDbZ3SSJz7Tz9626tkRc3EXHYwptm248EkfGMx8KpVtVoxKEaBiQ1ltA?=
 =?us-ascii?Q?1nQ9rj0YRsI7llZxGJK/ML7ek6ov2oFs9C1tATZ6bFuZVL54jTrifTWVlDo8?=
 =?us-ascii?Q?hq83zX0k1DLRJHDSp63J1zEMr8/bB4mZKVpH22mDfEmw8hk+qoHU0YZ8TM26?=
 =?us-ascii?Q?ySmyOg2BhmQvc7b53kIS6nKudjrtDCxI+jyS8NHNWWPgUPU97CG/FHtwegVu?=
 =?us-ascii?Q?zUS6bHGQPkIm9/4ySlamhf/F/nuWilNMcUlvofGn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb6243d-039a-44be-8a3e-08ddb94212d8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 08:25:59.3474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F32QfqwLEOA7cmT7N/YPMYDdDAha9MUr3TJjN8Dq46W39cmSKUnnt3AGjAnRtg+SDe0PBUYbVhf7E9EuWAshDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8337
X-OriginatorOrg: intel.com

On Thu, Jun 26, 2025 at 10:48:49PM +1200, Kai Huang wrote:
>Some early TDX-capable platforms have an erratum: A kernel partial
>write (a write transaction of less than cacheline lands at memory
>controller) to TDX private memory poisons that memory, and a subsequent
>read triggers a machine check.
>
>On those platforms, the old kernel must reset TDX private memory before
>jumping to the new kernel, otherwise the new kernel may see unexpected
>machine check.  Currently the kernel doesn't track which page is a TDX
>private page.  For simplicity just fail kexec/kdump for those platforms.

My understanding is that the kdump kernel uses a small amount of memory
reserved at boot, which the crashed kernel never accesses. And the kdump
kernel reads the memory of the crashed kernel and doesn't overwrite it.
So it should be safe to allow kdump (i.e., no partial write to private
memory). Anything I missed?

(I am not asking to enable kdump in *this* series; I'm just trying to
understand the rationale behind disabling kdump)

>
>Leverage the existing machine_kexec_prepare() to fail kexec/kdump by
>adding the check of the presence of the TDX erratum (which is only
>checked for if the kernel is built with TDX host support).  This rejects
>kexec/kdump when the kernel is loading the kexec/kdump kernel image.
>
>The alternative is to reject kexec/kdump when the kernel is jumping to
>the new kernel.  But for kexec this requires adding a new check (e.g.,
>arch_kexec_allowed()) in the common code to fail kernel_kexec() at early
>stage.  Kdump (crash_kexec()) needs similar check, but it's hard to
>justify because crash_kexec() is not supposed to abort.
>
>It's feasible to further relax this limitation, i.e., only fail kexec
>when TDX is actually enabled by the kernel.  But this is still a half
>measure compared to resetting TDX private memory so just do the simplest
>thing for now.
>
>The impact to userspace is the users will get an error when loading the
>kexec/kdump kernel image:
>
>  kexec_load failed: Operation not supported
>
>This might be confusing to the users, thus also print the reason in the
>dmesg:
>
>  [..] kexec: not allowed on platform with tdx_pw_mce bug.
>
>Signed-off-by: Kai Huang <kai.huang@intel.com>
>Tested-by: Farrah Chen <farrah.chen@intel.com>

