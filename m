Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C94C64D41
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 22:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfGJUNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 16:13:34 -0400
Received: from mail-eopbgr820053.outbound.protection.outlook.com ([40.107.82.53]:63365
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728480AbfGJUNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 16:13:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r02pCThxJEybDdynKE4TrldYiEXPebDrfUNevhJEunE=;
 b=BRDBamjgYtkL93DJmt+tlKeZ2yRq222TV0x2eGwBpPkmucJJ8e4Y3P08LK3SE5kis/kz4MazK3W157KLrDhPVB5+ghqPL4/amWFtd81x3PYLhdQZSU5FHi66SBJa+Dw/ORCXPJ2kuy0A68BarxapksPKxCUB+puNyqsBV9fdjnc=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB2988.namprd12.prod.outlook.com (20.178.29.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Wed, 10 Jul 2019 20:13:17 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd%6]) with mapi id 15.20.2073.008; Wed, 10 Jul 2019
 20:13:16 +0000
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
Subject: [PATCH v3 11/11] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
Thread-Topic: [PATCH v3 11/11] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP
 ioctl
Thread-Index: AQHVN1vmHnjV+FHKsE+g09pSSgqIew==
Date:   Wed, 10 Jul 2019 20:13:16 +0000
Message-ID: <20190710201244.25195-12-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: 238e9a2d-ba34-421c-d56c-08d7057308e7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2988;
x-ms-traffictypediagnostic: DM6PR12MB2988:
x-microsoft-antispam-prvs: <DM6PR12MB29881FBE540766EC95EF9183E5F00@DM6PR12MB2988.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(199004)(189003)(1730700003)(81156014)(81166006)(7416002)(478600001)(8676002)(486006)(446003)(7736002)(6116002)(476003)(2616005)(305945005)(71190400001)(71200400001)(3846002)(26005)(11346002)(64756008)(66946007)(66556008)(66476007)(66446008)(66066001)(186003)(76176011)(102836004)(14454004)(386003)(6506007)(36756003)(5660300002)(2501003)(52116002)(6916009)(1076003)(66574012)(99286004)(86362001)(68736007)(6436002)(2906002)(25786009)(6486002)(50226002)(4326008)(5640700003)(316002)(256004)(54906003)(6512007)(14444005)(53936002)(8936002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2988;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: N/UImD4OUX52nbd9Jrlkc/VlnWG69toBs3fFO2YmwN2PL7GnnEDs+YPWPH+SkEAOJ4v7fihQsj7ZjbuRIrI3j+JJcxUzsF7v2QEvB9t2dLe+p6FDRCQKAnNVT+QLNs/c2nTqS9bgJg93mrvElS4/zRs4GqRtpR3ombPGGjBzFbajH1o+vRnJOqci7D8mAznyrFv/rJGnedFf9HgnNkNSUACZizEeUciEr3cT8QG3aP6ZRnLp4enRH+8x5ByxaQikutfuEjoiLxxlJ5CU/wnz+TD2f7eXiIdOlS0ICc5DsVCw+Jf72BPNpfWRFxMdqVM6w96N4ZQAe+w4bZRk+LC2YuQxKZlKOnD1fKLDIo4kFXDuc7CrNH3mC5byn2elgFOLFmu2kQSe2FNkr9l7KzhFdljsO/G+BWpLOKJ0oh5VyYg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2AD93DEA99AA79479C7AC6B5BF4DF9BF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 238e9a2d-ba34-421c-d56c-08d7057308e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 20:13:16.8688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
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
bmdoQGFtZC5jb20+DQotLS0NCiBEb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2FwaS50eHQgfCAy
MSArKysrKysrKysrKysrKysNCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oICAgfCAg
MSArDQogYXJjaC94ODYva3ZtL3N2bS5jICAgICAgICAgICAgICAgIHwgNDQgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrLQ0KIGFyY2gveDg2L2t2bS94ODYuYyAgICAgICAgICAgICAgICB8
IDEyICsrKysrKysrKw0KIGluY2x1ZGUvdWFwaS9saW51eC9rdm0uaCAgICAgICAgICB8ICAxICsN
CiA1IGZpbGVzIGNoYW5nZWQsIDc4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlm
ZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vdmlydHVhbC9rdm0vYXBpLnR4dCBiL0RvY3VtZW50YXRp
b24vdmlydHVhbC9rdm0vYXBpLnR4dA0KaW5kZXggZWQ2MWE0ZDYzYjEwLi4xMDczMDA0ZjE3OGUg
MTAwNjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2FwaS50eHQNCisrKyBiL0Rv
Y3VtZW50YXRpb24vdmlydHVhbC9rdm0vYXBpLnR4dA0KQEAgLTQxMDcsNiArNDEwNywyNyBAQCBv
ciBzaGFyZWQuIFRoZSBiaXRtYXAgY2FuIGJlIHVzZWQgZHVyaW5nIHRoZSBndWVzdCBtaWdyYXRp
b24sIGlmIHRoZSBwYWdlDQogaXMgcHJpdmF0ZSB0aGVuIHVzZXJzcGFjZSBuZWVkIHRvIHVzZSBT
RVYgbWlncmF0aW9uIGNvbW1hbmRzIHRvIHRyYW5zbWl0DQogdGhlIHBhZ2UuDQogDQorNC4xMjEg
S1ZNX1NFVF9QQUdFX0VOQ19CSVRNQVAgKHZtIGlvY3RsKQ0KKw0KK0NhcGFiaWxpdHk6IGJhc2lj
DQorQXJjaGl0ZWN0dXJlczogeDg2DQorVHlwZTogdm0gaW9jdGwNCitQYXJhbWV0ZXJzOiBzdHJ1
Y3Qga3ZtX3BhZ2VfZW5jX2JpdG1hcCAoaW4vb3V0KQ0KK1JldHVybnM6IDAgb24gc3VjY2Vzcywg
LTEgb24gZXJyb3INCisNCisvKiBmb3IgS1ZNX1NFVF9QQUdFX0VOQ19CSVRNQVAgKi8NCitzdHJ1
Y3Qga3ZtX3BhZ2VfZW5jX2JpdG1hcCB7DQorCV9fdTY0IHN0YXJ0X2dmbjsNCisJX191NjQgbnVt
X3BhZ2VzOw0KKwl1bmlvbiB7DQorCQl2b2lkIF9fdXNlciAqZW5jX2JpdG1hcDsgLyogb25lIGJp
dCBwZXIgcGFnZSAqLw0KKwkJX191NjQgcGFkZGluZzI7DQorCX07DQorfTsNCisNCitEdXJpbmcg
dGhlIGd1ZXN0IGxpdmUgbWlncmF0aW9uIHRoZSBvdXRnb2luZyBndWVzdCBleHBvcnRzIGl0cyBw
YWdlIGVuY3J5cHRpb24NCitiaXRtYXAsIHRoZSBLVk1fU0VUX1BBR0VfRU5DX0JJVE1BUCBjYW4g
YmUgdXNlZCB0byBidWlsZCB0aGUgcGFnZSBlbmNyeXB0aW9uDQorYml0bWFwIGZvciBhbiBpbmNv
bWluZyBndWVzdC4NCiANCiA1LiBUaGUga3ZtX3J1biBzdHJ1Y3R1cmUNCiAtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5o
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KaW5kZXggOWRmMGUyMzE1NTQzLi4z
NjlhMDZiMjc1ZDUgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5o
DQorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQpAQCAtMTIwMiw2ICsxMjAy
LDcgQEAgc3RydWN0IGt2bV94ODZfb3BzIHsNCiAJaW50ICgqcGFnZV9lbmNfc3RhdHVzX2hjKShz
dHJ1Y3Qga3ZtICprdm0sIHVuc2lnbmVkIGxvbmcgZ3BhLA0KIAkJCQkgIHVuc2lnbmVkIGxvbmcg
c3osIHVuc2lnbmVkIGxvbmcgbW9kZSk7DQogCWludCAoKmdldF9wYWdlX2VuY19iaXRtYXApKHN0
cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9wYWdlX2VuY19iaXRtYXAgKmJtYXApOw0KKwlpbnQg
KCpzZXRfcGFnZV9lbmNfYml0bWFwKShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fcGFnZV9l
bmNfYml0bWFwICpibWFwKTsNCiB9Ow0KIA0KIHN0cnVjdCBrdm1fYXJjaF9hc3luY19wZiB7DQpk
aWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQppbmRl
eCBlNjc1ZmQ4OWJiOWEuLjMxNjUzZThkNTkyNyAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9z
dm0uYw0KKysrIGIvYXJjaC94ODYva3ZtL3N2bS5jDQpAQCAtNzQ2Niw2ICs3NDY2LDQ3IEBAIHN0
YXRpYyBpbnQgc3ZtX2dldF9wYWdlX2VuY19iaXRtYXAoc3RydWN0IGt2bSAqa3ZtLA0KIAlyZXR1
cm4gcmV0Ow0KIH0NCiANCitzdGF0aWMgaW50IHN2bV9zZXRfcGFnZV9lbmNfYml0bWFwKHN0cnVj
dCBrdm0gKmt2bSwNCisJCQkJICAgc3RydWN0IGt2bV9wYWdlX2VuY19iaXRtYXAgKmJtYXApDQor
ew0KKwlzdHJ1Y3Qga3ZtX3Nldl9pbmZvICpzZXYgPSAmdG9fa3ZtX3N2bShrdm0pLT5zZXZfaW5m
bzsNCisJdW5zaWduZWQgbG9uZyBnZm5fc3RhcnQsIGdmbl9lbmQ7DQorCXVuc2lnbmVkIGxvbmcg
KmJpdG1hcDsNCisJdW5zaWduZWQgbG9uZyBzeiwgaTsNCisJaW50IHJldDsNCisNCisJaWYgKCFz
ZXZfZ3Vlc3Qoa3ZtKSkNCisJCXJldHVybiAtRU5PVFRZOw0KKw0KKwlnZm5fc3RhcnQgPSBibWFw
LT5zdGFydF9nZm47DQorCWdmbl9lbmQgPSBnZm5fc3RhcnQgKyBibWFwLT5udW1fcGFnZXM7DQor
DQorCXN6ID0gQUxJR04oYm1hcC0+bnVtX3BhZ2VzLCBCSVRTX1BFUl9MT05HKSAvIDg7DQorCWJp
dG1hcCA9IGttYWxsb2Moc3osIEdGUF9LRVJORUwpOw0KKwlpZiAoIWJpdG1hcCkNCisJCXJldHVy
biAtRU5PTUVNOw0KKw0KKwlyZXQgPSAtRUZBVUxUOw0KKwlpZiAoY29weV9mcm9tX3VzZXIoYml0
bWFwLCBibWFwLT5lbmNfYml0bWFwLCBzeikpDQorCQlnb3RvIG91dDsNCisNCisJbXV0ZXhfbG9j
aygma3ZtLT5sb2NrKTsNCisJcmV0ID0gc2V2X3Jlc2l6ZV9wYWdlX2VuY19iaXRtYXAoa3ZtLCBn
Zm5fZW5kKTsNCisJaWYgKHJldCkNCisJCWdvdG8gdW5sb2NrOw0KKw0KKwlpID0gZ2ZuX3N0YXJ0
Ow0KKwlmb3JfZWFjaF9jbGVhcl9iaXRfZnJvbShpLCBiaXRtYXAsIChnZm5fZW5kIC0gZ2ZuX3N0
YXJ0KSkNCisJCWNsZWFyX2JpdChpICsgZ2ZuX3N0YXJ0LCBzZXYtPnBhZ2VfZW5jX2JtYXApOw0K
Kw0KKwlyZXQgPSAwOw0KK3VubG9jazoNCisJbXV0ZXhfdW5sb2NrKCZrdm0tPmxvY2spOw0KK291
dDoNCisJa2ZyZWUoYml0bWFwKTsNCisJcmV0dXJuIHJldDsNCit9DQorDQogc3RhdGljIGludCBz
dm1fbWVtX2VuY19vcChzdHJ1Y3Qga3ZtICprdm0sIHZvaWQgX191c2VyICphcmdwKQ0KIHsNCiAJ
c3RydWN0IGt2bV9zZXZfY21kIHNldl9jbWQ7DQpAQCAtNzgwOSw3ICs3ODUwLDggQEAgc3RhdGlj
IHN0cnVjdCBrdm1feDg2X29wcyBzdm1feDg2X29wcyBfX3JvX2FmdGVyX2luaXQgPSB7DQogCS5u
ZWVkX2VtdWxhdGlvbl9vbl9wYWdlX2ZhdWx0ID0gc3ZtX25lZWRfZW11bGF0aW9uX29uX3BhZ2Vf
ZmF1bHQsDQogDQogCS5wYWdlX2VuY19zdGF0dXNfaGMgPSBzdm1fcGFnZV9lbmNfc3RhdHVzX2hj
LA0KLQkuZ2V0X3BhZ2VfZW5jX2JpdG1hcCA9IHN2bV9nZXRfcGFnZV9lbmNfYml0bWFwDQorCS5n
ZXRfcGFnZV9lbmNfYml0bWFwID0gc3ZtX2dldF9wYWdlX2VuY19iaXRtYXAsDQorCS5zZXRfcGFn
ZV9lbmNfYml0bWFwID0gc3ZtX3NldF9wYWdlX2VuY19iaXRtYXANCiB9Ow0KIA0KIHN0YXRpYyBp
bnQgX19pbml0IHN2bV9pbml0KHZvaWQpDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5j
IGIvYXJjaC94ODYva3ZtL3g4Ni5jDQppbmRleCA1OWFlNDliMWI5MTQuLmVhMjFjYjFjYmZiNyAx
MDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5j
DQpAQCAtNDkzOSw2ICs0OTM5LDE4IEBAIGxvbmcga3ZtX2FyY2hfdm1faW9jdGwoc3RydWN0IGZp
bGUgKmZpbHAsDQogCQkJciA9IGt2bV94ODZfb3BzLT5nZXRfcGFnZV9lbmNfYml0bWFwKGt2bSwg
JmJpdG1hcCk7DQogCQlicmVhazsNCiAJfQ0KKwljYXNlIEtWTV9TRVRfUEFHRV9FTkNfQklUTUFQ
OiB7DQorCQlzdHJ1Y3Qga3ZtX3BhZ2VfZW5jX2JpdG1hcCBiaXRtYXA7DQorDQorCQlyID0gLUVG
QVVMVDsNCisJCWlmIChjb3B5X2Zyb21fdXNlcigmYml0bWFwLCBhcmdwLCBzaXplb2YoYml0bWFw
KSkpDQorCQkJZ290byBvdXQ7DQorDQorCQlyID0gLUVOT1RUWTsNCisJCWlmIChrdm1feDg2X29w
cy0+c2V0X3BhZ2VfZW5jX2JpdG1hcCkNCisJCQlyID0ga3ZtX3g4Nl9vcHMtPnNldF9wYWdlX2Vu
Y19iaXRtYXAoa3ZtLCAmYml0bWFwKTsNCisJCWJyZWFrOw0KKwl9DQogCWRlZmF1bHQ6DQogCQly
ID0gLUVOT1RUWTsNCiAJfQ0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaCBi
L2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaA0KaW5kZXggMGQwOGJjZjk0ZWY1Li45MGRkMzM2ZTgw
ODAgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCisrKyBiL2luY2x1ZGUv
dWFwaS9saW51eC9rdm0uaA0KQEAgLTE0NjIsNiArMTQ2Miw3IEBAIHN0cnVjdCBrdm1fZW5jX3Jl
Z2lvbiB7DQogI2RlZmluZSBLVk1fQVJNX1ZDUFVfRklOQUxJWkUJICBfSU9XKEtWTUlPLCAgMHhj
MiwgaW50KQ0KIA0KICNkZWZpbmUgS1ZNX0dFVF9QQUdFX0VOQ19CSVRNQVAJX0lPVyhLVk1JTywg
MHhjMiwgc3RydWN0IGt2bV9wYWdlX2VuY19iaXRtYXApDQorI2RlZmluZSBLVk1fU0VUX1BBR0Vf
RU5DX0JJVE1BUAlfSU9XKEtWTUlPLCAweGMzLCBzdHJ1Y3Qga3ZtX3BhZ2VfZW5jX2JpdG1hcCkN
CiANCiAvKiBTZWN1cmUgRW5jcnlwdGVkIFZpcnR1YWxpemF0aW9uIGNvbW1hbmQgKi8NCiBlbnVt
IHNldl9jbWRfaWQgew0KLS0gDQoyLjE3LjENCg0K
