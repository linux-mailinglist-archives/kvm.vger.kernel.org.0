Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22ED264D39
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 22:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfGJUNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 16:13:09 -0400
Received: from mail-eopbgr790054.outbound.protection.outlook.com ([40.107.79.54]:57219
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727546AbfGJUNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 16:13:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOjf0cMEsLJxDCyDUOnqLDL+17n/tP6OqXcFxRsafLg=;
 b=oXvLc1hhBPy9Xi/WhVDdQzX5skRTnYIX0wuFgrc21nwmBmiyppvw8aqXbGfN+KvzkRgDew1Mm9AWtbzWIN2Rcg3VW9DgWynlfSBV4P5+HaG58x2kTMUPkRy0+azMeddjma+zK+rWruknCdsZvysnN/6Ti2y+NfSdJXMXq3sXBmU=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3756.namprd12.prod.outlook.com (10.255.172.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Wed, 10 Jul 2019 20:13:05 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd%6]) with mapi id 15.20.2073.008; Wed, 10 Jul 2019
 20:13:05 +0000
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
Subject: [PATCH v3 04/11] KVM: SVM: Add support for KVM_SEV_RECEIVE_START
 command
Thread-Topic: [PATCH v3 04/11] KVM: SVM: Add support for KVM_SEV_RECEIVE_START
 command
Thread-Index: AQHVN1vhYh6TFncI8ESHo/9lo6JJYg==
Date:   Wed, 10 Jul 2019 20:13:04 +0000
Message-ID: <20190710201244.25195-5-brijesh.singh@amd.com>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
In-Reply-To: <20190710201244.25195-1-brijesh.singh@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0014.namprd05.prod.outlook.com
 (2603:10b6:803:40::27) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 150eee33-e656-4bb7-8a16-08d705730421
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3756;
x-ms-traffictypediagnostic: DM6PR12MB3756:
x-microsoft-antispam-prvs: <DM6PR12MB375642CAF4362ACEBFDCBDD4E5F00@DM6PR12MB3756.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(189003)(199004)(6436002)(4326008)(8676002)(71200400001)(6512007)(7736002)(6116002)(99286004)(476003)(66066001)(71190400001)(478600001)(5640700003)(1730700003)(14444005)(256004)(2351001)(53936002)(486006)(2501003)(6486002)(66574012)(50226002)(386003)(316002)(81156014)(81166006)(54906003)(76176011)(66946007)(66446008)(5660300002)(64756008)(66476007)(66556008)(6506007)(3846002)(305945005)(68736007)(102836004)(2906002)(52116002)(186003)(7416002)(1076003)(25786009)(6916009)(2616005)(26005)(8936002)(14454004)(11346002)(86362001)(446003)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3756;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XJ0BpZWQn/jv+hXwiAUr2miXfPyS2ovoLxLRc+tKRLC5gOAhtSf5DtrRN6b07vXAEnxRyto4ttqm+xj/t/qWsLY2lmdV/FvkTPTQrAKnKmyjuYZYIblkj2GQZNCDCc03Y0uXpuzCVd0XY8ky1L2g49oqLmxmniFlkfzB0TAAc+SG7Vnn7u0/AqwNWH4yXaIMwlo1yvGarNnYKciKsaIayXPniZZl826BF482HzI/8S4ctSfQdezZCG/S0QJpBn4dHcCmrNfTI5C2/Gf5A63Sr64ZHKNrD7tqNVKRXTr4gJyZ3HPMCoqSgIyACTfs6TsEqkTaIOs+l2OR7fX7yOO32w3ZhSMXf60IJIqTYMAgt28fU7LoUmCKxJONaC0JRSBsGG4ybvrmUYNfRnbIoR75YxiNWtjFpv0L2OptQmSEBR4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <052549B0C2AB2144BD30736AE46F83D6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 150eee33-e656-4bb7-8a16-08d705730421
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 20:13:04.7617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3756
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlIGNvbW1hbmQgaXMgdXNlZCB0byBjcmVhdGUgdGhlIGVuY3J5cHRpb24gY29udGV4dCBmb3Ig
YW4gaW5jb21pbmcNClNFViBndWVzdC4gVGhlIGVuY3J5cHRpb24gY29udGV4dCBjYW4gYmUgbGF0
ZXIgdXNlZCBieSB0aGUgaHlwZXJ2aXNvcg0KdG8gaW1wb3J0IHRoZSBpbmNvbWluZyBkYXRhIGlu
dG8gdGhlIFNFViBndWVzdCBtZW1vcnkgc3BhY2UuDQoNCkNjOiBUaG9tYXMgR2xlaXhuZXIgPHRn
bHhAbGludXRyb25peC5kZT4NCkNjOiBJbmdvIE1vbG5hciA8bWluZ29AcmVkaGF0LmNvbT4NCkNj
OiAiSC4gUGV0ZXIgQW52aW4iIDxocGFAenl0b3IuY29tPg0KQ2M6IFBhb2xvIEJvbnppbmkgPHBi
b256aW5pQHJlZGhhdC5jb20+DQpDYzogIlJhZGltIEtyxI1tw6HFmSIgPHJrcmNtYXJAcmVkaGF0
LmNvbT4NCkNjOiBKb2VyZyBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz4NCkNjOiBCb3Jpc2xhdiBQ
ZXRrb3YgPGJwQHN1c2UuZGU+DQpDYzogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1k
LmNvbT4NCkNjOiB4ODZAa2VybmVsLm9yZw0KQ2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCkNjOiBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQpTaWduZWQtb2ZmLWJ5OiBCcmlqZXNoIFNpbmdo
IDxicmlqZXNoLnNpbmdoQGFtZC5jb20+DQotLS0NCiAuLi4vdmlydHVhbC9rdm0vYW1kLW1lbW9y
eS1lbmNyeXB0aW9uLnJzdCAgICAgfCAyOSArKysrKysrDQogYXJjaC94ODYva3ZtL3N2bS5jICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgODAgKysrKysrKysrKysrKysrKysrKw0KIGluY2x1
ZGUvdWFwaS9saW51eC9rdm0uaCAgICAgICAgICAgICAgICAgICAgICB8ICA5ICsrKw0KIDMgZmls
ZXMgY2hhbmdlZCwgMTE4IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRp
b24vdmlydHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdCBiL0RvY3VtZW50YXRpb24v
dmlydHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdA0KaW5kZXggOTg2NGY5MjE1YzQz
Li41OWE3OTAzZjdjNGUgMTAwNjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2Ft
ZC1tZW1vcnktZW5jcnlwdGlvbi5yc3QNCisrKyBiL0RvY3VtZW50YXRpb24vdmlydHVhbC9rdm0v
YW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdA0KQEAgLTI5Nyw2ICsyOTcsMzUgQEAgaXNzdWVkIGJ5
IHRoZSBoeXBlcnZpc29yIHRvIGRlbGV0ZSB0aGUgZW5jcnlwdGlvbiBjb250ZXh0Lg0KIA0KIFJl
dHVybnM6IDAgb24gc3VjY2VzcywgLW5lZ2F0aXZlIG9uIGVycm9yDQogDQorMTMuIEtWTV9TRVZf
UkVDRUlWRV9TVEFSVA0KKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKw0KK1RoZSBLVk1fU0VW
X1JFQ0VJVkVfU1RBUlQgY29tbWFuZCBpcyB1c2VkIGZvciBjcmVhdGluZyB0aGUgbWVtb3J5IGVu
Y3J5cHRpb24NCitjb250ZXh0IGZvciBhbiBpbmNvbWluZyBTRVYgZ3Vlc3QuIFRvIGNyZWF0ZSB0
aGUgZW5jcnlwdGlvbiBjb250ZXh0LCB0aGUgdXNlciBtdXN0DQorcHJvdmlkZSBhIGd1ZXN0IHBv
bGljeSwgdGhlIHBsYXRmb3JtIHB1YmxpYyBEaWZmaWUtSGVsbG1hbiAoUERIKSBrZXkgYW5kIHNl
c3Npb24NCitpbmZvcm1hdGlvbi4NCisNCitQYXJhbWV0ZXJzOiBzdHJ1Y3QgIGt2bV9zZXZfcmVj
ZWl2ZV9zdGFydCAoaW4vb3V0KQ0KKw0KK1JldHVybnM6IDAgb24gc3VjY2VzcywgLW5lZ2F0aXZl
IG9uIGVycm9yDQorDQorOjoNCisNCisgICAgICAgIHN0cnVjdCBrdm1fc2V2X3JlY2VpdmVfc3Rh
cnQgew0KKyAgICAgICAgICAgICAgICBfX3UzMiBoYW5kbGU7ICAgICAgICAgICAvKiBpZiB6ZXJv
IHRoZW4gZmlybXdhcmUgY3JlYXRlcyBhIG5ldyBoYW5kbGUgKi8NCisgICAgICAgICAgICAgICAg
X191MzIgcG9saWN5OyAgICAgICAgICAgLyogZ3Vlc3QncyBwb2xpY3kgKi8NCisNCisgICAgICAg
ICAgICAgICAgX191NjQgcGRoX3VhZGRyOyAgICAgICAgIC8qIHVzZXJzcGFjZSBhZGRyZXNzIHBv
aW50aW5nIHRvIHRoZSBQREgga2V5ICovDQorICAgICAgICAgICAgICAgIF9fdTMyIGRoX2xlbjsN
CisNCisgICAgICAgICAgICAgICAgX191NjQgc2Vzc2lvbl9hZGRyOyAgICAgLyogdXNlcnNwYWNl
IGFkZHJlc3Mgd2hpY2ggcG9pbnRzIHRvIHRoZSBndWVzdCBzZXNzaW9uIGluZm9ybWF0aW9uICov
DQorICAgICAgICAgICAgICAgIF9fdTMyIHNlc3Npb25fbGVuOw0KKyAgICAgICAgfTsNCisNCitP
biBzdWNjZXNzLCB0aGUgJ2hhbmRsZScgZmllbGQgY29udGFpbnMgYSBuZXcgaGFuZGxlIGFuZCBv
biBlcnJvciwgYSBuZWdhdGl2ZSB2YWx1ZS4NCisNCitGb3IgbW9yZSBkZXRhaWxzLCBzZWUgU0VW
IHNwZWMgU2VjdGlvbiA2LjEyLg0KKw0KIFJlZmVyZW5jZXMNCiA9PT09PT09PT09DQogDQpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQppbmRleCBi
ZTczYTg3YThjNGYuLmZhZTZhODcwYjI5YSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9zdm0u
Yw0KKysrIGIvYXJjaC94ODYva3ZtL3N2bS5jDQpAQCAtNzE4OCw2ICs3MTg4LDgzIEBAIHN0YXRp
YyBpbnQgc2V2X3NlbmRfZmluaXNoKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9zZXZfY21k
ICphcmdwKQ0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCitzdGF0aWMgaW50IHNldl9yZWNlaXZlX3N0
YXJ0KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9zZXZfY21kICphcmdwKQ0KK3sNCisJc3Ry
dWN0IGt2bV9zZXZfaW5mbyAqc2V2ID0gJnRvX2t2bV9zdm0oa3ZtKS0+c2V2X2luZm87DQorCXN0
cnVjdCBzZXZfZGF0YV9yZWNlaXZlX3N0YXJ0ICpzdGFydDsNCisJc3RydWN0IGt2bV9zZXZfcmVj
ZWl2ZV9zdGFydCBwYXJhbXM7DQorCWludCAqZXJyb3IgPSAmYXJncC0+ZXJyb3I7DQorCXZvaWQg
KnNlc3Npb25fZGF0YSA9IE5VTEw7DQorCXZvaWQgKnBkaF9kYXRhID0gTlVMTDsNCisJaW50IHJl
dDsNCisNCisJaWYgKCFzZXZfZ3Vlc3Qoa3ZtKSkNCisJCXJldHVybiAtRU5PVFRZOw0KKw0KKwkv
KiBHZXQgcGFyYW1ldGVyIGZyb20gdGhlIHVzZXIgKi8NCisJaWYgKGNvcHlfZnJvbV91c2VyKCZw
YXJhbXMsICh2b2lkIF9fdXNlciAqKSh1aW50cHRyX3QpYXJncC0+ZGF0YSwNCisJCQlzaXplb2Yo
c3RydWN0IGt2bV9zZXZfcmVjZWl2ZV9zdGFydCkpKQ0KKwkJcmV0dXJuIC1FRkFVTFQ7DQorDQor
CWlmICghcGFyYW1zLnBkaF91YWRkciB8fCAhcGFyYW1zLnBkaF9sZW4gfHwNCisJICAgICFwYXJh
bXMuc2Vzc2lvbl91YWRkciB8fCAhcGFyYW1zLnNlc3Npb25fbGVuKQ0KKwkJcmV0dXJuIC1FSU5W
QUw7DQorDQorCXN0YXJ0ID0ga3phbGxvYyhzaXplb2YoKnN0YXJ0KSwgR0ZQX0tFUk5FTCk7DQor
CWlmICghc3RhcnQpDQorCQlyZXR1cm4gLUVOT01FTTsNCisNCisJc3RhcnQtPmhhbmRsZSA9IHBh
cmFtcy5oYW5kbGU7DQorCXN0YXJ0LT5wb2xpY3kgPSBwYXJhbXMucG9saWN5Ow0KKw0KKwlwZGhf
ZGF0YSA9IHBzcF9jb3B5X3VzZXJfYmxvYihwYXJhbXMucGRoX3VhZGRyLCBwYXJhbXMucGRoX2xl
bik7DQorCWlmIChJU19FUlIocGRoX2RhdGEpKSB7DQorCQlyZXQgPSBQVFJfRVJSKHBkaF9kYXRh
KTsNCisJCWdvdG8gZV9mcmVlOw0KKwl9DQorDQorCXN0YXJ0LT5wZGhfY2VydF9hZGRyZXNzID0g
X19wc3BfcGEocGRoX2RhdGEpOw0KKwlzdGFydC0+cGRoX2NlcnRfbGVuID0gcGFyYW1zLnBkaF9s
ZW47DQorDQorCXNlc3Npb25fZGF0YSA9IHBzcF9jb3B5X3VzZXJfYmxvYihwYXJhbXMuc2Vzc2lv
bl91YWRkciwgcGFyYW1zLnNlc3Npb25fbGVuKTsNCisJaWYgKElTX0VSUihzZXNzaW9uX2RhdGEp
KSB7DQorCQlyZXQgPSBQVFJfRVJSKHNlc3Npb25fZGF0YSk7DQorCQlnb3RvIGVfZnJlZV9wZGg7
DQorCX0NCisNCisJc3RhcnQtPnNlc3Npb25fYWRkcmVzcyA9IF9fcHNwX3BhKHNlc3Npb25fZGF0
YSk7DQorCXN0YXJ0LT5zZXNzaW9uX2xlbiA9IHBhcmFtcy5zZXNzaW9uX2xlbjsNCisNCisJLyog
Y3JlYXRlIG1lbW9yeSBlbmNyeXB0aW9uIGNvbnRleHQgKi8NCisJcmV0ID0gX19zZXZfaXNzdWVf
Y21kKGFyZ3AtPnNldl9mZCwgU0VWX0NNRF9SRUNFSVZFX1NUQVJULCBzdGFydCwgZXJyb3IpOw0K
KwlpZiAocmV0KQ0KKwkJZ290byBlX2ZyZWVfc2Vzc2lvbjsNCisNCisJLyogQmluZCBBU0lEIHRv
IHRoaXMgZ3Vlc3QgKi8NCisJcmV0ID0gc2V2X2JpbmRfYXNpZChrdm0sIHN0YXJ0LT5oYW5kbGUs
IGVycm9yKTsNCisJaWYgKHJldCkNCisJCWdvdG8gZV9mcmVlX3Nlc3Npb247DQorDQorCXBhcmFt
cy5oYW5kbGUgPSBzdGFydC0+aGFuZGxlOw0KKwlpZiAoY29weV90b191c2VyKCh2b2lkIF9fdXNl
ciAqKSh1aW50cHRyX3QpYXJncC0+ZGF0YSwNCisJCQkgJnBhcmFtcywgc2l6ZW9mKHN0cnVjdCBr
dm1fc2V2X3JlY2VpdmVfc3RhcnQpKSkgew0KKwkJcmV0ID0gLUVGQVVMVDsNCisJCXNldl91bmJp
bmRfYXNpZChrdm0sIHN0YXJ0LT5oYW5kbGUpOw0KKwkJZ290byBlX2ZyZWVfc2Vzc2lvbjsNCisJ
fQ0KKw0KKwlzZXYtPmhhbmRsZSA9IHN0YXJ0LT5oYW5kbGU7DQorCXNldi0+ZmQgPSBhcmdwLT5z
ZXZfZmQ7DQorDQorZV9mcmVlX3Nlc3Npb246DQorCWtmcmVlKHNlc3Npb25fZGF0YSk7DQorZV9m
cmVlX3BkaDoNCisJa2ZyZWUocGRoX2RhdGEpOw0KK2VfZnJlZToNCisJa2ZyZWUoc3RhcnQpOw0K
KwlyZXR1cm4gcmV0Ow0KK30NCisNCiBzdGF0aWMgaW50IHN2bV9tZW1fZW5jX29wKHN0cnVjdCBr
dm0gKmt2bSwgdm9pZCBfX3VzZXIgKmFyZ3ApDQogew0KIAlzdHJ1Y3Qga3ZtX3Nldl9jbWQgc2V2
X2NtZDsNCkBAIC03MjM4LDYgKzczMTUsOSBAQCBzdGF0aWMgaW50IHN2bV9tZW1fZW5jX29wKHN0
cnVjdCBrdm0gKmt2bSwgdm9pZCBfX3VzZXIgKmFyZ3ApDQogCWNhc2UgS1ZNX1NFVl9TRU5EX0ZJ
TklTSDoNCiAJCXIgPSBzZXZfc2VuZF9maW5pc2goa3ZtLCAmc2V2X2NtZCk7DQogCQlicmVhazsN
CisJY2FzZSBLVk1fU0VWX1JFQ0VJVkVfU1RBUlQ6DQorCQlyID0gc2V2X3JlY2VpdmVfc3RhcnQo
a3ZtLCAmc2V2X2NtZCk7DQorCQlicmVhazsNCiAJZGVmYXVsdDoNCiAJCXIgPSAtRUlOVkFMOw0K
IAkJZ290byBvdXQ7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oIGIvaW5j
bHVkZS91YXBpL2xpbnV4L2t2bS5oDQppbmRleCA0Y2I2YzM3NzRlYzIuLjI4ZDI0MDk3NGVhNyAx
MDA2NDQNCi0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaA0KKysrIGIvaW5jbHVkZS91YXBp
L2xpbnV4L2t2bS5oDQpAQCAtMTU1Miw2ICsxNTUyLDE1IEBAIHN0cnVjdCBrdm1fc2V2X3NlbmRf
dXBkYXRlX2RhdGEgew0KIAlfX3UzMiB0cmFuc19sZW47DQogfTsNCiANCitzdHJ1Y3Qga3ZtX3Nl
dl9yZWNlaXZlX3N0YXJ0IHsNCisJX191MzIgaGFuZGxlOw0KKwlfX3UzMiBwb2xpY3k7DQorCV9f
dTY0IHBkaF91YWRkcjsNCisJX191MzIgcGRoX2xlbjsNCisJX191NjQgc2Vzc2lvbl91YWRkcjsN
CisJX191MzIgc2Vzc2lvbl9sZW47DQorfTsNCisNCiAjZGVmaW5lIEtWTV9ERVZfQVNTSUdOX0VO
QUJMRV9JT01NVQkoMSA8PCAwKQ0KICNkZWZpbmUgS1ZNX0RFVl9BU1NJR05fUENJXzJfMwkJKDEg
PDwgMSkNCiAjZGVmaW5lIEtWTV9ERVZfQVNTSUdOX01BU0tfSU5UWAkoMSA8PCAyKQ0KLS0gDQoy
LjE3LjENCg0K
