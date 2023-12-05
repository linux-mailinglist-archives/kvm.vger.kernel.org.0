Return-Path: <kvm+bounces-3626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 387A2805EBE
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:42:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3A771F2160C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 19:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA6C46ABA2;
	Tue,  5 Dec 2023 19:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T3m/izD5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBF5183;
	Tue,  5 Dec 2023 11:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701805306; x=1733341306;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=D9K3o/U9EZ/u03jtnKCLqd3NntVHVQJ9VIEMgU9/0i8=;
  b=T3m/izD5zWakavaR7+95WsoBS1h2fZFR1AnZ5ZLmUHluC1UUQtoeX/Q6
   2/w8uJAW7QsviWWLhRZ9lsxNUy/YZZhk4ZJtb9huvu31/RhAqxLra54KG
   15Xpfzk/DV8aGD9hcXdro6ISr7aluhO2Dg99xinHqnXOhilB6kkqwVseY
   Deij8/0KdJuYauQ/FN+bnbe8c6k8NI+94Cjn7GScTWIk2i0b/1HwrZDNg
   MKOS32P91MmIYy3x3DfqS9ft3DTcWRj7RX0M0ACkw4kPcsrZHb5AZZQw/
   HkEztbCaFseCGG4pC5i7Bu/yvAc85uW0zPL/zRrqAtZ6mehQC5N8rAZao
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="393681129"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="393681129"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 11:41:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="1018319582"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="1018319582"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 11:41:45 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 11:41:44 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 11:41:44 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 5 Dec 2023 11:41:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btR4q2mK/1uhja5CDZ531zYfAdRfz3ZTU+7qORoQlGTslqmbIFMie4KGP1bO2PHJiSR/h89wwVKAdNwXKuJvg828SDj2iJXuhla01BH13/nIPhLIy7XhdAErkegqC7zjUjQkdMBwJTToxQEvxaVucqmLx0a7b6/webVdkSXyi+NnLpeCe/Vp56z4Ui8WjTSQ7YbJTfnUFa2tcq/Z0QOBCC1Z6NV3zrbM5ZDz7Pbd3yJ0w9VVXnwxIQ2uk4ywkwTWgwMmkwpok1gaaf2WSN3VdEm7+Fj3QeH+264J4a/FpzTtkzYnPr6Me6fq2nEXfSN/1ZdUPGBJ/jIlVlyUJMLf9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9K3o/U9EZ/u03jtnKCLqd3NntVHVQJ9VIEMgU9/0i8=;
 b=bze4i5QkNYF9AE6O/cQVqLZO1FbCqLLjcrpfL04l4arFWEN/Di77mopk+HQSzCh3lrNXqVsTJlglgBLF+OhxiZBTkeltymoSCXr/aAktsxlcXmTkIDmrMmrW2EL3coV0oFWl9RcNv/Rcf2uCzJu6VPwqQX0mxs8kBHwGnxmv/p6Nj6SlPRpclbih+qW1dcHikSw47B4z0URrU5jOAZRVbF9HQZA3zzTh/0QRqa0zyzx6AlnnJCocbrXwSvZoM4FnzCKWbxENSifiIJCkfHSQqHiPw5KVqpP0QJ5Oa7I+HrF1nRgzz9zumMK3h0+gi5ymqM2DMGe981M502H5P1vzZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4615.namprd11.prod.outlook.com (2603:10b6:208:263::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:41:42 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7046.033; Tue, 5 Dec 2023
 19:41:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "bp@alien8.de" <bp@alien8.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "Luck, Tony"
	<tony.luck@intel.com>, "ak@linux.intel.com" <ak@linux.intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "imammedo@redhat.com" <imammedo@redhat.com>, "Gao, Chao"
	<chao.gao@intel.com>, "rafael@kernel.org" <rafael@kernel.org>, "Brown, Len"
	<len.brown@intel.com>, "Huang, Ying" <ying.huang@intel.com>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHaEwHtT+sYH5Rms0yY5S8b++o88LCa57iAgABYYQA=
Date: Tue, 5 Dec 2023 19:41:41 +0000
Message-ID: <0db3de96d324710cef469040d88002db429c47e6.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
	 <20231205142517.GBZW8yzVDEKIVTthSx@fat_crate.local>
In-Reply-To: <20231205142517.GBZW8yzVDEKIVTthSx@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4615:EE_
x-ms-office365-filtering-correlation-id: 9a0ae4fd-9aa0-46d8-2894-08dbf5ca34ab
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1gIc0Ur9se2aQjxvIuBEbb/+LStDxRMhF8k6BfIbe4NQmBUzM4CJltTRPppCwM8YTtaz+2WjU0nrnFWlQ7hng1h20drs1o1Sec0YN28iW9diXtMaw+XXAU0g406RZw0rD7kMnRLEhwXHX6NJ5gyWJyE/vtVo+4QpbBtbrt7EaPPLnw/mdpfpGwYhwe+6XZLEYiAROtwzb7kEpSPP/MQ/e0GfqIXpsnJvSD0X0tz+UMGoLQ1fnlotTpWtbLycw5yyCpAzAM2jTXOvDggmQD4gYSkJ1kW86+T9C8B2ndDFXCCyORFkzoy7uIq9hnzMq0PL0xlssUSw1AUAsEe4HITYy0JsB8fQdHdfkydClj9Vz6xx/cB7w+RLCvDhGMTvfnSj4dTypyWXwwUxxg4b2OWMARIcF2Nv2Z5+beElLqqwyp4b8mz54292GtMGYoJYes53CE7LOAMKjcUNe366Q1IvDn8tdVqjTO4br7Xb6oT7Tf3pn2C3N5Jp5tvOhwV2mYPeMHjD+H+ye1cofEKfHtIIKy4UTcvrTpLYg7rB78/UvDI5INYVSS7DmxumMausSLKrWdmEEjRSBPTPWi2WLIKEOFl+syQZGl0jOhJZ+uuPRd9pQ5vmhRbfxBZ+MU8P72IDP+cv3sFMwTtAxoW7pojYfvq3dAmgyLYET21EXlulQbI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(366004)(39860400002)(376002)(396003)(230173577357003)(230922051799003)(230273577357003)(451199024)(186009)(64100799003)(1800799012)(36756003)(86362001)(7416002)(2906002)(5660300002)(41300700001)(38070700009)(122000001)(71200400001)(6506007)(2616005)(6512007)(26005)(83380400001)(82960400001)(478600001)(6486002)(8936002)(8676002)(38100700002)(4326008)(64756008)(6916009)(54906003)(91956017)(66946007)(66556008)(76116006)(316002)(66476007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFN4ZkpxQy9JK3E2UVR2azRQM2JwUDdseDhnM3pweW9XRjZTcHphTzFsU2tD?=
 =?utf-8?B?bWZrazBMeUI5ZWxWdWpTbUNnN0daUUVuWUx5QVpFNGNRa1AzUXphL0tJcWt5?=
 =?utf-8?B?b2o4Vy9pVURQSXBKeG9yb25IRHlUa2oxcWJoQ1JNTDQwcitObWhzMGRuazBp?=
 =?utf-8?B?OFZoR1NmTXNlSm51VHNIaTJFS0dTblI2dUkvZWZwRW90VkVjKzY0RFZadmY1?=
 =?utf-8?B?SlhJYUgyaHdKNnBMQVcyTlF5NUZ0ZGkyMXhycGduemZaU29GaURWRmtQenZT?=
 =?utf-8?B?RHFLYy9CNjZDbFJKcmdyY2NuWWFYSHNGeCtCVTIwT2tEU05tb2FoWFQ5ZDdF?=
 =?utf-8?B?aUx5MzhxeG5qbEw1R2hCOXVhNW91UHIxZ1ltRE9GWUE3bTdQSDlMMU9mUDE1?=
 =?utf-8?B?NUpOSkVYVGN4cnNiZEw1TlpoSEtRN0RNZFZaZXNOVkhZQlZ6ZkFqb2tYVUtU?=
 =?utf-8?B?SlVONU85Yzg1U2I4aWtwUWJtT3VRTmw3OVQrejVMcGhpT3Q4TUlFdWozQ0R3?=
 =?utf-8?B?NW9RTUxNYzc2aWgrY1pCY3VYdUo3ejAvUk1kRFFxdDd0VnRsRE9YcXNiUnhi?=
 =?utf-8?B?RW1NT0t5dkNNVFVXeUZoM3JXK3NmV01KTFd2T2FQTU96MFZRSWViSGQ3ZDRJ?=
 =?utf-8?B?OWs2TDRYRldobU1Pd2kvTHNQQzVkNzg4Z00wMFlWeTgyN1FPaXN4U1dDTHR0?=
 =?utf-8?B?ZkhBbk9zRkcybTlUTnNIRlgxSGxPZkd1cklxRnJ2N1M5V1QwN2d3ZlJQalNz?=
 =?utf-8?B?VzVVOFFQbnNIaElDelE4U1hlV1dBc0ZLOG5raXVKNE5WQmJVck9GdEdnZkNO?=
 =?utf-8?B?R2RtZ3huOG1QYTh2NjZqTUZrSWJYLzRLMTRVWVdNMkY2VDZybG4zV2g3TnNK?=
 =?utf-8?B?UThxNENIS2g5cENUbnlDNCtIQWlvMTlDTFNUazlKWGQ0WDZZOXdTR0N3SmVk?=
 =?utf-8?B?YkJmVmthSDU4MUNqQldkRklQbGkzUTJHZWFkbHJHZTlOQ2F2TENSZmN5ZjN2?=
 =?utf-8?B?M0gvcS9jQnVRL0lpU2YweWI1UmduSncvV0Rlem1OUFZDSmUvZ05DT0ZtSG82?=
 =?utf-8?B?bW9RS2V6SnpoWDhFd2MzOW8rbTBrcTkzVFpYRUVhVU5tVlVTbHgrRjhQanJ2?=
 =?utf-8?B?T2xQN0Vkc3VvYkZrZXNyVXdNZisxOFRmcmU5cnQwNUlzaXhqeXBtVlpYZjJY?=
 =?utf-8?B?aG1PZi9nbVYzSXIzU0tjMi82TVZ2cXdwdmtqY25LaWQyT1l5VzR6YW1kQ21j?=
 =?utf-8?B?K0FGbldVdGFxM3pTaGtTZFp4TTNmclo1TWtEN2ZKcTgxN1FPUDg3U2ZUcXFn?=
 =?utf-8?B?dmt0MGZFMU9yanp4ZWpieHk3aWt6NFhqWHNiYWdyOENGdSttNmszQVdyMGIw?=
 =?utf-8?B?ai96Q2tBdDhEdmg5cVh0NVd1ZkZ2RVhEay9tL1lNV2ZLeUN1Tm91OWNQZmtn?=
 =?utf-8?B?VW1Pd2RzVGY1VEZjN05sb3o1NUgvV29ONDduWmJyVDlwdFdKQWVrOW9XS2hx?=
 =?utf-8?B?WnJoZ2hVUVNlYXVuWXg2ZmhYajFnbitCTTZ2YzZSREZOMVk2ek5ramdDZW5t?=
 =?utf-8?B?NW9NbndWQlN1Ym00RmplRlV3N2VqZ0xpTE5rd2JOT0hCZDcvS2I2U0QrMno3?=
 =?utf-8?B?Q2JOV1k5MGxoR0U2U0FodlB2cFBwanMrMDZIb3VuUktVdTVaaFJJSUJlcDkr?=
 =?utf-8?B?Q0Yza3NJNCtMcjJhbUIvZ0NQei9sRTFoMTlnRW51QU9JMjUvVWpDVzJpQklq?=
 =?utf-8?B?bDlmT0FpYmtnNisyRi9mZHN5SHQ5Nit0THZEdEc0NmtWbUJ4bERzcFZScFRO?=
 =?utf-8?B?Q2kvNjFVUjFsVXZtY3hwOUVpNWZlTFVlUVNETE51QjNuSVd1d1ljaU1BUThY?=
 =?utf-8?B?Y1hya2VTNnVNbk9UNEZkZ3ZLOUpTWkI2QVd2c09GWWVpYzVLUG5MTnE2WkND?=
 =?utf-8?B?Y0hqMFIzZzRKbGhKSCttdEw5RDVBUEFjZ21VSi9DN29MM1NrcjZ4Rk9LWkpM?=
 =?utf-8?B?U1ROTHZjQnFwdjRSUjJxVHlwMDN3SWdlejFFVlZOSHlnWkQwUlo5NzBSbGFS?=
 =?utf-8?B?NTlWdmZBd0dTaXVSbjAveXd3UFkzVFFvdHM1Y2dGSTV1b21BVjY2V1FmaEV1?=
 =?utf-8?B?bWxvMXRjL2o0RDBNaGpZZzVSUVhDN3B1Uy9VL3B2TXoyQXJHRWZMSFlVeFlp?=
 =?utf-8?B?SUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1CDE45C1AB49046BE618F927EB25759@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0ae4fd-9aa0-46d8-2894-08dbf5ca34ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2023 19:41:41.8378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xZrG4gqzyleLww+cY3AAPrtst84sWxVw07T2/+6+tB6+uJG73qoBLsvWkkBrpJ0scVFJvKtHwjZOYIDha1sv+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4615
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTEyLTA1IGF0IDE1OjI1ICswMTAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIEZyaSwgTm92IDEwLCAyMDIzIGF0IDEyOjU1OjU5QU0gKzEzMDAsIEthaSBIdWFuZyB3
cm90ZToNCj4gPiArc3RhdGljIGNvbnN0IGNoYXIgKm1jZV9tZW1vcnlfaW5mbyhzdHJ1Y3QgbWNl
ICptKQ0KPiA+ICt7DQo+ID4gKwlpZiAoIW0gfHwgIW1jZV9pc19tZW1vcnlfZXJyb3IobSkgfHwg
IW1jZV91c2FibGVfYWRkcmVzcyhtKSkNCj4gPiArCQlyZXR1cm4gTlVMTDsNCj4gPiArDQo+ID4g
KwkvKg0KPiA+ICsJICogQ2VydGFpbiBpbml0aWFsIGdlbmVyYXRpb25zIG9mIFREWC1jYXBhYmxl
IENQVXMgaGF2ZSBhbg0KPiA+ICsJICogZXJyYXR1bS4gIEEga2VybmVsIG5vbi10ZW1wb3JhbCBw
YXJ0aWFsIHdyaXRlIHRvIFREWCBwcml2YXRlDQo+ID4gKwkgKiBtZW1vcnkgcG9pc29ucyB0aGF0
IG1lbW9yeSwgYW5kIGEgc3Vic2VxdWVudCByZWFkIG9mIHRoYXQNCj4gPiArCSAqIG1lbW9yeSB0
cmlnZ2VycyAjTUMuDQo+ID4gKwkgKg0KPiA+ICsJICogSG93ZXZlciBzdWNoICNNQyBjYXVzZWQg
Ynkgc29mdHdhcmUgY2Fubm90IGJlIGRpc3Rpbmd1aXNoZWQNCj4gPiArCSAqIGZyb20gdGhlIHJl
YWwgaGFyZHdhcmUgI01DLiAgSnVzdCBwcmludCBhZGRpdGlvbmFsIG1lc3NhZ2UNCj4gPiArCSAq
IHRvIHNob3cgc3VjaCAjTUMgbWF5IGJlIHJlc3VsdCBvZiB0aGUgQ1BVIGVycmF0dW0uDQo+ID4g
KwkgKi8NCj4gPiArCWlmICghYm9vdF9jcHVfaGFzX2J1ZyhYODZfQlVHX1REWF9QV19NQ0UpKQ0K
PiA+ICsJCXJldHVybiBOVUxMOw0KPiA+ICsNCj4gPiArCXJldHVybiAhdGR4X2lzX3ByaXZhdGVf
bWVtKG0tPmFkZHIpID8gTlVMTCA6DQo+ID4gKwkJIlREWCBwcml2YXRlIG1lbW9yeSBlcnJvci4g
UG9zc2libGUga2VybmVsIGJ1Zy4iOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgbm9pbnN0
ciB2b2lkIG1jZV9wYW5pYyhjb25zdCBjaGFyICptc2csIHN0cnVjdCBtY2UgKmZpbmFsLCBjaGFy
ICpleHApDQo+ID4gIHsNCj4gPiAgCXN0cnVjdCBsbGlzdF9ub2RlICpwZW5kaW5nOw0KPiA+ICAJ
c3RydWN0IG1jZV9ldnRfbGxpc3QgKmw7DQo+ID4gIAlpbnQgYXBlaV9lcnIgPSAwOw0KPiA+ICsJ
Y29uc3QgY2hhciAqbWVtbXNnOw0KPiA+ICANCj4gPiAgCS8qDQo+ID4gIAkgKiBBbGxvdyBpbnN0
cnVtZW50YXRpb24gYXJvdW5kIGV4dGVybmFsIGZhY2lsaXRpZXMgdXNhZ2UuIE5vdCB0aGF0IGl0
DQo+ID4gQEAgLTI4Myw2ICszMDcsMTUgQEAgc3RhdGljIG5vaW5zdHIgdm9pZCBtY2VfcGFuaWMo
Y29uc3QgY2hhciAqbXNnLCBzdHJ1Y3QgbWNlICpmaW5hbCwgY2hhciAqZXhwKQ0KPiA+ICAJfQ0K
PiA+ICAJaWYgKGV4cCkNCj4gPiAgCQlwcl9lbWVyZyhIV19FUlIgIk1hY2hpbmUgY2hlY2s6ICVz
XG4iLCBleHApOw0KPiA+ICsJLyoNCj4gPiArCSAqIENvbmZpZGVudGlhbCBjb21wdXRpbmcgcGxh
dGZvcm1zIHN1Y2ggYXMgVERYIHBsYXRmb3Jtcw0KPiA+ICsJICogbWF5IG9jY3VyIE1DRSBkdWUg
dG8gaW5jb3JyZWN0IGFjY2VzcyB0byBjb25maWRlbnRpYWwNCj4gPiArCSAqIG1lbW9yeS4gIFBy
aW50IGFkZGl0aW9uYWwgaW5mb3JtYXRpb24gZm9yIHN1Y2ggZXJyb3IuDQo+ID4gKwkgKi8NCj4g
PiArCW1lbW1zZyA9IG1jZV9tZW1vcnlfaW5mbyhmaW5hbCk7DQo+ID4gKwlpZiAobWVtbXNnKQ0K
PiA+ICsJCXByX2VtZXJnKEhXX0VSUiAiTWFjaGluZSBjaGVjazogJXNcbiIsIG1lbW1zZyk7DQo+
ID4gKw0KPiANCj4gTm8sIHRoaXMgaXMgbm90IGhvdyB0aGlzIGlzIGRvbmUuIEZpcnN0IG9mIGFs
bCwgdGhpcyBmdW5jdGlvbiBzaG91bGQgYmUNCj4gY2FsbGVkIHNvbWV0aGluZyBsaWtlDQo+IA0K
PiAJbWNlX2R1bXBfYXV4X2luZm8oKQ0KPiANCj4gb3Igc28gdG8gc3RhdGUgdGhhdCBpdCBpcyBk
dW1waW5nIHNvbWUgYXV4aWxpYXJ5IGluZm8uDQo+IA0KPiBUaGVuLCBpdCBkb2VzOg0KPiANCj4g
CWlmIChjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1REWF9HVUVTVCkpDQo+IAkJcmV0
dXJuIHRkeF9nZXRfbWNlX2luZm8oKTsNCj4gDQo+IG9yIHNvIGFuZCB5b3UgcHV0IHRoYXQgdGR4
X2dldF9tY2VfaW5mbygpIGZ1bmN0aW9uIGluIFREWCBjb2RlIGFuZCB0aGVyZQ0KPiB5b3UgZG8g
YWxsIHlvdXIgcGlja2luZyBhcGFydCBvZiB0aGluZ3MsIHdoYXQgbmVlZHMgdG8gYmUgZHVtcGVk
IG9yIHdoYXQNCj4gbm90LCBjaGVja2luZyB3aGV0aGVyIGl0IGlzIGEgbWVtb3J5IGVycm9yIGFu
ZCBzbyBvbi4NCj4gDQo+IFRoeC4NCj4gDQoNClRoYW5rcyBCb3Jpcy4gIExvb2tzIGdvb2QgdG8g
bWUsIHdpdGggb25lIGV4Y2VwdGlvbiB0aGF0IGl0IGlzIGFjdHVhbGx5IFREWA0KaG9zdCwgYnV0
IG5vdCBURFggZ3Vlc3QuICBTbyB0aGF0IHRoZSBhYm92ZSBYODZfRkVBVFVSRV9URFhfR1VFU1Qg
Y3B1IGZlYXR1cmUNCmNoZWNrIG5lZWRzIHRvIGJlIHJlcGxhY2VkIHdpdGggdGhlIGhvc3Qgb25l
Lg0KDQpGdWxsIGluY3JlbWVudGFsIGRpZmYgYmVsb3cuICBDb3VsZCB5b3UgdGFrZSBhIGxvb2sg
d2hldGhlciB0aGlzIGlzIHdoYXQgeW91DQp3YW50Pw0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
aW5jbHVkZS9hc20vdGR4LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KaW5kZXggYTYy
MTcyMWY2M2RkLi4wYzAyYjY2ZGNjNDEgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS90ZHguaA0KKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCkBAIC0xMTUsMTMgKzEx
NSwxMyBAQCBib29sIHBsYXRmb3JtX3RkeF9lbmFibGVkKHZvaWQpOw0KIGludCB0ZHhfY3B1X2Vu
YWJsZSh2b2lkKTsNCiBpbnQgdGR4X2VuYWJsZSh2b2lkKTsNCiB2b2lkIHRkeF9yZXNldF9tZW1v
cnkodm9pZCk7DQotYm9vbCB0ZHhfaXNfcHJpdmF0ZV9tZW0odW5zaWduZWQgbG9uZyBwaHlzKTsN
Citjb25zdCBjaGFyICp0ZHhfZ2V0X21jZV9pbmZvKHVuc2lnbmVkIGxvbmcgcGh5cyk7DQogI2Vs
c2UNCiBzdGF0aWMgaW5saW5lIGJvb2wgcGxhdGZvcm1fdGR4X2VuYWJsZWQodm9pZCkgeyByZXR1
cm4gZmFsc2U7IH0NCiBzdGF0aWMgaW5saW5lIGludCB0ZHhfY3B1X2VuYWJsZSh2b2lkKSB7IHJl
dHVybiAtRU5PREVWOyB9DQogc3RhdGljIGlubGluZSBpbnQgdGR4X2VuYWJsZSh2b2lkKSAgeyBy
ZXR1cm4gLUVOT0RFVjsgfQ0KIHN0YXRpYyBpbmxpbmUgdm9pZCB0ZHhfcmVzZXRfbWVtb3J5KHZv
aWQpIHsgfQ0KLXN0YXRpYyBpbmxpbmUgYm9vbCB0ZHhfaXNfcHJpdmF0ZV9tZW0odW5zaWduZWQg
bG9uZyBwaHlzKSB7IHJldHVybiBmYWxzZTsgfQ0KK3N0YXRpYyBpbmxpbmUgY29uc3QgY2hhciAq
dGR4X2dldF9tY2VfaW5mbyh1bnNpZ25lZCBsb25nIHBoeXMpIHsgcmV0dXJuIE5VTEw7IH0NCiAj
ZW5kaWYgLyogQ09ORklHX0lOVEVMX1REWF9IT1NUICovDQoNCiAjZW5kaWYgLyogIV9fQVNTRU1C
TFlfXyAqLw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvbWNlL2NvcmUuYyBiL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvbWNlL2NvcmUuYw0KaW5kZXggZTMzNTM3Y2ZjNTA3Li5iN2U2NTBi
NWY3ZWYgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L21jZS9jb3JlLmMNCisrKyBi
L2FyY2gveDg2L2tlcm5lbC9jcHUvbWNlL2NvcmUuYw0KQEAgLTIyOSwyNiArMjI5LDIwIEBAIHN0
YXRpYyB2b2lkIHdhaXRfZm9yX3BhbmljKHZvaWQpDQogICAgICAgIHBhbmljKCJQYW5pY2luZyBt
YWNoaW5lIGNoZWNrIENQVSBkaWVkIik7DQogfQ0KDQotc3RhdGljIGNvbnN0IGNoYXIgKm1jZV9t
ZW1vcnlfaW5mbyhzdHJ1Y3QgbWNlICptKQ0KK3N0YXRpYyBjb25zdCBjaGFyICptY2VfZHVtcF9h
dXhfaW5mbyhzdHJ1Y3QgbWNlICptKQ0KIHsNCi0gICAgICAgaWYgKCFtIHx8ICFtY2VfaXNfbWVt
b3J5X2Vycm9yKG0pIHx8ICFtY2VfdXNhYmxlX2FkZHJlc3MobSkpDQotICAgICAgICAgICAgICAg
cmV0dXJuIE5VTEw7DQotDQogICAgICAgIC8qDQotICAgICAgICAqIENlcnRhaW4gaW5pdGlhbCBn
ZW5lcmF0aW9ucyBvZiBURFgtY2FwYWJsZSBDUFVzIGhhdmUgYW4NCi0gICAgICAgICogZXJyYXR1
bS4gIEEga2VybmVsIG5vbi10ZW1wb3JhbCBwYXJ0aWFsIHdyaXRlIHRvIFREWCBwcml2YXRlDQot
ICAgICAgICAqIG1lbW9yeSBwb2lzb25zIHRoYXQgbWVtb3J5LCBhbmQgYSBzdWJzZXF1ZW50IHJl
YWQgb2YgdGhhdA0KLSAgICAgICAgKiBtZW1vcnkgdHJpZ2dlcnMgI01DLg0KLSAgICAgICAgKg0K
LSAgICAgICAgKiBIb3dldmVyIHN1Y2ggI01DIGNhdXNlZCBieSBzb2Z0d2FyZSBjYW5ub3QgYmUg
ZGlzdGluZ3Vpc2hlZA0KLSAgICAgICAgKiBmcm9tIHRoZSByZWFsIGhhcmR3YXJlICNNQy4gIEp1
c3QgcHJpbnQgYWRkaXRpb25hbCBtZXNzYWdlDQotICAgICAgICAqIHRvIHNob3cgc3VjaCAjTUMg
bWF5IGJlIHJlc3VsdCBvZiB0aGUgQ1BVIGVycmF0dW0uDQorICAgICAgICAqIENvbmZpZGVudGlh
bCBjb21wdXRpbmcgcGxhdGZvcm1zIHN1Y2ggYXMgVERYIHBsYXRmb3Jtcw0KKyAgICAgICAgKiBt
YXkgb2NjdXIgTUNFIGR1ZSB0byBpbmNvcnJlY3QgYWNjZXNzIHRvIGNvbmZpZGVudGlhbA0KKyAg
ICAgICAgKiBtZW1vcnkuICBQcmludCBhZGRpdGlvbmFsIGluZm9ybWF0aW9uIGZvciBzdWNoIGVy
cm9yLg0KICAgICAgICAgKi8NCi0gICAgICAgaWYgKCFib290X2NwdV9oYXNfYnVnKFg4Nl9CVUdf
VERYX1BXX01DRSkpDQorICAgICAgIGlmICghbSB8fCAhbWNlX2lzX21lbW9yeV9lcnJvcihtKSB8
fCAhbWNlX3VzYWJsZV9hZGRyZXNzKG0pKQ0KICAgICAgICAgICAgICAgIHJldHVybiBOVUxMOw0K
DQotICAgICAgIHJldHVybiAhdGR4X2lzX3ByaXZhdGVfbWVtKG0tPmFkZHIpID8gTlVMTCA6DQot
ICAgICAgICAgICAgICAgIlREWCBwcml2YXRlIG1lbW9yeSBlcnJvci4gUG9zc2libGUga2VybmVs
IGJ1Zy4iOw0KKyAgICAgICBpZiAocGxhdGZvcm1fdGR4X2VuYWJsZWQoKSkNCisgICAgICAgICAg
ICAgICByZXR1cm4gdGR4X2dldF9tY2VfaW5mbyhtLT5hZGRyKTsNCisNCisgICAgICAgcmV0dXJu
IE5VTEw7DQogfQ0KDQogc3RhdGljIG5vaW5zdHIgdm9pZCBtY2VfcGFuaWMoY29uc3QgY2hhciAq
bXNnLCBzdHJ1Y3QgbWNlICpmaW5hbCwgY2hhciAqZXhwKQ0KQEAgLTI1Niw3ICsyNTAsNyBAQCBz
dGF0aWMgbm9pbnN0ciB2b2lkIG1jZV9wYW5pYyhjb25zdCBjaGFyICptc2csIHN0cnVjdCBtY2UN
CipmaW5hbCwgY2hhciAqZXhwKQ0KICAgICAgICBzdHJ1Y3QgbGxpc3Rfbm9kZSAqcGVuZGluZzsN
CiAgICAgICAgc3RydWN0IG1jZV9ldnRfbGxpc3QgKmw7DQogICAgICAgIGludCBhcGVpX2VyciA9
IDA7DQotICAgICAgIGNvbnN0IGNoYXIgKm1lbW1zZzsNCisgICAgICAgY29uc3QgY2hhciAqYXV4
aW5mbzsNCg0KICAgICAgICAvKg0KICAgICAgICAgKiBBbGxvdyBpbnN0cnVtZW50YXRpb24gYXJv
dW5kIGV4dGVybmFsIGZhY2lsaXRpZXMgdXNhZ2UuIE5vdCB0aGF0IGl0DQpAQCAtMzA3LDE0ICsz
MDEsMTAgQEAgc3RhdGljIG5vaW5zdHIgdm9pZCBtY2VfcGFuaWMoY29uc3QgY2hhciAqbXNnLCBz
dHJ1Y3QgbWNlDQoqZmluYWwsIGNoYXIgKmV4cCkNCiAgICAgICAgfQ0KICAgICAgICBpZiAoZXhw
KQ0KICAgICAgICAgICAgICAgIHByX2VtZXJnKEhXX0VSUiAiTWFjaGluZSBjaGVjazogJXNcbiIs
IGV4cCk7DQotICAgICAgIC8qDQotICAgICAgICAqIENvbmZpZGVudGlhbCBjb21wdXRpbmcgcGxh
dGZvcm1zIHN1Y2ggYXMgVERYIHBsYXRmb3Jtcw0KLSAgICAgICAgKiBtYXkgb2NjdXIgTUNFIGR1
ZSB0byBpbmNvcnJlY3QgYWNjZXNzIHRvIGNvbmZpZGVudGlhbA0KLSAgICAgICAgKiBtZW1vcnku
ICBQcmludCBhZGRpdGlvbmFsIGluZm9ybWF0aW9uIGZvciBzdWNoIGVycm9yLg0KLSAgICAgICAg
Ki8NCi0gICAgICAgbWVtbXNnID0gbWNlX21lbW9yeV9pbmZvKGZpbmFsKTsNCi0gICAgICAgaWYg
KG1lbW1zZykNCi0gICAgICAgICAgICAgICBwcl9lbWVyZyhIV19FUlIgIk1hY2hpbmUgY2hlY2s6
ICVzXG4iLCBtZW1tc2cpOw0KKw0KKyAgICAgICBhdXhpbmZvID0gbWNlX2R1bXBfYXV4X2luZm8o
ZmluYWwpOw0KKyAgICAgICBpZiAoYXV4aW5mbykNCisgICAgICAgICAgICAgICBwcl9lbWVyZyhI
V19FUlIgIk1hY2hpbmUgY2hlY2s6ICVzXG4iLCBhdXhpbmZvKTsNCg0KICAgICAgICBpZiAoIWZh
a2VfcGFuaWMpIHsNCiAgICAgICAgICAgICAgICBpZiAocGFuaWNfdGltZW91dCA9PSAwKQ0KZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYw0KaW5kZXggMWI4NGRjZGY2M2NiLi5jZmJhZWMwZjQzYjIgMTAwNjQ0DQotLS0g
YS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCisrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHguYw0KQEAgLTEzMjksNyArMTMyOSw3IEBAIHN0YXRpYyBib29sIGlzX3BhbXRfcGFnZSh1
bnNpZ25lZCBsb25nIHBoeXMpDQogICogYmVjYXVzZSBpdCBjYW5ub3QgZGlzdGluZ3Vpc2ggI01D
IGJldHdlZW4gc29mdHdhcmUgYnVnIGFuZCByZWFsDQogICogaGFyZHdhcmUgZXJyb3IgYW55d2F5
Lg0KICAqLw0KLWJvb2wgdGR4X2lzX3ByaXZhdGVfbWVtKHVuc2lnbmVkIGxvbmcgcGh5cykNCitz
dGF0aWMgYm9vbCB0ZHhfaXNfcHJpdmF0ZV9tZW0odW5zaWduZWQgbG9uZyBwaHlzKQ0KIHsNCiAg
ICAgICAgc3RydWN0IHRkeF9tb2R1bGVfYXJncyBhcmdzID0gew0KICAgICAgICAgICAgICAgIC5y
Y3ggPSBwaHlzICYgUEFHRV9NQVNLLA0KQEAgLTEzOTEsNiArMTM5MSwyNSBAQCBib29sIHRkeF9p
c19wcml2YXRlX21lbSh1bnNpZ25lZCBsb25nIHBoeXMpDQogICAgICAgIH0NCiB9DQoNCitjb25z
dCBjaGFyICp0ZHhfZ2V0X21jZV9pbmZvKHVuc2lnbmVkIGxvbmcgcGh5cykNCit7DQorICAgICAg
IC8qDQorICAgICAgICAqIENlcnRhaW4gaW5pdGlhbCBnZW5lcmF0aW9ucyBvZiBURFgtY2FwYWJs
ZSBDUFVzIGhhdmUgYW4NCisgICAgICAgICogZXJyYXR1bS4gIEEga2VybmVsIG5vbi10ZW1wb3Jh
bCBwYXJ0aWFsIHdyaXRlIHRvIFREWCBwcml2YXRlDQorICAgICAgICAqIG1lbW9yeSBwb2lzb25z
IHRoYXQgbWVtb3J5LCBhbmQgYSBzdWJzZXF1ZW50IHJlYWQgb2YgdGhhdA0KKyAgICAgICAgKiBt
ZW1vcnkgdHJpZ2dlcnMgI01DLg0KKyAgICAgICAgKg0KKyAgICAgICAgKiBIb3dldmVyIHN1Y2gg
I01DIGNhdXNlZCBieSBzb2Z0d2FyZSBjYW5ub3QgYmUgZGlzdGluZ3Vpc2hlZA0KKyAgICAgICAg
KiBmcm9tIHRoZSByZWFsIGhhcmR3YXJlICNNQy4gIEp1c3QgcHJpbnQgYWRkaXRpb25hbCBtZXNz
YWdlDQorICAgICAgICAqIHRvIHNob3cgc3VjaCAjTUMgbWF5IGJlIHJlc3VsdCBvZiB0aGUgQ1BV
IGVycmF0dW0uDQorICAgICAgICAqLw0KKyAgICAgICBpZiAoIWJvb3RfY3B1X2hhc19idWcoWDg2
X0JVR19URFhfUFdfTUNFKSkNCisgICAgICAgICAgICAgICByZXR1cm4gTlVMTDsNCisNCisgICAg
ICAgcmV0dXJuICF0ZHhfaXNfcHJpdmF0ZV9tZW0ocGh5cykgPyBOVUxMIDoNCisgICAgICAgICAg
ICAgICAiVERYIHByaXZhdGUgbWVtb3J5IGVycm9yLiBQb3NzaWJsZSBrZXJuZWwgYnVnLiI7DQor
fQ0KKw0KIHN0YXRpYyBpbnQgX19pbml0IHJlY29yZF9rZXlpZF9wYXJ0aXRpb25pbmcodTMyICp0
ZHhfa2V5aWRfc3RhcnQsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHUzMiAqbnJfdGR4X2tleWlkcykNCiB7DQoNCg==

