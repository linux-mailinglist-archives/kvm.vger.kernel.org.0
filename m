Return-Path: <kvm+bounces-5697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F753824C2D
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 01:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B387F1F231AB
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 00:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A8771FBF;
	Fri,  5 Jan 2024 00:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tfl0AxnO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D74E185B;
	Fri,  5 Jan 2024 00:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704414857; x=1735950857;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=d2e+FjPlJTZmqAQwq3ZFx5xxkyqWUzDKHfHeNwzCH0M=;
  b=Tfl0AxnO7Kc2RPrgppQqSqgFpITBfqXrE3585EQypSTi3RqRrVR0Gmyk
   H96JNfjqgxV54rq0/z6A1Z+Ex2m7u/htxjcJnMH4cwTuYPT5i5ntN5XnF
   RAS014n8UmXOC6S2KvoaE5e/DjyoiZJO4413YgG/UG5pfiV6RXFXmG/Vb
   xMmzXcY+OTO6DQzoYlA30Qx8ucZyUoLEaqFJZKlUGPfkH177K55Uz9/FS
   S/+dwL5glNv0DsS1QL5xL1EtPcplaaMfqgeDxGLindk5iFsRCdmjr2pS/
   n/7mkCKxbzY9VEODtS0UPJhgqsH7a1RImv8gFZLKK9D64GH73u0OCxRfE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="382376442"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="382376442"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 16:34:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="903995981"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="903995981"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jan 2024 16:34:16 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 16:34:16 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 4 Jan 2024 16:34:16 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 4 Jan 2024 16:34:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZyLdtvYF17dxkIyqxu57pR9DmXqR3jcCk6rVj5AyYFQwfHVy2HsrgWrWqH3GHAxzId2KvHu51JKy57YcqcECRAZtTX1twQoQ26VDnGv//6jHELIIdcJQH8HUJt3ZEfBk21jsG8hlT/u2CGocDWXOCp9ziVsugvkwbrAoGp7RaDPm0T11Ju0xKcTcJGPTx4C4/uvtWwjvT3DoJmQ44pbI1j5AbhQ9OrAKVedUYe1Wmz+0BJP8broJwaCdzuQYf1Z0QN8G/JUd2Cg35ypSpL3tv8i6lG01i2hkifAu+pAyji1fPU/tdbMSS3suhDyP9DH1P7SMA5CiS+20zfKqsKcf/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d2e+FjPlJTZmqAQwq3ZFx5xxkyqWUzDKHfHeNwzCH0M=;
 b=LDDmDlHzjrEKu2WUr1VaO6uEu0BbbQR2YvjagWfzO8Qjg5tTLFfgLKhpQF1xiWEwbHQWavOk6lo5C1d3wk3pQczAZ7fbjDy2WFUu7YeRo4DytRIS6zetEntJcEBiKELh+kDZZlkW/Ln3dlGaTrXNEr6E7nHaLi42WrtD0Fk/7skMO8aod3CF029AR7KGdhJqErWPrEoM+W5lScaODXbxuUAwgajeTi0At4KunwWSQ5W3+2KPuf2jMAwU/qY3Xvg8KsvkUZWD1yUZr66U9jPrheL3mtPN4Hrc7C3rVLyDV9SIYchnuRAQy3aQSY3O/dcIxdOAuoThwPf29zvMWk5ArQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA3PR11MB7525.namprd11.prod.outlook.com (2603:10b6:806:31a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.14; Fri, 5 Jan
 2024 00:34:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7135.028; Fri, 5 Jan 2024
 00:34:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "john.allen@amd.com"
	<john.allen@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
Thread-Topic: [PATCH v8 00/26] Enable CET Virtualization
Thread-Index: AQHaM+ybd3H3II6aZU6KWHt3rvxkNLDIg7MAgADO/oCAAOpTAIAANboAgAADMYA=
Date: Fri, 5 Jan 2024 00:34:08 +0000
Message-ID: <a2344e2143ef2b9eca0d153c86091e58e596709d.camel@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
	 <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com>
	 <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
	 <ZZdLG5W5u19PsnTo@google.com>
In-Reply-To: <ZZdLG5W5u19PsnTo@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA3PR11MB7525:EE_
x-ms-office365-filtering-correlation-id: 1c83e27b-e8df-4fe3-8b47-08dc0d86078d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Vxf32yhG7NnE2DX+r33pZirda2PE6ptM5SQWJlkD/kia24PizWXa5cg6zTTrlurehl0uCNkijbyNB7D2oAbV6DWiVM3XqzojsPGfjfihdskweecsd/+6VKuPh/RhwsSgGLhRlQM6HtwJ+UjNoTXbc/svkBmyuyxRva20+1BMhe8mqQnXVzW073b3E4OQFKnkHwnJXFDicJSgFArb5KUK7iVmN0EEJcRgKmkB0IuHoB7KR4wikebjxuXz4m8R9+J6XLw/nLWt8meQKZl5EpYdQ3XYvZjm+Pzp+6egDSY3Y3tgHjlbYw2KxRCU4fby3pcg9kDEtss/EU8hM3uxqd5l/5zDiLSn5SAxLk5BOr/s01CpCiB8QAg5RHqmOCv2nWrS/8uYxoa0m8hOV84sqzHpHc9oYoKpMYp57hZj1jh4p/O4LOg2huZnTGd5fUzdDRg/1q/i17Hg+6MijmCQNkKZhi7tlF1YnKw0iPDsvEUKcGmr9TazYKX/kDYX4kI8Ud0UKrwOC41udw241JgJStK8IcE9IW8PGOj09HLqpa0xM5Ez7SkYoEz37zuhkEMz7LpC76woWqljWhJAnVzA/+SyRWFjF6+EA3WhqkSZeClIvOqvJ/U0CmtGMCVnHJmfcjN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(136003)(396003)(376002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(66446008)(66556008)(76116006)(66476007)(6916009)(66946007)(91956017)(71200400001)(26005)(2616005)(36756003)(6512007)(38070700009)(122000001)(86362001)(38100700002)(82960400001)(83380400001)(6486002)(41300700001)(6506007)(478600001)(64756008)(4326008)(5660300002)(316002)(54906003)(2906002)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkdkamVtc1plYVY4U2F3ZXdNZWNRd1F1bjVuVEJsV1RBclVONGxvRWhFOXJl?=
 =?utf-8?B?bERSbzdNNHQ3UGs5aUNtL0IyRXlXL3V4Nko3WWYxQWxReXJpaEw0amRIN01p?=
 =?utf-8?B?N2FrUFhRbk4yUzN4QXZEcU16VVJUa1RvbWtqY2JrV1NiYm9ZOXZOd3puTTNr?=
 =?utf-8?B?aUhjbDd6WUdBYXpnM292cW9mako4OVo1Q2tzRHJwQnZkeTNOQ2ZmcGQ0TFNw?=
 =?utf-8?B?NkQ0WHlsVWRBa3l1bWNlZVhPZE1uaG9jSDIwekl5MmZZZzQvZ2x2RHhKbHJv?=
 =?utf-8?B?cC81SnFObmtxYzc1cUZIajFNeDNjR01WRU1sMXNlT29IaW11ZXhxZHplcjRj?=
 =?utf-8?B?K2l6eUcwc0JtMnFnVWVtaUlETHJqMjFyMlgyVDZVZllCbzhVVk1CZ2dLenYx?=
 =?utf-8?B?ejV3TnlCSlVNTVZuSjFzd0svckhGTEFrcnNuRnVsSElqQXJhaFQvamhBVU9G?=
 =?utf-8?B?anhYaElSSTFwOUxDS2JVZGFVMERLZzM4OTRvVmlyaEQwSjlKTGVmQjhEYVNO?=
 =?utf-8?B?QzVXSTlBUStXR1JlYnF6L3Y4MUhLSGFqQ1RKWG1ONVIvTzRTaG9ybWhHQTY0?=
 =?utf-8?B?aXMzb1VkVTU3NGxZY1NULzZGL3ZFdGRBZzNEQldJelc1bVZEUGxKL05WNkRW?=
 =?utf-8?B?dGF4TVhYRVJTZlhvNGQ5ZGdkUE1BM3l6c0pTTlB3TzNOaGVJNVZWSEVlT3Fa?=
 =?utf-8?B?SXRoTnZVemMzV2xIYUcrTStKWm1jWFJld29zUklRTGQybGsrZS9acjJnN3Ay?=
 =?utf-8?B?dldUKzB4MHVESnJISzVHdngzRjNPUGJWd09VQ1ZMelBXcktQQzYzMWExbTNx?=
 =?utf-8?B?VGFmZ1U4Z05odHdLVm9JK3VwN2tVeEo3UUxQaU1VcjhCYU53RXZjY3g1RUhY?=
 =?utf-8?B?bjRINFNBOCtrcjlHVXM1ZzZIR3BubGRtRUNvaUk4SXBJV1FJTDBVb1FFcTl4?=
 =?utf-8?B?Wk9YZWJHakhWVGlTaXo4ZVBCMDBBK013WkJjYTlTTG5CNkg5elc4VlliWmRN?=
 =?utf-8?B?K1ZhdHVkRUt4UWsyTDhXSHhuNWFBMjJpZ3lZUFNlNHMwdUdFSDduMURpZHl5?=
 =?utf-8?B?OSs5aHNQK1ZYcmZmNUEyYThNeHdYV2g0VWNwQ0V1dlBaWldaQVZERGRvcTJ3?=
 =?utf-8?B?NmJseklSWTRKN0xRbzhVRE5hc2hrWG9JY0lkZjNMeDJ0OUtSRktoWHZ6MmhM?=
 =?utf-8?B?VU4rRHpLd25XaDJweTFDZkZKOC9kc0tCM0tLejI4dEVCMVJzKzBTT1RiUGpD?=
 =?utf-8?B?SzZ6UEliUjVNYUZlWDF4aVRtNHJndEZTTFp1YzZnN1ZsZU5lT09YWmR0Q1ds?=
 =?utf-8?B?dzJyT0FoYVFYKzhvTWlUaE5vT1BHTmZvRHJhdWh5QnhoTHBpaVZnWDBhS3pT?=
 =?utf-8?B?OHdqcUF0T2xhdEk5ZUk5MFBkWnM3RVVwZWYwUUl5cGxFeGFwbWxVbXpxY0dB?=
 =?utf-8?B?UVljeDZXbWVLTEVmMExrVENwaW5Za0VuUm82Z0FhVFFqZXB2bkNLbWhQdk8x?=
 =?utf-8?B?V24xWU5zQVFYd1FjTU5UU2VJSkZjZDJOaFVJUWlPaEZNY21JK2pHTkc2T3pW?=
 =?utf-8?B?bU5OemU5SllDWTRaTHdmcFRRajJ3aEdkVXptTGJpKy9Db3RZODFmRXJFNFRh?=
 =?utf-8?B?akJxekZRNVdJZW5DR2xYOWdoeDVQWDU5Z0hCN2s2K3BHdk9Xd1ZJTUI1UHBF?=
 =?utf-8?B?V3ZOSjhJeElvaHpUY0FyOER4K0tPZlVLaTVLNFNMcDF3QzQ0QTlCVmdaREw0?=
 =?utf-8?B?RllaeFozNDd1cmdwQlZrTlptZDRqWFp4cDRHeWRKQ1dsUFRpVnl3NnVJTFNI?=
 =?utf-8?B?NUV2S204OGdYdnR0eDhtWENYMVppNjZ5VGJyUHROSzRNdmJzQU1TeS9Gd3RT?=
 =?utf-8?B?bm0wbldCQXc4N3o2MS9ZajJFZDI5dEdYNVpETzRyc2JzZk9lVEhVZUNSVXp4?=
 =?utf-8?B?bmVvcnZyUGkzMjRqbHVhZnQ2MEhWY1dIb0hyNXcrMFREYXNsdS9sSFVrNktx?=
 =?utf-8?B?UGhGY1JkcHVpZkY0Q2RtbGVqRmdmWkJrcDFXR0JwT3BERUJTWHlsemJKUXdu?=
 =?utf-8?B?azFnTEVhdzVxTXpDczVpR1llRWRubEgxTFF3S0ZhSmJidTZ6RS9ZNzYrY04y?=
 =?utf-8?B?cmd4djdZNHpaSmNRVnNYSU9IekhSMSs0c3IxcTZUT09qRFJBWlVaRkxZYVYr?=
 =?utf-8?B?dHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97F5F28595ED3B47AF6259EAEA5FF9D9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c83e27b-e8df-4fe3-8b47-08dc0d86078d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2024 00:34:08.2831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CrX00Ne3UwdkAsEBVULEsF9lz3/7fr6P1Tgg/C8ncNKDhEXrpryA6epR7AzpuWmxlacLTiygTlFbu5zI2Uk3AqC6XMXkewi59vJ21vWm8P4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7525
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAxLTA0IGF0IDE2OjIyIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBObywgdGhlIGRheXMgb2YgS1ZNIG1ha2luZyBzaGl0IHVwIGZyb20gYXJlIGRvbmUu
wqAgSUlVQywgeW91J3JlDQo+IGFkdm9jYXRpbmcgdGhhdA0KPiBpdCdzIG9rIGZvciBLVk0gdG8g
aW5kdWNlIGEgI0NQIHRoYXQgYXJjaGl0ZWN0dXJhbGx5IHNob3VsZCBub3QNCj4gaGFwcGVuLsKg
IFRoYXQgaXMNCj4gbm90IGFjY2VwdGFibGUsIGZ1bGwgc3RvcC4NCg0KTm9wZSwgbm90IGFkdm9j
YXRpbmcgdGhhdCBhdCBhbGwuIEknbSBub3RpY2luZyB0aGF0IGluIHRoaXMgc2VyaWVzIEtWTQ0K
aGFzIHNwZWNpYWwgZW11bGF0b3IgYmVoYXZpb3IgdGhhdCBkb2Vzbid0IG1hdGNoIHRoZSBIVyB3
aGVuIENFVCBpcw0KZW5hYmxlZC4gVGhhdCBpdCAqc2tpcHMqIGVtaXR0aW5nICNDUHMgKGFuZCBv
dGhlciBDRVQgYmVoYXZpb3JzIFNXDQpkZXBlbmRzIG9uKSwgYW5kIHdvbmRlcmluZyBpZiBpdCBp
cyBhIHByb2JsZW0uDQoNCkknbSB3b3JyaWVkIHRoYXQgdGhlcmUgaXMgc29tZSB3YXkgYXR0YWNr
ZXJzIHdpbGwgaW5kdWNlIHRoZSBob3N0IHRvDQplbXVsYXRlIGFuIGluc3RydWN0aW9uIGFuZCBz
a2lwIENFVCBlbmZvcmNlbWVudCB0aGF0IHRoZSBIVyB3b3VsZA0Kbm9ybWFsbHkgZG8uDQoNCj4g
DQo+IFJldHJ5aW5nIHRoZSBpbnN0cnVjdGlvbiBpbiB0aGUgZ3Vlc3QsIGV4aXRpbmcgdG8gdXNl
cnNwYWNlLCBhbmQgZXZlbg0KPiB0ZXJtaW5hdGluZw0KPiB0aGUgVk0gYXJlIGFsbCBwZXJmZWN0
bHkgYWNjZXB0YWJsZSBiZWhhdmlvcnMgaWYgS1ZNIGVuY291bnRlcnMNCj4gc29tZXRoaW5nIGl0
IGNhbid0DQo+ICpjb3JyZWN0bHkqIGVtdWxhdGUuwqAgQnV0IGNsb2JiZXJpbmcgdGhlIHNoYWRv
dyBzdGFjayBvciBub3QNCj4gZGV0ZWN0aW5nIGEgQ0ZJDQo+IHZpb2xhdGlvbiwgZXZlbiBpZiB0
aGUgZ3Vlc3QgaXMgbWlzYmVoYXZpbmcsIGlzIG5vdCBvay4NCj4gDQpbc25pcF0NCj4gWWVhaCwg
SSBkb24ndCBldmVuIGtub3cgd2hhdCB0aGUgVFJBQ0tFUiBiaXQgZG9lcyAoSSBkb24ndCBmZWVs
IGxpa2UNCj4gcmVhZGluZyB0aGUNCj4gU0RNIHJpZ2h0IG5vdyksIGxldCBhbG9uZSBpZiB3aGF0
IEtWTSBkb2VzIG9yIGRvZXNuJ3QgZG8gaW4gcmVzcG9uc2UNCj4gaXMgcmVtb3RlbHkNCj4gY29y
cmVjdC4NCj4gDQo+IEZvciBDQUxML1JFVCAoYW5kIHByZXN1bWFibHkgYW55IGJyYW5jaCBpbnN0
cnVjdGlvbnMgd2l0aCBJQlQ/KSBvdGhlcg0KPiBpbnN0cnVjdGlvbnMNCj4gdGhhdCBhcmUgZGly
ZWN0bHkgYWZmZWN0ZWQgYnkgQ0VULCB0aGUgc2ltcGxlc3QgdGhpbmcgd291bGQgcHJvYmFibHkN
Cj4gYmUgdG8gZGlzYWJsZQ0KPiB0aG9zZSBpbiBLVk0ncyBlbXVsYXRvciBpZiBzaGFkb3cgc3Rh
Y2tzIGFuZC9vciBJQlQgYXJlIGVuYWJsZWQsIGFuZA0KPiBsZXQgS1ZNJ3MNCj4gZmFpbHVyZSBw
YXRocyB0YWtlIGl0IGZyb20gdGhlcmUuDQoNClJpZ2h0LCB0aGF0IGlzIHdoYXQgSSB3YXMgd29u
ZGVyaW5nIG1pZ2h0IGJlIHRoZSBub3JtYWwgc29sdXRpb24gZm9yDQpzaXR1YXRpb25zIGxpa2Ug
dGhpcy4NCg0KPiANCj4gVGhlbiwgKmlmKiBhIHVzZSBjYXNlIGNvbWVzIGFsb25nIHdoZXJlIHRo
ZSBndWVzdCBpcyB1dGlsaXppbmcgQ0VUDQo+IGFuZCAibmVlZHMiDQo+IEtWTSB0byBlbXVsYXRl
IGFmZmVjdGVkIGluc3RydWN0aW9ucywgd2UgY2FuIGFkZCB0aGUgbmVjZXNzYXJ5DQo+IHN1cHBv
cnQgdGhlIGVtdWxhdG9yLg0KPiANCj4gQWx0ZXJuYXRpdmVseSwgaWYgdGVhY2hpbmcgS1ZNJ3Mg
ZW11bGF0b3IgdG8gcGxheSBuaWNlIHdpdGggc2hhZG93DQo+IHN0YWNrcyBhbmQgSUJUDQo+IGlz
IGVhc3ktaXNoLCBqdXN0IGRvIHRoYXQuDQoNCkkgdGhpbmsgaXQgd2lsbCBub3QgYmUgdmVyeSBl
YXN5Lg0K

