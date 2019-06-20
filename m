Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9534D3F7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 18:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732227AbfFTQj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 12:39:27 -0400
Received: from mail-eopbgr770088.outbound.protection.outlook.com ([40.107.77.88]:38590
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732193AbfFTQjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 12:39:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbtNYxLxGV8f6QaGQ4ahAqBMG7VRpdsSTa+UoFQ2y9c=;
 b=R8544UScaXHdQ/3ocFMQfllL7LwKnKopZhcZTp68cCkrMSiJkMOgqEfzMuKhrJQ+X59t7+8mMBCxUJ0bQgb/K2iNXTW2OXm62lnYMDhx1SFChrH4GT2TX+u6ULoNs15tkmK/FTSwedMFN92pe9d3i3DKvf+Vou+xtkpYEUdYWfU=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3914.namprd12.prod.outlook.com (10.255.174.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Thu, 20 Jun 2019 16:38:59 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 16:38:59 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 11/11] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP
 ioctl
Thread-Topic: [RFC PATCH v2 11/11] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP
 ioctl
Thread-Index: AQHVJ4apDh2KKU1Q4k6H2coLOcAvZw==
Date:   Thu, 20 Jun 2019 16:38:59 +0000
Message-ID: <20190620163832.5451-12-brijesh.singh@amd.com>
References: <20190620163832.5451-1-brijesh.singh@amd.com>
In-Reply-To: <20190620163832.5451-1-brijesh.singh@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR15CA0055.namprd15.prod.outlook.com
 (2603:10b6:3:ae::17) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0911ff85-c080-47b3-7833-08d6f59dcb73
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3914;
x-ms-traffictypediagnostic: DM6PR12MB3914:
x-microsoft-antispam-prvs: <DM6PR12MB3914A762203BA3C21FD2B55EE5E40@DM6PR12MB3914.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(52116002)(54906003)(86362001)(305945005)(256004)(6916009)(71190400001)(2501003)(71200400001)(6116002)(2906002)(25786009)(6512007)(53936002)(66446008)(6506007)(5640700003)(386003)(7416002)(14444005)(2351001)(66476007)(66556008)(7736002)(486006)(5660300002)(11346002)(476003)(99286004)(446003)(73956011)(68736007)(8936002)(6436002)(66946007)(478600001)(64756008)(4326008)(6486002)(3846002)(36756003)(66066001)(1730700003)(14454004)(81166006)(1076003)(102836004)(66574012)(81156014)(50226002)(186003)(8676002)(26005)(316002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3914;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KatWGLYB+7UqoA2xSrDvHAEJL3jWBc4+ZH1EH7cNaFzEy2S6AGCryERM54YsSnHN3eeVZalgYfWmcjJ/EZgGw7ptlQ6hpLM3FcjQOzCbEqjTFTlw0iME0ScOlJRV6ZmGX2Ia/BjoEhAVpQ0EhJxFgqVeke2jHwiFX9KkRCgIRz4nsprB/LPGTvP+I9yDOWeWFK8I97ZeuoS91yqomYgXzFJ8QrAvYZ+dkSVRheTiwdaQd1GNXENFHXO+1vlCfVxvi1NjiEk0q10koJPebPIzqSPvK2PwsAJ+JjobagwvaAWrEBjQ9zyHps5Va7+pt2ioQVKn/xKFIWQu/tS60xj4X2a1g/S/fgcw3qdm+xA4bfnyDKt1BXPsn4xbX+KOb1528wS50vAKbWIwiVudj766sfnr8GNK957h7W4iJf9tmN8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF4D60EFFDB02341ADE4FED20BE42CCE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0911ff85-c080-47b3-7833-08d6f59dcb73
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 16:38:59.6164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3914
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlIGlvY3RsIGNhbiBiZSB1c2VkIHRvIHNldCBwYWdlIGVuY3J5cHRpb24gYml0bWFwIGZvciBh
bg0KaW5jb21pbmcgZ3Vlc3QuDQoNCkNjOiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25p
eC5kZT4NCkNjOiBJbmdvIE1vbG5hciA8bWluZ29AcmVkaGF0LmNvbT4NCkNjOiAiSC4gUGV0ZXIg
QW52aW4iIDxocGFAenl0b3IuY29tPg0KQ2M6IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhh
dC5jb20+DQpDYzogIlJhZGltIEtyxI1tw6HFmSIgPHJrcmNtYXJAcmVkaGF0LmNvbT4NCkNjOiBK
b2VyZyBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz4NCkNjOiBCb3Jpc2xhdiBQZXRrb3YgPGJwQHN1
c2UuZGU+DQpDYzogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1kLmNvbT4NCkNjOiB4
ODZAa2VybmVsLm9yZw0KQ2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCkNjOiBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnDQpTaWduZWQtb2ZmLWJ5OiBCcmlqZXNoIFNpbmdoIDxicmlqZXNoLnNp
bmdoQGFtZC5jb20+DQotLS0NCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgIDEg
Kw0KIGFyY2gveDg2L2t2bS9zdm0uYyAgICAgICAgICAgICAgfCA0NCArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKy0NCiBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAgICAgICAgIHwgMTIg
KysrKysrKysrDQogaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oICAgICAgICB8ICAxICsNCiA0IGZp
bGVzIGNoYW5nZWQsIDU3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9rdm1faG9zdC5oDQppbmRleCA0ZGRhNTg5MTIwMGQuLjE4NjdmYjY3Yzg2NiAxMDA2NDQNCi0t
LSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCisrKyBiL2FyY2gveDg2L2luY2x1
ZGUvYXNtL2t2bV9ob3N0LmgNCkBAIC0xMjA1LDYgKzEyMDUsNyBAQCBzdHJ1Y3Qga3ZtX3g4Nl9v
cHMgew0KIAlpbnQgKCpwYWdlX2VuY19zdGF0dXNfaGMpKHN0cnVjdCBrdm0gKmt2bSwgdW5zaWdu
ZWQgbG9uZyBncGEsDQogCQkJCSAgdW5zaWduZWQgbG9uZyBzeiwgdW5zaWduZWQgbG9uZyBtb2Rl
KTsNCiAJaW50ICgqZ2V0X3BhZ2VfZW5jX2JpdG1hcCkoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qg
a3ZtX3BhZ2VfZW5jX2JpdG1hcCAqYm1hcCk7DQorCWludCAoKnNldF9wYWdlX2VuY19iaXRtYXAp
KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9wYWdlX2VuY19iaXRtYXAgKmJtYXApOw0KIH07
DQogDQogc3RydWN0IGt2bV9hcmNoX2FzeW5jX3BmIHsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
dm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3ZtLmMNCmluZGV4IGFmOWIzM2U0YmI1My4uOTZiYzFk
YTMxYjQ5IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL3N2bS5jDQorKysgYi9hcmNoL3g4Ni9r
dm0vc3ZtLmMNCkBAIC03NDYyLDYgKzc0NjIsNDcgQEAgc3RhdGljIGludCBzdm1fZ2V0X3BhZ2Vf
ZW5jX2JpdG1hcChzdHJ1Y3Qga3ZtICprdm0sDQogCXJldHVybiByZXQ7DQogfQ0KIA0KK3N0YXRp
YyBpbnQgc3ZtX3NldF9wYWdlX2VuY19iaXRtYXAoc3RydWN0IGt2bSAqa3ZtLA0KKwkJCQkgICBz
dHJ1Y3Qga3ZtX3BhZ2VfZW5jX2JpdG1hcCAqYm1hcCkNCit7DQorCXN0cnVjdCBrdm1fc2V2X2lu
Zm8gKnNldiA9ICZ0b19rdm1fc3ZtKGt2bSktPnNldl9pbmZvOw0KKwl1bnNpZ25lZCBsb25nIGdm
bl9zdGFydCwgZ2ZuX2VuZDsNCisJdW5zaWduZWQgbG9uZyAqYml0bWFwOw0KKwl1bnNpZ25lZCBs
b25nIHN6LCBpOw0KKwlpbnQgcmV0Ow0KKw0KKwlpZiAoIXNldl9ndWVzdChrdm0pKQ0KKwkJcmV0
dXJuIC1FTk9UVFk7DQorDQorCWdmbl9zdGFydCA9IGJtYXAtPnN0YXJ0Ow0KKwlnZm5fZW5kID0g
Z2ZuX3N0YXJ0ICsgYm1hcC0+bnVtX3BhZ2VzOw0KKw0KKwlzeiA9IEFMSUdOKGJtYXAtPm51bV9w
YWdlcywgQklUU19QRVJfTE9ORykgLyA4Ow0KKwliaXRtYXAgPSBrbWFsbG9jKHN6LCBHRlBfS0VS
TkVMKTsNCisJaWYgKCFiaXRtYXApDQorCQlyZXR1cm4gLUVOT01FTTsNCisNCisJcmV0ID0gLUVG
QVVMVDsNCisJaWYgKGNvcHlfZnJvbV91c2VyKGJpdG1hcCwgYm1hcC0+ZW5jX2JpdG1hcCwgc3op
KQ0KKwkJZ290byBvdXQ7DQorDQorCW11dGV4X2xvY2soJmt2bS0+bG9jayk7DQorCXJldCA9IHNl
dl9yZXNpemVfcGFnZV9lbmNfYml0bWFwKGt2bSwgZ2ZuX2VuZCk7DQorCWlmIChyZXQpDQorCQln
b3RvIHVubG9jazsNCisNCisJaSA9IGdmbl9zdGFydDsNCisJZm9yX2VhY2hfY2xlYXJfYml0X2Zy
b20oaSwgYml0bWFwLCAoZ2ZuX2VuZCAtIGdmbl9zdGFydCkpDQorCQljbGVhcl9iaXQoaSArIGdm
bl9zdGFydCwgc2V2LT5wYWdlX2VuY19ibWFwKTsNCisNCisJcmV0ID0gMDsNCit1bmxvY2s6DQor
CW11dGV4X3VubG9jaygma3ZtLT5sb2NrKTsNCitvdXQ6DQorCWtmcmVlKGJpdG1hcCk7DQorCXJl
dHVybiByZXQ7DQorfQ0KKw0KIHN0YXRpYyBpbnQgc3ZtX21lbV9lbmNfb3Aoc3RydWN0IGt2bSAq
a3ZtLCB2b2lkIF9fdXNlciAqYXJncCkNCiB7DQogCXN0cnVjdCBrdm1fc2V2X2NtZCBzZXZfY21k
Ow0KQEAgLTc4MDUsNyArNzg0Niw4IEBAIHN0YXRpYyBzdHJ1Y3Qga3ZtX3g4Nl9vcHMgc3ZtX3g4
Nl9vcHMgX19yb19hZnRlcl9pbml0ID0gew0KIAkubmVlZF9lbXVsYXRpb25fb25fcGFnZV9mYXVs
dCA9IHN2bV9uZWVkX2VtdWxhdGlvbl9vbl9wYWdlX2ZhdWx0LA0KIA0KIAkucGFnZV9lbmNfc3Rh
dHVzX2hjID0gc3ZtX3BhZ2VfZW5jX3N0YXR1c19oYywNCi0JLmdldF9wYWdlX2VuY19iaXRtYXAg
PSBzdm1fZ2V0X3BhZ2VfZW5jX2JpdG1hcA0KKwkuZ2V0X3BhZ2VfZW5jX2JpdG1hcCA9IHN2bV9n
ZXRfcGFnZV9lbmNfYml0bWFwLA0KKwkuc2V0X3BhZ2VfZW5jX2JpdG1hcCA9IHN2bV9zZXRfcGFn
ZV9lbmNfYml0bWFwDQogfTsNCiANCiBzdGF0aWMgaW50IF9faW5pdCBzdm1faW5pdCh2b2lkKQ0K
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KaW5k
ZXggY2VjOTg2ZWJjNzkzLi45YjJmNjlkOWQwNDkgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0v
eDg2LmMNCisrKyBiL2FyY2gveDg2L2t2bS94ODYuYw0KQEAgLTQ5NDEsNiArNDk0MSwxOCBAQCBs
b25nIGt2bV9hcmNoX3ZtX2lvY3RsKHN0cnVjdCBmaWxlICpmaWxwLA0KIAkJCXIgPSBrdm1feDg2
X29wcy0+Z2V0X3BhZ2VfZW5jX2JpdG1hcChrdm0sICZiaXRtYXApOw0KIAkJYnJlYWs7DQogCX0N
CisJY2FzZSBLVk1fU0VUX1BBR0VfRU5DX0JJVE1BUDogew0KKwkJc3RydWN0IGt2bV9wYWdlX2Vu
Y19iaXRtYXAgYml0bWFwOw0KKw0KKwkJciA9IC1FRkFVTFQ7DQorCQlpZiAoY29weV9mcm9tX3Vz
ZXIoJmJpdG1hcCwgYXJncCwgc2l6ZW9mKGJpdG1hcCkpKQ0KKwkJCWdvdG8gb3V0Ow0KKw0KKwkJ
ciA9IC1FTk9UVFk7DQorCQlpZiAoa3ZtX3g4Nl9vcHMtPnNldF9wYWdlX2VuY19iaXRtYXApDQor
CQkJciA9IGt2bV94ODZfb3BzLT5zZXRfcGFnZV9lbmNfYml0bWFwKGt2bSwgJmJpdG1hcCk7DQor
CQlicmVhazsNCisJfQ0KIAlkZWZhdWx0Og0KIAkJciA9IC1FTk9UVFk7DQogCX0NCmRpZmYgLS1n
aXQgYS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmggYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgN
CmluZGV4IGNlNGFlODkyOWQwMC4uMjE3NzE5YjhjNzk1IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS91
YXBpL2xpbnV4L2t2bS5oDQorKysgYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCkBAIC0xNDYy
LDYgKzE0NjIsNyBAQCBzdHJ1Y3Qga3ZtX2VuY19yZWdpb24gew0KICNkZWZpbmUgS1ZNX0FSTV9W
Q1BVX0ZJTkFMSVpFCSAgX0lPVyhLVk1JTywgIDB4YzIsIGludCkNCiANCiAjZGVmaW5lIEtWTV9H
RVRfUEFHRV9FTkNfQklUTUFQCV9JT1coS1ZNSU8sIDB4YzIsIHN0cnVjdCBrdm1fcGFnZV9lbmNf
Yml0bWFwKQ0KKyNkZWZpbmUgS1ZNX1NFVF9QQUdFX0VOQ19CSVRNQVAJX0lPVyhLVk1JTywgMHhj
Mywgc3RydWN0IGt2bV9wYWdlX2VuY19iaXRtYXApDQogDQogLyogU2VjdXJlIEVuY3J5cHRlZCBW
aXJ0dWFsaXphdGlvbiBjb21tYW5kICovDQogZW51bSBzZXZfY21kX2lkIHsNCi0tIA0KMi4xNy4x
DQoNCg==
