Return-Path: <kvm+bounces-5591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2048234F6
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 19:51:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EF551F223C1
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1E41CA9A;
	Wed,  3 Jan 2024 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GPy2GDYs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BB71CA82;
	Wed,  3 Jan 2024 18:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704307862; x=1735843862;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ReDtQh3TGQgOtxAZFZfLD4HlqdH23bUllPurU94kjPw=;
  b=GPy2GDYscRZ2YRMBN4PYU5lmDwZGrbVifYMvt8d0qcQ+sP/1SfaZzbNf
   QSt1XW4HUwuw/P2+GG+KbYfLsjSCUnHGOsdMdU1o9RJGT8neB2FF8R4U4
   B3amlNHOXicuqx9G40ea5DpDrPXvNK3emEG9TKnF1Bp0iBYctFj/rexD2
   X0wjV6GEjQXLCLgrhkprp25RYV4Bz3KewZ6V/QFZwSjP2WwNzD38vrlcA
   bjMiE/1DWTH3tQ9wK4fkeaMXdKDG67vqe6TeSGOKcbf8alCcWnkM0DP5j
   YUqjsXEFaIc4r+8CGPmkzDvPeSV8bBv1zzVYG+Wjxx8PDMPuzYjIhCcEh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="10441330"
X-IronPort-AV: E=Sophos;i="6.04,328,1695711600"; 
   d="scan'208";a="10441330"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2024 10:50:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="780064384"
X-IronPort-AV: E=Sophos;i="6.04,328,1695711600"; 
   d="scan'208";a="780064384"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2024 10:50:57 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Jan 2024 10:50:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Jan 2024 10:50:56 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Jan 2024 10:50:56 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Jan 2024 10:50:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILbiAYeGhFraW9MFjGnvgCh7kyW7dFQDLrAGcwgzzpz6p/w0ve1OHx3ZE1mqxtGIvAqfdfGZGR/XnHidM96mpL519mG1mwSqVmfJiKxqqbzB8AOmTveCrpO9Qqsb47iaHNfdLMyHFKxLOBno4qlHGtkPo/16fNEd2AepMUXNJXzQEtPhIxATZT8QDG+CK2WhsYDKDkRl2QhKEUPBBmv3cjBKW0ffl6fzG6OTAoy38Etv9gwUABMVCkeaBJtK7qpgSx89AHkKnl1xD/v8ZmvAEbGZ89zev+qhuvGTAdtq15Gkv8IdVMifEGxAY1KptSPB+Scfd25UTq5w8AvZyn6TcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ReDtQh3TGQgOtxAZFZfLD4HlqdH23bUllPurU94kjPw=;
 b=R1TTjeZp4ZUxco414HtMrDe9T8z8NmLiT+E/3PhDQlmduVW0YgwDW5R+awVCYdGHbrWDdQHVRSNcsD3QfKjCMp4xu3ziCo0g9TdMY3skCwsxP0tOEvl8Ke7tyrRuQCF2dZpUjd2uEXxNnA6WuFe1ioGmOcx29n+2Hn+w+RNkwQugD7le8+WkbmhM55rzLOGp2UgNppFslhZi3rJa25Jc/5jBucbD2W/Q0Yq2MTBaj/BK/2FMcf7MULJasxaOIHHVVbEPx+ocTUL9/R/SlbcqsU4kG97txTMBYcFKPiTQu4QPc4fSgYR09JvvavCUfE6AJ6X3i+jnN0aJwrpN7KxKJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB5900.namprd11.prod.outlook.com (2603:10b6:806:238::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Wed, 3 Jan
 2024 18:50:53 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7135.023; Wed, 3 Jan 2024
 18:50:53 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
Thread-Topic: [PATCH v8 00/26] Enable CET Virtualization
Thread-Index: AQHaM+ybd3H3II6aZU6KWHt3rvxkNLDIg7MA
Date: Wed, 3 Jan 2024 18:50:53 +0000
Message-ID: <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB5900:EE_
x-ms-office365-filtering-correlation-id: d8550ad0-b2c2-4868-f9ca-08dc0c8ce9b5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W/YkHF+NYsrsikF347wMrFpr4CdUuOZTexG5GyyveowHsBDMK9hibJ8D+BSYYTijj2L3F59C0rPbYmWpIyZUhH+oLzcv6VHe2oK141Gy/KlVyiOdT+ZTeLjvDTZTxdaRxtFKdV+PKO4CyMNNZ6hUQHjnLU+kqEkkQ8tFfLFRRYNe3yPgtEE0NMjooshbRf9AcCtJZXbY2ASZOJwGamxo9b8SsXrHzYQm9//mlQQO6jjOG4CgCsfz+v07UU/D6mKCvDAhItwNsfTOdfaXt8guzSZLoRalu5QFYoajcRPylkCJEZ1dAW34MWd/4cOjt0t/qhBbxGgI34nQpj+t5aCLhNn7op8tD/De63R0/eTM9IwbJC+vd37mf1bobd8H035wkTQNpGWiQMBx8Cz5C5HFdRi0yg/xPPze6Wsk4AJEsWh/GmdaP6R9cD4xvnXYrRywmhM1qLVtQtD6hnkOkj1OWPL35syumxPsLBQ1WQdywccwwKulw3A3zREE+zY+lX/os1MbM1lr/ePCMJ04M989A0RdiFm5vKOjbpO8jzvY2SP1ZHmKQWgK4RtVlM6/Hvu11/5gp8clCdUsnjCRUVyYdpUeL7uaoHrhDKNzIG58Uc6hKRG+53z5ur/6zH5Jnrhl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(346002)(39860400002)(136003)(396003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(64756008)(66556008)(66446008)(66946007)(66476007)(6486002)(4326008)(76116006)(91956017)(2616005)(110136005)(316002)(8676002)(54906003)(8936002)(26005)(6636002)(71200400001)(478600001)(2906002)(4001150100001)(5660300002)(41300700001)(6506007)(6512007)(38070700009)(36756003)(38100700002)(122000001)(82960400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGgwckVvUFVxdVBJdDg4ZnZyNktDM1gvYXllZmxDSzRJbGJQUWRKVGVJNll1?=
 =?utf-8?B?clViKzVLY1gxVC82ZTlWVzZjNFlwYVJ2UmJxcXQxNUFUQVhqSTYrbmhURHRr?=
 =?utf-8?B?amFXWDRmMHY4dmdBOGV1V3JuUWRaaXRZUFJQeUNUNjgrMXRCTGxVZXNjaXJL?=
 =?utf-8?B?QmR3REt5MFFmNWlmNSs4Ym4xUGpVRkRrdGgrUjhnUmc5aEtiQ1pqZkUrRDV5?=
 =?utf-8?B?TmdiTTd6dGx6UG9VNFZNTktTemN0ZDFYV3R5UTJwa3pLeFhnTWdacExQU2Zl?=
 =?utf-8?B?Y0lqd0JRLy9TZk5wZDd0TzFkbENpRVJuTEllTi9hNTc2WjhTK3p4ZDJjUlhu?=
 =?utf-8?B?M3pIdVBhOTZIVDJNcjBHNDVzZmxxejRuU2cxU2ttejRJV3hJRXJYbGQ5VUNX?=
 =?utf-8?B?dFlqWFFjUm8wNENjZUhBN0htd2ltcHBpaXVrTzRwL3AzenRzVkxxcUE2L1pl?=
 =?utf-8?B?MFE1ZHdwRzMySnZQZWF0WjFiY2hIT3pQQy8rVjVrRDR5TGoySDgrN0p6ZE41?=
 =?utf-8?B?YXkwYks2Z21tV0V3MDkyUEJ6Y0QvdkZQa1JvcFgrL0VLZDExMG5LTVBKUUtv?=
 =?utf-8?B?UG9EV0RwT01QOUR0OUlKRmxRdHNrd1F6Ylo0aUQzeHhNbWp1UFAvZnlWQkor?=
 =?utf-8?B?U2F0SjFrQTZRSStWa0NyL2JGOVp4OXMrRWJMVkEvVzBIc3l5YXROMDZOdmhH?=
 =?utf-8?B?S3JPY20wUU92cnBMZmhhNUdwWHlsTCtFV2tSTUJ6MUJYdEdBd2dwaUhyQXhj?=
 =?utf-8?B?QU85YTY4WVVBTWxEc3FnTXRMWWdQcnVreEZEYTUyR0pvd25IMnNpM3ZKZG9K?=
 =?utf-8?B?ZXVSbDc2Q0xzWXVpNm53NmF2R2h0WTBoVkZDbjdQc2FLbHhRc09ySEszR3Zz?=
 =?utf-8?B?NFJsUUxWUjdxVXd4eWYvVXNsZXVKV0gxbXlpd2k5Yi96eTFiM2FqVDA1Sytr?=
 =?utf-8?B?U0dpREhYNUJ0ZGZ4K25xUytVSXVlUjF3WnNHQnpSOEdjYno5VnI1cngxcFNR?=
 =?utf-8?B?YTVjNmI4SGdleE1iR05YeTVsVEppbHhQWWxkM0hMdnR4d3F5QWg2alYxdG1V?=
 =?utf-8?B?cUM0RjQ2Z3NMR3ZacHBtSEMwUWJlbXRzSktwN1RaOEgrZDZ2bEFySVV5KzY4?=
 =?utf-8?B?OGY2QlZQZGVVbGIzck5YVE9qT3B5cWYzQTVxdFhLMzJUd2pLNm9PT2NhaHdU?=
 =?utf-8?B?WkhjV2s1SU44VXFjU1YvdWpab05FdTd3YkJGcHZldmg4azc4TWRHV2hQeG8v?=
 =?utf-8?B?SFFIMEFBbjZYdGh4S29SZnFNVWNhL2J2MGdvY0RCVjRmc0ZXMHpBRGhVaEtt?=
 =?utf-8?B?S3R4TWFodG9VSFUvVHFiWmF5bHZYdytZelFqWHNSMU9CTHhUdTgzYlJiYXU2?=
 =?utf-8?B?c2NvVjg2TWhmOEI4VUtlUS9aS1piMnYyNmcvTUZnZHdjQmgyTWVxRzhXbFY4?=
 =?utf-8?B?QjYyT2s5ZVFmT3hkSUtEamtqWjZwbkd3K3pVL0t4UEk1WGhOSFAxcHlFc3JG?=
 =?utf-8?B?bTFkOCs5cHVzQm5IQ0tvYkF2TmV1c0hzRTdPNGEyVW9zRGlJMnYzRGNJMzM0?=
 =?utf-8?B?bThVL2xzUWJ5VEMrTlNsalZ0QTNka3ZRNTFCaUJCV3ViZkR2U25ReTZOWVZr?=
 =?utf-8?B?NS9JbUhhVitmR0IwRGF1MnpVZndGRkdIYWtrZkFiQjg1Z3VYVmpTcTJwUzdX?=
 =?utf-8?B?dFdiaDdGZEJ2TjEwaVZvUzAvOVBlbXZ5QnhoTEdnWGRGOGNudit5MVB2Rmdx?=
 =?utf-8?B?WVQvRU5uZ1NRUGw0UlFCTi9hNmZZQlcvdElqdllueGZtcUdGZHRaUG54cCs4?=
 =?utf-8?B?Zm9YdC95K2JTdHZLQ0E5U0NyZjdlZUsrM1J4OUQ2RVVqcituYy9WVUtOZHdz?=
 =?utf-8?B?RWtXRjBZVjM3U1pBaS85Uk5KemtWczNkNFpMb2JsNDFoQ3lFUHpLd0xqeFlk?=
 =?utf-8?B?N05TemZOT0tQMDFMaGRVV0ZqMUhKZHFMc1ZSbnZVOEwzc3R3eEtqMEh6ejJm?=
 =?utf-8?B?dUFDMFlFVjM1MU81YTI3U0p3blhkWHVqTkVKTXRxZjNySEdjcUFtYWFibERZ?=
 =?utf-8?B?VnBQZ0tFa1MvQ3ZpbUNlcE1ZdGI3ZnlMWWxuWkNjK01QbXBuZXZadkNPNHVU?=
 =?utf-8?B?WjFPSzA5aWJYeVBDdkg0Sm9JbnQ4eFI0SFRkZFN2TVhKYlA3SDhrMWE4UGUz?=
 =?utf-8?B?Znc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D8DF62E3FC9FD4C915D1873C9A9E893@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8550ad0-b2c2-4868-f9ca-08dc0c8ce9b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2024 18:50:53.5388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rj7lM7/h+Ucp91yxm1NHMYXiTkEwMyBOA29oE3k7v+TSNvNq1vkEqp5aGMGCrsWUuQhMGQcldIzo2//IVNYqs8mutGL8eTTK1BL+2kO6wbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5900
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIzLTEyLTIxIGF0IDA5OjAyIC0wNTAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiBDb250cm9sLWZsb3cgRW5mb3JjZW1lbnQgVGVjaG5vbG9neSAoQ0VUKSBpcyBhIGtpbmQgb2Yg
Q1BVIGZlYXR1cmUNCj4gdXNlZA0KPiB0byBwcmV2ZW50IFJldHVybi9DQUxML0p1bXAtT3JpZW50
ZWQgUHJvZ3JhbW1pbmcgKFJPUC9DT1AvSk9QKQ0KPiBhdHRhY2tzLg0KPiBJdCBwcm92aWRlcyB0
d28gc3ViLWZlYXR1cmVzKFNIU1RLLElCVCkgdG8gZGVmZW5kIGFnYWluc3QgUk9QL0NPUC9KT1AN
Cj4gc3R5bGUgY29udHJvbC1mbG93IHN1YnZlcnNpb24gYXR0YWNrcy4NCj4gDQo+IFNoYWRvdyBT
dGFjayAoU0hTVEspOg0KPiDCoCBBIHNoYWRvdyBzdGFjayBpcyBhIHNlY29uZCBzdGFjayB1c2Vk
IGV4Y2x1c2l2ZWx5IGZvciBjb250cm9sDQo+IHRyYW5zZmVyDQo+IMKgIG9wZXJhdGlvbnMuIFRo
ZSBzaGFkb3cgc3RhY2sgaXMgc2VwYXJhdGUgZnJvbSB0aGUgZGF0YS9ub3JtYWwgc3RhY2sNCj4g
YW5kDQo+IMKgIGNhbiBiZSBlbmFibGVkIGluZGl2aWR1YWxseSBpbiB1c2VyIGFuZCBrZXJuZWwg
bW9kZS4gV2hlbiBzaGFkb3cNCj4gc3RhY2sNCj4gwqAgaXMgZW5hYmxlZCwgQ0FMTCBwdXNoZXMg
dGhlIHJldHVybiBhZGRyZXNzIG9uIGJvdGggdGhlIGRhdGEgYW5kDQo+IHNoYWRvdw0KPiDCoCBz
dGFjay4gUkVUIHBvcHMgdGhlIHJldHVybiBhZGRyZXNzIGZyb20gYm90aCBzdGFja3MgYW5kIGNv
bXBhcmVzDQo+IHRoZW0uDQo+IMKgIElmIHRoZSByZXR1cm4gYWRkcmVzc2VzIGZyb20gdGhlIHR3
byBzdGFja3MgZG8gbm90IG1hdGNoLCB0aGUNCj4gcHJvY2Vzc29yDQo+IMKgIGdlbmVyYXRlcyBh
ICNDUC4NCj4gDQo+IEluZGlyZWN0IEJyYW5jaCBUcmFja2luZyAoSUJUKToNCj4gwqAgSUJUIGlu
dHJvZHVjZXMgbmV3IGluc3RydWN0aW9uKEVOREJSQU5DSCl0byBtYXJrIHZhbGlkIHRhcmdldA0K
PiBhZGRyZXNzZXMgb2YNCj4gwqAgaW5kaXJlY3QgYnJhbmNoZXMgKENBTEwsIEpNUCBldGMuLi4p
LiBJZiBhbiBpbmRpcmVjdCBicmFuY2ggaXMNCj4gZXhlY3V0ZWQNCj4gwqAgYW5kIHRoZSBuZXh0
IGluc3RydWN0aW9uIGlzIF9ub3RfIGFuIEVOREJSQU5DSCwgdGhlIHByb2Nlc3Nvcg0KPiBnZW5l
cmF0ZXMgYQ0KPiDCoCAjQ1AuIFRoZXNlIGluc3RydWN0aW9uIGJlaGF2ZXMgYXMgYSBOT1Agb24g
cGxhdGZvcm1zIHRoYXQgZG9lc24ndA0KPiBzdXBwb3J0DQo+IMKgIENFVC4NCg0KV2hhdCBpcyB0
aGUgZGVzaWduIGFyb3VuZCBDRVQgYW5kIHRoZSBLVk0gZW11bGF0b3I/DQoNCk15IHVuZGVyc3Rh
bmRpbmcgaXMgdGhhdCB0aGUgS1ZNIGVtdWxhdG9yIGtpbmQgb2YgZG9lcyB3aGF0IGl0IGhhcyB0
bw0Ka2VlcCB0aGluZ3MgcnVubmluZywgYW5kIGlzbid0IGV4cGVjdGVkIHRvIGVtdWxhdGUgZXZl
cnkgcG9zc2libGUNCmluc3RydWN0aW9uLiBXaXRoIENFVCB0aG91Z2gsIGl0IGlzIGNoYW5naW5n
IHRoZSBiZWhhdmlvciBvZiBleGlzdGluZw0Kc3VwcG9ydGVkIGluc3RydWN0aW9ucy4gSSBjb3Vs
ZCBpbWFnaW5lIGEgZ3Vlc3QgY291bGQgc2tpcCBvdmVyIENFVA0KZW5mb3JjZW1lbnQgYnkgY2F1
c2luZyBhbiBNTUlPIGV4aXQgYW5kIHJhY2luZyB0byBvdmVyd3JpdGUgdGhlIGV4aXQtDQpjYXVz
aW5nIGluc3RydWN0aW9uIGZyb20gYSBkaWZmZXJlbnQgdmNwdSB0byBiZSBhbiBpbmRpcmVjdCBD
QUxML1JFVCwNCmV0Yy4gV2l0aCByZWFzb25hYmxlIGFzc3VtcHRpb25zIGFyb3VuZCB0aGUgdGhy
ZWF0IG1vZGVsIGluIHVzZSBieSB0aGUNCmd1ZXN0IHRoaXMgaXMgcHJvYmFibHkgbm90IGEgaHVn
ZSBwcm9ibGVtLiBBbmQgSSBndWVzcyBhbHNvIHJlYXNvbmFibGUNCmFzc3VtcHRpb25zIGFib3V0
IGZ1bmN0aW9uYWwgZXhwZWN0YXRpb25zLCBhcyBhIG1pc3NoYW5kbGVkIENBTEwgb3IgUkVUDQpi
eSB0aGUgZW11bGF0b3Igd291bGQgY29ycnVwdCB0aGUgc2hhZG93IHN0YWNrLg0KDQpCdXQsIGFu
b3RoZXIgdGhpbmcgdG8gZG8gY291bGQgYmUgdG8ganVzdCByZXR1cm4gWDg2RU1VTF9VTkhBTkRM
RUFCTEUNCm9yIFg4NkVNVUxfUkVUUllfSU5TVFIgd2hlbiBDRVQgaXMgYWN0aXZlIGFuZCBSRVQg
b3IgQ0FMTCBhcmUgZW11bGF0ZWQuDQpBbmQgSSBndWVzcyBhbHNvIGZvciBhbGwgaW5zdHJ1Y3Rp
b25zIGlmIHRoZSBUUkFDS0VSIGJpdCBpcyBzZXQuIEl0DQptaWdodCB0aWUgdXAgdGhhdCBsb29z
ZSBlbmQgd2l0aG91dCB0b28gbXVjaCB0cm91YmxlLg0KDQpBbnl3YXksIHdhcyB0aGVyZSBhIGNv
bnNjaW91cyBkZWNpc2lvbiB0byBqdXN0IHB1bnQgb24gQ0VUIGVuZm9yY2VtZW50DQppbiB0aGUg
ZW11bGF0b3I/DQo=

