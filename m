Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9994D3FA
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 18:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732232AbfFTQji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 12:39:38 -0400
Received: from mail-eopbgr770082.outbound.protection.outlook.com ([40.107.77.82]:17878
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731871AbfFTQjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 12:39:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0lXV5tySe2KfbECTa8PFrwmGekrzFQvQXc0vjomi4M=;
 b=s0YH7dyn7xL8hayTb9B6fL49cweM6nxse78E57qRAhp2UmeRnn1Zvt5WBcFNVxBRpkDFnUT2d3zps5LjHogdvToTTOMlFuNjkgWDwZgUwXXIeoSE7RAAPCkqNLBo7/uCWi0sapg6rmH5hSPrsU4X1rkyXWT9odMRN5FStCk7A9c=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3914.namprd12.prod.outlook.com (10.255.174.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Thu, 20 Jun 2019 16:38:56 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 16:38:56 +0000
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
Subject: [RFC PATCH v2 07/11] KVM: x86: Add AMD SEV specific Hypercall3
Thread-Topic: [RFC PATCH v2 07/11] KVM: x86: Add AMD SEV specific Hypercall3
Thread-Index: AQHVJ4anWvgVOiHxrkGOjoenz2w59g==
Date:   Thu, 20 Jun 2019 16:38:55 +0000
Message-ID: <20190620163832.5451-8-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: de3002ba-ae3f-49f8-8f65-08d6f59dc954
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3914;
x-ms-traffictypediagnostic: DM6PR12MB3914:
x-microsoft-antispam-prvs: <DM6PR12MB391461F6D9D0FEB4331D9075E5E40@DM6PR12MB3914.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(52116002)(54906003)(86362001)(305945005)(256004)(6916009)(71190400001)(2501003)(71200400001)(6116002)(2906002)(25786009)(6512007)(53936002)(66446008)(6506007)(5640700003)(386003)(7416002)(2351001)(66476007)(66556008)(7736002)(486006)(5660300002)(11346002)(476003)(99286004)(446003)(73956011)(68736007)(8936002)(6436002)(66946007)(478600001)(64756008)(4326008)(6486002)(3846002)(36756003)(66066001)(1730700003)(14454004)(81166006)(1076003)(102836004)(81156014)(50226002)(186003)(8676002)(26005)(316002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3914;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PtzgMv/XR9pWes0BzhPwo0W3WlRgeYISuyVVW2Lf07aPCwLeB5dg7PMMLmLr8x6sQ5j6KNBaIn6W0qJlgTq8EOFG1L4IM8vYN6uauYXeVI+sCOgE5+Z2SIpKQmIkT4UhtpW1OWxrNaQQw9MY/roirl6j+ZkCzjQM0BO2vnXLVVwsrgGzTpKsXAGrXHmDsdc7JoBICzjctghMk3WLiOcthYzmJrqfVWldwePmLSpYSyjDfSFtFa7uOQOlVnxBtknydHmmWJ5tZD3akt55YeJ4ZWtgQxK5g2E3bHIOFJ2Vbgq7Qayks04POFK4faHWzWoZFCiPmDS1X/oZy3ZpTwtdarySSXeqjqDL3xv35zuKP/572An371ak7BNMsNMP0n8swnsHd2v0KgESHFOduD9eZJD2JP/Kxf13f0imBNB/hWY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E8A3813C601F743B1C623209018717F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de3002ba-ae3f-49f8-8f65-08d6f59dc954
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 16:38:55.9484
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
