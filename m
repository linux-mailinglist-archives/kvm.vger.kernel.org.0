Return-Path: <kvm+bounces-3631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD33C805F1D
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 21:08:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C39B1C20A60
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B396DCF3;
	Tue,  5 Dec 2023 20:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OCZcgtRg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A43196;
	Tue,  5 Dec 2023 12:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701806917; x=1733342917;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/3MNT0euTU3CkKhUfV7/1HJwmsJKaFLC5Uyoy0kTOAM=;
  b=OCZcgtRgVzq/DQ8ni2itOrH/Yv6pynV7Hj9ariSNVqYGtXOotIKEyPH8
   eNsNOeDKndOL/495SjzKJBEOmJRI6w+Ic+Vu3CBrHMRpKM63uhhu/5Wkv
   tz8zHm4itlThuZgN82GH9bJqrmuqYrZ0Nt3Rhir5f2VVsBqV+znsObD+D
   N1GWp7r7eZyj1E8tWtYgPRgeW8v8q6ZbCkce0se5AEgO2+kVEFVrbw4zJ
   LjU3n8XJ0kTXXe7v/o/RkX7KbUaXGwd6woLWezwBa68QdGR3TlDA8rHEr
   ezv73FRiantowG55MLwzJY0uC+VOGgLLCf/MHAWQJjsbM9dNntYHBDKXs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="7250006"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="7250006"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 12:08:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="771034762"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="771034762"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 12:08:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 12:08:36 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 12:08:36 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 5 Dec 2023 12:08:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQ28JQE2oBCOZfJf+IngQtuYuPUowpC5bxgyRE+bpsMuK/S/kj1HwOW/e5y7OtIRdc1Mln+K6541k/p9QpfLPWSd0qWRcZufrP50pssH3cgzwXHXPQdhsM8QlM9TxGgZYiDUFIzY0CvMUYG3cdxfSUqFgK2hdearwLbZjXPlTZ4DD0kXgepyJ6U4V68qmhmC3WGf8iDR+RwNkum0rbFqn4u7obFT700N7sPi9ur//8dKvlXQjwEdWrtTFaKZD5hLUJnIMjSm4FiHfUXpD95S7YFbSnq55HUzNg9sptlxiE2YVx77uPEPavJ0Xk9Cy0gnEoOdhpR6MMb5lENzhjT5gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3MNT0euTU3CkKhUfV7/1HJwmsJKaFLC5Uyoy0kTOAM=;
 b=aaUKtVM6qnsU+6d0yWAaMLErtqrcvcNJ6pqZjc6me/h4ahJnFRpcOda4xKwPwlDE9IY8EIa4yAhzVooKFpHaKVuyXFSP8eys3MDQtaQcXTSDY2e/LGXvybxBezKGQ+V1xoMtoTIwDs+f9Bjxx1h/k8iKjRiaNu4AKxe5zRwbQ/N6qqwtKzNTQSX0sMcV/Yiqg9Lmh6BlidZoMrTvMJOPyRuqh3++rRkDLV93M5ePE8c3abg4CAnyMwbr68D54thuCUlEdhTyOalmo2CqNbe1WU6Hth+ZA0VoZuYRS7r2AdGU3Xahltv+fyyqA9VO37U3KQvPsLVPweGUS51YqoIr7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB8226.namprd11.prod.outlook.com (2603:10b6:8:182::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 20:08:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7046.033; Tue, 5 Dec 2023
 20:08:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "bp@alien8.de" <bp@alien8.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "x86@kernel.org"
	<x86@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
	"ak@linux.intel.com" <ak@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Luck, Tony" <tony.luck@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "imammedo@redhat.com" <imammedo@redhat.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Huang, Ying"
	<ying.huang@intel.com>, "Brown, Len" <len.brown@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHaEwHtT+sYH5Rms0yY5S8b++o88LCa57iAgABYYQCAAAQygIAAA1GA
Date: Tue, 5 Dec 2023 20:08:34 +0000
Message-ID: <2394202d237b4a74440fba1a267652335b53b71d.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
	 <20231205142517.GBZW8yzVDEKIVTthSx@fat_crate.local>
	 <0db3de96d324710cef469040d88002db429c47e6.camel@intel.com>
	 <20231205195637.GHZW+Add3H/gSefAVM@fat_crate.local>
In-Reply-To: <20231205195637.GHZW+Add3H/gSefAVM@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB8226:EE_
x-ms-office365-filtering-correlation-id: f971d88a-eead-4268-d824-08dbf5cdf5d9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ef3BoZhrXu2xLKTG9sXCCkDEC1PSx3X43+2rSYYgZp/OQAn4J12Ak5V6zNHif5R3tFD8iKDUFo4c2/UkVX3Jl8vLgtsn7D+Yxq81cX2zc4dMCE+h45LHkNZssPEChn1g3dE2VQfGRokDVbrIYgg4x10h3EyQE7uV+0rkF0rdMdGp0P0kMC15FhhNm1RLXvayn7GRGBi9N/OuipDspYmI3dFBvlNSYA0UEIUSa7+lXHPbwQy9RC9MI8qHQgiljocEEG4UzuFxpofyKm37aQ7UxmSEmhLmnDgjWbRqNOD4+6rflIzxVO1tPRWurF1hmPOPDp/qCKu9gju672Wa6LhySnh8go46JgVNAtpkWyT7bY11AixLbt3bqXfwabnz3lJu6PAsHCsWySoETHews5WQvR02swQGBLZVR7Jw9JH+cI+obdlV7UhKXS0DBHGcgET4gWnQVRH1gwXjoUDfzMoTEdLCDSxCWuUJ2DHOSi1TkkVq2wyj354A6jHHscoIrmSS+zH9pEMVpwbiMw+fGd3274ZNGhVb7fBwBW6oqOmfmiw72K3Gxjznvtf7rBhqDb8Dts/FnuTxx7ZHXdjvyvkkC703kX9kLzLqfUXm/ECs2A+JxYvMGsSVT/evf1bC9yS3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(39860400002)(396003)(136003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(26005)(6486002)(478600001)(83380400001)(6512007)(6506007)(71200400001)(36756003)(82960400001)(2616005)(316002)(91956017)(54906003)(76116006)(6916009)(66446008)(66476007)(64756008)(66946007)(66556008)(122000001)(38100700002)(8676002)(86362001)(2906002)(8936002)(7416002)(4326008)(41300700001)(5660300002)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cUdrZTBJVEorOVRBL1J1RVpQL0g4WGR4V29vdmdrdVFIMWtPK3dmNzJmdnM4?=
 =?utf-8?B?b3FJZG1ETjFOUVZQbUlJenhNbmo1TU5OejN6b3V0dUVkbkxOKzFZRlVkSGFY?=
 =?utf-8?B?K2dzKy90bDNHRDE1NDZRYjM1NHVYYlRLMk1XWGZKcmtvZTE2Kzl1RW9pdjJZ?=
 =?utf-8?B?dFFVQU9HNmsyd1plVXRZOXNRU2hYNFpDY3RHc1pscmY2czQwWEZBQ0JZSmpw?=
 =?utf-8?B?NmVuTXdkTEZrNzN3YnZWdHlBWnU5RDl1U0g0Vm05L2tIdFFaL1pvRVYwaFNU?=
 =?utf-8?B?dFBlWExQdW11eURzUkE5MzE1RUl0eTFPL3dZVWNteUpuVjJFV2RTejVUdEtp?=
 =?utf-8?B?dHpRUUcrVm9OdGNMRGhQTGFiL1BIT1JYWE1YdFVsdGdVM2ZzN1BYZVpKOTNK?=
 =?utf-8?B?ZG1ETnUxUWxHczVoNDhPN1BQeHNkU0dMeVYrYlRCQ0FQelFvNmlIL2k1ZXQw?=
 =?utf-8?B?NVcxMGFMSlMreThlTlh0WHJPaXRybENVaGpQOEhuL2lXd0ZsMkR2QmZKK3JH?=
 =?utf-8?B?T2ppK3pHVTBleXdldnNpNDRld0hEbXFYQ2hzZHFkeWw5eEpKdEx1U1lGc1c3?=
 =?utf-8?B?SHExWWFpdDllaUZxSEk0cFordlcvQW9nTytUNE9LQkhRM2l1bUNZeFFSWGNB?=
 =?utf-8?B?bWMwbnRVdFZRNHB5K3lnL1Bia0VtNDRta01vdGRjTGcyTUYwbU8vL0NmUzUw?=
 =?utf-8?B?b2hhUHJwbTQwbEt5VG5Za0pUKzN2SzBEbE01WmFRV2RDWFRKU0FmbUFvU21W?=
 =?utf-8?B?bS8xV2diY282dEt1SlU3VXpTNXJldFJCWUQ3dmtZbTcwUDV3UXkrUnBGWlhB?=
 =?utf-8?B?WkhuaWs2ZzEwNWV1R0RWWTFkZVJiQWw1QXNCZmlHTGVVRVd0V0hIdDVuNFlB?=
 =?utf-8?B?NGxRdlZaaEtJZjFVNU1paGVoc0RyRHdtNW9KdXVVR3VrQlUzZ1RITTFmRVd5?=
 =?utf-8?B?Y1FsdXpVY1lhWUhrZy8rTUViNCtZTWxqd3BxMFVxQ1hVSFNzNUppUDNJaVNL?=
 =?utf-8?B?ZjR4N1FyZ1NxMWppVjlscldFMjdxLzJpSldXSDN6SFlIdzEwd1NQTUhmZmpS?=
 =?utf-8?B?b216Z0Q5c3NVSFA1eGtFMXhYMXUvdUh0d3VmbHltS2d0V1diYkkwTy9hcC9Z?=
 =?utf-8?B?V3l5d3NabU5sbTE2QUZBMGk1bFBLbU1hcEFuWWVuR3orQ3l0b0d3Qkx2ZWxi?=
 =?utf-8?B?cDZFQ0ttaXk2UnpKMnRxL05KMFFmVHIweGtjQlM3ZmduSGw3bElFZGFhZ016?=
 =?utf-8?B?cG45V0xiQ2k1OGVLWGxUcDFSbWM5emZzbitjQUphWitUTjJCb2pSVG5JUlRu?=
 =?utf-8?B?cXllOS9MWlFvNE5HZ2xwQnJqTDh3OE9jU1pkZC9wOUwzTmlSMmtHcml0VXhr?=
 =?utf-8?B?QXRvemFpYkFuSzNQRXh5NGRIZ3BaL0V4amg5QWMvTDdUK3A4WFdTdFJsMmFj?=
 =?utf-8?B?VUgrT3cvNU9qNS9ZdThQYjhiWGY0eHI1bXFRU0NDR2gzUHV3bjhHRzBvbkFU?=
 =?utf-8?B?TlZrYURuSVdVOHZ1d1JjL1NVL1J5bXN5STBtMlBDOW0zOGRVeFN4Q2F2ajNU?=
 =?utf-8?B?Vk43cWJTVmt4RHFmYTkrZXBGNmdMSTNqTUhmcjFteU12K2pocFd4cEVTZ2VH?=
 =?utf-8?B?MW0yR1ZaRFQ2NDUwY1hoOXIxbUVsRG16VHZXeHo5ckhOekZsYWpYaGVxdVY0?=
 =?utf-8?B?eXVZM0NvaStvbFBkNGl4T3lhTUFmak02R3NPTHJ1akQ1UDRxWTRoOThzR0xU?=
 =?utf-8?B?Sm5ZRlVyUHpRbk9FVWp3VVEzYUJqL2dSQnNqKzV2ZnlCMGZwQlQxbkFkSGRh?=
 =?utf-8?B?Qkk3RC9peFEvejgySlBpTmM2elpHbG5ZWjR0NmllNklHa3ZlbXlCNlgvM0NB?=
 =?utf-8?B?UzJHR1A4K0JyQWh1M0VKaThpZk1Tb3h0MDhhZnJUMUJ4NGVGVTI2N1hHM1dx?=
 =?utf-8?B?YmJDeUNid28zSmFnSWN6dGg5UU5ZekNqbFdUQUJMN1JNTnA5RTk1eER1Y3VQ?=
 =?utf-8?B?bmpGdkY1VnRpUHg1K2xVc1NqNGg5MGdoR2VLS0xLRzZMR3htazhTWmpOUkor?=
 =?utf-8?B?YjM0L1BLRzhJV3pCQjVCejVqWmJmZjVKUlh3QVRrd0RmRExGUHJYd2hZT3FE?=
 =?utf-8?B?am5aVDVPQjdlb2hrbVp0MkpEWFMydVRmZG4xcFpwMTJ0cEllTTM0OXk0ZGFM?=
 =?utf-8?B?M0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28C9382A871F314D9A12963FEBEFFF98@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f971d88a-eead-4268-d824-08dbf5cdf5d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2023 20:08:34.4489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z9hCHKO4aMbWpltxQqhLx43hEdGu40Ph5V7I2h6AZpRZ4l8JWbP9kL4ss9wuHADpqMzJkDbejSA1hSl2arH92w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8226
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTEyLTA1IGF0IDIwOjU2ICswMTAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIFR1ZSwgRGVjIDA1LCAyMDIzIGF0IDA3OjQxOjQxUE0gKzAwMDAsIEh1YW5nLCBLYWkg
d3JvdGU6DQo+ID4gLXN0YXRpYyBjb25zdCBjaGFyICptY2VfbWVtb3J5X2luZm8oc3RydWN0IG1j
ZSAqbSkNCj4gPiArc3RhdGljIGNvbnN0IGNoYXIgKm1jZV9kdW1wX2F1eF9pbmZvKHN0cnVjdCBt
Y2UgKm0pDQo+ID4gIHsNCj4gPiAtICAgICAgIGlmICghbSB8fCAhbWNlX2lzX21lbW9yeV9lcnJv
cihtKSB8fCAhbWNlX3VzYWJsZV9hZGRyZXNzKG0pKQ0KPiA+IC0gICAgICAgICAgICAgICByZXR1
cm4gTlVMTDsNCj4gPiAtDQo+ID4gICAgICAgICAvKg0KPiA+IC0gICAgICAgICogQ2VydGFpbiBp
bml0aWFsIGdlbmVyYXRpb25zIG9mIFREWC1jYXBhYmxlIENQVXMgaGF2ZSBhbg0KPiA+IC0gICAg
ICAgICogZXJyYXR1bS4gIEEga2VybmVsIG5vbi10ZW1wb3JhbCBwYXJ0aWFsIHdyaXRlIHRvIFRE
WCBwcml2YXRlDQo+ID4gLSAgICAgICAgKiBtZW1vcnkgcG9pc29ucyB0aGF0IG1lbW9yeSwgYW5k
IGEgc3Vic2VxdWVudCByZWFkIG9mIHRoYXQNCj4gPiAtICAgICAgICAqIG1lbW9yeSB0cmlnZ2Vy
cyAjTUMuDQo+ID4gLSAgICAgICAgKg0KPiA+IC0gICAgICAgICogSG93ZXZlciBzdWNoICNNQyBj
YXVzZWQgYnkgc29mdHdhcmUgY2Fubm90IGJlIGRpc3Rpbmd1aXNoZWQNCj4gPiAtICAgICAgICAq
IGZyb20gdGhlIHJlYWwgaGFyZHdhcmUgI01DLiAgSnVzdCBwcmludCBhZGRpdGlvbmFsIG1lc3Nh
Z2UNCj4gPiAtICAgICAgICAqIHRvIHNob3cgc3VjaCAjTUMgbWF5IGJlIHJlc3VsdCBvZiB0aGUg
Q1BVIGVycmF0dW0uDQo+ID4gKyAgICAgICAgKiBDb25maWRlbnRpYWwgY29tcHV0aW5nIHBsYXRm
b3JtcyBzdWNoIGFzIFREWCBwbGF0Zm9ybXMNCj4gPiArICAgICAgICAqIG1heSBvY2N1ciBNQ0Ug
ZHVlIHRvIGluY29ycmVjdCBhY2Nlc3MgdG8gY29uZmlkZW50aWFsDQo+ID4gKyAgICAgICAgKiBt
ZW1vcnkuICBQcmludCBhZGRpdGlvbmFsIGluZm9ybWF0aW9uIGZvciBzdWNoIGVycm9yLg0KPiA+
ICAgICAgICAgICovDQo+ID4gLSAgICAgICBpZiAoIWJvb3RfY3B1X2hhc19idWcoWDg2X0JVR19U
RFhfUFdfTUNFKSkNCj4gPiArICAgICAgIGlmICghbSB8fCAhbWNlX2lzX21lbW9yeV9lcnJvciht
KSB8fCAhbWNlX3VzYWJsZV9hZGRyZXNzKG0pKQ0KPiA+ICAgICAgICAgICAgICAgICByZXR1cm4g
TlVMTDsNCj4gDQo+IFdoYXQncyB0aGUgcG9pbnQgb2YgZG9pbmcgdGhpcyBvbiAhVERYPyBOb25l
Lg0KDQpPSy4gSSdsbCBtb3ZlIHRoaXMgaW5zaWRlIHRkeF9nZXRfbWNlX2luZm8oKS4gDQoNCj4g
DQo+ID4gLSAgICAgICByZXR1cm4gIXRkeF9pc19wcml2YXRlX21lbShtLT5hZGRyKSA/IE5VTEwg
Og0KPiA+IC0gICAgICAgICAgICAgICAiVERYIHByaXZhdGUgbWVtb3J5IGVycm9yLiBQb3NzaWJs
ZSBrZXJuZWwgYnVnLiI7DQo+ID4gKyAgICAgICBpZiAocGxhdGZvcm1fdGR4X2VuYWJsZWQoKSkN
Cj4gDQo+IFNvIGlzIHRoaXMgdGhlICJob3N0IGlzIFREWCIgY2hlY2s/DQo+IA0KPiBOb3QgYSBY
ODZfRkVBVFVSRSBmbGFnIGJ1dCBzb21ldGhpbmcgaG9tZWdyb3duLiBBbmQgS2lyaWxsIGlzIHRy
eWluZyB0bw0KPiBzd2l0Y2ggdGhlIENDX0FUVFJzIHRvIFg4Nl9GRUFUVVJFXyBmbGFncyBmb3Ig
U0VWIGJ1dCBoZXJlIHlvdSBndXlzIGFyZQ0KPiB1c2luZyBzb21ldGhpbmcgaG9tZWdyb3duLg0K
PiANCj4gd2h5IG5vdCBhIFg4Nl9GRUFUVVJFXyBmbGFnPw0KPiANCg0KVGhlIGRpZmZlcmVuY2Ug
aXMgZm9yIFREWCBob3N0IHRoZSBrZXJuZWwgbmVlZHMgdG8gaW5pdGlhbGl6ZSB0aGUgVERYIG1v
ZHVsZQ0KZmlyc3QgYmVmb3JlIFREWCBjYW4gYmUgdXNlZC4gIFRoZSBtb2R1bGUgaW5pdGlhbGl6
YXRpb24gaXMgZG9uZSBhdCBydW50aW1lLCBhbmQNCnRoZSBwbGF0Zm9ybV90ZHhfZW5hYmxlZCgp
IGhlcmUgb25seSByZXR1cm5zIHdoZXRoZXIgdGhlIEJJT1MgaGFzIGVuYWJsZWQgVERYLg0KDQpJ
SVVDIHRoZSBYODZfRkVBVFVSRV8gZmxhZyBkb2Vzbid0IHN1aXQgdGhpcyBwdXJwb3NlIGJlY2F1
c2UgYmFzZWQgb24gbXkNCnVuZGVyc3RhbmRpbmcgdGhlIGZsYWcgYmVpbmcgcHJlc2VudCBtZWFu
cyB0aGUga2VybmVsIGhhcyBkb25lIHNvbWUgZW5hYmxpbmcNCndvcmsgYW5kIHRoZSBmZWF0dXJl
IGlzIHJlYWR5IHRvIHVzZS4NCg0K

