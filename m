Return-Path: <kvm+bounces-40475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 530F7A577DA
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 04:25:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B73E3B51B5
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 03:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D380B1531E1;
	Sat,  8 Mar 2025 03:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bJ6xBg4r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3E4AD4B;
	Sat,  8 Mar 2025 03:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741404298; cv=fail; b=Acv/PNvYrHbvJDfARescBA+qhdAPs0N2XK4HWnMxQ7yTa6DNplDUP6I9AoFdAQ9EjHf+7+j+DI+Pt48HBr+FrbVI4ED5bc0MhySPNXt3+IgZN5upEjX9nf5SlvaLDFj/bFwTawBk1kWtAOQ9Y3oZVT4BuoIte/Pecu943zPrqI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741404298; c=relaxed/simple;
	bh=NuTX8xe/XjOMPc2egeBvI2GxIbYZ3X1k5oKjervXQ+o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I5wxX0TzpWZHharJdY687PUaBK4uuFfc76kdubxZGTADmlmtpGfHkRSm6OlKXFEtBJ5lz1nRT7B1RuLOQ58BZr7eFNFWaVX6PWuSD81xvjFONtXzWIPFJfTQE1h8B2HOX6gqiZaVnX3+DwT3dGF+f4K+ajDEAbkyzRZt2W176Bg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bJ6xBg4r; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741404297; x=1772940297;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NuTX8xe/XjOMPc2egeBvI2GxIbYZ3X1k5oKjervXQ+o=;
  b=bJ6xBg4rEu/69hkLIFkRFgri2JTy35lpidGuxo3fzla1AsgOmYFWxb4Q
   p7o6zvn9014a0GDt8xqGsNedHAw6h/NyV2dMmCRU6VcZRyo5h2mHxkH4R
   i0Q126N2QpQCPZyLbpAUjzjXCOfcu9VEh7GiAK32HU5Y6jLFZmZDQk3Gy
   GYiPzgbObp91E98aFttkGiROSuzCnawQoYGmQZTaQR0mVG95tr0vSwhqW
   qobE4u+guKQGWWsQ5Z4rmxEryIDE8dQ+8WOJjQJGTfe587f6CXjP+BDeq
   XXab/kGKUIv+TSRvc5g0Bx2MhPv8PswDIKl9n1ifSyOEji60WV06cI3Pm
   g==;
X-CSE-ConnectionGUID: P6KoBHasTW+kz5UwVWjH4Q==
X-CSE-MsgGUID: nT9TIv5nTpmZuZ14O6zIcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11366"; a="30040886"
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="30040886"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 19:24:56 -0800
X-CSE-ConnectionGUID: 4CmHqahRRuaa2mB5Nb0iWg==
X-CSE-MsgGUID: t9bcOdUMRrigVPfciVSIQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="120010744"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 19:24:56 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 7 Mar 2025 19:24:55 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 7 Mar 2025 19:24:55 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 7 Mar 2025 19:24:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p4UkeJBQryhoaYUmdKJMbjsdiR1BLhFbxfIW8WiYWVFVk2m+oq5H9vTu/70ba62IBeq4WlY2bNDWfIHwgrn+rCzR3zpPYdNA8JJoQZ9bCyEscYDcCyJ4cvEwFEonlxMU5/gD23hOzLNWDQZ+VlbqyXCYQiRU+gBTdEuycsjIs0+HGPGWch4a7jp9t+rePc79yKw2lYU8exw6GJhLxGL3+Jxq3Jn80mFVRpOfEkFWNwQiIQ46+lpWeJRALd+wfrsV3fjdutfZKPJmiVAHf48g2ca8n+olU7n9CexSH87SL8BmcQVhHOIdLf3EUeIgTHRgYjeHzcHZ9u6VebZ57dZHjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3TlAhPWViDG26L2BNMPI9qpy+554QFkyyt7wp7IapI=;
 b=S7mu8P3vemOjfu4fKnWj6gtYOeywi+WnRH28+3EUdF1qdOVI6iE65YLepNcDA2ExXdzzi899IXgQYyOsAOEv8KK41+AYL1V76enDPlOrLpq38FwqGwnylSgkcBF9cMt0oH6X2D8pDroGSR7AWVFDZ8tBupCNg+GN0mN+IN16+1imhmFJhy2BxU3+WdwXnEHkVzF/gXm4zs5Xg65vyoc6dNYx9UAPMNZOpDHTU3Phx/Hs/OMlzFJf7bkmf1AeyaJo/y0EY01p2elF1YPrxWArS/hku/KojWHchQzo0F71yLukGuSXq8cs2imQaxd4vWOnO58CEzDAMcxu190tx6UUSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA2PR11MB4906.namprd11.prod.outlook.com (2603:10b6:806:fa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Sat, 8 Mar
 2025 03:24:25 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.017; Sat, 8 Mar 2025
 03:24:25 +0000
Date: Sat, 8 Mar 2025 11:24:15 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <tglx@linutronix.de>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>, "Maxim
 Levitsky" <mlevitsk@redhat.com>
Subject: Re: [PATCH v3 08/10] x86/fpu/xstate: Add CET supervisor xfeature
 support
Message-ID: <Z8u4Xwwp1wO/HeM0@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-9-chao.gao@intel.com>
 <74e49413-dd1a-4577-818f-b5b21b2a2b7e@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74e49413-dd1a-4577-818f-b5b21b2a2b7e@intel.com>
X-ClientProxiedBy: SG2P153CA0054.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::23)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA2PR11MB4906:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dcd8df8-0676-46ce-f0d7-08dd5df0b9f1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6orYwOxzmqzG45L8OZNDyAaG6TWvObS0UbdjmUCdF7Eph885m5Q76qKTzver?=
 =?us-ascii?Q?4gV5i+6H2Ipx7e4zjonDmD0Kswapy6VVmqdOHxXOMPB1yTKbL4qpip1jBFGX?=
 =?us-ascii?Q?60ShD7yriOy/h1W7uFN8MvviPWsCDlpc18d5alU+moPSwm+8IJuGRVnBUPNZ?=
 =?us-ascii?Q?PI8ycBrMI5gwKVNILMzxzieln32f3T7NPpMzpzXiuprEqC2u85XLiylwnPqD?=
 =?us-ascii?Q?C9SeU+V3/ShB+Gcl+1kTwl/wrCP3p9MdvlNK8SUis3KksCxUonxqwkFRyhmy?=
 =?us-ascii?Q?TT76fUeUWhkTIPFqFKpDEZWRUVqrTDS71XpFadpHrHiJXxJPdKkviaC5HBtF?=
 =?us-ascii?Q?7EwXbxEHtWHMo7qL96eH1Uo3xl0f5MdsbPFLMzte5H3BTkmcTIJLtE+O3ZW2?=
 =?us-ascii?Q?1ziiA6qfvxPy4cc66YF53qn6Br3YCylYcKW3CQAwRUHfZ/eBymMZ+TliHHoi?=
 =?us-ascii?Q?mzuTxtHxYieF1j5zuVkhVpe+zwJJSCWljJ6v0Oqu25QjyE3Ws3orDhXUPl55?=
 =?us-ascii?Q?3Q8zeAlSqOGSmGAnainc7DLWjoV+ca8dGzNkVvDm56G2HQ9SUQD/5BJ8kOvA?=
 =?us-ascii?Q?DMdDW3H5XXPi9BT9NWjSpeKf4vzV6Nev2ZK/QIoQ0zCkJ9/z81sWmFu33qf4?=
 =?us-ascii?Q?Of198Nnr50ay7iIe9R2cZ5FGCpDkeLfDZTSrb9sLZEtd3hyXuzfFlwqdFQLg?=
 =?us-ascii?Q?NC1xqsi1sJwd9WtNtt5tkcxx3M2zFq8QjqrkGukzT+BgkPrH6uIP5E9YgBWY?=
 =?us-ascii?Q?8Q94umw3vwH1jdTA/GXKRDJD+SilC6s+OK05v63GvUyJeVd7bsu2eN7begyj?=
 =?us-ascii?Q?JDsRmsd79o/T5o+QwLOUxLLGNovSEkgraNrsblUCsyEU2JLkbZZZuzb/4bgj?=
 =?us-ascii?Q?+4xeCqMsmBN8vQuKOsAedIH/eP1uc1zAvsC968EA6ZiME4ajxh5z5iivY5lg?=
 =?us-ascii?Q?Xs9ErturnjQ3T493VJ44Qgj/KaVyfJ28Zs3PQ5Be1hSSqc+OHrjh2xaWbOK8?=
 =?us-ascii?Q?mYICGdPBbVM4YJ9gXnivUYqNsSfmU3dSAC/faBXao+amzc07u5ufiIHE+lDy?=
 =?us-ascii?Q?ifs/muMidlb3ISq49qaVBwo5xojEPoGD+lYwoge3Oe0PmZvS2IzYf+HIptHr?=
 =?us-ascii?Q?voQos8ivfYI1ahVn+Fqee8us9CiauOHwYiTqP3LgfGhkCnwXn558mjaykQmZ?=
 =?us-ascii?Q?O510QOMopQ9/eHUCYLysKE6tDaGsqABS24lHdQmC4Q4optix4pjAs/z9TpNS?=
 =?us-ascii?Q?yQUqlF0tTTm4EB7wcPA+tx+YHNJgF23PjUq4x7wSwkbrqLN9FYhy7RzY7433?=
 =?us-ascii?Q?tN63RMYa9CGH/oUjREWhMhxolM81xyHpsGK6B+GIvTFGdyk6NUVnWvny+qlG?=
 =?us-ascii?Q?qXQHSxX6/9YbNuEGZoqdb3yuQrG/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1eMebXdqpclOpa3c50y4m9Q+RUJVPvEG20f3a99qVHv36EfgzlNlK/bi204Y?=
 =?us-ascii?Q?MuxGDbWZm9qzn57Zfr+BlL8ZW57Kr+iaYMKqi64DK0bFJ7wwMmiCMeWKW//D?=
 =?us-ascii?Q?1xm7Ef2RxZUmzr3hOhb5fs73AclWNGAfJ0JjLMXTPjbBKWilW78fa6QNTSh8?=
 =?us-ascii?Q?8bQAr3vDJzUNmZSBgr8i0yd1nRqnuKs2pKlNgw9oHxxDdSCZlt/f9kmicYJY?=
 =?us-ascii?Q?LwCEbIMrosdnGboQ0kqt5HLrWvaS5TJojC2e1Q8hT8t2JD3DxjI8Qgy1SEav?=
 =?us-ascii?Q?NRnWH9ZvnyGHlU/ajgwCcDFyzHweBAOve4bpofrcicZaivSk39Q4NE0wFSNe?=
 =?us-ascii?Q?Yo0ribbZROf/5Ezi9b9ODRQB8fG8CsZ9No/azwYzhosNGxUOUpMmQmzWZ/CG?=
 =?us-ascii?Q?VonuYq+6jfD+dxwdb9hsJqDNFS3LEBdKzLznvE09ELVnnPyyy134JPrLPqlq?=
 =?us-ascii?Q?Q2MPSwMorsEC556/aZnvIGxpsT+uoYm+lc1C+RmKYFK6xCRnGqV/6bFkmyhd?=
 =?us-ascii?Q?n7VtuygjG81Md+2KfhZGMRUe67taTwbIm2IXQOwxXu6Tl/ffVkdNkkb4ygMn?=
 =?us-ascii?Q?TT70DcGfdAyJIirMIDyyeVjwh4LyK2NDze7sj5YM+LwyPTvLQ+JPOsb4WqIo?=
 =?us-ascii?Q?d5GgMk2lWObOquhwt504gw5VuUr8kmauLGox9zg6zo3NCDMGxoavmT571qdv?=
 =?us-ascii?Q?4B/WFXSQXKnjgZDd5Y8PFCSOYFd29FFEpKa96blMw9497gTyr+/AOX43TVXP?=
 =?us-ascii?Q?7C+qmGT+7HTxNxX6YAu3nPhpM4ViOg6zBSXRjZqP0PmbPjn5bm6prJja2H9w?=
 =?us-ascii?Q?DG6CP9PQQ2k2b7D2i+HpRClv7FyY0/yqTciAttQYzFJ41X1x5iaO57xbGjTe?=
 =?us-ascii?Q?VkKUC0Dkg988KHD8W5mlpl2brKDVwHV6cQPk0S6tThrRDKI9wT5cGS0DP6FV?=
 =?us-ascii?Q?hIpNfjB51eALdfM/DSjnvEhdgsT4l80+87p/iWjMGavYoC8ND1DFqiR8UFnp?=
 =?us-ascii?Q?GE27D5sfGOm9/fLgT9uaPD8SkDI0VC5LuotkKeT/FQ7pCIkSLx1IqWL+SIiC?=
 =?us-ascii?Q?aRVrGMyqqT+Y9694vWznUZfjyCgKpCBKm1r733gt9jsxHAtoGU0vNLnBjiP1?=
 =?us-ascii?Q?XUXNSamaUoyr8Xac2l+xqflVwcW+9SnPrX1GMP0z7qpm+1gb7AvyJbqEflKs?=
 =?us-ascii?Q?PO8kDqwkD7/hR9/OBzbkTe3GkNJx0k9booGGYtgSwIvMmf0DeFHNN3JEFCEU?=
 =?us-ascii?Q?XfgeeVJqYibkZOepaoikIwGG2qEmdVXk2lAUkEhuTnmUTbLQjV5wKO8E8TIz?=
 =?us-ascii?Q?HnJMle2QJfqE7FGPyUdbZksyMxNQmU9xXtI3KnXpRmh6mCLfDPOQiZ91oBwZ?=
 =?us-ascii?Q?WaPWnuIiA4aLk9t3acrnaWWNd+boskqVwtXCgjeZ5khN9Mr6asRc5b5Ca40B?=
 =?us-ascii?Q?eGG1eptcgbVUjvQXjDOVI6/Y8e0wuYb8KHkp4eLU7LS+MW0S7GtAU6q7I/Us?=
 =?us-ascii?Q?iB1S+uebUCCXc0/Kvs6LHogrE1cHjgpcH04wSTVZZOPQUKximkNqO/XfKe49?=
 =?us-ascii?Q?rIkls+ztvaWnIRjnJDJih7cAAGcJTDkXBIvb+KKa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dcd8df8-0676-46ce-f0d7-08dd5df0b9f1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2025 03:24:25.0793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YtaTKTUER2hZ6JvtqFJG7XfR0p5MjZ/9pf5qYgI+oUdXuqoJDjeikMPDcuKBu08MoWlWZSJx8Kjk+m7p3G/NAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4906
X-OriginatorOrg: intel.com

On Fri, Mar 07, 2025 at 10:39:47AM -0800, Dave Hansen wrote:
>On 3/7/25 08:41, Chao Gao wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>> 
>> To support CET virtualization, KVM needs the kernel to save/restore CET
>> supervisor xstate in guest FPUs when switching between guest and host
>> FPUs.
>> 
>> Add CET supervisor xstate (i.e., XFEATURE_CET_KERNEL) support. Both the
>> guest FPU and the kernel FPU will allocate memory for the new xstate.
>> For the guest FPU, the xstate remains unused until the upcoming CET
>> virtualization is added to KVM. For the kernel FPU, the xstate is unused
>> until CET_S is enabled within the kernel.
>> 
>> Note CET_S may or may not be enabled within the kernel, so always
>> allocating memory for XFEATURE_CET_KERNEL could potentially waste some
>> XSAVE buffer space. If necessary, this issue can be addressed by making
>> XFEATURE_CET_KERNEL a guest-only feature.
>
>I feel like these changelogs are long but say very little.
>
>This patch *WASTES* resources. Granted, it's only for a single patch,
>but it's totally not obvious.
>
>Could you work on tightening down the changelog, please?

ok. will update the changelog to:

To support CET virtualization, KVM needs the kernel to save and restore the CET
supervisor xstate in guest FPUs when switching between guest and host FPUs.

Add CET supervisor xstate support in preparation for the upcoming CET
virtualization in KVM.

Currently, kernel FPUs will not utilize the CET supervisor xstate, resulting in
some wasted XSAVE buffer space (24 Bytes) for all kernel FPUs.

>
>> --- a/arch/x86/kernel/fpu/xstate.c
>> +++ b/arch/x86/kernel/fpu/xstate.c
>> @@ -55,7 +55,7 @@ static const char *xfeature_names[] =
>>  	"Protection Keys User registers",
>>  	"PASID state",
>>  	"Control-flow User registers",
>> -	"Control-flow Kernel registers (unused)",
>> +	"Control-flow Kernel registers",
>
>This should probably be:
>
>> +	"Control-flow Kernel registers (KVM only)",
>
>or something similar for now. XFEATURE_CET_KERNEL is *VERY* different
>from all of the other features and it's silly to pretend that it's the same.

Agreed. Should "KVM only" tag be added in the next patch, where CET supervisor
xstate becomes a guest-only feature?

