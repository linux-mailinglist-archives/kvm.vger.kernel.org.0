Return-Path: <kvm+bounces-38565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA8FA3BB99
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 11:25:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73AEB164580
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 10:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516D91DE4F0;
	Wed, 19 Feb 2025 10:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T/h7RNvR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B539C2862BD;
	Wed, 19 Feb 2025 10:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739960631; cv=fail; b=bhC/qgnIpahs0rxfIcg3o7qFZuot09CGPI+NZGGEkAUL9pSioDQ9Tg0iL5vFmoVHD14Bpxcw0GO6WHVHcA94EAXxV7TxP6Rlsgwd4NLs/F6TGGjqxNRqZXkj5soJccDFKWmkrkOmkO+zVvssm6GxeCSkcn4xOv5q2sjewiv9Kqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739960631; c=relaxed/simple;
	bh=lg1ASZaFYCZ8yFijc2X7ZrgijBxPVAG8/BTOU2+NXCo=;
	h=Message-ID:Date:Subject:References:From:To:CC:In-Reply-To:
	 Content-Type:MIME-Version; b=jaqxvN+VD7EaRR0GRAj3k2PTHzxJhkivgjxGzA42vshekJAI+Uh7YjOq5SEpoXw7ojzpdRodh7ICbaum353xSOVkq/amH+Uy8P3q4o3IN9nXVydE1x89dsJFSsqWGSNLGv1BpOMZ23AzrLUNUfkHYjHqycgxpFl7F85BI4hJ8G0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T/h7RNvR; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739960628; x=1771496628;
  h=message-id:date:subject:references:from:to:cc:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lg1ASZaFYCZ8yFijc2X7ZrgijBxPVAG8/BTOU2+NXCo=;
  b=T/h7RNvRXg60Scxb284Ngz1fZ5EP5iGkGwmPZuFW/iS5B7JGikW9VlGj
   Z3pTSWW3+u9EQPobkMteA/CSdRwjt/tbX5Xldk9ZyUsboQ0dOsMVRoAjx
   cp3Mp/2TyiF2fi2tChkjvc9Wc8armBvjHDlXZc7VYZPJ+irG+sbKoc4jw
   Ani5LVkbmJn2njf1ySJSAmrjyQdnEThEOmtEkDIyt97V0mUvXGqjlMVvK
   xqXfB1RNrMYllZxYZqRlXyGgzSqnShavjRiNuZ22V2KtwdkS0C5n+a0GW
   cy+N8LFTe68nzPErV4m+gUclAOImndIbWMtHMeUOK5W20LA5wgUURBG16
   g==;
X-CSE-ConnectionGUID: C6+bIeCzR5CUMNHBiLvPwQ==
X-CSE-MsgGUID: +nXPZjPWQvy5VFLPN6kMfw==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="40705478"
X-IronPort-AV: E=Sophos;i="6.13,298,1732608000"; 
   d="scan'208";a="40705478"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 02:23:48 -0800
X-CSE-ConnectionGUID: fYBnJXvhSn6iqT7N/2Y/mA==
X-CSE-MsgGUID: T+evokU6S6K2zw9W3EHIXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="115153640"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 02:23:48 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 19 Feb 2025 02:23:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 19 Feb 2025 02:23:47 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 19 Feb 2025 02:23:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QxFvSc0rV7eq1c+YK8OLQ89967fru8vNwOQVRm+2xhXxdvfzMwL+FvUwgpyHYsLzRLMDzPyeUdUJRenCXdauNfif4+RLkLSYxbzlU0K57hQ4FDTGuFoKAlpw548C6AfI2DnSedz/g9y30YnDySs9Wb6gW4k5FEAJI2KFCBkUJ1gA+LnK2MeMVizxj2slmtXaKXKrUo7Np/w1aSgE0YxCvAappwsKtsTnRI8WPAr8VjKNgJ7xdTBagnGJeXL8A0+9eiMZ/71TsO/bTD6I/g8G1g0HxjMX0Mji/Zm4Dn2KqWvWq+3O1KcSsh7Te6J4kNlxnZ6BjGkAdKxPaomrOjuX9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZfolvwJK+hR9MTkJi4sl30H67Svd/j/HDT6ndoEatA=;
 b=OJ3yC5UKrBvvkjzPCsyzYx35+Vl000dfG4MbvOaR2FLj+h7NrUq+lVgYmruk9CykX8tvF1cHmNzWY1jwiMeguHbiG9++LL2AT5UDwXVAE98OFP3NPMH1X1qYuKTqwFTq+4FgEOrtT51I0V0V/fD3NP5xLtbXLdZ4rVEtNshE2lwuBJ2lvO1LlDxeagQAi7it8JpAhrFbqXDNa5wsuCiI6TeTnvLzRUswEWMwA1nTiOMYawzKbTnk8M7zaCW7TW2OGkqCfkMSuJ07QZtTYVshfVXmnx11iaKwQhTT2KF3wstOWgCelerKXCewp15bTLsi7tXiOcu3c5lUqkNchrhHJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL3PR11MB6315.namprd11.prod.outlook.com (2603:10b6:208:3b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 10:23:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 10:23:31 +0000
Message-ID: <9cdf63d6-6e8d-4f68-a4be-c16ca4c22426@intel.com>
Date: Wed, 19 Feb 2025 23:23:17 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/18] Documentation/virt/kvm: Document on Trust Domain
 Extensions(TDX)
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
 <20241210004946.3718496-19-binbin.wu@linux.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <kvm@vger.kernel.org>
CC: <rick.p.edgecombe@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <isaku.yamahata@intel.com>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20241210004946.3718496-19-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0149.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::29) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|BL3PR11MB6315:EE_
X-MS-Office365-Filtering-Correlation-Id: abc9afff-3324-48ee-c777-08dd50cf7540
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eEhNaXVxU1N5bHUvWVFBTFcwemxjc0xXdi9qeEx6T0lkYzdHZlVLQ1dFYWJD?=
 =?utf-8?B?RDlkbi93UmFBV2dtbXNqY25FNWVPU0RVNEtUNnZDMVRHSS9GV3RUeWhBVG1G?=
 =?utf-8?B?eXdjRTc4WEtTVFVRWUpiOHJVU01HYWFZeURaSmZUNEtKQUhsK3BTV1IwSlRo?=
 =?utf-8?B?RlRnQy9leDJJZ3NaR2VPTVhLSnljd01HRUFLSVQ0Tm05clJQNjZDaWtGNFNk?=
 =?utf-8?B?Ulo0VlNHVzIyOW9LMHdVSlpEd012SmthK2syZTZFQ2xHNTRBeUNKZTArWjVE?=
 =?utf-8?B?dHpWZnNJQmRkeVcrbGxQcFlHcjRySDk2bEhiTjdzMURjZ1plMHVnN2x5M3Jq?=
 =?utf-8?B?TThMMjJoU3JBZHNWNGhKeWgwbmF1Qy9EUHpyY0sxRkUzdVd1VXFqSzJBYnkw?=
 =?utf-8?B?ZjA3a2tKOXBMVlFTNTE1enNnTTIxOE5tVFhTeHJiUEh4N1l0ODlubFZDODk0?=
 =?utf-8?B?U1BueEtwUGRLLytSQW85VG9qNlhVY0tKMmpOS2d6MFlsdk1leFBpenBvNlRT?=
 =?utf-8?B?M0gxM2RTWlFxc2RnQkwxc3h6aUVIbmsxSEZLYWlieVVnZUdjUldTa2lUa3RD?=
 =?utf-8?B?bHhZeWhXd1NTN3FKRzFvcGRPL1lLTjNRRHpCWUFJNFp6R01KSUVnQ1BMTXhC?=
 =?utf-8?B?em1id1E3aTAzM1d0MVFJWjlkV0k0bHFpQTBhNDBuYVVObkFZODltQTIrcFF3?=
 =?utf-8?B?bHV0aFNhYno4aHhxUjJOUmRjM3VxbGFhcXlwZzd1SFMzUlpVOEs0OGdpZTY3?=
 =?utf-8?B?YlU4Q29CM3Y5NldIVEtPa2RNcjkzQXMvMDJMdnNYQmVHbFo1a0N2SWlERDdN?=
 =?utf-8?B?N3g5YUl2ZDVFaG9PeTY0VE1ZYUJQcjhpTEM0a2pMKzVPUW5WQ1BFdWxtbUls?=
 =?utf-8?B?eEJPaGlYUy9QTkY1WlFKaTZxckNGdXJiTUtDM055SGdtNVNuTkNjZmdjMWYy?=
 =?utf-8?B?STErdno4V291Y3o2cG1RRXhCNGlIYnF2bWFIV21BSEx6bjZJVVlhTnpwbXdj?=
 =?utf-8?B?QlRaaVhoblZ2Y1A3NnpZU0wzY0RjVE1OS0dqUUtCNHZZK3BSUytYU0FpS0xN?=
 =?utf-8?B?NGZVd3lkL2p6cXBjcTVOZnVjQ0lsNVB0RXlMWVF4SXpaVmNuM3hmejM4cHYr?=
 =?utf-8?B?Q3Jhd01TaG1ZUnBuN0UzaGlZVVBJSHd3N0VnZGlQUXU2cmx1TE94czBFUHg1?=
 =?utf-8?B?Rkg3a2U2cnVEZGFuOHFOcmdsMmNNd1JhYkorNnE1WUcxNWZoRDIwMnQ4NkxC?=
 =?utf-8?B?OGtzbFpXb1Bmei9ZOFVpM2JqNkFBNlZrTlUzUWYxS2I3TVBBVWZ2dHhNbGpj?=
 =?utf-8?B?eHBPZGVyMW1MZE9RWUs2bFMwRHM1UlQ4RFlnMldQaDExUTRjdUNqT2JIK1o5?=
 =?utf-8?B?cGhTSnBjdHBHQjgyYnZwU0k0RzcxNUdCSGs2MDU1bUhUelBBZ1h4UE9tQjNH?=
 =?utf-8?B?dzRZRDl1Zk9hYTRlQzJvK0lxQVVDK0xSMzIwd0tlV1J4b3MzZm8reThjWVlB?=
 =?utf-8?B?V0F2MEFSSDc3cS9UTzhOZzdzbFl5eGE1M0sxT3RmazdqczNvYjl6aUxOTGpu?=
 =?utf-8?B?WHNTcGRZb2VtTmVuM3ZaYXlrNDV0S2JSdTkrWHFtNjdKYWFaTmdxNjJSeHVW?=
 =?utf-8?B?ZjVqUnFKcEsyRlhsOFA1VjduK09JSVVtWUtJUTdDdG9iK2twcWZQUmVkNjRp?=
 =?utf-8?B?d2gwa3VBbG12THRZUHhOMDVDdlVlRjdCWjZobjZnTVlNRCtJK29wTXVTaHdu?=
 =?utf-8?B?RmI1dG5haWJmai9qUUd5TzF0Wm9vOGMyREd0a09aMUVrQmw3VEEzd2laRzBj?=
 =?utf-8?B?YWR6VFVaK0FaS0ZQWkxudz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHF3aHdoZGZQanFwMTVEWjJBZmpDRVVtdlBkSW1ETGVLS0luZXFYdlowbHky?=
 =?utf-8?B?eFhWUjFKM1ZrQUNwZ09qMVlUbU1RY1N3ekRsRm1zRkk1dzZQdkZxeTY1MEwr?=
 =?utf-8?B?UjhYUDNMYlRMTVFldUV1RGN3aEVkdDI5N09KRzl5YmEvSWQ4a1ZDTjcvWm9k?=
 =?utf-8?B?eDdPQVVwdG1FemtCKzY2NC9xRmxwWnErd1l4SGdXTTIreE9iVEtFTkErNnJ6?=
 =?utf-8?B?WW9Mc2xTcHVOcGNFZmk1djkxTkthS0FzcWpzMjlGUTV0UjJzMEVhSTFSeUp6?=
 =?utf-8?B?NDJlSHhtTk1Zam9ubGZVWDVnS3l0cUEvK1lXZUhqMGZUTUc2TUtmMTRTb25G?=
 =?utf-8?B?TTNENkJyWDJORnJJcm5sVGZGNkNZOGxFUkozMWJCcmsvdUlLTDJSOEpYZms5?=
 =?utf-8?B?NEQvVDRQQnVlWVdoQ0tONEo0OTBnVWMrOFJvR25VM3RnRXMxUkNCdHBzdHRM?=
 =?utf-8?B?RHQxRlgxUUdsRGFhNmE3elpxdmk3cThySTFoVklibEU1THhKMkY3TkNKRExx?=
 =?utf-8?B?S0hEdFBGRmlmMzIwenNQcG9aejRBc2JtTG44SS96OCtHcExVZG5kaVNna1ps?=
 =?utf-8?B?aEVwSUphUGtYMjdiZzU2UTdzdGpramFHcnBEd014VDdTaFphdWd0U2NzazIr?=
 =?utf-8?B?QUJpR3AxdjByaUdrSmR1SXgrNmdLVTgzQUc0dkQvMzJDcDRNMmxHWXpzaDNh?=
 =?utf-8?B?RWVxYmtyRUQ5bHZBaytOS0EvRE40QUNtMnFpbFVjR2l6T2JELzlGTXFjbWg1?=
 =?utf-8?B?ZjB6cHNQemUxaGU2SFljU1BoY2t1Z2dzUm5VRjBDR2x5c3c3NjNiWktIVjNO?=
 =?utf-8?B?Sk5Jb1NZMnFJNXBnK3c5M0RaTXVhTStWc0I2ZXBDQ0xZUUhzVzhFSk9vaTZI?=
 =?utf-8?B?RSsyTWpLdnVkY3A2WFZnczhmVS9vQ3dFdml5NFEwTS9NeGhhclZFZFdBaDZH?=
 =?utf-8?B?d3I0YVhGdy94UllBLzh1UW02Yzd6MFNTZVlKeFcwcUlKNDdUVE9BQ25DbXBz?=
 =?utf-8?B?NXh5TmJEcEQyMzZIZGprTEFVaGtYS1hQVEJhMEFRMHZxbUVVajd5NnFsWWdL?=
 =?utf-8?B?cmZhcERWTFN3MEhyRkVTalMyUkpmRGxscDM2alRndU1lWmRsRUVKdnpRTVRk?=
 =?utf-8?B?a0ZxQS9uajhqZXg5Nk9pVitnZmIvV0RQQXY0Sm9zNlpqWENEY1YvRk93bHJ1?=
 =?utf-8?B?em9wbVJKankveUI0OTlSUk9DM3loR1d1bXV4ZGlSdDgzTWRRaUwyamVxdDdr?=
 =?utf-8?B?OGpYNzRnRm9Qb0M4Q2FxWWFuNHRESzc1TzZJRkFNN1R3SU5vOUJkQThJZUlo?=
 =?utf-8?B?QTBScERJWjhMY1hMeDFndnU5RU9uYktjb05KK1A0SlVlQ08zL1htU3VYT2Rh?=
 =?utf-8?B?ald5c3hNaDBsVU5rU0ZUL0NmTHJFcUdDMWFuaU1ORDY2dDJLRW9TYXRFM1BX?=
 =?utf-8?B?aEFUelhFK2ZmSWhjMjJ3bUpKVUdLM2J5ZFZnMEN0eTlaUmZFYi82RDZWdVV2?=
 =?utf-8?B?eDdZdk9ZODRQNFYxNE4xL2NNTktZNlEvK3dBMGh0ME4vcHJzTHRUYmNTeTAx?=
 =?utf-8?B?TDQ4eXkyWlRwU3hCNis3RVptK2RReWJrU2NDbmJQaitVeWM0N0dUeUxhelZ6?=
 =?utf-8?B?OWJ5SnhydjJkNFk0eUp0cmkrN2ttSlYreThoampSVTlLbHBjTnRNcmFEY1Zn?=
 =?utf-8?B?WTErRG5uK1VxTzNzdG9CMkthRmp4ZEpBKzcwZUljbnM0aDNscW52UnRUNml5?=
 =?utf-8?B?WUNsSnFHejZySUdjM0Rxc29kYmZDNlBIMnhOSldzZnlJZ0lvL296MllHR0dK?=
 =?utf-8?B?M2RKRTF5dHl6VVVvUGhUK1hhTXdFOU90bnk1VFRMRzg3bjdnWU05TklncWQ4?=
 =?utf-8?B?emtmTWR1M2dZd05LNlhUMm5MbWtGNFVvSTlMUGR6S0FVL0Z4QXNQUlkzVUJi?=
 =?utf-8?B?b3VpRVBjMk9YR0VEQkE4bXRBL0Fkc01Id2poek90bmhtUzl1TFlQSUdXTWlJ?=
 =?utf-8?B?K1cwK08zck5WZGVwOWNyWGc0VG1NT2JETndhMENpbUVIZWRPOXBPNHBJRks1?=
 =?utf-8?B?cDRiMjRZTmRrZjNjNFlpRzRvVDZUUTFFUVFJZUlaS2Q5a3lMcXFOcWVyMEtS?=
 =?utf-8?Q?MA2MlPGtjFyuOJdOGLhyqmssV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: abc9afff-3324-48ee-c777-08dd50cf7540
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 10:23:31.5591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1puyRHgUgRGS4cKpAmR/0+Sr8FExJoSdEtPwo+jWq9IKZX3QxjJ5x6YZq0yIU/6KJl+BL15X1P28xIhzLAZbgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6315
X-OriginatorOrg: intel.com



On 10/12/2024 1:49 pm, Binbin Wu wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add documentation to Intel Trusted Domain Extensions(TDX) support.

Add a whitespace before (TDX).

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> TDX "the rest" breakout:
> - Updates to match code changes (Tony)
> ---
>   Documentation/virt/kvm/api.rst           |   9 +-
>   Documentation/virt/kvm/x86/index.rst     |   1 +
>   Documentation/virt/kvm/x86/intel-tdx.rst | 357 +++++++++++++++++++++++
>   3 files changed, 366 insertions(+), 1 deletion(-)
>   create mode 100644 Documentation/virt/kvm/x86/intel-tdx.rst
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index bb39da72c647..c5da37565e1e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1394,6 +1394,9 @@ the memory region are automatically reflected into the guest.  For example, an
>   mmap() that affects the region will be made visible immediately.  Another
>   example is madvise(MADV_DROP).
>   
> +For TDX guest, deleting/moving memory region loses guest memory contents.
> +Read only region isn't supported.  Only as-id 0 is supported.
> +
>   Note: On arm64, a write generated by the page-table walker (to update
>   the Access and Dirty flags, for example) never results in a
>   KVM_EXIT_MMIO exit when the slot has the KVM_MEM_READONLY flag. This
> @@ -4758,7 +4761,7 @@ H_GET_CPU_CHARACTERISTICS hypercall.
>   
>   :Capability: basic
>   :Architectures: x86
> -:Type: vm
> +:Type: vm ioctl, vcpu ioctl
>   :Parameters: an opaque platform specific structure (in/out)
>   :Returns: 0 on success; -1 on error
>   
> @@ -4770,6 +4773,10 @@ Currently, this ioctl is used for issuing Secure Encrypted Virtualization
>   (SEV) commands on AMD Processors. The SEV commands are defined in
>   Documentation/virt/kvm/x86/amd-memory-encryption.rst.
>   
> +Currently, this ioctl is used for issuing Trusted Domain Extensions
> +(TDX) commands on Intel Processors. The TDX commands are defined in
> +Documentation/virt/kvm/x86/intel-tdx.rst.
> +

This paragraph duplicates the SEV paragraph right above.  I would 
consolidate them together as:

Currently, this ioctl is used for issuing both Secure Encrypted 
Virtualization (SEV) commands on AMD platforms and Trusted Domain 
Extensions (TDX) commands on Intel Processors.  The detailed commands 
are defined in Documentation/virt/kvm/x86/amd-memory-encryption.rst and 
Documentation/virt/kvm/x86/intel-tdx.rst repectively.

>   4.111 KVM_MEMORY_ENCRYPT_REG_REGION
>   -----------------------------------
>   
> diff --git a/Documentation/virt/kvm/x86/index.rst b/Documentation/virt/kvm/x86/index.rst
> index 9ece6b8dc817..851e99174762 100644
> --- a/Documentation/virt/kvm/x86/index.rst
> +++ b/Documentation/virt/kvm/x86/index.rst
> @@ -11,6 +11,7 @@ KVM for x86 systems
>      cpuid
>      errata
>      hypercalls
> +   intel-tdx
>      mmu
>      msr
>      nested-vmx
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> new file mode 100644
> index 000000000000..12531c4c09e1
> --- /dev/null
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -0,0 +1,357 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +===================================
> +Intel Trust Domain Extensions (TDX)
> +===================================
> +
> +Overview
> +========
> +TDX stands for Trust Domain Extensions which isolates VMs from
> +the virtual-machine manager (VMM)/hypervisor and any other software on
> +the platform. For details, see the specifications [1]_, whitepaper [2]_,
> +architectural extensions specification [3]_, module documentation [4]_,
> +loader interface specification [5]_, guest-hypervisor communication
> +interface [6]_, virtual firmware design guide [7]_, and other resources
> +([8]_, [9]_, [10]_, [11]_, and [12]_).

Some links (e.g., 4) is not accessible anymore.

I didn't check all links, but I don't think it's necessary to put links 
of all specs here.  We can have a link which contains all the specs 
(assuming this link doesn't change at least for quite long time).

And there's already an Documentation/arch/x86/tdx.rst which describes 
TDX support in the host core-kernel and the guest.  We can mention it 
here.  And it also has some introduction sentences that we can borrow here.

So how bout:

Overview
========

Intel's Trust Domain Extensions (TDX) protect confidential guest VMs 
from the host and physical attacks.  A CPU-attested software module 
called 'the TDX module' runs inside a new CPU isolated range to provide 
the functionalities to manage and run protected VMs, a.k.a, TDX guests 
or TDs.

Please refer to [1] for the whitepaper, specifications and other resources.

This documentation describes TDX-specific KVM ABIs.  The TDX module 
needs to be initialized before it can be used by KVM to run any TDX 
guests.  The host core-kernel provides the support of initializing the 
TDX module, which is described in the Documentation/arch/x86/tdx.rst.

......

[1]: 
https://www.intel.com/content/www/us/en/developer/tools/trust-domain-extensions/documentation.html

> +
> +
> +API description
> +===============
> +
> +KVM_MEMORY_ENCRYPT_OP
> +---------------------
> +:Type: vm ioctl, vcpu ioctl
> +
> +For TDX operations, KVM_MEMORY_ENCRYPT_OP is re-purposed to be generic
> +ioctl with TDX specific sub ioctl command.

command -> commands.

> +
> +::
> +
> +  /* Trust Domain eXtension sub-ioctl() commands. */

I think "Extensions" is used in every place in the kernel, so 
"eXtension" -> "Extensions".

And lack of consistency between "sub ioctl commands" and "sub-ioctl() 
commands".  Perhaps just use "sub-commands" for all the places.

> +  enum kvm_tdx_cmd_id {
> +          KVM_TDX_CAPABILITIES = 0,
> +          KVM_TDX_INIT_VM,
> +          KVM_TDX_INIT_VCPU,
> +          KVM_TDX_INIT_MEM_REGION,
> +          KVM_TDX_FINALIZE_VM,
> +          KVM_TDX_GET_CPUID,
> +
> +          KVM_TDX_CMD_NR_MAX,
> +  };
> +
> +  struct kvm_tdx_cmd {
> +        /* enum kvm_tdx_cmd_id */
> +        __u32 id;
> +        /* flags for sub-commend. If sub-command doesn't use this, set zero. */

commend -> command.

> +        __u32 flags;
> +        /*
> +         * data for each sub-command. An immediate or a pointer to the actual
> +         * data in process virtual address.  If sub-command doesn't use it,
> +         * set zero.
> +         */
> +        __u64 data;
> +        /*
> +         * Auxiliary error code.  The sub-command may return TDX SEAMCALL
> +         * status code in addition to -Exxx.
> +         * Defined for consistency with struct kvm_sev_cmd.
> +         */

"Defined for consistency with struct kvm_sev_cmd" got removed in the 
code.  It should be removed here too.

> +        __u64 hw_error;
> +  };
> +
> +KVM_TDX_CAPABILITIES
> +--------------------
> +:Type: vm ioctl
> +
> +Subset of TDSYSINFO_STRUCT retrieved by TDH.SYS.INFO TDX SEAM call will be
> +returned. It describes the Intel TDX module.

We are not using TDH.SYS.INFO and TDSYSINFO_STRUCT anymore.  Perhaps:

	Retrive TDX moduel global capabilities for running TDX guests.

> +
> +- id: KVM_TDX_CAPABILITIES
> +- flags: must be 0
> +- data: pointer to struct kvm_tdx_capabilities
> +- error: must be 0
> +- unused: must be 0

@error should be @hw_error.

And I don't see @unused anyware in the 'struct kvm_tdx_cmd'.  Should be 
removed.

The same to all below sub-commands.

> +
> +::
> +
> +  struct kvm_tdx_capabilities {
> +        __u64 supported_attrs;
> +        __u64 supported_xfam;
> +        __u64 reserved[254];
> +        struct kvm_cpuid2 cpuid;
> +  };
> +
> +
> +KVM_TDX_INIT_VM
> +---------------
> +:Type: vm ioctl

I would add description for return values:

	:Returns: 0 on success, <0 on error.

We can also repeat this in all sub-commands, but I am not sure it's 
necessary.

> +
> +Does additional VM initialization specific to TDX which corresponds to
> +TDH.MNG.INIT TDX SEAM call.

"SEAM call" -> "SEAMCALL" for consistency.  And the same to below all 
sub-commands.

Nit:

I am not sure whether we need to, or should, mention the detailed 
SEAMCALL here.  To me the ABI doesn't need to document the detailed 
implementation (i.e., which SEAMCALL is used) in the underneath kernel.

> +
> +- id: KVM_TDX_INIT_VM
> +- flags: must be 0
> +- data: pointer to struct kvm_tdx_init_vm
> +- error: must be 0
> +- unused: must be 0
> +
> +::
> +
> +  struct kvm_tdx_init_vm {
> +          __u64 attributes;
> +          __u64 xfam;
> +          __u64 mrconfigid[6];          /* sha384 digest */
> +          __u64 mrowner[6];             /* sha384 digest */
> +          __u64 mrownerconfig[6];       /* sha384 digest */
> +
> +          /* The total space for TD_PARAMS before the CPUIDs is 256 bytes */
> +          __u64 reserved[12];
> +
> +        /*
> +         * Call KVM_TDX_INIT_VM before vcpu creation, thus before
> +         * KVM_SET_CPUID2.
> +         * This configuration supersedes KVM_SET_CPUID2s for VCPUs because the
> +         * TDX module directly virtualizes those CPUIDs without VMM.  The user
> +         * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with
> +         * those values.  If it doesn't, KVM may have wrong idea of vCPUIDs of
> +         * the guest, and KVM may wrongly emulate CPUIDs or MSRs that the TDX
> +         * module doesn't virtualize.
> +         */
> +          struct kvm_cpuid2 cpuid;
> +  };
> +
> +
> +KVM_TDX_INIT_VCPU
> +-----------------
> +:Type: vcpu ioctl
> +
> +Does additional VCPU initialization specific to TDX which corresponds to
> +TDH.VP.INIT TDX SEAM call.
> +
> +- id: KVM_TDX_INIT_VCPU
> +- flags: must be 0
> +- data: initial value of the guest TD VCPU RCX
> +- error: must be 0
> +- unused: must be 0
> +
> +KVM_TDX_INIT_MEM_REGION
> +-----------------------
> +:Type: vcpu ioctl
> +
> +Encrypt a memory continuous region which corresponding to TDH.MEM.PAGE.ADD
> +TDX SEAM call.

"a contiguous guest memory region"?

And "which corresponding to .." has grammar issue.

How about:

	Load and encrypt a contiguous memory region from the source
	memory which corresponds to the TDH.MEM.PAGE.ADD TDX SEAMCALL.

> +If KVM_TDX_MEASURE_MEMORY_REGION flag is specified, it also extends measurement
> +which corresponds to TDH.MR.EXTEND TDX SEAM call.
> +
> +- id: KVM_TDX_INIT_MEM_REGION
> +- flags: flags
> +            currently only KVM_TDX_MEASURE_MEMORY_REGION is defined
> +- data: pointer to struct kvm_tdx_init_mem_region
> +- error: must be 0
> +- unused: must be 0
> +
> +::
> +
> +  #define KVM_TDX_MEASURE_MEMORY_REGION   (1UL << 0)
> +
> +  struct kvm_tdx_init_mem_region {
> +          __u64 source_addr;
> +          __u64 gpa;
> +          __u64 nr_pages;
> +  };
> +
> +
> +KVM_TDX_FINALIZE_VM
> +-------------------
> +:Type: vm ioctl
> +
> +Complete measurement of the initial TD contents and mark it ready to run
> +which corresponds to TDH.MR.FINALIZE

Missing period at the end of the sentence.

And nit again: I don't like the "which corresponds to TDH.MR.FINALIZE".

> +
> +- id: KVM_TDX_FINALIZE_VM
> +- flags: must be 0
> +- data: must be 0
> +- error: must be 0
> +- unused: must be 0


This patch doesn't contain KVM_TDX_GET_CPUID.  I saw in internal dev 
branch we have it.


> +
> +KVM TDX creation flow
> +=====================
> +In addition to KVM normal flow, new TDX ioctls need to be called.  The control flow
> +looks like as follows.
> +
> +#. system wide capability check

To make all consistent:

Check system wide capability

> +
> +   * KVM_CAP_VM_TYPES: check if VM type is supported and if KVM_X86_TDX_VM
> +     is supported.
> +
> +#. creating VM

Create VM
> +
> +   * KVM_CREATE_VM
> +   * KVM_TDX_CAPABILITIES: query if TDX is supported on the platform.

"TDX is supported or not" is already checked in step 1.

I think we should say:

query TDX global capabilities for creating TDX guests.

> +   * KVM_ENABLE_CAP_VM(KVM_CAP_MAX_VCPUS): set max_vcpus. KVM_MAX_VCPUS by
> +     default.  KVM_MAX_VCPUS is not a part of ABI, but kernel internal constant
> +     that is subject to change.  Because max vcpus is a part of attestation, max
> +     vcpus should be explicitly set.

This is out-of-date.

       * KVM_CHECK_EXTENSION(KVM_CAP_MAX_VCPUS): query maximum vcpus the
	TDX guest can support (TDX has its own limitation on this).

> +   * KVM_SET_TSC_KHZ for vm. optional

For consistency:

       * KVM_SET_TSC_KHZ: optional

> +   * KVM_TDX_INIT_VM: pass TDX specific VM parameters.
> +
> +#. creating VCPU

Create vCPUs

> +
> +   * KVM_CREATE_VCPU
> +   * KVM_TDX_INIT_VCPU: pass TDX specific VCPU parameters.
> +   * KVM_SET_CPUID2: Enable CPUID[0x1].ECX.X2APIC(bit 21)=1 so that the following
> +     setting of MSR_IA32_APIC_BASE success. Without this,
> +     KVM_SET_MSRS(MSR_IA32_APIC_BASE) fails.

I would prefer to put X2APIC specific to a note:

       * KVM_SET_CPUID2: configure guest's CPUIDs.  Note: Enable ...

> +   * KVM_SET_MSRS: Set the initial reset value of MSR_IA32_APIC_BASE to
> +     APIC_DEFAULT_ADDRESS(0xfee00000) | XAPIC_ENABLE(bit 10) |
> +     X2APIC_ENABLE(bit 11) [| MSR_IA32_APICBASE_BSP(bit 8) optional]

Ditto, I believe there are other MSRs to be set too.

> +
> +#. initializing guest memory

Initialize initial guest memory

> +
> +   * allocate guest memory and initialize page same to normal KVM case

Cannot parse this.

> +     In TDX case, parse and load TDVF into guest memory in addition.

Don't understand "parse TDVF" either.

> +   * KVM_TDX_INIT_MEM_REGION to add and measure guest pages.
> +     If the pages has contents above, those pages need to be added.
> +     Otherwise the contents will be lost and guest sees zero pages.
> +   * KVM_TDX_FINALIAZE_VM: Finalize VM and measurement
> +     This must be after KVM_TDX_INIT_MEM_REGION.

Perhaps refine the above to:


       * Allocate guest memory in the same way as allocating memory for
	normal VMs.
       * KVM_TDX_INIT_MEM_REGION to add initial guest memory.  Note for
	now TDX guests only works with TDVF, thus the TDVF needs to be
	included in the initial guest memory.
       * KVM_TDX_FINALIZE_VM: Finalize the measurement of the TDX guest.

> +
> +#. run vcpu

Run vCPUs

> +
> +Design discussion
> +=================

"discussion" won't be appropriate after merge.  Let's just use "Design 
details".

> +
> +Coexistence of normal(VMX) VM and TD VM

normal (VMX) VM

> +---------------------------------------
> +It's required to allow both legacy(normal VMX) VMs and new TD VMs to
> +coexist. Otherwise the benefits of VM flexibility would be eliminated.
> +The main issue for it is that the logic of kvm_x86_ops callbacks for
> +TDX is different from VMX. On the other hand, the variable,
> +kvm_x86_ops, is global single variable. Not per-VM, not per-vcpu.
> +
> +Several points to be considered:
> +
> +  * No or minimal overhead when TDX is disabled(CONFIG_INTEL_TDX_HOST=n).
> +  * Avoid overhead of indirect call via function pointers.
> +  * Contain the changes under arch/x86/kvm/vmx directory and share logic
> +    with VMX for maintenance.
> +    Even though the ways to operation on VM (VMX instruction vs TDX
> +    SEAM call) are different, the basic idea remains the same. So, many
> +    logic can be shared.
> +  * Future maintenance
> +    The huge change of kvm_x86_ops in (near) future isn't expected.
> +    a centralized file is acceptable.
> +
> +- Wrapping kvm x86_ops: The current choice
> +
> +  Introduce dedicated file for arch/x86/kvm/vmx/main.c (the name,
> +  main.c, is just chosen to show main entry points for callbacks.) and
> +  wrapper functions around all the callbacks with
> +  "if (is-tdx) tdx-callback() else vmx-callback()".
> +
> +  Pros:
> +
> +  - No major change in common x86 KVM code. The change is (mostly)
> +    contained under arch/x86/kvm/vmx/.
> +  - When TDX is disabled(CONFIG_INTEL_TDX_HOST=n), the overhead is
> +    optimized out.
> +  - Micro optimization by avoiding function pointer.
> +
> +  Cons:
> +
> +  - Many boiler plates in arch/x86/kvm/vmx/main.c.
> +
> +KVM MMU Changes
> +---------------
> +KVM MMU needs to be enhanced to handle Secure/Shared-EPT. The
> +high-level execution flow is mostly same to normal EPT case.
> +EPT violation/misconfiguration -> invoke TDP fault handler ->
> +resolve TDP fault -> resume execution. (or emulate MMIO)
> +The difference is, that S-EPT is operated(read/write) via TDX SEAM
> +call which is expensive instead of direct read/write EPT entry.
> +One bit of GPA (51 or 47 bit) is repurposed so that it means shared
> +with host(if set to 1) or private to TD(if cleared to 0).
> +
> +- The current implementation
> +
> +  * Reuse the existing MMU code with minimal update.  Because the
> +    execution flow is mostly same. But additional operation, TDX call
> +    for S-EPT, is needed. So add hooks for it to kvm_x86_ops.
> +  * For performance, minimize TDX SEAM call to operate on S-EPT. When
> +    getting corresponding S-EPT pages/entry from faulting GPA, don't
> +    use TDX SEAM call to read S-EPT entry. Instead create shadow copy
> +    in host memory.
> +    Repurpose the existing kvm_mmu_page as shadow copy of S-EPT and
> +    associate S-EPT to it.
> +  * Treats share bit as attributes. mask/unmask the bit where
> +    necessary to keep the existing traversing code works.
> +    Introduce kvm.arch.gfn_shared_mask and use "if (gfn_share_mask)"
> +    for special case.
> +
> +    * 0 : for non-TDX case
> +    * 51 or 47 bit set for TDX case.
> +
> +  Pros:
> +
> +  - Large code reuse with minimal new hooks.
> +  - Execution path is same.
> +
> +  Cons:
> +
> +  - Complicates the existing code.
> +  - Repurpose kvm_mmu_page as shadow of Secure-EPT can be confusing.
> +
> +New KVM API, ioctl (sub)command, to manage TD VMs
> +-------------------------------------------------
> +Additional KVM APIs are needed to control TD VMs. The operations on TD
> +VMs are specific to TDX.
> +
> +- Piggyback and repurpose KVM_MEMORY_ENCRYPT_OP
> +
> +  Although operations for TD VMs aren't necessarily related to memory
> +  encryption, define sub operations of KVM_MEMORY_ENCRYPT_OP for TDX specific
> +  ioctls.
> +
> +  Pros:
> +
> +  - No major change in common x86 KVM code.
> +  - Follows the SEV case.
> +
> +  Cons:
> +
> +  - The sub operations of KVM_MEMORY_ENCRYPT_OP aren't necessarily memory
> +    encryption, but operations on TD VMs.

I vote to get rid of the above "design discussion" completely.

amd-memory-encryption.rst doesn't seem to have such details.

> +
> +References
> +==========
> +
> +.. [1] TDX specification
> +   https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html
> +.. [2] Intel Trust Domain Extensions (Intel TDX)
> +   https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-whitepaper-final9-17.pdf
> +.. [3] Intel CPU Architectural Extensions Specification
> +   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-cpu-architectural-specification.pdf
> +.. [4] Intel TDX Module 1.0 EAS
> +   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-module-1eas.pdf
> +.. [5] Intel TDX Loader Interface Specification
> +   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-seamldr-interface-specification.pdf
> +.. [6] Intel TDX Guest-Hypervisor Communication Interface
> +   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-guest-hypervisor-communication-interface.pdf
> +.. [7] Intel TDX Virtual Firmware Design Guide
> +   https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.

As said above, I think we can just provide a link which contains all -- 
whitepaper, specs, and other things like source code.

> +.. [8] intel public github
> +
> +   * kvm TDX branch: https://github.com/intel/tdx/tree/kvm
> +   * TDX guest branch: https://github.com/intel/tdx/tree/guest

I don't think this should be included.

> +
> +.. [9] tdvf
> +    https://github.com/tianocore/edk2-staging/tree/TDVF
> +.. [10] KVM forum 2020: Intel Virtualization Technology Extensions to
> +     Enable Hardware Isolated VMs
> +     https://osseu2020.sched.com/event/eDzm/intel-virtualization-technology-extensions-to-enable-hardware-isolated-vms-sean-christopherson-intel
> +.. [11] Linux Security Summit EU 2020:
> +     Architectural Extensions for Hardware Virtual Machine Isolation
> +     to Advance Confidential Computing in Public Clouds - Ravi Sahita
> +     & Jun Nakajima, Intel Corporation
> +     https://osseu2020.sched.com/event/eDOx/architectural-extensions-for-hardware-virtual-machine-isolation-to-advance-confidential-computing-in-public-clouds-ravi-sahita-jun-nakajima-intel-corporation

[...]

> +.. [12] [RFCv2,00/16] KVM protected memory extension
> +     https://lore.kernel.org/all/20201020061859.18385-1-kirill.shutemov@linux.intel.com/

Why putting this RFC here.


