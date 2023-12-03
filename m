Return-Path: <kvm+bounces-3267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B8080236D
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 12:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD0B3B20B24
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 11:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB34156C3;
	Sun,  3 Dec 2023 11:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="doWcQCdP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCB41BF0;
	Sun,  3 Dec 2023 03:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701603846; x=1733139846;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nhde8Z+UU0DfrR+bo4OkNIbXzqI232k0pVvo48ouRPA=;
  b=doWcQCdPyPLp57E+nWFe/qc8286KrgwgR5sVHrRWah5TPgqTt7iZ0vPz
   A7OsoipAFDn2Lu6V5n88NgKG9lPggh8bj2TzzWwkS7VTSD9/vvA3xh2h4
   D/ePgAPggYNerKja3Y0nDmFFpklNigS92DcxiubR2dfCIWy2QJslK1GPX
   8SCSW9VBRFRtEPOLb3m+WJ/F2qhIWqPDRBOG3K7FzJqCzTPLMpHk9cLiI
   xd3UvALGG4rXcVbk4rWntNZOBo1cw/0FdHlJIKS7tOP4UogZ5c0Bl+2AB
   Xodk4rsXTrsWH312ivZom1sknzPYr13boUquw7rF460TX82uxqepD6bl6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10912"; a="693093"
X-IronPort-AV: E=Sophos;i="6.04,247,1695711600"; 
   d="scan'208";a="693093"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 03:44:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10912"; a="1101801972"
X-IronPort-AV: E=Sophos;i="6.04,247,1695711600"; 
   d="scan'208";a="1101801972"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2023 03:44:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Sun, 3 Dec 2023 03:44:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Sun, 3 Dec 2023 03:44:03 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Sun, 3 Dec 2023 03:44:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brEKn8EnloXzPGumABuxM5yIt+piAnAYowNaN3+MhgclIFuK5gCcuOj9Dwhm2mpnVH9GB3pkSgB3YZmWDQAKHBx80RvPcGYd79t7dxQzzg6d6zPN0x2JqQ24rNRxHEtWZOqw5HpIHDaCbz/dXFIS0Ui8c6Vd6hRVaMM0zp/y5cGy/6NinaJNaULpyHVcdSIy82WzssHYQ4JEvhdYWf0JPU8dSkiQxyVERuNSJIgsRZqpRqSWwQjS+jId0DvnzutankF3DFQXyg5gTI/obXoi5kEpnYIWwNCDlwW05E5VP/v2Q0We4vbyvorLJCUhqfJMazjMnppN/KGnLtLVpIWTjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nhde8Z+UU0DfrR+bo4OkNIbXzqI232k0pVvo48ouRPA=;
 b=Qc1bJ7fomUrOAX7nnmPFkDPtb4n1r3Y6LKEMyPwEcxEYkWzs2q/Eq8TZjHm3RDRkc6aNjqJPHalAoipZFm4McCvzd214x+bugqzq76BuiCBlrWrP/aNycjCMke/ZvkYpG60cFbn9TbMTlYEiIq+WsRSA7ZDM/9FB2MDGpwybAvssEMovRkxvqxjEhw8ef97dXMbJntSfKmRmw9jKG+N43wifwxEWRuGmmUb/eEDs/VnRQ49ZHmx1K97Ug59M5lABzgGSHK4JX2m+U9qnYlHFvgj46ZthBeCAGGgJ5Q92gu9KR1HltpjVUCPF+w5q/Z/FMBu4F4uRS+SAenJ44td5Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7733.namprd11.prod.outlook.com (2603:10b6:8:dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.32; Sun, 3 Dec
 2023 11:44:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7046.028; Sun, 3 Dec 2023
 11:44:01 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Luck, Tony"
	<tony.luck@intel.com>, "david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "ak@linux.intel.com"
	<ak@linux.intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "imammedo@redhat.com" <imammedo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>, "Brown, Len"
	<len.brown@intel.com>, "rafael@kernel.org" <rafael@kernel.org>, "Huang, Ying"
	<ying.huang@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHaEwHtT+sYH5Rms0yY5S8b++o88LCVBfCAgAKQDAA=
Date: Sun, 3 Dec 2023 11:44:01 +0000
Message-ID: <afc875ace6f9f955557f5c7e811b3046278e4c51.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
	 <b3b265f9-48fa-4574-a925-cbdaaa44a689@intel.com>
In-Reply-To: <b3b265f9-48fa-4574-a925-cbdaaa44a689@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7733:EE_
x-ms-office365-filtering-correlation-id: 63e6b8ef-0c52-4430-bd60-08dbf3f524a8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QEYO9ulK8vfWj21OyPgEKMv0zt3eCx5yqVg4prNjZX+x/zGsrQ5IL6oI3GvMwZXtz0184UpaGINB+Hxo2GR3bKNPCKL7VoLRsqryxNd3OVShlaq62/MyPxD55Ju4AXuKSZ4rhCHQjo1veVdR/VZDyS+DYVVJ+gfQq8/vwZvql3LQjXrv3gTi/haadSNOiKFW4ZSNFe2f+HADXUePOSTcFtPwsK7W7/7vbllLoVwJfA19CD3it3nEO/MPiE8MYbe8UOTHe53ocrCnf7tl25udXbjsJwBQXMgEikCWOshiLpTt8MO9PlXvQZRPjwU9x+v6RZzL0KCaNuq7SN0/1C9YtYS3zpBp0REaBV24/7WOd6hdNlAXV//KLwTrclHgRlR2GlVRkv8/hPlmo49Hxt/Z0msOuKAnVYPoXDFUoNjgyrhPpho5czVK5Gx12wKLv5yl8Lyqk57NkMH7utvjUa5XClXUruoBQIjAetAljQKQQvCrI8B6G80qVT7PHM6bbJjp+cdKByLELxegSo7w0LEf3ig9Fc2ALbmK8xM3OZXXPMGQH/nEzOkVk6g4oJXVYIFwaHhEF6VDiuRc8egZxlhb2SHJO0VNgWtjWfsIBMrQikAoPj5s6n9fyJBrAlKJPHZu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(376002)(396003)(366004)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(66446008)(64756008)(66556008)(66476007)(110136005)(76116006)(54906003)(91956017)(316002)(66946007)(5660300002)(4326008)(8936002)(8676002)(7416002)(6486002)(71200400001)(38100700002)(83380400001)(122000001)(86362001)(2906002)(478600001)(26005)(2616005)(6506007)(6512007)(36756003)(53546011)(82960400001)(41300700001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXkvUzJFaFNsMkd5U1BIR0pmN29XOE82WFFmZ3R1dlRCalhadmdlSlpHdk1W?=
 =?utf-8?B?R3JvZFExMXgzLzYzNGc4OHIzbFBITUY2dWNjdk5TSGU4amZsN1ZBZkxUcTE2?=
 =?utf-8?B?dno3S1lTV3Z4ZHhhVXlVZEdyWStjL3ZhV3lpdm5VdlFDOWd6dFFzV21uZjJk?=
 =?utf-8?B?dEd1MmxMSVp6aW96eGdzZWk5QU9TbTZ4MDVkUS83Z1YwMGtaNFF0NU9TOUx2?=
 =?utf-8?B?ZThQRDYyM25OaWtiUm1TbW1MaS81YmljYXBQamtZWlNwSU14NFZocHNjc3VZ?=
 =?utf-8?B?VDJBTjRKZDlUcUtrTTB4QThjNUZiL0lmTkxyVnVlNjhSbTBJN2VTdzQ2VlYz?=
 =?utf-8?B?UThuSFRYSHBVNnBTVGlDT24ydXNseHpTZWFCUGxCUXU3TXNQV2UzZS9LSTJ3?=
 =?utf-8?B?dFV2d2ZJeHcxOG5pZFhMUVhaNk5jZ01HOUptNy8xaHNKUk80NHo2d2kxRzFt?=
 =?utf-8?B?YTdkOXJ5eFdzaS9NOE55ay9ZUWoxRnFkRWRYNkpiMkR5TFFFUGNDN25oM2xy?=
 =?utf-8?B?SHZWeUV4S1JQeDI2SGswamlzZkg3TXlDUHVITDY1ckg1OTRFM0xoRGUvSEUr?=
 =?utf-8?B?S2xna21WTDdac0pGRi9VZlBwd2R0TUNsNG5LVlNJSnYxZ21rODBJSDVqYXJk?=
 =?utf-8?B?ZzVsd2FrY3hJZVQraFRLa2FTbThwazl2WDNNejdvaUFUZG5LaXBUckRCWXUy?=
 =?utf-8?B?anllSDVaSGUrMlpvR0h1Szh4TzNqaitwRnRXTVdiUmxmWW8xbmVTYzZheWZs?=
 =?utf-8?B?WEhpZmZIVWNCQndpdkkybEt3VWtYeis1ZmJDZkZqcEdXeFhjTThQbkpLMG9y?=
 =?utf-8?B?TlhvL3lWK2F4UDhoUlZhK1VOUHJHRGYyeXlqeTl1NWNDMDVBZGdkYWFuelNI?=
 =?utf-8?B?a1hPRXdSclNXUUJkOHNlNHlJYzJzWmpJZlo5SDlCaG5xbzNoM29pcnFCU0FV?=
 =?utf-8?B?eGRQTnlHa2craFF2OVdvRXBTVFlkTXJhbDhYc3QrS1VyOHVKbVUzZDBJSUEv?=
 =?utf-8?B?Y1RjRUxXVERFNDBhVHNwQUtCTFRnQTRVSjY3YlBmK2h0VDJFMWFpU2ZtdmEv?=
 =?utf-8?B?SFE4eHdYRW02ZmI0NmpESTMyZWZHMkFTWW9idXZqbWxtRDhNaXlmTXhEVTlO?=
 =?utf-8?B?U1JWSE4wcE94aEV2UUFGTjVkL0ttYWpJbnA4aHJnd2lxZzUzU1RsTk1kZXFO?=
 =?utf-8?B?WDlxejdUbVlDaVAyRFBGd2pneHZFYm5iZy93clVJZERWeHBFN2VhcVZXQ0xa?=
 =?utf-8?B?QjJJcVpsMmZFVmN1ZUpmQ0xJTUh2ZjIvMmR1REw4dGlnVGNmUWsvc2lZb01Z?=
 =?utf-8?B?QS9EL1ZSN1k0MExzaTBkU2VGb2JqNG1RTzRTUmlqUnNsbURxcDc4V015QlNW?=
 =?utf-8?B?YWx5bkZCWjB2VmJuWUs4RktmV1p0UFNQM1NLWGZ5bWx0OUJYV20vRFlJTGdB?=
 =?utf-8?B?RkI3ZnQzaGxpazE1dHhPTjlRY01PcTg2d1dXdGlTM0NtT0w3bVpwY1BzeXhO?=
 =?utf-8?B?NDZSU3lJaHpzbnQwbm8zdExGSC8waEZNN3l2MFEvOTl0czhZSk94WUgzVVky?=
 =?utf-8?B?S3VjdFBaOHBNNk15S0FBUEVDWjllYVM2TFJtRGlkOGEyN1hjU1c3a05KRHpX?=
 =?utf-8?B?Qkt2UlRLQThXa0kzWUx0OE5YZ0xJMTVCUjlCY1p6OFRZcGVmZnNDc1NNd1RJ?=
 =?utf-8?B?U2NlNWhna0hUb1V6N2JLNElIU0ZWL0syb2FDUitTaXRUaUxJZzU0SzNPUFBD?=
 =?utf-8?B?Y0UyaVNybVIvMURSdkxzME8yTzBLYmxXZkhMTkhoakFmbmp6NDRhYXJsS25r?=
 =?utf-8?B?UEdtSms1b0M2Q3BoS3BFWXhFZ1B0cmtBcHdBekZOOHN4M0tQcy9QdjhPYWYv?=
 =?utf-8?B?aWxPSTNvWU94bUJBMmVCbVdyWmNvNGphelkwL3JDQ2ovS0xWNlpXS2Nhb2Ja?=
 =?utf-8?B?RFJEdFFMQ2F3QUhoSHRwMDFWMHNCdVdzTE8zUmNXQkhVVUhvWTBwU1NvTXk3?=
 =?utf-8?B?bXZodFk2Q25hbmtKQ24xR2dRNG5WWFR5OUNzdnBiOVpBLzduRVNCQ0RaOXFp?=
 =?utf-8?B?VVgrZzliMVQzWmxxeDdJQWFDRzl4N0xJdHB4UEJmeWxraEdyMEdFWDJ4T3Ni?=
 =?utf-8?B?OGh5cTBpS2g0SVdnazdOc3ovbksvTHFrWU5CejZmdnZpcHBDN2NQM3dUa25M?=
 =?utf-8?B?RWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6465EB45DC274A46A5BCE2BCA424D0D9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63e6b8ef-0c52-4430-bd60-08dbf3f524a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2023 11:44:01.0221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JGkuX11j16V2DGU0Ih+W9mtzgxWwUIpYUS5Jiy7hKMFRqX6BdTzF1tVocDwcJTEP1alm/uz/+VaW3N+1nJkYnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7733
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTEyLTAxIGF0IDEyOjM1IC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDExLzkvMjMgMDM6NTUsIEthaSBIdWFuZyB3cm90ZToNCj4gPiArc3RhdGljIGJvb2wgaXNf
cGFtdF9wYWdlKHVuc2lnbmVkIGxvbmcgcGh5cykNCj4gPiArew0KPiA+ICsJc3RydWN0IHRkbXJf
aW5mb19saXN0ICp0ZG1yX2xpc3QgPSAmdGR4X3RkbXJfbGlzdDsNCj4gPiArCWludCBpOw0KPiA+
ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBUaGlzIGZ1bmN0aW9uIGlzIGNhbGxlZCBmcm9tICNNQyBo
YW5kbGVyLCBhbmQgdGhlb3JldGljYWxseQ0KPiA+ICsJICogaXQgY291bGQgcnVuIGluIHBhcmFs
bGVsIHdpdGggdGhlIFREWCBtb2R1bGUgaW5pdGlhbGl6YXRpb24NCj4gPiArCSAqIG9uIG90aGVy
IGxvZ2ljYWwgY3B1cy4gIEJ1dCBpdCdzIG5vdCBPSyB0byBob2xkIG11dGV4IGhlcmUNCj4gPiAr
CSAqIHNvIGp1c3QgYmxpbmRseSBjaGVjayBtb2R1bGUgc3RhdHVzIHRvIG1ha2Ugc3VyZSBQQU1U
cy9URE1Scw0KPiA+ICsJICogYXJlIHN0YWJsZSB0byBhY2Nlc3MuDQo+ID4gKwkgKg0KPiA+ICsJ
ICogVGhpcyBtYXkgcmV0dXJuIGluYWNjdXJhdGUgcmVzdWx0IGluIHJhcmUgY2FzZXMsIGUuZy4s
IHdoZW4NCj4gPiArCSAqICNNQyBoYXBwZW5zIG9uIGEgUEFNVCBwYWdlIGR1cmluZyBtb2R1bGUg
aW5pdGlhbGl6YXRpb24sIGJ1dA0KPiA+ICsJICogdGhpcyBpcyBmaW5lIGFzICNNQyBoYW5kbGVy
IGRvZXNuJ3QgbmVlZCBhIDEwMCUgYWNjdXJhdGUNCj4gPiArCSAqIHJlc3VsdC4NCj4gPiArCSAq
Lw0KPiANCj4gSXQgZG9lc24ndCBuZWVkIHBlcmZlY3QgYWNjdXJhY3kuICBCdXQgaG93IGRvIHdl
IGtub3cgaXQncyBub3QgZ29pbmcgdG8NCj4gZ28sIGZvciBpbnN0YW5jZSwgY2hhc2UgYSBiYWQg
cG9pbnRlcj8NCj4gDQo+ID4gKwlpZiAodGR4X21vZHVsZV9zdGF0dXMgIT0gVERYX01PRFVMRV9J
TklUSUFMSVpFRCkNCj4gPiArCQlyZXR1cm4gZmFsc2U7DQo+IA0KPiBBcyBhbiBleGFtcGxlLCB3
aGF0IHByZXZlbnRzIHRoaXMgQ1BVIGZyb20gb2JzZXJ2aW5nDQo+IHRkeF9tb2R1bGVfc3RhdHVz
PT1URFhfTU9EVUxFX0lOSVRJQUxJWkVEIHdoaWxlIHRoZSBQQU1UIHN0cnVjdHVyZSBpcw0KPiBi
ZWluZyBhc3NlbWJsZWQ/DQoNClRoZXJlIGFyZSB0d28gdHlwZXMgb2YgbWVtb3J5IG9yZGVyIHNl
cmlhbGl6aW5nIG9wZXJhdGlvbnMgYmV0d2VlbiBhc3NlbWJsaW5nDQp0aGUgVERNUi9QQU1UIHN0
cnVjdHVyZSBhbmQgc2V0dGluZyB0aGUgdGR4X21vZHVsZV9zdGF0dXMgdG8NClREWF9NT0RVTEVf
SU5JVElBTElaRUQ6IDEpIHdidmluZF9vbl9hbGxfY3B1cygpOyAyKSBidW5jaCBvZiBTRUFNQ0FM
THM7DQoNCldCSU5WRCBpcyBhIHNlcmlhbGl6aW5nIGluc3RydWN0aW9uLiAgU0VBTUNBTEwgaXMg
YSBWTUVYSVQgdG8gdGhlIFREWCBtb2R1bGUsDQp3aGljaCBpbnZvbHZlcyBHRFQvTERUL2NvbnRy
b2wgcmVnaXN0ZXJzL01TUnMgc3dpdGNoIHNvIGl0IGlzIGFsc28gYSBzZXJpYWxpemluZw0Kb3Bl
cmF0aW9uLg0KDQpCdXQgcGVyaGFwcyB3ZSBjYW4gZXhwbGljaXRseSBhZGQgYSBzbXBfd21iKCkg
YmV0d2VlbiBhc3NlbWJsaW5nIFRETVIvUEFNVA0Kc3RydWN0dXJlIGFuZCBzZXR0aW5nIHRkeF9t
b2R1bGVfc3RhdHVzIGlmIHRoYXQncyBiZXR0ZXIuDQoNCj4gDQo+ID4gKwlmb3IgKGkgPSAwOyBp
IDwgdGRtcl9saXN0LT5ucl9jb25zdW1lZF90ZG1yczsgaSsrKSB7DQo+ID4gKwkJdW5zaWduZWQg
bG9uZyBiYXNlLCBzaXplOw0KPiA+ICsNCj4gPiArCQl0ZG1yX2dldF9wYW10KHRkbXJfZW50cnko
dGRtcl9saXN0LCBpKSwgJmJhc2UsICZzaXplKTsNCj4gPiArDQo+ID4gKwkJaWYgKHBoeXMgPj0g
YmFzZSAmJiBwaHlzIDwgKGJhc2UgKyBzaXplKSkNCj4gPiArCQkJcmV0dXJuIHRydWU7DQo+ID4g
Kwl9DQo+ID4gKw0KPiA+ICsJcmV0dXJuIGZhbHNlOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICsvKg0K
PiA+ICsgKiBSZXR1cm4gd2hldGhlciB0aGUgbWVtb3J5IHBhZ2UgYXQgdGhlIGdpdmVuIHBoeXNp
Y2FsIGFkZHJlc3MgaXMgVERYDQo+ID4gKyAqIHByaXZhdGUgbWVtb3J5IG9yIG5vdC4gIENhbGxl
ZCBmcm9tICNNQyBoYW5kbGVyIGRvX21hY2hpbmVfY2hlY2soKS4NCj4gPiArICoNCj4gPiArICog
Tm90ZSB0aGlzIGZ1bmN0aW9uIG1heSBub3QgcmV0dXJuIGFuIGFjY3VyYXRlIHJlc3VsdCBpbiBy
YXJlIGNhc2VzLg0KPiA+ICsgKiBUaGlzIGlzIGZpbmUgYXMgdGhlICNNQyBoYW5kbGVyIGRvZXNu
J3QgbmVlZCBhIDEwMCUgYWNjdXJhdGUgcmVzdWx0LA0KPiA+ICsgKiBiZWNhdXNlIGl0IGNhbm5v
dCBkaXN0aW5ndWlzaCAjTUMgYmV0d2VlbiBzb2Z0d2FyZSBidWcgYW5kIHJlYWwNCj4gPiArICog
aGFyZHdhcmUgZXJyb3IgYW55d2F5Lg0KPiA+ICsgKi8NCj4gPiArYm9vbCB0ZHhfaXNfcHJpdmF0
ZV9tZW0odW5zaWduZWQgbG9uZyBwaHlzKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgdGR4X21vZHVs
ZV9hcmdzIGFyZ3MgPSB7DQo+ID4gKwkJLnJjeCA9IHBoeXMgJiBQQUdFX01BU0ssDQo+ID4gKwl9
Ow0KPiA+ICsJdTY0IHNyZXQ7DQo+ID4gKw0KPiA+ICsJaWYgKCFwbGF0Zm9ybV90ZHhfZW5hYmxl
ZCgpKQ0KPiA+ICsJCXJldHVybiBmYWxzZTsNCj4gPiArDQo+ID4gKwkvKiBHZXQgcGFnZSB0eXBl
IGZyb20gdGhlIFREWCBtb2R1bGUgKi8NCj4gPiArCXNyZXQgPSBfX3NlYW1jYWxsX3JldChUREhf
UEhZTUVNX1BBR0VfUkRNRCwgJmFyZ3MpOw0KPiA+ICsJLyoNCj4gPiArCSAqIEhhbmRsZSB0aGUg
Y2FzZSB0aGF0IENQVSBpc24ndCBpbiBWTVggb3BlcmF0aW9uLg0KPiA+ICsJICoNCj4gPiArCSAq
IEtWTSBndWFyYW50ZWVzIG5vIFZNIGlzIHJ1bm5pbmcgKHRodXMgbm8gVERYIGd1ZXN0KQ0KPiA+
ICsJICogd2hlbiB0aGVyZSdzIGFueSBvbmxpbmUgQ1BVIGlzbid0IGluIFZNWCBvcGVyYXRpb24u
DQo+ID4gKwkgKiBUaGlzIG1lYW5zIHRoZXJlIHdpbGwgYmUgbm8gVERYIGd1ZXN0IHByaXZhdGUg
bWVtb3J5DQo+ID4gKwkgKiBhbmQgU2VjdXJlLUVQVCBwYWdlcy4gIEhvd2V2ZXIgdGhlIFREWCBt
b2R1bGUgbWF5IGhhdmUNCj4gPiArCSAqIGJlZW4gaW5pdGlhbGl6ZWQgYW5kIHRoZSBtZW1vcnkg
cGFnZSBjb3VsZCBiZSBQQU1ULg0KPiA+ICsJICovDQo+ID4gKwlpZiAoc3JldCA9PSBURFhfU0VB
TUNBTExfVUQpDQo+ID4gKwkJcmV0dXJuIGlzX3BhbXRfcGFnZShwaHlzKTsNCj4gDQo+IEVpdGhl
ciB0aGlzIGlzIGNvbW1lbnQgaXMgd29ua3kgb3IgdGhlIG1vZHVsZSBpbml0aWFsaXphdGlvbiBp
cyBidWdneS4NCj4gDQo+IGNvbmZpZ19nbG9iYWxfa2V5aWQoKSBnb2VzIGFuZCBkb2VzIFNFQU1D
QUxMcyBvbiBhbGwgQ1BVcy4gIFRoZXJlIGFyZQ0KPiB6ZXJvIGNoZWNrcyBvciBzcGVjaWFsIGhh
bmRsaW5nIGluIHRoZXJlIGZvciB3aGV0aGVyIHRoZSBDUFUgaGFzIGRvbmUNCj4gVk1YT04uICBT
bywgYnkgdGhlIHRpbWUgd2UndmUgc3RhcnRlZCBpbml0aWFsaXppbmcgdGhlIFREWCBtb2R1bGUN
Cj4gKGluY2x1ZGluZyB0aGUgUEFNVCksIGFsbCBvbmxpbmUgQ1BVcyBtdXN0IGJlIGFibGUgdG8g
ZG8gU0VBTUNBTExzLiAgUmlnaHQ/DQo+IA0KPiBTbyBob3cgY2FuIHdlIGhhdmUgYSB3b3JraW5n
IFBBTVQgaGVyZSB3aGVuIHRoaXMgQ1BVIGNhbid0IGRvIFNFQU1DQUxMcz8NCg0KVGhlIGNvcm5l
ciBjYXNlIGlzIEtWTSBjYW4gZW5hYmxlIFZNWCBvbiBhbGwgY3B1cywgaW5pdGlhbGl6ZSB0aGUg
VERYIG1vZHVsZSwNCmFuZCB0aGVuIGRpc2FibGUgVk1YIG9uIGFsbCBjcHVzLiAgT25lIGV4YW1w
bGUgaXMgS1ZNIGNhbiBiZSB1bmxvYWRlZCBhZnRlciBpdA0KaW5pdGlhbGl6ZXMgdGhlIFREWCBt
b2R1bGUuDQoNCkluIHRoaXMgY2FzZSBDUFUgY2Fubm90IGRvIFNFQU1DQUxMIGJ1dCBQQU1UcyBh
cmUgYWxyZWFkeSB3b3JraW5nIDotKQ0KDQpIb3dldmVyIGlmIFNFQU1DQUxMIGNhbm5vdCBiZSBt
YWRlIChkdWUgdG8gb3V0IG9mIFZNWCksIHRoZW4gdGhlIG1vZHVsZSBjYW4gb25seQ0KYmUgaW5p
dGlhbGl6ZWQgb3IgdGhlIGluaXRpYWxpemF0aW9uIGhhc24ndCBiZWVuIHRyaWVkLCBzbyBib3Ro
DQp0ZHhfbW9kdWxlX3N0YXR1cyBhbmQgdGhlIHRkeF90ZG1yX2xpc3QgYXJlIHN0YWJsZSB0byBh
Y2Nlc3MuDQoNCj4gDQo+IEkgZG9uJ3QgdGhpbmsgd2Ugc2hvdWxkIGV2ZW4gYm90aGVyIHdpdGgg
dGhpcyBjb21wbGV4aXR5LiAgSSB0aGluayB3ZQ0KPiBjYW4ganVzdCBmaXggdGhlIHdob2xlIHRo
aW5nIGJ5IHNheWluZyB0aGF0IHVubGVzcyB5b3UgY2FuIG1ha2UgYQ0KPiBub24taW5pdCBTRUFN
Q0FMTCwgd2UganVzdCBhc3N1bWUgdGhlIG1lbW9yeSBjYW4ndCBiZSBwcml2YXRlLg0KPiANCj4g
VGhlIHRyYW5zaXRpb24gdG8gYmVpbmcgYWJsZSB0byBtYWtlIG5vbi1pbml0IFNFQU1DQUxMcyBp
cyBhbHNvICNNQyBzYWZlDQo+ICphbmQqIGl0J3MgYXQgYSBwb2ludCB3aGVuIHRoZSB0ZG1yX2xp
c3QgaXMgc3RhYmxlLg0KPiANCj4gQ2FuIGFueW9uZSBzaG9vdCBhbnkgaG9sZXMgaW4gdGhhdD8g
OikNCg0KDQo=

