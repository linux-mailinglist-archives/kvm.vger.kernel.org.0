Return-Path: <kvm+bounces-22538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6E9940525
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 04:30:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAB7AB21617
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 02:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7AB191F7E;
	Tue, 30 Jul 2024 02:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mRVehLle"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA3F16132E;
	Tue, 30 Jul 2024 02:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722306411; cv=fail; b=iJuKbHbCD+eb5/S7p8/aoQQyaxIH11nPKxFSMJFGmUyk8SPCZz4mLe9KPJAh/l+QRlBkx10VfRXht/y32BIHaYp60oIfonDWuVJl8gtaUvwChLB1G8oyPmp/gU+lvl362RoJaD5WR/VfVWcdgPqqriOeRGAkpjDV4A7cBpsJfOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722306411; c=relaxed/simple;
	bh=1xeWX0y2XxJTBsq13L93pUH7vxvTZ4UON1IhPxY6vpo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b1Tt+Tm+p7mOOYQz27JjB66gQjkkDm4SzlisPx3weAHg+jEc57yMmkVLcIuIPnwOFf5te36IwdIfTAVz55hj0fOhb4H7HQF22OkxMeivl+qwvm5pdyzC/yjJK3DQphuEi2L8nkV5fHpMDIocnh1/KkJ5GNg20Y54d8FYqa80ZF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mRVehLle; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722306406; x=1753842406;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1xeWX0y2XxJTBsq13L93pUH7vxvTZ4UON1IhPxY6vpo=;
  b=mRVehLleRnHpf2q+araQoC5mqvZiUToh/oJ6BaCSIjyXEuQGqt5Iubpa
   /Ip+5n5NqI/ByV9LkhwymyqQJz8kSHH4bF1823+XIz0T0D/FYxbRq+j+P
   fw3BIYzHtvHowGA/Zra1dDULKQQ1rsVFrr16vgZdHSA9+QXldkRTs+fLD
   lRxoiEOpSkVIlOeyfKkG63GSLzsJgXdLAEcXxYa3PVLg/1eDYZKQnFLOJ
   noO0yU36jV888u5SVTy9O58ZqVAYydQgHPMeCcPf/VjHfTXqZWniG4FpB
   EFfIn09Yh6JtDPrlZbEVhFsR5YsBxskiKlZbnVpGV5iU/HDN0kYG84BAE
   g==;
X-CSE-ConnectionGUID: eJHt7ocuTFGj0CqfIxDA0g==
X-CSE-MsgGUID: +PxAUztYTGux5xUq7oVF4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11148"; a="45515524"
X-IronPort-AV: E=Sophos;i="6.09,247,1716274800"; 
   d="scan'208";a="45515524"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2024 19:26:45 -0700
X-CSE-ConnectionGUID: yemVIRGUTTemI+Vt6Iw2pQ==
X-CSE-MsgGUID: xJmlZVnDToOV91I2/E1Usw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,247,1716274800"; 
   d="scan'208";a="54428936"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Jul 2024 19:26:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 29 Jul 2024 19:26:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 29 Jul 2024 19:26:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 29 Jul 2024 19:26:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cCa0O+QhuaR1gRvv/5OiJ+KRBL1Nua8WAS/pygDm48duFYcf1kNDheEt4xhh04hKZfU3bFy4iqGTMlsEueCK+YbkBoWtS+A8zcls6KE2LNnSK12lFSuYOa4u4wLSmPR6Q2MYAD8R153+CxNeEgcci+tF/S1CG5divhwg9JSfggG4CqAJb214KtJG2kKsP+lzL8mg6Cmpu+3zogDRLmNgL3AndNWnfxw/19YMRFdXchY0R9TcP9Da786FYPlPoX3ruj3Q68+nQjzdjrnoc9Ui5dO3xLgQZUFJK4Yuq9ogf6g5APok+ZqWSq8iZh5L3bJ2ERpCraLV1oYI2UJSee9YmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+BcxvcC5+R7Uk7GIOufhv3I2A83SBz2SIgJwr/ZYmz0=;
 b=Zr+j53C5IAHigUk9mk6Dl1Avue5QY8jIqwa5TPWcCQduWMz2xner81Fku+TSUKG8MXOgEkiOONQajFQ8LJiL+YU5mIBn2uwxSfIcLl7VCaUFJy6Mxt90y7Z1rxunhdXaFeHF3lX2kbZD0RB4KNZ7a1rOHMitK3LuDgmvMRP+wI1KKIGCNOnPUHMp1PisPHr0SenCUqS20wrUzio8IaKUGMqZAffaeZH0Dpyi8K9+DLTxIpKRjFISB5KNEL+mHs8ws3c1Dvj5xBQPYSEXNFg94eoA6x4IfKxWs47ygOQv4HLqeme1UKzDtjSMYpTHQYc3YcnGUggHgaJGuaocR0Igiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB7922.namprd11.prod.outlook.com (2603:10b6:930:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Tue, 30 Jul
 2024 02:26:42 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.7807.026; Tue, 30 Jul 2024
 02:26:42 +0000
Date: Tue, 30 Jul 2024 10:26:30 +0800
From: Chao Gao <chao.gao@intel.com>
To: Suleiman Souhlal <suleiman@google.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <ssouhlal@freebsd.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Include host suspended time in steal time.
Message-ID: <ZqhPVnmD7XwFPHtW@chao-email>
References: <20240710074410.770409-1-suleiman@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240710074410.770409-1-suleiman@google.com>
X-ClientProxiedBy: SI2PR01CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB7922:EE_
X-MS-Office365-Filtering-Correlation-Id: ba5a93e7-32f2-43c7-6743-08dcb03f0c88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?D8RdrdOt4saI4guvnwuf6paMj+xrAaJsiV1rTmTq8rIU2GEXfi2QiRYsfsXK?=
 =?us-ascii?Q?qo82yJcF2+ZMxwkJYHVk1yEo5y1gcmiLxJLq3ejn7ulXM20d99gdtPfnDxV5?=
 =?us-ascii?Q?6P9GGLxDtIyc9dAOOr0jUKQPuYlJgg3x2Eo0LoEapsZHg9cuUMsDYJigKsI2?=
 =?us-ascii?Q?1DmW43o4rSHTMoH6D8DClJ9Hhu1chlziqWF2rZttLrFugMUWttbhuFh2GiVQ?=
 =?us-ascii?Q?XAipOUvjv/pdChz2DDHF77k8lFjePgqgQdV9LG7fXKZyG5fkE+raSQ4dgCo/?=
 =?us-ascii?Q?rz3hAihwXBCVUDmNvJLWyUCClM+S/gs1+4+kCqvyrmeMPbyzx+EaSaviMcMS?=
 =?us-ascii?Q?+HRO5g+XRhvxytlI/Rzb/nqI6VwHoDdvjVJfV+MTwq+q5w+l6CWaKaUyr5JG?=
 =?us-ascii?Q?6qa5hosdD3EqPh5RJAcz15mctD169j392ZQdp61CppIWdiS3rzUWhRSEF4YO?=
 =?us-ascii?Q?5ZdqFbV3qgo6XS4rFR42t7FXeb9Wilh3fbxUuotffdQW9T2IAhkIaL+vnar0?=
 =?us-ascii?Q?fr1Ds3NXjDcV5WirwylpS+IRp7lSTTg0kuEJzspyk6ADnvlsYXfJWHlek44W?=
 =?us-ascii?Q?i+thDt/FMZMcAuUZxm32ebebdOLnqoZBGJvfAaAtC+dHa7z7inSRsy8y8dY5?=
 =?us-ascii?Q?g2pg3zIqUBZvi6CjVDalCoRqfivNHnAFMYvU96jZvqnob+kOKHtTty3tJuAT?=
 =?us-ascii?Q?ZmwqEqMbB8AmCfinwFlhbU5L+eHwAvTM1Oal+0fmA/YK5pkzhuSLZ4sTUHgT?=
 =?us-ascii?Q?LS6yLMUWWDgpcvyekOMtiR625ctBLcGw+9NMm4nQ+mrBADl+VpGc7Vts5VPq?=
 =?us-ascii?Q?nYRaqg1yLo3WdoxkLQRXy2jBF3BMEEbYIyhaQUEtyy5Phb4s/TcjPgbELd+Z?=
 =?us-ascii?Q?4BYAJFfy55e71ESJchcBsY+pBbRjt4jRINQLqqutLod5KTn5TSTwcN1lNdG2?=
 =?us-ascii?Q?x1VH5T9y9Hu5fHpqphOYPCzaJCXqZua/ZHOu2+8tmVP2qtQWOtvbwOKygTsb?=
 =?us-ascii?Q?cQ3HOdulEM27UgtzTlyFBDywRfIIRR5934+zIdpTpAE9laDlDe2j25/qEqdk?=
 =?us-ascii?Q?s+SlFcKdoLZmRPJkPyGIEVzOe8sLKg80fMe3VjRCn9b10nIbb9YJlgTghXL9?=
 =?us-ascii?Q?Tp3Z6axx75nUvia19V3xzQ2vmU1Iel5wuUifMNVjSvPTTWM+y1f8Wfv+p/Q1?=
 =?us-ascii?Q?hhkxk5eMVu1T9j36kmKDj2LKWoTMsxqsM6yY3iwHgymTJXmrWadTGs0xHUsN?=
 =?us-ascii?Q?IsKYFK2A7A9w7zAqTG2WATXNVKeuZ0LBUApKnIxWRZ+CjhJ2DMu1YA8DdePc?=
 =?us-ascii?Q?oMbpeESu+kbFzaFXOrgigynmPpljzsxmY/uKtOkGS4eHYw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rjy8sQ7MAIpqSo6HLSjRwnsvMWzpLp9oHz74XMczHgQHgxSzyysatVcA2/Ou?=
 =?us-ascii?Q?1quDuWI5WOc6+BlKH5Uf4eu8dHIMfxg1xNgEJZBAw0UOk2DelX/XRX9G564V?=
 =?us-ascii?Q?c4HF3VSQ6gGQFIS4oYuWQaXoSFHrcU1S6g38u5V4kH0euSPG556iJ1Hm/N0V?=
 =?us-ascii?Q?W2LYb3GSdpqfxFhdfAgtQtBU4UdUEAbSQlWZSKU47aYXaWUyQWlcHB4/ynrV?=
 =?us-ascii?Q?k7R2e1ysBoghr3vx5nF2XpTbySVfFVZNECYPtPhkw20LL/DniQAB+FDuD1XA?=
 =?us-ascii?Q?qy7jd50uWdHpSbbmANTykfowIvqa0x/3Ko22VBAyawEMhP/N0GhZVJYsY7MP?=
 =?us-ascii?Q?r3Aem/ffUMUJ3VBCh7qAMkdQOf1xALDiGctDuIie1gxufTED0F6Ypar+iUZe?=
 =?us-ascii?Q?zmy81iBXGkZKkDssgTC2HfFZBtFAj55Ra1b+kjK5EeX9nBLJhQw9/1sa3T8k?=
 =?us-ascii?Q?s9fKCb7Yfreg5vH2D7txdqYNf8UqXsJ07HvECSKbiwaCBWYkpjpDuNSRZZF6?=
 =?us-ascii?Q?hpDhrSpwu0m27M322Q6OYYKiU/te3+n33mVpTvBzxVz/Mz/i99XHqIBrX9gs?=
 =?us-ascii?Q?2YJk0iLpPju+qD/xTgi6jzK0cnJwKQBBegIrIn//taQw/XAPimaJ8lMBMFW5?=
 =?us-ascii?Q?LGGtaTeJvt+BdWF2ScfbJX5wV0PyKSc//BLo1Gsuz4IkUHrtszMthXhW9UaV?=
 =?us-ascii?Q?SaMaoU/uxHgW/+Ku4QU5HJ7qF9XhvTI0Pl33BdISn98Q1B8A669BohjwAj4n?=
 =?us-ascii?Q?CfLyV2ZP95uLJqFKp2Z0xjeYlxxLcA2KFBcF5mnkpnPH4GEbonu8vOcx22/9?=
 =?us-ascii?Q?aAd/B/D9tLrRmNw7hYWKGp6u08XEO+BsHXpGnkOLujODo4DxMpJjU6QcYLJT?=
 =?us-ascii?Q?pS6XjJAs0/2KftquWD0U146v3sIqFmAL4/x5ddYKeVjiEGJYMyCcMGuvrv+e?=
 =?us-ascii?Q?bCXlq+RfopgTuyyockSBuAyQT3GUm7bmcN1xdUwApB48PnlaW/EIZDCod1BP?=
 =?us-ascii?Q?n/eQXBU2Yfb3x8GtSv77+L531kw8kj3GhEEEfpYQXh58H6fbCVKaU9O5L22l?=
 =?us-ascii?Q?LlNu57SiHnAzeTG2fgzBlbYV3xY+hzp34lm4yt9CyYbuMD3X/6h+hWoCR+py?=
 =?us-ascii?Q?3qYYjIdnsxAVYI8imuMar70v6XsRpa8TLBp4jemukY+wlFvpA5WarQdCA32R?=
 =?us-ascii?Q?oRWr6nAxS+5rXhfK3GajsLYQfDzWvoXCAX9kt335M9LZCpCsCYnsB5eieDkx?=
 =?us-ascii?Q?o/6H9UQUIJs/PntIWMOEpo5WV3rbkf86nkZvqUKfwVGdYSA12OniSLwFx6Dm?=
 =?us-ascii?Q?8zN+ClE4pY5cuOSkVu7sK3vmuyJd+2R8R6D+pERAHCXgKj/5b/KW5XN8v/dk?=
 =?us-ascii?Q?YR06sGRfBKt7+wakJq+ImysFZXQVH6NLQgLcJjwFXiqVwcCvGyQ3wS0gx+aY?=
 =?us-ascii?Q?108b0eJr54b8/IWvAt6hl92z6WjD+Rm8BLt7Q19+j4scIX78RYkInuYircoX?=
 =?us-ascii?Q?iOZCGVzyJl6JrFCdz9Ye+ma8PfhBiWh1pMUYV4DoHAOplNDQdwg8CSohYFmy?=
 =?us-ascii?Q?xhHgCIE+MijojPCGC4kSZt/cJU19VVdjF8MN37ga?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba5a93e7-32f2-43c7-6743-08dcb03f0c88
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2024 02:26:42.3178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: maVdSTvUwu001xjSJst1Cvy+k+3mExBG2Gh/6m3XyzMrVJwxXkQb3S40L6rc3TEdl/O6uC+nk/gEdQu9Uu5sAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7922
X-OriginatorOrg: intel.com

Hi,

On Wed, Jul 10, 2024 at 04:44:10PM +0900, Suleiman Souhlal wrote:
>When the host resumes from a suspend, the guest thinks any task
>that was running during the suspend ran for a long time, even though
>the effective run time was much shorter, which can end up having
>negative effects with scheduling. This can be particularly noticeable
>if the guest task was RT, as it can end up getting throttled for a
>long time.
>
>To mitigate this issue, we include the time that the host was
>suspended in steal time, which lets the guest can subtract the
>duration from the tasks' runtime.
>
>Signed-off-by: Suleiman Souhlal <suleiman@google.com>
>---
> arch/x86/kvm/x86.c       | 23 ++++++++++++++++++++++-
> include/linux/kvm_host.h |  4 ++++
> 2 files changed, 26 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 0763a0f72a067f..94bbdeef843863 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -3669,7 +3669,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> 	struct kvm_steal_time __user *st;
> 	struct kvm_memslots *slots;
> 	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
>-	u64 steal;
>+	u64 steal, suspend_duration;
> 	u32 version;
> 
> 	if (kvm_xen_msr_enabled(vcpu->kvm)) {
>@@ -3696,6 +3696,12 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> 			return;
> 	}
> 
>+	suspend_duration = 0;
>+	if (READ_ONCE(vcpu->suspended)) {
>+		suspend_duration = vcpu->kvm->last_suspend_duration;
>+		vcpu->suspended = 0;

Can you explain why READ_ONCE() is necessary here, but WRITE_ONCE() isn't used
for clearing vcpu->suspended?

>+	}
>+
> 	st = (struct kvm_steal_time __user *)ghc->hva;
> 	/*
> 	 * Doing a TLB flush here, on the guest's behalf, can avoid
>@@ -3749,6 +3755,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> 	unsafe_get_user(steal, &st->steal, out);
> 	steal += current->sched_info.run_delay -
> 		vcpu->arch.st.last_steal;
>+	steal += suspend_duration;
> 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
> 	unsafe_put_user(steal, &st->steal, out);
> 
>@@ -6920,6 +6927,7 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
> 
> 	mutex_lock(&kvm->lock);
> 	kvm_for_each_vcpu(i, vcpu, kvm) {
>+		WRITE_ONCE(vcpu->suspended, 1);
> 		if (!vcpu->arch.pv_time.active)
> 			continue;
> 
>@@ -6932,15 +6940,28 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
> 	}
> 	mutex_unlock(&kvm->lock);
> 
>+	kvm->suspended_time = ktime_get_boottime_ns();
>+
> 	return ret ? NOTIFY_BAD : NOTIFY_DONE;
> }
> 
>+static int
>+kvm_arch_resume_notifier(struct kvm *kvm)
>+{
>+	kvm->last_suspend_duration = ktime_get_boottime_ns() -
>+	    kvm->suspended_time;

Is it possible that a vCPU doesn't get any chance to run (i.e., update steal
time) between two suspends? In this case, only the second suspend would be
recorded.

Maybe we need an infrastructure in the PM subsystem to record accumulated
suspended time. When updating steal time, KVM can add the additional suspended
time since the last update into steal_time (as how KVM deals with
current->sched_info.run_deley). This way, the scenario I mentioned above won't
be a problem and KVM needn't calculate the suspend duration for each guest. And
this approach can potentially benefit RISC-V and ARM as well, since they have
the same logic as x86 regarding steal_time.

Additionally, it seems that if a guest migrates to another system after a suspend
and before updating steal time, the suspended time is lost during migration. I'm
not sure if this is a practical issue.

