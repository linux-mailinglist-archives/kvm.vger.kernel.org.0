Return-Path: <kvm+bounces-57193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 321A2B51552
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 13:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3676A1C835DA
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4272D27B338;
	Wed, 10 Sep 2025 11:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U4envZ2n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD3327A919;
	Wed, 10 Sep 2025 11:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757503113; cv=fail; b=nkC7INRt/YWp7DPWfZCrvacSkybF1v3SOdEotuAMz+LVCTxpDk0mVmA2dvlOMVZjx6ZGNjD2NqlgtsquFQkykbhmtJPw3E0ggehsiLMYlvx/2tsQJ+cpBPu4BIyGKvVU+3b15zmZm2wIYWaLwThSMI+A7r3RwhSAkBI0u7NuO0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757503113; c=relaxed/simple;
	bh=njYKX3GUJ7PQKjbm599cuvXylchqB1LVqUvDtxscZYI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NUM823wSatv8pAuYiaPVazpkihheAQcCpObfLWMDPe51N43AcbasotKKOtmGCJPlXGkGZ6d3D7HB8Wb+XCDztbqhAsv9WTDb7yiHPjVuTceCY5e95SWj9c+Z47BhUGNP2N22VFv6PQ9Nxjoqyc999FzUV1oBBzvtxWz9VZnbmz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U4envZ2n; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757503112; x=1789039112;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=njYKX3GUJ7PQKjbm599cuvXylchqB1LVqUvDtxscZYI=;
  b=U4envZ2nCF61OIN4XRVCBqVxb3CYm2nohilaB5LQapODtsdlA4cNimjG
   uqpDIgGykaTJO3539J8rVRZFvggBf4SuUq3f80Vo003hrB2E1JVWGWVZL
   tbKiIkvm23N2ETZlnxLoRs8Mw9yc1MUqiVRKTx3a+rARoVkI6X6TymOED
   RPJLf7wy1lDVIimBp8rsqSAQE3iiZKFcoKHq9zmXLS8fDw516eDBAPXFb
   vfZkNUtz8TR8twE8xBARiAqiCBjhtCXH7/7KsrtTBRBNmdRxUzFGP2zCF
   XoBxGVy+6V4c75YonaEwg0i4SsccVWD9rBXdROASvZMWIW+o/oGT2y7J+
   w==;
X-CSE-ConnectionGUID: Dtgbx9ORQZKUz3VmNlc+Gg==
X-CSE-MsgGUID: CZ/pc+bWTuCWA3zFbrlGEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="59951419"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="59951419"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 04:18:31 -0700
X-CSE-ConnectionGUID: e03QvXpxSiSybgaVkDxaFA==
X-CSE-MsgGUID: Y5VKafgGQHOsrZqkzKRCag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="204352333"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 04:18:30 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 04:18:29 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 04:18:29 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.53)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 04:18:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QM6cYM41TkOF+NQQsNq6DLH2B0yQmjPPZGnTeL0aGbqK6il2L2yM9p97O4FpZV8jMs4juu064PIk+zhe/64vOhPi93YGrJXvL9yiIp/bXvasN2tT0DIW9CDh3CGhi72St9yqW+JYnkzXyXUZNmQ1ONi7XX+6BLtzBdfREDEpOMtC+jThPSLqZZ+kwsoteoxaC1YWXC/zWRyMJ+u7wRXv7KciFi9UH3dDyTAAntW7VnqGAuEb7c/UvDosSUQlKo9AXVmGcNs+Q7wm4TP1MIsRdReFMyagXl9LtVgrGQRgEy/dugR0wn0gwgnBJFs6UaXJOVVWphH1vyub2U2fxkI4Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MW8TuZzFZCByNIap66l9t/axblYPefvlAUBF5zCaG8k=;
 b=RRKZO7FbjhwaXmGf0K3fMAmuJF3+aPUvPbMs9mLmbbR40DDrS0GSCYVpKdP8qPa1lxj9sFyhr36BEuto/QFgk/bmJ37c0jCplEsZTTaNMbwk9kuEja+/Qg0uQRbskXJ/cBDllruRMIHXkP10ibDWtxW6OBVVI0MO3a1SYPaWUZFpb7PK222pZN5uoNaOFPbgBlRprFR99VyZYe2vy9UZMIXKb8Tl0HKE0dWrZ7HUzJoQ/rHEga1ceWqa4KhywMcmUmnWORxg8+Jf+OrTFjQkvZCb/AyOWPOgt4FaS3HWDsoNS8IFUc5MrWwg5S7IGmwklCJmJRzeEuYJc94F51gdQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN6PR11MB8194.namprd11.prod.outlook.com (2603:10b6:208:477::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 11:18:28 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 11:18:28 +0000
Date: Wed, 10 Sep 2025 19:18:15 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <acme@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<john.allen@amd.com>, <mingo@kernel.org>, <mingo@redhat.com>,
	<minipli@grsecurity.net>, <mlevitsk@redhat.com>, <namhyung@kernel.org>,
	<pbonzini@redhat.com>, <prsampat@amd.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <shuah@kernel.org>, <tglx@linutronix.de>,
	<weijiang.yang@intel.com>, <x86@kernel.org>, <xin@zytor.com>
Subject: Re: [PATCH v14 06/22] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
Message-ID: <aMFedyAqac+S38P2@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-7-chao.gao@intel.com>
 <be3459db-d972-4d46-a48a-2fab1cde7faa@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <be3459db-d972-4d46-a48a-2fab1cde7faa@intel.com>
X-ClientProxiedBy: SG2PR02CA0115.apcprd02.prod.outlook.com
 (2603:1096:4:92::31) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN6PR11MB8194:EE_
X-MS-Office365-Filtering-Correlation-Id: 7425a4de-716d-4209-590e-08ddf05bc40f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?IM/pNHprtwa2pO6JwePYsgqnAfK/oyc9XYMmwOG4mZ8/Q+tbq6gGHPEKwusr?=
 =?us-ascii?Q?yFEGXIbfdR/MWU+au/mil2njFXazGSQB7PKFiWkrbo/+35y4r0A0BIVu3QeE?=
 =?us-ascii?Q?59L5Z/YDouBEEIZQ+09CvSkvdXhGXsfPB2oo1Tco7rooLT6oruG/lXydTfX/?=
 =?us-ascii?Q?DxkFF4BbGPyNCxwKCY08kV3yYKwhad+whmsqGmsIRTwqKeneTjQBU8IucngF?=
 =?us-ascii?Q?T0V4axCC4b8JENlnq2PDnRdlYYPw54vHuHzb8uy5IC6aF3fket+fWWS3TDDo?=
 =?us-ascii?Q?+MF8glKfuDoKBw402fJyQLV2imZioBec6TfSXxl1hEUurKgQXq+4MOqHSwRR?=
 =?us-ascii?Q?/YxC0bPVScrfjWFiMvpMw79ozfqvDV4h8l4cbd1Bm4cIPCunWyP5UCe1uht7?=
 =?us-ascii?Q?8pbjFbs5Gl4A+7MVvt2TDfMHCWjofeYxZmgRh16JxwYGbBN6T/sgiPZaQBAg?=
 =?us-ascii?Q?3BHlNbKQDYLAc8SbkIAYjKFH9utr2SOqUMHYaAwmZNyFdzSy9wr+G/bYsAHJ?=
 =?us-ascii?Q?AFbjo9CImLtl4+3bkIrkx83hHKWGNE2YhdlPMToXZH4S/hPwU14SbtIQKEyi?=
 =?us-ascii?Q?HkrQJU5ZGYIVaafX3AiPfR1Yfs85i/5+flxAYSc1n7lRWgKJNA1XMidS8SsI?=
 =?us-ascii?Q?2XiDzZyuv0SW/K6GlM8vlC7Hm6Trtxl1q+be2TppnOrue6Hy/r1oDZo895YP?=
 =?us-ascii?Q?+gBtNvgzUceCYhejlPE3Pba/E8IK3VAtdE2Essy/vLhwtbsPuxqC5zcueTFn?=
 =?us-ascii?Q?GVWA+6ZlS4B/t0iFrZCOd8raT9iYZFGFAfcy2Ug23YeUsAzF3Q5CmynE2o3v?=
 =?us-ascii?Q?mw5/6686EJ5Ic8pzOYYy8QNa1pPLno0Vmo92fpE2WgoylSVuALqZOBMO6w7J?=
 =?us-ascii?Q?ciAKLcLPAIY1Fbo6VnInPogfP8b91tZIX4u0yBWqOvjt+YtlR8m3auKQ6qG5?=
 =?us-ascii?Q?lC/272Vw9pe7u0HnHMRfJp66gn2hv1q/U4PxA87wXu8SbAo0Gb52uCBWWfrO?=
 =?us-ascii?Q?NJdV9XMHIKxrUc2Sg+0aOaw0ph9NGk0bGzkj9B8JxerZtA2WFEt7XieVraiT?=
 =?us-ascii?Q?hrC0HIbn54dsLPlFkGc0OiEToLOK5CUeG27RdreGRhAN3Z7OIt3XIjv3224W?=
 =?us-ascii?Q?Ay2SE4RWkREp9VQLJFZeYh2oSntLtbfwbNay4azTn11aI0GeD1IEVCy7pA/O?=
 =?us-ascii?Q?SuKFu1fi3IV8tKgrXgSUu9AtatgacQHSkY+WdVXuVl8tTFlRHUj3seA5S0/4?=
 =?us-ascii?Q?0Y8Qd3JN4ehUh0C97CKT7kBzPRe4HOTBDSzQxxk7AIjtG775z2ZtG2PXqH5U?=
 =?us-ascii?Q?duGmIMp9UVk+tkcM/5IgwrZ5lpEpmKfYSkI6X9ENsMxAhnmegegKqJ0NIHXd?=
 =?us-ascii?Q?GJ1blY+4Ei4qLRa2KOJ3ThZFDrf1wSIJnPNuGwIj0r0ski2i5MB7MGJi0nDt?=
 =?us-ascii?Q?tgedMgZ99t8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PoEJK9esNO63ihU4rrv9kIj4DaZOVWg6uox/Il6OVfzPUhMW7tOfy+T90shq?=
 =?us-ascii?Q?Xb/mDcDkK1EeQvkYspbF3FXHV08h6wCUT9ESZ0T27YwoulvwksGXVbJqyvL7?=
 =?us-ascii?Q?Ioq5GDVVojc2mneNwMCIOn3QCDuEQSXSXRFpg03KlIgXgNgqrGKR0rq/WZ4H?=
 =?us-ascii?Q?asxYTSBJRuhgOWbyJFRdBra3D7HkWwPUWavXNV/qvm6HH2jf6eoN95xwmVTM?=
 =?us-ascii?Q?XK3hEx8bf27yoGWKsLJF8rtrtSNZyCeZjld0tUNQstE5g6qVnAH7hcEusapm?=
 =?us-ascii?Q?vI5s3ghjN1Q6T2omQqUY3UzfhWRW3BbUyQCnVdE6sNkajceFn9U5QRrePQ2q?=
 =?us-ascii?Q?S1PpOKprwP3M4+yn+8z96wI4et5LJ49ISeFHyl8kjZm9XfmBJPQxSlYiIbrF?=
 =?us-ascii?Q?tLHtLf9BPyN2SAuFCSqEjzTZifs+oxW1TW8AaNYu3AOc+qfrhVaVzZUyE2qM?=
 =?us-ascii?Q?k6OYqCWWPDqABLt5jPNB2u4c9aO0L/Ftxl8SWw3MXPH2IE5RWER8AKqTTB+o?=
 =?us-ascii?Q?bMkZ8IXOKcn5SbIHs4PSHO/6OYDFZ3nbsxKQzwNqKkcwqOWDuTNaLwWJyntT?=
 =?us-ascii?Q?Q0AO7XvRmYEP5ZWDIBt6q8+SMx3HfblAiXQolJQvKIWKRYtGOqOzt5mgmfSc?=
 =?us-ascii?Q?9mOuWuyBVuVF2l4MjKkIo6nIJreHnkv0NhUl2LqyT4An6ElltVi9FPDROrV4?=
 =?us-ascii?Q?XMSm5GWtdky8tA4MlU/ajoji2kOhVRtVFKle5JdLAy6oMnc+xkOxpu5AVynw?=
 =?us-ascii?Q?XBMLnAl2bXxTr4v+AwsAzOvG/hqCoVr5Zo2Eo5XdztiRHUaTJ7BtUw1flepV?=
 =?us-ascii?Q?U0iy3b6EX3qVJ3xfMzBZqiO93ZYRhrMKuPHe//YU6WbERjBhV7WP8Lnzsz2g?=
 =?us-ascii?Q?hfW6cVnY+n+nViOV++LqYb8WzAmo+VzSXxe43jwcq4WagiWjZW88AnslguY1?=
 =?us-ascii?Q?tB2D2K7fdY39Fb5LuwbhUsKkVb7jeP9hmf3hPbl4xmwtUbqRfIDTqMEVHYFb?=
 =?us-ascii?Q?Kz9znsil4NWdC1zcgYptpkayEmjfBbcDcjao7cg/Cf0ZxpxVDda3/zrkAWXk?=
 =?us-ascii?Q?9LtloHD5kp98EhaLMx88hadW8blwi/KSviqPcfnKSXNfA8p3Q2H7s1f2M8BM?=
 =?us-ascii?Q?gCmWCGu/Jr0lWN7fhtHnHAaeY+Bi6fNQ9nks3iUSjBq5cFSKrszqdf8lD1m4?=
 =?us-ascii?Q?4L9Ez/c7tMfwtswHa1AmXUAlRvt6VSSuWxt0SnjO4jGmlhA+RvsXdsPyK0F5?=
 =?us-ascii?Q?nK2Rw5MixndAvWQ0KFO0ObIuEBh33wNpuGFAD/X6Xmb0gajN67nd5Jdnli/E?=
 =?us-ascii?Q?PC/ZIFOBiCT2Cnq6rtMqIpGMPJDD0u1aueoojEPFf93H1qpJiPbDd71/hhFS?=
 =?us-ascii?Q?+AXPVA6WSKY4KYwckAOiZnxyUQZWfpCoiSZuJ5Snt9pFsPHLnLlnOqBPjzaV?=
 =?us-ascii?Q?SnR0oS4whSvhKnqofnEEZ4yReGAgrEA1dTq5NquZgbRKj7fH7FvwCD9ISRE4?=
 =?us-ascii?Q?tmNw387k7qsTq2RTe95h5s+ykY9PxEtvqbOrdJve5RqPdOviUN6jJ0B6lqp8?=
 =?us-ascii?Q?+DNp1b1KyDU68lBMGBRXYuMOarD6Z+bJsuny6aLb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7425a4de-716d-4209-590e-08ddf05bc40f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 11:18:27.9975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MmjKfPSj6Kfw8xQaDK0/+bMQYrTW7nBL9Y9tt33ira4szyEnOmpcplurfEgAIYeRnV16aJB05AoD07Wxms71g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8194
X-OriginatorOrg: intel.com

On Wed, Sep 10, 2025 at 05:37:50PM +0800, Xiaoyao Li wrote:
>On 9/9/2025 5:39 PM, Chao Gao wrote:
>> From: Sean Christopherson <seanjc@google.com>
>> 
>> Load the guest's FPU state if userspace is accessing MSRs whose values
>> are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
>> to facilitate access to such kind of MSRs.
>> 
>> If MSRs supported in kvm_caps.supported_xss are passed through to guest,
>> the guest MSRs are swapped with host's before vCPU exits to userspace and
>> after it reenters kernel before next VM-entry.
>> 
>> Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
>> explicitly check @vcpu is non-null before attempting to load guest state.
>> The XSAVE-managed MSRs cannot be retrieved via the device ioctl() without
>> loading guest FPU state (which doesn't exist).
>> 
>> Note that guest_cpuid_has() is not queried as host userspace is allowed to
>> access MSRs that have not been exposed to the guest, e.g. it might do
>> KVM_SET_MSRS prior to KVM_SET_CPUID2.

...

>> +	bool fpu_loaded = false;
>>   	int i;
>> -	for (i = 0; i < msrs->nmsrs; ++i)
>> +	for (i = 0; i < msrs->nmsrs; ++i) {
>> +		/*
>> +		 * If userspace is accessing one or more XSTATE-managed MSRs,
>> +		 * temporarily load the guest's FPU state so that the guest's
>> +		 * MSR value(s) is resident in hardware, i.e. so that KVM can
>> +		 * get/set the MSR via RDMSR/WRMSR.
>> +		 */
>> +		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
>
>why not check vcpu->arch.guest_supported_xss?

Looks like Sean anticipated someone would ask this question.

