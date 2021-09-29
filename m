Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AEF41BDCE
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 05:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243821AbhI2D7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 23:59:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:5925 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243226AbhI2D7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 23:59:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="212109272"
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="212109272"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 20:57:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="519581596"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 28 Sep 2021 20:57:57 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 20:57:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 28 Sep 2021 20:57:56 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 28 Sep 2021 20:57:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQJktEA/SS2XXVnZhH5n/ZOyY8FzQjL9QB9KlZKmMx8qwqoC79MNsGZIEt1O2zNhMLbnOwZady5vpMcS3staBxTvMjondpfulTpJAfy0fVZV+xVAMbAFV98vI25fPZhBaNTiANpAMC99l26MCw4m3fMMd/976NuWzcH2ZRE+ekbBhEkp2QMUbiPqgssIHdNkWswadtCwcCknzuULRuxaplbLwHeb6V54A8Z23IrwKV+gMI0+7OM/ajJ8olha5whvOdF6ZWwFgPx8PqLVX+O49RPQYaufuI4xbvA3FXYpWov7CyV/euBHWLYtUFro9tZ2OpjgfHY8LOEi8M/C/LDwmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=i+t+j16QU49cCczvH+zyQv4HdQCuKntjqx8pNvCtrl8=;
 b=OXfZOFK4nn1n8gT0q2ho/Qoir7WqkidLTvmSi8BXwbhCdKtnCt6rvP7aNiVQFbUcS3yO58RLHG11h6v43lDiEKCGqodB66cZZYtKe4zAQfi1IdXFLtQTDTxN85OSVnzkM0XFJlAYibJDs5QqFpJchS3jlH3g5QbijROSmufzv9dGhST8wK9VWjtMmUkKbN+YjE5mzY0yu0pkr7iHWGWKYJbJ7/h/ja1eZvRsJfLJg9QP9z3zV0ZAoqTAQVeEBHFGQH5gGN6HtvWXfFEfwQmnNsI7ocerBswp4FL9QoqGBLV0TxW2fy4kqvElV2uRV5eDTormfptEbO/NOCqenOdwbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+t+j16QU49cCczvH+zyQv4HdQCuKntjqx8pNvCtrl8=;
 b=k3PocCGSUMJeWPs1Ygwaqun4pfzhpF3nbaygjKDo648U8phefcUnjrsEoISLFRdA7Vu2d8FmA8bpMn0c5ohkyvt8wNvN2tiZwOEi2zGoJIfA2qhfcPcBPfFRRzjFogxXx3LYY+QATAPsqRRsg3SaHiGCknEEZoHPkZtz53BfKPk=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2289.namprd11.prod.outlook.com (2603:10b6:405:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Wed, 29 Sep
 2021 03:57:53 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 03:57:53 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>,
        "prime.zeng@hisilicon.com" <prime.zeng@hisilicon.com>,
        "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
        "wangzhou1@hisilicon.com" <wangzhou1@hisilicon.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v3 0/6] vfio/hisilicon: add acc live migration driver
Thread-Topic: [PATCH v3 0/6] vfio/hisilicon: add acc live migration driver
Thread-Index: AQHXqhc5lUNcPisp4UyTMpTu0c9BsKu6db8w
Date:   Wed, 29 Sep 2021 03:57:53 +0000
Message-ID: <BN9PR11MB5433DDA5FD4FC6C5EED62C278CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70f810b6-5075-467a-c212-08d982fd5069
x-ms-traffictypediagnostic: BN6PR1101MB2289:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2289AB90E95754A90823A8B58CA99@BN6PR1101MB2289.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fxQI0ovPvnR0SKcY7aQcvBQ87Hgv/l1zXGDBIP7HOWp0SKYmWXtP1ZslJNK1L27YpO9OvGL9gokyO2Cb7flVdqtaw9TPozMTvUmlP33xckIoluKJksdkxKZSFQUocsfrjwcr3cgfrHwwvK2vrkr5DKswktoxrTO0tnRnuI06uNjQJ7ctxPPwYcBuPTfhEv0PXKeq2ODKFCqmlv8tqrtNQLzSZjGi2xYKueEJ/7oaDYM21OcjV5if6W0UMj57F6SxScm284n2NMbOCq/CNo7axeasppQcQOMMF6zyaIegNIsF12KECxqnIMW4dZgRPQL4ZLjotegZCxHqmmTtzzzFMsNln6dUe5Hr1+iKCqgoMXs3z9y2NmtLs4aAl22iL1eblT3cqNitNhBBuOhaA+8YIhiCjcYMaWLYFep7QWbGXHoE9EBECdIMPGD+wtuOz1KR5ufr9D1U8uY1k3pZ7HJ4bQZRED8PnTwdzLPZ7ZJ/hGs7Ti9iJ18Uz0MjALzluV5Gyi5HS2yfzJgvBrTJFsvSKPyR2728ty2cHguOd21NlfUYZ9BIbCKSaWwHMF+7Tb/5Rv6tuo2eFgrrPTAdgU5NBeUTCt8PpAuPUmXZ90Nd+YErIDAHwQWvkV4HNVEVxG+3zGZehNhhaIydoRq3toss4Nv1WfToprpf21j/C6A854BYEdpegPEI3CDPYE6cXJ6pUyuHELASRM4q2RuqB8BmOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(107886003)(2906002)(110136005)(64756008)(508600001)(52536014)(5660300002)(8676002)(66476007)(54906003)(76116006)(7696005)(186003)(83380400001)(55016002)(9686003)(4326008)(7416002)(66946007)(66446008)(8936002)(33656002)(26005)(122000001)(38070700005)(6506007)(316002)(38100700002)(66556008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UCtBYnpsTWFVMUdwTjB4SEpNdjA4VC9OelVtQWxNRFRvZSszMDdCMHJrZjdL?=
 =?utf-8?B?SzhLVytkUFpjMDlRT1NOM3BteFJVNDdmOVY3OUpFYlZyZFp6Y2RCblFTWlZC?=
 =?utf-8?B?ZU11WEM4M3FON0ZlMnRrUXh2ekl6L3dNMlExL2VwTjBBOTdRUWxHdDNjK1VJ?=
 =?utf-8?B?TGJNektJNWJkRklWOVlNUkpnMHFxTFZhQzM2MlptZGJZdnl3SWE3RldwazdS?=
 =?utf-8?B?ZWtiRVJQOThyNXM3cDJhQS9ObVRjUnJPNUo0VU9nYTRCNVdWTG8yVmdMZlVR?=
 =?utf-8?B?YmtMdWl6R3daU0NocGkrUm5YMit6TU9iWElad1d2N25PZUZhRXh2cHM1djRs?=
 =?utf-8?B?bng3L25CbldNVktZMDNnOGFDd3lveSsycjlTeXFwb3lmeW5qTStNN3BVTlNy?=
 =?utf-8?B?RmRWNURFeVdPREJNUFAvbDA1Z0R2MXVERUZ5UEZETm5PcnFzUXpTM1F2YmFr?=
 =?utf-8?B?bENDZjE4aDZJMkxTVWVBRWQ4Z3ZRWTU3anVOS1AzaWZCdG5zeFdnZ0k4WGRF?=
 =?utf-8?B?WUd3b0dwRG1QNDhPa01icFY1a0oxLzh0djF4YWx5Q1VaUmQvSHpXQWthS2ov?=
 =?utf-8?B?TDk2SlRJYk9EaHpxNVk0dExrWFJnSmpoeHRxcktVeVZNZEdqVmE3Q0ErRVU1?=
 =?utf-8?B?dW1vbk4wM0ZoWXRUZm1kQ0kyckJaNXdZcUIva3FXTWwrTEJhWDBMUC95UUl4?=
 =?utf-8?B?cUtZc2VlWGREZ2ZDUndRVUdQN3VCeUwrNFd1YzhBK1hvZTBFYzhYcEorcGYv?=
 =?utf-8?B?QjdJdzdUVitmaHgwYWRCS3RGK3phOXdrQlBLT0pIaDF3NDVqTTdaNnJta2dV?=
 =?utf-8?B?Qi9YdjFiZmluY2l2bmxCQjFjeTNJZGt4TGRKNVBuMCtONm5mcDl0M2k1MlBz?=
 =?utf-8?B?NWJ6QWxnc3ZrWXZSOFVRcXRPZ1p0ZjRpb29TbWd1cDdXNzVORnhacktWeHVY?=
 =?utf-8?B?RUJwOE5jY2tpQ2RvRHE5cTNSb1VaUGRtVVptN0x5L3puRklhMFRndlhzVjJy?=
 =?utf-8?B?MHdsdHJNRnViY3BVZ05DeStIVWZNQ3NPU3BKWFBncFBob3dva3g2MjZRZWhK?=
 =?utf-8?B?NmhOSGU1R1hOeEVucWhFQkt0Si80aTZrcDJzQ09IUjY1Szg3cU16aHZ2K05w?=
 =?utf-8?B?OUN2OHVpWnBjTXZwSFhjeDVhOWJyWVVMSGFtckV4NTJ0cFdYWXR4WWFLWmN0?=
 =?utf-8?B?eSt0citNMVJuYXliWk1BaU0ya0REKzR4aDUvQlF3K0RRZUJkaTNCdEZCTUp1?=
 =?utf-8?B?QUpseCtORlNDaG9aSllPcjdMSUFSRDlxeFozK0tFOCtuaVd3ejdEalJLclRO?=
 =?utf-8?B?MnV0T2w1RlBwdk54S2FDdTZPRkVLNjdsZm1KNEhiamVNZVFGVGZ0bVE5Ymcv?=
 =?utf-8?B?VTllWjUxUGFyNXRJSkVpc1VNSHJaVHozbGdrNm9BdzdBUzdqWEdWSUxycGN2?=
 =?utf-8?B?NVdla1pGVHVBOVdMUk91OHorTkFFWmNJanpjK0tEOHlZSE5ucFp2dnlLUGZu?=
 =?utf-8?B?U2Y1SW9lanFPalRCdlRyVkpPdTNnRlA0L0FEdEloWk1HZTY2RWw0UGNGSEZu?=
 =?utf-8?B?dzByTk0rREpDRFdOaEtKNklub3BOczFBUlBnNkxaVEloNUlrbTlnWFNUcXZV?=
 =?utf-8?B?aDFyNW1FODBHOEFsaC93bU5qNVlSN0JvRlYvb2tYK3FuTWx3Z1kzakVNWkJw?=
 =?utf-8?B?enRCcnFZNVhLeUxuM1oyczRyRkhDQ1RLa2M0MXlkZEVYUDNBY1FnN2h0Sk5G?=
 =?utf-8?Q?Lr7u0mI1Pw+w2l5uxQvwX6VEBnRXNWhF8KUhbDj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70f810b6-5075-467a-c212-08d982fd5069
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 03:57:53.5925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Ok2L3qZotmFrmrfzyLpfU2RzaLACkT8uASykAtmKKD9p5aThfbNkKOIbE6v+urDim/SMg4BJs9k+zVedKx4Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2289
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGksIFNoYW1lZXIsDQoNCj4gRnJvbTogU2hhbWVlciBLb2xvdGh1bSA8c2hhbWVlcmFsaS5rb2xv
dGh1bS50aG9kaUBodWF3ZWkuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJlciAxNSwg
MjAyMSA1OjUxIFBNDQo+IA0KPiBIaSwNCj4gDQo+IFRoYW5rcyB0byB0aGUgaW50cm9kdWN0aW9u
IG9mIHZmaW9fcGNpX2NvcmUgc3Vic3lzdGVtIGZyYW1ld29ya1swXSwNCj4gbm93IGl0IGlzIHBv
c3NpYmxlIHRvIHByb3ZpZGUgdmVuZG9yIHNwZWNpZmljIGZ1bmN0aW9uYWxpdHkgdG8NCj4gdmZp
byBwY2kgZGV2aWNlcy4gVGhpcyBzZXJpZXMgYXR0ZW1wdHMgdG8gYWRkIHZmaW8gbGl2ZSBtaWdy
YXRpb24NCj4gc3VwcG9ydCBmb3IgSGlTaWxpY29uIEFDQyBWRiBkZXZpY2VzIGJhc2VkIG9uIHRo
ZSBuZXcgZnJhbWV3b3JrLg0KPiANCj4gSGlTaWxpY29uIEFDQyBWRiBkZXZpY2UgTU1JTyBzcGFj
ZSBpbmNsdWRlcyBib3RoIHRoZSBmdW5jdGlvbmFsDQo+IHJlZ2lzdGVyIHNwYWNlIGFuZCBtaWdy
YXRpb24gY29udHJvbCByZWdpc3RlciBzcGFjZS4gQXMgZGlzY3Vzc2VkDQo+IGluIFJGQ3YxWzFd
LCB0aGlzIG1heSBjcmVhdGUgc2VjdXJpdHkgaXNzdWVzIGFzIHRoZXNlIHJlZ2lvbnMgZ2V0DQo+
IHNoYXJlZCBiZXR3ZWVuIHRoZSBHdWVzdCBkcml2ZXIgYW5kIHRoZSBtaWdyYXRpb24gZHJpdmVy
Lg0KPiBCYXNlZCBvbiB0aGUgZmVlZGJhY2ssIHdlIHRyaWVkIHRvIGFkZHJlc3MgdGhvc2UgY29u
Y2VybnMgaW4NCj4gdGhpcyB2ZXJzaW9uLg0KDQpUaGlzIHNlcmllcyBkb2Vzbid0IG1lbnRpb24g
YW55dGhpbmcgcmVsYXRlZCB0byBkaXJ0eSBwYWdlIHRyYWNraW5nLiANCkFyZSB5b3UgcmVseSBv
biBLZXFpYW4ncyBzZXJpZXMgZm9yIHV0aWxpemluZyBoYXJkd2FyZSBpb21tdSBkaXJ0eQ0KYml0
IChlLmcuIFNNTVUgSFRUVSk/IElmIG5vdCwgc3VwcG9zZSBzb21lIHNvZnR3YXJlIHRyaWNrIGlz
IHN0aWxsDQpyZXF1aXJlZCBlLmcuIGJ5IGR5bmFtaWNhbGx5IG1lZGlhdGluZyBndWVzdC1zdWJt
aXR0ZWQgZGVzY3JpcHRvcnMNCnRvIGNvbXBvc2UgdGhlIGRpcnR5IHBhZ2UgaW5mb3JtYXRpb24g
aW4gdGhlIG1pZ3JhdGlvbiBwaGFzZS4uLg0KDQpUaGFua3MNCktldmluDQo=
