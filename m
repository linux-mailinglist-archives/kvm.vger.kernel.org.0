Return-Path: <kvm+bounces-63652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 44476C6C6BF
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 03:45:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1EF284E7124
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 02:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4BD29D26D;
	Wed, 19 Nov 2025 02:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gdbl/PxP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD22C1FBEA8;
	Wed, 19 Nov 2025 02:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763520318; cv=fail; b=Pww4sBaRS8N3tYqYVZJp8ycA7CvmV5c0KvxsMobMp8wamAO/DwEOGcF1lCol2QyUJJ1dU9qMU12BwdOjSwsqQV0hXAsDykM5j5J0MEQgjUjNiV84j8Az+IWQZSEPVJ3E3L4/70y/ekaZSV+Y9YSz1XJ9iWJi1wGPWJ1tXFXGnZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763520318; c=relaxed/simple;
	bh=9cDasjNRLxjTazxam2m3Omdh6bLQ0VDdQ6VN663KmTM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=p2kfU/jDWrCFodp1sx7z/NsDiiO9vuOgx3lGwpgLPcckLl2IelbuYiOVNupnucor4HSuCifD0LPGEzpiBuSo2D8upbQJvNm2JVznuysiZINVr2SifcWplOMBVepn3vSX48xlE3RzN23/6N3BVDUe3YmDTXT7z6sTh/sdTuIURZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gdbl/PxP; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763520317; x=1795056317;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9cDasjNRLxjTazxam2m3Omdh6bLQ0VDdQ6VN663KmTM=;
  b=Gdbl/PxPx573RQK6GHonHrUoYubbPgHaKUhGSGd6MIunSwunelhRAEv6
   falZZyROQXD7yuFpUQ1f16dEiSakZSTKbYP1gw8eQFUPzxCCE/vQDat3a
   B3ga/Y9Rkz4S0SuBCbMEYkk7v+Lt/CcOeZQ7jsHAIoYlfl/ea0MgQaAn4
   El0gESVWm4vD7WN7ZoWhn572tY81YoqNQTwOCp4IhOagCSt05KLsc8nkk
   nKdLte9DQ3/XTgMWtiY8mDWIck6XFm0WcqdUrWf39Aq1MXdwv2gBEj6ZE
   SLhDaYaRiwZzNZCiU0pQA/aiYvT42iaOlgEgM5cFMfl3IF7me0v6IU9jw
   Q==;
X-CSE-ConnectionGUID: 88tV1sqWRxGtuEAFfxKx6A==
X-CSE-MsgGUID: 9R19e6uiTU+loIXTGSVCJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="82945363"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="82945363"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 18:45:17 -0800
X-CSE-ConnectionGUID: uRmmIKsMQcm8W3k7r9th+Q==
X-CSE-MsgGUID: ENiWMFlvRfCDpqu5zvqwog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="190583709"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 18:45:15 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 18:45:14 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 18:45:14 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.61) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 18:45:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mprrfqf3c3Ius8McY4SNT72tVrBZVZjluoGARXk7aqnidyk+IFOWsU2VZXa/UUy/y2NPd5cSlxFGHSzYkje6US0kbwYde9tAAlkbhP4nKz2j26BosM0zOqY3hBXNKEQjSSfCnrYBSzJQ4Ryry7B/1dYikucSDdBrqCWLiRIqQuMLJePzbhTXiwV/tI4Kn6FSJzvb0zTAOaMxNLI6pSu72oZaCf+F5lpHBFPIOEHEaOHqgraOIN0iYBYkkWWjNfuWGih8ppIX5CFTS7znCkty8T9xoRN/bNkQ06WhmoGQNoUy1r/8wE6Nh4V3zfZrVTZstIvKO7MM1jzi8GFuxjNxPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yh++ChXASuBb3b4F8/n/6ZUAjyqckXaasaIyu9ERpRk=;
 b=EGJJBJjkmv0fe9l20YrLBJe9VdpNRpDyIUbMRw5lE7Gq1FQI0S6HkKrmlg7Mgdf87S/uNeUnYTPyhrvAryqhe2z8UXbhT1lKeutP3xG2RLGZuvBVmn1LZD0qXCn0yrwdBEGBTMmK7b6mLkvh6weJOqFLaphdtc0uwc84EsJ1PBrWxAeZdp196Du0aZD/NKyv7ME9NrFTIw9HMIF+wzhpmZflnLkLTwx925V+Cjs7bnV6BJ4+M+d6Y1cmNtqVdY+XHxBDK5+x8Jp2+e/zWx2XDHXwFy9sFS00LV/741fTLQ0lcid1BWd4mBCiGzW+9EY1+fRCl/CntOSvZQNh3Pelaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH3PPF2CAD058EC.namprd11.prod.outlook.com (2603:10b6:518:1::d12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 02:45:12 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 02:45:12 +0000
Date: Wed, 19 Nov 2025 10:44:59 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 07/22] KVM: VMX: Initialize VMCS FRED fields
Message-ID: <aR0vK3z1owwM8X8H@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-8-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-8-xin@zytor.com>
X-ClientProxiedBy: KUZPR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:d10:33::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH3PPF2CAD058EC:EE_
X-MS-Office365-Filtering-Correlation-Id: 87b7003f-530a-40a7-6bd0-08de2715a8ce
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5FiuZVAvCvab84QlyuW3noZj00IsXcSXRL33ut5KAPYCqfHAaiZk0VUKrOYC?=
 =?us-ascii?Q?fp+Tb3ys8jBeTGoyR4w6LeG1YsU/5TcAF5QUWjjPNQ815djjBxZbeTmasS+8?=
 =?us-ascii?Q?NJ7GUKDrZ7zp5XzAxnLm5t856QcTKx+ljMO4jzGKPfFEwoK30rOEiy0I/Any?=
 =?us-ascii?Q?0i5rvDP/OzGdb09RGQWHvR1J01Wuzwoo+ttSr5UdQtk57w4v4cPypFA6T2Md?=
 =?us-ascii?Q?Ops7YRCtW1D45DwOkMxajb/LFls9L0+h2Wq7BCoox0cK6p7zK4ULvd+lyRO0?=
 =?us-ascii?Q?xgOFjZT5jA1hlh+n45ny+9a+g8MUJfNv1L8KyFrqJ6ia5pDyPQNFJtTr1v3/?=
 =?us-ascii?Q?3VCQfSb2bidsByn5hCevkg5ajri25DE4wOwfBveoID1w+iUgkp69dGi8fMwH?=
 =?us-ascii?Q?7OHIXSb1nB/1q8t+IYQJchGewxxNufaM/W1eAaldKE6vAvb2ljY5G5Y3GgOU?=
 =?us-ascii?Q?IY9E0qWvfwNLjx3PMfUJ/SkOsyPmlkiDHe7KTYI61TMjOQFDyyBYhy0J3FMd?=
 =?us-ascii?Q?rUZ43oOKOT/QekDVA7YEeRsqAsAV/TzJXneluLUA08a07joJ30pDGiNwQ0J8?=
 =?us-ascii?Q?GoJ7rHkhjfsnfhUXqSN2iYVeUCE2G9cu4U/2r3KHhTkDAodejuoJFrxpCtkU?=
 =?us-ascii?Q?NZTAo1Ma3k0AUnRhgdfVFBNXQ3lne815Ih0e7iW2MErO/eHPBWl8nM0lEeiG?=
 =?us-ascii?Q?vfCdoC+bAdM9tiwbWk9vRBKyS3ufrQi0dvAvw+rNSUoIPSils+FCIhkCYg+u?=
 =?us-ascii?Q?1Wlu8d51ryN6EiYQ7x17MZiv2pIs4qaZ8IDwepORd17dikmb623w6xJv/Ay2?=
 =?us-ascii?Q?VPPdO+aYfzb/oqP6mMY5J5A9fN/MYtGiioGRKRP698+K5ybUA7v7bIBhrz3Y?=
 =?us-ascii?Q?6Z6jPTf50bU8y4O4SZtcuqBQymgyQLdMl2NSQm3d4U2O+skKyBPrvGLWJEGb?=
 =?us-ascii?Q?TMPoU7qgsXbgKbBwDneUfnrlWK4FXlCWDZ69BGIFn5cGP54/DBBPYdDCOw2E?=
 =?us-ascii?Q?HH98ovwvXlBHyOZgiA6RcibScjnDAtdJgyw5xteJ8na9Zz62tf7thhEq0vIA?=
 =?us-ascii?Q?9Eo3IjmxIcLbfCmcLrJIQOxlOzGbpJOql2F9QrPE+cek+wjtbRWze/oxv1PE?=
 =?us-ascii?Q?S4Rwi8MM3PKwkaIr+MfYVpvGbF4bpF21Fwag6lj0rwkUHpKWhHkJSo4kMBgV?=
 =?us-ascii?Q?umsGycUvzzEuw1OO6VgljecAEzBwDXOVb1bn5ahzG8S6FfE1nPglTQwR280o?=
 =?us-ascii?Q?DFqLKFghSBWBlJo6kYdsP//6NlmGn8E0UXZmfzah3Q+D8mV0P8kRnvdkOx0N?=
 =?us-ascii?Q?M0cszkqFI54x4r8R7Hru957fnojQEqLemFZ34zmlpwKpNeYQS8KhZ4QjOozU?=
 =?us-ascii?Q?9baBB5m9Oo4pXo7NtCEpDADO+9GJ/FEyyLjSao3boVADWVLT5erQ1QDr/K3N?=
 =?us-ascii?Q?G5QCeEQ1iGMMJfJZYeUr0EC0KuDVsOi9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BX0RMnjB+gvtORH3tZXZz4sJLQCRfXsquyZilusgFvXsWVmhc6MjfB4j++Vk?=
 =?us-ascii?Q?KFAQ8/6YUhICech0aZeM0EHwOinZCOQqspnCQv6YPl+TC22z22T5QDSLPXUi?=
 =?us-ascii?Q?3arJbxVYvvlyE2MGAPmlI3MNe0wAK7J7g2QmF19wfaJmwEKDItHRetx4hAEx?=
 =?us-ascii?Q?Vdf0/A7OGmHgZvV+8hGSizvnIvcHwBCA+Wi/UbGkkPmVfOn7fa1wsxBG7R+K?=
 =?us-ascii?Q?PhJn374UhMJ22JLfaPvMt2VUjTDYm9L8M3AE0cgF1liYCxBCVR+JRs0+R9HA?=
 =?us-ascii?Q?Xbt00PDyadG9Gn/B4Hg1TOXpDlFpaL+iMi3PMGCg/GIVmJs7xTcSol9LX4So?=
 =?us-ascii?Q?NpmCB/tBhvk08T2Vlo2WKONsg6J2gmRr7YDiYmec8+dWcLx7XK38MkCs5xgF?=
 =?us-ascii?Q?ovlz96Q7annyxE6pEGbr0yO5d+aD6VLpujfKgS20KN6uuJGMC+OsnEYI04BK?=
 =?us-ascii?Q?VgGWZaMuhQucEne2byFmTUoAB/XqP96SM/caFtSpXEj7rRWeEmK//knCfZFQ?=
 =?us-ascii?Q?cuO4dbeYwHFzyAXcoW6wHmvnNXbioNqIPiimbC85uCOKm5Z2bvFSwJjGdg25?=
 =?us-ascii?Q?KTcj+B8ELxFrCcF/9IThLGZnbr4lEXEnsL3YgrM4U8yBhQpkOCK6GvtA8EtP?=
 =?us-ascii?Q?rd34FVYeNxhc9PJ8jagx3qIah3QPuPo0K7KuWiX2dsuAsTAW/OreCwFU0/0F?=
 =?us-ascii?Q?Y5pLe4v0daaeGRreiQtmslQPMM2jYaU8p3TfA0sgo7cORGGRUtgY3hk39Vfw?=
 =?us-ascii?Q?rYP5vQ+SATcJ0N0Xn9OT2vPE0Y8cBvdzL4g7c14K9oXLE3kAy9AhS4Fb+Y1W?=
 =?us-ascii?Q?p79OwIrIJE0s4L9OngBGACYknfpYBkjZM8P1uVEJ06xqDuQaA/lw6ssW5F34?=
 =?us-ascii?Q?rKgbiVvupQLeGXSPvAM50/o4Ach05vPDGE3He2Kj5lCqaoDrD+hRJ2Em2tDt?=
 =?us-ascii?Q?oTTVSuTpSZT0lpbEhYiKLFxPUnaNsEmDOpu+tjok00HJqfikms5h4uuJeI1l?=
 =?us-ascii?Q?/w0M3yBEx19F3NKNV35giPiW8Al6nVOdiz0le79ntm67mhNOJ48OgYgY28en?=
 =?us-ascii?Q?/Iaf74Spr3EzMvZ9wJYJOrOaBbVEggsEhK39l5lltNpUb96214yx/hX1RISm?=
 =?us-ascii?Q?mQZWrP6dzrqP1Nmhr7uSpUaity1hi8P1UWf7gNL8AxKzaYrKKcrODuUURw1c?=
 =?us-ascii?Q?1pQUQOVJV/Gy9+Z7Hy83BE+MQJdLhmaxPzn16QOj8CpkbhrCFcCvzEmh2ROI?=
 =?us-ascii?Q?G+M7eIzg4CfcYjE+En1bHeblA54ZDvrFXZ+OoK/PIsxrrJpdMSzKayLU92wN?=
 =?us-ascii?Q?NOl8+KWusmdDPT+vsrxdgiebxm9OVauQdSfIkWjrj46r6w+j0IMGM4Cj7m36?=
 =?us-ascii?Q?t1UADPoIQK+pVe1ysl6pUGJWVZMz2t1J5XGQB41l+03MVWhhbpQRRmRX6OKH?=
 =?us-ascii?Q?UkOQ3supJyg/OIDSlyUdgl/WE+wQrcWvKzpYf5p5xOkDg/cC1sSPclBxaFaR?=
 =?us-ascii?Q?qcPoer+OKnmafsP6p8IIUGO7QsYonMmd+N8cN3xTM2a/NKiWmQ+gxTEy12y7?=
 =?us-ascii?Q?HTtA4EMi67VdVtZz9dOV1sbMR64vn/wbMHOlyxb0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b7003f-530a-40a7-6bd0-08de2715a8ce
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 02:45:11.9730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymcvjOiGZ9TJZ1Jk4qwlwiEud9kVzLQUvDa7WaBDlxVVeke+9R+ZWcJjvfH7wwoKx0VFMR2wS3DttJRwEY42Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF2CAD058EC
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:18:55PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Initialize host VMCS FRED fields with host FRED MSRs' value and
>guest VMCS FRED fields to 0.
>
>FRED CPU state is managed in 9 new FRED MSRs:
>        IA32_FRED_CONFIG,
>        IA32_FRED_STKLVLS,
>        IA32_FRED_RSP0,
>        IA32_FRED_RSP1,
>        IA32_FRED_RSP2,
>        IA32_FRED_RSP3,
>        IA32_FRED_SSP1,
>        IA32_FRED_SSP2,
>        IA32_FRED_SSP3,
>as well as a few existing CPU registers and MSRs:
>        CR4.FRED,
>        IA32_STAR,
>        IA32_KERNEL_GS_BASE,
>        IA32_PL0_SSP (also known as IA32_FRED_SSP0).
>
>CR4, IA32_KERNEL_GS_BASE and IA32_STAR are already well managed.
>Except IA32_FRED_RSP0 and IA32_FRED_SSP0, all other FRED CPU state
>MSRs have corresponding VMCS fields in both the host-state and
>guest-state areas.  So KVM just needs to initialize them, and with
>proper VM entry/exit FRED controls, a FRED CPU will keep tracking
>host and guest FRED CPU state in VMCS automatically.
>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

one nit below,

>@@ -8717,6 +8748,11 @@ __init int vmx_hardware_setup(void)
> 
> 	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
> 
>+	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
>+		rdmsrl(MSR_IA32_FRED_CONFIG, kvm_host.fred_config);
>+		rdmsrl(MSR_IA32_FRED_STKLVLS, kvm_host.fred_stklvls);

s/rdmsrl/rdmsrq

>+	}
>+
> 	return r;
> }
> 
>diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>index f3dc77f006f9..0c1fbf75442b 100644
>--- a/arch/x86/kvm/x86.h
>+++ b/arch/x86/kvm/x86.h
>@@ -52,6 +52,9 @@ struct kvm_host_values {
> 	u64 xss;
> 	u64 s_cet;
> 	u64 arch_capabilities;
>+
>+	u64 fred_config;
>+	u64 fred_stklvls;
> };
> 
> void kvm_spurious_fault(void);
>-- 
>2.51.0
>

