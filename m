Return-Path: <kvm+bounces-2994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B0817FF8FF
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC4DBB2116B
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8A159143;
	Thu, 30 Nov 2023 18:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y8mmai+4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CAB103;
	Thu, 30 Nov 2023 10:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701367370; x=1732903370;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AIJigdIqQ3EvwIYDTIZCNMmQUTfpTSvIU9t0UY7yfE0=;
  b=Y8mmai+4vgpkTWiWFupd6Usjrkq6U6jF2gpzoBlN6/sovTmIUAzDEBtr
   3uI7EDraDZQkvUpsa4UUZOBARO2P9nOF62yTEsuQbJn+Fpf34wZL0w+lq
   u1f/7bmPEvEYtP1AhVuOSLmkw7WhfvtBrjK09HD7HzCxJgId2TYk1uB/o
   HZVJdNdEz7wk3cJyyn0a6dXB1QmorhCDRWPaLI6hw16tdp6b8sIpHBPmW
   CJb3D643GlUsscTkbmOr8YU/V6Lgpnt+prpUDkAwNvcTcyzY/NshiOTVd
   eibnpHMxz0eXb7/CQWY4c3ORRew1OoPanVEA5jTLoloq+7/kjbN6k0JOy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="6643419"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="6643419"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 10:02:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="892895916"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="892895916"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Nov 2023 10:02:49 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 10:02:48 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 10:02:48 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 30 Nov 2023 10:02:48 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 30 Nov 2023 10:02:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMz5vzTdvt3OeHXkPmybrXjXVlfmOfdRfaaY+wR9PFPfou6DABRtRFwsMTklIBOBNYZkWDndLYTG8xhRxGkL2izLYBXUy1eh5FBwmEpWhgkNSPscffF3i/ZeUBRJK+wFmEcaGLaKvs+3smt0SETGg8q2hi6s/5XSNYM/i0sfWB28xvFdhHe6u0SkIBxz8Giu7+NODQAvgrsgwukKHvfFfivodx++CSP+1d/hsTkzxSojYHZ79kJHZCdYeepR61oM+edW/1WXrIaklEWaLCPCDr/PC93JQAoLQYLfyUP3bTooZHrHqm5a6TA3Mu5Eoeskla5IbLO6Aj+j+1ALnhspXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIJigdIqQ3EvwIYDTIZCNMmQUTfpTSvIU9t0UY7yfE0=;
 b=QRgimL/CDAjK51yXUEzszNjO/51v3ikCVzvm9VsluiH7/PkV5I7u+VINIZ06GxImtEf4mOSc7DwPUtY7qXXLdBMt5NX5CKu3IvU6md/OhOyvjISElPdmO2APDisKiNsQbxHTbVRWhnuLMejx9WL6ni5jMx/pa81NtgHxBYRoVyv63zJ+E0vYssBoRsHarplGWWVzBhZxABoINzEiVx9uxjlW0zJln11nBdKeDV+fgyPUL5ziKg+8Vt8YEyO6rSAXh52j9TmZ3dHO9GPcIFaRDjGTWkpq6j6PPNv52gR0ISHovypT5syVrw5nl4B0nGD00Z5YVAktUrPW/Slohd9UhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ1PR11MB6203.namprd11.prod.outlook.com (2603:10b6:a03:45a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23; Thu, 30 Nov
 2023 18:02:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7046.023; Thu, 30 Nov 2023
 18:02:45 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
CC: "peterz@infradead.org" <peterz@infradead.org>, "john.allen@amd.com"
	<john.allen@amd.com>, "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v7 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
Thread-Topic: [PATCH v7 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
Thread-Index: AQHaHqwJcLbwxqusyUagEZmr+deVnLCP2VSAgANOzICAAAlcgA==
Date: Thu, 30 Nov 2023 18:02:44 +0000
Message-ID: <624e948558c013904695cb66af6f299890e3612a.camel@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-6-weijiang.yang@intel.com>
	 <742a95cece1998673aa360be10036c82c0c535ec.camel@intel.com>
	 <90cb8be18da40c62f6acbf2bee19ec046e122e49.camel@redhat.com>
In-Reply-To: <90cb8be18da40c62f6acbf2bee19ec046e122e49.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ1PR11MB6203:EE_
x-ms-office365-filtering-correlation-id: 2ed15ff4-dc53-4454-16ec-08dbf1ce8dc6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5nm2A4/5OOziE0tQNz0f1jnqOryYK6VLR4ZJZFfvV4a8WCkrbSPcnQ2xm+kpWhWsmFvZEK25dDPgsU7GOGuqYMkvCqcLH/kbu+MlGJfJNmhrFzElKNJn+h21TfiB6aZJfDK5ehSApe+MDUPyNwhSfuSpCaVKRuTtdRehJRZiejTbFa2d7Fq1+Bg7NlKm5UEeRfxmO+7n628RVIFuZsQoP/Qc7JDicpQHiIcf0fT/DeYYk8gqSh9HxR9rdP8LgZR4vC4R+yeeP5WHtkE4zQKu/qMgG2emzlKoJf7nbzSanbR2qb1n1QgtJk1Qw7yfC4hDDnKG4bZDYjXv09wtYFJQOmzmiXT2F021r0wjkW848KmmdUHkegUGv6ueje+/QP1k6cL38r0DSWjmEUbHktJabWAmY+eeKIRPwpuS96xW4WZE5LWI3cxF+QrRNn4Gp0wCnkbg5xXEJSa7LOS1trxC9E+xYU2XDl1HL792Bf6rnX4DOHHBgojE0FznjyzlSOPfs7z5Zrb8H8lfyQwwKcUBTOdnQOu+8dpUiZhjX6/v/d8XMbKRP9U4eTWi5zh5R1t6v6gv8qvQoA5r3TF4GEXoJpzYXpYQkwDxKBL2QxrPvEWc3oOigKM7UUG2C/orRDLD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(346002)(396003)(136003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(66446008)(38070700009)(26005)(107886003)(2616005)(54906003)(66556008)(76116006)(64756008)(66946007)(316002)(2906002)(110136005)(91956017)(4744005)(66476007)(8676002)(4001150100001)(5660300002)(4326008)(8936002)(86362001)(41300700001)(6506007)(36756003)(6512007)(478600001)(6486002)(71200400001)(82960400001)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TldVVXdFWDRYcS9uWEVFSnRPc0p6Qm8wQndHaDltS3p1NWdyaGM2ZmxJWmxo?=
 =?utf-8?B?bngwTzk3eEJvbUlFZm1qenhhZzd5WEYydlYwTmxnQVpzLzFGa0h3cGZXZEVj?=
 =?utf-8?B?dmRVRmIzUGhsckR3ajZQSWVHejlZR05PalBKS051S0lpdUgyVEorMitEZTls?=
 =?utf-8?B?dzIyOGwzU0M2NGw3T2Zta2V2emF4TWtOeEJXYm0xdHFMK3JGQTlWdE0yL3Vy?=
 =?utf-8?B?OTByV1RSQzFUR0tLYnQ5VFB1Z3ZVUWlQcEJ3L0FZQklMSDVKVlhHTm1HaERT?=
 =?utf-8?B?MzFVSHBVY0dZL3ZGa1dPK2lndlBtQUtyc2FKOEIzVmtPSVd5eFptSDZEbUI1?=
 =?utf-8?B?U0dyMXUwdDdkbjd4VTlLZXFtRGp4OC8weUtqKzloTmd2SnJJQVBrdmlSZ2dm?=
 =?utf-8?B?OVlFZ2dOOHh6TTg0TWlTMkJFbXF5cGpjcWdUeXZjOXdtZmZzRjk4WFBRcEZs?=
 =?utf-8?B?OFc2dEF2SVdxZnNlMWxZcW5UYVhsTi9neXlnS3RVWmg5UjlleHE0QUtQWVNY?=
 =?utf-8?B?MkhFRk8xVndHeXNGVHJVd0kveENTcXpzQTZDVFJBc3NSZkZ0bFVyRTB5M3Yw?=
 =?utf-8?B?RDdNMDJ6ODhKZ0dXUDI4cWNNQmh6VDJMRDFQZEhsK0c1TUs3dTFwcFo3TDhz?=
 =?utf-8?B?b3RCTGduOXkzcEJ4aVFaMlNha0ZRK0J1N1JjS2Vvd1h2SFNiaTdGVXJZV2hX?=
 =?utf-8?B?Z2FYaDdrdHRSQ2M4RkhYL2d5bXFaRm5hOVhvNVdZREJCS2VNSDNGTWVGbEdD?=
 =?utf-8?B?RWg4Y0FuWG5lYmtFdE1IRmZaM0RMQktobEd4dkNLaFhScEtUcllMQTNjZkdV?=
 =?utf-8?B?RjRHcFFpSkVzWExNdTIyMC9QZHlORGh6S25XRFQxbUdlWFdXbzB2dkZFRDFD?=
 =?utf-8?B?SW84Nm9oU2NyTFBnWkhBYnpiMURESTNIc0NWWUhzWUdEMnV6dmtqdFJCME9K?=
 =?utf-8?B?QU04aEVsUm5kN0dNOWdoK2c0SlNsR0hOYk96aEIwZ1lZL0JhSWdxMmswYkJ2?=
 =?utf-8?B?UWpvSWpuNEZBbTVROGtxcjR5Q1RGVDNoTUFGUXlGdTl2cU1rdEZaWW93VDA5?=
 =?utf-8?B?TWtIeVJOMEdLWVRsMDV3ckhLVGg1RENCbDBnNE9qM0VvZE5IV0xFT0tHc1pp?=
 =?utf-8?B?QXRrbUhQelB3SEppanZtQVVLRjMwWHhNZ1hwNWUxK3kxNi9qVVlOY1l4MmpP?=
 =?utf-8?B?ZXlCWEU5a1Bid0VLdlkveGpyNTdGdWIzS3UrTG15K21MTFE3RzJSblNoSXBT?=
 =?utf-8?B?L2tJRHlLUzBaeHJEcnQzZm1qd3pTTm1PSVFIYzFZbkdZeTB0bVhkZkwzOUNF?=
 =?utf-8?B?bEgreHY1RmRBUkQvL1RIKzBtTm5TMVd0M1psc0U3WE83Z040U1NuZHo5NGJk?=
 =?utf-8?B?M256RjZtTEY0ckRQcWJidmhIQ0ZOZHZaTy85NVY2NGE5ZUFyU2FXR3hGZ0tZ?=
 =?utf-8?B?aDlOTkFWL3d2UmhIVzA4ZHpLbGRDSVpQZ3RLQnNVTlpGRUhyMDEybkRHY0hq?=
 =?utf-8?B?dHIzdTdGMW80Qm1qSThrZHBIOHZpK0tqQXZzK0FzL2xYc2lWUnlIMExaSzMx?=
 =?utf-8?B?VlVFTUZUZ1k1b3NDRW8zNlhIMklUSVFkcXNZbmNXVWUvR0gvcEhyT2pjVnVx?=
 =?utf-8?B?anc4dUl4eWloVldZd3lUcCtpVHRQRm0vZkZvOEE5YWtZOUFLeHJLMUtVcjIy?=
 =?utf-8?B?MVd3ODJZSUlRWTRNOTg1NHdQdHRMK3NHZFJSZHhLN3pGZXJUQ3NDWkdIYWNT?=
 =?utf-8?B?NGdzdEZyWGhidUxLSGtqSFJhWnVLcXN5Ym4zZ00raENxUVUzSGp4LzhrK2Fr?=
 =?utf-8?B?ODZibE81azV5NXJ6K1NWZlZsOFN1cjR0NUxwaUhrV1ZlenplTEQ3YWpBWW9i?=
 =?utf-8?B?ZDQ3RjY5OC9NbEFWYmlOd1pKNEJuUTI2cG01MG16Wnh6czhEeTJZSlA3aVZw?=
 =?utf-8?B?YjkrRlVmcHl6V2JyOFlJTGlxSXVhbTJ5KzlZQVNyM0tKbnRqb2ZRdDBBVW4z?=
 =?utf-8?B?U0VJWXkrN01GelpQNXg3aEpIUGdFZjJmSlMyeEtoZ0h2TDR2MFR1SlM4bzRo?=
 =?utf-8?B?OTdrN1hkR1BTMVBsVTZXR3pKTFF0MU9QWmJmd1A0aTBlelVVS0UxVUg3cG5u?=
 =?utf-8?B?NDMyVHJvN2YzM2hhVUkyeHhxTUJpK3NRVXZzYzU5S3ZiaXJqRno5SHRYTGow?=
 =?utf-8?B?WHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C3DE93FE9ACED42BC7D1E7D27EF79A7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed15ff4-dc53-4454-16ec-08dbf1ce8dc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2023 18:02:44.6733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xoH29BN+pPPDNp/KSVRBIe5C/al1bmuAIHZrEfzlCWVoh1FaRKudYO43ERRiykm88KYg8i6wyog/JIsaTfuRbQuHLfAnaCtwSg55YhjGGXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6203
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIzLTExLTMwIGF0IDE5OjI5ICswMjAwLCBNYXhpbSBMZXZpdHNreSB3cm90ZToN
Cj4gMi4gSXQgd2lsbCBhZmZlY3Qgb3V0cHV0IHNpemUgb2YgdGhlIEtWTV9HRVRfWFNBVkUyIGlv
Y3RsLCB3aGljaA0KPiBvdXRwdXRzIGJ1ZmZlciBzaW1pbGFyIHRvDQo+IG90aGVyIEZQVSBzdGF0
ZSBidWZmZXJzIGV4cG9zZWQgdG8gdXNlcnNwYWNlIChsaWtlIG9uZSBzYXZlZCBvbg0KPiBzaWdu
YWwgc3RhY2ssIG9yIG9uZSBvYnRhaW5lZCB2aWEgcHRyYWNlKS4NCg0KQWghIEkgbWlzc2VkIHRo
aXMgcGFydC4gVGhhbmtzIGZvciB0aGUgY29ycmVjdGlvbi4gU28gdGhlIG9yaWdpbmFsDQpjb21t
ZW50IGlzIGltcG9ydGFudCBhbmQgY29ycmVjdC4NCg==

