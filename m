Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9202817A00B
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 07:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgCEGjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 01:39:16 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52144 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbgCEGjQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 01:39:16 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0256Vas5003923;
        Wed, 4 Mar 2020 22:38:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=xeGb4iVm9qCO64h/1xu6V38CPmzScchi1hE2OKu7HBU=;
 b=iAMGfIUWF48sDpStNxSr/2i4FEgC+L18/5izaO0STgo5Ic6TqIr1g5rOo04+zm5AVhhq
 Wc9XfEOpLaxmnwrQI/Mbx7zUQEz4uqNhctjrRqbR3W3t5cXJoa4tAz5ytEq9PCY0y9Do
 iI+ogS3hlfeIilXfL+tSKQgI69fZ5ztpp8ZkVyTTr7BYMQk4CbFBZnga1YEBIBXuxOkw
 YbSORXJl9AuvBRfNIEMG3OGofdnca5bdIGfpozsDOPQKDdKQ9Qoai5UxxrkfjajSJ1Kw
 qnac0ON3Peh7CvzlGzXshXt8+pVUrNYne385tGsbiQdqQtrIzOvxo0dnPxZ52afxCB1T fQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yhn0y4jh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Mar 2020 22:38:59 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Mar
 2020 22:38:57 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Mar
 2020 22:38:56 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 4 Mar 2020 22:38:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6pma/xBxW+/gW9w6EbbS9pAdH0MVl3Io4xYosGDg2SVUGYp1b1XFm+0UEymdV7LwbQZoJuw2s8nW4kPym4aaKr2ZUmuqgRXddIKhThESBBRBJ6jblf9mRYwQkKYin2FmzYExpANKQ1wp7tlX+Yr6SbiXzzlJ/1lClT7WzwoSUTTJuWt2C9v403YeYU3xoqqdqa+Ih+/9Jlj4tZ26fTZIcj+lADXP6WEi85fBHIZztrxodjNpjfM2aUwOQBiSZoi7ZxubY7v1y5naks91Y9pitOnx612luNIoyXN24Jrp8gCBkDplAa/9fa1vbKawCoFwzsJJCGVXPOmUgGJ1bii5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xeGb4iVm9qCO64h/1xu6V38CPmzScchi1hE2OKu7HBU=;
 b=VQcFWlqdiemVcJxeakm/3Uf6ovsWJyQ0hL7GtI47TrobABMpS2Ffr0UJJhJ0zn3pDyXJPdm4KIq4sim3IXk+ioRz+CEfOXbqN63ndGsixXpksyNXdwXdtDLH/XhjVZI/mr8yOQF2OUw5Ea6LR0GEGmYiVs1HknUIu12UuV/L7QzW1OF1LG9Kb+B2W36D7RIJ65Z22cZmiyoi//gyAeaWZFlfIlyEOZxPWgpMp6NIGRpXoYL0CdCd+Kd5cgzz9mFyahZwJvAIefPHHL9KETyu6EgVX7e8Jmp+NWiS7u5Yd/6A+L9PjaXVjAxc7AAZ9pr7mPCM95kGwjkatSqzEqI60w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xeGb4iVm9qCO64h/1xu6V38CPmzScchi1hE2OKu7HBU=;
 b=pEQNknRshbH4xLfnMgtF7/eTynH1tblZvqTxV7bqu7n7vLGSecEa0Qe1y5DjZwCZnDI8N4WnxtWXOPTw3nVSneloij4lsbxXrZQuFFCC38hg+lDMic6AzauM6UdXK9aZ+AfRU/zQ4LHtJ0I1xb5Kj248Ecisgo8MhrZWPCec7Sg=
Received: from MWHPR18MB1645.namprd18.prod.outlook.com (2603:10b6:300:ca::9)
 by MWHPR18MB1248.namprd18.prod.outlook.com (2603:10b6:320:2d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Thu, 5 Mar
 2020 06:38:54 +0000
Received: from MWHPR18MB1645.namprd18.prod.outlook.com
 ([fe80::d99d:e2e7:c30c:b9da]) by MWHPR18MB1645.namprd18.prod.outlook.com
 ([fe80::d99d:e2e7:c30c:b9da%3]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 06:38:53 +0000
From:   Vamsi Krishna Attunuru <vattunuru@marvell.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@dpdk.org" <dev@dpdk.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "thomas@monjalon.net" <thomas@monjalon.net>,
        "bluca@debian.org" <bluca@debian.org>,
        "jerinjacobk@gmail.com" <jerinjacobk@gmail.com>,
        "bruce.richardson@intel.com" <bruce.richardson@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [dpdk-dev] [PATCH v2 0/7] vfio/pci: SR-IOV support
Thread-Topic: [dpdk-dev] [PATCH v2 0/7] vfio/pci: SR-IOV support
Thread-Index: AQHV51X7eLKwmiSOk0SM9CYSJOQVqqg5oG3Q
Date:   Thu, 5 Mar 2020 06:38:53 +0000
Message-ID: <MWHPR18MB1645DCF80543381CF9115D09A6E20@MWHPR18MB1645.namprd18.prod.outlook.com>
References: <158213716959.17090.8399427017403507114.stgit@gimli.home>
In-Reply-To: <158213716959.17090.8399427017403507114.stgit@gimli.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [103.227.96.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd2f770b-993b-46d2-7cdd-08d7c0cfdfa5
x-ms-traffictypediagnostic: MWHPR18MB1248:
x-microsoft-antispam-prvs: <MWHPR18MB1248252816DF8918D5E2C37EA6E20@MWHPR18MB1248.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:167;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39850400004)(396003)(346002)(376002)(136003)(189003)(199004)(52536014)(71200400001)(6506007)(316002)(2906002)(19627235002)(33656002)(5660300002)(66446008)(66476007)(66556008)(66946007)(64756008)(7696005)(76116006)(55016002)(81166006)(7416002)(86362001)(186003)(9686003)(54906003)(8936002)(26005)(478600001)(4326008)(8676002)(966005)(53546011)(81156014)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR18MB1248;H:MWHPR18MB1645.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MMJ/T2QkaRvE1WfLpUE3R3MjvUDVPxeDGJOuVQTbi/U9vSKGNzpG00xqv5gLZ2twCLXcu5QFhoxcZTPEOQtVSShfpE8YM4zO/TftPJLEioyyTd2ncjxQFMB1T7EiOEd/hb2upjJY0Mmbg6RZdzFEKseOHia1bgbtaEW6rofjr8EZ3yeiRR6+zy2Gm09xhnkPOcEXnww9YZd5sccZ4P4Nf/h9tQkAsJFAtz1i5A9n355QYtfQKofCamlGGx7fGOqerGq2xoPLq9SPFvkjiap0uyO/l72WZA0fmtgH4Z6glsuJH8hT3HOx4jjRuL2/XxZX2aA7LC4HeB1sPYGEZkw8SlP0rnvteno7FeHws2j3cPkSVbm/CgwuoAXlV50C4OJ0pW1pTer9ccvDY1vR2adVyzqUTztpaPwBlg+KuzaSTvGAk/NmBRtEPKf6a6W1g1me4i8FbsiQ6QwZ1QGZZ1zCwnhhPWINDxCNO+TND5wg8NU7gS4+kAqQHH0BRaTCyzuitZefBImBHJDZVr0moH+gBw==
x-ms-exchange-antispam-messagedata: 8f56Kjbj7Yjtk8zknSdCpQv7AkQpgFyiwxh7iLvrXQVTahfMG1LuoL1FcOcoCqTCyphsMCZ0l+ZcUKNq+ri1Ylu7S73Elplxhsq8nzZBU6LCUP8MGZceDib3h3gISAwrc0tRzi30sQLjz398modj3w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dd2f770b-993b-46d2-7cdd-08d7c0cfdfa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 06:38:53.7673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PbM9HNJMbJjf2P7POLeWkqXfSJXn1L5x1kJoIBKeUX6YKQoatkaAX/TEQBv6bx9ODc+N7sbezZRBrI2ZdpmAig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1248
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-05_01:2020-03-04,2020-03-05 signatures=0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGRldiA8ZGV2LWJvdW5jZXNA
ZHBkay5vcmc+IE9uIEJlaGFsZiBPZiBBbGV4IFdpbGxpYW1zb24NCj4gU2VudDogVGh1cnNkYXks
IEZlYnJ1YXJ5IDIwLCAyMDIwIDEyOjI0IEFNDQo+IFRvOiBrdm1Admdlci5rZXJuZWwub3JnDQo+
IENjOiBsaW51eC1wY2lAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnOyBkZXZAZHBkay5vcmc7DQo+IG10b3NhdHRpQHJlZGhhdC5jb207IHRob21hc0Btb25qYWxv
bi5uZXQ7IGJsdWNhQGRlYmlhbi5vcmc7DQo+IGplcmluamFjb2JrQGdtYWlsLmNvbTsgYnJ1Y2Uu
cmljaGFyZHNvbkBpbnRlbC5jb207IGNvaHVja0ByZWRoYXQuY29tDQo+IFN1YmplY3Q6IFtkcGRr
LWRldl0gW1BBVENIIHYyIDAvN10gdmZpby9wY2k6IFNSLUlPViBzdXBwb3J0DQo+IA0KPiBDaGFu
Z2VzIHNpbmNlIHYxIGFyZSBwcmltYXJpbHkgdG8gcGF0Y2ggMy83IHdoZXJlIHRoZSBjb21taXQg
bG9nIGlzDQo+IHJld3JpdHRlbiwgYWxvbmcgd2l0aCBvcHRpb24gcGFyc2luZyBhbmQgZmFpbHVy
ZSBsb2dnaW5nIGJhc2VkIG9uIHVwc3RyZWFtDQo+IGRpc2N1c3Npb25zLiAgVGhlIHByaW1hcnkg
dXNlciB2aXNpYmxlIGRpZmZlcmVuY2UgaXMgdGhhdCBvcHRpb24gcGFyc2luZyBpcyBub3cNCj4g
bXVjaCBtb3JlIHN0cmljdC4gIElmIGEgdmZfdG9rZW4gb3B0aW9uIGlzIHByb3ZpZGVkIHRoYXQg
Y2Fubm90IGJlIHVzZWQsIHdlDQo+IGdlbmVyYXRlIGFuIGVycm9yLiAgQXMgYSByZXN1bHQgb2Yg
dGhpcywgb3BlbmluZyBhIFBGIHdpdGggYSB2Zl90b2tlbiBvcHRpb24NCj4gd2lsbCBzZXJ2ZSBh
cyBhIG1lY2hhbmlzbSBvZiBzZXR0aW5nIHRoZSB2Zl90b2tlbi4gIFRoaXMgc2VlbXMgbGlrZSBh
IG1vcmUNCj4gdXNlciBmcmllbmRseSBBUEkgdGhhbiB0aGUgYWx0ZXJuYXRpdmUgb2Ygc29tZXRp
bWVzIHJlcXVpcmluZyB0aGUgb3B0aW9uIChWRnMNCj4gaW4gdXNlKSBhbmQgc29tZXRpbWVzIHJl
amVjdGluZyBpdCwgYW5kIHVwaG9sZHMgb3VyIGRlc2lyZSB0aGF0IHRoZSBvcHRpb24gaXMNCj4g
YWx3YXlzIGVpdGhlciB1c2VkIG9yIHJlamVjdGVkLg0KPiANCj4gVGhpcyBhbHNvIG1lYW5zIHRo
YXQgdGhlIFZGSU9fREVWSUNFX0ZFQVRVUkUgaW9jdGwgaXMgbm90IHRoZSBvbmx5IG1lYW5zDQo+
IG9mIHNldHRpbmcgdGhlIFZGIHRva2VuLCB3aGljaCBtaWdodCBjYWxsIGludG8gcXVlc3Rpb24g
d2hldGhlciB3ZSBhYnNvbHV0ZWx5DQo+IG5lZWQgdGhpcyBuZXcgaW9jdGwuICBDdXJyZW50bHkg
SSdtIGtlZXBpbmcgaXQgYmVjYXVzZSBJIGNhbiBpbWFnaW5lIHVzZSBjYXNlcywNCj4gZm9yIGV4
YW1wbGUgaWYgYSBoeXBlcnZpc29yIHdlcmUgdG8gc3VwcG9ydCBTUi1JT1YsIHRoZSBQRiBkZXZp
Y2UgbWlnaHQgYmUNCj4gb3BlbmVkIHdpdGhvdXQgY29uc2lkZXJhdGlvbiBmb3IgYSBWRiB0b2tl
biBhbmQgd2UnZCByZXF1aXJlIHRoZQ0KPiBoeXBzZXJ2aXNvciB0byBjbG9zZSBhbmQgcmUtb3Bl
biB0aGUgUEYgaW4gb3JkZXIgdG8gc2V0IGEga25vd24gVkYgdG9rZW4sDQo+IHdoaWNoIGlzIGlt
cHJhY3RpY2FsLg0KPiANCj4gU2VyaWVzIG92ZXJ2aWV3IChzYW1lIGFzIHByb3ZpZGVkIHdpdGgg
djEpOg0KPiANCj4gVGhlIHN5bm9wc2lzIG9mIHRoaXMgc2VyaWVzIGlzIHRoYXQgd2UgaGF2ZSBh
biBvbmdvaW5nIGRlc2lyZSB0byBkcml2ZSBQQ0llIFNSLQ0KPiBJT1YgUEZzIGZyb20gdXNlcnNw
YWNlIHdpdGggVkZJTy4gIFRoZXJlJ3MgYW4gaW1tZWRpYXRlIG5lZWQgZm9yIHRoaXMgd2l0aA0K
PiBEUERLIGRyaXZlcnMgYW5kIHBvdGVudGlhbGx5IGludGVyZXN0aW5nIGZ1dHVyZSB1c2UgY2Fz
ZXMgaW4gdmlydHVhbGl6YXRpb24uDQo+IFdlJ3ZlIGJlZW4gcmVsdWN0YW50IHRvIGFkZCB0aGlz
IHN1cHBvcnQgcHJldmlvdXNseSBkdWUgdG8gdGhlIGRlcGVuZGVuY3kNCj4gYW5kIHRydXN0IHJl
bGF0aW9uc2hpcCBiZXR3ZWVuIHRoZSBWRiBkZXZpY2UgYW5kIFBGIGRyaXZlci4gIE1pbmltYWxs
eSB0aGUgUEYNCj4gZHJpdmVyIGNhbiBpbmR1Y2UgYSBkZW5pYWwgb2Ygc2VydmljZSB0byB0aGUg
VkYsIGJ1dCBkZXBlbmRpbmcgb24gdGhlIHNwZWNpZmljDQo+IGltcGxlbWVudGF0aW9uLCB0aGUg
UEYgZHJpdmVyIG1pZ2h0IGFsc28gYmUgcmVzcG9uc2libGUgZm9yIG1vdmluZyBkYXRhDQo+IGJl
dHdlZW4gVkZzIG9yIGhhdmUgZGlyZWN0IGFjY2VzcyB0byB0aGUgc3RhdGUgb2YgdGhlIFZGLCBp
bmNsdWRpbmcgZGF0YSBvcg0KPiBzdGF0ZSBvdGhlcndpc2UgcHJpdmF0ZSB0byB0aGUgVkYgb3Ig
VkYgZHJpdmVyLg0KPiANCj4gVG8gaGVscCByZXNvbHZlIHRoZXNlIGNvbmNlcm5zLCB3ZSBpbnRy
b2R1Y2UgYSBWRiB0b2tlbiBpbnRvIHRoZSBWRklPIFBDSQ0KPiBBQkksIHdoaWNoIGFjdHMgYXMg
YSBzaGFyZWQgc2VjcmV0IGtleSBiZXR3ZWVuIGRyaXZlcnMuICBUaGUgdXNlcnNwYWNlIFBGDQo+
IGRyaXZlciBpcyByZXF1aXJlZCB0byBzZXQgdGhlIFZGIHRva2VuIHRvIGEga25vd24gdmFsdWUg
YW5kIHVzZXJzcGFjZSBWRg0KPiBkcml2ZXJzIGFyZSByZXF1aXJlZCB0byBwcm92aWRlIHRoZSB0
b2tlbiB0byBhY2Nlc3MgdGhlIFZGIGRldmljZS4gIElmIGEgUEYNCj4gZHJpdmVyIGlzIHJlc3Rh
cnRlZCB3aXRoIFZGIGRyaXZlcnMgaW4gdXNlLCBpdCBtdXN0IGFsc28gcHJvdmlkZSB0aGUgY3Vy
cmVudA0KPiB0b2tlbiBpbiBvcmRlciB0byBwcmV2ZW50IGEgcm9ndWUgdW50cnVzdGVkIFBGIGRy
aXZlciBmcm9tIHJlcGxhY2luZyBhIGtub3duDQo+IGRyaXZlci4gIFRoZSBkZWdyZWUgdG8gd2hp
Y2ggdGhpcyBuZXcgdG9rZW4gaXMgY29uc2lkZXJlZCBzZWNyZXQgaXMgbGVmdCB0byB0aGUNCj4g
dXNlcnNwYWNlIGRyaXZlcnMsIHRoZSBrZXJuZWwgaW50ZW50aW9uYWxseSBwcm92aWRlcyBubyBt
ZWFucyB0byByZXRyaWV2ZSB0aGUNCj4gY3VycmVudCB0b2tlbi4NCj4gDQo+IE5vdGUgdGhhdCB0
aGUgYWJvdmUgdG9rZW4gaXMgb25seSByZXF1aXJlZCBmb3IgdGhpcyBuZXcgbW9kZWwgd2hlcmUg
Ym90aA0KPiB0aGUgUEYgYW5kIFZGIGRldmljZXMgYXJlIHVzYWJsZSB0aHJvdWdoIHZmaW8tcGNp
LiAgRXhpc3RpbmcgbW9kZWxzIG9mIFZGSU8NCj4gZHJpdmVycyB3aGVyZSB0aGUgUEYgaXMgdXNl
ZCB3aXRob3V0IFNSLUlPViBlbmFibGVkIG9yIHRoZSBWRiBpcyBib3VuZCB0byBhDQo+IHVzZXJz
cGFjZSBkcml2ZXIgd2l0aCBhbiBpbi1rZXJuZWwsIGhvc3QgUEYgZHJpdmVyIGFyZSB1bmFmZmVj
dGVkLg0KPiANCj4gVGhlIGxhdHRlciBjb25maWd1cmF0aW9uIGFib3ZlIGFsc28gaGlnaGxpZ2h0
cyBhIG5ldyBpbnZlcnRlZCBzY2VuYXJpbyB0aGF0IGlzDQo+IG5vdyBwb3NzaWJsZSwgYSB1c2Vy
c3BhY2UgUEYgZHJpdmVyIHdpdGggaW4ta2VybmVsIFZGIGRyaXZlcnMuDQo+IEkgYmVsaWV2ZSB0
aGlzIGlzIGEgc2NlbmFyaW8gdGhhdCBzaG91bGQgYmUgYWxsb3dlZCwgYnV0IHNob3VsZCBub3Qg
YmUgZW5hYmxlZA0KPiBieSBkZWZhdWx0LiAgVGhpcyBzZXJpZXMgaW5jbHVkZXMgY29kZSB0byBz
ZXQgYSBkZWZhdWx0IGRyaXZlcl9vdmVycmlkZSBmb3IgVkZzDQo+IHNvdXJjZWQgZnJvbSBhIHZm
aW8tcGNpIHVzZXIgb3duZWQgUEYsIHN1Y2ggdGhhdCB0aGUgVkZzIGFyZSBhbHNvIGJvdW5kIHRv
DQo+IHZmaW8tcGNpLiAgVGhpcyBtb2RlbCBpcyBjb21wYXRpYmxlIHdpdGggdG9vbHMgbGlrZSBk
cml2ZXJjdGwgYW5kIGFsbG93cyB0aGUNCj4gc3lzdGVtIGFkbWluaXN0cmF0b3IgdG8gZGVjaWRl
IGlmIG90aGVyIGJpbmRpbmdzIHNob3VsZCBiZSBlbmFibGVkLiAgVGhlIFZGDQo+IHRva2VuIGlu
dGVyZmFjZSBhYm92ZSBleGlzdHMgb25seSBiZXR3ZWVuIHZmaW8tcGNpIFBGIGFuZCBWRiBkcml2
ZXJzLCBvbmNlIGENCj4gVkYgaXMgYm91bmQgdG8gYW5vdGhlciBkcml2ZXIsIHRoZSBhZG1pbmlz
dHJhdG9yIGhhcyBlZmZlY3RpdmVseSBwcm9ub3VuY2VkDQo+IHRoZSBkZXZpY2UgYXMgdHJ1c3Rl
ZC4gIFRoZSB2ZmlvLXBjaSBkcml2ZXIgd2lsbCBub3RlIGFsdGVybmF0ZSBiaW5kaW5nIGluIGRt
ZXNnDQo+IGZvciBsb2dnaW5nIGFuZCBkZWJ1Z2dpbmcgcHVycG9zZXMuDQo+IA0KPiBQbGVhc2Ug
cmV2aWV3LCBjb21tZW50LCBhbmQgdGVzdC4gIFRoZSBleGFtcGxlIFFFTVUgaW1wbGVtZW50YXRp
b24NCj4gcHJvdmlkZWQgd2l0aCB0aGUgUkZDIGlzIHN0aWxsIGN1cnJlbnQgZm9yIHRoaXMgdmVy
c2lvbi4gIFRoYW5rcywNCj4gDQo+IEFsZXgNCg0KSGkgQWxleCwNCg0KVGhhbmtzIGZvciBlbmFi
bGluZyB0aGlzIGZlYXR1cmUgc3VwcG9ydC4NCg0KVGVzdGVkLWJ5OiBWYW1zaSBBdHR1bnVydSA8
dmF0dHVudXJ1QG1hcnZlbGwuY29tPg0KDQpUZXN0ZWQgdjIgcGF0Y2ggc2V0IHdpdGggYmVsb3cg
RFBESyBwYXRjaC4NCmh0dHA6Ly9wYXRjaGVzLmRwZGsub3JnL3BhdGNoLzY2MjgxLw0KDQpSZWdh
cmRzDQpBIFZhbXNpDQoNCj4gDQo+IFJGQzogaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQu
Y29tL3YyL3VybD91PWh0dHBzLQ0KPiAzQV9fbG9yZS5rZXJuZWwub3JnX2xrbWxfMTU4MDg1MzM3
NTgyLjk0NDUuMTc2ODIyNjY0Mzc1ODM1MDU1MDIuc3RnaXQtDQo+IDQwZ2ltbGkuaG9tZV8mZD1E
d0lDYVEmYz1uS2pXZWMyYjZSMG1PeVBhejd4dGZRJnI9MnJweHhORjJxZVAwDQo+IDJnVlpJV1RW
clctNnpOWno1LXVLdDlwUnFwUl9NM1UmbT1WLTZtS21DVEhQWmE1andlcFhVXy0NCj4gTWExX0JH
RjBPV0pfSVJDRl9wNEdWbyZzPVluTzk4UEdLOXJvN0Y2X1haVGNjSGRZY1otDQo+IHJNTU9pbjBu
UkZoUEQ2VXY0JmU9DQo+IHYxOiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIv
dXJsP3U9aHR0cHMtDQo+IDNBX19sb3JlLmtlcm5lbC5vcmdfbGttbF8xNTgxNDU0NzI2MDQuMTY4
MjcuMTU3NTEzNzU1NDAxMDIyOTgxMzAuc3RnaXQNCj4gLQ0KPiA0MGdpbWxpLmhvbWVfJmQ9RHdJ
Q2FRJmM9bktqV2VjMmI2UjBtT3lQYXo3eHRmUSZyPTJycHh4TkYycWVQMA0KPiAyZ1ZaSVdUVnJX
LTZ6Tlp6NS11S3Q5cFJxcFJfTTNVJm09Vi02bUttQ1RIUFphNWp3ZXBYVV8tDQo+IE1hMV9CR0Yw
T1dKX0lSQ0ZfcDRHVm8mcz1ydlV4TENFTndOazBHQllrY3NCVlZvYnNMZk1iNEJWNWd0Yw0KPiAz
VnFZUVRTNCZlPQ0KPiANCj4gLS0tDQo+IA0KPiBBbGV4IFdpbGxpYW1zb24gKDcpOg0KPiAgICAg
ICB2ZmlvOiBJbmNsdWRlIG9wdGlvbmFsIGRldmljZSBtYXRjaCBpbiB2ZmlvX2RldmljZV9vcHMg
Y2FsbGJhY2tzDQo+ICAgICAgIHZmaW8vcGNpOiBJbXBsZW1lbnQgbWF0Y2ggb3BzDQo+ICAgICAg
IHZmaW8vcGNpOiBJbnRyb2R1Y2UgVkYgdG9rZW4NCj4gICAgICAgdmZpbzogSW50cm9kdWNlIFZG
SU9fREVWSUNFX0ZFQVRVUkUgaW9jdGwgYW5kIGZpcnN0IHVzZXINCj4gICAgICAgdmZpby9wY2k6
IEFkZCBzcmlvdl9jb25maWd1cmUgc3VwcG9ydA0KPiAgICAgICB2ZmlvL3BjaTogUmVtb3ZlIGRl
dl9mbXQgZGVmaW5pdGlvbg0KPiAgICAgICB2ZmlvL3BjaTogQ2xlYW51cCAucHJvYmUoKSBleGl0
IHBhdGhzDQo+IA0KPiANCj4gIGRyaXZlcnMvdmZpby9wY2kvdmZpb19wY2kuYyAgICAgICAgIHwg
IDM4Mw0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiAgZHJpdmVycy92
ZmlvL3BjaS92ZmlvX3BjaV9wcml2YXRlLmggfCAgIDEwICsNCj4gIGRyaXZlcnMvdmZpby92Zmlv
LmMgICAgICAgICAgICAgICAgIHwgICAyMCArLQ0KPiAgaW5jbHVkZS9saW51eC92ZmlvLmggICAg
ICAgICAgICAgICAgfCAgICA0DQo+ICBpbmNsdWRlL3VhcGkvbGludXgvdmZpby5oICAgICAgICAg
ICB8ICAgMzcgKysrDQo+ICA1IGZpbGVzIGNoYW5nZWQsIDQyNiBpbnNlcnRpb25zKCspLCAyOCBk
ZWxldGlvbnMoLSkNCg0K
