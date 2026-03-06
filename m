Return-Path: <kvm+bounces-72974-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cD1AF3k4qmnUNQEAu9opvQ
	(envelope-from <kvm+bounces-72974-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 03:14:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B7A4A21A828
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 03:14:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AF72A30484F6
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 02:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56BA2331A7E;
	Fri,  6 Mar 2026 02:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a5KCznoS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D2F7E0E4;
	Fri,  6 Mar 2026 02:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772763242; cv=fail; b=M5fvQ/gGJn66i6BjLk30unsjDYySPrQMdl2PbAUAkvZDiIouogo8GZ65jecIV5NBp59Hmh7TWrkUcAiO3fsKKbPOH98Y8dLTP6EiiLsY2wm9ktcgXKazKv5vURA2VM03yhrEu6EAAH6OtL2azHod/YpBdwbPT+SWH7hOiNrd2YI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772763242; c=relaxed/simple;
	bh=bgO2J0TWqPKJfkpf+RRtkMSd/p6YVCPpyW4oYpwu0l8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TxLIuJ/JhylBXeVFucgSvBEMNNv530wcx4qcHNkbbBLX41rYLPYT+L4HLplAONy+QqHKSVfqh7H/oNpdyKO8tao1BYA3DeJ5Iupn9GFPPHOq5FvLm8Hb/NzZSwSxSbwJZOCu+Oo/PC686y6CqfsordiQGlXX5R+//Q5ELvMqRAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a5KCznoS; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772763241; x=1804299241;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bgO2J0TWqPKJfkpf+RRtkMSd/p6YVCPpyW4oYpwu0l8=;
  b=a5KCznoS52ebC47zV2d1CHSq/k2JBZh+n9DemAMdjHuWbGoAPpYydse9
   q/14CapQz5cqaAaeYn2JYcmehFrkfE4haXG8EqUeLfgKCJdWzPm0Q5z6/
   KrCu8Go97qZDNbPJtFc8q6oQN+XkL8aM8kF/H0BEwU9gpGwMjjjMI2RGC
   Ec1PTvoJzTtHtg6g8AJ3vbWbV9qVEyT2thNq+wo0ebtDQ7aExxHEL6ks/
   aYQX5y411ptCmi4IvWUC2Nv5IeOM2rZ+/L3lwYh/dm0wh3JWi8+TEzUcT
   li7W583oRY+mbbBu/MuZ5qipL004FBQ7Jw8kE+LaPMpdxHEEchHpR6UR5
   g==;
X-CSE-ConnectionGUID: 5EYMRr5lTcyyRsnXVIuIKQ==
X-CSE-MsgGUID: U98jxG5+TySZcGLJWyOwAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="61442702"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="61442702"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 18:14:00 -0800
X-CSE-ConnectionGUID: ycJNQTo0RN+EtZHWurP/gA==
X-CSE-MsgGUID: xvFu55onTtiFQNP+dzBmdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="219005421"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 18:14:00 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 5 Mar 2026 18:13:59 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 5 Mar 2026 18:13:59 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.62) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 5 Mar 2026 18:13:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CEkYb5L5ddpz0JYpmMkkG4PG0TpTsS18NL5SQtM3dS9JK52mH3BhiBVeLMJe2lqmPMAkc3HaULyfgrBeaJnIdkkvWzYSVNzdCvU0RZoB+XR1+Y4OH1EweldHTrwd6gzV3Q7PgWQqUz2jlbAfGvyRfJIvwWehjPs+quTq0DoNzME45p5HIBAofFMtc8SyBuXRV8XaCx5aa71b242JwhMxV6gR19lGiaSPkaHQYCa8Eg+17WYcNLVKOvZIYjvNenIvc5DQ053GQibiXEpmAgrIaXMSfdJ8wr7rIi8pzbDnkGYGU09pNvgW57Ho2LmR/YYP4Xuw8S5usVohgZgjzDrbTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgO2J0TWqPKJfkpf+RRtkMSd/p6YVCPpyW4oYpwu0l8=;
 b=pONXrAmgiucLZd++4Ntwg3p7z9apCiRshSyY4ud/7yIQNnBPmuMJCdxx/Ji7HBz92EbTPXc3ub97MOAJ8qxdpvAPwg2X9RduiUYDdsORaA5utEwUWCAmPu7yjFlD02eFJPGeebpvnXPcM8KdlDv6jOASHe2DOSRgzu4K3RkIkSwGJSWdsc1zrZBAnXsNxJQuONpW5XFs0hH6/Ya1HKSkaKtPyQMEJE36Nq53hc3h4u4IhkRA66Hj2ztO4VCWKyFWdjPBYTTIxvNEPumEBAM5sOXvAGteVWm16OYI8XdN5bDBT/kzZQ7mxvU3dOe3nQfcO+PW1FF6afl1hx53DSvMNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB5913.namprd11.prod.outlook.com (2603:10b6:510:137::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Fri, 6 Mar
 2026 02:13:56 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9678.016; Fri, 6 Mar 2026
 02:13:56 +0000
Date: Fri, 6 Mar 2026 10:13:42 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>,
	<tony.lindgren@linux.intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v4 02/24] coco/tdx-host: Introduce a "tdx_host" device
Message-ID: <aao4VunqChU5ZTOE@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-3-chao.gao@intel.com>
 <1be33429-25ee-4e99-b795-18f77f6cbc34@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1be33429-25ee-4e99-b795-18f77f6cbc34@linux.intel.com>
X-ClientProxiedBy: SG2P153CA0033.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::20)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB5913:EE_
X-MS-Office365-Filtering-Correlation-Id: 44c1810c-0360-4831-13bf-08de7b26056d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: 8G7Xg0s5LPycylXQWH10whLOTFrkST15uaP/qEdvc+p5DDOpd+BnKzvKJK1l5K90Hs00HGUwbceAihygwhyv8Ha6XSxlvjpleH5gGJviJGJpA6vqOSkNazbyBCbxM9zsY012lsm90YqmQK1c816doolPJU9ZLuTJB29M/SKFnXtYChdsq9X6csjhtApeciQDpYyLlucbXChTItxa9j8N9efdVGjfJg74OYS7srD2vjrPgvfnx6j+5YPBQRIZJX6f+yjpLhFrlfCxVSovgDnkNo/KEE4GLBUTa03HNmv8LxzdpWcc8ARd1WnZ9sddWWF45amLEsvKeU2pfhR1VMKZwBYsrSzpRIrAIW6P5zT0Zo89LtYKbIr33ZWR8aupU8VyaTygxU35nQW+7V2AOoyFgLtsi/HjYQBX24z+xiq6B5oMgTF3lE/C6QETXtJ42/J+zGO6p6qGgRO/wyMOk/v20Lx/pOy8EDvFMmas3A2mkwezkZmH4LiktEVHsD5kAYskqePyW1RNH2gtKuBEXFAboKJCq4TySP5jtpQ91r8nGfLXIp2geugcsSBKpEbSNXLesUHc5uwtdlxq+ibveRfDVb2Wa32uo8kvKhnru8b/x8yML09YxVWssslwFagBCLDExxu9UsdEDl7WeXCnpRHrrBPm6Hntk4tLz4vuN1XIsJLYoHzX0Izap7p84QCynf+jaSnU6M/0cvMC/Fixr+vZNSYkq3IGM7/11xLjtJxOyAPdTlPxJeX6wuwTxjfQaUXI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LY6Eh6/rroGM1/Kxj+RN2TgedmM5p90XghHaMJdK+ChFJWy0rOJ8e0zo8WJt?=
 =?us-ascii?Q?+MSx9uFJUdJ0u4mF4Fbdc6i8PKbEwOA07hTMRX95M0Qqq2xR6FJwu670vC6L?=
 =?us-ascii?Q?MGbXhP09qGzfYYcKLNSmoioVsfTbrZFvkqKWoJ2Gm8U1pyP0WaQ/72fIdfYQ?=
 =?us-ascii?Q?OEwLD4IVyLOF1dAexnJMg9Y3DyBMahbCVlJ8B8WCW4w2tcQdW/G9W4fy/41P?=
 =?us-ascii?Q?pp1S8CUIShL9Sf1uvH94i6Oh3qO9UHtXnwnd86/KSbDOD2PcPkcaptr0xILj?=
 =?us-ascii?Q?L+ZXlHzElLLO7rGy8Uy5OqtTF1d2usrqmKqBxWRHl0Lv6BxEhyjiDXOind3S?=
 =?us-ascii?Q?g0k40FRGIF8q/2AsLE2nQu8obdt6bQCUlOHLVr7h/ypVo2/6NV2+zYByo3ES?=
 =?us-ascii?Q?SQncBY0Oyyxe7JbN4fHcng762Tf8GwRuUGOwiR8F6ABgCmL68ZJ888w2L8Pg?=
 =?us-ascii?Q?m+UopHSAn8YsWO2FAWpfEmFX/8wW/XVG239QrIpPcvql3fQ5camdMkF1ZCDL?=
 =?us-ascii?Q?wx9pbJbx/E0AZIZntAcLLNEidyOea8HKlM726s5XDVl19I3pqXnVgw/DZs5E?=
 =?us-ascii?Q?xWidr1POuht4B5jLDaUP5KscqK5iA7v87vknNc3GoiYPbUSde3+KlpUONa55?=
 =?us-ascii?Q?p++MXxhnZz0zDZ4vKMWJy5CO8agiqi4x5bUsbPFY3YGAFkl6l+DPNFdcLivz?=
 =?us-ascii?Q?Q8UfzKBUH+/Q2UFf64r4BctjrS/LFyp5o3RguF9ggCw3Dmbi5Gfq1DhUHN3E?=
 =?us-ascii?Q?pLo3bT/iiKq9HY2jnlBDSR4Dde7Cw/RtA51ZFLkgYJdbfNulscGMi/1rrSE8?=
 =?us-ascii?Q?mgqJxZ9rlMXDL4GvxFxg1UjG/s3ANk14o/RsXCWhVxYS/dCnFmquvcC6ULOR?=
 =?us-ascii?Q?PRz/P7Lg6eRnL9cT/YcShgFYjNWXDAw3ZBmORbOa/SKtlUIy793xBdH5awoD?=
 =?us-ascii?Q?UKWYaCUnL4KUdqLLvQvSAXDAf+vZFFeVyfk66DXxiTIqNizjolqBlBsKAlXM?=
 =?us-ascii?Q?6uAUGOX1Br7GDMAGKNh7RMRgVvbcSB/NGhj78J4gUBJS3qHnXV5VL8bDcUQ7?=
 =?us-ascii?Q?7RiCoK9FicemsppMckCIiaMydiP3u3culr1g8Xz1HLurvqOciQdBaGD9bx+b?=
 =?us-ascii?Q?4Ye7+s+E47Mn2KUAjad31uKKoBSNz+0Rd3riQOcv5vStZMjJkZpR/vAls+0w?=
 =?us-ascii?Q?XyzGyZUBKnWaP3rIsN4NvOTPZ1ui+0c8FWyBysPfgQc+SzpNCbqsg1d4q8J3?=
 =?us-ascii?Q?Hi/ZZKGuqcpo6ElWHw/wYIXaRY/aNxeZZSxUzr1pQDZMqAKsQbRg/Ex4ZoU6?=
 =?us-ascii?Q?up9H6CrA5euf1D3x/ufqw/X/PtaInUWhiZQ0iKykACCuR1khi77YEZFjZifP?=
 =?us-ascii?Q?Zm2Or1yDIFRX4N4vohX9sBxEKbWWQA1oHDkSsNqp9vRu+pVp01yHl6mjTZ4B?=
 =?us-ascii?Q?KNIV1B/K3/SbW4qsFDiWXk9UxQ7tPt7nQkobgDNOjY6RUpfFkQwTgYpivESc?=
 =?us-ascii?Q?ySqT7U6BY0vGe7nUrLDU5MvCF8PIx7D3Ag4YZtohVvTNNeHijaVE/KVbkFG8?=
 =?us-ascii?Q?Vi3vvDXMG396qH2trvCrFwkXnBKEPfSA+1yrdX4H0BW/mHqiwcvrS4vWfEuG?=
 =?us-ascii?Q?Z2fX4Mexc79Qwnc/ZqHC6ZmRvVFGKYSwqO9iuUezKU5a7bskdkAnl5P0vTT/?=
 =?us-ascii?Q?B/SzrzCqurS3OX67hFfvfCAEMkK0r7gmHurutz+WZ54ZUogkuo4uJLEmySaT?=
 =?us-ascii?Q?kIx3v1UTXA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c1810c-0360-4831-13bf-08de7b26056d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 02:13:56.4870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEtKNAc5CfVcafyBmn3NxLoFI+vTMPnNgwDqmjAXjYj+hkC4DXpy+5AAyEtk/Gxd1ev9YWgwtOyqdBdciRf5Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5913
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: B7A4A21A828
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72974-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

>> The call to tdx_get_sysinfo() ensures that the TDX Module is ready to
>
>Nit:
>There are "TDX module", "TDX-module" and "TDX Module" in the cover letter.
>Better to align the style.

You are right. The terminology is inconsistent and confusing.

Different Intel specifications use different formats: the CPU Architectural
Extensions spec uses "TDX module" (lowercase 'm'), while the Module Base
Architecture Specification uses "TDX Module" (capital 'M'). I'm not sure where
"TDX-module" comes from, and Sean's VMXON series [*] adds to the confusion by
using "TDX-Module" in log messages.

*: https://lore.kernel.org/kvm/20260214012702.2368778-12-seanjc@google.com/

I don't have a strong preference, but I'll standardize on "TDX Module" since it
matches the Base Architecture Specification, which I think is the most
authoritative source about TDX Module features/terms.

