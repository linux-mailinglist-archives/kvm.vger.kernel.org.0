Return-Path: <kvm+bounces-58184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C207B8B135
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:26:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB25D1BC77E4
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643962BE62B;
	Fri, 19 Sep 2025 19:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CYdJu2rC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61AC270553;
	Fri, 19 Sep 2025 19:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758309986; cv=fail; b=ZEpUF+N03TmpzN6mNikz/eznVPAo1xwvHaBuZJ/ctgV0duaTWzyfpevuBq1WB/YgYPKmG1/euhJ0kYcpOvxxY+wy5pQWLSR0rPhGPXJS/Kqaiha7+MlhEg2clrMDKKpFuNXqOGosfsHa1mUDcR3ha9u+RorkokpZeNM5mlB0adg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758309986; c=relaxed/simple;
	bh=iqimgm2wv78LE+r5tZCy/L9KYj/eVjiPPXbF/OtmGzQ=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hzDkLv9pmUTDY1r52p50TtEDFsNJeqc5M+EjE9mbIGYV5ElbegqD+vFt1RMfzFpv5afiHWLsy3jl3ns+8gVjY5cjTEwlmo+evVNdz/d/fYf4zrBiNnKS/gOIu8j6R9a8OWtXBFaQl2Qgod5BOiOQZI1UbPU503YY2nn4Ow3Lz5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CYdJu2rC; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758309985; x=1789845985;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=iqimgm2wv78LE+r5tZCy/L9KYj/eVjiPPXbF/OtmGzQ=;
  b=CYdJu2rCqhIR0rYyjAq2D+9aKltbsSJzPrp/S+7/XQuVLL3isp8Li/mO
   1IqroI4tAh0BlKr6ztRME5Y0I8nqq/PRYbqPX9MazNjkUNl5AlliWorix
   xVazCUZuZ163S6DfDjnbtTFRtmBR661WEFHYgQEmRWJeJFDE001i9lF0r
   mmFgCTRJi4ARWRwWNvstwN/ZlpyJQ6YOeiN5Jc9M5TLEqF2Qiaz5tKVvZ
   1O2lrjuH6RbHrC0rsovH/TWXBVcCGANlsYUJ2RbOyf89RX7XBSSAerrcT
   VgLOg9flT+FpgrZ/B9zKS7iAp0A6lKpIp1JNsl78JgNOOPEL4IGmqPMvb
   Q==;
X-CSE-ConnectionGUID: /3P02uFHS3GqHSXwnqDiyw==
X-CSE-MsgGUID: CkEMlT+8RqmH6N0r05r6kA==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="63294418"
X-IronPort-AV: E=Sophos;i="6.18,278,1751266800"; 
   d="scan'208";a="63294418"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 12:26:24 -0700
X-CSE-ConnectionGUID: QHKKz/3HSsqtGzsL2gUXXA==
X-CSE-MsgGUID: YhqpU/J/SUegVjKuI3f+Fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,278,1751266800"; 
   d="scan'208";a="199629096"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 12:26:24 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 12:26:23 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 19 Sep 2025 12:26:23 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.42) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 12:26:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jFDx2SYPsQJIL3SERQbc37UADSUrJf2/PpD3UT4KIP1+E9mIfx1XLCnySma2lVdEgEBFCulIErLkLiQCltl4SDDvqY9+gchBIPGox7KA+aQHdDz5warVMr4hVeYqUnhQoQYneA8v31nJXUTFSgVhkm5nV5nmmYuI8JFbLJjRu1qtuXesrthzTCpHoaZohvxTuZRo4Jhe3Un+cwXP2Qrt5DJar/ihhB1DA8aNmWYsY/ldKmn6SuxpEtqsaGVTcPOyo10QKStlqDQe9iX/urZgpd9LXUxcv84jNJmq7+BTvUX6kHatd7LndWxOdvCySq18bdc4ARA/g8LOIf+Qt95q2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqimgm2wv78LE+r5tZCy/L9KYj/eVjiPPXbF/OtmGzQ=;
 b=kHC7UdfHWW1FPLbrgEaM2/sfkTwvPbtlffJ8pLMhCi4f0DL9f4kVnPC+sJ8tPPCw67rCiKMI0jAVy8cpEj9yDX/UCiPxXkpGfwl5q2tJixzFpz/cgio7iU5HfH1396tliZTncTyHUbKpzea7mQ5x/1d2M74RRfglOMVClkuej7q4ncvw2qG6KKpv7rOf4ahEXq0giFJOAX5ofQUQK0YVTyb9p+NjsWu3nR/bQBUiLK9F1GLKYuAgZRzqAVSQ9kLrXnf0/+O88Q7OfG52Yg77f8OZq2d4VMj0bkeYnqBeBBrh6bRlRga9DsbPbIGxpId8jrKAAwLxSYcV+3eGDW1wwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB4978.namprd11.prod.outlook.com (2603:10b6:303:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.17; Fri, 19 Sep
 2025 19:26:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 19:26:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 03/16] x86/virt/tdx: Simplify tdmr_get_pamt_sz()
Thread-Topic: [PATCH v3 03/16] x86/virt/tdx: Simplify tdmr_get_pamt_sz()
Thread-Index: AQHcKPMyjmTRPc/hA0eIYW6zTP3tSbSZrNEAgAE31gA=
Date: Fri, 19 Sep 2025 19:26:20 +0000
Message-ID: <d9b9efaaf192d4f8b6fa4d93f964dfc7a6493e5c.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-4-rick.p.edgecombe@intel.com>
	 <1c29a3fdbc608d597a29cd5a92f40901792a8d7c.camel@intel.com>
In-Reply-To: <1c29a3fdbc608d597a29cd5a92f40901792a8d7c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB4978:EE_
x-ms-office365-filtering-correlation-id: e9b5b29e-7ea3-4d3d-f472-08ddf7b269c4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MUNtZU9uVGQ3UlFjc1ZIRkdUN3BDdG1wdmRadmJHOU5GZmo2ODBmcVNuUlEz?=
 =?utf-8?B?VDlUQ01TK1M0VDB2R1hxS3UyVlJ4N1ovdDJ0eFlmRmxEeGNjTm9GOUNkNWhQ?=
 =?utf-8?B?b1dEeUdzWWJrSTl5MjFZY2Y1eVRoOUo2Z3VwdloybFd0UkhJa1NZRi9PVkRk?=
 =?utf-8?B?bkFqZkFrT2lXV1FkM1J0YTVaNTJoTElhZmkvTGc5T0NwK2xmM3V2cENBSkRJ?=
 =?utf-8?B?TlJoTmhaRThPNTBRbWx6SjFXanFnMmhyaURqS3U0WDNHb2FnM1AyYVZGTGZy?=
 =?utf-8?B?WUNhMXJtWFkwekY4LzBXdUc1bUloZWpBcUN4d0cvR3JvUkFtZ3FMSjZtWk0v?=
 =?utf-8?B?WTFWTSthd0NzQUQyMW1jQ0htbE5VTENZK0kvdkRQTWlxSG4yRWhKK0pjSnZa?=
 =?utf-8?B?MWJvRmxjcHI4NURocFBUdEpCRzFjdUpNTGlCenEwQ3poTWtRS254eGEwMFpE?=
 =?utf-8?B?ZmZZNG90K0pLWGRQRUsyMyszdWxwZWRIRkl1R2E3YTBWQ1RWUHo1VlVnc05X?=
 =?utf-8?B?cXFTbXhBNXBsL3VzT2pUaU1mZ3NJSHI3dkd2ZHdMK3l1WGZsMTd0MSthczE3?=
 =?utf-8?B?TXRqS0M5TnhJNGxjbHczVGhKdWpKQmFNNG9ZWjF2RElkcXpVMWhESzdmRUdz?=
 =?utf-8?B?UHVrdlFQQ2Q0N2dnUnZrQVE3MEUvUW5MTXRWV3prUy8rWHRoNkFPZ2VmNEFu?=
 =?utf-8?B?Um1PdnpwRzYzOHU1LzNQdmxiV3ZESXBQNnVIQ3NodWVOdzJZNHlKczdSTmtG?=
 =?utf-8?B?WTREYXFOaE1LNmhydTRsdWpXTXFVY2x3SDBiUExVS2E4ZG9kcWNzRzlEbU9M?=
 =?utf-8?B?RnBEQXRZZ0pBWlRmanJpTE1KNGo0QUdXVHBpakdreSt6c01xZU90TWoyODlW?=
 =?utf-8?B?Nk5HaENBMitvcStONCtETGsyaUROenMzSzV6V0RaQ3FyczdsNjBiTlpNNWpD?=
 =?utf-8?B?ajUvOG5Bellya2Y5YjBLZnNDYXZnZmdZblRlVTh0dGYwd0NNRkZmTDlLelVh?=
 =?utf-8?B?UnVZQm5EYzc2OW54OFRCNTFEUmpyR01XSnJkMDRFckNoQ2JNd1ZFcDBVRWNK?=
 =?utf-8?B?Um9YcWUwY0R2NzhjNTVvQ1NsZ1BVRlhhMzhqZlJGMDNmU01wSzh5UnlJbHlm?=
 =?utf-8?B?QW9OQWlyNUs5cDg4ZDUvTHZlamVVdkhpZEw5cWhUWklwM243UmtiZWJNbW9z?=
 =?utf-8?B?YlNNMFFnd2tEVFV2VnNBbjVkT1JmWXdobVdyUGNXNUxaRU84YXZZZmhnS3hj?=
 =?utf-8?B?KzgxQVY1ZEkwNkZoZ0hlNlJiZkIyMlFSd2pOemI3cVBtdCs0ZDVIK3JzN2gv?=
 =?utf-8?B?cFhSSGR1Q1BKOG9YZXR1WU9Ub0FWVjZ4c1BQdldDNnZrME14QWlPYUwrT2NJ?=
 =?utf-8?B?S2R6bFVVQlltalU4TG14UTNaRjRFVFA0RGxPekxzb0xxdW1SeEE4WkJQL0pF?=
 =?utf-8?B?OHJLOElPTjZiTEQ5Q09reU5CTXBzVDZYTnJQTnBYbTVhb0JPMUNLUWNOeWw4?=
 =?utf-8?B?SWYrODlrc0Z6aVpaVUt6SlJ0M1F0cDhGSWZ2QU5abFp6a2dOMEcwU1dqdEtZ?=
 =?utf-8?B?Z085bnBzenl0NGIrZ0N5SjdhK25URkdDVXBiZERYc1NTeEQxaUc5QnRhZ0xE?=
 =?utf-8?B?aHVodm1GV0hZNnJwdjNra0RVa0FadTQ1VTFzc1FPcFN3dU1IQTNubExrZTJ6?=
 =?utf-8?B?YnBEbFQvbnE5cEhlUGIwTGNJbEQ5QzRmdXo1TW92eTdUTDV2MWNSUUZIMmhp?=
 =?utf-8?B?WDltWmgramp1akJZMkJadnh1RnRpNGEwNmRvVWs1bTdIVWdKR2k3VTFhUFd2?=
 =?utf-8?B?Z3hUclZBQ1pZNXZ4eDhzd2RQMGUxWEo0RzJPRnF4N3JrYnZyQVdSWDBYclJi?=
 =?utf-8?B?TTdzVExHS3Nzd0FCNzZJb3lQQ2wyL0tZNFFUNHdKOWlHdXgwZ0pZMFBENHZz?=
 =?utf-8?B?VDkxN0t0ZDN1QUV1MUZIWHRYbkRyK2FEQXZDTExPVkpqTE1oV0VnQW81MWJl?=
 =?utf-8?Q?8TEBwiwQaorRl/wWx2zGwuakWEGSdo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dG0wMzhRWStJTVZ2L3JSWm8vVnNEbmhWTjROODdNeXJlZkxwTlBjeUJrazNt?=
 =?utf-8?B?bTlJMkdIekEyQnVrUzBaWHNMdFl1dHVnc1UwN0xablE1NU4zYnV1dHNWenJW?=
 =?utf-8?B?bFpBM1d2UCtDenhXcldhRXNTcHVOVm50M2EzZGUyUjh0a3hGMEpOTVg1WStM?=
 =?utf-8?B?d21HaTJLanVTUS85Q0xkT3JYaGoxYktvVDRzQ1dXUnNxQXZsc044NHV2Y1BO?=
 =?utf-8?B?ejB0cVFXdG1vUUxsMHFmWDdkWEthbUtDVnExUEs3T0MxZ1Q2dWxGMStCWkVk?=
 =?utf-8?B?TE9YcDhmd2RSVXNQTWRPcWc3Y2QvbzdmeHZia0RudmY1S2lHYVZqVXd4STF0?=
 =?utf-8?B?b1BXdElXRTZ4aWw2NW5kalFhNUZpSEF2ZVRxdDVlbElRUTlnYThQaVlHVTk0?=
 =?utf-8?B?OWk0YTFUblZiNHhKSGxGNmxSMENYVGF2MjFXU0lhUjJ2VTYvMGR5YW9UcEdY?=
 =?utf-8?B?UUFURzQ0NkVXWnNvTmYxYmN1QmVLWmNhSGVXQnZTd05mSStUbk9pWDB0NFhx?=
 =?utf-8?B?R2tBb2crSkhuRlRiTDltaUo4Lzc1NzU5aDc4cjFzTFJISlV1eTNJNTlTaTB1?=
 =?utf-8?B?K2xjRWEybzB6NXZUNXdzd0tNOTdaY3lkZVhScGFLa3NJRXA2OElZdDdram1i?=
 =?utf-8?B?bmJWUDJsOGh5bkdOTlZuMG81YWR2MVNoQ3kwS1VmZEp2bThrZEx0UWVIK2Yr?=
 =?utf-8?B?Qmo1YVE3TCsxK1AvbTAzS1pDWk9ZS0JITmNtOWdJYUlhdlJ0UFVTTnhPSlNj?=
 =?utf-8?B?eHpjTForVzJlVHJIQ002a2pzV2pSaWVINzJQL041aTdyNnBNMHhzR29yeE5r?=
 =?utf-8?B?RURhY21GUzU1WkJKanN4T0F4ZFhna1gxZHY2YXg2Q0IwU3RGSW04NERrS1dt?=
 =?utf-8?B?U2tHUHRnRFd0TGdYclZJQ25UaTZqNm5lSU5DZ2thYlB1VERNa1NIMjVUTUtp?=
 =?utf-8?B?NGVzRW1TYndlN2x2T1haS1lPQUlBNDN2NzVYNlJseW9CYjg4QWUvd3ZkOFYw?=
 =?utf-8?B?cnF6L3d2dXVCUTl5UGFNR3JSS0I2UDBNNHhzcDBieWtjRmZFaHg3N0VFb1lk?=
 =?utf-8?B?bXltQUl5SytodFQ2WXZkYllBY0t6VlphbUJLUGRObEtzd2Q3WWE5YnZmMGls?=
 =?utf-8?B?K2drT3lNeXI0MlVLeW9xRTlobzB6WTl6TEovRXVlcjdsa1NrKzNYYzVveGFs?=
 =?utf-8?B?NEZ6U0tsTG02ck03WitZc3N0UTlCRVo5MzZTNUpoa1h5eFFLWU5zQWErZlBY?=
 =?utf-8?B?bXdGQU5ZQmlveE5aaWszclRjbkhxcGxQRkc0SHM0dnlzbVp2NDF5T0tqUGJj?=
 =?utf-8?B?WWJITnVnOUkvOURocFJ2L0lSVmh2TEZDeWpTT1VwVDFWa1NEcitpRWtBVHds?=
 =?utf-8?B?YnlEN0U1QzhMcnIwalFBMkdpUUJYYWd2L3gvenJMRjBQZ1Z5Wm9oTk5neXNx?=
 =?utf-8?B?SGZaSzMvOUgvWGxuTG5EQ3Q1akNzdEdERmYzQ1Y5cnJYdU80Vjh6SlQrV09v?=
 =?utf-8?B?NGVhanhjaUpiRU1HeTlzK1Vjb3VZbGVNN0oxK3h0NXVVQXpLQjcra0dPSnhs?=
 =?utf-8?B?Sk9hMmcrNzJTaStUZ0xKb1NYV1lDUUIxL3cwaERPcnFpd29GSXZIcDRPTWcr?=
 =?utf-8?B?eTVwdWRESHZqYWU0KzVxR3FvL0xoNUlraitXTlREaFlyTEJxYm5iNWJDK3J5?=
 =?utf-8?B?TjB2cXEzQkc5ekxuakphYkJHV3c3ZlpnVGdhcENZaVFzWlB4ZThVQ05uVEVo?=
 =?utf-8?B?L3ZPaEdQSjQ3ODNRV05kVEVadURtSW96NnRJaGQ3bUlZS0ZCZXF3MU9RWlJw?=
 =?utf-8?B?MHEzc3BOY2o0R2YzK1lleWY2N1k2OGR3SFpXMm9tN3FkOVVnL1JjWHRyQ1BR?=
 =?utf-8?B?cHNDUGx5RVBmcnAyTWg5OWZNOTR2R2RvY2grVC81YXR4SGM3bHFYbVRFbS90?=
 =?utf-8?B?WUdDWmxvamJ6Z1NRUkxUcFUydlNBZ1FuVDFZQ3Q4YXhyU0xOZ1doTGdHam5I?=
 =?utf-8?B?Y3RuZU16YzhkYSsyRmlyTnM4NTdVa1ZiVXRsUnJCYmxLU0JDN2NSMmI1emlI?=
 =?utf-8?B?MFpVT2s2RDBZRU5ualZSSUNwcVVkcStqYUc4THBjVjF4TWlTMktqbmM2MUdC?=
 =?utf-8?B?S3R6Skowb1RidEN2RU5PaVNLQzdmamluSkJ0Qk55YkVieExqZWt5TExoZHBz?=
 =?utf-8?B?N0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C1EC43162DE9F4EB569017B4E3DAA07@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b5b29e-7ea3-4d3d-f472-08ddf7b269c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 19:26:20.6860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GidFAMDPfRD31Kr3nW87Xcn8eAfjjwKRv4UtxlI+DQf+G2bHRcRY5Zy4mmMzKuwv1+9UB9YNts5uVKs+v9vX1Y8LFCy1PMsugg3UBAUWISU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4978
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTE5IGF0IDAwOjUwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ICsJCQkJwqAgbmlkLCAmbm9kZV9vbmxpbmVfbWFwKTsNCj4gPiArCWlmICghcGFtdCkgew0KPiA+
ICsJCS8qIFplcm8gYmFzZSBzbyB0aGF0IHRoZSBlcnJvciBwYXRoIHdpbGwgc2tpcCBmcmVlaW5n
LiAqLw0KPiA+ICsJCXRkbXItPnBhbXRfNGtfYmFzZSA9IDA7DQo+ID4gwqDCoAkJcmV0dXJuIC1F
Tk9NRU07DQo+IA0KPiBEbyB5b3UgbmVlZCB0byB6ZXJvIHRoZSBiYXNlIGhlcmU/wqAgSUlVQywg
aXQgaGFzbid0IGJlZW4gc2V0dXAgeWV0IGlmIFBBTVQNCj4gYWxsb2NhdGlvbiBmYWlscy7CoCBB
bGwgVERNUnMgYXJlIGFsbG9jYXRlZCB3aXRoIF9fR0ZQX1pFUk8sIHNvIGl0IHNob3VsZA0KPiBi
ZSAwIGFscmVhZHkgd2hlbiBQQU1UIGFsbG9jYXRpb24gZmFpbHMgaGVyZS4NCg0KT2gsIHlvdSBh
cmUgcmlnaHQuIEl0J3MgemVybyBhbGxvY2F0ZWQuIEhtbSBhIGNvbW1lbnQgc2hvdWxkIHByb2Jh
Ymx5IGdvDQpzb21ld2hlcmUgc3RpbGwuDQo=

