Return-Path: <kvm+bounces-29259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94A1A9A5EA4
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 10:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B179B1C21809
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2C81E22F2;
	Mon, 21 Oct 2024 08:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NP8oz6GO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5C61E201D;
	Mon, 21 Oct 2024 08:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729499345; cv=fail; b=HEYnnbEp4gxPKE0RcIWYIY+/mLDsHKWz4/PDo5GNasE+CcyXBf5GHzO13xeXc8bfdqXJ5tTxJWPdHdM6C+3QxPGtKxdQaphxBnNiWtbtXoBIdqi3CyX9hX2jnpIC6fsSrjtK2JNN3OgTOcHG/upow6YoK0ctme7v98ljJOj3R6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729499345; c=relaxed/simple;
	bh=US5s95+mZFg40G3wU5IsXx1KoH1px4cLPTuuqVkk/Xo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H1aD/YekwkhVnx74uhs7rltTUwhqZoRH/zb3c89HbQ/4BJ3G6gfQwUHN4YnPGChRc2JAogunaQrtekDz+HWEAIrXjD6ZI0yaICmfMRhKAoRGq+/l3nU5gkQLLBNi5DL9KUYapeXMmPOS8icEQ8wccXbHSAdJ3QuXhtbbtS2JcVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NP8oz6GO; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729499343; x=1761035343;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=US5s95+mZFg40G3wU5IsXx1KoH1px4cLPTuuqVkk/Xo=;
  b=NP8oz6GO6WoR5mAdV8FUUN8wYdx3CJ+BYUZMwy39WXKpKkVl3VjbPCDJ
   X75atIJdfrNs5u0p1HOPo64sesR+PG9Xmog4+tz46fo+j9kxCwGa8ZfNN
   78T0+zHQUH2a28pZZr/JNIGohE0jo2jrPkJ0VLIQE0oHkcEhVWztuLXYq
   pbiM0Ny//ebB064rPyxSZaTyCiRpW4O4n/F4KucgG4Dih/rfEG7oxCVjM
   az/v5raWxwbUQUqI6LCl0Jhqo6EEb3w6/QhSCmEtfrTDC7mzUfFC1x4RG
   lvXIETjO+AfkLmeb/dTxCu3EU+INZAV6wMqqQhLoAOCYbETd4C8m1HoMu
   Q==;
X-CSE-ConnectionGUID: WzbV61P0QgWx9A/OT9CrHw==
X-CSE-MsgGUID: ork78PFNS3iKl1cPz5XW6Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11231"; a="46464212"
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="46464212"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 01:29:02 -0700
X-CSE-ConnectionGUID: tWoXVmU/QO+L/BzzOIWzuw==
X-CSE-MsgGUID: uqqnxcJCT0ubHeEbmUUlcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="110297120"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Oct 2024 01:29:01 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 21 Oct 2024 01:29:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 21 Oct 2024 01:29:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 21 Oct 2024 01:29:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=leIWGa7muKknu5UpGI4Ir7gKmcI+a8aIPHLAKUlnft7RsLxix49Ua3ETHBvbR1G6d9AkOP/IvBKVYW0BxBFTKWngnjte4wB1/fYrDWpBFXzlXxfxk+W20IM03EMumyB7bOGygEdkX71cWQQiiaPgoMKS+qBvGRFqjESzLtJa7mKdOMIq6mNdMOJucbYjJtgwqbSQuvkPeYAVNT4K72qL5gwCJK7c2zUs9ElslxUGJp+mYgsZEEsHwTqkbRxJcyT7tafNDu3ZqpynSedU/RApKJdpZ1CDneQq/s4dDvdVXLqFnRvcJ0XEzg8jiLiwI+MeWcXZUo3Cvbw8L/Rju1NKUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FeVazgjiF1WzLC45UlHlgJJH2ibzLoKoY36zPjqEkiQ=;
 b=n2hWrTQ4uGxqfbnFv4qolcB2JhWzz2I7HC3zytszQSf265mpNu+JayDXXOwPaMQGBTBN05e0Q7vEozccDm2nkat99XEFt4nAUPb9XzAN09zz0B4j4SrHr793AZb/ejXtHp82aBk9ONnWP9vzso1kZC9gdPjOg4PqpreuMfiqZEcjp5lI7un+6ZoD7J9SGX1l5h1lIAWf1P489ZzOETPJM+cDOgTKvB/9OEobabKG+Ck2LJDOPDVec9altAwBwOt025oBQ9ZtGWVas0IKjYhCp/kn0aX4xZaA0161XMZxtfVO78bkapPh7DILEgl1gPdaiW1xXOl8mhD6m0WDGj5Q0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5952.namprd11.prod.outlook.com (2603:10b6:510:147::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 08:28:56 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 08:28:56 +0000
Date: Mon, 21 Oct 2024 16:28:46 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 03/27] KVM: VMX: Add support for the secondary VM exit
 controls
Message-ID: <ZxYQvmc9Ke+PYGkQ@intel.com>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-4-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241001050110.3643764-4-xin@zytor.com>
X-ClientProxiedBy: SG2P153CA0047.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::16)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5952:EE_
X-MS-Office365-Filtering-Correlation-Id: d8caa93b-371c-4b0d-666b-08dcf1aa67a3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?AA2kUYzkHRToqbLryg9Sbo6nI5P4XIhfyCdPEv5V9Falv25xartZzDdbSqdy?=
 =?us-ascii?Q?kCe2Isyjk51rePHaDiZASIAhde/V4EBMqR33B1pSbz83S13TPK3xmaSnydqN?=
 =?us-ascii?Q?SLzP63Rr+I25HYlCiFeCiciJFMClam05A+t+wymfXFIuuPQqvHob+aCadOl7?=
 =?us-ascii?Q?Eum73tyNb4TB2CDDxQDe3G1dBrIOCgGChF8c+hBFO5qkbQfjSF7mBujcTRw1?=
 =?us-ascii?Q?6O01GEaSi4MRoC8sqyfTaqgqlKVwSDMvwEZrXB4PC50dGhEyQ1YGUVECO8lv?=
 =?us-ascii?Q?B8DKhOHkj6RFIumLEV8nn8MbIayF1JIczJAWAYLUXez6sxDrqou/u8Ml+CIE?=
 =?us-ascii?Q?NZQ/FiEEGw/S673FJN42MVE+V24n9CBI5IOYIO9XtyXCkS7bR1MVYUr/aR14?=
 =?us-ascii?Q?TpwMXW6Y/NP0RaRNYTBnok/BfYcBLvQy/nMQogpcGtLuEvtpEHi45/fUMvgQ?=
 =?us-ascii?Q?N+k8Kr8zeZITDrpbGKJm/ja7coUmtnEfA81qt7UvVQBg+zFSRjab7uiJPqMr?=
 =?us-ascii?Q?fGFDta50KtiaUa089QxnTIiKeBPM0VXdCINqOgebX5ETGtMRIehBWp9DyTpe?=
 =?us-ascii?Q?vI3lNbIIsGBYtv4rH5KFUJVBj/Js1chJWtdP28OkpLtBPyE0Xg8sBalbVwU4?=
 =?us-ascii?Q?0BtI8kD7uhYAvRa+N7vxroEEq5jVssz2g2sY4JPDmyMJ89Xg05x/p7rcQM6+?=
 =?us-ascii?Q?KFChANlykhlVrmuDanuR0U7cVasBC2+OBKniYm+IdT/COBVuY73eMQ1onrXt?=
 =?us-ascii?Q?T7Ue5hgVoVQY9mocOKNuJl0a7fHJbXlOnn6PdEMKwhTZOo2z/Rb8hl0+F2G+?=
 =?us-ascii?Q?RzjTBtrLUy4RvGBU4ut8w3EU19QsNS8bv2V8WTkUKW9yFprvfj3v2LZtCkJL?=
 =?us-ascii?Q?Sfzhxb1lID44TbxTV6kICJIvqkIjPi5z2KJWn/qz4hMT9WhaEey1vJiNZQQ5?=
 =?us-ascii?Q?woWDCi8wVWZNOOTeaikWSxK6roc7AeFJxyG3xbtXf16iSluMMHOAbkDN8Vuz?=
 =?us-ascii?Q?0He308cRBHqlH024XrQdlAeT63Pmf0Dl+4jLExkqbnxJVDL9L4zD9OGunKSx?=
 =?us-ascii?Q?UPgLauvm6izTIiUSTAvYRVU0Gocq1ClnEQK2UmKRYROMZD8JZfDx0czySbv7?=
 =?us-ascii?Q?vVretVV5n76foQGBFaV5+KiKKf0nOFfVxjq7DXeoWNDyRI+wnp/67Q2hJH1M?=
 =?us-ascii?Q?oY1MHxy0CrHHsdeB58XGuOE2t1cf8SoQpbnQM+mHjkHuQCg2+N/VKKEecwQ5?=
 =?us-ascii?Q?yyYojsyHd29YZji6qw5WmNApdiwvs2qm2x3LYAMYaRrKEdIDIpnjrMfDDsMW?=
 =?us-ascii?Q?MSCzHTwgYS1wsKctEwMVVpy3?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SxrrNZnL6NwKRmysgmarZlkbtZ0Bcz0JbD7qm9SPkOZ8fWWuOMFk6Bk9fS7C?=
 =?us-ascii?Q?aJh585nIaQwwg9DDPGpr5cyYnk7G+BFnVTWvFq6+bxs8v9JelgXvEDMq+1d0?=
 =?us-ascii?Q?yWF7tkBPRs/OpjFyrabAJGvA1d2DDP0NjPpl9PZrO1FEHbhxPLdcuzF5TPS9?=
 =?us-ascii?Q?Va3Se6llqn8e/ks+U95tiP5tbj3DZg6I855boYs/eO+PLa/C5yFJgVna3E0U?=
 =?us-ascii?Q?Q7EeFg/EECxQc4uzvHw+Zcd6+OtTzInU58T655WIJutQ4OcfHnDNk2rbA0UY?=
 =?us-ascii?Q?7Y9xh7GNHvavkjeLOoQTVR5QeYCOA+0PJadUR8Nm+GurXUHj+E13PgXD1lWY?=
 =?us-ascii?Q?3v88HyDbaAAvS2erRGJn7y6+UffG7aZRUtQGCmVkZiuH1HRBopxBMqB05Fds?=
 =?us-ascii?Q?6szwsVWhxa6iSCuXERREMTEQ/rtfKBBqDuZ+r4B8H3w1ToOPS9DEON/7IWnF?=
 =?us-ascii?Q?OEeLR2NEqpDsKD/2wxlj5gIXBLCvJwFNRoR5zxvk9ZUFZu4J3N2hMZnJHsZI?=
 =?us-ascii?Q?DUNRPugV7uQGMkSde+kKiubEex000EY5PMP72bg1dDhoDu3iwt7i5D2IKfV1?=
 =?us-ascii?Q?RiY776+ju2EYkEra5AaTqWRjZBjwuXMgY1mcHQJENoF6GYFknX9/Hq3zlB8F?=
 =?us-ascii?Q?wZ/C0ZHeD4xsIJXDOeqYz79v4sOTwXNA5qt/RMTkRNcRT7MzGDlo0zKQxiTZ?=
 =?us-ascii?Q?DEqFg4UEnLoDmb2veN05oV0Ifp6XQNJkumSXL+9vqRdtTKFcgc2z48Ldc2EM?=
 =?us-ascii?Q?kqX7A11uG/2l6YctF5prpe6zekWvAB6/X5EnrsiHRhYZO4cYJ+42VXbLFg5Z?=
 =?us-ascii?Q?8rrP0U96d+smGxKvu/dTYagfxVda5QOOleNs6oSlZMuFvaSJOZPf1JiXDsXy?=
 =?us-ascii?Q?z+7f4VrKVJuOWKg0aoiBgBIBUUp1IfVz4cWLzvh8iwWKz8EDnvld/IlqR22U?=
 =?us-ascii?Q?u/k0xgehhb4skHk70Me3LXE/ZMjkdKn/7oIX6H+x0vijJbC+FQ199F83wepo?=
 =?us-ascii?Q?R6UUA1lxGcfCgBsRK48RUClWoMS82WE4ImYD1R+V8VgcPxVbXGJ8iWS8awLk?=
 =?us-ascii?Q?RRjaMXmHl/98UwInFwTH3+QHtC3ZEYardLMmC5Tm0WvYH66T5bFdUj1rTyaY?=
 =?us-ascii?Q?9qS21agbsOjl5RQjB7dv/KBt+5mXf0dwMfiuWU8eO6CtAC4x9FHfuLGDRYHs?=
 =?us-ascii?Q?026+SgYAexGuVer6m6MbvY0AJoJkVjsyreSFsz6zBL//z5Bk6PvLIANTOzwv?=
 =?us-ascii?Q?Eo5UjUVCXeYb5vY92f0ubIw2zpnu91Yq8ZL4b8H+BBrW++u7r0jT4mJXybjl?=
 =?us-ascii?Q?uN+bdU+P76+wu9ncVBmN9/t0OjssyscMjLE1/YzdzUP4WIG6AdomNZaGURmq?=
 =?us-ascii?Q?Xoqk0Byc9x1z+dpbv2PuDT2Fw6GLGXwfR+c9pobd3fpN9kYEM2jORPaH7EIZ?=
 =?us-ascii?Q?pdrhqPl+wn2qTSAhUC3wn6C0zOwUR4BbK39ynZuS+flOainJQlMBYIl/XZKw?=
 =?us-ascii?Q?6NQT+13PMsKANh7nMcW7PQTaXALeWNKMnLkXFqi5W40lS8uH5tAbbb3QfnGW?=
 =?us-ascii?Q?sk0QxoKlpp/KknyK1dL3QZ4PRXxQW2zOrA9wA+F4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8caa93b-371c-4b0d-666b-08dcf1aa67a3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 08:28:56.6389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1R1IvGHxlXQAuYb88ROdZG6GfQ9Q6vnNZlxdPWDr1B6yDOTDr0Rs2bac8INLAyCzNDaJoPz0Pgg32UlrcIujXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5952
X-OriginatorOrg: intel.com

>@@ -2713,21 +2715,43 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> 				&_vmentry_control))
> 		return -EIO;
> 
>-	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
>-		u32 n_ctrl = vmcs_entry_exit_pairs[i].entry_control;
>-		u32 x_ctrl = vmcs_entry_exit_pairs[i].exit_control;
>-
>-		if (!(_vmentry_control & n_ctrl) == !(_vmexit_control & x_ctrl))
>+	if (_vmexit_control & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS)
>+		_secondary_vmexit_control =
>+			adjust_vmx_controls64(KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS,
>+					      MSR_IA32_VMX_EXIT_CTLS2);
>+
>+	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_triplets); i++) {
>+		u32 n_ctrl = vmcs_entry_exit_triplets[i].entry_control;
>+		u32 x_ctrl = vmcs_entry_exit_triplets[i].exit_control;
>+		u64 x_ctrl_2 = vmcs_entry_exit_triplets[i].exit_2nd_control;
>+		bool has_n = n_ctrl && ((_vmentry_control & n_ctrl) == n_ctrl);
>+		bool has_x = x_ctrl && ((_vmexit_control & x_ctrl) == x_ctrl);
>+		bool has_x_2 = x_ctrl_2 && ((_secondary_vmexit_control & x_ctrl_2) == x_ctrl_2);
>+
>+		if (x_ctrl_2) {
>+			/* Only activate secondary VM exit control bit should be set */
>+			if ((_vmexit_control & x_ctrl) == VM_EXIT_ACTIVATE_SECONDARY_CONTROLS) {
>+				if (has_n == has_x_2)
>+					continue;
>+			} else {
>+				/* The feature should not be supported in any control */
>+				if (!has_n && !has_x && !has_x_2)
>+					continue;
>+			}
>+		} else if (has_n == has_x) {
> 			continue;
>+		}
> 
>-		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, entry = %x, exit = %x\n",
>-			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl);
>+		pr_warn_once("Inconsistent VM-Entry/VM-Exit triplet, entry = %x, exit = %x, secondary_exit = %llx\n",
>+			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl,
>+			     _secondary_vmexit_control & x_ctrl_2);
> 
> 		if (error_on_inconsistent_vmcs_config)
> 			return -EIO;
> 
> 		_vmentry_control &= ~n_ctrl;
> 		_vmexit_control &= ~x_ctrl;

w/ patch 4, VM_EXIT_ACTIVATE_SECONDARY_CONTROLS is cleared if FRED fails in the
consistent check. this means, all features in the secondary vm-exit controls
are removed. it is overkill.

I prefer to maintain a separate table for the secondary VM-exit controls:

 	struct {
 		u32 entry_control;
 		u64 exit2_control;
	} const vmcs_entry_exit2_pairs[] = {
		{ VM_ENTRY_LOAD_IA32_FRED, SECONDARY_VM_EXIT_SAVE_IA32_FRED |
					   SECONDARY_VM_EXIT_LOAD_IA32_FRED},
	};

	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit2_pairs); i++) {
	...
	}

>+		_secondary_vmexit_control &= ~x_ctrl_2;
> 	}
> 
> 	rdmsrl(MSR_IA32_VMX_BASIC, basic_msr);

