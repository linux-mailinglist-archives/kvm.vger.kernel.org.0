Return-Path: <kvm+bounces-73321-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eALpHp7ormlRKAIAu9opvQ
	(envelope-from <kvm+bounces-73321-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:34:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DF6323BC4F
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:34:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6F045317418E
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B719B3D904E;
	Mon,  9 Mar 2026 15:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QFBW81Ct"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60CA3D75D2
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 15:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773069914; cv=fail; b=B8SHBr/CFm7YUzaPiyZC9Vp4op2kGzAMM93PCj4Jql9G0don4HUDxHTbAnUc+f5A6A3dSftEwGBFiRLkT6qd+zOS8e89Jb1gjzct4iXVu+XdIVvVcGMDby/9GD/nhLl+GFAEuOEBd+BYbKwTM9TBiylw2zG9Sq9CMkwD/1+6k7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773069914; c=relaxed/simple;
	bh=WLuyxaJgRScSyxsyi4hpLLiAiw5o/d3IWKd8mOxIHDM=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RI6+4Ql+Q+xv9nlhNl3C9xSs8XnNNVOBWuMt62CZr/yqNIwuoGyHDraqszgCdeYwgErE+pqrsi6W+cL1nvBaSqUiA7cx1EVcPVcgKzzD0HMraSr6BXSnTdZVpuI77mOQ/LRKJWD8lsOZCuHf0z45TcTF4ZQTnF5tcJBIp70StLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QFBW81Ct; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773069912; x=1804605912;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=WLuyxaJgRScSyxsyi4hpLLiAiw5o/d3IWKd8mOxIHDM=;
  b=QFBW81CtBpSeQjrc9gJHOxXX2xELBJxD9qAIgT4wbzpHy4Q5Dq7CipTW
   Bs/lXaPiUq7LDiCylTMIRCv6zSnseYJCyiNlrjEdR3v9xGoL+L0OPrgCs
   08jMFBu1u6kGupzrm3I1UB9M6K7lB7vg2joHJw8XywUAH+0r8bZ2xfhLM
   msm1gxh1c/AhPHM7Y1g+buzYarqecSyeUmtIboNzOQ+BlYPEyh93dBt17
   TJHz43WoJ3xV/ZQAaZYkgEkKYx3P79Aopdsf8TIP4RlR08dhtyjGB7FRb
   C1/KYYKhi0ry78TNN63vAsUbcD/76atQI7F7qyIPDwf2bYGiY17sNbJSP
   w==;
X-CSE-ConnectionGUID: 0sQB29JARs6hjT2NnXk8xw==
X-CSE-MsgGUID: ESO1BGoXQXiAJSakchvxfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="73118744"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="73118744"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 08:25:11 -0700
X-CSE-ConnectionGUID: msqVXJ7NQtWHFvomOk9lvg==
X-CSE-MsgGUID: Yocw4qdaQniuCNQIxrPZGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="217829598"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 08:25:12 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 08:25:11 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 9 Mar 2026 08:25:11 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.38) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 08:25:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hcNWVD3mHYA0KUC4FFMLsQ5ZVfa49+mPYxh1Mzl7Qt4aJIpdx/EB++n70Tn/hvrK2VB9dvU6zAMyFpFSOjiCnegKYBd2tLmMQR1KdMS7caHtNYskEH/7Mr2bgZSBvFFE2RgbMjP6EFC65gtAyxdXotVeEKYjqnvwP05mRCwZ9kqiEV++TQev28DZE2Wx5Lga20MyZd6wqlEfKKwWWdpkAU5egXeDXtyZDNunc39xTf9POrQlWOvDeigAdFal4kzm03/k2NX65DGRh8owUJBzcfo+VHBMvGbOptxiq41wDEPQCCrPrUm7FZgto8bMXMsq7m5gHzzJZqsvZCiZCilt8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32qbH/lONh82j04jxxuq6jmqYNHi4h85sbogsYSMXxo=;
 b=ODlYtEnoDp/BSWWUgvi9Q4c2T3cMzRfDsdWL2S/vXE36XmmqyMOfouTi5hKNuqfs4ETrg9pdlMEaGtx4jxQA1F6mtUjilWn50bGtGfBP/Jl78xnuHCNIxRGjn0Zer/+4zrr/d9Y+/R9D05iJAt38alRoEAgSseHaIR6QbpGnFQ2Is1WtheqeGEo5a2LL2hNRs04pSNSx5cM14Uf8q9hPbwA+j5fuKxTHWvHlkbSP1qvXw9hnEtFJKhgFzcaNdJdmQgPRaaby6NRtdV5xhOD8LhLr6FTp1eD3fvl3KHV3jQypOLKyH6NThVViiWJnvnNEWN3vKYLIyhJsi0sS9Nke2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6135.namprd11.prod.outlook.com (2603:10b6:208:3c9::9)
 by PH7PR11MB8479.namprd11.prod.outlook.com (2603:10b6:510:30c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.10; Mon, 9 Mar
 2026 15:25:06 +0000
Received: from MN0PR11MB6135.namprd11.prod.outlook.com
 ([fe80::efd5:501b:c890:26b0]) by MN0PR11MB6135.namprd11.prod.outlook.com
 ([fe80::efd5:501b:c890:26b0%6]) with mapi id 15.20.9700.009; Mon, 9 Mar 2026
 15:25:06 +0000
From: =?UTF-8?q?Pi=C3=B3rkowski=2C=20Piotr?= <piotr.piorkowski@intel.com>
To: <intel-xe@lists.freedesktop.org>, <kvm@vger.kernel.org>
CC: =?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>
Subject: [PATCH v2 0/2] Improve VF FLR synchronization for Xe VFIO
Date: Mon, 9 Mar 2026 16:24:47 +0100
Message-ID: <20260309152449.910636-1-piotr.piorkowski@intel.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0003.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::20) To MN0PR11MB6135.namprd11.prod.outlook.com
 (2603:10b6:208:3c9::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6135:EE_|PH7PR11MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 990220c5-92c5-4e9f-b1dd-08de7df00af7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: J2CjZUQ2LOTiX3/Bw+P0FKYMc7/D5uExH4FlRwDzk+nEbeIX1QvmiRuAKGjPMVvgE25ZjY5pABQoefHRfF32LKsFlKj+VG0dmNCip3I6bn0GXP6ZUngdN8F2bYIPEiwqWD9XtsI5sHqMi9yXTcyN1KGMgG/qU5tW8gRnhAuIaVmDrX78+TGJC83hOJFh58Q/vlezT/j5KkLtBpJo0mrwGqnModA2xU0VRq5k4AtnXm1dcs4I/nheyVG0YP8CyR0KmLPMGn5OlMWQoTsKg03AfLJPEm5ragnYnCIi/mqZEJktWIYdbwLGvv1gEcLkcwRrJ2I0JnaC5G8cYbRU4h3hhkdtIgK0wYhoZAFyWofmakIig1XMy3cfh+2DP7sq5W/9cdgIGGq1WoVTQSES4O9dfDwbF5MrsaoCOr6PaS9GdoaMY8ZXOQ6Tg7DZ2j5y88blIrdUg+V+Bi+EHMMKnBJ5izt62GPhJ+jiJGCXGs11WcOkHxRwLNSOlSJk4wN1vI58Y7a6iqzPpGnou1gvgQ8HQTrV/EqHxTse6izysyUutc3pQK/k+zBqyElyxObOHSP1+2Qycwko2vfW1iOiXDni/4+IdyQ24brBT0ZLAU+QBwjQ8jwHL21ZRBTPzR5W6vu3tBk01LVo9BvHHcyvhBFVVuXChHCguGjUyJ29+qDu6A/lX1icCVPsQpqlhZhzLL3Y8zNdMNu3pRdwJDJMj6AfFnolxR0yZNLshAbETCj+m2A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6135.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3VNdjB5SUYvUFFCUlNqTUUwN0RXMEl3dUd4TUJYaG4ycUd1S0g1aTlzZ1Vk?=
 =?utf-8?B?dlZ6WDZUWWVDUnJzd252K0ZHQkxML05BbU11dFlIWmI1SGZ2UnpxVlgrQ05r?=
 =?utf-8?B?SWpGdHF3K2dDdTA3eHgydmsrMUpJQW90dVg2OVdKcnh2MzJsYzRVK0R6VWJW?=
 =?utf-8?B?S0tVMW5qYzRya2luSEkvSUhZbHRaNjRydVFVUUs2K3ZPQkRPTm95Mm10T21D?=
 =?utf-8?B?ZnJ1Y2ljTS9nS0I0RG9wRkZmR0hOVWVPY21tR0o4ZkluOW5WZ1BENkcvaisr?=
 =?utf-8?B?YkVVSDIvUCswb21LZFJtY2xwOG92bmY5b05rYmpKU1EwOVk4dlJWbTQyK3pj?=
 =?utf-8?B?Zy9OQlhHYTdONzVURzJRelRXbkR3cjRkd3VxTTdTdC9lNlRveXlKZG1Wb3kv?=
 =?utf-8?B?U2xoNitWRTdLMFA3SzBJdWdvVHp5SXdMeEg3TjlSUlJEUzZzK09EbnFIK003?=
 =?utf-8?B?T2YyQWpPblhFUlllcWFaMEh1QW5NdjJpSmNJSUh4eEp1ZFJUMUlPQWpqN1pR?=
 =?utf-8?B?NG5NN0o1NHhodlhFNnZZUDByT3pPcW42ZFNlR3JJSEg4Qy9VNDZZMG5FVzlS?=
 =?utf-8?B?VmNNUGxPR3J6aTlJcURqV1UweGRQb0c2OGNXM3lUZHYyb2ZGUEphWSt0ZVFi?=
 =?utf-8?B?UStwMlk5ODNhRkxOYlp1YVdxR0VhanY1S0ZmdmF0OSs1WXliaUVCd3VwTnZs?=
 =?utf-8?B?U2FMZXl0aUY4T1YxQlNYaTdaQzNXMUs5N2hqbzR4d1o3dFpEb1p0N0tnWTZD?=
 =?utf-8?B?RHV5Wk9RVzhXNFhLNWFIQkdmVmJzOUlMSDU2RDB2WG1MU2hLMFE5VVlWTzZQ?=
 =?utf-8?B?dFJ5WXhHVUhnZy9MR3djUE9SNXFlOG9JaWozbk01TlVDekQrdFpwdDltbG13?=
 =?utf-8?B?ZCtEMXRpbFYzL0lDV0xrK20zeFdkZ2hRM2tVTjZBOFp6aCsxQ0QrVnd4WVc5?=
 =?utf-8?B?RTVaU1RwL1NudWh5S0I2WHdoelJuK1pnOEFyTVBrVStlZWFJQXFCZEpvSXRE?=
 =?utf-8?B?dzNURS9Wa01ocEZVUHR3azlQR0V6Y1l4b0YveEhaQTZCQ3BUei9XQjFzcFdy?=
 =?utf-8?B?V3Nrd1BBV1p3WXlzbG9jMTE2RXZZZ2daVHBKZmZ4ZFY1YkJNZ0xzZGZPL2d1?=
 =?utf-8?B?OHZGeURlOC8rVjNoR1lxVnk4OHNEazFrQlhDMlQ5TmRZSi9ERXltT0h3NUs1?=
 =?utf-8?B?bkVyM2ZyV21zS29JK0pRMllzblpzaTM1SWRua095bEYvL2xaYlcyRGJnMWRs?=
 =?utf-8?B?UVhUbTdvOVY0N0lucGRGMUJTR2NPYkVYQ0w1T3o5SGplR1NYTEJtV3VjUUJF?=
 =?utf-8?B?aTBkSFB1aktPdU5BV2NlK2pJT2dwT2hMcXR3NlF1d1JJTWlkeHR1aDhmdHE5?=
 =?utf-8?B?Yjd0UDlGVFpqK0prMWNIekZ4MUtib3l4aVE5eWx6cDZoT1kzTzJWYzlEUlRL?=
 =?utf-8?B?VW5DSWhsWHBTMGtnRmVySDUxaEZMbks5b2R3WHRvdmpaUDlBZE9qNzZYYWhp?=
 =?utf-8?B?ekYwVXRTOTYxd3BMamplcDU2SGw2VE5VYjJGNTJFd3BJZnI4NEpiYjFoaWdv?=
 =?utf-8?B?SW5jbitFM3M0L2NsOUc5UStkQTNxaEF4a2Vlc0RGWmJFbktXdHUvVlVEbzFu?=
 =?utf-8?B?WnhmQUFvM05YOER3aWl3MUhTTmErc2lxS3ZZRnljZ3NlWUJrVEZIN29weStG?=
 =?utf-8?B?Rm1tRVJBYnlvcnVzK3FWdElSSjRiMWJJdDhJek1ubEE4eG9TR0hUSHhmMGJF?=
 =?utf-8?B?Uk5IdjY2dXpvTmd6aFVSUXNBSzZNcXlqV1AyVUozZ0ZBYm5XMjEvUE40dE5D?=
 =?utf-8?B?SDROTUloM3daSzN3WFkrcDRzWGNvS21EMjJiYlQxc3JSVWNLK095bXA1a2ZQ?=
 =?utf-8?B?bSttQW5TWkswQng5NDNyeGhiTU9QZ2lndVN3NlVTOWxrb0tLSlM5T3pIdVhD?=
 =?utf-8?B?QWNLemR3MFNiY2s5c0dxdC9tL090VGIvRkhVRGN0NHo4OGRqY3k1TTU2VGla?=
 =?utf-8?B?Z25LNEtENXFEdHZpRWFoOFAyZGUvenNHRmV1R0MzUEdHRmNBVUJLNlFTa0hZ?=
 =?utf-8?B?Vjhia0dTQ3d3R0R6ZVFrV2dmRnRiL1QwOXoxRlRXQ3k5cG5wbWp3ZUhNdEFO?=
 =?utf-8?B?ME41UzNZZ0FSb1c0UUVhT3h6SlJ0VUJ6UTZFNVRNc1g0K25yMVNxVUtqNUFU?=
 =?utf-8?B?bWY4dWZHRDNYaVVDZ1FsS1BhaUVuaklwQ1liWnpPb0F4RkhSNU9WdmRpOU00?=
 =?utf-8?B?a3hCTldyWHBWUFQ4NFNiTGxqTWpCODREOVI1d1l6UlhPeWhUU0hDRTZhdzhN?=
 =?utf-8?B?Ung3Z0FaeFU4WlNXZDNYblFlRFJpMlBQRGxCbTBNaythOHNPSzV2VlJySlRC?=
 =?utf-8?Q?o/loo2FmkLVKoLOk=3D?=
X-Exchange-RoutingPolicyChecked: ISuG9AhEZk2VQymHk+csYe3f0Ld6kdoYWadICtLV5CPHCADvInn2T9RpplZYL54XmEg3Kx5pklBQKO3dmF6V7OFgJmoAMfGHEX60Vr5AbhUOC1eISrhztOgF9ZpXaxKul3q1z6fkxW2ElV2xDFK3OqGDG7XIJuOKbo2LJQV5g280zSzZJt1nTlNrt0ZF3u6TCEWKm4nEivG9+T9xiUHzZ93n4fg5yOMXVa3uy1IE32VmBuILNcqIEgOLqUCi8xeDJBA6gcHPu7iOePySLX00ur8v+mkyQVeS62DaPoVLiwAIPqE+89jWCJdSl0o6/sWzBtDTMie2HQi7YfxrvJzubg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 990220c5-92c5-4e9f-b1dd-08de7df00af7
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6135.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 15:25:06.3954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oUIvE1q4MS7rzI6g7KPQN5fD6sQzD9X81dbjd9qDSwLRV1d65WALeH8y89ByTZh5CytgDrO+kMit9yaxYCz7+iYle7tmxEu8dE7+iN6gsao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8479
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 0DF6323BC4F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73321-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[piotr.piorkowski@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.978];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

From: Piotr Piórkowski <piotr.piorkowski@intel.com>

When xe-vfio-pci waits for VF FLR completion, it may start waiting
for "FLR done" before the PF driver is notified about the reset by
the GuC. With delayed HW/FW notification, the PF may not yet observe
VF FLR in progress when the wait path is entered, which can lead to
the reset being treated as completed before it has actually begun.

This series introduces an optional FLR_PREPARE state in the PF control
flow to mark that a VF reset is pending before the GuC VF FLR event is
received. The wait path treats this state the same as FLR_WIP, ensuring
that external waiters do not return prematurely.

The second patch hooks into the PCI error handler reset_prepare()
callback in xe-vfio-pci to notify the PF about the upcoming VF reset
before reset_done() is executed.

Piotr Piórkowski (2):
  drm/xe/pf: Add FLR_PREPARE state to VF control flow
  vfio/xe: Notify PF about VF FLR in reset_prepare

 drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c   | 78 +++++++++++++++----
 drivers/gpu/drm/xe/xe_gt_sriov_pf_control.h   |  1 +
 .../gpu/drm/xe/xe_gt_sriov_pf_control_types.h |  2 +
 drivers/gpu/drm/xe/xe_sriov_pf_control.c      | 24 ++++++
 drivers/gpu/drm/xe/xe_sriov_pf_control.h      |  1 +
 drivers/gpu/drm/xe/xe_sriov_vfio.c            |  1 +
 drivers/vfio/pci/xe/main.c                    | 14 ++++
 include/drm/intel/xe_sriov_vfio.h             | 11 +++
 8 files changed, 116 insertions(+), 16 deletions(-)

-- 
2.34.1


