Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4232224DEC2
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 19:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgHURmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 13:42:23 -0400
Received: from mail-bn8nam12on2073.outbound.protection.outlook.com ([40.107.237.73]:19552
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbgHURmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 13:42:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSZHh6nOO6R8JNhzVzrsDqUSfi412Ke1+dI3vBmGejhcorKZMXZHt0pISu/ndDUf+R1oEYI810CdwsETIKNfTlJbS+RgVa3T3uLXWTd/DUH1Frr7/DtB1kNKWmuftxslwdgQ622Gq0qCmGK9Y+DmiV5iaG3bsgq15E86q6M8EC2UMKubAOf1UdD86QAQWC/3TjHBKH/6UepgfsJaMzsUQcmjVo98BD0tHeJHWNoEfSWN1ClqXr4lGM/sSlM28Glz6ORpLdP5/RPZSaFRLkNBWmx5hFejpcGlBk9uEzOC3MqC9sWEuN7gZGstnA/hqqaO8EU6wVFYtu+7x4Kd5nvtPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5o8x6LyGirEqMQWA+35H1KQMYBPizOJSBXSppOd/Hg=;
 b=DVUjgPhGOgcyaS/4SdRGldWkJ/9vAyA3A1Rc42yYxsHsaQ854YVAIp9iwIrXg9nzjnvG8oVqE2dmjHfKJXaGp7C/kcyeA3TDa1fqzWx/GujgqTFlwzrEzU+k4PlytypPrBqrpmQQC7wf5WQ5nY+QIDmH5z1oL+CMOCYOvx1MkI5mpyBUr7ev+X9w6N+nZ4tmasFB5KvM5E9w2SJGuQMN713tgRZzBg6FzI8yxbLNowewul4XfOh2+fPSmivW4iEF+jZIRUWaDi2HS/ngM+x81WpUhgr50waNGvGPtynOVJQ42HCaX3N5T8dKIli+3drt7+xJLd7VODLPwmUnD/Si0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5o8x6LyGirEqMQWA+35H1KQMYBPizOJSBXSppOd/Hg=;
 b=1npGaiwBdoTSXvYjtMsH7mvRuVQoXn0i926mE/XIghCz8ES+GSYkjTOAcWXCdRqrLvx0pP0GmlZ3yIQKqUSZClNkCTBqVjWdApNZY2Y3VA7G/eFa8AQa9TARpp4zk3HiVIwC3soda/soaV3sbt0IIMM+Y3D8HunvwDi6YHJQo6M=
Received: from BY5PR05MB7191.namprd05.prod.outlook.com (2603:10b6:a03:1d9::14)
 by BYAPR05MB6517.namprd05.prod.outlook.com (2603:10b6:a03:e8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10; Fri, 21 Aug
 2020 17:42:16 +0000
Received: from BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::8c61:2805:f039:b511]) by BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::8c61:2805:f039:b511%8]) with mapi id 15.20.3305.023; Fri, 21 Aug 2020
 17:42:16 +0000
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
Thread-Index: AQHWYdQMsnCBwIAXv0SX/F24aOvyxqkfXZuAgAC4HICAALeWgIAdUbMAgAI3S4CAAgm6gIAAoSOA
Date:   Fri, 21 Aug 2020 17:42:16 +0000
Message-ID: <84EC8E16-5ACD-421D-9B3A-1C80985A1A0B@vmware.com>
References: <20200724160336.5435-1-joro@8bytes.org>
 <B65392F4-FD42-4AA3-8AA8-6C0C0D1FF007@vmware.com>
 <20200730122645.GA3257@8bytes.org>
 <F5603CBB-31FB-4EE8-B67A-A1F2DBEE28D8@vmware.com>
 <20200818150746.GA3319@8bytes.org>
 <6F9275F4-D5A4-4D30-8729-A57989568CA7@vmware.com>
 <20200821080531.GC3319@8bytes.org>
In-Reply-To: <20200821080531.GC3319@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:600:9e7f:eac1:78ee:bdb2:3750:e793]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18ab1556-92ef-4fea-05f1-08d845f98b8b
x-ms-traffictypediagnostic: BYAPR05MB6517:
x-microsoft-antispam-prvs: <BYAPR05MB6517F77D2C39CFB79120C8FCC85B0@BYAPR05MB6517.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CumJK+QIsYKlWJ0Yp5q1+TRTsNwERH/d24H7M+gF6eDR/dSIAWV9unpXoHG5pbEUXhpTST3dp209V7ZGuiX3SNQuWQJ2DhKruuDehpVl0kYopTJbfjPP2FYpwQfCEBrrO0AMu6Lfw3ytIT1cdnyDBjY02MBb0VBwmcxopp8svWsKwjI8JqiIM3NHGCcKkD6+SKKfX18Dgp9G+AjdUNnmA+xV1/8ngrKjZx7VYjivf2sqP/Q4o69G6bj/g5ATo30NCbwKHfp761ArGuPIRYUgvfUV9rFkpqlRo1iGblqSc8mTYLdzlXF5r7Zc1o8cDPRQnr2NF2b/l9B/E/N21JmkaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR05MB7191.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(33656002)(36756003)(6512007)(86362001)(8676002)(6486002)(2616005)(4744005)(2906002)(6916009)(478600001)(4326008)(64756008)(76116006)(316002)(7416002)(54906003)(66556008)(66446008)(66476007)(71200400001)(5660300002)(53546011)(6506007)(8936002)(66946007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: elTqrYHvgsdWwpZamXrIJpIgShWya/xIcotnsvdNLqlUfJ/gNrw4yEUWhacMKBmmDRicOJ1Bsir9OmT9cF2Sr58xbl5pbPTq2oERyqEIs+J9EWuaBXf8x0DOy+qCUbNUYx4HBdIhAz7eWbOW1RDlQ2u/bGfpfS9wZWYgYcH3pG67PMZ7cEKRrT9LpeEN3zbnNkU7JdAgQ7CgqzCTIZpqVArLGfm0h0xNbAnQQ40TyCdIVJnEtyVBlU6o6M+DgkTFg73SfujXloQLbsVHsl3CXnYz5e+lpTDqtRsH8c+ju8ZFejrh5rAuquRkPGGN3GOU5JwVuIdfNgx5d5tHOfoG3oHAYLGZRjtTrgwNIFpOE4QoyvFdXa7tz+nKJUO36gOk3E0QZoD7qglFX39M6kbs4ZJvTaSIzqJz1DwY2v2dXo6NhV0q+laM6CGW+moGRZf5WMfOv4+yQpmoeXue9epBeKPtjAUsIuzNDJcgNng1Ivi7+3dBv80RLA2vfLucQ67cjmd0tsOMsuq+ZsajGMtDa8PjmwkCPR091+iTSaarOTYrO0z2ca8iuzBTZ56qsEGAofjPXVoe5VpR4nj9s9060/o8/5D1FzLh50PpEqG5Z8+v8IxSjBRz+2qfS2eFi0drCN4SmqCnD0M58ij37RYPk4yXZdR0EBPg2sJag5X2xKlsh6jBTuxuLGPabUfFoImpJUjMrKB9V7AXPxRsgUuUxQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <623FFB87922255429A97E892C247FA28@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR05MB7191.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ab1556-92ef-4fea-05f1-08d845f98b8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2020 17:42:16.0972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EBwAnQgXMVh4nsEQIsWe+rmhEM/txZpGnZv7TX6Dx33ieQabux6L5ZMwaIsOI08LlPJwVhTuiy/qAqaE/Fg6Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6517
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgSm9lcmcsDQoNCj4gT24gQXVnIDIxLCAyMDIwLCBhdCAxOjA1IEFNLCBKb2VyZyBSb2VkZWwg
PGpvcm9AOGJ5dGVzLm9yZz4gd3JvdGU6DQo+IA0KPiBUb20gYW5kIGEgZmV3IG90aGVycyBkZWJ1
Z2dlZCBhbm90aGVyIEZTR1NCQVNFIGlzc3VlIHllc3RlcmRheSwgd2hpY2ggSQ0KPiB0aGluayBt
aWdodCBhbHNvIGJlIHRoZSBjYXVzZSBmb3IgdGhlIEFQIHN0YXJ0dXAgcHJvYmxlbXMgeW91IGFy
ZQ0KPiBzZWVpbmcgKGlmIHlvdSB0ZXN0IG9uIFJvbWUpLg0KPiANCj4gQ2FuIHlvdSB0cnkgdG8g
ZGlzYWJsZSBzdXBwb3J0IGZvciBSRFBJRCBpbiB0aGUgZ3Vlc3QsIGJ1dCBrZWVwIGZzZ3NiYXNl
DQo+IGVuYWJsZWQ/DQoNClllcywgdGhhdCBmaXhlcyB0aGUgcHJvYmxlbSDigJQgSSBjYW4gc2Vl
IGJvdGggQ1BVcyBydW5uaW5nIG5vdy4gVGhhbmtzIQ0KDQpNaWtlDQoNCg==
