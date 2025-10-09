Return-Path: <kvm+bounces-59684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 494D5BC771D
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 07:37:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94E323B8F78
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 05:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB71261B76;
	Thu,  9 Oct 2025 05:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e2LwdlQP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496F754279;
	Thu,  9 Oct 2025 05:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759988219; cv=fail; b=PYVa29wLe37iJm/m9Sn6HmSQfAcZm2lnA4DJNkj+T8jLRLU/0OyzuHHEGDo+OVNyTzuYpba/7YnEgVvEfRoos2BujsZP/s7608NA4T34Xoit4kfFaJ/17NPsXcKKxEsr4q6mfs/ysS8+FCedR+2h6+rHz333HIJibjC54fZ5AT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759988219; c=relaxed/simple;
	bh=ZrD+vOuv8dbaqJHYt2AwJ9k1RxgvkuUs1fJX5OY0IuE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PU2BXC/bqAzzGkNDpY8EXV/gcmkdQd1Q79nRXuYQFqM0f5S5SQNjs+ogkMZj22NDgT42jw6ZKJPWKq4ndfZuZ9MQ4lJM/i8qSd04RHWC/2S4tqZo2c5QBArOOuIrJh+uDFAWNufeXRenbfKH7nSuZX7e6xN/368yVgKFS7KN2c8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e2LwdlQP; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759988217; x=1791524217;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZrD+vOuv8dbaqJHYt2AwJ9k1RxgvkuUs1fJX5OY0IuE=;
  b=e2LwdlQPzjVf6nAYXPU8QASSURZx39SCLZN5peQUDw7jMMNLLQI2+YDW
   u4aQ3pIPPl4sHDbD4gjR0UGxjMjZ+RNWRKGBI1HleBgmXnFoiLiGZSgoj
   PkXU9uTuMObgZqCXKL22hn7lURk8lMYijTt6BRCa5l8a/1IIgQdrUFvOS
   es0bCzNxuE8re0iRo5JpCn6Yfc+JkaosB1H8CWg1plvJDOiY1pOGAhxWJ
   oWqy/P3yJK/c24byaOqH9fwmLfBrLDwXp0j7h1R0RCGJfBtOTAbhyJstd
   FggXlu2u9HlnL+1yhi3yU6aWjh3MhsHCnxK645Sa8E3x2hvJpynRrujGv
   A==;
X-CSE-ConnectionGUID: uP5wCe4eRnq56AVsuz1CSg==
X-CSE-MsgGUID: b0Db6ud/RkePzMmxDTHgoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11576"; a="64811192"
X-IronPort-AV: E=Sophos;i="6.19,215,1754982000"; 
   d="scan'208";a="64811192"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 22:36:57 -0700
X-CSE-ConnectionGUID: 1THorIt4TNGfIeZr5/8aug==
X-CSE-MsgGUID: l/m8R0OrSD+wUoXXsGFtXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,215,1754982000"; 
   d="scan'208";a="181047892"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 22:36:56 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 22:36:56 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 8 Oct 2025 22:36:56 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.1) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 22:36:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oZvB42KFWoRMsVot/tkyym5kAgCKzo9fkSJzSuCVrrUYMKV6k9o4QKu3WgywSbPwGmjDNoPTtny26ej00L7ZAa+4+Fle/hM5QBH0GMOezszJwIljk99ucYiPcC0H9/+6Tk4umgzepXJlWZZ5rfMMnf/Q11UGAInnRiuebr7SIZj6H1AS/9bpotykWzPd5nyCxh/ytDuAjG2T7DYtiyPXGXxpfq68sjZFTEztfZTaKaoqR8XOcsK9tZGJ6Hy/Nc0QHR+a0f+xq0R+p6x+MsIuNWS+Wi8GZnVUkZdVeQ2Tb5ejffajy4jROtLUmt608HKFn6Sb553nDGrMfHT9WVzlVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0z6IwfqiHfl5Q5i2YfYAFZgpmYwWQEXfc8GBL/874Y0=;
 b=fCRbJJ8ulzf93Rd3V1lgKNTxolqzn1B0UB2pIaGi20S6SinS6wCgzhUWHxWHYpByFCbND3Pz+4OLMyd8ZPwkTXkZ7/hPKZb3+mz/jpAwBK/vYL/OTgnga2EaVQP9AQ/Kvy0UPAhgqzbo3U8zKex9FtgCDSrb4pMicJh12nfWkV7yrdh3xc3s3T9OZlAxnCCLqPo/3YkO3XoqPgqWqpssP8DOCkBqNk5tNwkxPuBY6XUZiwYHZc367cUu7o/VFiurPUmgr9Ja6CZBzPAIsWcFNI9yiCSLpcgV4IiHrmbGgIkZMkOr9TphLAUbsAEtZfkR48R9k2ta+mNEYX2fxriPWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW3PR11MB4652.namprd11.prod.outlook.com (2603:10b6:303:5a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Thu, 9 Oct
 2025 05:36:53 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%7]) with mapi id 15.20.9182.017; Thu, 9 Oct 2025
 05:36:53 +0000
Date: Thu, 9 Oct 2025 13:36:44 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
Message-ID: <aOdJ7JZWsfanX0JV@intel.com>
References: <20250324140849.2099723-1-chao.gao@intel.com>
 <Z_g-UQoZ8fQhVD_2@google.com>
 <aObtM-7S0UfIRreU@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aObtM-7S0UfIRreU@google.com>
X-ClientProxiedBy: KU0P306CA0073.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:2b::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW3PR11MB4652:EE_
X-MS-Office365-Filtering-Correlation-Id: a5240ef8-c723-43e4-03aa-08de06f5da22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ys6CXz8N+QGnzUVHpvIVX+rGHtF2GxENg57mzSgpd2RkCGRGYcuM/Hfn55pH?=
 =?us-ascii?Q?y2NN+gEwBCTkaR0OxvGb8h6/Xn2yPnyu/ziFeBmf0XrbQXuBJMqEcKUw2n17?=
 =?us-ascii?Q?WynzdUFP/5msHmGk2aVE/WComSqRb1ouN3wB73xsliS7hEemAr+0iHCIhw6O?=
 =?us-ascii?Q?VlpRBVecSXxR58XDC8DPH+6yQx54R9Ai08D5kSHff99VHqQrAMrrx/nLxZdc?=
 =?us-ascii?Q?reLA0EW3aTegWOhiz26IzXA1oP0tOvDsiBtRpfBfiUzOcb7cOHgssxhDyjRX?=
 =?us-ascii?Q?HM6FGOWhptx1Dyd7p8zr4fAFbfMtolBXqairgK3r9T7UDSUruNZ8KYAeNjiZ?=
 =?us-ascii?Q?7QBHzNRqe66Amk41VCEpShxBfzd3LRkLNnPfxiBBnAXq7fRuqQqMv88Cp47y?=
 =?us-ascii?Q?uOBr34x/YNW5b86Vn6KN+mlt1xhzVeFuDyJ7USLvveV5JcHa0O2BzDikNzu4?=
 =?us-ascii?Q?j08mLnsY7jBjNxjPMahS8uZWZ9yNLAGqp953Xba1cMbFk3h32r3x5e1XEDNx?=
 =?us-ascii?Q?wgaKf6z6V1Cl+j8wTgVgXAOuoWzsfzV/P8XUraP08YueYK1qD9o16xNCcj7m?=
 =?us-ascii?Q?Z8Wl4jPB5gVDZJIkPb5huzbFTbCeyaFaOTCZ/QwcEQweZQd9lNXmNY8LxKWX?=
 =?us-ascii?Q?BaZok80LZZvc61jbiM5DGy7ksaeFpYzgKaBu7GUV9LuqO5IWOjJ6nh4pyZ+x?=
 =?us-ascii?Q?dfB9XYKFMivnBacfsFylbxGIXSDnLCWbuT6IXzKkrCVeuAbl9kWQ90Igi+jq?=
 =?us-ascii?Q?8pteUlmnT9+YBf32TSRuKqLpRwbcbCh+hmZdKxvOMrJ1ZMyztX9THSUj0e5t?=
 =?us-ascii?Q?5GHicLTjv38LXuwV9QficFK1MS99Oz5WPQGGH26Jv6+SyJEg8aG6BIadICIQ?=
 =?us-ascii?Q?C6hpmvQ7E4FwWW1j7kF/nK1JnXnMcW37iKmF+xHwmXCyuDdARxbuo9HpMdU9?=
 =?us-ascii?Q?V+hiO1jIxzQeZBNAsRaZV1Zc+8aYeWidZyOizNldmNfmfDQXMkS5/PR1v988?=
 =?us-ascii?Q?jb2vbKDBXS6rLNV8UusHEl4wEkH9W0Sjj19W0xPy0qFhJAdlY0LMwgFoQVMg?=
 =?us-ascii?Q?zsCpjSLBqaz2jC/WoRPqf5IGzvR4oAAExEALaf+acARYaeo6yM1+LzvWLx2L?=
 =?us-ascii?Q?rcqwPqzn2oKNH2WG5VjKIsLExw/jKPtYyk9oL2jaMcF/MTeXgm+diHdyS1bw?=
 =?us-ascii?Q?xv7owFd6uA2RWOb01BtLPi5lCLHRvRDVO21btUAe92eqUoOYWu+eZYfQNFYK?=
 =?us-ascii?Q?0/D4RJl7lZkTgkT7T58Z3wpkhTzkcw8lSyN/ZUmtIb+zE5U7r8re/yKSskd0?=
 =?us-ascii?Q?OTp0Y6Yuu8Y7pI6kA37Pq0/0vD+8e+szNPdMNd+9zh9Gws6yycIH2b0lz2c0?=
 =?us-ascii?Q?7pwEuEjBBu4wyjEFFiZ/XwMCH33Aa8SHgk4gZ/y7tT0dHFxmBGZBSWsYRqqQ?=
 =?us-ascii?Q?2tOUOBxmlHzpaTizFXZpPbWzKKUvAbey?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iItIx1b6uCMy45rzxsjRuq5gDOIv8R5pn3dhl/L66Is+CszOp9mPXdI7n5VF?=
 =?us-ascii?Q?xlJhXtTpbqdcg91slLtbVog6t/FJMzPiZx2Arsb41BegLSSwCWRL4B85+S6v?=
 =?us-ascii?Q?DvM877h2z/+Pjk++vZqaf6V7NawlnEjCN11eEa531OBgCuHKcndCMi46tL/k?=
 =?us-ascii?Q?aYiw3rkgpeKraZnK63U0YmOU6Q1oxEzBkGFJEM7g9GMLCNGQAIvSx3ksSX7o?=
 =?us-ascii?Q?dTfiUrBNrpaJVtib6su0oQCBFIS1e1N+J3nDCSC/EsFJrZZBIBSN0mP49uet?=
 =?us-ascii?Q?X4APvFEdFww+wGIf0AAF22NztzMHI36WAlYGzVsm6eC/vY6t0wrD1GKs8N0T?=
 =?us-ascii?Q?tRjhCdW9cgMSMQ+wZqx8Hfl6oZXgei8OMjYEBSr69T06zrL+9n0y2WE7nG0p?=
 =?us-ascii?Q?wD71M8p1/xx5ah0g/TPcjmMrZlwySUpvk0g3cSpcHiCF910zlabCPYltpPmr?=
 =?us-ascii?Q?cVEti6K7Z+FH0Y6YBCmktfrST0//VRhSRdjv1cYCU8t4+Makanm7ChLlSnTE?=
 =?us-ascii?Q?Cs2Xna+Y60VbgkybRrHg50rRxJcRC/CuHz6v3XBvQcgSF4xgvsW273MKyuyK?=
 =?us-ascii?Q?8/WIMiJD2+qkDiLC+Bl9KddQd0F5tAILIAFRyPzKhsxLtZtXKEa/ZWtHyMS8?=
 =?us-ascii?Q?8kvSQ/bPjrWsuQNJPymazqSsD/Drh1j0yCAGG+7RbEiB++SQvpWMLR2LKZ5o?=
 =?us-ascii?Q?+feijrOEp82j6EG8IjUmaI8UEyJtnnmu/N81RfqfYYkLye4Yzn763v77BIG/?=
 =?us-ascii?Q?PaO8BvN1zA3TPtGkluNpopiH5IDiHS7IquIxJ4rXXaEjddwT6QJZ4wVgVGM8?=
 =?us-ascii?Q?npMEGRPcCDdL27lRU4Nhgal6M3j1HgMXUl1ggxo/z7gyXT2DGFmYDdV3cBN7?=
 =?us-ascii?Q?5VjYS/WBOL8QfW8FMHrxcwq5hS79IeQNg5C2alPFum93A7xaHOH4bNrt/mM9?=
 =?us-ascii?Q?fcd9P/IfDGkl2q3/elKDkPEaRTrI5oyLjE/XNt1Sz0Nllvw5rJWUg/0LOSdE?=
 =?us-ascii?Q?uRHzQe0jPgdYVv3i6u1h5iSCwj195QKcO95mDTb6sVDkMT5A82kBPqI/9CUg?=
 =?us-ascii?Q?e1AqAf36BO+aYFLnbpeV99cAUEQ1dmdfVT87AGrBVGwpan3qA4JEgXM7hEYC?=
 =?us-ascii?Q?AnO3PUysKlnFg3oefsSK57S3fVYGg6+Z859vqIHpFwx3aFiotE+yCAgCLLyN?=
 =?us-ascii?Q?aKWAJjY4mWdfxsqICFqPiM/O8waVGEIm/lgFSlWw86viHQqlCojImrhvb8Hj?=
 =?us-ascii?Q?y7TbC/lbuYECXC6Aegz42RIItFbyQTHQXNl0HjYYQ5Cy29l6ZBBWt+nmEskx?=
 =?us-ascii?Q?vHeKxuAeVwXZn9XnS16ivxIYg3GleJB0bvlDnvQGSxhP7DajPRuYOMtdr/xF?=
 =?us-ascii?Q?DCUx6GCE3+ocpTV7jYwrmjMyHlr7EmRgITIpcVtYnEk105CmBzFy9B8sUoQU?=
 =?us-ascii?Q?2grbDMcw4g8hECTs1YH7mPrx5+wBI3yPWde15/wrOWkpS22ksP4/h1HXCpID?=
 =?us-ascii?Q?qLWZ2xUK+RI3+OwTCAmkULf1hza05JC+xMM9FrXdE56MAnFRNvzR32Xlii4J?=
 =?us-ascii?Q?wwa2WlRseWzGpLrORcO7LAPgkz1eomS4twtrvocY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5240ef8-c723-43e4-03aa-08de06f5da22
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 05:36:53.2123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vK0Aj7GfREgXlm9sTGPEXQ/w0q6mZ/P9xIc1GaqI12+wVcQv4JWh6f1pMstmAXCOqCRcdKTWSW9a6LxnwQa+0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4652
X-OriginatorOrg: intel.com

On Wed, Oct 08, 2025 at 04:01:07PM -0700, Sean Christopherson wrote:
>Trimmed Cc: to lists, as this is basically off-topic, but I thought you might
>be amused :-)
>
>On Thu, Apr 10, 2025, Sean Christopherson wrote:
>> On Mon, Mar 24, 2025, Chao Gao wrote:
>> > Ensure the shadow VMCS cache is evicted during an emergency reboot to
>> > prevent potential memory corruption if the cache is evicted after reboot.
>> 
>> I don't suppose Intel would want to go on record and state what CPUs would actually
>> be affected by this bug.  My understanding is that Intel has never shipped a CPU
>> that caches shadow VMCS state.

Yes. Shadow VMCSs are never cached. But this is an implementation detail.
Per SDM, software is required to VMCLEAR a shadow VMCS that was made active
to be forward compatible.

>> 
>> On a very related topic, doesn't SPR+ now flush the VMCS caches on VMXOFF?  If
>> that's going to be the architectural behavior going forward, will that behavior
>> be enumerated to software?  Regardless of whether there's software enumeration,
>> I would like to have the emergency disable path depend on that behavior.  In part
>> to gain confidence that SEAM VMCSes won't screw over kdump, but also in light of
>> this bug.

Yes. The current implementation is that CPUs with SEAM support flush _all_
VMCS caches on VMXOFF. But the architectural behavior is trending toward
CPUs that enumerate IA32_VMX_PROCBASED_CTRLS3[5] as 1 flushing _SEAM_ VMCS
caches on VMXOFF.

>
>Apparently I completely purged it from my memory, but while poking through an
>internal branch related to moving VMXON out of KVM, I came across this:
>
>--
>Author:     Sean Christopherson <seanjc@google.com>
>AuthorDate: Wed Jan 17 16:19:28 2024 -0800
>Commit:     Sean Christopherson <seanjc@google.com>
>CommitDate: Fri Jan 26 13:16:31 2024 -0800
>
>    KVM: VMX: VMCLEAR loaded shadow VMCSes on kexec()
>    
>    Add a helper to VMCLEAR _all_ loaded VMCSes in a loaded_vmcs pair, and use
>    it when doing VMCLEAR before kexec() after a crash to fix a (likely benign)
>    bug where KVM neglects to VMCLEAR loaded shadow VMCSes.  The bug is likely
>    benign as existing Intel CPUs don't insert shadow VMCSes into the VMCS
>    cache, i.e. shadow VMCSes can't be evicted since they're never cached, and
>    thus won't clobber memory in the new kernel.
>
>--
>
>At least my reaction was more or less the same both times?
>
>> If all past CPUs never cache shadow VMCS state, and all future CPUs flush the
>> caches on VMXOFF, then this is a glorified NOP, and thus probably shouldn't be
>> tagged for stable.
>> 
>> > This issue was identified through code inspection, as __loaded_vmcs_clear()
>> > flushes both the normal VMCS and the shadow VMCS.
>> > 
>> > Avoid checking the "launched" state during an emergency reboot, unlike the
>> > behavior in __loaded_vmcs_clear(). This is important because reboot NMIs
>> > can interfere with operations like copy_shadow_to_vmcs12(), where shadow
>> > VMCSes are loaded directly using VMPTRLD. In such cases, if NMIs occur
>> > right after the VMCS load, the shadow VMCSes will be active but the
>> > "launched" state may not be set.
>> > 
>> > Signed-off-by: Chao Gao <chao.gao@intel.com>
>> > ---
>> >  arch/x86/kvm/vmx/vmx.c | 5 ++++-
>> >  1 file changed, 4 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> > index b70ed72c1783..dccd1c9939b8 100644
>> > --- a/arch/x86/kvm/vmx/vmx.c
>> > +++ b/arch/x86/kvm/vmx/vmx.c
>> > @@ -769,8 +769,11 @@ void vmx_emergency_disable_virtualization_cpu(void)
>> >  		return;
>> >  
>> >  	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
>> > -			    loaded_vmcss_on_cpu_link)
>> > +			    loaded_vmcss_on_cpu_link) {
>> >  		vmcs_clear(v->vmcs);
>> > +		if (v->shadow_vmcs)
>> > +			vmcs_clear(v->shadow_vmcs);
>> > +	}
>> >  
>> >  	kvm_cpu_vmxoff();
>> >  }
>> > -- 
>> > 2.46.1
>> > 

