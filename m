Return-Path: <kvm+bounces-168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8CD67DC8EB
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:03:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C8B4281549
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116EC134DB;
	Tue, 31 Oct 2023 09:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kJx1bR8C"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3CC134A2
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:03:28 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F62F91;
	Tue, 31 Oct 2023 02:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698743007; x=1730279007;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EGNgA94oXAw09RVBKtnA0YU9qgZQ1tBWJ2ac+m8Ipsw=;
  b=kJx1bR8CwES67RYFanpm0ngX8tjUWdulUdq/Czg64ZFzgv3ZKbPV5DFb
   G+YRBmE7bpn/04mz7vQ3JTajngFy8eAI8xIC6TSKB82wWa9sARQONX2Ez
   pWvd4bqyP3T8k6cYLiSZOGvVsP/51kois8E2LSkFWg58yUPd6ov2v2sd/
   mXfcUwAvpT+P+mSu/+nKztqj+6VmkI7n+lX9GpRkEQQmKCQ1FqmJMRiVJ
   MzPtBSuHvaUs2uu3XVSdDlaf7rtICQhUypiRu+nN6dr58C3rAFTaPd8BM
   jwr/b1Ck/bmHxdVSaNvdaqxS1LQgwkjHETKaLlkVHgE5/qPV1Txa68K/J
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="419355714"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="419355714"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 02:03:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="934040951"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="934040951"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2023 02:03:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 02:03:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 31 Oct 2023 02:03:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 31 Oct 2023 02:03:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEvmwmKFeDMOT9VK7Chojdwd/8n19d7M8E6kPtVVbBkwz3+hqKxfXQ+inxA94b4BYd6Qv2j5ekf5FQaga3FUDNco5b/XPsB4z1gii0TUFdiHFzw60TuiLtCi6sfeWAcHLV0JOXOT7KjfC1lrjnaUI+lSaIhAzDKTcZjQ/11Y8Cc/RIvvXnvjWfYemaKtMpSsnrgDhL4oAw8FDqPAVJUJ7QbkXMhRS6xTyVYgSmEsAjX/pawrnHZjfxU3MooXsDBWWL+D0XPeigmwt1/eeg66HkgH/xxL9qQnIpRwdwuQcaC/BcC2bair5/DrXlwyuYLC86fXwm2nU7/BJAv1HZ1ozQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGNgA94oXAw09RVBKtnA0YU9qgZQ1tBWJ2ac+m8Ipsw=;
 b=WOhWBLr4RLcypgHryUn+EkM1CK799TzFstjjNPFwgB4JCKFv5DULY9lxYykHELvWoDh6vFca7j+clZpKo1ZrXI12T0fSPgAyL+xl5gVD8iK560v+59u+JNJRn45NnzeN6HaD1v2nne1C3VLDnQbO80MNdNXomhb1Tu9+hQD/vsFsWgwHFHXyEszrqkh2OPsg7CiblRF8ETSAQ/tqVQOUGCb6ReDgE/7E0MvLhnwMbIISAjS5i8MGxmZIQH74Es8c0Ag6Qe+kpNkY4FfG+OfGLWA7wdrj5bXztt9RGDX2eq0o4LB9olpt3P+EG1S1SMtyVTbgtylTQ3dyEyyjIYo1PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by DS7PR11MB6013.namprd11.prod.outlook.com (2603:10b6:8:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Tue, 31 Oct
 2023 09:03:23 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::64e:c72b:e390:6248]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::64e:c72b:e390:6248%7]) with mapi id 15.20.6933.027; Tue, 31 Oct 2023
 09:03:23 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"xin@zytor.com" <xin@zytor.com>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "Christopherson,, Sean"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v3 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Topic: [PATCH v3 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Index: AQHaC4qIl4qggoTYS0eBXdgT5AVuvLBjmxgA
Date: Tue, 31 Oct 2023 09:03:22 +0000
Message-ID: <2158ef3c5ce2de96c970b49802b7e1dba8b704d6.camel@intel.com>
References: <20231030233940.438233-1-xin@zytor.com>
In-Reply-To: <20231030233940.438233-1-xin@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|DS7PR11MB6013:EE_
x-ms-office365-filtering-correlation-id: 9eb3c3ab-fa18-40e8-8c0f-08dbd9f03c40
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ad8PbdAQc5ZoPiNsVvQw3NBKfpEIVIBF505QBUDaQh9O09lU0u/qgU02scsbpNckVflfZsNl4qGLigcvHx7QrHFaZVjdjZ/YOj7DJscrsg3gVxjhbMF/6iwZVHzCF1dBDR1R9HGlTCjlEDT1KYn5PvSymtpCtjXNSiXRVSdSZTAAudtR9YOqBdkBFXCze8i4pWOI+LtsT7G7csEX2HZnp3RF7C/YzKa4ZrtpsgbEMqK/WFo6JhKAjBpqQin/bYcPgrrRvF5QcignK939DZJrH0q5JNAYCCyYGIGZNOaLJeK/Ggfo/TIzZUqoyIFj99YfFUUDg2kBzgY+qTWOyj4zBg+1iq2fR3W+vxg2orA12wDz0hQlzffBu7zZQGkZNqvgQKfjEQALcZvxgpflqaS2i/2gMnDxPyJ3MtIFisYOut0mfpO7N/KYHk3rAx3tdabFaq530GoGQjfHPG5w4OMp0vDhsz2lXTTbRICxuoz8zlKyhcYaipyzAnW3BHAUFDPm5+25dhcXpz2YvnI2LEbhJHl9ulVp0lP9H/TAcm1YsJxIh19o9zx8qRwo1BxmThUERKfRKsKX3iMeko6zJY1eOzO51fl+aUrqYgFceLifXPcNB6I445hFbVXLxqUw9AFe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(376002)(136003)(39860400002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(54906003)(36756003)(2906002)(4001150100001)(5660300002)(7416002)(26005)(66556008)(8936002)(122000001)(4326008)(38070700009)(38100700002)(82960400001)(41300700001)(8676002)(316002)(66946007)(64756008)(76116006)(110136005)(91956017)(2616005)(478600001)(6512007)(71200400001)(66446008)(6486002)(66476007)(86362001)(6506007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajRqQkhtMi9vemMwN0QrZDZ6QUJhV1VmWEJYWUhzM2RCY0FmbWtpVEhsbG5T?=
 =?utf-8?B?Z0NEUjc3dGZsOGYxMWhiKzRManFxYUF2eVpadU9iR002UzhtS1RWRjZSMG0y?=
 =?utf-8?B?OTlKSm8xOXA3aDJEOTJTdnJYeGh2YUNTMjNSdjhqcjZ5T3J0eE05UjZ2UzBI?=
 =?utf-8?B?NEcrS3d1eFBsQy9kdkZyaUZJM1k2WGlKWW9ELy85U2tYOVNiNGgxeXJtRTlm?=
 =?utf-8?B?cVFuc1lkWHRvNW56ak44UG5MMXdLVnVJZXc3bmhOb1d4cklEbGRnTjYwU0ZU?=
 =?utf-8?B?UGNmQ2x4OWpETjJ1aVZDUlNSK20rUFBadGZ0bUViSXdPcERRV2htem5paDVF?=
 =?utf-8?B?WVdac2M4OEJwL0ZHSjB0SS93N0wvM3cxdVFrbXNHV29pUFNSdVhWdDNWSS81?=
 =?utf-8?B?N2QzaSswNVkvWW5DMis1ZWVkcWhMbXBwT2J0SWtodEw5a0JITkdwVkhiTkFp?=
 =?utf-8?B?VmhUVnZxUzZ1Y00wS0FUVVowN2ttWmxOSmZod3RLUjIzWWpmc21WTlZDODI3?=
 =?utf-8?B?MEZXTDNJNDVhRlorWVJXbWUzWVZTc2RhT3FXR3dFd29VQ01NL1cwczFwOHJV?=
 =?utf-8?B?bWxIR3EzRmh0UU5YZlI3R1dJSGs0Ym1OVHBpNEpjUVM4WXQ1K1o0cWdqOVBp?=
 =?utf-8?B?a1dpTHJ1Y0hXZFAxeXNqaEh3ZGQ4SUVjRU1aa0RLdmdBU2x6UVZYVWwyUTFF?=
 =?utf-8?B?a29YNFprYjNCWVlCVytxQUxJSVNuRlBOeG84RDAzTWNiNFFTZ296V3NKa0ZL?=
 =?utf-8?B?SEJlMTBFUkM2aklKQWRwT01FWDdCVXlodythemJZMFQ4ZER1Y3A5akM4enpH?=
 =?utf-8?B?SUZIblQ4VWpZMEIxQkVLdXRocWRzUDlwNEpjcWN2OHdxMGZDUXdMd1FpcjB4?=
 =?utf-8?B?aGF5MWRlSTJtamVIMU5WbjZRTU1kL1QzUDI0SDdFSkZiZ1dyc1FPMGF1Z2Mw?=
 =?utf-8?B?aWRXelEwZE5zVGJmbys2RjFYcWttUS9vc3F0S1BON3ByNG84NXFsZmRFMGFj?=
 =?utf-8?B?bTRZTUY5UHRIbDA3NnIwbFdpK2xNaE0vMEhMbnd6dkRmcit0dDd4dVJlQmRT?=
 =?utf-8?B?Q09EcnVvQVpUTS9SQUFWcnNQTWxKaVczVkxmMmhkS0xoWDRMYzd4dFVuRUhl?=
 =?utf-8?B?dnZrcXdyTVE2b213cTczTVpmNUoyNnQwZkk3NFV1bGF5Q3Q0ejhqUnQ1VXhH?=
 =?utf-8?B?cUdGSURzWG5VVW5jMENYODd4ZG5kVXdkaitYQ3p4L1VWdE5xeHR1SS9vaExC?=
 =?utf-8?B?NmtkZUx0RXBDdTFWWXlTMjlDanc3TUNKV3RPZHlyWk9ycEY1clNCK0JxL1kz?=
 =?utf-8?B?OEFYVTRXTTFlYzJCQUVwVFl0cHBpd2lnQzR1Ny9FYzcyRit6bnRNUWFnRlNV?=
 =?utf-8?B?YnVYK2p1em4yU2NEZS8ra1J2dU91Zmk5c1hOS2NYQUdGTVFXOTBvOGJjY0RG?=
 =?utf-8?B?Y25ORWlKOEZvMkxYdXBpcEhLejBCUUttYWpQSXdwMXcxRmV3WUh5NkVZcGJv?=
 =?utf-8?B?N1RVeFM3dUt5dUMyOGU2R0owVElZZ09UUVZha0h0eXBXOXl1QkRoNmFVTzIv?=
 =?utf-8?B?akNENGRSWTZvYW9HaVBkTEFUWkNhNTEvSndOakdWRHkvZzlZU2cxYnV5bmFh?=
 =?utf-8?B?a3U3Qk1BTzlhY0x6dWRqbUNUZjdjUmpndlpmWFNZSTZtOFFJZ2NJV2k1V1N3?=
 =?utf-8?B?MWNSY2J5SnFzRWY0MThocXpKS1ZXcXFiSTlEOThZSmlGYTZlV1dRa3dLdkxW?=
 =?utf-8?B?UkFyNlFvNUhKL3NhUVZRbUZSVCtUNVR2TE9SSEV3K202OSsxTzhBVUo4K2Zl?=
 =?utf-8?B?N1RlWVFDa3o1Q050Q1FnT2RDd2wxUGFyanFlVFYvcGFIcGNMZEpjRG1BYmhX?=
 =?utf-8?B?d2FPM0ZrNGRsRnZFMnNQSFNLeHRqUUxNdytjT1BWWW53VEZXMlk1dVowTGZt?=
 =?utf-8?B?WkV4eTdLSkNmN2syVFNXbnFMTFh6VTh4L1VKOWNxSHlkeGd3dzRjSTNlcTVa?=
 =?utf-8?B?VlRGSzFlNDlKZWNlL3gxc2ZoajcvajFFdURtdXlWdElSK2VTdHgrT2phcHc3?=
 =?utf-8?B?dXdUSXA4VlhUU1JEL3lwbFFGaXh2a1ErRHZqU0tCamx4MFJiRlBBQ0U2ckRt?=
 =?utf-8?B?ZEJzS01NUHpyL3Fod05yVjg0dGN4TnhhWktJYnlOamhyL3ZHaEVTQitZcHlL?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FAA1EA6D6FF894C8BC323757E9ED365@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb3c3ab-fa18-40e8-8c0f-08dbd9f03c40
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2023 09:03:22.9005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bhH1MhSQd2g8CjQhasc37hCC11R0wnwzp1A+2H4fne6W592cFj60pX9VlhjpsDsno/8LEkHu/DnvK4vgURvZcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6013
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTEwLTMwIGF0IDE2OjM5IC0wNzAwLCBYaW4gTGkgKEludGVsKSB3cm90ZToN
Cj4gRnJvbTogWGluIExpIDx4aW4zLmxpQGludGVsLmNvbT4NCj4gDQo+IERlZmluZSBWTVggYmFz
aWMgaW5mb3JtYXRpb24gZmllbGRzIHdpdGggQklUX1VMTCgpL0dFTk1BU0tfVUxMKCksIGFuZA0K
PiByZXBsYWNlIGhhcmRjb2RlZCBWTVggYmFzaWMgbnVtYmVycyB3aXRoIHRoZXNlIGZpZWxkIG1h
Y3Jvcy4NCj4gDQo+IFBlciBTZWFuJ3MgYXNrLCBzYXZlIHRoZSBmdWxsL3JhdyB2YWx1ZSBvZiBN
U1JfSUEzMl9WTVhfQkFTSUMgaW4gdGhlDQo+IGdsb2JhbCB2bWNzX2NvbmZpZyBhcyB0eXBlIHU2
NCB0byBnZXQgcmlkIG9mIHRoZSBoaS9sbyBjcnVkLCBhbmQgdGhlbg0KPiB1c2UgVk1YX0JBU0lD
IGhlbHBlcnMgdG8gZXh0cmFjdCBpbmZvIGFzIG5lZWRlZC4NCj4gDQoNClsuLi5dDQoNCkJ0dywg
aXQncyBiZXR0ZXIgdG8gaGF2ZSBhIGNvdmVyIGxldHRlciBldmVuIGZvciB0aGlzIHNtYWxsIHNl
cmllcyBhbmQgZ2l2ZSBhDQpsb3JlIGxpbmsgZm9yIG9sZCB2ZXJzaW9ucyBzbyB0aGF0IHBlb3Bs
ZSBjYW4gZWFzaWx5IGZpbmQgb2xkIGRpc2N1c3Npb25zLg0KDQo+ICANCj4gKy8qIHg4NiBtZW1v
cnkgdHlwZXMsIGV4cGxpY2l0bHkgdXNlZCBpbiBWTVggb25seSAqLw0KPiArI2RlZmluZSBNRU1f
VFlQRV9XQgkJCQkweDZVTEwNCj4gKyNkZWZpbmUgTUVNX1RZUEVfVUMJCQkJMHgwVUxMDQoNClRo
ZSByZW5hbWluZyBvZiBtZW1vcnkgdHlwZSBtYWNyb3MgZGVzZXJ2ZXMgc29tZSBqdXN0aWZpY2F0
aW9uIGluIHRoZSBjaGFuZ2Vsb2cNCklNSE8sIGJlY2F1c2UgaXQgZG9lc24ndCBiZWxvbmcgdG8g
d2hhdCB0aGUgcGF0Y2ggdGl0bGUgY2xhaW1zIHRvIGRvLg0KDQpZb3UgY2FuIGV2ZW4gc3BsaXQg
dGhpcyBwYXJ0IG91dCwgYnV0IHdpbGwgbGVhdmUgdG8gU2Vhbi9QYW9sby4NCg0KPiArDQo+ICsv
KiBWTVhfQkFTSUMgYml0cyBhbmQgYml0bWFza3MgKi8NCj4gKyNkZWZpbmUgVk1YX0JBU0lDXzMy
QklUX1BIWVNfQUREUl9PTkxZCQlCSVRfVUxMKDQ4KQ0KPiArI2RlZmluZSBWTVhfQkFTSUNfSU5P
VVQJCQkJQklUX1VMTCg1NCkNCj4gKw0KPiAgI2RlZmluZSBWTVhfTUlTQ19QUkVFTVBUSU9OX1RJ
TUVSX1JBVEVfTUFTSwkweDAwMDAwMDFmDQo+ICAjZGVmaW5lIFZNWF9NSVNDX1NBVkVfRUZFUl9M
TUEJCQkweDAwMDAwMDIwDQo+ICAjZGVmaW5lIFZNWF9NSVNDX0FDVElWSVRZX0hMVAkJCTB4MDAw
MDAwNDANCj4gQEAgLTE0Myw2ICsxNTEsMTYgQEAgc3RhdGljIGlubGluZSB1MzIgdm14X2Jhc2lj
X3ZtY3Nfc2l6ZSh1NjQgdm14X2Jhc2ljKQ0KPiAgCXJldHVybiAodm14X2Jhc2ljICYgR0VOTUFT
S19VTEwoNDQsIDMyKSkgPj4gMzI7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBpbmxpbmUgdTMyIHZt
eF9iYXNpY192bWNzX2Jhc2ljX2NhcCh1NjQgdm14X2Jhc2ljKQ0KPiArew0KPiArCXJldHVybiAo
dm14X2Jhc2ljICYgR0VOTUFTS19VTEwoNjMsIDQ1KSkgPj4gMzI7DQo+ICt9DQoNCklzIHRoaXMg
c3RpbGwgbmVlZGVkPw0KDQo+ICsNCj4gK3N0YXRpYyBpbmxpbmUgdTMyIHZteF9iYXNpY192bWNz
X21lbV90eXBlKHU2NCB2bXhfYmFzaWMpDQo+ICt7DQo+ICsJcmV0dXJuICh2bXhfYmFzaWMgJiBH
RU5NQVNLX1VMTCg1MywgNTApKSA+PiA1MDsNCj4gK30NCg0KWW91IGFscmVhZHkgaGF2ZSBWTVhf
QkFTSUNfTUVNX1RZUEVfU0hJRlQgZGVmaW5lZCBiZWxvdywgc28gaXQgbG9va3MgYSBsaXR0bGUN
CmJpdCBvZGQgdG8gc3RpbGwgdXNlIGhhcmQtY29kZWQgdmFsdWVzIGhlcmUuDQoNCkJ1dCBwZXIg
U2VhbiBJIGFncmVlIGl0J3MgcXVpdGUgbm9pc3kgdG8gaGF2ZSBhbGwgdGhlc2UgX1NISUZUIGRl
ZmluZWQganVzdCBpbg0Kb3JkZXIgdG8gZ2V0IHJpZCBvZiB0aGVzZSBoYXJkLWNvZGVkIHZhbHVl
cy4NCg0KSG93IGFib3V0LCAuLi4NCg0KPiArI2RlZmluZSBWTVhfQkFTSUNfVk1DU19TSVpFX1NI
SUZUCQkzMg0KPiArI2RlZmluZSBWTVhfQkFTSUNfRFVBTF9NT05JVE9SX1RSRUFUTUVOVAlCSVRf
VUxMKDQ5KQ0KPiArI2RlZmluZSBWTVhfQkFTSUNfTUVNX1RZUEVfU0hJRlQJCTUwDQo+ICsjZGVm
aW5lIFZNWF9CQVNJQ19UUlVFX0NUTFMJCQlCSVRfVUxMKDU1KQ0KPiArDQo+IA0KDQouLi4gc2lu
Y2UsIGlmIEkgYW0gcmVhZGluZyBjb3JyZWN0bHksIHRoZSB0d28gX1NISUZUIGFib3ZlIGFyZSBv
bmx5IHVzZWQgLi4uDQoNClsuLi5dDQoNCj4gQEAgLTY5NjQsNyArNjk3NSw3IEBAIHN0YXRpYyB2
b2lkIG5lc3RlZF92bXhfc2V0dXBfYmFzaWMoc3RydWN0IG5lc3RlZF92bXhfbXNycyAqbXNycykN
Cj4gIAkJVk1DUzEyX1JFVklTSU9OIHwNCj4gIAkJVk1YX0JBU0lDX1RSVUVfQ1RMUyB8DQo+ICAJ
CSgodTY0KVZNQ1MxMl9TSVpFIDw8IFZNWF9CQVNJQ19WTUNTX1NJWkVfU0hJRlQpIHwNCj4gLQkJ
KFZNWF9CQVNJQ19NRU1fVFlQRV9XQiA8PCBWTVhfQkFTSUNfTUVNX1RZUEVfU0hJRlQpOw0KPiAr
CQkoTUVNX1RZUEVfV0IgPDwgVk1YX0JBU0lDX01FTV9UWVBFX1NISUZUKTsNCj4gIA0KDQouLi4g
aGVyZSwgd2UgY2FuIHJlbW92ZSB0aGUgdHdvIF9TSElGVCBidXQgZGVmaW5lIGJlbG93IGluc3Rl
YWQ6DQoNCiAgI2RlZmluZSBWTVhfQkFTSUNfVk1DUzEyX1NJWkUJKCh1NjQpVk1DUzEyX1NJWkUg
PDwgMzIpDQogICNkZWZpbmUgVk1YX0JBU0lDX01FTV9UWVBFX1dCCShNRU1fVFlQRV9XQiA8PCA1
MCkNCg0KQW5kIHVzZSBhYm92ZSB0d28gbWFjcm9zIGluIG5lc3RlZF92bXhfc2V0dXBfYmFzaWMo
KT8NCg==

