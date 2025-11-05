Return-Path: <kvm+bounces-62036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 70523C33B78
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 02:57:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CB63189416D
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 01:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE502135D7;
	Wed,  5 Nov 2025 01:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jrcf3ZEu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA961DE885;
	Wed,  5 Nov 2025 01:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762307790; cv=fail; b=ZDCpNzIBQR4jkBjfBaOl1fFJQBRgYg6v7GiIcIi/hKvX2zQpgaiim6MgsZEC1YgL2TN3lGLxE9ipWEb+Q2JQLIgjp0h4u2r2MizBfNLU7LWca3YMW+x4+raGgsLRSrqoyqNMVRA7hNXALeWUMzBvm3myka5/dzetKDQek6OyeRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762307790; c=relaxed/simple;
	bh=szrVVTLLpZmPuNb9hIuIt0cvGUzjDsazRJnP+pdYNUQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bKmHUikQkh07BQOACIGCkH9eaJGqLIjy6kvgYq+ylNZRm93bgHN2RWaYMqhH898soyLr9Mj2Xi+BJFkacqeul7i02QAvkwz2z0pklhYCK7dkmELFBeuX016qdHOPj0cOOE2wHvP1m1Zfpej5GjDqunEPARtGZEuupXfe0XdYOXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jrcf3ZEu; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762307789; x=1793843789;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=szrVVTLLpZmPuNb9hIuIt0cvGUzjDsazRJnP+pdYNUQ=;
  b=Jrcf3ZEuJe8aQRzrF8MqNKhJ/wYOL5Ab8JblByQjjS8dKYiXRcUKvnht
   5PXwBBsvH6Vs09oWn/HGH9lZJmzt3Kg0PH6Vx6KXYFs9GXX+n7TDbanar
   lV51vMgBUYy/CRiSizqXLcifauh/kx3HsyhI7aLhmCeid26oJI+MXA0oA
   NAcKyxSyT5gMqOCNbWxz4IUy9nSc6JjmSbG/f3J57pCUFRwAtrYXK91CD
   BM7Mm/bL/vf27037HReFfqX7uU+VzjoSQAVcLKcjTR7FVqFt/0dlrtnqG
   5YiehX8cQ6+aaWpUxBxvWP8JYYhn5CR+yP8HVtcKM7un4+9H1wj35H1GB
   w==;
X-CSE-ConnectionGUID: +w2vZlDkSi2c5VVD5d0OgA==
X-CSE-MsgGUID: bApeKiREQyqu9JxpUpTekQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="67030514"
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="67030514"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 17:56:28 -0800
X-CSE-ConnectionGUID: wdBZ4Hj4RKuqODPoC2VbSg==
X-CSE-MsgGUID: RwgLnE/jRFOhteKXoOM1OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="191414127"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 17:56:28 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 17:56:27 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 4 Nov 2025 17:56:27 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.32)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 17:56:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BVn8THmn3pW1WvB2Ce2tht4XlTMNFq3kJly9VMgS9zTBFE3I6J7KaT5d+ywqPzsjwAKMrD2g0ztK/jKrm4cxG5YCYQ0jNAg4s25OeTSYizAX/u1ZN8bXUde+Sx22RzrFM8PcUqWZk47LfA8tPSfmK+GRlWmktwkWxNg5TYlAihk2g0e8Nqhn7qqL9NO404qIYGYGok4uBCvM8yTOc0L5ctf2qhUuqGf0yKf1U+7FmsKZL/nlmIMQqhGmI/q2+pLZX/hB8xdxCKWbFqCoqtlSiWw9icUkmZYiRgjS/j+hzQ5VWhaRRPiNH7pphNLFWeddKXTX7KVMS0IlnHoafly9Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdPR31ZJoaFzBA9DiyV8yzxG6f4DBI2Mngg9unxw3ZQ=;
 b=dbnZBzL2QuaNlvbfQPd48ixuaLgj77xHHdy7e7rFdz0frbjLFZJ/47HejdRkqx1QWj9n0P5uUrTOjgMtGN7I8IRmASJYu7bsDAR0idyeZuXYmzCCmElSags7rpfZk/Oa+alqQYsBgmxbrDpAP4wDm/5F6hZNZqkYwjqEtwFMWi9kqFmjRRN0O+LcRtUZyw0YMsF9bZzoQDJDHtzNrXzZWd5oLz8uj0eHJQBMGlUn+HzlAWj2lSZGjgSRoFWMpGgYdxHRG41RZOFX0NNABgj65K2RlsTE2wEARCbXDsMzecYxFXsBuVGhztrayNjLCmQfCsI4Gs1FLKIrbtoo7QHCmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6380.namprd11.prod.outlook.com (2603:10b6:510:1f8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.9; Wed, 5 Nov 2025 01:56:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 01:56:25 +0000
Date: Wed, 5 Nov 2025 09:54:57 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Rename "guest_paddr" variables to "gpa"
Message-ID: <aQqucSkE2UIL3MDu@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251007223625.369939-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251007223625.369939-1-seanjc@google.com>
X-ClientProxiedBy: SI2PR06CA0011.apcprd06.prod.outlook.com
 (2603:1096:4:186::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6380:EE_
X-MS-Office365-Filtering-Correlation-Id: be2f2f3c-5d2e-4247-5df9-08de1c0e86b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wWN/vraOtG6V7s+xHzzoYVipSV9Mqxax7lrM8AFYjWmt1wH5y/QRyb5/2Z46?=
 =?us-ascii?Q?pKhcj5L7gR4jrX8JfiCc0xvncopMSTXoBC4kc3nM8CNqXIa98nlskyZFRHuM?=
 =?us-ascii?Q?esvmlv7H1qhgRTd6tLisfMczWbItkZyLBQSTQqiO6Z9ZoFjHKsO2KIxQzAeO?=
 =?us-ascii?Q?+UymUjBwzI1DjDHaoWKLr4F5WINiIermQ4kg83JV73TZGQhnzDS2afxTm1KO?=
 =?us-ascii?Q?0w0MxX0tUsp7eaQEJkQcpTTABt4aAx8MF3ETCcyBSghkVzN7OpftbEEnjBR9?=
 =?us-ascii?Q?fr1OahbEqBI5rPRzj6E63JlOYHU4wwCmnbfD3/8TCm8HJv6yxJVvIowOXTZT?=
 =?us-ascii?Q?J2OnYRCDm3TnV/G0oHN6+W1bsLGYwd6fnqqITF0e3PRCID73IWgkBi6iOe3c?=
 =?us-ascii?Q?78mzWuWkOqeFgZZyi7MKGv53EZmDHGO4QGhif2txOlQetwKW68v1HIH/MbJu?=
 =?us-ascii?Q?DpmXD8xaJnrIEhKeFWFRifLBsFHmqASQZIm/MLUDmKk5bpWknfTHJj92tWaO?=
 =?us-ascii?Q?GloCCgpVxIYSIvJIQ5OzNCOwBB+obmnql3+DTnOG+w+QDj/037f+iUdt1L3k?=
 =?us-ascii?Q?UyyevUsQhUFoz3dZbe3yx5dBETu6DVC1cZd46mmjzmSMNVM6l0kvzBAoyH5f?=
 =?us-ascii?Q?OC1WXSCaUMysLHWf4RaCuLOd+CkwBsGcW3rqx9waZ3/FTTKDTnyBxAb8twMW?=
 =?us-ascii?Q?JGf2djs09eaYvsuqFEPKLk62BFYzDRu8azvovFmYKzWE4bkxOfycog1MYdWj?=
 =?us-ascii?Q?Pct9aUw5+7NUPITwHXrhgRjgpXMzss9yO8ZU3LnCSyF7M3TJUgfa0eqGzzWE?=
 =?us-ascii?Q?QfteYOGjrJi75rmF9hdKtUrgqOOGqBLRK0WKuxs7isS90ukpkYxvNt4UYRjl?=
 =?us-ascii?Q?Hgg9GRkla5BMDrH1n5tEgs2BosFyL/xeD5XqjguPvmuKHUftIJxALkrfz619?=
 =?us-ascii?Q?XNkl4sA5qsmEF1rCMcmjT5ML+3PFGwioLf/LtcNkO5p0PIlMiSKm/yhf4ojV?=
 =?us-ascii?Q?rv8VZejFk6UJWY/8FhFaO/IZmsQjpP62tl/p2xZbi5oSukV2bN6EWqI6AtIA?=
 =?us-ascii?Q?JDBCYqnZq3a0nDPuWYLbsIyLBVDJ3ZyxabIJ42mAcqwlWCH/v2CmFxb+nC4J?=
 =?us-ascii?Q?2M947hcxF+n15qk6cZINAuTPM25EJWqpeMXjbjpKwQ3UQJiBCZx3u4//vHBb?=
 =?us-ascii?Q?SApNq8BZFi+vVfYtXHvjxvkDuqTKKw7nIyi0PdmO2DY/ZnX/Jx78Hbjmn0/v?=
 =?us-ascii?Q?kz1YvmAH02yPGBy6h8KEaYlsLHHGSh8/JUR7DqRFCMTJfiff1lGqTYQgexjx?=
 =?us-ascii?Q?WaY9bFCtUapDxzKH0xiHMlyEMC2hJeVCnUn36liVUuxcZ/c8Ra65q3sosmJj?=
 =?us-ascii?Q?fpcpMipI7szNIGaOJa1+rHg7+p2iioZbgmqOpoZqQzuYfvog63cz+zuFJw8v?=
 =?us-ascii?Q?Dkne57LLTpG66U8Bdw+VMyZVdmtLwatb?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j56S3sGULwgOhR9hchge3RmHCIGAZIzmJW4b87/bmUz6bhkS6BXZgJnvjaJe?=
 =?us-ascii?Q?8Z9RX2o3q+J3IKoYMiNjIycxH4OIsKQncj3n+6nH1alGjrBIxJR57NIw/bjT?=
 =?us-ascii?Q?Usm6daxkYr1K1BSbm5D952SyEmxMfQ+6Yns9vHqcX8nPEA7PapcLr1igHqIz?=
 =?us-ascii?Q?VfW7UnhaXuXMu+DBl4bJWXe7ziH3hiYONoqHHJQQrKzU5zx3PH9471Pn1DDA?=
 =?us-ascii?Q?Z3snq3n+sx5KTZY8EH4+g6ncdP90F+6JvC/G4oOXRYvl0+9Irv+UdskVTcLv?=
 =?us-ascii?Q?D02zAay4M8vP/SKCKE2crBOhgENKzvRtB+ac+///EaU0v6tfmyfgqbZ9sfZn?=
 =?us-ascii?Q?p3crrpuTDXIixryzSI7iZN1Gi/GgtsjPSYzwfFTgFvwM0cpUt2pLoz2bWv/z?=
 =?us-ascii?Q?f5Y/ilrcv1akBiC3gYvSJrzYYblgKaTX2COCmxzAPjCG54MANbCB5ZUvSfOM?=
 =?us-ascii?Q?6BZFbK3/gukAstDPOw1f3hQNI4ozmIbpYebGyXrjgGFz6Tpb3siUN4ae9EWK?=
 =?us-ascii?Q?GYoCMUn1AO6lXbCZ20oK5VTDNkYOWL0p5+sJdcUC03Kvm+/DZJ7o4tXALgqt?=
 =?us-ascii?Q?1xzXhevrlmIxUxGjJYsHWRsZHdyM5N3ESbvtdq+GI5Riw5/UJCQ260ZJIhvm?=
 =?us-ascii?Q?ztNs/PtuC7/afKUpS9Fz4tcYj4y1C/9Yq6n3fOfXFxdzUDxVwr36QEF0g73R?=
 =?us-ascii?Q?0Z9DGpUv7LjjQe/abGEPUN89XJn99nOMfhyz1h8GB5ynFwQfVz6WUbS+f2l/?=
 =?us-ascii?Q?tuIVnYeaKk+QUxMndHhHTNdUDqQewnNNpfyioj189Lx17dCa9hsNxuqjt5Sd?=
 =?us-ascii?Q?ki1k0zELxrdBeYX1QoY4AAzHJSkc65ZjwUtZeIAzBzP1kJq4Y7r58nXOGjGv?=
 =?us-ascii?Q?O99+yWFL7N5QIwKL0asxBnG5Z5LMK0bE8r8RIkbUC59pZiYs/xFBRNgLy+MC?=
 =?us-ascii?Q?YNIGUTpR7mM/4LOOSyAoLNEDCSp//rRcI15F4+mA1WXKZo7yjMnOKt3D+zHC?=
 =?us-ascii?Q?HAOzRMrWAHNLRd6tHKoRD996hLNSM5LHhYHZ5rvOI1Jt7s9gbYy/eYjz13PN?=
 =?us-ascii?Q?ovHYnrez9qiivRKxnjdGnmSCZuz6AXxCSwlcDQOKJJGRMdeyUGyCIYeleuVd?=
 =?us-ascii?Q?NF3FZlCUNK58vXW9mBre+Zk6IclMz3THnb3SIbcMgZ1JidpfjT7N/ywXVuqN?=
 =?us-ascii?Q?hB7OEOw2OE4Y33/VvS1hk8KuHvnpPjKdubXdmZnaCbkB5nvoRVIfWnLA5zgi?=
 =?us-ascii?Q?/w3JKxGBQu8HraUHszTW6K4bMM2yJZYKX7XSYzW4ewwYgWgUWoG74OdreYd1?=
 =?us-ascii?Q?xlwocre2Iu7Xkoc8IYr0DptP3Y9VQD0yOof11TwndIUI0TPSE8AlhXC08zQv?=
 =?us-ascii?Q?xNyigROsv1rPXSjQw/dSTmtmrr9dgA2ND9ZXP27x79Fy/iPzZqGkK7he6YFa?=
 =?us-ascii?Q?OcxBg1Zbeo5sMWE0co5Kkt3d8wWwwFsVwB1LhsoQ/jCvzbrWsfQr0DD+FxuK?=
 =?us-ascii?Q?5Obvh1vyhRrmz7J110KMKKOOXOHXcdH4ahh/FXdb4s0ZPotx00lTLiIBXXtr?=
 =?us-ascii?Q?zcHhhzgIWNYFPxwyOHJr/1+XZCoIxD7s2AC7pCAV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: be2f2f3c-5d2e-4247-5df9-08de1c0e86b7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 01:56:24.9970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tD4rQ5JOK2s5xct95EAdvHgzuAWZDRPRqC2BZGX6xLVs3FJoc5wrgD2I5iCNf3BN/BF3i5wwQd/w7FIxdGaMKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6380
X-OriginatorOrg: intel.com

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Tue, Oct 07, 2025 at 03:36:25PM -0700, Sean Christopherson wrote:
> Rename "guest_paddr" variables in vm_userspace_mem_region_add() and
> vm_mem_add() to KVM's de facto standard "gpa", both for consistency and
> to shorten line lengths.
> 
> Opportunistically fix the indentation of the
> vm_userspace_mem_region_add() declaration.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 10 ++--
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 46 +++++++++----------
>  2 files changed, 26 insertions(+), 30 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 26cc30290e76..3aa7a286d4a0 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -675,12 +675,12 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flag
>  				 uint32_t guest_memfd, uint64_t guest_memfd_offset);
>  
>  void vm_userspace_mem_region_add(struct kvm_vm *vm,
> -	enum vm_mem_backing_src_type src_type,
> -	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
> -	uint32_t flags);
> +				 enum vm_mem_backing_src_type src_type,
> +				 uint64_t gpa, uint32_t slot, uint64_t npages,
> +				 uint32_t flags);
>  void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
> -		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
> -		uint32_t flags, int guest_memfd_fd, uint64_t guest_memfd_offset);
> +		uint64_t gpa, uint32_t slot, uint64_t npages, uint32_t flags,
> +		int guest_memfd_fd, uint64_t guest_memfd_offset);
>  
>  #ifndef vm_arch_has_protected_memory
>  static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 6743fbd9bd67..ce3230068482 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -963,8 +963,8 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags
>  
>  /* FIXME: This thing needs to be ripped apart and rewritten. */
>  void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
> -		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
> -		uint32_t flags, int guest_memfd, uint64_t guest_memfd_offset)
> +		uint64_t gpa, uint32_t slot, uint64_t npages, uint32_t flags,
> +		int guest_memfd, uint64_t guest_memfd_offset)
>  {
>  	int ret;
>  	struct userspace_mem_region *region;
> @@ -978,30 +978,29 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  		"Number of guest pages is not compatible with the host. "
>  		"Try npages=%d", vm_adjust_num_guest_pages(vm->mode, npages));
>  
> -	TEST_ASSERT((guest_paddr % vm->page_size) == 0, "Guest physical "
> +	TEST_ASSERT((gpa % vm->page_size) == 0, "Guest physical "
>  		"address not on a page boundary.\n"
> -		"  guest_paddr: 0x%lx vm->page_size: 0x%x",
> -		guest_paddr, vm->page_size);
> -	TEST_ASSERT((((guest_paddr >> vm->page_shift) + npages) - 1)
> +		"  gpa: 0x%lx vm->page_size: 0x%x",
> +		gpa, vm->page_size);
> +	TEST_ASSERT((((gpa >> vm->page_shift) + npages) - 1)
>  		<= vm->max_gfn, "Physical range beyond maximum "
>  		"supported physical address,\n"
> -		"  guest_paddr: 0x%lx npages: 0x%lx\n"
> +		"  gpa: 0x%lx npages: 0x%lx\n"
>  		"  vm->max_gfn: 0x%lx vm->page_size: 0x%x",
> -		guest_paddr, npages, vm->max_gfn, vm->page_size);
> +		gpa, npages, vm->max_gfn, vm->page_size);
>  
>  	/*
>  	 * Confirm a mem region with an overlapping address doesn't
>  	 * already exist.
>  	 */
>  	region = (struct userspace_mem_region *) userspace_mem_region_find(
> -		vm, guest_paddr, (guest_paddr + npages * vm->page_size) - 1);
> +		vm, gpa, (gpa + npages * vm->page_size) - 1);
>  	if (region != NULL)
>  		TEST_FAIL("overlapping userspace_mem_region already "
>  			"exists\n"
> -			"  requested guest_paddr: 0x%lx npages: 0x%lx "
> -			"page_size: 0x%x\n"
> -			"  existing guest_paddr: 0x%lx size: 0x%lx",
> -			guest_paddr, npages, vm->page_size,
> +			"  requested gpa: 0x%lx npages: 0x%lx page_size: 0x%x\n"
> +			"  existing gpa: 0x%lx size: 0x%lx",
> +			gpa, npages, vm->page_size,
>  			(uint64_t) region->region.guest_phys_addr,
>  			(uint64_t) region->region.memory_size);
>  
> @@ -1015,8 +1014,7 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  			"already exists.\n"
>  			"  requested slot: %u paddr: 0x%lx npages: 0x%lx\n"
>  			"  existing slot: %u paddr: 0x%lx size: 0x%lx",
> -			slot, guest_paddr, npages,
> -			region->region.slot,
> +			slot, gpa, npages, region->region.slot,
>  			(uint64_t) region->region.guest_phys_addr,
>  			(uint64_t) region->region.memory_size);
>  	}
> @@ -1042,7 +1040,7 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  	if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
>  		alignment = max(backing_src_pagesz, alignment);
>  
> -	TEST_ASSERT_EQ(guest_paddr, align_up(guest_paddr, backing_src_pagesz));
> +	TEST_ASSERT_EQ(gpa, align_up(gpa, backing_src_pagesz));
>  
>  	/* Add enough memory to align up if necessary */
>  	if (alignment > 1)
> @@ -1106,20 +1104,18 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  	region->unused_phy_pages = sparsebit_alloc();
>  	if (vm_arch_has_protected_memory(vm))
>  		region->protected_phy_pages = sparsebit_alloc();
> -	sparsebit_set_num(region->unused_phy_pages,
> -		guest_paddr >> vm->page_shift, npages);
> +	sparsebit_set_num(region->unused_phy_pages, gpa >> vm->page_shift, npages);
>  	region->region.slot = slot;
>  	region->region.flags = flags;
> -	region->region.guest_phys_addr = guest_paddr;
> +	region->region.guest_phys_addr = gpa;
>  	region->region.memory_size = npages * vm->page_size;
>  	region->region.userspace_addr = (uintptr_t) region->host_mem;
>  	ret = __vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
>  	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION2 IOCTL failed,\n"
>  		"  rc: %i errno: %i\n"
>  		"  slot: %u flags: 0x%x\n"
> -		"  guest_phys_addr: 0x%lx size: 0x%lx guest_memfd: %d",
> -		ret, errno, slot, flags,
> -		guest_paddr, (uint64_t) region->region.memory_size,
> +		"  guest_phys_addr: 0x%lx size: 0x%llx guest_memfd: %d",
> +		ret, errno, slot, flags, gpa, region->region.memory_size,
>  		region->region.guest_memfd);
>  
>  	/* Add to quick lookup data structures */
> @@ -1143,10 +1139,10 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  
>  void vm_userspace_mem_region_add(struct kvm_vm *vm,
>  				 enum vm_mem_backing_src_type src_type,
> -				 uint64_t guest_paddr, uint32_t slot,
> -				 uint64_t npages, uint32_t flags)
> +				 uint64_t gpa, uint32_t slot, uint64_t npages,
> +				 uint32_t flags)
>  {
> -	vm_mem_add(vm, src_type, guest_paddr, slot, npages, flags, -1, 0);
> +	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0);
>  }
>  
>  /*
> 
> base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
> -- 
> 2.51.0.710.ga91ca5db03-goog
> 
> 

