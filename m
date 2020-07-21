Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD178228A4A
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbgGUVBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:01:49 -0400
Received: from mail-dm6nam10on2056.outbound.protection.outlook.com ([40.107.93.56]:29697
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726686AbgGUVBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 17:01:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ET1yhNIwQyqU0V1gbOgKFxRQtTUQCaRjhsx18XB6Lx0dvyuRF82AR4sIo6MAn4WMAa3iHz7Ev6NBUJff/Datq6USSZRdTcOT7+hRcuzfGPxzUdwsUwktSlRBF8k5hpDZTu6RoDXn02TAwhrl4+Gpdle4/8zanWUW+82X2UvmQn3c24/SGyYCk8/ZtG/EQekrPG9XqkYhxXE3ALamunBqVChIiPnq/ErsDhDo350gClyBEMcq6njPthDhJtsjtYV2CVkFpRN4quaF9oHkdtoTzKlRJGGqAX3E0I0DMUCR/VCeehQWgHRHbFXq1mn9RNT4rNunYAc5KMDGyg7nEET7KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+V8S/SNWLMv/0tjR4P09/Ica21Z5Q2Ox4tBDJPV0ZYQ=;
 b=iDMwMT3MMKr7wM+0RcOb0yFnm6W/ZCcwo3XohBqzJGOWVavpOJk/rhsRTdkRZv6uHemh0A1HnFba4sDOgdGzRnCeYOEvubXkvzMFKV6fYxI49x5ynkiobbjxEfZ7ap8GaLagHSGOrzNW0oA2FS7qjEP1pOLOzaWYCb1vHMQQSjupBgiXGEyB9OaRt4EFtZ3PFWec0e8GHm+NGx5mE8+X75elSpsJjNH2t0nbt/rCcWNMs0hXb5zuIGhNJPMvGr/PR8nwp3t5pAxCEErtUu2LwdXBRNHCIpzunouoX+QGkYFdllQgaL7IWZFocQUo+Ovdm/krLf6PIWAv99ABXxVCMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+V8S/SNWLMv/0tjR4P09/Ica21Z5Q2Ox4tBDJPV0ZYQ=;
 b=KCcGQkn/H6D0uJ4hYsIM3XminAXEDrzm3LdKzCjmxBSdCTqz89GEwDtV/HEvIa+lpsk0n75kf57AkUJ+FQqWwzUVhE10wDNq6AfFyCROZRDLmj1xORGPP4ifF8eyjUOezODoklvpt8iX/W6qQ9Xz2SD/TTc6lGFYyhg3UnvPkVk=
Received: from BY5PR05MB7191.namprd05.prod.outlook.com (2603:10b6:a03:1d9::14)
 by SJ0PR05MB7472.namprd05.prod.outlook.com (2603:10b6:a03:285::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.14; Tue, 21 Jul
 2020 21:01:44 +0000
Received: from BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::7d2f:b4c0:5bd9:f6af]) by BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::7d2f:b4c0:5bd9:f6af%8]) with mapi id 15.20.3216.020; Tue, 21 Jul 2020
 21:01:44 +0000
From:   Mike Stunes <mstunes@vmware.com>
To:     Joerg Roedel <joro@8bytes.org>
CC:     "x86@kernel.org" <x86@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v4 51/75] x86/sev-es: Handle MMIO events
Thread-Topic: [PATCH v4 51/75] x86/sev-es: Handle MMIO events
Thread-Index: AQHWWdfdDTzyqLev5U6Jd/iJZ+m0yKkSkJaA
Date:   Tue, 21 Jul 2020 21:01:44 +0000
Message-ID: <40D5C698-1ED2-4CCE-9C1D-07620A021A6A@vmware.com>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-52-joro@8bytes.org>
In-Reply-To: <20200714120917.11253-52-joro@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:600:9e7f:eac1:44f1:7528:2d31:aa97]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66fd10c8-cf30-48d2-0b5b-08d82db9462c
x-ms-traffictypediagnostic: SJ0PR05MB7472:
x-microsoft-antispam-prvs: <SJ0PR05MB74723E72C230523B1DED2A45C8780@SJ0PR05MB7472.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v2GAPcSZkUSE2SLB+fvUUllRQXatIApzFturWsmYqnHhcLtouSC4k+PIA73CWYQWoQdxceV8x3DQjfOUi6bkg4YkovElZPNtBsLP0rhwRhkVJ0xUM8j8G2/jhkhjSlplFMTDyO3rfANfxGuG40ukLNaVbHN4ozVOcW2TFwu7fHpgt22k2umlrFzdQDl0Yzf/FHunVTgaS1dWKllyQ6ov2XPE3OUsU2zoi7NzYuL4bByU2wYVBtPWte+f/+4Q3/VuRzwIKSQSlKqDSa2hNCLwqLTLbKGSG5op+0rlUrQSpA0PhXR30Oxj4BlAcCedtAP7Fd58rCKCI2SA754StbDySg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR05MB7191.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(6506007)(53546011)(186003)(4326008)(7416002)(2616005)(6486002)(8936002)(6512007)(66476007)(33656002)(478600001)(54906003)(76116006)(316002)(86362001)(5660300002)(2906002)(66446008)(64756008)(66556008)(66946007)(6916009)(71200400001)(8676002)(36756003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: d/aW2nUxMcOBiuVRKWyUtd2kod2IZ+VzKZlLf3yQsMGfuP53dU4OiRgTqEON2wh6nd1P9R9lAO5i5/KlG77JDuefNt6Qr0rj4qXz64PUefm2fDtN5OuxPRMXkMS4/auBbKmccdclqhW2B0UujRUB3nOeuG327Leng7Ptl6soFTvXZBYIires8Tnag80pLleCXaVUdmGa8WvuayH1rKTe76yL4O/cHMht359m4Rt95mEGVSYMf3XcTxDcWIFzexaD4K2dtfuzMXp2lgMtmTGZJLdRvKkC3hYdQRg6cH8EztOUsAZdgy9Iu3agwb+a5hJzw0W6hsuqraKkyh/hxZiWfCrkpvmVN142L1aNVeloEUCd9ucDLehqggmslC+izDqXED8p9kQ8dfNuQqvpzFEC5LJQ4u4YA/+49miFVl6tZRUUgzpOYh/8pXOX2F+pt6U97oQysUFJwQU5204U5fuUKeYcN3T++TLnb+ZKbXX6kmUwOk7c60Eeh7iqF4TQZARaWJqqLA1lrWTcz1co/h9KvIlb58yoodfVFRD688kgF9wk7mj8WlrNO7iIE51uEyRO
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF0E2EA999EC494A816392FBDBBA1035@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR05MB7191.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66fd10c8-cf30-48d2-0b5b-08d82db9462c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 21:01:44.0624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BIa5w+c9eUC0JD04fYKB0qF83gLmT8ENpKnGaStamfuvLXGQ5eAeBxsjoS/K2Bbp1gRg5YSyIXTMpxi/rHc6Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7472
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgSm9lcmcsDQoNClRoYW5rcyBmb3IgdGhlIG5ldyBwYXRjaC1zZXQhDQoNCj4gT24gSnVsIDE0
LCAyMDIwLCBhdCA1OjA4IEFNLCBKb2VyZyBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz4gd3JvdGU6
DQo+IA0KPiBGcm9tOiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPg0KPiAN
Cj4gQWRkIGhhbmRsZXIgZm9yIFZDIGV4Y2VwdGlvbnMgY2F1c2VkIGJ5IE1NSU8gaW50ZXJjZXB0
cy4gVGhlc2UNCj4gaW50ZXJjZXB0cyBjb21lIGFsb25nIGFzIG5lc3RlZCBwYWdlIGZhdWx0cyBv
biBwYWdlcyB3aXRoIHJlc2VydmVkDQo+IGJpdHMgc2V0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
VG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1kLmNvbT4NCj4gWyBqcm9lZGVsQHN1c2Uu
ZGU6IEFkYXB0IHRvIFZDIGhhbmRsaW5nIGZyYW1ld29yayBdDQo+IENvLWRldmVsb3BlZC1ieTog
Sm9lcmcgUm9lZGVsIDxqcm9lZGVsQHN1c2UuZGU+DQo+IFNpZ25lZC1vZmYtYnk6IEpvZXJnIFJv
ZWRlbCA8anJvZWRlbEBzdXNlLmRlPg0KPiANCj4gPHNuaXA+DQoNCknigJltIHJ1bm5pbmcgaW50
byBhbiBNTUlPLXJlbGF0ZWQgYnVnIHdoZW4gSSB0cnkgdGVzdGluZyB0aGlzIG9uIG91ciBoeXBl
cnZpc29yLg0KDQpEdXJpbmcgYm9vdCwgcHJvYmVfcm9tcyAoYXJjaC94ODYva2VybmVsL3Byb2Jl
X3JvbXMuYykgdXNlcyByb21jaGVja3N1bSBvdmVyIHRoZSB2aWRlbyBST00gYW5kIGV4dGVuc2lv
biBST00gcmVnaW9ucy4gSW4gbXkgdGVzdCBWTSwgdGhlIHZpZGVvIFJPTSByb21jaGVja3N1bSBz
dGFydHMgYXQgdmlydHVhbCBhZGRyZXNzIDB4ZmZmZjg4ODAwMDBjMDAwMCBhbmQgaGFzIGxlbmd0
aCA2NTUzNi4gQnV0LCBhdCBhZGRyZXNzIDB4ZmZmZjg4ODAwMDBjNDAwMCwgd2Ugc3dpdGNoIGZy
b20gYmVpbmcgdmlkZW8tUk9NLWJhY2tlZCB0byBiZWluZyB1bmJhY2tlZCBieSBhbnl0aGluZy4N
Cg0KV2l0aCBTRVYtRVMgZW5hYmxlZCwgb3VyIHBsYXRmb3JtIGhhbmRsZXMgcmVhZHMgYW5kIHdy
aXRlcyB0byB1bmJhY2tlZCBtZW1vcnkgYnkgdHJlYXRpbmcgdGhlbSBhcyBNTUlPLiBTbywgdGhl
IHJlYWQgZnJvbSAweGZmZmY4ODgwMDAwYzQwMDAgY2F1c2VzIGEgI1ZDLCB3aGljaCBpcyBoYW5k
bGVkIGJ5IGRvX2Vhcmx5X2V4Y2VwdGlvbi4NCg0KSW4gaGFuZGxpbmcgdGhlICNWQywgdmNfc2xv
d192aXJ0X3RvX3BoeXMgZmFpbHMgZm9yIHRoYXQgYWRkcmVzcy4gTXkgdW5kZXJzdGFuZGluZyBp
cyB0aGF0IHRoZSAjVkMgaGFuZGxlciBzaG91bGQgdGhlbiBhZGQgYW4gZW50cnkgdG8gdGhlIHBh
Z2UgdGFibGVzIGFuZCByZXRyeSB0aGUgZmF1bHRpbmcgYWNjZXNzLiBTb21laG93LCB0aGF0IGlz
buKAmXQgaGFwcGVuaW5nLiBGcm9tIHRoZSBoeXBlcnZpc29yIHNpZGUsIGl0IGxvb2tzIGxpa2Ug
dGhlIGd1ZXN0IGlzIGxvb3Bpbmcgc29tZWhvdy4gKEkgdGhpbmsgdGhlIFZDUFUgaXMgbW9zdGx5
IHVuaGFsdGVkIGFuZCBtYWtpbmcgcHJvZ3Jlc3MsIGJ1dCB0aGUgZ3Vlc3QgbmV2ZXIgZ2V0cyBw
YXN0IHRoYXQgcm9tY2hlY2tzdW0uKSBUaGUgZ3Vlc3QgbmV2ZXIgYWN0dWFsbHkgbWFrZXMgYW4g
TU1JTyB2bWdleGl0IGZvciB0aGF0IGFkZHJlc3MuDQoNCklmIEkgcmVtb3ZlIHRoZSBjYWxsIHRv
IHByb2JlX3JvbXMgZnJvbSBzZXR1cF9hcmNoLCBvciByZW1vdmUgdGhlIGNhbGxzIHRvIHJvbWNo
ZWNrc3VtIGZyb20gcHJvYmVfcm9tcywgdGhpcyBrZXJuZWwgYm9vdHMgbm9ybWFsbHkuDQoNClBs
ZWFzZSBsZXQgbWUga25vdyBvZiBvdGhlciB0ZXN0cyBJIHNob3VsZCBydW4gb3IgZGF0YSB0aGF0
IEkgY2FuIGNvbGxlY3QuIFRoYW5rcyENCg0KTWlrZQ==
