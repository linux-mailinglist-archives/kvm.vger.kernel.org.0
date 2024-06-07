Return-Path: <kvm+bounces-19097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01A4C900DEE
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:12:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E97991C21490
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 22:12:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC0110A24;
	Fri,  7 Jun 2024 22:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KPEksRKr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1A84E1DD;
	Fri,  7 Jun 2024 22:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717798353; cv=fail; b=UksuO7fc30rIe+LQHaAGhoHJwJlSm75JzKpHbOM3bQYEwCO2ExJz99FDsTpDERvCwWuE2XQUPXnYReK6NZqVFxtFLwr/BAHZbQyXP/S/zUWO6lXb92M+VohzfJIMwtsKfESD8oh1hNOie5GkaoPbD7VUIpff7qsORJBIB0JtBYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717798353; c=relaxed/simple;
	bh=CNbGn2qy+rVE38aj8yGKSoUyBAnpheoxTq6UOgHsrR4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BkrG0OF/mzoWt3CL1Q552KT7H9OZ68whSRXFO22Do7KIByIl8HPimyGQQ0N+hWGmUd+Q2LAVEhAnE/RZw3TBele/ofwCccb/Q8PsKxGMYC884H9EfNILyhYiXfp9UG46d/L2tMWJnpcghwPm6rbqNzYz+N5zRwUUxVheVL0BFWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KPEksRKr; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717798351; x=1749334351;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CNbGn2qy+rVE38aj8yGKSoUyBAnpheoxTq6UOgHsrR4=;
  b=KPEksRKr3grh2AJdCqJr7r0zsiX7SffAiGT75LRtlc/8mMkn4kZg/B8q
   6L6MwZniau5jSlO6P3QUwSKgg+rpdyGd4meY4xMFmla5GFtNXOmCuXgyX
   HkcH0WOLBmyaIXP+laILAetkiknha8uX8aD8ZyV+PtBW6zRcVFUJrSDJl
   odu+5LHmvQ2ZDsMM5Cq8C2nSkrKOiW0flkCSNjtOAfkVactG+SA/Udoy0
   Ii4IipNDalKnia/i2ZIHfmJ/A818+O1tp4Fgu0NMRlXuFcsxkJwsY9U6j
   5VCdUO1LO5U2qVErq0j3btlg8AClfUpnSjPa4soUJhJPWBrbm9+0vV0qJ
   g==;
X-CSE-ConnectionGUID: SL+sx9F3RK2u/1/Hap05ww==
X-CSE-MsgGUID: TBdEf7hMR5u080L3UIvHUw==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="14338571"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="14338571"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 15:12:30 -0700
X-CSE-ConnectionGUID: e2Zu/kDYS6eE690bqFkVNA==
X-CSE-MsgGUID: ruz2n6ToTWW1z4PYPvDUXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="43011609"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 15:12:30 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 15:12:30 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 15:12:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 15:12:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 15:12:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElC+DsZUhZKYC1ThGf10f9FUmTV6tw0mWvjpD1tjn3k97l3Lq6ZXtD6UyazKxqeUIh5aB0aAnSonfxB2AnD5JIm5vC6PW5Gw6egAwjicGXsE4O5t9mi7Pdh/Jvst1Kc1FEbaFct+RWsitGhFAInbyuDCPdzjC1ztT/gPtZquc1eZC0wHc1r0uV7aIRVFIDMLhbL/2Y5bO8pSdZVNmAq7Eb4z3hY42+CXKoef177TEy5q++b5Djm9KCONO3WpNfOZF+PXJkCW8FhLZ24LcmMSV1Xw30YS+Yp+tvAqJv5f/MWO1vTOBbkcGDQc4hAFIIyw9OvzFs/gN7mFaXuwEBStQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNbGn2qy+rVE38aj8yGKSoUyBAnpheoxTq6UOgHsrR4=;
 b=azU0FbwYkpbdGu/gwgbtqjHW7z6jWbDnNuWgqnrBpBIChzxMMHr71baNywfCVJADuk1fpebsu5EtX6Gdket8PpUwi3hSI4yCj8Qk8sbvhvq8R8Za1OTqbCjcQYCiXB/Jw5OiC9dmT6a7p8L3rtd2SqaS8D5+fBq2S5jD+ts9vo1NmRMi+CAfvHaFELwtLMVnv4nG3Rp1+yz9s5T0lk6HrqEzKi1QYIIGzlj+ayyrgukj4Dy0qHnZZd3r4bcI2vEb2etF90ykxDyn+wZY7BymPRY0Qqy9KnC7ReR09HNzsfon+juY8Irm+hJ/PffhRSacJ1SnnTf8b+qI9Z2q0a2GFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB6705.namprd11.prod.outlook.com (2603:10b6:510:1c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.35; Fri, 7 Jun
 2024 22:12:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Fri, 7 Jun 2024
 22:12:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 13/15] KVM: x86/tdp_mmu: Make mmu notifier callbacks to
 check kvm_process
Thread-Topic: [PATCH v2 13/15] KVM: x86/tdp_mmu: Make mmu notifier callbacks
 to check kvm_process
Thread-Index: AQHastVsvIokCAHBf0eqTex6Vdas6bG8C5UAgADeRoA=
Date: Fri, 7 Jun 2024 22:12:19 +0000
Message-ID: <ffddbc64ddfbf1256b79336864c2203d81df4448.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-14-rick.p.edgecombe@intel.com>
	 <CABgObfanTZADEEsWwvc5vNHxHSqjazh33DBr2tgu1ywAS6c1Sw@mail.gmail.com>
In-Reply-To: <CABgObfanTZADEEsWwvc5vNHxHSqjazh33DBr2tgu1ywAS6c1Sw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB6705:EE_
x-ms-office365-filtering-correlation-id: 0ce88834-1f5a-4f6e-3974-08dc873ee630
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?RU92Qnc4UjFhMWxzU2FpQVNoNDVyM0EwOC9OU0VxTnp1Vk9jYjZpNWIzVWRo?=
 =?utf-8?B?c2hucmhMTjNBcmRkZlhuNXh2ZW5Gb2NnTW5HSUlzMDZNaEN5aEllZE9vVEdk?=
 =?utf-8?B?ZEtQV0NSdWZ5ZzdyUDF2ZDUyUndIeGxKUmU4dHg4Q1JiN1UyY3JXWlRlZkdR?=
 =?utf-8?B?Skt6QkprWkk3Y3B3a2hqRFh3MUNTSDFsZmVQUktxTjlDUlZUMGNVWkpPbUFi?=
 =?utf-8?B?V3JhZGgvZW5DVmEyeGtDb3hSSE1RNHl4RHlBSWdCNmhqaUJOU1B6UElYYmFw?=
 =?utf-8?B?b29HcXVKTlJRaUF3NGNCeThTNytiUzhmN1dISTladUVSYVBmQnZ5Nys2cEhW?=
 =?utf-8?B?QXFhWHNVQVU0Z1hRbFRvVHliTHpUZGYxTFVEdEZEaURtN2Y0TzIzWmRvUC84?=
 =?utf-8?B?RzJKRTZKYmVpcXFhOTdPeWtSQmVuUjcyTFNjcEw5M2xJQzVpUFJYWTUyUjky?=
 =?utf-8?B?bHduc0NhSkxNc2FBQzdFd1VyMWNlSHJBK1NVV1BKbm9wMExuRkhYL0JrVnU0?=
 =?utf-8?B?UTFPZ2dhalJ5S1MxUUNPTTB1WHc0cTgyQ09ET0hrSzJ3VlVQK0NLT0UxYUl0?=
 =?utf-8?B?WjBROC9zR1JCVTBRU0dVZGN6Q1pHY1VwaHBkUi94YWFFdG9wV2V3c3NGZUdR?=
 =?utf-8?B?dlhSb1N4ZFU1SkNFdTNSa3NHbGtveVh3YTdrNW9jVEFwSUNRZ010Q3hMbWpa?=
 =?utf-8?B?eVBhREVrWnJuTGRiMStHakRxbmgzOEhUbHAzK0I2NWVFdDRBdTJocWRXQWxq?=
 =?utf-8?B?L2IyZXJpc293QzNsOXQzTmNYU2Q5MHFNNDBaZnRZVEFpeEVnZGJCQlVWU24w?=
 =?utf-8?B?Kyt4RGpPcGhWYmlmNUZZYjk4YnFROEt2QVVWM0J1OS8wRTRUdTFMblJUVVRu?=
 =?utf-8?B?NGM0c1dWSEl5RkFJMTNFMWVuWEtIeEFTeXNKSWdMd2hBRjhzclNWR205eXVX?=
 =?utf-8?B?dlN0UjFRVWYxOVpqWFJsYnJyS3FnbDRTWFRJOUhEdEZSOENEd29maWwrVWhE?=
 =?utf-8?B?eHJGcFpZSFQ5SkFTK3J6bzdTTEYxUnBuNndtaWlKMDhKQXJ0T3lvRUlIbjJr?=
 =?utf-8?B?OW15VTlBM2tSeDlNeWlKc1Brd2NoUmwvNmNCOGNidlpsSTJaNCtZRVUxbC9q?=
 =?utf-8?B?a1I2MC82d1Q3dW0rQ3JVQXFWblBvRzllQ2s4MDdvR2lwSXlJVldQVTkxeFBY?=
 =?utf-8?B?d2pZQXFhRWFvcnlObUxWN0dZUWdndjhVRXFHVzhhNHM4cDc3MjlJS21zOFpl?=
 =?utf-8?B?cm0vNTRGU2lmVzZFaE1aSmRmRFIzdjYraUpyd0o3T0l6OHJUQi9uVTBNRU5s?=
 =?utf-8?B?K25GajJPRUJ3clNKa0M5RkJRM3ZsUmNWejA5SkdzQ2N5bFNiekRsT2VVejVG?=
 =?utf-8?B?ZHh3ZEJDaGJaVjdKSVZod2kwNVkyNUd6bDdqS2I3cnIwUmI4Ry9icGlsWHZ5?=
 =?utf-8?B?ZGpwazFKb0NpR3FRY1hvMTJBVDZZTi96dWtwNWd4WDBCaVpkWjlEcmdWWEg3?=
 =?utf-8?B?ejF0bTYrM1d2RFljSXBIaFJZY0tGa1MvNW9JNDRwT2EwSVJob1N6VjV3OGVR?=
 =?utf-8?B?TnlWaXhTZmtsYk5SWFkxL3BqeWhyb1hjbm9CVjQ5U25Za3lMbGxDQXJkdWs5?=
 =?utf-8?B?dnd5MHVaZHJISnRFUnI0amJYT3dseTRTQlZaYVRnbUFXMmhkci9xSmhMeW9Q?=
 =?utf-8?B?a05nRmRDVzdHbm9JeEwzc0diL0M0V1JkdzJKQmhZU0xTdERwOGUwWlIyeG9n?=
 =?utf-8?B?aFpXNzBNdHNjYWhRMXhRL1FvVm9nRVBmSVNPU21DQXB6bUxvVWM5UFZpMDFt?=
 =?utf-8?Q?+6PCkBFmSRJqGoptsTOO5kMjHx6EJBiEQHcOM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlJRRUtXZ2dJczNTSDRZazUvRFhZS1B5Tk13c3hweExTMEVYWWVXektrdTBZ?=
 =?utf-8?B?V09zcnZPbXhCVHZvMzRBdFNOVjhZT3ZlOStUeXZrdGdVTStrcS9rU0FtSzFs?=
 =?utf-8?B?aERhQm8xbU5PR0plbnh6RFExTG5sMjRQbG1POFpzTHdlQnR0LzRhTElWWkFi?=
 =?utf-8?B?LzkvQmlSdnpUOHBGUmR3Rk9rOUNMQS9zQ3ltYjh3WEJ6SFdHY2U0OFg1WmU1?=
 =?utf-8?B?bmhla0hJN2s0NnBERXNRR2NxZGROVG9jQm12enROOUFSL3JNTTNlMTVDUmFX?=
 =?utf-8?B?TFV5cE5YNmxwNDZCZk00UENSN2RBWjJTWkY4UU1tMEF6akRxbVVrUEgwUHJC?=
 =?utf-8?B?c2N0ZHprbGkrZkxnZ1E3SldwQmF4WEJoQjVIdG9lVzk4ZDJxa3NZTkx6b3lI?=
 =?utf-8?B?bkFJWGhLYVhwMSsydkNvL1E4K2FhWEpOWnlQUXZVeGJ1N3A2cXBhNC9hT09r?=
 =?utf-8?B?aGpKZHpjSytWdlBJSE1kcEZoZ2dUZldyTzlaWml0QjNiYXNoekFxT2ErUThj?=
 =?utf-8?B?eS9lbUh6anFEYU1BTDVZR1k1RWprb0RsYjZONHdGcTg1cTVNRXF2cEhQVkRF?=
 =?utf-8?B?ZzNJQVBtbkFtbWkwMDdmYStqcm9Ja1RLQmN5Z2xQMjh6OUZoaGM0UXBKalBT?=
 =?utf-8?B?R0E1V2VEaWNudVlENVZMNUFhbUV6blY1bnBTRDhSc0hSeEcvaTg5eTVBcjRH?=
 =?utf-8?B?bDdEM3IxYXZvSVdSV1FtZFdoWTYrSnl4U1NwN0NITkVmc3M3OGwyN0VGeW5I?=
 =?utf-8?B?aW85akMyOEtYL1VDakovOFQ3RGw2Vm92aE5ydUc2MVdFRmsxejlaWkJteEM4?=
 =?utf-8?B?NVdJekdTRkpaMldiME1ZQkx4SEhwQ2ZOVnVVMURRVmUvdXdKTG1jMER4eGF1?=
 =?utf-8?B?ZnVqK3BFR0VLWEQyc3pZNXRSM3o3cmRWRzZlZlpOZ085RGN0OVYzS3l0S3ls?=
 =?utf-8?B?RTBCdERLRUlhZHRkZlpNTnRvYzMyTWZPelgvUnl6NDFKSndzdHJyajhVQkRN?=
 =?utf-8?B?SmFHQ3pzeURpNGZFQWJRL3krelZnZWVTeDBuTHJBMERicnYyaVlwY08zQk9D?=
 =?utf-8?B?U2RaT0lVYU5JS21vbytIV28zdHh5bEZYMFR3VVQ1cUlzSHg0M0F4TklPcW8v?=
 =?utf-8?B?anVRSUJIWjlnZ2RFWlpWUlJjRC95M3dmS0F5U0grWGowNDJzL0lJcTZGRXNl?=
 =?utf-8?B?NTY2SUhVRVRnOFhpQlZHL1AxZXNmMkhkWVdXU21jcWlyQXBQVjJUdTFBQVVL?=
 =?utf-8?B?STVDWXNnRjB3UTFLbjlqVmpUckxQdTQ1MjM5Y0RuNGdiZVhaWWp5KytGZTg4?=
 =?utf-8?B?aTRrQ3pwbGxzOFpRMHJNZDZaeFUwaUZSdVdQTHFnZHJHaTlDK2ZtdWY4ZDRL?=
 =?utf-8?B?VlRNVCtxeC9vV0llVi8xVW1yaWZCc2MyVjdTVUlvYlgrRnRzdFl1amFmQ05J?=
 =?utf-8?B?dS9UWjduZ1VxeUV6OEVsdzlHZnBHZU02cWJqSzR2NjRZQTEyelBuTUc0WElY?=
 =?utf-8?B?Sk9ZbWlvZmZXdUNKMC9vOTRpR0M1MjdRbUZkSjgzdHNITUNoMDdqcExGbFJh?=
 =?utf-8?B?VFlVOTJJNldhOWo5QlNiQ1JBd3dTdUtJY2huV1Y3OVprV2ZRN2ZITVhWcGZ4?=
 =?utf-8?B?enN1aW9oT2JQZTBOa2ZVSC9wOWVrUFIwT1VJTzViV2dtQlpTNStkR3B6MlAy?=
 =?utf-8?B?Tk5PUy9mM2F0UlBkNjcxUUpYKzN3eVBYeDhNUW1BTHZBNmh4UkloN1IxR3dK?=
 =?utf-8?B?VVRaRzdrSWFpK1dLNkJrUWlPc2VvbVVTaFMyeStubWgwRE1iYU5JSTBzckdX?=
 =?utf-8?B?WDVTd3daTmlBUUJEOWhxV0lYeGtCZjdEdmhHSmJOQ3ArU0szUUNXMEdsTm15?=
 =?utf-8?B?eGo4VDVZUDY0Z25Hdm1oYVZWQ0JHMjZ3THFRb0NieEtMS2FFYWZ3MDZTc1RH?=
 =?utf-8?B?bC9VSWZVcFkvVUl0ZTJ6VkR4VE1WamgxLzU5R0VQVHhoSTE2RVNFWnlJUVd0?=
 =?utf-8?B?UXY3MC9tUmxWTmE0SzFkeXVZK2dURUVBK3dsTDZnNGgrTXFhYTl5YWQrYUJY?=
 =?utf-8?B?bkh6TEZYRkNzMXBmUnBDclExYW4wTDNGWE5oLzhhMmhnVExRV21YM2dXM3Zv?=
 =?utf-8?B?aEJTZHJZYmNOeUFZY0lZVHNjZng3Rkk4V0M3Q3RZZUp6YTFicFpobklnbXA0?=
 =?utf-8?Q?tE0wDheTMn8r1kFcz8Cy0Ss=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1EE80E072ED6F488F0F34B0A618A54E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce88834-1f5a-4f6e-3974-08dc873ee630
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 22:12:19.9374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w3EdIPGyJ+fkuGx0j8iHsJolkOs8UiJfpyO5/Xyadqb2Qk5Jnlh++eFA/Ay0Jv5RI1U0FcpNYUBBWZJ1qq5vnpU4Ev8OdtTTMrx8XjuUH4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6705
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTA3IGF0IDEwOjU2ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBTdWJqZWN0OiBwcm9wYWdhdGUgZW51bSBrdm1fcHJvY2VzcyB0byBNTVUgbm90aWZpZXIgY2Fs
bGJhY2tzDQo+IA0KPiBCdXQgYWdhaW4sIHRoZSBuYW1pbmcuLi4gSSBkb24ndCBsaWtlIGt2bV9w
cm9jZXNzIC0gaW4gYW4gT1MgcHJvY2Vzcw0KPiBpcyBhIHdvcmQgd2l0aCBhIGNsZWFyIG1lYW5p
bmcuIFllcywgdGhhdCBpcyBhIG5vdW4gYW5kIHRoaXMgaXMgYQ0KPiB2ZXJiLCBidXQgdGhlbiBu
YW1pbmcgYW4gZW51bSB3aXRoIGEgdmVyYiBpcyBhbHNvIGF3a3dhcmQuDQo+IA0KPiBQZXJoYXBz
IGt2bV9nZm5fcmFuZ2VfZmlsdGVyIGFuZCByYW5nZS0+YXR0cl9maWx0ZXI/IEEgYml0IHdvcmR5
IGJ1dCB2ZXJ5DQo+IGNsZWFyOg0KPiANCj4gZW51bSBrdm1fdGRwX21tdV9yb290X3R5cGVzIHR5
cGVzID0NCj4gwqDCoMKgIGt2bV9nZm5fcmFuZ2VfZmlsdGVyX3RvX3Jvb3RfdHlwZXMoa3ZtLCBy
YW5nZS0+YXR0cl9maWx0ZXIpDQo+IA0KPiBJIHRoaW5rIEkgbGlrZSBpdC4NCg0KQWdyZWUgJ3By
b2Nlc3MnIHN0aWNrcyBvdXQuIFNvbWVob3cgaGF2aW5nIGF0dHJfZmlsdGVyIGFuZCBhcmdzLmF0
dHJpYnV0ZXMgaW4NCnRoZSBzYW1lIHN0cnVjdCBmZWVscyBhIGJpdCB3cm9uZy4gTm90IHRoYXQg
cHJvY2VzcyB3YXMgYSBsb3QgYmV0dGVyLg0KDQpJIGd1ZXNzIGF0dHJfZmlsdGVyIGlzIG1vcmUg
YWJvdXQgYWxpYXMgcmFuZ2VzLCBhbmQgYXJncy5hdHRyaWJ1dGUgaXMgbW9yZSBhYm91dA0KY29u
dmVyc2lvbiB0byB2YXJpb3VzIHR5cGVzIG9mIG1lbW9yeSAocHJpdmF0ZSwgc2hhcmVkIGFuZCBp
ZGVhcyBvZiBvdGhlciB0eXBlcw0KSSBndWVzcykuIEJ1dCBzaW5jZSB0b2RheSB3ZSBvbmx5IGhh
dmUgcHJpdmF0ZSBhbmQgc2hhcmVkLCBJIHdvbmRlciBpZiB0aGVyZSBpcw0Kc29tZSB3YXkgdG8g
Y29tYmluZSB0aGVtIHdpdGhpbiBzdHJ1Y3Qga3ZtX2dmbl9yYW5nZT8gSSd2ZSBub3QgdGhvdWdo
dCB0aGlzIGFsbA0KdGhlIHdheSB0aHJvdWdoLg0KDQo+IA0KPiBUaGlzIHBhdGNoIGFsc28gc2hv
dWxkIGJlIGVhcmxpZXIgaW4gdGhlIHNlcmllczsgcGxlYXNlIG1vdmUgaXQgYWZ0ZXINCj4gcGF0
Y2ggOSwgaS5lLiByaWdodCBhZnRlciBrdm1fcHJvY2Vzc190b19yb290X3R5cGVzIGlzIGludHJv
ZHVjZWQuDQoNCkhtbSwgSSB0aG91Z2h0IEkgcmVtZW1iZXJlZCBoYXZpbmcgdG8gbW92ZSB0aGlz
IHRvIGJlIGxhdGVyLCBidXQgSSBkb24ndCBzZWUgYW55DQpwcm9ibGVtcyBtb3ZpbmcgaXQgZWFy
bGllci4gVGhhbmtzIGZvciBwb2ludGluZyBpdCBvdXQuDQo=

