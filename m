Return-Path: <kvm+bounces-10597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CDB386DC81
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2C51B232E3
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 07:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C03C69D09;
	Fri,  1 Mar 2024 07:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cxtJLRnv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F4F6996E;
	Fri,  1 Mar 2024 07:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709279726; cv=fail; b=DCVTV3mU0L7S+GLOkOe9R9S0BjtsRTTLSfsYPwzQBKkxCfwCCqUl2q7+p1n+chc9vZU3384DUSaLl7qLw3I2hfeECDfg5Sarp5/t0BZMI4VWa9T28YzOjpWJR92so1IqIXDacKvNAEv+HKTCPnh3U0NksH/UMa/UuXgNccR9bwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709279726; c=relaxed/simple;
	bh=RcpAVMpGxeXqGA2hoc6Xmk1VysXz1iZ4KxfJh+Pni1A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BH9ArvutT819Kr86CeGuxgdTBqdopYpxk10TxdgfIxPnttvHkVJfK3He0I9s1TWyQ7gUgoOUGqtUa9BoHoweG1VfKggnpQXfAB8sa6NqD3IyQJLZ51luVOrJjuL3O++IylOJv4YstgP4XHRDErQ/zXlQiA2sM0SwmkFsot9vO9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cxtJLRnv; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709279724; x=1740815724;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=RcpAVMpGxeXqGA2hoc6Xmk1VysXz1iZ4KxfJh+Pni1A=;
  b=cxtJLRnvTaVCZDTitrAWMYckNBcWCXdoFSUOBBli8JFrMjZQCj3dmwM/
   0ykGF5NcfabcS6dhzjS+j1dVxaPcWvj3Rf6k0T5ayK/BD2i69Ca5t93Dq
   AGyiWIRxKQuSvSFsJ8uRJ8lGkL49jwKfMIuytSt3DeSTqj4ZwoIIbsV/7
   XqEMEUUIKVI1i51NZeoYx8VRRcfoMgpYq1u8VgK6/Bwqx58fptEznP6+v
   Wjvtb2nKWLW1cniui1EcCurig5o1ykv2rsSSvKlviaJszwlM2iJdE7UNx
   /ZhSl3acaP+xPHrQin4E+ODJuDYvMcEwBc36Ya4GaY4lBCLmt0g5Sp/AI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="3651874"
X-IronPort-AV: E=Sophos;i="6.06,195,1705392000"; 
   d="scan'208";a="3651874"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 23:55:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,195,1705392000"; 
   d="scan'208";a="12800143"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Feb 2024 23:55:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 29 Feb 2024 23:55:22 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 29 Feb 2024 23:55:22 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 29 Feb 2024 23:55:22 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 23:55:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7RbWpGAT9SNFdrFr4DZ49y2tlqqtN+ZiiGsIApuVntalYJFcm/zVBJZjw2NzM8zpfQIGe9BK4R/lX7dJ4/ThVT3UATbLgmeJKtLm8yp1RPEz9McbrCPlZlp6VBED7hb/WERg0SB27bzvBtVxqCxvFDD7sN4ijTDqZT5ntnjqLsFooZWnWsNgrpCHnNHs1M3uqxdRU3tzpGBEzkfRg0e8KVGlhVb9b9V8yyS0MuMhBe73ixgMhi/9EPbQs0I+IEIF4ctuWEclJCm7RtfGJC2drI0Z8YPooi/sAIXOlEpVzeKw9/cGuBOPkXpAeemYpU0M54psZuqSaiL4h/aUoGctQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q95nB5E9Am1uNnvEnFo9ZO0w0G2QCHcyuDpSBalW3ls=;
 b=ZuE0oCa/b9uRcur5yoM40hFxYQFbkgRLI3EFrKXE9m3Xq6/5BKRkhPjkCg8LMW39HM9ly31MP5wXIvTurhf6BncrM3JS4img1YmEBKammGq2oPoazdB5/H9KnfwBGgUrcYbn6aICzEr19Q/9mgDwzEkkbK+U0gm+Ea5byTMCLTcFXAUlo5tAFp2EyAUY52kBcDZGRYXp8AsIhIQ3vUgYDEgatm9i9HQFKg/SoyPaBjjvY8Ja3yeb1CoFIJutxmKWol6mwIoYhyNfSAchiNVzXVoJ0v0bEDEv6BvGAGqmOtNOX7HIcrfMSfRxnhqw/iXFxMtndNun/5iIkOsV0Vt/Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB5282.namprd11.prod.outlook.com (2603:10b6:610:bd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.18; Fri, 1 Mar 2024 07:55:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af%5]) with mapi id 15.20.7362.013; Fri, 1 Mar 2024
 07:55:19 +0000
Date: Fri, 1 Mar 2024 15:25:31 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v19 027/130] KVM: TDX: Define TDX architectural
 definitions
Message-ID: <ZeGC64sAzg4EN3G5@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR01CA0028.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB5282:EE_
X-MS-Office365-Filtering-Correlation-Id: a66122c9-5de4-4cbd-1318-08dc39c4f074
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RY2tFm5wT3nXxcPIIyTm4MS4e66e5c9x0s2wcCeBs8vGV98wUvjXCt9tdGEh3Fa8CRBMejl5QGgEu9JIAnyLa3Vl2wyi4pCtfv7EhgKLECnIV7DTvGtuoEkd1xikqCGyUF9ZhEuYPxhOnLH3yuakozHdxM4tWyt+yYYUEMAxF75w+SKjrx0mwdJCCKoiJEV/7FyhdWY+rNPgESyLXgw8XnCfOnNB6lLJRgvPg8BPtzBXEAYSpjBLQfTM77of5qli8tG4Da7bqAaGsHluvqpVFPOllZ3ieRACIEH+Zilz5qvk9/W4ivKDvPYtleSl2PeAhV6FsdTIzG6vAFOvqHiVchwLsoT9T6Uc9xO2dLTIKEM9E84d5PV9uXUi6wwTriGJtQwvmJO2zfMBaLl4OTO5KJgM1LQNRf+JaWiJhpECw3Iec3dqoa4yAiOxS+QB/8KXKwx84zXSAEUgcDZ+NVgnA/zgOz7R2VXPsbUoNJ7PGq2N1/xtagaK7Wr9zShrbkSRruWsxEoPpU/uggMunZCvwi+CksLuEwPFUjwjYhSFReozPDo/o4e4hhrNxA+s4ZJqfLDvolOOtMpMPiy/GXIS/gwkh6oet6KWTmyytmO4eJpIFDGuV5YJxAMbaYv7m/yhmn04qwpLOQBhZIdQvEh/fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dtv+Dpps6RxdlzIoC923OjQA1o6yVOkmkGGy1euoeIcTEqgZCKxa/Ex+jEZI?=
 =?us-ascii?Q?1P8xgNU1Engg7jwx6VD2Dfk0Vg7ODQeoReNf7Yw9dbBp9dev758m7thZRhPi?=
 =?us-ascii?Q?oMgGSBsSVs63QtIfgjBk+MKLb9vCiCgSCW/eC1GNCuYqcsPwJJ/Eg6PoAqLT?=
 =?us-ascii?Q?1QYUYxHrKnwXMGIHi3hpEQJbixbP3lqquXQ0DcWWYZURaE2QeLO1jlJGohJE?=
 =?us-ascii?Q?g28203GDKEnLiiDFSB4RQvBrK9XOM/8Yma0Ob8K+MNA2z+ftiB07Unr/2KSV?=
 =?us-ascii?Q?OqTPK/Kk/fDmjdtZUHHVEyo0vhAbVJwYzfquGFR+fjnvAD94pq0drgOBp0cm?=
 =?us-ascii?Q?Sdcc2ByDFjMQXP1vSapKCz+yOf97z7e2Zq7qHgs0dR2K0KMWFeKyToFFzmZa?=
 =?us-ascii?Q?y5zPLz7EY6zFCm+vmpLdJgGWSBHnl9jymdi3a9mTegVIh83jjp2edJP4OmaE?=
 =?us-ascii?Q?0mRI5/apeGjpTfcRD5gO8vtmjsk5+mqPUPjagr+iQRs0x8tyZP77IQV14Fhm?=
 =?us-ascii?Q?lubQOgSSYk7szdWvnVF29O8eqxLud8n9Um9NoGYlG70oQEkbMedjdrk9GTK0?=
 =?us-ascii?Q?oJVnaqReaiTuE7VhlPticunhbdpweGlVi1FTfaLtVGJ8qxTV/zqsW/XM+3/h?=
 =?us-ascii?Q?u+E0IsEmYcEk4SAtvf+Hcp0IQuwblOuyXg84S1LutkshLh9g1BMNgPXbgwBE?=
 =?us-ascii?Q?zh0Vp9wawca8rxIv4W/npANG6a6j9pamB4Mk78tS3mzeWzyC+OdrmLdUd2zi?=
 =?us-ascii?Q?QQgL0zjIcB+mdxHM5bEbw19SItMJz5CbvYGV/bDqHuPf1kUv+loUHDgKW5Yq?=
 =?us-ascii?Q?yytiWzSGo5j3/8uAlGqIB1rkRB7+UNzXgGBo+gQ0abg1OFrJbvkwpnxF0V/G?=
 =?us-ascii?Q?9wNnWG7hxc7NCw/pY7d58Vz6T8gDzFkyM2tAQGTUwFUdQrwGEmVdkCE1ZCz8?=
 =?us-ascii?Q?BBsyDIqwiRX1lg0miLeqxNQRkHY2uy00qSHrgS1U20rvi+W5cBJOl9CHcn6a?=
 =?us-ascii?Q?aA7Mdqq3KDoVEbUTPK9KJv/D8S/upHOUGO7BO7u/1LGTZSd+f+wUAfd0869K?=
 =?us-ascii?Q?79C4BkDBFEpbft9f//+5pcVJ2YN4s0OXrp17nZMfw3mwqRfLWGikDPWfIzf+?=
 =?us-ascii?Q?OXjfsdIX/x+SJI0gogb1aprElkY7AkdlHdUKAnxkDo8Fi6pMsHvaSazpKIrX?=
 =?us-ascii?Q?JfM+jD7oI+egS9E4xGXMevrGLI2Vdpg8aSZTfRDCR+es7wxC+WwwbssKvk3l?=
 =?us-ascii?Q?zoR+yvnWfyVtu5i02yzV6CV8KkhdrBfqknmK1VRvLb1Kw2zTo1P/DEIWLg77?=
 =?us-ascii?Q?S2mkXP0fP3WNiqpynZHsBSRhugU3oWIVgIE8vYLPJsaghZO/VQXEvuuILtfI?=
 =?us-ascii?Q?/VP9i1hLfLT6Bg6G1nKq+KJJTfml7B/LoJPWn64tuVu0XXmbcmfd1qb3Lcdh?=
 =?us-ascii?Q?K6f2wRagtE8qS6gVUyjBWGTnHvS2ER4sKZeZCaaQvEdrcriaa61jVAHH3AeR?=
 =?us-ascii?Q?o60L7wc7imSvCA4xHTiOhyWEhNOzf2QU/IMLds06V+xbZtB6n93FtoQI5KCc?=
 =?us-ascii?Q?eI9oPVHOj+pwUOgbKUW1fBiSHJ8B+SkliwgnOcTK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a66122c9-5de4-4cbd-1318-08dc39c4f074
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2024 07:55:19.1807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 12eW8eZVLSABC8fdnLqU1xjU/DEoVkIRir+AJQfXiwaEfBIXG1gO+exfu6jWYtW0VecW7La31WshgXTHB38Zzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5282
X-OriginatorOrg: intel.com

> + * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
> + */
> +#define TDX_MAX_VCPUS	(~(u16)0)
This value will be treated as -1 in tdx_vm_init(),
	"kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);"

This will lead to kvm->max_vcpus being -1 by default.
Is this by design or just an error?
If it's by design, why not set kvm->max_vcpus = -1 in tdx_vm_init() directly.
If an unexpected error, may below is better?

#define TDX_MAX_VCPUS   (int)((u16)(~0UL))
or
#define TDX_MAX_VCPUS 65536


