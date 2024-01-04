Return-Path: <kvm+bounces-5693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8836C824B16
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 23:42:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 301DD283144
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 22:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CD462D043;
	Thu,  4 Jan 2024 22:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AsaaNVNw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D47D2D025;
	Thu,  4 Jan 2024 22:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704408135; x=1735944135;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OcrB8guGGwSsWZwUI74GXlfpyPk4jv2hRh0rE++up4k=;
  b=AsaaNVNwr8pkn39O5TiMbq3NDtbGnA7gUgT2PIrvch9dt0LuKG3ptN36
   oOxARlHxT/sOmzEjUsRzj5Lgz49MWBwZMByomlA89dTM/97NT0Mi8m0AX
   UBl5sfwR0umejIa7+MLLiBvH5HnHZUPQFe2Gb3re9PxNxkMRFZZ5s/JZi
   rPPYPKQMePdPRyp4fX7tf4EzmK+TPYUHvfcrN8dAplgY9VFK1qj0qoc2c
   MaPdqg0W0H4WWtUwW7tvcRdG1fTOK/0J3Hs1EtxQJYjRQSTaz4lj8o8wk
   Q1o+EUzWW6Yj+EFiZEdWK1F3efvXBnWY5974uWzZBZ/gOVJENPjMsaSrC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="4487856"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="4487856"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 14:42:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="15065688"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jan 2024 14:42:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 14:42:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 4 Jan 2024 14:42:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 4 Jan 2024 14:42:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXUnuKMeZUagjvb7aLtl1iaVbFvpfXi8VHx/YtezmQxHzzsJ5UeCOpZwcz3vR9tL6PjmQXAsXWDtzW5pDw16yAUzmVZ5ChiP9LchxbnOk/YOMzvnUCWzPhhsVdyg6O2ULTCZ7B+S9xYRmXilUAFHSTHL3tN9GOLfhOgt6vPXx99yOLE8jaqkOsy9ddaXJVvWwqahO3gS6baD6t4Vh1O80Ck7w/H8ejQK75gHjpdTxH3r/0vSAG5ibEsjWsB4iHrBc+GU3j4H6K5IN7EVVft51DnkHHc/ludlbyb51T3/sc01aQDPMOhlBU8/Icxd74A6Mo7OymJX9EXlJ4T1UVpRcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcrB8guGGwSsWZwUI74GXlfpyPk4jv2hRh0rE++up4k=;
 b=d0tqvrdL3NnIq40p5vhaVaK9Bk9EVEiVh+iejI7khpy5L5ptdnXvOzQ2Gm9kguT5YJoBn5LfBWlRhznOVgbPMVivZ2HpAce5caWdQY4MspHPcKQKkEd9eByviG8A7ouMynXzxW3gmb+6lLlxtgSG8JviW7mSnOqdEPXPjEn77hGLHmaLDur1viekkHnso9+364taXnk6/lilonqKlq07KKK/fLtRrYSTDu3n+ffF2595BBFllnOidk1eOIiOJH1ZTRpmZLb7PVwJwOagQ8/t0tS8oO+K9cyNMWaBghUR0GdHi5sSSufkPPZNTzOeN4pam35sjj6A/aKEsC9LCOf7yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB5944.namprd11.prod.outlook.com (2603:10b6:510:124::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.24; Thu, 4 Jan
 2024 22:42:12 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7135.028; Thu, 4 Jan 2024
 22:42:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "peterz@infradead.org" <peterz@infradead.org>, "Gao, Chao"
	<chao.gao@intel.com>, "john.allen@amd.com" <john.allen@amd.com>
Subject: Re: [PATCH v8 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
Thread-Topic: [PATCH v8 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
Thread-Index: AQHaM+ymiePiHppVrUSHp6wrEOg5IbDHL1IAgAMnVgA=
Date: Thu, 4 Jan 2024 22:42:11 +0000
Message-ID: <e3921caa199b49e81c24f24b2f3a6fe8d0b7d2b7.camel@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <20231221140239.4349-6-weijiang.yang@intel.com>
	 <4ba9edb3f988314637052321d339e41938dfe196.camel@redhat.com>
In-Reply-To: <4ba9edb3f988314637052321d339e41938dfe196.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB5944:EE_
x-ms-office365-filtering-correlation-id: 3dcc3261-7d00-4917-569a-08dc0d766443
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tSQ7p2OuHVWNmkTRff/PjVlc9SHDUT+rspcFTiyaSVpAXQcIc3hZNke6rN94ihV4S24X5MfYxADteNlRirfb1A0AnN6+is4H2B5a4kk28fqoW41ju0DIm4BvN56istDpDjMf84jrJGG2+U2wmH3KxJ+eCgMMQ7glX1eGYQ6D5FWY6uWz7GmZERCp7Hxq4bzpLoXCh+hZ0m7jE3WCqhyaB16MxPI3wfk9cCAd4m30TPh5mjcJAVfRQQFB0PQj5gAinNi8rB3bFVD1Cwgdh830VZYX5pJJ9W1mvX8EIQsPT3zmbLZ5L+BjWyNw5DX98soe2S4oQLby/b6hTwIx6mDZw3uUJLryQmcDJ5UkJlpSLgFFKyFP5IyjRA8w0/w4EwPUagATXirhlXEbz76gzBlPgi79uoNaIzQewUy31JDokD6PDkzWNpnBFATe9O+ZFkrGcgH/PaE8dCViX3c1sq+ab+qA6+MSapLLWJeTGYzmEsi9h5TqDxYgfVOzsd5j7kYtyvcXnnDOsiTY6GeTaF7fI3a4prR1WwJfsToKZOw/T0/dyAYFfmQqeQJEa7dQryem2sparV1N5z5RY9nwD4hI3bX82Z2jwma7g4uu0peMrYg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(478600001)(66946007)(76116006)(54906003)(38100700002)(2906002)(41300700001)(86362001)(558084003)(122000001)(316002)(36756003)(82960400001)(66446008)(8676002)(110136005)(66556008)(66476007)(26005)(5660300002)(64756008)(8936002)(6512007)(2616005)(71200400001)(6506007)(6486002)(4326008)(91956017)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1AzOFlsVnV0RExIblJaNkEzRHR1L0tHQUkxckdBSkRtUkFQNENJNllYSkxo?=
 =?utf-8?B?bHJlLy9TU1BqQng0ZXJ5U2I4dHJXNjRpUkFYSWcvMG9VeERoTjFINGtjRk5q?=
 =?utf-8?B?R21UcnVnb3hzdVVEdW16UndyM0ZQbHoybFE3NmZqdWVuZnQ0UW5Edi90SEdG?=
 =?utf-8?B?aUJITkxOaDJHNjE2NjhjakRLdmN2cEY4RHhaL2lQbERpenJWUk1waG56TU5Y?=
 =?utf-8?B?YUk0ekUrVEtVdmQrazVySkRBd2hnTlZqZ2M3Wjk4VlgwVmpHNmprMDFDRjJY?=
 =?utf-8?B?akpVbWViL00zQ3hmUlhSZXNJYXBUYzVTczB2SWxvaSt1U1Vpc2U2b3dCR0tJ?=
 =?utf-8?B?WERZU0NPYVJ4TW8rbndoSWZSa2dWOHhJRjVWTWs5ZU9YdFYxMFQrdjl0U0Jt?=
 =?utf-8?B?QStiM1l5TnhzZ1E4TGsvem84K0dCRFBwbU4ydHlZdVcxLytMVVBUbVJTNXQ4?=
 =?utf-8?B?emZzK2FYc1VtcEZzYWg3NHpSZWZ1TUJUb3dzT1dDaE1sRFlpaUFLbkU5MjY3?=
 =?utf-8?B?OWZVRnZBaG80Smk2ck5pNkVaRzNCTWUxUXRTT0ZyM0ZKYVVpM0E1VUVXMHJQ?=
 =?utf-8?B?MXAvako4VnFpalFkNEFTWUtpM2ZUZnhNSWY4RUFHYXZSMkdSZ2lUQjdyRlNw?=
 =?utf-8?B?NnZDWEtxdDhHbDIzaEhkeXdIeU9Dbk83YkRCYVdheUNkMVRwY01aejk2bXRw?=
 =?utf-8?B?c3ljUUlrWDBMTHJtWWY3SWNxOXE5d2FOSENaUTV3b2RzU29xekxTRnBZd2FM?=
 =?utf-8?B?bXlxNm1DTkhTMUJrU1VBSUxFOHZNd2hMK0hTdmcwczYreUlTRkQ3WXVtNmt3?=
 =?utf-8?B?SFVRWkpBMUp4TDE3TVhHcUU5SCtyYytqaUtGVDFEWSttRXJhMmcwU1hMZkVS?=
 =?utf-8?B?NzU4aGJsdmFBeWFZaEREckZNSTFaOUhLS3M0dEZmd2ptdGVxbGJBRWY4SUFN?=
 =?utf-8?B?aVkvNzNtN1Z0YjZURzI0aEZYSVlzNEVWSnVnU1VaUktJb29YQnRhWm1QTFlo?=
 =?utf-8?B?dG95YW01Mm53M2dRWnQvNEozS0FUenJyTUI5aFowM09LME5GRUR0ekdJWlNK?=
 =?utf-8?B?ZWtqZDNkdVJKWXV6MmR6SGE1cUxld0VKV3EvT095NkNiZ214eFZrTVpIVzNm?=
 =?utf-8?B?RERERGhUSngzUFJLL0ZqOUhWQit4VmhNc3IwVHF5WjkwbFlMQTZKV2kyRTNn?=
 =?utf-8?B?dnhINFducTVQa1ozRVdSUWUzMzZDOTVLakZpY3lmT25NWlpaakZIaFRIK3Qz?=
 =?utf-8?B?cC90eExYVWF4WUlTRlI0dUZTbHhxVG5PbjhaVWt6VTl0VldjbVhKREFtZlhh?=
 =?utf-8?B?dGZMWC9FbTRCNFVRS2pzNEdTZngxeGpQU2J1cU96dmZnUWovUnBMdjdGTk1t?=
 =?utf-8?B?K2RsNm4vOWMxejcrMjAvVXVWdk1oWDdsYlQ2NHJ0eGVqSXlwblZMQ3lwMThI?=
 =?utf-8?B?cExiWUsydCtOd0Jkd2NodnlUcnFHU0t2U0dabUpMOWF4T1hid3lkOUVDUEFv?=
 =?utf-8?B?ZG1hVmpMbnJpY09sa0xHU1hZV1hkVkdGbmdDQUZJNkI5Q3lyRWFXR1RGQVRT?=
 =?utf-8?B?UGNIT3RHOGZCVGdRVWhNL0dDOWNhSGpHRlVwZ3hDWU5uMEtDRkxDZkJYckVx?=
 =?utf-8?B?RXg0cE9KSHh3RGN0UGlpb3RQcUEwWWo0Q2xlMStzQnQzckdVYU14SkJqTnZG?=
 =?utf-8?B?YUJacnZVb3BjOFFnc0R2UFpMSEt0R2lqOWUrck9YcDJIRzI5RS8yd0JvekxL?=
 =?utf-8?B?ZkRjajV1cXhGcE9ZYTBCNXkrSE1qdW4xMVJBRzI5K3ArSWYxS2o1Zkk2ZTQ0?=
 =?utf-8?B?VDVvWE1yWXJDcDZMMGFoSVdENFltMitsT1Jsa3dmS3hnU2J0UkM0V1RLWGZI?=
 =?utf-8?B?di9JLzllMHluTjAxZmdqdmVYNzVHT2krbitXK29PMWNkRDhlMkpXdEZyOWR3?=
 =?utf-8?B?ZFlYWldzd0o0SlRvNHFlcUZLeWNZN2FFOEtlM082dWRQV3V6R1VpTCswQ1g5?=
 =?utf-8?B?aTRLa3pGVG1HdTFWM0ZKb1hFVlZiV01sMGFuTmU2Y21XL3NrMFFhZDJ6bG1i?=
 =?utf-8?B?dlYya0ZPWVRMZ1QwSGhZaytBd2N3ekpBS2tqQXlEYzNNQ1FzcU1OTGpkckNY?=
 =?utf-8?B?N3lGRWp2R3l6NVVTNDUveXhlaTQxV2VXdGVHbyswcEx4dkNZS1F3Wjg3TG54?=
 =?utf-8?B?ZGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB3D6EEF1CAD9E49861DFE13A02481EE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dcc3261-7d00-4917-569a-08dc0d766443
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2024 22:42:11.9123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MhJr2KBa3E/2lfjHPhuR8eZnqntHbHsbAdbu0xDTApiheuId+yJ6yBN/7e8h+7yySPAcW0aMgRNTdFaJzdSXERTstoHDfLAqxbbNH2QCu+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5944
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAxLTAzIGF0IDAwOjMyICswMjAwLCBNYXhpbSBMZXZpdHNreSB3cm90ZToN
Cj4gQXQgbGVhc3QgdGhpcyBjb21tZW50IHNob3VsZCBub3QgaW5jbHVkZSBleGFtcGxlcyBiZWNh
dXNlIHhmZWF0dXJlcw0KPiBhcmUgc3ViamVjdCB0byBjaGFuZ2UuDQoNCisxIHRvIHRoaXMuDQo=

