Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1AD3989D9
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 14:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhFBMnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 08:43:43 -0400
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:31567
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229850AbhFBMnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 08:43:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGFR6iCrp/SasabG+JiVnzqMlxY0FXLpfsiTIr72D1QTtLHT2EO7Mk1CEcO+g/UURC3eQUcYC5OWLKcYT7+rCGHHvYXOQ9WNA8Fp9Zd082EQQzICMlSsrr8WRK6B/G53WEpvDBNHQvbr8/m5cppXDKjMswybH3nsHMifRMGNDRIcu3nF4Qeau5LdiUwLHgZQZ2Ah77wXiT39oVxnpdV/SqZVP8gboq+LFK+ejpgg+WDRzvNes7B6A6lwMzd/+j0V4tKFrBGbKnyBJ9/Smozfr+yXlUmh7gtUHSZDOoPqKoYsnz0wVcqYrNQdeUNlyIdFAWRRjsLq6JrFmX764/tCAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MURESkbkVTCGUX5fWbhTmrfUQm4bFedTrJN/uKtGY8c=;
 b=mxKH9mfspfII3T5olrl666N6WgYjeqxWSeefiqGUHo39yy5Wh/XD8pKI/5KZ7NFztB5H7Mt/TQx8EEXRyfaWqRLNwSrII3WfpHeRI1S9i7XDJB2+ixZGY5uOWbzAAsM90vp4VodPyXXvWBke0HvI1j6mcK+wsHN7gCmFy4DKUWUrHQoVnDuFgATGXZ8rJ8TL1jIeMGtrKi6QhmchjLyqGXS/VsEjEnIiLqUOfVGGhKipxGuHkvNq11woRSuPZBXIK/XofSa8j3nswkEEhakw5my3PMK+dBLOoVcKtqRuwHF0rZCkyRnMjuIkNnBPBqqrT0zs6byX2WoNlIZn7AIQQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MURESkbkVTCGUX5fWbhTmrfUQm4bFedTrJN/uKtGY8c=;
 b=erE6JlAkMw13kKkvCj2CkBOuIFGs699kI7rslvMJWHLzfInKxkd7Wf5JEyBsTlMiK6aOoJU1VlKxS1pX28hIwO9hJPPTPcIn7DG59LTuyZzdbC+SLTUGhpxVre8zshRxwVsTW5x8GrDJ5hls1VgeRqd507gYF+iSvf5t+gzbDcrlCEjDub2L9Gv8xa9GFdtgdKbyiXgEn/SYFAkTpXBrhqVuf0hO++wmikmMPXS855LLijtjQg5A0UZ1PASLMrHCzmASQYWL5Iriw9ahSnoa869+2+Ft0aHQh/ChxU1hX2zrXQ3Gua+AlspFpQanzGpydaAli5KJvAXcKUBh8jn8GA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5401.namprd12.prod.outlook.com (2603:10b6:510:d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 12:41:58 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 12:41:58 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwDdOxjAAFIuqoAACAmcgA==
Date:   Wed, 2 Jun 2021 12:41:58 +0000
Message-ID: <PH0PR12MB5481F4C360C09B8697D3B595DC3D9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <PH0PR12MB5481C1B2249615257A461EEDDC3F9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <06892e6a-02c9-6c25-84eb-6a4b2177b48d@metux.net>
In-Reply-To: <06892e6a-02c9-6c25-84eb-6a4b2177b48d@metux.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: metux.net; dkim=none (message not signed)
 header.d=none;metux.net; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.220.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0f5b561-a867-4257-b96f-08d925c3cfab
x-ms-traffictypediagnostic: PH0PR12MB5401:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB54013215A4558E8D46676639DC3D9@PH0PR12MB5401.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hRSitfUtzrNdEx4ENuwftPZMHBiNBsgp3O5TI9ByCgo1TmQMTeVXGDjhgazM/8cdv+ACR7Wu64uuBs+ykdt5x10QbHO/n4WD4GZ2CxG3Zk/Mu8Vx1G9CsFTnc5AB3zhR2kpAqrSsx8mthB/Vq8wKSu7aTz5iU/CURX+cPYIlBHUiA4PCLSswOwVShoAq8RT6qD+G6OpryAY5QZf2zQT9iWJyrwoqfqol+NlwafEDB9FBfjgeupFgiGmu3r+wQe3wkyxy6FwE1kSnikF96O7EbbtNg/ZWIpK+9qp2a5SzxKUwOf8r9lnIIm3HVr/NaZRZtk9wDb4lwQMVNNhGMYClT/cFjbOfgh4uKD7DnsQt9/Z1lk2MUPO2y9jMHGfde+zj5qQyWXxTkMd0kiKa0fwX6VMUxo9IVwKILW7JNxbY/OPOvDZU1NNMiBUPGVwCkzAqge9p5ksSfUUkc//Q91AcWS+Yya9lK+4goo7swKF24Gbgn4mbCSuwhdyvcG9jYwK4bi0CqbD/AtyQFVbBjUFwmv7vLNxEUwUEoPSKOfjPzPLrtpy8bDMxhiaeruYxN+Hf3E4KoGr0svQbiwp3ZCjtfDIH9+gJuGr1MdBtznorsuE54Qa09p9tNBD4w2FUpW/+DaKd3MiLylh70cwcAOd7Ow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(52536014)(71200400001)(53546011)(54906003)(64756008)(66446008)(110136005)(7696005)(55236004)(4326008)(186003)(9686003)(66946007)(66476007)(26005)(83380400001)(5660300002)(8676002)(7416002)(55016002)(316002)(478600001)(2906002)(76116006)(86362001)(6506007)(33656002)(921005)(122000001)(38100700002)(8936002)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UC9NcFBzcGE0OFRJSmZzc3duWEloYnFzUU80T3h1ZE5sZmE0WnVXblNzOU0v?=
 =?utf-8?B?dXc3N2ZubHBObUVZY0gwVk1UWUw5cEZaaUNlUjZSbFhQeWV6aXR5OFFGZURE?=
 =?utf-8?B?dzJLVVlUZDliaWpxTk5USXhmVWFZRzZRUzRucmxOWFgyV29XZWlocGpxYllr?=
 =?utf-8?B?K3hwTTZqaXpnN2RXekUxMk11bHZxQncxZFNTQWc1enBVWkx0WVlSelR0Qkw2?=
 =?utf-8?B?ZUJldEVVZUxzMTcrSDBTM3R4WDg3Z2hFc0FYc1BiTWVZZmFzTVZ6SWV5MmRn?=
 =?utf-8?B?amNITXlCaXFCL3Bnb213Q0xEaVVyUFdpRCtrZWdLZXpkR05LaUNHb2RkTVVY?=
 =?utf-8?B?RHRVZ2hkTHNUSUFld3BLM3BKZjkxSzBxdU5uUlRCRVhaSCt4RnErOWQzanhh?=
 =?utf-8?B?MTN2RkJSVTNyV080M01RWFBiRnhoaWd5Y3cvMklKYmFjcUpDMEw5UnozZTRI?=
 =?utf-8?B?dk05TFFoOEVOWW1jM1lUOVo4b3JScStURndNOHlnWWdtTncxWktGeXpEQnJq?=
 =?utf-8?B?WnZvTnY5TGtpcWx5R2g3TW1vT095NXl6VEF6Zk9wVWhPWDdIM0pucnpDdVlh?=
 =?utf-8?B?UmkyZ3UyR1BtUmgrU0lNVWp3aU1IdGc5c3lRT2ZjOFRkV2hKRUlrZldZM0V2?=
 =?utf-8?B?eCtpeHNuQWZOVkJJaWg5aER3aXhsczZGYlJBcTZKRkN5YktHRVJ0UURZM2Q2?=
 =?utf-8?B?enBzakZjaU04YUwxNHlqbG8vUWRQUkg3N1lyMVFiVWRBdDE1VW5HRUxZMjBv?=
 =?utf-8?B?TktqS1k4ckUrYzg1WFpMMlM0cVozVmxwb0RDd2NHUG8rVVhGd0NLTExhT0Ft?=
 =?utf-8?B?YzhRWDc0bEhXZmt3RFhnZ1pRci9sRGdOSnh6U0VBL293RVhFcTVlVDFsblVE?=
 =?utf-8?B?M0pPRk1VZ2k0cDJnVkI0aTNjL3RZaHhzWlhvVUp0eVpOby84eFQ1QUdCL1lr?=
 =?utf-8?B?ZkR2WjVDNUs4QVMvMWlqNDN2MnpzT1ZjOXhwZXBPcW1RMDF1a0ZxOTNMenpa?=
 =?utf-8?B?alJYemllNzRObExJNFE0SzY2TkY0MWlxSjFlbDIvUXMrOUxIeFhsSWFpQys2?=
 =?utf-8?B?R1JIUXBxMHN1dlhmNWxlbURBVXBJSUgyd1pCckt0bnh0R0Q2YlQxNDFnYnNN?=
 =?utf-8?B?MEdERnFxTENXSzlLRml2Tk11ayt4ZzI1a3VkQnpCQzFjTEVXdnNNQTdqQy9h?=
 =?utf-8?B?MkFxeGhwVXZ2Rm5FVmJsSk1LTlhySXZhNGREUElJaWNHZSsyaHZvRWtINmt6?=
 =?utf-8?B?bzc4d0Z3RmMvMVZFdC82RC9HS3I1US9BOXNpdjVUVWpBRjEybGlXazBlbE9a?=
 =?utf-8?B?K1NhQnRWczNaV3NyaUt1MHNadXl3K01sWTJOdCs0TFJaMWpXMmh3MVpQRmJD?=
 =?utf-8?B?STVQa3BadVRhMFhKQVpsTWh4MXNCVGw2NndnbU5DRUpuTGRPckQxMWxacHhv?=
 =?utf-8?B?K01MV3ZGaWxycG5rbGIvQUg2N1dZUk1BTVZ6L1VyK3BNcDlGL21qQlpHV0Jn?=
 =?utf-8?B?L0NwQUN2b3hBVWNpSDdNM1E4cERTN3hEeElkK1dYeUhobDRLSVhBL2xKZm8v?=
 =?utf-8?B?QklNWWZjVWJPR2VWajdaZmNkamFRa3FEakZIRllEM1I3ampFZ1lORnQzM0tm?=
 =?utf-8?B?Ym5CbS9Ra2xBN3R1dlozcXBTY0VhNjQzbWFPaUoxbzR2NzRFK3hyVmVKTTBy?=
 =?utf-8?B?VTY2L0dBRXpVT1M2ZVJON1dTK1c0Q014dUxtMjZOTlVPcjBqNndoUXhwRHEy?=
 =?utf-8?Q?z18fMXUTGjR4b+GAsZCPstvbF7co3cfqllv52Qp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f5b561-a867-4257-b96f-08d925c3cfab
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 12:41:58.0692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pPnDCtRf0V+l8kUUG5lRe08kni/t3Bih6Y2+lg+CcjhjeWZaw7x6U1R1gylBz49GpdIYhNvqP51B/O0TIBab9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5401
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IEZyb206IEVucmljbyBXZWlnZWx0LCBtZXR1eCBJVCBjb25zdWx0IDxsa21sQG1ldHV4Lm5l
dD4NCj4gU2VudDogV2VkbmVzZGF5LCBKdW5lIDIsIDIwMjEgMjowOSBQTQ0KPiANCj4gT24gMzEu
MDUuMjEgMTk6MzcsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gDQo+ID4gSXQgYXBwZWFycyB0aGF0
IHRoaXMgaXMgb25seSB0byBtYWtlIG1hcCBpb2N0bCBmYXN0ZXIgYXBhcnQgZnJvbSBhY2NvdW50
aW5nLg0KPiA+IEl0IGRvZXNuJ3QgaGF2ZSBhbnkgaW9hc2lkIGhhbmRsZSBpbnB1dCBlaXRoZXIu
DQo+ID4NCj4gPiBJbiB0aGF0IGNhc2UsIGNhbiBpdCBiZSBhIG5ldyBzeXN0ZW0gY2FsbD8gV2h5
IGRvZXMgaXQgaGF2ZSB0byBiZSB1bmRlcg0KPiAvZGV2L2lvYXNpZD8NCj4gPiBGb3IgZXhhbXBs
ZSBmZXcgeWVhcnMgYmFjayBzdWNoIHN5c3RlbSBjYWxsIG1waW4oKSB0aG91Z2h0IHdhcyBwcm9w
b3NlZA0KPiBpbiBbMV0uDQo+IA0KPiBJJ20gdmVyeSByZWx1Y3RhbnQgdG8gbW9yZSBzeXNjYWxs
IGluZmxhdGlvbi4gV2UgYWxyZWFkeSBoYXZlIGxvdHMgb2Ygc3lzY2FsbHMNCj4gdGhhdCBjb3Vs
ZCBoYXZlIGJlZW4gZWFzaWx5IGRvbmUgdmlhIGRldmljZXMgb3IgZmlsZXN5c3RlbXMgKHllcywg
c29tZSBvZg0KPiB0aGVtIGFyZSBqdXN0IG9sZCBVbml4IHJlbGljcykuDQo+IA0KPiBTeXNjYWxs
cyBkb24ndCBwbGF5IHdlbGwgdy8gbW9kdWxlcywgY29udGFpbmVycywgZGlzdHJpYnV0ZWQgc3lz
dGVtcywgZXRjLCBhbmQNCj4gbmVlZCBleHRyYSBsb3ctbGV2ZWwgY29kZSBmb3IgbW9zdCBub24t
QyBsYW5ndWFnZXMgKGVnLg0KPiBzY3JpcHRpbmcgbGFuZ3VhZ2VzKS4NCg0KTGlrZWx5LCBidXQg
YXMgcGVyIG15IHVuZGVyc3RhbmRpbmcsIHRoaXMgaW9jdGwoKSBpcyBhIHdyYXBwZXIgdG8gZGV2
aWNlIGFnbm9zdGljIGNvZGUgYXMsDQoNCiB7DQogICBhdG9taWNfaW5jKG1tLT5waW5uZWRfdm0p
Ow0KICAgcGluX3VzZXJfcGFnZXMoKTsNCn0NCg0KQW5kIG1tIG11c3QgZ290IHRvIGhvbGQgdGhl
IHJlZmVyZW5jZSB0byBpdCwgc28gdGhhdCB0aGVzZSBwYWdlcyBjYW5ub3QgYmUgbXVubWFwKCkg
b3IgZnJlZWQuDQoNCkFuZCBzZWNvbmQgcmVhc29uIEkgdGhpbmsgKEkgY291bGQgYmUgd3Jvbmcp
IGlzIHRoYXQsIHNlY29uZCBsZXZlbCBwYWdlIHRhYmxlIGZvciBhIFBBU0lELCBzaG91bGQgYmUg
c2FtZSBhcyB3aGF0IHByb2Nlc3MgQ1IzIGhhcyB1c2VkLg0KRXNzZW50aWFsbHkgaW9tbXUgcGFn
ZSB0YWJsZSBhbmQgbW11IHBhZ2UgdGFibGUgc2hvdWxkIGJlIHBvaW50aW5nIHRvIHNhbWUgcGFn
ZSB0YWJsZSBlbnRyeS4NCklmIHRoZXkgYXJlIGRpZmZlcmVudCwgdGhhbiBldmVuIGlmIHRoZSBn
dWVzdCBDUFUgaGFzIGFjY2Vzc2VkIHRoZSBwYWdlcywgZGV2aWNlIGFjY2VzcyB2aWEgSU9NTVUg
d2lsbCByZXN1bHQgaW4gYW4gZXhwZW5zaXZlIHBhZ2UgZmF1bHRzLg0KDQpTbyBhc3N1bWluZyBi
b3RoIGNyMyBhbmQgcGFzaWQgdGFibGUgZW50cnkgcG9pbnRzIHRvIHNhbWUgcGFnZSB0YWJsZSwg
SSBmYWlsIHRvIHVuZGVyc3RhbmQgZm9yIHRoZSBuZWVkIG9mIGV4dHJhIHJlZmNvdW50IGFuZCBo
ZW5jZSBkcml2ZXIgc3BlY2lmaWMgaW9jdGwoKS4NClRob3VnaCBJIGRvIG5vdCBoYXZlIHN0cm9u
ZyBvYmplY3Rpb24gdG8gdGhlIGlvY3RsKCkuIEJ1dCB3YW50IHRvIGtub3cgd2hhdCBpdCB3aWxs
IGFuZCB3aWxsX25vdCBkby4NCklvIHVyaW5nIGZzIGhhcyBzaW1pbGFyIGlvY3RsKCkgZG9pbmcg
aW9fc3FlX2J1ZmZlcl9yZWdpc3RlcigpLCBwaW5uaW5nIHRoZSBtZW1vcnkuDQo=
