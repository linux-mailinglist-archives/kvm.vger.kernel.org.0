Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0985A55F1C
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 04:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfFZCjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 22:39:49 -0400
Received: from mail-eopbgr750058.outbound.protection.outlook.com ([40.107.75.58]:26912
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726374AbfFZCjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 22:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDebp5rsidi3yRC1mn09WihsNyuyFvf+pvaI1gTET2E=;
 b=RxqACXn47HxQsjyYWvtbWFx4++qh0S/gkFInFCBgZeX5c5tLKRcgd4IRXJe/dg1IV41TBJrhHYDf0IOOyBbP8iBgPH1kWA5LQ5SGsaFGoHX1I3W20n/WbbveDZ3lfNKdjBWADBgpO0DpR39eK0+1VYt5ZhTWL6r7FndpzXYrteI=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB5110.namprd05.prod.outlook.com (20.177.231.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.12; Wed, 26 Jun 2019 02:39:45 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58%7]) with mapi id 15.20.2008.007; Wed, 26 Jun 2019
 02:39:45 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Dave Hansen <dave.hansen@intel.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/9] KVM: x86: Provide paravirtualized flush_tlb_multi()
Thread-Topic: [PATCH 6/9] KVM: x86: Provide paravirtualized flush_tlb_multi()
Thread-Index: AQHVIbQq2DFUsKveqk6vAXwf0z5KPqas+eUAgABThoA=
Date:   Wed, 26 Jun 2019 02:39:45 +0000
Message-ID: <401C4384-98A1-4C27-8F71-4848F4B4A440@vmware.com>
References: <20190613064813.8102-1-namit@vmware.com>
 <20190613064813.8102-7-namit@vmware.com>
 <cb28f2b4-92f0-f075-648e-dddfdbdd2e3c@intel.com>
In-Reply-To: <cb28f2b4-92f0-f075-648e-dddfdbdd2e3c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [204.134.128.110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bef4cc8-a56d-4dfa-5e39-08d6f9df8d0d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB5110;
x-ms-traffictypediagnostic: BYAPR05MB5110:
x-microsoft-antispam-prvs: <BYAPR05MB51102A8C145E0F871B8C4E71D0E20@BYAPR05MB5110.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(376002)(396003)(366004)(189003)(199004)(54534003)(229853002)(6506007)(91956017)(102836004)(2906002)(7736002)(14454004)(76176011)(26005)(4326008)(54906003)(478600001)(316002)(305945005)(7416002)(8676002)(53546011)(446003)(8936002)(486006)(25786009)(66946007)(99286004)(6916009)(86362001)(476003)(2616005)(33656002)(81166006)(11346002)(66446008)(76116006)(68736007)(71190400001)(256004)(66476007)(64756008)(81156014)(71200400001)(66556008)(66066001)(6512007)(6486002)(36756003)(6436002)(186003)(3846002)(73956011)(5660300002)(6246003)(6116002)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5110;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: w22ghgS7uPsPW/OUWlMwRmy0XLH6oU4wazqEqBS8I1w2D0VkOR47S7YJSa3Yp3r3CWX/u+famYXxGfOMCz18QJCw2GU7LpetCZgfibIltor0rFQhhq/UGmgb8RQgwiEz/TyOhC9wo9fmpRav+t8d0Gv2HAYsXAvOoq2rgf6jErJvn1m+CFNajk2xKi1AdAccuTDXb2gbO0oPHsddP87d+EU5v60ixUr1YW5BmzB/nZ702spdnDmLerJHr/B0hzMvCMcv1pvA4mCfQHT9p0MvzqmHRwdvKLxYt+iGe30hArO4PqU0NtVwbn+5ZzGPhMdi38nm+eKwnexpi2r2vYpueVukDugAjInToy3VNqTAiw+8a7uHVT5SYd9Vva5EUYOWMwI4i5awBXHT96dYEnruUjGff36swEWJXZLKIZRNSG4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65D17E2574CECD4B8076A2BF50BFA818@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bef4cc8-a56d-4dfa-5e39-08d6f9df8d0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 02:39:45.8041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdW4gMjUsIDIwMTksIGF0IDI6NDAgUE0sIERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBp
bnRlbC5jb20+IHdyb3RlOg0KPiANCj4gT24gNi8xMi8xOSAxMTo0OCBQTSwgTmFkYXYgQW1pdCB3
cm90ZToNCj4+IFN1cHBvcnQgdGhlIG5ldyBpbnRlcmZhY2Ugb2YgZmx1c2hfdGxiX211bHRpLCB3
aGljaCBhbHNvIGZsdXNoZXMgdGhlDQo+PiBsb2NhbCBDUFUncyBUTEIsIGluc3RlYWQgb2YgZmx1
c2hfdGxiX290aGVycyB0aGF0IGRvZXMgbm90LiBUaGlzDQo+PiBpbnRlcmZhY2UgaXMgbW9yZSBw
ZXJmb3JtYW50IHNpbmNlIGl0IHBhcmFsbGVsaXplIHJlbW90ZSBhbmQgbG9jYWwgVExCDQo+PiBm
bHVzaGVzLg0KPj4gDQo+PiBUaGUgYWN0dWFsIGltcGxlbWVudGF0aW9uIG9mIGZsdXNoX3RsYl9t
dWx0aSgpIGlzIGFsbW9zdCBpZGVudGljYWwgdG8NCj4+IHRoYXQgb2YgZmx1c2hfdGxiX290aGVy
cygpLg0KPiANCj4gVGhpcyBjb25mdXNlZCBtZSBhIGJpdC4gIEkgdGhvdWdodCB3ZSBkaWRuJ3Qg
c3VwcG9ydCBwYXJhdmlydHVhbGl6ZWQNCj4gZmx1c2hfdGxiX211bHRpKCkgZnJvbSByZWFkaW5n
IGVhcmxpZXIgaW4gdGhlIHNlcmllcy4NCj4gDQo+IEJ1dCwgaXQgc2VlbXMgbGlrZSB0aGF0IG1p
Z2h0IGJlIFhlbi1vbmx5IGFuZCBkb2Vzbid0IGFwcGx5IHRvIEtWTSBhbmQNCj4gcGFyYXZpcnR1
YWxpemVkIEtWTSBoYXMgbm8gcHJvYmxlbSBzdXBwb3J0aW5nIGZsdXNoX3RsYl9tdWx0aSgpLiAg
SXMNCj4gdGhhdCByaWdodD8gIEl0IG1pZ2h0IGJlIGdvb2QgdG8gaW5jbHVkZSBzb21lIG9mIHRo
YXQgYmFja2dyb3VuZCBpbiB0aGUNCj4gY2hhbmdlbG9nIHRvIHNldCB0aGUgY29udGV4dC4NCg0K
SeKAmWxsIHRyeSB0byBpbXByb3ZlIHRoZSBjaGFuZ2UtbG9ncyBhIGJpdC4gVGhlcmUgaXMgbm8g
aW5oZXJlbnQgcmVhc29uIGZvcg0KUFYgVExCLWZsdXNoZXJzIG5vdCB0byBpbXBsZW1lbnQgdGhl
aXIgb3duIGZsdXNoX3RsYl9tdWx0aSgpLiBJdCBpcyBsZWZ0DQpmb3IgZnV0dXJlIHdvcmssIGFu
ZCBoZXJlIGFyZSBzb21lIHJlYXNvbnM6DQoNCjEuIEh5cGVyLVYvWGVuIFRMQi1mbHVzaGluZyBj
b2RlIGlzIG5vdCB2ZXJ5IHNpbXBsZQ0KMi4gSSBkb27igJl0IGhhdmUgYSBwcm9wZXIgc2V0dXAN
CjMuIEkgYW0gbGF6eQ0KDQoNCg==
