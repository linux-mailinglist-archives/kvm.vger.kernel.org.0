Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D401709B0
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 21:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfGVT1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 15:27:13 -0400
Received: from mail-eopbgr820080.outbound.protection.outlook.com ([40.107.82.80]:40939
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727302AbfGVT1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 15:27:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6OVc89/kz6iC1spjoQP4xFV/pUJxlnCxyxbnyGCjTR8sO/MUSgvyx/fUXZlzSFPS+36DWT3HKqtUmmiA0HQ6gLMcfI9IyQ07YxwUTgQkAc8iMICe49HDbcUsUbYNmZDhm/V48LcBTMYr6GXa0zsQPF4I85xLtJRWP1kRUun+mGxNPp6RQ/q8XSDSC0VnVFIBdyd6RizrZSdeCEQOFHQmQRSzCbT5G5fHfuBIpziOr5e+/fBX6EYXFbAFmutSMrVsp71yXonyA/uulrBJL2/yvfHFMbPtNU0zPvihOoM3c9lxgKpXL5KCJpY5Jgffuj1FcPX7yYO0FXgAd/yNPoq3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1YLJcWtnu++hveXk+I6g3Fyn5VrINS0NOdrYgR+RvQ=;
 b=kUFTsJKSntRoeSoNSd+Ne5j6vmXdc8pDKk8xmkujpeH8fqmrPVN48v3fUaEqw2rNGZxnHF1JyL6aaUgv0nnApVf4K6BYzyGwrd13BHVqVcm69UYV0sej62/PnqApPjaLNzRbPs32dx72bhXDUTL4n++/iGtmMKidtquzO7zAyHBuA1lGZVARuVpvsq3LJm7cOlBSOtyszC21LAZbAqV8T+ue7uuIYekB2zPYVudSEyiRBftyCVdwZzf82KPm0pAWGiHNHwar1vCpd770HQBfXXuD90Aca2yk4qL2WJmVUvORqU/jYCLts+At7dogM/nlBYSyixzix9j+ZhojgaKICw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=vmware.com;dmarc=pass action=none
 header.from=vmware.com;dkim=pass header.d=vmware.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1YLJcWtnu++hveXk+I6g3Fyn5VrINS0NOdrYgR+RvQ=;
 b=C5JYgVhswWIDVCQ371HymHx9RfIq0wn/waGfyrPiMn9QPjY2cdb/p1GN9kxknCb23Kb/byk1ssbs1TSQenEQ9uNV26RqjDNYkuc7G9caQHIC9KbrzBm6Ne7DwNawkODoKA431Jwn8F6SnCy8Jfa/iWgkyKq6I2sMesFFLdUHEUc=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB5512.namprd05.prod.outlook.com (20.177.186.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.8; Mon, 22 Jul 2019 19:27:09 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::e00b:cb41:8ed6:b718]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::e00b:cb41:8ed6:b718%2]) with mapi id 15.20.2115.005; Mon, 22 Jul 2019
 19:27:09 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH v3 4/9] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Thread-Topic: [PATCH v3 4/9] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Thread-Index: AQHVPc0sd/du+pBr/Ei/BI33xg03qabXB8iAgAADhAA=
Date:   Mon, 22 Jul 2019 19:27:09 +0000
Message-ID: <58DA0841-33C2-4D16-A671-08064A15001C@vmware.com>
References: <20190719005837.4150-1-namit@vmware.com>
 <20190719005837.4150-5-namit@vmware.com>
 <20190722191433.GD6698@worktop.programming.kicks-ass.net>
In-Reply-To: <20190722191433.GD6698@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f14a5f2-10b3-4235-4e91-08d70eda9733
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB5512;
x-ms-traffictypediagnostic: BYAPR05MB5512:
x-microsoft-antispam-prvs: <BYAPR05MB55124EB2EB082FC38EEC1317D0C40@BYAPR05MB5512.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(189003)(199004)(54906003)(7416002)(25786009)(102836004)(33656002)(76176011)(6506007)(26005)(81166006)(186003)(53546011)(478600001)(8936002)(81156014)(66066001)(305945005)(7736002)(476003)(76116006)(229853002)(66476007)(66556008)(64756008)(99286004)(66946007)(316002)(2906002)(486006)(36756003)(5660300002)(66446008)(8676002)(6916009)(2616005)(6512007)(68736007)(71200400001)(71190400001)(11346002)(14444005)(6486002)(6116002)(256004)(14454004)(6246003)(53936002)(4326008)(6436002)(3846002)(446003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5512;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t8PFk57PO+CBnWG4QUotQweR5Zh6Zo+PdoiBJ/761np8Ur38XwznZaVJ2qEAwMffcpyCzthc40W4w/CL6qkSy0G5s6t2vEw8AxDGrBhSklVjMZ4QMhauPJDZ7tOF3L0kovu7oUdhC5B0AcNP5s6JsyQPCIrytAE4FHsuiFjYg/r8kL3Mwraot1Poz7WKDsM4G8Qp1/3XRD6eNR3ZhNAMlEkrCFFIobYNmogDJ3vNgQpq6vkmxfnZisAcVEZPDYcLgIYxuqjJTD4c4gfXQ+2oNTUhGx4GJtjl4L5kpISAfhL6fsRAPakLvorTnk/fZRLckWU5c99/Qi90vhpwVepg0Oy9MKUZEO/P8T2UA/tsmi0s28GBaJPqoWTkMIiK4Q+M21BR6QeEdhetOzKvAnTG0arHQ6F/IhtLbuZV8kz4Iv8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A65B5E7E822C34B830FEF5BE20B7A60@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f14a5f2-10b3-4235-4e91-08d70eda9733
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 19:27:09.6577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5512
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdWwgMjIsIDIwMTksIGF0IDEyOjE0IFBNLCBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGlu
ZnJhZGVhZC5vcmc+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBKdWwgMTgsIDIwMTkgYXQgMDU6NTg6
MzJQTSAtMDcwMCwgTmFkYXYgQW1pdCB3cm90ZToNCj4+IEBAIC03MDksOCArNzE2LDkgQEAgdm9p
ZCBuYXRpdmVfZmx1c2hfdGxiX290aGVycyhjb25zdCBzdHJ1Y3QgY3B1bWFzayAqY3B1bWFzaywN
Cj4+IAkgKiBkb2luZyBhIHNwZWN1bGF0aXZlIG1lbW9yeSBhY2Nlc3MuDQo+PiAJICovDQo+PiAJ
aWYgKGluZm8tPmZyZWVkX3RhYmxlcykgew0KPj4gLQkJc21wX2NhbGxfZnVuY3Rpb25fbWFueShj
cHVtYXNrLCBmbHVzaF90bGJfZnVuY19yZW1vdGUsDQo+PiAtCQkJICAgICAgICh2b2lkICopaW5m
bywgMSk7DQo+PiArCQlfX3NtcF9jYWxsX2Z1bmN0aW9uX21hbnkoY3B1bWFzaywgZmx1c2hfdGxi
X2Z1bmNfcmVtb3RlLA0KPj4gKwkJCQkJIGZsdXNoX3RsYl9mdW5jX2xvY2FsLA0KPj4gKwkJCQkJ
ICh2b2lkICopaW5mbywgMSk7DQo+PiAJfSBlbHNlIHsNCj4+IAkJLyoNCj4+IAkJICogQWx0aG91
Z2ggd2UgY291bGQgaGF2ZSB1c2VkIG9uX2VhY2hfY3B1X2NvbmRfbWFzaygpLA0KPj4gQEAgLTcz
Nyw3ICs3NDUsOCBAQCB2b2lkIG5hdGl2ZV9mbHVzaF90bGJfb3RoZXJzKGNvbnN0IHN0cnVjdCBj
cHVtYXNrICpjcHVtYXNrLA0KPj4gCQkJaWYgKHRsYl9pc19ub3RfbGF6eShjcHUpKQ0KPj4gCQkJ
CV9fY3B1bWFza19zZXRfY3B1KGNwdSwgY29uZF9jcHVtYXNrKTsNCj4+IAkJfQ0KPj4gLQkJc21w
X2NhbGxfZnVuY3Rpb25fbWFueShjb25kX2NwdW1hc2ssIGZsdXNoX3RsYl9mdW5jX3JlbW90ZSwN
Cj4+ICsJCV9fc21wX2NhbGxfZnVuY3Rpb25fbWFueShjb25kX2NwdW1hc2ssIGZsdXNoX3RsYl9m
dW5jX3JlbW90ZSwNCj4+ICsJCQkJCSBmbHVzaF90bGJfZnVuY19sb2NhbCwNCj4+IAkJCQkJICh2
b2lkICopaW5mbywgMSk7DQo+PiAJfQ0KPj4gfQ0KPiANCj4gRG8gd2UgcmVhbGx5IG5lZWQgdGhh
dCBfbG9jYWwvX3JlbW90ZSBkaXN0aW5jdGlvbj8gSVNUUiB5b3UgaGFkIGEgcGF0Y2gNCj4gdGhh
dCBmcm9iYmVkIGZsdXNoX3RsYl9pbmZvIGludG8gdGhlIGNzZCBhbmQgdGhhdCBnYXZlIHNwYWNl
DQo+IGNvbnN0cmFpbnRzLCBidXQgSSdtIG5vdCBzZWVpbmcgdGhhdCBoZXJlIChwcm9iYWJseSBh
IHdpc2UsIGdldCBzdHVmZg0KPiBtZXJnZWQgZXRjLi4pLg0KPiANCj4gc3RydWN0IF9fY2FsbF9z
aW5nbGVfZGF0YSB7DQo+ICAgICAgICBzdHJ1Y3QgbGxpc3Rfbm9kZSAgICAgICAgICBsbGlzdDsg
ICAgICAgICAgICAgICAgLyogICAgIDAgICAgIDggKi8NCj4gICAgICAgIHNtcF9jYWxsX2Z1bmNf
dCAgICAgICAgICAgIGZ1bmM7ICAgICAgICAgICAgICAgICAvKiAgICAgOCAgICAgOCAqLw0KPiAg
ICAgICAgdm9pZCAqICAgICAgICAgICAgICAgICAgICAgaW5mbzsgICAgICAgICAgICAgICAgIC8q
ICAgIDE2ICAgICA4ICovDQo+ICAgICAgICB1bnNpZ25lZCBpbnQgICAgICAgICAgICAgICBmbGFn
czsgICAgICAgICAgICAgICAgLyogICAgMjQgICAgIDQgKi8NCj4gDQo+ICAgICAgICAvKiBzaXpl
OiAzMiwgY2FjaGVsaW5lczogMSwgbWVtYmVyczogNCAqLw0KPiAgICAgICAgLyogcGFkZGluZzog
NCAqLw0KPiAgICAgICAgLyogbGFzdCBjYWNoZWxpbmU6IDMyIGJ5dGVzICovDQo+IH07DQo+IA0K
PiBzdHJ1Y3QgZmx1c2hfdGxiX2luZm8gew0KPiAgICAgICAgc3RydWN0IG1tX3N0cnVjdCAqICAg
ICAgICAgbW07ICAgICAgICAgICAgICAgICAgIC8qICAgICAwICAgICA4ICovDQo+ICAgICAgICBs
b25nIHVuc2lnbmVkIGludCAgICAgICAgICBzdGFydDsgICAgICAgICAgICAgICAgLyogICAgIDgg
ICAgIDggKi8NCj4gICAgICAgIGxvbmcgdW5zaWduZWQgaW50ICAgICAgICAgIGVuZDsgICAgICAg
ICAgICAgICAgICAvKiAgICAxNiAgICAgOCAqLw0KPiAgICAgICAgdTY0ICAgICAgICAgICAgICAg
ICAgICAgICAgbmV3X3RsYl9nZW47ICAgICAgICAgIC8qICAgIDI0ICAgICA4ICovDQo+ICAgICAg
ICB1bnNpZ25lZCBpbnQgICAgICAgICAgICAgICBzdHJpZGVfc2hpZnQ7ICAgICAgICAgLyogICAg
MzIgICAgIDQgKi8NCj4gICAgICAgIGJvb2wgICAgICAgICAgICAgICAgICAgICAgIGZyZWVkX3Rh
YmxlczsgICAgICAgICAvKiAgICAzNiAgICAgMSAqLw0KPiANCj4gICAgICAgIC8qIHNpemU6IDQw
LCBjYWNoZWxpbmVzOiAxLCBtZW1iZXJzOiA2ICovDQo+ICAgICAgICAvKiBwYWRkaW5nOiAzICov
DQo+ICAgICAgICAvKiBsYXN0IGNhY2hlbGluZTogNDAgYnl0ZXMgKi8NCj4gfTsNCj4gDQo+IElJ
UkMgd2hhdCB5b3UgZGlkIHdhcyBtYWtlIHZvaWQgKl9fY2FsbF9zaW5nbGVfZGF0YTo6aW5mbyB0
aGUgbGFzdA0KPiBtZW1iZXIgYW5kIGEgdW5pb24gdW50aWwgdGhlIGZ1bGwgY2FjaGVsaW5lIHNp
emUgKDY0KS4gR2l2ZW4gdGhlIGFib3ZlDQo+IHRoYXQgd291bGQgZ2V0IHVzIDI0IGJ5dGVzIGZv
ciBjc2QsIGxlYXZpbmcgdXMgNDAgZm9yIHRoYXQNCj4gZmx1c2hfdGxiX2luZm8uDQo+IA0KPiBC
dXQgdGhlbiB3ZSBjYW4gc3RpbGwgZG8gc29tZXRoaW5nIGxpa2UgdGhlIGJlbG93LCB3aGljaCBk
b2Vzbid0IGNoYW5nZQ0KPiB0aGluZ3MgYW5kIHN0aWxsIGdldHMgcmlkIG9mIHRoYXQgZHVhbCBm
dW5jdGlvbiBjcnVkLCBzaW1wbGlmeWluZw0KPiBzbXBfY2FsbF9mdW5jdGlvbl9tYW55IGFnYWlu
Lg0KPiANCj4gSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90bGJmbHVzaC5o
DQo+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0NCj4gLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2luY2x1ZGUvYXNt
L3RsYmZsdXNoLmgNCj4gKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90bGJmbHVz
aC5oDQo+IEBAIC01NDYsOCArNTQ2LDkgQEAgc3RydWN0IGZsdXNoX3RsYl9pbmZvIHsNCj4gCXVu
c2lnbmVkIGxvbmcJCXN0YXJ0Ow0KPiAJdW5zaWduZWQgbG9uZwkJZW5kOw0KPiAJdTY0CQkJbmV3
X3RsYl9nZW47DQo+IC0JdW5zaWduZWQgaW50CQlzdHJpZGVfc2hpZnQ7DQo+IC0JYm9vbAkJCWZy
ZWVkX3RhYmxlczsNCj4gKwl1bnNpZ25lZCBpbnQJCWNwdTsNCj4gKwl1bnNpZ25lZCBzaG9ydAkJ
c3RyaWRlX3NoaWZ0Ow0KPiArCXVuc2lnbmVkIGNoYXIJCWZyZWVkX3RhYmxlczsNCj4gfTsNCj4g
DQo+ICNkZWZpbmUgbG9jYWxfZmx1c2hfdGxiKCkgX19mbHVzaF90bGIoKQ0KPiBJbmRleDogbGlu
dXgtMi42L2FyY2gveDg2L21tL3RsYi5jDQo+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gLS0tIGxpbnV4LTIuNi5v
cmlnL2FyY2gveDg2L21tL3RsYi5jDQo+ICsrKyBsaW51eC0yLjYvYXJjaC94ODYvbW0vdGxiLmMN
Cj4gQEAgLTY1OSw2ICs2NTksMjcgQEAgc3RhdGljIHZvaWQgZmx1c2hfdGxiX2Z1bmNfcmVtb3Rl
KHZvaWQgKg0KPiAJZmx1c2hfdGxiX2Z1bmNfY29tbW9uKGYsIGZhbHNlLCBUTEJfUkVNT1RFX1NI
T09URE9XTik7DQo+IH0NCj4gDQo+ICtzdGF0aWMgdm9pZCBmbHVzaF90bGJfZnVuYyh2b2lkICpp
bmZvKQ0KPiArew0KPiArCWNvbnN0IHN0cnVjdCBmbHVzaF90bGJfaW5mbyAqZiA9IGluZm87DQo+
ICsJZW51bSB0bGJfZmx1c2hfcmVhc29uIHJlYXNvbiA9IFRMQl9SRU1PVEVfU0hPT1RET1dOOw0K
PiArCWJvb2wgbG9jYWwgPSBmYWxzZTsNCj4gKw0KPiArCWlmIChmLT5jcHUgPT0gc21wX3Byb2Nl
c3Nvcl9pZCgpKSB7DQo+ICsJCWxvY2FsID0gdHJ1ZTsNCj4gKwkJcmVhc29uID0gKGYtPm1tID09
IE5VTEwpID8gVExCX0xPQ0FMX1NIT09URE9XTiA6IFRMQl9MT0NBTF9NTV9TSE9PVERPV047DQo+
ICsJfSBlbHNlIHsNCj4gKwkJaW5jX2lycV9zdGF0KGlycV90bGJfY291bnQpOw0KPiArDQo+ICsJ
CWlmIChmLT5tbSAmJiBmLT5tbSAhPSB0aGlzX2NwdV9yZWFkKGNwdV90bGJzdGF0ZS5sb2FkZWRf
bW0pKQ0KPiArCQkJcmV0dXJuOw0KPiArDQo+ICsJCWNvdW50X3ZtX3RsYl9ldmVudChOUl9UTEJf
UkVNT1RFX0ZMVVNIX1JFQ0VJVkVEKTsNCj4gKwl9DQo+ICsNCj4gKwlmbHVzaF90bGJfZnVuY19j
b21tb24oZiwgbG9jYWwsIHJlYXNvbik7DQo+ICt9DQo+ICsNCj4gc3RhdGljIGJvb2wgdGxiX2lz
X25vdF9sYXp5KGludCBjcHUpDQo+IHsNCj4gCXJldHVybiAhcGVyX2NwdShjcHVfdGxic3RhdGVf
c2hhcmVkLmlzX2xhenksIGNwdSk7DQoNCk5pY2UhIEkgd2lsbCBhZGQgaXQgb24gdG9wLCBpZiB5
b3UgZG9u4oCZdCBtaW5kIChpbnN0ZWFkIHNxdWFzaGluZyBpdCkuDQoNClRoZSBvcmlnaW5hbCBk
ZWNpc2lvbiB0byBoYXZlIGxvY2FsL3JlbW90ZSBmdW5jdGlvbnMgd2FzIG1vc3RseSB0byBwcm92
aWRlDQp0aGUgZ2VuZXJhbGl0eS4NCg0KSSB3b3VsZCBjaGFuZ2UgdGhlIGxhc3QgYXJndW1lbnQg
b2YgX19zbXBfY2FsbF9mdW5jdGlvbl9tYW55KCkgZnJvbSDigJx3YWl04oCdDQp0byDigJxmbGFn
c+KAnSB0aGF0IHdvdWxkIGluZGljYXRlIHdoZXRoZXIgdG8gcnVuIHRoZSBmdW5jdGlvbiBsb2Nh
bGx5LCBzaW5jZSBJDQpkb27igJl0IHdhbnQgdG8gY2hhbmdlIHRoZSBzZW1hbnRpY3Mgb2Ygc21w
X2NhbGxfZnVuY3Rpb25fbWFueSgpIGFuZCBkZWNpZGUNCndoZXRoZXIgdG8gcnVuIHRoZSBmdW5j
dGlvbiBsb2NhbGx5IHB1cmVseSBiYXNlZCBvbiB0aGUgbWFzay4gTGV0IG1lIGtub3cgaWYNCnlv
dSBkaXNhZ3JlZS4=
