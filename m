Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16F3338B0
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 20:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfFCS6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 14:58:39 -0400
Received: from mail-eopbgr750040.outbound.protection.outlook.com ([40.107.75.40]:21249
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbfFCS6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 14:58:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPLloLNsKW1cL+HWEfzGNNuCF2nAeJ5BpQY5PL+F/9E=;
 b=rdI5nELGaqY5isDhL77BPUTcy/FfsqIlQs6fJXFZF7l5r6sVgQnSeXbP8DbrwM5LK+zRyQtFgUbsqM1heTCeP7+w/YucnGutI+PsuZm9gdRFyvlodISAP8EKqHmi0zykjYZYNBvlwibSwcxBfOG2T2pIj6LTwp4LCnk0wEqFk6k=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3755.namprd12.prod.outlook.com (10.255.172.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.18; Mon, 3 Jun 2019 18:58:33 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::308d:c697:4e8e:13f4]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::308d:c697:4e8e:13f4%4]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 18:58:33 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     =?utf-8?B?SmFuIEguIFNjaMO2bmhlcnI=?= <jschoenh@amazon.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
Subject: Re: [PATCH 6/6] svm: Temporary deactivate AVIC during ExtINT handling
Thread-Topic: [PATCH 6/6] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Index: AQHU4KZzfF+I1STPkEG8oeMRWodS5qZhyCUAgCjzOAA=
Date:   Mon, 3 Jun 2019 18:58:33 +0000
Message-ID: <5f86b2ac-3a62-ab3d-ea00-59f1aaafa3f1@amd.com>
References: <20190322115702.10166-1-suravee.suthikulpanit@amd.com>
 <20190322115702.10166-7-suravee.suthikulpanit@amd.com>
 <a31f3f85-d94c-b139-ec69-d148dae5c67f@amazon.de>
In-Reply-To: <a31f3f85-d94c-b139-ec69-d148dae5c67f@amazon.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN6PR2101CA0024.namprd21.prod.outlook.com
 (2603:10b6:805:106::34) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2011fc0-8483-4048-5808-08d6e855799b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3755;
x-ms-traffictypediagnostic: DM6PR12MB3755:
x-microsoft-antispam-prvs: <DM6PR12MB3755C294D089D34346870E8CF3140@DM6PR12MB3755.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(396003)(366004)(376002)(189003)(199004)(65806001)(229853002)(110136005)(54906003)(2501003)(2201001)(68736007)(4326008)(65956001)(31696002)(86362001)(3846002)(6116002)(72206003)(66066001)(81156014)(76176011)(52116002)(25786009)(316002)(8936002)(26005)(66574012)(386003)(102836004)(2906002)(53546011)(486006)(81166006)(6506007)(36756003)(478600001)(71200400001)(476003)(58126008)(66556008)(66446008)(14444005)(66946007)(256004)(73956011)(66476007)(99286004)(2616005)(8676002)(6512007)(31686004)(186003)(53936002)(64756008)(5660300002)(6436002)(65826007)(446003)(71190400001)(7736002)(305945005)(14454004)(64126003)(6246003)(6486002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3755;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +YjZZi/DOJF4POmD5jZ59aEiHmsV8plXTsdhj+GEQd3XCmhxfL4/ZRqYXFiIlvqKMn4DbGOw9wEbvNdwCmsfA8alYjo4l6y+dflQ9pXCgkWnjOCaf5ATSvhH4fce04ZLVqn6ia7C30GGW7v82UGYZIQkSz3WDPLeT0Hpao9fbjm2/yjSEyUpr/XnwypyY+QqUJ/ST8opWvGJI0+yJ89Vi80x+nowgX3tZkeEZFQcAns88wCfwumDYycnRVBVOgJxd1UhYtTnGmm4r1O+wOmCX7DJgPHwVrdey66mSM+E+L0OBWL8CWwuQfmUbfMqWrDFki5F6GKXogrGqdRoCTusjMvbEdUDpGty8Ocp078d3pe6EDjAlIapnlTdH3xPV9HMBN7DTHXGnWfYcMcBUbOA51tezcuGNb6qyDOhFB8R8kw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9CE898BFD2BC445BAE2C891B52BA02C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2011fc0-8483-4048-5808-08d6e855799b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 18:58:33.1530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ssuthiku@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3755
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgSmFuLA0KDQpPbiA1LzgvMTkgMTI6MzcgUE0sIEphbiBILiBTY2jDtm5oZXJyIHdyb3RlOg0K
PiBbQ0FVVElPTjogRXh0ZXJuYWwgRW1haWxdDQo+IA0KPiBIaSBTdXJhdmVlLg0KPiANCj4gSSB3
b25kZXIsIGhvdyB0aGlzIGludGVyYWN0cyB3aXRoIEh5cGVyLVYgU3luSUM7IHNlZSBjb21tZW50
cyBiZWxvdy4NCj4gDQo+IE9uIDIyLzAzLzIwMTkgMTIuNTcsIFN1dGhpa3VscGFuaXQsIFN1cmF2
ZWUgd3JvdGU6DQo+PiBBTUQgQVZJQyBkb2VzIG5vdCBzdXBwb3J0IEV4dElOVC4gVGhlcmVmb3Jl
LCBBVklDIG11c3QgYmUgdGVtcG9yYXJ5DQo+PiBkZWFjdGl2YXRlZCBhbmQgZmFsbCBiYWNrIHRv
IHVzaW5nIGxlZ2FjeSBpbnRlcnJ1cHQgaW5qZWN0aW9uIHZpYQ0KPj4gdklOVFIgYW5kIGludGVy
cnVwdCB3aW5kb3cuDQo+Pg0KPj4gSW50cm9kdWNlIHN2bV9yZXF1ZXN0X2FjdGl2YXRlL2RlYWN0
aXZhdGVfYXZpYygpIGhlbHBlciBmdW5jdGlvbnMsDQo+PiB3aGljaCBoYW5kbGUgc3RlcHMgcmVx
dWlyZWQgdG8gYWN0aXZhdGUvZGVhY3RpdmF0ZSBBVklDLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6
IFN1cmF2ZWUgU3V0aGlrdWxwYW5pdCA8c3VyYXZlZS5zdXRoaWt1bHBhbml0QGFtZC5jb20+DQo+
PiAtLS0NCj4+ICAgYXJjaC94ODYva3ZtL3N2bS5jIHwgNTcgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKy0tLQ0KPj4gICAxIGZpbGUgY2hhbmdlZCwgNTQgaW5zZXJ0
aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3Zt
L3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQo+PiBpbmRleCBmNDFmMzRmNzBkZGUuLjg0MTE2
ZTY4OWQ1ZiAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2t2bS9zdm0uYw0KPj4gKysrIGIvYXJj
aC94ODYva3ZtL3N2bS5jDQo+PiBAQCAtMzkxLDYgKzM5MSw4IEBAIHN0YXRpYyB1OCByc21faW5z
X2J5dGVzW10gPSAiXHgwZlx4YWEiOw0KPj4gICBzdGF0aWMgdm9pZCBzdm1fc2V0X2NyMChzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsIHVuc2lnbmVkIGxvbmcgY3IwKTsNCj4+ICAgc3RhdGljIHZvaWQg
c3ZtX2ZsdXNoX3RsYihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGJvb2wgaW52YWxpZGF0ZV9ncGEp
Ow0KPj4gICBzdGF0aWMgdm9pZCBzdm1fY29tcGxldGVfaW50ZXJydXB0cyhzdHJ1Y3QgdmNwdV9z
dm0gKnN2bSk7DQo+PiArc3RhdGljIHZvaWQgc3ZtX3JlcXVlc3RfYWN0aXZhdGVfYXZpYyhzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPj4gK3N0YXRpYyBib29sIHN2bV9nZXRfZW5hYmxlX2FwaWN2
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+Pg0KPj4gICBzdGF0aWMgaW50IG5lc3RlZF9zdm1f
ZXhpdF9oYW5kbGVkKHN0cnVjdCB2Y3B1X3N2bSAqc3ZtKTsNCj4+ICAgc3RhdGljIGludCBuZXN0
ZWRfc3ZtX2ludGVyY2VwdChzdHJ1Y3QgdmNwdV9zdm0gKnN2bSk7DQo+PiBAQCAtMjEwOSw2ICsy
MTExLDkgQEAgc3RhdGljIHZvaWQgYXZpY19zZXRfcnVubmluZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsIGJvb2wgaXNfcnVuKQ0KPj4gICB7DQo+PiAgICAgICAgc3RydWN0IHZjcHVfc3ZtICpzdm0g
PSB0b19zdm0odmNwdSk7DQo+Pg0KPj4gKyAgICAgaWYgKCFrdm1fdmNwdV9hcGljdl9hY3RpdmUo
dmNwdSkpDQo+PiArICAgICAgICAgICAgIHJldHVybjsNCj4+ICsNCj4+ICAgICAgICBzdm0tPmF2
aWNfaXNfcnVubmluZyA9IGlzX3J1bjsNCj4+ICAgICAgICBpZiAoaXNfcnVuKQ0KPj4gICAgICAg
ICAgICAgICAgYXZpY192Y3B1X2xvYWQodmNwdSwgdmNwdS0+Y3B1KTsNCj4+IEBAIC0yMzU2LDYg
KzIzNjEsMTAgQEAgc3RhdGljIHZvaWQgc3ZtX3ZjcHVfYmxvY2tpbmcoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KQ0KPj4NCj4+ICAgc3RhdGljIHZvaWQgc3ZtX3ZjcHVfdW5ibG9ja2luZyhzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUpDQo+PiAgIHsNCj4+ICsgICAgIGlmIChrdm1fY2hlY2tfcmVxdWVzdChL
Vk1fUkVRX0FQSUNWX0FDVElWQVRFLCB2Y3B1KSkNCj4+ICsgICAgICAgICAgICAga3ZtX3ZjcHVf
YWN0aXZhdGVfYXBpY3YodmNwdSk7DQo+PiArICAgICBpZiAoa3ZtX2NoZWNrX3JlcXVlc3QoS1ZN
X1JFUV9BUElDVl9ERUFDVElWQVRFLCB2Y3B1KSkNCj4+ICsgICAgICAgICAgICAga3ZtX3ZjcHVf
ZGVhY3RpdmF0ZV9hcGljdih2Y3B1KTsNCj4+ICAgICAgICBhdmljX3NldF9ydW5uaW5nKHZjcHUs
IHRydWUpOw0KPj4gICB9DQo+Pg0KPj4gQEAgLTQ1MDUsNiArNDUxNCwxNSBAQCBzdGF0aWMgaW50
IGludGVycnVwdF93aW5kb3dfaW50ZXJjZXB0aW9uKHN0cnVjdCB2Y3B1X3N2bSAqc3ZtKQ0KPj4g
ICB7DQo+PiAgICAgICAga3ZtX21ha2VfcmVxdWVzdChLVk1fUkVRX0VWRU5ULCAmc3ZtLT52Y3B1
KTsNCj4+ICAgICAgICBzdm1fY2xlYXJfdmludHIoc3ZtKTsNCj4+ICsNCj4+ICsgICAgIC8qDQo+
PiArICAgICAgKiBGb3IgQVZJQywgdGhlIG9ubHkgcmVhc29uIHRvIGVuZCB1cCBoZXJlIGlzIEV4
dElOVHMuDQo+PiArICAgICAgKiBJbiB0aGlzIGNhc2UgQVZJQyB3YXMgdGVtcG9yYXJpbHkgZGlz
YWJsZWQgZm9yDQo+PiArICAgICAgKiByZXF1ZXN0aW5nIHRoZSBJUlEgd2luZG93IGFuZCB3ZSBo
YXZlIHRvIHJlLWVuYWJsZSBpdC4NCj4+ICsgICAgICAqLw0KPj4gKyAgICAgaWYgKHN2bV9nZXRf
ZW5hYmxlX2FwaWN2KCZzdm0tPnZjcHUpKQ0KPj4gKyAgICAgICAgICAgICBzdm1fcmVxdWVzdF9h
Y3RpdmF0ZV9hdmljKCZzdm0tPnZjcHUpOw0KPj4gKw0KPiANCj4gQXJlIHdlIHN1cmUsIHdlJ3Jl
IG5vdCBhY2NpZGVudGFsbHkgcmUtZW5hYmxpbmcgQVZJQywgaWYgaXQgd2FzIGRpc2FibGVkIHZp
YQ0KPiBrdm1faHZfYWN0aXZhdGVfc3luaWMoKT8NCg0KQWN0dWFsbHksIEkgbWlzc2VkIHRoaXMg
Y2FzZS4gTm93IEkgaGF2ZSBhIHNvbHV0aW9uIHRoYXQgSSdsbCBiZSBzZW5kIG91dCBmb3IgcmV2
aWV3IGluIFYyLg0KDQo+PiAgICAgICAgc3ZtLT52bWNiLT5jb250cm9sLmludF9jdGwgJj0gflZf
SVJRX01BU0s7DQo+PiAgICAgICAgbWFya19kaXJ0eShzdm0tPnZtY2IsIFZNQ0JfSU5UUik7DQo+
PiAgICAgICAgKytzdm0tPnZjcHUuc3RhdC5pcnFfd2luZG93X2V4aXRzOw0KPj4gQEAgLTUyMDYs
NiArNTIyNCwzNCBAQCBzdGF0aWMgdm9pZCBzdm1faHdhcGljX2lzcl91cGRhdGUoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCBpbnQgbWF4X2lzcikNCj4+ICAgew0KPj4gICB9DQo+Pg0KPj4gK3N0YXRp
YyBib29sIGlzX2F2aWNfYWN0aXZlKHN0cnVjdCB2Y3B1X3N2bSAqc3ZtKQ0KPj4gK3sNCj4+ICsg
ICAgIHJldHVybiAoc3ZtX2dldF9lbmFibGVfYXBpY3YoJnN2bS0+dmNwdSkgJiYNCj4+ICsgICAg
ICAgICAgICAgc3ZtLT52bWNiLT5jb250cm9sLmludF9jdGwgJiBBVklDX0VOQUJMRV9NQVNLKTsN
Cj4+ICt9DQo+PiArDQo+PiArc3RhdGljIHZvaWQgc3ZtX3JlcXVlc3RfYWN0aXZhdGVfYXZpYyhz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiArew0KPj4gKyAgICAgc3RydWN0IHZjcHVfc3ZtICpz
dm0gPSB0b19zdm0odmNwdSk7DQo+PiArDQo+PiArICAgICBpZiAoIWxhcGljX2luX2tlcm5lbCh2
Y3B1KSB8fCBpc19hdmljX2FjdGl2ZShzdm0pKQ0KPj4gKyAgICAgICAgICAgICByZXR1cm47DQo+
PiArDQo+PiArICAgICBhdmljX3NldHVwX2FjY2Vzc19wYWdlKHZjcHUsIGZhbHNlKTsNCj4+ICsg
ICAgIGt2bV9tYWtlX2FwaWN2X2FjdGl2YXRlX3JlcXVlc3QodmNwdS0+a3ZtKTsNCj4+ICt9DQo+
PiArDQo+PiArc3RhdGljIHZvaWQgc3ZtX3JlcXVlc3RfZGVhY3RpdmF0ZV9hdmljKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkNCj4+ICt7DQo+PiArICAgICBzdHJ1Y3QgdmNwdV9zdm0gKnN2bSA9IHRv
X3N2bSh2Y3B1KTsNCj4+ICsNCj4+ICsgICAgIGlmICghbGFwaWNfaW5fa2VybmVsKHZjcHUpIHx8
ICFpc19hdmljX2FjdGl2ZShzdm0pKQ0KPj4gKyAgICAgICAgICAgICByZXR1cm47DQo+PiArDQo+
PiArICAgICBhdmljX2Rlc3Ryb3lfYWNjZXNzX3BhZ2UodmNwdSk7DQo+IA0KPiBTb21ldGhpbmcg
bGlrZSBhdmljX2Rlc3Ryb3lfYWNjZXNzX3BhZ2UoKSBpcyBub3QgY2FsbGVkLCB3aGVuIEFWSUMg
aXMNCj4gZGlzYWJsZWQgdmlhIGt2bV9odl9hY3RpdmF0ZV9zeW5pYygpLg0KPiANCj4gSXMgdGhh
dCBhbiBvdmVyc2lnaHQgaW4gdGhlIG90aGVyIGNvZGUgcGF0aCwgaXMgaXQgbm90IG5lZWRlZCBo
ZXJlLA0KPiBvciBhbSBJIG1pc3Npbmcgc29tZXRoaW5nPw0KDQpUaGlzIGlzIGFuIG92ZXJzaWdo
dC4gSSBhbHNvIGhhdmUgYSBmaXggZm9yIHRoaXMgaW4gVjIuDQoNClRoYW5rcywNClN1cmF2ZWUN
Cg==
