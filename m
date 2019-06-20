Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769864D3F6
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 18:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732300AbfFTQjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 12:39:08 -0400
Received: from mail-eopbgr770088.outbound.protection.outlook.com ([40.107.77.88]:38590
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732227AbfFTQjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 12:39:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65kw4j+nIj7bH85fEGcIyoyjDqAkDbBzIUoGLO+djjU=;
 b=NjCCU2TrdepCmQEAB0hMDLFDznw+8jeJBeMEOwAxnf2nddnU4c2fDI5qUt8MWrBGvna4lFbUhueH/mCU6xgJVV97h+cim4EOmpdq6bmDVezfGGlEkeln2zsvkYOFTlon8rWz4NpJNn3NvmMiHr30saqS3shTnzbTDV2zxEkM74I=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3914.namprd12.prod.outlook.com (10.255.174.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Thu, 20 Jun 2019 16:38:58 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 16:38:58 +0000
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
Subject: [RFC PATCH v2 10/11] mm: x86: Invoke hypercall when page encryption
 status is changed
Thread-Topic: [RFC PATCH v2 10/11] mm: x86: Invoke hypercall when page
 encryption status is changed
Thread-Index: AQHVJ4aoL9SIPauJiU+/IFnPleXg4w==
Date:   Thu, 20 Jun 2019 16:38:58 +0000
Message-ID: <20190620163832.5451-11-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: 89e825ad-045b-4841-d322-08d6f59dcaf3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3914;
x-ms-traffictypediagnostic: DM6PR12MB3914:
x-microsoft-antispam-prvs: <DM6PR12MB3914A85BF53A025FCAA97028E5E40@DM6PR12MB3914.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(52116002)(54906003)(86362001)(305945005)(256004)(6916009)(71190400001)(2501003)(71200400001)(6116002)(2906002)(25786009)(6512007)(53936002)(66446008)(6506007)(5640700003)(386003)(7416002)(14444005)(2351001)(66476007)(66556008)(7736002)(486006)(5660300002)(11346002)(476003)(99286004)(446003)(73956011)(68736007)(8936002)(6436002)(66946007)(478600001)(64756008)(4326008)(6486002)(3846002)(36756003)(66066001)(1730700003)(14454004)(81166006)(1076003)(102836004)(66574012)(81156014)(50226002)(186003)(8676002)(26005)(316002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3914;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f/KhYjudbXwaSfJ8IiaAlDhTgxQviOsy7BqzCaD2FkRX3O9bniWMDW8BQJSiGN1kfZXicMTr1AjCjxrl1bBDZ/rFvxctVSFIcuZLAsEiF3bShfzhB0212tTJNEymKcJjfnTh5WUUo0R7cOY3OH7OuC6qQaIecnOYF23eLIW+DeDunZTy9X0A4GeBQx8+cMr3VUNzb/bL3du9MTJi16lECaVUnodnR5Fa/bRblltlGibQSf/I4Z+YHXwHyvLy5pHW7d4t9P46gikeXmyP47CEDSuAzw9D7+41oxQqHsoiE8F8FS0Rv4B4BYZeijJWA63JMCI3AuGt/hHLpHCPZrt8QMWHfPH6FjLlrBvY7uVHSN1P7Ek0vlg76v6ocWbxbMsFGbMIFZp23YU/MMejDV9+OlOuOXC3sQCCSS6AmEFEKtg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCD59C89494D11439A72942668298F75@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e825ad-045b-4841-d322-08d6f59dcaf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 16:38:58.6479
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
ODYvaW5jbHVkZS9hc20vbWVtX2VuY3J5cHQuaA0KaW5kZXggNjE2ZjhlNjM3YmMzLi4zZjQzY2Zk
ZDAyMDkgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tZW1fZW5jcnlwdC5oDQor
KysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tZW1fZW5jcnlwdC5oDQpAQCAtOTcsNCArOTcsNyBA
QCBleHRlcm4gY2hhciBfX3N0YXJ0X2Jzc19kZWNyeXB0ZWRbXSwgX19lbmRfYnNzX2RlY3J5cHRl
ZFtdLCBfX3N0YXJ0X2Jzc19kZWNyeXB0ZQ0KIA0KICNlbmRpZgkvKiBfX0FTU0VNQkxZX18gKi8N
CiANCitleHRlcm4gdm9pZCBzZXRfbWVtb3J5X2VuY19kZWNfaHlwZXJjYWxsKHVuc2lnbmVkIGxv
bmcgdmFkZHIsDQorCQkJCQkgdW5zaWduZWQgbG9uZyBzaXplLCBib29sIGVuYyk7DQorDQogI2Vu
ZGlmCS8qIF9fWDg2X01FTV9FTkNSWVBUX0hfXyAqLw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L21t
L21lbV9lbmNyeXB0LmMgYi9hcmNoL3g4Ni9tbS9tZW1fZW5jcnlwdC5jDQppbmRleCA1MWY1MGE3
YTA3ZWYuLjU1YTRjODA2Nzg2ZCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L21tL21lbV9lbmNyeXB0
LmMNCisrKyBiL2FyY2gveDg2L21tL21lbV9lbmNyeXB0LmMNCkBAIC0xOCw2ICsxOCw3IEBADQog
I2luY2x1ZGUgPGxpbnV4L2RtYS1kaXJlY3QuaD4NCiAjaW5jbHVkZSA8bGludXgvc3dpb3RsYi5o
Pg0KICNpbmNsdWRlIDxsaW51eC9tZW1fZW5jcnlwdC5oPg0KKyNpbmNsdWRlIDxsaW51eC9rdm1f
cGFyYS5oPg0KIA0KICNpbmNsdWRlIDxhc20vdGxiZmx1c2guaD4NCiAjaW5jbHVkZSA8YXNtL2Zp
eG1hcC5oPg0KQEAgLTI4LDYgKzI5LDcgQEANCiAjaW5jbHVkZSA8YXNtL3Byb2Nlc3Nvci1mbGFn
cy5oPg0KICNpbmNsdWRlIDxhc20vbXNyLmg+DQogI2luY2x1ZGUgPGFzbS9jbWRsaW5lLmg+DQor
I2luY2x1ZGUgPGFzbS9rdm1fcGFyYS5oPg0KIA0KICNpbmNsdWRlICJtbV9pbnRlcm5hbC5oIg0K
IA0KQEAgLTE5NSw2ICsxOTcsNDUgQEAgdm9pZCBfX2luaXQgc21lX2Vhcmx5X2luaXQodm9pZCkN
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
ZWwsIGJvb2wgZW5jKQ0KIHsNCiAJcGdwcm90X3Qgb2xkX3Byb3QsIG5ld19wcm90Ow0KQEAgLTI1
MiwxMiArMjkzLDEzIEBAIHN0YXRpYyB2b2lkIF9faW5pdCBfX3NldF9jbHJfcHRlX2VuYyhwdGVf
dCAqa3B0ZSwgaW50IGxldmVsLCBib29sIGVuYykNCiBzdGF0aWMgaW50IF9faW5pdCBlYXJseV9z
ZXRfbWVtb3J5X2VuY19kZWModW5zaWduZWQgbG9uZyB2YWRkciwNCiAJCQkJCSAgIHVuc2lnbmVk
IGxvbmcgc2l6ZSwgYm9vbCBlbmMpDQogew0KLQl1bnNpZ25lZCBsb25nIHZhZGRyX2VuZCwgdmFk
ZHJfbmV4dDsNCisJdW5zaWduZWQgbG9uZyB2YWRkcl9lbmQsIHZhZGRyX25leHQsIHN0YXJ0Ow0K
IAl1bnNpZ25lZCBsb25nIHBzaXplLCBwbWFzazsNCiAJaW50IHNwbGl0X3BhZ2Vfc2l6ZV9tYXNr
Ow0KIAlpbnQgbGV2ZWwsIHJldDsNCiAJcHRlX3QgKmtwdGU7DQogDQorCXN0YXJ0ID0gdmFkZHI7
DQogCXZhZGRyX25leHQgPSB2YWRkcjsNCiAJdmFkZHJfZW5kID0gdmFkZHIgKyBzaXplOw0KIA0K
QEAgLTMxMiw2ICszNTQsNyBAQCBzdGF0aWMgaW50IF9faW5pdCBlYXJseV9zZXRfbWVtb3J5X2Vu
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
