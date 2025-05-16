Return-Path: <kvm+bounces-46784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E0A9AB993B
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 11:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7D981BC6980
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 09:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 242CD232386;
	Fri, 16 May 2025 09:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KLEoTuFt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85666230BFF;
	Fri, 16 May 2025 09:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747388730; cv=fail; b=hCNvL9qS7X5M9He7K5uDbZYzko7G1KPaMwvgCvsQcNsBILtLGY6kp6V3gHQI/N2l8aJOWeSrNzqVhWC3oj0vM2ZMaxc2L+eNISqSQuxCS9RyQ7M0kHWMwhoWlqc+w+0w3OUS0czmaikhkSUMF7ETteNvPTIua1UhKjttaahf8DU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747388730; c=relaxed/simple;
	bh=LD+e01AVyKNpdyFNBlB8/pY8tnREYb/aAtmxYuf1NMg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=s09l+p+7O1Ojb0zbo7iZw4mYFu6DkcUvuP63o5E7fkZ/R6Vo2pXhH/gf4meLucRq+pbq19dflgxAKQzWkQDSTCyBOz1eceAOEDueS8Rd9ngljUKs5YRmtb8hyd/5mlE5TyaaYvddEbI3lKQMy/JCeWjw0d/kbAVQ0M19cpNPE9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KLEoTuFt; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747388726; x=1778924726;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=LD+e01AVyKNpdyFNBlB8/pY8tnREYb/aAtmxYuf1NMg=;
  b=KLEoTuFttGS6dgH65RE0SuSMrdoMjAnKsgenAgrZf4HsjK3mxWEwxlGW
   JeWhAcjIibRZqqcd+59nubP/x/G9jffWnG2D9MPt+ndfbZDKxiGcwCDvI
   uay8xBmqjKYgY7u+qqRzooOFAjlyN47JW7tyhhrVH4BpVYt/bgpTkuy00
   TDpoatMbw+i51Mbkw70+MP1eFF8jARP4h9iP/mMlDHN5OX7XlSw+1AleW
   K4D2BxJCNA5rw4GE2xu/ztVuVagmv8SQ31wuBuNuYTQ8DvZ0BfuFhFVCZ
   XMZIjIS/s8T1liU9MefwbCUx+a2K4e6otnugnyGhtkPnVhObWzX0Ls1du
   A==;
X-CSE-ConnectionGUID: lR1Kh+DUQKC0sZqVxtsdrA==
X-CSE-MsgGUID: Qp1Q6937RN6SixbHAjkq3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="49281543"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="49281543"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:45:25 -0700
X-CSE-ConnectionGUID: K93r1h9iSPaBl8rGFE5FvA==
X-CSE-MsgGUID: zWP3wAFkQayIn0MRYy48+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="138560437"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:45:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 02:45:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 02:45:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 02:45:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CnCmidUKZUOTeS5h/CFHRQGNY1vpHb2L7YUZfJqsYNTXOe40vcG09xaDtWGshYsRCGSqUOwhwt1tj8xiSnYACCh1xE2dwnd0elMnQ3z/AqBLsLn/fQBkBxHMNNWNt6xW60DaNhRNaN63Q/gzRKPziOalZfh0nppU4qL6LgoCA8Y1o0GJ8PgrdzNE50BGlHUSGKQP3BW8Q/4T38nhXjdGdJGslc6V4h6Jxw5xV8wtPWujA32bkpdL1QPV0GMOlzv2a2cqy6KxHvwZ5Q7Ofs8YNWqpMHnq8vctCQf8jtm73I9rAeGENQCLq7cz5Q67djvPUgabvzp5CxXL8Iyn5SYl0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FoFSR5i3Ddhu4WxKa4dC28ZjY7izbGv1jxIQOHlP9jw=;
 b=FO96EuGLc1pju+VWLXYTzTLBRINS3jnsjApWXxFQNEY3u7Y49JrPugXufaEnWPuWcnETUwTVJ4GD8fVaKHZQJ7WfiE0/6hDttagu5P0KDBVNaWdq7FqPuanuOa2itcPnfWOd6I3II3G0P7/X9aQI/Uy+9ouhBZ/BMImTUzDTGOWXVq1oXEodIliryObi2MCe8A7CurMOhy8inoC52PxokKfCknZqxrGzjMFM2o7HF1N/UlGm2IwGllT4gR3K2mhvlZKzSquW68SzJ7zWaN9BE6Y67AilZnm9j2i37VsoR8U6/xjRDVZw6LHJQ+gyrBL5I+lymylecvgCJqgebf+wFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPF1DFB73954.namprd11.prod.outlook.com (2603:10b6:f:fc02::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 09:45:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 09:45:21 +0000
Date: Fri, 16 May 2025 17:43:10 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"Du, Fan" <fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030618.352-1-yan.y.zhao@intel.com>
 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
X-ClientProxiedBy: KL1P15301CA0060.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPF1DFB73954:EE_
X-MS-Office365-Filtering-Correlation-Id: 7db2e3f4-23cb-497f-03a1-08dd945e5f77
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?lguUpODx5UjmzYXKRYRN/+yLaKTuZxeGhFs9Y6TWrZZhG3n+mFW8m6gZSP?=
 =?iso-8859-1?Q?HJ7r95Ertz5GlwBduNn+yVeKRrUAt+/CmtLb4Du37ikTT/R9RRJBzZ4wRx?=
 =?iso-8859-1?Q?qkrfJTmcgEuJIJYfA2aSaZsmyZr5BeDZJhLWXawEb47FIXs+Iokz1jmY/z?=
 =?iso-8859-1?Q?i5qDWE6ME+Gf1rIP7h/i+Negc3avNkHFA525BfzKcfyHggTcW0FfJvmDi4?=
 =?iso-8859-1?Q?4LC3ISjQhO7Vo+X8Sba9DO8lCbIWOBcbzodjiHOgHpVn4N/VH0DcliFgpB?=
 =?iso-8859-1?Q?d1tYhC2oRrnb/68eVYC4UlaxsnEU5AQpkymWVXq7kRHKynEN9YTENF8rIQ?=
 =?iso-8859-1?Q?i/p6W+3Cym9TgZ4asiXvzztZm1/Tui4AjCRaAQWM4F6VYRD9oxftE6yALw?=
 =?iso-8859-1?Q?g8XwH44gbQS6hbbM859m9aEo/ST4L6dzrzRdlKLqGl731JdWpHMks40zYC?=
 =?iso-8859-1?Q?9y9hUSy9GaMvOuIU4CxthNRiNhXHl5s16tnKnU5Kjig4+GBQcVe3lFCNlk?=
 =?iso-8859-1?Q?VIWS+GctylXZMaSK2JTfItY17CcyiWXrKio02ZmI8t3/NGH49k+nTMwOUk?=
 =?iso-8859-1?Q?vo44vVVr8VYwOrPRpxBJXKLpcD1PJV4sogfJGEZh67lxV4zFkKJTAd0v3e?=
 =?iso-8859-1?Q?3tGwUqM6ECbj1NkM9zr/GK+JBBwMlcaNhsBW9HjEUIuFrDpxSfgV+atvvV?=
 =?iso-8859-1?Q?06YpVGDZhVL9KgeNda88O+ahV4yWNBbXj4MRq7oVDl16nizZE9h8KH9cYB?=
 =?iso-8859-1?Q?oLzAPSdiDzWg4h2CkwwzZ0qQwpmyEDW+Mw6F0R/t1K4EOKS8sfIzrLyoer?=
 =?iso-8859-1?Q?mMgXq/JzePHBrwVwLT2EphrugqskzmQgRcthJFKO4gHBNHo0T5zru/pONt?=
 =?iso-8859-1?Q?gMN/saEUOwMU6Dr73nZm+RjetI/zjAYbKIL/KCVTia8BIE8RGakeo5Yuqx?=
 =?iso-8859-1?Q?RmD/kri4c7Zv8yiuzTlD2YxALLYI4fCGSvWfEv20O/U6UeVozyIlDKilmu?=
 =?iso-8859-1?Q?OfdQNke22QYsQO4XKJniodKPtbrXRRakecv8+zIdzN/TYwZ41cRluT4l1c?=
 =?iso-8859-1?Q?3Me6aJpg6rANHKXF+Qu52meWNeG1kzPrZE1IHogZApsbzlfjJ2lR7prlna?=
 =?iso-8859-1?Q?/3BgFbVmEHdtAIMjJ0WE5p6ehaFcljQgqPcXPsDt2xabkpoACU+dfHlbCN?=
 =?iso-8859-1?Q?cl6dbyIPM/9R6JgcVTZHtJD7Ii3IXM8AEq6fPtmF5OBWtasnQH00f5lbWO?=
 =?iso-8859-1?Q?WzoeYVSj9EkXP6aVX2brxLhVee447lVcQWDAXgKjzg5AVXg80XEv8Q0vos?=
 =?iso-8859-1?Q?PKpRrfyOVqZqUmg3Edtn+wmv4jbRZ18Yrw5bHMQLAfgdTBGxEV7kYDhQyR?=
 =?iso-8859-1?Q?LgEj+GvyY1zS6s4bYXxpYA8N/z0zCYSPWTh9Zxd6uUJqfZgrCDm2XjmTMk?=
 =?iso-8859-1?Q?9xoz79Z42rjeqGzI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+Oi9Tb7EfM9drbFUU2MF6zx8pIj1Tu3d8GxHueGrM05DnB25n6FPpAfaIN?=
 =?iso-8859-1?Q?gqK71bGFodqz+9z2YAyJZVPtcEbfwM2fYMpKIA59QodncTf/8LquJOD6e7?=
 =?iso-8859-1?Q?q6KC7lAY2/g6g3BXUQ3o/thFu0jpueUxn3Epv35baInuzk2PRwHCOhS155?=
 =?iso-8859-1?Q?KEs6UBGcx+nSRsABobr6Yl+06v+0S7H1ik1lMPVXrA3ssOl2mkyJOn8kUE?=
 =?iso-8859-1?Q?lWsxlnf3X2REq7Oq5CC8KjX0qqBNcvLYGRewO86D4F5Afyj6oF4cy/mftc?=
 =?iso-8859-1?Q?4GqugzAC8YCm4MVPO3zClyAzzuPxbpUTeUb+gb/c52uCmEmCl84l607MvG?=
 =?iso-8859-1?Q?zLYQj4xPIAOdigqDcRx2/lsYVlKKwV6A7UbvjhpVLv/AZACse0CFS6t6zI?=
 =?iso-8859-1?Q?7GPMO0soqx1Jk5uYpwnaRoI3+MMIp/njg7Vj+Cef4hdUJd8ANDuaUBuxbR?=
 =?iso-8859-1?Q?1i7C/D/91DJOXf+CW73zVv54/MX/qKxn+gIz1EPMe8fTGnCvuJAGiAFSij?=
 =?iso-8859-1?Q?NbUcF7s8JBX5Dn+/bTFA2jl0Ap7YErOrPVllgGYRPS6GyWDpHDCYO6PYxj?=
 =?iso-8859-1?Q?nTI4xNTwhr+GNozSd7k64MwNk+eP2jxbNXmIk1rFfcylCarlnp9qTtsXC+?=
 =?iso-8859-1?Q?bajA8SDDEKAoQJyU8xiPFsUWN7k84vottJ3FKXTYl4dcU8KCAk7JfTgg3G?=
 =?iso-8859-1?Q?F9m2xgz7B4n6MsY5cvoGszutZZzSXNefYpoBj8cD/6/vxzxr72nZxNhqZb?=
 =?iso-8859-1?Q?H2zlssSOkXPYZtFxEAkqTxdPUAWUU4zmYqytsePT9SyuuD3/541Qth2tDf?=
 =?iso-8859-1?Q?i7tABj2SxUhb+V8MfnPr46oBMSzC876Qh0jK5EKRzrvs0YScegCKeljSSJ?=
 =?iso-8859-1?Q?Xr2mIn0/ctab57OwwMyeSCeLHiH7XUxP/X7lBomkAHzZglsKxrJT9S+4MH?=
 =?iso-8859-1?Q?wmauyOFzGBJ9VTF/CaOgs4Bu82YA1PJCu1lXlevOF8JYemzuIuNgNa8btV?=
 =?iso-8859-1?Q?ETQLDEBSeCNYIa6fYMCCzSdqzum/VAB6t0amzgQPiDk0vCXDGsYvIhOHj2?=
 =?iso-8859-1?Q?LyTtFOgVrfhMHwmWN43EVcHlT5wUUg/QMuXDRiBqb4YLicW8pnI1tR2Kfp?=
 =?iso-8859-1?Q?NODSYy6Dm4D2KYWY4xSXd+GLD1jQoULSlSJmrGncq85St7r/bXcG0aHEu+?=
 =?iso-8859-1?Q?jNFQ4yzPrf3kn6k2mxFm7HqpwaTeAXaox0udFFhzteFq1tJPwczjYIyF6k?=
 =?iso-8859-1?Q?kMS/b4qSYoHs61pWfkl+Wy+tJsWwOTQKgD7CbDL3vypse3EA+xsR7hMVdm?=
 =?iso-8859-1?Q?b3qIpMqXOQYcMNSilwNTzhKkroOtFtxRBmjqNypyFYQKBNt2PTWxb7gx7t?=
 =?iso-8859-1?Q?r3E+lMPhQL+THw40KRGcWxs7SZMF/IoOVhYdnFwUCiZXHFX2uZIqnWXKMm?=
 =?iso-8859-1?Q?LigE6B1HJTiozKjR0Hh67BHdDxIsv4/9pTcU3SNMHWTiuNlGPAHaTjyvQ6?=
 =?iso-8859-1?Q?QzmR0mR9O+DnVouOkj55jDYR6MaIO0Mo4paoWkPQBstU5UOLylbwJ1iq0b?=
 =?iso-8859-1?Q?r131r4v5FXVkXG4R4Smu4SFXmDp5xrUsK064U40O22I3OKQUGWh/WKGP1m?=
 =?iso-8859-1?Q?SeJpbkGE1DJfg2RQAkrP9HTHzFHl1BSYla?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7db2e3f4-23cb-497f-03a1-08dd945e5f77
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 09:45:20.8995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 14GvR3yoVcT9ToF/liTN2VRgfmeUoeKvvmHcMkw4bzvyktxfS2qFgc3tv4r3JIZ6WPaJWd4whnnQpu6q26UhVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF1DFB73954
X-OriginatorOrg: intel.com

On Fri, May 16, 2025 at 09:35:37AM +0800, Huang, Kai wrote:
> On Tue, 2025-05-13 at 20:10 +0000, Edgecombe, Rick P wrote:
> > > @@ -3265,7 +3263,7 @@ int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> > >   	if (unlikely(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE))
> > >   		return PG_LEVEL_4K;
> > >   
> > > -	return PG_LEVEL_4K;
> > > +	return PG_LEVEL_2M;
> > 
> > Maybe combine this with patch 4, or split them into sensible categories.
> 
> How about merge with patch 12
> 
>   [RFC PATCH 12/21] KVM: TDX: Determine max mapping level according to vCPU's 
>   ACCEPT level
> 
> instead?
> 
> Per patch 12, the fault due to TDH.MEM.PAGE.ACCPT contains fault level info, so
> KVM should just return that.  But seems we are still returning PG_LEVEL_2M if no
> such info is provided (IIUC):
Yes, if without such info (tdx->violation_request_level), we always return
PG_LEVEL_2M.


> int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, 
> 				       gfn_t gfn)
>  {
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
>  	if (unlikely(to_kvm_tdx(vcpu->kvm)->state != TD_STATE_RUNNABLE))
>  		return PG_LEVEL_4K;
>  
> +	if (gfn >= tdx->violation_gfn_start && gfn < tdx->violation_gfn_end)
> +		return tdx->violation_request_level;
> +
>  	return PG_LEVEL_2M;
>  }
> 
> So why not returning PT_LEVEL_4K at the end?
>
> I am asking because below text mentioned in the coverletter:
> 
>     A rare case that could lead to splitting in the fault path is when a TD
>     is configured to receive #VE and accesses memory before the ACCEPT
>     operation. By the time a vCPU accesses a private GFN, due to the lack
>     of any guest preferred level, KVM could create a mapping at 2MB level.
>     If the TD then only performs the ACCEPT operation at 4KB level,
>     splitting in the fault path will be triggered. However, this is not
>     regarded as a typical use case, as usually TD always accepts pages in
>     the order from 1GB->2MB->4KB. The worst outcome to ignore the resulting
>     splitting request is an endless EPT violation. This would not happen
>     for a Linux guest, which does not expect any #VE.
> 
> Changing to return PT_LEVEL_4K should avoid this problem.  It doesn't hurt
For TDs expect #VE, guests access private memory before accept it.
In that case, upon KVM receives EPT violation, there's no expected level from
the TDX module. Returning PT_LEVEL_4K at the end basically disables huge pages
for those TDs.

Besides, according to Kirill [1], the order from 1GB->2MB->4KB is only the case
for linux guests.

[1] https://lore.kernel.org/all/6vdj4mfxlyvypn743klxq5twda66tkugwzljdt275rug2gmwwl@zdziylxpre6y/#t

> normal cases either, since guest will always do ACCEPT (which contains the
> accepting level) before accessing the memory.

