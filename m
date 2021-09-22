Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F9E414BB0
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhIVOVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:21:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:3280 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235464AbhIVOVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 10:21:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="210840411"
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="210840411"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 07:19:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="704037584"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga005.fm.intel.com with ESMTP; 22 Sep 2021 07:19:29 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 07:19:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 07:19:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 07:19:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgdjQAXtmDkF2aBTyDjkPF4LE7yiJNvIYSGBCSo+F0YOKxF4hvStt5RtQlxBTzuifkeAdouW8b06ZGeDY6uArpm8uzKMXI7ayE3e9MS374FMnJMVNu7Wg4De16NTKXj6dlHaVDlt5bfxdImUvb/8KYKCZDqcuB/vPR0o5T6H7t/J8OJ/feexmn4R3yQGmjn/5GXnzTChLXZFWfcXsq570JURmYdEgXzj82dItpZ62WyK6HqVgK7CzRzvL/rft7Sdl+cDpTVcRkl9MuO+BCzIy1eSz50oBXP6FXWsgT6uzxPghPx+xQU83/v5mHl/QKSO0OJ8Hw0pRDrf4Zjb+zFBlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Xs4+swah/TZCb8HpXn0pepAvTQc1UQHR6J1l7LNusGo=;
 b=bSoGkZPnyI17I3WNpTAOlAopXe6mOy9URqM4S1oy75JNsiXBj9rGP22wAtRhVHBTeKKhu1n2Bop/gDZHSxSStg8vgUfi/0ed3CvO3QU1PNNcDviNPrGWG2qjh5XoJRGj1zQVuXOXmyQzPIQV1emQHHuYkLWrsZeXsq2Tiupe6HaTHoL0u6FGLCV0vWsMbl5NJ1DkMmeyu0vtC33f27VgKeT1MblRfnqMhMdJrTxt4ulDO6sfOGy7lENnpaQg0K3e+3+oOuJsfXLmQYj5MqE6g/dAAsIti0COkU7aRaCUe8ycJHNoZk6OnDAp4jknXdvCdNd93Bs6UQmNJZuBgAHaOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xs4+swah/TZCb8HpXn0pepAvTQc1UQHR6J1l7LNusGo=;
 b=C6b9DdJdDtzNYILWpv+0gwOf6PDTTU5HtEm/VloaaV9efWr7f1BbStSEOu0YyOD1tDo2QWDHfOEqYplnf5/d0Ew5mqcvhLx2jHLzxoNkviRrwdzOII7+/qA+8IZhkjgWoo/I8CJC3zA1vkdoo3cpKml4myuCUDuYfOfBI2+BJgc=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5466.namprd11.prod.outlook.com (2603:10b6:408:11f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 14:19:15 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.014; Wed, 22 Sep 2021
 14:19:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
CC:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 09/20] iommu: Add page size and address width attributes
Thread-Topic: [RFC 09/20] iommu: Add page size and address width attributes
Thread-Index: AQHXrSGKjhCHWEBJVkuehiEMDf/SwKuwFTuAgAAJ5EA=
Date:   Wed, 22 Sep 2021 14:19:14 +0000
Message-ID: <BN9PR11MB5433D82D6630A87E8BD464AB8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-10-yi.l.liu@intel.com>
 <e158380d-cb13-c1aa-6dd6-77032fe72106@redhat.com>
In-Reply-To: <e158380d-cb13-c1aa-6dd6-77032fe72106@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5b212ec-3e86-4205-81ce-08d97dd3f4f5
x-ms-traffictypediagnostic: BN9PR11MB5466:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB546654FA92687830350BD5608CA29@BN9PR11MB5466.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6PUQmUy9C9hSCMPLxoXN53OQMyJdmJNdP27Xeb3jVZA/hIHgjYV20Cba4Mxssr/AFXpfmKRIisHw2B7HwG9v+6VDSMN31m+bIo2drqRHGdziey2OV894fxR+z/w22ymE9345lRJ28a8ISbZzctAsBgKsgqrZoRdlDXzq+Pi9jKTBjjfeqDOyHcrH31YQVexbZHlUobIXg8nv9SIeK0GUgcRdU/0NY0ppIEcOpQe/SYheDp6PFZfpRKW5Dqvpq4wBKCtxmA6IjzDOpZab9297mJYzKOBHM3NUwFKfQTBrQ1ur2+AjvcFsmHr6dRuVzqqpw4FPsFMTBZ3Dej8d4tJ0AdvT6NacSEo4fq0AqKrUkfOyxWM7P0XJVvbuudsQcPr+DoM9eFZUIUhPo2GmjmczOIjdSVBtJ8GEbK9LSsR/p7iCamO2Q1PbhpsFvD0yIavwW+vfrQxc1NAQgNQM5/ctuCj82zx7uT0VR4i9R3TL0c6D077bPl+t0Dd1MzF7ps0c8LmdUFXifTfCXIcttA1He5fc18tW1YZPoyhvPteoVtYHhuFquW0buDm5J7w6L8mklY1LZRuC6dpX9B9/daw6vLQaR84SNyn3IXneIH5Z8cJnMQpPgcCIrZIdfwxxYDLdmkv6zhJRpq0Uj2lt9lID8+/KKAmLcbCsyROdUmE6o3B5ph4Gkuo1pJww066I+LSM7yQVd38SQP1lDLKNyei2DA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(55016002)(6506007)(508600001)(316002)(4326008)(2906002)(8676002)(53546011)(38100700002)(52536014)(9686003)(38070700005)(64756008)(66446008)(66556008)(5660300002)(7416002)(66946007)(66476007)(186003)(122000001)(33656002)(7696005)(71200400001)(110136005)(54906003)(8936002)(26005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVFqeDhOT3ZqRmhzdHpRZXptQlEzWGVvTDNKc2QvajFFT0FmN25JMHdLcTUw?=
 =?utf-8?B?ZmVoN3ViWlo2dktEcmV3dnJmb0dQYXhrOVpKOGJnaXNPWEFVMEQweDNGQitE?=
 =?utf-8?B?SjNNZENWSHV5N1FNUXNZM3JEYTNJcGttaUt4MjJVMjVxMENyZFd3UHp5TjNw?=
 =?utf-8?B?cVVLd2N0anhISnVxeHlkaEZUdEZPRm9vNHhoalphR2F2QjBDV2FmQVNjejFJ?=
 =?utf-8?B?UlVLRmVJdGJVTGdtaWE0bVpqd1B1Wkg2cEFYemxScFoxeStBZndQU3F2NENx?=
 =?utf-8?B?VjZrelhtK09yaFBkZTBlYnBlWVNuSEhURlV6VmJ5MDNrR3dHYngrczNPQUoy?=
 =?utf-8?B?cngyUzZKQTk1alpqSW84YThDbkpoSHJrakgvZmNiMlRxRjUzQTlJbjVTdGdC?=
 =?utf-8?B?M2M5L2wvbkh6U2FOb0k3cldld3k3MVZ0N1lMM1N4SVQ1c3hNMWFZQTRjeUM0?=
 =?utf-8?B?ZXZGODl2ZlpnZTVkZnhKaFQ5N0dlcmkvQllJMFZ5dTdJRnZzbFkwZ2U1VkZY?=
 =?utf-8?B?ZDhuUzY5SnJNcldFc1p0cXV6YVZvQ0FLcGhjNGVqVERQSkI1b3N1RmpMVU9R?=
 =?utf-8?B?THNVeklMVEExeXZQYWtUUjRPd0gxU2dFaGxMc0FRQVIyN0szeVJ4dHlBdVh3?=
 =?utf-8?B?SXlQdzYyNE1ITXdtY0tEMlNsbjFQdGlXK0Q5N25uK3cwRERlWkpWTC9WcDN3?=
 =?utf-8?B?OUJudHdzL2g0ZGlNMmt0NCtvZThOUUxyNk4vN0s0V0lZQ3pxZkpmVWROWFA3?=
 =?utf-8?B?UlI2b2NuQmZNOG9HcmJEWmx3THRwV25Ebnd5NWc0VStPU1lpNzFnbjZERGFN?=
 =?utf-8?B?dFJkeDFTbjUwaFdscTJabDVuRWZKM21rMURZcWRFalcrS1hsRUxWdU9wR0R6?=
 =?utf-8?B?Y0htTEw3ZVFjR0xPVFU1d0x1anBNbElpcDJVLzRKVXNLYTk4SGhveXVtTE5L?=
 =?utf-8?B?UWwxQ1lsQVZHWUkrMzVmYjhKa2REQVhiZWJMdm5EZW9zK1ZvM0M4TE9SR2VQ?=
 =?utf-8?B?b0tCRjZrbVpPeTZ4d0diTzB5eUZ3RGJsdlZPbXRlby9mV1hJeFR0U1d6Q0Q1?=
 =?utf-8?B?OUVLWDJWMFlKSWd3T3R2amJGWG95cis1MXE0NUlwTDVkMVdhWXR3OXQveisr?=
 =?utf-8?B?OUFUVnZkcWdNZCsvSEhtL25UYU1HeDJRUm9UNjJIMDM3dmIrMXB1akVtQTcz?=
 =?utf-8?B?cHFJUHhnQXBIdThRc3YrSEJqM3BkKzd3RWNiVnpnbFhZUEVPV2hLanRDYllx?=
 =?utf-8?B?ZW5CZ1BnRlFrTms5eFU4VEN0ZktGRUpBSXBRdjIyUjU0a3p2amVuUlZuTTBY?=
 =?utf-8?B?ZDcwQUtsbTgwRlNzNVU3NlNRZzZGSGcvM01OYjk3eDBueWJWU3NXbTdqOTI5?=
 =?utf-8?B?VC9aVjc1UUZnOTBjSDlJYjVxMUpRck9DdlB3bDNTbDg3NGkvS2R6cnFLQkIz?=
 =?utf-8?B?cHZSaTdlNUsyaEI3SGVxTFNBNCtlVkswZURvOVRYdGRQb3JtY2N6d3M4T3dx?=
 =?utf-8?B?QU1hbFp6YkFnVDdNNisvK3VrY2RIVWVYeVVPK04rVHFTd3FsK085OS8wRThm?=
 =?utf-8?B?M1JZM2lKdlVoZFJrbGw2VXBUZ2h2SzFoNjBDREo4dGhXZnl3akl0Y2FTY0x4?=
 =?utf-8?B?cWpPcEtmeFk0Rmg1b0JuMFVhc1FSd1VjRC9FR0xCT21aT1ZWMnpXbHdXMW5k?=
 =?utf-8?B?OGovMmZKaHlZRnVlaXZ4TnRpSm1GTndpRHZSVDc4RkgrQnQvd2pUVE9UQXBH?=
 =?utf-8?Q?zCVL2Elwb3vrNXTMnX1HUAdN9IUjkcvEq+8D/Rb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b212ec-3e86-4205-81ce-08d97dd3f4f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 14:19:14.9006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k0W8ahwF0IHZYdhHt+LYkrCPB/X9DK05BB+Cuo0E0C/ZKeyveHqqwch3g6NbOpYDPaN+1ufUaL182lteWWE4KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5466
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgU2VwdGVtYmVyIDIyLCAyMDIxIDk6NDMgUE0NCj4gDQo+IEhpLA0KPiANCj4gT24gOS8x
OS8yMSA4OjM4IEFNLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBGcm9tOiBMdSBCYW9sdSA8YmFvbHUu
bHVAbGludXguaW50ZWwuY29tPg0KPiA+DQo+ID4gVGhpcyBleHBvc2VzIFBBR0VfU0laRSBhbmQg
QUREUl9XSURUSCBhdHRyaWJ1dGVzLiBUaGUgaW9tbXVmZCBjb3VsZA0KPiB1c2UNCj4gPiB0aGVt
IHRvIGRlZmluZSB0aGUgSU9BUy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEx1IEJhb2x1IDxi
YW9sdS5sdUBsaW51eC5pbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGluY2x1ZGUvbGludXgvaW9t
bXUuaCB8IDQgKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9pb21tdS5oIGIvaW5jbHVkZS9saW51eC9p
b21tdS5oDQo+ID4gaW5kZXggOTQzZGU2ODk3ZjU2Li44NmQzNGU0Y2UwNWUgMTAwNjQ0DQo+ID4g
LS0tIGEvaW5jbHVkZS9saW51eC9pb21tdS5oDQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC9pb21t
dS5oDQo+ID4gQEAgLTE1Myw5ICsxNTMsMTMgQEAgZW51bSBpb21tdV9kZXZfZmVhdHVyZXMgew0K
PiA+ICAvKioNCj4gPiAgICogZW51bSBpb21tdV9kZXZhdHRyIC0gUGVyIGRldmljZSBJT01NVSBh
dHRyaWJ1dGVzDQo+ID4gICAqIEBJT01NVV9ERVZfSU5GT19GT1JDRV9TTk9PUCBbYm9vbF06IElP
TU1VIGNhbiBmb3JjZSBETUEgdG8NCj4gYmUgc25vb3BlZC4NCj4gPiArICogQElPTU1VX0RFVl9J
TkZPX1BBR0VfU0laRSBbdTY0XTogUGFnZSBzaXplcyB0aGF0IGlvbW11DQo+IHN1cHBvcnRzLg0K
PiA+ICsgKiBASU9NTVVfREVWX0lORk9fQUREUl9XSURUSCBbdTMyXTogQWRkcmVzcyB3aWR0aCBz
dXBwb3J0ZWQuDQo+IEkgdGhpbmsgdGhpcyBkZXNlcnZlcyBhZGRpdGlvbmFsIGluZm8uIFdoYXQg
YWRkcmVzcyB3aWR0aCBkbyB3ZSB0YWxrDQo+IGFib3V0LCBpbnB1dCwgb3V0cHV0LCB3aGF0IHN0
YWdlIGlmIHRoZSBJT01NVSBkb2VzIHN1cHBvcnQgbXVsdGlwbGUgc3RhZ2VzDQo+IA0KDQppdCBk
ZXNjcmliZXMgdGhlIGFkZHJlc3Mgc3BhY2Ugd2lkdGgsIHRodXMgaXMgYWJvdXQgaW5wdXQuDQoN
CndoZW4gbXVsdGlwbGUgc3RhZ2VzIGFyZSBzdXBwb3J0ZWQsIGVhY2ggc3RhZ2UgaXMgcmVwcmVz
ZW50ZWQgYnkgYSBzZXBhcmF0ZQ0KaW9hc2lkLCBlYWNoIHdpdGggaXRzIG93biBhZGRyX3dpZHRo
DQo=
