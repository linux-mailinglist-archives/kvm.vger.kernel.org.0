Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3654D3EE
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 18:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732256AbfFTQjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 12:39:04 -0400
Received: from mail-eopbgr770088.outbound.protection.outlook.com ([40.107.77.88]:38590
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732193AbfFTQjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 12:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3d+JTMFJuiBLFQONRtO4gKVPMHPFop0AC5kikiFiylo=;
 b=LYLqOMV+mNWNHHsAQwrPvC+2+JO/qIfa1a2B8QJ2iujUuxKPU4gcn7JveHG7F+I1WqzasUz4RzMgxPF25O1SuxdwVc9aTr6kdQ/g1WrJ0MDBfZ8vgc0GEIGNw7EKQdHUp8J9C4zL0QpNM2wL44408/hqWrSQzj8ganmQUVRW0gg=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3914.namprd12.prod.outlook.com (10.255.174.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Thu, 20 Jun 2019 16:38:53 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 16:38:53 +0000
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
Subject: [RFC PATCH v2 04/11] KVM: SVM: Add support for KVM_SEV_RECEIVE_START
 command
Thread-Topic: [RFC PATCH v2 04/11] KVM: SVM: Add support for
 KVM_SEV_RECEIVE_START command
Thread-Index: AQHVJ4al/U5QDArzlUynC35qznGTOQ==
Date:   Thu, 20 Jun 2019 16:38:53 +0000
Message-ID: <20190620163832.5451-5-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: d392c89d-705f-4b2d-fcf6-08d6f59dc7bd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3914;
x-ms-traffictypediagnostic: DM6PR12MB3914:
x-microsoft-antispam-prvs: <DM6PR12MB39141FC56008EBCBCFFD9639E5E40@DM6PR12MB3914.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(52116002)(54906003)(86362001)(305945005)(256004)(6916009)(71190400001)(2501003)(71200400001)(6116002)(2906002)(25786009)(6512007)(53936002)(66446008)(6506007)(5640700003)(386003)(7416002)(14444005)(2351001)(66476007)(66556008)(7736002)(486006)(5660300002)(11346002)(476003)(99286004)(446003)(73956011)(68736007)(8936002)(6436002)(66946007)(478600001)(64756008)(4326008)(6486002)(3846002)(36756003)(66066001)(1730700003)(14454004)(81166006)(1076003)(102836004)(66574012)(81156014)(50226002)(186003)(8676002)(26005)(316002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3914;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cyOYL1L5SfnAY7Deanek9lcmpaLmbJJ7d/UtWLvi651acvC3sYO8Zj6NMd7+YglNuHh610IZ4olj/6BxWOF0Al9qpZgEon5H/fmT+46f/ibW5KAj6lV86P+QkMsVz3nk4KR/iWsos49pWkIQ1KTYuCHnkrMlWXMHGQ16V7ZB5wsIg6qbGHjS+Vp9ZOwM6CTircrgACG8zbNloNT9VjNozMFXA+XslezPkNtZkyWlPRtFTPspzptHX3xtqQQyWQGE7MH62KDmTm8swFFiVhBhtkTXXqixZuez8RqKRA553BlX02Auqtm/9J4DCHazwd5uOGYL5/a9LtEZRqbHEz73Z+mNFpMlKi+MnOb0vZ5L5sXShUdeF/H0OJK+vMRTOuYpsDkoGHUJhp3naBovPXRXXbQ0ZlXrzwQ4W7NH8f8Y/KU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1B8745281AF1549B17643AB0C6E3E78@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d392c89d-705f-4b2d-fcf6-08d6f59dc7bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 16:38:53.4188
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

VGhlIGNvbW1hbmQgaXMgdXNlZCB0byBjcmVhdGUgdGhlIGVuY3J5cHRpb24gY29udGV4dCBmb3Ig
YW4gaW5jb21pbmcNClNFViBndWVzdC4gVGhlIGVuY3J5cHRpb24gY29udGV4dCBjYW4gYmUgbGF0
ZXIgdXNlZCBieSB0aGUgaHlwZXJ2aXNvcg0KdG8gaW1wb3J0IHRoZSBpbmNvbWluZyBkYXRhIGlu
dG8gdGhlIFNFViBndWVzdCBtZW1vcnkgc3BhY2UuDQoNCkNjOiBUaG9tYXMgR2xlaXhuZXIgPHRn
bHhAbGludXRyb25peC5kZT4NCkNjOiBJbmdvIE1vbG5hciA8bWluZ29AcmVkaGF0LmNvbT4NCkNj
OiAiSC4gUGV0ZXIgQW52aW4iIDxocGFAenl0b3IuY29tPg0KQ2M6IFBhb2xvIEJvbnppbmkgPHBi
b256aW5pQHJlZGhhdC5jb20+DQpDYzogIlJhZGltIEtyxI1tw6HFmSIgPHJrcmNtYXJAcmVkaGF0
LmNvbT4NCkNjOiBKb2VyZyBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz4NCkNjOiBCb3Jpc2xhdiBQ
ZXRrb3YgPGJwQHN1c2UuZGU+DQpDYzogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1k
LmNvbT4NCkNjOiB4ODZAa2VybmVsLm9yZw0KQ2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCkNjOiBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQpTaWduZWQtb2ZmLWJ5OiBCcmlqZXNoIFNpbmdo
IDxicmlqZXNoLnNpbmdoQGFtZC5jb20+DQotLS0NCiAuLi4vdmlydHVhbC9rdm0vYW1kLW1lbW9y
eS1lbmNyeXB0aW9uLnJzdCAgICAgfCAyOSArKysrKysrDQogYXJjaC94ODYva3ZtL3N2bS5jICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgODAgKysrKysrKysrKysrKysrKysrKw0KIGluY2x1
ZGUvdWFwaS9saW51eC9rdm0uaCAgICAgICAgICAgICAgICAgICAgICB8ICA5ICsrKw0KIDMgZmls
ZXMgY2hhbmdlZCwgMTE4IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRp
b24vdmlydHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdCBiL0RvY3VtZW50YXRpb24v
dmlydHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdA0KaW5kZXggYWZhMTFhNzI3MWYx
Li44NWFiZTA4NzEwMzEgMTAwNjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2Ft
ZC1tZW1vcnktZW5jcnlwdGlvbi5yc3QNCisrKyBiL0RvY3VtZW50YXRpb24vdmlydHVhbC9rdm0v
YW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdA0KQEAgLTI5Nyw2ICsyOTcsMzUgQEAgaXNzdWVkIGJ5
IHRoZSBoeXBlcnZpc29yIHRvIGRlbGV0ZSB0aGUgZW5jcnlwdGlvbiBjb250ZXh0Lg0KIA0KIFJl
dHVybnM6IDAgb24gc3VjY2VzcywgLW5lZ2F0aXZlIG9uIGVycm9yDQogDQorMTMuIEtWTV9TRVZf
UkVDRUlWRV9TVEFSVA0KKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKw0KK1RoZSBLVk1fU0VW
X1JFQ0VJVkVfU1RBUlQgY29tbWFuZCBpcyB1c2VkIGZvciBjcmVhdGluZyB0aGUgbWVtb3J5IGVu
Y3J5cHRpb24NCitjb250ZXh0IGZvciBhbiBpbmNvbWluZyBTRVYgZ3Vlc3QuIFRvIGNyZWF0ZSB0
aGUgZW5jcnlwdGlvbiBjb250ZXh0LCB0aGUgdXNlciBtdXN0DQorcHJvdmlkZSBhIGd1ZXN0IHBv
bGljeSwgdGhlIHBsYXRmb3JtIHB1YmxpYyBEaWZmaWUtSGVsbG1hbiAoUERIKSBrZXkgYW5kIHNl
c3Npb24NCitpbmZvcm1hdGlvbi4NCisNCitQYXJhbWV0ZXJzOiBzdHJ1Y3QgIGt2bV9zZXZfcmVj
ZWl2ZV9zdGFydCAoaW4vb3V0KQ0KKw0KK1JldHVybnM6IDAgb24gc3VjY2VzcywgLW5lZ2F0aXZl
IG9uIGVycm9yDQorDQorOjoNCisNCisgICAgICAgIHN0cnVjdCBrdm1fc2V2X3JlY2VpdmVfc3Rh
cnQgew0KKyAgICAgICAgICAgICAgICBfX3UzMiBoYW5kbGU7ICAgICAgICAgICAvKiBpZiB6ZXJv
IHRoZW4gZmlybXdhcmUgY3JlYXRlcyBhIG5ldyBoYW5kbGUgKi8NCisgICAgICAgICAgICAgICAg
X191MzIgcG9saWN5OyAgICAgICAgICAgLyogZ3Vlc3QncyBwb2xpY3kgKi8NCisNCisgICAgICAg
ICAgICAgICAgX191NjQgcGRoX3VhZGRyOyAgICAgICAgIC8qIHVzZXJzcGFjZSBhZGRyZXNzIHBv
aW50aW5nIHRvIHRoZSBQREgga2V5ICovDQorICAgICAgICAgICAgICAgIF9fdTMyIGRoX2xlbjsN
CisNCisgICAgICAgICAgICAgICAgX191NjQgc2Vzc2lvbl9hZGRyOyAgICAgLyogdXNlcnNwYWNl
IGFkZHJlc3Mgd2hpY2ggcG9pbnRzIHRvIHRoZSBndWVzdCBzZXNzaW9uIGluZm9ybWF0aW9uICov
DQorICAgICAgICAgICAgICAgIF9fdTMyIHNlc3Npb25fbGVuOw0KKyAgICAgICAgfTsNCisNCitP
biBzdWNjZXNzLCB0aGUgJ2hhbmRsZScgZmllbGQgY29udGFpbnMgYSBuZXcgaGFuZGxlIGFuZCBv
biBlcnJvciwgYSBuZWdhdGl2ZSB2YWx1ZS4NCisNCitGb3IgbW9yZSBkZXRhaWxzLCBzZWUgU0VW
IHNwZWMgU2VjdGlvbiA2LjEyLg0KKw0KIFJlZmVyZW5jZXMNCiA9PT09PT09PT09DQogDQpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQppbmRleCAz
ZGZlM2YwNTFkZDkuLjk0YTU1ZTQxMjhhYSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9zdm0u
Yw0KKysrIGIvYXJjaC94ODYva3ZtL3N2bS5jDQpAQCAtNzE5MSw2ICs3MTkxLDgzIEBAIHN0YXRp
YyBpbnQgc2V2X3NlbmRfZmluaXNoKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9zZXZfY21k
ICphcmdwKQ0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCitzdGF0aWMgaW50IHNldl9yZWNlaXZlX3N0
YXJ0KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9zZXZfY21kICphcmdwKQ0KK3sNCisJc3Ry
dWN0IGt2bV9zZXZfaW5mbyAqc2V2ID0gJnRvX2t2bV9zdm0oa3ZtKS0+c2V2X2luZm87DQorCXN0
cnVjdCBzZXZfZGF0YV9yZWNlaXZlX3N0YXJ0ICpzdGFydDsNCisJc3RydWN0IGt2bV9zZXZfcmVj
ZWl2ZV9zdGFydCBwYXJhbXM7DQorCWludCAqZXJyb3IgPSAmYXJncC0+ZXJyb3I7DQorCXZvaWQg
KnNlc3Npb25fZGF0YSA9IE5VTEw7DQorCXZvaWQgKnBkaF9kYXRhID0gTlVMTDsNCisJaW50IHJl
dDsNCisNCisJaWYgKCFzZXZfZ3Vlc3Qoa3ZtKSkNCisJCXJldHVybiAtRU5PVFRZOw0KKw0KKwkv
KiBHZXQgcGFyYW1ldGVyIGZyb20gdGhlIHVzZXIgKi8NCisJaWYgKGNvcHlfZnJvbV91c2VyKCZw
YXJhbXMsICh2b2lkIF9fdXNlciAqKSh1aW50cHRyX3QpYXJncC0+ZGF0YSwNCisJCQlzaXplb2Yo
c3RydWN0IGt2bV9zZXZfcmVjZWl2ZV9zdGFydCkpKQ0KKwkJcmV0dXJuIC1FRkFVTFQ7DQorDQor
CWlmICghcGFyYW1zLnBkaF91YWRkciB8fCAhcGFyYW1zLnBkaF9sZW4gfHwNCisJICAgICFwYXJh
bXMuc2Vzc2lvbl91YWRkciB8fCAhcGFyYW1zLnNlc3Npb25fbGVuKQ0KKwkJcmV0dXJuIC1FSU5W
QUw7DQorDQorCXN0YXJ0ID0ga3phbGxvYyhzaXplb2YoKnN0YXJ0KSwgR0ZQX0tFUk5FTCk7DQor
CWlmICghc3RhcnQpDQorCQlyZXR1cm4gLUVOT01FTTsNCisNCisJc3RhcnQtPmhhbmRsZSA9IHBh
cmFtcy5oYW5kbGU7DQorCXN0YXJ0LT5wb2xpY3kgPSBwYXJhbXMucG9saWN5Ow0KKw0KKwlwZGhf
ZGF0YSA9IHBzcF9jb3B5X3VzZXJfYmxvYihwYXJhbXMucGRoX3VhZGRyLCBwYXJhbXMucGRoX2xl
bik7DQorCWlmIChJU19FUlIocGRoX2RhdGEpKSB7DQorCQlyZXQgPSBQVFJfRVJSKHBkaF9kYXRh
KTsNCisJCWdvdG8gZV9mcmVlOw0KKwl9DQorDQorCXN0YXJ0LT5wZGhfY2VydF9hZGRyZXNzID0g
X19wc3BfcGEocGRoX2RhdGEpOw0KKwlzdGFydC0+cGRoX2NlcnRfbGVuID0gcGFyYW1zLnBkaF9s
ZW47DQorDQorCXNlc3Npb25fZGF0YSA9IHBzcF9jb3B5X3VzZXJfYmxvYihwYXJhbXMuc2Vzc2lv
bl91YWRkciwgcGFyYW1zLnNlc3Npb25fbGVuKTsNCisJaWYgKElTX0VSUihzZXNzaW9uX2RhdGEp
KSB7DQorCQlyZXQgPSBQVFJfRVJSKHNlc3Npb25fZGF0YSk7DQorCQlnb3RvIGVfZnJlZV9wZGg7
DQorCX0NCisNCisJc3RhcnQtPnNlc3Npb25fYWRkcmVzcyA9IF9fcHNwX3BhKHNlc3Npb25fZGF0
YSk7DQorCXN0YXJ0LT5zZXNzaW9uX2xlbiA9IHBhcmFtcy5zZXNzaW9uX2xlbjsNCisNCisJLyog
Y3JlYXRlIG1lbW9yeSBlbmNyeXB0aW9uIGNvbnRleHQgKi8NCisJcmV0ID0gX19zZXZfaXNzdWVf
Y21kKGFyZ3AtPnNldl9mZCwgU0VWX0NNRF9SRUNFSVZFX1NUQVJULCBzdGFydCwgZXJyb3IpOw0K
KwlpZiAocmV0KQ0KKwkJZ290byBlX2ZyZWVfc2Vzc2lvbjsNCisNCisJLyogQmluZCBBU0lEIHRv
IHRoaXMgZ3Vlc3QgKi8NCisJcmV0ID0gc2V2X2JpbmRfYXNpZChrdm0sIHN0YXJ0LT5oYW5kbGUs
IGVycm9yKTsNCisJaWYgKHJldCkNCisJCWdvdG8gZV9mcmVlX3Nlc3Npb247DQorDQorCXBhcmFt
cy5oYW5kbGUgPSBzdGFydC0+aGFuZGxlOw0KKwlpZiAoY29weV90b191c2VyKCh2b2lkIF9fdXNl
ciAqKSh1aW50cHRyX3QpYXJncC0+ZGF0YSwNCisJCQkgJnBhcmFtcywgc2l6ZW9mKHN0cnVjdCBr
dm1fc2V2X3JlY2VpdmVfc3RhcnQpKSkgew0KKwkJcmV0ID0gLUVGQVVMVDsNCisJCXNldl91bmJp
bmRfYXNpZChrdm0sIHN0YXJ0LT5oYW5kbGUpOw0KKwkJZ290byBlX2ZyZWVfc2Vzc2lvbjsNCisJ
fQ0KKw0KKwlzZXYtPmhhbmRsZSA9IHN0YXJ0LT5oYW5kbGU7DQorCXNldi0+ZmQgPSBhcmdwLT5z
ZXZfZmQ7DQorDQorZV9mcmVlX3Nlc3Npb246DQorCWtmcmVlKHNlc3Npb25fZGF0YSk7DQorZV9m
cmVlX3BkaDoNCisJa2ZyZWUocGRoX2RhdGEpOw0KK2VfZnJlZToNCisJa2ZyZWUoc3RhcnQpOw0K
KwlyZXR1cm4gcmV0Ow0KK30NCisNCiBzdGF0aWMgaW50IHN2bV9tZW1fZW5jX29wKHN0cnVjdCBr
dm0gKmt2bSwgdm9pZCBfX3VzZXIgKmFyZ3ApDQogew0KIAlzdHJ1Y3Qga3ZtX3Nldl9jbWQgc2V2
X2NtZDsNCkBAIC03MjQxLDYgKzczMTgsOSBAQCBzdGF0aWMgaW50IHN2bV9tZW1fZW5jX29wKHN0
cnVjdCBrdm0gKmt2bSwgdm9pZCBfX3VzZXIgKmFyZ3ApDQogCWNhc2UgS1ZNX1NFVl9TRU5EX0ZJ
TklTSDoNCiAJCXIgPSBzZXZfc2VuZF9maW5pc2goa3ZtLCAmc2V2X2NtZCk7DQogCQlicmVhazsN
CisJY2FzZSBLVk1fU0VWX1JFQ0VJVkVfU1RBUlQ6DQorCQlyID0gc2V2X3JlY2VpdmVfc3RhcnQo
a3ZtLCAmc2V2X2NtZCk7DQorCQlicmVhazsNCiAJZGVmYXVsdDoNCiAJCXIgPSAtRUlOVkFMOw0K
IAkJZ290byBvdXQ7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oIGIvaW5j
bHVkZS91YXBpL2xpbnV4L2t2bS5oDQppbmRleCA0Y2I2YzM3NzRlYzIuLjI4ZDI0MDk3NGVhNyAx
MDA2NDQNCi0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaA0KKysrIGIvaW5jbHVkZS91YXBp
L2xpbnV4L2t2bS5oDQpAQCAtMTU1Miw2ICsxNTUyLDE1IEBAIHN0cnVjdCBrdm1fc2V2X3NlbmRf
dXBkYXRlX2RhdGEgew0KIAlfX3UzMiB0cmFuc19sZW47DQogfTsNCiANCitzdHJ1Y3Qga3ZtX3Nl
dl9yZWNlaXZlX3N0YXJ0IHsNCisJX191MzIgaGFuZGxlOw0KKwlfX3UzMiBwb2xpY3k7DQorCV9f
dTY0IHBkaF91YWRkcjsNCisJX191MzIgcGRoX2xlbjsNCisJX191NjQgc2Vzc2lvbl91YWRkcjsN
CisJX191MzIgc2Vzc2lvbl9sZW47DQorfTsNCisNCiAjZGVmaW5lIEtWTV9ERVZfQVNTSUdOX0VO
QUJMRV9JT01NVQkoMSA8PCAwKQ0KICNkZWZpbmUgS1ZNX0RFVl9BU1NJR05fUENJXzJfMwkJKDEg
PDwgMSkNCiAjZGVmaW5lIEtWTV9ERVZfQVNTSUdOX01BU0tfSU5UWAkoMSA8PCAyKQ0KLS0gDQoy
LjE3LjENCg0K
