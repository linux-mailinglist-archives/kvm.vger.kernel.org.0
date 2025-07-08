Return-Path: <kvm+bounces-51762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C095AFC923
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 13:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2413F189635F
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 11:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F182D8383;
	Tue,  8 Jul 2025 11:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nMMBRrcs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D70221561;
	Tue,  8 Jul 2025 11:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751972772; cv=fail; b=QxcHpMfOtbeOZzbyOSRFrH+EZ7b8zx0YOxxy2aNtYNgvEdZfe1QbzP4KlixYuSLLE0hJJRI7aKAsRlhz+wv3eG4c21qek1rU5a820lTi1j+ZVr9o2DcRClZw1MCAlzCz5efaVTmlk0eODez/naukbrG3vCrANorlvmwEeW1Bvmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751972772; c=relaxed/simple;
	bh=cFe88OxJtVNK6p+Ngjou0dEc44SudRf0IY2W8USz/6w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GGg3njvs9lbQTiU/f+bStVn+LRPRUCk+ezQdi8mzj4gSFmJXQUSYyelT7CtZ2cxTjs46cDFgccqEDzKhUeB6o2uci36bpC7rGxL03KSe49mIDg7pZJexwrN+PxsF3o7W6te+bDhFt++9WmnsNr3lsrAuaOhnH5R6i6tUObtbCDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nMMBRrcs; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751972771; x=1783508771;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cFe88OxJtVNK6p+Ngjou0dEc44SudRf0IY2W8USz/6w=;
  b=nMMBRrcsrMgFjhQyOGXVt/MengQkt3m4WHO/11I8Ufgn8BDkKeFq0+YG
   SMbwq+Cg9B+6wL4eYEuPgvUEX5Ige6aG5PPI4WmDcZowBwNzmhDKiv9ND
   5OaP2sd1u0HC6VwbKFhrplbf1FkLw46ldNALwYY0VfunOd1DPtF5uHoGP
   jCsja9Dcd/v8WE/cmIzs/OxEougWG//X4eByAVaG8UP4SmBxfP++NlF57
   ytSuQYFWEv1qxTSq2wm3ArVJUcBMUVXHzDod8SKSNIvSaYA298yEDaXQQ
   nbUeS5Rnyr5WqIGtCAEeIrd/MSnHnHPOB4K8PzI2XDXE3sifL6AUzLTV+
   A==;
X-CSE-ConnectionGUID: r/gY+fC/RWGPX13welNxXw==
X-CSE-MsgGUID: APdJ2sFcTeOdJ4gk0+tj8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="56819077"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="56819077"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 04:06:09 -0700
X-CSE-ConnectionGUID: JN5+kbB0QTWncXTmiS0Gag==
X-CSE-MsgGUID: g2mh3FW7TFaeohqa2XL8Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="159735519"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 04:06:08 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 04:06:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 04:06:08 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.56) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 04:06:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Guxe66G8gJNN5CHcil4oZDUqsQnDqe+I4Nt7/sCB9zv8G5pB6omaBzflI3un3YxMalGAwpc4W/YFjF9C2xO87gNyA2RLBKoil3VyeTDlrN38sLrwaB2B4sMCIE8WvtVEXYkmO5KHjNCntMg4p7/3sqG8PjrGL8rBLJ7rP8dQ32kMlFaurbs8jqMty45g78FiwRxJCRVeC1AztEyQrueKqw4rojil3DoqC7Zyb29sduKqtljjzWFB7JBCg3qrhmM2UtFMhjIB1AcXv2Gq+f7GzFGDszkIewyHJUnLZwz/xBxdJ1kkXjZM+3+AkLSLgMMOtr9lXtWSoF4KudThNZaGUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFe88OxJtVNK6p+Ngjou0dEc44SudRf0IY2W8USz/6w=;
 b=xZYx/3rwE6pkZIaQQdkL+Pd4wOZYHIKjq7oFUBUdMUMlYq07j+k8aieOahTIjA5GMHNVDuooLaLM+KtfV+7DE/+5N+0nEMaHjr2jSGPjrlo1q6Kr8n/L82A1n/OBvOJik5qdOCoDZH5bRIkDJmzrsHrBGfydoSJSYVt3ZlxLiI7A4I9bvDX94R9aQUrmCrqs7ZDQpK7pXyAI6ugZlMyuZ+j4vk4knKhq+uGgEACrKpeB36vBxkPmRRVwSmsH9Gfa1PQFCtY9agETPusPYVuY3JEvFNmf+kf1HQpxTs+zyfxRwHHmaFO+kbth3GgFBKHSPMSM0xOg+Jx0CowckDgf4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB8251.namprd11.prod.outlook.com (2603:10b6:510:1a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Tue, 8 Jul
 2025 11:05:24 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 11:05:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] KVM: TDX: Remove redundant definitions of
 TDX_TD_ATTR_*
Thread-Topic: [PATCH 2/2] KVM: TDX: Remove redundant definitions of
 TDX_TD_ATTR_*
Thread-Index: AQHb79/kJr8qbcuhXU2lP5JSdatqorQoEKSA
Date: Tue, 8 Jul 2025 11:05:24 +0000
Message-ID: <72483f3aca192c1dd7fe9071a58b118daf002848.camel@intel.com>
References: <20250708080314.43081-1-xiaoyao.li@intel.com>
	 <20250708080314.43081-3-xiaoyao.li@intel.com>
In-Reply-To: <20250708080314.43081-3-xiaoyao.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB8251:EE_
x-ms-office365-filtering-correlation-id: 79ac4bb6-8e8e-49d2-2ae7-08ddbe0f5694
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VVhkek82eWg4T0tDdVJvcmRqb2hxcGptbGFjOGVXUi9jckRKM3NkVE8vMXJY?=
 =?utf-8?B?eU5VN0dneHdsUm5hby9WVzdsRm5mcVVIOVdHaFRPb25YQjFBZzh3eFB2Vi83?=
 =?utf-8?B?M3VxOEdYWnFFQWNOQzZOaDVBUDNFWTdGeTFzQ0RGellZcVVmdzlGejdnTjRD?=
 =?utf-8?B?L2JiS3Q2WkF6cFR4YWhINGFGZU93Y1hwWFc0VzVGdkpGcmN0MlhDMlRSeFFm?=
 =?utf-8?B?SlR0U3RZeDVnVm1ueEZ0RlA0eDFxcTNMSkdOTmxvKzNoOVJrSU1aS1BIa2dU?=
 =?utf-8?B?NXFjSW9MdUM0UmpTWm13UEJPcWZ6MUpaeTNRZ0c0bnRRcEFjNkRvbTltYmVD?=
 =?utf-8?B?THRTMVZrRzgwUlhQQldBc1FwNUdEU2RJTWpVdHJoYWlGNlpUQy9mWWhaVVhk?=
 =?utf-8?B?NGNQV3ZhVkRrYk1iUGZGVjRRSGVIQ1BFdTgvMno1NFllekZtQmdsdm9JbCtW?=
 =?utf-8?B?d3FlV044Zy9CZ3ZON1NzQ3NQQXFhZFBoeWNPQ251bG4zdmlNV2hycDRaaCtq?=
 =?utf-8?B?dE1ZYnpjK2Ira1lBbDRkTjdtOGgranBHMkpVZkJYVGdJL0VsTE01bmpGMnpW?=
 =?utf-8?B?WkhwSUlqaGx2S3hyVGRmQ1lzcXA4Z202K3g1cktPNEdPNit5eFV4Qy9BMU5p?=
 =?utf-8?B?WjlVWXVia0hFM3hZcVArNkEwL2xBaXAzQXdBM1dONFBpQmQ1WE01Z29nSFFC?=
 =?utf-8?B?Qm4rWWxxTlZkb21wSEtBZ3ZuVE5wUXdtYzdLNEl2UC91TG9wQzZZem55WldF?=
 =?utf-8?B?SC9mU0ltUy9aeUJmQjhYb0hJM2oxWi8wcnRyWmtDNVlXZkRKWDNpajByTWVo?=
 =?utf-8?B?SGxmeE1KYVoxQk15ZzRJWnIvRUdPSTRmNWZtM3hURkphSVBrRmpGRFZEMTlk?=
 =?utf-8?B?VENvTS9EYkROK0VHRnFWeVh0U1ZWZEhySkdXbkNLT1NyRE40ZjNvVCszM0ll?=
 =?utf-8?B?U0xDMlZNb1VrSU5Pc1BKbFVnQktrUG45bTI0SVBHR2x2MlM0MkowckduSjU1?=
 =?utf-8?B?OXFNS0hORnBud2xPb3JJSitvbE83NGtNRzRHSEo2SVFqZzJDd044L25Lc2lo?=
 =?utf-8?B?TUl6NG1ScGlicmIwMjZEbUtxSnFRNWtSMTNjdk9ocDFKQ0NKVDcza29jTllr?=
 =?utf-8?B?NVlIY3VobHRoR0NmOTM3RHIzWGo4dWlIbURkN1g2dExKaS80Zno0b1djZ2JT?=
 =?utf-8?B?SUpoZVczRzdZVFNacnJJeVJVWjhMR2U4b2xVUFQ0R0hiSFRQUXl3RTAxR3Fn?=
 =?utf-8?B?d0FIOGVYeVlSTjRMbUVvamUxZVVrd25WVzhUKzk0Ylh6NUNKdm83aDU1SnZ5?=
 =?utf-8?B?a1poRkYxdjZtaVBEZmxVNHNteFl2WGthcndTMGFFZldLVkJpMnVFVzR6S1Fr?=
 =?utf-8?B?blhmVUlrSitoR0g4YW9HcTBqMHRVUTlmVTBSMURqZjVaM0dpM2JyaGV5UDlt?=
 =?utf-8?B?RHJySit4cU0vSkE4UldTMUs0MnY5dlRQYVkva2NXb21qd0NPdS93eGx4T2JZ?=
 =?utf-8?B?MHgrOHZkUkxMSzc1UUZxV3ZieS85U2xHdERRNDBxMThLOVJ2RmZseGR1U0lj?=
 =?utf-8?B?T3VtSllYUGVsbmptY3RTMFlLT3Y2dFM4N1ZsSVhMVWpsQUhHUGd3cDJwZUtw?=
 =?utf-8?B?SVM2Y0VBeVpIMzN4blFTU3RhTDJMUUVTalZLcU8yTXh6UVZVQWIrMmZ4OVRw?=
 =?utf-8?B?TTNBenFyMEk0NG1Ia2pjMjhkVkFZditGVi9RbVg1ZUtuaW1aOVJRRkNlaTNY?=
 =?utf-8?B?NDhmeWpYZTcwVGNyODJWaGdpU3poSXRoSjl0UlVFTkRSZE1QVW9RMDhwc2pQ?=
 =?utf-8?B?emdBWmV2TXJJelMwS1lZcWJuQTRCWXZNTHN3cHlkVStLT0xoeEYwTHZ6STAy?=
 =?utf-8?B?S1JMK0IwMkRPR0NLQVBmMTgwcGpmRFBqRG1uTWR4VXpOQzYyMU5CN0pJbnAv?=
 =?utf-8?B?OUg1dFVpSVZ1NWhiVWRWY0JZNnpGMUUvK2gwRUw0MjZiYkdjV1puWUNqdDBq?=
 =?utf-8?B?eU0wYkNTZTBRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDV0ZjFQeVhYNnRXcjUwTHY2Ym4wdThVSlVPV0Rnek41MmpuTStmU0RHUjhz?=
 =?utf-8?B?d0pvOFBzc083blVTSnB3STdhQXVRa0xxaDZ6Y0F0VXJrL20ra1NZMkh4NzNO?=
 =?utf-8?B?YTRYNm1iNVFycWNteTVPalJiRVpUSWR3MkZoWFdMcFRQdVpUSTJyUnFHMzJn?=
 =?utf-8?B?Zm00bnV3SGZzUk5Sc2ErQmxkQXh1c2xZbThFeE1HK0NacDZOajM5QlR6U1g2?=
 =?utf-8?B?VU5nT3EwTlV4bDhETjNJQ09WQWxIbDRhb0Q1R3F0V2dBclNxN3pHVXRuRGZU?=
 =?utf-8?B?T3hsSm9nT3Y2eWNaVlV1azd6cE1PT0ZNaUZGejJKZWlRNC9PcmxRdkJtYzlt?=
 =?utf-8?B?ZjlsalFVQnNXOGVqbU5PVlQ3Vi9rd2xaQ3UwUXB0M2s5WHljQ3RMckxvYzVo?=
 =?utf-8?B?YURIQyt0a2E4RmJkNE5tcDFtaXlJcW9mQkZ1Y2RpNXVmZVpGMEc4V0d1ZHpE?=
 =?utf-8?B?ZlJ1b1VncnBiZ3VXN0Y0VnhiVC96bEFtdkh4aDNoczZoaFh2TVNQOWV1dy9Z?=
 =?utf-8?B?WEJFeWE1eXFxL3p2NDZIQnM2WlJtTmdkdUtVZ2gvSWQ1SGJ6cTN6ZVlLUmtj?=
 =?utf-8?B?V0xnYXdvVDlDQmZXTHBOa2lRMFhOM2NCR09oYXBZdzBHS0ZJb280Yk84ZlZD?=
 =?utf-8?B?ZVpySTV3RVVWenpjK1FzRmNQWHhNTlhkRTg2R0ZvRU5LYmJxVUE4WjlIOTRY?=
 =?utf-8?B?OWZub3gycDNlcy9oc3FWdzY5cmcyVXZ2OUpxWG5MMC8vL3BvRDkrWmlmYjI0?=
 =?utf-8?B?RVdPeXRvcXBhLzNBN0o4am9wcmRHNy9tazVNUURxMlJmOVFZcmppbGZSNkpv?=
 =?utf-8?B?RHI1YzhpWnBManFCVjRuTVZhYVVhb0tkQzV6TlN0elNUY1owVUJJeExBZXYx?=
 =?utf-8?B?ZmdUdU84NEkzZkpTSDd5Z3BrZzVJN3NLanBBTDFNdGFkcG9OUy9ybExud1hT?=
 =?utf-8?B?NEkzVUtFbVZJVnVPY2I2RlVuRnZSNW9Ka3B5VGJudm5uWkloUStEMC9JTk5n?=
 =?utf-8?B?Q0NVeHFabDdWNC9XS051aXRFUWNvNlVGUVJvZEgxdWFQeUx2Mmc4alViYmJr?=
 =?utf-8?B?SnFyMjZzYmowcEV1L3ZoRVVwOE1vMHVJS2FFT2hYNlpnemt3ZGMyUFRVMjZL?=
 =?utf-8?B?Q2kwOGdBa3pRYXF0elJzbWpHRWo0N3BKcTBwVGxLM2wzanc1ays3Qko1NnJJ?=
 =?utf-8?B?UERjQTRWdGRDdUs2VmdaaGhWUlJVMFQvRkpoVTlZbFpFRGFQWU8zcWRIMVN3?=
 =?utf-8?B?aytVbFRJZmcydkNLbk1wNk9ZNW5zNFNLU2xrellscHF5ME5kZUF0OUkxdHBx?=
 =?utf-8?B?YVdQY1hSSlB3ODNTL0FjWUZDU3NZRjhCY2c0SW1BK0x4VTQ1d0RvTFVZNkdC?=
 =?utf-8?B?MXpZODdMamZ2WlBzQmhvQlZhRStkRzFLUHlJZFhtSXFWNUZTUmhHTGwvTkhy?=
 =?utf-8?B?OWgvZ0xhbys4YW5CbHFhdS9PaFk5VDMvYXNUajQrQkwzdUdnTXN0V0o4N1VM?=
 =?utf-8?B?RWxDSXVWOUxyTUFPMmowaHdPQnk5bjdxbGFVTjIyeUZzY0JCdElCVDE5cTNk?=
 =?utf-8?B?clIzejZaOVkzZmEzL0MwTWJEMVk0MkYzU2ZJT1lvT2tBUU5oODVXY0Q1d1Fa?=
 =?utf-8?B?d3ROVlRmZ0gwbnhxckVKcHBDQnJTQkFpZXhSb1JHZW40TFVlUXlIR0ZqN0RE?=
 =?utf-8?B?S2ZHYTNvcVJUUW9FVnd1a1ZSM3JYVWU5TnNRKzNYM2tvcXFnUWg3WUcwVTF3?=
 =?utf-8?B?YU4xbkRXV3hIM3gxaDR5SWxOc1RUOFF1MElnRGtBd21aT0RiV0xLeVhzcFEz?=
 =?utf-8?B?blAwNGt0RXFyOVkzdXY3UytWUFBxaVg5YWRnZnBhWWEwU3RFRWE5NlFzOEsx?=
 =?utf-8?B?OWt4QnRGeFgvRFVxUzZ5ckZtOUxyS2thcUY2Q0t1Z3AzOVFMUVQ1V0hGbjhV?=
 =?utf-8?B?dWRDRnVCVEZxZG9XbHAxREZHSFNaemt6eTNqVEt2bUIzdTVuOWd3YW02VUQx?=
 =?utf-8?B?N1FYenNlcnc4V1Urc3lEQXdENVhkS2pnOFJtMzhzZk05SjdMZkpJUEJicFF5?=
 =?utf-8?B?NDM4M3prekhveDhYU0dMbitxNkxWcGZQb2pyc3BGMC96VmEvWDBIOStYcW4r?=
 =?utf-8?B?QUQ3YjRTOUdSa09jYnZnSldUMkRoa25DaU9zbzh0cVVEZEEyWFRTR1A5UXBx?=
 =?utf-8?B?REE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75DC2104903FCF43837077EACD3F8657@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ac4bb6-8e8e-49d2-2ae7-08ddbe0f5694
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 11:05:24.2321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4A4xj3wA9ZbpYFBDuHfcgmCCjC+YxHYSYqq7djn53i/Hy0MJUKQ/bpiYqIoJ7k25B/0ckO3alpxb5IipWFNCkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8251
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTA4IGF0IDE2OjAzICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBU
aGVyZSBhcmUgZGVmaW5pdGlvbnMgb2YgVEQgYXR0cmlidXRlcyBiaXRzIGluc2lkZSBhc20vc2hh
cmVkL3RkeC5oIGFzDQo+IFREWF9BVFRSXyouDQo+IA0KPiBSZW1vdmUgS1ZNJ3MgZGVmaW5pdGlv
bnMgYW5kIHVzZSB0aGUgb25lcyBpbiBhc20vc2hhcmVkL3RkeC5oDQoNCk5pdDogTWlzc2luZyBw
ZXJpb2QgYXQgdGhlIGVuZCBvZiB0aGUgc2VudGVuY2UuDQoNCj4gDQo+IFJldmlld2VkLWJ5OiBL
aXJpbGwgQS4gU2h1dGVtb3YgPGtpcmlsbC5zaHV0ZW1vdkBsaW51eC5pbnRlbC5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IFhpYW95YW8gTGkgPHhpYW95YW8ubGlAaW50ZWwuY29tPg0KPiANCg0KUmV2
aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg==

