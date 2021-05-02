Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21038370E4E
	for <lists+kvm@lfdr.de>; Sun,  2 May 2021 19:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhEBR51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 May 2021 13:57:27 -0400
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:6625
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230110AbhEBR50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 May 2021 13:57:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZwlxIoTos6UrMynqPemo/A1ODhN2KV9MBiOUZOlTDEquqgclmgEZfKOGzjodTN5pGzarOx0vgpiz0hLKAWokX1lSIyf0hjs+byLNoJ0YrwznU8jNXxv9VPU+KLRQNDsiMy6H3e7N6cjTb1FrfQXI6QkCkknoVpzwRFI5c0V9GHV7NlVNRIlAfTOhTrt+x/mrp4UOrluNZXIyCC+fR71P5C9JyecquPYH1opiJqWf3y5lVmJoB18bgg6mwWuKGM/Qb39JjQjkYUiNvqGfFnekIwxcpTHiCbG1trlBXt/6Fn3CZeRE3cp0VdQXFJWh1RU0J4LQ4uL54RKx+xvRr/N1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZLRSiQmUiqLxIIkAUhYDnzWcGrHV8uxrm0nUiKanuI=;
 b=gnDXtd94FCuIfxp0O9pBE1NPhCRYW3UaFQqo3eGlU44r+zQeznUhvZbR85V5M5gMBLM/sZhBwVsRZ9PsUVGKdpXXCEJqgkusyqJIBb6cKHn6WX7IK84levplWkfxK/+HbckzDSS7eey4sqaXl87BtKyL/g2ya+OYWRCXmGhyZGsjxH0lOpFdP0cAWM0qZqlfeOI4/TSkcUFgn8Eeu6pypdtOlAUFV2vH9PFFeV1/o5brSBjBwFan987JBCvb4zUVVvPgyZETZG/SzIqDPOFSeLQl7V4m45mXCOiA0erJx7WawLUX+NF/Gg6sx91My0MCCdWYLsKRQFJHgZEVOLFB3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZLRSiQmUiqLxIIkAUhYDnzWcGrHV8uxrm0nUiKanuI=;
 b=PE3K2n0xrgUQDRZe8WFRTJIDAd80eqLpe3Dv+ZdymOi7pKUGSwCDdvJquk9ctzSprMapfR8bdnCLIGbdT1aYCWY/tw1X5FbEqsqxXh+VhfqjYj+hMl05677fGlsROvgTpgY9hRuecyA+N0LYgrOnriOM8hdurYdjnTgvGIm6Ho75SBC0Q+zg34MhYkO44aePhmqcUJZeaaPQ6mQ1OAggVBb7P3LtdinalW34986CIjE0KPVkbaQjMru7FYGU+rALafLhJJ7Q5oXmipZpRljjfpUvo89xyivDyq8uAnL2SrJE2OHaaZywjqGBoJ5YKt3Fzn6cVeqf7/1E2LM7CU+VRA==
Received: from BL0PR12MB2532.namprd12.prod.outlook.com (2603:10b6:207:4a::20)
 by MN2PR12MB4288.namprd12.prod.outlook.com (2603:10b6:208:1d2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.39; Sun, 2 May
 2021 17:56:31 +0000
Received: from BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f]) by BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f%5]) with mapi id 15.20.4087.040; Sun, 2 May 2021
 17:56:31 +0000
From:   Vikram Sethi <vsethi@nvidia.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     Shanker Donthineni <sdonthineni@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will@kernel.org>,
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
Thread-Index: AQHXPRTigOHff2apwEeawQns3nBPOqrL0MoAgAAM5gCAAAj7gIABBh4AgAAGT4CAADU7AIAACSoAgAABt+CAASvZAIACHFDw
Date:   Sun, 2 May 2021 17:56:31 +0000
Message-ID: <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
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
In-Reply-To: <87eeeqvm1d.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [12.97.180.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aadfdfc5-46ef-49a9-f55e-08d90d939e43
x-ms-traffictypediagnostic: MN2PR12MB4288:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB428866324FC76A1F267C1101BD5C9@MN2PR12MB4288.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IU5BE2BNKccQFJmdkqliJVg4SXbL/v0GOajjIW/11Ku/i5mtg95inWXmmFULVx4xcBOHxuqvYKb8GhDxcD5SI2XmLKzaQdEvKOiSfNm8kd0JUueMz19nbIfzhGhfliCoiYbuPYuhLF2kXD7YhAXm1mEKLizb8vFEd8iVco+gsMVT3Z1O9Dek8W+drANzUvRTKf6BQECZXlt/46EL5gDb5pt1yUv88wPLFxYNqwW2+tESPqfSFyQl8vupwoGx0XV6HOyZH2b6H6RzQHoH+V+aRF8pkY2bQWL6arT5W0QkjjW27JPt+9Zsn5BP3V2MlUp3nLtoh1M5m3uSFsm1sJuYJEF7Yh18/udkxfKPvrh+UWZ0eLjhRaX47oV/nAsYAdVtGUhSNG37McGy//oyJtaNLcNQKg5ocZwgwQf9Ev15Y69n9ndXhKXXrXKoQyXzhJWrqF5AFSf/iKGYLRduV0mx4h1IFfvMRvqXCW+/vCzuEKKuq2UNGebRQXpsxhqppi7GoghhjRr6okPoYozqxAIroZfQQ7UOYza51xxqdqJ2xhTkDmVrcN5fsWGjxPgnCiw4bSUzh6uRgHzfVLqhpLoNotWgaE/Tvejk34bdaeJ7MF0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2532.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(6506007)(5660300002)(4326008)(7696005)(33656002)(71200400001)(107886003)(122000001)(38100700002)(86362001)(478600001)(8936002)(52536014)(64756008)(76116006)(6916009)(186003)(54906003)(8676002)(316002)(55016002)(66446008)(66946007)(2906002)(66556008)(66476007)(26005)(9686003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Vi9ZVDlXMnRMckc1MnM0M29iMjBrUlAwM2Z6cWpLZFdJaDljNFU4ZUt5Wngy?=
 =?utf-8?B?YXRMY0gxN3gyQlN6Nk5ZZk91ZTU4UEl1TnV5Y0szb2RaN2Z6aFIyYnB1WWVr?=
 =?utf-8?B?WVh2OTIvQ3IrRDhwaFdHdTBrd2NPODUvRUFYaDNqaGJqbHNVUmQvSFUwZ2lN?=
 =?utf-8?B?cUN1SldZQk50UmliZXFvaURGbk04MlU1bG5rLzdvUEZJUnBCb1U1UHJ1SHZZ?=
 =?utf-8?B?MGhRcDBuS1IyNFB5ME4way9FZTB6SWdHVUR4SjBrUmlzMHhjQjVXOTRMQy9E?=
 =?utf-8?B?cFltZG1ETzE2Sm56dVpzUGZXZTU4TVc3dllkMFZHbW1tMW1qbndFNDdJQ0Vk?=
 =?utf-8?B?Q2ptTjQ4clJSREFtakNadnp3YWZBcVlXdnZteHB6czhydjIyVncyUWR5VzRV?=
 =?utf-8?B?MThkNjRNRW1ua0VkU1ZteDJnSTBvTFhRU0hTUHBDWnhPZHhLbGppTDc5WmFw?=
 =?utf-8?B?MEZ1UU9VTkRyY0J5WW41cjVTcWU3ajBTZzJLdTRmcXJROVZhNTR6OFRpUjdX?=
 =?utf-8?B?NFZVWVk4U1hiNXFFTnRvQnpqUllUT3I2NlJldk5nTFFzR1VIQnlpUzFLZW9i?=
 =?utf-8?B?U0dmVU5MSDd6V0Zsa3hwNVk2WnVBNDJ1WVhIQjhobjNQSU5KdkdOb1pwa083?=
 =?utf-8?B?RnYya3AwTnVYaEx5S0ZZaXFTZ1NHZmlTRnpyQXlVblI1TmZ3cnRQWDhDY1Bj?=
 =?utf-8?B?T0ZnSThRMVRzZmNSeEE3cW9vYWwrUm41WWRMc29iSkFRME5ibXpZZkUybVN3?=
 =?utf-8?B?SElDT0ZkOFhqOEQzMG9TQXRmM3NweUxjc09FbjFZdVlScDB5b084cE51ei9U?=
 =?utf-8?B?ckVuK3JFOGloR0FObEc3Z0lQSG5BVlJ6ZXNjN0R2SlRmQ0plTkN5UzhzK0kx?=
 =?utf-8?B?TVVNY0FudmNJSmVOQkgzQVdyclNQVEk0Kyt3NExlTzJIdHRUcktxcmtOZ05i?=
 =?utf-8?B?MHJ3ZjA3djJmL3diT2NMUHFXWXRLeDl1amJzYWp2eDd3bG9DT09TbWg3cW9x?=
 =?utf-8?B?YzJPM3A5VlVYKzZsZlo5UytqOXJkMHB4Skw3ek1lZXJqb0JtN2IxWXg3WEEw?=
 =?utf-8?B?dHBrNzRpN3puUXRhNWJBM05nNVBtS0w5NGtweTZ2RCtXTTExMEwvNE1rNGFw?=
 =?utf-8?B?ckJjZnpEMjRMRnBTeXpYNWJrZ2Yra2JDVjhYZ0xZcEtVSTNYUFZWcVF0RGo2?=
 =?utf-8?B?QitIQlhnblpnNlB6aU0zU3hUQ3d3bVU1cmJoVFovY2dwU1hEQklNU1p2VVc5?=
 =?utf-8?B?MDBzQ0JUK1dnRUY0b1Z5SWVKVVovM2ZHZkpKenJwUDRsY1J6c1dscWh2bFFF?=
 =?utf-8?B?cStZcWY3MFQ0Q0FhZGp0NXV6QkVFbFY5aWRzT2tsOGtrejZnQzNFWXR0RHlD?=
 =?utf-8?B?OHFxUnZZMnZqM2kxRlJUTGtLV1VFbHFKdXcvMkl2dEtSSXBHc1puN0ZNS3VX?=
 =?utf-8?B?cGFCYnNzR2hrRU1aU0xoWGFCd2dzMDlIM1h5SEVlTDBreTUzOEc5N2ZiRTU4?=
 =?utf-8?B?ZVZHb2JBRm0wWnByUG5adEdiVi9UaHVMbnZidVFSNmgzTUx3UGtDUUsyejNt?=
 =?utf-8?B?MERvellwaHg0dGFIby9FWTVBdGJuZzVGell4REFtYVg1RnhlQkZwRnBnSTlP?=
 =?utf-8?B?a1M0OTZFMm1TaFlXcHZid1Jxd3dkaTNnMkJXejdjbWQ3UTJBMDJJRXFXNi8v?=
 =?utf-8?B?cEk0TXBkK2hsTVhBajBzVk1mUWl1dm0ySjJEdzNHbG5JT0ZNV1FIcERFczZn?=
 =?utf-8?Q?o4i/h7Ikfx+UWYFdAo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2532.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aadfdfc5-46ef-49a9-f55e-08d90d939e43
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2021 17:56:31.4334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: swcvaY59vNx5wYIgWV8XYFOz2SXTuxZYJBh7i0Q73dpDp8pAEsUgzwWlhEKpoC78SNxWzYAiEw9bfVVXJota4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4288
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgTWFyYywgDQoNCj4gRnJvbTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4gSGkg
VmlrcmFtLA0KPiANCiANCj4gVGhlIHByb2JsZW0gSSBzZWUgaXMgdGhhdCB3ZSBoYXZlIFZNIGFu
ZCB1c2Vyc3BhY2UgYmVpbmcgd3JpdHRlbiBpbiB0ZXJtcw0KPiBvZiBXcml0ZS1Db21iaW5lLCB3
aGljaCBpczoNCj4gDQo+IC0gbG9vc2VseSBkZWZpbmVkIGV2ZW4gb24geDg2DQo+IA0KPiAtIHN1
YmplY3QgdG8gaW50ZXJwcmV0YXRpb25zIGluIHRoZSB3YXkgaXQgbWFwcyB0byBQQ0kNCj4gDQo+
IC0gaGFzIG5vIGRpcmVjdCBlcXVpdmFsZW50IGluIHRoZSBBUk12OCBjb2xsZWN0aW9uIG9mIG1l
bW9yeQ0KPiAgIGF0dHJpYnV0ZXMgKGFuZCBOb3JtYWxfTkMgY29tZXMgd2l0aCBzcGVjdWxhdGlv
biBjYXBhYmlsaXRpZXMgd2hpY2gNCj4gICBzdHJpa2VzIG1lIGFzIGV4dHJlbWVseSB1bmRlc2ly
YWJsZSBvbiBhcmJpdHJhcnkgZGV2aWNlcykNCg0KSWYgc3BlY3VsYXRpb24gd2l0aCBOb3JtYWwg
TkMgdG8gcHJlZmV0Y2hhYmxlIEJBUnMgaW4gZGV2aWNlcyB3YXMgYSBwcm9ibGVtLCANCnRob3Nl
IGRldmljZXMgd291bGQgYWxyZWFkeSBiZSBicm9rZW4gaW4gYmFyZW1ldGFsIHdpdGggaW9yZW1h
cF93YyBvbiBhcm02NCwgDQphbmQgd2Ugd291bGQgbmVlZCBxdWlya3MgdGhlcmUgdG8gbm90IGRv
IE5vcm1hbCBOQyBmb3IgdGhlbSBidXQgRGV2aWNlIEdSRSwgDQphbmQgaWYgc3VjaCBhIHF1aXJr
IHdhcyBuZWVkZWQgb24gYmFyZW1ldGFsLCBpdCBjb3VsZCBiZSBwaWNrZWQgdXAgYnkgdmZpby9L
Vk0NCmFzIHdlbGwuIEJ1dCB3ZSBoYXZlbid0IHNlZW4gYW55IGJyb2tlbiBkZXZpY2VzIGRvaW5n
IHdjIG9uIGJhcmVtZXRhbCBvbiBBUk02NCwgaGF2ZSB3ZT8NCkkga25vdyB3ZSBoYXZlIHRlc3Rl
ZCBOSUNzIHdyaXRlIGNvbWJpbmluZyBvbiBhcm02NCBpbiBiYXJlbWV0YWwsIGFzIHdlbGwgYXMg
R1BVDQphbmQgTlZNZSBDTUIgd2l0aG91dCBpc3N1ZXMuDQoNCkZ1cnRoZXIsIEkgZG9uJ3Qgc2Vl
IHdoeSBzcGVjdWxhdGlvbiB0byBub24gY2FjaGVibGUgd291bGQgYmUgYW4gaXNzdWUgaWYgcHJl
ZmV0Y2ggDQp3aXRob3V0IHNpZGUgZWZmZWN0cyBpcyBhbGxvd2VkIGJ5IHRoZSBkZXZpY2UsIHdo
aWNoIGlzIHdoYXQgYSBwcmVmZXRjaGFibGUgQkFSIGlzLiANCklmIGl0IGlzIGFuIGlzc3VlIGZv
ciBhIGRldmljZSBJIHdvdWxkIGNvbnNpZGVyIHRoYXQgYSBidWcgYWxyZWFkeSBuZWVkaW5nIGEg
cXVpcmsgaW4NCkJhcmVtZXRhbC9ob3N0IGtlcm5lbCBhbHJlYWR5LiANCkZyb20gUENJIHNwZWMg
IiBBIHByZWZldGNoYWJsZSBhZGRyZXNzIHJhbmdlIG1heSBoYXZlIHdyaXRlIHNpZGUgZWZmZWN0
cywgDQpidXQgaXQgbWF5IG5vdCBoYXZlIHJlYWQgc2lkZSBlZmZlY3RzLiINCj4gDQo+IEhvdyBk
byB3ZSB0cmFuc2xhdGUgdGhpcyBpbnRvIHNvbWV0aGluZyBjb25zaXN0ZW50PyBJJ2QgbGlrZSB0
byBzZWUgYW4gYWN0dWFsDQo+IGRlc2NyaXB0aW9uIG9mIHdoYXQgd2UgKnJlYWxseSogZXhwZWN0
IGZyb20gV0Mgb24gcHJlZmV0Y2hhYmxlIFBDSSByZWdpb25zLA0KPiB0dXJuIHRoYXQgaW50byBh
IGRvY3VtZW50ZWQgZGVmaW5pdGlvbiBhZ3JlZWQgYWNyb3NzIGFyY2hpdGVjdHVyZXMsIGFuZCB0
aGVuDQo+IHdlIGNhbiBsb29rIGF0IGltcGxlbWVudGluZyBpdCB3aXRoIG9uZSBtZW1vcnkgdHlw
ZSBvciBhbm90aGVyIG9uIGFybTY0Lg0KPiANCj4gQmVjYXVzZSBvbmNlIHdlIGV4cG9zZSB0aGF0
IG1lbW9yeSB0eXBlIGF0IFMyIGZvciBLVk0gZ3Vlc3RzLCBpdA0KPiBiZWNvbWVzIEFCSSBhbmQg
dGhlcmUgaXMgbm8gdHVybmluZyBiYWNrLiBTbyBJIHdhbnQgdG8gZ2V0IGl0IHJpZ2h0IG9uY2Ug
YW5kDQo+IGZvciBhbGwuDQo+IA0KSSBhZ3JlZSB0aGF0IHdlIG5lZWQgYSBwcmVjaXNlIGRlZmlu
aXRpb24gZm9yIHRoZSBMaW51eCBpb3JlbWFwX3djIEFQSSB3cnQgd2hhdA0KZHJpdmVycyAoa2Vy
bmVsIGFuZCB1c2Vyc3BhY2UpIGNhbiBleHBlY3QgYW5kIHdoZXRoZXIgbWVtc2V0L21lbWNweSBp
cyBleHBlY3RlZA0KdG8gd29yayBvciBub3QgYW5kIHdoZXRoZXIgYWxpZ25lZCBhY2Nlc3NlcyBh
cmUgYSByZXF1aXJlbWVudC4gDQpUbyB0aGUgZXh0ZW50IEFCSSBpcyBzZXQsIEkgd291bGQgdGhp
bmsgdGhhdCB0aGUgQUJJIGlzIGFsc28gYWxyZWFkeSBzZXQgaW4gdGhlIGhvc3Qga2VybmVsIA0K
Zm9yIGFybTY0IFdDID0gTm9ybWFsIE5DLCBzbyB3aHkgc2hvdWxkIHRoYXQgbm90IGFsc28gYmUg
dGhlIEFCSSBmb3Igc2FtZSBkcml2ZXIgaW4gVk1zLg0KDQo+IFRoYW5rcywNCj4gDQo+ICAgICAg
ICAgTS4NCj4gDQo+IC0tDQo+IFdpdGhvdXQgZGV2aWF0aW9uIGZyb20gdGhlIG5vcm0sIHByb2dy
ZXNzIGlzIG5vdCBwb3NzaWJsZS4NCg==
