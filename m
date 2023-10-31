Return-Path: <kvm+bounces-154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17EA37DC751
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 08:31:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 472541C20C1A
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 07:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B6A1097E;
	Tue, 31 Oct 2023 07:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AyfIrC9I"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309381095B
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:31:35 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9241C0;
	Tue, 31 Oct 2023 00:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698737494; x=1730273494;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RKPgYBbZkm3SFmQEKKNaPvxcw2vsm+XTkIpDxhrlV60=;
  b=AyfIrC9ImCSJLAdSDEBmRgC5WN1WQApNvRzlD3JYCFy3Rv1rGCyGZp5l
   8oAXocbEJjv3wAk4z+xa3vyJ58B5/bZYyy69SOtPYeCPHop2rI+UiTAyp
   fXDZW6ipRVujnqXJBZSk6KW2rQSZ2wKKeKe6SbjqsrEHgtph0xoUqcOGJ
   dGQdESOOeDijVCjN5x/DHoPKqTdo50rvfUBcUNHEeKA8H5ivLRAXObujx
   quISXvthfZmdfXRTJ1fR+GCBTshCJcFtKk2Slu35YOKUtoTxS9nv7XTr8
   9/MfhAqGC6F+w5wTh15mOFELQ2GtfzJ1EsjbyYc2cbCIJQHFRTzRbjAg/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="9761870"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="9761870"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 00:31:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="1091912637"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="1091912637"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2023 00:31:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 00:31:32 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 31 Oct 2023 00:31:32 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 31 Oct 2023 00:31:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aib82Gwsmw9bq5k1AFjZXh3Cj3m+01gH+1B94weZGF+enypht24/uTLDG8vS6Lf1nlkzqkxkoNckS/eBkTppcIuPrzKQU69FweHaDrmC/wZSjR/szUj2UDJ0gmOwCNenHHjTzrdQkVW3Rlzh/CVv1VZpXW3I0y+ODKXAfBNLKQVVM6FkVNVG86qb8RX7K4bVXzdSzbTFttTtbV46dHEOp0bvJBPDGI/X4fyMnpNY53iIE/rfoxahypIHmtaTRFm2M7l9kF/Sv0qvZAAPItN2VE5YhjUntL+0RQTlhdND4qtjI+dpSQiNe8FMzjWKuMDJsIm6X00n2GiCvx6vDo18Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RKPgYBbZkm3SFmQEKKNaPvxcw2vsm+XTkIpDxhrlV60=;
 b=n4EVNcdLf6dR1Dzen714xngMLhHoWIxPimKVBSQAt8wJlVzPRK36V4vKtrOK7FogVdjgkV+i9mnbRb205QPx0lgopf1/wd6P/1arFlMZvL5413KpbkxU1wZ53byEU/msMH0U5Lf/HYIZVySqzrwAwuhAtm8KB0/LEr+6rToSYAlGxW2zO/AOvA9vMqG0nskGPSrs53WNxPUGB1ZUrP/asgd7ZJGgxmTGvZh7x0LjfDdMyxHA56EU8Kmm4WhylVD2kTf0MUrWOjup66nHpCWihbG8htUt/6T1+DCC0DevoB4VRhmwjJXOec61O5cDvHl9eLVF16U1LNj+yi+aImVSaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by MN6PR11MB8241.namprd11.prod.outlook.com (2603:10b6:208:473::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27; Tue, 31 Oct
 2023 07:31:25 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3bbd:f86a:80ea:eb8a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3bbd:f86a:80ea:eb8a%3]) with mapi id 15.20.6933.029; Tue, 31 Oct 2023
 07:31:25 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Jiang, Dave"
	<dave.jiang@intel.com>, "Liu, Jing2" <jing2.liu@intel.com>, "Raj, Ashok"
	<ashok.raj@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Thread-Topic: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Thread-Index: AQHaCPdEtaV8qeHO6EmMpiKLQ58cQ7BjhMFw
Date: Tue, 31 Oct 2023 07:31:24 +0000
Message-ID: <BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
In-Reply-To: <cover.1698422237.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|MN6PR11MB8241:EE_
x-ms-office365-filtering-correlation-id: bc36bac6-d769-4c2e-b31d-08dbd9e36305
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +p92Ycnw6Sreab9szOgG9zm3eNNTEcoKtvvxf+c1UnTzc5HIupNeTph0QqbsdxB/uolNjURmoQmeqouCZTchli55AKhenSCI2pB90Yst5hHv8WyTRDUAUaVH8b/Gnz9KnSw/jElwv69nNSgKyoOgfE7X61Mu2lNaIQijU2qgmzHjTC6FH9CV+pHjtQS4L/6CLyHqT5I2N634Oz4lVrTwA+tfExkrH60XOGSS21rdpkNO7HjBAYtofSO0BDSqG4wa939C7RTxTCX8RPJZzK3XLhVAWikPMEV88Uh5SvvhsrivUvDoN5Ob0JaYZDrD6rVYl+i9iDJWh8BRAeIBJ32r56uGILmbxEgs4U4KxL7Lma5/Pjs455Vhij4UWVi/aPwHdeKo2sgafi5OXi2jM4K4mdWlK51/1rX9Qqvu9IlkyTDCvhtk9D95+NeGJo/CbYYQvSA+4h+ben4giRJ/BmuYMjEbbZEwNYw76KW64w3KJr14DBncFXR4v/DJKLXiySoEFn0YjWjZSFpIFOCUlki1NGDUDhCVCnlFKYZVD43z+xHEv3hKLgkS5hIGxRQmEzk0IkqVU5bfEF9EGaI69UkJcLLmdYCdI8To6SfF/nZKaek=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(366004)(136003)(376002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(2906002)(55016003)(4744005)(66446008)(64756008)(54906003)(66556008)(76116006)(66946007)(83380400001)(82960400001)(110136005)(66476007)(122000001)(316002)(38100700002)(7696005)(9686003)(6506007)(71200400001)(966005)(478600001)(26005)(33656002)(41300700001)(15650500001)(8936002)(8676002)(5660300002)(86362001)(4326008)(52536014)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWJwa0loeVhLbG82WGlnUVg5aVhGOHRibU1ldG1vTDR0ZHdvWEl6YUorNFUz?=
 =?utf-8?B?T1JsaXVGWHRHZm80LzRTS2hmaHR0NEV6N2hxU3VyZ1gwRnpHL0hqREtiMDFw?=
 =?utf-8?B?Tks1SE5qZEticzN1aG96UW5tTnBLYllOeWdGUUN4dnAyVHNPMUZqQ09iMHpV?=
 =?utf-8?B?Zi9zUG9wRDhZMDdZMVdCZVRyZFFKZ1JQMDBxSnpZVVBBTWw3QW9FK0lWZ1M0?=
 =?utf-8?B?bHQzRExSQTRiRzdQaS9YQzdxUWtFVWhxYnhmbitIMkFmeWE2Y1ZrWngrUkRy?=
 =?utf-8?B?eHlrenRxeVUyL080NDNtSVlDUHR4Qk9WT1hzY20xbFhuR2VQc3lsTGJSTnNL?=
 =?utf-8?B?cVJ6YzZxQytLUE5pbG0waHlmek9LMEh3V1llRkJXZ2k1QVozSUhYUzFCb0xp?=
 =?utf-8?B?TzQ0dnB5NGJFSDdaeFBsa3hPS2VaME1aeDh4aXdPcGxtLzQzRGVwY3oySk40?=
 =?utf-8?B?ZU5BTzBlSG9KY090MUFmQ1VMZng4N09walc2ei9IU1JOOGtqS2ZHcURsMm1B?=
 =?utf-8?B?K0RlR0NnSDhTNUtTaGV0dm9rdkFtNzZ2WlBDTGxmNGIzaTNlRk1RY1JwZjFH?=
 =?utf-8?B?TkJJaWdpWTJKaDQrU1FDNnpRMmhibjc2dDFhelJEcktZL1czVmRlVzdqUEV5?=
 =?utf-8?B?KzlydWpFVXNQV09TQVJwVG1pWWZGMW5saC9zamVhaUs2TzBUWllSTUZHNWg2?=
 =?utf-8?B?T2FEVUJIY0F5aGpOYXhIWHI4RWJmeGJCa3pnV1BTVlFUZXphazBiZEJ1cW1i?=
 =?utf-8?B?d3MwblIyZk0rdVZNRVo2aTlwT0dzakhpNFd3Uks1Q0dHbGRiYlpvSXhZcWRP?=
 =?utf-8?B?VTNuUTV6eEhVYUphdU5acHNORDlVVE9JZVo1cVo2SjdVTlVPNmhCQ3d6TDBD?=
 =?utf-8?B?Y2RmcHlubjdPTldnTVBMdE45ZU4wS2Z0b2s1bldvNGZtdStjc0RUZHNzQjNN?=
 =?utf-8?B?TitCVkVsNnNZY2JSc2ZKUzVjRkN1ZFEvUEtwdGxZY1BuZ3crOVVwNnRDQ000?=
 =?utf-8?B?Q3hrOCtvaDRDMjVVNW1vOWo1N0hCNisyY29EVnpQcXNKTjZ6eHhJZlJUaGJZ?=
 =?utf-8?B?Q3JaaTNrRW1nQnhiOTN1ZnJZTWJncGZ0aWtaUmxOY0hlaEtEVVMyeTBEWUtT?=
 =?utf-8?B?eFYybjZBQ0hLOEh2ckx2K3FMS2gvcTMyUEsrekx3RTMrZWdGMU9RaVRUTWxN?=
 =?utf-8?B?cDFqbXk5Qkw2R1BhMEsvUnNoSzhHTWlDV2I0QzltWUhmV0JnWUs2MDNsQVky?=
 =?utf-8?B?aXhuZDVDTkg2cG1tY1hFSFI2b0lPaG56R0JCbk5kajZZUTBQbXE4My9xY2Vm?=
 =?utf-8?B?OVpZWFBGaXFzVHJXT0dYOXlLZVd4T1lyd1krWFZaa1VpQ0ord0YrSE1UeHhH?=
 =?utf-8?B?VUExQ3kwWmJTbjRJRlB5ckY0NkJ0NExzQmxpOGQ0VEVxTHAyMUx6b1pnL3Y4?=
 =?utf-8?B?Ymc2SHphTnRQVFVNTHYyY2NtVkZ5YTFCeEZvVCtrL0ZRdWxaZlA2c3ZoNjR2?=
 =?utf-8?B?RWRiM2h2b0lGSldSTFpBSndyMUlEb3BRQjZZRHh5c0tKcjcwL3ZCckJ2MmxH?=
 =?utf-8?B?ZDd2SHBKemp4UW15T3M3MFlMdXc1azdjTy9uRzdQK3FZQjB3ZFh2cS9xUnFO?=
 =?utf-8?B?WldtMnJ3dDRYNFVlSm5IZTVZKzBLYklvbWpJWDVuN2FjVXFjQjJ3M3kyR0ZO?=
 =?utf-8?B?bWQwOGFUVXl4T3JGV2N1bW1XaHU5cmR1UEFHUDhRR2dNc0w5MU56bGVyODZC?=
 =?utf-8?B?a05xWTd0RmJTMDFGVFpuSDcvWGc1NDVlQTNPSVJkQWx2SzdKMGplSjNSelVZ?=
 =?utf-8?B?M1dGYnpoN3lYUnVBSEt2V2RwV0hrVmRlZU1CWGlFYS9RQmNrd3VIWHFOVTdR?=
 =?utf-8?B?VllWVzEyL0IxSC82cUtkNTEwWWFsVU5sWWZsTTIwSFc5MjgyMGdVbWpDdDNL?=
 =?utf-8?B?Y1RYZExuajhNQy9CSzRWM3Fnbk13eVNiWjBrbTR2SHhXVHorMlB5N01jUnhE?=
 =?utf-8?B?VjA2VFIwcE1ZTUdGY3k5T0lqcjdESS9XZ0htWVdIdzh0TGo2enlYamxSbnZT?=
 =?utf-8?B?aXJwdjB4V3ZwS0FUVVYrUG9YMG4vMXo1TGgwWGd2anFZZVFyRFJ1aXJVVWov?=
 =?utf-8?Q?pqI69NEvjasZbyE4WxZVL0Zjj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc36bac6-d769-4c2e-b31d-08dbd9e36305
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2023 07:31:24.4986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X/G1GWLs1nfRLKu7V/XXwHpYAfVwis5F8GUekEp+dJYJsMjqQpSLzpWFN9Ads+qeK65iRMoBW1/YGn3kx84Iug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8241
X-OriginatorOrg: intel.com

PiBGcm9tOiBDaGF0cmUsIFJlaW5ldHRlIDxyZWluZXR0ZS5jaGF0cmVAaW50ZWwuY29tPg0KPiBT
ZW50OiBTYXR1cmRheSwgT2N0b2JlciAyOCwgMjAyMyAxOjAxIEFNDQo+IA0KPiBDaGFuZ2VzIHNp
bmNlIFJGQyBWMjoNCj4gLSBSRkMgVjI6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwv
Y292ZXIuMTY5NjYwOTQ3Ni5naXQucmVpbmV0dGUuY2hhdHJlQGludGVsLmNvbQ0KPiAvDQo+IC0g
U3RpbGwgc3VibWl0aW5nIHRoaXMgYXMgUkZDIHNlcmllcy4gSSBiZWxpZXZlIHRoYXQgdGhpcyBu
b3cgbWF0Y2hlcyB0aGUNCj4gICBleHBlY3RhdGF0aW9ucyByYWlzZWQgZHVyaW5nIGVhcmxpZXIg
cmV2aWV3cy4gSWYgeW91IGFncmVlIHRoaXMgaXMNCj4gICB0aGUgcmlnaHQgZGlyZWN0aW9uIHRo
ZW4gSSBjYW4gZHJvcCB0aGUgUkZDIHByZWZpeCBvbiBuZXh0IHN1Ym1pc3Npb24uDQo+ICAgSWYg
eW91IGRvIG5vdCBhZ3JlZSB0aGVuIHBsZWFzZSBkbyBsZXQgbWUga25vdyB3aGVyZSBJIG1pc3Nl
ZA0KPiAgIGV4cGVjdGF0aW9ucy4NCg0KT3ZlcmFsbCB0aGlzIG1hdGNoZXMgbXkgZXhwZWN0YXRp
b24uIExldCdzIHdhaXQgZm9yIEFsZXgvSmFzb24ncyB0aG91Z2h0cw0KYmVmb3JlIG1vdmluZyB0
byBuZXh0LWxldmVsIHJlZmluZW1lbnQuDQoNCmJ0dyBhcyBjb21tZW50ZWQgdG8gbGFzdCB2ZXJz
aW9uLCBpZiB0aGlzIGlzIHRoZSBhZ3JlZWQgZGlyZWN0aW9uIHByb2JhYmx5DQpuZXh0IHZlcnNp
b24gY2FuIGJlIHNwbGl0IGludG8gdHdvIHBhcnRzOiBwYXJ0MSBjb250YWlucyB0aGUgbmV3IGZy
YW1ld29yaw0KYW5kIGNvbnZlcnRzIGludGVsIHZncHUgZHJpdmVyIHRvIHVzZSBpdCwgdGhlbiBw
YXJ0MiBmb3IgaW1zIHNwZWNpZmljIGxvZ2ljLg0KDQp0aGlzIHdheSBwYXJ0MSBjYW4gYmUgdmVy
aWZpZWQgYW5kIG1lcmdlZCBhcyBhIGludGVncmFsIHBhcnQuIPCfmIoNCg==

