Return-Path: <kvm+bounces-37771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 221C6A30119
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:50:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D63763A3B5E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 01:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B03D71CD1FD;
	Tue, 11 Feb 2025 01:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I2uZy9kH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3914A1CAA9A;
	Tue, 11 Feb 2025 01:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739238242; cv=fail; b=vAAbAnbxONwFX+I26UsDiZfdWdeqpj7eWG4NLE0gGg8OsE3Hxiw1+X53wUH19Zjn8H61zdJwXYt/T4HEEJ+6iqFN+M9Iu7VcddE6xece9/8VzSkRrz3lN0ZnK6elQhibFGcCMCNDIth0oWjdlpwKeGARKgOQI/CSkISQ2MzZG4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739238242; c=relaxed/simple;
	bh=uRebcNJOhVnPhWO7nP8qJXWnMjOY/Gj/cY4u+V+RbqY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pjYKgtxaOPvLmoZv+pekAwEEj4EjsUXWJBqenZPMrU+LFO6J+dRB4fR9YO0eIzVr4cy0svyxBLE0PKGq5Ijb8CWap0le5fvBOH9s/xXs8clEo+j1i6/9FiP8rwZawYN03bjzTsi+muAs4j7RLfA4zcRwDwNSzMWmTm4zxoHXIr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I2uZy9kH; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739238240; x=1770774240;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uRebcNJOhVnPhWO7nP8qJXWnMjOY/Gj/cY4u+V+RbqY=;
  b=I2uZy9kHsAYtmXMXhcvDQiu9DJ76u+CRKMWzhCNiRB1y9fKOds+t+hjU
   DnmmZbzTnpvqeK2GcPnGb5qiKO7febD37l1JwiAi9nRXzg64Moq6BXDiK
   syPFNP72sVzsLpinFdgoWw9JEVAMXAwFENhy/m/oUW5jTnARAKUu9uRPp
   eg8utwpsMnWP5FepLbrs7fSCs0hYnvxqZ39TU1A4LnSmKvtewjEH/BJAd
   pSqztVJi0isyDIcWfDVq0bjwuTrTVlyRdklv/V5irVEWtwoyz3f0649H6
   /A1RodoN3sVab9apHT1r1QCaWrqOzJIPzbALwisMG91MogkrMPRymCJIP
   A==;
X-CSE-ConnectionGUID: wEyoHCmFS7a0sFABiCYotQ==
X-CSE-MsgGUID: HwFC+mRRSQqX015mWWWAuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="39084093"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="39084093"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 17:43:59 -0800
X-CSE-ConnectionGUID: ukn95/+5TuSRLiiwA93xwg==
X-CSE-MsgGUID: 4uhyu2ZPRFK3QN4XqS+uUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="143264435"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Feb 2025 17:43:59 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 10 Feb 2025 17:43:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 10 Feb 2025 17:43:58 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Feb 2025 17:43:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p2hT7Pqh5qSDrVcwwW075k0wYQsjp8Uyu6i3i564tZoeDR+xM0Xf6epk4lvrd4+AD/f2AbBcS5Peg4CKW1N0ntAemFRNxyOHCqUi8wU1pYvWcppl66xLIEtZ8czItlqyEEbRpDMzt4t5uGNzo2JfLOr06ZqOsYyZrzpSx7+LQKaRlaBOrAOG2tm4jBe4qIqbEG1ziwJ5GQJVotuhJ+qVjv34FnoBw8bmwEwAwe4YFfdpnAOSYGNi0OTrp1tYJuqJeI0cWliJEL57Kq1OFRiy2Y1iBFDz1GE9qFR0PSdXW9TvetN1y+nG1gIYB2jjGx8FZWvo9sH3erl2uofPoxyY3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yINkIO+ckUIQl72DNs/beui51HJF3IJKF6cAONcXbGU=;
 b=vLC9aVXwlQ39zGGvQQ5RgIAM7duclllMQv5JWz3aK6Xmv1ZpKNiAOfG/+MuBO6NiU66ilR3fFG0KPltumtJ3WTfWNJllWgOjuu9Li7ag0o1uWXu6bZ5W+A1RZLJE+rFklnRa+ytHqel8NtMZSe5vWYn1MonTyCb8RBsqCz3JHyvDymt1GkVNs8alJTe/IQzroXrx9uBMuN4RsfJ1OFV3Ut6dK30xEjsHjHI+oqB111xJ/85oPz70ZkxpgL8NjJ/tEF4ESJTcTSs6UU2dNtKmKVvMlBS6/NTGv8iuhmMn6w9ziSkD6c70eCGDsKKmQNqEtqR6K6Bm2W6rzMFkJtJgAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW6PR11MB8437.namprd11.prod.outlook.com (2603:10b6:303:249::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Tue, 11 Feb
 2025 01:43:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 01:43:49 +0000
Date: Tue, 11 Feb 2025 09:42:40 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
Message-ID: <Z6qrEHDviKB2Hf6o@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250208105318.16861-1-yan.y.zhao@intel.com>
 <23ea46d54e423b30fa71503a823c97213a864a98.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <23ea46d54e423b30fa71503a823c97213a864a98.camel@intel.com>
X-ClientProxiedBy: KL1P15301CA0050.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW6PR11MB8437:EE_
X-MS-Office365-Filtering-Correlation-Id: 08ff826f-89e6-49aa-61b7-08dd4a3d87cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5WVTw29ziskga9zhgI6lsYeIiO6JMs9FSlYofuV+b26OrtHhYXtOPBdB4p98?=
 =?us-ascii?Q?yKNt8v+st2kNiPzR+GZidc+GFrKHZPmLnnaboizeX2V1Jat+X4KAzGNYdGMo?=
 =?us-ascii?Q?Lz5m/kmUGBFx6lsJZ0QIpFGAJPTp2kUesrejPkN2TAJL9KAlv+Bz3Ahwjyfx?=
 =?us-ascii?Q?MAEHOirkQftgtxJj31Z6r7qE1voIaivEGldDnpCmfmxjfHt2b9stsQVdXard?=
 =?us-ascii?Q?xpPYT/SvUuHfiw2SBmyDLKDWzvmnAG4BeThzbMrDY8bXoOldJKakmrvTh2k3?=
 =?us-ascii?Q?5oG+QZxhGaMEfMcApAWrJ/5JM9k2GClyX0uTyhVXQNeCQg6YMxsEIRdaEkZT?=
 =?us-ascii?Q?A6DIhEp6WBqNjEA6lmUyNhYWPR7wSmjxvUdptMng0vuW3QBoE9KyYIZd8Rew?=
 =?us-ascii?Q?1YWk5QmyqDLrEfteMTcLzB4+XrTa5h0BV/B19UGL8OcZlJec5S0vlkyJ/EgZ?=
 =?us-ascii?Q?eibLUzPDEeZvK4WQn4NaAbS/SLJGc/oD48as2J/42ZQsnf2+g38MTKuy/YdK?=
 =?us-ascii?Q?P4WJLYb3f/8itO6eS3Qm+dgpRL9OTzz3Ds6r96DgZwR8nzFTsKnkb1q3GWRh?=
 =?us-ascii?Q?pBy/F9NH0m0LWVSuOaS95cwHfgbwJamnWSaEZieuP3i+ZzRXfJ5iygk5WuB1?=
 =?us-ascii?Q?WK+z4fslS0kmKWiCPIGHS/XqKbVSLMWobNaa7MKZHgLvQOUf//02ZEY+et4Q?=
 =?us-ascii?Q?r9w3FVEr3wO/BZ1Z6T2Q9k13UrCTOYIKrth3umW+4/kpYEuAbKCbKmPeC6pR?=
 =?us-ascii?Q?ApTuzWKS9v5if19dDgCIhWhjGpBxnKMt0pd56KojcvX8NIy10fcBQWKA6COn?=
 =?us-ascii?Q?wtcqWeeW62iKi/N7CPPkvRPLU3MHbfh/HxFImtVhiRcVEgfpJBIKND+bPN8q?=
 =?us-ascii?Q?FHe7kTf7F5Cw8aIQlSwEAZyMJEfFlRTmrRgXYA3TzcAbofLhfKset0zzGY+n?=
 =?us-ascii?Q?fss9bdAQyFns5NaVfX3yihPTM+390zlmxujAvqUmj6zcm1b1HzpDKYYAy31O?=
 =?us-ascii?Q?QLRsyk8dr5sULlTw5wO+aossPPbZ1bwUsE2Az8CU863nkTJsy4yTdJNrs+p9?=
 =?us-ascii?Q?S97JCKuwmInKZBr7IIMM18oXoyn8pc9X/ejxNUzp8Xz1/e0RDgbPHjkEEUUM?=
 =?us-ascii?Q?omb6vjAdznJdeW2bk1uDzx+uJo3tw2b3Dw940IhJd1MTEUs259HpWkyFcHRZ?=
 =?us-ascii?Q?YzQszBeELPoQWw3Wyelz5GsrEo99FIUTFrg166Sc5xt4UCV0BjIwFf3FaKsd?=
 =?us-ascii?Q?m1b5rigsY5gcAyKXku7eUZUYZCnxsMcdS8xkjoMWU1lkxj/NEkSNvCZzlbOH?=
 =?us-ascii?Q?xbQhax4HUJUBml6ItOwK0c0UUAv5JmP7hfqemSaOLzmPJPaHalTLUxZxijda?=
 =?us-ascii?Q?7519L0V5yJw6o8+eSSHyYsZq+86l?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T0x7NtG58nnCwrYWdWhiAsoc5PvMbhG9rFM7YSdMBSoTlkeIZRAPuhJXTwPN?=
 =?us-ascii?Q?hGCm2sONf3v1BFvdaRrdt57xiKqoqvzfGj3n/BZZiISAvk8SiRseEyYSgimA?=
 =?us-ascii?Q?k3YegeR3Vc6Q2SRSdj0mfdlVfJNDRYTS2Dx0HWi+JMkyjK0T5GM7pjFTBFJP?=
 =?us-ascii?Q?/sJMuu0ph9DNSsxG6SrjFWAgjzmhrHzcWofjui4PAf/d95sl0XJ4C+uphKwQ?=
 =?us-ascii?Q?7i2agEeI9VqqjVaSPLspBiV2mndOhF/I9IrZIxzLX+1EaEXBrqNnICTe8iTP?=
 =?us-ascii?Q?N3Tm+x9LiY1Ilkk/3ec80Pxih2u0b9ZskDtOqCS2SSMo8cqjS0pblPL1Dlh0?=
 =?us-ascii?Q?34Z9Dsd0ui1+vicRZ5cVMRift9chVdtzje79hD+YOAeEHtQPTG4N79UWeK0z?=
 =?us-ascii?Q?Theor3jIy+6fbG9QhSnW7BpLNNe6o8fQrFxLi+O3OYpgQzn2iyRsVQ+G4Vpd?=
 =?us-ascii?Q?55ppwZEfxohcGHFI+OAiruxynLZ8xO19rvKsXxSle+eclgUt6HXu0CvtCTDk?=
 =?us-ascii?Q?yRIOmIFOeo+1E0KjAiMALKtJCy6NaqCdnbE5d0KK2dRU7vbpkveW6FmODdLQ?=
 =?us-ascii?Q?xUG+XF2HcoLPyPM7jTx+/8F+8awH8ZT1s0UAyYDJmTcnI13gxA8rQkHeXF7S?=
 =?us-ascii?Q?9C1T5TmZmqNvxwuKjF6vki+bROmE8IPHWUcyAn4XmaHBo1d23aMQ+5xF9z1k?=
 =?us-ascii?Q?/3ZLLvXT2pX1Oli0sTCRvgedon33XIDGjw9S1KAX2l/usujypjdi2FBsmRRr?=
 =?us-ascii?Q?Pzrrl1fFByMOs1bsszmmzUWxQPCVJPLsrIhnJrRD7CH6DCpdsVW7/O2ime0/?=
 =?us-ascii?Q?uCMvoaa7ksHJK3oU6QuRXsT5pBRIiw+xZr3F2GD+2CPdQhuNVjAr66LjKnk7?=
 =?us-ascii?Q?KOFtym2URwPYcY6a9DRovpYNiXEbOgjUuSYs2GKzuwmxskW0LghS2adDEs6C?=
 =?us-ascii?Q?Cf6f4Do/P+vh3mdZDIUV1FI02pbFjtY0E1fOXObk9jzIs8fY+pUHvA/tKEWC?=
 =?us-ascii?Q?3/VKUvb7w+0+fvI8raX65pGM1pk+WuDF80SxnPSli6FBvP1JXR03RheBH5RU?=
 =?us-ascii?Q?XQRjwRSruyy/q3p3/d6MpuNUBZb3yLXEj2o3tvGbcusq/JuODwioGj4+wWLc?=
 =?us-ascii?Q?s7gA+Jt5PxzzJQUtCuiir0zi1kXW4U7bi5W9TlJbyswUCvlJBx/A+s33PKfR?=
 =?us-ascii?Q?r0rUU8W1v40doohK/K/EIFZZwq69d8zqvxszgdHB2V+t4wzJw7ZgdFcsCRd9?=
 =?us-ascii?Q?SPQa19p3a8nEIbOx2VPN4VsItkvXqcw9qbDn3rOyD0ToQl+GzvyWCv5Q3bPq?=
 =?us-ascii?Q?kyMUR+oqVe7OAH6FpOxc+PSBjDr1y36058LbMPVTmWRm2L4KztfbLJXOfo0R?=
 =?us-ascii?Q?VDBU4YP9FsicVbI7ZQe6aeHXB3pPNOFS82oYEqnIHlFtQYw/201fzWk0SwUS?=
 =?us-ascii?Q?x4PovTm3DEj1dLrHmlSw31dHjkP6tqtyyZxs8CxI3LcKWO602kfi/8C9gis+?=
 =?us-ascii?Q?RtQppbEL8Dq5pwpOnp1Ewu2UD+xdPAjycVF6uzyf4Vdi3VtCMh79twXft1sc?=
 =?us-ascii?Q?dOApIEp+G8q/LP+jaZwPZ2izdp+cQM7tuQaagpH7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ff826f-89e6-49aa-61b7-08dd4a3d87cc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 01:43:49.1620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWIf2L37LGPzzf/dU7iLdDT7+4j5g/vnMlHNA8JZ89zKN1oRySNFZaB0X3W1eEarHtGGnVGhZ8q3uP//BH46JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8437
X-OriginatorOrg: intel.com

On Tue, Feb 11, 2025 at 09:03:08AM +0800, Edgecombe, Rick P wrote:
> On Sat, 2025-02-08 at 18:53 +0800, Yan Zhao wrote:
> > In the read-only mprotect() phase of mmu_stress_test, ensure that
> > mprotect(PROT_READ) has completed before the guest starts writing to the
> > read-only mprotect() memory.
> 
> Is this a fix for the intermittent failure we saw on the v6.13-rc3 based kvm
> branch? Funnily, I can't seem to reproduce it anymore, with or without this fix.
Hmm, it can be reproduced in my SPR (non TDX) almost every time.
It depends on the timing when mprotect(PROT_READ) is completed done.

Attached the detailed error log in my machine at the bottom.
 
> On the fix though, doesn't this remove the coverage of writing to a region that
> is in the process of being made RO? I'm thinking about warnings, etc that may
> trigger intermittently based on bugs with a race component. I don't know if we
> could fix the test and still leave the write while the "mprotect(PROT_READ) is
> underway". It seems to be deliberate.
Write before "mprotect(PROT_READ)" has been tested in stage 0.
Not sure it's deliberate to test write in the process of being made RO.
If it is, maybe we could make the fix by writing to RO memory a second time
after mprotect_ro_done is true:

--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -47,17 +47,18 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
         * is low in this case).  For x86, hand-code the exact opcode so that
         * there is no room for variability in the generated instruction.
         */
-       do {
-               for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
+       for (i = 0; i < 2; i++) {
+               do {
+                       for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
 #ifdef __x86_64__
-                       asm volatile(".byte 0x48,0x89,0x00" :: "a"(gpa) : "memory"); /* mov %rax, (%rax) */
+                               asm volatile(".byte 0x48,0x89,0x00" :: "a"(gpa) : "memory"); /* mov %rax, (%rax) */
 #elif defined(__aarch64__)
                        asm volatile("str %0, [%0]" :: "r" (gpa) : "memory");
 #else
                        vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
 #endif
-       } while (!READ_ONCE(mprotect_ro_done));
-
+               } while (!READ_ONCE(mprotect_ro_done));
+       }
        /*
         * Only architectures that write the entire range can explicitly sync,
         * as other architectures will be stuck on the write fault.


Orig error log:
[root@984fee00a151 kvm]# ./mmu_stress_test
Random seed: 0x6b8b4567
Running with 128gb of guest memory and 168 vCPUs
Waiting for vCPUs to finish spawning...
All vCPUs finished spawning, releasing...
Waiting for vCPUs to finish run 1...
All vCPUs finished run 1, releasing...
Waiting for vCPUs to finish reset...
All vCPUs finished reset, releasing...
Waiting for vCPUs to finish run 2...
All vCPUs finished run 2, releasing...
Waiting for vCPUs to finish mprotect RO...
168 vCPUs haven't rendezvoused...==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441760 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441782 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441876 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441825 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441905 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441780 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441888 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441834 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441832 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441880 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441792 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441787 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441804 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441784 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441781 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441868 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441902 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441806 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441842 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441844 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441848 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441860 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441766 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441786 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441794 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441763 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441850 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441772 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441818 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441877 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441846 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441768 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441754 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441757 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441800 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441833 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441758 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441841 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441853 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441909 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441862 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441771 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441883 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441799 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441847 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441855 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441793 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441755 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441797 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441805 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441835 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441861 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441863 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441815 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441893 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441776 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441871 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441864 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441899 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441845 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441778 errno=4 - Interrupted system call
==== Test Assertion Failure ====
  lib/x86/processor.c:582: Unconditional guest failure
  pid=441740 tid=441897 errno=4 - Interrupted system call
168 vCPUs haven't rendezvoused...     1 0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
168 vCPUs haven't rendezvoused...    Unhandled exception '0xe' at guest RIP '0x402638'Unhandled exception '0xe' at guest RIP '0x402638'     1   0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
168 vCPUs haven't rendezvoused...     1 0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
  Unhandled exception '0xe' at guest RIP '0x402638'
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     1  0x000000000040fd01: assert_on_unhandled_exception at processor.c:625
addr2line: '/proc/441740/exe': No such file
     2  0x000000000040552d: _vcpu_run at kvm_util.c:1652
     3  0x0000000000402a10: vcpu_worker at mmu_stress_test.c:168
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     1  0x000000000040fd01: ?? ??:0
     2  0x000000000040552d: ?? ??:0
     3  0x0000000000402a10: ?? ??:0
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     1  0x000000000040fd01: ?? ??:0
     2  0x000000000040552d: ?? ??:0
     3  0x0000000000402a10: ?? ??:0
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     1  0x000000000040fd01: ?? ??:0
     2  0x000000000040552d: ?? ??:0
     3  0x0000000000402a10: ?? ??:0
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     1  0x000000000040fd01: ?? ??:0
     2  0x000000000040552d: ?? ??:0
     3  0x0000000000402a10: ?? ??:0
     4  0x00007f67fec08179: ?? ??:0
     5  0x00007f67fe8fcdc2: ?? ??:0
     1  0x000000000040fd01: ?? ??:0
     2  0x000000000040552d: ?? ??:0
     3  0x0000000000402a10: ?? ??:0
     4  0x00007f67fec08179: ?? ??:0



