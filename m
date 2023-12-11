Return-Path: <kvm+bounces-4115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6E880DE5F
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 23:38:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA1A8B21643
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 22:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 105F655C05;
	Mon, 11 Dec 2023 22:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mlm7JYfd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189D5AB;
	Mon, 11 Dec 2023 14:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702334313; x=1733870313;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e5D4xGLDZ9ZDKlBP0q5T5QMcQYBxvbVrMRUjyfZuIl8=;
  b=Mlm7JYfdYtRFOC/hMpS2X9O/wfpEwRp15gXD8XK2KJfB3fcS2H9Jz1PB
   Np27itQ1HkCBt8yaWA4k4iWmDrui6WSLGstoTW5y4U5VBF+itgcp0jRFC
   XflKZ6WHqANSWPXMKUztOlb7IsujbXFSlibq3nte0kadMevhCqudNIaW9
   H6mFXI9uQJ+lCCGjck8HWAma1Su32X8VOuBJAfVCvuOwVTDkXmbmJvktZ
   R/aPkByHOvv9R8CTnQdIhazw+6Ao33ipf9fXsXnQuPnbVUegINldd3bf1
   tL+sXZHwteAuRnJRnl9eiHSjyWQRWJzpEfuWY9F8a56VjcuO7ETbh4jtS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="8082463"
X-IronPort-AV: E=Sophos;i="6.04,268,1695711600"; 
   d="scan'208";a="8082463"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 14:38:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="839214938"
X-IronPort-AV: E=Sophos;i="6.04,268,1695711600"; 
   d="scan'208";a="839214938"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Dec 2023 14:38:32 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Dec 2023 14:38:31 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 11 Dec 2023 14:38:31 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 11 Dec 2023 14:38:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQfVbplmZcwJFrBFwonvc5VI+TabdmF1Z4q3fCMZChePYVjxlhyoUrKjwpJHdO4LH+RRp3KG6uKqBOMH8t8PpDBQGdnEwrd8miaBBabQfVDaz5yz/8amefb7UkYM1S0+oJL+ZJDo3gkoOF6q2an5tATjGz0zj9nHFHbEln7aKczjqE4Gnevv76g1/yB+YKSBppmvsuRF4uUXeY15OLmY202hWY7DGJiROiaYR+cmVyDm/HqL98xyt8nIiP7C52ThVtS4G0YaJlqzil5iouw+oempratdsUrhCIlrp2x3xgb55dyJXIoQPo+rNIt9kegOITmkkfXHZGpDaepcq+O7Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5D4xGLDZ9ZDKlBP0q5T5QMcQYBxvbVrMRUjyfZuIl8=;
 b=ApFu1dmxwjERKytKKfDveNn5TjeOrpUu3gxKvsB3/f7PgdYdk3Nyro52rf+x65ppnkbWKS68vQq0F0Cc6ED0MTGYRCRuD8oAI3kA4iMJfGW8B6+SQD6YAjfq1QzlnnVxpHBfVNTEtSA1zyZEvMm18Akuj1Mty9ISc/1w9/oVT3r5ax+5z6LysbT1SldNtM9vGAQwKFr5YJqFfEhGyS8+LuCZx2E/QHOhSOlpWMZePwYhlVcLiKO1oTGQov4GQeP7j9TE+hIebRrFk8/U8kHM/CN5+YtogknkmF/vz57D6nqqAzyHQ6ny84hxrgbMpunYV0+3aW7J2LjDFfSj0fmlVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB8265.namprd11.prod.outlook.com (2603:10b6:303:1e1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.33; Mon, 11 Dec
 2023 22:38:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7068.031; Mon, 11 Dec 2023
 22:38:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "zhi.wang.linux@gmail.com"
	<zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v17 016/116] x86/virt/tdx: Add a helper function to return
 system wide info about TDX module
Thread-Topic: [PATCH v17 016/116] x86/virt/tdx: Add a helper function to
 return system wide info about TDX module
Thread-Index: AQHaEYrTMU6+/ir35UKt+qCnOBQCCLCk4mAA
Date: Mon, 11 Dec 2023 22:38:20 +0000
Message-ID: <21c7fda2f6f9a320cb7cb0ae8c42ca4ab47adc70.camel@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
	 <9069af111a000d8e67d94ffbda8ea82756cc9d36.1699368322.git.isaku.yamahata@intel.com>
In-Reply-To: <9069af111a000d8e67d94ffbda8ea82756cc9d36.1699368322.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB8265:EE_
x-ms-office365-filtering-correlation-id: cde3d0cc-19f3-4ad0-d80b-08dbfa99e0a3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6D44rYtWkxDnwJPNY3TjYd1yeUIsLm/miY1k6JJrQdKeQpwrBNoDwm2oNnUcqjQBLKU7WVLok5qY8WziQ7Dssoiu5X1SzOGkiHVDc+57ntZRFCsWZV/Ez+8er+oebWNBlM71zI5tLrDXNKkjYx7y/6/RFjUF8Yx/FzXRgGpETJ4yunu5b/f0PLBt5UUWCbOFTGnoeUYR0rGHtbEQrhfRBPn9YjVcUaZK3ZIbawkOnwImoZkfESrcU6E7OwuCpg0j2dJuxDAUniVkrjk7APGgwnaJwBAeKCrOGBJRwVdFxTgUwp6c6Ogkc4Ul8m7U4MzbjDCzZm8aoGZUF63qyic2hrIFerEBmCDMKdkOzKKesJsCqKkl95XmuLNZ2qxO+sjzkyTMNqs/du1/T0MYD+jrROSN4njIaIE52zqAgtXyAPf8eO0GoP4gUhDpQFixURJAi88AbNLPhkHVbCpXjREH24jV0MiMDYTLisL2ZYJWHYeAEVU2qUpQWxaYVGxaAwfTkoe1uglNsnnKMw5ejl6hCZgR9ct68Z3N89sTjPa7qZqD4UQqcA9Or1tzyUYqdlfKe4phsZ91VTN67NAWOA7XBLUXqZzUqu6TMmV24e8/dTa89fEkChpcJdO6oknpN9dv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(83380400001)(2906002)(41300700001)(86362001)(478600001)(82960400001)(38070700009)(76116006)(91956017)(66556008)(66476007)(66446008)(6636002)(54906003)(66946007)(6486002)(64756008)(110136005)(122000001)(71200400001)(316002)(38100700002)(8676002)(4326008)(8936002)(6506007)(6512007)(36756003)(5660300002)(26005)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHlacDRudkkvWE1xM2lCYmxaRDBkOVVPbGtpajJtVU1VVEZFYXcvSVdtRmxi?=
 =?utf-8?B?SzBrQjNPSGxhU0VFL2NvZWZwQXVEVHBoOEorQ25BQ0NtUy9jUFN0SjVvNDFL?=
 =?utf-8?B?WjRkWDRRVUtUVVZqS3d0L1RUeUlBUkUxREx4Z2g3RlZSVlRwdXo1c0xKRHBw?=
 =?utf-8?B?NFc3RlREcXV1bzFvWkc4bnVTRkhiei9EUlA1RktCUDRZc1JmcGhOSlJKUExq?=
 =?utf-8?B?Wi9LU2RPajFWQ2ZpTmxzTzVnQnRubzV2Nkt2cVRORjZNOTlONVp6MG9pclJQ?=
 =?utf-8?B?a1V3T2Qzam5zb0cxU0FURVhSandiNlNUeVBOeTdqK3NTZEFQNVQrd3ZvaEhW?=
 =?utf-8?B?dmRZdnBFelVLWDdVN2F4R01NS0gzeW1JZ1NWT2J5UnkwSlREdEl2bnkzYUxa?=
 =?utf-8?B?RnNaT0xzckQ4TmNLZElqV1FGUEQzSGRwSE8wQ0R3eERrcEo3dFlScTkxWEJu?=
 =?utf-8?B?a1BIcFcrOXZOM2lZdysxV3BEOXR0VFZscEtROW5qbGlDSThGZjFGSFBZUnpJ?=
 =?utf-8?B?RVp4RmFqT0tJN2NiU3Y3SG5DMmY1MlkvZGdVVUFhd1FndXl5bGpmenphYTl2?=
 =?utf-8?B?eTloeklIeVhTS1B6TUlOZzBodEpKQnZZVExrZFBJUjB1WldmL05CejAvM2ZY?=
 =?utf-8?B?cVlCQVUzY1N6a3lvd2tnZmJ1MjBTR3Z6a0d6YWhYamVUN0NSVWRNYlZFTWJx?=
 =?utf-8?B?RkdONHhQSWZTdjcxOGJlOEdnZGtXRXZEbTRQODN6cHBHRUZ5ckMyL2lTZ2t6?=
 =?utf-8?B?VTk3Y3J2a25JR1NDeEJjNGcvU3M1Q3NCWkpUWTVjak9tNTdINm9meC85K1l2?=
 =?utf-8?B?S1MvNk9WTHFyT0I1MXVlVXpvWHNxRFpTN3JDTjhBNC93L3MvcnRXUDJjc2dD?=
 =?utf-8?B?TmxiOE95OEVWMTBKZDB2a3FWeEF0ODFqeUJjejJIQXpzcWJ6V2N3aGo4YnRq?=
 =?utf-8?B?MWhTdjVDckVWOWEzcHVnOEZ4RUozVmh5emg0djJqVjFXdlZYWXFBQlhxczlK?=
 =?utf-8?B?aThtTnVBNmF1ZTJjOWtSVW91UlE2RUZ1UEJBMEZ5aHdwaXpuSDU1NkZGa3h0?=
 =?utf-8?B?Z3ZPOVEvYU0zalRJNGhsOG9PK0FIZGhadGF0SmlCMlAwWVNTdHh5a3EyOEVT?=
 =?utf-8?B?RDAwY1RMN21raElwWVpSSFZXa1N3b2FBRE5aYWZUNUY4S1diNnVicVJWejls?=
 =?utf-8?B?RS9TRno5bklySjZMTzBFU0l3UWZEemZTS1FoSFhEdUxxM2Q2N1Q4eGNqcFk4?=
 =?utf-8?B?cVlSemQ4a2VFOHE1cWs0aVdLSXllRzlaclJoV0hPMFFkem1nSEUrZVBGdVNr?=
 =?utf-8?B?Zk1QbFJpVTFyZTFzTVAzUU1YSktLTC9vZmh2bXh5MzBnNEZzVDBiVVZSMFpW?=
 =?utf-8?B?cWxLYjFwQ1VVSWJwTW5jN3pyQ2wvWkYwSVJvYjdSWE51d2NZYTJySTRqcjBC?=
 =?utf-8?B?MW1oRnVVb093alFqRjJCaENTMlBoTDYvaGYvNXF1TlNPOHFGWnA1ZWpGQ2pR?=
 =?utf-8?B?UkNyU09WMWk2Y3hoY3JSRjI0a1Iyc0xwYnhwMHlNQ05rNlQ5dWc2Y2I4ZXFx?=
 =?utf-8?B?dDlWWSs2QUJ5MmNtUTlvRmUrWER0bHEwMGRMdXBTc1F3NTAzK2YwdXZXMkl2?=
 =?utf-8?B?R24vUjBoVjd0MCtWTXcvZVBGWDErYWw5Mk54Q2hGOVhxd0pXV2xVR0lHeXRp?=
 =?utf-8?B?VFBXdlhWMjl3Mys4bVJyVGFyTTQwcUUzKzB3RmJUTjM4Z2RZR0xzcXNMdzBh?=
 =?utf-8?B?aU5xV0k4ZDIzS2hZTDNJSE9OWjFrNldKeHFWS0FHRDhpeWZ4SktvMkNYMWJn?=
 =?utf-8?B?V3lJNFNtb2xTcE5yUnpWSDA0RXZZVEc2dnRBeUVZZFZiKzFvdm1PaGlrdm9T?=
 =?utf-8?B?TlJCeis1Qk1ZLzBzMUtCY2lqU3Z0S01lN2dTTTdKYVBDeTZtNGxkZzdoSHFX?=
 =?utf-8?B?NGNtNGNUajNVenZEVmxTUVB6WTZ6WUpwaW5vQkRaZHAyVUZLMWt3aXB4Y1ZM?=
 =?utf-8?B?cmo3U0xyOE5lQWF4S2oyTjNLY2Q4UUl0VVk0bk9RKzFkNzlLWW50ZXczMUlx?=
 =?utf-8?B?T2pyekp0U1JNOEcxekNTOFZEV3FPT04wekNpSnU5SVFSeVNtR0pEajIyV2dv?=
 =?utf-8?B?M09lVEVyVUFWYWp0UVdhNjFJWDJwemc1VlI5dGNGYWRKZDQrenhlY1kwUytV?=
 =?utf-8?B?TFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED3B23120EF9554B94866C5B868FBF5E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde3d0cc-19f3-4ad0-d80b-08dbfa99e0a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2023 22:38:20.8700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KPCU+rBXBDwELJst3zjH84UgqWFGUteJ0SOHBAl+mEaSJMoVUezUxyXfaIXMLFM52ophwBIZ18pj2X3+CHdwVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB8265
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTExLTA3IGF0IDA2OjU1IC0wODAwLCBZYW1haGF0YSwgSXNha3Ugd3JvdGU6
DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IA0K
PiBURFggS1ZNIG5lZWRzIHN5c3RlbS13aWRlIGluZm9ybWF0aW9uIGFib3V0IHRoZSBURFggbW9k
dWxlLCBzdHJ1Y3QNCj4gdGRzeXNpbmZvX3N0cnVjdC4gIEFkZCBhIGhlbHBlciBmdW5jdGlvbiB0
ZHhfZ2V0X3N5c2luZm8oKSB0byByZXR1cm4gaXQNCj4gaW5zdGVhZCBvZiBLVk0gZ2V0dGluZyBp
dCB3aXRoIHZhcmlvdXMgZXJyb3IgY2hlY2tzLiAgTWFrZSBLVk0gY2FsbCB0aGUNCj4gZnVuY3Rp
b24gYW5kIHN0YXNoIHRoZSBpbmZvLiAgTW92ZSBvdXQgdGhlIHN0cnVjdCBkZWZpbml0aW9uIGFi
b3V0IGl0IHRvDQo+IGNvbW1vbiBwbGFjZSBhcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggIHwgNTkgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgYXJjaC94ODYva3ZtL3ZteC90ZHguYyAg
ICAgIHwgMTUgKysrKysrKysrLQ0KPiAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIHwgMjAg
KysrKysrKysrKystLQ0KPiAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oIHwgNTEgLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIDQgZmlsZXMgY2hhbmdlZCwgOTEgaW5zZXJ0
aW9ucygrKSwgNTQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5j
bHVkZS9hc20vdGR4LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiBpbmRleCAzYjY0
OGYyOTBhZjMuLjI3NmJkYWU0NzczOCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9h
c20vdGR4LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gQEAgLTEwOSw2
ICsxMDksNjIgQEAgc3RhdGljIGlubGluZSB1NjQgc2NfcmV0cnkoc2NfZnVuY190IGZ1bmMsIHU2
NCBmbiwNCj4gICNkZWZpbmUgc2VhbWNhbGxfcmV0KF9mbiwgX2FyZ3MpCXNjX3JldHJ5KF9fc2Vh
bWNhbGxfcmV0LCAoX2ZuKSwgKF9hcmdzKSkNCj4gICNkZWZpbmUgc2VhbWNhbGxfc2F2ZWRfcmV0
KF9mbiwgX2FyZ3MpCXNjX3JldHJ5KF9fc2VhbWNhbGxfc2F2ZWRfcmV0LCAoX2ZuKSwgKF9hcmdz
KSkNCj4gIA0KPiArc3RydWN0IHRkeF9jcHVpZF9jb25maWcgew0KPiArCV9fc3RydWN0X2dyb3Vw
KHRkeF9jcHVpZF9jb25maWdfbGVhZiwgbGVhZl9zdWJfbGVhZiwgX19wYWNrZWQsDQo+ICsJCXUz
MiBsZWFmOw0KPiArCQl1MzIgc3ViX2xlYWY7DQo+ICsJKTsNCj4gKwlfX3N0cnVjdF9ncm91cCh0
ZHhfY3B1aWRfY29uZmlnX3ZhbHVlLCB2YWx1ZSwgX19wYWNrZWQsDQo+ICsJCXUzMiBlYXg7DQo+
ICsJCXUzMiBlYng7DQo+ICsJCXUzMiBlY3g7DQo+ICsJCXUzMiBlZHg7DQo+ICsJKTsNCj4gK30g
X19wYWNrZWQ7DQo+ICsNCj4gKyNkZWZpbmUgVERTWVNJTkZPX1NUUlVDVF9TSVpFCQkxMDI0DQo+
ICsjZGVmaW5lIFREU1lTSU5GT19TVFJVQ1RfQUxJR05NRU5UCTEwMjQNCj4gKw0KPiArLyoNCj4g
KyAqIFRoZSBzaXplIG9mIHRoaXMgc3RydWN0dXJlIGl0c2VsZiBpcyBmbGV4aWJsZS4gIFRoZSBh
Y3R1YWwgc3RydWN0dXJlDQo+ICsgKiBwYXNzZWQgdG8gVERILlNZUy5JTkZPIG11c3QgYmUgcGFk
ZGVkIHRvIFREU1lTSU5GT19TVFJVQ1RfU0laRSBieXRlcw0KPiArICogYW5kIFREU1lTSU5GT19T
VFJVQ1RfQUxJR05NRU5UIGJ5dGVzIGFsaWduZWQuDQo+ICsgKi8NCj4gK3N0cnVjdCB0ZHN5c2lu
Zm9fc3RydWN0IHsNCj4gKwkvKiBURFgtU0VBTSBNb2R1bGUgSW5mbyAqLw0KPiArCXUzMglhdHRy
aWJ1dGVzOw0KPiArCXUzMgl2ZW5kb3JfaWQ7DQo+ICsJdTMyCWJ1aWxkX2RhdGU7DQo+ICsJdTE2
CWJ1aWxkX251bTsNCj4gKwl1MTYJbWlub3JfdmVyc2lvbjsNCj4gKwl1MTYJbWFqb3JfdmVyc2lv
bjsNCj4gKwl1OAlyZXNlcnZlZDBbMTRdOw0KPiArCS8qIE1lbW9yeSBJbmZvICovDQo+ICsJdTE2
CW1heF90ZG1yczsNCj4gKwl1MTYJbWF4X3Jlc2VydmVkX3Blcl90ZG1yOw0KPiArCXUxNglwYW10
X2VudHJ5X3NpemU7DQo+ICsJdTgJcmVzZXJ2ZWQxWzEwXTsNCj4gKwkvKiBDb250cm9sIFN0cnVj
dCBJbmZvICovDQo+ICsJdTE2CXRkY3NfYmFzZV9zaXplOw0KPiArCXU4CXJlc2VydmVkMlsyXTsN
Cj4gKwl1MTYJdGR2cHNfYmFzZV9zaXplOw0KPiArCXU4CXRkdnBzX3hmYW1fZGVwZW5kZW50X3Np
emU7DQo+ICsJdTgJcmVzZXJ2ZWQzWzldOw0KPiArCS8qIFREIENhcGFiaWxpdGllcyAqLw0KPiAr
CXU2NAlhdHRyaWJ1dGVzX2ZpeGVkMDsNCj4gKwl1NjQJYXR0cmlidXRlc19maXhlZDE7DQo+ICsJ
dTY0CXhmYW1fZml4ZWQwOw0KPiArCXU2NAl4ZmFtX2ZpeGVkMTsNCj4gKwl1OAlyZXNlcnZlZDRb
MzJdOw0KPiArCXUzMgludW1fY3B1aWRfY29uZmlnOw0KPiArCS8qDQo+ICsJICogVGhlIGFjdHVh
bCBudW1iZXIgb2YgQ1BVSURfQ09ORklHIGRlcGVuZHMgb24gYWJvdmUNCj4gKwkgKiAnbnVtX2Nw
dWlkX2NvbmZpZycuDQo+ICsJICovDQo+ICsJREVDTEFSRV9GTEVYX0FSUkFZKHN0cnVjdCB0ZHhf
Y3B1aWRfY29uZmlnLCBjcHVpZF9jb25maWdzKTsNCj4gK30gX19wYWNrZWQ7DQo+ICsNCj4gK2Nv
bnN0IHN0cnVjdCB0ZHN5c2luZm9fc3RydWN0ICp0ZHhfZ2V0X3N5c2luZm8odm9pZCk7DQo+IA0K
DQpXaXRoIHRoZSBsYXN0ZXN0IFREWCBob3N0IGNvZGUgSSBkb24ndCB0aGluayB3ZSBuZWVkIFRE
U1lTSU5GT19TVFJVQ1QgYW55bW9yZS4NCg0KSSB0aGluayBpdCBtYWtlcyBtb3JlIHNlbnNlIHRv
IG1vZGlmeSB0aGUgVERYIGhvc3QgY29kZSB0byBleHBvc2UgYW4NCmluZnJhc3RydWN0dXJlIHRv
IHJlYWQgVERYIG1vZHVsZSBnbG9iYWwgbWV0YWRhdGEgYW5kIEtWTSBjYW4ganVzdCB1c2UgdGhh
dCB0bw0KZ2V0IHdoYXQgaXQgd2FudHMgdG8gY3JlYXRlL3J1biBURFggZ3Vlc3RzLg0KDQpJIGFt
IHdvcmtpbmcgb24gdGhlc2UgcGF0Y2hlcyBhbmQgSSdsbCB1cGRhdGUgdG8geW91IHdoZW4gZG9u
ZSAoc2hvdWxkIGJlIHNvb24pLg0K

