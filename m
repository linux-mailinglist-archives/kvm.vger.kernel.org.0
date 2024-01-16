Return-Path: <kvm+bounces-6307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E70482E87E
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 05:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91C271C22AD6
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 04:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F86879FB;
	Tue, 16 Jan 2024 04:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VTl+F0KT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B01D79C1;
	Tue, 16 Jan 2024 04:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705378422; x=1736914422;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t2Ldu1fXCx2EWP5YVeTaLGOmcBPj2JHAHHcr+6e1IBs=;
  b=VTl+F0KTbWm3jRtnu2WaQKBoN6E2RcEJRbYc928M9VRw5OOZhbzkPJxJ
   Sp0UKUPleyCkh9ymGEwZ+DFlnFfq+ngtot1Fg+PPFw+cdwUpJp0Q27dTu
   ds4o6I9DbvTt3UiH91Pq8JBA3AoiS/U1N8MD6iwNHnrbivtMU8SwkYi5R
   VVBy83mz9jCqalfQHglGsyOF8/A1HXCeXDr/7opr3gatf2EeatuQGmeX6
   RwdU+CdYenhbfH13Xq/Ws2ytx5/sBnkyADOLKeVulJ8O/LTYuZsjOIB4Y
   i7fBWnBDPXmmNTCDflzQQd6MYyw/XWprpgIRyAIcmXUZ3dc4QBcIsgV+e
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="13243067"
X-IronPort-AV: E=Sophos;i="6.04,198,1695711600"; 
   d="scan'208";a="13243067"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 20:13:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="902971268"
X-IronPort-AV: E=Sophos;i="6.04,198,1695711600"; 
   d="scan'208";a="902971268"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2024 20:13:39 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Jan 2024 20:13:38 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Jan 2024 20:13:38 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Jan 2024 20:13:38 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Jan 2024 20:13:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EE6VW3p7cDyYySQ6wcquDouSS9KtkN4sDskF3NmI0NPMkyanYSEqDKHEaXf1jgCdqWILUPXqwScl6pfjkYGDath2aD3RJ6GEMyf9/SOXAwkmiMJo6S4DRvGJElouJj6nbLqEAAFjgcD/+a9t3snmK8HuUnzbnJnEsLrAIa3g1XFPmY1QzFJwaLNNKMUc3E1w9O+PVhE2y3Hg+oOx19uBwPwInT9qrdWrQTiSRvA1FLRQg4lU56W9Zo0K/6JllsOj1vr2cwEUvURFTCrO/aul6FnY3/QRcDHegM3ujj2DKqOkdRNAyEKpp95Z/M1rDijOQp0tUUx6DRcuHyB2QmjhFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2Ldu1fXCx2EWP5YVeTaLGOmcBPj2JHAHHcr+6e1IBs=;
 b=QiWGjhO39BpJ0LZXT70tgw0ClTuIbw23LXy8T3Fe1eWgq86BKXOrFq+kleGGEx+sRFYzU2as+CbTHGVlqOWjr6TZzwxL2eQFYScOgbsNbyaU57nU8rN0oUfn/aLZBBmWtsVTgQxY2loX43qQ2rE32gKAUVmTvuqaMk3Uod6cuX8bvd3suHseOqaV0BIv4bUBPKa8LnyEIzf1S34T+icQyZ/AOYbERSQ/+X3fF+6dlivGwnMuyjhdtq/B0AkLVTjsIaw3AC3n7kr2+bnhHvzsuUtWjdYNs0IGTPTrew8L5rJVrQivmZ6ikDmRoOZqrUrAmBuruNN4OP8lRAUlZTKH5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.19; Tue, 16 Jan
 2024 04:13:36 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277%4]) with mapi id 15.20.7181.020; Tue, 16 Jan 2024
 04:13:35 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: RE: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Topic: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Index: AQHaRT8NfyvFkqdAjk6/fSX6qVKXsrDaxl0AgAERwXA=
Date: Tue, 16 Jan 2024 04:13:35 +0000
Message-ID: <SA1PR11MB6734D02F421F7ADC9B71CF70A8732@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20240112093449.88583-1-xin3.li@intel.com>
 <4374f38331e2c7261618f0bda5b50edc83077b8a.camel@intel.com>
In-Reply-To: <4374f38331e2c7261618f0bda5b50edc83077b8a.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CY5PR11MB6392:EE_
x-ms-office365-filtering-correlation-id: 42f48b0b-7cfe-46e8-a9d6-08dc16498263
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fR5706izLp+7aqVLWRNVZSstnqgYdGCSRpD2dxg/qEaYC29Zkcn8GmLn2iyUhh1GtRNMCxEE8ckCn6TwYzF7xzmRfbEB9PUHb589opdndiQeq2TEURzwTuC0OGGh9TMzjOrbIKHbAAAb9vrqWph3MAqLZcvE+4d/6Pk5GYtzhrCoVJRbxCP9YeUqjt0s8vEJNdFtmT7Cc/3rFBQP9pXQYjECoQyYIMKtv+J5L4GlCZzejwgmzndQwPDC4zu1XHx9cXJGuerag+Sro9UXJ824Nu04//naLI6Qi5ya76SFFZQq4WEbemiEVaody5Lsv8Py6v1QxHivYL9HJ0ortWF0AZBeoDtmsY7Z61Utd/LfLaY3Qtft74S+kEtNFVFbdVWQoaPTGhrARGxhR2nYyUrI/nLxWwptWhxDC9b67pXlYWT9nf+8DI3j6qyI4DyGFA1x24IqEvska+F6Tb3j3bJKTpI+GM75I+74a19jBq6CNlS+VN2KG90uhDWzq2LSi2ygOcEa5iP2tTLEwfSY3wpXZKDOl+NJamWkurp+CV+eQ6sYQBaw4rrR2rNH0ZuweL1nrEWLpYfCKBvdwE4dbw7Gb5MBYAZi2ywsEawX5W3xULs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(366004)(396003)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(41300700001)(38100700002)(122000001)(86362001)(33656002)(38070700009)(110136005)(82960400001)(66946007)(52536014)(316002)(66476007)(76116006)(66446008)(7416002)(54906003)(64756008)(2906002)(8936002)(8676002)(5660300002)(71200400001)(26005)(66556008)(478600001)(9686003)(7696005)(6506007)(4326008)(966005)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXZ5Uk1Tc1lQbGxUZ1dpR2ZlWkk2bzlxNlUvT1BXUGFabkE4cFY4MWFBbWpK?=
 =?utf-8?B?UVBjWU5qaVB0TTREajdKWTRobUhCdzRNSVVia1dyeGVyTTlUNDdwVlFEdzU3?=
 =?utf-8?B?Q1VmZnlFZkNJNjNUamxmOHZzSFhVcXkvSkNLMmx0UmNzblNwajZycTUybENP?=
 =?utf-8?B?UkJCTjNwTDRUTXRRMStobmV1RDVsWEp4NTU2cG1TRWx1RmQrTS81OS9CMTVY?=
 =?utf-8?B?VmUyMzlxK3pkNkNhZGhSNUtiMHVmU1hTVElnYndxVkVKM2l4N1BhVUtieUpD?=
 =?utf-8?B?OGVLcC9tbEZMSzBTUjFuRmRFSFNwQXdKYnUxam5EbDRLSFJQTWU1TEwwNFo1?=
 =?utf-8?B?RG5qdEFNUnNaMmwzckFQWk00aitib2ZUS0lxcjZuS1d4RXc3eGh4aWZUbVJy?=
 =?utf-8?B?bmZVYzgzbWRKeU45cHViMXQrU2RJZ2RvRVJWbVZYc2JCdzFXOUpEelZPZHZN?=
 =?utf-8?B?UGpJS3kvQ2hKcDZmRHNYd3lZckFMR0xRMjNPaExmM0JxZzlkT0ExbFE0eG5t?=
 =?utf-8?B?eFRSSUpxNVF1S2krWUF1ZmlnRy96Zi95cjV1bnZ2eXdFbWtMS3hmdzR5TGU2?=
 =?utf-8?B?REZIRFJLb1BkWkhTQVdZcVJLR0FhVVp3WGNidllqR3JGK21HQXlOSTlxZlkv?=
 =?utf-8?B?NnRQOExJQ2ljTTRoU1YvNjNHL29TQ2JtZ3BwRXJHVGlsZEloMDc4Sm16MmxZ?=
 =?utf-8?B?aldidXRzMDRXR08rNXRsdGtPZDA4WjRmK0FYSTZveXJ1bWNBMDhWNGhHNWhP?=
 =?utf-8?B?akR3SUc4amJUTTNoOEtORnRoVEcwZW1Gdm9OS3Rualo3UlRwcG1WcUFKdEpa?=
 =?utf-8?B?UXRWTWJtQlhXQ1c5TWtuUldBbzRQQWRzQmdvR25pTXU4VWkrRUtwRjM5YTN0?=
 =?utf-8?B?THRQR2plS1llOE1TSlZPRkVkS3pWSmlPN1lrUXNhOTNhOGZUQkQ1eTZpYy81?=
 =?utf-8?B?VFpFcXNpZ254Z2EwbnkrNmxneE04RE04T0VacUxTVU14OE9zOWRUL2g5S2gz?=
 =?utf-8?B?dSsvUUpsL1IwKzRkL2Z2eVQ2T0Fma3lWU2lqUjZZME84SW9Mb25tMCtQa0Jj?=
 =?utf-8?B?OEtNempQeHdmTUlES2RuQmR0MUhYMU1qVEJXK2k4MGMvNWRyaVdFZ3FWdGpN?=
 =?utf-8?B?UEtMaU5SbWFIMHdZNHBOcVZielJjbXZQQXoyS1JRZzNlc2hDZC9hcmprSEF5?=
 =?utf-8?B?eWdzeHY2a1FTTDYvZGNod0c0TnRDR2txc2NMUWpRa2RWanZFNWNvTFZXRHhN?=
 =?utf-8?B?ek1UbGt0WUNIM3dJMzcza284SHNyZUU0aXhYK2cyNSt0bTl2UnQvUnZod2xC?=
 =?utf-8?B?c0RXYThacU42KzBtRm9ZSVlEdGIvVEQ5cUYyYnBkRnEwWUZTZnhsdWw2VUtE?=
 =?utf-8?B?Y1A3c2RXS2F2eWc2akNaK2JnQlpyQ042RFVSZDhqazB1TE84ZDAvUURJU1c3?=
 =?utf-8?B?eVNFTFRvbDVCWHQyUXRiZGlEeHZFemRhQ0xlWEZEcG9DdzRDcDBzT3l6c1B1?=
 =?utf-8?B?VHVGMWRNSm9xTlBMMGpXTFZneUlCRllsMHRsbmh5QmxKeGU2MmprV2JMcnJs?=
 =?utf-8?B?TG9ZWXVwUWxLcDcxeXVxc2dmUUJNL3FRVURGNi9PcERlOFlseHpQVlVmR2Ur?=
 =?utf-8?B?VjVBelZCYnJhNEFLYUFTTlVvS1RzWkhDZzBxRzAxdmZrWUxxM2Z4aS9KazRm?=
 =?utf-8?B?ck16TWxoQUpkVFJEZnd0Y0hzdXk3SG1RM1JkNDJMSEtLa1BhdGhKaUpycTlq?=
 =?utf-8?B?aVB0R213emlIaThXT3FZTTVsd2ZDWmVFWk9SRjhVNjdLQjlkUjl2VFVjOXZ5?=
 =?utf-8?B?bUtZTmdZOVJUaHRuVWo2ZEo5QWpEbXVvQkpQeEk4dGVCZ1FWYmVSd1dGU1E4?=
 =?utf-8?B?NEl6bUdWTFl1dHNaL1o2cko1QTJRaFFWWUFVb2dSWHpTZ2d2d0hGdTRuWlhR?=
 =?utf-8?B?NUo5YXNIOWU0REVFeG9iTTIwajh0d1lHNGh2bmtCOC8rakJzSmNyNHd6SWdP?=
 =?utf-8?B?WWdxVWphY0ZZdmxJYnZXL1l1cUJFT2ZHV2QvMi9tM25YQ0FQSmlwejdWMTlY?=
 =?utf-8?B?VXNNNWJiZUNkN2xVVGk2NjV5WEZOK2EvdTlYZW1JMjdxVVo0QXlVSE9lMURT?=
 =?utf-8?Q?OaoE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42f48b0b-7cfe-46e8-a9d6-08dc16498263
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2024 04:13:35.5414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cRBT9c4Hs2yIpiAQJyeQzkeiwHajGcz3ml9MWiId6jynNrEXz+GLZCLsWR5cgBzMYP1TUduim3cM6PS0EK0mAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6392
X-OriginatorOrg: intel.com

PiA+IERlZmluZSBWTVggYmFzaWMgaW5mb3JtYXRpb24gZmllbGRzIHdpdGggQklUX1VMTCgpL0dF
Tk1BU0tfVUxMKCksIGFuZA0KPiA+IHJlcGxhY2UgaGFyZGNvZGVkIFZNWCBiYXNpYyBudW1iZXJz
IHdpdGggdGhlc2UgZmllbGQgbWFjcm9zLg0KPiA+DQo+ID4gUGVyIFNlYW4ncyBhc2ssIHNhdmUg
dGhlIGZ1bGwvcmF3IHZhbHVlIG9mIE1TUl9JQTMyX1ZNWF9CQVNJQyBpbiB0aGUNCj4gPiBnbG9i
YWwgdm1jc19jb25maWcgYXMgdHlwZSB1NjQgdG8gZ2V0IHJpZCBvZiB0aGUgaGkvbG8gY3J1ZCwg
YW5kIHRoZW4NCj4gPiB1c2UgVk1YX0JBU0lDIGhlbHBlcnMgdG8gZXh0cmFjdCBpbmZvIGFzIG5l
ZWRlZC4NCj4gDQo+IEZvciB0aGUgc2FrZSBvZiB3YW50aW5nIGEgc2luZ2xlICd1NjQgdm14X2Jh
c2ljJywgZmVlbCBmcmVlIHRvIGFkZDoNCj4gDQo+IEFja2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5o
dWFuZ0BpbnRlbC5jb20+DQo+IA0KPiBBbHRob3VnaCBJIHN0aWxsIGRvbid0IGxpa2Ugc3BsaXR0
aW5nICAuLi4NCj4gDQo+IFsuLi5dDQo+IA0KPiANCj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS92bXguaA0KPiA+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3ZteC5oDQo+ID4gQEAg
LTEyMCw2ICsxMjAsMTQgQEANCj4gPg0KPiAuLi4NCj4gDQo+ID4gKy8qIFZNWF9CQVNJQyBiaXRz
IGFuZCBiaXRtYXNrcyAqLw0KPiA+ICsjZGVmaW5lIFZNWF9CQVNJQ18zMkJJVF9QSFlTX0FERFJf
T05MWQkJQklUX1VMTCg0OCkNCj4gPiArI2RlZmluZSBWTVhfQkFTSUNfSU5PVVQJCQkJQklUX1VM
TCg1NCkNCj4gPiArDQo+ID4NCj4gLi4uDQo+IA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgv
bmVzdGVkLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jDQo+ID4gQEAgLTEy
MjYsMjMgKzEyMjYsMzIgQEAgc3RhdGljIGJvb2wgaXNfYml0d2lzZV9zdWJzZXQodTY0IHN1cGVy
c2V0LCB1NjQNCj4gc3Vic2V0LCB1NjQgbWFzaykNCj4gPiAgCXJldHVybiAoc3VwZXJzZXQgfCBz
dWJzZXQpID09IHN1cGVyc2V0OyAgfQ0KPiA+DQo+ID4gKyNkZWZpbmUgVk1YX0JBU0lDX0RVQUxf
TU9OSVRPUl9UUkVBVE1FTlQJQklUX1VMTCg0OSkNCj4gPiArI2RlZmluZSBWTVhfQkFTSUNfVFJV
RV9DVExTCQkJQklUX1VMTCg1NSkNCj4gDQo+IC4uLiB0aGVzZSBWTVhfQkFTSUMgYml0IGRlZmlu
aXRpb25zIGFjcm9zcyBtdWx0aXBsZSBmaWxlcy4NCg0KSUlVQywgU2VhbiBwcmVmZXJzIHRvIGRl
ZmluZSBhIG1hY3JvIGp1c3QgYWJvdmUgdGhlIGZ1bmN0aW9uIGluIHdoaWNoDQppdCBpcyBvbmx5
IHVzZWQ6DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vWlRCSk83NVp1MUpCc3F2d0Bnb29n
bGUuY29tLw0KDQo+IA0KPiBbLi4uXQ0KPiANCj4gDQo+ID4gKyNkZWZpbmUgVk1YX0JBU0lDX01F
TV9UWVBFX1dCCShNRU1fVFlQRV9XQiA8PCA1MCk7DQo+IA0KPiBBbHNvLCBwbGVhc2UgZml4IHRo
aXMgb25lLg0KDQpCYWghDQo=

