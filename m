Return-Path: <kvm+bounces-13000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4494888FD8B
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 11:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE207295732
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 10:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58787D41B;
	Thu, 28 Mar 2024 10:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iFjQlt0G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BA27D40B;
	Thu, 28 Mar 2024 10:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711623408; cv=fail; b=Jb4rEC5uOd8oRPGUxKLa4KhiXhiaSRkQPRuJToobH7fDIsB3TI4r4RANmif5IXynYK+V8lidChlIIREYl5oHgBucbjj2N4RlxTxOdY+0XAA97G2mIGqe0Bgd5R8XJ6r9BGa4OYb7KCxpfFEn8XFxi15HPacvqsrqTEGaiP7w6lQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711623408; c=relaxed/simple;
	bh=HHyMilW9E8hApD+EKet+xfqkLDqJhY/Yu35ab8kCSrg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cph/nVap/P1cRKPAdm7uG1uMgX0T8yJpKc/TR0aRKOI7RvH7eq5IzSc4+M7EX5Re1UaJSZsCr4WT3zG5FF6enkIZXxAM0wV2jDFm108ou1yTu8tAevCSjG2xJ8i0x0XVYyGyVIW5C4fNEMqmqRlSdU3e/PY286qKwuwNdJFR5D0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iFjQlt0G; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711623407; x=1743159407;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HHyMilW9E8hApD+EKet+xfqkLDqJhY/Yu35ab8kCSrg=;
  b=iFjQlt0GtTMjBPK69vIxzttIXGBxuh+d89k22Nc/vgglbhPeSIe92TWd
   dRLb//MywpByV3GkNHlVpttouN9MbotFRe+TPb1SWFOtmYkXg464YSnhi
   InxGvueHiqUgxvzlMDtbG3d/jvDPWeKUTqVCOzPLVqOVyiYzmC7hnKttK
   56K0YiKluVTHUgYiRNdUTYQPXLjgmIPSDTcqFtVZ/VN4huLU1K19gKzl2
   TqnqjjCP/uyOo64/O7ZVkcvusbejRTSMQ7LhYQAMiX0cojbqLFanDpSxl
   0qq1Xxd/bGHFN4BrKwxA7nPC6f31+90jbWa7qL19XBZ6Qnr9nM4UEDgED
   Q==;
X-CSE-ConnectionGUID: D5CWCNGkTQel2KUDfgiyVQ==
X-CSE-MsgGUID: Xoba6UScQGKaKFHs5srXzQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="7368202"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="7368202"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 03:56:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="17062209"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 03:56:46 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 03:56:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 03:56:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 03:56:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 03:56:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgefbhOFWpsTvDz4YLOlDs39RqdDXsb76hsX/r0FpI2J57qyEEc0AUJM71NdBGLD369HpylZsSY/gYa7PcrY2VWzZlNwfh4AaR60fUB4gEInbGKHRfUrYCbZ5UyBr6ZoYelTovBya4OMFXw3o/7N7Du9DVdAVKGh6GDrXgxeL0uK6ZO/ji0eM3qf3w8Xkk11jx0hROHOrKIjgaQg6N7BUNHCNcolm6tnASqvmLZaQLfN77uMklZNfcuFRqHyXvL7VcRwVCfqOp5M2NP3GzWG+S1PwwY1GHDV188y6hYMYrRfuUXKirKNdAa76K4BorVHPjsC2Fs43/DnrdHt3vOsdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gATQ/DXWzK3SEvjJ3TSSi6KQPACfK2zeW1plFT8R688=;
 b=cv4x3rKmjZh2hbt3iayzZYdjc+br9aJWSdDlnrD5DKfRZM77uADJ1ZVh/yAK2gLce4yDVVW89T9dYCAMbQEZ/HWxVDvwOOFaa1yJlG+JlxQR9lZzQ6gAp1HKOKpS6InORJBLyoMVhP/qOuJPrhkmYKKDVMyqLPohGr5fFA5EIvOSX6F7d4JUZEPjhnavpvuFZVuIykabR+fgwZrq4ZAOIfixM3QGX7sBpuTSCRGnynRsrFsqy+NDCRO6Co4cyavO6fHKMIOhDCvibLpk293qmCwGam9pC4IKWKxo6I3IlY/JkM9CL2smEygSUg/eDoW6B2wNgYGTLjysnL8vMFerAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 10:56:36 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 10:56:36 +0000
Date: Thu, 28 Mar 2024 18:56:26 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 092/130] KVM: TDX: Implement interrupt injection
Message-ID: <ZgVM2kJTx1p4BjbM@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b2d9539b23f155b95864db3eacce55e0e24eed4d.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b2d9539b23f155b95864db3eacce55e0e24eed4d.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI1PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB4951:EE_
X-MS-Office365-Filtering-Correlation-Id: b732bb41-34c7-4410-037c-08dc4f15bcdf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8NBZnNQxCuzUKCp5bg95fVhhUazwSCX0nWjkXgmot2xpLoEnss9x8BsaWwTH1LAZlJEf1xFh8rz8YD2ORmSTsgPwVtVBcF4vBFHY2Ye5SZ9EeH9GI1RYJDugoJLCVvtSwUcKrwY9nY43kUU2/xQRsV4kKpYcHnaTezKhi04Q62pFxqjPzO3hLaHq3By7eZXSXkF2TfdyfICLxSohEf4yea8mVh+KOquBKhRqgk57OrGsYv0oVKEA3vFTGGE09XVZwUeY1AY5ifHQARNIUsE9+1FkxWA9uxxApP0E6f9md9/wUBSN5gw6ztH5z6kqLRzP2NiqxSv+7Ey/vBvimONtEbjnm6le/uYytIwzBcxdyUKn6Gh4r1e/7gfLn6EPTxiF/ltb4iDAn40oGmKvvn0aFHG24WCwTecyUnELU+H/kVIee1k3VwIJoQL6jwvk3cKQGhdXtois8AbZAy0+W4fR1QhqYOhS2mxvAnUGcF9OESpczOS+rLO7U/iB4d4tmadgAk3JtCd/5DeNZPkfUSTS0ZuRhKmb4Td+uKk9N89qTMk14Tl7ts+LVWLNDl33koarnrYfepsF01mHo7Ei9fo2IZB7v7CorvnRaYPh+ewRpfwlcm5N6869wj8osZPYQ/IVj3D7uf58Piv0WguPjroyOVmaO+HnX9TVd9s91b59szI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JqeAek1+Ha2G9PuKERVR8fw404YOgsyVjpDJLwmizNOG9dpKWACkbo/g9OEj?=
 =?us-ascii?Q?APhdy9CxIYUBkRfbeEjdUOf+TJTUW+b1oAm4P04mMs2u2Z3cJXvTjElkf8MK?=
 =?us-ascii?Q?t9O9iFFuKs8000NS6JZVW/pvmLF4TexxE/EBp7mrkhnrt6P0J492PNjHUUJp?=
 =?us-ascii?Q?ekAfB8ZAFt4pQ6MZjy5cR8GHHv7g0JIrqen2I6nuOCeinj/LYo9kohRFJnFk?=
 =?us-ascii?Q?7/c8GSLTiRYS9tDB5Ax6BvE/aVh7Trhqjf6AkeJf7DNeJ8sg1XsErJGB/Cdz?=
 =?us-ascii?Q?lZjxCgBkzmcP+G0y/EJ9wvXuWw9F9gYXCIWXhBSmWxKqjp56IkrbsA9VWw8U?=
 =?us-ascii?Q?1dizXNFXH17QYqiF99WOR3cGchN7fhZbaw+vOH1k6VgQ/3vhzCR8fN3XfFSv?=
 =?us-ascii?Q?+B9v/GjjZ0oqp3wIr2D7OexV0ETDXGiX9RmhvdxRqTu4+4gkMs1fuaPEfdKq?=
 =?us-ascii?Q?OtqIr9hM3yT77vBUszFrN7CjT2Gr6f5fuyYTB8u0R1/GKlT9qxuVK8KdH4LR?=
 =?us-ascii?Q?NqgUSIcCbxK81wLnFbt+UpS+nftbSBGQB6oqxzUzUJrvUOL5/uInWQB1Ii1v?=
 =?us-ascii?Q?40GTYzg53kvW39qyF+CiK7lGHWfm3qYi+BrhGniMJyy4YDS5pTJ9FN2hGrze?=
 =?us-ascii?Q?pe0r4CxzAAlGWjKOgqExJXoTEYp+4o5dic3fBZzFxocRCn47/tuQqFZkh64m?=
 =?us-ascii?Q?Hy2qb3MCo+ayZ5HM6R4JZygVap0WPtPj0xHXMpoRekPd/DvOV5Oo/lIcdhGt?=
 =?us-ascii?Q?DhjyhjeTq3NErkN6NQ/EzpoFSeNS3XBeOdT4BTadfBhor5Bv4ezBuuEtgCSr?=
 =?us-ascii?Q?ZQkwtWErmQpaVB42MZouk1CG1bod6S45NMMRVwAjZOM54NtHeESx1FTl5caN?=
 =?us-ascii?Q?2CDrfXkcB3vKNTAufGRM+Y0uys5xjYVnh58bN3uL8adVV1FqrGX15jB3aLxM?=
 =?us-ascii?Q?/xpG/9475eKNdMRGZRGcdLCHcMu42XhDuisG0ApltNypQcz+cAe4yBE1gmbP?=
 =?us-ascii?Q?ARXPDe4hKrkVgJDg/PosVZrk1f2lO8Sl4N/0zrj+gGe7UWsN1yJxPvOKNyR5?=
 =?us-ascii?Q?FXl8qhffggKPsM1PF/Ff/3e9JqeIpBX0ePalgnIpowriA1NqjZ/yzAKqKnnB?=
 =?us-ascii?Q?0Q9re9WG9ieAdOORJoQJyPyJD3xBSNcfsYKozmwgYkN+wY4ZkaNpVEQNAee4?=
 =?us-ascii?Q?ycqp6LaN9aFHRk/s/mPXc7yHDUDLYGMqYMmuN6gNM6XEw9i4Zj+chqvcHxDU?=
 =?us-ascii?Q?zRzZVT56ecKaBUCEio6TkfVZP5tmktiAewFJN7d3SE9nYd2X23EkMe8Ug25Q?=
 =?us-ascii?Q?F4L5w89lxKYanpcS95wTmzDvaIuZhiCuwX6idO7NaSd8zwPzV6D0irgiswT8?=
 =?us-ascii?Q?dmKI4EXBMobZlNT7mIfaamu3dA7TpxcmzC8tajI7iBHdW8Sqejqrd1kcOQ6G?=
 =?us-ascii?Q?GKgimB6J32czr880Md1yKdACKVc4xei0Crjwhwvrp3jneNefMe2/85E27PV5?=
 =?us-ascii?Q?0Hh0MrHjsHpyFGa7cIffcN6wVJRx9RWQpCdDpH9lOJo6tqcy15wiQbeKO/Z1?=
 =?us-ascii?Q?wIXxsrYNGu4OtTPEzy8f1rOKmoObvTPKTh3zQC6Z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b732bb41-34c7-4410-037c-08dc4f15bcdf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 10:56:36.2589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KvcKxJe9IVMZ+7PDhUuajLlPNPlvFh+HGYr1igLRLRj80wb4SbF3rT4ERorQYCTGK8yBlVTggZxPnMgVRL279w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-OriginatorOrg: intel.com

>@@ -848,6 +853,12 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> 
> 	trace_kvm_entry(vcpu);
> 
>+	if (pi_test_on(&tdx->pi_desc)) {
>+		apic->send_IPI_self(POSTED_INTR_VECTOR);
>+
>+		kvm_wait_lapic_expire(vcpu);

it seems the APIC timer change was inadvertently included.

