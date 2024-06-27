Return-Path: <kvm+bounces-20597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43A0591A30C
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:52:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89612B22B32
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 09:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A7113B58B;
	Thu, 27 Jun 2024 09:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iz4+Zwp+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED51713AD1D;
	Thu, 27 Jun 2024 09:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719481939; cv=fail; b=cOPylIxKXeSncRIZhrCc7C5MlrxiENCG1iFNksHCLMgGD4op4QljSbCYfYCzS1dgPNicylkqvh0T4DpFYo0sc2Hz233ip4dzasH65hfS2VJgKZv+fSuknaBGPCdr9LyEcjP+kTfOuneuIWo9dKv+GxJlrQex997JVyFqcIk6Cpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719481939; c=relaxed/simple;
	bh=bkhGfgj/PN6K7TiZZFOH9Dv/CmPqHkj0DGYVuE4Ve/0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MG5SdYbKcUfvxS/gTqonGxZa+UxAP5wgHuqKXfPNU0AZibLSkVUafHQzaZb6kcT6z4ZCw/wEPrXPwY7V7PHd0OqYwvvjXvS6D4rHSoRo2QF4BHy/QrnUuSiNE/riRNmkkXteR0b4bxN7/kjis87ul84mAuoPJSOKQBq8BwNhzh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iz4+Zwp+; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719481938; x=1751017938;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=bkhGfgj/PN6K7TiZZFOH9Dv/CmPqHkj0DGYVuE4Ve/0=;
  b=iz4+Zwp+H40YtNS/fdhtUqDtRSKGYTlE20/4UgEyyIjGr6iys11iHHnr
   1lJFgxne8pj1+U4BE2qlwE950WcyLfPY0QhDmEZx9f50dmcTWm+KSCKD9
   VqyqHyJNNE47I8wXwC0XMqJIcJMGlPlKywdSWXS0jy6GV+3h6G48/ZC9p
   FkmCGAQ8pg56sBcPs0ocVYbkGHoUp/OretPULpQNFRlIf7Hoev0MCBKPz
   fkeCshdMBFPwxNpNJG1W6G/YhU6PZDMdLhl+QsxwL8MceuPDFJ4zPESdX
   5Z0prdt5FNzG+YdtdkAoAO/1RhNAAxJwTMuyYNIKMipkF02zMYFRsCMex
   Q==;
X-CSE-ConnectionGUID: SRiNq7nrSEudZA7wBiDkwQ==
X-CSE-MsgGUID: 5VVgjJs2T+eJBcLLV+UAAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="16744585"
X-IronPort-AV: E=Sophos;i="6.08,269,1712646000"; 
   d="scan'208";a="16744585"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 02:52:18 -0700
X-CSE-ConnectionGUID: w19zk246Q6Cko504wHJgNg==
X-CSE-MsgGUID: w2OVGRKsT3qMOItruoiVAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,269,1712646000"; 
   d="scan'208";a="48927276"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Jun 2024 02:52:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 27 Jun 2024 02:52:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 27 Jun 2024 02:52:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 27 Jun 2024 02:52:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEtlwU8Mt6ojeScNxmsxe1dUgoBzvHKUsnFWxDd9GLSNXuaFZHWNMUDcN9XR0i/I8wW01xcpAQKQ7GYYskPL6rOPy+GUzgxAD7NT4L/a1mkL+ypuoR2Wm4e35yR6jiRuNYkNKlNY47wuRq6oiJKtkkwHHtaZgtfggFZ24iVE9o2bI7U2bUPrPUs9C+F9vAAP4y0espPVWnuCcrEwMaD2uYRBbiiqtOxhEHbd/FsPHyuIW0So6FgzxFrdSeMKjVsWp97bNDGb7+I/Npdp/jFXk4NnqgI3rnGXfJio3GIyDehKcV+0LcdeZUsJ3H27Ear0Jl86k/rK5ArJPcQO3/VodQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2TsvAKliNSCKDWN6Mbko+tuIJe78Na9ESdNkuR0J/is=;
 b=Ga9Y1fUrl9oYHpitw2xij5SeU9EnpQurT5SgHLXndqArgfXfxIoZIGSG6IcWAjfzCV9mnp5KHswtBH7mVoew+Zk95HtgxSdRiepBs7kOFGPjqUutYstKqNluTd+ePELNh7wcG8YLnbN8qUiPx8jNxzSFVX05xgWreRkjqiMZWKtdRbWX6iuC8mPKzXBU169mY4jXmQWSpGMwX9tT9+LB8Lg1Skq58+5xnef78nmyM0iuoLaC5+3BzbZssFbv014Fa6ZCUTGcGTAdl+V0L6iho5LB8xyviqjcrlLl2Q1OrSxYSUIZy2LEpL6khtTWvKVuAAx2Ig5nP0mgVw7Q+7lKRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB8353.namprd11.prod.outlook.com (2603:10b6:208:489::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.26; Thu, 27 Jun
 2024 09:52:14 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7698.033; Thu, 27 Jun 2024
 09:52:14 +0000
Date: Thu, 27 Jun 2024 17:51:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <20240626133528.GE2494510@nvidia.com>
 <BN9PR11MB5276407FF3276B2D9C2D85798CD72@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276407FF3276B2D9C2D85798CD72@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SI2P153CA0010.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB8353:EE_
X-MS-Office365-Filtering-Correlation-Id: ec62c98c-dbac-46bb-c32d-08dc968ed2c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?iPeVN/K1BWmgYQBYHBB0pzxFhC6jYGetYUt/gxn3Myki3nOwged851KEonLk?=
 =?us-ascii?Q?FKx6rltKec3UkDgMeoSS0S0Lb0/mxU4PafsOEvEPjoU5zLCpJcH1WpzgpIiM?=
 =?us-ascii?Q?toE3BY64MXaOc0A9aZnfzBIy1pbJ0DDNnXnUe5guRtBUSsdL4z7s16z+kouA?=
 =?us-ascii?Q?8ybSFPaoOpVyotxFBPzUSrJ0+X4Gu6XbLFqmsDK13Z2BvPtKuLYtAlQntKxX?=
 =?us-ascii?Q?SRylVrpDVwUCvwtxyw7+0mTV5bzbMz/PWqaICI89FT4ZQXWhYq7TI4qa3wvl?=
 =?us-ascii?Q?qO/4vAAT4az8TvX3uke5wLZ/VLpUdnWntGGPsMWSfaNa7hydJHB+qm6hJYrS?=
 =?us-ascii?Q?364/NHREhsJDq8oP1hdOEsXiVv7PUCY5s/v8+oj1T8EQZ3Xn8zI+8YVd7anE?=
 =?us-ascii?Q?hMtpTCLR8gj9WgvPFCnwX1VjKZM/So25Lx7RpF+9mxa3qw9hEoue+gBjLDeV?=
 =?us-ascii?Q?pLxHZZus20IzQhWCl+4UbJkaHRwsxdutm6t23vhwhTbsrNpCNKpFY3XHprCk?=
 =?us-ascii?Q?Mwv0NVgqJ1Nij/GkHbyb84JThRooSZ5/ckrJTSk1z5voQ+Y0GomN10BRiy46?=
 =?us-ascii?Q?Ot1hi9qnezMUyCl77Eri/zGzj8Hy8ZnnIB6Qv1B1IvHD5QsonbbsvNY+wyKa?=
 =?us-ascii?Q?ZMIQIsK7A943bO3EzDqwkKz3jj711lO6gn7YMMhxiNqYP5ncG4542oXHN+EE?=
 =?us-ascii?Q?GxnPNKU5x39wo0VNAaLlkL5Y5u7DLIJ6tAodM9MQJpC/HRV6hRc3PLiQC076?=
 =?us-ascii?Q?YSEopmdEXRD/aIu9d8QNLdhJ+4/RVKixCwK0cJ0/k5SFSOok+lz1sbQYIky8?=
 =?us-ascii?Q?hZ/6xOr1MNOyuuiSi0n6Hw9kmb333B5HQTz0YLwLCwyi/sMx0RN+4NGdx50U?=
 =?us-ascii?Q?lXRDKjzu9x/z0F6hv3a1L7nblll0UULFnBWTsyvD1SrwjgNFMzy/wpfDXnYo?=
 =?us-ascii?Q?Dm0fS7EuHlreCKW3Zgf/ArUKHr3GDNNbTss4Mx6PAf/R8p05rKNtIICuGse1?=
 =?us-ascii?Q?tSZcYFVrKCNL9pUkXOxDRA+V+dkZw9tKF6wUlPQt7WgIj9FDRZH5GQIiMT62?=
 =?us-ascii?Q?2WHTh8NjSTZYNeRfYe/tqIrq4fGqDt5a7xvIjXi3Lu0mdKNr/EOKwXw4DK0b?=
 =?us-ascii?Q?BvzFZNKV77/wm2UQ0TYci2rWq8A/tjHjANBHatp11ALn6OM8YlmxcCNNZnzt?=
 =?us-ascii?Q?SzDdcHQOn6jMxd+CrMhwfOotGVGhTIhUKyYtuFqpujesbtZokrws0e+ROW41?=
 =?us-ascii?Q?7jH0fQ4X7kgrgTvtKC3YHLfyk8ilRVE4WAArEjLghrnkDDiItneaOeubLitH?=
 =?us-ascii?Q?XRUorE8gzZxpp0OtyJS7dsxgzu0OdKNaHrnTr3KQXsS/iQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XdZtR7p1spxrAVoOLvzl9sBmyKV7QjVxXp8ANHPz0TDNiXTBZ16ZbqbKdWq+?=
 =?us-ascii?Q?UEG3bFmar58xY4Hs9QSxKaZHPFnKH2Y96BJI0ujPMOyZ/FgJTRSjyxpz2Yha?=
 =?us-ascii?Q?Besn/GUHyPSNP03yjzuxKHgJynXWOb/dMIE1Rj+iNlntUSXVPtfClAMc2Nl5?=
 =?us-ascii?Q?z401BA4H0Q+MDA8IZRPrYVLlNcS/QdX/AJ5vPKFxoXaM5aDO7rZHhukbz13a?=
 =?us-ascii?Q?8ptqR28ZI25C5te8j4dXn2HtqcgXnYc5XCwK6jFSX0wkJKsoi8pm+NM14aH+?=
 =?us-ascii?Q?y+Ny1Q1C/oDdH1fvwAHnvEcLr+cs5fH9blTO7VNEYvEDqXLns/cNWfvDORvv?=
 =?us-ascii?Q?zf5GdPWHsrbFgPs0HF9Q4d2gGECjqRADC0iAlP2+tmzpW5Vw4A9+rvYYkN65?=
 =?us-ascii?Q?sDsBO6HkifNv7Vvj69cpGpXyheoMV8bg2PKwP30JWvSjzpCrnDel3AFkovUG?=
 =?us-ascii?Q?Ai+nf8knWxGXDwMgtGcLPVYajGvn7IhH8lAUlcLgCGoFXn4/li2aeXbmT9FW?=
 =?us-ascii?Q?X5G+1Ycu/nNyk3qfmKKNxpmCgV18Rldqr6+XRG+GLZiKpEooV07ewUlKfxVw?=
 =?us-ascii?Q?HrvQVpXEKrLGoSLRpC5VZHBXYx6A1jgPuF27dHqdjQ+fxyyo1vAgjS5J08Ex?=
 =?us-ascii?Q?fzqA7FmeziXRYOEQuD80iuzIxiMwJr7QDcobWzdxWoO4lRb68XA4T84ESY4+?=
 =?us-ascii?Q?+5pdVybsKyT4ezIsxPhJVn2L8TdGn2lDSSuuCRiR54xJLJ/YfkXOuFbJok0t?=
 =?us-ascii?Q?/3pHl7xuMYdPdNaYJozsBYgN7tIBaDZiKWk83Y2jUwn/pLp0n9NvZI0fTS6W?=
 =?us-ascii?Q?XvvKxJ9sVyOeJmIvwAvJi9Bt1/muLxwyJ323/tcXMsKpht5lo+a+K3h5OqhG?=
 =?us-ascii?Q?Ryl2ZDvnLu9q9zbixwmCzXF1SDnkAd+rx/EL/Zjnm4WawDXJG1lAJaqr7Ui3?=
 =?us-ascii?Q?iRKJQwytA7pXHqxJxkpBqBPI7dHbas/2lrUkmkg37hMCzBja89h3PcPi6CRd?=
 =?us-ascii?Q?91Ob4RtsL5vTVRssyJDd/akz41qLUlRZvCI0G7aDlw88szMfp/Q0g0UsJgLy?=
 =?us-ascii?Q?rCKalt4OFdHjhcR6zm/9tQ1tR/XV8Z6mnHET59vn/hGRQjY9ePQNyTKjFJ+h?=
 =?us-ascii?Q?NUnYwxioWg5plrgl1zAtQZw7vAM5tmbGjOvb1g8AA72298JdEM7Qmqti9Jqd?=
 =?us-ascii?Q?we+g9TOjtDGKOtC/X/MG/V9Ukp+FNtW/e8CzMdWWzyiea9V30do+y1R6WRxT?=
 =?us-ascii?Q?Lsa0gScVM7/vLRjwEKNJg1nOckBJGQvSZ7duedLPdCLdf8PiM4HZzOwQnOsu?=
 =?us-ascii?Q?LuUB+Bz63FSY4XMSfcx+tEd/sdr0LE76j59nZo7A35qpCSVO/LiQoaosu9SU?=
 =?us-ascii?Q?/yGGIzZ7dShUFOawLbaj/TjQulARwwhd23gL0b+Q3XHJhqbRtwsG1dnz2k4D?=
 =?us-ascii?Q?grZ0zBWeJAU3KTbyUKZ1B2ciZH2VLIt0Ov0Iw89VS2nTNZUNHMTAoyhIsAZs?=
 =?us-ascii?Q?2/Uc5efswFRc4Cd+NjVjtG+Q2xBOMLZ9RFrVDcqyR9+H6+r8o8ClAatM9DZF?=
 =?us-ascii?Q?w5S8fHspFNQo0kW+3EMcmU8jdJQqJj2Mmr7jvWqH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec62c98c-dbac-46bb-c32d-08dc968ed2c3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 09:52:14.6987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /daPJkghKZdbvUoIHL3qZjefe19C8BGCch8GR23NxsXZeJH9Yc6XZrULoCzUiCMIbVQVeClHIeW9TCNiheCHqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8353
X-OriginatorOrg: intel.com

On Thu, Jun 27, 2024 at 08:17:02AM +0800, Tian, Kevin wrote:
> > From: Tian, Kevin
> > Sent: Thursday, June 27, 2024 7:56 AM
> > 
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, June 26, 2024 9:35 PM
> > >
> > > On Mon, Jun 17, 2024 at 05:53:32PM +0800, Yan Zhao wrote:
> > > > Reuse file f_inode as vfio device inode and associate pseudo path file
> > > > directly to inode allocated in vfio fs.
> > > >
> > > > Currently, vfio device is opened via 2 ways:
> > > > 1) via cdev open
> > > >    vfio device is opened with a cdev device with file f_inode and address
> > > >    space associated with a cdev inode;
> > > > 2) via VFIO_GROUP_GET_DEVICE_FD ioctl
> > > >    vfio device is opened via a pseudo path file with file f_inode and
> > > >    address space associated with an inode in anon_inode_fs.
> > > >
> > > > In commit b7c5e64fecfa ("vfio: Create vfio_fs_type with inode per
> > device"),
> > > > an inode in vfio fs is allocated for each vfio device. However, this inode
> > > > in vfio fs is only used to assign its address space to that of a file
> > > > associated with another cdev inode or an inode in anon_inode_fs.
> > > >
> > > > This patch
> > > > - reuses cdev device inode as the vfio device inode when it's opened via
> > > >   cdev way;
> > > > - allocates an inode in vfio fs, associate it to the pseudo path file,
> > > >   and save it as the vfio device inode when the vfio device is opened via
> > > >   VFIO_GROUP_GET_DEVICE_FD ioctl.
> > > >
> > > > File address space will then point automatically to the address space of
> > > > the vfio device inode. Tools like unmap_mapping_range() can then zap all
> > > > vmas associated with the vfio device.
> > > >
> > > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > > ---
> > > >  drivers/vfio/device_cdev.c |  9 ++++---
> > > >  drivers/vfio/group.c       | 21 ++--------------
> > > >  drivers/vfio/vfio.h        |  2 ++
> > > >  drivers/vfio/vfio_main.c   | 49 +++++++++++++++++++++++++++-----------
> > > >  4 files changed, 43 insertions(+), 38 deletions(-)
> > > >
> > > > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > > > index bb1817bd4ff3..a4eec8e88f5c 100644
> > > > --- a/drivers/vfio/device_cdev.c
> > > > +++ b/drivers/vfio/device_cdev.c
> > > > @@ -40,12 +40,11 @@ int vfio_device_fops_cdev_open(struct inode
> > > *inode, struct file *filep)
> > > >  	filep->private_data = df;
> > > >
> > > >  	/*
> > > > -	 * Use the pseudo fs inode on the device to link all mmaps
> > > > -	 * to the same address space, allowing us to unmap all vmas
> > > > -	 * associated to this device using unmap_mapping_range().
> > > > +	 * mmaps are linked to the address space of the inode of device cdev.
> > > > +	 * Save the inode of device cdev in device->inode to allow
> > > > +	 * unmap_mapping_range() to unmap all vmas.
> > > >  	 */
> > > > -	filep->f_mapping = device->inode->i_mapping;
> > > > -
> > > > +	device->inode = inode;
> > >
> > > This doesn't seem right.. There is only one device but multiple file
> > > can be opened on that device.
Maybe we can put this assignment to vfio_df_ioctl_bind_iommufd() after
vfio_df_open() makes sure device->open_count is 1.

e.g.
-long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
+long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df, struct inode *inode,
                                struct vfio_device_bind_iommufd __user *arg)
 {
        struct vfio_device *device = df->device;
@@ -118,6 +111,8 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
                goto out_close_device;

        device->cdev_opened = true;
+
+       device->inode = inode;
        /*
         * Paired with smp_load_acquire() in vfio_device_fops::ioctl/

 @@ -1266,7 +1296,7 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
        int ret;

        if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
-               return vfio_df_ioctl_bind_iommufd(df, uptr);
+               return vfio_df_ioctl_bind_iommufd(df, filep->f_inode, uptr);


> > >
> > > We expect every open file to have a unique inode otherwise the
> > > unmap_mapping_range() will not function properly.
Even with commit b7c5e64fecfa ("vfio: Create vfio_fs_type with inode per
device"), in group path,
vfio_device_open_file() calls anon_inode_getfile(), from which the inode
returned is always anon_inode_inode, which is no unique even across
different devices.

> 
> Can you elaborate the reason of this expectation? If multiple open's
> come from a same process then having them share a single address
> space per device still makes sense. Are you considering a scenario
> where a vfio device is opened by multiple processes? is it allowed?
> 
> btw Yan's patch appears to impose different behaviors between cdev
> and group paths. For cdev all open files share the address space of
> the cdev inode, same effect as sharing that of the vfio-fs inode today.
> But for group open every open file will get a new inode which kind of
> matches your expectation but the patch simply overrides
> vfio_device->inode instead of tracking a list. That sound incomplete.
Yes, looks it's incomplete for group path.
What about still using inode in vfio fs as below in group path?
(I'll post the complete code which have passed my local tests if you think the
direction is right).

BTW, in group path, what's the benefit of allowing multiple open of device?

struct file *vfio_device_get_pseudo_file(struct vfio_device *device)             
{                                                                                
        const struct file_operations *fops = &vfio_device_fops;                  
        struct inode *inode;                                                     
        struct file *filep;                                                      
        int ret;                                                                 
                                                                                 
        if (!fops_get(fops))                                                     
                return ERR_PTR(-ENODEV);                                         
                                                                                 
        mutex_lock(&device->dev_set->lock);                                      
        if (device->open_count == 1) {                                           
                ret = simple_pin_fs(&vfio_fs_type, &vfio.vfs_mount, &vfio.fs_count);
                if (ret)                                                         
                        goto err_pin_fs;                                         
                                                                                 
                inode = alloc_anon_inode(vfio.vfs_mount->mnt_sb);                
                if (IS_ERR(inode)) {                                             
                        ret = PTR_ERR(inode);                                    
                        goto err_inode;                                          
                }                                                                
                device->inode = inode;                                           
        } else {                                                                 
                inode = device->inode;                                           
                ihold(inode);                                                    
        }                                                                        
                                                                                 
        filep = alloc_file_pseudo(inode, vfio.vfs_mount, "[vfio-device]",        
                                  O_RDWR, fops);                                 
                                                                                 
        if (IS_ERR(filep)) {                                                     
                ret = PTR_ERR(filep);                                            
                goto err_file;                                                   
        }                                                                        
        mutex_unlock(&device->dev_set->lock);                                    
        return filep;                                                            
                                                                                 
err_file:                                                                        
        iput(inode);                                                             
err_inode:                                                                       
        if (device->open_count == 1)                                             
                simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);              
err_pin_fs:                                                                      
        mutex_unlock(&device->dev_set->lock);                                    
        fops_put(fops);                                                          
                                                                                 
        return ERR_PTR(ret);                                                     
}              



