Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF6B232985
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 03:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgG3B1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 21:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgG3B1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 21:27:52 -0400
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (mail-co1nam04on0608.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe4d::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5E7C061794;
        Wed, 29 Jul 2020 18:27:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/2zz/tD+N2zdClQuxTZfdlhG+0OYpPmTf70AJk7JaUOBpRjAt8w4p89Yr1Rfz0LO6zbbUWg5wuQWgS+EscaQAZWJNkKrWgU/P2G8tn3wSuVGo4OCBf81qaYakXOm/+5z2vQiOOa14FzzEAAGG+A5yEgfxzSHakJhdLrtqxx/1P9QeKKRJOnKBAlRj4GJ85Til5wJWNXRQhDVoEuoddj455S4XFliSZ53C94k3TlcGQv2iVtEASQtchgf4qlv5tWCUKWHwlULVnFE07ycjJkc1H0Ms9GUdRqcEW2Xrx/6CxLk8V0YvB2EFaJxBgFuif+9ycY4wakz3xp0ff1jQun2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FY9urDxZEPkBEGifrGZgd9rDpxIIqaBlpfqrZQR+/ps=;
 b=RCDE+MOjYw+G1h9lNrYiv1m5u0JKz0vlK5/bSgNOtQJ5JEQUWE67BTbgUNcHrWkFljsBOby7W8fJCL45CU6FhgSkD74/evVqLy/XpnRfM5nd5bjOVn1R/lQuo4B8ArwqJ2OZkVrnp/38Uz7hkABL9/dF5sapT9NCHBV0MdKJAHwns2zGTtDdbwxjnuP7sYnPRpHR9LAuYpP6XJ+PhenlRaBQuRotCeHV4zmWWRLZfhdWeoPXh78Me2CS5LGGhHrGz8oHfMIK08QFZpEO+s2T02P7iQhmBxJ6CbXzwsNEbMx9rlL8uYdaI00ICajh0SW2+2UHfaNvAorqwaUorvtaPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FY9urDxZEPkBEGifrGZgd9rDpxIIqaBlpfqrZQR+/ps=;
 b=RSGrhsL+b/bPICtRujuO79q6OJn50kNRcQrjaVcO0admlT+GouVHhcVG9d3CN6yUGdWZE7HjfNIdm0LevoalmwRmigQH0BvdifdKffOq8uV1OXpTdUJRJgzjQ0/2vJVSOnwHt1ps+a4PoANJXmaeL2W1pa8657fcSrHFbarLQfw=
Received: from BY5PR05MB7191.namprd05.prod.outlook.com (2603:10b6:a03:1d9::14)
 by SJ0PR05MB7280.namprd05.prod.outlook.com (2603:10b6:a03:288::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9; Thu, 30 Jul
 2020 01:27:49 +0000
Received: from BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::7d2f:b4c0:5bd9:f6af]) by BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::7d2f:b4c0:5bd9:f6af%9]) with mapi id 15.20.3239.018; Thu, 30 Jul 2020
 01:27:49 +0000
From:   Mike Stunes <mstunes@vmware.com>
To:     Joerg Roedel <joro@8bytes.org>
CC:     "x86@kernel.org" <x86@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v5 00/75] x86: SEV-ES Guest Support
Thread-Topic: [PATCH v5 00/75] x86: SEV-ES Guest Support
Thread-Index: AQHWYdQMsnCBwIAXv0SX/F24aOvyxqkfXZuA
Date:   Thu, 30 Jul 2020 01:27:48 +0000
Message-ID: <B65392F4-FD42-4AA3-8AA8-6C0C0D1FF007@vmware.com>
References: <20200724160336.5435-1-joro@8bytes.org>
In-Reply-To: <20200724160336.5435-1-joro@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:600:9e7f:eac1:21a1:5a0:da53:d63e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c9e819b-608a-4f51-c72f-08d83427c540
x-ms-traffictypediagnostic: SJ0PR05MB7280:
x-microsoft-antispam-prvs: <SJ0PR05MB728092D2A62234E5B8259837C8710@SJ0PR05MB7280.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Za47x9ckP5i4amtlyaaNrTv45actS2jmXbocq1QmOHViSHyz8fteKPUQURD3zZgTQ4BCsGY9LudkPH8CTC1aQULwqj9jw2uzh5uMo2U/UPrWCr3GrdzEGEZxoJQ9ce20MOMmeGQ4u3hAhPhOnRkwdrHuIDoBwaToGXzBH1nhZgUuTHcRbw02PkyqcnsTkepQP1qymSGsnAxsArtLbopaSbS+DImWieFaDfePr+DTO72tYlB40Do7H2PRF499knU76Xwd0d8jLVWMZ719um9GosaH/8LgGD+howiyQIlVQcY95ybEPmDmYIHFco/Frh2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR05MB7191.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(4744005)(64756008)(6512007)(36756003)(66556008)(66476007)(66446008)(83380400001)(478600001)(316002)(76116006)(2616005)(2906002)(7416002)(66946007)(5660300002)(86362001)(53546011)(6506007)(8936002)(71200400001)(186003)(4326008)(6916009)(6486002)(33656002)(54906003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /2C99xzWeF/KU9StAZywfFM1iFjff2Gg9yMD0zgouSFQ2EDyGsvmPkXKwG8Tt2sJ5WKawOUR54IzbOtd3uRKFwRtfbCHQMMt8wHelKIjC+e10LbGWjoVeh/vefFCSoKywm6aaVgIp9WibUMoLgJlCz/8xNyBYA+TINceDvI43H+h5r2p6+BsjBXdvR/mDwXMKJGkRnQktfH1FcmyB+wQgNjKi1xeEcCf8p4yBtaGME4Eq8JVgabui8pAUK1VXrfD6NGDu7porChXESwf+xdMFmt7ZYIXsGN+VMdhCPRUWgYBECJmuuZ+q8VsjoufItCyskvQ7EC/FNV2sIHMYuFemhwos6LCu5DYZHAn+4KLNw8Z1yUdCyrcR6JKAxPZKhFQd/jp9jJI7ar5MA75DnOzxHHAKmOb4idl99Xe9ePeKIy3I5axfOzDY9Ny1vYCChyfzf4IChiL3kkV08Lrhtofiju272MZ5WPWBlX8EoDhP1RG8WwqRakBR4WvWmLHT2aw2wMqidibl80XDwP45vuB/cpAUz+H3qbnPHhYpHH6I7Ieytls3C7HwFqeE1ySJ4njLD1Oev/xqjTVMy+GqcLVi8E9kmheZhVD8vJ3mUIQXFTu51fGIMQ6D525ridco8pHkAGLYXA+FeMUWfSvGiVdrmmV3DUcAEuyMwDqkj+rG97UdjqlmNwcdmy0TVl2efvd4vvDV7BO1dgOfnt30l8cbQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D0CF3C099AEF64099DB28E05D9218F9@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR05MB7191.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9e819b-608a-4f51-c72f-08d83427c540
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 01:27:48.7215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l9PYQ3s2UDKScP7L4LI0A5d5ziYkxp5eZfgK003NlXttufywRKYF0fCpMO1758n48/SNmrxxJKkBvXe1i5kq/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7280
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgSm9lcmcsDQoNCj4gT24gSnVsIDI0LCAyMDIwLCBhdCA5OjAyIEFNLCBKb2VyZyBSb2VkZWwg
PGpvcm9AOGJ5dGVzLm9yZz4gd3JvdGU6DQo+IA0KPiBGcm9tOiBKb2VyZyBSb2VkZWwgPGpyb2Vk
ZWxAc3VzZS5kZT4NCj4gDQo+IEhpLA0KPiANCj4gaGVyZSBpcyBhIHJlYmFzZWQgdmVyc2lvbiBv
ZiB0aGUgbGF0ZXN0IFNFVi1FUyBwYXRjaGVzLiBUaGV5IGFyZSBub3cNCj4gYmFzZWQgb24gbGF0
ZXN0IHRpcC9tYXN0ZXIgaW5zdGVhZCBvZiB1cHN0cmVhbSBMaW51eCBhbmQgaW5jbHVkZSB0aGUN
Cj4gbmVjZXNzYXJ5IGNoYW5nZXMuDQoNClRoYW5rcyBmb3IgdGhlIHVwZGF0ZWQgcGF0Y2hlcyEg
SSBhcHBsaWVkIHRoaXMgcGF0Y2gtc2V0IG9udG8gY29tbWl0DQowMTYzNGYyYmQ0MmUgKCJNZXJn
ZSBicmFuY2ggJ3g4Ni91cmdlbnTigJnigJ0pIGZyb20geW91ciB0cmVlLiBJdCBib290cywNCmJ1
dCBDUFUgMSAob24gYSB0d28tQ1BVIFZNKSBpcyBvZmZsaW5lIGF0IGJvb3QsIGFuZCBgY2hjcHUg
LWUgMWAgcmV0dXJuczoNCg0KY2hjcHU6IENQVSAxIGVuYWJsZSBmYWlsZWQ6IElucHV0L291dHB1
dCBlcnJvcg0KDQp3aXRoIG5vdGhpbmcgaW4gZG1lc2cgdG8gaW5kaWNhdGUgd2h5IGl0IGZhaWxl
ZC4gVGhlIGZpcnN0IHRoaW5nIEkgdGhvdWdodA0Kb2Ygd2FzIGFueXRoaW5nIHJlbGF0aW5nIHRv
IHRoZSBBUCBqdW1wIHRhYmxlLCBidXQgSSBoYXZlbuKAmXQgY2hhbmdlZA0KYW55dGhpbmcgdGhl
cmUgb24gdGhlIGh5cGVydmlzb3Igc2lkZS4gTGV0IG1lIGtub3cgd2hhdCBvdGhlciBkYXRhIEkg
Y2FuDQpwcm92aWRlIGZvciB5b3UuDQoNCk1pa2U=
