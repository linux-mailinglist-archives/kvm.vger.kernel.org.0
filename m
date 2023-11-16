Return-Path: <kvm+bounces-1866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBB377ED9F7
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 04:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC07C1C20984
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 03:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F35179E4;
	Thu, 16 Nov 2023 03:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iQ8YApLz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0EF19F;
	Wed, 15 Nov 2023 19:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700104797; x=1731640797;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MZo6KiZ6Vb+Ht1oZDRGkw4fhT6GFKtI3Iqt8t8SzSms=;
  b=iQ8YApLz1fp/kv3TO+A1xuOFHjEd72zd1rkjH65Gpcv/FdTdjlxPzQns
   BDf8dPZnTcYotAV7p6rKA9+FMs4kZb5/jE8PrWoAiH08IASMlkYxFm3S7
   Td8lb96be1jkXphon4IFwMTuMGAeIFAoicHdqTvmK7exBHf+YpaIpkqgg
   01+s9ylr6GllPj436XMPdxRmMTnXGmM7emnHO71uGgTrMZVnWG1B3UCjK
   umCn/cM0PryokZGFdDwBhMYbKna+qvXWi6kTGZV5KbOPBzA1Saxwz4xCQ
   PPbAHoF8HL6MUilwzbHshRZiagxmOhlqF2JsZsaPO8u56Yhk5fQi9zyTP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="457500466"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="457500466"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 19:19:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="888774284"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="888774284"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2023 19:19:55 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 19:19:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 19:19:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 15 Nov 2023 19:19:54 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 15 Nov 2023 19:19:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vb8nvgI+L5LC1ygc1ke5io5oJhHUPc7jJ0JQI43ZUad3F/YwkqsMR8B0nkttB8ABCH36JtghFqCHrWHyg2uz9b8pJzagHhU9EDXatTDAkAMdhHsumzqlnbPTNhTX+xzHfjME8wnZADvlBdi49dxJwDUPzwhq12WnYbSlgYGKwAQWL+rC+U6+mQojRd+qLfnkN19VRgqgK2zV9xAN/KN3kiOlztAeFC8KY1Q3DodD9/vejWepqR431YkqBstnZ2q8XGqE/uU+9mH0lFrwoOmW61avlfoEPQOFeYbvwe6rK7i7o6Rx5N6MrzxCqXy3AlF0rfG+aJvOM7yVAhC5zwwNEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZo6KiZ6Vb+Ht1oZDRGkw4fhT6GFKtI3Iqt8t8SzSms=;
 b=njpKLRFV5TKj64w+jpz7CABEZFTr1Fw2qSpqQL6vR/EUGeJBRh03dpA49yUBAbph2kaNin6NiNmUu2bDVwXi5p++R7579I2Na5cIJ4SImgP/EXGHAeh0RoNFj/zPCFc9GbBh95yDF3u92BKzDlPgsWWPNafoaRZ4oSkCQ2YoJvzK+/v/5V8/J65x/quCVl0oGZmMDYrzh+nebfuzbImrCAgcsGFqk7KY4bLacsJ4FVfrOfUQsJfJ/IolHf9KYK5DL6WtzlpuNdw/XBRmY28BieGU1p4k+OnaNS7sX26fne+3K84CWdD0Kf5nUAcJvFKt8PFBPOWzwqQR4tpzyNMivw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7491.namprd11.prod.outlook.com (2603:10b6:806:349::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.20; Thu, 16 Nov
 2023 03:19:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7002.019; Thu, 16 Nov 2023
 03:19:51 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
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
	"peterz@infradead.org" <peterz@infradead.org>, "Shahar, Sagi"
	<sagis@google.com>, "imammedo@redhat.com" <imammedo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
	"rafael@kernel.org" <rafael@kernel.org>, "Brown, Len" <len.brown@intel.com>,
	"Huang, Ying" <ying.huang@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v15 09/23] x86/virt/tdx: Get module global metadata for
 module initialization
Thread-Topic: [PATCH v15 09/23] x86/virt/tdx: Get module global metadata for
 module initialization
Thread-Index: AQHaEwHk1WEU6GoyN0mDwyxXYrXi6bB7z9wAgACBoIA=
Date: Thu, 16 Nov 2023 03:19:50 +0000
Message-ID: <099af84250bf1ee765628643307e792208ec86d0.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <30906e3cf94fe48d713de21a04ffd260bd1a7268.1699527082.git.kai.huang@intel.com>
	 <20231115193550.GC1109547@ls.amr.corp.intel.com>
In-Reply-To: <20231115193550.GC1109547@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7491:EE_
x-ms-office365-filtering-correlation-id: 1292f532-29b2-431e-2f99-08dbe652e529
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3sytQaJyEN7B/XnBJ79dODUl9PZS+Ns2RPmb3UWKRyOQZBxhY1bU9CJMkSjOS/FiEuTUxm/tljmrYV8jB4Gw1bN6fKb2NWLl+pBFsS/JeQTZldKuEjGSR/lKaiPrHEnqaGu9rlNzdyXN/Nwdv6RzluDcXGeUe0aSR6FYlDq7ztuJftIgD6sBfIQxgC70AytjQFSYiW6CeH7WKDU2Ai7sNmdHNVa8xRrqwkGJYne+E2/fpqSyzJrTn1Q8zzyk8qvgFiiFtc4E240ZsMQFDpwD38mPnZVg//4Qe1akKe/VIWRlbdgUYjIaCN+uAi2r2FLuana6RhaQiHo0Y5qzect1efunYY46x1Wu15Z51N5Bap2ADv0j2XxE3jOgX/3pwmPzO/JiXYXWCNYNQVHniNUs2jOD9af40eO5wMYr4chnKLMOY3+OX9c5658N3nFrKtrG6Zgj+ge8vByxXtpiS4iqn+omwMXyVtEtxzkrizKh7Qp4TqVoTPyU7kVG4KBmogTWZF9F2SfaHvhjMSyLAFGCPktE/Qq6vfZFHNgw9oowdhsMkKLFgLVPNfcYSeJoalLgnh3tE/npiBsGhhNYJKs9GSidWFELIW4kI+/AAe+Q5fWnGMwsRyKg9CgYpVBdtm9d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(136003)(376002)(39860400002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(6486002)(478600001)(2906002)(6506007)(4001150100001)(2616005)(6512007)(91956017)(5660300002)(86362001)(71200400001)(7416002)(6916009)(316002)(4744005)(64756008)(54906003)(66946007)(66476007)(66556008)(66446008)(76116006)(4326008)(8676002)(8936002)(38100700002)(38070700009)(41300700001)(26005)(82960400001)(36756003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGNjYm1XZitIRkdPdzdjZS9JaTN2K3JnRUcxS08wbGxjUTg5aVhzQTdxUG0w?=
 =?utf-8?B?aUNkVE5IcHBFRE1aaDJZM3h5a0tHclVVSkg4WWhyUEdKalJmYWdVUTRQc2g1?=
 =?utf-8?B?cjV3eWF0UzRBM1E4S2lPM0lyOHpLM1d1N0dLYnM5K21FNjZocHNZWk53TkN6?=
 =?utf-8?B?S3ljSnRYZjM2K3J2R0xqMFN4R1dOZTZKbEJQRmg1OU9sWUIzOHJvc0Jka3RP?=
 =?utf-8?B?WE1wY1R5dUo3RWV1QlNSZlBhaVFCcEpVaGk0VzkvQ1B5N0VWQWgrcWdEd1Fr?=
 =?utf-8?B?cnJKdllWOHV5Zkc1aWJpQkRBVUp0clpYTGlkeFpGby9vZ1RONlhQZmFMQkc2?=
 =?utf-8?B?bGhEMEJnWUlURHpab3BxdzI1N0h4Vmp6UDNxTXpIeXZaRlhzSW9wc1ZzUkNQ?=
 =?utf-8?B?OEZyei9hcVhOZDJLcE52aEZRT2ZjMlhhNWpON1R0Mk9XUWREdHZHeUxOVytI?=
 =?utf-8?B?S200NDZVZWlqUVV3TDhUcWxnRTZDNjNnVGQ2dXBnL2NDVFFqR0JSN0FTUXNr?=
 =?utf-8?B?T3k3akFYZjl2eG92SmFaTEZTM0JOUEFiQi9haklTbnN0NzVmc2g0Ritta0Zu?=
 =?utf-8?B?aEF4cGxZN1crNGNmcXFVSGpmbGpYY0swQVNuam0rVjBkc0ttM0VqK2Z0K1RR?=
 =?utf-8?B?S1p5cDhMWHZqU3cvNE90OE5Oci9qaTB3aHRha3BTWlAyU082MDVmK25IN0tz?=
 =?utf-8?B?cWR1QkMwZEVjZkM1MFVLcVRzeG1JSnh4OFdtNXpNMFBYL2ladmV4RHhvcTR6?=
 =?utf-8?B?UzdOdHdWV01TK2Z3TWhLZVAxcTVIMjBIVFhGaDhpMks4ZEN5RXlpODJYK0FO?=
 =?utf-8?B?VXptUmczLzY3bzBVWUh0bTMydmRxaGY2bW9yVXdNUVltVTFtc3Q0ZjdzTXRW?=
 =?utf-8?B?SzBzTnQ0RS9odHJqWE12ZmhCU252UEcxMVRRNXVvYUlIVk9ydlpDVWJBdis3?=
 =?utf-8?B?UXpSVmV6Y1c1VzZXbnUvYTQ0cldwTUV4dVVPQmsrRzAyUDJNU2M1MEU2NDJS?=
 =?utf-8?B?QXgxT0JZQWZnUFFQNlcwWDJrcGFuNjRYRWxGQUNNWjlHWXFaa3QzV2hUNFhr?=
 =?utf-8?B?VEZaTUEvMVFnQW52S0UzWERXVzR6bGVacWpYUXJkbjZlS2JLTXFpazR5dncy?=
 =?utf-8?B?WVpUZmd4U3oyTmtLZnFkNExJQm5LbklaRHhhekJOQ1B6Y3dXb1pockZxdUZJ?=
 =?utf-8?B?NEFnRSsrNkhHRjc0Zld4MzUyc0ZJVWE1UlRFNXZNWWUrTkRGM25iRllBdS9y?=
 =?utf-8?B?dDNQbUdMeGViS0dneUhkaWcycnJaUU92d2Z5SDdicFVldEhlOVM2Z0VOa216?=
 =?utf-8?B?VGY5amwwQVJEaHRqRzNnTHoyL3BRenZTM0l3NHhhN1VjQUhCOHZXUU42a2lM?=
 =?utf-8?B?czZkdVl2ZGUwVHNSS2JjVlk5LzlqZUhONitwVk5pYUpDVnNBY0lhQWtOcGhq?=
 =?utf-8?B?cElYK2k2OGRnU2RBT3hEeUlQUUJFUTdSVkNWbGNkVWE5MVJmWFBQSUZHU3pK?=
 =?utf-8?B?UGNvK0xQaEc3REFpamp4bTltbGJTTWJEUEtHeGN5NTVTVjVwa1Z2aVRSVjln?=
 =?utf-8?B?OE5XVmpsbXpodFNVa0pyLy9YQUFNdjkwZHBXYU5kSUJHTHdUNExmUXhPRTZH?=
 =?utf-8?B?V05NRGEzcE9FMHg2V2VoVUUwWkFDOUZzdUxxcXZuTWI0TVZNc215bGxRVnp5?=
 =?utf-8?B?NHpDS05URXVSYXJjWWxhaXpZNXkxSGlCWndFRS9iblhLSlBRTStscnl0UXc0?=
 =?utf-8?B?L0lZZE13L3ZIT3dhV3MzdFlxdzlGQVNGcjJvQWJCSGw0QU5GV2hhTlJLVWh0?=
 =?utf-8?B?bDhHUkpLcjNYYUJsbSs1Um1JUEE3eTBJZE9CUld6THdvNjZrVFRITFN0NEJy?=
 =?utf-8?B?UGZTRWRsWS9KVThOb3l2cEh1MUpoNXhKS2FRbFRZeklWSHVQVWEwTjk4bDg1?=
 =?utf-8?B?TWpUN3g3eno0NFBzZlNqK05CRTZwQjdSVnl2K3FUQUhLajhraHphZjR4aXNS?=
 =?utf-8?B?MEsvVi9LbGVDd3V1Q3E1cUdGOFFtRDl3U05uTVdhUEZaTTEzeVhBNUdYTlF1?=
 =?utf-8?B?ZW9CVHFaRWlsU2R4WHk0VUNzNld3amRtcDEyUDdsK0hURENrWWtTMDZpUHBW?=
 =?utf-8?B?VE5BNE10L3Y5VzZudXFvbkIvV1dEaWFpTFlCeWIyVmNpeE9sZlpvcHp4MHNT?=
 =?utf-8?B?NlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75780D91B1FA5E4EBDCEF2E76B3B3659@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1292f532-29b2-431e-2f99-08dbe652e529
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2023 03:19:50.9170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 20FdqTs0cmSp311eHzLP1FzhfXckC3M0WkcSIzerKIxNomNh3mbR7fNoulLsId9jts7YK/hOcEz3j/p1GtIYpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7491
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIzLTExLTE1IGF0IDExOjM1IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gTm93IHdlIGRvbid0IHF1ZXJ5IHRoZSB2ZXJzaW9ucywgYnVpbGQgaW5mbywgYXR0cmlidXRl
cywgYW5kIGV0Yy7CoCBCZWNhdXNlIGl0J3MNCj4gaW1wb3J0YW50IHRvIGtub3cgaXRzIHZlcnNp
b24vYXR0cmlidXRlcywgY2FuIHdlIHF1ZXJ5IGFuZCBwcmludCB0aGVtDQo+IGFzIGJlZm9yZT8g
TWF5YmUgd2l0aCBhbm90aGVyIHBhdGguDQo+IEluIGxvbmcgdGVybSwgdGhvc2UgaW5mbyB3b3Vs
ZCBiZSBleHBvcnRlZCB2aWEgc3lzZnMsIHRob3VnaC4NCg0KSSBhbSBwbGFubmluZyB0byBkbyAv
c3lzZnMgc29vbiAobm90IGxvbmcgdGVybSkgYWZ0ZXIgdGhlIGJhc2ljIFREWA0KZnVuY3Rpb25h
bGl0eSBpcyBtZXJnZWQuICBUaGUgVERYIGd1ZXN0IHNpZGUgYWxzbyBoYXMgc3VjaCByZXF1aXJl
bWVudCBzbyB3ZSBjYW4NCmRvIGl0IHRvZ2V0aGVyLg0K

