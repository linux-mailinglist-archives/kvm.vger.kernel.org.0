Return-Path: <kvm+bounces-56818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 633D8B43799
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 11:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E24C3AA929
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 09:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D9D92F8BCA;
	Thu,  4 Sep 2025 09:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M372VVRq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF88A2E11B8;
	Thu,  4 Sep 2025 09:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756979514; cv=fail; b=TZeDW/jDZox6szasToN4vnClP30AQ97o5tQlpXbqhEETOvb9E90QJPijV8ldCOczOCE2jjb7nYsOdV3yNg/UI89mbjUVU3smUtxpBtODPyXn+FhVNnDvhsMNgWlp0eKn60inLgpNWgfU2y6GRWbMvP0yDtC9Zx5dOxJ3RzE2+DY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756979514; c=relaxed/simple;
	bh=UlaJKb/5yZTV7Aw64dH0mewvppGxQx3aKuyHVbWIajk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IGWJk94YBAjmgIHEAIv90gQwyaKB035FVqadI0AuA7GqSxC00TKByl2QzJJ0uvYa6hI6k+QhdNjuXTgec54iSWZj4iAI7e8aMPWL+rXiIZJ5F1rG+acgdQ+4vbEipt57UU9KGuD58bOUTlTPLOYvWqMVTffxv5iwednzlvYggWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M372VVRq; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756979513; x=1788515513;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=UlaJKb/5yZTV7Aw64dH0mewvppGxQx3aKuyHVbWIajk=;
  b=M372VVRqK97bihPMmJ/oWgkrL1Q6ctOV8gKdQ501WrMOZxZgOj2Ip2mG
   zSGE9SSdPWdg371U+PTgG9iuQASEPPWVW31bxd1w+SoefTwohthbYBNBu
   jjn1zYc9NX5UEpDwHI2Q9kSzwX1gWTZH+rbSSk8/QlqIpp6XpMqgTDN7C
   6oVzdIu6baynccx0p1sGILI/qkH7S+jsrja2zqQog6Wew+AoQyD0qDR0L
   1vZMtk7jdpJi5rYrmxK9K0kdEfApqgMJY5vA3DNkb3+uZgfQVB5MmxxaT
   tD8CSOqdW7uYuVFa+GYf6gcpne/+/IbT4CLouSnHfVl3U0k3p9isTRsox
   w==;
X-CSE-ConnectionGUID: 68y2SFKFSPWYMvx/G/mpSQ==
X-CSE-MsgGUID: SHYPg/SHQo+4wEwx5ryeOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="59422525"
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="59422525"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 02:51:52 -0700
X-CSE-ConnectionGUID: +l6u0vkUTBafRwmF+p2WJg==
X-CSE-MsgGUID: 2potk+EbQ2+L6Jn4uxvlgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="177107735"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 02:51:52 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 4 Sep 2025 02:51:51 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 4 Sep 2025 02:51:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.88)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 4 Sep 2025 02:51:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s6xyczqH5UeIvIDKmIM7DpJ3snhMsmIa1zwYp0XPp8gco9gEn+k4723sPIFOKVsZyTDmWWVVFofVvm+FuWVkjK4s7LG4dFyzzApBn06rPJ3DDCK7nluh0pzeXezzBdNH7Pp3owtt6JMqnBpnqq3shDrRzzSOARq07HeVfpve8mlAVAbNtwzLznso3toaKBODNR1bEHgvirk0k14yGHWUsOir3gyga4TYPgWYNDQdBwSqvJezQtwng3krAiOfKxSA81dgIHQ0mDzgeTo9Sso3nVKIXBWTZAmP5DpyjOJENX+qZ8x3UpRbty66vKO2+U11DKdmjHfvoSwCxOrdViv2rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6SQIQqP98lgs+1FHADWfZqFJn+nupFgFPMEXyyBZEE=;
 b=peZDsqE/+KB2S65smL+U9y805Mb79kmhFzMAVemK6qMSUCVwAHQQi7lfj3wrj/1J5MhXwrfZmPX/3HebTa0F7FXYVZk5ybGj13NBXjyi8HQEN2KilUSX//FD+MYUj/TRLphltePd9rd+LEQmrexdPepEf2YP+2eLahp4dzWuE2HPvg4iKPj5501y/LDDSaabeowiC5mMRzB5apERQooQ5MUb0uU9K8qu+RN4d1DaiolZsIGlrh9ddUbUqXIzRUBgk7YvMVdv0gd+81uNbDBfdP0sKlTzNj0VsqMZ6/Uf/WAuToPpXPHIW+gM49F566Vlc4xB37sBn8R02S0A60PbFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7419.namprd11.prod.outlook.com (2603:10b6:806:34d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Thu, 4 Sep
 2025 09:51:47 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9073.026; Thu, 4 Sep 2025
 09:51:47 +0000
Date: Thu, 4 Sep 2025 17:50:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 18/23] x86/virt/tdx: Do not perform cache flushes
 unless CLFLUSH_BEFORE_ALLOC is set
Message-ID: <aLlg+VavGQlnQqFY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094516.4705-1-yan.y.zhao@intel.com>
 <0d3229ff-2359-4ade-a715-c8af56c2916c@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0d3229ff-2359-4ade-a715-c8af56c2916c@linux.intel.com>
X-ClientProxiedBy: SI2PR02CA0040.apcprd02.prod.outlook.com
 (2603:1096:4:196::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7419:EE_
X-MS-Office365-Filtering-Correlation-Id: d08e4240-4fc9-45ac-86b9-08ddeb98a9e7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DLi5xC2eiNcaczxCG7I2sCK7YQecbA4JyuidcUz1W7JrIYuvBK0fR/V6yg82?=
 =?us-ascii?Q?Gb4xdWP7m90k+CmlBHZtEfMKL/ImGwNjveHEI+YFQha8ieugp4vbp+k8o4u4?=
 =?us-ascii?Q?VqKeJScPK18W/Y8mYLq7lqq/dB6oL7zx9d4GnniG4V65yZMc6AqaV97fKYv3?=
 =?us-ascii?Q?i0eiIBex0PADvBKSiihtfFOwWODU28oSisUs6BHwgkWsMGW7KKp/JCbSIcfK?=
 =?us-ascii?Q?pAgDCo2a0aVTi8JN4l73C8YgFnN8casl3MqbCZgLQtc5vWmL+9GGRdKXLUJ7?=
 =?us-ascii?Q?P9MmvqolkYekeXkPjFUKitg/1U7Px0YdmwjGr+1HvD+GWU/o5owRa6VkWYiL?=
 =?us-ascii?Q?akpw7OFp2dGkLMREn0rQjSOZmLZA3poTE2jZQZdavOh9YLFmtg1UTKus7ZX4?=
 =?us-ascii?Q?RvFzDQevf7FDcShPAfNR2NXtOmWCyI/koNji554LwczaBS7sz1jE0lisJukY?=
 =?us-ascii?Q?Ndt9qkH1v6tou9lz19iBH1/83f15bktXr4x7zReRzesrGEAc0UVsgeCy8qgl?=
 =?us-ascii?Q?slbnpi4pB2hcGN7T/2zq/6m1dsQ+1Huc5htTY1a834icwkVTlK/p6KCqhSzb?=
 =?us-ascii?Q?LmS/C3JRyGRJrORmrX0f7Ujtbh+7//ouzvsvb0HkvlDki18SYUt7k2JspBTt?=
 =?us-ascii?Q?6SA/op9oTj+XggFRFyeCP246uMXucX8mnlslvVkeP3SEVcouoXGDEQuSNfon?=
 =?us-ascii?Q?Qd0yUv9A4HjDD5x2oXXmW5aELFNRAegTk3P9eU7uS/agc2liuCxfdxrsN87k?=
 =?us-ascii?Q?wrL0XTgNV1aTvH78WeAG6L0x9ntRZ/+gG57IYMwndKKW6kA3OHdaAU7U4wET?=
 =?us-ascii?Q?zY7GHn3meuPHEYvP243J5dEZTwiFzTMPZhQ1SMeebdMZxLVBjGzijm0Xg8co?=
 =?us-ascii?Q?oAqpL4r//4mE/dnBzOjs5sgnM0/Otx8tkUqIG3aPvF0lI0Y5ZioSU1JUnMBj?=
 =?us-ascii?Q?nfd5Z0TYm3a5IMn5kttFYW3UfP8qxm70HpFWiCw8xMuGuk8JONUN3SZv/b3H?=
 =?us-ascii?Q?+EuLDiT82n0s5aiQ8OQnk9kg/aTrXQARwzDgufYV9mZzF/h+IAQad3bt8B/Q?=
 =?us-ascii?Q?i91RF4yxCV9oO+lIUWB3yHxIhRV0sqWjEgdtUoFzagrvTtY81ONBG8jEE2Jm?=
 =?us-ascii?Q?BaiFbsXQsdVzee1hbQun4iZ2neCibZlKLuYRVAlOwX0CIx/D9JElac15oakx?=
 =?us-ascii?Q?eKOmSsxFz4/PTW2KByov0MuOwf8oc8vZAs21oqg1tjunwDvkGYpar0SDuJNp?=
 =?us-ascii?Q?DQml0r0jTA9corc6BsuO59xO094R17aHilH+iSGHwwWWrlhlFij7B83M04T3?=
 =?us-ascii?Q?3q7JVukq4wjnW7V61XVSScoCJNjhroZhYUh4wUlDmMsxm8wKg2UQ4B/JMNf2?=
 =?us-ascii?Q?EM6xH94=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MsMZUdRWo7QAJ9POqFI2HX5yWIOzetUrvRkLR0YNaiIjhprTC6KnVPXPKm+O?=
 =?us-ascii?Q?aXOR+8Fyz0QGGKqtXOTY9GuJQo9PHr3dtQqNVyK2vPHBJbA8J/75WSsA4Xbw?=
 =?us-ascii?Q?DUJ6VuPrQdHR5eJOjxQVddM2e9WDL9ZWeVOLkOEtm03QQgS2LxuNF5E8I8ZG?=
 =?us-ascii?Q?AmcANvgKeTGq4OMVllm9kOKkHk96Ei2s8KOD/4f87ZGbVMpQ/MO413ewV4h9?=
 =?us-ascii?Q?hYJOaYg65Qmw7elfkLsPCTGlqEMQbvP8Tyba7MI/yhOSuB3vbZ+net2zMhfw?=
 =?us-ascii?Q?6O/tep5I9ybdIjk2xLn7samHXKpHZA11XWFN6a4tp9bqSBMecr1oCSmKmkjp?=
 =?us-ascii?Q?WCEXDWMc+G2i1cVZW34DbqL0Ab8I9VItoKJlDiX8YqOzNleI7uHsRmfUE1nM?=
 =?us-ascii?Q?ns6ZgB+lLC95zhyAJ06kLoRRJ3Cc9u8aQVsrpEWUQxmG+VnLDe+0mVVjiAzR?=
 =?us-ascii?Q?Ln/Eldgkfi5aPaRneGzEUQ2dRwsH731hxeY2vLpzHj5NJqOBcqkJiORBiG31?=
 =?us-ascii?Q?XxJUFCOGnqLFUCMGzsbaDHooAC5CIZDB9C/P1AHFOdyAE2c595GkeXHHcdsz?=
 =?us-ascii?Q?RM6/QCLoIS6Tkfw5V0vcECt+y1266YiA1u1nWkBU0XLG/WT8uLRfEwL1BVdD?=
 =?us-ascii?Q?IaVnwGVrZtLwfF9bP18vu5VtktOLkxr0lMpJw5KKUoptQhL6tuKxa48MXlSa?=
 =?us-ascii?Q?TmvKLeb28+SRRp0EkZJot0dYiDS8uIajJmzC7+whYW3RmDKnHLUOUI+JCRL4?=
 =?us-ascii?Q?Xnnc7tI9K/koaRqH4J4oUcEJ/UrR2Wk3nR6mHgZQM8PgKL+aaKL9OERMyJ9r?=
 =?us-ascii?Q?4yTWvgg/MwiXKrhMPILO64L1PspMGHUy7Nl6E0WelbUjQsndF9FHtycPYExv?=
 =?us-ascii?Q?o8KpfN+ZpeOZWdK6mAQnEVOzAmtlhZfS+ZPvypXISsH2xIWh1C3ZbxQv629Z?=
 =?us-ascii?Q?X1UX0nwryT3j9VcswMes7IHtwUa/LmUc1QdW4LY9vklGQ6Iqz7q2M4/+ENVe?=
 =?us-ascii?Q?Tyatv8brkrrQwAR+IuiLxxyBbZhWv+vOjJvSnYDk7u5UwLpt+xCqcGbe2ARc?=
 =?us-ascii?Q?U3pANiDLWb7qCtCuKTN2sqzuNRs8TLeQ4zYrBF/1izLtvz73TK8KK0+DBRvG?=
 =?us-ascii?Q?c5Mj3cixcrH/7IadF+BexESkrjXK2j1VlalpoIUN5lscIT/nG7K75nf39+oM?=
 =?us-ascii?Q?MmQpOeXFhqCmhaF4GrUiorTwAvau6affq1fZU3+3L+uod2+LOLBDeLryYVQE?=
 =?us-ascii?Q?7ccWgu3APVxX2hUSsB4qVMCfv03FOMOOv5TNMTErgCT8Y2QhMJy48xBhiaUy?=
 =?us-ascii?Q?dnrg/QKDRWsPp7cwNseH6mYu535WfZY0GnBKWAuSF2KaifyIKlFFHVpV126l?=
 =?us-ascii?Q?KLKj46mKj8dx1anWiS2fhHnu7xkgyzmA2oFd2mMTKoaVf4VIMRVeNNDeuydC?=
 =?us-ascii?Q?qzAAPc9pmtiala3Q5nF2VbDryhdJchGWtZEQgb+OEaMlAPJm4m23wU1d1+8+?=
 =?us-ascii?Q?mKGeweK9uBVKR0n25FEIZewfYoqVax8K6AX6/E+jgwZjpKnkKkPNyfLKO449?=
 =?us-ascii?Q?VwT7EEqWj3MzzZJem6q50mBccMgOC952qgkdL4ku?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d08e4240-4fc9-45ac-86b9-08ddeb98a9e7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 09:51:47.6461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5uPCDzSpRMiI3w2brpdU7NL+4nefkzkG+m4UT0UMxXCmm4xOQ1oNtEC/C06n12TiDzFvHfDz1fCyaoiKL/jO9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7419
X-OriginatorOrg: intel.com

On Thu, Sep 04, 2025 at 04:16:27PM +0800, Binbin Wu wrote:
> 
> 
> On 8/7/2025 5:45 PM, Yan Zhao wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > 
> > The TDX module enumerates with a TDX_FEATURES0 bit if an explicit cache
> > flush is necessary when switching KeyID for a page, like before
> > handing the page over to a TD.
> > 
> > Currently, none of the TDX-capable platforms have this bit enabled.
> > 
> > Moreover, cache flushing with TDH.PHYMEM.PAGE.WBINVD fails if
> > Dynamic PAMT is active and the target page is not 4k. The SEAMCALL only
> > supports 4k pages and will fail if there is no PAMT_4K for the HPA.
> > 
> > Avoid performing these cache flushes unless the CLFLUSH_BEFORE_ALLOC bit
> > of TDX_FEATURES0 is set.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> > RFC v2:
> > - Pulled from
> >    git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
> > - Rebased on top of TDX huge page RFC v2 (Yan)
> > ---
> >   arch/x86/include/asm/tdx.h  |  1 +
> >   arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++------
> >   2 files changed, 14 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> > index f1bd74348b34..c058a82d4a97 100644
> > --- a/arch/x86/include/asm/tdx.h
> > +++ b/arch/x86/include/asm/tdx.h
> > @@ -15,6 +15,7 @@
> >   /* Bit definitions of TDX_FEATURES0 metadata field */
> >   #define TDX_FEATURES0_NO_RBP_MOD		BIT_ULL(18)
> > +#define TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC	BIT_ULL(23)
> >   #define TDX_FEATURES0_DYNAMIC_PAMT		BIT_ULL(36)
> >   #ifndef __ASSEMBLER__
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index 9ed585bde062..b7a0ee0f4a50 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -1648,14 +1648,13 @@ static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
> >   	return page_to_phys(td->tdvpr_page);
> >   }
> > -/*
> > - * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
> > - * a CLFLUSH of pages is required before handing them to the TDX module.
> > - * Be conservative and make the code simpler by doing the CLFLUSH
> > - * unconditionally.
> > - */
> >   static void tdx_clflush_page(struct page *page)
> >   {
> > +	u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
> > +
> > +	if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
> 
> According to the cover letter, if TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC is enabled,
> an explicit cache flush is necessary.
> Shouldn't this and below be:
> if (!(tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC))

Right, Sagi also reported it.
https://lore.kernel.org/kvm/CAAhR5DEZZfX0=9QwBrXhC+1fp1Z0w4Xbb3mXcn0OuW+45tsLwA@mail.gmail.com/

> > +		return;
> > +
> >   	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
> >   }
> > @@ -2030,8 +2029,12 @@ EXPORT_SYMBOL_GPL(tdh_phymem_cache_wb);
> >   u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
> >   {
> > +	u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
> >   	struct tdx_module_args args = {};
> > +	if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
> > +		return 0;
> > +
> >   	args.rcx = mk_keyed_paddr(tdx_global_keyid, td->tdr_page);
> >   	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
> > @@ -2041,10 +2044,14 @@ EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
> >   u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct folio *folio,
> >   				unsigned long start_idx, unsigned long npages)
> >   {
> > +	u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
> >   	struct page *start = folio_page(folio, start_idx);
> >   	struct tdx_module_args args = {};
> >   	u64 err;
> > +	if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
> > +		return 0;
> > +
> >   	if (start_idx + npages > folio_nr_pages(folio))
> >   		return TDX_OPERAND_INVALID;
> 

