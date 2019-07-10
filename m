Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B426264D3E
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 22:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbfGJUNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 16:13:25 -0400
Received: from mail-eopbgr790054.outbound.protection.outlook.com ([40.107.79.54]:57219
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728424AbfGJUNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 16:13:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0lXV5tySe2KfbECTa8PFrwmGekrzFQvQXc0vjomi4M=;
 b=XOaDJSN/MIG0HfJu/LsA2FSRlEOuRt4aoAIld1IrbCEvpz6dh2YUloDIf3XT6GU4y9Tnli90qYBL1maXDAQvcdRyZOCvMoIqugearAUN1w/rJelHmgPw9lxdICuQgsZJ4jkzagojv603BGLu2RiIKExdWpzxH5sFFnLMbwGs5Y4=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3756.namprd12.prod.outlook.com (10.255.172.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Wed, 10 Jul 2019 20:13:08 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd%6]) with mapi id 15.20.2073.008; Wed, 10 Jul 2019
 20:13:08 +0000
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
Subject: [PATCH v3 07/11] KVM: x86: Add AMD SEV specific Hypercall3
Thread-Topic: [PATCH v3 07/11] KVM: x86: Add AMD SEV specific Hypercall3
Thread-Index: AQHVN1vjMQXW4t+xaUqH2ZDry8JE4w==
Date:   Wed, 10 Jul 2019 20:13:08 +0000
Message-ID: <20190710201244.25195-8-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: a561f9d9-1bdf-4981-1cce-08d70573065d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3756;
x-ms-traffictypediagnostic: DM6PR12MB3756:
x-microsoft-antispam-prvs: <DM6PR12MB37567D570C55AF26F1D17EE5E5F00@DM6PR12MB3756.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(189003)(199004)(6436002)(4326008)(8676002)(71200400001)(6512007)(7736002)(6116002)(99286004)(476003)(66066001)(71190400001)(478600001)(5640700003)(1730700003)(256004)(2351001)(53936002)(486006)(2501003)(6486002)(50226002)(386003)(316002)(81156014)(81166006)(54906003)(76176011)(66946007)(66446008)(5660300002)(64756008)(66476007)(66556008)(6506007)(3846002)(305945005)(68736007)(102836004)(2906002)(52116002)(186003)(7416002)(1076003)(25786009)(6916009)(2616005)(26005)(8936002)(14454004)(11346002)(86362001)(446003)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3756;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pfNSbdSrzJncI/QvJwIb692jq+B121K9PtQpo3n/lMUcgybYw7hiAO2KXqk2ELfO9uNqG6s8FscmyvOKwYOen4RjC1eD7yS7Xh80rqNyp3FOWIM3DkagsHlYrJ+C9PW9wV6W6QwRv0x0kXUZGMJAyiT0JTLC9PNFDs+dx57uVMKtbQboFk9osGAem/OJNKKHZYIdIGVM8pMdEhIW9edggKodZnL6ys+lgxxOhBDBUHYzV2PTbXgCkhe+Sq3d+eSfFOEoiL2BIuR7jUjYLw6kVhSKvhWo3Y2GG5FZC+qHPPgUwcGx6nWm3w9gsLmLiBMY0UxRDaTybU7UjEMRp7AAAQ4v0Utipd6Jb+3Qo8U+hbfuCiDi+iV2xHBJzVy9PPD6Onncu3U25Qb7XLWGIb8e9GYDQuheTPquKNF3Od1vE70=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E856D0075254D94A8153957880C16604@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a561f9d9-1bdf-4981-1cce-08d70573065d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 20:13:08.4526
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

S1ZNIGh5cGVyY2FsbCBmcmFtZXdvcmsgcmVsaWVzIG9uIGFsdGVybmF0aXZlIGZyYW1ld29yayB0
byBwYXRjaCB0aGUNClZNQ0FMTCAtPiBWTU1DQUxMIG9uIEFNRCBwbGF0Zm9ybS4gSWYgYSBoeXBl
cmNhbGwgaXMgbWFkZSBiZWZvcmUNCmFwcGx5X2FsdGVybmF0aXZlKCkgaXMgY2FsbGVkIHRoZW4g
aXQgZGVmYXVsdHMgdG8gVk1DQUxMLiBUaGUgYXBwcm9hY2gNCndvcmtzIGZpbmUgb24gbm9uIFNF
ViBndWVzdC4gQSBWTUNBTEwgd291bGQgY2F1c2VzICNVRCwgYW5kIGh5cGVydmlzb3INCndpbGwg
YmUgYWJsZSB0byBkZWNvZGUgdGhlIGluc3RydWN0aW9uIGFuZCBkbyB0aGUgcmlnaHQgdGhpbmdz
LiBCdXQNCndoZW4gU0VWIGlzIGFjdGl2ZSwgZ3Vlc3QgbWVtb3J5IGlzIGVuY3J5cHRlZCB3aXRo
IGd1ZXN0IGtleSBhbmQNCmh5cGVydmlzb3Igd2lsbCBub3QgYmUgYWJsZSB0byBkZWNvZGUgdGhl
IGluc3RydWN0aW9uIGJ5dGVzLg0KDQpBZGQgU0VWIHNwZWNpZmljIGh5cGVyY2FsbDMsIGl0IHVu
Y29uZGl0aW9uYWxseSB1c2VzIFZNTUNBTEwuIFRoZSBoeXBlcmNhbGwNCndpbGwgYmUgdXNlZCBi
eSB0aGUgU0VWIGd1ZXN0IHRvIG5vdGlmeSBlbmNyeXB0ZWQgcGFnZXMgdG8gdGhlIGh5cGVydmlz
b3IuDQoNCkNjOiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4NCkNjOiBJbmdv
IE1vbG5hciA8bWluZ29AcmVkaGF0LmNvbT4NCkNjOiAiSC4gUGV0ZXIgQW52aW4iIDxocGFAenl0
b3IuY29tPg0KQ2M6IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+DQpDYzogIlJh
ZGltIEtyxI1tw6HFmSIgPHJrcmNtYXJAcmVkaGF0LmNvbT4NCkNjOiBKb2VyZyBSb2VkZWwgPGpv
cm9AOGJ5dGVzLm9yZz4NCkNjOiBCb3Jpc2xhdiBQZXRrb3YgPGJwQHN1c2UuZGU+DQpDYzogVG9t
IExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1kLmNvbT4NCkNjOiB4ODZAa2VybmVsLm9yZw0K
Q2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCkNjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
DQpTaWduZWQtb2ZmLWJ5OiBCcmlqZXNoIFNpbmdoIDxicmlqZXNoLnNpbmdoQGFtZC5jb20+DQot
LS0NCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1fcGFyYS5oIHwgMTIgKysrKysrKysrKysrDQog
MSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2luY2x1ZGUvYXNtL2t2bV9wYXJhLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1fcGFyYS5o
DQppbmRleCA1ZWQzY2YxYzM5MzQuLjk0ZTkxYzBiYzJlMCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2
L2luY2x1ZGUvYXNtL2t2bV9wYXJhLmgNCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9w
YXJhLmgNCkBAIC04NCw2ICs4NCwxOCBAQCBzdGF0aWMgaW5saW5lIGxvbmcga3ZtX2h5cGVyY2Fs
bDQodW5zaWduZWQgaW50IG5yLCB1bnNpZ25lZCBsb25nIHAxLA0KIAlyZXR1cm4gcmV0Ow0KIH0N
CiANCitzdGF0aWMgaW5saW5lIGxvbmcga3ZtX3Nldl9oeXBlcmNhbGwzKHVuc2lnbmVkIGludCBu
ciwgdW5zaWduZWQgbG9uZyBwMSwNCisJCQkJICAgICAgdW5zaWduZWQgbG9uZyBwMiwgdW5zaWdu
ZWQgbG9uZyBwMykNCit7DQorCWxvbmcgcmV0Ow0KKw0KKwlhc20gdm9sYXRpbGUoInZtbWNhbGwi
DQorCQkgICAgIDogIj1hIihyZXQpDQorCQkgICAgIDogImEiKG5yKSwgImIiKHAxKSwgImMiKHAy
KSwgImQiKHAzKQ0KKwkJICAgICA6ICJtZW1vcnkiKTsNCisJcmV0dXJuIHJldDsNCit9DQorDQog
I2lmZGVmIENPTkZJR19LVk1fR1VFU1QNCiBib29sIGt2bV9wYXJhX2F2YWlsYWJsZSh2b2lkKTsN
CiB1bnNpZ25lZCBpbnQga3ZtX2FyY2hfcGFyYV9mZWF0dXJlcyh2b2lkKTsNCi0tIA0KMi4xNy4x
DQoNCg==
