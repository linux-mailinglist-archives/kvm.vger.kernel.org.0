Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99294D3ED
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 18:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732246AbfFTQjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 12:39:02 -0400
Received: from mail-eopbgr780044.outbound.protection.outlook.com ([40.107.78.44]:56128
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732227AbfFTQjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 12:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIDhuwpdNoZZzaAiozaYieMpP+TSCYN/t/wib5gzffE=;
 b=RTfSJIFKhL184U1wR8x0QYqTnrnKr0CBBHNOup31D07XI9YRr5H8wjPN2w64v535bzUflojV/VgSWmJK5FFdhY0xq6b5nJqqhYkgBFMtuGkaWnkNUIRrcY8wjWc2wlZsVBoaot3DcTd7z1he4m4HRiZssN5UT1IfDITaEDfQZuA=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3402.namprd12.prod.outlook.com (20.178.198.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 20 Jun 2019 16:38:57 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 16:38:57 +0000
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
Subject: [RFC PATCH v2 09/11] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP
 ioctl
Thread-Topic: [RFC PATCH v2 09/11] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP
 ioctl
Thread-Index: AQHVJ4aofLcEYvDS006/L5KMdAGS8w==
Date:   Thu, 20 Jun 2019 16:38:57 +0000
Message-ID: <20190620163832.5451-10-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: c4709a77-eadc-4429-a850-08d6f59dca69
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3402;
x-ms-traffictypediagnostic: DM6PR12MB3402:
x-microsoft-antispam-prvs: <DM6PR12MB3402DC30CDE35CDC897F9EE1E5E40@DM6PR12MB3402.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:416;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(189003)(4326008)(186003)(256004)(476003)(99286004)(50226002)(14444005)(2501003)(1076003)(478600001)(66574012)(53936002)(26005)(446003)(305945005)(68736007)(5660300002)(66066001)(11346002)(2616005)(486006)(8936002)(8676002)(81156014)(3846002)(6116002)(81166006)(1730700003)(6506007)(6486002)(6436002)(2906002)(6916009)(71190400001)(2351001)(54906003)(6512007)(316002)(14454004)(386003)(102836004)(5640700003)(76176011)(73956011)(36756003)(7736002)(66946007)(66446008)(64756008)(66556008)(66476007)(86362001)(52116002)(25786009)(7416002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3402;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZSgCRYp5A8SVEXVqxu516eUA1vaYwh0JkRz5jn2Uv8Fg0xCCkTudLo8ENfTC9u4W41GC/x2ZcV040uiCxmQovDXxP+/sWu7kAKBvR5GUHEJSS0SVzLlp6RfceNlxwylZTcEllsbHZUrWoPkvtdPUgaSAaHGdzaKCG6Z75uCzWCWS3QQNUAkdyfLYVT0fcrzXnBLRD5BEhiC7QkV8PTOZo0OOxcO9SSza6FcrFwE+VIOpJooEdGoFTIo1fgIlNGG7E2f+N3715+3WKSlSFln7pVojoHQ9nbrYV5KZinal33EAJg3sm1M9seLz0N1Dz7lqhNnYMbkmMwtzPNKsu8Fdk+nSJVbY1xXr9S6A5sr9G/Jo+Df0r8vw2/B/BVlMNWKDmilSNB/fEnn7hh6V2B6dGVzZg1KIjUFgI3MrztZNQY4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <100AF63F5970654D80DBFF78A7046288@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4709a77-eadc-4429-a850-08d6f59dca69
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 16:38:57.8114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3402
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlIGlvY3RsIGNhbiBiZSB1c2VkIHRvIHJldHJpZXZlIHBhZ2UgZW5jcnlwdGlvbiBiaXRtYXAg
Zm9yIGEgZ2l2ZW4NCmdmbiByYW5nZS4NCg0KQ2M6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51
dHJvbml4LmRlPg0KQ2M6IEluZ28gTW9sbmFyIDxtaW5nb0ByZWRoYXQuY29tPg0KQ2M6ICJILiBQ
ZXRlciBBbnZpbiIgPGhwYUB6eXRvci5jb20+DQpDYzogUGFvbG8gQm9uemluaSA8cGJvbnppbmlA
cmVkaGF0LmNvbT4NCkNjOiAiUmFkaW0gS3LEjW3DocWZIiA8cmtyY21hckByZWRoYXQuY29tPg0K
Q2M6IEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPg0KQ2M6IEJvcmlzbGF2IFBldGtvdiA8
YnBAc3VzZS5kZT4NCkNjOiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPg0K
Q2M6IHg4NkBrZXJuZWwub3JnDQpDYzoga3ZtQHZnZXIua2VybmVsLm9yZw0KQ2M6IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmcNClNpZ25lZC1vZmYtYnk6IEJyaWplc2ggU2luZ2ggPGJyaWpl
c2guc2luZ2hAYW1kLmNvbT4NCi0tLQ0KIGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0Lmgg
fCAgMSArDQogYXJjaC94ODYva3ZtL3N2bS5jICAgICAgICAgICAgICB8IDQ0ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrLQ0KIGFyY2gveDg2L2t2bS94ODYuYyAgICAgICAgICAgICAg
fCAxMiArKysrKysrKysNCiBpbmNsdWRlL3VhcGkvbGludXgva3ZtLmggICAgICAgIHwgMTIgKysr
KysrKysrDQogNCBmaWxlcyBjaGFuZ2VkLCA2OCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIGIvYXJjaC94
ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KaW5kZXggYTU0ZmVmOTc5YThlLi40ZGRhNTg5MTIw
MGQgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQorKysgYi9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQpAQCAtMTIwNCw2ICsxMjA0LDcgQEAgc3Ry
dWN0IGt2bV94ODZfb3BzIHsNCiAJYm9vbCAoKm5lZWRfZW11bGF0aW9uX29uX3BhZ2VfZmF1bHQp
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQogCWludCAoKnBhZ2VfZW5jX3N0YXR1c19oYykoc3Ry
dWN0IGt2bSAqa3ZtLCB1bnNpZ25lZCBsb25nIGdwYSwNCiAJCQkJICB1bnNpZ25lZCBsb25nIHN6
LCB1bnNpZ25lZCBsb25nIG1vZGUpOw0KKwlpbnQgKCpnZXRfcGFnZV9lbmNfYml0bWFwKShzdHJ1
Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fcGFnZV9lbmNfYml0bWFwICpibWFwKTsNCiB9Ow0KIA0K
IHN0cnVjdCBrdm1fYXJjaF9hc3luY19wZiB7DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2
bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQppbmRleCBiNDdhMDVhNWUxMzcuLmFmOWIzM2U0YmI1
MyAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9zdm0uYw0KKysrIGIvYXJjaC94ODYva3ZtL3N2
bS5jDQpAQCAtNzQyMSw2ICs3NDIxLDQ3IEBAIHN0YXRpYyBpbnQgc3ZtX3BhZ2VfZW5jX3N0YXR1
c19oYyhzdHJ1Y3Qga3ZtICprdm0sIHVuc2lnbmVkIGxvbmcgZ3BhLA0KIAlyZXR1cm4gcmV0Ow0K
IH0NCiANCitzdGF0aWMgaW50IHN2bV9nZXRfcGFnZV9lbmNfYml0bWFwKHN0cnVjdCBrdm0gKmt2
bSwNCisJCQkJICAgc3RydWN0IGt2bV9wYWdlX2VuY19iaXRtYXAgKmJtYXApDQorew0KKwlzdHJ1
Y3Qga3ZtX3Nldl9pbmZvICpzZXYgPSAmdG9fa3ZtX3N2bShrdm0pLT5zZXZfaW5mbzsNCisJdW5z
aWduZWQgbG9uZyBnZm5fc3RhcnQsIGdmbl9lbmQ7DQorCXVuc2lnbmVkIGxvbmcgKmJpdG1hcDsN
CisJdW5zaWduZWQgbG9uZyBzeiwgaTsNCisJaW50IHJldDsNCisNCisJaWYgKCFzZXZfZ3Vlc3Qo
a3ZtKSkNCisJCXJldHVybiAtRU5PVFRZOw0KKw0KKwlnZm5fc3RhcnQgPSBibWFwLT5zdGFydDsN
CisJZ2ZuX2VuZCA9IGdmbl9zdGFydCArIGJtYXAtPm51bV9wYWdlczsNCisNCisJc3ogPSBBTElH
TihibWFwLT5udW1fcGFnZXMsIEJJVFNfUEVSX0xPTkcpIC8gODsNCisJYml0bWFwID0ga21hbGxv
YyhzeiwgR0ZQX0tFUk5FTCk7DQorCWlmICghYml0bWFwKQ0KKwkJcmV0dXJuIC1FTk9NRU07DQor
DQorCW1lbXNldChiaXRtYXAsIDB4ZmYsIHN6KTsgLyogYnkgZGVmYXVsdCBhbGwgcGFnZXMgYXJl
IG1hcmtlZCBlbmNyeXB0ZWQgKi8NCisNCisJbXV0ZXhfbG9jaygma3ZtLT5sb2NrKTsNCisJaWYg
KHNldi0+cGFnZV9lbmNfYm1hcCkgew0KKwkJaSA9IGdmbl9zdGFydDsNCisJCWZvcl9lYWNoX2Ns
ZWFyX2JpdF9mcm9tKGksIHNldi0+cGFnZV9lbmNfYm1hcCwNCisJCQkJICAgICAgbWluKHNldi0+
cGFnZV9lbmNfYm1hcF9zaXplLCBnZm5fZW5kKSkNCisJCQljbGVhcl9iaXQoaSAtIGdmbl9zdGFy
dCwgYml0bWFwKTsNCisJfQ0KKwltdXRleF91bmxvY2soJmt2bS0+bG9jayk7DQorDQorCXJldCA9
IC1FRkFVTFQ7DQorCWlmIChjb3B5X3RvX3VzZXIoYm1hcC0+ZW5jX2JpdG1hcCwgYml0bWFwLCBz
eikpDQorCQlnb3RvIG91dDsNCisNCisJcmV0ID0gMDsNCitvdXQ6DQorCWtmcmVlKGJpdG1hcCk7
DQorCXJldHVybiByZXQ7DQorfQ0KKw0KIHN0YXRpYyBpbnQgc3ZtX21lbV9lbmNfb3Aoc3RydWN0
IGt2bSAqa3ZtLCB2b2lkIF9fdXNlciAqYXJncCkNCiB7DQogCXN0cnVjdCBrdm1fc2V2X2NtZCBz
ZXZfY21kOw0KQEAgLTc3NjMsNyArNzgwNCw4IEBAIHN0YXRpYyBzdHJ1Y3Qga3ZtX3g4Nl9vcHMg
c3ZtX3g4Nl9vcHMgX19yb19hZnRlcl9pbml0ID0gew0KIA0KIAkubmVlZF9lbXVsYXRpb25fb25f
cGFnZV9mYXVsdCA9IHN2bV9uZWVkX2VtdWxhdGlvbl9vbl9wYWdlX2ZhdWx0LA0KIA0KLQkucGFn
ZV9lbmNfc3RhdHVzX2hjID0gc3ZtX3BhZ2VfZW5jX3N0YXR1c19oYw0KKwkucGFnZV9lbmNfc3Rh
dHVzX2hjID0gc3ZtX3BhZ2VfZW5jX3N0YXR1c19oYywNCisJLmdldF9wYWdlX2VuY19iaXRtYXAg
PSBzdm1fZ2V0X3BhZ2VfZW5jX2JpdG1hcA0KIH07DQogDQogc3RhdGljIGludCBfX2luaXQgc3Zt
X2luaXQodm9pZCkNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9r
dm0veDg2LmMNCmluZGV4IDg4YTY3MmRhNjhkNS4uY2VjOTg2ZWJjNzkzIDEwMDY0NA0KLS0tIGEv
YXJjaC94ODYva3ZtL3g4Ni5jDQorKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCkBAIC00OTI5LDYg
KzQ5MjksMTggQEAgbG9uZyBrdm1fYXJjaF92bV9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlscCwNCiAJ
CXIgPSBrdm1fdm1faW9jdGxfaHZfZXZlbnRmZChrdm0sICZodmV2ZmQpOw0KIAkJYnJlYWs7DQog
CX0NCisJY2FzZSBLVk1fR0VUX1BBR0VfRU5DX0JJVE1BUDogew0KKwkJc3RydWN0IGt2bV9wYWdl
X2VuY19iaXRtYXAgYml0bWFwOw0KKw0KKwkJciA9IC1FRkFVTFQ7DQorCQlpZiAoY29weV9mcm9t
X3VzZXIoJmJpdG1hcCwgYXJncCwgc2l6ZW9mKGJpdG1hcCkpKQ0KKwkJCWdvdG8gb3V0Ow0KKw0K
KwkJciA9IC1FTk9UVFk7DQorCQlpZiAoa3ZtX3g4Nl9vcHMtPmdldF9wYWdlX2VuY19iaXRtYXAp
DQorCQkJciA9IGt2bV94ODZfb3BzLT5nZXRfcGFnZV9lbmNfYml0bWFwKGt2bSwgJmJpdG1hcCk7
DQorCQlicmVhazsNCisJfQ0KIAlkZWZhdWx0Og0KIAkJciA9IC1FTk9UVFk7DQogCX0NCmRpZmYg
LS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmggYi9pbmNsdWRlL3VhcGkvbGludXgva3Zt
LmgNCmluZGV4IGUzMWNkYjQxNTE5Zi4uY2U0YWU4OTI5ZDAwIDEwMDY0NA0KLS0tIGEvaW5jbHVk
ZS91YXBpL2xpbnV4L2t2bS5oDQorKysgYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCkBAIC00
OTIsNiArNDkyLDE2IEBAIHN0cnVjdCBrdm1fZGlydHlfbG9nIHsNCiAJfTsNCiB9Ow0KIA0KKy8q
IGZvciBLVk1fR0VUX1BBR0VfRU5DX0JJVE1BUCAqLw0KK3N0cnVjdCBrdm1fcGFnZV9lbmNfYml0
bWFwIHsNCisJX191NjQgc3RhcnQ7DQorCV9fdTY0IG51bV9wYWdlczsNCisJdW5pb24gew0KKwkJ
dm9pZCBfX3VzZXIgKmVuY19iaXRtYXA7IC8qIG9uZSBiaXQgcGVyIHBhZ2UgKi8NCisJCV9fdTY0
IHBhZGRpbmcyOw0KKwl9Ow0KK307DQorDQogLyogZm9yIEtWTV9DTEVBUl9ESVJUWV9MT0cgKi8N
CiBzdHJ1Y3Qga3ZtX2NsZWFyX2RpcnR5X2xvZyB7DQogCV9fdTMyIHNsb3Q7DQpAQCAtMTQ1MSw2
ICsxNDYxLDggQEAgc3RydWN0IGt2bV9lbmNfcmVnaW9uIHsNCiAvKiBBdmFpbGFibGUgd2l0aCBL
Vk1fQ0FQX0FSTV9TVkUgKi8NCiAjZGVmaW5lIEtWTV9BUk1fVkNQVV9GSU5BTElaRQkgIF9JT1co
S1ZNSU8sICAweGMyLCBpbnQpDQogDQorI2RlZmluZSBLVk1fR0VUX1BBR0VfRU5DX0JJVE1BUAlf
SU9XKEtWTUlPLCAweGMyLCBzdHJ1Y3Qga3ZtX3BhZ2VfZW5jX2JpdG1hcCkNCisNCiAvKiBTZWN1
cmUgRW5jcnlwdGVkIFZpcnR1YWxpemF0aW9uIGNvbW1hbmQgKi8NCiBlbnVtIHNldl9jbWRfaWQg
ew0KIAkvKiBHdWVzdCBpbml0aWFsaXphdGlvbiBjb21tYW5kcyAqLw0KLS0gDQoyLjE3LjENCg0K
