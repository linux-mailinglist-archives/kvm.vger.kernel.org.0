Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E98536F261
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 00:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhD2WJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 18:09:16 -0400
Received: from mail-co1nam11on2060.outbound.protection.outlook.com ([40.107.220.60]:4225
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229570AbhD2WJP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 18:09:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HehnpJxeO3cyACaTngfDge0ey8/Z7cFTKMQWMwUm9weUJKcG3VjWPKEfin2ur9AU70y6H+NLzxky/6uC+AHJuS1hsmVGcm3rojwfwypsY2eZJ0+ny0q2gDWbpomqxCiFoWMB9M7idX58+uI1s16WPtLvDC9ctJadtXBOM9qKqmaxLsMXK8t1x1CoIdrUQGfw9HU3du2FK+dv9djXAj01gnZQetM6spYh7/6ftrW4I7g7jcvjdprJy2qDsvcWU8dnVqmkm5CuQvYqAvm/RR2d7i3b2oSBE+fr5MMKkSmMvr/m9WayLNp8y2nqBabsoSUq6HymQb3CoccFfOEQwdx7Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6X0hFpZa6Vi1NbFLrnAq97wFhQMPxNy/Xy7aGLOCHFM=;
 b=NhPFDXzvcZx27eIs/LFpHgkT6QcKdtRtub5NZ6Eg6eLpLZES2/bubKLgvnNc4IZ1S0HNtssaND9+CSZa3GknCsyY5PkU+DysdbeVOXkHquQ+Cfbhu8WG+QHeW1Ptf5abariY96V7ypObO1wkBXoBXhbR1jz6EsKUwmYTOmXFCd4LA5WWH7QpML7bmdM8QnlP0z+Qio0yYZ8PthzTpKnWTTIhD7amhO8XDZoC5fV4TZvKwtF+QmVtAOMppotIAntfCLgd6zt1pXZQz6Pw+7Xvl/xme4eXoc1bOH9cW8m9k6j8v9SyJw5oWCEF6QUkfd3eWYfoVpV2jEcbTfIju2CcGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6X0hFpZa6Vi1NbFLrnAq97wFhQMPxNy/Xy7aGLOCHFM=;
 b=eu6xfiUCvMmKfo5sL8UPwK0aDCTAM/svftu0cF0Ieizv2j94LOPVDugPUeuR0ZydzigHsQMFokehNYELHXkLrTDwsPK60YKkoLPBf6Gb+w+jSA8VvnlwvAZZnLGhjJ9Zh6zGsvedY1OUEpcZBeAEqTOIYBLwucYIyBkbNr/H9BinCcySbJV1+Owelb2dF+4j9SQX6prA3Bkn+oqPUtDasMmmIpB5tkFN0txZkSp0Ja0kABShmYKfzpDEjlMECCHSRfmTjWv5Rmv4iGDw1AWNa3Fi4oRiPXcH96h5LVQYdqCPOwCIE0MtNrC++iyaBw8+9oo9EuFoMQSuiynFfQFD2A==
Received: from BL0PR12MB2532.namprd12.prod.outlook.com (2603:10b6:207:4a::20)
 by MN2PR12MB4093.namprd12.prod.outlook.com (2603:10b6:208:198::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 29 Apr
 2021 22:08:26 +0000
Received: from BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f]) by BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f%5]) with mapi id 15.20.4065.027; Thu, 29 Apr 2021
 22:08:26 +0000
From:   Vikram Sethi <vsethi@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Shanker Donthineni <sdonthineni@nvidia.com>
CC:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
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
Thread-Index: AQHXPRTigOHff2apwEeawQns3nBPOqrL0MoAgAAM5gCAAAj7gIAAJJTg
Date:   Thu, 29 Apr 2021 22:08:26 +0000
Message-ID: <BL0PR12MB2532C10511989BE9EAD2A032BD5F9@BL0PR12MB2532.namprd12.prod.outlook.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
        <20210429162906.32742-2-sdonthineni@nvidia.com>
        <20210429122840.4f98f78e@redhat.com>
        <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
 <20210429134659.321a5c3c@redhat.com>
In-Reply-To: <20210429134659.321a5c3c@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [2603:8080:1102:19fe:94b2:89d7:739a:1f5c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76761dad-c047-42b4-3569-08d90b5b5034
x-ms-traffictypediagnostic: MN2PR12MB4093:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB4093D70F17BDBAF12A8C4152BD5F9@MN2PR12MB4093.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vuZ33HfbrYqUt5G1uYWV7GmifO4LP8qRD7qMlAjmjCtiigA1ECcXksqnkpmGFbyOf/KOgRSbXTUb9YBEiglVeuKGQj7uImdaFsklVX0QIVytOfy12e63jYA1SEpk+7ZER7+AH7i0IvJIIJ5TyQ9ffJyrs3LOs+fMvv8QiVAODPjjO0v4f7JmLFMFxeXQg6247aTX4TkOGh2MC263RAbYpyn/Q5hALElGqWfBBHP7mfBov+3eJNCE9YDAFVEQGZe+1hBKHJTVE9MuxyfwbJ9mv/lTyKSXGbgWE1vIseQ6YmWbRBCujsSlcSHncfNSugSlJajj3+x8KnNr4zRHdZMGclN+0IFy+xTrCPUTyf+muQN1nkctZxYsVkM/uWuzfMCTfi39mOCYx4an+AbRyJxxbMOBZZ58L/Iqxeh+ejivLxpwszFj/a4Ojq7Z76DnlQUon77NWHehmLCgHYlIedW1Vhb3jmGBHhtjTWbXPxLYzfdHJuo0D+NIIqVIaniE8fshU3YOzqbd3lyzMzogzgvYrlAZYRRwb0d8hmulk+mQo6Xr+EwlHn1LVKAhSq7/pgfWxmKRFd9wTxEX50r5ngd+X254Jd69Em1/OxFBAe5eKjs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2532.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(122000001)(66476007)(38100700002)(6506007)(7696005)(478600001)(66946007)(53546011)(86362001)(186003)(52536014)(71200400001)(66446008)(6636002)(316002)(54906003)(9686003)(55016002)(110136005)(83380400001)(2906002)(8936002)(64756008)(107886003)(76116006)(33656002)(8676002)(5660300002)(4326008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?YWhqekpVeEQvRzAxOE9LdmdpSXZ6bnNjSlBnUUMvaEhKRWJjSXJwUS9nSDFN?=
 =?utf-8?B?WmJ3UE1ZM0o2Um14YktpZGNEYkNDTmdIRllMZ0t1bEFGZXA5ajFjMFc1YkZi?=
 =?utf-8?B?eStaNEd3T2J0eEQ2ZjZ0aDE4ejU2c2FJQ3YrendRbWFuYklDYndjeHJnMGVI?=
 =?utf-8?B?V1lla0UwNVBFM1JuMnJJYTBjaTN4T1RqT1p1Zlc5N1p3dndJNHdWNnNUM1VW?=
 =?utf-8?B?d1pQMVlPUnNaSFJnSnBoTk9OS1ZiTXh4Y01hNHp1dWdtdUcvYXJ4Y0ZQUndO?=
 =?utf-8?B?Nk9ZbDNoY1k2SEhZNHlCaWZvVWZSVm4vUHZqTlYrUjZEaFFhRHllbFo1K0lv?=
 =?utf-8?B?UUhkSXlCYkVTaURuSXVDYWVqMytoWjJaQkFnb2YzdER1dFMyRWxKS3lRRU9P?=
 =?utf-8?B?YkdQZWNOMzFSYkhwOWFxWTZFQlJyekF5WTVvckZUUjhHWHB0aTM1bndKS2Fs?=
 =?utf-8?B?UjMzTy9xTWZMaHpPNEcyY1ZPbjdSeFBhdWdwNk01Wk1kbTh1UmJpdklMNExo?=
 =?utf-8?B?UFQ0ZHJGSTdMdTdKVGpQaE45VkRWVWdFb3FzMXlvWFEyMUhzMkxVMnN3aWZy?=
 =?utf-8?B?aUlYVFB1dFFZbEJJWVNIN09wU05tTnY4UGJ4YXZKQ25wZGdFUE9CWDJILzFU?=
 =?utf-8?B?RXhQaDVDNy9zYmZXNndCeUViaVdCVjZvT0lqMFQxcllaQ0ZYSk1OWlFBdkVD?=
 =?utf-8?B?WFpXb0F5VUEzUmZxOEFtblIyWHRMWEVjczZBNjZrdUNoL0pGZjZuZjVRbnE0?=
 =?utf-8?B?bUtMUldlL2ZUa2V4K0JtYzBNSHFneUc0YkRZaGVTVHEySitJTTQveHV1cThS?=
 =?utf-8?B?alR4YVpoM09vTzA5NEVKMEJJdjVLdUJsUHRMUS9SZkJaK3lya0prTVN6MG1W?=
 =?utf-8?B?R0R6cmlrZk5NaDFJMjBnb0dmRlhsbmRMZ3B3L2Z3dVhzNmhoNk1EczFIT3FP?=
 =?utf-8?B?cUNWczI4SDJ5Z0ZOWGpDMzV3QXc3RGdkMzAwNitrbnl1cy9PZjQxN0E5UzQr?=
 =?utf-8?B?TUhnVEh2MnMxTDFTbnNhRmRBRGNOaDBkZ2xSTkxSRkZHTG0xdGdlTlZRUXVw?=
 =?utf-8?B?SndWV0V1QWh3Mzl5V01VYWlDQmZQRGxzV1FMbFlKM2FMMkxYdnliR2pVVHBM?=
 =?utf-8?B?N1lJcXdhUHF2K2xqNVdsMTRXMjVpZXZyUSs5aVRScDkxN3AyVkdtc1hCd0tp?=
 =?utf-8?B?bExzTVQrakpnSkx5cmh6Q1lkMm1sRUo4VlB5U3BxeFQrNVd2K2RqQmFpcU45?=
 =?utf-8?B?SkxpWkZ4YWdWUjM1YzhRREtEUWpjTk1SRjZYV0lGb1o3SVlVWmxwWlR0ZWJG?=
 =?utf-8?B?L3Z2SmNYNmhzWTBvVSt5RTUvTHdmY1lIb21uR09kL1VZZVpKNzhva1RkdkRZ?=
 =?utf-8?B?eFdkWDBld1N4L1d2bDl6WFgvZHVodW4vQ3dza3BxWmFTRzBYZGpDQTVSQzZB?=
 =?utf-8?B?ZEQ4NmhiSnprd1hBd2NFcWpkcTQ1VXFuWVZPNU1IS3JNV0x6NGdreVNGeG9D?=
 =?utf-8?B?bi9kQ3RwbVltOWJzWEVwQlF0eGMxdHBZY29UckluQXlCNFFlV1VFTTRkUXdV?=
 =?utf-8?B?WFhEaDVpNDBYOTZHS2dyOE5WQUhGTGRZaTFOME5kWGp5d1BJeHFRbXJBbm1h?=
 =?utf-8?B?QWo4N21rSTlJSno2K0tSZFpVZG1FMWcwWjFHVHFFQkg2VzNKaStnTmJzdVJW?=
 =?utf-8?B?c1pBcnNFMTF3dnZrb0VDOVpzVGRmQWN2ZWRpR1JjWGpQUVJQdDdRazB3ajAw?=
 =?utf-8?B?eWsrZ0NvYlduNTdITUNSU0lOQVlYTlJTdzB5SC9sd2JDR3oyWFJYa09XYmJp?=
 =?utf-8?B?N2NZT1g2VHlGd3NndWpOYnl0NnNzQnZIOU05S0NXR2RVZFhweWtBbnUrYTU0?=
 =?utf-8?Q?Bqz1J4A/mvbtu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2532.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76761dad-c047-42b4-3569-08d90b5b5034
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2021 22:08:26.1816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cbPSSB5HVMNDPHEcD1RR0qObLXUaWb/tPMXX2VaxArYEmt3BLg9p8sA9ZK/TauxhaGXs7kGvR3dVkbBICMoHiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgQWxleCwNCg0KPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRo
YXQuY29tPg0KPiBTdWJqZWN0OiBSZTogW1JGQyAxLzJdIHZmaW8vcGNpOiBrZWVwIHRoZSBwcmVm
ZXRjaGFibGUgYXR0cmlidXRlIG9mIGEgQkFSIHJlZ2lvbg0KPiBpbiBWTUENCj4gT24gVGh1LCAy
OSBBcHIgMjAyMSAxNDoxNDo1MCAtMDUwMA0KPiBTaGFua2VyIFIgRG9udGhpbmVuaSA8c2RvbnRo
aW5lbmlAbnZpZGlhLmNvbT4gd3JvdGU6DQo+IA0KPiA+IFRoYW5rcyBBbGV4IGZvciBxdWljayBy
ZXBseS4NCj4gPg0KPiA+IE9uIDQvMjkvMjEgMToyOCBQTSwgQWxleCBXaWxsaWFtc29uIHdyb3Rl
Og0KPiA+ID4gSWYgdGhpcyB3ZXJlIGEgdmFsaWQgdGhpbmcgdG8gZG8sIGl0IHNob3VsZCBiZSBk
b25lIGZvciBhbGwNCj4gPiA+IGFyY2hpdGVjdHVyZXMsIG5vdCBqdXN0IEFSTTY0LiAgSG93ZXZl
ciwgYSBwcmVmZXRjaGFibGUgcmFuZ2Ugb25seQ0KPiA+ID4gbmVjZXNzYXJpbHkgYWxsb3dzIG1l
cmdlZCB3cml0ZXMsIHdoaWNoIHNlZW1zIGxpa2UgYSBzdWJzZXQgb2YgdGhlDQo+ID4gPiBzZW1h
bnRpY3MgaW1wbGllZCBieSBhIFdDIGF0dHJpYnV0ZSwgdGhlcmVmb3JlIHRoaXMgZG9lc24ndCBz
ZWVtDQo+ID4gPiB1bml2ZXJzYWxseSB2YWxpZC4NCj4gPiA+DQpJIGRpZG4ndCBnZXQgeW91ciBl
eGFjdCBjb25jZXJuLiBJZiB3ZSByZW1vdmVkIHRoZSBjaGVjayBmb3IgQVJNIGFyY2gNCmFuZCBz
aW1wbHkgc3RvcmVkIHRoYXQgdGhpcyBpcyBhIHByZWZldGNoYWJsZSByZWdpb24gaW4gVk1BLCB0
aGVuIGVhY2ggYXJjaCBLVk0NCnBvcnQgY291bGQgZGVjaWRlIHdoaWNoIFBURSBtYXBwaW5ncyBh
cmUgT0sgZm9yIHByZWZldGNoYWJsZSBCQVIuDQpLVk0gZG9lc24ndCB3YW50IHRvIGdvIHRocm91
Z2ggUENJZSBlbnVtZXJhdGlvbiwgYW5kIHdvdWxkIHJhdGhlcg0KaGF2ZSB0aGUgcHJvcGVydGll
cyBzdG9yZWQgaW4gVk1BLg0KQmV5b25kIHRoYXQsIG9uIGFybTY0IHNwZWNpZmljYWxseSB0aGVy
ZSBpcyBubyBXQyBNZW10eXBlLCBidXQgd2UgdXNlDQpOb3JtYWwgTm9uIENhY2hlYWJsZSBtYXBw
aW5nIGZvciBpb3JlbWFwX3djIHdoaWNoIGNhbiBiZSBwcmVmZXRjaGVkIA0KYW5kIGNhbiBiZSB3
cml0ZSBjb21iaW5lZC4gV2hhdCBzZW1hbnRpY3MgYnJlYWsgZm9yIGEgZGV2aWNlIGlmDQppdHMg
cHJlZmV0Y2hhYmxlIEJBUiBpcyBtYXJrZWQgYXMgTm9ybWFsIE5vbmNhY2hlYWJsZSBvbiBhcm02
ND8NCg0KV2UgbmVlZCBhIHdheSBmb3Igd3JpdGUgY29tYmluaW5nIHRvIHdvcmsgaW4gYSBLVk0t
QVJNIGd1ZXN0LCBhcyBpdCBpcw0KYW4gaW1wb3J0YW50IHVzZWNhc2UgZm9yIEdQVXMgYW5kIE5J
Q3MgYW5kIGFsc28gTlZNZSBDTUIgSUlSQy4gU28NCipzb21lKiB3YXkgaXMgbmVlZGVkIG9mIGxl
dHRpbmcgS1ZNIGtub3cgdG8gbWFwIGFzIHdyaXRlIGNvbWJpbmUgDQooTm9ybWFsIE5DKSBhdCBz
dGFnZTIuIERvIHlvdSBoYXZlIGEgYmV0dGVyIHNvbHV0aW9uIGluIG1pbmQ/IA0KDQo+ID4gPiBJ
J20gYWxzbyBhIGJpdCBjb25mdXNlZCBieSB5b3VyIHByb2JsZW0gc3RhdGVtZW50IHRoYXQgaW5k
aWNhdGVzDQo+ID4gPiB0aGF0IHdpdGhvdXQgV0MgeW91J3JlIHNlZWluZyB1bmFsaWduZWQgYWNj
ZXNzZXMsIGRvZXMgdGhpcyBzdWdnZXN0DQo+ID4gPiB0aGF0IHlvdXIgZHJpdmVyIGlzIGFjdHVh
bGx5IHJlbHlpbmcgb24gV0Mgc2VtYW50aWNzIHRvIHBlcmZvcm0NCj4gPiA+IG1lcmdpbmcgdG8g
YWNoaWV2ZSBhbGlnbm1lbnQ/ICBUaGF0IHNlZW1zIHJhdGhlciBsaWtlIGEgZHJpdmVyIGJ1ZywN
Cj4gPiA+IEknZCBleHBlY3QgVUMgdnMgV0MgaXMgbGFyZ2VseSBhIGRpZmZlcmVuY2UgaW4gcGVy
Zm9ybWFuY2UsIG5vdCBhDQo+ID4gPiBtZWFucyB0byBlbmZvcmNlIHByb3BlciBkcml2ZXIgYWNj
ZXNzIHBhdHRlcm5zLiAgUGVyIHRoZSBQQ0kgc3BlYywNCj4gPiA+IHRoZSBicmlkZ2UgaXRzZWxm
IGNhbiBtZXJnZSB3cml0ZXMgdG8gcHJlZmV0Y2hhYmxlIGFyZWFzLCBwcmVzdW1hYmx5DQo+ID4g
PiByZWdhcmRsZXNzIG9mIHRoaXMgcHJvY2Vzc29yIGF0dHJpYnV0ZSwgcGVyaGFwcyB0aGF0J3Mg
dGhlIGZlYXR1cmUNCj4gPiA+IHlvdXIgZHJpdmVyIGlzIHJlbHlpbmcgb24gdGhhdCBtaWdodCBi
ZSBtaXNzaW5nIGhlcmUuICBUaGFua3MsDQo+ID4gVGhlIGRyaXZlciB1c2VzIFdDIHNlbWFudGlj
cywgSXQncyBtYXBwaW5nIFBDSSBwcmVmZXRjaGFibGUgQkFSUyB1c2luZw0KPiA+IGlvcmVtYXBf
d2MoKS4gIFdlIGRvbid0IHNlZSBhbnkgaXNzdWUgZm9yIHg4NiBhcmNoaXRlY3R1cmUsIGRyaXZl
cg0KPiA+IHdvcmtzIGZpbmUgaW4gdGhlIGhvc3QgYW5kIGd1ZXN0IGtlcm5lbC4gVGhlIHNhbWUg
ZHJpdmVyIHdvcmtzIG9uDQo+ID4gQVJNNjQga2VybmVsIGJ1dCBjcmFzaGVzIGluc2lkZSBWTS4g
R1BVIGRyaXZlciB1c2VzIHRoZSBhcmNoaXRlY3R1cmUNCj4gPiBhZ25vc3RpYyBmdW5jdGlvbiBp
b3JlbWFwX3djKCkgbGlrZSBvdGhlciBkcml2ZXJzLiBUaGlzIGxpbWl0YXRpb24NCj4gPiBhcHBs
aWVzIHRvIGFsbCB0aGUgZHJpdmVycyBpZiB0aGV5IHVzZSBXQyBtZW1vcnkgYW5kIGZvbGxvdyBB
Uk02NA0KPiA+IE5PUk1BTC1OQyBhY2Nlc3MgcnVsZXMuDQo+IA0KPiB4ODYgS1ZNIHdvcmtzIGZv
ciBvdGhlciByZWFzb25zLCBLVk0gd2lsbCB0cnVzdCB0aGUgdkNQVSBhdHRyaWJ1dGVzIGZvciB0
aGUNCj4gbWVtb3J5IHJhbmdlIHJhdGhlciB0aGFuIHJlbHlpbmcgb25seSBvbiB0aGUgaG9zdCBt
YXBwaW5nLg0KPiANCj4gPiBPbiBBUk02NCwgaW9yZW1hcF93YygpIGlzIG1hcHBlZCB0byBub24t
Y2FjaGVhYmxlIG1lbW9yeS10eXBlLCBubw0KPiBzaWRlDQo+ID4gZWZmZWN0cyBvbiByZWFkcyBh
bmQgdW5hbGlnbmVkIGFjY2Vzc2VzIGFyZSBhbGxvd2VkIGFzIHBlciBBUk0tQVJNDQo+ID4gYXJj
aGl0ZWN0dXJlLiBUaGUgZHJpdmVyIGJlaGF2aW9yIGlzIGRpZmZlcmVudCBpbiBob3N0IHZzIGd1
ZXN0IG9uDQo+ID4gQVJNNjQuDQo+IA0KPiBQZXIgdGhlIFBDSSBzcGVjLCBwcmVmZXRjaGFibGUg
bWVtb3J5IG9ubHkgbmVjZXNzYXJpbHkgYWxsb3dzIHRoZSBicmlkZ2UgdG8NCj4gbWVyZ2Ugd3Jp
dGVzLiAgSSBiZWxpZXZlIHRoaXMgaXMgb25seSBhIHN1YnNldCBvZiB3aGF0IFdDIG1hcHBpbmdz
IGFsbG93LA0KPiB0aGVyZWZvcmUgSSBleHBlY3QgdGhpcyBpcyBpbmNvbXBhdGlibGUgd2l0aCBk
cml2ZXJzIHRoYXQgZG8gbm90IHVzZSBXQw0KPiBtYXBwaW5ncy4NCj4gDQo+ID4gQVJNIENQVSBn
ZW5lcmF0aW5nIGFsaWdubWVudCBmYXVsdHMgYmVmb3JlIHRyYW5zYWN0aW9uIHJlYWNoZXMgdGhl
DQo+ID4gUENJLVJDL3N3aXRjaC9lbmQtcG9pbnQtZGV2aWNlLg0KPiANCj4gSWYgYW4gYWxpZ25t
ZW50IGZhdWx0IGlzIGZpeGVkIGJ5IGNvbmZpZ3VyaW5nIGEgV0MgbWFwcGluZywgZG9lc24ndCB0
aGF0DQo+IHN1Z2dlc3QgdGhhdCB0aGUgZHJpdmVyIHBlcmZvcm1lZCBhbiB1bmFsaWduZWQgYWNj
ZXNzIGl0c2VsZiBhbmQgaXMgcmVseWluZyBvbg0KPiB3cml0ZSBjb21iaW5pbmcgYnkgdGhlIHBy
b2Nlc3NvciB0byBjb3JyZWN0IHRoYXQgZXJyb3I/DQo+IFRoYXQncyB3cm9uZy4gIEZpeCB0aGUg
ZHJpdmVyIG9yIHBsZWFzZSBvZmZlciBhbm90aGVyIGV4cGxhbmF0aW9uIG9mIGhvdyB0aGUNCj4g
V0MgbWFwcGluZyByZXNvbHZlcyB0aGlzLiAgSSBzdXNwZWN0IHlvdSBjb3VsZCBlbmFibGUgdHJh
Y2luZyBpbiBRRU1VLA0KPiBkaXNhYmxlIE1NSU8gbW1hcHMgb24gdGhlIHZmaW8tcGNpIGRldmlj
ZSBhbmQgZmluZCB0aGUgaW52YWxpZCBhY2Nlc3MuDQo+IA0KPiA+IFdlJ3ZlIHR3byBjb25jZXJu
cyBoZXJlOg0KPiA+ICAgIC0gUGVyZm9ybWFuY2UgaW1wYWN0cyBmb3IgcGFzcy10aHJvdWdoIGRl
dmljZXMuDQo+ID4gICAgLSBUaGUgZGVmaW5pdGlvbiBvZiBpb3JlbWFwX3djKCkgZnVuY3Rpb24g
ZG9lc24ndCBtYXRjaCB0aGUgaG9zdA0KPiA+IGtlcm5lbCBvbiBBUk02NA0KPiANCj4gUGVyZm9y
bWFuY2UgSSBjYW4gdW5kZXJzdGFuZCwgYnV0IEkgdGhpbmsgeW91J3JlIGFsc28gdXNpbmcgaXQg
dG8gbWFzayBhIGRyaXZlcg0KPiBidWcgd2hpY2ggc2hvdWxkIGJlIHJlc29sdmVkIGZpcnN0LiAg
VGhhbmtzLA0KPiANCj4gQWxleA0KDQo=
