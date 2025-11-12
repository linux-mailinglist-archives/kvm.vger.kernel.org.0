Return-Path: <kvm+bounces-62834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 440BCC50A3A
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:50:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BA943B52DE
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 05:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95172C21FB;
	Wed, 12 Nov 2025 05:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AQmVsPbk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192EE29A309;
	Wed, 12 Nov 2025 05:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762926574; cv=fail; b=Zv0qXzB+OMvvrNw8MwqYFnmX00tOYK65Y8OzLkItU2FOBc/tXhxDAeyprH0RrO/8DYVraWDVXNUUqWkvosO8eFYnQtxozrBsAx445N3i9HsUf2wn1PxgmCr88fs1ZWZq7jWwXbE5VZr3XeC7u/fioXEdlhAEqttkjZnMl2TO98U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762926574; c=relaxed/simple;
	bh=vbXfEahk+CY6wAjLJIqw3rO9dT5TBbzQoozu6BGaoaY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OmlkoOaEQq2IpzvIlvQDF4E2Wc+Ht26gMk+qMKvIeHPZ9DZylsI8hnJO2T3KjMek9VFhj7e8H0wlENdmJTsYOkWVrCuB8m++Jm0M6KFVK0SGZTzeZaD1htqHi8aoCRK5Lmu6GxtwNRZmfF9KYDzS7zmeRa5sxVorHV+eQ+VcR+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AQmVsPbk; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762926573; x=1794462573;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vbXfEahk+CY6wAjLJIqw3rO9dT5TBbzQoozu6BGaoaY=;
  b=AQmVsPbkz2mX4jwk5Pb31lRz+zIyvfgoy5wfmNbT6XlRQaIF5tiVPO1Y
   JiTkgtddJeE1VzdcObqlcgaLStQzNQuVhaxTl+1MfgC8UFf7q0jZ5B1Ur
   DTNrn7G5l5wJaD0H/HsqL7yP8T/w53aPualWGtzVGOfHaB0Hz5dt1vuZB
   G1wP9E79mvx3GRbbLScZO9Haa3Vszvo01KqUS9hyVHwh/FsPR76dbU4mR
   MBbp5JsF6oREg10XbLhAcbaHuGVkmgs3ytYOI6ozY0k5k5YOfgbwQc5aL
   NyFW5cRGbnafiA6X+JQ0enOuZMSNHWUIMSvHtoyB9lJD1uJJcCm4xKMhO
   w==;
X-CSE-ConnectionGUID: 9OkeDwswRKe+Mfq+1uPDQQ==
X-CSE-MsgGUID: idaSANjpQi2wJtk9OXqBWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="82615033"
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="82615033"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 21:49:32 -0800
X-CSE-ConnectionGUID: C1cyyIIbTXKnY3G8wRPeyA==
X-CSE-MsgGUID: ONwegh5PSMqkI2uqW+avsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="194334386"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 21:49:32 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 21:49:31 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 21:49:31 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.69) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 21:49:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZUMp0b9nvqIcgnw50jLAx8dpyFke0+wROHtBRNcfrK+2pHzb90QFe0reTYmwRMFEvpEiwLg7HkP/5v6yNBbKEzh0ZUsXzZtKJcNu6PW/AHIYWjNH8q2xJpmVgRrp0aUHdeVZNxnDMx9HeCQ41DGLyTT8/LQ14IdfYXUyp8k2ARrAFSXpc3QkUBj3Jyu7LPyWmaOTFJFfIvAm4ngJqHYB9ABHyuHSNz4CyUpGOqXdWXGRwfVP4nshAgrZNDzTE+h+ZDHqXMliUsW8SdNLFjJBBaNiTYdNfuqhclsunn7kvxh1Ygqy8SVbvNaoZunWkaZDRlSd+f0tWy6EuqooMP4BNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51kGg5WDwpzL5Z3SIjSGROaUOXmvPCqwVTbbW8cam5g=;
 b=GPba54ppRUnlNGtKk6yk+kYJjt61o5Pf5BvgEmoDHrTTQsccEw0ata8yQouGRdiBrEljLTeH8nhk2bNTkxLy8vzwe3N3ek4TwbcBFHaVMEYkSVZQqTrLvaIjwjnOk7ypcDfelK/FWucDiQBzaHFoDrft0RtwGqzGMTkpoidua/LoEiV92yanLCVlHOEAAiMBKtoTRgkREzo7gdHPWpRMCdaCXgVFb8kFeRv7RX6x3hsUxmTKAYpzVmg4k5/syeCurw+0VFGlGMigBPUK9cWPsvs/46OH/9ks4x8eYCfGrsH2DvljvGvbQM5Lf2zM9sRxcJ/vaK6BVzJDDKgNAOMaHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY5PR11MB6342.namprd11.prod.outlook.com (2603:10b6:930:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 05:49:23 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 05:49:22 +0000
Date: Wed, 12 Nov 2025 13:49:10 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 08/22] KVM: VMX: Set FRED MSR intercepts
Message-ID: <aRQf1sQZ9Z3CTB8i@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-9-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-9-xin@zytor.com>
X-ClientProxiedBy: KL1PR0401CA0001.apcprd04.prod.outlook.com
 (2603:1096:820:f::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY5PR11MB6342:EE_
X-MS-Office365-Filtering-Correlation-Id: 108371ea-3037-49da-460a-08de21af3ad9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uqS+qHXQD5hPBvHDFFDvW5JMdB8DvYMGJNQalZppFsmsVl/sJ/banE7M11R7?=
 =?us-ascii?Q?RPFrt9NY4cdLivp55+gBaHQ8AcKeK4JzOjPKiRs0aCqeAzVz8J1maS5Gyw3t?=
 =?us-ascii?Q?fWRokgaFC3JEY0dftwAKZyzwD3DdI2wjXW6WMSa54hdKQ/9CUbr+Mzk3uTGX?=
 =?us-ascii?Q?DmrqRUv7a6ClxO05pkvq98fAUg2Hc1TdK7l5gW6m0IyzhTJYxYIjQTJ+WxfR?=
 =?us-ascii?Q?e0VDqYqGf3ngCOiNo69VOYneH9FBq5WnQkvHeS6O0kKq0Qw8e0+2bY2TXyvA?=
 =?us-ascii?Q?qZLpPlboh7ZfTaZlsGmqI82aK0uTgDNKRH2fOM3uFCCq2Ui+d7QDeaxbOcGJ?=
 =?us-ascii?Q?Bw2Tu4lD1FFyMv0NrB/OFPvzsmCkx56DsgYfUV+s/9ZRmQ8WMJZUvsaib1bu?=
 =?us-ascii?Q?dO1aaOou1tVNvoGJzJWxazNdtR81cK7u+vIPPgNzX7vWcE/ExQ1oz3PP103a?=
 =?us-ascii?Q?a44H039w+xivRYTTMv0Fy+mbVSZsipmZw/jmcIlmOUE/MmlrycUSkO8E16AJ?=
 =?us-ascii?Q?q0wFLuZGmg1ZOo5aobmIexWl49IfmVBfvV24TCEydKbUist7SgQkoQ6c368D?=
 =?us-ascii?Q?1CIA1TMlCVqVIhP4HWlFGUbT7qxbcLRIroQayfVRO7ZxJEfoKv+crkeFhY6/?=
 =?us-ascii?Q?Dwr6JwFNTwYB4949ZjjHOal9c0BFtxU+sCyWhP4mXaOhCWpGTaQMCDDZ6J90?=
 =?us-ascii?Q?Ndi9vMXUW4gxJlowQ91a1DC444c1iGq2WfA7Eb4b7rHuUWtgGJOhBBEjnqaP?=
 =?us-ascii?Q?e0itwzQwmXVI+EqqkRT3yc9FfpyCsx7UFgz/ceIStfU8bSUnmHBnH3WIgtHg?=
 =?us-ascii?Q?O6oeAqwUuuZZROF4UzmEdHg00mnX6sqCXrvntUH77EUjzVxVc0nVaGY0Efcn?=
 =?us-ascii?Q?GFhKC2MEmzCUa48Rd3eIt9JlBZUaxQqqrIqfGMeGxuHu0DC/ZPUvrlcbjphk?=
 =?us-ascii?Q?n8IjIQZNCC8v+t6WvS/IhUXs4V3ebmFyJXsB04swZWt24/dc28YF7harEm5V?=
 =?us-ascii?Q?enX7zfCYg69y6LOnbbXZrc7QzIsdQwtvZk+HdytcxgYJUsCN7Su7US5A8Ebd?=
 =?us-ascii?Q?YBHNSX+TyfhJ+FnR6b3HzoSo+XoMPhO4RSMTRpe12DzF4UrqA/RKNU8RNa+E?=
 =?us-ascii?Q?8NCt18hFIZxmo9XlW+eeAyZbcRGOFC/+V57Bx5U/ifto3rFq6+svhvM6G2RM?=
 =?us-ascii?Q?8afM8uVfeLWt0+vDzgdvafY9YhoWFojUdro0Hm+ATWTPAzHEZK5Zn1nD1Aip?=
 =?us-ascii?Q?Qo9P8My5W5bD2SefotjMGR02wsyxouJG6XAv/5VaIqLD133mPsPG7JzJDCEx?=
 =?us-ascii?Q?UUb5ftYejqGvkKvX0Q0cNGd1/+XOQqoG6UY9FeyZUlNHjyypwHWsfYnZKS3T?=
 =?us-ascii?Q?FiFj2HfUpT/atWafi8Dr9QINYdtf+hFxMBIa4zMGs+jK6c98ng+0rJkdNgf0?=
 =?us-ascii?Q?H/4Kf/B1eOB4R0eoMy/A37IisUIdzNrU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kU3+rgZ/X1g6fwP28FgXwNhDBwBeCXgsHf1/adkE5rtssTVFvoNbqYozvTf8?=
 =?us-ascii?Q?d9Pj79eOQiwvE/2rQj93+Cu3UBjGDGOVGjLJVTdZVL2dyMeugmdtSs5R1sF8?=
 =?us-ascii?Q?zv6/BMyfxJW6qTOsTFRj9AnAS6TPqASBsM1u0WMNtc7KsS5eJ3ASNtghKBwV?=
 =?us-ascii?Q?QbfynGCjdfc2XqlTJghKwr2hWAby7PsWFcNJIukuT81hsIV8Lhmh4SpyAOnr?=
 =?us-ascii?Q?mKGE+PT0TbMLvGKD5BSaRCWLLrF7pqlHGz/tbQrwunggjJJeHeYlHsNXpo7q?=
 =?us-ascii?Q?7n2QoUcT+gSZBJhayxAuLFQJRdd3GBTAOGFseg6vlHipu2z0ZeBOZbs+Yri2?=
 =?us-ascii?Q?ZmyjPw4P3DusIul67HowpWiJwPRMVIigP+PuBCfo5g2WH0M4G556YwsSFabq?=
 =?us-ascii?Q?ypvlK7bfcTx/14WjOgZZ+KyLWGXmq9BKgr54/kazYYJuaksRs3pZEMZLm3y2?=
 =?us-ascii?Q?92PPNPePAO4DfyfIv/YApcunqnFHTpExHIDHOSS/aCnkE/wlUJU1ZTGcmNFA?=
 =?us-ascii?Q?FE09+lh6UgnonuPQfWSLMPI40Mbp7Y20odNUlltZRChxALe6a1hZDKoYIOci?=
 =?us-ascii?Q?vKpz4sQpGdumbmsgZpNln02kyRx1eO1RMjpzhSrCjJBp1HdRK33BkkP6Yjsj?=
 =?us-ascii?Q?YccghGMGIBl9QLGenLAx5/XpIAnPgGyhYlPoRlTW+OuGftLo0v47kiPn4mK4?=
 =?us-ascii?Q?76uJgS+x3w5YvQkvSokD8Rg/GAOTJ6gi0dNXtpzXaVMi6YsRNFofjGtoI4oH?=
 =?us-ascii?Q?RXc3rjlA2QkTcFTnbFdLKlq3S9IFjqaamQWR2zeoT+MfbPY0oSdKOceBFWQM?=
 =?us-ascii?Q?eLggT7g9U1wi8i5bO1vrXXxAA4YiIii59b8jhad/3uJHaB+CgBvcXuW+cT7D?=
 =?us-ascii?Q?15lCxiICWtlIG/hJvVjkY8zv8LfQbHkPtCt+TcOEOKoS97F5djBWQrgUD16v?=
 =?us-ascii?Q?/ZwZVEVPkoJYnfUfkVSPGdIkmkm7TA+vrJbYIy2e1n7X6saPXKc1C+xDjhba?=
 =?us-ascii?Q?5hTKM6617GkUJfL4bRofmJXk47U7ir2/hse2LEXV6eNaKUKoX15ukxEXoaK2?=
 =?us-ascii?Q?DEUtc5dpCyJEr9j5gjCz+zsGVuRs5Pm+hHOtVr8RACQDjrTsh8amWvVCZ70Z?=
 =?us-ascii?Q?axtrQ0QyrTKneOhN/hL53PbO1VQ0eydJI8hC3rz2UB9f8Xt5y2c80vHJMVvH?=
 =?us-ascii?Q?jQVUp5czMlK4kUXzCm+A+uTBA0yofmmS4hCr07wglPsJEuYJ2M3W6Cl3nk2E?=
 =?us-ascii?Q?G9b/rfcb01OCmJUt5O9X90Au2IXXG9I5bHQL0RCFzItXmgksDjF2jzdgX+n2?=
 =?us-ascii?Q?B1QHDjEnTUJxNa1OP4jf4QJnBUVBJekMGuQBiAQCMYGOEZJlGJyzyzkLhvYI?=
 =?us-ascii?Q?/Jt1a2QyVCw4mtsr36SC4CwvrGfECPxHaLS3G98whDm6JXiEHKnw5JRzJuSn?=
 =?us-ascii?Q?dy0NFKiQmfgq4qljPtWDI0FlKf610slcuF9fkQMZMu4ePVEWeCTWPhkjdsfg?=
 =?us-ascii?Q?pmerwyfeWWFBKU4WNpiNiN4tvhtuFIYsstRueRL6VdT761ejQYOJR4OSXhsr?=
 =?us-ascii?Q?jHyMT8yiPF8COS+dIoywbP2NX07+RTGrDR+YoL0v?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 108371ea-3037-49da-460a-08de21af3ad9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 05:49:22.6512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8BI34eYVlfksgTf7pe1urh8ZNxd2blyfiwKu431uJQmOEvNBsn+SVDgT1AYm4VRNCxnNKc6eiKjhMQ97qOMb3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6342
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:18:56PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>On a userspace MSR filter change, set FRED MSR intercepts.
>
>The eight FRED MSRs, MSR_IA32_FRED_RSP[123], MSR_IA32_FRED_STKLVLS,
>MSR_IA32_FRED_SSP[123] and MSR_IA32_FRED_CONFIG, are all safe to
>passthrough, because each has a corresponding host and guest field
>in VMCS.

Sean prefers to pass through MSRs only when there is a reason to do that rather
than just because it is free. My thinking is that RSPs and SSPs are per-task
and are context-switched frequently, so we need to pass through them. But I am
not sure if there is a reason for STKLVLS and CONFIG.

[*] https://lore.kernel.org/all/aKTGVvOb8PZ7mzVr@google.com/

>
>Both MSR_IA32_FRED_RSP0 and MSR_IA32_FRED_SSP0 (aka MSR_IA32_PL0_SSP)
>are dedicated for userspace event delivery, IOW they are NOT used in
>any kernel event delivery and the execution of ERETS.  Thus KVM can
>run safely with guest values in the two MSRs.  As a result, save and
>restore of their guest values are deferred until vCPU context switch,
>Host MSR_IA32_FRED_RSP0 is restored upon returning to userspace, and
>Host MSR_IA32_PL0_SSP is managed with XRSTORS/XSAVES.
>
>Note, FRED SSP MSRs, including MSR_IA32_PL0_SSP, are available on
>any processor that enumerates FRED.  On processors that support FRED
>but not CET, FRED transitions do not use these MSRs, but they remain
>accessible via MSR instructions such as RDMSR and WRMSR.
>
>Intercept MSR_IA32_PL0_SSP when CET shadow stack is not supported,
>regardless of FRED support.  This ensures the guest value remains
>fully virtual and does not modify the hardware FRED SSP0 MSR.
>
>This behavior is consistent with the current setup in
>vmx_recalc_msr_intercepts(), so no change is needed to the interception
>logic for MSR_IA32_PL0_SSP.
>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>---
>
>Changes in v7:
>* Rewrite the changelog and comment, majorly for MSR_IA32_PL0_SSP.
>
>Changes in v5:
>* Skip execution of vmx_set_intercept_for_fred_msr() if FRED is
>  not available or enabled (Sean).
>* Use 'intercept' as the variable name to indicate whether MSR
>  interception should be enabled (Sean).
>* Add TB from Xuelian Guo.
>---
> arch/x86/kvm/vmx/vmx.c | 47 ++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 47 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index c8b5359123bf..ef9765779884 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -4146,6 +4146,51 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
> 	}
> }
> 
>+static void vmx_set_intercept_for_fred_msr(struct kvm_vcpu *vcpu)
>+{
>+	bool intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_FRED);
>+
>+	if (!kvm_cpu_cap_has(X86_FEATURE_FRED))
>+		return;
>+
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP1, MSR_TYPE_RW, intercept);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP2, MSR_TYPE_RW, intercept);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP3, MSR_TYPE_RW, intercept);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_STKLVLS, MSR_TYPE_RW, intercept);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP1, MSR_TYPE_RW, intercept);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP2, MSR_TYPE_RW, intercept);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP3, MSR_TYPE_RW, intercept);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_CONFIG, MSR_TYPE_RW, intercept);
>+
>+	/*
>+	 * MSR_IA32_FRED_RSP0 and MSR_IA32_PL0_SSP (aka MSR_IA32_FRED_SSP0) are
>+	 * designed for event delivery while executing in userspace.  Since KVM
>+	 * operates entirely in kernel mode (CPL is always 0 after any VM exit),
>+	 * it can safely retain and operate with guest-defined values for these
>+	 * MSRs.
>+	 *
>+	 * As a result, interception of MSR_IA32_FRED_RSP0 and MSR_IA32_PL0_SSP
>+	 * is unnecessary.

I think it would be slightly better to document why MSRs need to be passed
through rather than just why it is safe to pass through.

>+	 *
>+	 * Note: Saving and restoring MSR_IA32_PL0_SSP is part of CET supervisor
>+	 * context management.  However, FRED SSP MSRs, including MSR_IA32_PL0_SSP,
>+	 * are available on any processor that enumerates FRED.
>+	 *
>+	 * On processors that support FRED but not CET, FRED transitions do not
>+	 * use these MSRs, but they remain accessible via MSR instructions such
>+	 * as RDMSR and WRMSR.
>+	 *
>+	 * Intercept MSR_IA32_PL0_SSP when CET shadow stack is not supported,
>+	 * regardless of FRED support.  This ensures the guest value remains
>+	 * fully virtual and does not modify the hardware FRED SSP0 MSR.

Modifying the hardware MSR itself isn't a problem. The problem is that the
MSR isn't supposed to be accessed frequently in the guest if CET isn't
supported and will never be accessed via XSAVES. So, there is no good reason
to pass through it. And passing through the MSR means KVM needs to
context-switch it along with vcpu load/put, i.e., more code and complexity.

>+	 *
>+	 * This behavior is consistent with the current setup in
>+	 * vmx_recalc_msr_intercepts(), so no change is needed to the interception
>+	 * logic for MSR_IA32_PL0_SSP.
>+	 */
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW, intercept);
>+}
>+

