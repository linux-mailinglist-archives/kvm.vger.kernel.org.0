Return-Path: <kvm+bounces-15496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2E68ACD35
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 14:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DFD31C20BCB
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 12:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E743714A0AC;
	Mon, 22 Apr 2024 12:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="delgsT+t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E10146D6C;
	Mon, 22 Apr 2024 12:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713789987; cv=fail; b=IhQMxjeYATlj/p4VCqUXMGObdXE+VXXtLGqkJFsCwpmF45Z3eYtNCimCtNLnhvp9F0aTrRJjZebjqFdbxyl3+3BivnzdoDahpTGk6wkQdRzCYAfAPGg5s43LWsjbjvKLszAAE9M11fsRc9EWNoVvAlYzRY9dh3vHr+sY5rALSZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713789987; c=relaxed/simple;
	bh=cmeNWN2ywvE417cwcWfemce+25BTzl6g/HO4FLgsu3M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t7RqD2dC6VBehUrqI25bqyICOcAZGTCJlJL9x6o5jiSEq/+ZBtfoP/+9cag25dXliVnDq8kRJx/arX6SW3hOwngFgesvuxIrq18QdpHD6owAN0lb7pW0ayE/PHy/rTszT7lly54sh2Lg3RqEIsdLk+KlVFMJ/heVnZ18EKTAREU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=delgsT+t; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713789985; x=1745325985;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cmeNWN2ywvE417cwcWfemce+25BTzl6g/HO4FLgsu3M=;
  b=delgsT+tvVTgpHmK7FOlBshaXYjgFKVpaC4y48/h3EALoEnRSzsKoCEf
   La8MbLlAhYYHNp0bE6cs3QGjxDz1XqpbnQxVz6kWgjwHLFUnM1XLVNynU
   ToDxk9o/GZvXoz4DMR8op2n18YUFf+Hh++QzQ0gd8Y+Rlyyqx3ICXKKi0
   IIgcdfOWZzTedKEqW0Dx/XvScRWcwp1L+RagVa2W+ay5yobIgVCv7Cl0w
   xxMR9UH+EiQRnTTEhQbPzOxrYbkj5LQwzqi3MVKtW4+NhpU3c6vR/0Bqg
   03NFZS99vbF2ATDTeCAuweRZHLiY8HQfoCI3KJLoW3DO+DtPvYo2BZTlJ
   Q==;
X-CSE-ConnectionGUID: s+MKMacKSYeYigg84iHzSA==
X-CSE-MsgGUID: FX8sxPYORR2BXqp3iafziw==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="9492339"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="9492339"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 05:46:25 -0700
X-CSE-ConnectionGUID: 1PwEarFwSX6mcumfZlvpYA==
X-CSE-MsgGUID: 0evbp8VtQfyG/zUN75HAFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="24075524"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Apr 2024 05:46:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 05:46:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 22 Apr 2024 05:46:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 22 Apr 2024 05:46:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnJwpN4FjVoGhtq5H97XIZGBWR9sXy0UzZGgcVXbkQwIhaHFrk4PRsHWw1oGharTo+6vhukji3C/3j1+4uo+mh0nEZgjnZxiDWJN9vaco08jhh/LbBY08Iyq+QBL5rTk/ikCmKKx50AYbzwT8EuoOOauP+FQMWYsNmmZ/CRmydcE1qqGLefuJDhITC9xgNeGRMM5ARFN0/b7D3o08OUrKesZq8uhasuvfhjHm5EpunzhmZGC/hUvdSs224wrRSq/8XYhucIYhl5TSzbGaI0hlF3R21V5DwlgXA96tvub6qJ9hkM7Mc9lvodBxYLZBMyBgGyb/D9DD/qC1yCttnWs7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmeNWN2ywvE417cwcWfemce+25BTzl6g/HO4FLgsu3M=;
 b=oDxSIPqSbk8lTv4RAQZAiUW3vlPwuWkQtiCaPeGhaDy2aCiBa0LA4CPQ37sD7sUgVSWax/XhFBQmn5hT3PHfBxqp9pXkJh++MF4anVt+q8F1o1nACkq0wFM7E0u3bcZAlFlbhisCe5Qu/34peJfEOhGzyyP0xbSLGW44LOIOq87xE3TcdtKQyHZ23VRo7tSKGj7X9xY9iVEzj+hND5ztmmCeymKU8l8nvkDDfUUe7P8SXyNqB5IL6y60H6osXzPLMiUB5Z0AEGgrfJl68ZZ+GMe0Wh/8437i7pNGMGCYkG/xull/7qLavD3JV2XZT7zSKd4uZNr3vtW/pXJqF7lwDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB8192.namprd11.prod.outlook.com (2603:10b6:610:191::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Mon, 22 Apr
 2024 12:46:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.018; Mon, 22 Apr 2024
 12:46:19 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AIAAFk4AgACOYoCAAAdQgIAAE+EAgADmKACAAJDvAIABMcMAgARpbwA=
Date: Mon, 22 Apr 2024 12:46:19 +0000
Message-ID: <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
References: <Zhftbqo-0lW-uGGg@google.com>
	 <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
	 <Zh7KrSwJXu-odQpN@google.com>
	 <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
	 <Zh_exbWc90khzmYm@google.com>
	 <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
	 <ZiBc13qU6P3OBn7w@google.com>
	 <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
	 <ZiEulnEr4TiYQxsB@google.com>
	 <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
	 <ZiKoqMk-wZKdiar9@google.com>
In-Reply-To: <ZiKoqMk-wZKdiar9@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB8192:EE_
x-ms-office365-filtering-correlation-id: 4d068e02-201a-4988-38f0-08dc62ca351a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?N2tQZlNvY3l3Y3orSTh6ZmY2ZjkvUjRORW5RT0VXVVUxN2k1VTNmdStkdFNk?=
 =?utf-8?B?SGxDc1NWL2MxY0xQVVNuM2pKRWd4eGUvTmpUMERjRXlWMllYMzhHYkZVMGkx?=
 =?utf-8?B?OUZ2ZnNXa214ZGxSMzh5R2hMc2tLT2VuQnkrcnpnQW45N2ZvSHFOd0IrOXNY?=
 =?utf-8?B?dmV2M3NPMHYwN1BvZ2FMbzZHaXJWcU9VdHNHRFA5SzRvWmpPN1AyU0RlSnFo?=
 =?utf-8?B?NVhnVWJ2aTR5MmdFNG1EQWNRTEVKRlhRTXMyQmMvM2dwQW5oUk93cUZIdTJV?=
 =?utf-8?B?THR6Ny9XUzJhNHFMMllxU3BDVEhkbWpjNUlmQm13R1p3NkRETkswNU9aSzBr?=
 =?utf-8?B?ODRxNnErdUZxU2JEWitUb0JSWmV6cDlLdkJaUzArMEovRVVHR0JHQnRSMDRK?=
 =?utf-8?B?enJzTWR5WkRDYkd0bVR0dzJ0WGladEZXUHJGUEhIUUx2b01xOVlQeXpvMHRk?=
 =?utf-8?B?Tk11ZU9mMHFDNFJ1R1B4SnNyMVIrKzRXVVRJSkZCZjFxRjVmV1ZrU0xLb3ls?=
 =?utf-8?B?M0FLMENPUG5aZVgvNUhUTzBReE5tV0x3QndPTkR6WUpaeHlVUTdWRklrTUdz?=
 =?utf-8?B?eUhwY3p2d2p6U3dZZWZQcittMFhiOGtFcnBEcDBSWXNzTjJqaGhNRFZhQ3lH?=
 =?utf-8?B?azJ0bTBKcm5aWmtkSjM4dFhQN0p0UVpiN1gvVkZKS3grZXpGa0o0RGpTZXBs?=
 =?utf-8?B?bHlNUVc5WDhPb1plQTR2S2h3TGc1QVg2WFdid0I0Q0JVaWQyUUh4dndqRnAr?=
 =?utf-8?B?bnpiVnliUnBaNTFjdG51VnlEbkdXeVN2b3Z3dGMzM2ZXYVhFaVBSQS9WSWI0?=
 =?utf-8?B?bXBmR0FydDNwcHNSd3ZCTlpSSlczaC9Za0RNaTduN1JpdGtNK0pyUW0xdHZR?=
 =?utf-8?B?RjlsZm93MFVBYzhDeEZ2cHVkcGcvdnhqdzJHRFhOUW03M2RTOGNtWWhBMWZu?=
 =?utf-8?B?c2lTSXNuMy95Q0MxSk5qTEtqR3NiVHljdU5qdkVXZWsrdE90ank1NmhuSnZI?=
 =?utf-8?B?a1prcU5Db2hxY1RoeUp6NTNaS1VWQ3UydHhlZWdzcEo1RExOZWI2ZXI2M2wv?=
 =?utf-8?B?ell2L0p6dVU3RURiYXJlU2JhODVZelJydnc2dld1aWxaYVk3U0xTdE5NZ3hp?=
 =?utf-8?B?R2FFMytmVTRsRHJBV015em9VQ0p5RHZIWisyYnBFR0J1ZEFFeE5GZnpiekFK?=
 =?utf-8?B?Nm1tY2t0c1h3Q1hsRk9WaEV3OHV0ZDNtVk14Rkk0SG9jQjhSRHhnS2FLNlZn?=
 =?utf-8?B?TFVhbFRqdnFIdC9qRGdTaExkRjhRVmNPbUI5clp4d1oxYmZhQW05cThWOE1M?=
 =?utf-8?B?QXRSTTZIa2tBcFlJSVlCUVQxN3AvNW44NHRGSytraDZsVWVQNHBTUlV6enpL?=
 =?utf-8?B?ODRKbmxXSnJTeUFER3kwSnNLT0ZIUzZZWmVVVkI4NFJWTVZvM0pYeFJOejVa?=
 =?utf-8?B?ZEl6MHF0aWs0VGhkdXRMNi81aE1FZXFxeVpUMTZDeC9IYlhkdUZ6NG1zYWJP?=
 =?utf-8?B?ajdVWlEvVUlFdGt2c3ZMcXpncFk5bFREUk9kd3o5bnVRQWRGVy9KbS92c1FB?=
 =?utf-8?B?N2NiMUdDcFhETDhsVlp2amlieVB3Vms1R3Qvb08rY24xcjRvZUJaT0s3bmlx?=
 =?utf-8?B?aUlCVWNVOFRkbVRuSVlZc1lFdnBFZVE3bTlXUmhlRXBQS3BwdlBwWlBWcDUv?=
 =?utf-8?B?WU8ydEFEcUVEbnB4YkR4Q2pSVGJGaFNtRUtzQjY1TUdnY1RRL09jU00zYzlh?=
 =?utf-8?B?VTBtUFJOdkZ4QnQxc2QwL1FHSjA2dTdkdk0zZ1lKNCtML1cxZnJUTS9hVUlO?=
 =?utf-8?B?MUxpZy9MeEhvRXFqd0hEdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjRJN1BzeDFST3FyMWJMR1RHemlTeFR4Q2trOExWeHFzNmJVZnc3V21wazlk?=
 =?utf-8?B?UUo2dmRLQ2ZLVGllRXFvMG9xRVg0MWFqNXNxdVlEUmdRZWhEUG5SUmJEQXgr?=
 =?utf-8?B?Ym9xZ0lMWHdVUEdTYzBTTFl1c2d3RFVEMUNpckF6V2IzV2x0WTNTajVhNE9K?=
 =?utf-8?B?NG5WK2YwZGRUQ2VhQVppM1F0OHdjaEcveDZTV1NYWUZBNm95bjhvUlBTTldF?=
 =?utf-8?B?ZFNxOUJuL2xoL2hTLzRRb1NDSHdxZDI3VVF0UC9tRVlUbVlycWovbThTbjcw?=
 =?utf-8?B?aDR4WXRUWFhQWW03OTZLYTl6Y2MrbWN0bCtoUUN3eWNjc2o3VXpveE5kRUh4?=
 =?utf-8?B?dFlBSzRiMWg1VENrcnVHWVpCTHplc3RQWjFPRGVtZlZKWG1ORERZSUVqR1E3?=
 =?utf-8?B?ZFZWd3dQdVVvZWtwUWQ5aVdkTGF5RlhaalYvNVZ2Mm81dEFUSnd2MmhXb1ZH?=
 =?utf-8?B?cWsva3hwQXJINUNJK1dTbWd6K1VIVlZ5ZDZWQktPcW85OXl0MGhscWs2bExC?=
 =?utf-8?B?RjU3NmZLbnJDcWR5SUh4NStJQmE0L2pnTFB0a2Yyc2pmc2hET0FmbElqN3Zk?=
 =?utf-8?B?My9zMm9VRnBBQzNGYVhHYUQ5RnJzYnlnck5Rd3NTbWNOdk5lZncrcUZLaHp4?=
 =?utf-8?B?d1NaY3VUa1ZKdUl3alhIUEdQWHdBQUc4WGJYQUh4cHFiN0s1RjIvNmp3TFFQ?=
 =?utf-8?B?VU9Sbk8yenlKcC95K0ZSUUtLRmJId1NReVNVT1J0N3pCMGRXa0pKZGp0Zkl4?=
 =?utf-8?B?T3hwYmdDbnpxT3EveDJlSVVHeGFDS2ROd09EdytYNWJUSnV2bnZmamZuWGdx?=
 =?utf-8?B?U1RRWDZXVHNGalhXNUMvUm5PYjVHaDNTYUtJRldwWHo4SG5mS2tmWktHeXRl?=
 =?utf-8?B?OXIyT25RZk5yRDJ4UDdXQkQvdUx2eUdDMDZsRHRLaVMxcWFYOFdsNjU2LzFI?=
 =?utf-8?B?UnJ4NXg3VGhyWGVxaGczK3NTSjdPUTJCL3hscXdxU3Q1cWo5YnZOcVpDRzBp?=
 =?utf-8?B?VHNEbWlQOWRnSGlFbWVqNVZhSVJmaWsxMzNnNmlaaXZzVy9vVkNpRWpQdGlx?=
 =?utf-8?B?T0tpUGZDM0pFQ3JkUENON096cXRCOXh1YXRDZjZBOWxrc1pPZi92N2xhY3Zn?=
 =?utf-8?B?WExIRXVVOGRhQUtTZmZSdkVNSkNJeXczQnh2RjlmUm5lY05LNVhiOEliSHdn?=
 =?utf-8?B?aFNOcTYwc0MrRzJ0QmgwODhUcGVlNm5GVysrZ285RkJFbTJYdE9GM3Y0ZERi?=
 =?utf-8?B?UE1LWEpKRVlNa3o3R3FQdldZdmVOVHV5VWVydDU3dUhXc1VPckQySW9TeG5t?=
 =?utf-8?B?cVBwdFN2alhhdDBLNEF1Z2h2ZExSMUtXL2VJelAwYU8zQUUzYVJOenFJMDV2?=
 =?utf-8?B?MGRndmRMNU5pQVBEWVN5UVhGcThWemY2bWZweE9maHV5SUNhUnJJNjBIOE5a?=
 =?utf-8?B?SFRxRzhVeVh3eU56UjQ0T0ZGTXNtbkpyM3k3Wkc5VjQ0eDlELzF3eHZXamZO?=
 =?utf-8?B?MnJRMGhLUzdwaHFnOCtoWHZLdWpMOFE0L2VRM2ZKYk5ENERKdWMxNmVObUty?=
 =?utf-8?B?VXRDd3BFenZ5R3l4Z1pWWlAwa05pQVk0cFdFSnVwUjR0aGFQdUtkdzZ1MGZN?=
 =?utf-8?B?eVZ3a1Z3bWg2dU84cUhZcXhxZWVsNWFGVlVaWkdaMkRlcWxCV3ZjN1hHWWtX?=
 =?utf-8?B?OWpNTXJZSlo1OGJ1aVlaNDVGZXBmVFFIV2w4Tkl5NTVPQi81TnRnZnVaWjV1?=
 =?utf-8?B?Z3hqNUUyY3BHaDl6djV5N1FpaFJoQjdFOGtsYXNtalhhNk16VnVZQ0VrTXVp?=
 =?utf-8?B?OGd1L3BxRjdNYkVoMjd6NHJWVjF0UzVvUFk0bGNnaUdHVjdvNnp1SVJtV3JJ?=
 =?utf-8?B?a3MxTFVkWlZoMHIzd1JnOEpCVWFSWm1ROFZsb2RHbDh4MzRhMHlOYnlzWFM3?=
 =?utf-8?B?Y3hoT2VwRGplRFRrVGdBWVZtbVl6MVlkTkRMblRDMlEwMmtPWElWcDFaSzhZ?=
 =?utf-8?B?RXg2Z2ZuVGltRTdDYmRKc1JoM1hEc1lJbnduSzk3ZUFoN1Z6YTFoZER3dFdW?=
 =?utf-8?B?SitxajNTQlVrQXhMMjlpMkUzUjRXOVZJNjNVbWFRekwycDFiZ0pyckx4dEtn?=
 =?utf-8?B?U2pNTEw4R1ZkajNEOFZ2dmJ0c3BsS3pSN2lJUWgxZ21ia2doelY2aUMwNk9m?=
 =?utf-8?B?YVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C35289B361497347A0679A4BD921FD66@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d068e02-201a-4988-38f0-08dc62ca351a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2024 12:46:19.3137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kn8oNDuPh1xLSl9n8Sp/rXT0PMJZkYTXQpSy0hSxGjgua+jfAiE2OtzzPjIHK4oMDJedzPb76qP3ohbOPdjH4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8192
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA0LTE5IGF0IDEwOjIzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIEFwciAxOSwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIDE5
LzA0LzIwMjQgMjozMCBhbSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiA+IE5vLCB0
aGF0IHdpbGwgZGVhZGxvY2sgYXMgY3B1aHBfc2V0dXBfc3RhdGUoKSBkb2VzIGNwdXNfcmVhZF9s
b2NrKCkuDQo+ID4gDQo+ID4gUmlnaHQsIGJ1dCBpdCB0YWtlcyBjcHVzX3JlYWRfbG9jaygpL3Vu
bG9jaygpIGludGVybmFsbHkuICBJIHdhcyB0YWxraW5nDQo+ID4gYWJvdXQ6DQo+ID4gDQo+ID4g
CWlmIChlbmFibGVfdGR4KSB7DQo+ID4gCQlrdm1feDg2X3ZpcnR1YWxpemF0aW9uX2VuYWJsZSgp
Ow0KPiA+IA0KPiA+IAkJLyoNCj4gPiAJCSAqIFVuZm9ydHVuYXRlbHkgY3VycmVudGx5IHRkeF9l
bmFibGUoKSBpbnRlcm5hbGx5IGhhcw0KPiA+IAkJICogbG9ja2RlcF9hc3NlcnRfY3B1c19oZWxk
KCkuDQo+ID4gCQkgKi8NCj4gPiAJCWNwdXNfcmVhZF9sb2NrKCk7DQo+ID4gCQl0ZHhfZW5hYmxl
KCk7DQo+ID4gCQljcHVzX3JlYWRfdW5sb2NrKCk7DQo+ID4gCX0NCj4gDQo+IEFoLiAgSnVzdCBo
YXZlIHRkeF9lbmFibGUoKSBkbyBjcHVzX3JlYWRfbG9jaygpLCBJIHN1c3BlY3QvYXNzdW1lIHRo
ZSBjdXJyZW50DQo+IGltcGxlbWVudGlvbiB3YXMgcHVyZWx5IGRvbmUgaW4gYW50aWNpcGF0aW9u
IG9mIEtWTSAibmVlZGluZyIgdG8gZG8gdGR4X2VuYWJsZSgpDQo+IHdoaWxlIGhvbGRpbmcgY3B1
X2hvdHBsdWdfbG9jay4NCg0KWWVhaC4gIEl0IHdhcyBpbXBsZW1lbnRlZCBiYXNlZCBvbiB0aGUg
YXNzdW1wdGlvbiB0aGF0IEtWTSB3b3VsZCBkbyBiZWxvdw0Kc2VxdWVuY2UgaW4gaGFyZHdhcmVf
c2V0dXAoKToNCg0KCWNwdXNfcmVhZF9sb2NrKCk7DQoJb25fZWFjaF9jcHUodm14b25fYW5kX3Rk
eF9jcHVfZW5hYmxlLCBOVUxMLCAxKTsNCgl0ZHhfZW5hYmxlKCk7DQoJb25fZWFjaF9jcHUodm14
b2ZmLCBOVUxMLCAxKTsNCgljcHVzX3JlYWRfdW5sb2NrKCk7DQoNCj4gDQo+IEFuZCB0ZHhfZW5h
YmxlKCkgc2hvdWxkIGFsc28gZG8gaXRzIGJlc3QgdG8gdmVyaWZ5IHRoYXQgdGhlIGNhbGxlciBp
cyBwb3N0LVZNWE9OOg0KPiANCj4gCWlmIChXQVJOX09OX09OQ0UoIShfX3JlYWRfY3I0KCkgJiBY
ODZfQ1I0X1ZNWEUpKSkNCj4gCQlyZXR1cm4gLUVJTlZBTDsNCg0KVGhpcyB3b24ndCBiZSBoZWxw
ZnVsLCBvciBhdCBsZWFzdCBpc24ndCBzdWZmaWNpZW50Lg0KDQp0ZHhfZW5hYmxlKCkgY2FuIFNF
QU1DQUxMcyBvbiBhbGwgb25saW5lIENQVXMsIHNvIGNoZWNraW5nICJ0aGUgY2FsbGVyIGlzDQpw
b3N0LVZNWE9OIiBpc24ndCBlbm91Z2guICBJdCBuZWVkcyAiY2hlY2tpbmcgYWxsIG9ubGluZSBD
UFVzIGFyZSBpbiBwb3N0LQ0KVk1YT04gd2l0aCB0ZHhfY3B1X2VuYWJsZSgpIGhhdmluZyBiZWVu
IGRvbmUiLg0KDQpJIGRpZG4ndCBhZGQgc3VjaCBjaGVjayBiZWNhdXNlIGl0J3Mgbm90IG1hbmRh
dG9yeSwgaS5lLiwgdGhlIGxhdGVyDQpTRUFNQ0FMTCB3aWxsIGNhdGNoIHN1Y2ggdmlvbGF0aW9u
Lg0KDQpCdHcsIEkgbm90aWNlZCB0aGVyZSdzIGFub3RoZXIgcHJvYmxlbSwgdGhhdCBpcyBjdXJy
ZW50bHkgdGR4X2NwdV9lbmFibGUoKQ0KYWN0dWFsbHkgcmVxdWlyZXMgSVJRIGJlaW5nIGRpc2Fi
bGVkLiAgQWdhaW4gaXQgd2FzIGltcGxlbWVudGVkIGJhc2VkIG9uDQppdCB3b3VsZCBiZSBpbnZv
a2VkIHZpYSBib3RoIG9uX2VhY2hfY3B1KCkgYW5kIGt2bV9vbmxpbmVfY3B1KCkuDQoNCkl0IGFs
c28gYWxzbyBpbXBsZW1lbnRlZCB3aXRoIGNvbnNpZGVyYXRpb24gdGhhdCBpdCBjb3VsZCBiZSBj
YWxsZWQgYnkNCm11bHRpcGxlIGluLWtlcm5lbCBURFggdXNlcnMgaW4gcGFyYWxsZWwgdmlhIGJv
dGggU01QIGNhbGwgYW5kIGluIG5vcm1hbA0KY29udGV4dCwgc28gaXQgd2FzIGltcGxlbWVudGVk
IHRvIHNpbXBseSByZXF1ZXN0IHRoZSBjYWxsZXIgdG8gbWFrZSBzdXJlDQppdCBpcyBjYWxsZWQg
d2l0aCBJUlEgZGlzYWJsZWQgc28gaXQgY2FuIGJlIElSUSBzYWZlICAoaXQgdXNlcyBhIHBlcmNw
dQ0KdmFyaWFibGUgdG8gdHJhY2sgd2hldGhlciBUREguU1lTLkxQLklOSVQgaGFzIGJlZW4gZG9u
ZSBmb3IgbG9jYWwgY3B1DQpzaW1pbGFyIHRvIHRoZSBoYXJkd2FyZV9lbmFibGVkIHBlcmNwdSB2
YXJpYWJsZSkuDQoNCj4gDQo+ID4gPiA+IEJ0dywgd2h5IGNvdWxkbid0IHdlIGRvIHRoZSAnc3lz
dGVtX3N0YXRlJyBjaGVjayBhdCB0aGUgdmVyeSBiZWdpbm5pbmcgb2YNCj4gPiA+ID4gdGhpcyBm
dW5jdGlvbj8NCj4gPiA+IA0KPiA+ID4gV2UgY291bGQsIGJ1dCB3ZSdkIHN0aWxsIG5lZWQgdG8g
Y2hlY2sgYWZ0ZXIsIGFuZCBhZGRpbmcgYSBzbWFsbCBiaXQgb2YgZXh0cmENCj4gPiA+IGNvbXBs
ZXhpdHkganVzdCB0byB0cnkgdG8gY2F0Y2ggYSB2ZXJ5IHJhcmUgc2l0dWF0aW9uIGlzbid0IHdv
cnRoIGl0Lg0KPiA+ID4gDQo+ID4gPiBUbyBwcmV2ZW50IHJhY2VzLCBzeXN0ZW1fc3RhdGUgbmVl
ZHMgdG8gYmUgY2hlY2sgYWZ0ZXIgcmVnaXN0ZXJfc3lzY29yZV9vcHMoKSwNCj4gPiA+IGJlY2F1
c2Ugb25seSBvbmNlIGt2bV9zeXNjb3JlX29wcyBpcyByZWdpc3RlcmVkIGlzIEtWTSBndWFyYW50
ZWVkIHRvIGdldCBub3RpZmllZA0KPiA+ID4gb2YgYSBzaHV0ZG93bi4gPg0KPiA+ID4gQW5kIGJl
Y2F1c2UgdGhlIGt2bV9zeXNjb3JlX29wcyBob29rcyBkaXNhYmxlIHZpcnR1YWxpemF0aW9uLCB0
aGV5IHNob3VsZCBiZSBjYWxsZWQNCj4gPiA+IGFmdGVyIGNwdWhwX3NldHVwX3N0YXRlKCkuICBU
aGF0J3Mgbm90IHN0cmljdGx5IHJlcXVpcmVkLCBhcyB0aGUgcGVyLUNQVQ0KPiA+ID4gaGFyZHdh
cmVfZW5hYmxlZCBmbGFnIHdpbGwgcHJldmVudCB0cnVlIHByb2JsZW1zIGlmIHRoZSBzeXN0ZW0g
ZW50ZXIgc2h1dGRvd24NCj4gPiA+IHN0YXRlIGJlZm9yZSBLVk0gcmVhY2hlcyBjcHVocF9zZXR1
cF9zdGF0ZSgpLg0KPiA+ID4gDQo+ID4gPiBIbW0sIGJ1dCB0aGUgc2FtZSBlZGdlIGNhc2VzIGV4
aXN0cyBpbiB0aGUgYWJvdmUgZmxvdy4gIElmIHRoZSBzeXN0ZW0gZW50ZXJzDQo+ID4gPiBzaHV0
ZG93biBfanVzdF8gYWZ0ZXIgcmVnaXN0ZXJfc3lzY29yZV9vcHMoKSwgS1ZNIHdvdWxkIHNlZSB0
aGF0IGluIHN5c3RlbV9zdGF0ZQ0KPiA+ID4gYW5kIGRvIGNwdWhwX3JlbW92ZV9zdGF0ZSgpLCBp
LmUuIGludm9rZSBrdm1fb2ZmbGluZV9jcHUoKSBhbmQgdGh1cyBkbyBhIGRvdWJsZQ0KPiA+ID4g
ZGlzYWJsZSAod2hpY2ggYWdhaW4gaXMgYmVuaWduIGJlY2F1c2Ugb2YgaGFyZHdhcmVfZW5hYmxl
ZCkuDQo+ID4gPiANCj4gPiA+IEFoLCBidXQgcmVnaXN0ZXJpbmcgc3lzY29yZSBvcHMgYmVmb3Jl
IGRvaW5nIGNwdWhwX3NldHVwX3N0YXRlKCkgaGFzIGFub3RoZXIgcmFjZSwNCj4gPiA+IGFuZCBv
bmUgdGhhdCBjb3VsZCBiZSBmYXRhbC4gIElmIHRoZSBzeXN0ZW0gZG9lcyBzdXNwZW5kK3Jlc3Vt
ZSBiZWZvcmUgdGhlIGNwdWh1cA0KPiA+ID4gaG9va3MgYXJlIHJlZ2lzdGVyZWQsIGt2bV9yZXN1
bWUoKSB3b3VsZCBlbmFibGUgdmlydHVhbGl6YXRpb24uICBBbmQgdGhlbiBpZg0KPiA+ID4gY3B1
aHBfc2V0dXBfc3RhdGUoKSBmYWlsZWQsIHZpcnR1YWxpemF0aW9uIHdvdWxkIGJlIGxlZnQgZW5h
YmxlZC4NCj4gPiA+IA0KPiA+ID4gU28gY3B1aHBfc2V0dXBfc3RhdGUoKSAqbXVzdCogY29tZSBi
ZWZvcmUgcmVnaXN0ZXJfc3lzY29yZV9vcHMoKSwgYW5kDQo+ID4gPiByZWdpc3Rlcl9zeXNjb3Jl
X29wcygpICptdXN0KiBjb21lIGJlZm9yZSB0aGUgc3lzdGVtX3N0YXRlIGNoZWNrLg0KPiA+IA0K
PiA+IE9LLiAgSSBndWVzcyBJIGhhdmUgdG8gZG91YmxlIGNoZWNrIGhlcmUgdG8gY29tcGxldGVs
eSB1bmRlcnN0YW5kIHRoZSByYWNlcy4NCj4gPiA6LSkNCj4gPiANCj4gPiBTbyBJIHRoaW5rIHdl
IGhhdmUgY29uc2Vuc3VzIHRvIGdvIHdpdGggdGhlIGFwcHJvYWNoIHRoYXQgc2hvd3MgaW4geW91
cg0KPiA+IHNlY29uZCBkaWZmIC0tIHRoYXQgaXMgdG8gYWx3YXlzIGVuYWJsZSB2aXJ0dWFsaXph
dGlvbiBkdXJpbmcgbW9kdWxlIGxvYWRpbmcNCj4gPiBmb3IgYWxsIG90aGVyIEFSQ0hzIG90aGVy
IHRoYW4geDg2LCBmb3Igd2hpY2ggd2Ugb25seSBhbHdheXMgZW5hYmxlcw0KPiA+IHZpcnR1YWxp
emF0aW9uIGR1cmluZyBtb2R1bGUgbG9hZGluZyBmb3IgVERYLg0KPiANCj4gQXNzdW1pbmcgdGhl
IG90aGVyIGFyY2ggbWFpbnRhaW5lcnMgYXJlIG9rIHdpdGggdGhhdCBhcHByb2FjaC4gIElmIHdh
aXRpbmcgdW50aWwNCj4gYSBWTSBpcyBjcmVhdGVkIGlzIGRlc2lyYWJsZSBmb3Igb3RoZXIgYXJj
aGl0ZWN0dXJlcywgdGhlbiB3ZSdsbCBuZWVkIHRvIGZpZ3VyZQ0KPiBvdXQgYSBwbGFuIGIuICBF
LmcuIEtWTSBhcm02NCBkb2Vzbid0IHN1cHBvcnQgYmVpbmcgYnVpbHQgYXMgYSBtb2R1bGUsIHNv
IGVuYWJsaW5nDQo+IGhhcmR3YXJlIGR1cmluZyBpbml0aWFsaXphdGlvbiB3b3VsZCBtZWFuIHZp
cnR1YWxpemF0aW9uIGlzIGVuYWJsZWQgZm9yIGFueSBrZXJuZWwNCj4gdGhhdCBpcyBidWlsdCB3
aXRoIENPTkZJR19LVk09eS4NCj4gDQo+IEFjdHVhbGx5LCBkdWguICBUaGVyZSdzIGFic29sdXRl
bHkgbm8gcmVhc29uIHRvIGZvcmNlIG90aGVyIGFyY2hpdGVjdHVyZXMgdG8NCj4gY2hvb3NlIHdo
ZW4gdG8gZW5hYmxlIHZpcnR1YWxpemF0aW9uLiAgQXMgZXZpZGVuY2VkIGJ5IHRoZSBtYXNzYWdp
bmcgdG8gaGF2ZSB4ODYNCj4ga2VlcCBlbmFibGluZyB2aXJ0dWFsaXphdGlvbiBvbi1kZW1hbmQg
Zm9yICFURFgsIHRoZSBjbGVhbnVwcyBkb24ndCBjb21lIGZyb20NCj4gZW5hYmxpbmcgdmlydHVh
bGl6YXRpb24gZHVyaW5nIG1vZHVsZSBsb2FkLCB0aGV5IGNvbWUgZnJvbSByZWdpc3RlcmluZyBj
cHV1cCBhbmQNCj4gc3lzY29yZSBvcHMgd2hlbiB2aXJ0dWFsaXphdGlvbiBpcyBlbmFibGVkLg0K
PiANCj4gSS5lLiB3ZSBjYW4ga2VlcCBrdm1fdXNhZ2VfY291bnQgaW4gY29tbW9uIGNvZGUsIGFu
ZCBqdXN0IGRvIGV4YWN0bHkgd2hhdCBJDQo+IHByb3Bvc2VkIGZvciBrdm1feDg2X2VuYWJsZV92
aXJ0dWFsaXphdGlvbigpLg0KDQpJZiBzbywgdGhlbiBsb29rcyB0aGlzIGlzIGJhc2ljYWxseSBj
aGFuZ2luZyAiY3B1aHBfc2V0dXBfc3RhdGVfbm9jYWxscygpDQorIG9uX2VhY2hfY3B1KCkiIHRv
ICJjcHVocF9zZXR1cF9zdGF0ZSgpIiwgYW5kIG1vdmluZyBpdCBhbG9uZyB3aXRoDQpyZWdpc3Rl
cl9zeXNjb3JlX29wcygpIHRvIGhhcmR3YXJlX2VuYWJsZV9hbGwoKSI/DQoNCj4gDQo+IEkgaGF2
ZSBwYXRjaGVzIHRvIGRvIHRoaXMsIGFuZCBpbml0aWFsIHRlc3Rpbmcgc3VnZ2VzdHMgdGhleSBh
cmVuJ3Qgd2lsZGx5DQo+IGJyb2tlbi4gIEknbGwgcG9zdCB0aGVtIHNvb24taXNoLCBhc3N1bWlu
ZyBub3RoaW5nIHBvcHMgdXAgaW4gdGVzdGluZy4gIFRoZXkgYXJlDQo+IGNsZWFuIGVub3VnaCB0
aGF0IHRoZXkgY2FuIGxhbmQgaW4gYWR2YW5jZSBvZiBURFgsIGUuZy4gaW4ga3ZtLWNvY28tcXVl
dWUgZXZlbg0KPiBiZWZvcmUgb3RoZXIgYXJjaGl0ZWN0dXJlcyB2ZXJpZnkgSSBkaWRuJ3QgYnJl
YWsgdGhlbS4NCg0KR29vZCB0byBrbm93LiAgSSdsbCBkbyBtb3JlIFREWCB0ZXN0IHdpdGggdGhl
bSBhZnRlciB5b3Ugc2VuZCB0aGVtIG91dC4NCg0KPiANCj4gPiBUaGVuIGhvdyBhYm91dCAiZG8g
a3ZtX3g4Nl92aXJ0dWFsaXphdGlvbl9lbmFibGUoKSAgd2l0aGluDQo+ID4gbGF0ZV9oYXJkd2Fy
ZV9zZXR1cCgpIGluIGt2bV94ODZfdmVuZG9yX2luaXQoKSIgIHZzICJkbw0KPiA+IGt2bV94ODZf
dmlydHVhbGl6YXRpb25fZW5hYmxlKCkgaW4gVERYLXNwZWNpZmljIGNvZGUgYWZ0ZXINCj4gPiBr
dm1feDg2X3ZlbmRvcl9pbml0KCkiPw0KPiA+IA0KPiA+IFdoaWNoIGRvIHlvdSBwcmVmZXI/DQo+
IA0KPiBUaGUgbGF0dGVyLCBhc3N1bWluZyBpdCBkb2Vzbid0IG1ha2UgdGhlIFREWCBjb2RlIG1v
cmUgY29tcGxleCB0aGFuIGl0IG5lZWRzIHRvDQo+IGJlLiAgVGhlIGZld2VyIGt2bV94ODZfb3Bz
IGhvb2tzLCB0aGUgYmV0dGVyLg0KPiANCg0KQWdyZWVkLg0KDQo=

