Return-Path: <kvm+bounces-46128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D115AB2D88
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 04:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8462D172AD3
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 02:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D4025392D;
	Mon, 12 May 2025 02:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WSpoYzPY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BD78834;
	Mon, 12 May 2025 02:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747017197; cv=fail; b=Y1mDXdw3IRNAJtABZz1xiRF0uyj9TTspq9hnU0Qd9l4R+DZ18WNnQlpsDJ9rEEC54oa06KVFsTJN8W2yy6gZRyhUaQbMdCk99Grn6A3MlNbF6ORXE1Dde5OtnBGkphZ0jLoXfn+/OhrM+J2h6miJgsAPUNNSd3rU/5ibuXPL8Nw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747017197; c=relaxed/simple;
	bh=/JMg07gqYHrLPjGFjihNDimertqCm6f4vUBbYJicj2M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QWxJIi4PKrv/6U5tiGbIRCKP1T5icdzOrzHpMoaI8VtGzJ30mBOUX6T6oEC9MCQiR5VePgoyWGkCI39CpBYqeMd8siTsrGXeqfQAqLuOyHTfPBZTLo5zH2favsH9KaQ1SCkwoeaVw8dSAbDKY6cbmDmfoMfWYJF+JhoiPbRjg7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WSpoYzPY; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747017195; x=1778553195;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=/JMg07gqYHrLPjGFjihNDimertqCm6f4vUBbYJicj2M=;
  b=WSpoYzPYbCeEa85bnRiWGLHaHVQ6qGv3531XVfefHQ9+AW+WIZxcrOHI
   dzpr74E/aBQOzHOvgNEzVtwXPZbMIZnaSQoB2ynxFBKSCfY2yV4hQZXoe
   htuVxuK0J8+a+OdduffVP/tnNX3AU5LD418/ATXWtTiKB8PqPRFGUPNeF
   lpip/1NDNLaq2fnZzEjFm3Mt7+soFPv4ggnT6XoAzN3MqHW5KunyYV/1l
   2RnEjONpOV9cYCuBt79wADOO3kFuFOEbuRHAYeIrS7jfx3Q6pz0ho6cZF
   knlT3nYJfK4g/0U+vwAqyxur0/gbUe/VdWnfcdbprgiB8KW4UEQ7hZJxu
   g==;
X-CSE-ConnectionGUID: 5vZ/weKnSHWrglMcoQHSzA==
X-CSE-MsgGUID: qIzQHEf7RFuDoCF/9klfBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="36426277"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="36426277"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 19:33:13 -0700
X-CSE-ConnectionGUID: 1rqjkSg0T8eS4qfXactM5A==
X-CSE-MsgGUID: HZABnjAJTvuH1qz5KPgOLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="138202170"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 19:27:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 11 May 2025 19:27:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 11 May 2025 19:27:49 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 11 May 2025 19:27:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VbbCiPWbehVw401v/jpYfjvh1V6eJR76nlT7Ykg86uaS7hoBP4/dDmAlts8pmHWCc2w8BWnrbZS3xnseGpQfJYyaVzjrRudvmMoPXBhngkhihTRsSrsVa4BKmlioxYjd3OsarYjeGzgsc4R+GUq4tziO4VxsCLyh/LzxFM4CNU8c5sjPAIfEi0G2amPGH5AYdEmGCA3wbpom0tVAu69ELr/P/qWZ4m/8uLBRLMRZGEQjqzb7c4IB4I738spt2JmXRVh6gndBu9amt/OnJql43ljbsqz8JCmIBn4jA0tWg/t9McCD64MrzzFeEFAXPfqKMb36/KX5DubUq+crY9jg1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjt6woImh13PN9knVXz6Hr2QDY7iEXUBFCZ5P6osCxA=;
 b=vH9ghOBCx4i+y6voY1Dp+vbcDnwejEvGXmUF4pQDIn7oCTmvCcMv/IVG0NuQh+KUp1j1Do0niGjcRWPCNyUNAT55+v40iY5RvnuXKKij8WDexGfLH2Pxu+P65ysWk7/peGOoTWsdF1EUEmytPeyC2VuA+hBi57zcw0oETSAw7CDn31BYTd8STw7NL05RPsD5aeYc7hFO98wu21jh0U/8A2OBuFJYwe47WXq+kdch4l9AsBlSS5RC3im8FCqjuIWF37B0t2W/unilnPKF1n2n2yW1oAbtluxs7qTiyWGEVEEQxH26mihnO5F/YBoyb2s/ev36lgRtSgVqPrwJWqU0MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.29; Mon, 12 May 2025 02:27:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 02:27:07 +0000
Date: Mon, 12 May 2025 10:25:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 18/21] KVM: x86: Split huge boundary leafs before
 private to shared conversion
Message-ID: <aCFb/ecA2AR2sNm1@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030844.502-1-yan.y.zhao@intel.com>
 <fa85ac0cf3e6fae190dca953006d57c02fac6978.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fa85ac0cf3e6fae190dca953006d57c02fac6978.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0046.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA0PR11MB4541:EE_
X-MS-Office365-Filtering-Correlation-Id: b3a0af5d-85a6-497a-502b-08dd90fc7df2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wv904jX4B8QQ5JDaijNz1PWVxSICrJFQqxDd9LZHJIriXUxH26dw8R33g2Db?=
 =?us-ascii?Q?UaxDpk3ymiAxOfZ7em5oyuaMxlzzq9HQPztyWvhuOiYhZ1codB5vUL9H+s2i?=
 =?us-ascii?Q?BaBZPFNcoK9ocRt6Pizpl6nlOtncJzUy6BT/TZ0hVx1rp7cLbW7vxYTl56Ie?=
 =?us-ascii?Q?gOF1f+3haSmZVw47QtUPA92LG+xI06QpiWOOJRRBL/ZlWHW2+r5IHiEQVsHb?=
 =?us-ascii?Q?WWlDONWRbFGORvf8SbDgFS1i6B5Vq7GBXr0pzyFb1yTRQLeWA6azoJWYQtw5?=
 =?us-ascii?Q?T+47X11BVm2ji6aLyRxPX+cSP+VF6GwldBLaPFgVGXOZ1/O6EURBNfIkhNph?=
 =?us-ascii?Q?+G/CYmx8BcQXbVlLc/1XUcOmhRNfUu4UfHFJVNf6XQKhPOKtMB6Ro9/mP+jU?=
 =?us-ascii?Q?GWmeptxOf9kciy0cmSVTSal2vzU7GWccpRvlIOrMlrY0tUl2v6hk9dUFwaSy?=
 =?us-ascii?Q?QSSkdDHHqmP/FqaTa3/n7JK/LXfyef7S/QFcW4Y+qMGwTV3OoPwktxzflnel?=
 =?us-ascii?Q?VhDThpCuhPLHySz3WRwzt3zLmn7sbmJ7j2hiPCpyFkq7A8so61GeD7QKEGhH?=
 =?us-ascii?Q?NOP2PMW1cuoX0Ole5rQAGR0QfmPUGSs0TsKbthPFL2zGXSUXKc3BqpZZ6eWk?=
 =?us-ascii?Q?CGGnXwElsZuRaU8yWppntQsSi1dyptKYxaaGXdYtTcwXMfMpeY0KfQVv9mLH?=
 =?us-ascii?Q?OutdZGvsNriDI7F3BsywZrdKzQOw7KtyJTSDYNx0UnFYI0TWYUyhZAKXuo+S?=
 =?us-ascii?Q?DU+jbNeohgPgJcgARdCGsfe9cnUoSe0oJOu/K6hbeCWeO2oryrnwkiqQHzCI?=
 =?us-ascii?Q?6pHodZZ5BiflMJq01lCRKIGPaRhjZTDK+8oI3q5QYqy/L7pAEzqoJjkNgjEy?=
 =?us-ascii?Q?lpnAmKuLUFWjhVOCmQkTeZhcL4DUHWsRA+vr6WbwBD1bP3yM4/0MIJlSSBUY?=
 =?us-ascii?Q?aXYpnYm/2FNdRObOcy0t2nujlGakQmQahupWUMDWKsUnUtxsjRj7LAXSfAEQ?=
 =?us-ascii?Q?cCnTU1auOqDKCDFVNiPrTvTgtr8pHmGDfrKp0WSFq54PaXryn+xNSmLlXCCN?=
 =?us-ascii?Q?Ew6XTv0ZS58sO4T6/Ur0jeP57StL2QUzqlD1aMKlYWP7cTuuPdo9ke+rlpeC?=
 =?us-ascii?Q?cY+ZSNmLD2xoflNeW2rW3W5rjsNLjtYpiib9y+TYmRVDSS9DeZpH1BUZ+bRA?=
 =?us-ascii?Q?AeO+KP8C7mcI+joAF15aMFoGVT1Z+QppoF9WUIITXH3XdgOzWS/oce0pp6ru?=
 =?us-ascii?Q?BEL/A6OaPDZR7bH3KY8A0251XJTfbARgEtyTMR8F12L7VsWdbukzbqnF/o42?=
 =?us-ascii?Q?dSE/I5o3GGk+iMs+xrIVdS09f+KjC5skVMxyfAPcrtQxTW1Zrpof7p+Tqrmn?=
 =?us-ascii?Q?JwAFrex0D0fHLET+RtbOG7awOAC3EqxkqD1nh3cZSA0FJyeK5jcVFauiwChK?=
 =?us-ascii?Q?7Q2L3aRRJbk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ztjLhbQMH8ifqKvFletjYcTfrKYokoeheJwnFxbDDMtah1QjteNWH91VVrex?=
 =?us-ascii?Q?bmKiEqXlFtFdWQss+zcjqkiLRRvkmHeX+aRBWbeHUCCHCk784TCMQ+n3KGrq?=
 =?us-ascii?Q?W63HlR/zw5RA2UD3fBSGko/4F88OBDahyZOaiCnAjaoFCfq8Era8l61FSIBf?=
 =?us-ascii?Q?jKHcsHSavqXiE452OfbrFZVnvYVm6d7dOLmY8YNP1wHBbFVI5k2D6KbUejAI?=
 =?us-ascii?Q?PnNh5rzIq6RseTfNTwP8WN9alcULlIZpiu3zQWFS0UHnZdfb7NFVJksyrpuO?=
 =?us-ascii?Q?V2rfD1IYG0nNYbOJo+jg0NhiA/a1cyVPNMGsZTYpbjIE12QBD9c+e7CRj3xE?=
 =?us-ascii?Q?j7v1+I3K2zAIOc/UCShfkDxq8Waz3Symo2mJAMznwn/yRqvqtSiqw9lNRqSE?=
 =?us-ascii?Q?wvW3uhhos3Rq+/ARcdk+MbfAhr62/fk98ahLl1AHAHtnaXZuUngIQux3l9+D?=
 =?us-ascii?Q?IapvTYFmzea5Y/fDAFhRE+Lm+92MMMvBqi6t0t5sbZbq1d8ZOYVRC5fD5TR2?=
 =?us-ascii?Q?Lm3bak6Ud+F8nY9S740/OPfTDjqoUDJy4lErR9QaUeMYcLyB+YZZtUf6X6V0?=
 =?us-ascii?Q?G/zHU/r+M9WytiaJwdepWf4CFbZCC+08fOgBeCxW5gCwgdjyzMsJJ1nVAVC0?=
 =?us-ascii?Q?ct9NUhos+1yi8u/k9/qOnXW5z/dgJCon0w34W/8A2lCeUnhbNTaDJlsbAKLW?=
 =?us-ascii?Q?NF65RWpKHVz0Hp12mbUdtMzBvY8tDgvhPNoNoCXY9UPCPt+adRVfns8+UM+S?=
 =?us-ascii?Q?iQG8DmpvzAyiCW5ejtjl9cUb+v8xZ+FGgGXnNWrzqNA8XLN93E1PLboa+HGr?=
 =?us-ascii?Q?TyE0R5jvTAuWWjhm857FO6vW29Abmb0RUo/gR5K+D+3zdXQPUKF+2tnLSomg?=
 =?us-ascii?Q?reFP3CbhtxDR8yV9ixJYIKAZXO5iCnnWcs1cDQhtrXDasq9DkDK2xVDNIn36?=
 =?us-ascii?Q?9JVp0O/shoRUTxMH54D3MBcW+U3cFlf6pzBPtI2fRc2SHLSOZKNrwLpCeaJ/?=
 =?us-ascii?Q?TQ/rBfFuNlWMHMkN/jYqBBHARJrYdGIDVp0IYkEwCqLrNdDg3MEK1HWgzl99?=
 =?us-ascii?Q?sAksVjMiWqRQ/iDKuALRl8yK+y8qJZri2pS95cxHFlB3ueIMBVewuikHxCJ0?=
 =?us-ascii?Q?Swxd+NAP7HSJgHOyyx8/jYti/Xd5wxTev9JxRZFowXTtGSI6RzpB8IAWMdpY?=
 =?us-ascii?Q?txHgPfOuxKnPYwf3b8FfDAg5AJqaVSMeYAbm2cO/IYmZ/qce3kRnbK7nUsae?=
 =?us-ascii?Q?T1Yn2CntRo5Nc84Eu7ILFyvhqdHMXvfy3pBqKG+KuuAH1Oczt4H6XMKt7ed5?=
 =?us-ascii?Q?6kvXNYAfCcWluMJ3po29WVD86JjnyvNjODiEAaIlGz1ekoz1slF5GNrPCbSm?=
 =?us-ascii?Q?oZcVMNRE+QdP5CjEUXb+8s3CPdSz90SPhyb8MpkkFnvcL0HNQIzffdbrCV5+?=
 =?us-ascii?Q?0TCoaMbCf80+nitTy573PjQmFK4tGy6e7YgRMrToG+Zd015C06RSr95A19Gh?=
 =?us-ascii?Q?JIQrigmXSgID3Ft2roiS64ytPNLAfx6tqpf0bevMmNF8h28hRBdHC3KASxwD?=
 =?us-ascii?Q?+ZweCvW8PD1sxQEcNEa68BzD/2c/dW4w6iEtC0tK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a0af5d-85a6-497a-502b-08dd90fc7df2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 02:27:07.7538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H3QrR2XeufW0mdDFDVlO469twhUNNFC8FFzrk5KNgm17qkT5s1DhZBtVpYZFDfS11Ffil24uFqbUNGzmJ94IaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
X-OriginatorOrg: intel.com

On Sat, May 10, 2025 at 07:34:39AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:08 +0800, Yan Zhao wrote:
> > Before converting a GFN range from private to shared, it is necessary to
> > zap the mirror page table. When huge pages are supported and the GFN range
> > intersects with a huge leaf, split the huge leaf to prevent zapping GFNs
> > outside the conversion range.
> 
> FALLOC_FL_PUNCH_HOLE demotion failure doesn't look like it is addressed in this
Hmm, FALLOC_FL_PUNCH_HOLE demotion failure is handled in patch 19.

> series. I noticed that mmu notifier failures are allowed to be handled by
> blocking until success is possible, in most cases. KVM just doesn't need to
> because it can't fail. We could think about doing retries for
> FALLOC_FL_PUNCH_HOLE, while checking for signals. Or adding a ENOMEM error code
> to fallocate.
In patch 19, FALLOC_FL_PUNCH_HOLE could return -ENOMEM.

Returning -ENOMEM may be inevitable as we can't endlessly retry. So for
simplicity, there's no retry in this series.


Besides that, do you think whether we need to conduct splittings before any
unmap is invoked?

As in the patch log:
"
The downside of this approach is that although kvm_split_boundary_leafs()        
is invoked before kvm_unmap_gfn_range() for each GFN range, the entire           
conversion range may consist of several GFN ranges. If an out-of-memory          
error occurs during the splitting of a GFN range, some previous GFN ranges       
may have been successfully split and zapped, even though their page              
attributes remain unchanged due to the splitting failure. This may not be a      
big problem as the user can retry the ioctl to split and zap the full            
range.
"

