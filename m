Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851461A05E4
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 06:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgDGEnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 00:43:15 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:30900 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726714AbgDGEnP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 00:43:15 -0400
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0374gblp022062;
        Mon, 6 Apr 2020 21:43:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=HMZIF16ygR3CZ1WelwGz6PeUiFcUlO8wZoyCcuZ/u4Y=;
 b=fbWHF1FjkqVmGQ7SC5iXb9rwX5ICT/ywfLTwgCyn74YhNgMdWbqhADmtuc5bEjkzRGZV
 ak36HaVZQLEGpIzigxoazcF7HrE26qht0dczgi2NHBqDtGuW9kashU7ocWk9j8hUL4yv
 S4il9uyGytrSDeyfRzLNjtrla7++vfatByUUbeDHhUzCNcVIrViBK6RrYaf/zlkfBu6f
 TZvuBDv86uz0oFyHh9fOh5vDdvfdOXpiF8rO0zXLxHaNRCS7QF2Ryqb3tZY7d3y/no51
 iin3mFFEaKA9THrM6JrYevZCjwL5SkWlJtK2bTEgKLHE8RYqdodCrD0zS+pUGkcjC16g BA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by mx0a-002c1b01.pphosted.com with ESMTP id 306p5adcae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Apr 2020 21:43:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kScPml7PbAqBfJM9WZ8iPSQjU5BGmwkBQObZsRC4kJr8F1nVjuqGFWfytkWBQM0ezB2HDW+V8mGUMYScloXx4IrW86o4sYT5VpcRjNjzQJ146B1hkj3vCRNzgYVgfPrDLWiOrNg6z5p0FA7UiAk1o10sp3aKsVyCQ7uq9pEHRjwyJ96jPGR2po95MwUp7I79tonydqEJ/7S7kdop0I/93XTD8DNeR8EKbnct+Ggjvu2Ie5ePVv0BqeGsJBNESZn+SQqfeXlJHGeqak+bBTvxkNqG5fu5qyl2seUJcExDn+m+oaM66SCQAJPi0OOK57nHAvLJ7DL+aYCoYUBVinFq0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HMZIF16ygR3CZ1WelwGz6PeUiFcUlO8wZoyCcuZ/u4Y=;
 b=PWffN2Vp+ranSZ4SU529kYV0sWlB5Mcmgwg+jBGMXS+75dnHwcQv+V0ujDq0zuKi83L/lP9G7A6wZRkS/c/AY/QrsFg8vmjihh1J4gqPWI2xKQcFMfnkyDluF2/SeylQ39TPlekRg9FzJSoh80wm8gSO3n7bQumtxQFOzwaIbNHIc+ys1kr50y1P0Jet+Or1q3zJMl/aAfSMXqVxWyRzQ122R5DmKVvrYfyl3F/5AkCzUw7F6z6nJV+xAMPHHGQTMQbj/vCaTQSwv6dSH5zjYHds3rd9fZGAyQsckBKGz+maJ2hxdGyecNJkFl9T8DUCodylFkNP0YwyMfI19/2jIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BYAPR02MB4293.namprd02.prod.outlook.com (2603:10b6:a03:56::10)
 by BYAPR02MB4104.namprd02.prod.outlook.com (2603:10b6:a02:f1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Tue, 7 Apr
 2020 04:43:09 +0000
Received: from BYAPR02MB4293.namprd02.prod.outlook.com
 ([fe80::9128:c9f2:ce5d:ffb1]) by BYAPR02MB4293.namprd02.prod.outlook.com
 ([fe80::9128:c9f2:ce5d:ffb1%6]) with mapi id 15.20.2878.021; Tue, 7 Apr 2020
 04:43:09 +0000
From:   Suresh Gumpula <suresh.gumpula@nutanix.com>
To:     John Snow <jsnow@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ata driver loading hang on qemu/kvm intel
Thread-Topic: ata driver loading hang on qemu/kvm intel
Thread-Index: AQHWCtnRdUw08txLJ0GRwS5YdMwr1KhrwK+AgAAE5wCAAI65gIAATreA
Date:   Tue, 7 Apr 2020 04:43:09 +0000
Message-ID: <EFBCC9BF-F686-4631-A249-8CA9AB407285@nutanix.com>
References: <7C92AFF4-D479-4F80-8BED-6E9B226DFB72@nutanix.com>
 <56486177-b629-081e-2785-b6e2ca626e88@redhat.com>
 <D7D964C2-DD4B-4F17-BA3D-C45C992A4B15@nutanix.com>
 <b48ef18c-fb70-9d6f-c925-09227058a9cf@redhat.com>
In-Reply-To: <b48ef18c-fb70-9d6f-c925-09227058a9cf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:647:4502:bdd0:3d6b:3:57bc:29d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16b5982a-9bc6-4497-0b84-08d7daae2c30
x-ms-traffictypediagnostic: BYAPR02MB4104:
x-microsoft-antispam-prvs: <BYAPR02MB4104EC784F40BC66A167B4B497C30@BYAPR02MB4104.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 036614DD9C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB4293.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39850400004)(396003)(136003)(376002)(366004)(346002)(4744005)(6506007)(316002)(8936002)(2906002)(86362001)(71200400001)(81166006)(5660300002)(110136005)(53546011)(33656002)(36756003)(76116006)(66476007)(8676002)(66556008)(2616005)(64756008)(66446008)(6486002)(6512007)(186003)(81156014)(44832011)(66946007)(478600001);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: nutanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PLDGcn68rVmdE9e6XOWq2AlTrhQi3xvUyTjvSCQUWESvKCw90Q5+Uxlof1Nm8BWCXd6jzGrAbjCS+jmLMyPYteypfqroOO3Ky6xS4BCibq6/QBirBKo7a/wo6UcCG/+5ygZKps7W2uS/A7kZCvFYt9ESVcwbodyTdMX1vjk49hx/PDOoKKdH58bPLiloFGnKDytcAJeDSr2K+ZFYqEqZeOmXpZv3uSydUEdyR+GA+oLb91EfyrUVY2EAHlal8TujDE7RntwMeJ9ws0H+/ACoEepr7z3FoimNH07/nOTKvLGU/hTpgPmDnVePzAEYKAXOtfmwvcMof+cpw/a13cKsHRPp4mFDIrxJDwGr3CylXG3ft3IUzovuQabwQz17UNeg39O++WaNmdJu45RKIniOEzh9dIwVxSWiq91ED/uoYO2CIR4ExE5DZ1m38FpaP9gM
x-ms-exchange-antispam-messagedata: hTtKGbjB+OKojxJGPWmOKxrFO6KYTU7mGokuwHsG5zzV1zY8MVYtMT1uG18KAp48JJyQ+VofhI0pa5GfNjYGfD/CRFZyaelQVkTw1I+L+uGJ23PvT1oPMoL/djHqMZDjN9F4bZy+SX35Kr2a8pBtdI5h1EF0mscMSx1FkH5LNng47Ltfmein6GzNLKwmTkSay+Ppe37ApvYQELnR8QJepg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <758708EDD165C9469A4CCDC863B5AE4E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b5982a-9bc6-4497-0b84-08d7daae2c30
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2020 04:43:09.5645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iVZKzHaIQZ6N3UR2LLizRumNHvphFhW1eAMKz8E0ZCbI1xT5Jnq8931F4DBQY/tci5IuIH8vmzOdzcNP7djVaybKMTSPAWXfx9fWDKQqzm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4104
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_01:2020-04-07,2020-04-06 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

U3VyZS4gTGV0IG1lIHRyeSwgdGhlIGxhdGVyIHZlcnNpb24gdGhhbiAyLjEyLg0KDQpUaGFua3Mg
bXVjaCENClN1cmVzaA0KDQoNCu+7v09uIDQvNi8yMCwgMTA6MDEgQU0sICJKb2huIFNub3ciIDxq
c25vd0ByZWRoYXQuY29tPiB3cm90ZToNCg0KICAgIA0KICAgIA0KICAgIE9uIDQvNi8yMCAxMToz
MCBBTSwgU3VyZXNoIEd1bXB1bGEgd3JvdGU6DQogICAgPiBUaGUgZ3Vlc3Qga2VybmVsKG5vdCBh
IG5lc3RlZCBndWVzdCkgYm9vdCBpc28uIGkuZSBpdHMgcmVndWxhciBWTSBvbiBhIGhvc3QgaXMg
aGFuZ2luZyB3aXRoIGZvbGxvd2luZyBlcnJvcnMuDQogICAgPiBJdHMgY29uc2lzdGVudGx5IHJl
cHJvZHVjaWJsZSB3aXRoIHNvbWUgbG9hZCBvbiB0aGUgaG9zdC4NCiAgICANCiAgICBIaSwgSURF
IG1haW50YWluZXIgZnJvbSBRRU1VIC4uLiBpdCdzIHF1aXRlIGxpa2VseS4gRG8geW91IGhhdmUg
dGhlDQogICAgb3B0aW9uIG9mIHRyeWluZyBhIG1vZGVybiBRRU1VIHZlcnNpb24gdG8gc2VlIGlm
IGl0J3MgYSBidWcgd2UndmUNCiAgICBhbHJlYWR5IGZpeGVkPw0KICAgIA0KICAgIC0tanMNCiAg
ICANCiAgICANCg0K
