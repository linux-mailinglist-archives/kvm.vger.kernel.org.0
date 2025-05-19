Return-Path: <kvm+bounces-47007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C187CABC5BE
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 19:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C065D18950F5
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 17:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 352DD288C3D;
	Mon, 19 May 2025 17:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QaVxnNf1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AE62746A;
	Mon, 19 May 2025 17:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747676581; cv=fail; b=kXQkJAOy4/FgC7cSg+yW2/EM4QV78TN1D6rwKEFeYrGa5FttTRrgAOQ6qI1Z7nMiqteN4cYlHNEZ6vQo6oUqVn9iawq88C/YORRgfIexRKNd8CCz9fSHMMMY9fJlfputLb+oOCAmj8l3lk+8PFmbY5A77jDW/x9fxt+HI8SwmBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747676581; c=relaxed/simple;
	bh=hmy0bS5yiTqqEUl2TaN3R7RBaHToHXm2NAtC42j5zpA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qOgXLjXAYYv6oKjJ5TDUi0Ya460F2GQtSbux1Ze6l7ZEJjzqx6c4Xz9CL0etctknQ8brsguPRK5elpP9w6nfCQumgK6xIjIN3NyZV5rCiysAZWMgCL+JjMDyYVXLkzAcJBNoIXk/zZfmEAFUEyRFbFi7nZtZ4c3NXrgFD+ThEhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QaVxnNf1; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747676579; x=1779212579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hmy0bS5yiTqqEUl2TaN3R7RBaHToHXm2NAtC42j5zpA=;
  b=QaVxnNf1USI0GlPw92tRj4R5frQiDgtWocl2J/i5TMF2/thqrJfu+48G
   HNvZXWKHBa/SHo0RTfo1TnGv0ODvWM6qBFdVfAUP6TDY/jq9b7wYjBBX1
   o6dTPxMMUiwF+QtZUtf64ovEUjCaOsW7UIitVFlJUM1Q4+XjVu9uY7asr
   PeecfCPCfYkkQwfBlF4S9GFh/F4Xy4APRj6MFOLVA9jDeqWfB5iU2Fkxg
   baCTFyOOUo4yGcPHSoUOw9cWsNVfeWNG9lmtdG4yZtUoJ2SW909rLTZQl
   3Uj2Zo2CLGhyWBXo5TJmNG/fihBWGuJxmXBSiDYT0JdMoHMMUYQF9BJUR
   A==;
X-CSE-ConnectionGUID: 1UrxX+SlTkCHMM/yNyvhfA==
X-CSE-MsgGUID: ey6dEmPLQi+I17PghzqiWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49740173"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="49740173"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 10:42:52 -0700
X-CSE-ConnectionGUID: 8aHuQJQeROC1XlrbBUVKvA==
X-CSE-MsgGUID: 8h3gVsPISyyi0KGCqGHeRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="144561793"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 10:42:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 10:42:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 10:42:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 10:42:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r534CgQUhZVCKjD80Ybot9qZwiMKERE0EaOaPcN9R3Ipjzxx3aiZuqaN7shoYxVgiJWSyJRGi85dcZ5Dm9IQfskf+HQyVGdFsVQMDLzeuYVM4AEXzGkX8DjE1h4WQkP/Dxalm7930zm9H4/qJMfxNcRxb22cBLjaDakZ9HZ0UEJE2RH5CSIPV7rHIrbWZw5UCRmwlccjkhUoOuLmThoxrSLXkfTINPWVT18PJNLMwAtzzZaXYL9ldHcLMNs2eWQn6Ts4ghMIBoN5rMvs8FXYsNTSVSMM+vn2QupRyQdEy2uo3LicFIyZ8yFOUBAcu8o6fOraDSkVQtlYQALzGcCwVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmy0bS5yiTqqEUl2TaN3R7RBaHToHXm2NAtC42j5zpA=;
 b=sPB7mjI3xn+lSE/MTa95rXYwRAE7i8xGsEnrEdY2lfwyydAVFPw3g8r4nommiogDsjNJSHiKhvAlTksJ/TEk8O24orl/3u3hSBy7sHq45G+pX58PzZYlOvEocYXCdW2I1MAYA7eati2FPWppoGV3wzvMon4NDZKfVQToXmfCujDfl1I+AnqtrDjg+P1TNe7WBGsBc46vPJ/4iLzmKp2UMJ7GmU4LOytKgL+R+kbeFJVB+0EvZ97CpFWixCVwnsiEgAguKmIFTDPMcHfTi4dc/CqW43d8eCwP84954wWt3KnlgUGzy4KWdJq57dpth6oIzMSOYdgX7qCzKZJGV4QQfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5257.namprd11.prod.outlook.com (2603:10b6:408:132::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 17:42:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 17:42:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "ackerleytng@google.com" <ackerleytng@google.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 10/21] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
Thread-Topic: [RFC PATCH 10/21] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
Thread-Index: AQHbtMY0fWGadiEOpUminaJ+lP6+0bPRHeuAgAOm44CAAOfGAIADzgWAgADmloA=
Date: Mon, 19 May 2025 17:42:20 +0000
Message-ID: <eea0bf7925c3b9c16573be8e144ddcc77b54cc92.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030634.369-1-yan.y.zhao@intel.com>
	 <9d18a0edab6e25bf785fd3132bc5f345493a6649.camel@intel.com>
	 <aCa4jyAeZ9gFQUUQ@yzhao56-desk.sh.intel.com>
	 <20fd95c417229018a8dfb8f3a50ba6a3bcf53e6c.camel@intel.com>
	 <aCqsDW6bDlM6yOtP@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCqsDW6bDlM6yOtP@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5257:EE_
x-ms-office365-filtering-correlation-id: b0e8212f-7ea4-40f9-778d-08dd96fc817f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?L3ZMWmpEam94TXlyZnFSTWtiSkR1c25GcnZ2RnV3T252YStRZkY0Z255NkZs?=
 =?utf-8?B?RGhkUmFyVFpSczF1c3pRMWJwV2xzVmxjQmtTQUtsQTBuUFFUR2dhVkk3S1Rq?=
 =?utf-8?B?MHljazZQcFZlSnhiZWZ2THdHY3UzZ1dXNVIwM29oYU5NMzJXWUQ5aGVOWWo2?=
 =?utf-8?B?MnRxalR0VitiUjdqTkp1ZHIweUpzNWlpMWlJR1BrTkl0cVJhSTE3ZkFIakNK?=
 =?utf-8?B?OGZPa3NUNm1RbjUrbTVVblFMQmwzeUdtZU5jWUFueHhXUGZTSE5xOElrRkhC?=
 =?utf-8?B?RDNBeWp0a2lNaEQwc0J3Vmt2K2xkRjFsTFE1aFowUXF6MGo3SXBRdjhCZTE0?=
 =?utf-8?B?RGNFYkJhWkIxSFNta3VDaUJUZEJFaUVsZEFkWGlkSWlsdmdiZ2pwb0FKK1p4?=
 =?utf-8?B?RGMrQ0V5MVJYSWplYVltT1RLME4relgrSWZNOWlpRGVPNm9hTXFiTUhGcGwr?=
 =?utf-8?B?RDA4UHR5OUVWQzFDV2hZUWtvanI2MDR3eURQZ0NqclJxTHVzNkZpSHl0S2Z5?=
 =?utf-8?B?MzRrYlpYM213ZEtWWmhYY1IrQUdyUENNS0ZLVTR0VnJRSkFOVmlQV2lmdjB2?=
 =?utf-8?B?R2JtbkRlWnNRQ1FDOE9kMGZIUWxRTTQzRis0Wk03WS83V210WlhoOS8zZzgw?=
 =?utf-8?B?dW1scS9aeEI5bWp3TEJPVFNHV21CaGpnb1hWL010M054ckJoZHdnWDJaVVJO?=
 =?utf-8?B?eEk5Nmw0Z1V3TVNXa0lRUW1NamRMSVBsaVpnamYwTnA1OXFCSFo5RzZ2bkRG?=
 =?utf-8?B?bEtFRHc5YmxRaDdIMlMxYXpuSzFqcmZvTXdMUnRZc2RzTUgxY0ZveHhMMjFE?=
 =?utf-8?B?MFMzeFY5V2xhclFnRm5Uc2o4a2NGZGI5VDZmZnRBQlBsUmRSd0Y0NUlsa2Rt?=
 =?utf-8?B?OHdFbW9CcmVZZXRPS04wemZ4U1AzY09KNHYyUjBTMjhuSWNxTkhIZExsNk9j?=
 =?utf-8?B?THhxdG4vbGZVajlHWE5tZ001dHM1aTlpdk1JZkRUV3R3dWtreWpFSlhVR1hY?=
 =?utf-8?B?V2RkdmxMbk80TnZTbkNLYWZ6Y2grZ0k4cHJwaWNqOUQzR0srbEE0cStBY3Z1?=
 =?utf-8?B?RDBUZ3NHRXdPNFpEZ2pUeTBpVEtxU1lKUW5nZG5Hb05ZTTVoZ1d3OWlpTkpW?=
 =?utf-8?B?Z3ZlZXJiK1RkNnFlenhWTUZZV2Nmc0tDN2NMS0V3eityb3BYOFE0d2F1RFNx?=
 =?utf-8?B?SzB1SzdwbVZDYzJLeTdHMFVBcGZ4SC8xVGcwd3BJa1NDTTFwZm9CR25YK09r?=
 =?utf-8?B?aHdnVHpTNUFIUnRCVmN6d0JOT0dMS1pWZDRlK2hEdDZCSytMU1pHMlR6WVJS?=
 =?utf-8?B?SkRLaXNIZzl1ZldkNWdEVGo1MThsOGQrQU1KaUJYTC9xNEpicURlZUhNYmRI?=
 =?utf-8?B?VVUwc0hNQndSNmZGbFI0aFY1TlZ6Rmx1VGdtOHBpQWVORFBYeE40Vm02a1RL?=
 =?utf-8?B?azA3MjRPc1RIV3g4eWZ0TG1tV2JHdC80Z2RnTTFjVGNkSXZRNC9kenl6N21i?=
 =?utf-8?B?SUg0NjkyRjkwQ3hPSnFQUjVZY1dqM1dXQkhBMGxoQVh0RzFRWmZCK09STXNL?=
 =?utf-8?B?ODdYeGJxZmhrNzE0blYzdStXcVd2ZncrZXFrZzlzcWEwNUo1NllUcGZBdGJt?=
 =?utf-8?B?aWs1QW1CSmE4Zk1BQWlKNkxSMHFpY1dMakRodWRFajZFU2VNbUpUNjFRaWIx?=
 =?utf-8?B?R014ank5SlNrdmhTUDRFeVpiTXNSY1RGeEsyU2hDNGV6QjcvZXI5amVtcTlq?=
 =?utf-8?B?S09XRkdLZFhoUVdhZnE3ZGFpZ3FUbzJQS0syaURucG5PNlpvRVhON2twUXpx?=
 =?utf-8?B?R2tiaHFaYUdVc3VZcHAxaWJtRjNRYUlOSEw3dnpwZlM4aVlkQnRSSXZVN0p0?=
 =?utf-8?B?WWFMNkIrYUd1aSthMnlRbmJFRkoyT2pXZXRJbHAvaWNOc0tXSStweGZKV1Nl?=
 =?utf-8?B?MGdETXdzN3hscHRnTnU5Sm10b0M1cU56REVIY0R6OEZYTHltenFOY1BoWFpF?=
 =?utf-8?B?Mng5c0Qzd053PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUkzRXBORXgvV2t3SnIrSHZ6bUxBQytUdEtsc3BQdHNyZkVMUnR6NTFwa3RL?=
 =?utf-8?B?ZzI2MUZwRHNQZzI2Ykt1a3ZpaWNPSGJYS2hTaUVVVGlMR0ZCclhOWVNEaW5x?=
 =?utf-8?B?eVZjeFpUejhLK0U4MDkzUnVNVXpsTisvTVJlckVBRCtTbGNmSEY0WTIrUFZK?=
 =?utf-8?B?ZXhUUzV5WjdRS0VpUjNCVyswSkhNbjNzd2dUT2djc2w1cEpNWFFIY0ZWenVS?=
 =?utf-8?B?UFovZjgybk5VODkrMnU5NXhYWDVaQ2hVVU12ZHIyZm5ROWFoSkZYR3NoV3J2?=
 =?utf-8?B?NWtwc2d0S0NUS0tDUGMyOTJJakZMeFNWb1p3ZCs3NmMwSllSeGd6blJaL0pm?=
 =?utf-8?B?dmE3WTd2YjFWTjlWV05TV2NOa0p4YU8yOG1uQTdPTkxlTis3NzNUeUxVcFYz?=
 =?utf-8?B?ekVnSFBiZHRlWWx1OG1lSUR1VkZSWExQY3RQZUt4Qm1pQnFnVXlhbjdZck9F?=
 =?utf-8?B?YmZxRktheHFzdDlYZHlmUjE0K2NxNm85ZFR4elRpNkphMGJYanR6K1VsR1Iw?=
 =?utf-8?B?aEgyMVA5RUthUXlGMzY1UmVkMm5NNHZkNGhydHVQY2dzcVNMNitOd0lHSkYz?=
 =?utf-8?B?RUZEMVRtdkVwVXpNL0k1UzYyc0FJZEE3N1dZanZCeDFIQTJweFhRTlRSY282?=
 =?utf-8?B?VWo1L2VkYmRWMUVtUWJ3WWdLS1JyZUpKU2lCT011S0VENEdhWWptQWUrOUZo?=
 =?utf-8?B?dDNLbXNidkpLRkxXck9rVk5WTWNxdGJ6SEJ6R1BOSFNqMGpNTDVsd0ViUnVo?=
 =?utf-8?B?ZXE2TGxkRCtkbWhwamJyYmorV3FRRHRGMGdXcTJFcWszM2hsYlkrNGhVNFJ3?=
 =?utf-8?B?NVRHTWRBZ29zS0NDTHdLZVRwVmFYLy9nSFNSZFlqYnZSSFprVVErTExKL1N2?=
 =?utf-8?B?bng3cnJCeGtVbDhROUdqcmNkKy9qWFNjSEs0QUltYzM0NTRYSlJjS1RTNm1V?=
 =?utf-8?B?b3hQaVhmWTJ1ZFErTGNiVkpvVXN3QWxDU2pkK0QrelZBTlA0SndaUU5qeng4?=
 =?utf-8?B?T0RQQlhWQ3FkL04ycEQ5VHlsZzVYa0ZZOVVCWmhtR04zdFJVWWNVQUlibmVI?=
 =?utf-8?B?LzZxcnhESkpuNHZlNTVQb2FqcjkzZkhQL1pQTWovMlU0dDVKSDlFUWc1bEpp?=
 =?utf-8?B?NCtFVFVBVFgzNEFkSEx0dDY5c3ZEMCtFejM4dm1pRW8vVDlTYTlkcjR6U05P?=
 =?utf-8?B?SFdYOFdmR2p5RVBPT2VzcStuWWdRUGY3aVRqT3pEYlFwbTdzeWpIUWVVOGx6?=
 =?utf-8?B?N3lFeEVmcEVtaWVabUJtRElEV0tsTkFONmVqNnpVSW9ENUIrb21BYmUyLzlX?=
 =?utf-8?B?amlxMnJGcE50WDRVazVKaXRGNDZMOXFsS2dBM0VyajFjVkVjOFh6aXdQQkNT?=
 =?utf-8?B?Q3BMUFJ4VXh1S0tlZklWY0pua3VzdVFJTExBOWtxRDB2R2hFczdkWlhBZXFk?=
 =?utf-8?B?WkxCTDZ6elJoZGhiLy9kT3BWWnJ1ODN3Y2pJMVpLRWxmWW9Sb2ZocDdGclBx?=
 =?utf-8?B?YzR0cU1RYTFvZTdSVnZ1ejJDWm5PZ3hkSEw3ODNwNk50cmVROE9XZ2FkdVN1?=
 =?utf-8?B?ckZ4blZmZXZmS3dWUVptb1lKcDdRd0wxaFN3MlQxVjJqMFFDK3ZDNkR0OURs?=
 =?utf-8?B?dlFXWmdDZ0o0V21sak84WjVnek1PWGpXS1hqd2RSOVloT2FqVmh0RmRvc3dB?=
 =?utf-8?B?djZ2RjlCNUZUSVJuTVdMYnZTd2ZoaWVnK21GVFY2c2Ftcy9zYnNoTmRXS1lj?=
 =?utf-8?B?L3R0THhGZE5EWFhLeWkwS3hvbHVYTXh6TlI4bGZPbFUvbGVTQkxNSkxsQU5J?=
 =?utf-8?B?ZWlNb2EwWk9nK0ZGTHpUdEk3MmFNM3kwUXNuT3pWUnpGTjFmcFU5QUx6Ynp2?=
 =?utf-8?B?NHVHTkw2dDRITmZjeFAwd2NLV2NNRTFpVlVDYlYxTHhodTVIVlFCNzUxY0M5?=
 =?utf-8?B?MFZ3ZGwwa29iM0ZUMGtnWE51bjA0empqYVk4Uzh4cEcxOGNkTExTTnBVeDhs?=
 =?utf-8?B?OU9rZkhQQ2wrRmlERjZVMmZndnFFRWx3ZFVFUmJ4NHE5QnJ4VnRSblppNmQx?=
 =?utf-8?B?VUNzd3V2UWJEUkJPTGxIU01aSnNHT3g2WlJYeTNGYXQwbXZ3bHFLQ2ltVnFl?=
 =?utf-8?B?YnF2TEN0VHJaZTRXOER4UGp6V1JWR2lvVnA5aUVMK2syNTZndEpXeDVlbGpa?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15410E8FE0C24A4E8D4C319BA06980F4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0e8212f-7ea4-40f9-778d-08dd96fc817f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 17:42:20.4847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DuZ8tBDpz7Cdg4jFzgg16tqMvBOAHnrM13bmTtnGSchkfS62+WmGvfbNSIni1fGh/Dp/wttB1f3pt9GWBSQAaVnxyjhD5sDUeTuFMltRoF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5257
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDExOjU3ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gTGlr
ZSBiZWxvdz8NCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYyBi
L2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jDQo+IGluZGV4IDFiMmJhY2RlMDA5Zi4uMGU0YTAz
ZjQ0MDM2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KPiArKysg
Yi9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KPiBAQCAtMTI3NSw2ICsxMjc1LDExIEBAIHN0
YXRpYyBpbnQgdGRwX21tdV9saW5rX3NwKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IHRkcF9pdGVy
ICppdGVyLA0KPiDCoMKgwqDCoMKgwqDCoCByZXR1cm4gMDsNCj4gwqB9DQo+IA0KPiArc3RhdGlj
IGlubGluZSBib29sIGlzX2ZhdWx0X2Rpc2FsbG93X2h1Z2VfcGFnZV9hZHVzdChzdHJ1Y3Qga3Zt
X3BhZ2VfZmF1bHQgKmZhdWx0LCBib29sIGlzX21pcnJvcikNCj4gK3sNCj4gK8KgwqDCoMKgwqDC
oCByZXR1cm4gZmF1bHQtPm54X2h1Z2VfcGFnZV93b3JrYXJvdW5kX2VuYWJsZWQgfHwgaXNfbWly
cm9yOw0KPiArfQ0KDQpFcnIsIG5vLiBJdCBkb2Vzbid0IHNlZW0gd29ydGggaXQuDQoNCj4gKw0K
PiDCoC8qDQo+IMKgICogSGFuZGxlIGEgVERQIHBhZ2UgZmF1bHQgKE5QVC9FUFQgdmlvbGF0aW9u
L21pc2NvbmZpZ3VyYXRpb24pIGJ5IGluc3RhbGxpbmcNCj4gwqAgKiBwYWdlIHRhYmxlcyBhbmQg
U1BURXMgdG8gdHJhbnNsYXRlIHRoZSBmYXVsdGluZyBndWVzdCBwaHlzaWNhbCBhZGRyZXNzLg0K
PiBAQCAtMTI5Nyw3ICsxMzAyLDcgQEAgaW50IGt2bV90ZHBfbW11X21hcChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsIHN0cnVjdCBrdm1fcGFnZV9mYXVsdCAqZmF1bHQpDQo+IMKgwqDCoMKgwqDCoMKg
IGZvcl9lYWNoX3RkcF9wdGUoaXRlciwga3ZtLCByb290LCBmYXVsdC0+Z2ZuLCBmYXVsdC0+Z2Zu
ICsgMSkgew0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50IHI7DQo+IA0KPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoZmF1bHQtPm54X2h1Z2VfcGFnZV93b3Jr
YXJvdW5kX2VuYWJsZWQgfHwgaXNfbWlycm9yKQ0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBpZiAoaXNfZmF1bHRfZGlzYWxsb3dfaHVnZV9wYWdlX2FkdXN0KGZhdWx0LCBpc19taXJy
b3IpKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRp
c2FsbG93ZWRfaHVnZXBhZ2VfYWRqdXN0KGZhdWx0LCBpdGVyLm9sZF9zcHRlLCBpdGVyLmxldmVs
LCBpc19taXJyb3IpOw0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qDQo+
IA0KPiANCj4gDQo+ID4gQWxzbywgd2h5IG5vdCBjaGVjayBpc19taXJyb3Jfc3AoKSBpbiBkaXNh
bGxvd2VkX2h1Z2VwYWdlX2FkanVzdCgpIGluc3RlYWQgb2YNCj4gPiBwYXNzaW5nIGluIGFuIGlz
X21pcnJvciBhcmc/DQo+IEl0J3MgYW4gb3B0aW1pemF0aW9uLg0KDQpCdXQgZGlzYWxsb3dlZF9o
dWdlcGFnZV9hZGp1c3QoKSBpcyBhbHJlYWR5IGNoZWNraW5nIHRoZSBzcC4NCg0KSSB0aGluayBw
YXJ0IG9mIHRoZSB0aGluZyB0aGF0IGlzIGJ1Z2dpbmcgbWUgaXMgdGhhdA0KbnhfaHVnZV9wYWdl
X3dvcmthcm91bmRfZW5hYmxlZCBpcyBub3QgY29uY2VwdHVhbGx5IGFib3V0IHdoZXRoZXIgdGhl
IHNwZWNpZmljDQpmYXVsdC9sZXZlbCBuZWVkcyB0byBkaXNhbGxvdyBodWdlIHBhZ2UgYWRqdXN0
bWVudHMsIGl0J3Mgd2hldGhlciBpdCBuZWVkcyB0bw0KY2hlY2sgaWYgaXQgZG9lcy4gVGhlbiBk
aXNhbGxvd2VkX2h1Z2VwYWdlX2FkanVzdCgpIGRvZXMgdGhlIGFjdHVhbCBzcGVjaWZpYw0KY2hl
Y2tpbmcuIEJ1dCBmb3IgdGhlIG1pcnJvciBsb2dpYyB0aGUgY2hlY2sgaXMgdGhlIHNhbWUgZm9y
IGJvdGguIEl0J3MNCmFzeW1tZXRyaWMgd2l0aCBOWCBodWdlIHBhZ2VzLCBhbmQganVzdCBzb3J0
IG9mIGphbW1lZCBpbi4gSXQgd291bGQgYmUgZWFzaWVyIHRvDQpmb2xsb3cgaWYgdGhlIGt2bV90
ZHBfbW11X21hcCgpIGNvbmRpdGlvbmFsIGNoZWNrZWQgd2l0aGVyIG1pcnJvciBURFAgd2FzDQoi
YWN0aXZlIiwgcmF0aGVyIHRoYW4gdGhlIG1pcnJvciByb2xlLg0KDQo+IA0KPiBBcyBpc19taXJy
b3Jfc3B0ZXAoaXRlci0+c3B0ZXApID09IGlzX21pcnJvcl9zcChyb290KSwgcGFzc2luZyBpbiBp
c19taXJyb3IgYXJnDQo+IGNhbiBhdm9pZCBjaGVja2luZyBtaXJyb3IgZm9yIGVhY2ggc3AsIHdo
aWNoIHJlbWFpbnMgdW5jaGFuZ2VkIGluIGEgcm9vdC4NCg0KV2h5IG5vdCBqdXN0IHRoaXMuIEl0
IHNlZW1zIGVhc2llciB0byBjb21wcmVoZW5kIHRvIG1lLiBJdCBkb2VzIGFkZCBhIGxpdHRsZSBi
aXQNCm9mIGV4dHJhIGNoZWNraW5nIGluIHRoZSBzaGFyZWQgZmF1bHQgZm9yIFREWCBvbmx5LiBJ
IHRoaW5rIGl0J3Mgb2sgYW5kIGJldHRlcg0Kbm90IHRvIGxpdHRlciB0aGUgZ2VuZXJpYyBNTVUg
Y29kZS4NCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMgYi9hcmNoL3g4Ni9r
dm0vbW11L21tdS5jDQppbmRleCBhMjg0ZGNlMjI3YTAuLjM3Y2E3N2YyZWUxNSAxMDA2NDQNCi0t
LSBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCisrKyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMN
CkBAIC0zMzI4LDExICszMzI4LDEzIEBAIHZvaWQga3ZtX21tdV9odWdlcGFnZV9hZGp1c3Qoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LA0Kc3RydWN0IGt2bV9wYWdlX2ZhdWx0ICpmYXVsdA0KIA0KIHZv
aWQgZGlzYWxsb3dlZF9odWdlcGFnZV9hZGp1c3Qoc3RydWN0IGt2bV9wYWdlX2ZhdWx0ICpmYXVs
dCwgdTY0IHNwdGUsIGludA0KY3VyX2xldmVsKQ0KIHsNCisgICAgICAgc3RydWN0IGt2bV9tbXVf
cGFnZSAqIHNwID0gc3B0ZV90b19jaGlsZF9zcChzcHRlKTsNCisNCiAgICAgICAgaWYgKGN1cl9s
ZXZlbCA+IFBHX0xFVkVMXzRLICYmDQogICAgICAgICAgICBjdXJfbGV2ZWwgPT0gZmF1bHQtPmdv
YWxfbGV2ZWwgJiYNCiAgICAgICAgICAgIGlzX3NoYWRvd19wcmVzZW50X3B0ZShzcHRlKSAmJg0K
ICAgICAgICAgICAgIWlzX2xhcmdlX3B0ZShzcHRlKSAmJg0KLSAgICAgICAgICAgc3B0ZV90b19j
aGlsZF9zcChzcHRlKS0+bnhfaHVnZV9wYWdlX2Rpc2FsbG93ZWQpIHsNCisgICAgICAgICAgIChz
cC0+bnhfaHVnZV9wYWdlX2Rpc2FsbG93ZWQgfHwgc3AtPnJvbGUuaXNfbWlycm9yKSkgew0KICAg
ICAgICAgICAgICAgIC8qDQogICAgICAgICAgICAgICAgICogQSBzbWFsbCBTUFRFIGV4aXN0cyBm
b3IgdGhpcyBwZm4sIGJ1dCBGTkFNRShmZXRjaCksDQogICAgICAgICAgICAgICAgICogZGlyZWN0
X21hcCgpLCBvciBrdm1fdGRwX21tdV9tYXAoKSB3b3VsZCBsaWtlIHRvIGNyZWF0ZSBhDQpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11L3Rk
cF9tbXUuYw0KaW5kZXggNDA1ODc0ZjRkMDg4Li4xZDIyOTk0NTc2YjUgMTAwNjQ0DQotLS0gYS9h
cmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KKysrIGIvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11
LmMNCkBAIC0xMjQ0LDYgKzEyNDQsOCBAQCBpbnQga3ZtX3RkcF9tbXVfbWFwKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwgc3RydWN0DQprdm1fcGFnZV9mYXVsdCAqZmF1bHQpDQogICAgICAgIHN0cnVj
dCB0ZHBfaXRlciBpdGVyOw0KICAgICAgICBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpzcDsNCiAgICAg
ICAgaW50IHJldCA9IFJFVF9QRl9SRVRSWTsNCisgICAgICAgYm9vbCBodWdlcGFnZV9hZGp1c3Rf
ZGlzYWxsb3dlZCA9IGZhdWx0LT5ueF9odWdlX3BhZ2Vfd29ya2Fyb3VuZF9lbmFibGVkDQp8fA0K
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAga3ZtX2hhc19taXJyb3Jl
ZF90ZHAoa3ZtKTsNCiANCiAgICAgICAga3ZtX21tdV9odWdlcGFnZV9hZGp1c3QodmNwdSwgZmF1
bHQpOw0KIA0KQEAgLTEyNTQsNyArMTI1Niw3IEBAIGludCBrdm1fdGRwX21tdV9tYXAoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3QNCmt2bV9wYWdlX2ZhdWx0ICpmYXVsdCkNCiAgICAgICAg
Zm9yX2VhY2hfdGRwX3B0ZShpdGVyLCBrdm0sIHJvb3QsIGZhdWx0LT5nZm4sIGZhdWx0LT5nZm4g
KyAxKSB7DQogICAgICAgICAgICAgICAgaW50IHI7DQogDQotICAgICAgICAgICAgICAgaWYgKGZh
dWx0LT5ueF9odWdlX3BhZ2Vfd29ya2Fyb3VuZF9lbmFibGVkKQ0KKyAgICAgICAgICAgICAgIGlm
IChodWdlcGFnZV9hZGp1c3RfZGlzYWxsb3dlZCkNCiAgICAgICAgICAgICAgICAgICAgICAgIGRp
c2FsbG93ZWRfaHVnZXBhZ2VfYWRqdXN0KGZhdWx0LCBpdGVyLm9sZF9zcHRlLA0KaXRlci5sZXZl
bCk7DQogDQogICAgICAgICAgICAgICAgLyoNCg0KIA0KICAgICAgICAgICAgICAgIC8qDQoNCg==

