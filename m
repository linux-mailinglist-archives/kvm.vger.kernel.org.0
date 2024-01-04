Return-Path: <kvm+bounces-5694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44FE1824B2A
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 23:47:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50DA4B241A0
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 22:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9D32D03B;
	Thu,  4 Jan 2024 22:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bZdKb3o+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF072CCD6;
	Thu,  4 Jan 2024 22:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704408446; x=1735944446;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+8ukBBYLO/HfRJ3QWuxfBlybFXsloqXFIeGYYWOoHd0=;
  b=bZdKb3o+1EaiK8fYWVejuazP8ExYIKcnoolrLX6RAHTQ2Bhi+F2EfWXo
   2T03AD38ma+qeMz6bMgM8Xl39A+kAxfISndRY0WLM9GT/PBttzYI5d6rw
   8azLyEUCN0ivJ1URuvmLQRF8H4YQ25x4bybyxjvzDRPYwD37CaAIuDT36
   gtuWUohfBss9/dNv+BHzZk5cIIrlK8uUP9P7kezyaBT/ZsLeZh+my+K5i
   iVoG4NDWu3OIMyzTTdt0P654j7cRKOXKBsOej8bQ6kicWgLohYdC2B+ph
   NjIVxrknf06hNjzEklFqPYr3jB214Gk3xuaDM3xV9X9Glc/9bJsX8Ma9q
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="10892755"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="10892755"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 14:47:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="1111912334"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="1111912334"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jan 2024 14:47:24 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 14:47:24 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 4 Jan 2024 14:47:24 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 4 Jan 2024 14:47:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIltq3eHki0wSgzEx5/IcsbsTDfUj3bniZAb/SmXFHeKWWC4TbRXm7NH8a5auHiK3wrFAQnPUIVl6I7OcY3e5GvXPnrqddEVEFUXfV6x8doeS1o1DuNyU3YPUwoUBzMhJOMjtEVjvuLveUCmQjC7C2xmdlB/PclJTqE8OuXenIAEfSP7Hpg2kDOGEo3RQim4KImfxc1Ia5p8mO3qhp/sPTj5pAb1apM8VlVqj4RxNnVa0EriX0skFuOmXtafx0Fqy3IoBKanVz47aXHdX5Yy0sKOehI6sY9bOkiSa7gWlsRBWv9uMRbGtiPsdHuhTn4Aszypeq73wdf5RXeBw/ls9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8ukBBYLO/HfRJ3QWuxfBlybFXsloqXFIeGYYWOoHd0=;
 b=nXqOO9BVuHtjiJcwXjLqXDM69Szdi29AXBF7RXkhMvOzrM6crIMQUxQMMEmkZew83nju7sieFnZC9ebiKvjzYrv2SXU2NKsow+OaR4Kjy3EGsv7wRNvq3D2/mM8fcFCi4Z5aJF2Mv6v2UQEcX2rnL8UkSyjDsLKWU2yCE5m/KbfVz+KibaeqSzCNnQkr7IGMNIAEv4tVRpBb0Axkhr5CM91Mq/TZbjlelZlHgw8trhAfMqZQ5ArGXLRdk2k9Z+Vybj+9Au6QuLbEBIgR9570Ihe41euzjV5fQ0tnOMZTz3iZZXgEnbqdi2IDW6DShWaKWByHHM+D0qvLNAaXz7OPpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB6986.namprd11.prod.outlook.com (2603:10b6:930:56::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Thu, 4 Jan
 2024 22:47:16 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7135.028; Thu, 4 Jan 2024
 22:47:16 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v8 06/26] x86/fpu/xstate: Create guest fpstate with guest
 specific config
Thread-Topic: [PATCH v8 06/26] x86/fpu/xstate: Create guest fpstate with guest
 specific config
Thread-Index: AQHaM+ylBC/+E0ccDEaCk+hVFG6RhLDKWBQA
Date: Thu, 4 Jan 2024 22:47:16 +0000
Message-ID: <055eee55f2ed04a822d99e1824d08a70aed942f5.camel@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <20231221140239.4349-7-weijiang.yang@intel.com>
In-Reply-To: <20231221140239.4349-7-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB6986:EE_
x-ms-office365-filtering-correlation-id: fa3fdb75-67b1-4944-b7ae-08dc0d7719f2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ic3sa7r5fBIW9RGjS09Hzfqatdyu3/AN58XEBOzP1Jg4IVBMTSoBJf+qHjsEeY+ergOh+S9n+MLP6IaBkrxpE6SJn+Z9p5Tunk6hB2KdLACNZdj4FaAzl1+EQIpNP3TfGAFBueIo44+qRTFCPYIaPZbCkiVQi3s36SpJ+dD0+pzb/SLnGFNyX+dpp/UzQKwQoR6Qr8FQz3HDMfRmMP/B+7l0T5Ok9V6mg3rz0dW6lhoYbhgU4qz50Shi3cg9JrRNosOVMzua8PJ8tFJDiMqWsi9w7FCD4HDqfkTFACIYqZUK+MGhsoCpLN5PeA7NcKTVgE2+MTB4PRNQgQUYSbyE8PmF5uh7/LUWnT7/L3B/mP3voG1sKf9iiQ8f5sGpoNSkFzYTsVw2ct3LxZ1ykEoAsgOLzcHQIbEhGisMJIoHf8c8Ne1zLcC4IExolTttOsCr/bV2PNfYVCVt44X5NZJTxVDlmavxGdZQgcngVTs7zf3QlqaCH5uX/QwgQ2ZY7AHwdxLZcC61Rf3XAfgtj6TVaAlg2YdxfKSZe3FwHIm4Yg3VjT4fET35CahS9z7dhHQw0u0T7XKzPgWZ9+sHB17M0SwlT+UL5Rih5LYZ4jvvP9KRVqvQh2w95IItEWljo/JD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(346002)(39860400002)(136003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(91956017)(6486002)(66946007)(66556008)(66476007)(66446008)(76116006)(64756008)(2616005)(8936002)(316002)(8676002)(4326008)(26005)(54906003)(110136005)(6636002)(478600001)(71200400001)(41300700001)(4001150100001)(5660300002)(2906002)(6512007)(38070700009)(36756003)(38100700002)(122000001)(82960400001)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVQ0M0FQbFJ0OTkzMm9JNmJsU082bDRaM29ZZmlFa3cvUlMrNUd0Rm9uTWk0?=
 =?utf-8?B?d21MSXZ6RVNndnRwRm5wbUM1d2QvdWhqVGVZOFVhTmg1VmxueEJuQXpOdVpv?=
 =?utf-8?B?UjkxYUZZY1BMeXlqd2hkeFVDVlpFcEpZcFQvQllGeXB6eGtTUTJWSk1FalE2?=
 =?utf-8?B?djVuejVUalBaMFpWSkFFLzh3RUpQSHkrMHBoL1dGcHpRVEdlY2tON0VIK0U5?=
 =?utf-8?B?ZlFZaFhRZ1pJeHJtbmRDVGpobkc0cngzSUYvYkZGZ1JVU2s3RVZWRlpXMU5F?=
 =?utf-8?B?c0UzRGhscDduNGQrdEx1UzlHUm1ib3g2bXF3VWozK29xRU1xQi9KK2xjenZ2?=
 =?utf-8?B?bkMrYmxic1l1YTQxbU5HWGxGS3gwSWJXdTlaUXdHRVRzQVFpM3Y2QmV1N3RT?=
 =?utf-8?B?dmlSaUZOS3l4NlFFMExvdWZ2NmFUaVpNMVhMNjVJMk1TV1FtU2E0eFpmWUQ2?=
 =?utf-8?B?bXBMTnA2dVk4Z3hORnJXVW9ZejhxbkhReitWc2JmUUR3aXFnYVB2Ulh4bkRq?=
 =?utf-8?B?djJOZ1NtTDFTblYzajF2RXhCaUZUOWRyaXI3QlZCaGJkK1l6RjZnaGRrd3Z4?=
 =?utf-8?B?eTRHNy9BSjlEQWZtMVpBT0toa00wMDQ2K0NlWFlkZzFkTVN2dVV6ZkR4cloz?=
 =?utf-8?B?MWRGYmd1Y3YrVGk1Y1haVzZKRzlPdDc4QWhyb01mN2tMVWxvUCttK2NTZS9i?=
 =?utf-8?B?ZUZSZkNQcyttTUY1VU1BTXRVZWY1Ukt6aFJ6ZGVXeEgxWkhpOTVvdTFkSjNR?=
 =?utf-8?B?RTZhR0pEanlCV29wNTFDUVdMcnp4aFJWZnpPcDgyOUdEUFp3UDkySG9DMXYw?=
 =?utf-8?B?b25Yejc3eWxGUDZwcW9BdUZ6ZDJ0b3NtRzZvWmZLNERUU2lOL3V1WWVsMHhw?=
 =?utf-8?B?SForRGlIVFZjSWRobDRncWMybUJLcG5XOWd2cUk2eURxTEFLZlI1RTgwZVVJ?=
 =?utf-8?B?c2kxSlhmZzdjd3JmWlFFMW9LTU1oWWFIVFdjWngrOG1wQlNDZTBBWFA3WkxJ?=
 =?utf-8?B?UDlDVncvM1FlbU1xdkcyN245d1l1aDE4aUlzZk1DSndjZ1Jsa2ZtVXNtanoy?=
 =?utf-8?B?bzFuYzNVVEtsZmIyVUdhQldwZmdnSUFvN2J1anRQcDNDVWhXYmYvaTJHNmgr?=
 =?utf-8?B?OWFoeVJJYTNEYytRS0MvcWVxeDFkS0ZSQSsrMUNWaFJWNXBiYmFVc3ROelhW?=
 =?utf-8?B?V2k4VUVTQzRZRWFEZHVqVG5iRkhCVVdBMnE0cXBmc3dFcGF2SnhHampGL3VM?=
 =?utf-8?B?bkhvK2pvczE2OTFWU1NYOW9sZ2lMUjFzaml2TDhHYlczTzFENC9rK21lSUtu?=
 =?utf-8?B?NnI3Mmh1am9zd0NtTTd3U2ozcVJZdVp4WWNjVUZtNW9iUFFmaktkOERvbVA2?=
 =?utf-8?B?YStqQTFsbXVkTTgyeXVNdXNURnhlWUVmNjlWUjBlaUpPazRPVjFpOHBkNW9R?=
 =?utf-8?B?RU12aDRzWGphWnhzdTV0QTdxNkc5UXk3OXlIdFJ1UzlyR0VtMGMrajNFRHhw?=
 =?utf-8?B?Yk9aWm55c3dMVWJpNHRQUjRHWjdUMUcrUVVvZzJXUytXMGJEeUUyLzlpMDRp?=
 =?utf-8?B?UXd1ZE5RS3FqU2JTQkZMM2xKcnMyRDUxVWdDOGxJRHNOWGJRUlNpcWlLL01F?=
 =?utf-8?B?bHpHRmI1ZnUxdlEvcU1pOHA3L0VYUHpTWlFxK1ZyNWo1dmRzZSs4NFFabU5O?=
 =?utf-8?B?RG5hdjJ0V29mdlhmUWJ3MzBQSkU5c1J1Vy84KzhWUGRydWhqZjJFOHhLNTFL?=
 =?utf-8?B?WG8wUWw5ZFNsOVdTcmM3NWI2Y2pZbmM1dkJjamhOeXFZVmxjMWNsendwVyt4?=
 =?utf-8?B?ejEzVDRxRkh1YUZBaFJxaVFVd0ptdnFIQk80TlhmczlOK2E4M0lkOWlrMnRv?=
 =?utf-8?B?d2lYa08xOFpqNDM4Q2pLZGRQYjY3TWRXVU5WV2VXMS9vUkFkbzhxQTBkRjNS?=
 =?utf-8?B?d01nWlVFbUpYRHVLRUU0V2hCOUd1OUJwYy9OT1JmTUpNZ3FVOXRwN0JHaGcz?=
 =?utf-8?B?MW10dEpXVkN3ejMwQUNIR1ZtYWd2RUJpR0g2TXN6MHdPSmpkaUxONEdSdmQ5?=
 =?utf-8?B?WFpJdHhlN0NuYXMxQXFiV2p5cEpYZXlkRE9UUWc0QlovZVp0WWR1blFvdjVt?=
 =?utf-8?B?dHdvSW9BaVBQZS9leUpZbnJwQTNzbDdQaVR4c2hUL0dBd1BtaVM4WmVvUkZU?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DED5914A8C3D43418103EADF7F63E946@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa3fdb75-67b1-4944-b7ae-08dc0d7719f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2024 22:47:16.7127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tSaxxjN5Y7R8YEuWhUJWKZ90siaLyBiCOHy9KEquPndTqomW8+ludEZz4LUHWVrFBf7ge2hLRJHF1yWmR+FVnW1GkQhbiuWA9cEtg15QgP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6986
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIzLTEyLTIxIGF0IDA5OjAyIC0wNTAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOgo+
ICtzdGF0aWMgc3RydWN0IGZwc3RhdGUgKl9fZnB1X2FsbG9jX2luaXRfZ3Vlc3RfZnBzdGF0ZShz
dHJ1Y3QKPiBmcHVfZ3Vlc3QgKmdmcHUpCj4gwqB7Cj4gK8KgwqDCoMKgwqDCoMKgYm9vbCBjb21w
YWN0ZWQgPSBjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1hDT01QQUNURUQpOwo+ICvC
oMKgwqDCoMKgwqDCoHVuc2lnbmVkIGludCBnZnBzdGF0ZV9zaXplLCBzaXplOwo+IMKgwqDCoMKg
wqDCoMKgwqBzdHJ1Y3QgZnBzdGF0ZSAqZnBzdGF0ZTsKPiAtwqDCoMKgwqDCoMKgwqB1bnNpZ25l
ZCBpbnQgc2l6ZTsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoHNpemUgPSBmcHVfdXNlcl9jZmcuZGVm
YXVsdF9zaXplICsgQUxJR04ob2Zmc2V0b2Yoc3RydWN0Cj4gZnBzdGF0ZSwgcmVncyksIDY0KTsK
PiArwqDCoMKgwqDCoMKgwqAvKgo+ICvCoMKgwqDCoMKgwqDCoCAqIGZwdV9ndWVzdF9jZmcuZGVm
YXVsdF9zaXplIGlzIGluaXRpYWxpemVkIHRvIGhvbGQgYWxsCj4gZW5hYmxlZAo+ICvCoMKgwqDC
oMKgwqDCoCAqIHhmZWF0dXJlcyBleGNlcHQgdGhlIHVzZXIgZHluYW1pYyB4ZmVhdHVyZXMuIElm
IHRoZSB1c2VyCj4gZHluYW1pYwo+ICvCoMKgwqDCoMKgwqDCoCAqIHhmZWF0dXJlcyBhcmUgZW5h
YmxlZCwgdGhlIGd1ZXN0IGZwc3RhdGUgd2lsbCBiZSByZS0KPiBhbGxvY2F0ZWQgdG8KPiArwqDC
oMKgwqDCoMKgwqAgKiBob2xkIGFsbCBndWVzdCBlbmFibGVkIHhmZWF0dXJlcywgc28gb21pdCB1
c2VyIGR5bmFtaWMKPiB4ZmVhdHVyZXMKPiArwqDCoMKgwqDCoMKgwqAgKiBoZXJlLgo+ICvCoMKg
wqDCoMKgwqDCoCAqLwo+ICvCoMKgwqDCoMKgwqDCoHNpemUgPSBmcHVfZ3Vlc3RfY2ZnLmRlZmF1
bHRfc2l6ZSArCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEFMSUdOKG9mZnNldG9mKHN0
cnVjdCBmcHN0YXRlLCByZWdzKSwgNjQpOwo+ICsKPiDCoMKgwqDCoMKgwqDCoMKgZnBzdGF0ZSA9
IHZ6YWxsb2Moc2l6ZSk7Cj4gwqDCoMKgwqDCoMKgwqDCoGlmICghZnBzdGF0ZSkKPiAtwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGZhbHNlOwo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gTlVMTDsKPiArwqDCoMKgwqDCoMKgwqAvKgo+ICvCoMKgwqDC
oMKgwqDCoCAqIEluaXRpYWxpemUgc2l6ZXMgYW5kIGZlYXR1cmUgbWFza3MsIHVzZSBmcHVfdXNl
cl9jZmcuKgo+ICvCoMKgwqDCoMKgwqDCoCAqIGZvciB1c2VyXyogc2V0dGluZ3MgZm9yIGNvbXBh
dGliaWxpdHkgb2YgZXhpdGluZyB1QVBJcy4KPiArwqDCoMKgwqDCoMKgwqAgKi8KPiArwqDCoMKg
wqDCoMKgwqBmcHN0YXRlLT5zaXplwqDCoMKgwqDCoMKgwqDCoMKgwqDCoD0gZ2Zwc3RhdGVfc2l6
ZTsKCmdmcHN0YXRlX3NpemUgaXMgdXNlZCB1bmluaXRpYWxpemVkLgo=

