Return-Path: <kvm+bounces-1587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D037E9896
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 10:11:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A050B20A4C
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D9A1865D;
	Mon, 13 Nov 2023 09:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QPpBeNab"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6544218624
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 09:11:11 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48ED810D0;
	Mon, 13 Nov 2023 01:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699866670; x=1731402670;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jYdnl6N1TINeYqFD8uaAprDn72VxvNTyURDHFTgGu8I=;
  b=QPpBeNabR+gNh5WkPcIJTgFtC3LF1RS0lX5Ji4VgMHxrdInZwlFWusQ8
   mkR+07uRG2gBBOTJ1Qb9mSegs9yZWJ5VN3qdGYTPA3t+18uJw7Wg7T0EM
   tlK8P+RJt2dG2GI7KXlaZJ9E2yYZpMl8LKv80zDONl3B0niN2hpGKBSaL
   8o+VsqhAyS8ei9nmd1O2zheIlU0BFp1rQW9+0IAeFeA9VASmhC/nfga8K
   wFcTMVom34rxMdibAUZjpuukKE9EjsGSn+08uxVL5x7TMEpNBXXeMBz18
   L6hi8eP1TMlKA5Yatpo/YBXWQ1NQxUbo5hbYJeFwTZuOBDOpLwA+jbI/l
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10892"; a="456893748"
X-IronPort-AV: E=Sophos;i="6.03,299,1694761200"; 
   d="scan'208";a="456893748"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2023 01:11:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10892"; a="907990351"
X-IronPort-AV: E=Sophos;i="6.03,299,1694761200"; 
   d="scan'208";a="907990351"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2023 01:11:08 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 13 Nov 2023 01:11:08 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 13 Nov 2023 01:11:08 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 13 Nov 2023 01:11:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNfIFKYXsI8gODLWNYMTj49hSCLMGqu/X2h6+bRkR5I6s+Z6dkNknULXivg5ME7Ck1hEhL3OuG5P4Yt71WhiQLQMOutIegaa/uWw2EbhlEyzLm6moqK3AajphwtTx6NIu7dnCsfbxGSmcPnpsxhHN78WTuaF9RN62+KlXM/2hrIcbjr+hd6Q5eJkk919PS6ohFhFL2QYcL5Pwq7Lt7lrNsTtumEhgHaIfr82EZzFeQg80BF+RcrqVskLXaAmvdyEJe95PX8HwcCyNZS2wu1/4oPyoLbqFWUz7KW8uXnQ/FeorGWSeDw741JDIYw7icRag8pUXn75GkB+ymcYBOOB2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jYdnl6N1TINeYqFD8uaAprDn72VxvNTyURDHFTgGu8I=;
 b=A1dhCCKzegaT1ALBGYeNCZ+J4XCjY3kXjDUMZLlcWAmmFZ+hcts2DzVgZar/bnq2hbQE0a1HPjUln6plYPJYhlVlt79Kw6ziLnVvrlEuTQ4Lwb8PKIUrCSCVwLVuH9Va2ddhkdWRR+K/k9iYec0TBMPrx6sorHYKBzykleFfV/UaCqihhg5r73Yu0TZ3GV9xT8ESlbIWEt8GCTUEP8WfkR599W+WVNznfF0znHYEyAr1PEqJcAVml25PzrAOms1eJGuvn4mJOf//7cPFq2zr+vKrM7zAz7N2FRiAeMqeFuRaKWP3FWj+kTqFYSHpJTnLP2N8ISaQKVrVLDGS7y4Wmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Mon, 13 Nov
 2023 09:11:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.6977.029; Mon, 13 Nov 2023
 09:11:03 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "ak@linux.intel.com"
	<ak@linux.intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Shahar, Sagi" <sagis@google.com>,
	"imammedo@redhat.com" <imammedo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"Gao, Chao" <chao.gao@intel.com>, "rafael@kernel.org" <rafael@kernel.org>,
	"Brown, Len" <len.brown@intel.com>, "Huang, Ying" <ying.huang@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v15 00/23] TDX host kernel support
Thread-Topic: [PATCH v15 00/23] TDX host kernel support
Thread-Index: AQHaEwHiMdXLHOpvlkWolk2EpfoOn7B39B+AgAAIgAA=
Date: Mon, 13 Nov 2023 09:11:03 +0000
Message-ID: <b3c47404dd8d13decb7f809a1aff7b6575146e7e.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <b3f02f00-3422-4c4b-b142-2981441bed96@suse.com>
In-Reply-To: <b3f02f00-3422-4c4b-b142-2981441bed96@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_
x-ms-office365-filtering-correlation-id: 19823777-43c0-47ff-c787-08dbe42875eb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tmI5HenZxoKobjlBOw68yYGKfWBYRHhEuBVD41QZpolQG/NGHpajl3NV0bxndHLNGgGYTN8/Fm4u5RcLLStFQJXBYycwr82XPMNuFxfiVgfSv4BIl5zoHwIILJtv36KrAQZVwhe/9UDXX/mQs8m65TQsCOsDga+dixSTrArntbTSOzSSnVixM0yCT8diQO23Y8joBorfM+hZTFCzrfOT6TVR1J5keY1tFfwXevREqroPwn1qjk73myJCbvKgc2Rg+UUU7Khx/MWZKXdmVre8XvTz8iF1eXWohXklXPaRQUCieGTFfAphvY1wRIfqcsGmvK33VI8tF0uZ9/zQzo3IehzY5Nkvrj2bQuc5mZj4bYyvRWFKLP/97vyBn0iFjOdSWsmIaKJZww1KcqZ2oVcBhTxI8bh+Cj+RoaHXi3kIeEiC4y+fl+7TmcC59H+xdhJT3tAdz67nlmi+uqgJXw2e96qo0JnHecxBWfBQRjN7V14cqDqL5HcsTHFmNitY5lAXKP5mXg/ERn2OvFEGuNT0n4QJiRvphK8E6HBiDnFWhdIusA5RX0kJ3JyRtPq5P/dKGPQAkg3XFxc5L0zLvkaWcjLkqlB3acXwL2Bsju7KgcsHJ0vhWvVPPT0wfxqgTuB3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(39860400002)(396003)(346002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(2906002)(4001150100001)(7416002)(122000001)(4326008)(8676002)(8936002)(5660300002)(82960400001)(41300700001)(86362001)(6486002)(478600001)(6506007)(71200400001)(36756003)(26005)(38070700009)(6512007)(2616005)(316002)(91956017)(110136005)(38100700002)(66946007)(66556008)(54906003)(66446008)(66476007)(64756008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVNaWFo3blVoVERUZFZtYklYMUNReVZEdEI4aVNCcG5lb3ZMaTFjMzF6VlhB?=
 =?utf-8?B?OVM1dHE3QXZoc29YSHQyYXlldmkrd2hBVUJyZ1pYUGxPU3lsd1VXMzByVzdw?=
 =?utf-8?B?UTVMN3piWTNkRW16YVU1OVJRZVYrZU4vM05NMDZ0OUhueVRlTGFIbHpoVGhC?=
 =?utf-8?B?bC9lU3E2Q2x2cjEvS2F4K3EwNFJxZVgzeEhQMVlWRjI3WEJRdUJCYVpRS1F4?=
 =?utf-8?B?RTRZcWwxUUd6Q0paYzBHMmZpU0NidDBzQVY5eGpVWGVHcHhxRHJyMDNNcVhh?=
 =?utf-8?B?N0FKS3RMZ3J5Mk9pM0JKWlpVWEJMbzExc3dSMnNlV3JPTHQvK24xbTdydVVw?=
 =?utf-8?B?WUE1Qm82bXN4SXdkcjZIa01KWjZVTVEwRDJ4M3ZPQUhxRHNRUExrQjVSOEtw?=
 =?utf-8?B?ZnF5UERWNEdaM2Vpd20rdVEvaXlYakxYOXljLzRxQWt1WWNXbVI4TzhFbkdX?=
 =?utf-8?B?Q3o4VWdWNWpTeUdSKy9mZFgxUGZHRHpUa3cwd3lHSnRWZHQvbklCRkRpb2dW?=
 =?utf-8?B?eDV0WXhkY0tWbGZEOXZHcStsd0tOMHVJTEhzUko3dFlwMFVQdDFWQkdxWDJy?=
 =?utf-8?B?UWM1d3AwN0JEMnV6YTNySjFsTGhJM2dwa1Qya1d0Nlo3SllRQlhua0V2LzJB?=
 =?utf-8?B?TVpTekxtY0F2N2c4eGkwQXN3UURpQmpGRjhvSTBGRHgycUFvK0kwRUVGaUZ3?=
 =?utf-8?B?THJQaDUrYU5BcEFSSjNld1JYellUWE5FUEJva2hPRVZoUUhudFBoM3B1N0lq?=
 =?utf-8?B?ZUxZOEdPYzBKZmZzV0JKMGV6TjZGQTV2WHVDNCtoOG5BYmNsZnhJZ3RoYi9J?=
 =?utf-8?B?ZnNiNnVJZmRheVpQNUJFTGUrWmZjZktYRE9LUGRhejRhOUxWS0hiMmI2Y1Rj?=
 =?utf-8?B?d2RyM0ZYSE1HWVd6KzF2T1RDaVlITnBzVDh6SVlSTXdVN3ZNZ1gwYzZlQWUz?=
 =?utf-8?B?TlRRUy9neGdxVEx1R1JhYkovMmNDNG04aC9XZzMvTUgveGs3ZEZtaXN4bHZH?=
 =?utf-8?B?dHJFMk4yMUdXaW13M3RiZm5WMUNDaVVuZ2ZEWk1lWXUvY2k3ZGxmejIzdVp1?=
 =?utf-8?B?TjdBZFlzZE9lN1l0TTF3ajZLeUM5RVVuZFBjbVUyWFJoRDhlMXZTUkloZXRj?=
 =?utf-8?B?YmdLQkFmbU1FTk5lNTltMFNXVHlSWUpFMDRMYmZFTUtnN0YxZElxV3VEb1FR?=
 =?utf-8?B?bDQvTzViM3JXYWdYWEszN05yUXBMK0gvc1hIa2w3SDBzM0pTTEZjc2RxTjd5?=
 =?utf-8?B?NDVDRlFUVGNpQU4wRmVlMmQ3aW1JVG5US0dJTEh6S05uK3FGazVhQXh3ZExC?=
 =?utf-8?B?OXFjYU52SmlELzU3V3ZOeU80dzIyUlNUZnhUN2VYUkJQOHpqN3JKSGJrODU0?=
 =?utf-8?B?TGdlN3FUdkdhSW9rUnFlMk4rYlJCb0VCUWlKdjRrZEFZWGJ0dVV2eUxLdnFk?=
 =?utf-8?B?WCt4K28ySXU2VzN2am0zRHRaN3ROczgyeTBKS0ovaGRRTXdGNm9ZL1BROUhS?=
 =?utf-8?B?bzBCQWxLUkIzSmtMZnl6TTNkaGNtU05ZN0w3QVQ5NmpWN0tFdDdNM1pZVkov?=
 =?utf-8?B?cGpNVTlyM2xmMEduWGpyeFlVa09IbEI2dkN4eDMreDk0Z3J4cUo1NTJKWU5s?=
 =?utf-8?B?bnFzSk02ZFNJVW14cno5V29sV0pyaFpNK01kNE1XYlVpNFpzaVJRUlczTmFs?=
 =?utf-8?B?aXFBNmw3UzRxZHkyWWJXS2ZjTytXN1AzUU9xUENXaGtrbE9SWU0rc3Zhckkx?=
 =?utf-8?B?L3Y1eFZBYTRDdFN0QkVoUUUvbTRZU3ZieUQrVS84ZCtjdWNtRGNVUG9pZzZw?=
 =?utf-8?B?ZWVkRHk5Vmg2WkhNUklBM0l6M2E2ZndSOThCekVSV3BkbVJKR0Q0VktvRWFK?=
 =?utf-8?B?eno4QVM3TzBDTjVDUUx1Mk54MTNRSFpscTZWZk9kN1hkV21UbUtkN1E1clFr?=
 =?utf-8?B?TUdHWUJkL3NHVnprSmhsWXE0N1lRUlpxUi9HWTJHMjV3R2MzeFVFcS9YSytN?=
 =?utf-8?B?b0RJUXlQSWswbEppSlEvdGlJTUU1UjZRWEdJejhpc2I4Y09KUS91akxlNi90?=
 =?utf-8?B?MGpOZk90anRQMVd4eTBSVmFxVlhTaURMVEZvUzFLcndpUTU3VVdRRHR2RytJ?=
 =?utf-8?B?WDVwYVFVUU1nd3gxRFFHYVdrdUpGdmcxbE5TT0M1c2RYSFMwb0ppWUk0Y3Jh?=
 =?utf-8?B?VGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <43BB75469F0A7749B58CFAA71A099BA1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19823777-43c0-47ff-c787-08dbe42875eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2023 09:11:03.0844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K5roKDx/E6I8QHANSexQFIpJYXwSZK+CGv4XtlcAJxqVeR9rv3w0Y6IA3MxvNIv82HN0MnmZ+80B3XWiu9uAcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5978
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTExLTEzIGF0IDEwOjQwICswMjAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiA5LjExLjIzINCzLiAxMzo1NSDRhy4sIEthaSBIdWFuZyB3cm90ZToNCj4gPiBI
aSBhbGwsDQo+ID4gDQo+ID4gKEFnYWluIEkgZGlkbid0IGluY2x1ZGUgdGhlIGZ1bGwgY292ZXIg
bGV0dGVyIGhlcmUgdG8gc2F2ZSBwZW9wbGUncyB0aW1lLg0KPiA+ICAgVGhlIGZ1bGwgY292ZXJs
ZXR0ZXIgY2FuIGJlIGZvdW5kIGluIHRoZSB2MTMgWzFdKS4NCj4gPiANCj4gPiBUaGlzIHZlcnNp
b24gbWFpbmx5IGFkZHJlc3NlZCBvbmUgaXNzdWUgdGhhdCB3ZSAoSW50ZWwgcGVvcGxlKSBkaXNj
dXNzZWQNCj4gPiBpbnRlcm5hbGx5OiB0byBvbmx5IGluaXRpYWxpemUgVERYIG1vZHVsZSAxLjUg
YW5kIGxhdGVyIHZlcnNpb25zLiAgVGhlDQo+ID4gcmVhc29uIGlzIFREWCAxLjAgaGFzIHNvbWUg
aW5jb21wYXRpYmlsaXR5IGlzc3VlcyB0byB0aGUgVERYIDEuNSBhbmQNCj4gPiBsYXRlciB2ZXJz
aW9uIChmb3IgZGV0YWlsZWQgaW5mb3JtYXRpb24gcGxlYXNlIHNlZSBbMl0pLiAgVGhlcmUncyBu
bw0KPiA+IHZhbHVlIHRvIHN1cHBvcnQgVERYIDEuMCB3aGVuIHRoZSBURFggMS41IGFyZSBhbHJl
YWR5IG91dC4NCj4gPiANCj4gPiBIaSBLaXJpbGwsIERhdmUgKGFuZCBhbGwpLA0KPiA+IA0KPiA+
IENvdWxkIHlvdSBoZWxwIHRvIHJldmlldyB0aGUgbmV3IHBhdGNoIG1lbnRpb25lZCBpbiB0aGUg
ZGV0YWlsZWQNCj4gPiBjaGFuZ2VzIGJlbG93IChhbmQgb3RoZXIgbWlub3IgY2hhbmdlcyBkdWUg
dG8gcmViYXNlIHRvIGl0KT8NCj4gPiANCj4gPiBBcHByZWNpYXRlIGEgbG90IQ0KPiA+IA0KPiAN
Cj4gSXQgbG9va3MgZ29vZCBhcyBhIGZvdW5kYXRpb24gdG8gYnVpbGQgb24gYXBhcnQgZnJvbSBE
YXZlJ3MgY29tbWVudCANCj4gYWJvdXQgdGhlIHJlYWQgb3V0IG9mIG1ldGFkYXRhIGZpZWxkcyBh
cmUgdGhlcmUgYW55IG91dHN0YW5kaW5nIGlzc3VlcyANCj4gaW1wZW5kaW5nIHRoZSBtZXJnZSBv
ZiB0aGlzIHNlcmllcyAtIERhdmU/DQoNCkkgYmVsaWV2ZSBtYW55IHBlb3BsZSBhcmUgYXR0ZW5k
aW5nIExpbnV4IHBsdW1iZXIgdGhpcyB3ZWVrLsKgOi0pDQoNCj4gDQo+IA0KPiBGV0lXOg0KPiAN
Cj4gUmV2aWV3ZWQtYnk6IE5pa29sYXkgQm9yaXNvdiA8bmJvcmlzb3ZAc3VzZS5jb20+DQoNClRo
YW5rcyENCg0K

