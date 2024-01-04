Return-Path: <kvm+bounces-5690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF5D9824ADD
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 23:27:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32D611F22F43
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 22:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0672D04D;
	Thu,  4 Jan 2024 22:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IVBJ/mqA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992772D035;
	Thu,  4 Jan 2024 22:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704407199; x=1735943199;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sZMMdJx3HWsrj4uQCNMH/mV/KaSfmxZFjz4AXsOxcdU=;
  b=IVBJ/mqAzA9UZyJrC/VrbuH5PcRat1XiTOSxV+dqOM4BSVIiD5hVSY0t
   fDNyPQCeMkD+jGjlanmdJsHRxiTnPfP9DlVumJ+hNSeL5xJT/W7MUWaR1
   BB041MSTjyLvg3sDZTC1WVbGBinhEGIfPVUjHYbP/bxoqdxjX3p+Wil39
   9k9l9dwIFG/S+ZIZwdnjHKl5PswFFU0LdI+1qtrK11z743leljPBbjMnj
   2P58yJETOvr6kfqW5ekCKR5xX17LQ1u8RXAHTsjXzX7TRaAOUhtFcghxA
   wo8jKbZsPOtyyuptaHyd/X4JUVjyXgb1XIIdpKek+p/zhuSETw8gL/hhV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="15999303"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="15999303"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 14:26:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="756763173"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="756763173"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jan 2024 14:26:38 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 14:26:38 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 14:26:38 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 4 Jan 2024 14:26:38 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 4 Jan 2024 14:26:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsdqKLV8szwpTixr9xuq4rnhr3LJq43padGge2zeitUGOB3a93fMMzRr/s3TyKDUhkMFyd/uVUxht1ShY/E8bOAdMGaFMJTnGfUddjzRRCA2j+JwfKeK9BeL34TeOoZ2GejmXD95hfrupdi1ycbK5ze5isXrS2+umDTetPsg7RFdRB6MfK3W6xB68wbpvEFXyf3VqLDkKYFJyhKSTQeCSpMzGWuUatP/x9MVGqFIOcRL8OEvtTyIgAtAcID2KyQuqDWB0QjI2hF6s8jzhtuPRJG60QKvTTZY0zT0ew0RrsGcHmpP3m1kgHQ6tASvSS3RdeOaJyG7uc7qInINH52+1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZMMdJx3HWsrj4uQCNMH/mV/KaSfmxZFjz4AXsOxcdU=;
 b=APKkAzV7Gv2N5hVaXu3oyGYgdSRIYaWVjWU60OnNVdivBNmOoyi1UN8GVJe7Bkn2fIKO/zcf+ktc0Lx90WF97D3BFo/xMZhhCuH94RWjZsFrWrgz6NISksZVxx6Ba37KCqC2e4Dhivpt5ZzV1YRRIAs9eSuDsPRKNNTlZ12K+KqjXfSaa2uV7QpDwe6tprQUG1DJCIYBtNQRYeWyE/tMTx11rjNbUAHPiRDa6GYrNpSq2PuScSFeDNOvPY2nmOInihZpFXILK6m2/9TcsAXukq9+3nwsMMRPTov4542kKhRaZvZxDDdqTkbedrRfmQjw34aBYXC8a+6o0bKt7dV/LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV2PR11MB6000.namprd11.prod.outlook.com (2603:10b6:408:17c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.16; Thu, 4 Jan
 2024 22:26:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7135.028; Thu, 4 Jan 2024
 22:26:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v8 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Thread-Topic: [PATCH v8 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Thread-Index: AQHaM+ybdHxGU7FdA0WJCW/8YQZk7bDKUk2A
Date: Thu, 4 Jan 2024 22:26:35 +0000
Message-ID: <20dc456a8b38d5cb9af3bbc8d2ebba869a2d7a44.camel@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <20231221140239.4349-5-weijiang.yang@intel.com>
In-Reply-To: <20231221140239.4349-5-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV2PR11MB6000:EE_
x-ms-office365-filtering-correlation-id: 81809c0f-3178-4ffe-9dbc-08dc0d743658
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bcJ62y0z13wy1NjTCVDf0A5GWQ6P4T0v/Gmd/Ljn5/TWDa0Dstvh2SmA6Hg5ICImOyDBQ133tIv1wEPKSnud2ESLpJ7KYkoAsYZiDsPgz5lCgneQ5IzwEiKNMCcHq2cEuS8W55mK8pB9lNilglpgIILHkf5J6NhyM+xq15wQPwi/7rfVuOK0IvyW2Pstc0dZLwcGn9UNoLzpkJhTLL01Pbr//Wxaf6u2FO9xgJLP0n3MBeLIA9sr9wFdUkvsH4uRW0Q3v2AZyFwhuhXoFIlNmzjmNDPWL+fB/3wGqHx0ZZ7vZH8pcHOMW53z+w2uFfva7wCkScz5fKufSQ0gEbdHhFHYfdsCAQpQD5e6atgstennhFmJBtwhUAFRLV9zUtKEAoFQNjCBTT40RtLKovOJqieXvzvh903aka2EgMkhz83JWWrvizTurWjGxQ8uytj5skMfMr1E5Kg40ZHGMd4emgrnOJgbLHkwUn4pnUIsY4Qp1+yEIrzn2Hy7imCntpq1OYMOsx5fHCUUNIiCF3GgAptkAZ3uD1XGEE4k5he7RxtA91wMKxjznwfSi56LH6Gt7WSsH8X32KGKiMPYRE4ANJSV5Iek97MLjTwNSbSeZn93/7uJ4VObmfuDIaK7Qxdx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(366004)(136003)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(6512007)(2616005)(26005)(71200400001)(6506007)(478600001)(2906002)(5660300002)(6486002)(4001150100001)(41300700001)(66946007)(76116006)(91956017)(54906003)(66446008)(6636002)(66556008)(4326008)(8676002)(110136005)(8936002)(64756008)(316002)(66476007)(82960400001)(86362001)(122000001)(38100700002)(36756003)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dC92Q0lwMDdlK1pianVRa3VUS0wzcEpmR3FvWGY5VkVreVRsQnFLR0h3dWEv?=
 =?utf-8?B?d1cvWUlFbG1hVlZldkdUZ0gySFR2U1pSK0FqYXM1dFJRN1RwSGxUSXUrd1BT?=
 =?utf-8?B?aFcxNldLUSs5dE02OW44d2YyNEF1WnIvV0l2dksvanBsL1RycWk5OXR6V3lh?=
 =?utf-8?B?ZmNoNnhROTBtWGJCWjcwY2h4MEFoUzdJbjVkb0F0c1FMN3gzWHNZdFJHWmxR?=
 =?utf-8?B?cUpDUE1US0RVN2JHb3IyRDVtUDJMK1NjSGY1Sk84cStqYkhSYkticVE2dUg0?=
 =?utf-8?B?bE1KZnRsQTQ5blRIVk42akgwOEs4d0RSNy9Qb2FrNHArbDNaT01obTcraVdr?=
 =?utf-8?B?UkY4bm9TNmc3bW1yV1RkRlFoSWZZS0pxeWFnRHVvWlUvWXRyR0dXTGlIeW5F?=
 =?utf-8?B?Y3hoeE5ybU1LM3FQUE5uc2Z6TnQ0bi9ISlpHZmNWQ2hnSjZEWThrUXBxa3Fo?=
 =?utf-8?B?Tk13YjVGQTBjaHlqamdCQ1BzUkorTVhSaGtnL3h3TUdCRi9FMFlhNmVkbDhv?=
 =?utf-8?B?VXF6UnQ2ZWRmNW1ScUVVL2hQSGJZL2E1NUxoMWh4c2ZCbkFkNTBVb0RPejBN?=
 =?utf-8?B?N2R3K2lFaFJ1K3dhcE1qOWMyZmxOU0VRK2JqY1dyQ1lVbnhCbncxTkZwcEtE?=
 =?utf-8?B?dUV1UkdYSG1rcHpZNDVDVkpaN3ErNGUzU3dBRjdLb0FCV2xIUmFZSWl4cmpw?=
 =?utf-8?B?NitvclhETUsrQlJFUEZ5ak41dERaVU1BWExKSFNGS2Y3bFZpcEJ2bktXMlNa?=
 =?utf-8?B?dzdrNVNKdWdIWElwdlF3L2M3UXkwZEI2NUI2SFMwTU0xamdYaGFsYVRyQmdU?=
 =?utf-8?B?aXp2Q1dTblJPZnJjaGQ3T0RTV3RHUHFuWnRjTDZpWUhGU1V4eS9qTHBENm5m?=
 =?utf-8?B?OGhpT0dGaFR0OFRZV2VKWThLTGR5cmJWb1ZOMExFMDNpMVoyQThoS1M0Z0xi?=
 =?utf-8?B?QnByeUdML1JqSGh2WUE2UTNKYjdzVHY3dnIvbHdiUG1LeEhFK2x6NldtVjRo?=
 =?utf-8?B?WlArTG9QOG9nMGxQN282OGFxWUd1VG9MY0hTUTFzbklidzBLOHQxVkJFVzRL?=
 =?utf-8?B?ZzdVODVIYmd4QnZNK3JIdHNyYWxUeEpoWG4va2t1NEdsVTNMZVA0YXRSbTZa?=
 =?utf-8?B?aEZ4R2lqV2ZvMWNvaGZIa0RYZVc1aVZ0UFNMS1ljVHQvWHcyY1ROUE15V1lh?=
 =?utf-8?B?NjdMY3VhU2dXNy9aSStEUnBwdnlRTmsrMitqU0xXWVVPaG1UbkxBVlQxc01u?=
 =?utf-8?B?MXJZMnk1SjJCN0syM05Dc3VSeXdtNjFZemRzT0FNZjgrY0VZZ0ozSEhUcTU5?=
 =?utf-8?B?dE44TlF0ak5lb3pOY1loWVRTdjRHSFV1dzF4Ykxncjc3aXNZUXA3Y0hTMmV6?=
 =?utf-8?B?a2lqaHJvcUZ2cUNQdzg0VTlDZHloUmJCQW5VMEN0L21RaFVVRmhGSDVSZ2Zt?=
 =?utf-8?B?YUlxNngxdkVRUXhuT25PTDNOSEZaemovSmJlTkI3NGQrcXVCNlp6Vng5N09O?=
 =?utf-8?B?TE5aZXpLeUpLWjVqVVhOcHdXTGtaSXhRSXZuakpTTXlEcE9lWEw1UUUzUWtR?=
 =?utf-8?B?aTArVkZpL3k2cXdDQmkxWi8yWTFwbmlHY09IR3VLVW8zOGZSRXl6NC9BSVY2?=
 =?utf-8?B?czNpTTZ4bGw4WGJKb2RNMU5EZGRCL2dWcjZMeitwTi9KNXNxRFc3b3Y2SXVV?=
 =?utf-8?B?cFJIajNkdnJhMC9oZWNvdVRvYU5EWk4zK1JVT09NTFFLbkJkZWtyRmU1TUFa?=
 =?utf-8?B?cmpMb3JqZ2ltSG56M0JrWWNPWmpLZlNUTGFINm5janBaaVNIRGZlSnFQRDd0?=
 =?utf-8?B?blE2OTdQUkpaUmhuOEl4M3lnZGd1Z29xa1ZSZlBSN1ZjNmppSEtpbW5TVFUx?=
 =?utf-8?B?UXFDUmREbXFXWEdMZVdDdDlJbE11M1NWeE5nN1EyZGR2OU1HU0xod3NwV0pi?=
 =?utf-8?B?QngvS2tLNDdYYVRyZTYyc0U0ejA3UHdYeW9VcE5mWGpkUUZYWmtxVzhCaXJY?=
 =?utf-8?B?aVpYSU4razloY2ZFSkZSdUlFcEpSNVlnZU5zUjNMcEtLT25hbVZKWTBPblVC?=
 =?utf-8?B?Y25ZUDJ0ZGdRMDl5NHRjWEJvREdpRWRrK3pNbE1FQ01TbTNTUkYxZFdmb1kr?=
 =?utf-8?B?ZkZBaWxVdmF4WmRXV3BPTFMrSzNKODNQZEE3OFl2TGFoU3JtRFFnNnhiRFk3?=
 =?utf-8?B?ckE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FB091DB8149794090EDDD59EE4D04D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81809c0f-3178-4ffe-9dbc-08dc0d743658
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2024 22:26:35.8350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OzpRmLQnGx/TmBaIjgoeCtbPj4+9mCA78aGvpOsV0Ut/x7+3nC91S1ttT1yB7TtxNaK/BYheO6Vz4BQv1a+AXCyB6RST3hWO9WkkOVciqw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6000
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIzLTEyLTIxIGF0IDA5OjAyIC0wNTAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiBEZWZpbmUgYSBuZXcgWEZFQVRVUkVfTUFTS19LRVJORUxfRFlOQU1JQyBtYXNrIHRvIHNwZWNp
ZnkgdGhlDQo+IGZlYXR1cmVzDQo+IHRoYXQgY2FuIGJlIG9wdGlvbmFsbHkgZW5hYmxlZCBieSBr
ZXJuZWwgY29tcG9uZW50cy4gVGhpcyBpcyBzaW1pbGFyDQo+IHRvDQo+IFhGRUFUVVJFX01BU0tf
VVNFUl9EWU5BTUlDIGluIHRoYXQgaXQgY29udGFpbnMgb3B0aW9uYWwgeGZlYXR1cmVzDQo+IHRo
YXQNCj4gY2FuIGFsbG93cyB0aGUgRlBVIGJ1ZmZlciB0byBiZSBkeW5hbWljYWxseSBzaXplZC4g
VGhlIGRpZmZlcmVuY2UgaXMNCj4gdGhhdA0KPiB0aGUgS0VSTkVMIHZhcmlhbnQgY29udGFpbnMg
c3VwZXJ2aXNvciBmZWF0dXJlcyBhbmQgd2lsbCBiZSBlbmFibGVkDQo+IGJ5DQo+IGtlcm5lbCBj
b21wb25lbnRzIHRoYXQgbmVlZCB0aGVtLCBhbmQgbm90IGRpcmVjdGx5IGJ5IHRoZSB1c2VyLg0K
PiBDdXJyZW50bHkNCj4gaXQncyB1c2VkIGJ5IEtWTSB0byBjb25maWd1cmUgZ3Vlc3QgZGVkaWNh
dGVkIGZwc3RhdGUgZm9yIGNhbGN1bGF0aW5nDQo+IHRoZSB4ZmVhdHVyZSBhbmQgZnBzdGF0ZSBz
dG9yYWdlIHNpemUgZXRjLg0KPiANCj4gVGhlIGtlcm5lbCBkeW5hbWljIHhmZWF0dXJlcyBub3cg
b25seSBjb250YWluIFhGRUFUVVJFX0NFVF9LRVJORUwsDQo+IHdoaWNoDQo+IGlzIHN1cHBvcnRl
ZCBieSBob3N0IGFzIHRoZXkncmUgZW5hYmxlZCBpbiBrZXJuZWwgWFNTIE1TUiBzZXR0aW5nIGJ1
dA0KPiByZWxldmFudCBDUFUgZmVhdHVyZSwgaS5lLiwgc3VwZXJ2aXNvciBzaGFkb3cgc3RhY2ss
IGlzIG5vdCBlbmFibGVkDQo+IGluDQo+IGhvc3Qga2VybmVsIHRoZXJlZm9yZSBpdCBjYW4gYmUg
b21pdHRlZCBmb3Igbm9ybWFsIGZwc3RhdGUgYnkNCj4gZGVmYXVsdC4NCj4gDQo+IFJlbW92ZSB0
aGUga2VybmVsIGR5bmFtaWMgZmVhdHVyZSBmcm9tDQo+IGZwdV9rZXJuZWxfY2ZnLmRlZmF1bHRf
ZmVhdHVyZXMNCj4gc28gdGhhdCB0aGUgYml0cyBpbiB4c3RhdGVfYnYgYW5kIHhjb21wX2J2IGFy
ZSBjbGVhcmVkIGFuZA0KPiB4c2F2ZXMveHJzdG9ycw0KPiBjYW4gYmUgb3B0aW1pemVkIGJ5IEhX
IGZvciBub3JtYWwgZnBzdGF0ZS4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogRGF2ZSBIYW5zZW4gPGRh
dmUuaGFuc2VuQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWWFuZyBXZWlqaWFuZyA8d2Vp
amlhbmcueWFuZ0BpbnRlbC5jb20+DQoNClJldmlld2VkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmlj
ay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo=

