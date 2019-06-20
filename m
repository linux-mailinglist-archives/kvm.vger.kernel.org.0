Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 026264D600
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 20:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfFTSDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 14:03:12 -0400
Received: from mail-eopbgr790089.outbound.protection.outlook.com ([40.107.79.89]:5088
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727574AbfFTSDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 14:03:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVCBWcxuCdP4tzGZUnso/keG4BIXpWd9tzQZiSdM98g=;
 b=nq6Kc6JIj+bn+oUqoiKibjWNe5uTLVTI86GqfG7mpZCnL3e/teBnR8BfbQtqFP8yf3nxXtTD2EchH+h6Vu1Mfwa90i6hR4x9MzixbtVQgQN0nXzodf4ScIzQGi0ulup6hZ4TL9BQsPbP6CS5h4WepIaXl4lCDKa68aRNAsDUiJs=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB2842.namprd12.prod.outlook.com (20.176.116.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Thu, 20 Jun 2019 18:03:05 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 18:03:05 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 00/12] Add SEV guest live migration support
Thread-Topic: [RFC PATCH v1 00/12] Add SEV guest live migration support
Thread-Index: AQHVJ5JohKMZUl6sx0qZdgLCEug/WA==
Date:   Thu, 20 Jun 2019 18:03:04 +0000
Message-ID: <20190620180247.8825-1-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: c6beb0f3-4b5e-4a07-d331-08d6f5a9895e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2842;
x-ms-traffictypediagnostic: DM6PR12MB2842:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <DM6PR12MB2842E04FC8A5A03298323B67E5E40@DM6PR12MB2842.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(366004)(346002)(39860400002)(189003)(199004)(81166006)(81156014)(386003)(86362001)(256004)(486006)(476003)(50226002)(186003)(2616005)(4326008)(8936002)(25786009)(68736007)(14454004)(5660300002)(26005)(66066001)(64756008)(5640700003)(6306002)(73956011)(3846002)(66556008)(6512007)(66476007)(53936002)(66946007)(966005)(2351001)(6486002)(66446008)(478600001)(99286004)(71200400001)(305945005)(14444005)(7736002)(6506007)(102836004)(71190400001)(52116002)(6436002)(8676002)(36756003)(54906003)(316002)(2501003)(6916009)(2906002)(1076003)(6116002)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2842;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9epW2PqMgLSh2OdSE35nmxmelFJTPR2v3yW8/Fp18n8cEGKulW6xHZMUn+HY6WSm/BL5Ge6KjYhXAEAcXBhW+1kkiouXcJbMEOw+c0QUXnppyjOri58htgXToMZMfqbxD/7GMqw4RPlCjMIRtxnbGqRo359tsSd/Zyg6Z2O0urRvC8ouFxmlRNoDg3thl/DobCWCw0gcVsYqAsw3Sx0FtERLqM8DRW18GCz9ydPoY8MTu7DPUPJ9iJRhTx6qxROm89WOcUJ51L5xiCwNuBDsI2YsauZ4jo/vbD6VcZPxTCmZWCnCcMuYakyIaPqBS8REgyEjiDFofF9QQO6VL/wQ1bbLHnZiRr5rErKfx+CTP9RqJTppwCYSsG70MZ42+tWLNPQoGQChyA8wtapDiK/yJYOELga2Aketisw3mDzyTS4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6beb0f3-4b5e-4a07-d331-08d6f5a9895e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 18:03:04.9999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2842
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QU1EIFNFViBlbmNyeXB0cyB0aGUgbWVtb3J5IG9mIFZNcyBhbmQgYmVjYXVzZSB0aGlzIGVuY3J5
cHRpb24gaXMgZG9uZSB1c2luZw0KYW4gYWRkcmVzcyB0d2VhaywgdGhlIGh5cGVydmlzb3Igd2ls
bCBub3QgYmUgYWJsZSB0byBzaW1wbHkgY29weSBjaXBoZXJ0ZXh0DQpiZXR3ZWVuIG1hY2hpbmVz
IHRvIG1pZ3JhdGUgYSBWTS4gSW5zdGVhZCB0aGUgQU1EIFNFViBLZXkgTWFuYWdlbWVudCBBUEkN
CnByb3ZpZGVzIGEgc2V0IG9mIGZ1bmN0aW9ucyB3aGljaCB0aGUgaHlwZXJ2aXNvciBjYW4gdXNl
IHRvIHBhY2thZ2UgYQ0KZ3Vlc3QgZW5jcnlwdGVkIHBhZ2VzIGZvciBtaWdyYXRpb24sIHdoaWxl
IG1haW50YWluaW5nIHRoZSBjb25maWRlbnRpYWxpdHkNCnByb3ZpZGVkIGJ5IEFNRCBTRVYuDQoN
ClRoZSBwYXRjaCBzZXJpZXMgYWRkIHRoZSBzdXBwb3J0IHJlcXVpcmVkIGluIFFlbXUgdG8gcGVy
Zm9ybSB0aGUgU0VWDQpndWVzdCBsaXZlIG1pZ3JhdGlvbi4gQmVmb3JlIGluaXRpYXRpbmcgdGhl
IGxpdmUgbWlncmF0aW9uIGEgdXNlcg0Kc2hvdWxkIHVzZSBuZXdseSBhZGRlZCAnbWlncmF0ZS1z
ZXQtc2V2LWluZm8nIGNvbW1hbmQgdG8gcGFzcyB0aGUNCnRhcmdldCBtYWNoaW5lcyBjZXJ0aWZp
Y2F0ZSBjaGFpbi4gU2VlIHRoZSBkb2NzL2FtZC1tZW1vcnktZW5jcnlwdGlvbi50eHQNCmZvciBm
dXJ0aGVyIGRldGFpbHMuDQoNClRoZSBwYXRjaCBzZXJpZXMgZGVwZW5kcyBvbiBrZXJuZWwgcGF0
Y2hlcyBhdmFpbGFibGUgaGVyZToNCmh0dHBzOi8vbWFyYy5pbmZvLz9sPWt2bSZtPTE1NjEwNDg3
MzQwOTg3NiZ3PTINCg0KVGhlIGNvbXBsZXRlIHRyZWUgd2l0aCBwYXRjaCBpcyBhdmFpbGFibGUg
YXQ6DQpodHRwczovL2dpdGh1Yi5jb20vY29kb21hbmlhL3FlbXUvdHJlZS9zZXYtbWlncmF0aW9u
LXJmYy12MQ0KDQpCcmlqZXNoIFNpbmdoICgxMik6DQogIGxpbnV4LWhlYWRlcnM6IHVwZGF0ZSBr
ZXJuZWwgaGVhZGVyIHRvIGluY2x1ZGUgU0VWIG1pZ3JhdGlvbiBjb21tYW5kcw0KICBrdm06IGlu
dHJvZHVjZSBoaWdoLWxldmVsIEFQSSB0byBzdXBwb3J0IGVuY3J5cHRlZCBndWVzdCBtaWdyYXRp
b24NCiAgbWlncmF0aW9uL3JhbTogYWRkIHN1cHBvcnQgdG8gc2VuZCBlbmNyeXB0ZWQgcGFnZXMN
CiAga3ZtOiBhZGQgc3VwcG9ydCB0byBzeW5jIHRoZSBwYWdlIGVuY3J5cHRpb24gc3RhdGUgYml0
bWFwDQogIGRvYzogdXBkYXRlIEFNRCBTRVYgQVBJIHNwZWMgd2ViIGxpbmsNCiAgZG9jOiB1cGRh
dGUgQU1EIFNFViB0byBpbmNsdWRlIExpdmUgbWlncmF0aW9uIGZsb3cNCiAgdGFyZ2V0L2kzODY6
IHNldjogZG8gbm90IGNyZWF0ZSBsYXVuY2ggY29udGV4dCBmb3IgYW4gaW5jb21pbmcgZ3Vlc3QN
CiAgdGFyZ2V0Lmpzb246IGFkZCBtaWdyYXRlLXNldC1zZXYtaW5mbyBjb21tYW5kDQogIHRhcmdl
dC9pMzg2OiBzZXY6IGFkZCBzdXBwb3J0IHRvIGVuY3J5cHQgdGhlIG91dGdvaW5nIHBhZ2UNCiAg
dGFyZ2V0L2kzODY6IHNldjogYWRkIHN1cHBvcnQgdG8gbG9hZCBpbmNvbWluZyBlbmNyeXB0ZWQg
cGFnZQ0KICBtaWdyYXRpb246IGFkZCBzdXBwb3J0IHRvIG1pZ3JhdGUgcGFnZSBlbmNyeXB0aW9u
IGJpdG1hcA0KICB0YXJnZXQvaTM4Njogc2V2OiByZW1vdmUgbWlncmF0aW9uIGJsb2NrZXINCg0K
IGFjY2VsL2t2bS9rdm0tYWxsLmMgICAgICAgICAgICB8ICA3NSArKysrKysNCiBhY2NlbC9rdm0v
c2V2LXN0dWIuYyAgICAgICAgICAgfCAgMjggKysNCiBhY2NlbC9zdHVicy9rdm0tc3R1Yi5jICAg
ICAgICAgfCAgMzAgKysrDQogZG9jcy9hbWQtbWVtb3J5LWVuY3J5cHRpb24udHh0IHwgIDQ2ICsr
Ky0NCiBpbmNsdWRlL2V4ZWMvcmFtX2FkZHIuaCAgICAgICAgfCAgIDIgKw0KIGluY2x1ZGUvc3lz
ZW11L2t2bS5oICAgICAgICAgICB8ICAzMyArKysNCiBpbmNsdWRlL3N5c2VtdS9zZXYuaCAgICAg
ICAgICAgfCAgIDkgKw0KIGxpbnV4LWhlYWRlcnMvbGludXgva3ZtLmggICAgICB8ICA1MyArKysr
DQogbWlncmF0aW9uL3JhbS5jICAgICAgICAgICAgICAgIHwgMTIxICsrKysrKysrLQ0KIHFhcGkv
dGFyZ2V0Lmpzb24gICAgICAgICAgICAgICB8ICAxOCArKw0KIHRhcmdldC9pMzg2L21vbml0b3Iu
YyAgICAgICAgICB8ICAxMCArDQogdGFyZ2V0L2kzODYvc2V2LXN0dWIuYyAgICAgICAgIHwgICA1
ICsNCiB0YXJnZXQvaTM4Ni9zZXYuYyAgICAgICAgICAgICAgfCA0NzEgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKy0tDQogdGFyZ2V0L2kzODYvc2V2X2kzODYuaCAgICAgICAgIHwgIDEx
ICstDQogdGFyZ2V0L2kzODYvdHJhY2UtZXZlbnRzICAgICAgIHwgICA5ICsNCiAxNSBmaWxlcyBj
aGFuZ2VkLCA5MDIgaW5zZXJ0aW9ucygrKSwgMTkgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xNy4x
DQoNCg==
