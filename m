Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2170055F89
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 05:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfFZDc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 23:32:28 -0400
Received: from mail-eopbgr800075.outbound.protection.outlook.com ([40.107.80.75]:24064
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbfFZDc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 23:32:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwAChuyD23YBRtOl0BxcFTUWUjeFLfOlxOpirhwtyHg=;
 b=F9cnyT1pvxeGJVvkH5SVE+pNvTtvCUiQX7cbtXGFks0jqTJALFsyNlMEhJ+SdvNy6Si54lQFkc61eJPdiHVOFfV1SfaiNuv0JOMQA/3VbG2YzGFkujyawrRHk2n/f1rSXO8R6n0l8Q0Akftwn15XekE9LrSw6MwnlIDax1qvAmw=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB5541.namprd05.prod.outlook.com (20.177.186.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Wed, 26 Jun 2019 03:32:25 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58%7]) with mapi id 15.20.2008.007; Wed, 26 Jun 2019
 03:32:25 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Dave Hansen <dave.hansen@intel.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH 4/9] x86/mm/tlb: Flush remote and local TLBs concurrently
Thread-Topic: [PATCH 4/9] x86/mm/tlb: Flush remote and local TLBs concurrently
Thread-Index: AQHVIbQneqvfvnASJUSZoJZyXs9Ulaas9rUAgABVYwCAAAcogIAACOEA
Date:   Wed, 26 Jun 2019 03:32:25 +0000
Message-ID: <E4BD986D-F8A1-45D3-9DC1-AE0649D1F5C3@vmware.com>
References: <20190613064813.8102-1-namit@vmware.com>
 <20190613064813.8102-5-namit@vmware.com>
 <723d63ee-c8cb-14a1-0eb9-265e580360f4@intel.com>
 <1545B936-7CEC-4A1C-B776-74004F774218@vmware.com>
 <88a76cb8-2484-818a-2be6-d06a4ffef107@intel.com>
In-Reply-To: <88a76cb8-2484-818a-2be6-d06a4ffef107@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [204.134.128.110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72bd90e4-9c5f-4a44-f97c-08d6f9e6e835
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB5541;
x-ms-traffictypediagnostic: BYAPR05MB5541:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BYAPR05MB5541533570E65D514C0B7A24D0E20@BYAPR05MB5541.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(39860400002)(346002)(396003)(366004)(199004)(189003)(66946007)(86362001)(446003)(81156014)(486006)(25786009)(2616005)(2906002)(305945005)(8936002)(476003)(54906003)(3846002)(316002)(229853002)(256004)(6116002)(53936002)(71190400001)(66066001)(11346002)(33656002)(6486002)(99286004)(76176011)(6246003)(6512007)(6306002)(26005)(91956017)(66556008)(53546011)(66446008)(71200400001)(6506007)(8676002)(478600001)(64756008)(14454004)(73956011)(6436002)(66476007)(68736007)(7736002)(76116006)(4326008)(102836004)(7416002)(5660300002)(966005)(36756003)(6916009)(186003)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5541;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4HQlkwJxrPpA/cYQt4H6P7qB9SFTOvyi2QI/O+/hDts5R7gV4dYxaauQils94xwFQftqbQZEt8f0Y65MkqAH5BT2Z9WhA9kx5xiM9KRvgfHBJFQQ7qs4qbqp9hm8sVQ5QqOC3F1U43paue7QyuIbe6yw12q1x4CJeiiSb95m9Zw5flib7VgQ0IJYpErH6O13/ukmI8yReB9CPF/05d5PBrV0Tay5VFB9cVnUUhsx+R/QE77JEYquvjr2JkoMH1hSWWnFN/nCIcICcRe9S9KsW4TSHUvjxwOVrAJWDNuHPzzhU7VcotFsnqhtL5khbQkDxnW6SNQszbAoGkEjrgJzEzanHQ3PiMP2BoggwnkRHRfv+zK4oOBFJD//8lITWqeR6Si3ySCbhLdvjMz6dzmfG+L/1jVNvpM6DCw70yf3600=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A93801C3C77B54FBCD984EC5F738BCA@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72bd90e4-9c5f-4a44-f97c-08d6f9e6e835
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 03:32:25.2340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5541
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdW4gMjUsIDIwMTksIGF0IDg6MDAgUE0sIERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBp
bnRlbC5jb20+IHdyb3RlOg0KPiANCj4gT24gNi8yNS8xOSA3OjM1IFBNLCBOYWRhdiBBbWl0IHdy
b3RlOg0KPj4+PiBjb25zdCBzdHJ1Y3QgZmx1c2hfdGxiX2luZm8gKmYgPSBpbmZvOw0KPj4+PiAr
CWVudW0gdGxiX2ZsdXNoX3JlYXNvbiByZWFzb247DQo+Pj4+ICsNCj4+Pj4gKwlyZWFzb24gPSAo
Zi0+bW0gPT0gTlVMTCkgPyBUTEJfTE9DQUxfU0hPT1RET1dOIDogVExCX0xPQ0FMX01NX1NIT09U
RE9XTjsNCj4+PiANCj4+PiBTaG91bGQgd2UganVzdCBhZGQgdGhlICJyZWFzb24iIHRvIGZsdXNo
X3RsYl9pbmZvPyAgSXQncyBPSy1pc2ggdG8gaW1wbHkNCj4+PiBpdCBsaWtlIHRoaXMsIGJ1dCBz
ZWVtcyBsaWtlIGl0IHdvdWxkIGJlIG5pY2VyIGFuZCBlYXNpZXIgdG8gdHJhY2sgZG93bg0KPj4+
IHRoZSBvcmlnaW5zIG9mIHRoZXNlIHRoaW5ncyBpZiB3ZSBkaWQgdGhpcyBhdCB0aGUgY2FsbGVy
Lg0KPj4gDQo+PiBJIHByZWZlciBub3QgdG8uIEkgd2FudCBsYXRlciB0byBpbmxpbmUgZmx1c2hf
dGxiX2luZm8gaW50byB0aGUgc2FtZQ0KPj4gY2FjaGVsaW5lIHRoYXQgaG9sZHMgY2FsbF9mdW5j
dGlvbl9kYXRhLiBJbmNyZWFzaW5nIHRoZSBzaXplIG9mDQo+PiBmbHVzaF90bGJfaW5mbyBmb3Ig
bm8gZ29vZCByZWFzb24gd2lsbCBub3QgaGVscOKApg0KPiANCj4gV2VsbCwgZmx1c2hfdGxiX2lu
Zm8gaXMgYXQgNi84dGhzIG9mIGEgY2FjaGVsaW5lIGF0IHRoZSBtb21lbnQuDQo+IGNhbGxfZnVu
Y3Rpb25fZGF0YSBpcyAzLzh0aHMuICBUbyBtZSwgdGhhdCBtZWFucyB3ZSBoYXZlIHNvbWUgc2xh
Y2sgaW4NCj4gdGhlIHNpemUuDQoNCkkgZG8gbm90IHVuZGVyc3RhbmQgeW91ciBtYXRoLi4gOigN
Cg0KNiArIDMgPiA4IHNvIHB1dHRpbmcgYm90aCBmbHVzaF90bGJfaW5mbyBhbmQgY2FsbF9mdW5j
dGlvbl9kYXRhIGRvZXMgbm90DQpsZWF2ZSB1cyBhbnkgc2xhY2sgKHdlIGNhbiBzYXZlIG9uZSBx
d29yZCwgc28gd2UgY2FuIGFjdHVhbGx5IHB1dCB0aGVtDQphdCB0aGUgc2FtZSBjYWNoZWxpbmUp
Lg0KDQpZb3UgY2FuIHNlZSBteSBjdXJyZW50IGltcGxlbWVudGF0aW9uIGhlcmU6DQoNCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAxOTA1MzEwNjM2NDUuNDY5Ny00LW5hbWl0QHZtd2Fy
ZS5jb20vVC8jbTBhYjVmZTA3OTliYTlmZjBkNDExOTdmMTA5NTY3OWZlMjZhZWJkNTcNCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAxOTA1MzEwNjM2NDUuNDY5Ny00LW5hbWl0QHZtd2Fy
ZS5jb20vVC8jbTdiMzVhOTNkZmZkMjNmYmI3Y2E4MTNjNzk1YTA3NzdkNGNkY2I1MWINCg0K
