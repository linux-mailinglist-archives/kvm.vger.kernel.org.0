Return-Path: <kvm+bounces-2548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF197FAFBD
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 02:46:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B2E9B21171
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 01:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF164681;
	Tue, 28 Nov 2023 01:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T9fWCFvf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660DBE6;
	Mon, 27 Nov 2023 17:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701136007; x=1732672007;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DN1sDPJpi0daNEsnfehBLeNHApw4DKCZ+v66jJYhV3U=;
  b=T9fWCFvfWaIpk8UQaVNVXk2u/ohSFzO3uFWvG69Lq2db2d4+K5PoZGCu
   yDj/dDxgUKt4WBFjpyRUeJXbD48IXLmSygbDyW7geLUbwrloQugNYNCq1
   wFGxRqRuR5xc3ydXrzUjG2md5QBRAkvUwt0EYX5QZQZH1F4zMlkmOPp6O
   EoROW6Q7VNDkxmQBFTs1XSiEBC+GkfDM5EQ1x/Q9Md6YZHzcrJXsrlo/l
   keRIOYXOMFuMdCmocGw6X2GTwVSGiJ3SoyquRUf/ZeBjGcUfk0XUAN+Z+
   Nn9GSrB3+901WCkR7LLVQXg75hp6DTp3olVPGRNMVvcdwemJtpoEbzLJi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="392579977"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="392579977"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 17:46:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="1099937951"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="1099937951"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 17:46:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 17:46:44 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 17:46:44 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 17:46:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1HFmcz8GS1VGrMt/t4KZFT2vTPRBq2rzwLRhQRTqA8S+uvezKljZttbP7fNWVEDLsR55fyKi2eHtX6drKuYrFeBtmxHMOLdW5Ef4PnsgtrN4Mg538gx6OU/QnPwidAqm0NcAPmE7XLnnnNYyjQVXiPWv8yPuIKw9JrayiwkgwpErJFeFPLox2mkFb6wdzBU3JoLh+rYobM/W7OgfF/2GTL6NQwRvZDIQjwRtpVuseYYeRaM37ZPX7xosaNuLYb4Ni+FvJXeazqiGVnJQsvqooE8S4fZP42+Jfo5Ja8BsbUws2VJCMiFpBZoS2TW+uuchIe0H9kbCnQ0z8xmgun4Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DN1sDPJpi0daNEsnfehBLeNHApw4DKCZ+v66jJYhV3U=;
 b=UBoaAgZJuyMcj1cGC940XeoHlVgO1sWcv5Ac12PG+/L8DvhQ3csExbXMh26S3pMNdrOpWjLlazHo0V6aqrB0+Tm6JAVzydIL1RRy2qVP8jokAPUMXCuiLZWcynKO53rR7EOiKe+fR4Iyr8tkueqvfWap2DAkJ3tg9wi2CBaJpxKdXPn7u1KgtQ+mAy493A8PozX0yrls7O7fPoAdGbbaY5+pT0p5XDo8tmdgCa0FhUnZNhw/HYIg2HTbO4MWf5AXEVafMXCVhCzdMQr3nHVEm8Zsb3N2BBUhDpCFmCLfgXiApwg8crpezLqGXJUI2/WlLgt3tzfktNV2/OfO/6QE1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6883.namprd11.prod.outlook.com (2603:10b6:510:202::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 01:46:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9%6]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 01:46:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v7 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Thread-Topic: [PATCH v7 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Thread-Index: AQHaHqwJgZjdYYieAEWfcgnw7RStqbCO/B+A
Date: Tue, 28 Nov 2023 01:46:42 +0000
Message-ID: <bbcdb8c0729b6577684f89b180cae2f5ec422bdc.camel@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-5-weijiang.yang@intel.com>
In-Reply-To: <20231124055330.138870-5-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6883:EE_
x-ms-office365-filtering-correlation-id: a0005154-6d76-47ea-dc49-08dbefb3deed
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b6roJ8yZ8oO0r4XjawPaKkUbOJNqLMylRA/6YqU1JKWTwbmfSnQIPHnAKYicnvTXDyz41oWYXrvnAQPzrcpmHOZE7Qs5YfFko6K0E8gVBl+T7yx9Aoma1qrELfn4OLT/lDhy/BWSFngT78rEI9qhLnI9MD3tZW87dcrbcswAp3DiD/7rzWXHYTCDXdQhSObHMZWW+ENCeSidpPmXSrLvx8Ogjh3Qr+w8yozFlO/rnXY5dHIG9DS6uKv+VR3rAr5v9vI0gbUKAnHzZnFJ1NCuvVBuNzg1nHt1aa4Sdp0u3fxmRocGx9gQyGePFpAfcpKjds5G+OytZrtZStoOSKNgdTwkAqzrI4Dcbcfa+Wq77afiFnufGi9YJGRHjqSKxxJya1viNRSdUKxmbCFq/FJvLROhvlMMXJWITKon7HM4MU3A2gJH77eut+foDSnjhG8Gu3zHDkDHWXccZnZl7rd44pk2FtIR0u5MLlAYy6WWudwJUSwzxpx5nT6n54Sjct8WNDjzc+lP9svZ5aMY2kWdhKJK/AIgwjSiOVdFenWIwHccCwJkKwNocI2pzHYSzZ/4jz5OGTd5Ew7Gx0o85EZ/qcXd/URVjtpQnNDs05aUKMR7QiGQRIY8tb+hot5W+2r/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(396003)(39860400002)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(8676002)(41300700001)(4001150100001)(2906002)(71200400001)(38070700009)(86362001)(5660300002)(8936002)(4326008)(66446008)(66476007)(76116006)(36756003)(66946007)(66556008)(316002)(54906003)(64756008)(6636002)(6486002)(110136005)(91956017)(2616005)(6506007)(478600001)(26005)(6512007)(122000001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDlMaGswWG8ydTJJdHh5MHlPRjBVeWZDZVdXRFVWNitzRGJadUc2YjhWcDlB?=
 =?utf-8?B?YmxjWGZCczdDLzNQVTV2SUZIc0tvQWtMQ0Rla01SVUI5MEdJK1RDL21sQ3lH?=
 =?utf-8?B?dEx2YXVXL1ZMZi9tcVgyUGUzVG1pZ1JMYjl4bDJOVW15blIrb21YNmE5eWZO?=
 =?utf-8?B?N1hudlVSUUFKSENsTkR2U1dCY1JiQ0YvV0podnhQMy9Wa0F3S1BmU09yUCtO?=
 =?utf-8?B?VllTZml4b2d3b3pZVXdNcGh2SldaYVBkWXZBb1JQck1VemZvMXJGVlhNYXlk?=
 =?utf-8?B?U2c2Uk9NREdJSW9MenhFM1pMeXo3aEhwd1ZhbytxWUVVYlRpMEVMa1doSFRG?=
 =?utf-8?B?dVZxWlJHRjVoV2lERCtTNzYvUHZXVHlzWkpreWYwQzlSSHg2U2NaRkVFVHVr?=
 =?utf-8?B?WlBQd0ZhRHdTMi9GcWwycHZUZ1RJcXFZWUxTelgvR0NYQi9UQmxmTnR5VjBk?=
 =?utf-8?B?Zk0zeDQ3d28xcEZWaUM4VldnblRlZUF2TkFLTkIvZlFJUnBhWUw0OG0vNEZn?=
 =?utf-8?B?SkNxSndGV1ZwSTYycEpkc0htdVJEVkhjMEVIMXI0SWxBakExKytRQjJKUE1I?=
 =?utf-8?B?SExWQUZsK1pCaVdQYkk5SmpKWit6WCt2MERlTXVhY2l5ZmRFWkJVTXVsRkNl?=
 =?utf-8?B?blFOZ1g4ZkkxYXJMb3hlQU1xbWhFeTBxb1VpNis2bFUrTEgzdm9JVmRqbklT?=
 =?utf-8?B?V2hHcFJRMXE5ZVNkdERKdWV4a2s4OEpCM1ZveHdXMGFaTmJZbmxnSnF1M3BC?=
 =?utf-8?B?OW9nRGNRUjFKaitYUlBqSlp1UE1NQWx0cDgxTC9oMXRpWHlOM1B1RWVTOTZJ?=
 =?utf-8?B?bkZsZVR2Z2dxN09ka0k2blVxK3NkTitVT0U2YVhhcnNJUUJzelNzTkJGSnND?=
 =?utf-8?B?SVJCL0ZXTmNRcGd6dW9BazhWcmEyN0UyZlIrLy9XTXJpd3Vtam9MUUpjV0Jq?=
 =?utf-8?B?eGhqTkJqYTlwSldDZzlEV3VNRUtpTkRlWmVrZWlhblAzV0NPd2R0Z0d1dVJF?=
 =?utf-8?B?U2Z1S2dEOE9ObkZFV0tyM013d1plWi91RnBtMHpNY1ZmT1l5bDU5Z3J3RWdH?=
 =?utf-8?B?ZUVkM1pQcy9GV1lUZFA3TDZxUHB6RGdtZkhZOWRsbUVOUFNRK3ZpRnRBdDdU?=
 =?utf-8?B?ck1OZEZoemloQzdXVVNiZGcxZGhDeEtEam5GaVFaZjEwZVE2RjhKS3BLWWpx?=
 =?utf-8?B?QWxKV2x4cU9xN2FFaXI4WmljQ1VFaGlLV0VabWJjd1kraWpheDFKc0FjeXZL?=
 =?utf-8?B?ejFiVzgxY2hOeFhMRHR6L1d4N3RoMHQ1LzQ2eG81U1l3ckcwUlltaloxRVJ1?=
 =?utf-8?B?NWloSy91RFhIaTZmeld0S0JBTVBzcDI0eVhKSnJ3UEt2ME5abEl5c0VRTTBi?=
 =?utf-8?B?VlJZY1d1dGZjZ3hES2tERXJ3ajlRTWFVQ2RXUWY0K1UrTFFmcnQ4WFAzUFFC?=
 =?utf-8?B?ZkhMZE9aVzVqRWVLRG9LSmlKUjk5QWNpblpOY09SUFJ0NThkNHMvSzh0NEJs?=
 =?utf-8?B?bjZ0bjIxRGNYdmJxVUE3U3VsWHE4L2ZlTHJoa2JCRkFNazY0Z09IZTNLemtO?=
 =?utf-8?B?MTFnOWZLdWdkaUdjc1VaRWo1R0tUL0JXdDlKbWk3dlgzbXpCTTVlTnFKOGRm?=
 =?utf-8?B?cmppd2xLTU1zUmdoWGlEYnFzNEUrOTZjNTRicitYd1dUK1VkNUZEeHVSWlQ4?=
 =?utf-8?B?bUF0VnRSL2RVZUNFdVlPaERYS1BleTlrbkVhODVpQ1AzZ2xKWEdhbFlxMkww?=
 =?utf-8?B?b1p0eGxHSWxKaHExNjNPeHlFZzZsd1dGQWQ4bG90ZnZvdkZBTlFzTDlqZHFY?=
 =?utf-8?B?L1plYmUzSzl0eWlScElpLzh6ZVFlaHRwWTZqcnFNazM2ZFVTZmtwUlYyUHpk?=
 =?utf-8?B?ODhtTVBhb3VNSTRZSjZJNC9FS21CT2tHQWt5cm9ybi9RUHpiZHZWdnFKaFdV?=
 =?utf-8?B?N25JR1RSQzBoWW9wRDFNLytTUkZENTVjNi81TXhWRWhuZE5oWkZSMUJsaFVK?=
 =?utf-8?B?RkJBR3czeFNtK0I5MjFncXRHY0ZIUE1jd2VsUklXVzFDVzJBRjc2R0d5dnQ1?=
 =?utf-8?B?UGdPeUVWQXk3L0hJMGUzV25ZNm54UWR3azlYdldLU202RVBNM2VHZWYvL2gy?=
 =?utf-8?B?NUh3bmExVDZTdVM0enZHUVh4aEE2M0VTQUFPdlhEcG14cGNobzVkUVVYZmlq?=
 =?utf-8?Q?xM5e1xuj/KZ9RraI03rkq1I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1B1CEB9249B2D4595E1C2DDD079263C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0005154-6d76-47ea-dc49-08dbefb3deed
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 01:46:42.0832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y8mIklbR2aHuo9isenbbz2PzaG/SQTCZeYLw20524EgKHqSVhox833KEcJHTudiKyeeXXtHfIaRxXt9VHmYyo996o0tEOJ6DS7SV33TCCo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6883
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTExLTI0IGF0IDAwOjUzIC0wNTAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiBEZWZpbmUgbmV3IFhGRUFUVVJFX01BU0tfS0VSTkVMX0RZTkFNSUMgc2V0IGluY2x1ZGluZyB0
aGUgZmVhdHVyZXMNCj4gY2FuIGJlDQo+IG9wdGlvbmFsbHkgZW5hYmxlZCBieSBrZXJuZWwgY29t
cG9uZW50cywgaS5lLiwgdGhlIGZlYXR1cmVzIGFyZQ0KPiByZXF1aXJlZCBieQ0KPiBzcGVjaWZp
YyBrZXJuZWwgY29tcG9uZW50cy4NCg0KVGhlIGFib3ZlIGlzIGEgYml0IHRvdWdoIHRvIHBhcnNl
LiBEb2VzIGFueSBvZiB0aGlzIHNlZW0gY2xlYXJlcj8NCg0KRGVmaW5lIGEgbmV3IFhGRUFUVVJF
X01BU0tfS0VSTkVMX0RZTkFNSUMgbWFzayB0byBzcGVjaWZ5IHRoZSBmZWF0dXJlcw0KdGhhdCBj
YW4gYmUgb3B0aW9uYWxseSBlbmFibGVkIGJ5IGtlcm5lbCBjb21wb25lbnRzLsKgVGhpcyBpcyBz
aW1pbGFyIHRvDQpYRkVBVFVSRV9NQVNLX0tFUk5FTF9EWU5BTUlDIGluIHRoYXQgaXQgY29udGFp
bnMgb3B0aW9uYWwgeGZlYXR1cmVzDQp0aGF0IGNhbiBhbGxvd3MgdGhlIEZQVSBidWZmZXIgdG8g
YmUgZHluYW1pY2FsbHkgc2l6ZWQuIFRoZSBkaWZmZXJlbmNlDQppcyB0aGF0IHRoZSBLRVJORUwg
dmFyaWFudCBjb250YWlucyBzdXBlcnZpc29yIGZlYXR1cmVzIGFuZCB3aWxsIGJlDQplbmFibGVk
IGJ5IGtlcm5lbCBjb21wb25lbnRzIHRoYXQgbmVlZCB0aGVtLCBhbmQgbm90IGRpcmVjdGx5IGJ5
IHRoZQ0KdXNlci4NCg0KPiAgQ3VycmVudGx5IGl0J3MgdXNlZCBieSBLVk0gdG8gY29uZmlndXJl
IGd1ZXN0DQo+IGRlZGljYXRlZCBmcHN0YXRlIGZvciBjYWxjdWxhdGluZyB0aGUgeGZlYXR1cmUg
YW5kIGZwc3RhdGUgc3RvcmFnZQ0KPiBzaXplIGV0Yy4NCj4gDQo+IFRoZSBrZXJuZWwgZHluYW1p
YyB4ZmVhdHVyZXMgbm93IG9ubHkgY29udGFpbiBYRkVBVFVSRV9DRVRfS0VSTkVMLA0KPiB3aGlj
aCBpcw0KPiBzdXBwb3J0ZWQgYnkgaG9zdCBhcyB0aGV5J3JlIGVuYWJsZWQgaW4geHNhdmVzL3hy
c3RvcnMgb3BlcmF0aW5nDQo+IHhmZWF0dXJlIHNldA0KPiAoWENSMCB8IFhTUyksIGJ1dCB0aGUg
cmVsZXZhbnQgQ1BVIGZlYXR1cmUsIGkuZS4sIHN1cGVydmlzb3Igc2hhZG93DQo+IHN0YWNrLCBp
cw0KPiBub3QgZW5hYmxlZCBpbiBob3N0IGtlcm5lbCBzbyBpdCBjYW4gYmUgb21pdHRlZCBmb3Ig
bm9ybWFsIGZwc3RhdGUgYnkNCj4gZGVmYXVsdC4NCj4gDQo+IFJlbW92ZSB0aGUga2VybmVsIGR5
bmFtaWMgZmVhdHVyZSBmcm9tDQo+IGZwdV9rZXJuZWxfY2ZnLmRlZmF1bHRfZmVhdHVyZXMgc28g
dGhhdA0KPiB0aGUgYml0cyBpbiB4c3RhdGVfYnYgYW5kIHhjb21wX2J2IGFyZSBjbGVhcmVkIGFu
ZCB4c2F2ZXMveHJzdG9ycyBjYW4NCj4gYmUNCj4gb3B0aW1pemVkIGJ5IEhXIGZvciBub3JtYWwg
ZnBzdGF0ZS4NCg0KVGhhbmtzIGZvciBicmVha2luZyB0aGVzZSBpbnRvIHNtYWxsIHBhdGNoZXMu
DQo=

