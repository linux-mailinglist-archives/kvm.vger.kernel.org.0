Return-Path: <kvm+bounces-18266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8EFE8D2E06
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 09:22:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74712283FAF
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 07:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E9FF167264;
	Wed, 29 May 2024 07:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b7mWXuO+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967C11E86E
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 07:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716967330; cv=fail; b=BXLJwsDOx+LW3c4h4phcCJZOWfuy/iglGjn7MhpPWDkFzNT7iiQrta5prALKrac7+u25ZlZFTcXVg5xQhtcc2ToWPtkoNLPucbismz2Q/RiAKMpHYc1saw8CG0o+O/LVhwW1+EOQ4pM46EvlY+wcmy2VWQSF3M8fDR2Ip/7ukAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716967330; c=relaxed/simple;
	bh=RSS70Vnj8Weul8SkXAoHwex/4g4nHZNBFbf4O4nvdao=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HJMuJY9Nu9Z6Qx8V+oGCljCChJBdZmnHZxadZTKmHmLJ8hTj+DXrBmEWHwSL1Ne2uxL2UQhbv9ByMdrSzp5LTKe0qpzN0x/VkBP40pdYYwxHTYTxO+5HNfp6tJket0s9XFW+pgSRcjnJwZQuq5JOyzS9lWRU49YqlqINYYbe0OA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b7mWXuO+; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716967329; x=1748503329;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RSS70Vnj8Weul8SkXAoHwex/4g4nHZNBFbf4O4nvdao=;
  b=b7mWXuO+Xla7OJGHz+KztPLR3mdzt75GSDYSYuSm/f6GrUK2JHD+tEA7
   qDGW6ucJ0BuATHx09oyeA/rIsGxMoVQMAgKsh5gjOguN8Fa6otN1wIXZc
   Cl0LVkP5GGHRQdM7advSf1EcN4QbBRSIPY7A8LxDyAXoxnL1GK5trm8sE
   4qQbgXGGqFEeJbY9KSUgmkoQgmOiMaj+KNNkxjd2DZ2SKFiMOF444E1bq
   xRhLYk+nmeiz1ZPpAcjqOiOxO2PxbSfX6V7gEFIY5nvladjg4UplUoP7H
   bUjtLyiXVJLOuv2kVxjaP+FE4qAKqyxK2c10hMjCOlQTZcnCCGCSl2eta
   w==;
X-CSE-ConnectionGUID: jyz78C/FTfO+xpPQjOOpAQ==
X-CSE-MsgGUID: 6mcq0vL8QkWPozRqRb2XMw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="24768722"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="24768722"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 00:22:08 -0700
X-CSE-ConnectionGUID: leb21JsrR/e3ZOWnx5MuPw==
X-CSE-MsgGUID: zdXAFJHKQlSOoP7n2Pyf2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="40215323"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 May 2024 00:22:08 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 29 May 2024 00:22:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 29 May 2024 00:22:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 29 May 2024 00:22:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVRePQYZUiFU26s771BYzyLICl/mdHG0B9C4qAX22l/VV1lAxJ7dXJnpz3hZ0tGbKt5XeRuLvHdIg68Y8AI5QkRLMG4kneoYoAGfFQD+WwsMC0SjRs5kZ6k2UH5Ih/vnoZGcgd8U1+0GPBt15/9+o6mt0K0FC9IBr2AJ+o18kzMHsw0cMK6QkmQK7Zkk3czF3PdHTSYv75SVMkgJlF1TViam6qR315y3l3f+mTr9zUnsxFhA/OpBKz6MhTtY36lU8rDvrdHfT7LnmsmbYhU4E7AX+aZMUCK5cwJNLUtU7+vMT4HAU1mq+G9aZjeS5IrevRW52WHmG4Y1R1vn7wXyqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RSS70Vnj8Weul8SkXAoHwex/4g4nHZNBFbf4O4nvdao=;
 b=IBBM82ISbMdBK/6RUUAWKsFlD5msaZqEsb90ZMaO8NILx+VrfBGsDIikxezirm9fDKYNxfJo+pPHEGThNrVkRi1610vtIcOjQ8mHMDJ2U0QSVqHBbb3WqYoCMtTo7FLi/nNJrALIvXHeabGFWmWOKqL6V4A+oMG8mHAew82FnSVfFxQfsjkD5f4XI2OutUKQjAoMDyRT5/RFsa2LH8+a9pUt5E4XXa6ZrVxD4Ij5bbeZOk3JoL5jKTgeo1+IUCBZiuc7mLmY/fBnCNg/9yRvmr3uH+Arwejq2YqlMiguJ/VdK5iWrub+nR9IyiYa13doHuY5C2FgrU7RM0iaZBAZDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB6979.namprd11.prod.outlook.com (2603:10b6:510:207::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 07:22:05 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 07:22:05 +0000
Date: Wed, 29 May 2024 15:21:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: Tao Su <tao1.su@linux.intel.com>
CC: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<xiaoyao.li@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't save mmu_invalidate_seq after
 checking private attr
Message-ID: <ZlbXlbC0vpNEbOe/@chao-email>
References: <20240528102234.2162763-1-tao1.su@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240528102234.2162763-1-tao1.su@linux.intel.com>
X-ClientProxiedBy: SI1PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::12) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB6979:EE_
X-MS-Office365-Filtering-Correlation-Id: 5445fe40-7d94-4ee3-afb1-08dc7fb00a9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?AYPxJU9gaqpE3blY41YHVdAuUIR9xZ52do3JnmD4417nlOXKYdYicr0eAiP0?=
 =?us-ascii?Q?ZcUXiUTJ05zLb6+kqCiS5BFzsk119zdANKE3nR5QPNFT0qGlvIJs96vWvyR8?=
 =?us-ascii?Q?3gfuUh8U56UFYQ7mi+exTg+w8k8ZmBBDJ74fO2VNTf+E9CpFK9VQqVEprqRG?=
 =?us-ascii?Q?C9PL90nzdk8yoz9uHBePutrCoCRYGR/ydD5OYlKBr3GaAw3C3DD27BxAgjdP?=
 =?us-ascii?Q?DvnLC749JO4QwRPjyVRrg6e1ZlxgwxnsdTpvY+QE/CBAygNkuLpibyLW8/fe?=
 =?us-ascii?Q?sSsYb3qW9ylLCKlL/SCPgW1qRt2dDFaobgAztA6DVIOCXbLglzW82GJwYoGA?=
 =?us-ascii?Q?a+WsHgOp1NFWYVj3yd/aHhJWYUJqoWvPmgxAl2y9KkOVZQXD5KCke5DhM81o?=
 =?us-ascii?Q?Pb/L/P5ZMeCr1pqMfKWhyfRBddam94k197JOV2AUYlGq+hETWF3kd512F39A?=
 =?us-ascii?Q?HyznAtO7Xj5syCVejVXeXMqpv8WKI7kEKCMg5PplxeTVgv5BjIGfmYJs4hfw?=
 =?us-ascii?Q?q0B+acV6jpyhF8HZnHurwoBA9HaL+/ZJjccCa1lRvvu7yMQOnp6ouR0kI4oj?=
 =?us-ascii?Q?HE8wcceSOOJpjPWAVOylgu2ecpl9zqUhHDhKz1LF5GJeZLseYYWlkUrVN2k5?=
 =?us-ascii?Q?Kq5ItO75pe4vGOq1FGF0MgajlXm9TEeRtAA26pFGq6+EIIj/ZIoDVTQ7lsx9?=
 =?us-ascii?Q?iJfJRiPLP0zeDduJmESw6dRnDdyl9lqQfA5/DD9v9dpMKwM3FD8rk6CqiN6o?=
 =?us-ascii?Q?5Q9ZJFFx5RQXdFXrGjDD8anTzqcAkW58/Ms/r0oQc/vefXYLyiHmCSCcQqRd?=
 =?us-ascii?Q?S/YIIRBNJWo5FC6gxk1qqS4Qb5dY+Vk/N4YHse8kBqjRam5dgab11oP3bBE0?=
 =?us-ascii?Q?9Y/42H6YgOOAO+SqtIE8/KnPkubDuPifF4brqXfa4r1h0H0eNNzUtX5gdFY/?=
 =?us-ascii?Q?FKAXrv9E1MToTeyPSPM00rU1Tqd0Aj/jQuNglJjj41fTpBE9LGEV/0yXG6gc?=
 =?us-ascii?Q?xXLhVI5CWmAKv6lY5/5TO7s/ybX3cgQS1j6uwi9HXWi36PWjxvEpifXLzbWv?=
 =?us-ascii?Q?8iNUxCz8PC4zvYOl8eCkHVLD7+ZR5ogCGeh/7vql3NgPQkuu4zw5cZJpcej3?=
 =?us-ascii?Q?a1RaEnu9qtY7RYj2mw56ltVT0DYA3NO+h5xViCdDauuwicq9E2q7S+3+8w0q?=
 =?us-ascii?Q?dygJiirSERCH+AtjpMdYDXkETGsoAmQqDHkScVlXhIwGZgpuniE9J3RNXxJH?=
 =?us-ascii?Q?hIdgXedue3SB+MWa7XfrJr3lE3DU4y7G5PFTgKjjYg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zGxVPQH/QgxayWQmiZxqRVcGLXYHkF2WNvBTSOYQcTw2hCzOeWkaByJJxF6q?=
 =?us-ascii?Q?WMe+JA+FglrVS52Q/HHJpJE092nG2FySA91pbUK3rkksYe0ZLGLCt07M0N7M?=
 =?us-ascii?Q?p2nM7tpnri26jPkChrzqmkWTNQymMYCgEXNCpYdX/ZygGjlndFTfwialQHLR?=
 =?us-ascii?Q?PsGGecwyzF94TLDv3mXVyfn0ACMvD8cefqPk56JAPI00ziFY2gridJoYTGsw?=
 =?us-ascii?Q?Q5oy8MruZxoQ4EAeqO1IMPf2zdLtn5Rw+psVzZeBP9TNsWVNrXrPe2uyeLqg?=
 =?us-ascii?Q?D0evlM1V1HTccT1VHANZ4OaRzhvRzQXetmH8ngl2qLegjD9YtmWsPus4f+X6?=
 =?us-ascii?Q?YXe7ZPUEFtYKiBZzbz+pF3QInBtYp8LYDVkDSpRcn704KXrKF4RBdrwGkr0H?=
 =?us-ascii?Q?kEJMnFEBHznLi1y8zniT/8H9yLEeG8vzQVphKs1NygFaU1UHafBRUbfb6bCb?=
 =?us-ascii?Q?9CgkqM8bVdG4++ulbLG/CbnJuelumKIUe+/KaELgOjBRvq3cBDDgUE6LLeLk?=
 =?us-ascii?Q?GeaktxoqQ3azoTtv7jN52NndPel1wvOVDp7zrRD4Cyl27+cIJUoDEqBUsCeR?=
 =?us-ascii?Q?KvCHSQVYyK9Aw68UKA5R890ErO2O/l2ooRwEk768BeqjCnOJq1r4NvzEVnc+?=
 =?us-ascii?Q?maGzUDou/MhLWSyj8pDERAwJIjSQq/os5fdg0B7jUmQh20YwIWSR9EvXMl5f?=
 =?us-ascii?Q?u3dMcN80RqRJ4tQ6VsCSZqkHo+NP4boQpFuDSu0zZVovSZdqihICGGgk/5kE?=
 =?us-ascii?Q?U5UHdD2jMrlGJfTcZqB0f+WesXTHg23WI3bYnIWaiVWNp+RIJeJzWznhdPOQ?=
 =?us-ascii?Q?p4CXwVmPUM/LsO8d8joPmxWmppJwviGFFExVI92HowvUZNIUVmSFI3Wm+W+L?=
 =?us-ascii?Q?EPfxtEJuhL3DP8YzTZjHpAlyI2fKa6C0qLK1QDhUY1+a5VXttsiUvYMcFPc1?=
 =?us-ascii?Q?p+S3L+lrGs5TKbf/PhVoeO/n0oYQeq6Fyn48Tx3shH9QrvxhFrhZ8As3VpTo?=
 =?us-ascii?Q?cT8e+K0jDi6gIvs7OzVpyXdkb2xMJ5bK2Vq+6/g/c15LDe8wM7DFxNeo/f4N?=
 =?us-ascii?Q?TdQZsGdf72Mt3L9Uuspgo5ZJUi5kvUdJVy6k3/rultQ7j98m3oL9bXrBYD0K?=
 =?us-ascii?Q?oACfY/8MQuwyWMoiCNtCJtuAoJVLwOsUY6dgv8vyA538Dni1tNfqIwQ2oiHZ?=
 =?us-ascii?Q?Z1S66h7cFfG5u766co3ZPRf18PMQu8DNiMjdeaMIw5eojQyWChnK76gd7icT?=
 =?us-ascii?Q?YWxJRwTUJuiewgWZHwgHGKHWMr8TnUpD5B0NVpXr4foCxoTHYqrwivSHQXkc?=
 =?us-ascii?Q?aAwqMKOMIf4B6qgoZiDY1/h7tw+tiCoh7VUAMBuj7pIJt5R0A/A1P6+zMdtP?=
 =?us-ascii?Q?CcN3VMEgarDxu0gajGFabRKFWJKh4wzTS/BTTr1LwtSMSzR4HInJfpu3pPws?=
 =?us-ascii?Q?Sy0+8Xaz0p1m6x/BszgH0aGWjiDq6XEeAjVNfNdGoKDTx6EFXzsiJhyr2mr5?=
 =?us-ascii?Q?pLwpcvvLJLO1GMbBHXczDHkiX5gqSB6TsdmBNi802lkLdOekyAfacji2rnJD?=
 =?us-ascii?Q?HD14NLYo6YsTUHqZ+BsLPceL5d5rYMPn+5cYScmp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5445fe40-7d94-4ee3-afb1-08dc7fb00a9c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 07:22:04.9952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvo+DvFoQt/t15VpfruG+RvBpn3GmxdvmdcP+J5qUnCFYEaFk6LSGcnc5IcauceyULm84lc9jS0fasYzf3gy/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6979
X-OriginatorOrg: intel.com

On Tue, May 28, 2024 at 06:22:34PM +0800, Tao Su wrote:
>Drop the second snapshot of mmu_invalidate_seq in kvm_faultin_pfn().
>Before checking the mismatch of private vs. shared, mmu_invalidate_seq is
>saved to fault->mmu_seq, which can be used to detect an invalidation
>related to the gfn occurred, i.e. KVM will not install a mapping in page
>table if fault->mmu_seq != mmu_invalidate_seq.
>
>Currently there is a second snapshot of mmu_invalidate_seq, which may not
>be same as the first snapshot in kvm_faultin_pfn(), i.e. the gfn attribute
>may be changed between the two snapshots, but the gfn may be mapped in
>page table without hindrance. Therefore, drop the second snapshot as it
>has no obvious benefits.
>
>Fixes: f6adeae81f35 ("KVM: x86/mmu: Handle no-slot faults at the beginning of kvm_faultin_pfn()")
>Signed-off-by: Tao Su <tao1.su@linux.intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

