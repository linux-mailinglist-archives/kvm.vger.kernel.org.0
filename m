Return-Path: <kvm+bounces-23987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3C089503C4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 13:34:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABCC2281091
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 11:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29E61990DA;
	Tue, 13 Aug 2024 11:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XQ+nHa/T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1B518733C;
	Tue, 13 Aug 2024 11:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723548877; cv=fail; b=f3o32/mvPi2XAGrLtuCfl1BK0hxziQ7rEpxQx6NYO7HUV2LfsrJqvclYgU7qWuBJyjhpfLar9FonAluJO82Zf7o2mcCWfgfjpbzW+rEeMruVSN2lCSrAQY5Vf98fTYpICq/L3vIob6fpM7nIf3jC6ERa/4wW6U5iE/CkJnLesZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723548877; c=relaxed/simple;
	bh=Az0Dff/QPMyaDj41wktSu5RYjHJ+PSTFVPqoOn2kOh0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZilDAWHMEP8rKQsypyI8jB0LHHWJXqmgpSAkzYLkPxlbU+f+cN2NBC4rtKmZPZ+z3i1ZhV33F8rvjAFCUi7pXdDp6rTnV4XulyuvVRqVJlOxw67d2a8SULSG+4QfYfhcjnchHVCR4XVp4Cf/OKM66839MLu7Yt2XP/D9lP/XHm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XQ+nHa/T; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723548875; x=1755084875;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Az0Dff/QPMyaDj41wktSu5RYjHJ+PSTFVPqoOn2kOh0=;
  b=XQ+nHa/TN89sZMX6AjjzRfhLn16cDZgUGZ0y3GeBmwqTKbNQ3d7+Kp/d
   CBpwCunm4ZGp1cWEwXtRXdZ3E/0r17ceP5HGuiQAzjerV/c6SMdyhZt9O
   4R93IGgN7pC35gmTwoXpgSKsSP2beo4MXP4rSGiYrO2UbX9coSVdwZ4n4
   Zq08nr050Pw99wprz/oJTHt3FP4tswBUvU/MbMvccZWTdYZoWyirc83Wu
   Sy2GT27nz3WZ6Rcz+KzMbcn4EKYQwbwS41VUPmmgO/j+btvrRIR70vFHM
   5FPMAxk26zoNzr2IH3qPxZ7qC3Ja81Rlk7vNb2wTcnWBjilzWvWYU0wPK
   g==;
X-CSE-ConnectionGUID: ixhKNR6OShCyjca4dvK3UQ==
X-CSE-MsgGUID: MlhjmKIxRSy7IC9Nx391oQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="21575031"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="21575031"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 04:34:34 -0700
X-CSE-ConnectionGUID: TifFxGjRSIyOrZGcw4/lTQ==
X-CSE-MsgGUID: tibyuvNNQnu3e12qidHF3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="96172216"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 04:34:34 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 04:34:33 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 04:34:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 04:34:33 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 04:34:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a1LfJhhR+J4rOk3N3sKJyAjWheAiTjI9y1KzEVWzG1PuX6tEjAOtE9xvv10NpVi6u8xXxTJH1mhSSiWrkMAZzDay5znjO6NXTMeEL9YRzUpHk8UDX4f8lc9zTI0DmzmEqfcV+1dnU+xl0Q0+TlK4VcsExEUdTJ8mMumJhUARXitaEVrcbIBnB8DPNPn0+FF7QKDOfDo4bCQ66XzOB4cPmn9uyIqs/yWywQVWtYNTotBAwSJktLYWVohnFTUssXztS7HV5lcFYISaZBU3iq0oLN/PBjXsce0H5NCuHKSoRUI7R5Mm8rNICwWTYb7cF2IW0Z2VZR2MxDpDctsWw7RF5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Az0Dff/QPMyaDj41wktSu5RYjHJ+PSTFVPqoOn2kOh0=;
 b=QpoGntHZk+E36PLFgFLVRju/5B/xnXc2DYz+tbkX80kd1zyCXy6KPUPwxM1AiCJUkWyhCTJ56nYG3bWJls5e5nRD5mxTrRPZcMwr3FfGsBC7O/5ZjI8oSyrRbCxE5qgbd52pYTTftB0WzuNSwwP5EDIZStvg4oueVOXhafE4nyS9rahN4h6R8JcqykUD1DI422Q8dGy9lbX+24HSPW1EMQp1m2bl0Bnq7N2Ipz87YA1z5bECM7H+7cVh4137Gss+s1h9QpH8sXc0fkZWzcRrEtodQddDvkSLHl/ZZhNktXoFbTFy4lD2/PqvmytJLFlYqExZaP91khnCDFYV03+ing==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM3PR11MB8736.namprd11.prod.outlook.com (2603:10b6:0:47::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.27; Tue, 13 Aug 2024 11:34:31 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.7828.023; Tue, 13 Aug 2024
 11:34:30 +0000
Date: Tue, 13 Aug 2024 19:34:20 +0800
From: Chao Gao <chao.gao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <isaku.yamahata@gmail.com>,
	<tony.lindgren@linux.intel.com>, <xiaoyao.li@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Message-ID: <ZrtEvEh4UJ6ZbPq5@chao-email>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-26-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SI2PR04CA0008.apcprd04.prod.outlook.com
 (2603:1096:4:197::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM3PR11MB8736:EE_
X-MS-Office365-Filtering-Correlation-Id: 35ca8a9f-2c11-4053-37cc-08dcbb8be57a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Jsf6HZ3mHf92EkVTtl8EjIW50itQKN2l2iNi+571dGRu4g8mtI7yXDKSvbEe?=
 =?us-ascii?Q?ORdpQDjgFdh1eH6nZZXF9bXZwM0cEiHq9Z5DQgSvQ9JVoWGRQ6YoyY2orlZL?=
 =?us-ascii?Q?mHr0FTQknU7ujks3L9OhSJv4GkcAX5xLIoQC7gvuGwJejS/1KdD+HEICKhbY?=
 =?us-ascii?Q?C+XMfSqMOKKwaEVMltES8UezVFA6rA+gPNQMvt0ji1e/+0vky7qlmsm0DcMm?=
 =?us-ascii?Q?NKws28QSgloTQr4jsh0F92ZcnHBN98L1ppeqx4+VXkmybP9qM2uDgA7qwmtu?=
 =?us-ascii?Q?zTnmo3koBoTAbPLRpDGbx3GA4x4ed268xVylcaws2c6604SZER4jb8wox9jg?=
 =?us-ascii?Q?h1UZsCAe7YbTQz7Bs3EkPpqe4q4P6aQGLDAYJf4DCmM5BMAbTANXYkMTGrcL?=
 =?us-ascii?Q?+3HjEHMTi++4ieya1YQ8VoacS+rMKEB8JowRuX4qdS/+x9xK8zK95aXgiuUP?=
 =?us-ascii?Q?hpAvSyNIsRfvSXKqPf3ydbGJMP4euLBV4wEv8QN1QmxUAA2a5qzlrQVSuiG0?=
 =?us-ascii?Q?m6Xbxqt53NOHN7IcKYCzZLnkytGUwDK9hDGuGNwrfy7N+zAgqgBMTJm2Ca6E?=
 =?us-ascii?Q?pyFZIoDeXob4VebYFu/SSsh8onRYMmB480R3BxpLt3Np5Mins2nIEXJF3lj/?=
 =?us-ascii?Q?4zsK/TBYXVjD086INyQQAYNVhUmhZ8qV3r+XMMBAxavqb40Kb4htO8XMl0av?=
 =?us-ascii?Q?ev42tftdPXc//ckhFgWGXJGfK3DXpj/LCPLFO4HtyxpbnrxqcoX/fK86NKq5?=
 =?us-ascii?Q?FDpSHxRY5RJUNSIJmc/XPHeoIpGzn2qFpczpD/2hVXG4jJ4a4ti6eGas3GYb?=
 =?us-ascii?Q?KMxJ0lpNS8l9XkStSCgXxviGyPsSmQFvau+jX8YYo+Vno3QK/yyjV0raKL8r?=
 =?us-ascii?Q?xO5yS3n41mH5BQjJCRtYVa4k13sIYoyDpW0bEpVNG5Z5H2uTtaMlXwA15W/m?=
 =?us-ascii?Q?BfRDyVkAtLGRdErpZbydC4kB/qlLKHTmuKV4QPBOrxV2rX8og1vQ0YcXjyQV?=
 =?us-ascii?Q?cj4woTrgscURg6LQwDx6Mfvus/VjsMZ+YKd08XU89zKmrocYcDTX59Ygbc/3?=
 =?us-ascii?Q?l/boJ0JP/tHeInnQXZb3WNpri0it+pdn3uYQqNFSM5rIAcvArLMXwY6IOL1S?=
 =?us-ascii?Q?Ooppbt/FVjWaBKbo5EPD7mAqtNyQU95zI0WCpdj0e+bqvML/xGM8n4Vg4Ow2?=
 =?us-ascii?Q?1bwHnlCkf3pfc+/buLSgvVmjgYOyO4oQ1WUeRxSn8+rV4RN2we6TzaMiZ8/n?=
 =?us-ascii?Q?mCwxR9JTGNV1Zy+Dz5eFwVdlPqAvRABWfU9qisGznEHdUFKwkm2mayGBRtW5?=
 =?us-ascii?Q?WcExWjDkj7xdivH4uigJn7vo+IRDWPbNQvwIqRlhieXwcg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RFLTUXxNGKn5XvFqsKv6UNKexV4cLw4zRsioQxVKnidyb4MDB6QK3m9NrdDR?=
 =?us-ascii?Q?ESGitSyHAPGdRC+oTSqMroMAsr679Gra11u3TkggDLOnVHZ3NqQrZDYWdqVB?=
 =?us-ascii?Q?NbNfmLkFf+dcD5EyNY7ZiAorNCr1QxrWnTQMI4F9Ve4lnMfVR6AnKHS5CwQ7?=
 =?us-ascii?Q?NPUP3kkm8/Q45sYCQnUSiXPXN+sGxgX6KkOKBCApDl6MvP1VWc5Iq0TZEHIU?=
 =?us-ascii?Q?5vhmsKrgGxu7guplG4NYqi/0i/m3xiiIC6KbILhrUePMjlB5EX4kEzkN0i8U?=
 =?us-ascii?Q?z+0EEcYofi4CfO8S8mpys5ddUTTMZhBcOe2nQgKqFDOUVrOwqNDM5lhavXNE?=
 =?us-ascii?Q?SF5sGtn6GQTJSyLnqMTmVAYg8XlVwcycyL/t2k7CRtIzPKFLgO+/jf7rtFda?=
 =?us-ascii?Q?HE9SexDepqTfdmVD+y9ySAT4Ueu863WUAxDZJAAqvvHQoDKYjFH4rGnQ78ej?=
 =?us-ascii?Q?sJ743KzN84aCpCcFSPzwmDZfsbKSU2otBcv3EuiwvoYSJt98uK5afZiG9RZJ?=
 =?us-ascii?Q?gf+7zT4LL5IGFnJzMu8yrI6Nmiwzhniap5hBglbx9ujo7vMw4ATdpf8a5qkm?=
 =?us-ascii?Q?yMfSQDiRceeyna+RzhdloeghTOeFQKTLaVkLnE0gOizQDVySPXBtTz25ZJNr?=
 =?us-ascii?Q?5NSXncNTxtXZClPY/Lag6BSoIqAapA8VDE2h4be2NN9uEBXp9jRPP86KF9/q?=
 =?us-ascii?Q?VhwxlbCHVngftJJq+55pPZ/wGKDKAM2KV1sZgHzhnMyHxeSvdek/j7UINyGq?=
 =?us-ascii?Q?bHnTN6pnfkEH6ASk95CjHaXg299Jv1VeUi/sV1i+DuxyBfyP4JunYJe0UeV6?=
 =?us-ascii?Q?Nad/1RxU2PbK1sm21SJfNv928t4m343SmSYXYfBcBtFNpRGwGpxyabE/MAmy?=
 =?us-ascii?Q?fOP5OVFlWaotdOQPfB0JYrsAmXUqz5//m5G3yyYZCvW9hiFA83E0PyLUXMyP?=
 =?us-ascii?Q?Hfcm1nUkhg8QaUQTzOUbvz/vMXxsoOAJA/Kbpk6yJ2ibTZ+KucTdsjOlxX+x?=
 =?us-ascii?Q?Ee9etuWaisT/uEft1Q3Ek1yVedcKGBP+znvvYF842G1CifcTZdzy9CFscWR9?=
 =?us-ascii?Q?94FKzqiTrEmwrT+nJjl4y3ZwWaMnRqftCi3ifXLXyuR8tXMui7n81xASwzlC?=
 =?us-ascii?Q?aHgYiS9xoWch+ROidqB0v27crI9LC5PVzwyL9yAF4vcsMiVMvqcPsSbw33+U?=
 =?us-ascii?Q?nwaNYidK8Q3Sh9QPC7UXul+unX5oEr35AkTJULIvxWeYJqZKQti21i07G1V4?=
 =?us-ascii?Q?WDtiXUC2n2NiLIUSm3jqZp7u+l6w3qzTtDeATTz/TP827v3xTC8ObQygNfdz?=
 =?us-ascii?Q?wsL5liDwoqIbQB1cQSxGlcgbP5pDQLP2vcHEgrqBICWNMfoTgKChMPxs6uxc?=
 =?us-ascii?Q?rIWMOGVWsIt7LLn+f2VXTk7xzwgrDNrij0xCvBru66CxaSqVz5bx5YLUN5k0?=
 =?us-ascii?Q?lJbFcF2lnTTEjm2JrDb/8xytA6nDKZGGWUaV58tG9FUcd2fSykF/6n+L/7QZ?=
 =?us-ascii?Q?4g2tG/sMz7uyU6YoZKYTGGdHjQ0hBtAG5yDjlCSIZ+NSNS1RupN2yr0trcq/?=
 =?us-ascii?Q?gDyDnrTbpuqP7gpOdKXBS+msh/PAiBhlYZDPTYuJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ca8a9f-2c11-4053-37cc-08dcbb8be57a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 11:34:30.5915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E8yyvKk9XTCO04t0RaGm9QA33Y2JNe8W3HY3WnJm98tlBZOJT41y6pT/xOICX+RoqHpkStRn34lUkvrOlFB+rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8736
X-OriginatorOrg: intel.com

On Mon, Aug 12, 2024 at 03:48:20PM -0700, Rick Edgecombe wrote:
>Originally, the plan was to filter the directly configurable CPUID bits
>exposed by KVM_TDX_CAPABILITIES, and the final configured bit values
>provided by KVM_TDX_GET_CPUID. However, several issues were found with
>this. Both the filtering done with KVM_TDX_CAPABILITIES and
>KVM_TDX_GET_CPUID had the issue that the get_supported_cpuid() provided
>default values instead of supported masks for multi-bit fields (i.e. those
>encoding a multi-bit number).
>
>For KVM_TDX_CAPABILITIES, there was also the problem of bits that are
>actually supported by KVM, but missing from get_supported_cpuid() for one
>reason or another. These include X86_FEATURE_MWAIT, X86_FEATURE_HT and
>X86_FEATURE_TSC_DEADLINE_TIMER. This is currently worked around in QEMU by
>adjusting which features are expected. Some of these are going to be added
>to get_supported_cpuid(), and that is probably the right long term fix.
>
>For KVM_TDX_GET_CPUID, there is another problem. Some CPUID bits are fixed
>on by the TDX module, but unsupported by KVM. This means that the TD will
>have them set, but KVM and userspace won't know about them. This class of

What's the problem of having KVM and userspace see some unsupported bits set?

>bits is dealt with by having QEMU expect not to see them. The bits include:
>X86_FEATURE_HYPERVISOR. The proper fix for this specifically is probably to
>change KVM to show it as supported (currently a patch exists). But this
>scenario could be expected in the end of TDX module ever setting and
>default 1, or fixed 1 bits. It would be good to have discussion on whether
>KVM community should mandate that this doesn't happen.

Just my two cents:

Mandating that all fixed-1 bits be supported by KVM would be a burden for both
KVM and the TDX module: the TDX module couldn't add any fixed-1 bits until KVM
supports them, and KVM shouldn't drop any feature that was ever a fixed-1 bit
in any TDX module. I don't think this is a good idea. TDX module support for a
feature will likely be ready earlier than KVM's, as TDX module is smaller and
is developed inside Intel. Requiring the TDX module to avoid adding fixed-1
bits doesn't make much sense, as making all features configurable would
increase its complexity.

I think adding new fixed-1 bits is fine as long as they don't break KVM, i.e.,
KVM shouldn't need to take any action for the new fixed-1 bits, like
saving/restoring more host CPU states across TD-enter/exit or emulating
CPUID/MSR accesses from guests

