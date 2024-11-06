Return-Path: <kvm+bounces-31033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0F6F9BF7CD
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 21:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BF271C2129C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 20:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C46B20BB2A;
	Wed,  6 Nov 2024 20:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g+7f/H3b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBC820ADDA;
	Wed,  6 Nov 2024 20:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730923588; cv=fail; b=qNxkkNOvHgD0CtB+fDcIJNF/Cn4Ss2RUhspy7CNByvJ075FsFkQ7StVSdgIrH5SIgRWoG0OzIgjC9KkaFDID4BhhkSQehFnHuNFHH3o/GTYmMKjuh0mMi0iFcdsJ5W+oEdi56I818hy6mTQVlScPg/ogQEoDFvEOz1B5GxYofOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730923588; c=relaxed/simple;
	bh=m0GoPyU4n0s+QqqHdrlqMscniDYG+h4FY1s4fsRBpxI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RkPaPcAlxmdNnYd5VtHHmSH194HYJ5h73Cgaegkw9xyT5vAHuhqOrPAaAGqFJtDO1SlehuF31rbaJQKhkwNFRWAo4MabzMK1fN6ZGuhdRAA8Qhj2w6e48P60BLzZzjsUIFj5TXAda2v/TTCdtRzz8lUeu30JWRN5D8zxI1uB6Ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g+7f/H3b; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730923586; x=1762459586;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=m0GoPyU4n0s+QqqHdrlqMscniDYG+h4FY1s4fsRBpxI=;
  b=g+7f/H3bzp3loVLq3zlYKZ4VMfXLqsvjYPTPL+mbcTZjuTma6GVc5MfT
   zt5Nx4/nj7LKGfxUaI5TiZDtVZvij8SELZ4ioFhh+Q9x0gEBgZQZPwiYp
   iGqtgQb11rdRgkzLSNSFNwBOjiOfgz1lt55itr+JiwGYOCMavYsoToedU
   OKeyKkbGgzXvc2EqMDioTTwBmmOGSwe5h4aASefS1WGUSDXkbbJ5Fr7qh
   nDaeCM1F9UjvKAKf+t6oGtVq+cCUNEkIcAcwpFyDF9MgelqvUlhuH3o3R
   H/B7R/4vMxN1hN79lsIJrO/Ngx1PcE1Um/rtKfduji1rKtEATlzJali2V
   A==;
X-CSE-ConnectionGUID: UaYzro+gSQaMqgq1hz9+tQ==
X-CSE-MsgGUID: Jt+yLw7FRROz03l/QA50+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41844656"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41844656"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 12:06:17 -0800
X-CSE-ConnectionGUID: V+yFxpSrQUm8u6KTf0304Q==
X-CSE-MsgGUID: ltTuryWNQlipAAh1KQHwYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="122256689"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 12:06:16 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 12:06:16 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 12:06:16 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 12:06:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FWkzi+/YWtOZU18N2uiULhQcpo+igfCSI6AJqKLw5wgaQzi5WsFqO8rbrn6C0Jxy8nuLarLLVB0Ir8VpsKqy7WLvyhnGDQk8hdmW9zLzTzBT9UPaIAoRR/NL6L+9NZ4L9icy4JsLHFeKfdpC8HdyI4ce0oMwjNRH6o0uk445VuvrnoFF1JonYAc9NGP69oKDdZAr3dGtKwb1PTvIYt9Kh2icDB65+24a0ZhNaontq+v2tlwAffavugzek1zfGWcuhQjXWV2UjcAxD9tHqBNESOpyoqvVRQuYbC9kHCkpyz3LbmxrUn7dP+mUW6usR15+k6C9AJo8SbDO5hkb+DbHAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0GoPyU4n0s+QqqHdrlqMscniDYG+h4FY1s4fsRBpxI=;
 b=wu6Y7xXAN08B1u2d6wCYjGzEkTUJZJoFT4mz4NHBtp903ml8RTGC3cn84ILWWFUehAnmVhAKYFGBgZfaMMv3iiY8DBlWinwegp8z1j4VCt+YQsj0ReIVhGx70O+xvwY2S90sl7qDOks8Lct2aPUbekMheMickyCmcUuqqUbNTp4BufgCG7Q6QjwJU393gUbDIpmIy851XEGOJCA0yH0KUyanvBq7OWdMFDnqPwsRDYiRaFFsnOkS0k+69xbIFjAC2uvrdzJKIRSyxJ3mOB4pgUIe2JiCxCVqMMH/loh3dM+urgvvH4Gz2tT0swtUoiDNlJh+tmnad9HUyJtr32KAmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 20:06:12 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%4]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 20:06:11 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Lindgren, Tony" <tony.lindgren@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kristen@linux.intel.com"
	<kristen@linux.intel.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Topic: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Index: AQHbKTw/9pTudzVvXkeM2HJfNrr8zbKfa8kAgAFOlYCAAJhngIAIzdEAgABGW4CAAFU6gA==
Date: Wed, 6 Nov 2024 20:06:11 +0000
Message-ID: <2d69e11d8afc90e16a2bed5769f812663c123c14.camel@intel.com>
References: <cover.1730120881.git.kai.huang@intel.com>
	 <f7394b88a22e52774f23854950d45c1bfeafe42c.1730120881.git.kai.huang@intel.com>
	 <ZyJOiPQnBz31qLZ7@google.com>
	 <46ea74bcd8eebe241a143e9280c65ca33cb8dcce.camel@intel.com>
	 <ZyPnC3K9hjjKAWCM@google.com>
	 <37f497d9e6e624b56632021f122b81dd05f5d845.camel@intel.com>
	 <ZyuDgLycfadLDg3A@google.com>
In-Reply-To: <ZyuDgLycfadLDg3A@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|CY8PR11MB7134:EE_
x-ms-office365-filtering-correlation-id: 4d635bdd-b993-4402-14a9-08dcfe9e75f8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OGllTnZOSWE5bzFwSkZWU015Z29jK2FHWjAreXRHWFhvZUpxYWRnYUFxYzZM?=
 =?utf-8?B?WEJjWFNkOHA3R1grWUpLTXFyQm9kcDBqcFp1NEdkUmZING9LZTVmRERmUU4v?=
 =?utf-8?B?NDdmMEcxZUo3SjR5dUV2RUhHUjdzYUJac0xzQ2EwdFVwTWZPOXBmeTJSVFBN?=
 =?utf-8?B?LzBlLy9kRHFGOGhMOThjZE1HVkl3V05VSzZvdDFQS1ZUVEM0bmxQOHRmL2E1?=
 =?utf-8?B?NlR0cDJEbG8vdHMwNkVvWk0vWTFtVmo0WXdnb05QN3hQV1NuTHBWeTF3Qk01?=
 =?utf-8?B?dFNUQmlXdC9YdlEvKzN6VDVCaG1USzVNajZsNS9RT1hUbjl1VlFaTTI5cVg2?=
 =?utf-8?B?R3JISUZPcSttMG9RY2tyalRZTVNVbEh5VktzaDBhVGlJMHBjVjFHOUlwU1dO?=
 =?utf-8?B?NGR4YnFpUURZNWdGRHg5NzFTdXd4c3FLRkRYUDJ2TUVCZzRDeXozKy9COE9l?=
 =?utf-8?B?SFRGaXg2YTgxRjlnYjFZRGdsOUc4T2JKWm5DRWd4bEdoeGtEYWh3VnJCSm5x?=
 =?utf-8?B?WGs3SkkvWjZVZStDdHRrNTZVUXRVVTBYTklaeWtDS2VtdHIzbU5sZWx6UitQ?=
 =?utf-8?B?ckVzV2hicFRCV0x3aHdNRkpWbFF5M0RtMUhSQ1hKOUV1cFF4d2FEcHlUTWZJ?=
 =?utf-8?B?Q1RxOUkwcmVYTDlGQVFHWEl2RkRkOURFME5QTnR3SVowalpPeHM1YnArSW1w?=
 =?utf-8?B?cWd2UW41YnRhY3JSSnlFVzJOSkcvTWFiWFQ2b0hENElhZWdsZFowcVhvZDB2?=
 =?utf-8?B?dmxrQkJyd0dFWWJ1WGM5N0dSR0lTcEp0TThHT0NLYy9ZaTJBeUpEejRoVnNX?=
 =?utf-8?B?bjJmcER3dEdPdnhuQWlCMEZYSTJuZDUyWkxyK0lKQXpFaHRxL0ZSekxGaHFE?=
 =?utf-8?B?dFRLTCt6ODZZODRqYTZEVGFTSUxiUmhzRnd2cXkrS05iKzAvYkxHTEpuZXZZ?=
 =?utf-8?B?a0s4c0oxVFNObVNsdWo4MzA0OUwvWnV2cUpqYjZKcWFJSEM3UUtWMVdYTFNK?=
 =?utf-8?B?NGZDK3NiZTh3akhYV1oyUTA4dko1VnozVy9xMUNDdUwwbmRJWDgzNTM5UEdm?=
 =?utf-8?B?Nkd2S2RTSlNFblU4TmJGd2gvMU9EOFE3TkU1YVNEVG44dEVtbUwzV2ZSaVNC?=
 =?utf-8?B?cERGTHhzSmVlYjFCUXhkQ21LSjN6WWZ5TGdkbDgvVUJ6a3l5OUVWR3N0VGRJ?=
 =?utf-8?B?MnlrUmxTRVFVNWhSYmZaR0RxS1NKZGN6K0lrZlEyMHBoQTQ2VEdVQ1lGOElO?=
 =?utf-8?B?ZGRyOGRMajdQUE1SNW1qR3dzSjF2Q0pOQjZuaGxhUDVhOER0RklOVVRkWXQx?=
 =?utf-8?B?ZGptZFNZdkJ1RHVaZCt6RS9kN2czdUdxU1pHTkpRLzMySWJQYTN4Z2Z6UVhU?=
 =?utf-8?B?dkJxR25KMGc0bzFDRWUwMVpPc1gySyt4TUxVNFFWZlFLSWtac0NVcm51bTYz?=
 =?utf-8?B?cGh3K2Q2UW9pN1JRTXkvcjdXa1JvZHRiMUhTRnA5M0lrUXJwVnhzTnVqMC9Z?=
 =?utf-8?B?RFRyaTM3bVpJSU5qRnd5MThxRGVNbVZqc1lFdEsxZ29hSzhkZDhiVHByM1JS?=
 =?utf-8?B?RVJkRFpPZHkyeUp4SEtKYzBwdkZVTFFGZ29HcXJMUWhUeHpBQ3BtcHBsMGV4?=
 =?utf-8?B?WmRuVjNSREtrR1hhWlM0QlMvVzJqREljZHBZY2xCOXZLTjM1VG5wb2ExWlFE?=
 =?utf-8?B?emd1dVVhUWNzUm9NYVE5bS9PVUZNdXlkam41ci8xeW1qVE9MQlFFZVZ0M2pw?=
 =?utf-8?B?K0RXa0NGN0E0SUZxamVTbmowS1JZUXRQV3NsUHhsQWxDMFNjd2tYbUhyQmN3?=
 =?utf-8?B?dVFFakIreEFIUGdkZUYvZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WklzOFRoMXRmSnN1RzBjSUZjOTd1UzY0bzQydEdLSngxVTE2SGtUV2MwVXBR?=
 =?utf-8?B?RlY0Q2xoRXlNZVVoUTFVbWdaaWR2dG5YaDF1WCttT3JVSTZ0TzBqZXJPMXVo?=
 =?utf-8?B?WXZaSE45RjNMTlp1TGZ5THdFVUt5MlVLS1IrQ085L3lkN3h3UG5reGhPQlU4?=
 =?utf-8?B?YUd0Wlh2bTJ0Y1BBVCtzcmEwRWdGQUYyeHFIZC9rM1FveTdRdDlyTkxJYlFH?=
 =?utf-8?B?WUlHMHE5K1JnbnlYa2RBT2lIcGRuM2pRSlAzSFZTaFVIYTc2d1dDY2R0Wnp3?=
 =?utf-8?B?RkZSZzlyMGVqaVpJQ1p1Y0lJbFQwSURvbU5vUmxyZkk0Uk93VHpCdVRlVzBz?=
 =?utf-8?B?a3JMNXV3bGZSSndDU01PM1VYd0I4L20rTDg2NDR0bXJUS1k0bnFTY0RFWVox?=
 =?utf-8?B?UWxKNEpxOHlMUDhwWWtOUGUxb2k4VzZZZVBrVEVsQ3VLZVJjeU0vanBiR2Nu?=
 =?utf-8?B?c3hIN3JWSFlEekQ3M3c1R0NHYkd6L04yenF0UzBPdnFqelUwcm16N2tUNWtR?=
 =?utf-8?B?b0JSYVhqZ3cxUFRXSi8yeFluYW01UjNISE9XR2ZqMUhJMmRJY29PZDNsS0JS?=
 =?utf-8?B?MFN1WTN4TTI2WG9VT1lMNVIxek1Ud2dBRVBNUVFzcmZOSVRBemUxNGQyWVVW?=
 =?utf-8?B?WGRDNnRna2hqcEc4Mjl0b3BEK3N6Z29mSWo3cVhTNkFDUitQRmMzSzZlSWx4?=
 =?utf-8?B?ZlA2bGZtajQ2YW5EZFNhcXJjaG9ueWRDRkpBQmN2ajFQd0J3ZzhvdXc4QTFF?=
 =?utf-8?B?NTUxUi9MQ1MvZXBMTDdNSGRnbXFHemxFYWZ3SkhobkxORVlnclZ5NUtRZkFY?=
 =?utf-8?B?QTJzc3hqOU9TT1NieXJuY2xKRkFZOTNrdk9tTFJLam9JNnNHS0x0WTJyZkM1?=
 =?utf-8?B?MkwwTVB0c2xZSFlLMml1MFdKL3lGVnlMVFVDQnVmRXF6UTJhaTRZOU5GSGZH?=
 =?utf-8?B?NERWSThLRUJKKzVBazVmc1ArcVpKVXNZQWFneHJ2QU9sMlFIRG44dGZQUWQ4?=
 =?utf-8?B?eDk4bHlmWFd1QVFLUVRuY2cyeXNqdUprekQ1alc2WGluRit5emdyeG5XbmE5?=
 =?utf-8?B?ZkJrbjRaNlhNNmtaNEkzUXNWZ3RhSjJHZmxoVE9ra0h5c2tMOHdTc1dSTjlQ?=
 =?utf-8?B?OStsUUdIUTZoUlptRlIxbEdPM0JUR0ZxYXdLT2RkN2J0RWZjd3crYmJpb1VC?=
 =?utf-8?B?cHhZUXViMnRLZUhxREdSVG5ONFJIV3JzYXJQZGl4d1l5YmFmWDNVVzBxT2dL?=
 =?utf-8?B?enpYWWJwN0ZPZWhlNG1IcmxvOVhjSFBYYStqUyswNnB2ZDdvQlpENFBBdVJy?=
 =?utf-8?B?c085U0hEbldsOXhCR0dlYkc0c2dvM2UzTW1JUDZ0alZ4TlVSU2ptYVQvdktp?=
 =?utf-8?B?ODV1RTk0bEJ1azVQRmtNb1N1QzVZNWFSMU12TFdHbjNId1lxQW9ka2VuQWs3?=
 =?utf-8?B?NXkzWitkTG1wdU5RTGF5OWNwd21FUkZHeFJaSTY0U3dJOGFWQzYvMmxmZGpN?=
 =?utf-8?B?Z09MeUZmSjV2ZWJ5Zmo3d1ZKUXFOanBoQS9qU2x5UTAxbnlDVFF6dkpKYVht?=
 =?utf-8?B?RlF3THNQbDZjdndFRnArK0g2bDN2L2FnbEFwdVk0RFJESzBBcEYrSnlUay9M?=
 =?utf-8?B?ZHdqREcrMm02WG9FdW4wWm92MEhZVTd3cld0OTRMakM1NnMyZGovTHVtNmpx?=
 =?utf-8?B?bVJjWFRmWVgvNmNYWXZ4VHQ5eXR6c3I5TW9zREtPVW9XZ1dTQWVPNTJBa3M2?=
 =?utf-8?B?dEk0ekRQRncyNGRuSmd0MEl1VHZ3V1FUSGk0UUluRkhoeUF0aFhJbDBWRXJO?=
 =?utf-8?B?dXpWUE1zVU5hc2liOGdyWHZDTFJET2pUTFp2dkMvWXFjbWRRRFhzSUNWMDFh?=
 =?utf-8?B?YmZMUnlvZjRsaTlYNjVYeDN4MTk3aXZVY2lmbTZuNWErKzBqdS9kVkRqNXRP?=
 =?utf-8?B?Z0VUY1drYWpieUZ5dmJMK05kQXl6R3RJRkRmOU5kQkdodXowSUMyUU9HeWI3?=
 =?utf-8?B?VUREM2JleE5mWjFPbzNzdW5SaTVZcmxtaWY1UHZjWVExM3U0VkdWNGxucjVN?=
 =?utf-8?B?QzFzT2c1UGRBYVgzZnZRRDVwTVkwZFA1cW9IMU9SZmU4TDlNcWZyL0JFMTM5?=
 =?utf-8?Q?N2X7aASltfnXJ4kxCxf5v1f3u?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <14609C1E545DC945B7BB271B5D6FE366@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d635bdd-b993-4402-14a9-08dcfe9e75f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 20:06:11.6998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CrJMENePyMPk+biSz9mmbf/1AXo/LyfslRPTcIwaATAex3g1zPdgUtkKS3psuu+8XZGO1hvuRBcdFCSe4Jr/Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7134
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTExLTA2IGF0IDA3OjAxIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE5vdiAwNiwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyNC0xMC0zMSBhdCAxMzoyMiAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFRodSwgT2N0IDMxLCAyMDI0LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+IE9u
IFdlZCwgMjAyNC0xMC0zMCBhdCAwODoxOSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90
ZToNCj4gPiA+ID4gPiA+ICt2b2lkIF9faW5pdCB0ZHhfYnJpbmd1cCh2b2lkKQ0KPiA+ID4gPiA+
ID4gK3sNCj4gPiA+ID4gPiA+ICsJZW5hYmxlX3RkeCA9IGVuYWJsZV90ZHggJiYgIV9fdGR4X2Jy
aW5ndXAoKTsNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBBaC4gIEkgZG9uJ3QgbG92ZSB0aGlzIGFw
cHJvYWNoIGJlY2F1c2UgaXQgbWl4ZXMgImZhaWx1cmUiIGR1ZSB0byBhbiB1bnN1cHBvcnRlZA0K
PiA+ID4gPiA+IGNvbmZpZ3VyYXRpb24sIHdpdGggZmFpbHVyZSBkdWUgdG8gdW5leHBlY3RlZCBp
c3N1ZXMuICBFLmcuIGlmIGVuYWJsaW5nIHZpcnR1YWxpemF0aW9uDQo+ID4gPiA+ID4gZmFpbHMs
IGxvYWRpbmcgS1ZNLXRoZS1tb2R1bGUgYWJzb2x1dGVseSBzaG91bGQgZmFpbCB0b28sIG5vdCBz
aW1wbHkgZGlzYWJsZSBURFguDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGFua3MgZm9yIHRoZSBjb21t
ZW50cy4NCj4gPiA+ID4gDQo+ID4gPiA+IEkgc2VlIHlvdXIgcG9pbnQuICBIb3dldmVyIGZvciAi
ZW5hYmxpbmcgdmlydHVhbGl6YXRpb24gZmFpbHVyZSIga3ZtX2luaXQoKSB3aWxsDQo+ID4gPiA+
IGFsc28gdHJ5IHRvIGRvIChkZWZhdWx0IGJlaGF2aW91ciksIHNvIGlmIGl0IGZhaWxzIGl0IHdp
bGwgcmVzdWx0IGluIG1vZHVsZQ0KPiA+ID4gPiBsb2FkaW5nIGZhaWx1cmUgZXZlbnR1YWxseS4g
wqBTbyB3aGlsZSBJIGd1ZXNzIGl0IHdvdWxkIGJlIHNsaWdodGx5IGJldHRlciB0bw0KPiA+ID4g
PiBtYWtlIG1vZHVsZSBsb2FkaW5nIGZhaWwgaWYgImVuYWJsaW5nIHZpcnR1YWxpemF0aW9uIGZh
aWxzIiBpbiBURFgsIGl0IGlzIGEgbml0DQo+ID4gPiA+IGlzc3VlIHRvIG1lLg0KPiA+ID4gPiAN
Cj4gPiA+ID4gSSB0aGluayAiZW5hYmxpbmcgdmlydHVhbGl6YXRpb24gZmFpbHVyZSIgaXMgdGhl
IG9ubHkgInVuZXhwZWN0ZWQgaXNzdWUiIHRoYXQNCj4gPiA+ID4gc2hvdWxkIHJlc3VsdCBpbiBt
b2R1bGUgbG9hZGluZyBmYWlsdXJlLiAgRm9yIGFueSBvdGhlciBURFgtc3BlY2lmaWMNCj4gPiA+
ID4gaW5pdGlhbGl6YXRpb24gZmFpbHVyZSAoZS5nLiwgYW55IG1lbW9yeSBhbGxvY2F0aW9uIGlu
IGZ1dHVyZSBwYXRjaGVzKSBpdCdzDQo+ID4gPiA+IGJldHRlciB0byBvbmx5IGRpc2FibGUgVERY
Lg0KPiA+ID4gDQo+ID4gPiBJIGRpc2FncmVlLiAgVGhlIHBsYXRmb3JtIG93bmVyIHdhbnRzIFRE
WCB0byBiZSBlbmFibGVkLCBLVk0gc2hvdWxkbid0IHNpbGVudGx5DQo+ID4gPiBkaXNhYmxlIFRE
WCBiZWNhdXNlIG9mIGEgdHJhbnNpZW50LCB1bnJlbGF0ZWQgZmFpbHVyZS4NCj4gPiA+IA0KPiA+
ID4gSWYgVERYIF9jYW4ndF8gYmUgc3VwcG9ydGVkLCBlLmcuIGJlY2F1c2UgRVBUIG9yIE1NSU8g
U1BURSBjYWNoaW5nIHdhcyBleHBsaWNpdGx5DQo+ID4gPiBkaXNhYmxlLCB0aGVuIHRoYXQncyBk
aWZmZXJlbnQuICBBbmQgdGhhdCdzIHRoZSBnZW5lcmFsIHBhdHRlcm4gdGhyb3VnaG91dCBLVk0u
DQo+ID4gPiBJZiBhIHJlcXVlc3RlZCBmZWF0dXJlIGlzbid0IHN1cHBvcnRlZCwgdGhlbiBLVk0g
Y29udGludWVzIG9uIHVwZGF0ZXMgdGhlIG1vZHVsZQ0KPiA+ID4gcGFyYW0gYWNjb3JkaW5nbHku
ICBCdXQgaWYgc29tZXRoaW5nIG91dHJpZ2h0IGZhaWxzIGR1cmluZyBzZXR1cCwgS1ZNIGFib3J0
cyB0aGUNCj4gPiA+IGVudGlyZSBzZXF1ZW5jZS4NCj4gPiA+IA0KPiA+ID4gPiBTbyBJIGNhbiBj
aGFuZ2UgdG8gIm1ha2UgbG9hZGluZyBLVk0tdGhlLW1vZHVsZSBmYWlsIGlmIGVuYWJsaW5nIHZp
cnR1YWxpemF0aW9uDQo+ID4gPiA+IGZhaWxzIGluIFREWCIsIGJ1dCBJIHdhbnQgdG8gY29uZmly
bSB0aGlzIGlzIHdoYXQgeW91IHdhbnQ/DQo+ID4gPiANCj4gPiA+IEkgd291bGQgcHJlZmVyIHRo
ZSBsb2dpYyB0byBiZTogcmVqZWN0IGxvYWRpbmcga3ZtLWludGVsLmtvIGlmIGFuIG9wZXJhdGlv
biB0aGF0DQo+ID4gPiB3b3VsZCBub3JtYWxseSBzdWNjZWVkLCBmYWlscy4NCj4gPiANCj4gPiBJ
IGxvb2tlZCBhdCB0aGUgZmluYWwgdGR4LmMgdGhhdCBpbiBvdXIgZGV2ZWxvcG1lbnQgYnJhbmNo
IFsqXSwgYW5kIGJlbG93IGlzIHRoZQ0KPiA+IGxpc3Qgb2YgdGhlIHRoaW5ncyB0aGF0IG5lZWQg
dG8gYmUgZG9uZSB0byBpbml0IFREWCAodGhlIGNvZGUgaW4NCj4gPiBfX3RkeF9icmluZ3VwKCkp
LCBhbmQgbXkgdGhpbmtpbmcgb2Ygd2hldGhlciB0byBmYWlsIGxvYWRpbmcgdGhlIG1vZHVsZSBv
ciBqdXN0DQo+ID4gZGlzYWJsZSBURFg6DQo+ID4gDQo+ID4gMSkgRWFybHkgZGVwZW5kZW5jeSBj
aGVjayBmYWlscy4gIFRob3NlIGluY2x1ZGU6IHRkcF9tbXVfZW5hYmxlZCwNCj4gPiBlbmFibGVf
bW1pb19jYWNoaW5nLCBYODZfRkVBVFVSRV9NT1ZESVI2NEIgY2hlY2sgYW5kIGNoZWNrIHRoZSBw
cmVzZW5jZSBvZg0KPiA+IFRTWF9DVEwgdXJldCBNU1IuDQo+ID4gDQo+ID4gRm9yIHRob3NlIHdl
IGNhbiBkaXNhYmxlIFREWCBvbmx5IGJ1dCBjb250aW51ZSB0byBsb2FkIG1vZHVsZS4NCj4gPiAN
Cj4gPiAyKSBFbmFibGUgdmlydHVhbGl6YXRpb24gZmFpbHMuDQo+ID4gDQo+ID4gRm9yIHRoaXMg
d2UgZmFpbCB0byBsb2FkIG1vZHVsZSAoYXMgeW91IHN1Z2dlc3RlZCkuDQo+ID4gDQo+ID4gMykg
RmFpbCB0byByZWdpc3RlciBURFggY3B1aHAgdG8gZG8gdGR4X2NwdV9lbmFibGUoKSBhbmQgaGFu
ZGxlIGNwdSBob3RwbHVnLg0KPiA+IA0KPiA+IEZvciB0aGlzIHdlIG9ubHkgZGlzYWJsZSBURFgg
YnV0IGNvbnRpbnVlIHRvIGxvYWQgbW9kdWxlLiAgVGhlIHJlYXNvbiBpcyBJIHRoaW5rDQo+ID4g
dGhpcyBpcyBzaW1pbGFyIHRvIGVuYWJsZSBhIHNwZWNpZmljIEtWTSBmZWF0dXJlIGJ1dCB0aGUg
aGFyZHdhcmUgZG9lc24ndA0KPiA+IHN1cHBvcnQgaXQuICBXZSBjYW4gZ28gZnVydGhlciB0byBj
aGVjayB0aGUgcmV0dXJuIHZhbHVlIG9mIHRkeF9jcHVfZW5hYmxlKCkgdG8NCj4gPiBkaXN0aW5n
dWlzaCBjYXNlcyBsaWtlICJtb2R1bGUgbm90IGxvYWRlZCIgYW5kICJ1bmV4cGVjdGVkIGVycm9y
IiwgYnV0IEkgcmVhbGx5DQo+ID4gZG9uJ3Qgd2FudCB0byBnbyB0aGF0IGZhci4NCj4gDQo+IEhy
bSwgdGR4X2NwdV9lbmFibGUoKSBpcyBhIGJpdCBvZiBhIG1lc3MuICBJZGVhbGx5LCB0aGVyZSB3
b3VsZCBiZSBhIHNlcGFyYXRlDQo+ICJwcm9iZSIgQVBJIHNvIHRoYXQgS1ZNIGNvdWxkIGRldGVj
dCBpZiBURFggaXMgc3VwcG9ydGVkLiAgVGhvdWdoIG1heWJlIGl0J3MgdGhlDQo+IFREWCBtb2R1
bGUgaXRzZWxmIGlzIGZsYXdlZCwgZS5nLiBpZiBUREhfU1lTX0lOSVQgaXMgbGl0ZXJhbGx5IHRo
ZSBvbmx5IHdheSB0bw0KPiBkZXRlY3Qgd2hldGhlciBvciBub3QgYSBtb2R1bGUgaXMgbG9hZGVk
Lg0KDQpXZSBjYW4gYWxzbyB1c2UgUC1TRUFNTERSIFNFQU1DQUxMIHRvIHF1ZXJ5LCBidXQgSSBz
ZWUgbm8gZGlmZmVyZW5jZSBiZXR3ZWVuDQp1c2luZyBUREhfU1lTX0lOSVQuICBJZiB5b3UgYXJl
IGFza2luZyB3aGV0aGVyIHRoZXJlJ3MgQ1BVSUQgb3IgTVNSIHRvIHF1ZXJ5DQp0aGVuIG5vLg0K
DQo+IA0KPiBTbywgYWJzZW50IGEgd2F5IHRvIGNsZWFuIHVwIHRkeF9jcHVfZW5hYmxlKCksIG1h
eWJlIGRpc2FibGUgdGhlIG1vZHVsZSBwYXJhbSBpZg0KPiBpdCByZXR1cm5zIC1FTk9ERVYsIG90
aGVyd2lzZSBmYWlsIHRoZSBtb2R1bGUgbG9hZD8NCg0KV2UgY2FuLCBidXQgd2UgbmVlZCB0byBh
c3N1bWUgY3B1aHBfc2V0dXBfc3RhdGVfY3B1c2xvY2tlZCgpIGl0c2VsZiB3aWxsIG5vdA0KcmV0
dXJuIC1FTk9ERVYgKGl0IGlzIHRydWUgbm93KSwgb3RoZXJ3aXNlIHdlIHdvbid0IGJlIGFibGUg
dG8gZGlzdGluZ3Vpc2gNCndoZXRoZXIgdGhlIC1FTk9ERVYgd2FzIGZyb20gY3B1aHBfc2V0dXBf
c3RhdGVfY3B1c2xvY2tlZCgpIG9yIHRkeF9jcHVfZW5hYmxlKCkuDQoNClVubGVzcyB3ZSBjaG9v
c2UgdG8gZG8gdGR4X2NwdV9lbmFibGUoKSB2aWEgb25fZWFjaF9jcHUoKSBzZXBhcmF0ZWx5Lg0K
DQpCdHcgdGR4X2NwdV9lbmFibGUoKSBpdHNlbGYgd2lsbCBwcmludCAibW9kdWxlIG5vdCBsb2Fk
ZWQiIGluIGNhc2Ugb2YgLUVOT0RFViwNCnNvIHRoZSB1c2VyIHdpbGwgYmUgYXdhcmUgYW55d2F5
IGlmIHdlIG9ubHkgZGlzYWJsZSBURFggYnV0IG5vdCBmYWlsIG1vZHVsZQ0KbG9hZGluZy4NCg0K
TXkgY29uY2VybiBpcyBzdGlsbCB0aGUgd2hvbGUgImRpZmZlcmVudCBoYW5kbGluZyBvZiBlcnJv
ciBjYXNlcyIgc2VlbXMgb3Zlci0NCmVuZ2luZWVyaW5nLg0KDQo+IA0KPiA+IDQpIHRkeF9lbmFi
bGUoKSBmYWlscy4NCj4gPiANCj4gPiBEaXR0byB0byAzKS4NCj4gDQo+IE5vLCB0aGlzIHNob3Vs
ZCBmYWlsIHRoZSBtb2R1bGUgbG9hZC4gIEUuZy4gbW9zdCBvZiB0aGUgZXJyb3IgY29uZGl0aW9u
cyBhcmUNCj4gLUVOT01FTSwgd2hpY2ggaGFzIG5vdGhpbmcgdG8gZG8gd2l0aCBob3N0IHN1cHBv
cnQgZm9yIFREWC4NCj4gDQo+ID4gNSkgdGR4X2dldF9zeXNpbmZvKCkgZmFpbHMuDQo+ID4gDQo+
ID4gVGhpcyBpcyBhIGtlcm5lbCBidWcgc2luY2UgdGR4X2dldF9zeXNpbmZvKCkgc2hvdWxkIGFs
d2F5cyByZXR1cm4gdmFsaWQgVERYDQo+ID4gc3lzaW5mbyBzdHJ1Y3R1cmUgcG9pbnRlciBhZnRl
ciB0ZHhfZW5hYmxlKCkgaXMgZG9uZSBzdWNjZXNzZnVsbHkuICBDdXJyZW50bHkgd2UNCj4gPiBq
dXN0IFdBUk4oKSBpZiB0aGUgcmV0dXJuZWQgcG9pbnRlciBpcyBOVUxMIGFuZCBkaXNhYmxlIFRE
WCBvbmx5LiAgSSB0aGluayBpdCdzDQo+ID4gYWxzbyBmaW5lLg0KPiA+IA0KPiA+IDYpIFREWCBn
bG9iYWwgbWV0YWRhdGEgY2hlY2sgZmFpbHMsIGUuZy4sIE1BWF9WQ1BVUyBldGMuDQo+ID4gDQo+
ID4gRGl0dG8gdG8gMykuICBGb3IgdGhpcyB3ZSBkaXNhYmxlIFREWCBvbmx5Lg0KPiANCj4gV2hl
cmUgaXMgdGhpcyBjb2RlPw0KDQpQbGVhc2UgY2hlY2s6DQoNCmh0dHBzOi8vZ2l0aHViLmNvbS9p
bnRlbC90ZHgvYmxvYi90ZHhfa3ZtX2Rldi0yMDI0LTEwLTI1LjEtaG9zdC1tZXRhZGF0YS12Ni1y
ZWJhc2UvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KDQouLiBzdGFydGluZyBhdCBsaW5lIDMzMjAu
DQoNCklmIHlvdSB3YW50IGluZGl2aWR1YWwgY29tbWl0cywgaGVyZSdzIHRoZSBsaXN0Og0KDQoN
CktWTTogVERYOiBHZXQgVERYIGdsb2JhbCBJbmZvcm1hdGlvbg0KaHR0cHM6Ly9naXRodWIuY29t
L2ludGVsL3RkeC9jb21taXQvNmFlM2FiMWRkYjUxYTRjZjBmMDgxMDg1M2EyNGQ0N2QzNjBhYmFl
YQ0KDQpLVk06IFREWDogR2V0IHN5c3RlbS13aWRlIGluZm8gYWJvdXQgVERYIG1vZHVsZSBvbiBp
bml0aWFsaXphdGlvbg0KaHR0cHM6Ly9naXRodWIuY29tL2ludGVsL3RkeC9jb21taXQvZmQ3OTQ3
MTE4Yjc2ZjZkNDI1NmJjNDIyOGUwM2U3MzI2MmU2N2JhMg0KDQpLVk06IFREWDogU3VwcG9ydCBw
ZXItVk0gS1ZNX0NBUF9NQVhfVkNQVVMgZXh0ZW5zaW9uIGNoZWNrDQpodHRwczovL2dpdGh1Yi5j
b20vaW50ZWwvdGR4L2NvbW1pdC85ODE2MmNmOTllZTcyOGI5N2EwYzk2NDdiZDJiMzlhMjU0ZGE2
YTRhDQo=

