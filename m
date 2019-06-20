Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2773B4D3F9
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 18:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732267AbfFTQjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 12:39:04 -0400
Received: from mail-eopbgr770082.outbound.protection.outlook.com ([40.107.77.82]:17878
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732191AbfFTQjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 12:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yEqLXdHA8YKJNBY9MZ+JiBArP82BjiJD6+bZEM9Ni1k=;
 b=F2spIOfCGko9R9rMHgoIJTcoypVZN5mg7tbqSeeAIdmyoL6SNNErehN/osGJiSNzPeJnNSFevZxtX7m0X6+FWNN8OLLpTomzgwuPODDqDj66DvyUH8KoN3lm7LSRBzgkd9zVdjSeMz5to8XsajHmtglLkhQpqHh/uoCOr9bVFu0=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3914.namprd12.prod.outlook.com (10.255.174.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Thu, 20 Jun 2019 16:38:54 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 16:38:54 +0000
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
Subject: [RFC PATCH v2 05/11] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA
 command
Thread-Topic: [RFC PATCH v2 05/11] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA
 command
Thread-Index: AQHVJ4am6aYlKKczIEabW8drEZ3wiQ==
Date:   Thu, 20 Jun 2019 16:38:54 +0000
Message-ID: <20190620163832.5451-6-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: ba0ed45e-366e-4899-040b-08d6f59dc858
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3914;
x-ms-traffictypediagnostic: DM6PR12MB3914:
x-microsoft-antispam-prvs: <DM6PR12MB391452AF8AD63609379E0EB4E5E40@DM6PR12MB3914.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(52116002)(54906003)(86362001)(305945005)(256004)(6916009)(71190400001)(2501003)(71200400001)(6116002)(2906002)(25786009)(6512007)(53936002)(66446008)(6506007)(5640700003)(386003)(7416002)(14444005)(2351001)(66476007)(66556008)(7736002)(486006)(5660300002)(11346002)(476003)(99286004)(446003)(73956011)(68736007)(8936002)(6436002)(66946007)(478600001)(64756008)(4326008)(6486002)(3846002)(36756003)(66066001)(1730700003)(14454004)(81166006)(1076003)(102836004)(66574012)(81156014)(50226002)(186003)(8676002)(26005)(316002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3914;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DER4viwojDnl1EcH+Yi2tmFQpSOog5zbNUUBqsv5pv2zUDAHjkefvWp0GRyw2SOz6BnsBZE3mCln1B0ry0QYEiFw52/n/H1LPuHI7qrblPYEyVES7JaTPjfnHW7CUIGf8DbLbtJSlDGVvU6ktQtTVkZU/wE0dWPHJDfkKlgJX9Gepao8UTp7hlcL4NPVgH2ksEu13iq5mCe6FpMv+gHLifBWVxzs0eRGpv5H7v+sYbmXvt9VZCD++4QdQYqcLmdkAhsMdMnVEapWR/10mx3fpowrNxITqZMEh0BWuOCBIzTmiAzPKjqmfOUygPlYKBFfZWd5jk6xCEKunA1gVciugQa1eELbVjCfMkK2ZdiF3wJhhVui2QjT/v5ywRe3W/uaWWdaVKjA92dqLKW49xpkqiCXogZS3BG4KyEwhpNetV8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A757C40101C13D42A28B6208C6608A0C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0ed45e-366e-4899-040b-08d6f59dc858
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 16:38:54.2853
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

VGhlIGNvbW1hbmQgaXMgdXNlZCBmb3IgY29weWluZyB0aGUgaW5jb21pbmcgYnVmZmVyIGludG8g
dGhlDQpTRVYgZ3Vlc3QgbWVtb3J5IHNwYWNlLg0KDQpDYzogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4
QGxpbnV0cm9uaXguZGU+DQpDYzogSW5nbyBNb2xuYXIgPG1pbmdvQHJlZGhhdC5jb20+DQpDYzog
IkguIFBldGVyIEFudmluIiA8aHBhQHp5dG9yLmNvbT4NCkNjOiBQYW9sbyBCb256aW5pIDxwYm9u
emluaUByZWRoYXQuY29tPg0KQ2M6ICJSYWRpbSBLcsSNbcOhxZkiIDxya3JjbWFyQHJlZGhhdC5j
b20+DQpDYzogSm9lcmcgUm9lZGVsIDxqb3JvQDhieXRlcy5vcmc+DQpDYzogQm9yaXNsYXYgUGV0
a292IDxicEBzdXNlLmRlPg0KQ2M6IFRvbSBMZW5kYWNreSA8dGhvbWFzLmxlbmRhY2t5QGFtZC5j
b20+DQpDYzogeDg2QGtlcm5lbC5vcmcNCkNjOiBrdm1Admdlci5rZXJuZWwub3JnDQpDYzogbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KU2lnbmVkLW9mZi1ieTogQnJpamVzaCBTaW5naCA8
YnJpamVzaC5zaW5naEBhbWQuY29tPg0KLS0tDQogLi4uL3ZpcnR1YWwva3ZtL2FtZC1tZW1vcnkt
ZW5jcnlwdGlvbi5yc3QgICAgIHwgMjQgKysrKysrDQogYXJjaC94ODYva3ZtL3N2bS5jICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgNzUgKysrKysrKysrKysrKysrKysrKw0KIGluY2x1ZGUv
dWFwaS9saW51eC9rdm0uaCAgICAgICAgICAgICAgICAgICAgICB8ICA5ICsrKw0KIDMgZmlsZXMg
Y2hhbmdlZCwgMTA4IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24v
dmlydHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdCBiL0RvY3VtZW50YXRpb24vdmly
dHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdA0KaW5kZXggODVhYmUwODcxMDMxLi42
Y2U0Y2VkYjg0ZTQgMTAwNjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2FtZC1t
ZW1vcnktZW5jcnlwdGlvbi5yc3QNCisrKyBiL0RvY3VtZW50YXRpb24vdmlydHVhbC9rdm0vYW1k
LW1lbW9yeS1lbmNyeXB0aW9uLnJzdA0KQEAgLTMyNiw2ICszMjYsMzAgQEAgT24gc3VjY2Vzcywg
dGhlICdoYW5kbGUnIGZpZWxkIGNvbnRhaW5zIGEgbmV3IGhhbmRsZSBhbmQgb24gZXJyb3IsIGEg
bmVnYXRpdmUgdmENCiANCiBGb3IgbW9yZSBkZXRhaWxzLCBzZWUgU0VWIHNwZWMgU2VjdGlvbiA2
LjEyLg0KIA0KKzE0LiBLVk1fU0VWX1JFQ0VJVkVfVVBEQVRFX0RBVEENCistLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQorDQorVGhlIEtWTV9TRVZfUkVDRUlWRV9VUERBVEVfREFUQSBjb21t
YW5kIGNhbiBiZSB1c2VkIGJ5IHRoZSBoeXBlcnZpc29yIHRvIGNvcHkNCit0aGUgaW5jb21pbmcg
YnVmZmVycyBpbnRvIHRoZSBndWVzdCBtZW1vcnkgcmVnaW9uIHdpdGggZW5jcnlwdGlvbiBjb250
ZXh0DQorY3JlYXRlZCBkdXJpbmcgdGhlIEtWTV9TRVZfUkVDRUlWRV9TVEFSVC4NCisNCitQYXJh
bWV0ZXJzIChpbik6IHN0cnVjdCBrdm1fc2V2X3JlY2VpdmVfdXBkYXRlX2RhdGENCisNCitSZXR1
cm5zOiAwIG9uIHN1Y2Nlc3MsIC1uZWdhdGl2ZSBvbiBlcnJvcg0KKw0KKzo6DQorDQorICAgICAg
ICBzdHJ1Y3Qga3ZtX3Nldl9sYXVuY2hfcmVjZWl2ZV91cGRhdGVfZGF0YSB7DQorICAgICAgICAg
ICAgICAgIF9fdTY0IGhkcl91YWRkcjsgICAgICAgIC8qIHVzZXJzcGFjZSBhZGRyZXNzIGNvbnRh
aW5pbmcgdGhlIHBhY2tldCBoZWFkZXIgKi8NCisgICAgICAgICAgICAgICAgX191MzIgaGRyX2xl
bjsNCisNCisgICAgICAgICAgICAgICAgX191NjQgZ3Vlc3RfdWFkZHI7ICAgICAgLyogdGhlIGRl
c3RpbmF0aW9uIGd1ZXN0IG1lbW9yeSByZWdpb24gKi8NCisgICAgICAgICAgICAgICAgX191MzIg
Z3Vlc3RfbGVuOw0KKw0KKyAgICAgICAgICAgICAgICBfX3U2NCB0cmFuc191YWRkcjsgICAgICAv
KiB0aGUgaW5jb21pbmcgYnVmZmVyIG1lbW9yeSByZWdpb24gICovDQorICAgICAgICAgICAgICAg
IF9fdTMyIHRyYW5zX2xlbjsNCisgICAgICAgIH07DQorDQogUmVmZXJlbmNlcw0KID09PT09PT09
PT0NCiANCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3Zt
LmMNCmluZGV4IDk0YTU1ZTQxMjhhYS4uNTFlOGMyYmYyOGRiIDEwMDY0NA0KLS0tIGEvYXJjaC94
ODYva3ZtL3N2bS5jDQorKysgYi9hcmNoL3g4Ni9rdm0vc3ZtLmMNCkBAIC03MjY4LDYgKzcyNjgs
NzggQEAgc3RhdGljIGludCBzZXZfcmVjZWl2ZV9zdGFydChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVj
dCBrdm1fc2V2X2NtZCAqYXJncCkNCiAJcmV0dXJuIHJldDsNCiB9DQogDQorc3RhdGljIGludCBz
ZXZfcmVjZWl2ZV91cGRhdGVfZGF0YShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fc2V2X2Nt
ZCAqYXJncCkNCit7DQorCXN0cnVjdCBrdm1fc2V2X2luZm8gKnNldiA9ICZ0b19rdm1fc3ZtKGt2
bSktPnNldl9pbmZvOw0KKwlzdHJ1Y3Qga3ZtX3Nldl9yZWNlaXZlX3VwZGF0ZV9kYXRhIHBhcmFt
czsNCisJc3RydWN0IHNldl9kYXRhX3JlY2VpdmVfdXBkYXRlX2RhdGEgKmRhdGE7DQorCXZvaWQg
KmhkciA9IE5VTEwsICp0cmFucyA9IE5VTEw7DQorCXN0cnVjdCBwYWdlICoqZ3Vlc3RfcGFnZTsN
CisJdW5zaWduZWQgbG9uZyBuOw0KKwlpbnQgcmV0LCBvZmZzZXQ7DQorDQorCWlmICghc2V2X2d1
ZXN0KGt2bSkpDQorCQlyZXR1cm4gLUVJTlZBTDsNCisNCisJaWYgKGNvcHlfZnJvbV91c2VyKCZw
YXJhbXMsICh2b2lkIF9fdXNlciAqKSh1aW50cHRyX3QpYXJncC0+ZGF0YSwNCisJCQlzaXplb2Yo
c3RydWN0IGt2bV9zZXZfcmVjZWl2ZV91cGRhdGVfZGF0YSkpKQ0KKwkJcmV0dXJuIC1FRkFVTFQ7
DQorDQorCWlmICghcGFyYW1zLmhkcl91YWRkciB8fCAhcGFyYW1zLmhkcl9sZW4gfHwNCisJICAg
ICFwYXJhbXMuZ3Vlc3RfdWFkZHIgfHwgIXBhcmFtcy5ndWVzdF9sZW4gfHwNCisJICAgICFwYXJh
bXMudHJhbnNfdWFkZHIgfHwgIXBhcmFtcy50cmFuc19sZW4pDQorCQlyZXR1cm4gLUVJTlZBTDsN
CisNCisJLyogQ2hlY2sgaWYgd2UgYXJlIGNyb3NzaW5nIHRoZSBwYWdlIGJvdW5kcnkgKi8NCisJ
b2Zmc2V0ID0gcGFyYW1zLmd1ZXN0X3VhZGRyICYgKFBBR0VfU0laRSAtIDEpOw0KKwlpZiAoKHBh
cmFtcy5ndWVzdF9sZW4gKyBvZmZzZXQgPiBQQUdFX1NJWkUpKQ0KKwkJcmV0dXJuIC1FSU5WQUw7
DQorDQorCWRhdGEgPSBremFsbG9jKHNpemVvZigqZGF0YSksIEdGUF9LRVJORUwpOw0KKwlpZiAo
IWRhdGEpDQorCQlyZXR1cm4gLUVOT01FTTsNCisNCisJaGRyID0gcHNwX2NvcHlfdXNlcl9ibG9i
KHBhcmFtcy5oZHJfdWFkZHIsIHBhcmFtcy5oZHJfbGVuKTsNCisJaWYgKElTX0VSUihoZHIpKSB7
DQorCQlyZXQgPSBQVFJfRVJSKGhkcik7DQorCQlnb3RvIGVfZnJlZTsNCisJfQ0KKw0KKwlkYXRh
LT5oZHJfYWRkcmVzcyA9IF9fcHNwX3BhKGhkcik7DQorCWRhdGEtPmhkcl9sZW4gPSBwYXJhbXMu
aGRyX2xlbjsNCisNCisJdHJhbnMgPSBwc3BfY29weV91c2VyX2Jsb2IocGFyYW1zLnRyYW5zX3Vh
ZGRyLCBwYXJhbXMudHJhbnNfbGVuKTsNCisJaWYgKElTX0VSUih0cmFucykpIHsNCisJCXJldCA9
IFBUUl9FUlIodHJhbnMpOw0KKwkJZ290byBlX2ZyZWU7DQorCX0NCisNCisJZGF0YS0+dHJhbnNf
YWRkcmVzcyA9IF9fcHNwX3BhKHRyYW5zKTsNCisJZGF0YS0+dHJhbnNfbGVuID0gcGFyYW1zLnRy
YW5zX2xlbjsNCisNCisJLyogUGluIGd1ZXN0IG1lbW9yeSAqLw0KKwlyZXQgPSAtRUZBVUxUOw0K
KwlndWVzdF9wYWdlID0gc2V2X3Bpbl9tZW1vcnkoa3ZtLCBwYXJhbXMuZ3Vlc3RfdWFkZHIgJiBQ
QUdFX01BU0ssDQorCQkJCSAgICBQQUdFX1NJWkUsICZuLCAwKTsNCisJaWYgKCFndWVzdF9wYWdl
KQ0KKwkJZ290byBlX2ZyZWU7DQorDQorCS8qIFRoZSBSRUNFSVZFX1VQREFURV9EQVRBIGNvbW1h
bmQgcmVxdWlyZXMgQy1iaXQgdG8gYmUgYWx3YXlzIHNldC4gKi8NCisJZGF0YS0+Z3Vlc3RfYWRk
cmVzcyA9IChwYWdlX3RvX3BmbihndWVzdF9wYWdlWzBdKSA8PCBQQUdFX1NISUZUKSArIG9mZnNl
dDsNCisJZGF0YS0+Z3Vlc3RfYWRkcmVzcyB8PSBzZXZfbWVfbWFzazsNCisJZGF0YS0+Z3Vlc3Rf
bGVuID0gcGFyYW1zLmd1ZXN0X2xlbjsNCisNCisJZGF0YS0+aGFuZGxlID0gc2V2LT5oYW5kbGU7
DQorCXJldCA9IHNldl9pc3N1ZV9jbWQoa3ZtLCBTRVZfQ01EX1JFQ0VJVkVfVVBEQVRFX0RBVEEs
IGRhdGEsICZhcmdwLT5lcnJvcik7DQorDQorCXNldl91bnBpbl9tZW1vcnkoa3ZtLCBndWVzdF9w
YWdlLCBuKTsNCitlX2ZyZWU6DQorCWtmcmVlKGRhdGEpOw0KKwlrZnJlZShoZHIpOw0KKwlrZnJl
ZSh0cmFucyk7DQorCXJldHVybiByZXQ7DQorfQ0KKw0KIHN0YXRpYyBpbnQgc3ZtX21lbV9lbmNf
b3Aoc3RydWN0IGt2bSAqa3ZtLCB2b2lkIF9fdXNlciAqYXJncCkNCiB7DQogCXN0cnVjdCBrdm1f
c2V2X2NtZCBzZXZfY21kOw0KQEAgLTczMjEsNiArNzM5Myw5IEBAIHN0YXRpYyBpbnQgc3ZtX21l
bV9lbmNfb3Aoc3RydWN0IGt2bSAqa3ZtLCB2b2lkIF9fdXNlciAqYXJncCkNCiAJY2FzZSBLVk1f
U0VWX1JFQ0VJVkVfU1RBUlQ6DQogCQlyID0gc2V2X3JlY2VpdmVfc3RhcnQoa3ZtLCAmc2V2X2Nt
ZCk7DQogCQlicmVhazsNCisJY2FzZSBLVk1fU0VWX1JFQ0VJVkVfVVBEQVRFX0RBVEE6DQorCQly
ID0gc2V2X3JlY2VpdmVfdXBkYXRlX2RhdGEoa3ZtLCAmc2V2X2NtZCk7DQorCQlicmVhazsNCiAJ
ZGVmYXVsdDoNCiAJCXIgPSAtRUlOVkFMOw0KIAkJZ290byBvdXQ7DQpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS91YXBpL2xpbnV4L2t2bS5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oDQppbmRleCAy
OGQyNDA5NzRlYTcuLmUzMWNkYjQxNTE5ZiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvdWFwaS9saW51
eC9rdm0uaA0KKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oDQpAQCAtMTU2MSw2ICsxNTYx
LDE1IEBAIHN0cnVjdCBrdm1fc2V2X3JlY2VpdmVfc3RhcnQgew0KIAlfX3UzMiBzZXNzaW9uX2xl
bjsNCiB9Ow0KIA0KK3N0cnVjdCBrdm1fc2V2X3JlY2VpdmVfdXBkYXRlX2RhdGEgew0KKwlfX3U2
NCBoZHJfdWFkZHI7DQorCV9fdTMyIGhkcl9sZW47DQorCV9fdTY0IGd1ZXN0X3VhZGRyOw0KKwlf
X3UzMiBndWVzdF9sZW47DQorCV9fdTY0IHRyYW5zX3VhZGRyOw0KKwlfX3UzMiB0cmFuc19sZW47
DQorfTsNCisNCiAjZGVmaW5lIEtWTV9ERVZfQVNTSUdOX0VOQUJMRV9JT01NVQkoMSA8PCAwKQ0K
ICNkZWZpbmUgS1ZNX0RFVl9BU1NJR05fUENJXzJfMwkJKDEgPDwgMSkNCiAjZGVmaW5lIEtWTV9E
RVZfQVNTSUdOX01BU0tfSU5UWAkoMSA8PCAyKQ0KLS0gDQoyLjE3LjENCg0K
