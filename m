Return-Path: <kvm+bounces-29346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2FF9A9DEA
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 11:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B30EB285388
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 09:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DAF61957E7;
	Tue, 22 Oct 2024 09:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K5sWb0II"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AE422083;
	Tue, 22 Oct 2024 09:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729588041; cv=fail; b=ngEzmodb0JxXWjcLrEEQNi7yQfxWhEGTiCsO/emcE8naNAQats4pLv5Mjo+Owuv8pWhmiuIMXI1eWZj/odoGEHGWNJG/zLR8bRpLuXz/E8qCb0MIM9Nwf2sN+EARdcTBjxPSYr+CudOpQ1awefohmpDOpJshxKFgIFE+mX50ReA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729588041; c=relaxed/simple;
	bh=pk9YbN4Cu/Fujlkng+y9ritaWgkoOG/3DFqCy2Sicis=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Bl7+r8LMTay1057NUa9MNGiVKhsBDurN0HMqWF+04VclgJNB21shMDLzP1i8W4X6s5QZ6kPEHo596iB7zD92iU2WZw8cSz6xbqshQrYeLFn7hQZKhFBXd1w9ph+9kF7Kk6UbG2Q0Jy/+uLBaGEnUDN9u3RtE4SMuIjLYZsNJBUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K5sWb0II; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729588040; x=1761124040;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pk9YbN4Cu/Fujlkng+y9ritaWgkoOG/3DFqCy2Sicis=;
  b=K5sWb0IIC9gzYzA2Dpeh6jQiuG2Q7L1Nfdf6F7sULIKd3bkgG8XlWOvb
   raINUkGLEtDKBeszXjZ3gQfFor9KnnNOwxk3zgWzFK0AqM/Lp9DcBJ0TE
   g4pMedrxcQo9y8C+NuKut9YQmN7wK7xNnlTc4Vfg2S89Se3bFGFt6zIIR
   /NX0GU7LDS4QHx6ximWcblcaciNXhmWC9KU7bLP6Y5tWvUBru7Hain/Zo
   WrlWgUujjbZjVO5k9qf5tLv93sY+fI5hmXoq7B+/I0ehYTi225aOhWb7g
   roa/FqOiPzTYTeF4g3Ej45MvJw4ABc0jm8fxGq29W0PLkPpPOxR+ujwtI
   g==;
X-CSE-ConnectionGUID: o4zJRPA0RuyjfQIPA/6D+A==
X-CSE-MsgGUID: IdxH5iVnQtCpMLD/djXzdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11232"; a="54513555"
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="54513555"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 02:07:18 -0700
X-CSE-ConnectionGUID: Q08UnTshRgyqAJ3w0to9MA==
X-CSE-MsgGUID: O1bS+zhrRKyV4oUMm9mUBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="79733867"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Oct 2024 02:07:18 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 22 Oct 2024 02:07:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 22 Oct 2024 02:07:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 22 Oct 2024 02:07:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZA82HS3Wya77T3Cu+h264VfRpcGiw8M/tv8irSdY8qNRkO4dPuN8W7EwfD0qYFfU1d6n6tS+DXMzLL0T9QVBqUmD/u5yjj3PHM/khBFqe+2MVPdKf/PCZkF+S7vV03bDMn7xGCoR5RBLsIDKJQSk99yl8Gr1B22jxYItwQ8bQxREDQ+HIfGYF3atJPGAk13rd5FlGHMLm6c4b/cLs8c52Neijdy+0zdTuRsT+shi0cJxE7Sb/Cd9B2Ypf3xzFI+BAvCm4SjTUmrmcFxE9bjB79TNdoT/VmrWdZ1Cm2/BWgXZp/997klsPmizBlBn9wereKfnXHnCUQx38p4VtIOeMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtjGrX9n2j54ciJnVgJk2KEAtSjWDzzEI57KCUkDxp0=;
 b=L6x8Qx2nk23TgwPZ0zojJtp+wmnTcDoI/+TXgLcAwMNfYjWj1h2JMgDc86bOgx9834eMvQ5hcH0FYBwjg3FJaCDB0HZWzx9MfECktrtAXu2yyBQCUwUQfvYCC4UevSPkcDx24MxR037noyrUClQ30DA5sT3as136czTbnV+Z4SrXpll/vtQNLZGgS7J5O93Js0sN2kJdYMU3Aqaz4LGbv08bkAu6zi+bGMCCwKUI88w1A66bvvsDV4b1LVaTZRurAv9sk9BQkpIyyW3oEkCJgj4EgPEcdDQAm6Hij8iPMy40EY+RO3WVvhXnCRV4n5vp11S08THlFfllll/kZWmD/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA0PR11MB8399.namprd11.prod.outlook.com (2603:10b6:208:48d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Tue, 22 Oct
 2024 09:07:10 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8093.014; Tue, 22 Oct 2024
 09:07:09 +0000
Date: Tue, 22 Oct 2024 17:06:59 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 07/27] KVM: VMX: Initialize VMCS FRED fields
Message-ID: <ZxdrM9IV7iX02Of0@intel.com>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-8-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241001050110.3643764-8-xin@zytor.com>
X-ClientProxiedBy: SI2P153CA0009.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA0PR11MB8399:EE_
X-MS-Office365-Filtering-Correlation-Id: 1742c5fd-f473-4961-c3d6-08dcf278e8ab
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?O26sIxukpBBMzc171bT/6+BrS56velI7YE953YIq41JetOrr3TfrAstWKDqC?=
 =?us-ascii?Q?ed3Zj/ahRyajbAbk8Ih42AJITYfYFnoOve6BzdgDTJ2My6dG+TYhQVORnLvA?=
 =?us-ascii?Q?ap+FG2IJcDOgIQaqHEA0BnZkqviDYZlNby3yIV1kdrKH464ljoQy405Zx2fo?=
 =?us-ascii?Q?DaVdmtBNmqNeU1oLScIhAd5dk/V0pFvFnB/7UKmovqB1yQ3Sj1EBVkuYuvRU?=
 =?us-ascii?Q?0El9bR8eRND06RAoevUZWmy1iLA2Fke/JBnv2wMGhLQGSAX9ASGSZMcfSARd?=
 =?us-ascii?Q?zu8hcOeyVSYqHy0A7ElW+g8wkCsCwOXuwAnYXwW/IXyJ9zXcox1aXfnzIA3x?=
 =?us-ascii?Q?tarXpVX3jeqCbG+C9fmk+V/oZShSby/FWPGoDsc8vOE2o45VqSZOOHeXdOWz?=
 =?us-ascii?Q?OCbsQru7HLY39svGvBQB4QFN2H7MWpjktcv7bFUxNYD8Pw3sgSQ09N89gtx1?=
 =?us-ascii?Q?R6d4sU7S6N83kMEsD4i5kpfQY3R9w/yfoSdanQFW+AX1BGXcLFwkRAsoWRhO?=
 =?us-ascii?Q?kkxnb2MwRIUdP9zxHViFB4w72XbuA3p9HEO8tgwRS+t1guzWoZLosw2OMFls?=
 =?us-ascii?Q?NQE7fnzJuZGzeBvL+8kqIBQCEJpLgYzhU1AxELu9DGPMYMrbuu23AWm+L9ig?=
 =?us-ascii?Q?7Hiud29B3Kh1HZ+2b5J73W3lfNjQi/niSr01/y4L5ygePYejC25wuONcV1/Z?=
 =?us-ascii?Q?0o4xLB4pgTwPp1V90Ns+LS7v6nVggvRJEzcfgLw96YmGEvDcliZTEIFhD/uz?=
 =?us-ascii?Q?xQymAewW61W3uM9lcSEY+uBUhiV3F2DpoFS9SZE2hOv3TyHgPpKQAVqo2IQt?=
 =?us-ascii?Q?OA5El4mFd8bR5YZ8OZqWT7jVZJXA0WEcMcpYccI+L4T3jrfOIVFrhM+/Znjm?=
 =?us-ascii?Q?ZEFL0WC57s/zcMFRQJrGCxeKprOVSgZ3CImwqZ+KMKdQLBrYGa6PLBG8+pcG?=
 =?us-ascii?Q?n9nGAW2n1VddypRCcc2k5VSBLMOnGLJLZe0VcSg947OFQCZPCaeurL1Pvrkk?=
 =?us-ascii?Q?FTe0TPfs0jEoss1ykNQzWjaEuNkIhzgk9IK7AYQAV/eIY/zHWqkVk5omE3+w?=
 =?us-ascii?Q?7S3JarF/v0FooeCB8Z6IoCLTsQ2sUYFQO3/SIuaF3MMMXnuirLFB+VOBZaaE?=
 =?us-ascii?Q?479a4EYA4KwksKIacWiPgJqsvbappLVcDJQtwLKuUHcfwasPL261CSuMP/LF?=
 =?us-ascii?Q?oiXOQDfHOLkRzasp1qb77ty6z5T4TqExRe/aV7oCFy7rMkvsj48uSB+tuu6i?=
 =?us-ascii?Q?KvFmjrdV5ad6zRcUJBBeNTZiNrF2VCGGdV+ctNs7ksyBL4nmbRJ81GZ36Jo2?=
 =?us-ascii?Q?SnU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w8T6a01D05aAqjsFspLMNNlkfFWAXor61NAP1KNpibY3kg9B9/q+tveDyaAC?=
 =?us-ascii?Q?u0xitKvMqcl4Wz8a6rz9/X1fi1/SOFJTQX6/mQ34fqiwU5tXNMmXzCC5Jy+F?=
 =?us-ascii?Q?UmLD0rrGUcQk8pLnB2ePUKc0DcpRVwFtPWGcfatg8mTS01Skw4Yc7zgLWWjJ?=
 =?us-ascii?Q?tkzByXfqwzgkiu0/6W47u4jAWwPMtRLoAvTsLg+CbZ/zzS6AUt04UeEYoY3g?=
 =?us-ascii?Q?EBr7UBA4F/4YKQ4h2w6JuTHJqG0mdZXmGtXWEzQi5EraFW+ev1CN07c1Ak1e?=
 =?us-ascii?Q?/ezWeELeQh23+aEs2DbMxySAllpCTaVCrsdnBTbsZ9Po2X8Ms1ih97DQ/FsC?=
 =?us-ascii?Q?s+VG7/Vz5iFqOWbLV2UocEL/eU9LKH1J5zB9TWx0hvtfqcAMAd4ymzWq7ek4?=
 =?us-ascii?Q?VlahWlHqOxKQkqThEAVmR9LeZbFUuOenJUEo6g3BvojVZBUo5LkOnahGJM07?=
 =?us-ascii?Q?39dOovg9aN6clvnrJ+S3F4RFH1v+p+of6gasyxU25Ky0Y/Kprll3hh6toM44?=
 =?us-ascii?Q?WQBzxZidnm31FJdN10uZrTZ+E2sc+pWlsGy1W78ppgfEgurE3tmVFpq7N6ko?=
 =?us-ascii?Q?OgLUkrIq/F3K85Gbr2tMnUGGGe4uXF5kNH/Ldc64Iaz2sGLEn0uc6EzB5LU8?=
 =?us-ascii?Q?qqzlA9WqQ+olqeMLGf2FX09dfZzYOGNs5lt9sRWw8P+7Gusn6Z+xCXt8NSQT?=
 =?us-ascii?Q?OCv6XZntinOHXE6eImtBPl1CSCmgP5gnqK36TiRlzQvd/yAWNHs2JA2spmOP?=
 =?us-ascii?Q?A7RoBO1W/cAWD/7N046cAChn6h2fTxNBVq3lGZoxaIZ+1DVW2FWXyWt0bCSE?=
 =?us-ascii?Q?fVNr1E0WfsH/QKh3xbZmSe6/DKVTolwFfbiCs2LYeMPdyHfIWfPqa1DAFJCy?=
 =?us-ascii?Q?g268PWug8FM0yGBZP9HNDnzoQRYkc0HVr+dgWQ1u3OjCcGZbRms1VOwg75l6?=
 =?us-ascii?Q?kXiXwJ5PHuaVIc4mJHnF6sH+pFgZpLqvjvHumCY3YgWMWwAW/1oXgbaM8dIY?=
 =?us-ascii?Q?mfPeQhrIQS+qxHIAy0AH1UTMdaSX8SsCwYnu2qVoQCIDSZbENkJa6rMvDUyE?=
 =?us-ascii?Q?DkZ5US9jR3wCzrdQe4XmVQABTiCX4TeOlHBruWwXJDA8opMUfHlMPjHaMRgd?=
 =?us-ascii?Q?qcS56Xdet46t2HKaYhVzMQBuZtVyDgjeRHtgPnxfJlhw0C8e2y3zHfKViHHS?=
 =?us-ascii?Q?bKYOd4uBTLvEn92cZmIuwowRqdo936Hiw4dZnf3xY3rVyvBp72kAQAfo2kGm?=
 =?us-ascii?Q?RLoXX0o3JRppEVyf+Es7RP+Y7pKbptVD0/9p4CGd85GXS26TW66Xb6DWJ8hi?=
 =?us-ascii?Q?FAfkJyy2StsNTdbXb/w4czkoWlAoO/HhnDlyitn2h965F0UZ5oepA+05rqQO?=
 =?us-ascii?Q?m7Cf8KRiTDo1ttoFmKHMK1qDQKKKQHvC9WycJi7+sCIh1y9NBLEyYzildXJr?=
 =?us-ascii?Q?MPTDyb3b/arjXcQ3aGPq2RZJrc7gWe5GMKHMGRN9EgzjhzGREgR2Nk9FgTax?=
 =?us-ascii?Q?BstP1We4kFTOjQJWdiftZZx1dVKKWqW8e+WhGLxSdELGLlc6SO4dPdWbBUtk?=
 =?us-ascii?Q?X9cRmefaYO4871qXSoND7FjsoFNlYGJ/Zxc5u4B/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1742c5fd-f473-4961-c3d6-08dcf278e8ab
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 09:07:09.6411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jvb4zEKjiYzdTtHRifHKTPN98ZUmG+I7K8mcxsVdFdMw1wcANrs6aB9zH34g/kJ2v5WNHujpYwCfCtZwxftdUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8399
X-OriginatorOrg: intel.com

>@@ -1503,6 +1503,18 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
> 				    (unsigned long)(cpu_entry_stack(cpu) + 1));
> 		}
> 
>+		/* Per-CPU FRED MSRs */
>+		if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
>+#ifdef CONFIG_X86_64
>+			vmcs_write64(HOST_IA32_FRED_RSP1, __this_cpu_ist_top_va(DB));
>+			vmcs_write64(HOST_IA32_FRED_RSP2, __this_cpu_ist_top_va(NMI));
>+			vmcs_write64(HOST_IA32_FRED_RSP3, __this_cpu_ist_top_va(DF));
>+#endif
>+			vmcs_write64(HOST_IA32_FRED_SSP1, 0);
>+			vmcs_write64(HOST_IA32_FRED_SSP2, 0);
>+			vmcs_write64(HOST_IA32_FRED_SSP3, 0);

Given SSP[1-3] are constant for now, how about asserting that host SSP[1-3] are
all zeros when KVM is loaded and moving their writes to vmx_set_constant_host_state()?

>+		}
>+
> 		vmx->loaded_vmcs->cpu = cpu;
> 	}
> }
>@@ -4366,6 +4378,12 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
> 	 */
> 	vmcs_write16(HOST_DS_SELECTOR, 0);
> 	vmcs_write16(HOST_ES_SELECTOR, 0);
>+
>+	/* FRED CONFIG and STKLVLS are the same on all CPUs. */
>+	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
>+		vmcs_write64(HOST_IA32_FRED_CONFIG, kvm_host.fred_config);
>+		vmcs_write64(HOST_IA32_FRED_STKLVLS, kvm_host.fred_stklvls);
>+	}
> #else
> 	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
> 	vmcs_write16(HOST_ES_SELECTOR, __KERNEL_DS);  /* 22.2.4 */

