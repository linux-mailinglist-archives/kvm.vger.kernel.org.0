Return-Path: <kvm+bounces-5737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A53B6825973
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 18:53:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18C13B21261
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 17:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A593589D;
	Fri,  5 Jan 2024 17:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fkW9U0kp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D523529C;
	Fri,  5 Jan 2024 17:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704477145; x=1736013145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qQ9qSkfe+NOAELUBosiiVzNtLZY6C4+fHUB1QK9Uvgc=;
  b=fkW9U0kpQlXFtS9te2ZKRhixYMjhSsVOLk8sutLEDqZZANSUsQLhxgwb
   jboB0XUV5ZIfk6UFCe0BjlvoP49IdHrhxKcTUP7QhsiM/0yII7VJVCCzM
   s63v/Rn8rgyHAUMI+NFHpvqlMQI5D5KM0S+B3QHgwZVnQvVpBcNJXc4ho
   nW1EEBX1Bcld0T7qCFLQH5kzawsSsRJk1TnP3OhlLTZIROluIcmX48e1D
   8pu+x4PVHuc4KnzErtch6TEU4RI3/MUu2GCKoQnUBrQnYBo0+ZJjUxu3d
   PlE3uDCDk+yFFtjYbcZcmIMlm5JZS7cOWJJJGhK4jEnQCBrt+YafBKfem
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10944"; a="463947062"
X-IronPort-AV: E=Sophos;i="6.04,334,1695711600"; 
   d="scan'208";a="463947062"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 09:52:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10944"; a="1112149834"
X-IronPort-AV: E=Sophos;i="6.04,334,1695711600"; 
   d="scan'208";a="1112149834"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Jan 2024 09:52:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Jan 2024 09:52:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Jan 2024 09:52:23 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 5 Jan 2024 09:52:23 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 5 Jan 2024 09:52:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THer1HTygJQU2E5KFrk9djnjMy4d0N8WsrTseRA3ppqK0J1ICePc1tv8Bk3Tu/OXVnAzTaXdVvHgnZYsQcYfvkNfWiJbPu7u+Oyhf2eSrnU7jLbnHSjvszPjHDbkaAO/uF8CPafKf+mqWGKMvVwCl7IHCkIHdRCgoahI4+m4QmHOwv3Gj6SCiogto7j0FjfjkU1Tee83FNnOK4HEpZSIsbiCAXIJOmY+Xm7+n8rroDlfdtUBcdDLchfzfVaS7Wk/6lmq65fNU12lx7bPBD5ppjqEe+gw0zH/SQ+Ts5p7kykURoCl5aLv60D+mC1w85/5sG/uFlBgdrYsBWnuvFX7RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQ9qSkfe+NOAELUBosiiVzNtLZY6C4+fHUB1QK9Uvgc=;
 b=AMXZww6c0xTt5HgG+yR2m2Zk2QqtjzEkNA0qefaT1Pc9Z/mprNCbJWpEh01rPJjhmJXtJ4w566m3sgUjIBiynLzYA4b/7ZJsb7AwbihfLQ39a331QBmhnFZE7c6bUI6YXm7SvkdSOCgXGsK+A4DEuaohSwPD8Og8pM06WoxjHJaXWu3or5UUaLijhSWUZMrnwRzUAJsD+SRubh0uBvp0Q1hoEY4TZwzKBKenDRHTYJ04aJ5giXUd1/IEAQXEvYZzWpDjk2MdUZIXw+Cc5pY/2tQAKt6moXM1pP6SuGcenaKmwcYy9Dq1L9rjCCKXfHViSDed0E04iaGjGWE954Eb9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7882.namprd11.prod.outlook.com (2603:10b6:208:40f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.17; Fri, 5 Jan
 2024 17:52:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7159.015; Fri, 5 Jan 2024
 17:52:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "john.allen@amd.com"
	<john.allen@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
Thread-Topic: [PATCH v8 00/26] Enable CET Virtualization
Thread-Index: AQHaM+ybd3H3II6aZU6KWHt3rvxkNLDIg7MAgADO/oCAAOpTAIAANboAgAADMYCAAAXLgIAAj3+AgABzaACAABlggA==
Date: Fri, 5 Jan 2024 17:52:20 +0000
Message-ID: <9abd8400d25835dd2a6fd41b0104e3c666ee8a13.camel@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
	 <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com>
	 <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
	 <ZZdLG5W5u19PsnTo@google.com>
	 <a2344e2143ef2b9eca0d153c86091e58e596709d.camel@intel.com>
	 <ZZdSSzCqvd-3sdBL@google.com>
	 <8f070910-2b2e-425d-995e-dfa03a7695de@intel.com>
	 <ZZgsipXoXTKyvCZT@google.com>
In-Reply-To: <ZZgsipXoXTKyvCZT@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7882:EE_
x-ms-office365-filtering-correlation-id: eeecd45b-8b14-43f6-54a5-08dc0e1710bd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mImAT5kf6FsfBBezJ/c8fGhfnZo52MBNHGyms1IvNeBWin1Mu4wHJZm953JzHHb+mN2ePME9kAiJYNwjwDD6qxHgWLRncGs7rhyFLj3qKQlygIHUSZV5QxSs8X3HdcqZA0rCQC7Vkes31Rde8VUK+sKTvDnNSLsJdikROOugZoQrKqoaJHFd+S+suLJeWFKTVsY7Zotfw9P9adTgPLD6aDRPaqTSjhtO9H3S/HTJ/iyq3ZgUPyPhxdh+IG3tXD3Lv7IrCE5FqFGhBOQsPRKzf9IMpNbXdzh9t4jhUxS0/enEKtVFY33CXcwq/wXISbCaeKUX+KD6kjqWSCzxdn7+P19/1IrNlhUoX6a+KpqsweUTvxYiyHzBfcrffzWjvbODZmQzIfu4+YCRzsh4DkOpxSmKsG9ujIHcxEpKcc1kgVErgeRNKu9Th4fkVowkOkC6X1X6BqDK9dknwole4dXdOUU7KuGJ93VrCYPSq1DfCdndzqqL3bd0ANIedC7tI8SJMjzhPpAoXwSTLQibceo17K+OsMbvKwA2vCNIu8mfm6Lk2m9B9UZLeVzed9uwxai6vKO5PRlAFYYwYuDiUhXgTCUTs6nPqF4UPIBrHoDMZn95RiWFQIsd2r8VEbn5jz2q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(346002)(396003)(39860400002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(38070700009)(83380400001)(26005)(6506007)(6512007)(2616005)(122000001)(38100700002)(71200400001)(5660300002)(54906003)(8676002)(41300700001)(478600001)(2906002)(6486002)(316002)(110136005)(66556008)(4326008)(91956017)(8936002)(76116006)(66476007)(66446008)(64756008)(66946007)(86362001)(36756003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2prZ1Z6cFEzUTBVc2ZpVFhiL21BcFE2RkhYbGc2ckMvUlFMWVlCUCtJdldn?=
 =?utf-8?B?MjBOTUl0ZW1LTXBvNFl5Wmp0SVNGUDZjWkhzVlV3ZjVzZWlxbDFvRkpndjd2?=
 =?utf-8?B?bENrdXRqS3Badm4xRTd6UnNBT3gwSFhCTTJZTjZxc3JrSTBNZkdjMlVLendr?=
 =?utf-8?B?SHg3QWJxT2VzUVBHS2ErRWdEWWpGRENEMm5tRXc5SVBmZk45NUNkSWJ2Q2tN?=
 =?utf-8?B?bGovK1Q1Wm5tbjJoeDU4UDJOb1N5NVVxOVRQbnVIQzdrZENNUEFPTzB6dHI3?=
 =?utf-8?B?UlZrcUtDd29rZkNHRWd2T1hXTlpsUEZDT0g2SWk5NGpBeFRkZGd0R09LcXNB?=
 =?utf-8?B?RTdabXVqQVBjc1dQKzdveURZY0o1TFdBb0JkNFNkNERtUUkzeWNtdGVlTk1J?=
 =?utf-8?B?Z0NkZ3ZBczdScUIyWjBCSDNMUkFHQm81S0ZLaG9DL2hDOXJTZjNMVCtab2hx?=
 =?utf-8?B?VDNZSCtNQlZuU1ZaMnp4cC9wbE9rTjNkeGFhS1Z5V3l6azcyUXRMV2FmVWRt?=
 =?utf-8?B?UHFqdEZ4UTBtcVV5NUUwYlQzcllmVEhFVStkeWkxcDZMaXNOYXRmUUJ6dlFT?=
 =?utf-8?B?cVNnQytjSG5SZDNjQ1ppdENwaTRsV2FMV2FiWGt1UGdyT1pwSFRnRGpGVjRI?=
 =?utf-8?B?bzBvaHI1NkllSjVqRVMwRWhXNGl5cnREZ3hSZytGeGhFeDFtSEJyUW1mZi9T?=
 =?utf-8?B?Z2JtWTFheWg1UUpTQWh4Q1ZqSHovZDlPYSt3QVhtb2ZMYnF0QXdPalN3Z3lK?=
 =?utf-8?B?Q29qS1FQeWFxdjI5Qi9xbUVTWUFJY1lQZHJZSVBVeTRMVXJCQ0RyT2NJdGVo?=
 =?utf-8?B?VEpEY1d6d3dTSElvYmNVN3ZVYXRibUtUNExRdmtuTGhrYnhXZWpSMWp4UlQ3?=
 =?utf-8?B?N2gxV09nRkVSQnVKamZoTU8zYkFvOWRTU3lzd2M3b3M0NzJRR0UvazFRTkNa?=
 =?utf-8?B?enJZTXp6SWdGRzEyY2d0VElLZllYak5jMnBDSXhIVm50WGREejRHUSsrL3Ra?=
 =?utf-8?B?bFlsY20zZWVETUFjSXI0bStSZW5lTEFHS1NzZDF2bHN5SDNVeTU2QzUrbFR3?=
 =?utf-8?B?b0Q4VGpXK0N0ckl0L1k0YXNVS2kzdHNadnBCVkhQeUhLcXFaaDFsTEVoRHk2?=
 =?utf-8?B?SW4ybjRBdFpwcGFwMlZjRElRL1kxd20vU1FvNnVNakhYRnlwbFQwL211Z1dE?=
 =?utf-8?B?N2tmOTc0d0xFcWRucU9MenZ0eGU4aklxaGQ2ZFlhVFFXOTlYN1NaeHBWaWhy?=
 =?utf-8?B?b2t2L2pwbUxPNTcrbmdLbWRSVStYWEJsc1hOQllMLzRjNDlyVkFubVlXRmZr?=
 =?utf-8?B?ckxicDNWdHVtZEpVWm9KaWZFa1FWWjYyZUMxZ25TZzViZllHMEdTQjNVa2tE?=
 =?utf-8?B?NWZ1MTlqNlZraFdCbVFHYWtsS01zWENxNklkZXE1OTBuS0pqS3hQSXEyTCs3?=
 =?utf-8?B?RHpvOE9XejlpRkFaK3dMQ1VWeFFIcjQ0VmxCS2c0em9FcW1KRFJjWlM3aWpK?=
 =?utf-8?B?WUVJWGY1SmlQd0pKeU5HbDdmWU12T1h2U0lIdWFWcTlDa3h1YVJncmtTMVVY?=
 =?utf-8?B?ODRkMExSSlA3RFpyTkNOUkVkL1c1WktTR3QydW5vZ05mckxXOHdhU2h0dVJV?=
 =?utf-8?B?NWZEbUJyYjE5ZnlsZDhWWmk0SUlqd0pVNWY4aENWdlpiQndaVTVFNERIRFhm?=
 =?utf-8?B?UXdMUTUwcDBXQ0dIaGdZOEVRRlFHYnQydWRhNXRTZHAvdXhtQUh5R0ZwZkpi?=
 =?utf-8?B?TzFqb0Z6SXJYeU5WVjBVM0FqR1laOVRwOU1ocnRuVFBadzRLSng2ZHdyMkF4?=
 =?utf-8?B?bnZEeGdjdkc3N1Qyd1l1OGtyNlZPcmM4eW1vUWlaZHNnQ3NPNjJWbnBZa0Zk?=
 =?utf-8?B?UCt6RWpuUEp2QWZvT0VEWkprUmZkVVJ6d2dRZlo4WlZnQk5LZ0NjQS9qYWxE?=
 =?utf-8?B?MnpvRWhDMTR6bVo2NlZ6YzRJRjRlYkdvVi82U2xReVpOWHpmUjlnM1IwUHdC?=
 =?utf-8?B?TmpqSWZyVVFvOFBJSmVNNGErUkdlb3dxVEhlengyWkRxaG1ySTVsSGhRRGsr?=
 =?utf-8?B?U2hta09pVjd6aDJHbUpqM2dGK1BibEFiZUhSSFYzL3BZMnViQmJYdGZweTBL?=
 =?utf-8?B?a1phUkNrelBDTzd4QzE1N1ZHUTZKWTdSWjRtQnQyNE0ycG52UlZNaERvbnpo?=
 =?utf-8?B?anc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34177FD7D4CAD1489B5697779E1F6B33@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeecd45b-8b14-43f6-54a5-08dc0e1710bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2024 17:52:20.7441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hiaeew5doJocg4TVj+9QtfIbKi7m7rMXJQbb6DhBlTxG4rJWqWGCs3ZHJwVoHaXgiVRu2AWxcfruAdTop9luY39RvXtm0ZYGHgiE9PfJB/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7882
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAxLTA1IGF0IDA4OjIxIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBObywgZG8gbm90IGluamVjdCAjVUQgb3IgZG8gYW55dGhpbmcgZWxzZSB0aGF0IGRl
dmlhdGVzIGZyb20NCj4gYXJjaGl0ZWN0dXJhbGx5DQo+IGRlZmluZWQgYmVoYXZpb3IuDQoNCkhl
cmUgaXMgYSwgYXQgbGVhc3QgcGFydGlhbCwgbGlzdCBvZiBDRVQgdG91Y2ggcG9pbnRzIEkganVz
dCBjcmVhdGVkIGJ5DQpzZWFyY2hpbmcgdGhlIFNETToNCjEuIFRoZSBlbXVsYXRvciBTVyBmZXRj
aCB3aXRoIFRSQUNLRVI9MQ0KMi4gQ0FMTCwgUkVULCBKTVAsIElSRVQsIElOVCwgU1lTQ0FMTCwg
U1lTRU5URVIsIFNZU0VYSVQsIFNZU1JFVA0KMy4gVGFzayBzd2l0Y2hpbmcNCjQuIFRoZSBuZXcg
Q0VUIGluc3RydWN0aW9ucyAod2hpY2ggSSBndWVzcyBzaG91bGQgYmUgaGFuZGxlZCBieQ0KZGVm
YXVsdCk6IENMUlNTQlNZLCBJTkNTU1BELCBSU1RPUlNTUCwgU0FWRVBSRVZTU1AsIFNFVFNTQlNZ
WSwgV1JTUywNCldSVVNTDQoNCk5vdCBhbGwgb2YgdGhvc2UgYXJlIHNlY3VyaXR5IGNoZWNrcywg
YnV0IHdvdWxkIGhhdmUgc29tZSBmdW5jdGlvbmFsDQppbXBsaWNhdGlvbnMuIEl0J3Mgc3RpbGwg
bm90IGNsZWFyIHRvIG1lIGlmIHRoaXMgY291bGQgaGFwcGVuIG5hdHVyYWxseQ0KKHRoZSBURFAg
c2hhZG93aW5nIHN0dWZmKSwgb3Igb25seSB2aWEgc3RyYW5nZSBhdHRhY2tlciBiZWhhdmlvci4g
SWYgd2UNCm9ubHkgY2FyZSBhYm91dCB0aGUgYXR0YWNrZXIgY2FzZSwgdGhlbiB3ZSBjb3VsZCBo
YXZlIGEgc21hbGxlciBsaXN0Lg0KDQpJdCBhbHNvIHNvdW5kcyBsaWtlIHRoZSBpbnN0cnVjdGlv
bnMgaW4gMiBjb3VsZCBtYXliZSBiZSBmaWx0ZXJlZCBieQ0KbW9kZSBpbnN0ZWFkIG9mIGNhcmlu
ZyBhYm91dCBDRVQgYmVpbmcgZW5hYmxlZC4gQnV0IG1heWJlIGl0J3Mgbm90IGdvb2QNCnRvIG1p
eCB0aGUgQ0VUIHByb2JsZW0gd2l0aCB0aGUgYmlnZ2VyIGVtdWxhdG9yIGlzc3Vlcy4gRG9uJ3Qg
a25vdy4NCg==

