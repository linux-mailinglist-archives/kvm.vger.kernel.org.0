Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E4064D47
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 22:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbfGJUNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 16:13:45 -0400
Received: from mail-eopbgr820080.outbound.protection.outlook.com ([40.107.82.80]:23808
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728469AbfGJUNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 16:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yrkk7KFTBJRgwdvaQu/OkLRXXjn5FxlViVTBydYMhts=;
 b=QdZlkQWshXU3IpAxEZddc8NucE4LxJgagyZW6hvLdIscijZRRp7+4S6AXTmC8jxMt2FAS3S3Fl//AMVQW4c3s/Fs/9xja/hdA+L4kX9FImuFFOLm0vHHSVvTLDaSYfePxzapeW3/rSyNDPRtQGhVFISiDcAYWYlwAJx4PbCJ1xQ=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB2988.namprd12.prod.outlook.com (20.178.29.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Wed, 10 Jul 2019 20:13:11 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd%6]) with mapi id 15.20.2073.008; Wed, 10 Jul 2019
 20:13:11 +0000
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
Subject: [PATCH v3 10/11] mm: x86: Invoke hypercall when page encryption
 status is changed
Thread-Topic: [PATCH v3 10/11] mm: x86: Invoke hypercall when page encryption
 status is changed
Thread-Index: AQHVN1vlvYtNVeXn2US0n5tv1Wageg==
Date:   Wed, 10 Jul 2019 20:13:11 +0000
Message-ID: <20190710201244.25195-11-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: ca092446-9961-4f75-3720-08d70573084b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2988;
x-ms-traffictypediagnostic: DM6PR12MB2988:
x-microsoft-antispam-prvs: <DM6PR12MB298892AD5C3410FFFF2C46C7E5F00@DM6PR12MB2988.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(199004)(189003)(1730700003)(81156014)(81166006)(7416002)(478600001)(8676002)(486006)(446003)(7736002)(6116002)(476003)(2616005)(305945005)(71190400001)(71200400001)(3846002)(26005)(11346002)(64756008)(66946007)(66556008)(66476007)(66446008)(66066001)(186003)(76176011)(102836004)(14454004)(386003)(6506007)(36756003)(5660300002)(2501003)(52116002)(6916009)(1076003)(66574012)(99286004)(86362001)(68736007)(6436002)(2906002)(25786009)(6486002)(50226002)(4326008)(5640700003)(316002)(256004)(54906003)(6512007)(14444005)(53936002)(8936002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2988;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: i4Xfz/wv81RexZPeMNcRTRuhuYbHoPkILVIfEi4vqsObdXS/7/Y29/cblobn5Tf71b/I1JQGfES9ddcgZkRimbGRzZ0KXAONgWnLRl84EWMUOUPhRtIMRBWIFCuXh3nOgqq/avXAcQq0y3/v8aWNIXbO0XTqhqfZfIIuVLvquLsQ+G1VVwD3nPqDFIPelg/hsgKj2APw2AjcpiXYy+RhRHt1mlaUV0pvaQGYbBtYMUwa7JUjd7YG6xvi6vRJqfGBRQbsnZXFDlyrWKlCounFNjjSmf6WAs9j9zMeoNeKB+ZzbwzWfRQsUZHfyQrNC5hLxOAWJ24BGxp3eR632Z1PsLEgNKuZgr0gAhCgvlN4mSKeDsYdz8XNdBbKCgWJnXaLoiCNQzDhwLjXbXx4t52O2HVpPi+Z9Zj7DfwmGFrhHt0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B62A30A6BACE6408C90BDE55ADEE8E6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca092446-9961-4f75-3720-08d70573084b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 20:13:11.6408
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

SW52b2tlIGEgaHlwZXJjYWxsIHdoZW4gYSBtZW1vcnkgcmVnaW9uIGlzIGNoYW5nZWQgZnJvbSBl
bmNyeXB0ZWQgLT4NCmRlY3J5cHRlZCBhbmQgdmljZSB2ZXJzYS4gSHlwZXJ2aXNvciBuZWVkIHRv
IGtub3cgdGhlIHBhZ2UgZW5jcnlwdGlvbg0Kc3RhdHVzIGR1cmluZyB0aGUgZ3Vlc3QgbWlncmF0
aW9uLg0KDQpDYzogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+DQpDYzogSW5n
byBNb2xuYXIgPG1pbmdvQHJlZGhhdC5jb20+DQpDYzogIkguIFBldGVyIEFudmluIiA8aHBhQHp5
dG9yLmNvbT4NCkNjOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KQ2M6ICJS
YWRpbSBLcsSNbcOhxZkiIDxya3JjbWFyQHJlZGhhdC5jb20+DQpDYzogSm9lcmcgUm9lZGVsIDxq
b3JvQDhieXRlcy5vcmc+DQpDYzogQm9yaXNsYXYgUGV0a292IDxicEBzdXNlLmRlPg0KQ2M6IFRv
bSBMZW5kYWNreSA8dGhvbWFzLmxlbmRhY2t5QGFtZC5jb20+DQpDYzogeDg2QGtlcm5lbC5vcmcN
CkNjOiBrdm1Admdlci5rZXJuZWwub3JnDQpDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zw0KU2lnbmVkLW9mZi1ieTogQnJpamVzaCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPg0K
LS0tDQogYXJjaC94ODYvaW5jbHVkZS9hc20vbWVtX2VuY3J5cHQuaCB8ICAzICsrDQogYXJjaC94
ODYvbW0vbWVtX2VuY3J5cHQuYyAgICAgICAgICB8IDQ1ICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrLQ0KIGFyY2gveDg2L21tL3BhZ2VhdHRyLmMgICAgICAgICAgICAgfCAxNSArKysrKysr
KysrDQogMyBmaWxlcyBjaGFuZ2VkLCA2MiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoN
CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tZW1fZW5jcnlwdC5oIGIvYXJjaC94
ODYvaW5jbHVkZS9hc20vbWVtX2VuY3J5cHQuaA0KaW5kZXggMGMxOTZjNDdkNjIxLi42ZTY1NGFi
NWE4ZTQgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tZW1fZW5jcnlwdC5oDQor
KysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tZW1fZW5jcnlwdC5oDQpAQCAtOTQsNCArOTQsNyBA
QCBleHRlcm4gY2hhciBfX3N0YXJ0X2Jzc19kZWNyeXB0ZWRbXSwgX19lbmRfYnNzX2RlY3J5cHRl
ZFtdLCBfX3N0YXJ0X2Jzc19kZWNyeXB0ZQ0KIA0KICNlbmRpZgkvKiBfX0FTU0VNQkxZX18gKi8N
CiANCitleHRlcm4gdm9pZCBzZXRfbWVtb3J5X2VuY19kZWNfaHlwZXJjYWxsKHVuc2lnbmVkIGxv
bmcgdmFkZHIsDQorCQkJCQkgdW5zaWduZWQgbG9uZyBzaXplLCBib29sIGVuYyk7DQorDQogI2Vu
ZGlmCS8qIF9fWDg2X01FTV9FTkNSWVBUX0hfXyAqLw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L21t
L21lbV9lbmNyeXB0LmMgYi9hcmNoL3g4Ni9tbS9tZW1fZW5jcnlwdC5jDQppbmRleCBlMGRmOTZm
ZGZlNDYuLmYzZmRhMWRlMjg2OSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L21tL21lbV9lbmNyeXB0
LmMNCisrKyBiL2FyY2gveDg2L21tL21lbV9lbmNyeXB0LmMNCkBAIC0xNSw2ICsxNSw3IEBADQog
I2luY2x1ZGUgPGxpbnV4L2RtYS1kaXJlY3QuaD4NCiAjaW5jbHVkZSA8bGludXgvc3dpb3RsYi5o
Pg0KICNpbmNsdWRlIDxsaW51eC9tZW1fZW5jcnlwdC5oPg0KKyNpbmNsdWRlIDxsaW51eC9rdm1f
cGFyYS5oPg0KIA0KICNpbmNsdWRlIDxhc20vdGxiZmx1c2guaD4NCiAjaW5jbHVkZSA8YXNtL2Zp
eG1hcC5oPg0KQEAgLTI1LDYgKzI2LDcgQEANCiAjaW5jbHVkZSA8YXNtL3Byb2Nlc3Nvci1mbGFn
cy5oPg0KICNpbmNsdWRlIDxhc20vbXNyLmg+DQogI2luY2x1ZGUgPGFzbS9jbWRsaW5lLmg+DQor
I2luY2x1ZGUgPGFzbS9rdm1fcGFyYS5oPg0KIA0KICNpbmNsdWRlICJtbV9pbnRlcm5hbC5oIg0K
IA0KQEAgLTE5Miw2ICsxOTQsNDUgQEAgdm9pZCBfX2luaXQgc21lX2Vhcmx5X2luaXQodm9pZCkN
CiAJCXN3aW90bGJfZm9yY2UgPSBTV0lPVExCX0ZPUkNFOw0KIH0NCiANCit2b2lkIHNldF9tZW1v
cnlfZW5jX2RlY19oeXBlcmNhbGwodW5zaWduZWQgbG9uZyB2YWRkciwgdW5zaWduZWQgbG9uZyBz
eiwgYm9vbCBlbmMpDQorew0KKwl1bnNpZ25lZCBsb25nIHZhZGRyX2VuZCwgdmFkZHJfbmV4dDsN
CisNCisJdmFkZHJfZW5kID0gdmFkZHIgKyBzejsNCisNCisJZm9yICg7IHZhZGRyIDwgdmFkZHJf
ZW5kOyB2YWRkciA9IHZhZGRyX25leHQpIHsNCisJCWludCBwc2l6ZSwgcG1hc2ssIGxldmVsOw0K
KwkJdW5zaWduZWQgbG9uZyBwZm47DQorCQlwdGVfdCAqa3B0ZTsNCisNCisJCWtwdGUgPSBsb29r
dXBfYWRkcmVzcyh2YWRkciwgJmxldmVsKTsNCisJCWlmICgha3B0ZSB8fCBwdGVfbm9uZSgqa3B0
ZSkpDQorCQkJcmV0dXJuOw0KKw0KKwkJc3dpdGNoIChsZXZlbCkgew0KKwkJY2FzZSBQR19MRVZF
TF80SzoNCisJCQlwZm4gPSBwdGVfcGZuKCprcHRlKTsNCisJCQlicmVhazsNCisJCWNhc2UgUEdf
TEVWRUxfMk06DQorCQkJcGZuID0gcG1kX3BmbigqKHBtZF90ICopa3B0ZSk7DQorCQkJYnJlYWs7
DQorCQljYXNlIFBHX0xFVkVMXzFHOg0KKwkJCXBmbiA9IHB1ZF9wZm4oKihwdWRfdCAqKWtwdGUp
Ow0KKwkJCWJyZWFrOw0KKwkJZGVmYXVsdDoNCisJCQlyZXR1cm47DQorCQl9DQorDQorCQlwc2l6
ZSA9IHBhZ2VfbGV2ZWxfc2l6ZShsZXZlbCk7DQorCQlwbWFzayA9IHBhZ2VfbGV2ZWxfbWFzayhs
ZXZlbCk7DQorDQorCQlrdm1fc2V2X2h5cGVyY2FsbDMoS1ZNX0hDX1BBR0VfRU5DX1NUQVRVUywN
CisJCQkJICAgcGZuIDw8IFBBR0VfU0hJRlQsIHBzaXplID4+IFBBR0VfU0hJRlQsIGVuYyk7DQor
DQorCQl2YWRkcl9uZXh0ID0gKHZhZGRyICYgcG1hc2spICsgcHNpemU7DQorCX0NCit9DQorDQog
c3RhdGljIHZvaWQgX19pbml0IF9fc2V0X2Nscl9wdGVfZW5jKHB0ZV90ICprcHRlLCBpbnQgbGV2
ZWwsIGJvb2wgZW5jKQ0KIHsNCiAJcGdwcm90X3Qgb2xkX3Byb3QsIG5ld19wcm90Ow0KQEAgLTI0
OSwxMiArMjkwLDEzIEBAIHN0YXRpYyB2b2lkIF9faW5pdCBfX3NldF9jbHJfcHRlX2VuYyhwdGVf
dCAqa3B0ZSwgaW50IGxldmVsLCBib29sIGVuYykNCiBzdGF0aWMgaW50IF9faW5pdCBlYXJseV9z
ZXRfbWVtb3J5X2VuY19kZWModW5zaWduZWQgbG9uZyB2YWRkciwNCiAJCQkJCSAgIHVuc2lnbmVk
IGxvbmcgc2l6ZSwgYm9vbCBlbmMpDQogew0KLQl1bnNpZ25lZCBsb25nIHZhZGRyX2VuZCwgdmFk
ZHJfbmV4dDsNCisJdW5zaWduZWQgbG9uZyB2YWRkcl9lbmQsIHZhZGRyX25leHQsIHN0YXJ0Ow0K
IAl1bnNpZ25lZCBsb25nIHBzaXplLCBwbWFzazsNCiAJaW50IHNwbGl0X3BhZ2Vfc2l6ZV9tYXNr
Ow0KIAlpbnQgbGV2ZWwsIHJldDsNCiAJcHRlX3QgKmtwdGU7DQogDQorCXN0YXJ0ID0gdmFkZHI7
DQogCXZhZGRyX25leHQgPSB2YWRkcjsNCiAJdmFkZHJfZW5kID0gdmFkZHIgKyBzaXplOw0KIA0K
QEAgLTMwOSw2ICszNTEsNyBAQCBzdGF0aWMgaW50IF9faW5pdCBlYXJseV9zZXRfbWVtb3J5X2Vu
Y19kZWModW5zaWduZWQgbG9uZyB2YWRkciwNCiANCiAJcmV0ID0gMDsNCiANCisJc2V0X21lbW9y
eV9lbmNfZGVjX2h5cGVyY2FsbChzdGFydCwgc2l6ZSwgZW5jKTsNCiBvdXQ6DQogCV9fZmx1c2hf
dGxiX2FsbCgpOw0KIAlyZXR1cm4gcmV0Ow0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL3BhZ2Vh
dHRyLmMgYi9hcmNoL3g4Ni9tbS9wYWdlYXR0ci5jDQppbmRleCA2YTlhNzdhNDAzYzkuLjk3MWY3
MGY1OGY0OSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L21tL3BhZ2VhdHRyLmMNCisrKyBiL2FyY2gv
eDg2L21tL3BhZ2VhdHRyLmMNCkBAIC0yNiw2ICsyNiw3IEBADQogI2luY2x1ZGUgPGFzbS9wcm90
by5oPg0KICNpbmNsdWRlIDxhc20vcGF0Lmg+DQogI2luY2x1ZGUgPGFzbS9zZXRfbWVtb3J5Lmg+
DQorI2luY2x1ZGUgPGFzbS9tZW1fZW5jcnlwdC5oPg0KIA0KICNpbmNsdWRlICJtbV9pbnRlcm5h
bC5oIg0KIA0KQEAgLTIwMjAsNiArMjAyMSwxMiBAQCBpbnQgc2V0X21lbW9yeV9nbG9iYWwodW5z
aWduZWQgbG9uZyBhZGRyLCBpbnQgbnVtcGFnZXMpDQogCQkJCSAgICBfX3BncHJvdChfUEFHRV9H
TE9CQUwpLCAwKTsNCiB9DQogDQordm9pZCBfX2F0dHJpYnV0ZV9fKCh3ZWFrKSkgc2V0X21lbW9y
eV9lbmNfZGVjX2h5cGVyY2FsbCh1bnNpZ25lZCBsb25nIGFkZHIsDQorCQkJCQkJCXVuc2lnbmVk
IGxvbmcgc2l6ZSwNCisJCQkJCQkJYm9vbCBlbmMpDQorew0KK30NCisNCiBzdGF0aWMgaW50IF9f
c2V0X21lbW9yeV9lbmNfZGVjKHVuc2lnbmVkIGxvbmcgYWRkciwgaW50IG51bXBhZ2VzLCBib29s
IGVuYykNCiB7DQogCXN0cnVjdCBjcGFfZGF0YSBjcGE7DQpAQCAtMjA2MCw2ICsyMDY3LDE0IEBA
IHN0YXRpYyBpbnQgX19zZXRfbWVtb3J5X2VuY19kZWModW5zaWduZWQgbG9uZyBhZGRyLCBpbnQg
bnVtcGFnZXMsIGJvb2wgZW5jKQ0KIAkgKi8NCiAJY3BhX2ZsdXNoKCZjcGEsIDApOw0KIA0KKwkv
Kg0KKwkgKiBXaGVuIFNFViBpcyBhY3RpdmUsIG5vdGlmeSBoeXBlcnZpc29yIHRoYXQgYSBnaXZl
biBtZW1vcnkgcmFuZ2UgaXMgbWFwcGVkDQorCSAqIGVuY3J5cHRlZCBvciBkZWNyeXB0ZWQuIEh5
cGVydmlzb3Igd2lsbCB1c2UgdGhpcyBpbmZvcm1hdGlvbiBkdXJpbmcNCisJICogdGhlIFZNIG1p
Z3JhdGlvbi4NCisJICovDQorCWlmIChzZXZfYWN0aXZlKCkpDQorCQlzZXRfbWVtb3J5X2VuY19k
ZWNfaHlwZXJjYWxsKGFkZHIsIG51bXBhZ2VzIDw8IFBBR0VfU0hJRlQsIGVuYyk7DQorDQogCXJl
dHVybiByZXQ7DQogfQ0KIA0KLS0gDQoyLjE3LjENCg0K
