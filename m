Return-Path: <kvm+bounces-3418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 130C98042B7
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 00:41:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36C981C20BAC
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 23:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7262C364C8;
	Mon,  4 Dec 2023 23:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WlLcrTZI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2CCC3;
	Mon,  4 Dec 2023 15:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701733287; x=1733269287;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0BdLPq3nwPfhDxTHB35Ggic9HuSR97k84gb90/10RZU=;
  b=WlLcrTZIMv/piMr6+StCTgnBRYN7GAkeP3yk91EDlUzc27W5C2owefLl
   jOnrvDad3F3ps2aVT/+X493Pf+zNefShTVj0thxY1Yns1IkzwdNSKqAdV
   Nra2ABYaU0P61slk5aEt54kowFQ+F56YpKBLLZG/W2BAxcfi/Y8JSLK8q
   cw2O5+iwgXjXIXG+rNCOqlCVIYWfpNw7GjrDihtmTJoqVgGOjpgXuegrl
   jc7s9inBnjKFocFFU4UwwLH4s2YqVoO52cwS6l3XKx+y4wYqTo5tGKN9c
   oCC+4SbodwHhZcP+9Cv4/N4lOtTz1fT0BvlL3XaFJATtnteLMpTAFSepX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="884226"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="884226"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 15:41:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="720489280"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="720489280"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 15:41:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 15:41:19 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 15:41:19 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 15:41:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YheEQSj3oUXAFTeefcm99+sl8feNn+7SnvvHC48UbaDhZ7sySqjvJBLhN1dIr6oERA+CV+sz1vHyl/BIkiDwElmJ2ZG54EoQD5xSC3E3G/3WqJ1uAoJwWj1O3kIr1FQWmbFdq67BniKWHCFI3qd2fgC7t209/9/1+JP0IQ3yUtKpyzcjSIkXXTA2kVmFy/Fqy4RgjWyhszdIMp8LtVrtVSBpQTfrwq2lcQhS0kaE6ZjtBYL+Nm9e0g8Fae2rruySV2E9pHziPK6Y/A68CtyKyP32MEa63cjl3U6SAW02nBlhwo2HelxcF6BFFZhGFI6pO16EMDyOR1aeK6+ug+FAWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0BdLPq3nwPfhDxTHB35Ggic9HuSR97k84gb90/10RZU=;
 b=OuKnz31avEFJTqN5mKb4ca7uOZkdyMK1la8b4gRZlWawlYQoqgDB+ZBngw7k3mXWg++8+JvVIl2p75ibJYrKGtFL1FPDMEcoKeUxeZAUSiwNZivCch177AlZdGaS+qOO0FqjtPEkdXRgTnaIikLceLaz/6L/0g2NufTIvUVGyPtvNdxO62MsPSjDkS08aXPJPHQNFG96lmfwD7Q2Jq4Q8cqv5WQEsiHnJavAFo4P3CYNVuVqP9Fp9kYTsdwbubf7BhPDCCNXAzH5CRNDW7PVhdp+0ngG+AbXDAGc0yXv9kQxTnLeydVpW4whf2itZ52QL+RdX5cPkc5qCUUJ7AoNLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7246.namprd11.prod.outlook.com (2603:10b6:208:42e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Mon, 4 Dec
 2023 23:41:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 23:41:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Huang, Ying" <ying.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Luck, Tony" <tony.luck@intel.com>, "david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "ak@linux.intel.com"
	<ak@linux.intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>, "sagis@google.com"
	<sagis@google.com>, "imammedo@redhat.com" <imammedo@redhat.com>, "Gao, Chao"
	<chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "rafael@kernel.org"
	<rafael@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Brown, Len"
	<len.brown@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHaEwHtT+sYH5Rms0yY5S8b++o88LCVBfCAgAKQDACAAeyrgIAAQREAgAASGACAABYpgIAABLSA
Date: Mon, 4 Dec 2023 23:41:10 +0000
Message-ID: <71f02b309fa20854fafdfbcc5deb1acf982fceac.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
	 <b3b265f9-48fa-4574-a925-cbdaaa44a689@intel.com>
	 <afc875ace6f9f955557f5c7e811b3046278e4c51.camel@intel.com>
	 <bcff605a-3b8d-4dcc-a5cb-63dab1a74ed4@intel.com>
	 <dfbfe327704f65575219d8b895cf9f55985758da.camel@intel.com>
	 <9b221937-42df-4381-b79f-05fb41155f7a@intel.com>
	 <c12073937fcca2c2e72f9964675ef4ac5dddb6fb.camel@intel.com>
In-Reply-To: <c12073937fcca2c2e72f9964675ef4ac5dddb6fb.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7246:EE_
x-ms-office365-filtering-correlation-id: 98f126f4-44c8-40e2-3505-08dbf5227e83
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D7STgTdhCiRCM9RHjn8uKqp9XONUeioFtleui0ateekzlMF46lGIOma4BR2BQIgM3/bO+jkFSiV3qVtxA1jFldzdeRdF6Tr1p7WVN68/m+5YnfXIgrlpMqLUE7BxUJMDNLsCxud7/RZXkBLxWkJQhK8X07LALfBJEFyNDkm44EPy/yg0juVR/FegMS3IG9oszLfybmNLrtSCTvO0gUJP0kT6y2qYdZEMNcOxM4UGREGRkKL1sVmXHdjqqGE90YEhEjMq97p0HFJ9ONEOPLMXoMlRGbr8vux/JerKNMTvmZS80TrvCjQqg1EAl3xyckzDFTAOCVUqK0CaYF35H7nrOtyb0mSVK4YksD+sSxYXNN7wH3oa9Hol77HLbWVICsg+2yg1mmBAxYbCxzUySUfRnGhR9bDy5bPkRryHs20vyTA363Bix1kLEqtKDSDMGyIvO5y5uWogLxHJBb1QZJ79twUbKZPB6lD1CuuZTP0fXMl5l5PeS4npEBuQqKIBkhmMF2NRhAaN4N3bM5uS3ZovuEHJlWEk7F1prKnMrU3/sp16+cB28E4CcS5ktIgH5d2jAv6N36WMlekUfXFXC7b3IsMiGPA2mSv1eAyO7D5hfUUE5ffBzX1CLLgXlc4QpNCh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(376002)(39860400002)(136003)(366004)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(82960400001)(83380400001)(26005)(2616005)(38100700002)(6506007)(6512007)(122000001)(71200400001)(478600001)(6486002)(66946007)(64756008)(76116006)(66556008)(66446008)(66476007)(54906003)(91956017)(316002)(110136005)(8936002)(8676002)(4326008)(2906002)(38070700009)(41300700001)(36756003)(86362001)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODQ4MEVHSWh1cEJ2ampBeklnQjkxZTF0MUVqbm83MThDZWZMZm9vbU15dG5v?=
 =?utf-8?B?c3h3aWVYbk5rME5rekp3aTY4UUFJcHVuekpNT2pNWU5pWFh3R1hML0hBVitH?=
 =?utf-8?B?Mk5xeWt6RWtRZy8xWG1CTzJYNzYyL01tRExoYkF2SkcyWmJXL0ZFcFVlc0NT?=
 =?utf-8?B?MGs1TSs5bXMzSGhVRWhwV2VpaXcwYklndUU1aGtRbFlueGc4Q1U5WGtadzNs?=
 =?utf-8?B?ZmZ4M3g0TFNPNkNxVzRxclpJQy9HbGJPcVVFVUlSRkNMbHFzNFhabVlieTlx?=
 =?utf-8?B?YzRZUTlYUGVReGRaVFhsVkxqKzdVQ2hUTm1iWlNpTTRQNFVOSXVVZHhZRVJl?=
 =?utf-8?B?ZGVKKzB4YTErQVJiZHJuL3hybFNrSkJNeHBnaVQzTXZxUGJoWitHcnVaSTZj?=
 =?utf-8?B?d2dmWTNWWWtPb1ZRekZCVEFuUU9qbk03bE8vMTJWaUVOZnlUQW9wQVpKTENy?=
 =?utf-8?B?UjVYOGVTQVl3YkZnQ2lJVHFLSlBteEF6U0MzT0xVOXRwc1h1SUF4NHNhUER3?=
 =?utf-8?B?UGtjYUFlZUk5THJmMFFINW9vVzNxcWwwZXJRWXF2OFdmc2VoUmRoNmJYMy9k?=
 =?utf-8?B?c0NVRk1vQ05qc1Z6d2ZQekhONkwyWHQvb1pETmpITjBlY0pWR0VkdGNxQWRK?=
 =?utf-8?B?SGFjR2lNV2VxOEhzYnQ1STRNaURLL1J5OHBmT0EybDdNWWdOazNGcGs1Wk90?=
 =?utf-8?B?eExVSXNxWHdBMDRjRm5kWXE4UVVFRjc0ZEJtMlFUOC8yT3J0eGpGd0Uvd1gy?=
 =?utf-8?B?SFduOFRIdHppTEZNbGpSODNYajAycVZ4d042MGZtcm5nMXRYc1BFYXVMVHAw?=
 =?utf-8?B?LzcvYjhicURWUndGTENmbkNYMVdQbGhwZytTVUNWWjkxdnNhVi9tUzAzWnJ6?=
 =?utf-8?B?TURUbHV5UzBQUnYvN2g2NUM2M2o2TnBvUzh0cmt1TWJxanhwOTFLM3cxZUtG?=
 =?utf-8?B?K2o4d1ZlUGtkYXNHemVVaGRNUVlDYnBnTXllTFJ5RWdNVXl1WmZST05LS0Vo?=
 =?utf-8?B?eUZGWmFnSTV4Wms4SWxKOFlCYlEwN0U4NWlmcGRSWG9QdUp3aFcwRTlWbm1u?=
 =?utf-8?B?K25wNGZYMTN5ajgxbjJUdWtFZ3R6VGlhUjNKb095cGVPUFprdHVQRHY1Y3hJ?=
 =?utf-8?B?VFdKYXp6bGV6L21wQStuRTY4MU5kSTg1N1JRZGRrTUc2UkZGNk9teFpFcW1p?=
 =?utf-8?B?Yk5BdHhNTmdvUlVNWTBqdGo0NXE2NXNLVXJUbVhxMWp0V0UycFo0M2tFOWll?=
 =?utf-8?B?THpzMlF2U2d6RFBYZXFJTi91YkhBRmE5UW5iMXl5UnM5Vm0rRWFjNCsxeDBY?=
 =?utf-8?B?NEV4a0JwU0VFcldNZ1pNSlZrQ3ZvYmJWY09HdVAveTN1TGg4Tkd4ejVobXF1?=
 =?utf-8?B?N1lYanZybjcyOHY3UFV4ZGZtMmJGakIwNnJkWUlxclBZeTA3Yk5ENEZXeWJv?=
 =?utf-8?B?dkRycER5ekN5eDcydFhjdEFhRFBrdjV2VDFybytWUVJEZjVET292R1RrMFh3?=
 =?utf-8?B?UXo1ZndsK1p4cElvRmxEemkvTTh6TUwwQlk3bVNjYitQdy9vR1NPWmNmblhu?=
 =?utf-8?B?Y0lSQngwMFZSa2ZqOHRwaWtkR2JlamhDRG82dGhTRjR3d255OFFKQmlkSURN?=
 =?utf-8?B?Z2pHNnVZbmtQQ1M2dkdUK3hUTC9LM3RyU2ZPM3ZsejFkb2tjQ25BcUZXcmFW?=
 =?utf-8?B?K0VNQnUvQWdVL1M0N2JPTlVYR1VGNjZPZXkxanBZUFFOMzN5WjVLeUFlQVlB?=
 =?utf-8?B?dVdzSi9Rdk5LaS9pQUtkelFncGJCbVArME9qRkN4dGlEM3l6ZGdMYXRXcUs0?=
 =?utf-8?B?cUhlRlhKOFNLTTJ5Z3ZaR0czMjUyU1ZUV3NuTDZtSVJ3dmRteTV6ejR3VWF6?=
 =?utf-8?B?d2l5UVdUVEd5ZFc1enc0bkMxdWJlc25IUy9ZYXNMMUtGajdOR2U1QzRENWtU?=
 =?utf-8?B?cFRFVFFpU1JuZFMyeGRxcHdERXpYSUV6OTJNcjlYL2htM3cwVzBCQ0lkRGxs?=
 =?utf-8?B?dkpNR0VzOEc2aVJ0aXhJTUxyVU5NWjJvaGFiWGFWUGZWWUl0OEo0bysxbHlK?=
 =?utf-8?B?L2c0dUpGYy9jYS8wejhSZ3JOdU5ZUmhIbS9Td1A2MldvMXBjY2xUUjZIRit5?=
 =?utf-8?B?VUdjWWt6VmNDeHgyOEVGVHp4UEx6NGtkUjg2TkEzWmc1SDVtRExxT3lzYmxh?=
 =?utf-8?B?Z2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <37F2850C09FF2C46BAD83AAC6E7BB66D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f126f4-44c8-40e2-3505-08dbf5227e83
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2023 23:41:10.3005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oj5giwTmQf0/tzQEkBsJGfgIklq7HgV/a0r//9d6+/BVbFa2QfKGd5ciAtt/gVriSEx+hWyk17djLTzfCB1RIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7246
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTEyLTA0IGF0IDIzOjI0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBM
b25nLXRlcm1seSwgaWYgd2UgZ28gdGhpcyBkZXNpZ24gdGhlbiB0aGVyZSBtaWdodCBiZSBvdGhl
ciBwcm9ibGVtcyB3aGVuIG90aGVyDQo+IGtlcm5lbCBjb21wb25lbnRzIGFyZSB1c2luZyBURFgu
wqAgRm9yIGV4YW1wbGUsIHRoZSBWVC1kIGRyaXZlciB3aWxsIG5lZWQgdG8gYmUNCj4gY2hhbmdl
ZCB0byBzdXBwb3J0IFREWC1JTywgYW5kIGl0IHdpbGwgbmVlZCB0byBlbmFibGUgVERYIG1vZHVs
ZSBtdWNoIGVhcmxpZXINCj4gdGhhbiBLVk0gdG8gZG8gc29tZSBpbml0aWFsaXphdGlvbi7CoCBJ
dCBtaWdodCBuZWVkIHRvIHNvbWUgVERYIHdvcmsgKGUuZy4sDQo+IGNsZWFudXApIHdoaWxlIEtW
TSBpcyB1bmxvYWRlZC7CoCBJIGFtIG5vdCBzdXBlciBmYW1pbGlhciB3aXRoIFREWC1JTyBidXQg
bG9va3MNCj4gd2UgbWlnaHQgaGF2ZSBzb21lIHByb2JsZW0gaGVyZSBpZiB3ZSBnbyB3aXRoIHN1
Y2ggZGVzaWduLiANCg0KUGVyaGFwcyBJIHNob3VsZG4ndCB1c2UgdGhlIGZ1dHVyZSBmZWF0dXJl
IGFzIGFyZ3VtZW50LCBlLmcuLCB3aXRoIG11bHRpcGxlIFREWA0KdXNlcnMgd2UgYXJlIGxpa2Vs
eSB0byBoYXZlIGEgcmVmY291bnQgdG8gc2VlIHdoZXRoZXIgd2UgY2FuIHRydWx5IHNodXRkb3du
IFREWC4NCg0KQW5kIFZNWCBvbi9vZmYgd2lsbCBhbHNvIG5lZWQgdG8gYmUgbW92ZWQgb3V0IG9m
IEtWTSBmb3IgdGhlc2Ugd29yay4NCg0KQnV0IHRoZSBwb2ludCBpcyBpdCdzIGJldHRlciB0byBu
b3QgYXNzdW1lIGhvdyB0aGVzZSBrZXJuZWwgY29tcG9uZW50cyB3aWxsIHVzZQ0KVk1YIG9uL29m
Zi4gIEUuZy4sIGl0IG1heSBqdXN0IGNob29zZSB0byBzaW1wbHkgdHVybiBvbiBWTVgsIGRvIFNF
TUFDQUxMLCBhbmQNCnRoZW4gdHVybiBvZmYgVk1YIGltbWVkaWF0ZWx5LiAgV2hpbGUgdGhlIFRE
WCBtb2R1bGUgd2lsbCBiZSBhbGl2ZSBhbGwgdGhlIHRpbWUuDQoNCktlZXBpbmcgVk1YIG9uIHdp
bGwgc3VwcHJlc3MgSU5JVCwgSSBndWVzcyB0aGF0J3MgYW5vdGhlciByZWFzb24gd2UgcHJlZmVy
IHRvDQp0dXJuaW5nIFZNWCBvbiB3aGVuIG5lZWRlZC4NCg0KLyogICAgICANCiAqIERpc2FibGUg
dmlydHVhbGl6YXRpb24sIGkuZS4gVk1YIG9yIFNWTSwgdG8gZW5zdXJlIElOSVQgaXMgcmVjb2du
aXplZCBkdXJpbmcNCiAqIHJlYm9vdC4gIFZNWCBibG9ja3MgSU5JVCBpZiB0aGUgQ1BVIGlzIHBv
c3QtVk1YT04sIGFuZCBTVk0gYmxvY2tzIElOSVQgaWYNCiAqIEdJRj0wLCBpLmUuIGlmIHRoZSBj
cmFzaCBvY2N1cnJlZCBiZXR3ZWVuIENMR0kgYW5kIFNUR0kuDQogKi8NCnZvaWQgY3B1X2VtZXJn
ZW5jeV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uKHZvaWQpDQp7DQoJLi4uDQp9DQo=

