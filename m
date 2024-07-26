Return-Path: <kvm+bounces-22286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64B6093CE48
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 08:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87C801C21448
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 06:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6077176AA3;
	Fri, 26 Jul 2024 06:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LY5o4Siv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4D6548EE;
	Fri, 26 Jul 2024 06:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721976617; cv=fail; b=kBlROlsAuW/LJ847paWVpqwtcMYzGUzCfF642l8IRDFFr2x3yskbkRUAnzMnHDxG+RBtw7tW2nMDzgdoj4rTfgj+XxmbX42fE+1vShkBEixsM9A+4gjJ2JBEQa4U/7pDUrFdulgDjJslnt83RBviGVybYA0ZTc291pUxHEtombo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721976617; c=relaxed/simple;
	bh=iWv8oi8WMadlJwekjaDcsyiISwCX7mr0FGo6lnwe7iw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FxQk0NvhpFFf6SPu7Bny1QBWvbIwl/EZDILzytu0NWRXbMJyag+AsiTOgUhBBl4IWKAxkv/3zOg629aL0z+nLIUEP+ql0/RmlNs8I5MNKtfK6xiFF1oEq7J8aIQcORDVxgknmczEMvp1rhZtdEuUF9WWI2eMOF1lcjb7H3NGAwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LY5o4Siv; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721976616; x=1753512616;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=iWv8oi8WMadlJwekjaDcsyiISwCX7mr0FGo6lnwe7iw=;
  b=LY5o4SivHBOVQgq0IjUniF3f6IVaDdzsT7foYmro3bU4AWeXWR+UL+Rh
   UJVdE3njQrCn8W7VY+SwhT8BSZu6JUb0YPT7qbtmYpNQh2gqFqGlKF7vt
   kRxnXBPRGEkz9T0AT+t04wAsCG4fwjaoW3bd8zzs94FnKQNA8lHLHkPPv
   2oZIi/KwDa1hlC4tKCrNPefwpLlbgM9LNi6eVFU+ZFWqT2BJ9JbuYDbDa
   LEoimmZOmRkDx9FDe6IzfBX1lMLA/oxRS+n1Lo7tplhuyAGenXyV+Fyo0
   6LMarsMH6BnckT/2HTR+wBhiXhDZ1UYkqK2h0AiPAaB+WjK4/8g4p5EJx
   w==;
X-CSE-ConnectionGUID: 3i1X8ZhVSUihDZBacYRMVA==
X-CSE-MsgGUID: IHZa8BmpQQGd91+TuX51bA==
X-IronPort-AV: E=McAfee;i="6700,10204,11144"; a="30909835"
X-IronPort-AV: E=Sophos;i="6.09,238,1716274800"; 
   d="scan'208";a="30909835"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 23:50:16 -0700
X-CSE-ConnectionGUID: JLxdTKXnQeS4nFjG1+4tag==
X-CSE-MsgGUID: ll9SYQB0TNGoXCWpcnvL7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,238,1716274800"; 
   d="scan'208";a="52841720"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jul 2024 23:50:14 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 25 Jul 2024 23:50:14 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 25 Jul 2024 23:50:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 25 Jul 2024 23:50:14 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 25 Jul 2024 23:50:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y2Tio2qx8HU+0PXWqduwOpp+fR6tUFfh8+jelAr0tw54RqHo5gluicU2Q9n562CrZnNeana/6kfkH3lUSLJVS7/AwIRReIcMoaEOxWUMahscuYp6lpaZ0VpUVKAeJ+1KIVtvy1De13ev+A4B40g2/rxtRrcYFVbhS560cewlb68Krp0/NovNXK3U/XUZ9YEa0fn40b8KmwV9+f/tyhcacNaL7XqOiX/N+FlBBSol/36PmQTd3H84Qq6O73Bp2+DUrreJ2pDsDHUjsi/bA3zY/DZpnhRVShyw8AcqC9/CNEdY+RxJy+6dPochQiC/oCdzCH+uGGSNGPvBa7Yd9CMICQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rND2hOjbakXltQpIdKwRUeDRYxRVqY9h6RmZumJaHk=;
 b=EtgmfTTN1ICB+z0fDsh6b+FhIl/FRvIx9IEk3gL1+ZbNmk7hKyoZAmlPEcFeT6nvRoTMexrVRmWMQ9C6wZHAXf28+3LLyXGRqvZa+5u/xeg//5jL2z383ak6vrkZCkZZ0xmcV2Rl+vSfBjILRHjyldg6Ydp7Wzein0FQHFOby/FVG9H5ovevpzjLXUCW5YPlBSuCgytz8tU06AqBus39FnNpe8fUogts5diM72WPQKlczjX9v7XFPHMqHJB6IMRJ8GncVBJAYDjN6PrzpOydqfBCcAi1o9+a9Nec/IBWykw5TyaTrcv3zpapTKhL5eAroskM1z7pujM5a18GWVqLgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB8503.namprd11.prod.outlook.com (2603:10b6:510:30d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Fri, 26 Jul
 2024 06:50:12 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.7784.016; Fri, 26 Jul 2024
 06:50:12 +0000
Date: Fri, 26 Jul 2024 14:50:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <kvm@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, "Sean
 Christopherson" <seanjc@google.com>, Borislav Petkov <bp@alien8.de>, "Thomas
 Gleixner" <tglx@linutronix.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] KVM: x86: relax canonical checks for some x86
 architectural msrs
Message-ID: <ZqNHGBZyiHKvQKj1@chao-email>
References: <20240725150110.327601-1-mlevitsk@redhat.com>
 <20240725150110.327601-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240725150110.327601-2-mlevitsk@redhat.com>
X-ClientProxiedBy: SGXP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::31)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB8503:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c98dcc9-9128-4c2c-7d1f-08dcad3f322d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4qk7kG85gZg2SuEof0O4FnfjtsQYxoEDM0eIWGHS0+atNPzR715BOC/v+PIg?=
 =?us-ascii?Q?6VfKwnBUNNMSPxbQaPj472IWKnbEzrIwchS8Lqa8Z4ixZu5XvQIbi5x2pYE+?=
 =?us-ascii?Q?ZfNAcJ2nhNhU1ALmgyT6k2RjLknfqbluOSDycT+Y55t+zoUTJiyfkknR+cYe?=
 =?us-ascii?Q?yO8ohzV0VA0qTjOxJ0cFqhJeDLRZl6ZrBXg3u/uRqcfojNn+GEAH1Pvwpl/c?=
 =?us-ascii?Q?RTkN8xBsvcT4pxGhokkRnvlXtmWvzwtV3NliCRmhem3v+V4jCy2FWkb019fr?=
 =?us-ascii?Q?kngjzfu07laMI2LoBVnY20MUv381CLeBHae34yTsKgvTBrXPyMw57dkLxkQ2?=
 =?us-ascii?Q?Nx7saf56kR+8GhB/rVZUFC24AW8hfDrGcVHahADSL6iVmVEqt5we46L3Rr/m?=
 =?us-ascii?Q?uczV2my+SP5+MYVMpEmuRLW++LDTo6fDjx7yV+3Y10ZOY24noCldCFHvAJbr?=
 =?us-ascii?Q?XutwS5k5YFIBndE1D00ciyRwUO+MUjimiIdM4el1vsDDKs2eq/embgWBNA4X?=
 =?us-ascii?Q?AZ3bzVZcOYD3foGPMwhKmQzUyIrtg6ixgjrdnK3RU+y7d3hNO2w1+vvrSrq4?=
 =?us-ascii?Q?Tx6uxA378/eShlcccJyH7P5kTC2HJPk2sor2Y5iQjwawNvnGYmPaR2u0JnJr?=
 =?us-ascii?Q?B6IFIe3HiqEPpIlp79XkMOK379/8WGi/sLZezuQ92VLbRikUBGQ7ZbCsxuJd?=
 =?us-ascii?Q?tZ1Abytfc3j9T7z5uEupt7HR5zP8H6GWiwbzo8f4pz42ZmRLkYrf4DO0ANI/?=
 =?us-ascii?Q?K6npca4z7dYCCYS27OMC2X0daLmc5/uAmCbkta56PfNOrfA3rpEvUbaMU5BE?=
 =?us-ascii?Q?X9eEo9QV/OCeEqg6mgE0IwWUFOiEXiXPz2KDBiMQT06zgY7d9gUSRj08ZRTM?=
 =?us-ascii?Q?sGezvvjdmrVHGUoa+goI0edATWgHuGFcE8e9UhsgZtzvNpZI2gLf1KMLXwDT?=
 =?us-ascii?Q?ERFWulTL4WfPyPLOoG1xw7U8b1jgVPD26LWY5wu3nfyHmnXdk8lt2CcL1yBX?=
 =?us-ascii?Q?QveOctaKKva4stjp+Dfpw51v6n8qReaoRffqNezoE+qizFiMCUM7+kCP04rS?=
 =?us-ascii?Q?E+s4HRMLqWAbXQ9jhi4vPeLCsKNjcWasozG+V/oeHFjbOXVgalLmg73v68nC?=
 =?us-ascii?Q?WAZ9kqRZM2T08/l169aZgXvJ0e7HzjrIxPEevMIq+6wQvywi1IjopizcsZ4J?=
 =?us-ascii?Q?39wPqKxNBjGdF0be4gjijMquc6aRHXqFlRRtUkgWNYg5cBPPyqEJDT/HNNlU?=
 =?us-ascii?Q?t+QozpMTlyd8XNmBqM32XHgYQSkeyV74jHHYHQqVYHriXz2hYU/anaXtOQ8N?=
 =?us-ascii?Q?l5ZGyvENDAM0yN6bxltV+/cQ9f7EWlQd5CI8syI0bPihjpJRsNpyZokKx/hr?=
 =?us-ascii?Q?u86TbGo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?58FnQRs3pkCjHPfD36jQmr4wnV2grJSty7hcqMvoRaWw29nKrXuiTdh+JO6Y?=
 =?us-ascii?Q?mD7oHErK+idbwCY10uOSB2wMxTj3tsz0d+f6swSiKhkt4qqiYj0dHiYIdwIF?=
 =?us-ascii?Q?rXWfVHQyXfGM6b1JSooy7Old+sQP0cMBa8DRIAm7uA3gc48ES5F0JFenwBGG?=
 =?us-ascii?Q?RwVFTlRnv1uHaF45Kxr76IxC5KhA3l7RS6g6t+uTKAFzCePpATPsdFrOqPz8?=
 =?us-ascii?Q?SprDFFzgjRTjPsrVn/kalaqhgQZM58Y5ufSleoLcQlQJMJwmOw5mr4SttI08?=
 =?us-ascii?Q?3GoQ7uadOcm3jKbqWo5kgoFDBqE2n5MEmOS4B2wb/SZJohOglvwHGmQGQzDq?=
 =?us-ascii?Q?fGDw4uZLcm48XJdvmAVJTYAfzY/yNtWT7431jnsBFiLNk2sZ0V0OGUFbth92?=
 =?us-ascii?Q?Py0zeIMVT5khZQaOxJ4xnk6n3hQLscgLytBfB6bwk+m1telsu1rUtdrunGI2?=
 =?us-ascii?Q?oR4FpT2fVXwFVa6+U5I8RfiBxEzJ06GW2fuF+ZMt1laR9TYU7v7M2lo5YG6K?=
 =?us-ascii?Q?0OTAyXQ/TOEfmtLx7nZmPzhT1PZq1psZJMHOS7jneJ0vRzzsdfYJJq3NOu4Z?=
 =?us-ascii?Q?OVkGzkcsiMzF2oMhraZDnj+M0ILEei8/pvUvuOKmuB68ozry8qxGTV4RhAZt?=
 =?us-ascii?Q?g9fUGvCvuQFdr7dG5+FLKVaNTT7Q51po24oyxrA/9cXXLOmSHpYQH4enT1oD?=
 =?us-ascii?Q?eWs1VuI/iaAtBN6D7z++7AG6bwSaBYO98LooZRoiIr2fCwUKgv00aHQut4yU?=
 =?us-ascii?Q?T9Gw5jUi5lo70mZu2A7otEQkJ4WTahmXfNNqOnHXjxiMYWeCI+nsVKGBD8BS?=
 =?us-ascii?Q?24x0205rY571Mp5y3WmZN9Pye3gK2hPeOFy/YONklVuFId82+Py/O/eCE72B?=
 =?us-ascii?Q?NofuGgrb/8H4TCkQYwt0pnKVCLzCgfCIbXfc965/1VrVq4Q7cquT/5TAJpx/?=
 =?us-ascii?Q?Jt4+wNSTpvmu3h9AG43vJCZAlM1C7O39iYydnlhr+jqu+/9aEdKXsh3a/tZO?=
 =?us-ascii?Q?DaSSIgnpyXfesCjn2LiI8DLEJBsvur3w39vAT4dnlHzez+8oFdqQqe7xT30i?=
 =?us-ascii?Q?NilrrjVKJJ3C7YvhLM+itpoC+v4RsJZCIieiFLP9MMnqxOIFILDydvhBAz1K?=
 =?us-ascii?Q?fxh9UW5RnvtbxGb6x2dfb2rQ+3hoj6k0qAdxf1GNKU5lB+fptiW/0xdHWBbC?=
 =?us-ascii?Q?3pCB+1V/+urEkQnnupk68/3Ts8R2vFeBYF83PTVXiXgTAs/S6jNGWJvvd54H?=
 =?us-ascii?Q?i7+oIEs2RtkNROQlBrzL0dsXUR71zS0ya3xor5fUFozeVH42/fptrzbgM1Zm?=
 =?us-ascii?Q?uYG7u6snQNXotkvN4qta25PO0h4N3/eHvVLnNA0RGsNDMZ2HEq5CNG1HieQQ?=
 =?us-ascii?Q?GWocylY8niv5QrXDthaTUZPxBHVkuGK71An7ZpCAkc740oB9wlLMYyMhnzVX?=
 =?us-ascii?Q?AawyQ1AZfH0f2E7bXpDdsr0Gtv8ygv/aYm/sdf32vaOMD1vmIfawpY1loCFt?=
 =?us-ascii?Q?OaQxLQpuZB3U947O6SRp/COhR4CELb659HBL3oviEbStE6kWAxsVDF7WWKIo?=
 =?us-ascii?Q?h11Tp9CIXHUVBsZ7nyd8NEzPVGB2Q9oMVKoaHdDL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c98dcc9-9128-4c2c-7d1f-08dcad3f322d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 06:50:11.9514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XoPm/XK7KjAF/dbUSXgCDCOyQVF2v2qFUZ3+UQzvz43N4IQezPt3SXwFjFFQ/JpdAN9ebLWUdOdvZhIwPwt01w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8503
X-OriginatorOrg: intel.com

On Thu, Jul 25, 2024 at 11:01:09AM -0400, Maxim Levitsky wrote:
>Several architectural msrs (e.g MSR_KERNEL_GS_BASE) must contain
>a canonical address, and according to Intel PRM, this is enforced
>by #GP on a MSR write.
>
>However with the introduction of the LA57 the definition of
>what is a canonical address became blurred.
>
>Few tests done on Sapphire Rapids CPU and on Zen4 CPU,
>reveal:
>
>1. These CPUs do allow full 57-bit wide non canonical values
>to be written to MSR_GS_BASE, MSR_FS_BASE, MSR_KERNEL_GS_BASE,
>regardless of the state of CR4.LA57.
>Zen4 in addition to that even allows such writes to
>MSR_CSTAR and MSR_LSTAR.

This actually is documented/implied at least in ISE [1]. In Chapter 6.4
"CANONICALITY CHECKING FOR DATA ADDRESSES WRITTEN TO CONTROL REGISTERS AND
MSRS"

  In Processors that support LAM continue to require the addresses written to
  control registers or MSRs to be 57-bit canonical if the processor _supports_
  5-level paging or 48-bit canonical if it supports only 4-level paging

[1]: https://cdrdv2.intel.com/v1/dl/getContent/671368

>
>2. These CPUs don't prevent the user from switching back to 4 level
>paging with values that will be non canonical in 4 level paging,
>and instead just allow the msrs to contain these values.
>
>Since these MSRS are all passed through to the guest, and microcode
>allows the non canonical values to get into these msrs,
>KVM has to tolerate such values and avoid crashing the guest.
>
>To do so, always allow the host initiated values regardless of
>the state of CR4.LA57, instead only gate this by the actual hardware
>support for 5 level paging.
>
>To be on the safe side leave the check for guest writes as is.
>
>Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>---
> arch/x86/kvm/x86.c | 31 ++++++++++++++++++++++++++++++-
> 1 file changed, 30 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index a6968eadd418..c599deff916e 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -1844,7 +1844,36 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
> 	case MSR_KERNEL_GS_BASE:
> 	case MSR_CSTAR:
> 	case MSR_LSTAR:
>-		if (is_noncanonical_address(data, vcpu))
>+
>+		/*
>+		 * Both AMD and Intel cpus tend to allow values which
>+		 * are canonical in the 5 level paging mode but are not
>+		 * canonical in the 4 level paging mode to be written
>+		 * to the above msrs, regardless of the state of the CR4.LA57.
>+		 *
>+		 * Intel CPUs do honour CR4.LA57 for the MSR_CSTAR/MSR_LSTAR,
>+		 * AMD cpus don't even do that.
>+		 *
>+		 * Both CPUs also allow non canonical values to remain in
>+		 * these MSRs if the CPU was in 5 level paging mode and was
>+		 * switched back to 4 level paging, and tolerate these values
>+		 * both in native MSRs and in vmcs/vmcb fields.
>+		 *
>+		 * To avoid crashing a guest, which manages using one of the above
>+		 * tricks to get non canonical value to one of
>+		 * these MSRs, and later migrates, allow the host initiated
>+		 * writes regardless of the state of CR4.LA57.
>+		 *
>+		 * To be on the safe side, don't allow the guest initiated
>+		 * writes to bypass the canonical check (e.g be more strict
>+		 * than what the actual ucode usually does).

I may think guest-initiated writes should be allowed as well because this is
the architectural behavior.

>+		 */
>+
>+		if (!host_initiated && is_noncanonical_address(data, vcpu))
>+			return 1;
>+
>+		if (!__is_canonical_address(data,
>+			boot_cpu_has(X86_FEATURE_LA57) ? 57 : 48))

boot_cpu_has(X86_FEATURE_LA57)=1 means LA57 is enabled. Right?

With this change, host-initiated writes must be 48-bit canonical if LA57 isn't
enabled on the host, even if it is enabled in the guest. (note that KVM can
expose LA57 to guests even if LA57 is disabled on the host, see
kvm_set_cpu_caps()).

> 			return 1;

