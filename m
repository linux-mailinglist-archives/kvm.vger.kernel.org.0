Return-Path: <kvm+bounces-53532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A3EB13865
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 11:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35FBB4E079C
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 09:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FBC2A1BF;
	Mon, 28 Jul 2025 09:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FhKPZF/O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E517483;
	Mon, 28 Jul 2025 09:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753696169; cv=fail; b=YjW+cq21vLGLIga8FiQJdHf+671bYc97uHYGE51McBpVAaIcMKOAb4wg8OV57KjsOF+hwfjWvOb+C89IWkUmAT2trm9XvupxC9a7gm5mkH8ySr7cI/uQfmSaTe8Q7rguFJInQF50JCuAqR3u2SBit79yKnQhHoKeRo1CFCBZpHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753696169; c=relaxed/simple;
	bh=ej6TI129F5mqL9by6SDI5BkBF2Y4ySiwsl1W04ID4dg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XvdXDgcq38iFbqHEhUYV5NCQCobmVHBpzu4MZOU3wBJMtYRPGlZSyCnNQRZA/1EdCwfLKmf+dEpJUmn0stKYjRXPuQ0X5AiuXHpeesTmtgBh/7Jhb0nGDXZwJ889NMFNRNfihRTdVy5ixaVgbkW3a0mOGQaYpr4JdrwMCulYA48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FhKPZF/O; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753696168; x=1785232168;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ej6TI129F5mqL9by6SDI5BkBF2Y4ySiwsl1W04ID4dg=;
  b=FhKPZF/ODf2PMCAuW0mjBezAXHIpCeMat4J+I2GlHZO4HpyB9dkSj89h
   j5yuWEhgN1/a7irYaUeEdgoRWnzPbsbf8W0DA8YNe7X9MvA20G0Dvpggh
   iH0lEBKeD0EFAbXJF2avUNm/5spYk/2fH6HxsoO8Gb5Msww95XCjuA/1Y
   XnDtPRZR2b2QEuNyU69XZx6T/94NoFNM11wtavHuGPczbtiL/+hToob/k
   tI5Vyjm/DNTlwLLcXc68wMR19Sdlv6gLNC6zt5MRz4sShKJW6AHYGGr5f
   CQTm2IpEMi+4eMD/kwy6xUt8vfCgnS7iPhF55oiWy+iHLNotbVhOmFRK0
   w==;
X-CSE-ConnectionGUID: Duoq3ky0S/SSebobufgRfQ==
X-CSE-MsgGUID: 3IbNotbQTJ2USEr0fWZkcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11504"; a="66208922"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="66208922"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 02:49:16 -0700
X-CSE-ConnectionGUID: OVPVgm/1TOOm1Ort/lU++A==
X-CSE-MsgGUID: 35OlMWDmTf+gCE+YzA0X1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="167706721"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 02:49:15 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 02:49:14 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 28 Jul 2025 02:49:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.83) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 02:49:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D3l+94XSloH90HwkWWmSoLOSDAcBh2bj1ePCkJ/x8FZ7V4lmAL2xXc0QfJmRkiIxi1wWmg/vbXN6aB7k6sGxZUPCz1fEW7LYHwnn3u1zWFpqwlmlZy0zjvhnSRPIG+ND0qJL8qUrVQ8mON/ZXaHetgVxSWrLNkP/paw00dEA2bqpMBgwcjYxD0ZbFLn/nNmYb/STjfKNVHvLte6VhicO+w/hXOzM/K+oEesD7KU6gWv2AUItvpAoozWfZsNiVdYBaaU+WTjLJsWexgLxiCPnSwzGDcsqpeZG3v2iMaEA/h1Xq+ten6WdlGcqNADpGFQZf+GDpjFDfJcvM/LLktLntg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kA6QiDUjGuIEJsxySbPr+pN+wTnUTKOXLIornjBevgM=;
 b=ZKK5ZJHswctfP8FSby3Z729zz3FmPDWFq27sgiXRsU5BwnBfv1gO4k8creM568ISkBmQfeRBvu0wI4FAkCEJ14KW7yCQk9F3pvpwJQ7Yf6cpEu/IP3gNdlqxK/SkvCViJoJBefFzsifNeime4XCqcfSWqzamIlvUhLrkg8jrVgOreetva+fTkh82RbgT9P1n5+FU+MNR2BZ9vOS7jhkO1DlIOFzDC2NKmglcgq20iwnAl1g3c6cUMYzIHeXEI6s6ES1uZMygbXWoQI8QR36OmlV6QIuEJQO8uXfG1jai0inhJViiAWAtJ/dRHT3Zyk+ivQyFDuYyGIxib+uJ3kr3jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB4957.namprd11.prod.outlook.com (2603:10b6:a03:2df::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Mon, 28 Jul
 2025 09:49:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8964.025; Mon, 28 Jul 2025
 09:49:11 +0000
Date: Mon, 28 Jul 2025 17:48:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Sean Christopherson <seanjc@google.com>, Michael Roth
	<michael.roth@amd.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <ira.weiny@intel.com>,
	<david@redhat.com>, <ackerleytng@google.com>, <tabba@google.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <aIdHdCzhrXtwVqAO@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
 <aHSgdEJpY/JF+a1f@yzhao56-desk>
 <aHUmcxuh0a6WfiVr@google.com>
 <aHWqkodwIDZZOtX8@yzhao56-desk>
 <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com>
 <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
X-ClientProxiedBy: SI1PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB4957:EE_
X-MS-Office365-Filtering-Correlation-Id: 49d19088-8e26-43ea-dc15-08ddcdbc0119
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NzdnU29HQkdjTFJJUkJqOUJwNCsrN2tCTkFzSENMS3kvSmdUZ0hnV2RzbXlD?=
 =?utf-8?B?NXJQSjJ4S01mcHRRTmUycGdBLzRLb0FpNUNneGtFeXdITlI4TUVHdENETWtj?=
 =?utf-8?B?UGVZcDk4UVJXYUxSYnBtWDFBSnlFOU9pc0dsRkc4RzAzUlhXb2RnYm44OHRt?=
 =?utf-8?B?N0p2THVkMnhaTWMrb1VmSncwN1RCR2F1MGp0Y255SlR2VHlNamkrR24vd0to?=
 =?utf-8?B?cmdsamV2ekh2WFpWTGxLcUtXbzFWTjE2ME5BNEc4MWp3VmU1WDlBaHNVbWQ5?=
 =?utf-8?B?QTRRYzJuM2NnL3lwemRYUmVhMzljYTNDb3pXT0xFblliK0pLN1J1WDNPVUk0?=
 =?utf-8?B?eWVqTHNkdmI3S2sxK1I3aElRamVWZy9sL1pmSVFYampjZjZmSEY4N1doSDRM?=
 =?utf-8?B?dXdjVGM4TCtKK1czNFZEVy9ZaVhjUlJZMXhZa3NTcm95b29rRTFCY1JmOHJa?=
 =?utf-8?B?Tk9ieG9FTXZ5RXl4Q1FNY21uV0J3dEtiTVd5RjE1UmdaRGt4SWVzelduM1Nx?=
 =?utf-8?B?Z3ZnbkpYeUJiWFV2bWRJS05yUU84RVRpZE9scmFLaW42QU96UUUyTHpVOS9Z?=
 =?utf-8?B?cUhTRTUzTFl0R0dYbG14aTdObDhBOUgxeUZaY0dLblhHRmZYcU9ZeWorbUpJ?=
 =?utf-8?B?UGptT2lDOWhDeS91Tmd5Vjc0MGZIdStoL1FBeGJIWGs4b1RtVnFybGF0bHlL?=
 =?utf-8?B?TmtwWElrc0JnRUoxREp5VzVTYllwZ1BpU1pPQ1dDL1ppNks0N3NXSWFvbUVP?=
 =?utf-8?B?dDVObDkxb1Y2WjRFMWdQUmtrN1ZWNHV2aG1ZYTF1SEhZNm9PeDBSWVVOMnZB?=
 =?utf-8?B?ZllvYVc2YWswaFRnS3J4SFpMa3BVVUNoaXREM0VwUWM3aFdHVk84RFRIZitX?=
 =?utf-8?B?QzlhK3o5RlpCbG1KRDdPaHhSOHhzQ1FvenVWS1BRNnZSNzNpcTI1NUcwWDJK?=
 =?utf-8?B?bnlteUx4WjlPY3BDS3E1bnpXeGc4akRlVkFoaWF2dXNtVW8rU2FBVFY0K0VK?=
 =?utf-8?B?RkR6VGdwK1FXL05KMVVpc0ZkbEJSMzlCTXl0VnhUTjZFT3Azb3pvL0xvYnhw?=
 =?utf-8?B?dlRFSGlCVU5vbDk3eHRqc1BkM1dtU3FrQ1hqREcrclNZOXFaY25US1VIbmVu?=
 =?utf-8?B?U2xYOGNtUWNqdVZIcU5DL0UvTjhYNGxpbnJ0RDVkYjR4YXBMT2JjZ3E0ZXNQ?=
 =?utf-8?B?VlQzcG1kZGNoSFlPNDNjbWJVdnlCQk5pd3BBK0JHRXB6U2xRZUpCZGRZU0hs?=
 =?utf-8?B?VTFZYmFpUFdyNHBLZ2pVK1RQKytsbVZMYU5kTm90SUpvTWZhUjQ1dEZPdGVX?=
 =?utf-8?B?dmM2UmRGM3lXYzRJenVvWW9UdmJRR2Q5bnpYZ0s2d3E3a29oMDI3cmJ4ckxU?=
 =?utf-8?B?ak5UWVY5K1E3WUpzQkhlYmExenJKcWU1MXJxSDFQQ3g5VTdWU3k5c1NudldF?=
 =?utf-8?B?eU4vOHZsSHVyTDRlVGVWcGpJbVJQNmpRL3h4WnZEaXh2VGJsUm5oT0VVa1pK?=
 =?utf-8?B?V3BvTExMbEdST0htcUsrZmV3R083VkkzM00zaVk5K0lLS004bmpVU1hiVzVr?=
 =?utf-8?B?RGxvRXIzYTkvZGhzeWxzSWZRb25ueCs4S3FWVUtxSENVY3VxZVF2ZmRtbm14?=
 =?utf-8?B?bWdiQ1VDdzNFT3BCa0Y4Q2tRWWo4ZDJSZXBNYVRzK3cvNkFxaXA2bUQ0cmM4?=
 =?utf-8?B?UndIRkd5OTVDVk11RDhJd0J6M1BLUzNSdGt3Q2J3YUF6QlVqN2s0bWl0eXBD?=
 =?utf-8?B?TVhUUFdSN3FaTE1qZ3ZURkIwTkU0OEUrZ1dBVXRweGxJNCtHdG5WbHVsK2c2?=
 =?utf-8?B?NUs0aTlhY1BGQ2c0K1dJWTFUNjJtTFllaXdxTVpsMEJYa05NdE9ZdTZUdUZi?=
 =?utf-8?B?YWJyWU94bENLSExEQVAraThvclZQcG40MWF0WTFrd2Vrdlh0Mm1SUHROQlFC?=
 =?utf-8?Q?CN5PHAfg5JI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akF1SFlZTUI4MmUxMXlBVmdRNTdQRytFSWhIL0U4RDMzWUlHcFNpTDd0QWpz?=
 =?utf-8?B?RkN2U2t2MHp0S0J4dGc5c2hlendwTy9EbzFRd2VuOVY1eEVkUlVDL3JENXJG?=
 =?utf-8?B?NElhckNrN2xxbzFJUVcreHNzSDVtNVRlY0NlcEtENTByalR3MDBXVStxRUF3?=
 =?utf-8?B?MDB6Nk8wZ0dUTVZOb1RQakNGR24wQng2VnBnSlRzTU0rOWl3d3cvbDdHNmxK?=
 =?utf-8?B?S0hVL2VnWkI2Nkl3bE5pVFdnaUdOeDNCekpMK0c4ZTNDLzg2anF4ckhxOVo4?=
 =?utf-8?B?ZGhCdU1MNURzWG1FVzduSE9SN2pqbkVnV3hKRWZCTnR5N3pEdHBlM1YwaE9a?=
 =?utf-8?B?QllIV09ZMUNsWkVSemhSa1ZnUWtHVFBZbFBmbVFIN21tclUzTHhOUG82Z3h5?=
 =?utf-8?B?VHV0eWQzbGNRV2hPY0s2UHlUNHZ1bkhZMDkyNXp0N3NxeVVONHJJa0MzKzZ6?=
 =?utf-8?B?eWlNZElyNlQwZ21pK1k3cGJjMGpQenFIOTZaYWRKQm9iS2lGL01kc25iZTZS?=
 =?utf-8?B?cUNVQXhNWUhnMmIvT2RXcjkvSE9JWUs1MTR0am1QN1J3aHlhd0FzNlNVcGd2?=
 =?utf-8?B?ZExldzErYmlpTHBQVjBFT1VlWXdTVDQ4SDh3MXJQcEVUUVpzemJ1YW1RRitp?=
 =?utf-8?B?b09JelI3Zmp5YllXaitTcC9GV3VmaW5ZZVRER2ZIZGJ6VkJBZVVQNy9WSHJI?=
 =?utf-8?B?Y3lsK292Y01udEpOMks0aXA0R0dJZTlYOGlUZllnbzkzcW11bTRVRUM0b05J?=
 =?utf-8?B?VVhXVnhSYWt3WHNET0h0Tml3LzB3QUNGRTYzcldDeHlzTm4vTlhMZHVHU0dM?=
 =?utf-8?B?ajl4cFdUTlA0aTk3MnJkT0ZpdFlDUUZOMlZoNnkxcXhmcEJ1S0srbUlzYWdl?=
 =?utf-8?B?RUdTNXBJWnFYSHRta1drdlUrZjRsVWl5Vy9nSDhlS1ArYXd6UXRHekRBakVR?=
 =?utf-8?B?WG9rcFVHbXUzazZpVDNEa2Qzd0xwaWExTFkxVUwvd1k5NVZXOE40SzhOTEx2?=
 =?utf-8?B?OWxsc0NHdWg0em1YU1lyOEtKRzBBejdDSUNDeVFvQmNjS2poMHJld0hDY0hE?=
 =?utf-8?B?T0MwRVAxZ0ZvUUwxam1ML0RpdGtkcjhZWnVDN2xFeGR0S3NMUGVROENlVlNx?=
 =?utf-8?B?YzNGb1B2d3NxeFhDYWJuNlkwb0xuM3FoOXdydEp5M0RBcVpRQ2txNDh1a0Rz?=
 =?utf-8?B?dHhmczdES3A0Um00dm9pUnJBYThxU2FWbE85cEpOK01VWW05aC9SSTJrU2hC?=
 =?utf-8?B?U005Mzg2cytic1VxZWx3by9Fd3lzZ3NsdG5NUDhqQkdOdEZZd0k1MmhUOVUw?=
 =?utf-8?B?R2JiVER2cHNsakU2b0RLMlNBUFRTazI1eW1mNDNsaFdSakFDVU5uL2hjNkNI?=
 =?utf-8?B?VTYxYmdZWjR2Nm5wTTBsS2lud21YMGJjYVMvN3kyamNwSzF2dnJ6R0ZRTGtS?=
 =?utf-8?B?eHJOb0YwYnNqZWpVdUZ1L1Qwb1ptN1ZEMngwR3RtZDBZaHJUY2hncmpaOWNB?=
 =?utf-8?B?UXdhd2F0WVpJN2dkU2FpVkJPTnI0YjJoTnBDNVVwcFBSTlRQcjUrbmNBTTJH?=
 =?utf-8?B?MnJGdXFBSjFRUFlKd0VvOVhkK2FVK25ZR0p5cDhhL2tWWUN0Nk1SN0w1Z2wr?=
 =?utf-8?B?V2hNbWc2YndNY3lQRi9XYm94RThOdW1McHVjNTlsVU85M1RRaU9MMDJiemk5?=
 =?utf-8?B?TEpCM0VVT0dKMUI3VHltU0krQ1JlL1ZZOUJZSGJVRVlVRmFrcGtjckhCaGZk?=
 =?utf-8?B?UmlNSkNIR2tFdkd6emxxbDRkT09nMTIvMnQ1bFF0dWtzSlNhOWFsci90MVdD?=
 =?utf-8?B?SXBpd0o3MEhxajQwZkVIbnBoSmJSZUExbWl4amhJaVBIbEk3T1ZXODNmbEJK?=
 =?utf-8?B?VnV6UmRsV0dHakhDZEVZU0VIWDNjTmZuU2k1UjVjN0kwSWUvYnV5Q0w3STJO?=
 =?utf-8?B?MkFrSXA1TUtvQWl0dVFJZGNLSGFmYkNWT0lsYVpMRHVla3h0T2UzVzNVWURx?=
 =?utf-8?B?dXM0Vm1vaWlQK24zdVhhMG9HNkdwTG9od2QwdmowdjRpQVh0dWg5dXhyWnpV?=
 =?utf-8?B?T1A0K2ZyMWNlczUzSjBpbHNSMmNMV3FDWTZPWUxVRW1oK3pUc0k2OGh2ZmNT?=
 =?utf-8?Q?LizuiIZKXmfE2nG/nX8rauPAc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d19088-8e26-43ea-dc15-08ddcdbc0119
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 09:49:11.4662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8GtysIGTsqOckZeCzJkkZPXVmXhmuOjId+GCdKPZriFMiPHmrZMwbjksocrM6egbavYqsFuchrwssb2fVb2B4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4957
X-OriginatorOrg: intel.com

On Fri, Jul 18, 2025 at 08:57:10AM -0700, Vishal Annapurve wrote:
> On Fri, Jul 18, 2025 at 2:15 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Tue, Jul 15, 2025 at 09:10:42AM +0800, Yan Zhao wrote:
> > > On Mon, Jul 14, 2025 at 08:46:59AM -0700, Sean Christopherson wrote:
> > > > > >         folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > > > > If max_order > 0 is returned, the next invocation of __kvm_gmem_populate() for
> > > > > GFN+1 will return is_prepared == true.
> > > >
> > > > I don't see any reason to try and make the current code truly work with hugepages.
> > > > Unless I've misundertood where we stand, the correctness of hugepage support is
> > > Hmm. I thought your stand was to address the AB-BA lock issue which will be
> > > introduced by huge pages, so you moved the get_user_pages() from vendor code to
> > > the common code in guest_memfd :)
> > >
> > > > going to depend heavily on the implementation for preparedness.  I.e. trying to
> > > > make this all work with per-folio granulartiy just isn't possible, no?
> > > Ah. I understand now. You mean the right implementation of __kvm_gmem_get_pfn()
> > > should return is_prepared at 4KB granularity rather than per-folio granularity.
> > >
> > > So, huge pages still has dependency on the implementation for preparedness.
> > Looks with [3], is_prepared will not be checked in kvm_gmem_populate().
> >
> > > Will you post code [1][2] to fix non-hugepages first? Or can I pull them to use
> > > as prerequisites for TDX huge page v2?
> > So, maybe I can use [1][2][3] as the base.
> >
> > > [1] https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com/
> > > [2] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/

From the PUCK, looks Sean said he'll post [1][2] for 6.18 and Michael will post
[3] soon.

hi, Sean, is this understanding correct?

> IMO, unless there is any objection to [1], it's un-necessary to
> maintain kvm_gmem_populate for any arch (even for SNP). All the
> initial memory population logic needs is the stable pfn for a given
> gfn, which ideally should be available using the standard mechanisms
> such as EPT/NPT page table walk within a read KVM mmu lock (This patch
> already demonstrates it to be working).
> 
> It will be hard to clean-up this logic once we have all the
> architectures using this path.
> 
> [1] https://lore.kernel.org/lkml/CAGtprH8+x5Z=tPz=NcrQM6Dor2AYBu3jiZdo+Lg4NqAk0pUJ3w@mail.gmail.com/
IIUC, the suggestion in the link is to abandon kvm_gmem_populate().
For TDX, it means adopting the approach in this RFC patch, right?

> > [3] https://lore.kernel.org/lkml/20250613005400.3694904-2-michael.roth@amd.com,

