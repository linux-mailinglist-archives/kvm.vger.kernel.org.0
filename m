Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A204C3722D9
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 00:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhECWEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 18:04:55 -0400
Received: from mail-dm6nam10on2057.outbound.protection.outlook.com ([40.107.93.57]:28544
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229497AbhECWEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 18:04:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGNlpdNn5NvO/tckxnl+MfRnmqFkRtgb8yP0X1z6jTeAVZ6uCFq5SUi/ygtQrW072HbZVAMhAjBz2gC0HccLxy8sn0fQ77vmL5mkypeBMm8okLu4w6RiCMlfurjIDQU4ZQ4XzFE8+dQd4CeH1C3SAiXt0yNbxQJ7KneMgGUm+uBEPKP6I9mJdbKXeDajECtYuDJhrcrOg6mvN3eV0iL+hFoTn5Tr6illpfG79EWyj48a/nkJxXG3bMM/tmvP/7mFt+ICFCXzDNmbVmfGSLvbECLxnb5MWm69ThIO2aWHIUXc6Lq6DhsPmH8i2Wyi+SXgEjA6BA2CgnZZhbWPuVwNpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zieIDeVeywsW59op/yz6AwWPSaaZTevG73UMdx3SlM=;
 b=dUyRER8kgHAVyx+TzPdaoICvHYYPQAqEoQ0Ol4J7ZRZ8UxeIrq/0r6jTZXhdqguLW0qfyVEHV2TsKteoT+IkSoVAbHeypUoPltvbXH2PmVOlpYxHmlOAqFuUzUU2a5OIvfurtIs5Z8ayjAoOTnY3Xa/ALuidwdZSCKH9ijovEnz4jyzUzwJoeAvf+JQTKgNm+3Zs1Wgw/foekxtbpod8TjlNc6XdXlK4sz5WDPJazwmSRHayL+3sDtapcv7aU+6ZgJes3VgHZUZKfUVG5l2Wy7bZRPWhUQu/r8ouHRakyHI0YUeAuu3HZjq8MCmyBq5VUGphVZafwf1Fu8Zuq8rlrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zieIDeVeywsW59op/yz6AwWPSaaZTevG73UMdx3SlM=;
 b=eCeWsCJdqa1f5QoXez0eHgiUX3slFccuhrAYgG9qYUgJ76zGS6d6lO9KVmBU9NXAusPHlaRTZFfsjSYg1/RwzhFEDoqzT4U6tfWPYTlR1v1j632lRwc4v4i9fRTjNj7d9ratz9wzJOpVp5/ht4a75Ts7euJefcJq+NDOakci7NRG4j+Kj6a/NpNFBIhlBIMVZ6tXKoFU+gFSRUXiCvfRlOWEuXWws4nQJEd1n8iXsbT2gHwGcTj+7H7HwJBJn2WTR7YhLlnkeAlCtDiudry5JywtHY87VfhczbDu/CXi6AvGXfdFaM7IaQ+igXRibICM9hHt7/cFrHMLP/lEx6r+Pw==
Received: from BL0PR12MB2532.namprd12.prod.outlook.com (2603:10b6:207:4a::20)
 by MN2PR12MB3805.namprd12.prod.outlook.com (2603:10b6:208:15a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Mon, 3 May
 2021 22:03:59 +0000
Received: from BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f]) by BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f%5]) with mapi id 15.20.4087.044; Mon, 3 May 2021
 22:03:59 +0000
From:   Vikram Sethi <vsethi@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Mark Kettenis <mark.kettenis@xs4all.nl>,
        Marc Zyngier <maz@kernel.org>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Sequeira <jsequeira@nvidia.com>
Subject: RE: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Thread-Topic: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Thread-Index: AQHXPRTigOHff2apwEeawQns3nBPOqrL0MoAgAAM5gCAAAj7gIABBh4AgAAGT4CAADU7AIAACSoAgAABt+CAASvZAIACHFDwgAEVfYCAADdZj4AAAavQgAARoACAAHZfsA==
Date:   Mon, 3 May 2021 22:03:59 +0000
Message-ID: <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
        <20210429162906.32742-2-sdonthineni@nvidia.com>
        <20210429122840.4f98f78e@redhat.com>
        <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
        <20210429134659.321a5c3c@redhat.com>
        <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
        <87czucngdc.wl-maz@kernel.org>
        <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
        <878s4zokll.wl-maz@kernel.org>
        <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
        <87eeeqvm1d.wl-maz@kernel.org>
        <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
        <87bl9sunnw.wl-maz@kernel.org>  <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
        <BL0PR12MB253296086906C4A850EC68E6BD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <20210503084432.75e0126d@x1.home.shazbot.org>
In-Reply-To: <20210503084432.75e0126d@x1.home.shazbot.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [12.97.180.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8968630-f469-4875-7e02-08d90e7f5aa4
x-ms-traffictypediagnostic: MN2PR12MB3805:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB3805BCD5452CD57B4C557456BD5B9@MN2PR12MB3805.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PXG4Q6vtO5in72BBxk0LpIeUIH/7ACiqpocnPJtzSgMkh67LDegl6x2YIvhsXUX1T6o5LrVAK8z1CrlVAR1qL8wI1iXRKYU9aY78dbRgBiv29282syRiTqlvO8KGDI+LHJqSXekCBYIJAQjEqsIuCewrVZbr0Ns0q7d4dpX2HcqkdHgr1JTlbl1U5tvfJmXQ1ikLHC3LRkXdv0zWly9++0cuLOWTpIhWVTbWzphptlA4tQ6RUFDS2Jdz/N5cXTEof/MBTCTHSjWVw6JBqp/8mA0NHeL1ypGULAZkDOHzzfEe00F2wSwTFb5nc9qw/F5A/u+Ht4skqHvze6bf4IP1iekR4b1OEgSzerdV2O/rx01hDuw8fZIqtAeR4BGAPVLzxEXd4ngC70d8RZMP+P/SPq45etkqibUDOPW2brGEMB/O9KK2iNPTLrYN6/XIiGdl3ykxjE0bOwE05EeE/yimm+yTTS3wFMPQKtOIfPESdMBM+OR+Wdtpqn9+8poRKSjU+iFacH4l3wGt1Rg+maQtQajDAWgwTuqEx7vgRllyG6Eo/WHyswIjjRFGica01Fba1zO9r9VPV0n4Qb6Paw5V24PFZJBPF7youkmJPEwM2Jo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2532.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(52536014)(9686003)(55016002)(83380400001)(316002)(33656002)(2906002)(8936002)(6916009)(66556008)(66946007)(4326008)(8676002)(66446008)(76116006)(64756008)(66476007)(7416002)(5660300002)(6506007)(186003)(122000001)(71200400001)(7696005)(478600001)(86362001)(54906003)(107886003)(26005)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TEx5dmw4WmE0dVlQNFhkQVdKRVg0VDN4NE53M1owWGhoamcwQ3RvZkdEMlRY?=
 =?utf-8?B?bXBDSXFJWmFrOGpFYmpadHZaNGZKYzhkc0pUU3RsZUVQdlZ3V2Z2VFJ0bjM5?=
 =?utf-8?B?ZEpad1lSaEo3U3c0UVhQdlJnNFpTRWpXQUFSSGhMcC9KM2FiY3hRNWxpWmJH?=
 =?utf-8?B?a2hTY1IrcjgxcGcxalVpaTl2NlE2UnM4VFFIQytXMDVua21lWDhIY0FJaGpR?=
 =?utf-8?B?ZjZzSU5weVRQZmhha21HVWlXbkJnS2hiOWo1UFJybENYakc4bThCSFE5Nmg2?=
 =?utf-8?B?L2lMY095VndubUJaanV5YmZFdHFQcFNoNndmODBBQnArZ1hsaGovbXFWS2kw?=
 =?utf-8?B?OFUrZWdBd20rRE1NYWFlUFpUYmFEWnJJQUFvTU1sL1MxcTZDajVKeXNGajN4?=
 =?utf-8?B?aG16STAvNHJrUmtTR3pVSUd3dWp6UnBad2R2NHVxSUI1SGdKdjNBZzM4d1RL?=
 =?utf-8?B?Nm9PUThPUWJ1UmpmQ2ZrTjRiQWlsVHNWWm0xM3lBZjFDVDIvdng1N3RXOGIy?=
 =?utf-8?B?cytRZ1F3WFJqZkx1dmJKc2syNW5UTGxxSEgyem84ZFpJN1Y2RDFjbzVZRlho?=
 =?utf-8?B?VHpFbEMrVUhPdHJrWDNuUS9GeGk1OHgrYlJ0QjRqMEp0Y3FpWUF0dlRQRE9H?=
 =?utf-8?B?d1FJdFgvczZKWkg2enFBWVZUdXU3SmR6dU43eG1RUVlBVjg0YXJhMXNiM0lX?=
 =?utf-8?B?cUN3dDlNRjVpMlI2MzFWeW5SN2Q0V25vTVJBQUhnZ1RXRmtIdGFGUE9scUY5?=
 =?utf-8?B?NHRQOXVGZ2FWRE0zdFFCZmpseE9WTE5jbG9xNTBmUEZLVU9NQjQyQ2J1alhy?=
 =?utf-8?B?L290VGJjNnNWN1RvYXBMaXBIYit2d21LQUREZkoyZkxwb2hyWFJxVUd5OVVB?=
 =?utf-8?B?VE1pSFM2enZ3S2J0aU9hZHhmaHdudXRHRkRoYklJTU1VR2FyRS81b1FVM1Ja?=
 =?utf-8?B?MWhPcXQwR0xsRDNEU2xIZURsMmd4ancyT3V1eDRPbXphQ3Bxd3R5V1JqMUxj?=
 =?utf-8?B?akg0MEJJeTF2MWJGc3VMdlBNYjZ4bmpXTDhEZUhXSUF6eXc1VEYwQWo1VHNY?=
 =?utf-8?B?dWNhTWIxMXB0Ty84alJQS215ei9xVWVmSG5FZ3hvTVJIV0JCNms3SkVsclZp?=
 =?utf-8?B?UkxrSXF2U1hMd2Y5TWVaVnFCdFh1M3BRQXptMnRnTTFETzdOM0VMTXpwQXlj?=
 =?utf-8?B?ZFhIaUxObDJwZmsvdVhPaUlGeW4yWXBBVytxMFRWNXQvWTFJSkpFY1JoVGRI?=
 =?utf-8?B?OWRoYmUzTS8xazYxYzZXdUlBaHRkTWtQQi9TOVpaeks4RkhQQVpUcG1Ic0VX?=
 =?utf-8?B?T2dMVUpmbURYazhnSld4TUlNTDNXcnZsbDJwVjBxdTdRaElIL1MzbHRMRkZq?=
 =?utf-8?B?QWcvWEw3UW1mclp5aEkxTmIwc3gvNDZyK29ub05hNEFtNnExL1RMalpNMGp2?=
 =?utf-8?B?Vndad1kzSDlqQU9CQzVNdGlHZlVUemNqVXlOZE11RlVzb082d2JQaHBPYlFw?=
 =?utf-8?B?cTRObWZUZWRGczM0d3Z4U2laenhXTDA2ZFo4ektYRTNGSG50d1ltbWZGR3VO?=
 =?utf-8?B?S3hVRXJaZnRDVHkyVEJwTzB2YkdONUE4RzdyZlpXNittUzZ2Ui9TeVBMNVJN?=
 =?utf-8?B?ais0Y2hpakt2VjRuZTExeUY3d2wzMTQ4MmZyNnNUMlIrZTdabzZBRU43YjZr?=
 =?utf-8?B?OFU5eGxvNG5ncENDTWJLUVp1RjFVV0JVWkJUeC9QM2FDUlBRdzJVV00rZk15?=
 =?utf-8?Q?twUy8aj6blA0f322g4UZBVxPCzikJCR7c8H8joe?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2532.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8968630-f469-4875-7e02-08d90e7f5aa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2021 22:03:59.2351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xz9sRVwE6woAO2juBYfgO2e5T13k2r4w3YZ8t9NuP3zbHdz/xbF5bumBWdDLvUlMqBbLXpDdiLfjkq6tZQl35Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3805
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgQWxleCwNCj4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0
LmNvbT4NCj4gT24gTW9uLCAzIE1heSAyMDIxIDEzOjU5OjQzICswMDAwDQo+IFZpa3JhbSBTZXRo
aSA8dnNldGhpQG52aWRpYS5jb20+IHdyb3RlOg0KPiA+ID4gRnJvbTogTWFyayBLZXR0ZW5pcyA8
bWFyay5rZXR0ZW5pc0B4czRhbGwubmw+DQo+ID4gPiA+IEZyb206IE1hcmMgWnluZ2llciA8bWF6
QGtlcm5lbC5vcmc+DQo+ID4NCj4gPiBzbmlwDQo+ID4gPiA+IElmLCBieSBlbnVtZXJhdGluZyB0
aGUgcHJvcGVydGllcyBvZiBQcmVmZXRjaGFibGUsIHlvdSBjYW4gc2hvdw0KPiA+ID4gPiB0aGF0
IHRoZXkgYXJlIGEgc3RyaWN0IHN1cGVyc2V0IG9mIE5vcm1hbF9OQywgSSdtIG9uIGJvYXJkLiBJ
DQo+ID4gPiA+IGhhdmVuJ3Qgc2VlbiBzdWNoIGFuIGVudW1lcmF0aW9uIHNvIGZhci4NCj4gPiA+
ID4NCj4gPiBzbmlwDQo+ID4gPiA+IFJpZ2h0LCBzbyB3ZSBoYXZlIG1hZGUgYSBzbWFsbCBzdGVw
IGluIHRoZSBkaXJlY3Rpb24gb2YgbWFwcGluZw0KPiA+ID4gPiAicHJlZmV0Y2hhYmxlIiBvbnRv
ICJOb3JtYWxfTkMiLCB0aGFua3MgZm9yIHRoYXQuIFdoYXQgYWJvdXQgYWxsDQo+ID4gPiA+IHRo
ZSBvdGhlciBwcm9wZXJ0aWVzICh1bmFsaWduZWQgYWNjZXNzZXMsIG9yZGVyaW5nLCBnYXRoZXJp
bmcpPw0KPiA+ID4NCj4gPiBSZWdhcmRpbmcgZ2F0aGVyaW5nL3dyaXRlIGNvbWJpbmluZywgdGhh
dCBpcyBhbHNvIGFsbG93ZWQgdG8NCj4gPiBwcmVmZXRjaGFibGUgcGVyIFBDSSBzcGVjDQo+IA0K
PiBBcyBvdGhlcnMgaGF2ZSBzdGF0ZWQsIGdhdGhlci93cml0ZSBjb21iaW5pbmcgaXRzZWxmIGlz
IG5vdCB3ZWxsIGRlZmluZWQuDQo+IA0KPiA+IEZyb20gMS4zLjIuMiBvZiA1LzAgYmFzZSBzcGVj
Og0KPiA+IEEgUENJIEV4cHJlc3MgRW5kcG9pbnQgcmVxdWVzdGluZyBtZW1vcnkgcmVzb3VyY2Vz
IHRocm91Z2ggYSBCQVIgbXVzdA0KPiA+IHNldCB0aGUgQkFSJ3MgUHJlZmV0Y2hhYmxlIGJpdCB1
bmxlc3MgdGhlIHJhbmdlIGNvbnRhaW5zIGxvY2F0aW9ucw0KPiA+IHdpdGggcmVhZCBzaWRlLWVm
ZmVjdHMgb3IgbG9jYXRpb25zIGluIHdoaWNoIHRoZSBGdW5jdGlvbiBkb2VzIG5vdCB0b2xlcmF0
ZQ0KPiB3cml0ZSBtZXJnaW5nLg0KPiANCj4gIndyaXRlIG1lcmdpbmciICBUaGlzIGlzIGEgdmVy
eSBzcGVjaWZpYyB0aGluZywgcGVyIFBDSSAzLjAsIDMuMi42Og0KPiANCj4gICBCeXRlIE1lcmdp
bmcg4oCTIG9jY3VycyB3aGVuIGEgc2VxdWVuY2Ugb2YgaW5kaXZpZHVhbCBtZW1vcnkgd3JpdGVz
DQo+ICAgKGJ5dGVzIG9yIHdvcmRzKSBhcmUgbWVyZ2VkIGludG8gYSBzaW5nbGUgRFdPUkQuDQo+
IA0KPiBUaGUgc2VtYW50aWNzIHN1Z2dlc3QgcXVhZHdvcmQgc3VwcG9ydCBpbiBhZGRpdGlvbiB0
byBkd29yZCwgYnV0IGRvbid0DQo+IHJlcXVpcmUgaXQuICBXcml0ZXMgdG8gYnl0ZXMgd2l0aGlu
IGEgZHdvcmQgY2FuIGJlIG1lcmdlZCwgYnV0IGR1cGxpY2F0ZQ0KPiB3cml0ZXMgY2Fubm90Lg0K
PiANCj4gSXQgc2VlbXMgbGlrZSBhbiBleHRyZW1lbHkgbGliZXJhbCBhcHBsaWNhdGlvbiB0byBz
dWdnZXN0IHRoYXQgdGhpcyBvbmUgd3JpdGUNCj4gc2VtYW50aWMgZW5jb21wYXNzZXMgZnVsbCB3
cml0ZSBjb21iaW5pbmcgc2VtYW50aWNzLCB3aGljaCBpdHNlbGYgaXMgbm90DQo+IGNsZWFybHkg
ZGVmaW5lZC4NCj4NClRhbGtpbmcgdG8gb3VyIFBDSWUgU0lHIHJlcHJlc2VudGF0aXZlLCBQQ0ll
IHN3aXRjaGVzIGFyZSBub3QgYWxsb3dlZCBkbyBhbnkgb2YgdGhlIGJ5dGUNCk1lcmdpbmcvY29t
YmluaW5nIGV0YyBhcyBkZWZpbmVkIGluIHRoZSBQQ0kgc3BlYywgYW5kIHBlciBhIHJhdGhlciBw
b29ybHkNCndvcmRlZCBJbXBsZW1lbnRhdGlvbiBub3RlIGluIHRoZSBzcGVjIHNheXMgdGhhdCBu
byBrbm93biBQQ0llIEhvc3QgQnJpZGRnZXMvUm9vdCANCnBvcnRzIGRvIGl0IGVpdGhlci4gDQpT
byBmb3IgUENJZSB3ZSBkb24ndCB0aGluayBiZWxpZXZlIHRoZXJlIGlzIGFueSBieXRlIG1lcmdp
bmcgdGhhdCBoYXBwZW5zIGluIHRoZSBQQ0llDQpmYWJyaWMgc28gaXQncyByZWFsbHkgYSBtYXR0
ZXIgb2Ygd2hhdCBoYXBwZW5zIGluIHRoZSBDUFUgY29yZSBhbmQgaW50ZXJjb25uZWN0DQpiZWZv
cmUgaXQgZ2V0cyB0byB0aGUgUENJZSBoaWVyYXJjaHkuDQoNClN0ZXBwaW5nIGJhY2sgZnJvbSB0
aGlzIHBhdGNoc2V0LCBkbyB5b3UgYWdyZWUgdGhhdCBpdCBpcyBkZXNpcmFibGUgdG8gc3VwcG9y
dA0KV3JpdGUgY29tYmluaW5nIGFzIHVuZGVyc3Rvb2QgYnkgaW9yZW1hcF93YyB0byB3b3JrIGlu
IGFsbCBJU0EgZ3Vlc3RzIGluY2x1ZGluZw0KQVJNdjg/DQoNCllvdSBub3RlIHRoYXQgeDg2IHZp
cnR1YWxpemF0aW9uIGRvZXNuJ3QgaGF2ZSB0aGlzIGlzc3VlLCBidXQgS1ZNLUFSTSBkb2VzDQpi
ZWNhdXNlIEtWTSBtYXBzIGFsbCBkZXZpY2UgQkFScyBhcyBEZXZpY2UgTWVtb3J5IHR5cGUgbkdu
UkUgd2hpY2ggDQpkb2Vzbid0IGFsbG93IGlvcmVtYXBfd2MgZnJvbSB3aXRoaW4gdGhlIGd1ZXN0
IHRvIGdldCB0aGUgYWN0dWFsIHNlbWFudGljcyBkZXNpcmVkLg0KDQpNYXJjIGFuZCBvdGhlcnMg
aGF2ZSBzdWdnZXN0ZWQgdGhhdCB1c2Vyc3BhY2Ugc2hvdWxkIHByb3ZpZGUgdGhlIGhpbnRzLiBC
dXQgdGhlDQpxdWVzdGlvbiBpcyBob3cgd291bGQgcWVtdSB2ZmlvIGRvIHRoaXMgZWl0aGVyPyBX
ZSB3b3VsZCBiZSBzdHVjayBpbiB0aGUgc2FtZQ0KYXJndW1lbnRzIGFzIGhlcmUsIGFzIHRvIHdo
YXQgaXMgdGhlIGNvcnJlY3Qgd2F5IHRvIGRldGVybWluZSB0aGUgZGVzaXJlZCBhdHRyaWJ1dGVz
DQpmb3IgYSBnaXZlbiBCQVIgc3VjaCB0aGF0IGV2ZW50dWFsbHkgd2hlbiBhIGRyaXZlciBpbiB0
aGUgZ3Vlc3QgYXNrcyBmb3INCmlvcmVtYXBfd2MgaXQgYWN0dWFsbHkgaGFzIGEgY2hhbmNlIG9m
IHdvcmtpbmcgaW4gdGhlIGd1ZXN0LCBpbiBhbGwgSVNBcy4gDQpEbyB5b3UgaGF2ZSBhbnkgc3Vn
Z2VzdGlvbnMgb24gaG93IHRvIG1ha2UgcHJvZ3Jlc3MgaGVyZT8NCkEgZGV2aWNlIHNwZWNpZmlj
IGxpc3Qgb2Ygd2hpY2ggQkFScyBhcmUgT0sgdG8gYWxsb3cgaW9yZW1hcF93YyBmb3Igc2VlbXMg
dGVycmlibGUNCmFuZCBJJ20gbm90IHN1cmUgaWYgYSBjb21tYW5kbGluZSBxZW11IG9wdGlvbiBp
cyBhbnkgYmV0dGVyLiBJcyB0aGUgdXNlciBvZiBkZXZpY2UgDQphc3NpZ25tZW50L3N5c2FkbWlu
IHN1cHBvc2VkIHRvIGtub3cgd2hpY2ggQkFSIG9mIHdoaWNoIGRldmljZSBpcyBPSyB0byBhbGxv
dyANCmlvcmVtYXBfd2MgZm9yPw0KDQpXaWxsL0NhdGFsaW4sIHBlcmhhcHMgeW91IGNvdWxkIGV4
cGxhaW4geW91ciB0aG91Z2h0IHByb2Nlc3Mgb24gd2h5IHlvdSBjaG9zZQ0KTm9ybWFsIE5DIGZv
ciBpb3JlbWFwX3djIG9uIHRoZSBhcm12OCBsaW51eCBwb3J0IGluc3RlYWQgb2YgRGV2aWNlIEdS
RSBvciBvdGhlcg0KRGV2aWNlIEd4eC4gDQoNCg0KVGhhbmtzLA0KVmlrcmFtDQo=
