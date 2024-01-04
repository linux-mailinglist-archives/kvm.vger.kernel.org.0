Return-Path: <kvm+bounces-5689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E1E824ADB
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 23:26:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B99251C212DE
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 22:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1047C2CCA2;
	Thu,  4 Jan 2024 22:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SYO6aVFY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CFE2C859;
	Thu,  4 Jan 2024 22:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704407183; x=1735943183;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OmrhzuzE5u7zz9LCqTUu5jVrecYtq28i/bDhsIu7pD8=;
  b=SYO6aVFYdX643TUBB1Gu4KbNGrlLUgWNMMlr6XYi0qY1hERbhu9ep1Cq
   iTTSKlcpXCyzAeTdU+Gx65/Rqkj7/3BhYIqHriiiNXDQ7qGmsmU4sAoUp
   VsRwET1fPhFV/FoT7TowIg5icnFltXPFme7MXan8B6tRONdIKEr0ITWtN
   aPc1qrhXbIsSE6fjyo4eq8TOScjGVzmCExvbRLcJSs4XBA9ESmiLHUlrq
   tAs4NnaF4R6iu11zuQEecP1POwOJGEU64mfUWF2f2a0x1vvv8qOwMLyQL
   gKVKvvcQXJwTVtqXjigsX/W9sBt8MniYxRroU0zWS7cTQ+MIhhg+avF77
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="18893992"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="18893992"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 14:26:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="780563578"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="780563578"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jan 2024 14:26:21 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 14:26:21 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 14:26:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 4 Jan 2024 14:26:20 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 4 Jan 2024 14:26:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXB6U+viV7ISvgp7W586O3+gefSOR1YLnKvXFv8G84bbQqnuzk1YXvqz5Gsg3r/0uF17c21a9SPu6EgbNwlB/xjmjLgrmSZxRwvPBOSkzqcINUq5WwAwLxjWadvWQQQkm7fBvWA878YfjzwD2LpmWWclJqWnwXgI4uRWkyX6nAdQqJEreKqtECcEwwRiq9Id21oyw9QvqmIQNEF5uEvudHKSLMpTll7ALBAxQ6yDME4CMAYh+pQ431bXrXrFQM7OfEHa2QfE4w5il64eXaVurem0hoDKQWWKzKXmfkCl/N0aBp2vqVITL7f/qPURP8tYcCIoWZ79tugIjPgf+oFmSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OmrhzuzE5u7zz9LCqTUu5jVrecYtq28i/bDhsIu7pD8=;
 b=n3CGLN7e7qElBPmJd4+B+WKo/aRuHF0VUHC6GcXNlu6bc0nRlMkBwldfexUI8tEO5i7QZHirn0bUCGR6vUOL85LJDsLgWYP3t11gRHXEkKSl2A1rhnfj6tLL51iHLyfVauKg7c231TtRRQB4Azhj7WEJMFdlAxcKnCyn2Kw2Xrt7e4Hkkq4Ua++QPoVpdy1FlOMzPOSOeYVlcY/sg+i24zdLSI3MChu2OEiVlca5+6tUe3P59sYSD9ExBuZi+OWe2Ke08thbiUrM60+rlIfvEy/ehRtqU+0kwvfpucETJrFgVutSQemlp5wMwAaeWTSKBGi/5MnjtOeHiw94X9AwRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV2PR11MB6000.namprd11.prod.outlook.com (2603:10b6:408:17c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.16; Thu, 4 Jan
 2024 22:26:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7135.028; Thu, 4 Jan 2024
 22:26:12 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "peterz@infradead.org" <peterz@infradead.org>, "Gao, Chao"
	<chao.gao@intel.com>, "john.allen@amd.com" <john.allen@amd.com>
Subject: Re: [PATCH v8 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Thread-Topic: [PATCH v8 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Thread-Index: AQHaM+ybdHxGU7FdA0WJCW/8YQZk7bDHLVEAgAMk4QA=
Date: Thu, 4 Jan 2024 22:26:12 +0000
Message-ID: <41602aa2e8f6e8813f58eca42bf9ece53d236978.camel@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <20231221140239.4349-5-weijiang.yang@intel.com>
	 <ff50b8907eb6aa475b4572f6ec03355cb0d3d2a9.camel@redhat.com>
In-Reply-To: <ff50b8907eb6aa475b4572f6ec03355cb0d3d2a9.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV2PR11MB6000:EE_
x-ms-office365-filtering-correlation-id: 81b63838-c40c-4afe-da88-08dc0d7428a7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hNivdowXYl70jAMZsJxp13L7AMFoMG/xxNZRBN9xWjzSd0UFb64C2Z9hysoAiRmvNjPefw0fOntFDo/lgaHUanwW1/9CmDwyJ8A661h9APlT7CIpIqtQCRGVH/iEZmnKD8QYJmK2VYSAsYwdLAu52Bq7i1RImoEYZ6MA8zoTH4+E+dhZiLcTlStGhbGfOGYUspO/rbgEaKsjRrbspgfSyeReka74DlYKdHOU4zuH3eXLSmsHUGZ7b/Ya2P4DJpFPTRds2n82OTY2JFQMrkzmSmzhQzATJcdnNvGicU6H75dtLRPLfmhw4SGdnHHzzzTEystNFG/mWb0jNDkBWaKPtmtXXhPUXI9gyLInZndHwmyEjsRK6UMfml/njd58hlq+2JMBW7E29Q+Jh6d8oInyrk+p5qLDLcA6GjJyw5IchcdddqyuO56GXVq2Q871vVUe9vB78jf9gpdw4I4cQOdOeTxFO56XPjr+OUvgG+WkpdgfTi/T73Ss6TSQKqGG3j5IsPt0z+GtEngt4aSaoWogNzgHfG3NY7/YQIB1xwvPuCw9hJ5GpopvfYnNS6APo/2ScOoHRlV9BxqhDRUn/DeNORsWgk8YqcknMuRqwiSmQQk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(366004)(136003)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(6512007)(2616005)(26005)(71200400001)(966005)(6506007)(478600001)(83380400001)(2906002)(5660300002)(6486002)(41300700001)(66946007)(76116006)(91956017)(54906003)(66446008)(66556008)(4326008)(8676002)(110136005)(8936002)(64756008)(316002)(66476007)(82960400001)(86362001)(122000001)(38100700002)(36756003)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVU0UnFrNVJtTzZybjJxRGlvZFMzT2grNjYxNzFLR2dkTXFqbFkvWjlkK2h5?=
 =?utf-8?B?YjRKNUdIUWJ4MGdxV0xYdTREYzBaV0lXVUlKV0toNGVLQUcxRW1tcXZqeTRK?=
 =?utf-8?B?NUoxdURvS0ZjVHBudkJBdnhlYnFZM3NPNURVV1pZb2xZSSsrWlV6YmN1Vkx2?=
 =?utf-8?B?K09Vd1QrMEVQZzd4ck10eVZWZVp2cnN0aUVpK2ttR1FYS2hZc0JBV3h2bEM1?=
 =?utf-8?B?Umx2cEVsYnZMcWZFbDRQMFc4K3l5SGtaVXY4T1FCUHpJZndva0lKVUM2Qy9m?=
 =?utf-8?B?RUw1dnAzdTgzU2ZJK0Z3VnRUT0tIaGVHM0hueU96QlJZcW5jZjVmU1BFblEz?=
 =?utf-8?B?L3c3RHd6WFBOTm8rY2xKVEwvUGJ4a3o2aTZGcDRvbDNLUDNWdnhhM3BJeCtP?=
 =?utf-8?B?bXpzbVZKVzFTaitLbTQ1Vk5MYmwzWmM4M2xIZExibFZPZWl4K3Q2TmNWYmdm?=
 =?utf-8?B?VGNBYXBpdEVHSmJLYmczSkFUVTFDbFdiaklBbnhNRFVtZisvK2p6Wm1ZeFRY?=
 =?utf-8?B?em5lWXJZaExrOW9hWTNIcTBSQmdPbThZdXREYXRIVXNYaUNOdjBPckphQytC?=
 =?utf-8?B?UEROUlg4Nko1MW1IL3FWZTdMMWVwYUVZREZMRnVHS2RUaWxwSGpYQm5JOWYr?=
 =?utf-8?B?U0tWei9RZ2IwVng3eW1GemE4M0lrL1owMXdCSUZ0SHhaMzdPNjNWNFhIUTJW?=
 =?utf-8?B?Y0N0Q3Z5TnE3c3UrUGhaYXdEUldjYi9FdnhIVzkxYVl6UCtBN2UxZlNyckxZ?=
 =?utf-8?B?ZldsaG1WWitxZFMrVDhETmhRS29zVENPUEJWZmdmUXcyTjFxZ2RnQVBHdUNi?=
 =?utf-8?B?bmhyYlc0UUcwbFBJdWtFb2V6L3NYa3Q0NDRiZ2FjVXZSeVhpamVuaVNObVhR?=
 =?utf-8?B?S1JMQXFGRHMyUE9GVzNscUtKTmZCK0RyYWwxNWJFQ2hCYkl0UElGbHhzd20z?=
 =?utf-8?B?TnNzeDl0MkdxTTlCSmRIWXJnZENMdDZwNW9JSzBUVVJ2QUsvZzBFeXMzMjZR?=
 =?utf-8?B?Q1pBdlhZVlFGNGtRbDgyTkFrVEZKeUdZb2dEZC9IVi8vWTQrK0N1c3ZaaWpO?=
 =?utf-8?B?cWFUZmdEQ25ucjJWT3lRbnFqd2RLRHZIeStMWDNlRXJNSnNMQ1k5K3IyNWpB?=
 =?utf-8?B?VGtUOG15TDVDaEMxTnVvZkdORnlyMDFpTldkRTdYUXVZbm50UzhDZzdZTFFP?=
 =?utf-8?B?bVk3MGFQRzJCZFN1Tk9PMTlTbTE4VHMyUjhqUnZOT1JlZVRrN29LSEtZS0t2?=
 =?utf-8?B?TUhMSXB1VWtrV29wY0Y4dkdrWitFSjhuYmUwTUVBZnNwLzZsMDdMbXRnTlVX?=
 =?utf-8?B?aXJNRTRHYjcvajd0cmpLT0VHdUI4WldjNGpFa3VVcDVQZ05xWnlIRWxrLzlu?=
 =?utf-8?B?NmNhS0VJTmVuQzhhS3kyelRDd0ZpVFYwRXNGTC9wYnZBYVlWOTRtTVE3a2xa?=
 =?utf-8?B?bU96UjNweFJmZ1Y0Nk9qVThaaFAwa3B2dldFaGlEWGdGMWZMWmVFbWFEK2lR?=
 =?utf-8?B?MFZ0cFh2ZmNhUEJsUndFWEdxeS80ellmb1MrYUZHMmZjT1A5RTNhMTNNWWNJ?=
 =?utf-8?B?amN3Z3VYT0tHZUhNaUlDaVJkNXFqVEF2bVZVZGJWYm82RlRkWVZ3UFltRThF?=
 =?utf-8?B?ODh1T1BnMHZHbzkwK3doTy9nelJYclZaSnlOUGkxNjJHY1hRekNYSTFCTWsy?=
 =?utf-8?B?cjVzQ3B1ZkhKakw2WFFBVU1qRGo3c0hMcjJ6TUhvenBWYzBKaDhVZml2U3Z5?=
 =?utf-8?B?SUVENWhzSDBlNUd3SmMyN09rRlZ4dS80VjJyaS9EZVFROWlDbmZLZEM2ci9v?=
 =?utf-8?B?aFo1M0lwV1FLaXpkZmVIcndyRks5SjVGd1RQTHIxcE82L2swZ09FSlNLMXBD?=
 =?utf-8?B?YzBNYWIvTnNkd29JVVVEYWpVWHl4cmZObkFvcmNFVDRwZ1cyNHI0TW5uemkz?=
 =?utf-8?B?dXpyR1NyNlR1bVhDWVh0cGN6cU9zV1lkZEQ4TkFMcllVVHYvTDhTUzNCRDVv?=
 =?utf-8?B?TlpiM1VId24xbE9ZVzBCckp3MWUxZW8rRHhwdmxNS3VWa2VZaDVQeE1WWVRI?=
 =?utf-8?B?aGZDQ0dkVzI1cUhnakl1QVdCMkNxeGsrOStjWmU2WXNkV3pab3J4UTNWUG9N?=
 =?utf-8?B?NUMxa2FZdjdaMzdZc1dkVEpoUlVhcjNsRkN3VDgzek50VDgvQkgxejAxaWFM?=
 =?utf-8?B?S1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B047B7393310F6469E08A7C371CF6FAA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b63838-c40c-4afe-da88-08dc0d7428a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2024 22:26:12.8662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dlOl9RY3XQEgv8dAkc7J7Q1hNWYAJwojUWmUY2fw8NYZLt+ddEyAl1isG9aYw5rHQdwALBudxx6Gk69+dYQT2ZK2FGAJhSD8sZquy7aQt64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6000
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAxLTAzIGF0IDAwOjI1ICswMjAwLCBNYXhpbSBMZXZpdHNreSB3cm90ZToN
Cj4gSSBzdGlsbCB0aGluayB0aGF0IHdlIHNob3VsZCBjb25zaWRlciBhZGRpbmcgWEZFQVRVUkVf
TUFTS19DRVRfS0VSTkVMDQo+IHRvDQo+IFhGRUFUVVJFX01BU0tfSU5ERVBFTkRFTlQgb3IgYXQg
bGVhc3QgaGF2ZSBhIGdvb2QgY29udmVyc2F0aW9uIG9uIHdoeQ0KPiB0aGlzIGRvZXNuJ3QgbWFr
ZSBzZW5zZSwNCj4gYnV0IEkgYWxzbyBkb24ndCBpbnRlbmQgdG8gZmlnaHQgb3ZlciB0aGlzLCBh
cyBsb25nIGFzIHRoZSBjb2RlDQo+IHdvcmtzLg0KDQpIaSwNCg0KVXNpbmcgWEZFQVRVUkVfTUFT
S19JTkRFUEVOREVOVCB3b3VsZCBiZSBwcmV0dHkgY2xvc2UgdG8gd2hhdCB3ZQ0KaW5pdGlhbGx5
IGRpc2N1c3NlZCB3aGVuIHRoaXMgc2VyaWVzIHJlc3VtZWQ6DQpodHRwczovL2xvcmUua2VybmVs
Lm9yZy9sa21sLzIwMjMwODAzMDQyNzMyLjg4NTE1LTEwLXdlaWppYW5nLnlhbmdAaW50ZWwuY29t
Lw0KDQpFeGNlcHQgdGhhdCBpdCB1c2VkIG1hbnVhbCBNU1Igb3BlcmF0aW9ucyBpbnN0ZWFkIG9m
IHhzYXZlcy4gQnV0IHRoZQ0KZ2lzdCBpcyB0aGUgc2FtZSBJIHRoaW5rIC0gdGhlIHN0YXRlIGlz
IG1hbmFnZWQgbWFudWFsbHkgYnkgS1ZNLg0KDQpBIFhGRUFUVVJFX01BU0tfSU5ERVBFTkRFTlQg
c29sdXRpb24gc2VlbXMgcmVhc29uYWJsZSB0byBtZS4gSSBraW5kIG9mDQpsaWtlZCB0aGUgdGhh
dCB0aGUgTVNSIHZlcnNpb24gZGlkbid0IGNvbXBsaWNhdGUgdGhlIG92ZXJseSBjb21wbGV4IEZQ
VQ0KY29kZS4gQnV0IHRoZXJlIHdhcyBhbiBpZGVhIHRvIGdpdmUgWEZFQVRVUkVfTUFTS19LRVJO
RUxfRFlOQU1JQyBhIHRyeSwNCnRvIHNlZSBpZiBpdCB0dXJuZWQgb3V0IGVhc3kuIEkgdGhpbmsg
aXQgdHVybmVkIG91dCAib2siIGNvbXBsZXhpdHkNCndpc2UuIFNvIGl0IGRvZXNuJ3QgbWFrZSBp
dCBjbGVhciB3aW4gb25lIHdheSBvciB0aGUgb3RoZXIgZm9yIG1lLg0KDQpJIGd1ZXNzIGl0IG1p
Z2h0IGJlIHNsaWdodGx5IG1vcmUgZWZmaWNpZW50IGFzIGluIHRoaXMgcGF0Y2ggYmVjYXVzZSBp
dA0KZ2V0cyB0byB1c2UgdGhlIGxhenkgRlBVIHN0dWZmLiBJdCB3b24ndCBuZWVkIHRvIHNhdmUv
cmVzdG9yZSBpZiB0aGUNCmV4aXQgaXMgaGFuZGxlZCB3aXRoaW4gS1ZNLCBvciB0aGUga2VybmVs
IHN3aXRjaGVzIHRvIGEga2VybmVsIHRocmVhZA0KYW5kIGJhY2suIEkgdGhpbmsgdGhhdCB0aWx0
cyBpdCBpbiBmYXZvciBvZg0KWEZFQVRVUkVfTUFTS19LRVJORUxfRFlOQU1JQy4NCg0KUmljaw0K
DQoNCg==

