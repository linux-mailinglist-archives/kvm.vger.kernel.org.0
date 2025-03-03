Return-Path: <kvm+bounces-39838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 724E8A4B5C5
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 02:25:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EC4F1885088
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 01:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 176B613C9D4;
	Mon,  3 Mar 2025 01:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k03e5l6w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F1D8634D;
	Mon,  3 Mar 2025 01:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740965102; cv=fail; b=j9TnMgGZl2FcxrYR5c0vp9NnLcfIgeemFmWoc6mw2Y8zGNk9UvC5sEZayxBQr/kuJ17BlXFn0e7Yb+0/qi1q5962SjeRgvxQSZ6C8q5sfYLdRkXjjD98KMEaz2Pofl4b3INA2ooujcmKZQUCDZoIs1E57LQB68azIZEZ4gilITI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740965102; c=relaxed/simple;
	bh=6WkE1QSf9IKhQ5dXW7Jif0tmxO518g06Br7IFOLJrHs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sCvJJRZYvZ0IYn5MXH3TqHcEJLLHcDoHXJKrf1shS+oQ5aL51bPKpsspuXRaqFg39gn3uAnbK2yp3ue1u0jTtQ+tISjXuQrJtZn0mcb/bg9rFwFAgqaLC7Fwj8r+D9lUk5Yw9SlL74ZoTDXu9QjQ4Xw69Gq9rbUiI6Fb7IOyJ6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k03e5l6w; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740965100; x=1772501100;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=6WkE1QSf9IKhQ5dXW7Jif0tmxO518g06Br7IFOLJrHs=;
  b=k03e5l6wCB+5Bu8U5FdcW6ZxooUI/iZ0HPorNqMFJ5ycXfMhdqvl4knG
   km/X8fHbpOA2Q4dPuNcTV1OwxqH2uVlG+BmyxTTlyvP5FQnD+toY1rSd5
   juDnCPrfRQ/3XojOFjJPiCeFmP5CmmU7XI8Sjk+Wu/S5IB+XybdLwEZoQ
   efFO+aHT0bBjkjnGI01Z5jxAVLdcLwFzbDzY/9U2e9Tu46zzW3OqDF1xC
   1yYnrDmbuw3/nzW9k1TPk9C+sr9BnLVrPGjSSpLoJBCy6sEzf3+5FhWX1
   mwcSTY/1gNOMVOlH3H6+9iLX9kv3uUQ+IEeev495+bup1tmrU2y908dj3
   A==;
X-CSE-ConnectionGUID: ky0ugAwQRoWJbyvdTDZSZA==
X-CSE-MsgGUID: VMdBE0YGSzyglmLgiLLKPA==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="67200544"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="67200544"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 17:25:00 -0800
X-CSE-ConnectionGUID: GbDr0ZhPQHq1+00Bf8Vjlw==
X-CSE-MsgGUID: d8YFLso6ReeGLKxH1l/pTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="141079477"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 17:24:59 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 2 Mar 2025 17:24:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 2 Mar 2025 17:24:58 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 2 Mar 2025 17:24:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gEFDu4yLwyNt+nIsX9CjuWJlpOIsm2XElXrYCBDBGgeXpVT0hzJ3FkmBllCd6dTMilnTvjlMNoUkOX99tuPZ5956dWDGJ/EbS/NlpM7suFtDWQLf6ZPHmCmdultGxA5MtB6mTQZb142dMhj1gwAlPmS1p8sie9xagu8BIm8TQVXMnNach+R9rGtVf87APVgBfQcPOojGSO4sMxHjYcZ1JqrIUQ6JAd2IbQAp00D8n4tEp7qU19GAYbPvu5qZUfpgodYDzR3KRtPC2aKQustGNBr+RO+59B5ysPUiULoZ3BzrNVknjPE11Z+85tT2m3OaSLeyzlzog4q2UaGcLw1VEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ua1GP6Cb9wWR/I8uP7YOWCFyrC4qimnnzd+nvozqCY=;
 b=k0wKVgT8KJLzo+agTVVjZ9cWRn5XrYFug0SorONzXyAojkKX+yrqnaW/SN+wxjcrfPlJqbFXJaVUEe2SHHW4nmlST5QMBifgkw/FJA63zYNdlXuZ91bFRG5Dp0/ETbfvb9weVJ7CG/Pz6O9IG7zDh6RNBXCy7gKHR9gLiIbIHl2/+E3eXQH3x65JKvaBIHlzG8u2vxTe80/V26qbgSMCQIYXmpanqaMjtHP1TH9l1qT0j5F0LszfCystwwVqCHnRK0vL6KlZ/8aJLwk/T1AafkE0Uh4PHEkG0Hv/a1hZ4ekkLtY2jRxpamEnn7uchbCTkV6o4YXMU6hqSo1JHTYHWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7188.namprd11.prod.outlook.com (2603:10b6:208:440::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Mon, 3 Mar
 2025 01:24:55 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 01:24:55 +0000
Date: Mon, 3 Mar 2025 09:23:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 2/4] KVM: x86: Introduce supported_quirks to block
 disabling quirks
Message-ID: <Z8UEmKhnP9w1qII9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250301073428.2435768-1-pbonzini@redhat.com>
 <20250301073428.2435768-3-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250301073428.2435768-3-pbonzini@redhat.com>
X-ClientProxiedBy: SG2PR02CA0126.apcprd02.prod.outlook.com
 (2603:1096:4:188::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7188:EE_
X-MS-Office365-Filtering-Correlation-Id: 12a45aac-69c5-4420-8da6-08dd59f234ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?92GeyEsuZzug1vvXTse0t2kDvrW74txO0TCC4JiEsxGx41lTZdMCiWYdZHSh?=
 =?us-ascii?Q?nrCgOKFZNvOnUZRmjUh7D/ygf9XQCE1bi/FtC2BmsWXH1iIM6qyA+bkYBDLY?=
 =?us-ascii?Q?bYV93XNMvdyRgzZNRCqpW+VkmaiuShmPdwm4Zc1/M8TGK+Px/KwpXRbsKH1v?=
 =?us-ascii?Q?OcY0v+nvbAe23m+Gq9TD3sXzY4K+0vza7crS/jwekmGlNhnlEoPzsd5qcD4o?=
 =?us-ascii?Q?Qv6BVDa53mbxhT8Veq1EIkeEKGEdBG2VfdT9/8wlSD1MZIlEUZB844eON1vP?=
 =?us-ascii?Q?Ti4ixeLti6TYWRJ1pW7iZpvOFYryjwZ2ovw7tAox9GqHVXeN10Nl8GVpFV4+?=
 =?us-ascii?Q?mINdmHcTmkk/LmcmVLNwcR5v03eoOML4G90CCPCPfXccvrq2Tp8wtNy38leD?=
 =?us-ascii?Q?XNC7nKf4RlIVaY1hlS6JLuCEcbbyT3SVpSI0pv370giUpg6DAZU220BEwUHB?=
 =?us-ascii?Q?Y/dHuxw/YZOsKwtUGXtfyEyJcGj6p2Ib6mHhIoi4PGNvFt0KBl7sbf7qEgrC?=
 =?us-ascii?Q?yr0DojB7j8shVwX5/vQHuVFQ9IcBgGB+pk+afHH755Bo0fNpii/7yyL45xIS?=
 =?us-ascii?Q?sfQJVogJMGQsfsi3Ah1yM1Wi/aWHUt3huwUSPb3pLGzSQDiARDc5KoHbWzmT?=
 =?us-ascii?Q?c2pDqboxdVzlwV5/XCEkP46BtUQQg5Rujk5InMNZJPQwJL8QVmULt48udu2U?=
 =?us-ascii?Q?hnM5SxPPwX89wrRx2K/GSMqDWyo8PnEonkrbziGFe644oGi8QN5Z/X1iwvRM?=
 =?us-ascii?Q?rKDZjWPt3MoSEp3meRKG99gsa/sqRqW+gDakxhwLVdvHw6k4JfbyuISdZl4A?=
 =?us-ascii?Q?k7mBvI8gYNtkp77pdm6Hh9w6GMSO6ekwsdourTtYhzseFYodb5ZI65UT5u85?=
 =?us-ascii?Q?Q7pOrI38ap/zw3OSIMPvKuxm/zIOCr7isqWqGBcXWJkxDvhjbl9ZzTDTAZWE?=
 =?us-ascii?Q?PYu/Yxj5ovxRYY0w0lAdkT9oAayuKUAkrnRQzyoxPYRjgTnk4q0lLmvXpEbc?=
 =?us-ascii?Q?DJxPTwtvahqXrnhqQ+xKXXtmx4aTLAEOrvo/NbJv2Ch5VCWXO6/30TCphEb1?=
 =?us-ascii?Q?mHeWgNnI1PtTF5TLgBqyOMjwsvV5VaaV+hRhZF/7o4xpDXR/VuENnL3JTIRu?=
 =?us-ascii?Q?fobErv4dg4/JqovmkVsaFQEAmf1scotKxTm3eZeOsVGKTyaRnJ7pmJdURisH?=
 =?us-ascii?Q?mxt3ls4eWkG69X28ASK+FrRMAhJeXln05uRkw83zz44h5wi06wbq+NOBOFj/?=
 =?us-ascii?Q?1lczVAJM/4vg2Bj7QAeryw6TyRicZ8MUrV3h2pJDeD2UCeOWFP6WT06q9ap3?=
 =?us-ascii?Q?jL03EJpyz+JWrvHW310rKj8+mT6umTPm9wy+2JCwqA9gH2SNbySWpNAe5qj/?=
 =?us-ascii?Q?3KRoGxL1X7Tl+WKA53pyJMX9RQUP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?paRDCtnbrImeDDjTBEBlgZasKhak793LjrR3DhW/5ZE4wv3hcQ2LzuxtBsJZ?=
 =?us-ascii?Q?hhCP5AZQ6WON4crVeJAWX2RaYi4P71b1x1D0jusUTdjUm7Sa0TQNbOiakptb?=
 =?us-ascii?Q?WnqwC+W0G4vErYXNU3RQ6hvEuepWA9Aube/367Iv4Ly55MmU2kFYq6pZENjv?=
 =?us-ascii?Q?CnKMcPrvJd9iRp8cqkLyNl0NvUTpZ73F6XWQiPnSzhA0p2K+SVmvIqEUtiaC?=
 =?us-ascii?Q?2cFSPkAZNLjETQWYr3XWXyAC6sqhS4EBTmtzSaHEMZD324xmmGVwWrzmFp+I?=
 =?us-ascii?Q?Ng9Sw9HGZ2Qo1jqcadcuwAulDcjhxHm4v9BZgHF9G9pmIU9xIYfjWPX/VHuz?=
 =?us-ascii?Q?6OBy5P6VAl8cT4Tm2ooTXHqDBp8nX/F+BYYk+wfZO/tlYVJYU8Y2jhbkYf5G?=
 =?us-ascii?Q?aS0eomwtr0+Un0qikDri8Sxa6sleaKtem60NDoWAcqLDulmt+hTeHjLPZ8dO?=
 =?us-ascii?Q?5pSXsK87NlcDFvh2SDXH4RkEbNcCjchUMz53U8vMve6euLLrYQO508Ci7oj4?=
 =?us-ascii?Q?pOAzat7bbNEm1LAENZSj7uYOtI6eSeBAZM9+bbO4yFWez0U9We2LGqsos8hJ?=
 =?us-ascii?Q?5qk0ih9A2e1dXuzoxFBk8W4RGqIit+QSxnJMZDabsfYl+v7N7H6kZitavC/g?=
 =?us-ascii?Q?hXOl0wqCr6kLK9OiTTv0jQ+E2tVtHg8ms5XGMM9CJ1ULrAXKwG9btQOx6/Oq?=
 =?us-ascii?Q?p0THI/1Vd+dDG53gsDWAccMPExbkZJMsLVkPMdTJV0GD+n9GExTXtNTWsWzh?=
 =?us-ascii?Q?tMLLWLWzRVQcFpCTSRtLUco6b6R2KEUThwV+LkWGzyaCoBTMkcEOWKxcGR6l?=
 =?us-ascii?Q?zNWqDGXBqB5jQWnyyJ3NZtRJwO0uEBI8jx5IC9iOo8qQ8IBPT7Chr/cko50Q?=
 =?us-ascii?Q?P90LT16dvORgazIhj1zbBui1Ebsx31suHyKRE1O/PS7nPb+zRcnWM5yyv4+b?=
 =?us-ascii?Q?LHFrRVQECGLnOZubvAOegOZhB2tzfJVUJjOEbLs7B0cKwOSZ6cu1KTI4plJi?=
 =?us-ascii?Q?jrVBxdsSmrPA3EhTQIMt3bp5ynJI/enUmkOqAexYpusvXIOdVzHHtWjmVgyD?=
 =?us-ascii?Q?ENOrNvX3A5Uh9NzFU1t87EXX9TN2X6y0dHxdsf800nPVfqfjwvt9bz4BQEKP?=
 =?us-ascii?Q?ojf+C82vYFzS/zYEqmPVvLrmXRx1d5dbh7Y+sR8/W00qDVyOkYNaygsrvDVx?=
 =?us-ascii?Q?DHVTk/FpKeIs/RcPTy2BbgIZrrIwtsCvujWN0LMFkZKwMC51YfrNCXTLXcKw?=
 =?us-ascii?Q?3JhTou7nIJU52xJQRZzXPXo+ukxSRCrS5mQHBhpEP+idOG3RCG/5dKVbFusW?=
 =?us-ascii?Q?4iqTJXWwO/u8MQbUjTkylkQ0QDdTpa+ZJ8q35pFc9r5CwKip6fBJ3ImTRvrr?=
 =?us-ascii?Q?60pBSdjWb1yB2zbmSBszPJXiHNud4GkZBFNGkm7fXqDao2xyLv9Ut+q0KRqb?=
 =?us-ascii?Q?WffHi7TPoIigY2cgB5sVG67yETafjgtZ0cc6zxApH1jjqhAQ6Sfw+yRyvwh3?=
 =?us-ascii?Q?2H/y0FOb2CKyueaM1uABtWBTfoN4Y6lN/Ix5Fel2mtRTJIqZM+S7riCDK5st?=
 =?us-ascii?Q?41BBlo5nlqKucuC9xcnLHLAfGWtamnNnxtTU8Ekw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a45aac-69c5-4420-8da6-08dd59f234ae
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 01:24:55.8438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JstBoP1tGLwl0/81QZGWFx9v/HfrXZqUdTJ31uQ2WBAyvICrLkXDLxplZQr9D/5K5S2Acg/FcEd6dgDPQJzqQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7188
X-OriginatorOrg: intel.com

On Sat, Mar 01, 2025 at 02:34:26AM -0500, Paolo Bonzini wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Introduce supported_quirks in kvm_caps to store platform-specific force-enabled
> quirks.  Any quirk removed from kvm_caps.supported_quirks will never be
> included in kvm->arch.disabled_quirks, and will cause the ioctl to fail if
> passed to KVM_ENABLE_CAP(KVM_CAP_DISABLE_QUIRKS2).
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Message-ID: <20250224070832.31394-1-yan.y.zhao@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 7 ++++---
>  arch/x86/kvm/x86.h | 2 ++
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fd0a44e59314..a97e58916b6a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4782,7 +4782,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
>  		break;
>  	case KVM_CAP_DISABLE_QUIRKS2:
> -		r = KVM_X86_VALID_QUIRKS;
> +		r = kvm_caps.supported_quirks;
As the concern raised in [1], it's confusing for
KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT to be present on AMD's platforms while not
present on Intel's non-self-snoop platforms.

What about still returning KVM_X86_VALID_QUIRKS here and only having
kvm_caps.supported_quirks to filter disabled_quirks?

So, for KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT, it's still present when userspace
queries KVM_CAP_DISABLE_QUIRKS2, but it fails when userspace tries to disable
the quirk on Intel platforms without self-snoop.

Not sure if it will cause confusion to the userspace though.

Or what about introduce kvm_caps.force_enabled_quirk?
if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
        kvm_caps.force_enabled_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;


static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
{
        return !(kvm->arch.disabled_quirks & quirk) |
               (kvm_caps.force_enabled_quirks & quirk);
}

[1] https://lore.kernel.org/all/Z8UBpC76CyxCIRiU@yzhao56-desk.sh.intel.com/
>  		break;
>  	case KVM_CAP_X86_NOTIFY_VMEXIT:
>  		r = kvm_caps.has_notify_vmexit;
> @@ -6521,11 +6521,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  	switch (cap->cap) {
>  	case KVM_CAP_DISABLE_QUIRKS2:
>  		r = -EINVAL;
> -		if (cap->args[0] & ~KVM_X86_VALID_QUIRKS)
> +		if (cap->args[0] & ~kvm_caps.supported_quirks)
>  			break;
>  		fallthrough;
>  	case KVM_CAP_DISABLE_QUIRKS:
> -		kvm->arch.disabled_quirks = cap->args[0];
> +		kvm->arch.disabled_quirks = cap->args[0] & kvm_caps.supported_quirks;
Will this break the uapi of KVM_CAP_DISABLE_QUIRKS?
My understanding is that only KVM_CAP_DISABLE_QUIRKS2 filters out invalid
quirks.

>  		r = 0;
>  		break;
>  	case KVM_CAP_SPLIT_IRQCHIP: {
> @@ -9775,6 +9775,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>  		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
>  	}
> +	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
>  	kvm_caps.inapplicable_quirks = 0;
>  
>  	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 9af199c8e5c8..f2672b14388c 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -34,6 +34,8 @@ struct kvm_caps {
>  	u64 supported_xcr0;
>  	u64 supported_xss;
>  	u64 supported_perf_cap;
> +
> +	u64 supported_quirks;
>  	u64 inapplicable_quirks;
>  };
>  
> -- 
> 2.43.5
> 
> 

