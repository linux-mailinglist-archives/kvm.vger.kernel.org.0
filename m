Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F39F12F5D
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 15:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfECNi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 09:38:56 -0400
Received: from mail-eopbgr820058.outbound.protection.outlook.com ([40.107.82.58]:44546
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727555AbfECNi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 09:38:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QX0mxNmMULoy1wbPafJqreKrFu7S8vjBu7HZe7ruSmk=;
 b=GApNbBNA00sgcrc5pKhIC6PkNYdXJP4BHbsnLkf51MZnCKCTO0cEilxYu9fGxQ4e+pkB40zrNRJl+5JXzRfwTHdwijX+3llbD4nfuxPYjuYCtEduyHJYv73zETE5yGhNJhJNrH5R/3wbCbmjzw7+U5kWggJ2gUxKgoVnZxIMfD8=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB2812.namprd12.prod.outlook.com (20.176.117.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Fri, 3 May 2019 13:38:53 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::d119:23e5:be33:4ac6]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::d119:23e5:be33:4ac6%2]) with mapi id 15.20.1856.008; Fri, 3 May 2019
 13:38:53 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH] svm/avic: Do not send AVIC doorbell to self
Thread-Topic: [PATCH] svm/avic: Do not send AVIC doorbell to self
Thread-Index: AQHVAbWM1dd1RWWcW0KGDe4yNBolwg==
Date:   Fri, 3 May 2019 13:38:53 +0000
Message-ID: <1556890721-9613-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN6PR01CA0003.prod.exchangelabs.com (2603:10b6:805:b6::16)
 To DM6PR12MB2844.namprd12.prod.outlook.com (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd69f81e-f692-4292-e725-08d6cfccaec4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2812;
x-ms-traffictypediagnostic: DM6PR12MB2812:
x-microsoft-antispam-prvs: <DM6PR12MB28120CFA050FC3EA923EE910F3350@DM6PR12MB2812.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(346002)(366004)(39860400002)(189003)(199004)(66066001)(52116002)(2501003)(81166006)(81156014)(2906002)(4720700003)(8676002)(25786009)(68736007)(6506007)(386003)(5660300002)(102836004)(316002)(54906003)(110136005)(486006)(36756003)(256004)(3846002)(6116002)(2616005)(99286004)(72206003)(478600001)(14454004)(73956011)(86362001)(66946007)(66476007)(66556008)(64756008)(6512007)(66446008)(8936002)(6486002)(53936002)(7736002)(50226002)(186003)(4326008)(26005)(476003)(71200400001)(71190400001)(305945005)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2812;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: x0gm3pCBeYSagw5yeezPtjltir0ZOC554qPxl5IxDqr4FhNxxbrsA+TCtCWb8Rfpg0LKLCwogV23hqDop1b0XEa0VjeEsLo++5pSuMCP8DzCT+2FM/NHzX/RJY71kN/HuolJYbH/NqZ4MhMy14ZUtOVarIEXfd6PXAcdgWrQD9efTJJGbJKEqeAr6F6lAAme3ANvKvlVzq3xfFx6tyUknUIIucz2rb0uvJxH7DNgnu38ZU40lTNTpk043mfjm64V6/JQNILs9QaQzdHl1qVJqYNNQXE9QeSGpMVjGvtZUfuyv3Tp88RiWtk9vP+W6ejlnlB9HB7Ji2t7xB2wTQeWmJiytKf7PswbjwrPDM9/KjXOpAHBv8fnPbWOcM7sXCeET1T6IpPYIUl6xMCcRqCe80OCmbjU2m1LrWcBzUnZuuk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd69f81e-f692-4292-e725-08d6cfccaec4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 13:38:53.5164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2812
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QVZJQyBkb29yYmVsbCBpcyB1c2VkIHRvIG5vdGlmeSBhIHJ1bm5pbmcgdkNQVSB0aGF0IGludGVy
cnVwdHMNCmhhcyBiZWVuIGluamVjdGVkIGludG8gdGhlIHZDUFUgQVZJQyBiYWNraW5nIHBhZ2Uu
IEN1cnJlbnQgbG9naWMNCmNoZWNrcyBvbmx5IGlmIGEgVkNQVSBpcyBydW5uaW5nIGJlZm9yZSBz
ZW5kaW5nIGEgZG9vcmJlbGwuDQpIb3dldmVyLCB0aGUgZG9vcmJlbGwgaXMgbm90IG5lY2Vzc2Fy
eSBpZiB0aGUgZGVzdGluYXRpb24NCkNQVSBpcyBpdHNlbGYuDQoNCkFkZCBsb2dpYyB0byBjaGVj
ayBjdXJyZW50bHkgcnVubmluZyBDUFUgYmVmb3JlIHNlbmRpbmcgZG9vcmJlbGwuDQoNClNpZ25l
ZC1vZmYtYnk6IFN1cmF2ZWUgU3V0aGlrdWxwYW5pdCA8c3VyYXZlZS5zdXRoaWt1bHBhbml0QGFt
ZC5jb20+DQotLS0NCiBhcmNoL3g4Ni9rdm0vc3ZtLmMgfCAxMSArKysrKysrLS0tLQ0KIDEgZmls
ZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9rdm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3ZtLmMNCmluZGV4IDEyMjc4OGYu
LjRiYmY2ZmMgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtLmMNCisrKyBiL2FyY2gveDg2
L2t2bS9zdm0uYw0KQEAgLTUyODMsMTAgKzUyODMsMTMgQEAgc3RhdGljIHZvaWQgc3ZtX2RlbGl2
ZXJfYXZpY19pbnRyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgaW50IHZlYykNCiAJa3ZtX2xhcGlj
X3NldF9pcnIodmVjLCB2Y3B1LT5hcmNoLmFwaWMpOw0KIAlzbXBfbWJfX2FmdGVyX2F0b21pYygp
Ow0KIA0KLQlpZiAoYXZpY192Y3B1X2lzX3J1bm5pbmcodmNwdSkpDQotCQl3cm1zcmwoU1ZNX0FW
SUNfRE9PUkJFTEwsDQotCQkgICAgICAga3ZtX2NwdV9nZXRfYXBpY2lkKHZjcHUtPmNwdSkpOw0K
LQllbHNlDQorCWlmIChhdmljX3ZjcHVfaXNfcnVubmluZyh2Y3B1KSkgew0KKwkJaW50IGNwdWlk
ID0gdmNwdS0+Y3B1Ow0KKw0KKwkJaWYgKGNwdWlkICE9IGdldF9jcHUoKSkNCisJCQl3cm1zcmwo
U1ZNX0FWSUNfRE9PUkJFTEwsIGt2bV9jcHVfZ2V0X2FwaWNpZChjcHVpZCkpOw0KKwkJcHV0X2Nw
dSgpOw0KKwl9IGVsc2UNCiAJCWt2bV92Y3B1X3dha2VfdXAodmNwdSk7DQogfQ0KIA0KLS0gDQox
LjguMy4xDQoNCg==
