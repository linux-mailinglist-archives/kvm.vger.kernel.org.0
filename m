Return-Path: <kvm+bounces-65547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B267CAF251
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 08:34:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7AFC73008B63
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 07:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C46F280318;
	Tue,  9 Dec 2025 07:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QWhhptX7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97AF221F24;
	Tue,  9 Dec 2025 07:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765265640; cv=fail; b=dwioJyBP6SCJMxloW2e0wULtcClo93ydHxFqyB60ASqVOfBRtwndzIRxQFiJyDeD9GSpIfcYHVFgxkBba+GdcLFkVxIVOhuaIJ7ETJ3rIOWncm9I3VBzBi1KH51klOP1F+Yk8wwuYu1CEnTWMg7Hxxn/0wGreNfsp7XP3hTTNpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765265640; c=relaxed/simple;
	bh=7Gdy1SOiH4WGlJQEVxovz7IsQT2fhiOsUeQC/CnAZTs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lXiqxNNAJD0DqmpuS7vSCfVrfvuLykjDeYWC9mLf5UikJuDnXUDJAqMB/NTPMRJldqp9W+N28nTWJsVlsSDH4bX4gA//Es7uSvODANNXXJRWNCT2m1qjd9U9WrjDNAA51s0vlQZ76ygFiLzENVAwnP501UiHXrj0S+q1ik3p9Io=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QWhhptX7; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765265639; x=1796801639;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7Gdy1SOiH4WGlJQEVxovz7IsQT2fhiOsUeQC/CnAZTs=;
  b=QWhhptX7cm/J9j9ipyjrnMXvCDjWEO/87qMLYvw+5i23Z36ErptmR10v
   q/7r0s0vu6rEsezuT6QTs/XVrf7uP6GRRsaKWCnuslugy8w1qMeDCQbIp
   erQ6qrcTFS3J+A1ezLBIRq8Cx+jRNCrFjJHPseULPphT30etjH54BIl9R
   05DxuxCfuZ8ELsmu9YJKU2E9HV6N+xvY5/Oqpllo0LVJVcPjGP/AlhhuN
   b7jCeBe2EVlRZ+jBWQ4M6h/voCFU8HU255LDEmXexxoEAijAqer8zKI4B
   /TR8koHgA0mrIs/wubCBhJwt9h8zDHe8TgrPt+wW3hz91UOiA5zZJ4xDX
   A==;
X-CSE-ConnectionGUID: cjHI37tPQLi9Qyqj6BsJlA==
X-CSE-MsgGUID: 0QCkljRzT8+rRbpL6wOvDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="71062631"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="71062631"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 23:33:58 -0800
X-CSE-ConnectionGUID: UJpYDptmQC2LSLo9ytsElw==
X-CSE-MsgGUID: nLZbxY/zTCG/DYLQE2VEyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="196443726"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 23:33:58 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 23:33:57 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 23:33:57 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.49) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 23:33:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pixh2hAu6of8+sl7qmIeUxN+B9mZvdCD4vCCK5U3NG62CUCplJ8ZREiis1PAbLprZS3NbRMH28d/bQH41Hb4c9x2kk4jUCyLLgnRQ5nIEEV/uy7dgwL9Uhv4iptrADtohaRBKy1QRW+t5DG44HK53lLDRWQSSiRhueGzOPE8ssfrVr97MP1RZ3uuvCeyW3z91welpTSFK6qDMiD8pFLNrk2yhHVLUj0WU7hpLPlrFofndKm6wZz6qYS/h5wPZiyfp6GsHazx9hJUZpbjeBlrmr+Ng7FKGEuY/3FnXMh0NtMlj4vU6taTPh1igFjh1k7OXTJdE4jhZD0KvOPIGgoarg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Gdy1SOiH4WGlJQEVxovz7IsQT2fhiOsUeQC/CnAZTs=;
 b=v9ryWRTIxHNiKDf3nLBKf0Optb933C1Cq3n/+nb135cg8UjD2PUZK5eQcqxrFwP1hejAjYWycbabCtF0EccQzIrjdWUfEgrnr8bNE6DJB2EMNYEnMfnBsB7k2Ab8iYTb/ypHxiVOWQcIL2xrxgafwwv3hyti1HDHBr9Hcok7DCGMF45ECyPFyQgPLDnCyM1SuDOOiV61hambIUjfT7FqOrV3fArk5JLCdtTSYldrc1Mk6fI3DaxiP93xTi6eDF3ntmTLSSC6hbgNZSdMS3tD504N5OG3kS9mx1omjYP57DQ87EqsMGYbBvAB84TFwQ1bnAjnklDuTWV/SkWXhw7rMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4707.namprd11.prod.outlook.com (2603:10b6:5:2a6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 07:33:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 07:33:50 +0000
Date: Tue, 9 Dec 2025 15:33:40 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v2 6/7] x86/virt/tdx: Use ida_is_empty() to detect if any
 TDs may be running
Message-ID: <aTfQ1Ima5cX8ItRn@intel.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-7-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251206011054.494190-7-seanjc@google.com>
X-ClientProxiedBy: TPYP295CA0017.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:a::9)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4707:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e27ac94-1bf4-476d-f04c-08de36f54bfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7hDXS9W8ClsFVrRvnNXdlsMoBAlaFevwzN+2S9zulKcfRmIXo1WWytx03YCF?=
 =?us-ascii?Q?YQ6R0KSbuO9XO+eJgg86d7PvBMG5qwQRph3PMGevpEPZ6aPqA4MUCmrFTEwx?=
 =?us-ascii?Q?8UF5kh4E8DAxsvgOZqcQmqih4lIBBo7hTvyykd6MR/CADI30cizIcTw2r8dc?=
 =?us-ascii?Q?uNuMozM+JwZhVG3FOvDaYAnN9DzTStKBDbg6aMqM1hjmazwFvGQKCthY6afm?=
 =?us-ascii?Q?KiajaWaf2Xq+lfaaZK1uP9v5XeuzmBkSgfWaYhTnsa+2q/Pb91dpkLAQ2p5b?=
 =?us-ascii?Q?GCQtaG47KU1KniraMtnZCQR6qaKK+IUSxTpRnymMmx0VXcSGtonxwFogO7ZA?=
 =?us-ascii?Q?0VzxIIbPw/Oa1nNtKgcHmNMyO0cW/AJ/ByQnT385Y+2Fild1+IQNcLbsFDsf?=
 =?us-ascii?Q?7Oop14caQpPw/5kbPc9p3N1SDJbpqd06rvMFUNvXhTl+bvT4s3n/x7WIXY50?=
 =?us-ascii?Q?KOhvByuy0imghgjhv9mTRQdqIiM98cRa5hPOQ7pMo3SFvIPL2c4AbHYj1SEQ?=
 =?us-ascii?Q?gQg2DM4B+KZGo1oOkFdweFC+o40+rDr3DIXXXxJX8GZK7rTUQEnnMpBeO3CB?=
 =?us-ascii?Q?JJPXabqF0YAIC2sKoGeC7QkGmK3EqGAAyHqOutlvp/HViaxEK9nJ3AuPzrJ7?=
 =?us-ascii?Q?7a6E6v09Vae40ARcYXvane7x/G9eyQ8RDD0c4XFbnSZ/uVmEkPj/MfYolpL4?=
 =?us-ascii?Q?qngeeJ4LU1iW4mnMF6QDOWY7NldpO2hD0hsoP3YDEvAijcZDF1CTEA3opI85?=
 =?us-ascii?Q?1InRMcMCvxOQx0kHwtWIqcLtHeww4MjFM9+7ql3S0tb8GD8LihOnAI5qjWGu?=
 =?us-ascii?Q?w/rnfGDz+B4gzmkNPmdWo1M52BNTqz3QfGmU9eBz8Xx/bDzuI4CINZ2+ouH0?=
 =?us-ascii?Q?YPeR/zyO/2IDC+7BOP2fHMipuHjZXEoeIKhkNoOx9oau5hQN4gRi3cEXhp6h?=
 =?us-ascii?Q?pH++zQESalbgx/OoTyc4k9sC67SPBHfzfEVQQZom8OGfiY5GmyTupPZOULv7?=
 =?us-ascii?Q?NSrauiHzP+7/YbylVwclBIfkaVf6DhN301GzvGyUEtcJme8lVhQx67eEDJvg?=
 =?us-ascii?Q?Q69z7CjVg8vfXyqpdYTtdaSAwSYm9A5YJ6ZORauqJvxoDJuegBJmiKc9+NQQ?=
 =?us-ascii?Q?u513kESnJXxWtf7mRh3xo3TNLlMcT8UsaBfgAYsI2AYpRMpaz2ZFHpJ5leao?=
 =?us-ascii?Q?K80pKNFcd8O4csAbXzmiFkBXJuf0cFTdrKNLWoAdSU0h3fotpqxSEwfn5bZb?=
 =?us-ascii?Q?9LP2rjp5NhG0CGPOSUlMFjuI8OG0IQ5SeesSgws7XNS+TyHKtDCUMUYQT7P+?=
 =?us-ascii?Q?yRIwY/vU2CaLmxY6IQW4XUPZVZS4+vMiT8GAOo0iSc7OHZwgC8OgUInkMD5j?=
 =?us-ascii?Q?6SLWAtt8F/yenqKe+sR+x4c+PXtNptGPfNFdHcSWbcUr4GQ/b2Co5SGdfrQ0?=
 =?us-ascii?Q?CSUV/zlS0UviburcmEZn7ua5j2NXoc3K?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HzigbvXf4r1NJu3oYTNLq+SVeQs/DdOVO+j5lJLWbcmn3MB6SYUlMYRuT6q7?=
 =?us-ascii?Q?r3np6k2DEsiGfGpj2dMchGX8C1edDa0vOJUl5YAmaympvoYegUyF0zqe9Q9q?=
 =?us-ascii?Q?/IjHLmC1rcQKUJtmZjbjLI4FhDPgpzZZ/ynpNRKSeel1QjTZQEHZpVy2XuNG?=
 =?us-ascii?Q?WkQFt5/UYTvCup1zCfuNYQVm8zJBJ2wl3Y+2WnOyWfISkpi2tNfoTdUHG2tI?=
 =?us-ascii?Q?iMp79X6um4QgW3jdzSN0UYvjWDo1cASALzHe44jCfAPMg/b8jkxrZdJ6CNAo?=
 =?us-ascii?Q?BzoJwYDO3h8e9bwL+NYvR/Ye5XGRMX9pDYlK/3wc0Ctrx/o1k3fA0XRpOvxf?=
 =?us-ascii?Q?N5eor+1fBVsCgERs7IUzp8Ha+ttrAI1sE8DGuc4oZ2HbFsnKPKbPnZTUUoFr?=
 =?us-ascii?Q?Nxja9U5cJpxdw+SOiNoVxHRZySdLLdtIqymhCorUcDo4dBda8jrjUVMilIbO?=
 =?us-ascii?Q?ZfJwCTbqDkOhDNDw5vFkC5Vuk/O8uOV6AS9xRNoAQNe08YiU6RJyBzzGWSwT?=
 =?us-ascii?Q?GxFsYEqxnx+uMYhLmRgQtfk35QfkhkDa8zzKd2jSHikaWlTOkWnjHCqAdmlF?=
 =?us-ascii?Q?EbnW3o9NaTp8RLJhADnjvsIEQ09kV9Q9Y7U8zQrI1PUWGrBO0XdiHBohGu93?=
 =?us-ascii?Q?+6IwUYY1NIkzt+4k+iDl/MiTgz5uA/lIjMS2ErqZQtiPO+I8gE8YYiviSawd?=
 =?us-ascii?Q?BNilCxLdMTRukU2VyiYb2ZQ1x+qHJPSQmZeh2xVp1iIuRl3mpVtcQ+ohFZnc?=
 =?us-ascii?Q?OcOse6WqGbFAmyfUy4abCJPzGgCz3kljKLGcIr9XHF8xloxrDew3UoyXrvXS?=
 =?us-ascii?Q?CQ1R0R8/k+WM215YfdiYBQoFwg2XM+9OT+EyKaYqq5+sUPBo4rdU+met5aSe?=
 =?us-ascii?Q?YyxmLLffNihATVEjxcTLyV1JXW+rJpZDbchDGj3ga/tW/C/qbo2r5PCrrMc/?=
 =?us-ascii?Q?N58vaxw32OXw+muPIZF2Y1bB7f5VYhMD7155l/BnyJMAUB/c9fDUZ0x7vyji?=
 =?us-ascii?Q?G/Z9Rar6ABOMhh+lWqrNASG6FtTayfibC6E90s07nJVjvtuPeln0H3LkLVd7?=
 =?us-ascii?Q?Ng/3EXvazHr4HF24amA2uBnqjRCWX80GvcO1HRUpNPoTlkC+cZWCZoHWDkBk?=
 =?us-ascii?Q?Y5PWwnB9OqFmDpDclkOGmiH/eQONQ6Dr+FuODzjuM/Hp8HMQcgdnsVHpe2OC?=
 =?us-ascii?Q?GDB32uGbMnHHtzpGQBtL1jf/2CQMRZE8bjegGJLEkWCSR9e1XrLlP4GUoYbO?=
 =?us-ascii?Q?x9RHMsOPGaqdmi01VskbrqJFMqYAxvf/AUpSAKqEnrCIYMuKXrp/mqr/X9z+?=
 =?us-ascii?Q?tcWL+2bIkJDz9PNoB8LtDF/ClWj3GX4g/eOWByZkVifNyS7eEs4+Fln+ae9s?=
 =?us-ascii?Q?ciIUxphEL0cJ8X2obfpoxgm7G9FP4tyRPrw7H1oQuIQnsD50tnoh+N+hQsdx?=
 =?us-ascii?Q?XAd3kZHG6867RUoe/1e6669l3eyDtPzW5yeKvtw+0SxImopL2HJ86oVb8Fdi?=
 =?us-ascii?Q?xjJMzy3mlhTqsMxPJa55ucbZQw8Ly8ihV992XMgZSQ5GC5Kq72RNrI6Mm/dN?=
 =?us-ascii?Q?uLJuFKYURHOvJ8sjGAS9v9kgTh03Y+e6vP+icBKc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e27ac94-1bf4-476d-f04c-08de36f54bfd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 07:33:50.4603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yf9L6iHZ0aiAWrbHi3wcjcyqLSr3l5jBf6PSxgw/hbYl4aIUVGALDRrVjCrbAcaDPrxTMy2iS5pyrwrksDbtCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4707
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 05:10:53PM -0800, Sean Christopherson wrote:
>Drop nr_configured_hkid and instead use ida_is_empty() to detect if any
>HKIDs have been allocated/configured.
>
>Suggested-by: Dan Williams <dan.j.williams@intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

