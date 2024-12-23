Return-Path: <kvm+bounces-34342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2EA9FADFF
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 12:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B542918842F3
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 11:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA1131A76C7;
	Mon, 23 Dec 2024 11:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YLu1+EbS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B398166307;
	Mon, 23 Dec 2024 11:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734955059; cv=fail; b=ZcIDejWGTjovFBnqVG87yQBmFWArtk+V1GCWkjngSQeFeTr/JPt2qC6qYPyLDcn+AropHopW6jINDNz48GT7+Fc8MiwdKkGQMwg8PeUSoqUPOQru1D1g9jT/iat5LZZI/YpC7aMROVSTCLtRIJ1AE1nl7eDEhAMSrkYCZS39UhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734955059; c=relaxed/simple;
	bh=ITX0nkMZcMy2d5y/EBEGCZHlP8Hkp7Dg+LGh95zy5F8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AYfTwjPNv/PrgRlkxMBpnGMRcSdfOONISsEelB1gONMT3+5BX2Lvb/A2lkkaJ/d3Q0EWasnNWOzH0/0X/9kPWJk/oWG+huiPlJ3wUjFXGtF3wvoUz/+7qMMSV2BcnXzMDBcuWn9E80SLsHzBtKl1eYV2w5A7mlJA/3DochBfbEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YLu1+EbS; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734955058; x=1766491058;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ITX0nkMZcMy2d5y/EBEGCZHlP8Hkp7Dg+LGh95zy5F8=;
  b=YLu1+EbSd5Cag0Jyz7BZGLjbMOQpl6oAqahGG/kloKqlTvCLmS0/JrC9
   KhD1hjpHAKYq889O1HWlTdJITuS8/VJLpsP19CLwcvld9k2k3ANeFGcmq
   CtFDcVfTpiEm3P31n4OckxI3DuMaRJSyE69due3nw4c/xIvzcMXsmtyYU
   RXSyW0rm+bR/7djFK4mCsa9l0pN3Y1gQAE49orrLFCcalHInOG68dG6t6
   FHgxyKcremcoLrB2pLmNr4EZGWxqZKxh9lDSosHbret5p2WKuPZE0C5sE
   nYQQKGwXm6MXupoilU52E93EYOCdJZDSXKx26j4iuEXcSDrR2iCXFuvK9
   g==;
X-CSE-ConnectionGUID: 3mWi2+0zRpyYZF2NYuIpQQ==
X-CSE-MsgGUID: 8g0S45ItQ4O4PKqm1j5Gpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11295"; a="34729401"
X-IronPort-AV: E=Sophos;i="6.12,256,1728975600"; 
   d="scan'208";a="34729401"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2024 03:57:37 -0800
X-CSE-ConnectionGUID: 3b6ViG7lRHaREUpk6RHZPQ==
X-CSE-MsgGUID: nofZs5DkQfClrbHNiGSHTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="136501481"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Dec 2024 03:57:38 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 23 Dec 2024 03:57:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 23 Dec 2024 03:57:36 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 23 Dec 2024 03:57:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UwblYFmXixbbkAJku6gGNzzTc9Ad1dNZPqNR3ejyF6iubZMCb4peo2RYc/iccuUuOMBEidk5Uq7awS5yjf1JT375wr5fzE8fEV3XEJqhrU9gYCifx+d1Ap2czWCGbIzZ4Lm+qilzNqejoX3ogDBwPWDNsLdcJWkyscB83Uz9ncTr7CjLVqrlCB2lI+Y+YGWQIQrYx8O23uaqCI8LWKs3sxEwwsP0GuSXZY5k+6CRiU8eKALCcvrJcP4WDmoF7PbbE76Mb/bjrMukjVGN95d2aTAWYbUPNbMAR7a0mmBoBEhxcDWM181Dm6bhqvusOZTCf7PeNCzsAj+VcBdBI7asFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Lgupcrh9Pyk62KksFUqiwytfCo76Rtgi09M30P2iFE=;
 b=aADmPnmTTug7HeEhVWomDnyB7Jl+omnFlwC2gZSkkcCrOT2jzMjw1UHOJFIzjo4AajI9+7jqV+60LbZhDXibYcZR4zUYvRjqWE7PRTZC9Ns1PlPgpmKSR7JM+LUDJMg2DpgkBbq9O9FhqM67L76JREuRYUtnBuB+EUmOUY0GRkjCjmv+mKyBSx68JMJrNtq9oUA0PLVX8V8uv3VVCI7mMO90sxRwRv5iYPoV66aRrVop8dFp6l9jvz70EwUxrLeAf0g/jQNbcAtdqQ8VHBHcPO4uLs1w2nPSTXrd/sO9QrZk7vL2YA8fq/cPsrRHU2iTFYzBeT6UlwmFMHRxVYbvrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB8044.namprd11.prod.outlook.com (2603:10b6:806:2ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.18; Mon, 23 Dec
 2024 11:57:30 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8272.013; Mon, 23 Dec 2024
 11:57:30 +0000
Date: Mon, 23 Dec 2024 19:23:07 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<isaku.yamahata@intel.com>, <binbin.wu@linux.intel.com>,
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v6 05/18] KVM: x86/mmu: Add an is_mirror member for union
 kvm_mmu_page_role
Message-ID: <Z2lIG5orqFxqi4HW@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241222193445.349800-1-pbonzini@redhat.com>
 <20241222193445.349800-6-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241222193445.349800-6-pbonzini@redhat.com>
X-ClientProxiedBy: SG2PR01CA0113.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB8044:EE_
X-MS-Office365-Filtering-Correlation-Id: c89340ae-1601-44b2-bbf2-08dd2348fa53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zjlvlxofdAqjFkA+mbsTcKoijVpHZwGfIu4Pq2PgSms0MHC3eYj4yb5gfGJ5?=
 =?us-ascii?Q?9LdNAvYXQcABlRKiquA6cX0z77SWpfIz3vRb55o7SNbSizTrMusl3oorDkjI?=
 =?us-ascii?Q?n7sVfImQphLaNE9wVFHzvy1wt08PyM25c8YYr0n2HnKl7/TqNd9/RyfW9Di8?=
 =?us-ascii?Q?gexvy8YwRcxqCRcNoVtwkNjSaZ2gDZVoyb3EHM5MSPym4hOdkey0r8eMUkkH?=
 =?us-ascii?Q?FBjcNS21E7009vIbbUZ20ccAuGTGctWZRewGxBkGN/V7cuke0ylN+QHIrdQb?=
 =?us-ascii?Q?Y/Y5EyxQ+v2Pa8UTjE2RtjgcXn4+dQnyYhkbFvR3fV2wBvr6kRRFRmAbfnC/?=
 =?us-ascii?Q?+L8h6r8gUDZZUXaRHlyAgT/f4ld3uAHGqjI1Kobo3gY7OmRkQxHPaPizz2YH?=
 =?us-ascii?Q?yjSkfune44DJX1+RQm7VckUB6FNJzOjXGu5GoZJihaENrIFk/mnkYkrT10mn?=
 =?us-ascii?Q?+M9apxouW2tNWuqLKYRBaticeQKZVgaSeedFsOmScgLcg3ktDsZhwi1ocmr5?=
 =?us-ascii?Q?QHthT3RixK0a9HxFOM2dYfxsThDjaIpp1XvC7p7afmeHXidomaRZ7IeJkOfl?=
 =?us-ascii?Q?hedjgG6aZi0QNt0y8iOIAUvNjnkZKau5tLt4dPapOEgO9ANlxLAoxH/Pvcfc?=
 =?us-ascii?Q?qHNUuIcJzeJvLzcAizXDNKwJjMkL8yCHbTBpO6xpdnEXPC/TdP9FuRQzkROk?=
 =?us-ascii?Q?V85qUqtfWthuJdWGxd707Ts52NQ+LjHSVti0jtxRAPPhqhvluCqkz7uZ4q0w?=
 =?us-ascii?Q?DMLUdmAriHOj8ZeDn82QCN/3RYSuHtGgTApeHuxdvaprsQMYRLgl23+haKMR?=
 =?us-ascii?Q?69/F6xmiK18wZZx6Inxk7J/mdy6Y9lH2KspzPrwUB1YdN699FKHCQrxEJlb3?=
 =?us-ascii?Q?aXRut/yjqwMOxiLI9/+5XgkHE2ul7PM0XZWO2iw+RrAF+yVrianDZ/jFr/zc?=
 =?us-ascii?Q?OhOY5nKhT7NLMAjLrQ/nHrfEWU4B721m6KCGKFwmMGumbMvzIrFSNP5QfCf4?=
 =?us-ascii?Q?kv/t/Ypyczn7IFS7oY2oRzc7X56RG3wDkXyKIs021H/fNSEESXqpsGD9o01P?=
 =?us-ascii?Q?SUov3Yenn7rta9ucrR0/2iRXsxunohB9xE7ZNnjRL9S12eC3g8ePDl/qTu9I?=
 =?us-ascii?Q?PgRnyvRia1QdhKX7p0BioPjEyO5vRm8VfQM1uhSe8fBr7Ylqozc2hyf8AIFO?=
 =?us-ascii?Q?quNQNsLr2MkKVWOUIUl0hzjr/xT+tlr2oE436rPVmrmSPCTEH173MsyF97LL?=
 =?us-ascii?Q?6qskCK3k3e1f/gVGXu/UKfpTmPqjrNpfmgrjqh9nFUZuvhgkT+lWRYe4+at9?=
 =?us-ascii?Q?mtZa65yzjDnqumhmv/8w/r/YPy8bombRa8OtdUHOdYyMLYLlLC4vPv1ZCeCH?=
 =?us-ascii?Q?gSa0EdhO4FApAc4RPGA8yQzTALHD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xNkBfioZfKYxOUoN43hPX3vBDb4ozBuAXPqwwc8azZTREQXo4VlBANN8V5Pv?=
 =?us-ascii?Q?K5fnF1OAEhCf/8JpjfI+A3Ciakcke2sdNWQAnJZjPq35uaG4u2rG1A0sWc2V?=
 =?us-ascii?Q?LcBXKqHr5K13ZjLOlwO4C4O1nAw7/Mt++7x3V1HaL52ChNXgWg2EK66apKe/?=
 =?us-ascii?Q?Q9+SijshgUfHHIXrkcvyFx4RlHq9twsc1x90H3FxedTWSuuuoEvXSde4L1xd?=
 =?us-ascii?Q?fuGkIXjfXiCHsyhow8WBEOpVEO0G0Yt8T+Kw0H4/VfG3gdZsNJcuuWqoHK0i?=
 =?us-ascii?Q?V0jvxehnV4fUfMPHRHfYIjdUgndSeP50P1FAqRx7zYcJxRGvMWcuKdNxWe0W?=
 =?us-ascii?Q?upshbQJ1AMogvxl9RzQBnmXVIG9ke2IUA+OybaUFDNoEwloPfjuuCC6C1TTM?=
 =?us-ascii?Q?/arwHL5fgEhk59crd6rI/efL2bAGEss7n80AIYJnW04ZKCPmyth0FpQZVY8+?=
 =?us-ascii?Q?jj4EH0lftAqbDcAcE3F1+YI7q+J+afzNjHhYVgSQhd+JLsQLeHbtYIqSy7e+?=
 =?us-ascii?Q?5SMSb2+PX/GyDITAQJA7lklxWT5uaF27X0LqOL1hfdp7V1pEjaNWfky0C6+F?=
 =?us-ascii?Q?D3vhBOkDOVmbHPPyFU4BKKW3Y4hGFb2pWWMW7P+A11FNgXSE1nHR/TsqxG7c?=
 =?us-ascii?Q?rTZynfac9r4i7XGIcKpqhXB9OHHn1BtYw7YO/4HEpl4F79PsiCzgBwlT+U79?=
 =?us-ascii?Q?fHwkW6VZcD9aunT3/KpEMlAagdEpgHg7FhHIjZ+tnkGQmlWlcHmoUyCW8Kc6?=
 =?us-ascii?Q?rX89gnoEzokTnK5rLGXh5Ji/2kr8eaOFFHHXq6p316FPhNpeVrpkw2f8ovn1?=
 =?us-ascii?Q?RNjVOK8FntBy5K2bAxsSWfKjIknwBq9CgIbsrtuVCQBPOxqcdwzFrWDL2D/s?=
 =?us-ascii?Q?2KrKnsGO3dVhWnw+XHttT5NZPJCbkn7HkF97n4BrUpgUUutcxHoO3gqTgZVk?=
 =?us-ascii?Q?ZUKHFxeeUSoWce2+RAzr/HOBgCh7a8LdCcdT7EufXOUZfsCHRoDDNDTdMurH?=
 =?us-ascii?Q?0yRubkW1X7eiXHjBwOEwzwbFDtrQL5ETzuB4OsIG0qor0fJivqW3ukhWS/oQ?=
 =?us-ascii?Q?FPEa+CvNHpMDRiAVB3l6ojW9th9JJjlUtimfeN0hiPuBdtfnydDj6GgIqTaP?=
 =?us-ascii?Q?5CidIf96MtjBb24D/QKD7rXVnxl61lG58fDw2+PVOPBS56G6Y/8tKDaDlluZ?=
 =?us-ascii?Q?HWPlwgk4/7m8oI/eRTtuGZ3WjnW5TGe5pJYQhnpMf+itsgxDgUMF64A1ZFAT?=
 =?us-ascii?Q?fiesbZsZbEzuygQAxqbbZY5xyjU9UMrrloZYg/dbjFLCsugt8mTHexizBOoA?=
 =?us-ascii?Q?ZjAw/rXCkuUPsk8BEypF/eA1CvTwBbDRLzzs5U4n3bL9A/3aipvFthhn597m?=
 =?us-ascii?Q?MFzU2RsA9uN/QVn2i71lXnVIIeouWP2FW20FypcN0Us/+UhFpcCMqnsnHx98?=
 =?us-ascii?Q?pP9s7UHTv9+hQUlqAYyCyAXorfodzn9lNuAbySqhZg8YhqydE1LNqCySwyxF?=
 =?us-ascii?Q?ckvIqU1DycPL+0xg9zEKpuQlZvv4DROFpE4IpT8eXOmFWAfW8Cyj0TL5Aeu4?=
 =?us-ascii?Q?FRpxfEWPka+90aEEbVY1o3tKMj63rcUx4rFYws86?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c89340ae-1601-44b2-bbf2-08dd2348fa53
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2024 11:57:30.2024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R2Y093rBY7/UFWVhdjlgJWORp8Dpz2/x6e9o9jeB+p76C7LK/h7DWk/N5NI2EJ55sxE1W6pLMqmhE2hDjEdzrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8044
X-OriginatorOrg: intel.com

On Sun, Dec 22, 2024 at 02:34:32PM -0500, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Introduce a "is_mirror" member to the kvm_mmu_page_role union to identify
> SPTEs associated with the mirrored EPT.
> 
> The TDX module maintains the private half of the EPT mapped in the TD in
> its protected memory. KVM keeps a copy of the private GPAs in a mirrored
> EPT tree within host memory. This "is_mirror" attribute enables vCPUs to
> find and get the root page of mirrored EPT from the MMU root list for a
> guest TD. This also allows KVM MMU code to detect changes in mirrored EPT
> according to the "is_mirror" mmu page role and propagate the changes to
> the private EPT managed by TDX module.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Message-ID: <20240718211230.1492011-6-rick.p.edgecombe@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 3 ++-
>  arch/x86/kvm/mmu/mmu_internal.h | 5 +++++
>  arch/x86/kvm/mmu/spte.h         | 5 +++++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5f020b097922..cae88f023caf 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -349,7 +349,8 @@ union kvm_mmu_page_role {
>  		unsigned ad_disabled:1;
>  		unsigned guest_mode:1;
>  		unsigned passthrough:1;
> -		unsigned :5;
> +		unsigned is_mirror:1;
> +		unsigned :4;
>  
>  		/*
>  		 * This is left at the top of the word so that

Sorry for not spotting it earlier.
We may still need to update the comment for kvm_mmu_page_role. e.g.,

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4b4976fa95ad..07adf7c875f8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -315,10 +315,11 @@ struct kvm_kernel_irq_routing_entry;
  * the number of unique SPs that can theoretically be created is 2^n, where n
  * is the number of bits that are used to compute the role.
  *
- * But, even though there are 19 bits in the mask below, not all combinations
+ * But, even though there are 20 bits in the mask below, not all combinations
  * of modes and flags are possible:
  *
- *   - invalid shadow pages are not accounted, so the bits are effectively 18
+ *   - invalid shadow pages are not accounted, mirror pages are not shadowed,
+ *     so the bits are effectively 18.
  *
  *   - quadrant will only be used if has_4_byte_gpte=1 (non-PAE paging);
  *     execonly and ad_disabled are only used for nested EPT which has



> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index d9425064ecc5..ff00341f26a2 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -157,6 +157,11 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
>  	return kvm_mmu_role_as_id(sp->role);
>  }
>  
> +static inline bool is_mirror_sp(const struct kvm_mmu_page *sp)
> +{
> +	return sp->role.is_mirror;
> +}
> +
>  static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  {
>  	/*
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index af10bc0380a3..59746854c0af 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -276,6 +276,11 @@ static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
>  	return spte_to_child_sp(root);
>  }
>  
> +static inline bool is_mirror_sptep(tdp_ptep_t sptep)
> +{
> +	return is_mirror_sp(sptep_to_sp(rcu_dereference(sptep)));
> +}
> +
>  static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
>  {
>  	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
> -- 
> 2.43.5
> 
> 

