Return-Path: <kvm+bounces-34854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8933A06ACE
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 03:20:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1EAE1634E8
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 02:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A0839FD9;
	Thu,  9 Jan 2025 02:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E+rKcw56"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F63D3FC7;
	Thu,  9 Jan 2025 02:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736389210; cv=fail; b=YEvhNqTcgtjRBFjFRFoulW7Xem8/7l1iPVZuCxUnlsqgqAP0N3xyefaXWRAaVDE709GTG/KZVinFdHL3aniQKHL5PGnWRuquPr+q5jLZHH4koWOEgjqXFs4tYA42cXSS/QjVuhWSjFSLiwtLqu7JagbxVq+OI1/9bPXFD3QRtDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736389210; c=relaxed/simple;
	bh=4ArtB3pfYGlLdZULZuJNMssfYXNvvLZs8VZJYVvLHok=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Cne99KGs+ZauyZpy5nELe+XlAyBiEyEBTazCjmI/xSOvI8E+P2kEkYNzN5FHkNRoISvBrhIz6rJXfcRyIXdE0UGnnLfFlNU2Q7hvU23udm1P9YPyAm7dlJpNgEriWdUQl26mUvBCg9P3lC6MYz2Olq8QgcJPU+Fd3Gf0p2JC+3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E+rKcw56; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736389208; x=1767925208;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=4ArtB3pfYGlLdZULZuJNMssfYXNvvLZs8VZJYVvLHok=;
  b=E+rKcw56K/fLQhbMI/UZZVM1nl9jqGApyPG0AR0LJRRJz0elzjXF4iDc
   3p66n8HSAvhIja9qUSYufxZaDDIwO2vMuWm5Ch4XTlwxTf+gZxJp9iNm5
   0LuW47sOLuoKDeI3GOmooCiHT2QtzV6C1O3WEo9bvBuAjXN3Jdf+mLvCb
   pm4ncY60zRf9o1LUwmz6YO7EFUycnPjMr+m5024hYaxOwCxElYaylJa2t
   OXV9lfnSftKMYBDQf8w8QlrwIYYdMSm1WbS9zPDC/MxcSSYrnSosR/2hw
   /gtLiV1sOZ4eUXCSyPkpGxRnmVI+3iV9AIPkeGp7X74XwYipQ2uEM3LgM
   w==;
X-CSE-ConnectionGUID: g0NX/IvOQJWaTZyylHv2kQ==
X-CSE-MsgGUID: ZfYnG9bGTbafdriM1Ee+Yw==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="54181563"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="54181563"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 18:20:07 -0800
X-CSE-ConnectionGUID: iCt12dMwRyycLvzRPlwv/Q==
X-CSE-MsgGUID: Aqhc5jZyTIepAwXpxNUgMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108330739"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jan 2025 18:20:06 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 8 Jan 2025 18:20:06 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 8 Jan 2025 18:20:06 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 8 Jan 2025 18:20:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PK6Q2ibwVWgyMYAhgLd2TZ24fv50TzBjUcpLidg7fXMtjBgErpt4UOfPB9LceFXvicj8df/SpZos6sdMOjB29RDWOzgCEBky1Ietpr/CqkWR3PZ6po9UqPa2sOIU2LnAUq8OEO6Lu+NRkZKa8Dh/BuM93HQybrIsl4pgnA0RttwGN2lK/8N/tLF9jLEnkjFe7WP3M2osKLRrCTuobBj4OXJbYbq25vldxY91uf7SMoHc//eJKtrU1Ui1WZBQ7uMRHgsEv4BWk2THqzBPGEMnrWYDbLrWXkjrOYHRxTYOoDWeK3EAEJ2JyE1eTE3JSYzrkD8yD5l/ls/a5JhIBNiRag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rDLxvz33xd6kA8aTvu/jYZEZR8KwnIq9iVq4EwpIRG4=;
 b=tozz2mahcLl0lL3PaKf4KufkRmf8sVO1hcecIMv5DTZmtQicDzKu0vyBK5Y8tUNIOj/OnDmBndakQ5lzj3a7v94rmQguYaDeqF3HHVoJWjl8mNxqi0YWw62ewnZhvyksdKMQ1B70qaS7jtZWBJ55qwvVX7igj5+pQyV0ZnJxq8GrtSyrotJ6lxvjxyBBTzSsEhNdd2jv/gYetgnvUfozTtRMZAKOHJeWuH1ZlevExvp89MJ6ZCeAMEgjkhUwiBHzad4QZej0eTS8jfb10XiVDTv+WikrnJA3aAvr+HiqaBlP/9G3f5vRstZmylKJewQRFGiu6u2reVzz7LwlFYVMTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB8027.namprd11.prod.outlook.com (2603:10b6:806:2de::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.11; Thu, 9 Jan 2025 02:20:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.010; Thu, 9 Jan 2025
 02:20:04 +0000
Date: Thu, 9 Jan 2025 10:19:12 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 10/13] x86/virt/tdx: Add SEAMCALL wrappers to remove a TD
 private page
Message-ID: <Z38yIIhvlaz4NRB/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-11-pbonzini@redhat.com>
 <f35eff4bf646adad3463b655382e249007a3ff7c.camel@intel.com>
 <Z3zM//APB8Md0G9C@yzhao56-desk.sh.intel.com>
 <9654f59b-9b8b-445c-9447-d86f6cfc9df7@intel.com>
 <Z33Jp85ospUC/QaD@yzhao56-desk.sh.intel.com>
 <3a32ce4a-b108-4f06-a22d-14e9c2e135f7@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3a32ce4a-b108-4f06-a22d-14e9c2e135f7@intel.com>
X-ClientProxiedBy: SG2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:3:17::34) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB8027:EE_
X-MS-Office365-Filtering-Correlation-Id: 18c86a5a-9bf3-4f9f-5773-08dd305420cf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?czzYCo7EFM1tQBAnEkyQ+drcR+sS22xnvav/FpVIlh/1h2N1lNe/dxnwxXx+?=
 =?us-ascii?Q?HraWW2/xPLTuJEu5nMPgux8VdRF7y3RbIk0wN3x6RCOdOjQdqTvIzJGsfKqK?=
 =?us-ascii?Q?MTD1OwZYKEqPm0bSMAHbmE1SGvSjOTBymNx70hNhy/d4VoF79XO+eNbNNHfk?=
 =?us-ascii?Q?g+wuvka/Cp2nvliKY3CJDiafEZaYFEkfX90ydBvXUY2CPoPMQUqOXjLZWtqr?=
 =?us-ascii?Q?vNuawC3vnrzQDA2WjkAxsqcklx+R8Iqra8/UZD94xn0g5C26M5Q1WjG0tHe0?=
 =?us-ascii?Q?eBGmcza4mhMQHdp2CblFj287NfiCg0GK+bv04uPHPahfWQ/xBRfk54JF55CR?=
 =?us-ascii?Q?90OdtHTYCcYSPXrTboT975ux82WtsDN4ZFpU3Xf1SQo+R1wHiNAxh2ylUqLP?=
 =?us-ascii?Q?QFo9tSj9higgv0TnGrUseBNDXi9fd3U0vtU9FASoYB3DQTG7tA0IfQ10LI6l?=
 =?us-ascii?Q?Z/M/In/paZe1ScCHRkZc+85yAUKkfIo43QPF8GHs6GdIabIDX4BRhCbYpe8M?=
 =?us-ascii?Q?KkdPUb1QjocftLj7cXMboYqM46AlLIZkMh+xOMxHreoKf0buP9Jw1DlZG2Qg?=
 =?us-ascii?Q?Wnap9CuOD5gY+WG929Xxsfb3871FX4d1ilG+2UvOO3TNeQllhutUo+n3bQvb?=
 =?us-ascii?Q?K0LxCEaF25HAikGtpfxDfBBXZno/o87Onj5HMNnsqnszOd9l6gmXJyYSj8Tw?=
 =?us-ascii?Q?HsNH84XWG/voSdUAyk77/MkT6Q4xOVu1UZGe7q+ngO3gnBqEnoFaylLaHGvJ?=
 =?us-ascii?Q?VC8oKg5tGdfSKNYYS4baVFjJXA5imTVa8Rmy5Cn/jCwTFx9RONk4KvK0ss1C?=
 =?us-ascii?Q?/7+JVBshSKE+8nCLcdDSjEDMVyK5SiCxwNQRDcgyTZPTb7nKV+vJbnmACznI?=
 =?us-ascii?Q?+KeM0vSOLqr3l7oyyEsS6u10fyiz9MvfGM+c/Uyx5C0SOhmjLwCeZzRe/uP6?=
 =?us-ascii?Q?eRv9HstdRlsFqEAS/OUJ722Bevj9cfdOIj/LWHQFutwla/VeLUh9tsIaHtag?=
 =?us-ascii?Q?C0RsJxWPSedjJ9TqyD8fvr03Bnx7ItcBXglY8Auy+s1KmV96kpOoFNw6UYnK?=
 =?us-ascii?Q?o6dXklM4TLfJxkkfpfkAASxzLszxiMndFVZzmQlcCftxI/vAf0A8j4DPaW31?=
 =?us-ascii?Q?KesCajs5xJAEibfECNXMu8FQinwgDrx2AE3+viVxYPkHrpQlWnQFCjh6O/59?=
 =?us-ascii?Q?FQVhZRcU4lhbMWFrI6t3Y4lZhcVoBDvpbwXlcEZx2/5jxw61UgyfZVh+oQOj?=
 =?us-ascii?Q?zXOTMGSqfroEVyM6h6jF/Iv2f7TrEIx0NFdw3EqYrfrQNiDcJ5Pop84CNphU?=
 =?us-ascii?Q?L7aBGu4ERA4p8ns/p+8ln+SlG8fYd0+QPVwoM5F8ndOy9Sn6XS7VJL77nuFy?=
 =?us-ascii?Q?AR394lKfWm71+9XCb3NPp5SpO8Y0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0Ph6aRoTBNdt/CEW8UelNnCylu7tfjr+G7CJnBlu2oL3vt+JINDfVUCyGbH1?=
 =?us-ascii?Q?EMQEC6A7S9DKetnP5wXEH5sKklHcMrVGiQ7xs0wZrkYsIfCGY4+2hx8Eb+OU?=
 =?us-ascii?Q?BDs/c2FjAEl2kiLx0NZ4eEpqEqXkKUOxHbCeEHr2Rorwgl6SkdgYpn8r/jfm?=
 =?us-ascii?Q?zD8nfYANEA3VJ760fAkkrp3n0P5Qw6zb53rGEqnNoryw+1ZoYX5NrqOiPKA1?=
 =?us-ascii?Q?yW/YtRwzD4mgBLWY9hWeL74vo4p95UAyJ4kriepBYC0bhSh0m1tuFGLJYgt0?=
 =?us-ascii?Q?ttXfhHoYlOViwdPdFZz8MDCQB2bCuMyNPheSeIQu2S63ohqPlV5vcy2JsP5L?=
 =?us-ascii?Q?g2LeNKvjoYpWPyHWPQLmlApbr1/MYJx79Bx8y5tC4yoLrWHBIbnd5MdhDCc+?=
 =?us-ascii?Q?61dAGJfINorRgMFu8BtngOZgciDj/uW81TRssGGi0qrrIdC3TtyJJtrKiJDI?=
 =?us-ascii?Q?bQgHLJzJUQ3c/+9xOUcnMSPutWYoDv16s9VW4juR326Wz9tpO1Dr60wsmq5x?=
 =?us-ascii?Q?yeSRGecgeCVMb6mnZD7/o87fjqkCuPLSM56fR/pNg3oU2NArfXsoelAfYWmM?=
 =?us-ascii?Q?p6L3z7ffKvipAwadhRmN9jFj6zV+JdZiFxfCQe/kdCx/pwihF/1lhmJuCZ28?=
 =?us-ascii?Q?ugkHyRD6/lNrKVcJ9vdNH6ta0If3/P1e8uSTBuI7tzYxufkoU+wduSHLWIka?=
 =?us-ascii?Q?1zoaNnUV+hjqUcx1nfTzxu/iVcenkxLfSKAIdMe6b+2Ixeb8NzVwvYkHrpfE?=
 =?us-ascii?Q?tg8Tenvr66rJsoOP8ytX8KLYhRPxdzwLXZC3955igjnx8cATcoI+f7Bx4Z1e?=
 =?us-ascii?Q?i1FxnGL3HTndoBkVlUZqS83zh+MzfBr2DueW7+dXoPvvuhhuGgXS7rXPWcB1?=
 =?us-ascii?Q?HIYqEvbbP3dR0HRR+ZVyDcvfeYlj76peS/3bSOyPMUZnDvjVeP2zeE68IUR5?=
 =?us-ascii?Q?MIuQY9TP9fR8n+kjs3XyHcq5Dw800N/i+HNNZZyt3rqqnF45r0XE2636s+S3?=
 =?us-ascii?Q?lNeiTc8hTKQU3+SHH/z2BSgqwaYanH5cMmnYVqMggGgYHQgyO52NNaxYGGH1?=
 =?us-ascii?Q?6xtCfMyJwaKGe4TAWaR6EbhLIT2WDPjTHPAeeSqc7LAHMeDa3gqDL+w98r2D?=
 =?us-ascii?Q?hsBpWLUDV0O6EgUydUZ8NL2IfKUQTHfJXzeGXht/94ZqYo03qiEdl734k4iN?=
 =?us-ascii?Q?07bNvJ8V5p9ckZ0P+gEKnt4M9hMzkW84XV+wfwFqAareaS9AGS9TbQdinFd6?=
 =?us-ascii?Q?5bQTSB+oeS4SA30+KWjP6rvL3Q4cTDKCiZx90UQ8IWpBjuUkc+Ua2BNsrB+h?=
 =?us-ascii?Q?hqu8/hq0X/E4c46nob+PYslW0TswqL4YMCuzG3HAk6HENFBKFXFSUBfPsTF0?=
 =?us-ascii?Q?U6trJWc/uNv1A1uWMCxU7PLpLCiMATszXVRhMxlaEgIfEyAE4IWdwyiCmPiA?=
 =?us-ascii?Q?oGtbbg9Q7R7BhbHq4OpFaVqNX3d+Vg6OIBIvpVkjMAJFN7M1PEj1iVOnwV3w?=
 =?us-ascii?Q?Mu2Tbb3BQPdaQWmePgAs+2tZmSesE5aY4AEFMN6jBsim1jA7Kg6gEBf0Otlq?=
 =?us-ascii?Q?ty/1oo4+3aG6wywh4MR/I1DJq6to5RC7L1gH2Hyv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c86a5a-9bf3-4f9f-5773-08dd305420cf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 02:20:04.3954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pazrjy1acmjLspTWkBgnFnA2WNIy8xoh5gyunu1Q7Erw6rUqcZXnpvW6tV9sF0TgSHclSDbjIBdF+yfFiFgRCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8027
X-OriginatorOrg: intel.com

On Wed, Jan 08, 2025 at 08:31:14AM -0800, Dave Hansen wrote:
> On 1/7/25 16:41, Yan Zhao wrote:
> > There is a proposed fix to change the type of KeyID to u16 as shown below (not
> > yet split and sent out). Do you think this change to u16 makes sense?
> 
> I just think that the concept of a KeyID and the current implementation
> on today's hardware are different things. Don't confuse an
> implementation with the _concept_.
> 
> It can also make a lot of sense to pass around a 16-bit value in an
> 'int' in some cases. Think about NUMA nodes. You can't have negative
> NUMA nodes in hardware, but we use 'int' in the kernel everywhere
> because NUMA_NO_NODE gets passed around a lot.
> 
> Anyway, my point is that the underlying hardware types stop having
> meaning at _some_ level of abstraction in the interfaces.
Thanks for explaining the reasoning behind the preference to "int" and pointing
to the example of NUMA nodes.
It helps a lot for me to understand the underlying principle in kernel design!

Regarding the TDX hkid, do we need a similar check for the hkid (as that for
NUMA nodes) to avoid unexpected SEAMCALL error or overflow?

static inline bool numa_valid_node(int nid)
{
        return nid >= 0 && nid < MAX_NUMNODES;
}


> I'd personally probably just keep 'hkid' as an int everywhere until the
> point where it gets shoved into the TDX module ABI.
> 
> Oh, and casts like this:
> 
> >  static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
> > @@ -2354,7 +2354,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
> >  	ret = tdx_guest_keyid_alloc();
> >  	if (ret < 0)
> >  		return ret;
> > -	kvm_tdx->hkid = ret;
> > +	kvm_tdx->hkid = (u16)ret;
> > +	kvm_tdx->hkid_assigned = true;
> 
> are a bit silly, don't you think?
Agreed. That's the part I don't like about this fix.

