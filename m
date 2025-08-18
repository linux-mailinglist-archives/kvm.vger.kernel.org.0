Return-Path: <kvm+bounces-54902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D358B2B0D9
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:51:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E2E8684BA4
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 18:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E17273809;
	Mon, 18 Aug 2025 18:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DEi5qTD2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F35272E65;
	Mon, 18 Aug 2025 18:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755542989; cv=fail; b=nx3MMnQoqQ6k62IcPxU7jUJaUTuUjUIIpKXUDk7GUx0T6XRaVcS/CfTdOdNRdVxAPnNS4DJgklRrFHeXOZYz40PgnUyHMYXoRKAXI+xGA1ZaVds9DAIRHfu74QlEUAjdaAbUCBKnnd+bwrXmgbqOdVSd5eyfBOBb0uHjsrbuLQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755542989; c=relaxed/simple;
	bh=Zuy+ifm8G3CY3/TXkH5eqrk7pKwE4jIKntrlYqyZpFI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fzvj3o73n3SmHJ7Q0fgzlr8jjbQvd7QHxaZofGkhBGCyHb9r19o2pTukrEaxO0XpKn+IkzqTqnT66gsQPWLPR7iS6fEsrDXFEVx4tiF4PO37IJ1Ociyz8Kl5CNMjt3OGgfJwoNxXkFGlD4B65wIpiB6Og5iYIpahDZ+68X3ryVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DEi5qTD2; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755542987; x=1787078987;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Zuy+ifm8G3CY3/TXkH5eqrk7pKwE4jIKntrlYqyZpFI=;
  b=DEi5qTD24qSpnGJa+dIS1hJXjw47kVN5Gzf4mYYQM5DA0iIlvVQo2nJB
   FgxGnPm9CvLgwPSAvSWf4iWtcl4698zIVxnNv88gz4gC0aNdK/tuzkVff
   y6heic9yMsTGQjNhTCHmjxdnVdBZoIOUY1YhFY8UBziWIRY66njExILRj
   mxeo2WFGNUPEFvby6xQeHwUGq99edPVkVOd+e49vrf5IQ0ydt0lzfq8Yw
   rammFNQVt5uTP2fwEC/9+binBkLjWCJyB/3YTH69kp8OtMOKEIAXZXOPv
   eCi+OOb5FvWNx642wnmQTuGkxBGwphwwHGJKvqPxVzbL0/2W/YRNY6kQ2
   Q==;
X-CSE-ConnectionGUID: H7eeEXplTeKonnzf3xBbDw==
X-CSE-MsgGUID: R2wLRF1NR/Snd5y7E7auaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11526"; a="56982520"
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="56982520"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 11:49:46 -0700
X-CSE-ConnectionGUID: OB36xasmThm6YUV8HXRA0w==
X-CSE-MsgGUID: YsMVsZagQGSZjR3PD14phQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="172861962"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 11:49:46 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 18 Aug 2025 11:49:45 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 18 Aug 2025 11:49:45 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.53) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 18 Aug 2025 11:49:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H47cxSquXBGc7CG0JyTpZYl+w/8b0JgbiJjHJ0vWuea75O0as8nLi+oR+iCHVK0s/wvy7wknJ83qk8dnyVIP+bfQjzMYVJXwm+dxYsnJcKEWnS0cjrjYpFQCbragGujxpdRWTyHEIoEsRrQIrTOetbpVu+/mkY9C5gkJXhzB4/1J0q8WE9vkW0badtG/7L9Bn7i23wGGksHGYsmzB516ZOjE0/BjxevSef0WnhI61Nmc07z4Kmmw7oXBCqZTQIXBjEpPCFbF2M0Ps01Ipgks/7Ty2qmN4Hj+Ayl5BkkqeNqFPGDNMPkmh+2hLV3aAOPpWVdj4h4s4TONQeOtB6RoXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zuy+ifm8G3CY3/TXkH5eqrk7pKwE4jIKntrlYqyZpFI=;
 b=YqKd76KT2qSHTL9rwcOP0rlCHdbX3rfQrjexft8uvTPjWzQQF2ymXfNkm8zbrmUAR5Vm+O6HVIaSclSpr9iwKXL5zlVncK5wIzyho7MlO4KAB0GeLsAqq3IevWS5xJ/jOf5BezZLy5zhlmOFWzzgNyx48vMnV+nKPZcDYmgppBPQnwgZFbC4aXcigrD/bhlE7fjwvwZsMuylBvK8CDi3m0XeXw3MqVOWJfaOaU2/f9d7YrZ5d5E4ommYuVI9VjPU15Pu2yx7pDO9w83FBtGyf0MFBPkNXkhlXA37XJylHW7bYk8GW8cFuuL7C3lVeizd1BFZRGV5CpUXGHWS47a6Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB5868.namprd11.prod.outlook.com (2603:10b6:a03:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 18:49:43 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 18:49:43 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in
 guest
Thread-Topic: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in
 guest
Thread-Index: AQHcDrxaRC2HgQTKCkiAAwmmnxOsO7RodPeAgABPRoA=
Date: Mon, 18 Aug 2025 18:49:42 +0000
Message-ID: <136ab62e9f403ad50a7c2cb4f9196153a0a2ef7c.camel@intel.com>
References: <20250816144436.83718-1-adrian.hunter@intel.com>
	 <20250816144436.83718-2-adrian.hunter@intel.com>
	 <aKMzEYR4t4Btd7kC@google.com>
In-Reply-To: <aKMzEYR4t4Btd7kC@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB5868:EE_
x-ms-office365-filtering-correlation-id: 358e0644-9995-4850-9980-08ddde87fea1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VWo0cmFtbGRzdkpGcGFCQkM2UzZtaGdqeWJmRkxKMi9zbE9BREp5bmZsWVlR?=
 =?utf-8?B?ZmRzc3FmS3E4cmVjd2tkUEpFYW5kQjVBb0JqZW5RcUJRUzd4aFFoWUNIVzYx?=
 =?utf-8?B?NTk5K25sTTc2di9YYzVraEdhT21OVG5LU1ZObENmRzd5SWNHcUd4dU5qKzln?=
 =?utf-8?B?VkIzMjc3aGpsNk14Q25iZ1U5RnBUajNkTTl2OENWY0ZGOTMvYmowMTVXR1M0?=
 =?utf-8?B?NUtTbzB1WkxRUzExS0FpS3VNVVlLbkQ1OTFEYmZYNXFqRURkMHRvcW9ydEU2?=
 =?utf-8?B?OWl2d3RsZXRXTnRHTmxCT2xuRmt4RW1Nb0xidm0rd2RtdkdQQUk1MHpmaHBS?=
 =?utf-8?B?Vlpid0poalFpMCtEVmZxYkJOeW90d0d0N0xSaHIxSWJSVEE1MWg5WDFsMGN2?=
 =?utf-8?B?VndaYklkekdTbk9TMGE1OSs2TGZVWTFKU3NqVUZmOTNzNko5YmlWZTNlbVZI?=
 =?utf-8?B?Zk1tbUZENjZuWjRjb1VPd244a1ZYNG5ydEQxRHBEOFJvY2wvdkhJV1ROUFA1?=
 =?utf-8?B?YjRWdURKNS9RS05wUjI2dG1RNUVkNHdIaHcxMmQvaW9lSkp0WHhTak9BVVc1?=
 =?utf-8?B?TDlqYlFlSytBNWszNWx6eFBWQThObm1yV0xNbHA4N3JVYzVVM0QxNzYwQVh6?=
 =?utf-8?B?MXd4ZTlaejJMbEV4SHl0OEYxbEJIWDB1N25ieGhRUFovRGREemxUNnRDS2ky?=
 =?utf-8?B?RVMydk1uOTlid0RHaDBtNERUTjBMSUErT1dnUWJTSHZKNFJhdXl3WjJsQzN2?=
 =?utf-8?B?SXZzK1NyWnlqMk1YREZlVEhwWEdMSXAvS1g0MjV0Wjk2ZFM2Um5yL3ZnWFpr?=
 =?utf-8?B?c25ndXZKSUlwT3Q4QmZqYmk2M3RIaHlCRUxQZXM0dUpxNDFwZkoxbW1hNEwy?=
 =?utf-8?B?OTljMHJ0SjdHOW5JSXZDclNsRWRzZE9yVS8wdzZ0eHgrRTNTNlcvZmkxaFd2?=
 =?utf-8?B?d1hlWi9UT1R0MS9mM2hIeERlemFUWXJ0bDBHWFVNMWVmTE1RV1NKdnQ2YkpI?=
 =?utf-8?B?Z1VGOXArYVFzRUtmUVdmNTlzZWJJOEZNT1pkQ2RVVHR2a3QzU0FaNVBGZFVW?=
 =?utf-8?B?WXZTdXNEN3JiakRDQTUwZ0dTNXljMEdYUjVuR1M3MUI5SzNydDAzT1lyUFFp?=
 =?utf-8?B?Vy9zV2RyTVE1YXc1dk9EVWRZbFB6L3hVczBsMEtiSC9waWJkaTZLQ3UrQTBu?=
 =?utf-8?B?d3h0NjFoUG1aRTZwbHI3bDFKYTBvNmZzZVNTMWEvRnRGRExETnlQKy90S0hE?=
 =?utf-8?B?cUt5dlkzQWUrN05ZelkxanYyeDd1TXZtZGgvcE9yRUVsYXB2Vk5QZXBmdmda?=
 =?utf-8?B?NmJKeWY1RmNxbWVsVkY5c05HWDI5LzA4U3Fkb1RsdFdiVW5JdThVNUpaaG5K?=
 =?utf-8?B?aFg3dmdCS1dtcCtLakhvUWNNdHhtUTVtTngrNVlWS2t4c3B3bVFwK0VZS01n?=
 =?utf-8?B?VU4rUjhmYVQyMjRzNGNkcVRHeGpudkJWQStVelhCSEhORnFyZVI2UVA2bTBs?=
 =?utf-8?B?T3dJSjNLS1hTTnRIU3Y2dEZRZFdTS1pUbkUrbGRSRmZYdC9OQnZhd0cwQkQr?=
 =?utf-8?B?Nmt2TDJWemlEOEx0Q3VRaHRGMUlzQmxVTUxOWmFoZTd3WW5sKzFDNXVaZ2Mw?=
 =?utf-8?B?eXpiSUlldWFoQi9LU0Q4YVFwLy85N1djcjdWL0NBSVdwRXIrazl5WEZGcGVs?=
 =?utf-8?B?bEhFZ2Y0Q0s2d3JHR2FHaWF2TjFaOVY0QXV4MlBRV3l5c2ltcFJSUG5QQ243?=
 =?utf-8?B?eVg3M3NRcjJBcnFFRTBXVi9rRHBrUkQ2eTl0cFM1bkRCWUQ2L2x6aEc5L0ph?=
 =?utf-8?B?VWRQcSs2KzM1bmFKWmtOTXhJUjB0U21RZFZWampOaTlWelBTNTVJZlRvcGhq?=
 =?utf-8?B?SHo1MU9kL2l5UUhIMm0wZXpWYjh1ZnVxdVpVNHJ5dHAxWmVTMWJkYTROUitC?=
 =?utf-8?B?RWxUZmpPTGNhaUFWU3lOd0ZsQU9Fb25uTyt5KzhIK3FFZGJhY2lJdFk2OEkx?=
 =?utf-8?B?K284TlptczFnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVR3dHFJL1lPOHJoL29EODQ4azJFK1MxZGsvdnVFWURTVmZXbVdkQ0FLc3hN?=
 =?utf-8?B?WlppRXlhdFZQMWg2MDdEdWJ2RzVMRTljOUZ5QjRmUjV2eE1LYmVTV1ptbDFT?=
 =?utf-8?B?Qm9tN015Zi8yYWhnaVBJZlRuV1dTdFFvZ2I2dndrQksvbkR2MTJhQWM1N0lu?=
 =?utf-8?B?UjhmTG5NYkphOEtiaDB3MnkvSjBsUW94anhETE1DNllhWjdQcWNLQTdmSWNR?=
 =?utf-8?B?bERLTVh0ek9VQTVkYXpLMUovZ0dpUkRLOWV0OVBEZUVGZkFlNnB3QnFObzFJ?=
 =?utf-8?B?aEs0STVab1dGeGdNZnQybG5PMnZuSDRVUUJEYW4xVjE0d3RJazkrZkJrQ25z?=
 =?utf-8?B?cGdqWUZQVTMyUjROWlgzZVJPMTRWc2ZlRDdNM3lnRk1kdE5lR1NBUnVERlZU?=
 =?utf-8?B?cjJSbEs0dlNkWmFOaFBMVzNHQXA2UjJJTG9hanhsaW5UQ21pVVgwWVFWbjhi?=
 =?utf-8?B?c3dvSmJXb2dqajYxTmp3VDk3L1JCUklRRGVnbjZGbzhkOVpGRndnNEhjMHNv?=
 =?utf-8?B?SVJ0SllWbDJnWnI4M1VVazdOK0FpRTJjTmdJa21yMzRjQmE0eUwyd1Bubk04?=
 =?utf-8?B?bnllMTA0cUxTa282MzJoZThHdzZjS21TblpiOE9mbW0zenZSWEErUWJSRUFY?=
 =?utf-8?B?WDd4eS9MT2VDdThldGM1NmF5dDFmcjIra0ZldHc0cUFTeEZYNmZmbmRtbnNZ?=
 =?utf-8?B?amtPMVd6cHAyd0xnV1g5bUVydFpPSnFERkNaRkJpQTcrMDZDZnpHcWJqK0hi?=
 =?utf-8?B?djBaOCtHZU4rZDljeVdPTjc2SGw1UXRpVTJMdDRWNUI3V1hXVzNWbHZ4cFR4?=
 =?utf-8?B?ZUNsRUFCNzNTYU1ydmpGZE1hYWhocFQ2R3VXZVlncUZ2TGVQaGFLWGlmN09t?=
 =?utf-8?B?RXNVaTYwcDZOQlBvT1dTcDhZUDA3cGczQmxSOUR1VHc3UE0xRWQvRUxYWHJp?=
 =?utf-8?B?WlpleU43TzRNdFlPK2RHQWR1MXkvVm5OMTlzeG9HQkV3NUFTN1dFM3hBWkNw?=
 =?utf-8?B?ZnVIZ1YyS0dER2lBRllHRENGYVRLZ1BJK0c3SDlDUTFyU1ErdFE4UGRBUnpG?=
 =?utf-8?B?Uk5DaEN6K3MwS0RvcHdnNW9FQXhtSEd3R1lIT0psZUwrV29KRWJFbGdiMzBT?=
 =?utf-8?B?TDBBd0FNNFVta0xMV0Y5VlQ5Z2o4YzBoZE1DSTdWYUhYSjFEc0p2RnJ4VTJ2?=
 =?utf-8?B?em5hMzhIbjcxbDA1aVJ4b0k1TTRteHlia0FLS3Jybno4SzV1YUpsVFZ2K1Ft?=
 =?utf-8?B?ajNLVlVLRlZHMFlGL1dldFhMVTBxM3g2UGJIb2tmOHZKUzFDMDNMY0R2YnRD?=
 =?utf-8?B?R3V1M0Z5bndNak5UQmFIR2tzVmxodEt0Q2hhU3Q0UnhadmZuS0o3WkNkcXFx?=
 =?utf-8?B?bzBEelY5d3ZLcElVVGVjMTQrU1IzK0J1VCtMeTgrY1JCbWl2dm44bjBrNzFD?=
 =?utf-8?B?YW16VVkxYXhkVERWL3BiYXRUSTVOQUVmdnBJQ2Urd3d6SDFIbDBwYXNSYjdo?=
 =?utf-8?B?cVVGVi93RzdUYWVONGZKSkRYRUJnWm9nejVpMjJ5YngwaXZFOGlBaDhQVElS?=
 =?utf-8?B?ZVdRL0lHRUhtRFFvTHJjYk1lWHFVRjBBL3diZlJzUlUydU9Qc1ZTVFNGWEpI?=
 =?utf-8?B?dXdiYkVwUUJjMllBVWVJZTk3RDlXVm92UDE0ejlHMkhMMGlseHdBNVE4MEg4?=
 =?utf-8?B?RlY0MFR2YVlGOHhmWTVWeGw1ZVFzVDNER2NBZFhDajVpT2dnRC93UWhLaU1D?=
 =?utf-8?B?M0Y5aDV3a2JWRXI3bHhNbTRyRzhEdng5R0FmQnp0MWtJYytsMGRieXhUcysz?=
 =?utf-8?B?R0VUdHBXeWUrWUJBa3E0NjdDNzNOY0lFSUFpaFZjUzMrRHVmZ3lRdU9hWDVX?=
 =?utf-8?B?S281NFZSQkRXSTRSTUNuOTQ4QzBDVE9NTDR3RGQ5U0NNRHBXT0VtUmZkSkxD?=
 =?utf-8?B?NjZwdzM0WUdyZXdNdDcyc3B3R0R6cFZKcGI3S3FOYkxTZ1FvYk9BVmtXYkhS?=
 =?utf-8?B?N0daT2VFeWRvaGlzS2M1a0NBbUxJaTlQbXBkWGdnM0pveTcvVjVOOGQvbUs0?=
 =?utf-8?B?eVowdVhWNmJjakRsdTVhOHJSc0RyNXpxU3kyQ1U4SytmQXFsSit3N2g3UjZy?=
 =?utf-8?B?L2JEaVZaK1BjcjgvbWF5MGIrbUNPWk9jYVN5b2FDMGZjaUZXSGhoVnAyNzlU?=
 =?utf-8?B?eUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <120A00D93E12A44BBB0A5428E834740A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 358e0644-9995-4850-9980-08ddde87fea1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2025 18:49:43.0198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qGQtGqBAn/ZNPilEh2wn4Bcyirq8s+yVRugV8/sfKmew8+QcVZTXKIxNQj+O4/2Qcf53ui+XU7H6FtErdRNBilSJc43Yj1MUvx91z0+iWMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5868
X-OriginatorOrg: intel.com

QXR0bjogQmluYmluLCBYaWFveWFvDQoNCk9uIE1vbiwgMjAyNS0wOC0xOCBhdCAwNzowNSAtMDcw
MCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gTkFLLg0KPiANCj4gRml4IHRoZSBndWVz
dCwgb3Igd2hlcmV2ZXIgZWxzZSBpbiB0aGUgcGlsZSB0aGVyZSBhcmUgaXNzdWVzLsKgIEtWTSBp
cyBOT1QgY2FycnlpbmcNCj4gaGFjay1hLWZpeGVzIHRvIHdvcmthcm91bmQgYnVnZ3kgc29mdHdh
cmUvZmlybXdhcmUuwqAgQmVlbiB0aGVyZSwgZG9uZSB0aGF0Lg0KDQpZZXMsIEkgd291bGQgaGF2
ZSB0aG91Z2h0IHdlIHNob3VsZCBoYXZlIGF0IGxlYXN0IGhhZCBhIFREWCBtb2R1bGUgY2hhbmdl
IG9wdGlvbg0KZm9yIHRoaXMuDQoNCkJ1dCBzaWRlIHRvcGljLiBXZSBoYXZlIGFuIGV4aXN0aW5n
IGFyY2ggVE9ETyBhcm91bmQgY3JlYXRpbmcgc29tZSBndWlkZWxpbmVzDQphcm91bmQgaG93IENQ
VUlEIGJpdCBjb25maWd1cmF0aW9uIHNob3VsZCBldm9sdmUuDQoNCkEgbmV3IGRpcmVjdGx5IGNv
bmZpZ3VyYWJsZSBDUFVJRCBiaXQgdGhhdCBhZmZlY3RzIGhvc3Qgc3RhdGUgaXMgYW4gb2J2aW91
cyBuby0NCm5vLiBCdXQgaG93IGFib3V0IGEgZGlyZWN0bHkgY29uZmlndXJhYmxlIGJpdCB0aGF0
IGNhbid0IGh1cnQgdGhlIGhvc3QsIGJ1dA0KcmVxdWlyZXMgaG9zdCBjaGFuZ2VzIHRvIHZpcnR1
YWxpemUgaW4gYW4geDg2IGFyY2ggY29tcGxpYW50IHdheT8gKG5vdCBxdWl0ZQ0KbGlrZSB0aGlz
IE1XQUlUIGNhc2UpDQoNCkluIHNvbWUgd2F5cyBLVk0gc2hvdWxkbid0IGNhcmUgc2luY2UgaXQn
cyBiZXR3ZWVuIHVzZXJzcGFjZSBhbmQgdGhlIFREWCBtb2R1bGUuDQpCdXQgdXNlcnNwYWNlIG1h
eSB0cnkgdG8gc2V0IGl0IGFuZCB0aGVuIHdlIHdvdWxkIGhhdmUgYSBzaXR1YXRpb24gd2hlcmUg
dGhlIGJpdA0Kd291bGQgcmVtYWluIG1hbGZ1bmN0aW9uaW5nIHVudGlsL2lmIEtWTSBkZWNpZGVk
IHRvIGFkZCBzdXBwb3J0IGZvciB0aGUgYml0LiBJZg0KS1ZNIG5ldmVyIGRpZCB0aGVuIGl0IHdv
dWxkIGJlIHNpbGVudGx5IGJyb2tlbi4gSXQncyBub3QgYSBrZXJuZWwgcmVncmVzc2lvbiwNCmJ1
dCBub3QgZ3JlYXQgZWl0aGVyLg0KDQpJZiB3ZSByZXF1aXJlZCBzb21lIG90aGVyIG9wdC1pbiBm
b3IgZWFjaCBzdWNoIGZlYXR1cmUsIGl0IHdvdWxkIGZ1cnRoZXINCmNvbXBsaWNhdGUgdGhlIENQ
VUlEIGJpdCBjb25maWd1cmF0aW9uIGludGVyZmFjZS4gSSB0aGluayBJJ2QgcmF0aGVyIGtlZXAN
CmRpcmVjdGx5IGNvbmZpZ3VyYWJsZSBDUFVJRCBiaXRzIGFzIHRoZSBtYWluIHdheSB0byBjb25m
aWd1cmUgdGhlIFRELg0KDQpNYXliZSB3ZSBjb3VsZCBoYXZlIHRoZSBURFggbW9kdWxlIGVudW1l
cmF0ZSB3aGljaCBkaXJlY3QgYml0cyByZXF1aXJlIFZNTQ0KZW5hYmxpbmcgYW5kIEtWTSBjb3Vs
ZCBhdXRvbWF0aWNhbGx5IGZpbHRlciB0aGVtPyBTbyB0aGVuIFREWCBtb2R1bGUgY291bGQgYWRk
DQpzaW1wbGUgZmVhdHVyZSBiaXRzIHdpdGhvdXQgZnVzcywgYnV0IEtWTSBjb3VsZCBtYW51YWxs
eSBlbmFibGUgdGhlIGJpdHMgdGhhdA0KcmVxdWlyZSBjb25zaWRlcmF0aW9uLg0K

