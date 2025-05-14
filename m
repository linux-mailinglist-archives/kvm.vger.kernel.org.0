Return-Path: <kvm+bounces-46417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DED7AB62D1
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 08:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2882D862957
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 06:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099D21F6679;
	Wed, 14 May 2025 06:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aD27PVho"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ECD14B965;
	Wed, 14 May 2025 06:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747203324; cv=fail; b=bQpEy3EapOA7keDfGt9WVpWtkxDq0E6J0TMfeRNAUYROrxMm2u0m4YP3TZI60hcUQpBKcesMERyi4LMP+GbphSylLWPUsy/yezFcg+PPiDPCeajt/Sw0fXnu7NUd2Hk73YOIB6AoTNXJbMjSXQzBMJWXYBycd639ONs5e13VlT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747203324; c=relaxed/simple;
	bh=9AmM+eDjfJ5pJ93v9xJ7rd7FcFiczbArNNLUes6y6OQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AniiWg2eAsmZzytszMF5RtfSM0YcRzJjnAq+81rwCYmSy8Okl8Kfu8luuZTBLpdmJoJ/alQzAeb+H6/gzCIY1sUJc0iX7wEScqFJlB555rsQCziecQFykXsFADQPJyD/uoqfO/k4iUQxD1Jo+y/fiQu52IKYLTy97Tf0HXqoACw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aD27PVho; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747203322; x=1778739322;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9AmM+eDjfJ5pJ93v9xJ7rd7FcFiczbArNNLUes6y6OQ=;
  b=aD27PVhoRVNaPIiL1A3mXOd9Vdq1DJgfDaFrH7cnSEno+WVA4ez28OQk
   5CjXHeIgzPqhOfB4cTGuQL87tKNPmCSU8GbyUhm1eqLcLeJQII/78rUds
   5uG+lfrP3nddFVoOQyvOfTrYRUwg0anI4NfBt5PXZRmFlhkLJwDRK8vE+
   rSJh5/26H0Tnz0/p2wLgZKW/hVQ5L2INXT2J++Ge7G9yWyfEKAuaHbfYo
   JEhkCW1iaG/aBsMj524j/b97a1ZNJdeXv9wBaAw+eHyqkdwHhIXXGjcv7
   RQE//Y85xiKcO+wMPDjS0c2IemIOleneQvBaK0p/aZLKOBhtC2VMWO/nh
   w==;
X-CSE-ConnectionGUID: 874Ec0sBT3WfCtSApm5QxA==
X-CSE-MsgGUID: liV91FUNQmy2pWKtS7tqVw==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49199451"
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="49199451"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 23:15:21 -0700
X-CSE-ConnectionGUID: zDrCltyJTluuPkyVf4SAaw==
X-CSE-MsgGUID: shfjlQ49Qa6uXqXfpKbjZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="138924538"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 23:15:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 23:15:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 23:15:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 23:15:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sFDxPbxba+zTXiLaMUFthsxonXUfxvkB7m1UJrmS34Oi2lZd1FvgJdkLPCRhtwF+W11XVc9RJlYI/KKrS7M53hdmfXSPeNNlKvCB9/iwWmBl0X3AVWNRRzQtLFWEiEaGrMXnHgd3eE4zz6PznqslMWyDExbFbTBzCPiS6jlZQuBq2EYh4BaXend8fj0OIN3Xvu/q1XJYeGmnaJitrqs587joo0rBLzN3WeXsmHId1rYnNLLFaoT6Xp7/havlGqb3tNmIT3kSl3SpeDo6yw+rLkPpn5i8BoD/WclfQhDve/BuI3l9DIlublX5gJlUL42IjiROzR+rorD2+eHRweqm8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05koPOluBBsMPPhdSI1ihwooCnN2Gn5tEfIKB3jkeDw=;
 b=aw3HreclAXy8IeywvZKFJgdNjD/5zo/X5utHZxLBK3f0hnWrZu6N712S2C9v/Tg5Kpc1ftjydEmpdvcTc3Q4MeoQeRJTHgcGb3ICV8V5LAE2YUph/FFi8/908NiqWAmbtIUxNF8rr2/c+ZLPEmn1WPRwQyuCTm7OQdMbkQmas16023TBf1si5GCykb35tATxrDA2wuWvOLp/wv9D6Y29UUZn8RksH830ykRXhvzKgoQIDuH2A2xiBTGy5j718Biyrp308qN52f4bP8YzP1PupwiRcIdR1wlb1jgiINokg0ENaWap/8i4oB0rftdOpw/DD0o2AVSXkHEORoJ7Upax8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA0PR11MB7956.namprd11.prod.outlook.com (2603:10b6:208:40b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 06:15:13 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Wed, 14 May 2025
 06:15:13 +0000
Date: Wed, 14 May 2025 14:15:01 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <rick.p.edgecombe@intel.com>,
	<isaku.yamahata@intel.com>, <kai.huang@intel.com>, <yan.y.zhao@intel.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Message-ID: <aCQ05eUM+U9N2bZ7@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
X-ClientProxiedBy: KL1PR01CA0129.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA0PR11MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: b1aed4b7-1a94-40b7-bee0-08dd92aeafcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?XfifdR9tLhZy+YOwZryffGrzWyF3cXr4Z72zgTwL2yaFAgpbq88wmMdqQ6Jc?=
 =?us-ascii?Q?DTyeENdnGURzM87BfHFlBb8NGqKcKUue93K9X8kDd+QkSIJQNWawRbIfUd/u?=
 =?us-ascii?Q?ktfeeQ2Hw1t1l6hsgovmnGzSVqAEo2mKz4s+rcST/E+UGiKy1ILpW4CnTs61?=
 =?us-ascii?Q?UmM5pKfS7hqquJf2xFb0v6wIAphp9vn9lfkRyPPfBLk0ICTI/udI2NyJcq65?=
 =?us-ascii?Q?0b0uHfI00ThyY6yd6hiTcbT+k/UejiziLw68zLBjR26QJ/TaIQlUlkH9eRv4?=
 =?us-ascii?Q?r8Hjn0yDm4lEJ3IfA5QPm4xpRbCOS0lenoSXbRQShaq3Toj81suRM47C+CnT?=
 =?us-ascii?Q?vn5kJINLemUuWiI2QWGtNnbedmD4GiE8u2dXT6S/YlJEuhAJmgsOCTgMN8oS?=
 =?us-ascii?Q?6fvWcK/YhKSRtz03qh1H/OzAm7h/Ryn/fA6RSTRVmmsRnEUlS8yTazchyDvd?=
 =?us-ascii?Q?+GXOyfvDNAfTADXrZWJrewq9bdXnnN2/ju5GhPk17YiIXaSI+aEkhrgnncrR?=
 =?us-ascii?Q?YcRs88bwBY+Dv966GRHNpwtJGNdM/WpEWC+xIvEmpz+LTRUMv9sQeMgSdcXn?=
 =?us-ascii?Q?tztTrsdnQ1H5UsBqoAXSedHka4rObL3HZz8bC11eJVE5dJBucLWOJtBxy4mH?=
 =?us-ascii?Q?O4iwGszmIaaJjLJEtRVcuPPDqg4K9VUWj+MTvowd9ZswBhkdgTzz3R+Xztbi?=
 =?us-ascii?Q?6NmzqQuVLuus5Lv9YoKczBnukMXZyORibPrQAQQbPKGZo0uvPjzGX9xWq6XS?=
 =?us-ascii?Q?ge3/ZMKxlhfOsx2j7M23Al5BH42rFVGT31UxKdKlcKQbGN4acp97t4PSbSWY?=
 =?us-ascii?Q?tek3GCS5HB19Y8nU38sD95WXH75L8YSa8ciJMAL50qZvaKld2xXLyJldq7Yq?=
 =?us-ascii?Q?8deUqq4TfG6263lcz3VguKuwD2pAoL42xN/vJq9UOVbwuh3wEtbZbu51JXJ1?=
 =?us-ascii?Q?FMjn/EmVB7FTN8jd4Wp30kt0N5wJiDuwKkmaNZ3iPAmoij8oElWYQ+ShLekC?=
 =?us-ascii?Q?RPDUSqZAVE9BkblQ+jYhzI+Etyp8dM4pD4W0f6RIZxKbKObKjJvqJ1pla/Cu?=
 =?us-ascii?Q?5NGJcqfTdHCOGpCoqC/HU8zUEyHSnTGtsY6xu/JtEcWvWgw02VLNaLwSYYW5?=
 =?us-ascii?Q?2ZzSDUThEg35sW3bbri6B2zV5D9RVsmNU9YwZD1VVqzsRV3iBOfhPtER9WMr?=
 =?us-ascii?Q?XX1GaGA4Rpj30PXUcnR2k3ONKKAvjuPv/CHVy+HgOrv0g46leMeZ+NPOTYIS?=
 =?us-ascii?Q?MEZn0oJXAvCM9d3Ky3lC9LYdCnZXVmyEPQPm+Em8iugjnElEjFgwAbSmAlqK?=
 =?us-ascii?Q?aKDBbPC+9ojTXjTrZJGsxg0XZmT8Zaywr44+oPJM1l7g8Hvsnp7WuyAj2Y0A?=
 =?us-ascii?Q?KmSLDKrl/I9z1mXA30de6mfXAVkbNlKX/E4SID1CKEXvNA2QsCBRa39aZcHt?=
 =?us-ascii?Q?9kuTNEBP3cY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f/ODI4BD5JLmeGuEjArIUg3/3kx62J/oF+a0bfdwwqCtZSP2e7rgudqeCIt5?=
 =?us-ascii?Q?+L6cLosBl+io88P6u5Z4d1Su+LoUEFY9tb87eAiV9fK/2psOTH957GXAemeu?=
 =?us-ascii?Q?0ULeOjoMKf9+rf62BHrBpJ9ZxL4SZo5higzBKyZaUwRUFx6mq8wH91g4+ag6?=
 =?us-ascii?Q?r4ascmeiq5aojGXLXDTC1S6EInRWN/fc4367rjKVnhJvS77/h/EMxq+/DBQm?=
 =?us-ascii?Q?L1NcIiyHDk96A6bOXaF5Q54R7PM7ZlCQ7gDmlkgc07TP6GxeJZaxkctZb/1n?=
 =?us-ascii?Q?Wn+0XyAGdLjAjSTMuTzqKenzc5FanwCK9vh5wgMqzmwlOlbIbIkFUnmcdZYR?=
 =?us-ascii?Q?Kv7ombT1FQu8tArgWc8E6FTiA+6LX78juqbYL/qhYcVgF9hziWgccymq1vfL?=
 =?us-ascii?Q?2Tj9dgt4lti+JYI4wpja7HebKFnpvQZoJYFUgrv5oRirAF0KybX9Fbz2aY3s?=
 =?us-ascii?Q?fCR0692KtVlP4v8VkNRdYv7dKQw3mp4Mc3L5gFvElJPucZMQM/HZQLh3LXtG?=
 =?us-ascii?Q?nsFizMFeeoad2N/uQB4eUc7KhWcalcKYF4cPwewA2GXBSqLa4Ip6SpNJEqIT?=
 =?us-ascii?Q?ugZNJvuado4rkX34p+YkBHoFgkDE8ZrsGo/W7lQVVQIK1Iy4V4lIFAybyccp?=
 =?us-ascii?Q?yO4SRCpKkeiikPGZQDYOeXQQ1S4eNx6Me+tZhHSYbeBpxLRadV/YTQqzczaY?=
 =?us-ascii?Q?aslC6Bbex2j3iZgpfBgCelRAXED5ftCekSLor6ik8ArjRXG3mJjP/0twQ2Eh?=
 =?us-ascii?Q?jRAJkdtg33Qf6Q6OyRWu+Dzox6WghL2VoUyK098YkPEt/1l0eD5jm915FcJV?=
 =?us-ascii?Q?V/+WX06dpEPR1egHvKZ5uAoJRO7XYTh7Xhbh60YDDnmWKMGFgZRJ70MQ0DhQ?=
 =?us-ascii?Q?AwDtGydVsA01v6l74qwtceW0iiYotURFhpApcurPLQ5tF+OlPAi1Z+conYUw?=
 =?us-ascii?Q?/UGNplZIJKmqJXIL/cOR4C/ybjkTRDEF6q9m1+aD38FP09FR5RVEipZZNdoc?=
 =?us-ascii?Q?Yo3BPP86T9ZneX3m/Qumi6WosFJM3Ro46dUAXGBe5KVgXlWMur224VXEhOeG?=
 =?us-ascii?Q?e+b4Uo3iqZKFzeXYDmEdzNZOyUd5dztxNuCJcaKvTLLVU434wuSpBphTaWG0?=
 =?us-ascii?Q?N2jA60jahjMKtVpR1UdCPjapDbyQf6jw3jyBoyToCpmIYJz+ZUitOBYmfbnr?=
 =?us-ascii?Q?u0ZHfzPi6sdLfE2Lm5yF65U4bvPIZmSxO/LJ1YU8sedPYvfbyNgKt1axicED?=
 =?us-ascii?Q?pr9rgDd3lol/sGrpWSOiUVyAQvnvbfz539wijz1oz+MZYKkJU0+rbbLtTGpw?=
 =?us-ascii?Q?yZN6h5/jFuPzIWaF4ZP29DjC/rZuvliL/HvOGY4MNP3KVgHIOcBvjZ7jsn6T?=
 =?us-ascii?Q?honp0rW6duXiGzHfSSjpY6H/5ZEiplCFB8ZqYtiFZETQfCFP9QlwPrU6mDWe?=
 =?us-ascii?Q?jWdFczIVl1PD/WD87tqCE+ybzzRjFBi7tdgiVVH9UkOKCloF7TmYgQEIraWW?=
 =?us-ascii?Q?PGPhw3DAmUSQxLppxLRIVKn0ZF6fDcaF19mTfwyTd1vzr802KeJKFhRTPujO?=
 =?us-ascii?Q?s/Dqg/UPtJmqKM2O+AUD2hykxwQpnRHVcvA2UV+r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1aed4b7-1a94-40b7-bee0-08dd92aeafcb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 06:15:12.9594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Ox1uCVrlpaJpBKvc8bGLjBXMU+BEuqfkme77yV82j7rhlDbH2370AbbA+3qzFQS/CEDJNmwq28JZ4+IuRZ8Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7956
X-OriginatorOrg: intel.com

>+static int tdp_mmu_install_spte(struct kvm_vcpu *vcpu,
>+				struct tdp_iter *iter,
>+				u64 spte)
>+{
>+	kvm_pfn_t pfn = 0;
>+	int ret = 0;
>+
>+	if (is_mirror_sptep(iter->sptep) && !is_frozen_spte(spte)) {
>+		pfn = spte_to_pfn(spte);
>+		ret = static_call(kvm_x86_phys_prepare)(vcpu, pfn);

nit: kvm is using kvm_x86_call() in most of cases, e.g.,

		ret = kvm_x86_call(phys_prepare)(vcpu, pfn);

>+	}

>+	if (ret)
>+		return ret;

fold this chunk into the if() statement above to align with tdp_mmu_link_sp()
below?

I'm concerned about handling phys_prepare() failures. Such failures may not be
recoverable. ...

>+	ret = tdp_mmu_set_spte_atomic(vcpu->kvm, iter, spte);
>+	if (pfn && ret)
>+		static_call(kvm_x86_phys_cleanup)(pfn);
>+
>+	return ret;
>+}
>+
> /*
>  * Installs a last-level SPTE to handle a TDP page fault.
>  * (NPT/EPT violation/misconfiguration)
>@@ -1170,7 +1190,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> 
> 	if (new_spte == iter->old_spte)
> 		ret = RET_PF_SPURIOUS;
>-	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
>+	else if (tdp_mmu_install_spte(vcpu, iter, new_spte))
> 		return RET_PF_RETRY;

if RET_FP_RETRY is returned here, it could potentially cause an infinite loop.

I think we need a KVM_BUG_ON() somewhere.

