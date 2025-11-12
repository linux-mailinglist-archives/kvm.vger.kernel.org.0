Return-Path: <kvm+bounces-62838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C339DC50AF2
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 07:17:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 57D5D4EA777
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A252D7DF2;
	Wed, 12 Nov 2025 06:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h6wua/Vz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E2C4A35;
	Wed, 12 Nov 2025 06:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762928215; cv=fail; b=SNI5sEuVCqtvX5OM7h8TDK8rTxdB/C5oAMmJujcRIY+V6/xjqtjb4+iauMQlrgJ7mPWfWS2niDW+3v8umRW8gS8/+nZ30JwOAeXAFF4lPBn5wh2O0emrX+6pzPRl8OfISzKc3/jLcSlO2aEKn/+z7sLZOOOZkXtuJIEmj2nNkSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762928215; c=relaxed/simple;
	bh=yaugaBbPSbNrq8qZJFETpmgnI3zScUEAGZC7V+uaTpk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mmzWN5lrwyPOsoLVZaRWjOxnEuL20ifwPPSua/MzOcCu2sSAZGaAOJ52R3WYpgeguqYPCVCoh+ITVS5TQWJvnacHMyIAW40zZ5Nu3lYrB9A0rcJqk3OViQLr4x7FiiL6+NVkepQuEPz6vjPWy00Ri2rJo61WIeUGC8t1giMge2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h6wua/Vz; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762928213; x=1794464213;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yaugaBbPSbNrq8qZJFETpmgnI3zScUEAGZC7V+uaTpk=;
  b=h6wua/Vzs+6sIAXImrBT6cRIm6E44T7yjqgEDE7NGZdUXVjMksoLrR0g
   TMtk8Of5tOSQbcJWQzA7fqFSUMUxAdjozi1xazQfm5Qp+B/Mac9rgwRu4
   0zMhM3kZDBepC3TGWqotZwhQ3AkY6lnL4E+mCJYf49Emc3yN0+NFHLONT
   otU9DwsibOU/tC2w/NWYGnwmEAVEd3O1TXVwcAqHiqzDfz05cPzoKdA29
   lKfcAi+7iyKU6xsXFD0uEaO3bqb+LgbgZLRDjsBfxu2l/Feb1cRQayn3t
   th9GXXvO+AH4skfyrFQV7Iav6Rm6smad90jxxL2w+P7yijEgyuecWUPJT
   w==;
X-CSE-ConnectionGUID: BTOx+AgHQUSCe6n5/qiqWg==
X-CSE-MsgGUID: P6smjQg9SNyx+kdYD6KaTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="64189553"
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="64189553"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 22:16:52 -0800
X-CSE-ConnectionGUID: 8CV4JD5jSF6f58ZCGHEf7Q==
X-CSE-MsgGUID: K8/Mk3U1SMChxIJdRyHsDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="226395547"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 22:16:52 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 22:16:51 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 22:16:51 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.38) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 22:16:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f5oS6HFvxw0xpX6JqA/oYJVh98KpnxbD0gcs/8G1SwfYH/T9TzffCodfnYRzk9/6KZ2qUdYwm08G+XqsvuIqkpBCAgrteECENCTWBFpVq2mPHoSdQJO6KeuL/yJ2MVIbPyLQH0LzNH0yw2A9/W0jpnFgH0zOAqXKXr6CxOir06xT3wPR6MoS295mtWNvUcRq3b8tPqj2CYPjW5jPVBMMbC96mVmQrVhbAQQ1CY/f5HTz0MSeyICQGduWGTDaq/Gm0tWtZmg2xaw/j8C3+QNQ6wkGBXREyCcwXyo7EZQ/znRPLijppAqlSIZy23ctipdck2Y5RUcALDzQ/dX8zC4AGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxsmlqlIMTnIBP/SDCkHcSjJ5XLzd6N60sIvAavezb8=;
 b=l6403ATRAOTZdVTNoJhtRze+FhYMvbNnyNSUp2IfLtVUNLYR5vp1hx5H8PP/0dAOEWRlDgkyveo9DfymL3547KP4atngDU4BhYtY6nuP7ebZCEW1/JDQ6AXYhHyVfT8MyicD5zugu9RgTR6ILRSswpwAK+snSYYf0KXVg7IgZBOd/S3/rxMnsWq/Do1gmqkHT57c6s51NE60CdAIB4PACxz3jN67eZs6sbBA4Z8SmeqMWSBhBTi2WwHc27Hm3NtOFZlh1PrTmufwtpkNfL8keOXu8fDUH9NkEFEaiw7XM5mXKD/3sHN3QWIgmoXZQm8O4guGbr36QOXjw66+clFBWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB5934.namprd11.prod.outlook.com (2603:10b6:303:189::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Wed, 12 Nov
 2025 06:16:49 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 06:16:49 +0000
Date: Wed, 12 Nov 2025 14:16:37 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 10/22] KVM: VMX: Add support for saving and restoring
 FRED MSRs
Message-ID: <aRQmRZYQr579kT4N@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-11-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-11-xin@zytor.com>
X-ClientProxiedBy: SI1PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB5934:EE_
X-MS-Office365-Filtering-Correlation-Id: c467b814-2ff3-4d2a-0964-08de21b31029
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9+NTj1Q+ZBv0+Eqw/Hrtt94BEiUZRlfW0dpHzeWiOCXawGQNQyv9CVTM4BrZ?=
 =?us-ascii?Q?55pUEOY6GybmKWPCXLWvmpwmKcNG4O4614G2P+vfD6sCQdfGkz9BBtop7mMF?=
 =?us-ascii?Q?Ox68gsEcYXSntS3CQB6Jx6Psz5A2E/5+G0ISSHQd6t3x+GK4g5CUiO5va+nq?=
 =?us-ascii?Q?9XpYcV8GDCddnkCXE9B5LWou5/klsGZ2hTCSp182y2X1eZmlGrQ4iboT79iP?=
 =?us-ascii?Q?fxzk3IZ5RGpXrtVIjUWP2CxpTNoNw3IC/eWX4DllH5CFZpeNfwHDhIBeyX7k?=
 =?us-ascii?Q?a/PpwZW+eLc9UDDMPGv2F57A1O71bIuFQxKA+ZVCnJdkOyJTjIUfD/vQLSMM?=
 =?us-ascii?Q?jlOTu/+JMlafgPqy6iJU0SZDQjXa9TBKtWMoHz30Gz6Ea7+PffJJkEHoc7lv?=
 =?us-ascii?Q?/YA1SAtMUpc0H3j/WjYBtMnKvJx8xZqoU/i3O+tUwr36cRd2Yw16F9zyLyt3?=
 =?us-ascii?Q?bwrkRVPVcdQJfRAxqqsrOoeRHKf28rRKByfuXluyyftgaWwIenEP/LB9hRw/?=
 =?us-ascii?Q?ii4zfqHy9vrzzHuWUO3C2AtGA1bbD0wVBAh0O52Ig609P/3cTCoQ0GEDBLf7?=
 =?us-ascii?Q?N9YBOEJyMFK9etB41cr2xAJpUClgaigPhhkp27ZX4iCl/4JHSqbduwW4qKZW?=
 =?us-ascii?Q?EmHeYs9BjxJVlvvSborl6FFa0C/VRoUxCfwu5NRUPlMP2FEUM7UgdJkZo37j?=
 =?us-ascii?Q?4YEgJ5Cgsr+iSk4DJW5LAfjg+8TG+Y/VYE2jDEPQYs9vnLcDYaKsGoHjiYb6?=
 =?us-ascii?Q?nMe+Z+5m9qtFx4bGOYHVsFFNw9MX0+9WWMD21xrPa75o5+PoODVsn1qvJWMa?=
 =?us-ascii?Q?dZfixWbT2gaRDY2xVm4CZFoTm629+oERlbN3p7HsfK+PLWMewk52ti8Z38Av?=
 =?us-ascii?Q?mkAJhL2LXFGCPQ2do2ayNy+B8YjrmY9uWVhff3lB6hcpJ0hK6Q/4IFuAN/QZ?=
 =?us-ascii?Q?nOD9Ohr5w3AiIQfoRbr8Zk136Z4e2K7wKfgdUoflfwHMmTKswt6iEu9RK3f7?=
 =?us-ascii?Q?kmn7KAVy4iVMpA7Y6ME1rgN9xn/1TmZ9bsEEARDa8MF2TuJXkN4QabI0HP7I?=
 =?us-ascii?Q?aeStG6VSYDvJQ2kPhllN0gusJSaFO4YwWnwrzvqTdZ8FEzdT93pwGxq3BHdX?=
 =?us-ascii?Q?UnovnO8lTeaKjLUW6LFiiJot7ySiKtXyWLwOUx3w46awYxfAoVt7bF44DYPj?=
 =?us-ascii?Q?HHuZjTfUiaiv+uP+Tp1he/EXFp57pg3LEP2bl6DXNnZADzKrXWFLDy+44Vne?=
 =?us-ascii?Q?sdN3ZFqEwn3dOZnEXxAOpvLxnXyKlvDE1VRxf55zWqBsw6XbRUNoBeAbEy3X?=
 =?us-ascii?Q?TUuMUgxYKWMnJjcN+baP3N+4bc0ObT1vCgngujZyoC0pJ/3XHjnlOYCITOQG?=
 =?us-ascii?Q?Q5pZNPxfYxI7rd6M24dFovox1pPNLRkVQAdV7GqzqubroJI1MrDUtFqfNVqr?=
 =?us-ascii?Q?+L44eYQk1T4fNUdD7EaecwlrMSog0WkW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JqFzGNsTglwRCx0TAUIKxG8q9j3AFhNGunyGt3UkmJqC+LuVc1+hhSRJqBTz?=
 =?us-ascii?Q?cczYoWtlITheLGCOEsUDN8GcSubzexjlLLnkVmafGwl3W4InV715K1pYjLTA?=
 =?us-ascii?Q?u0icbo7lA8925+hTT/DLz3m3okmdOQ69kjbnNJ/VzYYYaPPpQhCQEpKhKYMs?=
 =?us-ascii?Q?Lt9qMCgj2F9Kwx8hc3M5NS2RblP8+an/YDrsHM74/t0INC63faihVSQWGWYR?=
 =?us-ascii?Q?NtjqxzIPMTGQPsXIsqZNh75sdHV4K6nCeXDrxh9gwECRFNFomFefdImuIoMZ?=
 =?us-ascii?Q?8TAD/4KIY7atHqXMJh/MfT1wo2FRcctV0wJFHystyb58yaADTZCPH+no+Fen?=
 =?us-ascii?Q?ivsrodhbus43Tf3kTIKAf9A+wqT2yHf0kq0p9XRWNuQGdyoe4uf8h0IJrQVp?=
 =?us-ascii?Q?V2RMlAlq2GOxx6Dsmp9QNw4cKBjhYakmHgrpBGrFraYeozuIDXaVKMjLoUdh?=
 =?us-ascii?Q?RpNfqTSM2vIMjdZExPRwOY2C+moaGvShEeRj4axrnPU2kHFJmqe6IEXaQSnD?=
 =?us-ascii?Q?D3PUvcNqPDJpuGoxfjtqqAX499iEwxA1uQXimLUO0fXNUtcFBEreDNqiw4oQ?=
 =?us-ascii?Q?eStcdBzhnaXyVVV++RapBKqtJN84g0R2CRCIxv+ZUPFbn+ZWHgptX21VF1eU?=
 =?us-ascii?Q?F6myzBC+QYqVYUaybXoC8B8lYW97ogv0GUR9dBEyAsdeY5RehA/0eBx6tFNa?=
 =?us-ascii?Q?9IpDtZsEXlEyixFRMngIpedAZYLMItRnbBPFpA9sBfml+D89JK/O+Zo626T9?=
 =?us-ascii?Q?CLTmzhRfXM5+Oxl0n1ELshNOxKJ/sKqhvNEzumAGNoJlhBT/6w6awa+YR40/?=
 =?us-ascii?Q?yynGE0iEve3CZtSTqBQurhbeX3MJWt4rHxsT+M3j9ffuq9ow53GJ7ET1qlFR?=
 =?us-ascii?Q?VIyfgiR54c+Mpm6yMaSemZ2Lcs2hCUxYYbY85yL7hgvrbROJojeJCwyH1ike?=
 =?us-ascii?Q?T/cNVeCCxvv51C/gevbmnP9Vgxzl6ntWfOHC/Vdf5zjNRbEuykgDnF+hDr/y?=
 =?us-ascii?Q?rqOJG4e3PUY1DA0F+d+62Pq9VWrDuPVGfHDFZ1UsSqqUXpFFLCTi9gZIcAYA?=
 =?us-ascii?Q?pvOyIlCsk1bIO+Z5RSPYKXy+UC9VNkzxXofkuqrMGfSB6Gf+DvOJVr+Huxve?=
 =?us-ascii?Q?6KCmIHmgqnoTVDpnS00qHbsuRuQzPls1BuGoDa+ez+pw6ezKGENUIrXgpxjL?=
 =?us-ascii?Q?t0I2wHR7aYjcpKc0XN7U0r3qg/j1eIT6yugji7e5PJm2f0Ig+/KuHSwKg6Aq?=
 =?us-ascii?Q?2yaoqkX6H5i57bd4OIyE4rDSKyMCxfHVzUgdxL0ru7DgMl6aYT0VxEcZPxVW?=
 =?us-ascii?Q?ay1sErQt5qApM/nuUW467BvHg6rcm7c685Zpqbvl/Z+uSoO6qGhVL7pUEdmf?=
 =?us-ascii?Q?5eu/Bpd5FmqfPCzlX4IzwdS3c4TJzlBdJoS7svU5XNvHHxPOhtquZKjFQgbL?=
 =?us-ascii?Q?PMGtcigvh/a0668TqyqHpdPrIf8tdYiEdg0of08y5C0MSZ8pCZs2srluQ6FI?=
 =?us-ascii?Q?lGms6jTUBgGStVw1b2sVpibvXfeDSg73K3XSyMHUBRs403DcV88FSmna+3uD?=
 =?us-ascii?Q?c7y4mV9T7yddcghKcr+3NtELfrNa0LJV/dW68BEx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c467b814-2ff3-4d2a-0964-08de21b31029
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 06:16:48.9131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PyiH4lNf6uiYObY1RsDybEO/3ZjFLdBMUqC33/yWKDYNcdnNntZhLYHbhfD86DMBOyv5Wp0Q+wTbOrhRJIQiAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5934
X-OriginatorOrg: intel.com

>@@ -4316,6 +4374,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> #endif
> 	case MSR_IA32_U_CET:
> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
>+			WARN_ON_ONCE(msr != MSR_IA32_FRED_SSP0);

This will be triggered if the guest only supports IBT and tries to write U_CET here.

>+			vcpu->arch.fred_ssp0_fallback = data;
>+			break;
>+		}
>+
> 		kvm_set_xstate_msr(vcpu, msr_info);
> 		break;
> 	default:
>@@ -4669,6 +4733,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> #endif
> 	case MSR_IA32_U_CET:
> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
>+			WARN_ON_ONCE(msr_info->index != MSR_IA32_FRED_SSP0);

ditto.

With this fixed,

Reviewed-by: Chao Gao <chao.gao@intel.com>

