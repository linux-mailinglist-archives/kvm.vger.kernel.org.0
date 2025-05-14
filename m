Return-Path: <kvm+bounces-46414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1788AAB624D
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F52D1630A1
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 05:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0F0F1F4174;
	Wed, 14 May 2025 05:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UYayXai4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444813EA98;
	Wed, 14 May 2025 05:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747200403; cv=fail; b=mF0oEFAqfPnk47to7ykZO7z2wMcqRala0Xwh8zLwOor7T1B/XERh50QXmQ5MkGUjg6XvbH7nZKFF7ayNS+alVZDaKEmzR38yPweUJkoi2YWC4Yk3KIvnNFJZABbXhQxeTiSwVfjNhwAPRUJlSmrk/yrTzZlOFC3TCLxli3QcjrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747200403; c=relaxed/simple;
	bh=WvuIOGgD/2hjF2ydoEQOCVD5ZSUzy3IZ3wek8O1J9Xk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kpRxCuB60LddvqUPdTghZ8B9igDe/jcvZuviO3OV5dREij5ChaOQYvl5MK/VbQlMiIv3PvDuwX9/mzBUIqyqquiqujr7AoAXt1jDAUVXD2vZhv/iRNxspEsSfOul/qNvDAYhTtTxODvRpmwDXN/NKFUWq3P5m6PKEl2c/rtnYkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UYayXai4; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747200401; x=1778736401;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WvuIOGgD/2hjF2ydoEQOCVD5ZSUzy3IZ3wek8O1J9Xk=;
  b=UYayXai4hcpo2ADYYsHU6tBvb7V/VB/rGn4Ewwrp+8h4wfQz5dN0GrNe
   DE7GpSsz7TWJz3BWDWcTggFcQXgAVTwlrAWA7V6zunCLoh3j5eTXhHz+4
   kAjSDQcIOvSF6x8la9Xo8J8TtfH0+rhDua9jOEm+EOV1uXnQL4NzNQOtd
   jXK+jes/49JuOW80qeA6Ou32niikzIvBo6UFysISIaJH3qeYTj0htdo9n
   gV9u7gEsHeZqK25Sm3qetLvIvA+ARlP5w4BI3ZUNeg1xLq40KuDFR79tY
   FzEW3LKeIfW1AlASldKhD8x2O9JnZzSLA6BVcpR6YhSBdT3CO7dFzze3w
   Q==;
X-CSE-ConnectionGUID: zp++2pVzTBiC+SXh+JwMDQ==
X-CSE-MsgGUID: KrTt9aR6R1+oE1LGDR4Rdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49241603"
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="49241603"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 22:26:40 -0700
X-CSE-ConnectionGUID: sXZERIRFTjiQ6//3ou4hSw==
X-CSE-MsgGUID: vU6auSukRFuZ/jq4NXD30A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="143039057"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 22:26:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 22:26:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 22:26:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 22:26:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iP0l3fSdjaWgRUelUWzjrZolAsgGqtwJf0xdeXE4/aVveUIAGN0lS+LVtYtInG5ySESRtxJW67EEbjVD05bd15sJtDseQE88quBAVuU/LAgf0Zf4v0KDZp3inlwBt2zxKV1449Xb0QeCSlvf7J/JYXfoOgRiJ36hL6fNICTxIjUjcwWf1YGEXycqyVbDStoWFiOZ0+iTnTszSBdCUMXQs5iHQLwSabi6XQlBzvUKmVJ20Ml5LsMYne1X/o6VH6XMbBfu5Uah5yZLMa651RWnfdKUX0A5m5iq6dmMXPz6Y30sl2/6njRE1ReERG6klavN//g9+92Ip1filfgP2C6BpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dt70jM+Cw/Oxyg4ZA2Umhyw9u45IvVuB3VG35DVARSI=;
 b=xPNztM0HZp1MbpugtPfDg3vf4UtNXJ17TCXWtiAWet738Wh1sy0UfNROg5gbRh2IEVFwoCK9S3POnc4OfF44L1PNL0frOjOkFlzjCiR0vDZVtXVOGoj38lwQJwnjUcd5sMFnZEWQI3nLB0ACEj5D4WXi8Rsmuf44inJOCXkWJWttM3tUF4Y04ce6Ax6tXgKPRBu7tNzLvhi4GDu42j7VhXvz+g6BSh6uvqsJK/IDs9FileYTPOsY283jGKSweow2rv9kkJ0tUGT25o2FHXLw9OM0spHpgE/+sLcGf+yYcwXXfhYzj7bkMMkh14Wh/iX3es3l/gEOMszXwhde65i/Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB7382.namprd11.prod.outlook.com (2603:10b6:8:131::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 05:25:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Wed, 14 May 2025
 05:25:50 +0000
Date: Wed, 14 May 2025 13:25:37 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <rick.p.edgecombe@intel.com>,
	<isaku.yamahata@intel.com>, <kai.huang@intel.com>, <yan.y.zhao@intel.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Message-ID: <aCQpUQx5jNQxPBez@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
X-ClientProxiedBy: KU0P306CA0062.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:23::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB7382:EE_
X-MS-Office365-Filtering-Correlation-Id: 84f889c4-697d-4506-8f0a-08dd92a7c9cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bX0IDG1zCcRJa5T516iuucHXtBre5u+2cBgNg8cej9ZREK03nosrmY3pYxpR?=
 =?us-ascii?Q?9aFx9YmW1jOOZ0Eu/QuP6sOEqwndKTTz17TewAV4Xhk2ETPbToMleB/LU8Ix?=
 =?us-ascii?Q?jHi/6sQPAuzoPb4H7eabTyljKS5QrgK9NcqNpCv95xGscM3mGgeyYN9IqtCh?=
 =?us-ascii?Q?LWHpYUkMU2N/AoI9u/2zOeXM3ncKdcVdHkYdQnDEeEi2kY0YDKJGvtr2OHWc?=
 =?us-ascii?Q?wskB0aTpoXrjHI6dQZv4TRIyF1q6DO4+uJEtjMfdpLt56KWxgCbgGaXgi9Mp?=
 =?us-ascii?Q?OHgRBFRei/cXN/pPWBjD5sGM3wD23EmJOxVBVOtnUhqZbVyUVbZ7IqiqqMBD?=
 =?us-ascii?Q?b+7b9IiyXHfLizAE/luNVZS9J2KuOg1W+ytsIxtT//bWOBO2pDyb41ktWban?=
 =?us-ascii?Q?Q4SdhaJQRCV6cQYaW4bh1HYPFp+HJn5Z04hU/FwdpamCifgRK2088TVfNCZ0?=
 =?us-ascii?Q?wKtA5V1iIPsxV4b/S9RKJlWsTMd7F4HyCZUUKifMkD+mxQc0meBDA9u/+b7L?=
 =?us-ascii?Q?OvlZA08aTt7Q8Nozv0/hx81YXK5V95v6GkLs0Nlwck6EGwubUM7mLdKnZzoj?=
 =?us-ascii?Q?c6gDmheOkAL+Sm16NR9sqZZqVtw1TCXWDjccetHIIjvnG0ll9XK0KOLIrYab?=
 =?us-ascii?Q?CMGAxFKqFoJIVcu+FDEpuG9cTbtnBsQxMvLSTnhFy3LI3H9sCkUbHsDov1lg?=
 =?us-ascii?Q?kdQKR4cQXEvrpVVWpOK6dkufJ5+liE9zQAC901rFtDNdXut2fSwXNq1EKYXN?=
 =?us-ascii?Q?3OyT4vbBEUKTGAD6luRZtCRhSHjRN6rURR7hw2GvaKMN7E0RpCRrwxMH4uk/?=
 =?us-ascii?Q?i039hAXdRT3QBIO7399lSAHoYZ0xw24vKHFth4m2ejIJmy2EaNz8r20X7J+u?=
 =?us-ascii?Q?VytggmIh2SyXjsA7ODl6RpwI96wOAKJxxUOVAS3vJgW+G9DoPN624fm2ZQZN?=
 =?us-ascii?Q?+cYbo/aZRciAlED6hrbuCZZnfnbm17bXhI7Xq9EHGFQWItrubdZhD99W+sss?=
 =?us-ascii?Q?K8St9okxfuUuDqJZ/I99MonB5ttPD6m1uMGBs2miMxsjQYLUBRYVwI3FRrwv?=
 =?us-ascii?Q?7EFnjvKsC8/WtvcoAQ8+QtQQzKS5pdz4asR6g11MymDKi92AMtP5Ey58nj4j?=
 =?us-ascii?Q?wxgbw66Sf/Wyn8NccwrEmV3C0kaVbuvVad0NCdw+5vs3bqMPJi1HhTKfWG1j?=
 =?us-ascii?Q?73ZUcyhh67XF3A73XDtYm+HzwVcFbBZovmT2/fsWsuhR4ifkqKMsZs3Z7GTM?=
 =?us-ascii?Q?T5PwBOGO8E0/5b7fbTRDtZPLdlG0NyfzDrdYbuFTGsD+JwD5g9f3j+wVdVvq?=
 =?us-ascii?Q?txkeRtjBw6NYA7nk3O/aeAqNM2CqWJeQLCTZdT4JdXTcs70u9PGlTiaXoFNq?=
 =?us-ascii?Q?0ajQkMsFNXlOly9Sf0t6LDbyDBTTfpUYPHi4WhBEdXjIrG24aP+4iMa+fanw?=
 =?us-ascii?Q?lPgEGuRQ7kg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F5k0WamqlUjBLAeXuJj3LCLZnlDmitM/cehx6oeJt3TGhioGE8rITNsf5OQ3?=
 =?us-ascii?Q?v83B6aGc3DvgpjQE0LhRLD7+odkYS/wefEE+1EzWb3LL/6E9VutAmI7sPiqx?=
 =?us-ascii?Q?c7M3AIfcL99epznTcQVmfnl2iWi1xLG2EqPROf+k/Ffbc2/rhG2BjHwdK1eQ?=
 =?us-ascii?Q?Be80Ln/OUsqzRtBf1vU2xJx0HwNuXkR9zk5Vh8dINXVXwxsCfNrO4pVQIxJi?=
 =?us-ascii?Q?63te5vy3KUHv6VfEFpunhqeljgoL7aLUhI9rhz6cM5IeSVEw6S/IfhJzgEg5?=
 =?us-ascii?Q?Qk3ynHFbGMJU0rQUgci95CmVq+OiSavTKepdlmwv+86/Qj9rq3Wqf3sCpvJn?=
 =?us-ascii?Q?b++ekborMBhPl/HPtJb3dB2D/6K64hycxed4yIXB3C6GTu7VokN2JD1zIjHI?=
 =?us-ascii?Q?s4ykJuFfN5vAYfUMl4dHEBctYG1+rCiVXYoG2nHG2eoCgWhmJ87vcEO3ovmO?=
 =?us-ascii?Q?SqnAOmGNpwxvQpYgKEydBS3A3uhJooVwL8Km7HAAFXmW/ZCqlWMGUDreo9BZ?=
 =?us-ascii?Q?9xnu/JMeA6+8Erq7Gv41WrqoFOrfY5AdHRM8xEbz9JiyCsp9G2dY/SWfV6Ps?=
 =?us-ascii?Q?kI3N7zdHc2wV1X7/HAe28LmSBntLHmzEhgF+NxSPR0ZXLkXMxQ+R3oArvKi9?=
 =?us-ascii?Q?hAaau/WIPpBzWVGj1VrA4y7TLa5lT6l63SrypEQxRsYsYjsFfuzYpfpauI53?=
 =?us-ascii?Q?giwknS42FfFnIaAlbtiIHfFBvoGfWXTj3XEdkArtWbUadHAaAiFu9CYkex9O?=
 =?us-ascii?Q?mfl/snGTkR/AMvijlMPNhxhnLAsHTo3/SqBqNvg0Hr4Ga7BlwiNeTZ56MKet?=
 =?us-ascii?Q?H84msmul8wRdr0velbtsA5vz/X7DE7mijXse44l8wLnHNQTokjFhux72fvHm?=
 =?us-ascii?Q?3xC8ucf3VwkSQHWuMvzJSBrDbfdoGEti1qrH1+dnyDkBAXtI9m0QPr3LEmFF?=
 =?us-ascii?Q?+mzWANCO9uCADj0mLNcEmPezkTHiEt2dZAtutzbaaLdrZPUelscb5lmg//lA?=
 =?us-ascii?Q?T9fd8mb35bCtkhgdHwmmAIgnqunTFSt/eJavWbHS/d1vqOvO/61UhBEplh54?=
 =?us-ascii?Q?R2ceAttXvqRmK0zjjmzRMxEy30NXEEroc1HKwazB0gXGffjaY+BiSMIluH9z?=
 =?us-ascii?Q?WeIqm9obiiJM316WfonbQ/ByrxzMngPryIWybPBtx2+/RKHa5CF96aeGqrE+?=
 =?us-ascii?Q?oTYijbf+gfGYeCDnZVbLGljVzyWLX+aBhJQdgno5hIZx3MHurFV2gbxhbZeu?=
 =?us-ascii?Q?E4VpfupD/dbKzh6mJb2sK4UCJ4C4Qac6YhBsAOfYY2+k71WMUOR6fGl81cja?=
 =?us-ascii?Q?8ETS7iSWzkMWQuuAw/dmnSyZ4HQOIQVcPAliQ6PdINLSZcsOYTxp+kogx6qO?=
 =?us-ascii?Q?lJhTgKABzd7bcF9YVEfaIXk6bK4ZuZd1yburjzt76ldI8G2OQaWNpJgDDGX9?=
 =?us-ascii?Q?uREZSwto6irlAITCqd9TQf96qPCLvUnZ+eo5yaKSRB5mU2TPqFD2eAqwQHd+?=
 =?us-ascii?Q?KnUyN/pl+GLdJ0OyfkkBnT+EsxcvtCJIFovbzxGcBXzQxHMC4psTAtjnDVqe?=
 =?us-ascii?Q?SKpv6T9xB1V/yBJ+ABvc4dZbRhKaqlAp7ACudJcq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84f889c4-697d-4506-8f0a-08dd92a7c9cc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 05:25:50.1512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LvwzFTAJEtf3o+qgKJN95s6jzHgW8HPuh2QHDs6mFhU2VGTor4Wn/LVnR7oEOEYRyKaeg6W8T7lbF/60Sba8cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7382
X-OriginatorOrg: intel.com

>+static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
>+			struct list_head *pamt_pages)
>+{
>+	u64 err;
>+
>+	hpa = ALIGN_DOWN(hpa, SZ_2M);

Nit: it is better to use SZ_2M or PMD_SIZE consistently.

e.g., patch 2 uses PMD_SIZE:
 
+atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
+{
+	return &pamt_refcounts[hpa / PMD_SIZE];
+}
+EXPORT_SYMBOL_GPL(tdx_get_pamt_refcount);

>+
>+	spin_lock(&pamt_lock);
>+
>+	/* Lost race to other tdx_pamt_add() */
>+	if (atomic_read(pamt_refcount) != 0) {
>+		atomic_inc(pamt_refcount);
>+		spin_unlock(&pamt_lock);
>+		tdx_free_pamt_pages(pamt_pages);
>+		return 0;
>+	}
>+
>+	err = tdh_phymem_pamt_add(hpa | TDX_PS_2M, pamt_pages);
>+
>+	if (err)
>+		tdx_free_pamt_pages(pamt_pages);
>+

>+	/*
>+	 * tdx_hpa_range_not_free() is true if current task won race
>+	 * against tdx_pamt_put().
>+	 */
>+	if (err && !tdx_hpa_range_not_free(err)) {
>+		spin_unlock(&pamt_lock);
>+		pr_tdx_error(TDH_PHYMEM_PAMT_ADD, err);
>+		return -EIO;
>+	}

IIUC, this chunk is needed because tdx_pamt_put() decreases the refcount
without holding the pamt_lock. Why not move that decrease inside the lock?

And I suggest that all accesses to the pamt_refcount should be performed with
the pamt_lock held. This can make the code much clearer. It's similar to how
kvm_usage_count is managed, where transitions from 0 to 1 or 1 to 0 require
extra work, but other cases simply increases or decreases the refcount.

