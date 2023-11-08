Return-Path: <kvm+bounces-1146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B8077E5280
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 10:16:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E978528148B
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 09:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B03DF4E;
	Wed,  8 Nov 2023 09:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NssESzC6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40A4DDD5
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 09:16:17 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500A51B1;
	Wed,  8 Nov 2023 01:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699434977; x=1730970977;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4F/9x+kRy0znImV6ciJGZWIoVZnkzVKUDP9/v+sib2A=;
  b=NssESzC6rk99R50KyKwtU3/AEQi2qFKgu33BQp4z5YjerneA8VloPwGV
   BPeSZ8UDGihgWLkMW0XmlL1yQiDr5bfIy/o8yjXR6JHGY/OPEh6rxtY4R
   fGscg/blBe4BDe9atV1kNbiYkrqVJLnDu55Mm6x+FQ1QGfLD93BoXNiqu
   l2+706jGHQGlLTBC5/BZ5ncW3u0Km4d+pal+OE9GdZXR4ieYtWZlwhUR+
   HgMBI3Cv8G/2rpbRYhkH/ng5ASvy6uEVWNHWPBHLoON6pfGMu0t9e7ixL
   ZciuYDLZ9uVLpjn1usDdlxc+AuP6X/jK2S1q++Su9h8OeWOZiECD4UwPp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="369062691"
X-IronPort-AV: E=Sophos;i="6.03,285,1694761200"; 
   d="scan'208";a="369062691"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 01:16:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="766592849"
X-IronPort-AV: E=Sophos;i="6.03,285,1694761200"; 
   d="scan'208";a="766592849"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Nov 2023 01:16:16 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 8 Nov 2023 01:16:16 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 8 Nov 2023 01:16:16 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 8 Nov 2023 01:16:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HK4aham04fQ0lR5N1ElKcma4jiVH7I8TBuY0kpeZxeO9+tGoMqzI173pOv8g3sz27TbDreMg4JzHh8ClmBnKVi+5Pgb2tSgCfJetU0stFAN+XTJAoU047b/Qj4wEIR0cmPXVohaYwTmtrdcMG0io5ADKd5XL/1OJyEMItUmynM2Ak2bu399MHHOBmJDs+/ORmjGODHkSbInsP+v7EBGUXmxO/wojSSgHzipS9T2F7qZ6tqD5SNBHwlf3BQbaLbstIR6FGl4H92mIOCHZ/shs9LvIXC4QiHem5yN2P11wiSojsUD0+OszUoFLfmkpzjnJa+sK4JBo9DqPX4Z2OWXbRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4F/9x+kRy0znImV6ciJGZWIoVZnkzVKUDP9/v+sib2A=;
 b=dlonINjednXXa8r+X5xCBG056VhxTT8M2R6SqonaB/+G10qm0BeR/4iHoXXZWPkbGuaNzzO/7SUnmQWONrZRvlJ40c/H8kpD2nOpU51Dm6/eFExEnZE1ZAxr7sqSfrmVM3qZJ6FkSQ7QdPveokVKoS6ad3mr496sTkExffWkO9sNj7xmN5dB/vPBHZxLBMGLlPdsZ9RYziTBPAvTY39u8rSy0xs26qLFXGonxNaS0u4tLJDRD850Ohdpb69pamg5jrzsN0/gb2RhoK2hDAUdSn5sH7BJqtRjp65sRFc1KWXHhVfLde2St+7P8Xfb6YrT5lT4CTqkDiCnU2DFD2huHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL3PR11MB6434.namprd11.prod.outlook.com (2603:10b6:208:3ba::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Wed, 8 Nov
 2023 09:16:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.6954.029; Wed, 8 Nov 2023
 09:16:14 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "Chatre, Reinette" <reinette.chatre@intel.com>, "yishaih@nvidia.com"
	<yishaih@nvidia.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Liu, Jing2"
	<jing2.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "tom.zanussi@linux.intel.com"
	<tom.zanussi@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Thread-Topic: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Thread-Index: AQHaCPdEtaV8qeHO6EmMpiKLQ58cQ7BjhMFwgAJFzACAAIkGYIAADu6QgAEuhgCAAKTv8IAAk0eAgAXJGJCAAMJ9AIAAN2KAgAA+XICAAGpo0A==
Date: Wed, 8 Nov 2023 09:16:14 +0000
Message-ID: <BN9PR11MB52768A15A295455C9D82AA8B8CA8A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
 <BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20231101120714.7763ed35.alex.williamson@redhat.com>
 <BN9PR11MB52769292F138F69D8717BE8D8CA6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231102151352.1731de78.alex.williamson@redhat.com>
 <BN9PR11MB5276BCEA3275EC7203E06FDA8CA5A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231103095119.63aa796f.alex.williamson@redhat.com>
 <BN9PR11MB52765E82CB809DA7C04A3EF18CA9A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7f8b89c7-7ae0-4f2d-9e46-e15a6db7f6d9@intel.com>
 <20231107160641.45aee2e0.alex.williamson@redhat.com>
 <20231108024953.GR4488@nvidia.com>
In-Reply-To: <20231108024953.GR4488@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL3PR11MB6434:EE_
x-ms-office365-filtering-correlation-id: e52ed47a-270a-4e30-def0-08dbe03b5b70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: voiDPU3UHqIe2Ojjt+wNKa1SOFijLG2LpLa7VBu1imdULgGEFqs5oEMGOsBMc/YRTWYrRziOXw68BfIwq9pdcd5PfMCRtF39fq9RlCt53UVePO9ckqXD8MFEtdMHNmsMp8/AOcbFmHxXmp9D1ugu+H9aZf5ix4FHbBhcfAF4iqOFvgEeYNcPeKTvSWDCljKLH6mGaVS+0TwAKTwab4v1Uy8b7vuV9gJnLpLoLFxsGT4gNXWkOvW/09BFcU4o1mXX6g+MPHNZ+gAFSPWH9ikW2MxAmRBUREhxZuVo+g5rZl8YWYNBb8MjKPSE937QFaBEja8o31CTiEVbNDG9sVzvxGD6ynE4NejgOfRIThtT6JcQHlVTA1V3addjgHG3Ckkc96Amd3RrWzcgCGZk1yW0iwUw7Pw0Tq4ZXPQ/8TotCKUk1hV9QxnOr+0YIqpyJ7uAGjTouDTYs5hbEYZnyWc9IICm1BjcnMrUwG4IOreCP9hefzCsREBDdSH2kfGjxqqkVO3jHrQg3kGxX15/6qFw/SPRSaet0w0E1WFpZoDNQ1IlTIW6TfQdepg6iNSIaYVL2/8GCj83hSc02b6LOhkK+Yz05RY56W9wmuJlPmUW8uBOWxGPWY5Mj4SIBO+km+Wb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(376002)(366004)(346002)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(86362001)(122000001)(38070700009)(26005)(33656002)(7696005)(9686003)(6506007)(55016003)(82960400001)(71200400001)(38100700002)(478600001)(5660300002)(52536014)(4326008)(8676002)(54906003)(8936002)(41300700001)(2906002)(76116006)(110136005)(64756008)(66446008)(66476007)(66946007)(66556008)(316002)(66899024);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFlwR29VTlhrTnYwb2VDV1N3UUxsbkRJSFZwdVlQa0U0dkRPV3NCa0l3cG8z?=
 =?utf-8?B?WGx5clprVDZrSUg2UjZpN1d0U2V6SlFndjB4N05LbGxzRXBYM3RKREtrZEVY?=
 =?utf-8?B?VFMzK24zMkliOTJRR1R6cTBtTmJ4MUZqWmV6aGVyc3EzbDhLU3RWRmxqOGt5?=
 =?utf-8?B?MWhWdHROZDZpcTRGZEVyNnlpbWVLekJmWTJncjB3RCsrUGJKaXRNU2FJZ3la?=
 =?utf-8?B?T3dUMzd4Q05yc0hqQUJpeEowN2xwaWtMNGVKeVhjL3hNNDI0VVVNbmltK2gw?=
 =?utf-8?B?cnFGR0Q0K2M3cTl1dUFEcjZ6blh2WWJjNDhMd3R5ZCtTcmE2Mm1rNDBnVm81?=
 =?utf-8?B?dlY2bDI1dlp6NVdKSWx5ZmlPQUMxMGVvSXNJaTE3ZWRQaU9zR1N5WXE3NlQw?=
 =?utf-8?B?blVwQ1pacEdpQzVJNTRkTkowZnZvNGxxeUpJL1RUQ1lrUlFzVlZNRTlybnFl?=
 =?utf-8?B?dlBCRkxTeE9OZ2JoUE5iNk1OZlNrMGRLQjgzN0IzSVBQUWU0elRBZFM4NjA5?=
 =?utf-8?B?cDVkcFk1Q1lnY0ZuMDl1N0FqdHBFaFRsbk1BUXlORmFsb3pwUVZnWnpHWTly?=
 =?utf-8?B?bVZZU2pEZHdZL244VW8welpKOU5EaDhWdjMvTENTdisyZXQ5Uy9zdUlwVjBT?=
 =?utf-8?B?RDhZN05XTFZmUTNHV3Z4cDNTVWtKczZiekJjOXdkbkNOV1g0SE9sclBkY084?=
 =?utf-8?B?Z3dLV1ROc0VRK2dmY0R2VnN6MUpoUTZVS0JqOUlwWHFBa05OUHFRbW9oUDFT?=
 =?utf-8?B?L1g3ZEJ2M3E1YlNzSUFxQXRvcnBmNEE5Y1RtQ2JTQXJWUUIxM3BtTjRxWDlr?=
 =?utf-8?B?bWpRYTBRMmRvSzhLaTl6T2ZBZ0l1TkVRZGlmamhXMjhUNTlpV3d3bUhDYjdU?=
 =?utf-8?B?Wm01VXFtRlFteGlGeFArSkNjZkpyM1VRZmtjc0hNZUVrUmNmWGlhbkluaHpn?=
 =?utf-8?B?Tk41OXFIb3FpUEF3K2NEZzZGakdHemhnUVZ1TFZpV3FYQWloYytyYVFtelgy?=
 =?utf-8?B?YjJxYlBUdHN4UkZEVkZPaFg0Z0h4RVZBQmRza0pRVHJwai9iZ3hhd2p1a1hs?=
 =?utf-8?B?aWNHbmNMNXR2VTA1dldsU2JTaHJZZjFzVW1XSU5jQjlqbSszaGlmOXk3Nkdl?=
 =?utf-8?B?NTZmaWZzZkJEZGdyRkwrY05yeFhmSmFHWEY5cTRqRkFtZm90c2x1enRoNVYw?=
 =?utf-8?B?bCtBNjZQR0I1ay9FR0hGdGY0cERvT1FNeERkL2JEVzFvODdIZS9zRm4xSGZ5?=
 =?utf-8?B?empDSzJoUzQ5S0k2czJXUXNjblN1aEtsSGdCYkpzdmw1QWlkZEd0WHNLQ2Zo?=
 =?utf-8?B?cWhKL1VoVnlaVWlpRUwzN3hjNDd1TUkzUWU0cE5CZ245bVJmQzZXZEdQS21S?=
 =?utf-8?B?ZEMzR1JzN1ZYRkMvbERUVXhFaDE5cnM3Zm1QRzBPelN0a05oYWJtcHg1WURi?=
 =?utf-8?B?UEpPN1NOM25udEJhQVBMc29ocm5VbmY1YndGSlMrbFJMQXh5MVBodDdmQU5R?=
 =?utf-8?B?OVcyemIya05odWtPaW9TejgvUFhhY0pscE5iZHo4YVhBckJjUm1CcjNHOVR5?=
 =?utf-8?B?eHltZE9qUFVrMjZVVjA5NmR0UCswSU80RFlXa2N1NmVaVjNZYjJreXdNZlY2?=
 =?utf-8?B?NW11enBrYTV3a0x5eWx0WlFoL2V0NlFpK3ZSRlNVSkdXUElwQzVaOTBuM0c5?=
 =?utf-8?B?MFpCb21BSm54VGx0NE1WcS8yVTlQK1E4ZGtuQ1g0R3B1cDJkNStOajlxc2pX?=
 =?utf-8?B?NlBrckg0YUhnamxFTjRxZmcxQ1Q1dzYrZmVDRHV6R2lUWTVQQW1uVGIvdmVL?=
 =?utf-8?B?RENTeGNSejg2b25lTmhqVkp0ODJmK0p2dzZ2RExVZFEyVTZzV2tSY1B2SXMr?=
 =?utf-8?B?ejdjVWJESU41NExuOUhIRi9DNHU4WnN3cjMvdThoZW9aVmVOWFUzMDhiYitO?=
 =?utf-8?B?bEFzdkdIZGNBSU5HZDVJU24vL1VMYzNHS25YODd0a3VwUC9zZnp0S21SYURk?=
 =?utf-8?B?Q2ZiV01iTnNmdHFqUlhiVVlZVG1aNWQ5dFpjbnliY21oSWFNdTU2Z1hPV0Yx?=
 =?utf-8?B?dWZ5bllhM0VUN2FOMHZQVFRkdG5JaFBETi9oM2xUblVBT2UvRkUvUjN3S1ow?=
 =?utf-8?Q?b9oSB1CL8gb7JyvYY7jpvS79a?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e52ed47a-270a-4e30-def0-08dbe03b5b70
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2023 09:16:14.4610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lLETgKSRiIdYbHSBFdhn0uhbUa3N2pBV3n7bxtqDiRi9XkR2Jv9xt4NC+ShOVz1SaQQAo8w9IV3+TSle6B/KBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6434
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIE5vdmVtYmVyIDgsIDIwMjMgMTA6NTAgQU0NCj4gDQo+IE9uIFR1ZSwgTm92IDA3LCAyMDIz
IGF0IDA0OjA2OjQxUE0gLTA3MDAsIEFsZXggV2lsbGlhbXNvbiB3cm90ZToNCj4gDQo+ID4gVGhp
cyBkcml2ZXIgdGhhdCBkb2Vzbid0IGV4aXN0IHlldCBjb3VsZCBpbXBsZW1lbnQgaXRzIG93biBT
RVRfSVJRUw0KPiA+IGlvY3RsIHRoYXQgYmFja3MgTVNJLVggd2l0aCBJTVMgYXMgYSBzdGFydGlu
ZyBwb2ludC4gIFByZXN1bWFibHkgd2UNCj4gPiBleHBlY3QgbXVsdGlwbGUgZHJpdmVycyB0byBy
ZXF1aXJlIHRoaXMgYmVoYXZpb3IsIHNvIGNvbW1vbiBjb2RlIG1ha2VzDQo+ID4gc2Vuc2UsIGJ1
dCB0aGUgcmVzdCBvZiB1cyBpbiB0aGUgY29tbXVuaXR5IGNhbid0IHJlYWxseSBldmFsdWF0ZSBo
b3cNCj4gPiBtdWNoIGl0IG1ha2VzIHNlbnNlIHRvIHNsaWNlIHRoZSBjb21tb24gY29kZSB3aXRo
b3V0IHNlZWluZyB0aGF0DQo+ID4gaW1wbGVtZW50YXRpb24gYW5kIGhvdyBpdCBtaWdodCBsZXZl
cmFnZSwgaWYgbm90IGRpcmVjdGx5IHVzZSwgdGhlDQo+ID4gZXhpc3RpbmcgY29yZSBjb2RlLg0K
PiANCj4gSSd2ZSBiZWVuIHNlZWluZyBhIGdlbmVyYWwgaW50ZXJlc3QgaW4gdGFraW5nIHNvbWV0
aGluZyB0aGF0IGlzIG5vdA0KPiBNU0ktWCAoZWcgIklNUyIgZm9yIElEWEQpIGFuZCBjb252ZXJ0
aW5nIGl0IGludG8gTVNJLVggZm9yIHRoZSB2UENJDQo+IGZ1bmN0aW9uLiBJIHRoaW5rIHRoaXMg
d2lsbCBiZSBhIGR1cmFibGUgbmVlZCBpbiB0aGlzIHNwYWNlLg0KPiANCj4gSWRlYWxseSBpdCB3
aWxsIGJlIG92ZXJ0YWtlbiBieSBzaW1wbHkgdGVhY2hpbmcgdGhlIGd1ZXN0LCB2ZmlvIGFuZA0K
PiB0aGUgaHlwZXJ2aXNvciBpbnRlcnJ1cHQgbG9naWMgaG93IHRvIGRpcmVjdGx5IGdlbmVyYXRl
IGludGVycnVwdHMNCj4gd2l0aCBhIGd1ZXN0IGNvbnRyb2xsZWQgYWRkci9kYXRhIHBhaXIgd2l0
aG91dCByZXF1aXJpbmcgTVNJLVgNCj4gdHJhcHBpbmcuIFRoYXQgaXMgdGhlIGZ1bmRhbWVudGFs
IHJlYXNvbiB3aHkgdGhpcyBoYXMgdG8gYmUgZG9uZSB0aGlzDQo+IGNvbnZvbHV0ZWQgd2F5Lg0K
PiANCg0KRXZlbiB3aXRoIHRoYXQgYSBsZWdhY3kgZ3Vlc3Qgd2hpY2ggZG9lc24ndCBzdXBwb3J0
IHN1Y2ggZW5saWdodGVuZWQNCndheSBzdGlsbCBuZWVkcyB0aGlzIGNvbnZvbHV0ZWQgd2F5LiDw
n5iKDQoNCmFuZCBmb3IgU0lPViBhbnl3YXkgdGhlIHRyYXAgY2Fubm90IGJlIGVsaW1pbmF0ZWQg
Z2l2ZW4gdGhlIGludGVycnVwdA0Kc3RvcmFnZSBpcyBzaGFyZWQgYnkgYWxsIHZkZXYncy4NCg==

