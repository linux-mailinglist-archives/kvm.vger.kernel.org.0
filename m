Return-Path: <kvm+bounces-2527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB6E7FAAD6
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 21:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7C0E1C20B9C
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 20:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4BD45977;
	Mon, 27 Nov 2023 20:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QjiTi9BU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44A8B8;
	Mon, 27 Nov 2023 12:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701115368; x=1732651368;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=asx1t0PJy6V321RhBrezsfJM2c+S+x2usuEIdEtHx10=;
  b=QjiTi9BUF4e22MSolePEmzQYMWUS3mT5VhA2LILTnjr6L0EDQxQz9O1K
   6Lzgwwd4nTyFW6OdF6YK43XyBL0pp8AO0xEVaiUvF3FxzdDoZpFxkjKM8
   g3JrdDqxzuYbGyH1riU54H6UL4pTPr91mvtJmtPG2PT8vag4hNSPqHzqP
   c2DcRu+gF8bRhH6Vqgxe1UyRbD7SQTX9y460V4SlFt9yXg4EJuApHCi73
   O6GZ15LgHcHtzk3HaEybwbLdTlFUL+RDI8DZUXgiTu11jOV5Bc/fVfvnr
   t625Wojyc3TLvEZCnUMtp1C2qt1Kne61Le2MjL/1QpCR7UspQTGIoLKYa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="459280769"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="459280769"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 12:02:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="797342655"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="797342655"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 12:02:47 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 12:02:47 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 12:02:46 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 12:02:46 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 12:02:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPh2kLCnfWa32kKUZhHMW95S4+lSnjgB1Ca9dCVLaEbDJOl8B1LnOqS/1q8Okghc4Dg7oXyGQfvhoBFpMSRfi+5SanSZ7wLpVVCpRCdSoXM4K+wSEsoA0VWBoaDpOyQYcOfLFoo8w1mJnFb8+M77oC4rIe53i87wcAkjW7P0ejfw0b7QYKEjClQ2nZ5/XcS5ZJ1UeITqZcAN1PZYvbMvnCsTRlmWg0rahR5Be57ojkEdif7P6F+cC8ZkccqY8qCuad1CYjUZ7EIktXEBhRv4XnDtaivhBtC2vW92eMHsuICQZQnYlCQTEh5aQCM0BSgqsYn6ruQXNI2WgXFm3A3zhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=asx1t0PJy6V321RhBrezsfJM2c+S+x2usuEIdEtHx10=;
 b=cZ23J7PLtVeKczch0SSxANVZOAqihrHGzVsCPlk1MT/0In9HpcuwQh2nkT8WEFZLRv5r5tpiSTMgi3I5+4mFjiV0cdhjeoaMfasgevpm+1jI/0jSWvuLQRvL8L4J0PX33wHAKYjs2Phv7DbT7or+TM1WcXsYxbS7wnXVkE3a91FZtnmYcg/pM0iVB4/Zp7Md6XEzOVwUOvl1FLPz/rbtXvLP88+DtritTK4mvNllXypd5amrK2qP0H5Ig2yRgC3Mfsgwrn7s++mwtBtiLhdakHC8MJH9xKHPzw/hSIfw1K/XjFqsW1JsFWUvsvdEu9ybDPupepQsRzjQyaZRsQuuAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7334.namprd11.prod.outlook.com (2603:10b6:8:11d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28; Mon, 27 Nov
 2023 20:02:42 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 20:02:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "Luck, Tony" <tony.luck@intel.com>, "david@redhat.com"
	<david@redhat.com>, "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
	"ak@linux.intel.com" <ak@linux.intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>, "sagis@google.com"
	<sagis@google.com>, "imammedo@redhat.com" <imammedo@redhat.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"Brown, Len" <len.brown@intel.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Huang, Ying"
	<ying.huang@intel.com>, "rafael@kernel.org" <rafael@kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>
Subject: Re: [PATCH v15 17/23] x86/kexec: Flush cache of TDX private memory
Thread-Topic: [PATCH v15 17/23] x86/kexec: Flush cache of TDX private memory
Thread-Index: AQHaEwHp2HWZl9Al5EWrZJMGp6I1arCOlOeAgAAWWQCAAAgUgA==
Date: Mon, 27 Nov 2023 20:02:42 +0000
Message-ID: <97340f5746343d3b6d0a990b3e52cb2dcb5f0074.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <2151c68079c1cb837d07bd8015e4ff1f662e1a6e.1699527082.git.kai.huang@intel.com>
	 <cfea7192-4b29-46f9-a500-149121f493c8@intel.com>
	 <e8fd4bff8244e9e709c997da309e73a932567959.camel@intel.com>
In-Reply-To: <e8fd4bff8244e9e709c997da309e73a932567959.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7334:EE_
x-ms-office365-filtering-correlation-id: b24c018c-70ed-4a7e-49dd-08dbef83d08d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /bhoVXttCKf6ub68CWGdAlzzjTLGkkQWCuShfW2hh4YOxrldlvtjKEKLtANJwUa9pekDaCciNk/Q7QmaOAb8KsTJsa52EZzd4KKKUS2cHPU+5w5Pb3BKfCRxwp2t3yMvnzb0SSBE5gIVanolFd7cEqCAej1eBGtK/MDaTd8dyFCR17E6xZwJH1GX570WRmQpWZQJylNtZxQ3Mzn4kMrImj25fRxYcX8+WN1KMKRX/p8lUwbog97/wxd3bBpRGhVlUK+v/SIk23xow88lsLtIT19XT6QOXd7j+2k1MGpSPsmXYBfszR+wXErNR3DElAgoXW8fUOEcBgJeW17uiGIT4lCCf0UcwV0TYvctAH0PR8g2+dDp+TbXFO+lJTmlxIVvXA8k4OttzQvEyHsw2hsHQE0EwGNiDQpqQsY6pLejUqrHDXKpenCtpTzFx5d9RSDYGcou3NmCyQmHO9TPChQJEoifMObdcU29qh6ILjvfWY/NQ8vsvX83QZEVn/qjOWZa/8MqVQN2Y+5AkkzcPf7X1FlF5wOPOBsXrYj1NwGIhGZvK41zgkvAnL5M3brGegzXpkDDW2A58Yl4/kjyJqeL3R/m5Hh+P2yVYyZzWhaSRXpuPPVz1ZxSwYcovbT00app
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(376002)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(5660300002)(7416002)(2906002)(86362001)(71200400001)(478600001)(2616005)(53546011)(26005)(122000001)(6512007)(316002)(64756008)(66446008)(54906003)(66946007)(66476007)(8676002)(4326008)(36756003)(76116006)(8936002)(66556008)(6486002)(110136005)(91956017)(6506007)(38100700002)(82960400001)(38070700009)(4001150100001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1ZkQ1BrazlCMWk1RWtnaHV3VktDSzBXQUM2WmRPVmlXWGJtRlQ1MWZFaG9M?=
 =?utf-8?B?bHR0Y3pGMjFtVnFBY3VnZTFhL0V5cy9XcFZ5dG1lVTQ2STYyVC9HaDdaMlBR?=
 =?utf-8?B?SEpHVURvN3dxUGZ6QXpPYks3OGkvOStScXBSRlJacDVGZ0Y0NVREYzF3TUlT?=
 =?utf-8?B?Q01OR2tGNVNCUXJ4eEp1WUlxSWRqRWJrbnFBNjVhNEpCYzgzRGkzNytHdVBk?=
 =?utf-8?B?TUttdW9FT1c5cE5IaGJGbEpQZzhaRGhqYjAvbDVSWUppSW5uR3hkS3p1czBV?=
 =?utf-8?B?OXgrK2dJeDZsOGE5dGdCNDY2VndXeDh2cEZGRThKL0RNL0JYOWpIay9sWDM4?=
 =?utf-8?B?ZDczL1hXZVlOaXduMDJPcUt2bWJvOFpZRnRvTXAycnhQbVBWaStvcW1WUlFB?=
 =?utf-8?B?Z2NYenZEd3NmUkY0U0p0QUVEdWtUNjVKYlI5RlI4SXpYUjhsdndUczhXWWoz?=
 =?utf-8?B?TFRZZXNkQlk2Mk82dUhRTHIyTDA5dFpDWW1nVmtaSHVWVzVmUWVnSi9zZzlR?=
 =?utf-8?B?K2JaUEpuZE5YN1FHUkt4VWFXb2Ric3dLRlJHaTNYWW9iU3JUQlRtbXdTNDNr?=
 =?utf-8?B?WisvbHZMOEhFSGdObFhVUW9sY21IVGVEYVdPY2tLR1FvdFp1bE5Zd3h4bkF2?=
 =?utf-8?B?aHFMdnU4cjBaUTRxYVpLaEpSZWdteGV4eFd4dksxZlIvWENpaGY3Z09RbUw4?=
 =?utf-8?B?R0h3SG5hUFVHWVFmQmR2b1BIMm4rUGpzZjVvbTlCTmZxVUtJZTZwSURNSThu?=
 =?utf-8?B?cG5zcUN5TFlRVHNrT283UXdQV3dNRVlLWFlmbTNodkFuSGN1RjRTdko0L04z?=
 =?utf-8?B?SWdsaVRIMHhyazBHdkQycDZ5VGRjSHU5cnRxU3hnNkY2WTBqb2w5NUZwTm80?=
 =?utf-8?B?Z0NXL1ZON2R4WDZ3bVpjbEUwRWV4UlQ3czFKYWNoSGxZZUFpMDZHWit6ZWgy?=
 =?utf-8?B?MlF1TnMwMnRXTDFXSnZVbXIzSHp4L01LR0F6akFoOS9ldzQ2N04zZHN4d2hw?=
 =?utf-8?B?enVpQlFtTHhmSXNvdXlOYmQ3M2IybXprYTkrUk96M0JLNEI3U2UxSW5ZRitY?=
 =?utf-8?B?eTVQM1ZZSnRlcDVERzZ5NWFxMmxkOC9xblBhc1h4V21QWmcyUHd1K2IxZ3da?=
 =?utf-8?B?UHZGYjJNSVFWUDFsOWRRSWxJUjFjRTI4QXhLTDVUUSszUXJqS1FIUzhyajYv?=
 =?utf-8?B?UFhyNVR5MkdlT3ZueEJ0WG9mWDlnVElvZHJ2RFpXWFREdW1FMkt1UzhtVXlh?=
 =?utf-8?B?RFBYeW5oSVIyWEg4UWl0K3pEZlloanBOVlJRRDlHcFNhZnFPZngwWkwwVE92?=
 =?utf-8?B?S29lbHBhdU9WVzF1eG5GbmNrSzVqWGZ4UHozZGdzVHV3dzJOZ1RNUTBSalNw?=
 =?utf-8?B?MklrWnJXL1lnUDhpV0ZNVHYvNkdZWklzandxc1F1eDU1L2xQa084Q21iMGMw?=
 =?utf-8?B?UmhLd3dEQW92L1ZSbE9TM0NSUGJVaTNEdjE0eWh6dEdvdEtIUjRlR0tJaXRF?=
 =?utf-8?B?Ni84OFVkbTVUNkF3RE0yVXRCTnBQa3lhZWZwTGZwNHhvU1dGbkZKdGkwNEtB?=
 =?utf-8?B?bTkxRjRJV3dwQXpIS1U3Z3k3T1N6SGVTYlhZSEdUZnRTaEZsekhNSG5xa3lH?=
 =?utf-8?B?R0JzQTFBZWw2cVArWGQ5dkt5NTRVeURrUUR6SUZJMHhRdXJZVWhOSFVkWTd2?=
 =?utf-8?B?ZHdsTTJkM25RRDB0WllBUXRUK2ZxcFQ5aU1VTlhscHQ5c2ZZbXM5NmxmczJO?=
 =?utf-8?B?TEV3TkxJYVRjS29GWlRsM0dld1RKT0RmNjJaUGVyTFBQKzVERVNDa2dWQS9z?=
 =?utf-8?B?NjBvWithZGVGZGdvUUdWSTR1WnI1S25YOHJkQjB5UmlZbVdMdGE5VWg4cVVD?=
 =?utf-8?B?dGswR3FKcThHZHluR0hMWWQ1U3J3N0FHNSsrdThSbzNYUFBZaXErckNZNFRS?=
 =?utf-8?B?RlR6dHRUdUNFOStRRitrbU5QQUl6K01rYklmbVRaSHZHRnpmeGo5cXJyNklv?=
 =?utf-8?B?OFQva0RJc2xvTEpFd3NEQWsrRG4rdStWaXM4RVlSYVZ4TXNpUXJjZVRMdVpU?=
 =?utf-8?B?VzZhSzdFSFVHWm81SGUrWFJnbU9OZnVMWHc1S0R5UzN3Z01LbDh5Z3BlK0hk?=
 =?utf-8?B?ZVh4QUpKTVg3Tkg4SzN5Z01Ddit5bUNxZ2lyV0hTNWtxTkdhUEFyQThzYmpO?=
 =?utf-8?B?clE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <16A0468B01E9C9418265BC7E7639B4C7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b24c018c-70ed-4a7e-49dd-08dbef83d08d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2023 20:02:42.1414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MeKOMz79Uinr3wJR5F0VEfd78dUIyrIZgRLz7NZ36KJdacb2wyQ6XGpExTYXlyGCo/VVpUrrT1Et2dppTi6+RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7334
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTExLTI3IGF0IDE5OjMzICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBNb24sIDIwMjMtMTEtMjcgYXQgMTA6MTMgLTA4MDAsIEhhbnNlbiwgRGF2ZSB3cm90ZToNCj4g
PiBPbiAxMS85LzIzIDAzOjU1LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gLi4uDQo+ID4gPiAtLS0g
YS9hcmNoL3g4Ni9rZXJuZWwvcmVib290LmMNCj4gPiA+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9y
ZWJvb3QuYw0KPiA+ID4gQEAgLTMxLDYgKzMxLDcgQEANCj4gPiA+ICAjaW5jbHVkZSA8YXNtL3Jl
YWxtb2RlLmg+DQo+ID4gPiAgI2luY2x1ZGUgPGFzbS94ODZfaW5pdC5oPg0KPiA+ID4gICNpbmNs
dWRlIDxhc20vZWZpLmg+DQo+ID4gPiArI2luY2x1ZGUgPGFzbS90ZHguaD4NCj4gPiA+ICANCj4g
PiA+ICAvKg0KPiA+ID4gICAqIFBvd2VyIG9mZiBmdW5jdGlvbiwgaWYgYW55DQo+ID4gPiBAQCAt
NzQxLDYgKzc0MiwyMCBAQCB2b2lkIG5hdGl2ZV9tYWNoaW5lX3NodXRkb3duKHZvaWQpDQo+ID4g
PiAgCWxvY2FsX2lycV9kaXNhYmxlKCk7DQo+ID4gPiAgCXN0b3Bfb3RoZXJfY3B1cygpOw0KPiA+
ID4gICNlbmRpZg0KPiA+ID4gKwkvKg0KPiA+ID4gKwkgKiBzdG9wX290aGVyX2NwdXMoKSBoYXMg
Zmx1c2hlZCBhbGwgZGlydHkgY2FjaGVsaW5lcyBvZiBURFgNCj4gPiA+ICsJICogcHJpdmF0ZSBt
ZW1vcnkgb24gcmVtb3RlIGNwdXMuICBVbmxpa2UgU01FLCB3aGljaCBkb2VzIHRoZQ0KPiA+ID4g
KwkgKiBjYWNoZSBmbHVzaCBvbiBfdGhpc18gY3B1IGluIHRoZSByZWxvY2F0ZV9rZXJuZWwoKSwg
Zmx1c2gNCj4gPiA+ICsJICogdGhlIGNhY2hlIGZvciBfdGhpc18gY3B1IGhlcmUuICBUaGlzIGlz
IGJlY2F1c2Ugb24gdGhlDQo+ID4gPiArCSAqIHBsYXRmb3JtcyB3aXRoICJwYXJ0aWFsIHdyaXRl
IG1hY2hpbmUgY2hlY2siIGVycmF0dW0gdGhlDQo+ID4gPiArCSAqIGtlcm5lbCBuZWVkcyB0byBj
b252ZXJ0IGFsbCBURFggcHJpdmF0ZSBwYWdlcyBiYWNrIHRvIG5vcm1hbA0KPiA+ID4gKwkgKiBi
ZWZvcmUgYm9vdGluZyB0byB0aGUgbmV3IGtlcm5lbCBpbiBrZXhlYygpLCBhbmQgdGhlIGNhY2hl
DQo+ID4gPiArCSAqIGZsdXNoIG11c3QgYmUgZG9uZSBiZWZvcmUgdGhhdC4gIElmIHRoZSBrZXJu
ZWwgdG9vayBTTUUncyB3YXksDQo+ID4gPiArCSAqIGl0IHdvdWxkIGhhdmUgdG8gbXVjayB3aXRo
IHRoZSByZWxvY2F0ZV9rZXJuZWwoKSBhc3NlbWJseSB0bw0KPiA+ID4gKwkgKiBkbyBtZW1vcnkg
Y29udmVyc2lvbi4NCj4gPiA+ICsJICovDQo+ID4gPiArCWlmIChwbGF0Zm9ybV90ZHhfZW5hYmxl
ZCgpKQ0KPiA+ID4gKwkJbmF0aXZlX3diaW52ZCgpOw0KPiA+IA0KPiA+IFdoeSBjYW4ndCB0aGUg
VERYIGhvc3QgY29kZSBqdXN0IHNldCBob3N0X21lbV9lbmNfYWN0aXZlPTE/DQo+ID4gDQo+ID4g
U3VyZSwgeW91J2xsIGVuZCB1cCAqdXNpbmcqIHRoZSBTTUUgV0JJTlZEIHN1cHBvcnQsIGJ1dCB0
aGVuIHlvdSBkb24ndA0KPiA+IGhhdmUgdHdvIGRpZmZlcmVudCBXQklOVkQgY2FsbCBzaXRlcy4g
IFlvdSBhbHNvIGRvbid0IGhhdmUgdG8gbWVzcyB3aXRoDQo+ID4gYSBzaW5nbGUgbGluZSBvZiBh
c3NlbWJseS4NCj4gDQo+IEkgd2FudGVkIHRvIGF2b2lkIGNoYW5naW5nIHRoZSBhc3NlbWJseS4N
Cj4gDQo+IFBlcmhhcHMgdGhlIGNvbW1lbnQgaXNuJ3QgdmVyeSBjbGVhci4gIEZsdXNoaW5nIGNh
Y2hlIChvbiB0aGUgQ1BVIHJ1bm5pbmcga2V4ZWMpDQo+IHdoZW4gdGhlIGhvc3RfbWVtX2VuY19h
Y3RpdmU9MSBpcyBoYW5kbGVkIGluIHRoZSByZWxvY2F0ZV9rZXJuZWwoKSBhc3NlbWJseSwNCj4g
d2hpY2ggaGFwcGVucyBhdCB2ZXJ5IGxhdGUgc3RhZ2UgcmlnaHQgYmVmb3JlIGp1bXBpbmcgdG8g
dGhlIG5ldyBrZXJuZWwuIA0KPiBIb3dldmVyIGZvciBURFggd2hlbiB0aGUgcGxhdGZvcm0gaGFz
IGVycmF0dW0gd2UgbmVlZCB0byBjb252ZXJ0IFREWCBwcml2YXRlDQo+IHBhZ2VzIGJhY2sgdG8g
bm9ybWFsLCB3aGljaCBtdXN0IGJlIGRvbmUgYWZ0ZXIgZmx1c2hpbmcgY2FjaGUuICBJZiB3ZSBy
ZXVzZQ0KPiBob3N0X21lbV9lbmNfYWN0aXZlPTEsIHRoZW4gd2Ugd2lsbCBuZWVkIHRvIGNoYW5n
ZSB0aGUgYXNzZW1ibHkgY29kZSB0byBkbyB0aGF0Lg0KPiANCg0KRm9yZ290IHRvIHNheSBkb2lu
ZyBURFggcGFnZSBjb252ZXJzaW9uIGluIHRoZSByZWxvY2F0ZV9hc3NlbWJseSgpIGlzbid0IGVh
c3kNCmJlY2F1c2UgdGhlIGNhY2hlIGZsdXNoaW5nIHdoZW4gaG9zdF9tZW1fZW5jX2FjdGl2ZT0x
IGhhcHBlbnMgYWZ0ZXIga2VybmVsIGhhcw0Kc3dpdGNoZWQgdG8gdGhlIGlkZW50aXR5IG1hcHBp
bmcgdGFibGUsIHNvIHdlIHdpbGwgbmVlZCB0byBkbyBoYWNrcyBsaWtlIGZpeGluZw0KdXAgc3lt
Ym9sIGFkZHJlc3MgZXRjLg0KDQo=

