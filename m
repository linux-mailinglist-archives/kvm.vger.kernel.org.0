Return-Path: <kvm+bounces-2545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A42D7FAF8E
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 02:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 059AD1F20F15
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 01:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E10D51875;
	Tue, 28 Nov 2023 01:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PLEdKaxV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E877ABD;
	Mon, 27 Nov 2023 17:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701135120; x=1732671120;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4CeoVqa+Nj8HD6C9Ph6qnUZxTjWAqyMEqfqtdZqeFlk=;
  b=PLEdKaxVp1FZAmq1JIuVmnJwcRBzerGHbjK3XtlbGrwAhdzWBdqcXnkH
   OPCXwXp6ifMplu86g7LFcIA+/GxZiuZtJEEnV1P0MJEpfcfhwUiqfy/wH
   jCoRTW9luls5q9qnthYzlz75BputEOSphu7gCmzIZJ+XiCgnuafdF+Tv0
   h9QrfK4dk1sPhM/3P1PipKYeC4gJgV+ovBh2DvAiTnIcFNtfy2qPkID38
   hpm+aJ19zhAoSiDWbIqXRjmatjqyYZICL9xrsmXOwWDbi+Ow5BTLSU2io
   qwlH8PcwHDvgq9XEhg+/xNpPm2SuWpysMuXV0ynQ7jAtS945tNL8VvtEb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="6080097"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="6080097"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 17:31:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="1015748955"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="1015748955"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 17:31:58 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 17:31:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 17:31:57 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 17:31:57 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 17:31:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6ht5bj3oxdwR1OsHPsAB6CEFmOoZ5yUaxG8ioW/+uq5NF/S4Oj7uKp7RYbqBfa89piCAqPICI94Hp9wtaxZG18bnORw/VmRE+s4Oh9AmRE6iZXb/K0p3iVaphXBTBerhXfgVZSdwK6FuGxFlzMLYC+DtJSA6uqllAKMS68GWS72C/nsV8d5JiTQKqupn7Lo9304UwpquNfxFP074k7oXkGvfAq7puDa4mVs0DbI/w/5CcsEOtnk+Ee8/F5i7bImQ06d2MY/HJ/JdGXgCojhd3tMiUSLouPlIv6JQv4o0txASWuXjqYFuxGK8BOVLkgYH1HmjJR2ZTmGp+y3Ylvxww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4CeoVqa+Nj8HD6C9Ph6qnUZxTjWAqyMEqfqtdZqeFlk=;
 b=HRYcAg8hu+pONJJmxfgsC2fKdMlkJFBzc/4HkZU0McYs35uyziN5Y5fC0ZtGTDTy9+58mtde8xTuKHh4iI3Tg/zgSLa6HwjZ0uZZZmU3sfw/d5oigNH6/jUDFSRG+tTHNuq3NBe2JDkv42iqKg/FnicgFAX2ID+j9HpMg8jSkCSiqddVA/7kkeI8mqsYpqCoE50S31TkdPnwoAWnGoU95SR1NZuZjY4rnYxXUEC5JvNluiohFdgwIGMi4YU4I+3gkJgNF9Y2vpWAuSrIvXg2Y7Z1wJUicUZ7t4nqGaKAXxtA8iobPk0r1Zdcs8ytD8648HO0I3L1bgTlk65lSqc2xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4564.namprd11.prod.outlook.com (2603:10b6:5:2a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28; Tue, 28 Nov
 2023 01:31:54 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9%6]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 01:31:54 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
Thread-Topic: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
Thread-Index: AQHaHqwJhO6d42WHGEKS+emnbAz9lbCO9/yA
Date: Tue, 28 Nov 2023 01:31:54 +0000
Message-ID: <29d7597cfccb7cab9717d973905a8285873bb92c.camel@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-3-weijiang.yang@intel.com>
In-Reply-To: <20231124055330.138870-3-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4564:EE_
x-ms-office365-filtering-correlation-id: 83dcdb1f-3adc-41ea-bcb0-08dbefb1cddf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oYdRaUNKSpHDjDU5l3D5S05uQ9nS0S4o2GK3BI8gF5+kFME7XpI59HFScw4fSVhQZCxwrV8ui1N/xs5is21Lj0WaAwp9OkDS+zBnh2rUcygLH76vmMK0QcVFM+51PaBKy/oCNzajf1Cj9X/qnBNykPsSfqyPdukVspTmQgoeP2CH0p/x4U7qVVbZlA6x1XrTjS9c9hwo+iyZidBtj/vMZJHTIELCZLix6oHWKdaOSbOeIZ7TZ5GIfrEUDj7E5ZA7xksZLL3/UzTsZ3rr66mK8WSgMIn98gvMOovvSXm5cwrnKRrt/fu+TcpEhc2HHa/f3RuLp09QO+CDNbOjfT2neWcmRNdJ3smiiG4511i3Kd9gVtu00HfXgUmyvTUCOpoNPDvj/0hZ3dS+Auwb58uKmmaKTqKkYfl0BaJBJ9nicbN/c9dD0AmOp08XNruWK6DB+m8XcGDn4FW2XJnV0D/OdbCnY89rmXVRO6MvolCIJK7ZnTel6hHaLyNU10mHBqWFuVNzFugbJ3p6IrMWWMocpCLP1HWEbK2LOkISo+BcAa8wstPBHtj1Tg17cELPId5GgObi17B5XUQyOQ5Gu0NdS0DK6m8sPD2zQtm+my/26oZ0RwtBhbK6+cs6EU5bqKH8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(39860400002)(366004)(396003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(38100700002)(41300700001)(36756003)(558084003)(86362001)(4001150100001)(38070700009)(122000001)(5660300002)(82960400001)(26005)(2616005)(2906002)(71200400001)(6512007)(6506007)(8676002)(4326008)(8936002)(478600001)(6486002)(66446008)(66946007)(64756008)(54906003)(110136005)(76116006)(91956017)(66476007)(66556008)(6636002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dG8wUkVWSDk1Qy9sMGJ2WVhlNXAvQU1DaXdDRFYzaE1PTFBPL05FejVQNG1P?=
 =?utf-8?B?aERzTFM2Ky8ra1Z3WTYzUTRIb2U0Z3hSVTJPNjFNM3h6YW1oYmhDWUJ2ZTE3?=
 =?utf-8?B?V3hTQXpjMEdHNElMYlBXeGRScFlNZzlPdEhpNWF4OHNyUk5Fc3dxQlBXa0pN?=
 =?utf-8?B?NjY4OE5kd1RrUitUUXVQdGRkZzVyb21BZnBPeVQzQUZiRUxKTFJ1TkpOeHNq?=
 =?utf-8?B?NCtCTHF2L1V2YzcybDdiMXdLTTZ0ZTZuTWt3OHJPajYwYWRXSEhGQUhQN084?=
 =?utf-8?B?aU5yL201bnM0OWZoeUhHd3pSajdWWFVkNzVRNi9xaE1aWUdXU0NDNVJ3OHd6?=
 =?utf-8?B?TThib2pEMGlCUjBiajRWbEkzZHJDbUF2Y0Nkd05CYnJuaVB1OEFOaXdVYklz?=
 =?utf-8?B?Y0VJWkdFV1hmalRrUGNwZEVhQzI2TVdtSElMclJrR1hQZUpyV3lFbFRiTGR2?=
 =?utf-8?B?d1hOMCtGcFJvYkYrbVNsUHdkV0cyZVY4Qzdnb3V6WFNLekk5R3JoL2dGSkFF?=
 =?utf-8?B?b2UrOCtBcXdwOURLSmt2d3crazcwbUFrZlBnKzFOYlc3bXdkbTFNT0xDcmhR?=
 =?utf-8?B?MjFKdWh5aGpTYVpMZVFkSGRIbDU5UG9qWUJUem81YTJMNWorRWkvL3hBR05h?=
 =?utf-8?B?VTh4bFJYaTAyb1gzTWpzMHNJZCtXbFY2OVZkMFRzWEdYL3dMT2ZtMnhWbkNs?=
 =?utf-8?B?YUhET05JenlnNVM2ekdxaytKVTM0eTB6V1ZlN2pnSFdQeDNaYmFHZy9Sb2d3?=
 =?utf-8?B?cERKYkp4NGpmT2dlaDRZeTh0SmJRRHQ0UXU3eWswZ3h5bVZGTEV5em9pWkph?=
 =?utf-8?B?ZGV1b1lkLzNtVjFydEk2K2psSS9aeFhTRzFpRzVCNGh1UzJrRlNQOG9TL2p5?=
 =?utf-8?B?Q3dISm5tUElFV2MrUFp1YWpGTEwrWi9hUmtCS280QUpmVHRPMWFzRmtEcnFh?=
 =?utf-8?B?TmNGZ0tqbVNsamNKNUl2YW5DWDNkeER1UXFnYnhieFF3amwxV1A4N2lpd3h6?=
 =?utf-8?B?SEN2WkRuVndSeWhtaUppeFVBbm9aZUovOUVRUUxpbVkvS0piM2RldE0wdDcx?=
 =?utf-8?B?RFJmV0FPUWpnNDhoZk9rMWQyVko0NUVJUklBUVg4WmZhNy92Y2c0R1pabytY?=
 =?utf-8?B?N3NqNnFtZk53Vm4yaXJXcmlvQmVDeU1RbE5QV215Q0MxQzE4eHdmTWFOY1Zi?=
 =?utf-8?B?NVNiajB1UnVaanRVNmpxUk44bTRKQzBDZHJDMnd4UExTM0ZieUxMWCtQOXhk?=
 =?utf-8?B?dlc3RHlycEVwYjZKdmV2OXM4TWZ2NkFyRk1qQ05ZS3ZWa0xHalRtVndyTWhu?=
 =?utf-8?B?TkRHZHd4aTNvU2lRakMzY3NvYTVCMWkvOW9KdEJlbzhOUWs5MGFGT0QyQ2FR?=
 =?utf-8?B?RjhJWTM2QUxNMVoyMktxa3AycDFTSWFDdXdmOXZYN0pPODVnUlJ4UytCK0Fl?=
 =?utf-8?B?Q3dLZVVkMENjVEs0NmNTYUM5NktUWHZHYVZlMkdBVkpYOVNRMzNvUE1FdVZD?=
 =?utf-8?B?Vks5bit1VERYeTdqRlRvMlZiNk9tb2NIMjZiV1Z5djNaZlpoaXlxVGJDODQ3?=
 =?utf-8?B?WVJDNWRpYytRdCtwN0Q1RVh1cU5KYjB2VGhTVjhRcmljTFFKbXhlL0JIWmRM?=
 =?utf-8?B?RTUvbmZQMHNhMzVBbjNwb1lVRGcyVFBUUGN6cldINEVKcHFGRnNNRjJpUGtQ?=
 =?utf-8?B?UlRSWEl5L2Uzb2g4a3BYbnJOcnUyS3FncXY1TnNackV3L2RhOUl5VDhVc0Vi?=
 =?utf-8?B?WWsvNkZpeVdnSlNiWEVFdVExdHkrVVZnNTM0ZnhTOG92SGVGM1JXWUdUZzlL?=
 =?utf-8?B?N3d3dUJjcDFRTWducWlkRmpKN3duMHJibklQZy81TTAxdC9OeWdoMU5mZVBo?=
 =?utf-8?B?TitnR1NOZzB1UFc2UVozcndZUXBsM2Y3dnkwaS9CcXNlRVdINk14MTUvMFNK?=
 =?utf-8?B?R2ZmTTJabXNiTHB5UVM3MWRpRm43d2NhRUNwNzQ5Y0M2N29vQ1ViOTFXeE1R?=
 =?utf-8?B?WjdFaG1VMTZYclo4c1Y1enBRNTRGRE9uRzBoMlV0RVFCd1BtcVBQU1h6djVZ?=
 =?utf-8?B?dUZkbHB4OHF3MnQ1QlR4dERUQmQxMzdJa0xxVERwOU5ZQkhRbG1iSm5DQ2Vj?=
 =?utf-8?B?azQ3UlF3VkoxSmw5TTJscWRjUjNnY0JuWWJlTXo4ZW1ickFMNHpWNnpyWEs4?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <20D5C9651D118246BF4D0A9CE14B2C0D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83dcdb1f-3adc-41ea-bcb0-08dbefb1cddf
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 01:31:54.4806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jJAJPYLQKfDLFVJKciAD4F1rXyRNKUa4TMObvhWs+upMNTWRRXUrORPO8BypWz3nzWl7dHjQ4DRs1hZgGI1zB87NYslVKZeO0iX/ahQmlT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4564
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTExLTI0IGF0IDAwOjUzIC0wNTAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiBzZXR0aW5ncyxpbiByZWFsIHdvcmxkIHRoZSBjYXNlIGlzIHJhcmUuIEluIG90aGVyIHdvcmRz
LCB0aGUgZXhpdGluZ3MNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgXmV4aXN0aW5nDQo=

