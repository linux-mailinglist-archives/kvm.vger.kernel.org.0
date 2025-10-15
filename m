Return-Path: <kvm+bounces-60053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17845BDC0C5
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 03:51:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFBF018A1C45
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 01:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E2D2FE056;
	Wed, 15 Oct 2025 01:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DgkjYntJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1A52FD7CF
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 01:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760493004; cv=fail; b=AruoN9yjIko1dzF2x9gmmAzrGVgoW9ZtGRcW8PKMgg93YNGfJd3iQt6dwFiLwnTcELg1z9xHC3G/ROIBQTYMm8kxWws4xfZYjbfrTRzkcS7M8oHwfVQ6UMzghq8UfWv0/Ot8ikeEL3+V9vGut/Eh5GIbULgUs803iRL1IVBTK+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760493004; c=relaxed/simple;
	bh=Fiwr+9+p+2fJoYisnja1OPGDUNOzjwqXvt3Alcblic4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TuXBPAyXug0h0O2KoAstelWdDUJNIdtVltMroy8OWq9VrBM3vTbPGXC6XAJ4yJ7SkdJfLtgh6oiB+CvUz6IOxAx4kIabwujB/RBoFh6a0R/pL97efLcqkykPPuoSjRM/Psh8AnJcilY9O0hkJZJKhYQ2/aU2cf3C+uKZVc+n02s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DgkjYntJ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760493003; x=1792029003;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Fiwr+9+p+2fJoYisnja1OPGDUNOzjwqXvt3Alcblic4=;
  b=DgkjYntJkd4jWvRoT2IkjBDmQw3Ta4p3+RdCVmFnWkdeHmSQuobqpl60
   3Bq/lPQclRwoc08hxpPBOE0vTgZLns+lAHardU5TT8GrnVzLVMZeQCytI
   9Wse46qLCnuqTWUhl7g9X2Gh1faNq0OpQBZL36kmNEQLtxAvwRRJ05UpF
   9UMxDUCq3YAmcMmbPFTyN40WOWqiy7s0b+BorZ5Vv3Sj2Put7A5HUusoq
   pvia8QinDaJIXi3Pr9XrzrU8+pxseZFJuCSc5ICMlLMe7spxEgLYwyemz
   w0rEjELfWUUko6yxEYVoeM0+6s2zsY7J5CKce92t/jx24dEyXwTznl2nR
   g==;
X-CSE-ConnectionGUID: 5U98mBetTI+a611hR/UNng==
X-CSE-MsgGUID: CWBJER3gSKGx9PVAMUQfDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="62755253"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="62755253"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 18:50:02 -0700
X-CSE-ConnectionGUID: 5QMusBFKSs2tH004kO6QNQ==
X-CSE-MsgGUID: BP5sjHWMQD2kVCjopg1sJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="186039908"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 18:50:02 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 18:50:01 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 18:50:01 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.32) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 18:50:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m/g1MwwEQvVBINyy/xuAhmO0SRy+AwqbGmobDByV9Tz/oDZJekaqeVIWht/jb4TJa7818ukxPPhgQcMZDDRbbkyPIvi346AqPo3ufbCGLs07f1Ow8HWrEcnNJZwanM2TtBFqWMwQGc/FOrvQdFQoqaV7+k7/OXbv3gKBYbQ4YzhcJDWjz+t2XTcztlVxmlxnWoXTAG9koq/GNv5LzXJP5UhgmIacOWL42iS4fj62dxzJyeRvIlqFSFL3zAoYUU2NY+hdGcn+uA5ktoj+vPIxTgdJ4me1wLXtTmV6J3i4KDLmBy47QTd5Lg9nIG1xqF2rf3CrX/H7sq9dKP3Wib6pKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EgbejINnhA4n6p/IVj4T6PxauJJWxifGFJGT/Ie45Po=;
 b=CmJFp4JzGuNZbfJq056ASLDoLNUCrkHyBn/+DYsKOx00ck2QxE0S7NnKnFfYg/iO7FRF/Te7XThd0p+NyRB81niuIDHgkboMcYfWNwcDiNS+2bEQRjdBkOb+qbXwAuie82JEdhW+uiVUJ53vmCxdcNSF/acN1LDp2Rdz/Uy9TXyb9LroHHAoYrNa6atZzwogUGbE8glMMUJY+Y3o1qr/JTqJ+j46PLostIbpwS7RBSu0Wtn+XB0L7P+n5GT+9nib4MpQl0VoYISBzbHMZ9U4p5u/4VFrr4frUi+H/E1GPMDZH7tJEIRIwE9JiItG3om3yZwGstL8BmOjwqMUCNT3Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB6322.namprd11.prod.outlook.com (2603:10b6:208:38a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.9; Wed, 15 Oct
 2025 01:49:59 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%7]) with mapi id 15.20.9228.009; Wed, 15 Oct 2025
 01:49:59 +0000
Date: Wed, 15 Oct 2025 09:49:50 +0800
From: Chao Gao <chao.gao@intel.com>
To: Mathias Krause <minipli@grsecurity.net>
CC: <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
Subject: Re: [PATCH 2/2] x86/eventinj: Push SP to IRET frame
Message-ID: <aO79voQQcg2+m693@intel.com>
References: <20250915144936.113996-1-chao.gao@intel.com>
 <20250915144936.113996-3-chao.gao@intel.com>
 <b54b2600-fe9d-44df-8a2a-4e8712d8ab09@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b54b2600-fe9d-44df-8a2a-4e8712d8ab09@grsecurity.net>
X-ClientProxiedBy: KL1PR01CA0131.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 1261fc09-9f5b-4251-b183-08de0b8d262c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mWobTLllhM8bgjSUBTneDxM0ngpr/fvDdAkZvnf26Sq5BIrt7vyPsK0Fqwds?=
 =?us-ascii?Q?J4WEf7jXpX71gAQ1pxKuanFqcJ77GLyq2c8svUNngLBOu5rom93sRH7VI9MX?=
 =?us-ascii?Q?+wff5UuOlTYfGuMKqj+k1yxz8dn2xb9xW8Jy15yziJeVpeBkEPD1Y1J2Tubi?=
 =?us-ascii?Q?1P5iDJIMkUy+oZfmplG9BZuQQPDHSESBggKPChxhAirHW+sCuzO2kyKmqBXP?=
 =?us-ascii?Q?Z0aWvv+HuiXktXYd0pCtaesUShsGXqXWkooLCiB6teJFPPn+q3oWVA1PWsKw?=
 =?us-ascii?Q?F+ryyDybj3O3t0doFdGRKb3ehO9Sdwof6D6KOwPn/1aTp1ExGFPpWMSVPT5P?=
 =?us-ascii?Q?b9SI2N/9RsrZe0atVTgHrpSKlsUnocMkIwwJmXD0PfXySv4mSbacWl+n4cOc?=
 =?us-ascii?Q?nTrk50B1HOkP0b2DRJuw/2djwLO+y2NzOOTJ6fMOEqGon+P9cpreKynx8KKw?=
 =?us-ascii?Q?UQ5WQIBqMBlUTuqVc6uaPMKdbElvse/9Jz6FMKx7U+OeijdKiIDYpq658a5Z?=
 =?us-ascii?Q?M+ywyabj+htdxCGDRCMUhgcBURKnrVug2aqJ2m/hZdTMP6Iv4nsXNZiZ2u1m?=
 =?us-ascii?Q?FjiTpgAqBe4j4ZKHhR8TVg6ZQhEjHSRXLefJTQkk0jUxAffGVOXbxOi1id+2?=
 =?us-ascii?Q?10SxyXMEGz507Vfi/7+SDjZ8r0vdZyb3IURdlfyF6qBmS0gqgWvfsrttHyhh?=
 =?us-ascii?Q?fLsZRxfKsijxXCACfNH0mSeLG6x4hLFLNGWeQ6fYyQIjlYJ+o0JIbh+KsdgH?=
 =?us-ascii?Q?/iiGPdhH4xLuvP/J+Owh2cy91S7UvxW03k4nGG9ba6qrC2hezHHX9sOPoxrt?=
 =?us-ascii?Q?skgAjP9RnRwpmexm57vrwRCmAld1Mr4aTbEeqBesR5aTV1T5NMoIlPD5Luw+?=
 =?us-ascii?Q?DwpUO4VzNlREiGVcCJIS/XgmHfiXeDYaqLY1rRajjayAC9LazV8m2YwVwegg?=
 =?us-ascii?Q?8iaCS1xpQlExsOh2odPhopiWN3Rj8FpHOoyTg2vkrP6iPXf7ByG+X+r0n5cG?=
 =?us-ascii?Q?t/9r4PyvSxkcEGTsFyVperg0k4oqL66fX1C8C6ccqIayBOhjhp7WcoEOukdC?=
 =?us-ascii?Q?wKDlLaE7h6HlDAw9tm42NwT+L4cTCU0iCVQgLSvQ+T4GYCL8lfQkYXc+ZXgD?=
 =?us-ascii?Q?jVgQr/QeX8NQgs7tjsPxxqYjD89E/0+QBJicNQ+Kw0pQBOCv8tsAEEoALaIY?=
 =?us-ascii?Q?s6az5xajxhrbZVuqifUqaxWy0kH+z+6Nrcd24+j9Hb4Zmh3B2qBVFOjouuy2?=
 =?us-ascii?Q?73UmX5axeDQ7KN/DzWo73HE8iUXlb78gMM+ZzjIge/YOxcRR0a6OQoGICJfW?=
 =?us-ascii?Q?y+oRy2NLdpSE738m0H6wmirVGA9yuOLQnHpBGic8gBmW4Jft1a13meIHuNXT?=
 =?us-ascii?Q?OJH9rtFqzJKQZMb7X6V2aquPgB5mG95fTuKXu+Fn+f6+53f2yDsZmEonP7yl?=
 =?us-ascii?Q?AdBBIyjcRnu9VCRuDnFbyNHGWA0VvMT7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ej9pfUUL0g8l7cTMYx2oNQUzUAhqFnPhkYuelvEtvwbYTq5MiBunqEunLAvk?=
 =?us-ascii?Q?wV3jxukWC4hA+knauO4Btsiw8izL0nPdGo51BMUwPxirVhG0slIDDqltjMCM?=
 =?us-ascii?Q?fq0QjrqWJPL/cUQAKqp8801/SiG4fxORrXEWVCQtIkTsNdUv0GO/hJkK+hiO?=
 =?us-ascii?Q?DHb5F0j4qQhtNT7qqOWdSp/kpkUSRd/SEhk+EaM4DIxFcoUBOOtq7j+XnToH?=
 =?us-ascii?Q?Hj25lZCyP2YH5mtsYZZlXfPZs1wjj0+gMRuT+EwK73zMkywY/ZbOFKt6VvVv?=
 =?us-ascii?Q?R0ykKTvhx559u2OdcO4DfQcvtvtA7wO8DVz6IJG+T42EmurlPfQA7zgq7Ike?=
 =?us-ascii?Q?S3pgTG4K0BVEteHVBQbbV+TT/MEs7AQf1x+u42mt1+R2N5xChZl6pxa+GoUc?=
 =?us-ascii?Q?/7UalCsEiekvq18TOG5d4eBOEwp6oEonix9FGAaEDLChaMXaZbYdATR42I6H?=
 =?us-ascii?Q?Bytxb3PqhEHpqEeP17RDiriHQfny9ND6oeBhYx7Fu4j7SOivWsPt9l4j7Ut6?=
 =?us-ascii?Q?yoGMetK1lWXxTShmldPRcEq30GGh6M/gyRJiqpKgZoS8aRFeCy+iK5+8sI3y?=
 =?us-ascii?Q?r4cGpUcPFrqdZdkI/h+Teld+CIS/1EBRkwk7B882xsE0phiBWVGBx6T2TPCP?=
 =?us-ascii?Q?pEY/TyiQncB+mZSX/igXFDLvYNjBZ33d+ygYhK3A0KM7zpPWzdY8R8WwTazX?=
 =?us-ascii?Q?tnMFCYdJlgnjHERwx8EFcs7fKk3obkbe5H6Ce1+HmeoSHQjl1bda3Sr8gB5U?=
 =?us-ascii?Q?noqTQvidwChxPU8OBb4+f/WSz7ELbUOk6GevZF1gPk59Hxuheg1+SkZ0BBnP?=
 =?us-ascii?Q?xtjpj3Qyy93xsYveTV1r1Ltb8jZznJ0ikYiVvdm20D4WipicAecll7RRD00B?=
 =?us-ascii?Q?UdrhrMNeAsskqswQPpZp2mZ++RIGNt4/LbpeZoib3ZxfWv5Et8lZAGt0MveO?=
 =?us-ascii?Q?TdK4PrtNdZ3iomJu+6Itq9iMClfI4GLEJ6n+Ln3bogRpCDfBClbw077MpLvj?=
 =?us-ascii?Q?KkWlvC/yCHiR92tG+L/P/8pq+cR3rzX70UzibKySzJ7dQA9Qv11uTgl7h5BX?=
 =?us-ascii?Q?yZvjVOzEOcxJVuQ5H76/m+vKZQ6nlGHkAZObNz0QFZYjtcYcCgLWTXjxW4ec?=
 =?us-ascii?Q?HdDgfPP+SzRAlpY0mJeOZAPPrBycAG3jffPsMrvB1kk0PgVmCtzBXO6Ze/u3?=
 =?us-ascii?Q?QLumhSB1417u0hkpBGkPyIDr0qn1HhJ9r/gZKhiBeRa82fANE1gb2fq9Wtsf?=
 =?us-ascii?Q?6ziUPmRwE638Aai+kMc8padmIH79P9RhZxUlrK1t1MNrvBhmsKeK+Fe+2SkL?=
 =?us-ascii?Q?8wW574igl4AAumOzTYJK64eN5DTwe6xlR5PfBthemMirCzyvgwno3kiHj/9O?=
 =?us-ascii?Q?Eu5fGqLfaRNRgC0xbB+GTsvLGCIVwjRF64Cvy9j2Y7vAnPZYM8zOm9czppN6?=
 =?us-ascii?Q?EAe+jZ6UWhczUKaJGQjG5buvZHObS8LyF+bjMEMlEaKiKzI6gze1kIxUJr07?=
 =?us-ascii?Q?YluhxmabznCWoY2ynhDMex2Ai+FxTdEmGLSjAa8UFcqfXRTHyxvBEmko65hK?=
 =?us-ascii?Q?9xwvIJumPZNFTRpM8e/gvjT2/LM6ga80rqXzGUuM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1261fc09-9f5b-4251-b183-08de0b8d262c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 01:49:59.3448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WKImyPDjThKt4M2sdVxVeqYS9+MvP6/Xt7rX/hwX0FIf7iGEau1EDgSAps/1tN2GWbrw1ZKPAXSgmZxI+2j2WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6322
X-OriginatorOrg: intel.com

>> ---
>>  x86/eventinj.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/x86/eventinj.c b/x86/eventinj.c
>> index ec8a5ef1..63ebbaab 100644
>> --- a/x86/eventinj.c
>> +++ b/x86/eventinj.c
>> @@ -153,6 +153,7 @@ asm("do_iret:"
>>  	"mov 8(%esp), %edx \n\t"	// virt_stack
>>  #endif
>>  	"xchg %"R "dx, %"R "sp \n\t"	// point to new stack
>> +	"push"W" %"R "sp \n\t"
>
>We should also push SS, for consistency reasons. Not that it would
>matter much for x64-64, but a NULL selector for SS still feels wrong.
>
>>  	"pushf"W" \n\t"
>>  	"mov %cs, %ecx \n\t"
>>  	"push"W" %"R "cx \n\t"
>
>The leading comment also needs an update and the 'extern bool
>no_test_device' can be dropped as well, as fwcfg.h gets included by
>eventinj.c.
>
>So, maybe something like this on top?:

Looks good to me. Thanks for your suggestion.

