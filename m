Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78E14D8E3
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 20:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfFTSDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 14:03:22 -0400
Received: from mail-eopbgr720085.outbound.protection.outlook.com ([40.107.72.85]:31712
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726843AbfFTSDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 14:03:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OK7h8pxuTS47T82sKhCXzKmckLFAoeBKV06Ie45lRNM=;
 b=ngwuUudkGdmfCPn82MD5KJLnzKhByEbdzv/WzXgFjNzTB5SkW/ZJfBNYAgme75vF9758gBo/MTucBDjimSlfkWZKhl3kddnEOQuSwJjRbWAiQU6hwCzL8db6LJqy9FGprDi6+Ak0i+/lrMTjISScC14GV6oOnbLwEYupaZH5yEc=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3260.namprd12.prod.outlook.com (20.179.105.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Thu, 20 Jun 2019 18:03:17 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 18:03:17 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 04/12] kvm: add support to sync the page encryption
 state bitmap
Thread-Topic: [RFC PATCH v1 04/12] kvm: add support to sync the page
 encryption state bitmap
Thread-Index: AQHVJ5Ju4VS6djRjvkaGkMwqb7aRwg==
Date:   Thu, 20 Jun 2019 18:03:15 +0000
Message-ID: <20190620180247.8825-5-brijesh.singh@amd.com>
References: <20190620180247.8825-1-brijesh.singh@amd.com>
In-Reply-To: <20190620180247.8825-1-brijesh.singh@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:4:15::11) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec67198f-819a-434c-710e-08d6f5a98d38
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3260;
x-ms-traffictypediagnostic: DM6PR12MB3260:
x-microsoft-antispam-prvs: <DM6PR12MB32606DC8B99813EA979DB330E5E40@DM6PR12MB3260.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:203;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(136003)(39860400002)(346002)(199004)(189003)(43544003)(2351001)(53936002)(486006)(2616005)(11346002)(81156014)(8676002)(14444005)(6436002)(446003)(5640700003)(50226002)(6512007)(476003)(102836004)(6916009)(99286004)(2501003)(6486002)(76176011)(8936002)(52116002)(81166006)(316002)(186003)(6506007)(26005)(478600001)(256004)(3846002)(2906002)(386003)(66066001)(14454004)(54906003)(6116002)(305945005)(25786009)(1076003)(66946007)(66556008)(73956011)(64756008)(66446008)(71190400001)(71200400001)(68736007)(36756003)(66476007)(5660300002)(7736002)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3260;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zvOaUUm42Sjb45SIGyNnWZkbLH0lsmemCt/jnGFpwmxKzNheGW/nPqpMF2FacDTqUKp1MQUDSjxc4nEWFJbNySFa2/+lK+ANnVP6IKEb0xEe3YMCFPhU3V9OIJ9c1Q3PaU/SElh1mqz/NAyhTXIMPsGIhiNjuArVEVba6yt48lcnt2MMDPdp9/hhwI9H/xwJg3RpirP1U/rlnzK5z4V43Xxt9Dosmm37pv9/r2gSVRqTYhRG6xxUDK+Qj3DCwPnjpb1z1ZGUSvpoQMb6eK3KkPzYCvPJbZuH67amJqgEnZGelWIYwd//6h4UwvugUF5MvV8BHeGh8s2b08ogitBkv5GCLnT3wAb9tsymBfJg7XucMK9lEzCEzIv634+Kv0TOoMhKj3i8qYBzonpGQtf5VRew/BJJ83DXaZMA7W3Q3m4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec67198f-819a-434c-710e-08d6f5a98d38
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 18:03:15.8278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3260
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlIFNFViBWTXMgaGF2ZSBjb25jZXB0IG9mIHByaXZhdGUgYW5kIHNoYXJlZCBtZW1vcnkuIFRo
ZSBwcml2YXRlIG1lbW9yeQ0KaXMgZW5jcnlwdGVkIHdpdGggZ3Vlc3Qtc3BlY2lmaWMga2V5LCB3
aGlsZSBzaGFyZWQgbWVtb3J5IG1heSBiZSBlbmNyeXB0ZWQNCndpdGggaHlwZXJpdm9zciBrZXku
IFRoZSBLVk1fR0VUX1BBR0VfRU5DX0JJVE1BUCBjYW4gYmUgdXNlZCB0byBnZXQgYQ0KYml0bWFw
IGluZGljYXRpbmcgd2hldGhlciB0aGUgZ3Vlc3QgcGFnZSBpcyBwcml2YXRlIG9yIHNoYXJlZC4g
QSBwcml2YXRlDQpwYWdlIG11c3QgYmUgdHJhbnNtaXR0ZWQgdXNpbmcgdGhlIFNFViBtaWdyYXRp
b24gY29tbWFuZHMuDQoNClNpZ25lZC1vZmYtYnk6IEJyaWplc2ggU2luZ2ggPGJyaWplc2guc2lu
Z2hAYW1kLmNvbT4NCi0tLQ0KIGFjY2VsL2t2bS9rdm0tYWxsLmMgICAgIHwgIDEgKw0KIGluY2x1
ZGUvZXhlYy9yYW1fYWRkci5oIHwgIDIgKysNCiBtaWdyYXRpb24vcmFtLmMgICAgICAgICB8IDI4
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKy0NCiB0YXJnZXQvaTM4Ni9zZXYuYyAgICAgICB8
IDI3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKw0KIDQgZmlsZXMgY2hhbmdlZCwgNTcgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvYWNjZWwva3ZtL2t2bS1h
bGwuYyBiL2FjY2VsL2t2bS9rdm0tYWxsLmMNCmluZGV4IDRkNWZmOGI5ZjUuLjA2NTRkOWE3Y2Qg
MTAwNjQ0DQotLS0gYS9hY2NlbC9rdm0va3ZtLWFsbC5jDQorKysgYi9hY2NlbC9rdm0va3ZtLWFs
bC5jDQpAQCAtMTc4Myw2ICsxNzgzLDcgQEAgc3RhdGljIGludCBrdm1faW5pdChNYWNoaW5lU3Rh
dGUgKm1zKQ0KICAgICAgICAgfQ0KIA0KICAgICAgICAga3ZtX3N0YXRlLT5tZW1jcnlwdF9lbmNy
eXB0X2RhdGEgPSBzZXZfZW5jcnlwdF9kYXRhOw0KKyAgICAgICAga3ZtX3N0YXRlLT5tZW1jcnlw
dF9zeW5jX3BhZ2VfZW5jX2JpdG1hcCA9IHNldl9zeW5jX3BhZ2VfZW5jX2JpdG1hcDsNCiAgICAg
fQ0KIA0KICAgICByZXQgPSBrdm1fYXJjaF9pbml0KG1zLCBzKTsNCmRpZmYgLS1naXQgYS9pbmNs
dWRlL2V4ZWMvcmFtX2FkZHIuaCBiL2luY2x1ZGUvZXhlYy9yYW1fYWRkci5oDQppbmRleCBmOTY3
NzdiYjk5Li4yMTQ1MDU5YWZjIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9leGVjL3JhbV9hZGRyLmgN
CisrKyBiL2luY2x1ZGUvZXhlYy9yYW1fYWRkci5oDQpAQCAtNTEsNiArNTEsOCBAQCBzdHJ1Y3Qg
UkFNQmxvY2sgew0KICAgICB1bnNpZ25lZCBsb25nICp1bnNlbnRtYXA7DQogICAgIC8qIGJpdG1h
cCBvZiBhbHJlYWR5IHJlY2VpdmVkIHBhZ2VzIGluIHBvc3Rjb3B5ICovDQogICAgIHVuc2lnbmVk
IGxvbmcgKnJlY2VpdmVkbWFwOw0KKyAgICAvKiBiaXRtYXAgb2YgcGFnZSBlbmNyeXB0aW9uIHN0
YXRlIGZvciBhbiBlbmNyeXB0ZWQgZ3Vlc3QgKi8NCisgICAgdW5zaWduZWQgbG9uZyAqZW5jYm1h
cDsNCiB9Ow0KIA0KIHN0YXRpYyBpbmxpbmUgYm9vbCBvZmZzZXRfaW5fcmFtYmxvY2soUkFNQmxv
Y2sgKmIsIHJhbV9hZGRyX3Qgb2Zmc2V0KQ0KZGlmZiAtLWdpdCBhL21pZ3JhdGlvbi9yYW0uYyBi
L21pZ3JhdGlvbi9yYW0uYw0KaW5kZXggM2M4OTc3ZDUwOC4uYTg2MzFjMDg5NiAxMDA2NDQNCi0t
LSBhL21pZ3JhdGlvbi9yYW0uYw0KKysrIGIvbWlncmF0aW9uL3JhbS5jDQpAQCAtMTY4MCw2ICsx
NjgwLDkgQEAgc3RhdGljIHZvaWQgbWlncmF0aW9uX2JpdG1hcF9zeW5jX3JhbmdlKFJBTVN0YXRl
ICpycywgUkFNQmxvY2sgKnJiLA0KICAgICBycy0+bWlncmF0aW9uX2RpcnR5X3BhZ2VzICs9DQog
ICAgICAgICBjcHVfcGh5c2ljYWxfbWVtb3J5X3N5bmNfZGlydHlfYml0bWFwKHJiLCAwLCBsZW5n
dGgsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZycy0+
bnVtX2RpcnR5X3BhZ2VzX3BlcmlvZCk7DQorICAgIGlmIChrdm1fbWVtY3J5cHRfZW5hYmxlZCgp
KSB7DQorICAgICAgICBrdm1fbWVtY3J5cHRfc3luY19wYWdlX2VuY19iaXRtYXAocmItPmhvc3Qs
IGxlbmd0aCwgcmItPmVuY2JtYXApOw0KKyAgICB9DQogfQ0KIA0KIC8qKg0KQEAgLTI0NjUsNiAr
MjQ2OCwyMiBAQCBzdGF0aWMgYm9vbCBzYXZlX2NvbXByZXNzX3BhZ2UoUkFNU3RhdGUgKnJzLCBS
QU1CbG9jayAqYmxvY2ssIHJhbV9hZGRyX3Qgb2Zmc2V0KQ0KICAgICByZXR1cm4gZmFsc2U7DQog
fQ0KIA0KKy8qKg0KKyAqIGVuY3J5cHRlZF90ZXN0X2JpdG1hcDogY2hlY2sgaWYgdGhlIHBhZ2Ug
aXMgZW5jcnlwdGVkDQorICoNCisgKiBSZXR1cm5zIGEgYm9vbCBpbmRpY2F0aW5nIHdoZXRoZXIg
dGhlIHBhZ2UgaXMgZW5jcnlwdGVkLg0KKyAqLw0KK3N0YXRpYyBib29sIGVuY3J5cHRlZF90ZXN0
X2JpdG1hcChSQU1TdGF0ZSAqcnMsIFJBTUJsb2NrICpibG9jaywNCisgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBwYWdlKQ0KK3sNCisgICAgLyogUk9NIGRl
dmljZXMgY29udGFpbnMgdGhlIHVuZW5jcnlwdGVkIGRhdGEgKi8NCisgICAgaWYgKG1lbW9yeV9y
ZWdpb25faXNfcm9tKGJsb2NrLT5tcikpIHsNCisgICAgICAgIHJldHVybiBmYWxzZTsNCisgICAg
fQ0KKw0KKyAgICByZXR1cm4gdGVzdF9iaXQocGFnZSwgYmxvY2stPmVuY2JtYXApOw0KK30NCisN
CiAvKioNCiAgKiByYW1fc2F2ZV90YXJnZXRfcGFnZTogc2F2ZSBvbmUgdGFyZ2V0IHBhZ2UNCiAg
Kg0KQEAgLTI0OTEsNyArMjUxMCw4IEBAIHN0YXRpYyBpbnQgcmFtX3NhdmVfdGFyZ2V0X3BhZ2Uo
UkFNU3RhdGUgKnJzLCBQYWdlU2VhcmNoU3RhdHVzICpwc3MsDQogICAgICAqIHdpbGwgdGFrZSBj
YXJlIG9mIGFjY2Vzc2luZyB0aGUgZ3Vlc3QgbWVtb3J5IGFuZCByZS1lbmNyeXB0IGl0DQogICAg
ICAqIGZvciB0aGUgdHJhbnNwb3J0IHB1cnBvc2VzLg0KICAgICAgKi8NCi0gICAgIGlmIChrdm1f
bWVtY3J5cHRfZW5hYmxlZCgpKSB7DQorICAgICBpZiAoa3ZtX21lbWNyeXB0X2VuYWJsZWQoKSAm
Jg0KKyAgICAgICAgIGVuY3J5cHRlZF90ZXN0X2JpdG1hcChycywgcHNzLT5ibG9jaywgcHNzLT5w
YWdlKSkgew0KICAgICAgICAgcmV0dXJuIHJhbV9zYXZlX2VuY3J5cHRlZF9wYWdlKHJzLCBwc3Ms
IGxhc3Rfc3RhZ2UpOw0KICAgICAgfQ0KIA0KQEAgLTI3MjQsNiArMjc0NCw4IEBAIHN0YXRpYyB2
b2lkIHJhbV9zYXZlX2NsZWFudXAodm9pZCAqb3BhcXVlKQ0KICAgICAgICAgYmxvY2stPmJtYXAg
PSBOVUxMOw0KICAgICAgICAgZ19mcmVlKGJsb2NrLT51bnNlbnRtYXApOw0KICAgICAgICAgYmxv
Y2stPnVuc2VudG1hcCA9IE5VTEw7DQorICAgICAgICBnX2ZyZWUoYmxvY2stPmVuY2JtYXApOw0K
KyAgICAgICAgYmxvY2stPmVuY2JtYXAgPSBOVUxMOw0KICAgICB9DQogDQogICAgIHhienJsZV9j
bGVhbnVwKCk7DQpAQCAtMzI1MSw2ICszMjczLDEwIEBAIHN0YXRpYyB2b2lkIHJhbV9saXN0X2lu
aXRfYml0bWFwcyh2b2lkKQ0KICAgICAgICAgICAgICAgICBibG9jay0+dW5zZW50bWFwID0gYml0
bWFwX25ldyhwYWdlcyk7DQogICAgICAgICAgICAgICAgIGJpdG1hcF9zZXQoYmxvY2stPnVuc2Vu
dG1hcCwgMCwgcGFnZXMpOw0KICAgICAgICAgICAgIH0NCisgICAgICAgICAgICBpZiAoa3ZtX21l
bWNyeXB0X2VuYWJsZWQoKSkgew0KKyAgICAgICAgICAgICAgICBibG9jay0+ZW5jYm1hcCA9IGJp
dG1hcF9uZXcocGFnZXMpOw0KKyAgICAgICAgICAgICAgICBiaXRtYXBfc2V0KGJsb2NrLT5lbmNi
bWFwLCAwLCBwYWdlcyk7DQorICAgICAgICAgICAgfQ0KICAgICAgICAgfQ0KICAgICB9DQogfQ0K
ZGlmZiAtLWdpdCBhL3RhcmdldC9pMzg2L3Nldi5jIGIvdGFyZ2V0L2kzODYvc2V2LmMNCmluZGV4
IDZkYmRjM2NkZjEuLmRkMzgxNGUyNWYgMTAwNjQ0DQotLS0gYS90YXJnZXQvaTM4Ni9zZXYuYw0K
KysrIGIvdGFyZ2V0L2kzODYvc2V2LmMNCkBAIC04MTksNiArODE5LDMzIEBAIHNldl9lbmNyeXB0
X2RhdGEodm9pZCAqaGFuZGxlLCB1aW50OF90ICpwdHIsIHVpbnQ2NF90IGxlbikNCiAgICAgcmV0
dXJuIDA7DQogfQ0KIA0KK2ludCBzZXZfc3luY19wYWdlX2VuY19iaXRtYXAodm9pZCAqaGFuZGxl
LCB1aW50OF90ICpob3N0LCB1aW50NjRfdCBzaXplLA0KKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB1bnNpZ25lZCBsb25nICpiaXRtYXApDQorew0KKyAgICBpbnQgcjsNCisgICAgdW5zaWdu
ZWQgbG9uZyBiYXNlX2dwYTsNCisgICAgS1ZNU3RhdGUgKnMgPSBrdm1fc3RhdGU7DQorICAgIHN0
cnVjdCBrdm1fcGFnZV9lbmNfYml0bWFwIGUgPSB7fTsNCisgICAgdW5zaWduZWQgbG9uZyBwYWdl
cyA9IHNpemUgPj4gVEFSR0VUX1BBR0VfQklUUzsNCisNCisgICAgciA9IGt2bV9waHlzaWNhbF9t
ZW1vcnlfYWRkcl9mcm9tX2hvc3Qoa3ZtX3N0YXRlLCBob3N0LCAmYmFzZV9ncGEpOw0KKyAgICBp
ZiAoIXIpIHsNCisgICAgICAgIHJldHVybiAxOw0KKyAgICB9DQorDQorICAgIGUuZW5jX2JpdG1h
cCA9IGJpdG1hcDsNCisgICAgZS5zdGFydCA9IGJhc2VfZ3BhID4+IFRBUkdFVF9QQUdFX0JJVFM7
DQorICAgIGUubnVtX3BhZ2VzID0gcGFnZXM7DQorDQorICAgIGlmIChrdm1fdm1faW9jdGwocywg
S1ZNX0dFVF9QQUdFX0VOQ19CSVRNQVAsICZlKSA9PSAtMSkgew0KKyAgICAgICAgZXJyb3JfcmVw
b3J0KCIlczogZ2V0IHBhZ2VfZW5jIGJpdG1hcCBzdGFydCAweCVsbHggcGFnZXMgMHglbGx4IiwN
CisgICAgICAgICAgICAgICAgX19mdW5jX18sIGUuc3RhcnQsIGUubnVtX3BhZ2VzKTsNCisgICAg
ICAgIHJldHVybiAxOw0KKyAgICB9DQorDQorICAgIHJldHVybiAwOw0KK30NCisNCiBzdGF0aWMg
dm9pZA0KIHNldl9yZWdpc3Rlcl90eXBlcyh2b2lkKQ0KIHsNCi0tIA0KMi4xNy4xDQoNCg==
