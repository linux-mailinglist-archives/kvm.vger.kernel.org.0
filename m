Return-Path: <kvm+bounces-24993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 827BE95DD32
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 11:33:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 121CB1F228B6
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 09:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13BC515665E;
	Sat, 24 Aug 2024 09:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E82kMyMP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E799154C07;
	Sat, 24 Aug 2024 09:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724492026; cv=fail; b=hv0wZj/b539Z5oIFG4MQga6pLHEWiXb9rDS2AY/5249L4bzvMyWklU64rHs+HyBubznc2UIL2O2Y+O0T7YsQjk5pHXgpkalqdVI+jmV0hw4vZS38JYLlH0+f18/tmzkEQs9XM57FmuYoPk1p3b+6gpdEgMHzs1mVMjFCc85/wto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724492026; c=relaxed/simple;
	bh=5sClnAdyrZcEYhdIgsCuf4ksLMlL4KXNsrMwKtKjDgQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mb9t4ti6YQKDlnBwzCgIo/Mb1bWLvDDOQjdEupahqTw1SlVbrRPFv5ipMw+cR2SQAYJfy+f55eoo45T9BO1A2rr7grFzdI5pSwOEnTktS74+0wSl6OP8inxxg+hUb/zgDhK9Yv9JSKUoNdXLI+4YYXtIZLfPFy/V1Xmtd0tqei0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E82kMyMP; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724492024; x=1756028024;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5sClnAdyrZcEYhdIgsCuf4ksLMlL4KXNsrMwKtKjDgQ=;
  b=E82kMyMP28lTuZF0+ZcPUZNKNwScm8M6onmGY+umYCgrBs/+ZMRhybFn
   tJroHtwM+yQMeCQnZh6NhfavOHAiBg0micffi6OQWMpT5Z/eJsRW1W0Td
   HT4CfniA0MZXjnj1oLwt6nVm53X36xbxd9un7nHDGUU9Q/Nia5AmNnwLD
   dMOVdrBywyhi6CVJkelQ267Vw3jggP436pic07VhrxtpDvKJOJMStmd4m
   1TYOeBwyB3wgVeClJ17A171MCzhzVvo7igfJXyNW33U4vnpNi9UgH1Hdo
   M28sEMoWOEBBGIlnd7a61NhwVx+mY7BcsTMOh12WuFTZMgN2ApP6Mmkjz
   Q==;
X-CSE-ConnectionGUID: fab9uVlkQBqmZ+ZJ8c06Qw==
X-CSE-MsgGUID: zlvUBPz3Qw21yrZ+50U9Lw==
X-IronPort-AV: E=McAfee;i="6700,10204,11173"; a="23152504"
X-IronPort-AV: E=Sophos;i="6.10,173,1719903600"; 
   d="scan'208";a="23152504"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2024 02:33:44 -0700
X-CSE-ConnectionGUID: rHgu6FS2QSm4I0B+57Kdow==
X-CSE-MsgGUID: un71MtCoSAOLDbBxR//ivQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,173,1719903600"; 
   d="scan'208";a="62571719"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Aug 2024 02:33:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 24 Aug 2024 02:33:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 24 Aug 2024 02:33:43 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 24 Aug 2024 02:33:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W/znCdG0RxXQHp7z5CUW3s0dJ5FbloWVelmJTAaJStnMXLfpXn+JK1tyetGDPs41edOrHtE/PqPf4ciuZ15tSIs1myQtS3ulOpCzEQLvmguBbF5ZDPia9s2rhP4VpYmrNM8RkLlfRUi3f6mgcNv6/kg1EtieeQkUwVqripPJYkCQePEBlRlfmzjugExVaEnGIO1+lG86PX7+5I20PT7ca12r1S0ZEIIPzK1D3L5UeEhiOTD/2sVcC6hu3NYPBftjITcTZvALEluoCx5MHjqxDTdi0Z9f6mUJYwl36PTe+uVug3D9JmMFt9dLI008PEFSglHppZ4uh9HUK+BnBje5ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5sClnAdyrZcEYhdIgsCuf4ksLMlL4KXNsrMwKtKjDgQ=;
 b=lSFKmG5NglSWJfvESeSK9lS4PxIi0v84JsaRf6PK+mUwdFJARqOZTTa9ZrFi0igMWgDLn6+gG3CgO9ymnWrd9VL6h6B9Y3cz8Rkx8RNgj5ioCdyxH04ZVy5SGcxcuEY95yNp/vPL+RdaZmRp/4L66KgAARuHSVu808XVRg5NTbMqfhXbkNXknW+H8OCd/vn9GMYOufYi1ZvXEKRqGsrFTJOB2fc7SNr0AqWroMM2vPLcbd3KX5HE/YYIf2D0oWX+1TZLqzHzpfHLMXgYw76MCh26DlrobRLDplDSIq1qDSOfcGEKya3MV5cB9UBqq5xddgoFEhq0BvkKv3LUJRRYng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6497.namprd11.prod.outlook.com (2603:10b6:510:1f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Sat, 24 Aug
 2024 09:33:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7897.021; Sat, 24 Aug 2024
 09:33:40 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "zhangxiaoxu5@huawei.com"
	<zhangxiaoxu5@huawei.com>, "liuyongqiang13@huawei.com"
	<liuyongqiang13@huawei.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH -next] KVM: SVM: Remove unnecessary GFP_KERNEL_ACCOUNT in
 svm_set_nested_state()
Thread-Topic: [PATCH -next] KVM: SVM: Remove unnecessary GFP_KERNEL_ACCOUNT in
 svm_set_nested_state()
Thread-Index: AQHa87/4pKa8+D0M1UafH5nDbbJ08bI0wW0AgADIToCAAKApgA==
Date: Sat, 24 Aug 2024 09:33:40 +0000
Message-ID: <e21beaa7c31639f9e8836f963f16c23ee982329f.camel@intel.com>
References: <20240821112737.3649937-1-liuyongqiang13@huawei.com>
	 <b3c27ca7-a409-4df5-bb55-3c3314347d7d@intel.com>
	 <Zskil6dbwJmL93cO@google.com>
In-Reply-To: <Zskil6dbwJmL93cO@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6497:EE_
x-ms-office365-filtering-correlation-id: 02daf015-344f-48aa-5b43-08dcc41fd6ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K2tLOTlVS0ZTWmRjMHBQQ0psYXlDQWtpTnFhS3JneVIzcGRuK1hnbitUYVFi?=
 =?utf-8?B?L2Nab1plOFYwNWQzZk9RRXlxaW91TWpsNDFUZkhsV1RpRTkyendWaGFnQUd3?=
 =?utf-8?B?cTQvOVljZU1TU1lRRyswWkVOZkVNZGpJZmtsLzlMbDBJM3V1RTVRMG16OXh0?=
 =?utf-8?B?M3JmL2R5djdlZGd0bWNJcFNjdk5lZUg0SWJTdkI3S1libkV0UE0raDFLWWY3?=
 =?utf-8?B?eFovbVBIbjFMeHUzMVNKZ1ZFcSs2T0ZjelA5SDJXMzlHZEM4NU93VnVHVXlS?=
 =?utf-8?B?eFhYazNBdkxnUzhkcTBjOFJiYmhvcWF5cFozOXhQRUNpZklzdkQzSDFRL2RC?=
 =?utf-8?B?VG5uNlA3TU05TEFsVkhQb2p6dmtxR0Fnak9MSmk5Q1hhbFlFSkh3SU1SaHM2?=
 =?utf-8?B?WFhjMTB2bDU3SjRRNE9vZ1IybmExUnpoRDNxbVJmWGJ4ckoza00vQk11YzEw?=
 =?utf-8?B?NjFUbmN6ZDg4VHNSeDc4SGFFbHhqd1ZvZGs0VzM3T2E3SGtaOWg0MXNrRldT?=
 =?utf-8?B?bjkxT3YxeG9WT0FFV0wvRCtKWndlVDdJaThFbGh2bWs4M3VzZXdDZk53TTFF?=
 =?utf-8?B?NmJEZzlEYkpZQ2hsV1FpSjErbFBXZ3dsL3B1TkdPd2tBQzdPbkUwWFNNakNm?=
 =?utf-8?B?SXNaa21hUzdwOTNYU2h4eE9hZlkyVlkxN2N4NTJNdWx5dVVzaVQ1UCtaWTlI?=
 =?utf-8?B?ZTJjNVY2SlB3L1RXeFAwcFBiWlljTGlpaUdsQTdEYm93b1hVT3VBaXpCaUho?=
 =?utf-8?B?N2M4OHhZSkJ4VmlPVVpXS0w3MTEwWnRGb1JxMEk5bjFJMllPVDhmamJFTGVF?=
 =?utf-8?B?M2d2dnBockxVMEU1T0NraCswcWlpdlRqV0puQ0JzeW90ZDVXcWp6bm1MVlJz?=
 =?utf-8?B?VnBNbUdDN0RTWHpkT01aTTE4bSsvOXdlMDRvM1MxQnNXbWZTRytOT20rNDdr?=
 =?utf-8?B?Y3BwTEI1bW5WTjJtMjNPS0Uxd1NhcU01bUljZmVIUHhPbVo2UEpuS0tKQ0c4?=
 =?utf-8?B?VVQ3QVBoOE9kcnpQbTZPdWR2T1JqUkdnS0hDT0dvSjkxSDVzM1F3aUpXSVJr?=
 =?utf-8?B?d0Z6WW92WnBibFJOUWx4cnpHcVNBbzFXZ1dhRE91aFlDVkNrM0hCRE9QdmQv?=
 =?utf-8?B?ZVdzTW1NeVhuK29BNUVpb1RZR1YycG5IdmJHdEZtTldrSTNnNzlZTFdvUHVw?=
 =?utf-8?B?c1JtVklraXdNY0ttYklhMVRlUkt3bWVnQkltV0R2NUpkRk9tNjhIa1FSb2Nt?=
 =?utf-8?B?djNrbmNML3lpTGF4TFByZzNERC9FcVJvMkI0cjBPOVZlTk1DWkZOakcrd2pj?=
 =?utf-8?B?NGJyeGJrcEZnOXE5STdLdC9yNHd6SHFjR3hSYVQ1TDVVM3lqTW0xN0RSVlpQ?=
 =?utf-8?B?eDJWVGV0S0NKbW4rSGp3cWF2WEkycE93dk0wYWVpMGxhdHZ5SEt4Z0dvMkgy?=
 =?utf-8?B?cUZaeU44d1JxSXZCdG9LNnhDZzFzbnpNbjVYb29pa0xaRDZhUU5Qak03SHJ6?=
 =?utf-8?B?MzEvYVEyNXJZeG54SGdCRzIzOTVTNUtQZGZSc2FoVjhqTCtXelNyNTJacklB?=
 =?utf-8?B?YVZYZzNjdEY1QXNneTY1K0JGMEFUSHZQZW5Dc000TEFxalcrWGNWcnAyRi9B?=
 =?utf-8?B?cDQ3ZVZiMEtNV2ZmTSt1YnU4L3l1anRiTnFZSWtybjh6WWlFTlhlVjlzYWlC?=
 =?utf-8?B?dVVyQVpVcEl6Z1lzSVJSNzk4b3B0MC9td2lkc3EzN0k5VzdzTFRwZm9UL2hx?=
 =?utf-8?B?cnlrZUw0OVdpKzUwM0g2bjhlWkM4OHJwQXVjU0xpUmgvWk9CNnVaS0Z4Q3dE?=
 =?utf-8?B?N1o3RlNHSnpxdkpJVU1HdGJEN29sSWFvRDdXOEJSZ0oyanRLd2dzZmtVTy9h?=
 =?utf-8?B?Q294NGlpL2J6WkFLY2RJaGJjYXpuaGhTeGRCZENHNlF1TXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDltdlU4dld4SmpqdTlBSUZXblVUaTJwcHZlZ3FMbk0rc1lsQUpxekJmUkNw?=
 =?utf-8?B?bFVLRnE0YjlxVEhmRG12QkpEYkFpRUR0U05lSGg2Y05ycDlBLy9EK3dhazhp?=
 =?utf-8?B?TDVpYTFKL2xPMVRIWlRIVWxUbzJFR3J0SFhKdnhjZ1E3S3BWTlhKZ21FVEZW?=
 =?utf-8?B?QzVKTUNiVU41SHpHZitWWEVIR2FYT0tOOUZxWHByQXQxdzUrK2NpaFBVYjFS?=
 =?utf-8?B?bExTY0JNOGMrSHZuU083V1ZTZTRvNXNveXIvTTFRWEt0djN0TFVwY1hBMG1H?=
 =?utf-8?B?NUwvVjhFRi9GZEo0OUlDS2N2RDNxbE5TRU5RS3BtY1FESFRpdmNkWExJT1ov?=
 =?utf-8?B?S2o5Y0lQU2ZvWVB0UWVzbUcxczR0clBFWklieFhKR2tCcG5xb2g4bkdqaHZP?=
 =?utf-8?B?RlBJaE00ZlJYTmxuUHZKaW5NRG5NcEk2SE9sdUR0dVVhaUExSG9NdUNyRjVl?=
 =?utf-8?B?S090eVBibTAyckh0T2xnQzd1d2Vya0VXdmptZkdqb2pXN1ZaZ0w5TVlHTVdq?=
 =?utf-8?B?VXBQcWNnbFZCbGlzRHJYYkV0YXdKdE80NTVWdG55ZlkrWG9ldHI2enhTNEdH?=
 =?utf-8?B?SVJ4aGVUd3VXUEc5bEJxRlNLU2ZWODRzcm5jNXBmMEdOTDVtM1Rvb0VRenE5?=
 =?utf-8?B?SUxrR28zc1c5dUlpelYzaE9OZHpyWlM4WHN5UlVaYkF1RzVNOFFsUlhya3Rk?=
 =?utf-8?B?VWV3YXB0Z1lNcGhvQVkzN0dLZUpqVWFkMnZ6ZVFQc0pHL2MvYnhIRTVFY0d0?=
 =?utf-8?B?UmVXY2pVLyt3R01xdDUyMnZQVlVSbjdQSlhlQysyTi82QkZIQUF0T3FyOTBl?=
 =?utf-8?B?UzdLTU9CVnRjc053aG5RTXhsdzdUanVMVU5zVGFZTW91Yng3eExsLzdOaHV1?=
 =?utf-8?B?VEgwTDBCUlVMdUhodmU2bm45MFlWSzBpSEo4K09oSVhTRUNyZjBWSVBORFc4?=
 =?utf-8?B?UFc5RkZhalJyS1g2akVHZjUxUjNRTkFIeFJDWExvV2JBWThMeWFIN2FOTWZC?=
 =?utf-8?B?SFQ0cFczVE4rZ2V1ZWJlQ001Zy9IZHoyTkJPajkrRERVTzVPT2lLS1hWZGRn?=
 =?utf-8?B?U0o1M3FXNzZwOVNqRXd2ai83aFQwZzloNWIzcUlWVjZzOTV1d0pFa2lUd2NP?=
 =?utf-8?B?S2QwRGI4a2trRmtMRUl5YWVEaHJLRWJscWFKZzBUdjR1SlNHQ1FVSGtKMVJX?=
 =?utf-8?B?ZTR0aGJVRDE4VjFIbnJQUDJXdzFqR2lDNVY4V29FQzBKbWhGQ1BHV0grbFZ1?=
 =?utf-8?B?bjZTSFIrUmZkZU5ueGR3Z0lncHZVQUJBTmgySVlrUXpZTmdtdXN3Qm9ENmN1?=
 =?utf-8?B?WTIxOGZKWjd3dURkY3czb2lDalk3dHZyYitqYmthTUtqZ1hIVG5tUlA1dW9u?=
 =?utf-8?B?RlZBaElYNWhCeDFxeXJhNDVvZEJaSDJ6UDJVWkNoZEhHRFdjNTk3NXdjQVl5?=
 =?utf-8?B?bkswL2FiQktNRUplenZ5eDZhM0x5cHA0bmQyekxraGNGZnllVGZCbHNBa0Mr?=
 =?utf-8?B?N2l3R2luN21SbnhyWCszaHN6ZW1oTzhuWEVyd0E0NTE5TlU0RU1scjRsbGlC?=
 =?utf-8?B?R1RBa3JSeWJuZzl5dHdnSi9oZTlsOEtDT05SazZWZzh4WGRuNTRZTWJhZ2Yx?=
 =?utf-8?B?OFdRV0tHV3RhelhxY042a2ZBZi9VVGY5MUhzRldDS0tPSmpQZEtIV2ZVbWJv?=
 =?utf-8?B?OU0yNytiU1ZDTUNPT1RMYXJJZE8zT2N3QmxmaUVqUUR1c2pvc2hiSHhCbXBT?=
 =?utf-8?B?TGJlUFN5bTc4cEdIQmFMVVpUOVJxOS85OUJqc1lQbXhuaitERHRMbC9SZkFq?=
 =?utf-8?B?Z0M2M1cyNXB0Z3NRaVhkY1FFbW1SUjNGLzY0ZHo3RWl4OW1yQXFsci9MWE0y?=
 =?utf-8?B?S1ZEdE5EWHFlSUZxQlR2K3hkSDJNQTltN2lsNkhqMVFGbW5PdTBrWkMxQ1Zz?=
 =?utf-8?B?SWJEMUltZGxhTDVVQlpTMXZETU1FUy83TFUxdmdqSXF4a3RaL1lMSDRmYkl3?=
 =?utf-8?B?SFA1M3RzcHB0SmxLWURwTU1nYlJKTUoxN1RnZHV5ZFZQa1Vrb08rMHdBckE3?=
 =?utf-8?B?WUJ5UWprVWExYWI4UzUxazdNUFVCeHkremhhenFHcDR1THNxRTBJUWpySGo1?=
 =?utf-8?Q?AjEAECOiIWTM15XYlKX4GMxUO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7118781D77D5241AD87C43D6E153D1B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02daf015-344f-48aa-5b43-08dcc41fd6ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2024 09:33:40.4176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xzPpCSdxyg367Rf8DgE0hKwVFcEnSU+o5gFMuH8743dTZW04TAfbHI2ZDNyxTDgflJEpPQNXKLixpgaGWyAvtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6497
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA4LTIzIGF0IDE3OjAwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIEF1ZyAyMywgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IA0KPiA+
IA0KPiA+IE9uIDIxLzA4LzIwMjQgMTE6MjcgcG0sIFlvbmdxaWFuZyBMaXUgd3JvdGU6DQo+ID4g
PiBUaGUgZml4ZWQgc2l6ZSB0ZW1wb3JhcnkgdmFyaWFibGVzIHZtY2JfY29udHJvbF9hcmVhIGFu
ZCB2bWNiX3NhdmVfYXJlYQ0KPiA+ID4gYWxsb2NhdGVkIGluIHN2bV9zZXRfbmVzdGVkX3N0YXRl
KCkgYXJlIHJlbGVhc2VkIHdoZW4gdGhlIGZ1bmN0aW9uIGV4aXRzLg0KPiA+ID4gTWVhbndoaWxl
LCBzdm1fc2V0X25lc3RlZF9zdGF0ZSgpIGFsc28gaGF2ZSB2Y3B1IG11dGV4IGhlbGQgdG8gYXZv
aWQNCj4gPiA+IG1hc3NpdmUgY29uY3VycmVuY3kgYWxsb2NhdGlvbiwgc28gd2UgZG9uJ3QgbmVl
ZCB0byBzZXQgR0ZQX0tFUk5FTF9BQ0NPVU5ULg0KPiA+IA0KPiA+IEhpIFNlYW4vUGFvbG8sDQo+
ID4gDQo+ID4gU2VlbXMgbW9yZSBwYXRjaGVzIGFyZSBwb3BwaW5nIHVwIHJlZ2FyZGluZyB0byB3
aGV0aGVyIHRvIHVzZSBfQUNDT1VOVCBmb3INCj4gPiB0ZW1wb3JhcnkgbWVtb3J5IGFsbG9jYXRp
b24uICBDb3VsZCB3ZSBoYXZlIGEgZGVmaW5pdGl2ZSBndWlkZSBvbiB0aGlzPw0KPiANCj4gSWYg
dGhlIGFsbG9jYXRpb25zIGFyZSB0ZW1wb3JhcnksIGUuZy4gc2NvcGVkIHRvIGV4YWN0bHkgb25l
IGZ1bmN0aW9uLCBub3QgbWFzc2l2ZQ0KPiAodXNlIGJlc3QganVkZ21lbnQpLCBhbmQgY2FuJ3Qg
YmUgdXNlZCBpbiBhbnkga2luZCBvZiBub3ZlbCBERG9TIGF0dGFjaywgZS5nLiBhcmUNCj4gbGlt
aXRlZCB0byBvbmUgcGVyIHZDUFUgb3Igc28sIHRoZW4gdGhleSBkb24ndCBuZWVkIHRvIGJlIGFj
Y291bnRlZC4NCj4gDQo+IEF0IGxlYXN0LCB0aGF0J3MgbXkgdGFrZSBvbiB0aGluZ3MuDQoNClRo
YXQgbWFrZXMgc2Vuc2UuICBUaGFua3MuDQo=

