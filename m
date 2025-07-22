Return-Path: <kvm+bounces-53144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1330AB0E012
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 17:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E9176C19EC
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 15:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A6B28CF4A;
	Tue, 22 Jul 2025 15:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m2v+ggoc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3A21F153A;
	Tue, 22 Jul 2025 15:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753196934; cv=fail; b=uQN5awRaaGi/RhtY5hz5eFxe0RDBykCsOMkbPSXx2FPYOmEQrtdKWmcJUPFOyIRoP/NjGLfEfgvNfoCKJsFuuY0Opb3QTyILC/aGOW239PX/yNaqZAxhChtbd2qXYVICjvXCARzM6A75KhnWnZjDN5QpDZZMFqCSVW1GetgTtg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753196934; c=relaxed/simple;
	bh=0rRqogr9R6YRy8cNi5WM8fWeY5LKVlROTHYsYGhNV5o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o0NHsIGymS6CRQiIe3x7rGt4rrs1BnooVnvxprTwDvOq+W9QzV4gN3jQxgvQ7w42XQUeEIWQGh1eJk/PloFp8CeW2vPgy6lTDZVxqOpxWARVBV1UgFcv5TfxbustNOD+88rMTTL5cIElxkOdX/XRIguydQ8P5kJ8BsgwW9/vREI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m2v+ggoc; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753196933; x=1784732933;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0rRqogr9R6YRy8cNi5WM8fWeY5LKVlROTHYsYGhNV5o=;
  b=m2v+ggocPM9oA1cSfkCsSh+wJ8NY9PVOqLGKXUOzX/BjjOwppfV89DTj
   iVk0tTcWCX1YOct/QGYLWdYzTTf8uLXp5MeeSOb4CnkoAT4DxZsLqhoNI
   9FmXCWnvKRimEK8+vRcXRGtAVzP/oLcGlaHRtMFbyLmH0NUKcKp7Vm6gl
   6B6l1/eG50FqgkChZ2cz30Lm9cfwJJl5Ru2o7EiQq3scisjyGzjvvLnp2
   kZAxxV/xClBg51tYj26e+OzfryCf8rYedtfoJRYnS+f+jWLhYAmoycTjb
   EzWaKVK6KsyZTWFA5a2hpBelLNTtLgoAtDQlWisEo6DlgfdIQosgVj/kK
   A==;
X-CSE-ConnectionGUID: gdL2bvMTQTSF8F/iT4g2Yg==
X-CSE-MsgGUID: sZrbOMw5R7Swo3IUuW5rcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55599957"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="55599957"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 08:08:53 -0700
X-CSE-ConnectionGUID: Op20hzwKSbaVJFqi78JFAQ==
X-CSE-MsgGUID: +JbzJDX0RsiZQfGtqxQSTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="190134146"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 08:08:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 08:08:51 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 22 Jul 2025 08:08:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.88)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 22 Jul 2025 08:08:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZk7v2dIn/og24xF6wWa20no6cP+X7+ztuXxX95apnsii/VvexF7T3zN/NCsnEl8rTC6957adkIhdgasykA/VDeZy2v2wd2YDFadsH/eEK3YSfBokQuFlSUgofpGwq04JQDLZrRAbkigCYbvo0eZyxRjThXTFhx74E5qoOxdnQBimTmn1tVTrk30Z6UdBQObLpRl+3WPS8yCwZLhlvhF/02c4Hj/FDOLHSqM3faKh2X0a8sewzEhF80SBR83IELCq5YAyI3RKIOPuEI5f1kRXU4qEsvKK6StQWZ2ceLJu+rU9fDmeVsWJRNMl9FxVZmhpT0sucMyk4Gng5XDK4UAxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0rRqogr9R6YRy8cNi5WM8fWeY5LKVlROTHYsYGhNV5o=;
 b=sTTXmSCgAqkUH3J6nljNYbFrr8tJ6AmnxfWvuz7EPYoZaXQpn6yV1DeOIsZwlBXSyosQY3Kb5s16ZYWjZHqYlkRFRsAmwZBfm+I1H5d4i/3kmdpwi/2XlGKafohO70+1sJ5XDsFPaxCdRcDtV1XWGR2Z8x2gyD48ptfyFnihuiQSLZdZZph6d7RegNN0qF/k6voazSTS9CLK3He6VVQ1fgVJB8fMktOqb/RF3ssvL85nvtSQWdc0ttzdnPqwFU5n1BUy+uFswD1jLZ10P7iR6pPDoFj1VsG34les5ToZd3vh95mzp6HGPsgmKRRoVOseTDBx1+fdimYxoi0VcdqWQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB4972.namprd11.prod.outlook.com (2603:10b6:806:fb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 15:08:43 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 15:08:43 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Luck, Tony" <tony.luck@intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de"
	<bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH V3 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Thread-Topic: [PATCH V3 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Thread-Index: AQHb+wrgu/rGOAUQREeRbq8uTT2N6LQ+Pu8A
Date: Tue, 22 Jul 2025 15:08:43 +0000
Message-ID: <677013fe62bfa7e3382a288d4a928a8a980df245.camel@intel.com>
References: <20250722131533.106473-1-adrian.hunter@intel.com>
	 <20250722131533.106473-3-adrian.hunter@intel.com>
In-Reply-To: <20250722131533.106473-3-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB4972:EE_
x-ms-office365-filtering-correlation-id: 76cf7dc0-756a-4039-0ad1-08ddc931a5f8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TVZ1YnJkaEdsRGFSOFlWcE9FQmcwNmpyRzdHRHN5Vnd5N2t4RUNQQmJXMjJi?=
 =?utf-8?B?bnBoVDNCOVZtQk44SU5ScGc4cmpTOEZsbm9QMlh2aFpwQ3RMRGNTUTVCam9G?=
 =?utf-8?B?UldQcnNoL3BGTGo0eXFNMUsyTTJGMVRCSE1Tb1g1S0h6VURGL0NjN2FybTN5?=
 =?utf-8?B?RUtmQTUrdFFSYlpxMmVrTS9hOFc5WVo1Y0NvKzhlanI0QzlVYW1nODNGaW5X?=
 =?utf-8?B?bzhjb0NQUEJpZkFicE9BMnRzSUJWZSs3S016OThxTjUwMHYxWkkvZDRxWkRW?=
 =?utf-8?B?QVJwLzBhQjkzcFE3eEFQTEc2cFg1Y0JqUzdVRW0xbmU1NlRzd0R6SmhJbjcv?=
 =?utf-8?B?SXVqUEpReGo2cGkzRXNwMHNrdUl1ejZ1WDlUTjNXYUhTMjFzVUcxU2pmb0Nl?=
 =?utf-8?B?MDEzbnlqdHd4emdmeldJZGx2Ym81ZjM1bTR1Z3U2UllqaUQ2QnVWVDF3cEQr?=
 =?utf-8?B?Z1lVSVpnMVIzUkhmT0V3bit4Ymx0N1U1ZXRyRU83VkxwNzNlcEdCTWNqelRQ?=
 =?utf-8?B?OTJPOWtYSU1qVUVrcGk3Sk5FOUUwbmttYnZ0RjdlbWpoelZLdnlSU3R1U09t?=
 =?utf-8?B?Tmh0RllEMGsybUFVYTZ0NUNnditVN2JTMkkxbjBzRnlTNGsyWlUrMk1haE1J?=
 =?utf-8?B?ZGdTVm5MMFZ0eUlVV1hmRjJqVkRJZkdLVzFXektGNEsxOXYwd01XMkZsNVg0?=
 =?utf-8?B?eExNWkllVU1rejQrODdkaFdjWmgrOTdIdkNrYlFqZlVsWG9CZ1N0c1FEM1Fs?=
 =?utf-8?B?TE5XZi9jY2lrS1RYMzI0eVZ1aGRvY3JuOUNocXhCdDVWeDRoT2I1dWc3MjR0?=
 =?utf-8?B?V0NtU1laREtkZm54ZFV1aDlKdTBLNytXQk5MMXkxdW1GZzJJZG9QbTIwR1pL?=
 =?utf-8?B?NU1yTkd3WlZMY0hWQldDMUhDTEVQVVVkMUc1WnR4L0doNUM0MUpxSVBGUXpM?=
 =?utf-8?B?SGtkcnZpeDMza2M3d2NNdzlXdHgrZ1RDVmhHNGZ3S210UUdFZjU2aWF0R1pU?=
 =?utf-8?B?OWFOZ0hidyt6VWJPdGk4Y2xRMVU2Q0RSdTk3RGc4d1MrWFA2QVNOUGNLRU1G?=
 =?utf-8?B?TTg5UWQxV2Qxb2swOFV0TEJIQnA0VndxQjNEZ29jcWt3b0dqM0ZuNWUycFpV?=
 =?utf-8?B?WGs1MTNDYlNSZXFDTmcwR2tMYXR3aStmRENuRGFQalBTczBhMGhFR2lIYm0w?=
 =?utf-8?B?ZlhMRHZTc09VQk1VU000S1JXUE5uL1g1RS9rRWpwcWd1VHQ1bUlScmxXT1pt?=
 =?utf-8?B?KzhqVjVhbmtSYlZVcy9oWjUxQXBvWVVnUStybmNuY2pQK0VHdHhvVkN5ZjhK?=
 =?utf-8?B?R2toRi9uNGdDd3hkQUVDbTJWY0NHNC9XeTV5clVocXBkN1V6T0ltSUhhdm0z?=
 =?utf-8?B?S0dwR2o2Y0VGbWhZR1FEZGNmaHdMcDMyRjJVMTlLM2d1dTJDZ21HZXJpaHZD?=
 =?utf-8?B?emZPRFlQd0NvZHMrR3NLNUhDcUloYmZsTkYrV3lSUnRlZmZ0Ri9yblpmWko0?=
 =?utf-8?B?WWVBTXh2Yko4Zm41a0JiblNZdjUyWitpVFk0NGNmZ0JCRnVqYnJpRXo0UGJU?=
 =?utf-8?B?SldUQ3lSS2wxZkl3VEFONlhkMmt0cDJsaHdLZ21TaFZ5L25zWkQ0V2tSbjhp?=
 =?utf-8?B?YVFzTUYyNHhIUjF2RmpTa0JiM2xqVFNocnpZMitucUMvSTZCSGtMdU5odFRL?=
 =?utf-8?B?N2c2SVE5OEh6YkxVNHVOQUxqdUJzVmhCRW9aazREVjVPMUg4dStiWUtkZk11?=
 =?utf-8?B?Y1pucjhJZ0xzanJsVVZZRHFCTDgzU0FyQ3F4bjJxRFZyeUN6VzRWRG9vUlhm?=
 =?utf-8?B?NnlubGVWTytDNW9HWngyMWRRdWhleGFjMEtvNjd6R0s1T3RpMG42azNjVno3?=
 =?utf-8?B?NjM3VjVZZUxBN0MrK2tSM0U2ZGNaemVud1pZNUR0Q29rbEFUS1dvQVE1dWxw?=
 =?utf-8?B?RG5oZnZDZ2Q3K1NpcUJOUzhaalRmUDE1aXJVQStncHM1RDFXbkdHV051UEN2?=
 =?utf-8?Q?uYGfXXt+I92mJYz86bDy8FXptbpwzM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUU1bFpEeThMckNWOU95UkNLUzUyNFo1dVpyV2xqNmsxZ0lIQWx6QVlBeXdT?=
 =?utf-8?B?YUIrVjRrZ2l6RGxnRkhoYzhzN1BRZUFCdGRzeVRQL2VMb1g0ZmxDeExIYWE0?=
 =?utf-8?B?Y3BtMkFGcWdZcVMwZUlBMmN2NUgycHJsRDdKUUc5eXdkdkFoUkhlNlFidUhQ?=
 =?utf-8?B?bU00dTB2N1lsck9yS0VjUlYvMVV3UWlXQXZpK0RQc0RRckFGYVc2dnpDTUZq?=
 =?utf-8?B?by9iN3NhVnpKRjlDajk3UlFtbHFVcm52MzZ4YU1OaEp0Y1oyeHJZUVd0czNC?=
 =?utf-8?B?UFgyTEI3OXkzWE56VWNITVBFa3Q5NUNneHN6dDJpRXhUT2tkS2xTNGd3ejUx?=
 =?utf-8?B?aEc5SnNDdlhGV3p1c2FCSEtFT09BeXRrMS9YK0NnejBhbS92RGdiRGhSNzZn?=
 =?utf-8?B?U3ZJc3BDMWhWeGU2YTU3dFplR3pGSVcydDAyaHZuc2NVNXlSeFg3T0MxdE10?=
 =?utf-8?B?cDZuSGlZWTZKbGRrL3N2YXNVYVlKWkdCL3VHcnd5clJEalNnNWFVRjJGcmtM?=
 =?utf-8?B?L0FXZlJlY2MvemtoOGZ1UXNURFMzS0p5K1lqd29HRmluTlJXVCt6bGhIUkFq?=
 =?utf-8?B?dGZKbU81QitRdkhwS3J3VkliemZBamdZUWV1cVVMMithT3BUUm5nVGtHcTc0?=
 =?utf-8?B?cGJsV293RG1FYjdaeUR0MitBeEd6bFVKbm42QWxJWXk4Y3ZrWGtrVlQ2NHVQ?=
 =?utf-8?B?L2pIQ3F0elRwbmQzVjBmaWpiNW1Ca1NPY1UxTXRkSGhxN1hZR3F2ZDZBRVhC?=
 =?utf-8?B?YUcxcFZXY0F0MTBWR1g3MFpnbVZWRGJpdHRNTFdnTm4vd3pSd05CWVhvMU41?=
 =?utf-8?B?WWkxemgrVDY4c3pvVDBlRlJLVVZ3N2ZCL3RUQ3g3M3F4VVNzWlVyNVZTbnp0?=
 =?utf-8?B?UmZzTCtnTmFiNnJ6MlpwdFJmSWpEN1htbjNrdkY4TlZJT1JTWEFJWjUrNy92?=
 =?utf-8?B?dndwcDg3SGVOVWkxejNkWUdQdEUwS21nZFJ0bmdMRHVHZ20xZ3BBMFREQWZI?=
 =?utf-8?B?V1g5cENYUUpCZ3pOZXdJN2ZSd05zOHVVZHh3UjhWMEdLTUNpOU9xU0dpNERh?=
 =?utf-8?B?R2JGWUJLQy9waFhCK1dLWWFsMkw5T3RHd3cwM055RWJPWTNtZ1poQlBJdEdK?=
 =?utf-8?B?RlcvdlIxOUkwZkR0MDNXZFpFZVhWWDhGcExSSUFkNEUvZGtPQmwwRUcwbjNK?=
 =?utf-8?B?SXFSek9SMXpUSHk4K29OcG9ENklKZ3VoSXFGWnJVdmMrbmFrV3hML21NUmxl?=
 =?utf-8?B?THNRQzlaMzl6bnJvYy9BZVlRZ3VlTjRLS0s0OFU5Y3B0Q3diYzc0WUp3Z1M5?=
 =?utf-8?B?UXdQdnE0UnlJNkd2UkRMNFpTM2tka2kyNTc1NkN3Q0Vid3p4WHBoQWFSY1Vo?=
 =?utf-8?B?c3IxKy9URXBnRFVLSjFiSWRlS0VNRFZBZXk3U0N1SXlycndLeVdIcThLMjRH?=
 =?utf-8?B?SktCOXJsK2IzMjQ0eHQ4Z0hVRTlvYmI0NE1QcE1lT1VFczlnN29KaklPUTIw?=
 =?utf-8?B?dU14T1I4a2htSFJ2RmtuTWd0T1BIVFkyME9xUWZqUlduWVJzV096Y08zK1N4?=
 =?utf-8?B?UXk5OFRWMUxEWFJkTUo5eFlTS0plamgxVThLSTJVTms2SGhyS2NFdWlIa0JD?=
 =?utf-8?B?T1FBc1lBUFZqRklFUkRsSjY3aHUrMXBIK2dnUXQ1NFZ2NlprSSs4ejhZSFcw?=
 =?utf-8?B?cW93QmpYUVY3ZGd6ZHRIVk0zMC80emp0Unp4YW5LNGo3RHhaRnZIbk8zNXZq?=
 =?utf-8?B?bURPVld0ODlQYndBakQvNlNrMlBVdEdQeHVTQVRjVkVpQWxkT2FwWkxlRDhW?=
 =?utf-8?B?bUFCVlpkaWFkcFc2OGl0bDRqcnB6K2lsL1dNWDFMaERKUmFZWVNnTHBERGR1?=
 =?utf-8?B?anFyd2NtUmszUEhqbUVYWXhwQzVMM2RHVDNQcmJnSUlHQVFGMHBTVFJFMU1O?=
 =?utf-8?B?Ym56SlRKc3padVlwR0ZFUm9MMksyZC9MdGdPZkhncU5PUHFRY1ovVVlvS2s3?=
 =?utf-8?B?d0hST1V5bHVkRFRRK3FpcUxhaGl0bXpqaVI5cW1XdmZBL1dMTkRTQVQyV3N0?=
 =?utf-8?B?V1hMb0tPQ3JqMzZ6TUFpRWhKVkhTTFNiWkp3YmhRb1J5Y0RmSVpIQkJweHhL?=
 =?utf-8?B?WHkwL0piMXNCTmhlSDBKNGFaZDJCem9teFBLcThTZ1pKK1ZzT3hCU2lOWFJJ?=
 =?utf-8?B?Znc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D329A7EE1F4BE4DB9AD95A861814F44@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76cf7dc0-756a-4039-0ad1-08ddc931a5f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2025 15:08:43.1021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a5A4mWbndexs606EuD39HQoUr1Spb+odVZQxcIpTEs0tDe234hD2wBEiwtXtJiL36hw+MozD6i7uI+xTT7vrbVLorwfpdtlFOuVcC1usuRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4972
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTIyIGF0IDE2OjE1ICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBBdm9pZCBjbGVhcmluZyByZWNsYWltZWQgVERYIHByaXZhdGUgcGFnZXMgdW5sZXNzIHRoZSBw
bGF0Zm9ybSBpcyBhZmZlY3RlZA0KPiBieSB0aGUgWDg2X0JVR19URFhfUFdfTUNFIGVycmF0dW0u
IFRoaXMgc2lnbmlmaWNhbnRseSByZWR1Y2VzIFZNIHNodXRkb3duDQo+IHRpbWUgb24gdW5hZmZl
Y3RlZCBzeXN0ZW1zLg0KPiANCj4gQmFja2dyb3VuZA0KPiANCj4gS1ZNIGN1cnJlbnRseSBjbGVh
cnMgcmVjbGFpbWVkIFREWCBwcml2YXRlIHBhZ2VzIHVzaW5nIE1PVkRJUjY0Qiwgd2hpY2g6DQo+
IA0KPiAgICAtIENsZWFycyB0aGUgVEQgT3duZXIgYml0ICh3aGljaCBpZGVudGlmaWVzIFREWCBw
cml2YXRlIG1lbW9yeSkgYW5kDQo+ICAgICAgaW50ZWdyaXR5IG1ldGFkYXRhIHdpdGhvdXQgdHJp
Z2dlcmluZyBpbnRlZ3JpdHkgdmlvbGF0aW9ucy4NCj4gICAgLSBDbGVhcnMgcG9pc29uIGZyb20g
Y2FjaGUgbGluZXMgd2l0aG91dCBjb25zdW1pbmcgaXQsIGF2b2lkaW5nIE1DRXMgb24NCj4gICAg
ICBhY2Nlc3MgKHJlZmVyIFREWCBNb2R1bGUgQmFzZSBzcGVjLiAxNi41LiBIYW5kbGluZyBNYWNo
aW5lIENoZWNrDQo+ICAgICAgRXZlbnRzIGR1cmluZyBHdWVzdCBURCBPcGVyYXRpb24pLg0KDQox
Ni41IGNvdWxkIG1vdmUgYXJvdW5kLiBXZSBwcm9iYWJseSB3YW50IHRvIHB1dCB0aGUgZGF0ZSwg
b3IgZG9jdW1lbnQgdmVyc2lvbg0KbGlrZSAoMzQ4NTQ5LTAwNlVTKS4NCg0KPiANCj4gVGhlIFRE
WCBtb2R1bGUgYWxzbyB1c2VzIE1PVkRJUjY0QiB0byBpbml0aWFsaXplIHByaXZhdGUgcGFnZXMg
YmVmb3JlIHVzZS4NCj4gSWYgY2FjaGUgZmx1c2hpbmcgaXMgbmVlZGVkLCBpdCBzZXRzIFREWF9G
RUFUVVJFUy5DTEZMVVNIX0JFRk9SRV9BTExPQy4NCj4gSG93ZXZlciwgS1ZNIGN1cnJlbnRseSBm
bHVzaGVzIHVuY29uZGl0aW9uYWxseSwgcmVmZXIgY29tbWl0IDk0YzQ3N2E3NTFjN2INCj4gKCJ4
ODYvdmlydC90ZHg6IEFkZCBTRUFNQ0FMTCB3cmFwcGVycyB0byBhZGQgVEQgcHJpdmF0ZSBwYWdl
cyIpDQo+IA0KPiBJbiBjb250cmFzdCwgd2hlbiBwcml2YXRlIHBhZ2VzIGFyZSByZWNsYWltZWQs
IHRoZSBURFggTW9kdWxlIGhhbmRsZXMNCj4gZmx1c2hpbmcgdmlhIHRoZSBUREguUEhZTUVNLkNB
Q0hFLldCIFNFQU1DQUxMLg0KPiANCj4gUHJvYmxlbQ0KPiANCj4gQ2xlYXJpbmcgYWxsIHByaXZh
dGUgcGFnZXMgZHVyaW5nIFZNIHNodXRkb3duIGlzIGNvc3RseS4gRm9yIGd1ZXN0cw0KPiB3aXRo
IGEgbGFyZ2UgYW1vdW50IG9mIG1lbW9yeSBpdCBjYW4gdGFrZSBtaW51dGVzLg0KPiANCj4gU29s
dXRpb24NCj4gDQo+IFREWCBNb2R1bGUgQmFzZSBBcmNoaXRlY3R1cmUgc3BlYy4gZG9jdW1lbnRz
IHRoYXQgcHJpdmF0ZSBwYWdlcyByZWNsYWltZWQNCj4gZnJvbSBhIFREIHNob3VsZCBiZSBpbml0
aWFsaXplZCB1c2luZyBNT1ZESVI2NEIsIGluIG9yZGVyIHRvIGF2b2lkDQo+IGludGVncml0eSB2
aW9sYXRpb24gb3IgVEQgYml0IG1pc21hdGNoIGRldGVjdGlvbiB3aGVuIGxhdGVyIGJlaW5nIHJl
YWQNCj4gdXNpbmcgYSBzaGFyZWQgSEtJRCwgcmVmZXIgQXByaWwgMjAyNSBzcGVjLiAiUGFnZSBJ
bml0aWFsaXphdGlvbiIgaW4NCj4gc2VjdGlvbiAiOC42LjIuIFBsYXRmb3JtcyBub3QgVXNpbmcg
QUNUOiBSZXF1aXJlZCBDYWNoZSBGbHVzaCBhbmQNCj4gSW5pdGlhbGl6YXRpb24gYnkgdGhlIEhv
c3QgVk1NIg0KPiANCj4gVGhhdCBpcyBhbiBvdmVyc3RhdGVtZW50IGFuZCB3aWxsIGJlIGNsYXJp
ZmllZCBpbiBjb21pbmcgdmVyc2lvbnMgb2YgdGhlDQo+IHNwZWMuIEluIGZhY3QsIGFzIG91dGxp
bmVkIGluICJUYWJsZSAxNi4yOiBOb24tQUNUIFBsYXRmb3JtcyBDaGVja3Mgb24NCj4gTWVtb3J5
IiBhbmQgIlRhYmxlIDE2LjM6IE5vbi1BQ1QgUGxhdGZvcm1zIENoZWNrcyBvbiBNZW1vcnkgUmVh
ZHMgaW4gTGkNCj4gTW9kZSIgaW4gdGhlIHNhbWUgc3BlYywgdGhlcmUgaXMgbm8gaXNzdWUgYWNj
ZXNzaW5nIHN1Y2ggcmVjbGFpbWVkIHBhZ2VzDQo+IHVzaW5nIGEgc2hhcmVkIGtleSB0aGF0IGRv
ZXMgbm90IGhhdmUgaW50ZWdyaXR5IGVuYWJsZWQuIExpbnV4IGFsd2F5cyB1c2VzDQo+IEtleUlE
IDAgd2hpY2ggbmV2ZXIgaGFzIGludGVncml0eSBlbmFibGVkLiBLZXlJRCAwIGlzIGFsc28gdGhl
IFRNRSBLZXlJRA0KPiB3aGljaCBkaXNhbGxvd3MgaW50ZWdyaXR5LCByZWZlciAiVE1FIFBvbGlj
eS9FbmNyeXB0aW9uIEFsZ29yaXRobSIgYml0DQo+IGRlc2NyaXB0aW9uIGluICJJbnRlbCBBcmNo
aXRlY3R1cmUgTWVtb3J5IEVuY3J5cHRpb24gVGVjaG5vbG9naWVzIiBzcGVjDQo+IHZlcnNpb24g
MS42IEFwcmlsIDIwMjUuIFNvIHRoZXJlIGlzIG5vIG5lZWQgdG8gY2xlYXIgcGFnZXMgdG8gYXZv
aWQNCj4gaW50ZWdyaXR5IHZpb2xhdGlvbnMuDQo+IA0KPiBUaGVyZSByZW1haW5zIGEgcmlzayBv
ZiBwb2lzb24gY29uc3VtcHRpb24uIEhvd2V2ZXIsIGluIHRoZSBjb250ZXh0IG9mDQo+IFREWCwg
aXQgaXMgZXhwZWN0ZWQgdGhhdCB0aGVyZSB3b3VsZCBiZSBhIG1hY2hpbmUgY2hlY2sgYXNzb2Np
YXRlZCB3aXRoIHRoZQ0KPiBvcmlnaW5hbCBwb2lzb25pbmcuIE9uIHNvbWUgcGxhdGZvcm1zIHRo
YXQgcmVzdWx0cyBpbiBhIHBhbmljLiBIb3dldmVyDQo+IHBsYXRmb3JtcyBtYXkgc3VwcG9ydCAi
U0VBTV9OUiIgTWFjaGluZSBDaGVjayBjYXBhYmlsaXR5LCBpbiB3aGljaCBjYXNlDQo+IExpbnV4
IG1hY2hpbmUgY2hlY2sgaGFuZGxlciBtYXJrcyB0aGUgcGFnZSBhcyBwb2lzb25lZCwgd2hpY2gg
cHJldmVudHMgaXQNCj4gZnJvbSBiZWluZyBhbGxvY2F0ZWQgYW55bW9yZSwgcmVmZXIgY29tbWl0
IDc5MTFmMTQ1ZGU1ZmUgKCJ4ODYvbWNlOg0KPiBJbXBsZW1lbnQgcmVjb3ZlcnkgZm9yIGVycm9y
cyBpbiBURFgvU0VBTSBub24tcm9vdCBtb2RlIikNCj4gDQo+IEltcHJvdmVtZW50DQo+IA0KPiBC
eSBza2lwcGluZyB0aGUgY2xlYXJpbmcgc3RlcCBvbiB1bmFmZmVjdGVkIHBsYXRmb3Jtcywgc2h1
dGRvd24gdGltZQ0KPiBjYW4gaW1wcm92ZSBieSB1cCB0byA0MCUuDQo+IA0KPiBPbiBwbGF0Zm9y
bXMgd2l0aCB0aGUgWDg2X0JVR19URFhfUFdfTUNFIGVycmF0dW0gKFNQUiBhbmQgRU1SKSwgY29u
dGludWUNCj4gY2xlYXJpbmcgYmVjYXVzZSB0aGVzZSBwbGF0Zm9ybXMgbWF5IHRyaWdnZXIgcG9p
c29uIG9uIHBhcnRpYWwgd3JpdGVzIHRvDQo+IHByZXZpb3VzbHktcHJpdmF0ZSBwYWdlcywgZXZl
biB3aXRoIEtleUlEIDAsIHJlZmVyIGNvbW1pdCAxZTUzNmUxMDY4OTcwDQo+ICgieDg2L2NwdTog
RGV0ZWN0IFREWCBwYXJ0aWFsIHdyaXRlIG1hY2hpbmUgY2hlY2sgZXJyYXR1bSIpDQo+IA0KDQpS
ZXZpZXdlZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K
DQo+IFJldmlld2VkLWJ5OiBLaXJpbGwgQS4gU2h1dGVtb3YgPGthc0BrZXJuZWwub3JnPg0KPiBB
Y2tlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBBZHJpYW4gSHVudGVyIDxhZHJpYW4uaHVudGVyQGludGVsLmNvbT4NCj4gLS0tDQo+IA0KPiAN
Cj4gQ2hhbmdlcyBpbiBWMzoNCj4gDQo+IAlSZW1vdmUgImZsdXNoIGNhY2hlIiBjb21tZW50cyAo
UmljaykNCj4gCVVwZGF0ZSBmdW5jdGlvbiBjb21tZW50IHRvIGJldHRlciByZWxhdGUgdG8gInF1
aXJrIiBuYW1pbmcgKFJpY2spDQo+IAlBZGQgInZpYSBNT1ZESVI2NEIiIHRvIGNvbW1lbnQgKFhp
YW95YW8pDQo+IAlBZGQgUmV2J2QtYnksIEFjaydkLWJ5IHRhZ3MNCj4gDQo+IENoYW5nZXMgaW4g
VjI6DQo+IA0KPiAJSW1wcm92ZSB0aGUgY29tbWVudA0KPiANCj4gDQo+ICBhcmNoL3g4Ni92aXJ0
L3ZteC90ZHgvdGR4LmMgfCAxMCArKysrKysrLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNl
cnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3Zp
cnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBpbmRleCAx
NGQ5M2VkMDViZDIuLmE1NDJlNGZiZjVhOCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvdmlydC92
bXgvdGR4L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBAQCAt
NjMzLDE1ICs2MzMsMTkgQEAgc3RhdGljIGludCB0ZG1yc19zZXRfdXBfcGFtdF9hbGwoc3RydWN0
IHRkbXJfaW5mb19saXN0ICp0ZG1yX2xpc3QsDQo+ICB9DQo+ICANCj4gIC8qDQo+IC0gKiBDb252
ZXJ0IFREWCBwcml2YXRlIHBhZ2VzIGJhY2sgdG8gbm9ybWFsIGJ5IHVzaW5nIE1PVkRJUjY0QiB0
bw0KPiAtICogY2xlYXIgdGhlc2UgcGFnZXMuICBOb3RlIHRoaXMgZnVuY3Rpb24gZG9lc24ndCBm
bHVzaCBjYWNoZSBvZg0KPiAtICogdGhlc2UgVERYIHByaXZhdGUgcGFnZXMuICBUaGUgY2FsbGVy
IHNob3VsZCBtYWtlIHN1cmUgb2YgdGhhdC4NCj4gKyAqIENvbnZlcnQgVERYIHByaXZhdGUgcGFn
ZXMgYmFjayB0byBub3JtYWwgYnkgdXNpbmcgTU9WRElSNjRCIHRvIGNsZWFyIHRoZXNlDQo+ICsg
KiBwYWdlcy4gVHlwaWNhbGx5LCBhbnkgd3JpdGUgdG8gdGhlIHBhZ2Ugd2lsbCBjb252ZXJ0IGl0
IGZyb20gVERYIHByaXZhdGUgYmFjaw0KPiArICogdG8gbm9ybWFsIGtlcm5lbCBtZW1vcnkuIFN5
c3RlbXMgd2l0aCB0aGUgWDg2X0JVR19URFhfUFdfTUNFIGVycmF0dW0gbmVlZCB0bw0KPiArICog
ZG8gdGhlIGNvbnZlcnNpb24gZXhwbGljaXRseSB2aWEgTU9WRElSNjRCLg0KPiAgICovDQo+ICB2
b2lkIHRkeF9xdWlya19yZXNldF9wYWRkcih1bnNpZ25lZCBsb25nIGJhc2UsIHVuc2lnbmVkIGxv
bmcgc2l6ZSkNCj4gIHsNCj4gIAljb25zdCB2b2lkICp6ZXJvX3BhZ2UgPSAoY29uc3Qgdm9pZCAq
KXBhZ2VfYWRkcmVzcyhaRVJPX1BBR0UoMCkpOw0KPiAgCXVuc2lnbmVkIGxvbmcgcGh5cywgZW5k
Ow0KPiAgDQo+ICsJaWYgKCFib290X2NwdV9oYXNfYnVnKFg4Nl9CVUdfVERYX1BXX01DRSkpDQo+
ICsJCXJldHVybjsNCj4gKw0KPiAgCWVuZCA9IGJhc2UgKyBzaXplOw0KPiAgCWZvciAocGh5cyA9
IGJhc2U7IHBoeXMgPCBlbmQ7IHBoeXMgKz0gNjQpDQo+ICAJCW1vdmRpcjY0YihfX3ZhKHBoeXMp
LCB6ZXJvX3BhZ2UpOw0KDQo=

