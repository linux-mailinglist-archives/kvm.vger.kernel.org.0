Return-Path: <kvm+bounces-53792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B2AEB16FAA
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 12:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5160418C4892
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00885223DED;
	Thu, 31 Jul 2025 10:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lMENvZOv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ECB2E3708;
	Thu, 31 Jul 2025 10:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753958110; cv=fail; b=KLTpSEoZRyrkB09ij9fqDeASPZzt4J/hUGGvnHN3sKQSUL7JhQwCcXiwgeS9W3zpCPdZyahYQ8NHch/wbSmT+Hs9qPJqFGFJ3aVeiTjAgmlriKXir0KUsYBM0aqGqnA5aIg9ofFTGB3ksR3i3OU0EAL90tUjgO7DKcmTc/6tBNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753958110; c=relaxed/simple;
	bh=xJjIs/8M0flvkizjxrJfAY4KkLRDhJinOVAtD3IkTe4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=U6X+l0WGFT4wYDGl8/mS1X3NuNCbsgWUZ6GtEAasEVBU+e3p+j6QPClucyLVfp9hXrn2VuPSFtk0F+5NwTMVhtydv08Ts1kKLT4BPxf3zKHM0WzsS9a9as8oThn59KIXWM9T+L8RYGcFEDW57HMWQOhJk7s0TAExUEPh+FCBe4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lMENvZOv; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753958108; x=1785494108;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xJjIs/8M0flvkizjxrJfAY4KkLRDhJinOVAtD3IkTe4=;
  b=lMENvZOvoQ+0Z1SK6WNvquNHoJxb2MIx//LTv2UY+O9MEInPfXxGzzjs
   bIAzI2Q38YKxX7+TaDDt0bbMEVV4Mfl3NfF4/LoR0osb9/jXm5zjVDZxb
   RcLORUnM7Mq7gJV6g/s8ylSC/b60jND+Wz3I8aLyG+CwwCvsKS8uuOThl
   lX2Qx7to62kNE22lGGkzz5r8ZgR4YXv1ecX4rmqp6qgamX8OMQbF2isL2
   Op9ad/vzwD6uVOB3Bxm5yw5z5VbFTdZ3Hh9Zzp+zBVTQvgLeVi8m7Uz7i
   AHe/tcBuIjoNKw52aR05ZMXqJwW6uqi0hGXPXHaW4uqD5IALS9y9lM9Rv
   w==;
X-CSE-ConnectionGUID: byuDjaJ9RDOP5Te7vKLLzw==
X-CSE-MsgGUID: FsMKUE/JSq21Kf9SQCO4ig==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="60098588"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="60098588"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 03:35:08 -0700
X-CSE-ConnectionGUID: krC3D9SxRlW/beIT1mR0Vw==
X-CSE-MsgGUID: 3bgzDe6FRrKry+A8ZADpkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="162501488"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 03:35:08 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 03:35:07 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 31 Jul 2025 03:35:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.81)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 31 Jul 2025 03:35:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aGVDKgyUrTEaksKAatC1Ne0vWCy2I226A2CmEiz1vaeDlL5sLPpsRvH5K88a9bseVjs+iNN+/KjmDpaO9YGSReBY1J1U0s3cqTLBgQ7KmT1dNGJJuok49jM2KaxC6rcsXqeze+Nqpgz7ozXRjDRou2y2007+blVnVIQbI9MOTftruTsPd+BzjFbbvCcWi7ASYDWkLeq4tR13QCZuKlnssiAIqHXMzcTcOm70cyJYnGgWmkgB4l6sYtlKBmv+s2rRq8zCEOzyB91Rkk1CkSQDYkJJdj/g2eQcuFMqyFtjWNmHVdqEkZjzFqMz1F77q4uiE79PAzW3iUqQ6efhNM6qQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nuxxbKx+ILII/XY3LBOifHRYgxSC+jTf2TCZxZ+eYcM=;
 b=wUvwgHfEQYdM2MMf4wmXpGVmG0fqVyxvPZEjzxuhhAn3bJiH0y/u48zNxZ3iDAew9wtjDbY7AmAS99vu9GziYueHSNzKc2xWBmjvUlSHYIcz1P4LqAu9o4J0mfiQa/N2hsk0AHoqeLkLGcwCbzA/NwFVNnO5JmPCXSbqTdphsSM6jbNhA42Uw4YmTmg5B8CUNKNg/v4iU4YaTu/f8Ul1zpRmf03dnIeBtGGOMp3OPSPRHY7fq4g3e9O1pJiMk65Dw2Uk4hDO/YNQP+kW/Ch0PWBlEO7lUoPDdgnqpe4RpYFM2uM82n1Vg09rntga1XhB/gJxQKjGYd/hMPgZ1p789Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB5920.namprd11.prod.outlook.com (2603:10b6:a03:42e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Thu, 31 Jul
 2025 10:35:05 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8989.013; Thu, 31 Jul 2025
 10:35:04 +0000
Date: Thu, 31 Jul 2025 18:34:54 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH v1 2/4] KVM: x86: Introduce MSR read/write emulation
 helpers
Message-ID: <aItGzjhpfzIbG+Op@intel.com>
References: <20250730174605.1614792-1-xin@zytor.com>
 <20250730174605.1614792-3-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250730174605.1614792-3-xin@zytor.com>
X-ClientProxiedBy: SI1PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: 74514c40-2b4a-4216-73e3-08ddd01de965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Zv4kZ68RYoj71l5/BkdDNgNwDNYD/hxJXlHvX/K+gtRgT2GBk44yMQw7B7GY?=
 =?us-ascii?Q?D+AmzqBM4tP60LiciRMg2mr6cBb5wtudYF7AIR5XaebVygtdFF7ryfl2wKi1?=
 =?us-ascii?Q?R7aAIKGu5cg27bIgSETD+Rg+qgid8DnvlLuIpQe/sJxuNN2/gRvss+U2ooVc?=
 =?us-ascii?Q?WAMWI8aOJcZyo9za/nXIHhoFOPYIZKvpnJYv4KN8cIE4L4NKFUseYkfZfdRi?=
 =?us-ascii?Q?K/ht7m/yY6cSBZ4XaepNxRgNXeJWorn33RyrrZ10ntgncfbbVqrKknsWXVEZ?=
 =?us-ascii?Q?7s4axR3wAnZ3GvkQgi3BRxpYQmDpPBlHRmKPrCBiNVKQe2NaOrx4Z2XiJGQu?=
 =?us-ascii?Q?0Sf3FJBYvROFzFy/bwGdxUWEn+lXwTxcMKC5IjGhcFW/MypnRc941TUcocxy?=
 =?us-ascii?Q?jHK5axdW0L/jWS7jwqGXrlWYgBokShTzHC50uyRVF7GMtqcxlvhINdF+GWzz?=
 =?us-ascii?Q?XWrImlG7ERYS6OiL92rN4FuMPEAb7vMjqlDlC5Egwgt6dmhVjxlBdgPZwIh4?=
 =?us-ascii?Q?s1nxColEdab1gJ4AvVnCdObJiKnQppE5Mj+fgg1Rd544mWqyuXkKJiklBJ0C?=
 =?us-ascii?Q?L3J95kkQmmJW0tYCJhnmD9rGbHP8cDfZHU3YwUgC269dgDheO8+wbRFWVzet?=
 =?us-ascii?Q?+7IvDYxxeO93b8l5RXuUwjRdO8cX2Tme7X54nNcnvfqd2e9wMtnksfICy9y0?=
 =?us-ascii?Q?Dmr6J1qUVg3gyKdyhsIljDN2jxvjGOePGefEW+EcaFsa3JYsWdJSBzE1r9YP?=
 =?us-ascii?Q?JC8mZy1cKoNUehvIZY+mqs54n9+XAtlma58EEdhKGo3AUtwHnlRMRnpVtuA6?=
 =?us-ascii?Q?RgWLfgPm8hRXS/TZq36Np/z9Oe7L951/F4g6eCON/Hvh61tisyr+HLSsIz/6?=
 =?us-ascii?Q?pxi8Qm9yKBFnRUaYoU7e7O5s/vdDCtZ82xWofe19IjBhT3MpVXBDTsFt8Goc?=
 =?us-ascii?Q?h1xB1JqTgP8qopAwhFHtaqAVDbkM3xNE5UqXPWfwh3whrD0tZTVynmE2qUw2?=
 =?us-ascii?Q?SNq+AGkiqfcDquG7lrL4XrGSxBFs5p9fR5okPcJB6RUJwVswFb8gVhkt93MG?=
 =?us-ascii?Q?/xmAFXs25Q8HDnnlLQwy2VW+qonCqjqMZ3ZOj/N4vnuWSFGKpJWjhRIaprnJ?=
 =?us-ascii?Q?1mXcpPiQjJ5SocaSAbWT3HDyM7Rz6LNX6yiTmbNYUu/NHYA+E1oPxwmbeeVe?=
 =?us-ascii?Q?1BEwGZ4duukfWEeuKMUiwopBR3bUNdKBc3FypbtdvZ+rR9ehRpMr8CuvIxOG?=
 =?us-ascii?Q?JZIyGEKqZ7XClLK6GN5Aaxr5PgSf90aitqHMUe4xADRjoYbA3cTQ7XtIjWy9?=
 =?us-ascii?Q?CXUFJBPpkN4LAggAUF4zsfnfKIJroRb5LjUeoxQ2V3e58qXlCXILRZwJMfNy?=
 =?us-ascii?Q?SbNxI3dxgEHQjBJpZnIrSWZ3ZeElCPlvTLLAUzwmRxUdSdnJvbc/rgOwL/c0?=
 =?us-ascii?Q?7XbKgftcTT4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AmWib+gRfilmaywKuzm73h/I+iJReZeTNz50GIkFc8knaHAtR+EPCSXoSc9p?=
 =?us-ascii?Q?t7DhYrK0CR0vuutKoA6H2qFhA2xVQNqVAyOyToqhzqPEeN0uzREtxBBy2Q5Z?=
 =?us-ascii?Q?umWHB4gdwlEmHOAvy9gIr6VESl2ekh+fOEfAnrfdu6wKP97XhrhRQ2UiPGro?=
 =?us-ascii?Q?WDb5XOEMcg2zBA8jXZYa/aoRwdoyo7u9EOu4zd4wxJjc+tJ2RsG5NVJzHfMt?=
 =?us-ascii?Q?OSyOnZSrlIe0a2RYqiiCW120/ZLVq5pV8UsIFNTu7JL1Jkr3DuxN9HUR2Xa+?=
 =?us-ascii?Q?X3I5fOV55i/f0h90zEfQXWOybPFtPLep/KMjJdrKMAWbWfjVv777ING69u4o?=
 =?us-ascii?Q?TnGbNMegaKyR5ZHzc6Y3YG5h8g6WucPgqqT42EKlkkpO0d63DLO9hPfMB6Sc?=
 =?us-ascii?Q?sXBrsGQsu+GhjYdYl6ylaVRnYoE9ogE27fY2XHep52FoKnC/Z7IuZckZtayT?=
 =?us-ascii?Q?tDUugeBRHZ/0IdFocge3+2NVfdHIapO+EcrLfY9TqKgDD1ZDL8zscst+K9oV?=
 =?us-ascii?Q?Y8wvlVItWCCPiPCzWXAloMK/+i0KvMFok2JU/Y96nq7lrFu6kSCZVp5CzujM?=
 =?us-ascii?Q?BJnaNUiP9jhXFvZp84rPd8nnoDEL3aiqrBOyYySvjtdw/DVKZj0owxsbhZPj?=
 =?us-ascii?Q?NSX1weISIbjylgaeuyCI01DPuftOhpZD4QhQYo9p1mHOssYIQ7f3eAcACHDE?=
 =?us-ascii?Q?AedkgQO2qok1sl80rcgWhwaS6LeUIi4WATZk7FcGM7iw4vZlYwUZ/yIqYweQ?=
 =?us-ascii?Q?K6+FJd5WJ+hWRZ//mgJ2veHWRAWwtrRCwg3OTCdNznxLIn4f4MVSXai3flDg?=
 =?us-ascii?Q?+0+DA5jtS6uJMhvrxw0NpCWCFpZNnipKJAPK/J8/n9IbD3mwEKgnKWjOd4ki?=
 =?us-ascii?Q?yII3y7lxhH0VOK1NKxuM2xUJkvmO0oFeRz7dxmEWJ1YG11xtCYoS/Lo6pttr?=
 =?us-ascii?Q?ItfLyqHNuVFSBW/z7ioEbzk1Q2OIl21w8QCBDVMOTvSAdKH+OyudLLoTu6Kz?=
 =?us-ascii?Q?NNC3K6PUoUyDSdoirmW7bd505tNTQZXELT9W+g5gWWrQIYwfVSicBFjKnuqz?=
 =?us-ascii?Q?CGPNDgi4MJi9QkcVk1pPslMVc7796NIyIHCizy0yZARflwmOaZeZ/Z0NL7tv?=
 =?us-ascii?Q?A3P9Ytdd90suWE1ztbeEXLtlIt8BsM2m3dIbVbnthnSCR9byEXIc6OgTLwAP?=
 =?us-ascii?Q?5OSW5ZHMkDJWsTMMMwUtiq8isYq9qtU36VlyTc9Kq74PXg4pnRBkrUXibEsG?=
 =?us-ascii?Q?6qAVUORgOaD1vWWvg0lVm0beSMNZe3ie+ek5E1dXZYaDyLCvN08s1/fxwZ6y?=
 =?us-ascii?Q?T7ra81ASVIoHASxg5A4Z6Sqo1B+aX2z+zjAzx/B+J4XH7rSuESz0yaeSV1WL?=
 =?us-ascii?Q?T9pyB4K499mclJcRIYsPpeanKRIrUQPoQCctM00TXG8X2hexqOfVDpGRItzq?=
 =?us-ascii?Q?WMgp2qb9SSvIiIeb8JcUhR/16QlwI4uh8gbhwfdfBjjC2XKBxJW+VtLYxkhz?=
 =?us-ascii?Q?wRGF06Fj1OQw9R5PFUA7QXbynFiXjjhhPHgHDpbY0cGdNI88OU+PsRCfuWnM?=
 =?us-ascii?Q?WZtyl4uyBo4NmiWIxFl32RldnZaRhEM8Sv00q1YT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74514c40-2b4a-4216-73e3-08ddd01de965
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 10:35:04.7134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ta/M1K1CGCn/wGd463tOeC24aRyVh2SxpGaHWXRHm5/HPMXjauEyMXGbR8DtkmyMamMdZ5jq6ClZ3grJgJbxXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5920
X-OriginatorOrg: intel.com

>-fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
>+static fastpath_t handle_set_msr_irqoff(struct kvm_vcpu *vcpu, u32 msr, int reg)

How about __handle_fastpath_set_msr_irqoff()? It's better to keep
"fastpath" in the function name to convey that this function is for
fastpath only.

> {
>-	u32 msr = kvm_rcx_read(vcpu);
> 	u64 data;
> 	fastpath_t ret;
> 	bool handled;
>@@ -2174,11 +2190,19 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
> 
> 	switch (msr) {
> 	case APIC_BASE_MSR + (APIC_ICR >> 4):
>-		data = kvm_read_edx_eax(vcpu);
>+		if (reg == VCPU_EXREG_EDX_EAX)
>+			data = kvm_read_edx_eax(vcpu);
>+		else
>+			data = kvm_register_read(vcpu, reg);

...

>+
> 		handled = !handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
> 		break;
> 	case MSR_IA32_TSC_DEADLINE:
>-		data = kvm_read_edx_eax(vcpu);
>+		if (reg == VCPU_EXREG_EDX_EAX)
>+			data = kvm_read_edx_eax(vcpu);
>+		else
>+			data = kvm_register_read(vcpu, reg);
>+

Hoist this chunk out of the switch clause to avoid duplication.

> 		handled = !handle_fastpath_set_tscdeadline(vcpu, data);
> 		break;
> 	default:
>@@ -2200,6 +2224,11 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
> 
> 	return ret;
> }
>+
>+fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
>+{
>+	return handle_set_msr_irqoff(vcpu, kvm_rcx_read(vcpu), VCPU_EXREG_EDX_EAX);
>+}
> EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
> 
> /*
>-- 
>2.50.1
>

