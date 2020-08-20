Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AFF24AC75
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 02:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHTA6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 20:58:19 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:41727
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726362AbgHTA6S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 20:58:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gT5Mf4lrgu8ztFetERwUSBQUNAwf53qv9zLmQ6XpFORSRm0WMhdUV+Qj846CXQtMs3bOOBC9BqY0WXwAWQZ54EZPFVy+RO5034T11dgC5JYaNiarLkBK6j8/glowD1hoZENkOuYF6vgQvJ4BmW735ggww0p0eeJhkMRJb6DWDuAoeNdjHx0qfcVZqJO9R+LxUJvY/z1/wXuS1qdEna3dirQKCQVZhce/9F6XJCLQB4RVhoJaB0qHkQB+du7eglaww2Q2TZuEWGsGZTakGT/foS6Sxx5ygMI9onSOpOAGNiZvoDOIQNJNUKJDqe4+nIMUVNvn6bKOV6aJPA3ED+gGGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qB4Gvxs2ekOMHSs4Q78o7/uZtse43SwLvsiZWG3g+1I=;
 b=GK1RJxbJb8VQ2H7yqT9cO14yAl2krOdUczi39ihfrk7ggymZ3DrTWraMOBEO++aV8KTDW/XXKPiFi41bTUsL3JneWwCfQWJ9jGv3O0qaWadWPsQigppHQmJF8jpE1fhqmvq/8DxaDlUJd/V2w0nfxi3dVQGETfLCKoOlATGM1RECr76BBVFnbP5B6/7Ad2EFWWbn1CJKgo+/TP6wyGNHFhRzry91KtpIJmLYFrCOB5coKJRqtR87rupdDE46eM6TDxHHrMzzismwNEAXwZUNYUxWu7B2LFjE6rdsz4NqJAmriI4az02xUKJHMJyqUWPBthga4Hcn5ubT3AB4RITK6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qB4Gvxs2ekOMHSs4Q78o7/uZtse43SwLvsiZWG3g+1I=;
 b=cKDYxejtCxMUoR/JPlnEHqBo4F89zEW5opTWZDiNMjetHjAAo/l9+nbUgO3GB+hxXqwCNceWJ+rSzUHKqcmta0T7Iye3E9oc1QHzXGRu17FlRS9FheXSlsQyki2rricaxX8obYSiUFBhysAlnwarmHA7vT2Vg22xvfSd/nfHT7o=
Received: from BY5PR05MB7191.namprd05.prod.outlook.com (2603:10b6:a03:1d9::14)
 by BYAPR05MB4968.namprd05.prod.outlook.com (2603:10b6:a03:9c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.17; Thu, 20 Aug
 2020 00:58:13 +0000
Received: from BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::8c61:2805:f039:b511]) by BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::8c61:2805:f039:b511%8]) with mapi id 15.20.3305.023; Thu, 20 Aug 2020
 00:58:13 +0000
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
Thread-Index: AQHWYdQMsnCBwIAXv0SX/F24aOvyxqkfXZuAgAC4HICAALeWgIAdUbMAgAI3S4A=
Date:   Thu, 20 Aug 2020 00:58:13 +0000
Message-ID: <6F9275F4-D5A4-4D30-8729-A57989568CA7@vmware.com>
References: <20200724160336.5435-1-joro@8bytes.org>
 <B65392F4-FD42-4AA3-8AA8-6C0C0D1FF007@vmware.com>
 <20200730122645.GA3257@8bytes.org>
 <F5603CBB-31FB-4EE8-B67A-A1F2DBEE28D8@vmware.com>
 <20200818150746.GA3319@8bytes.org>
In-Reply-To: <20200818150746.GA3319@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:600:9e7f:eac1:5987:639b:294e:d744]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63464a6d-1b90-4794-6353-08d844a41d92
x-ms-traffictypediagnostic: BYAPR05MB4968:
x-microsoft-antispam-prvs: <BYAPR05MB4968BBBF8EB9E9BCB192D06EC85A0@BYAPR05MB4968.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BUSAzkb4TbHrcSdmFlpuWxRWpALFoJjMUvt6J1gMEAOAkP8IHDZgMsWvO34G5O2zzqNYVjGJB6EkIXVz2mP8n5ehxlJb4HDjzh9XrffG2XI2qAG6LNNVpGUJF0//mZK40HrYGlokAiWGFhLps+VlePzQByXwtwR1O3R8FqwwWTOrDemzulF1aPtVHdHQXylzko5ZqVRQEse09dsrhEYfXgBxVcAszkZNxpQlhQbt/UTrLbN+ydWLi/W1gZ7aLeltSW5gmr7+OH75JW+QGMsmmOk22Ou57Gi223O6t5f2I3ey106uEBoneo+zB4RD93XinDGRpIcBv4q5ScWQH+pj5/7No5XnmTASF/QGsDeusoEMaWqNbme2BIniRIatCiqWgBkh+xy8fm3odezmlDp3Xw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR05MB7191.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(5660300002)(66446008)(66476007)(66946007)(66556008)(8676002)(64756008)(4744005)(76116006)(86362001)(966005)(53546011)(2616005)(316002)(186003)(71200400001)(2906002)(6916009)(4326008)(36756003)(6512007)(45080400002)(478600001)(6506007)(54906003)(8936002)(6486002)(7416002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: rhIRUr7HJAZbCvOz5n07kmjWnTADQq9/ojBZIQ1bJlCKdDa3YAcFtL93HQS6bln7f7nsn9GhUvWvVoZhHFXmWtuNUSaAum3vODbk9xM4OL9ESiL7MDikgIj+NS34FXdQ7q8wsNG+gA3+IESExjLBxWKueKwizQmIbMNYRAUTPa83weNSPq5H9Hocr+udeXcM/4fINXD1PhYf6hhJKfBGmzleKDxLU1gWibl6gT5M3OgIJiElgG660UIbedLq4mZsG3NLPQ2XiONhlD/KkGBUn7ibw63eDQHSEEBPiUAgXZU5d9j7N3891Qd27QIauPnjjUQpNZCs7+iJ3ETxVEpITRJErYIk7f8w/b4lkScPNRw62bHUKKX6iMPnnBQ+v7ECzlQaOraIEG4KeK27yp3nY6qAieL4Fi5JC3H8/jwRqfOeDUUG7SLf79lascNh+q4H++HocrqZnt/yyPXF75BM20W5d1nDklWMgzQqwc+AQl0Ewx7QFMHdEZB6z+2fCCleQ+iroQKOAuFyTqxeD4XLnCv9pPUuOGBM6jaoxDv8PNQfqFLMblEOS77Sd0BIboLmNEOgW6PFI5yHDjxSnS87R4VXbKG9UDVirLtRpxND0/6x+BspafCEJaOsMIkPx6NFYRlTtQhQmvGavvlIYxhuQZk713VxmygH19B/vd16XXacwqXO+AaYQtif/5LQS1ThEJooHbZKZI9VnDIJRP3TCA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <66EEDEA3E2BFF249AC116C3A22162711@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR05MB7191.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63464a6d-1b90-4794-6353-08d844a41d92
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2020 00:58:13.2949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u7zemQLtlBWa53RU12pTAZcd1DuPuhotqVlv42x0kDl9E3Ygzg5wmcgHISIG0/5RFgDvxNLylbWEDwcRstgzBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4968
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgSm9lcmcsDQoNCj4gT24gQXVnIDE4LCAyMDIwLCBhdCA4OjA3IEFNLCBKb2VyZyBSb2VkZWwg
PGpvcm9AOGJ5dGVzLm9yZz4gd3JvdGU6DQo+IA0KPiBDYW4geW91IHBsZWFzZSB0ZXN0IHdoZXRo
ZXINCj4gDQo+IAlodHRwczovL25hbTA0LnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29t
Lz91cmw9aHR0cHMlM0ElMkYlMkZnaXQua2VybmVsLm9yZyUyRnB1YiUyRnNjbSUyRmxpbnV4JTJG
a2VybmVsJTJGZ2l0JTJGam9ybyUyRmxpbnV4LmdpdCUyRmxvZyUyRiUzRmglM0RzZXYtZXMtY2xp
ZW50LXRpcC01LjkmYW1wO2RhdGE9MDIlN0MwMSU3Q21zdHVuZXMlNDB2bXdhcmUuY29tJTdDNzE1
ZTllNjQzM2JjNDQ5ZDM0ZWUwOGQ4NDM4ODc4ZWIlN0NiMzkxMzhjYTNjZWU0YjRhYTRkNmNkODNk
OWRkNjJmMCU3QzAlN0MwJTdDNjM3MzMzNjAwNzE2OTE4NDYzJmFtcDtzZGF0YT1ldGxhN1NHZzRI
bW1KcWhKNEFJdWwwNDNWRE5WdmxsbG5idGZkYzBaJTJCQ1UlM0QmYW1wO3Jlc2VydmVkPTANCj4g
DQo+IHN0aWxsIHRyaWdnZXJzIHRoaXMgaXNzdWUgb24geW91ciBzaWRlPw0KDQpZZXMsIEkgc3Rp
bGwgc2VlIHRoZSBpc3N1ZSDigJQgQVBzIGFyZSBvZmZsaW5lIGFmdGVyIGJvb3QuIEnigJlsbCBz
cGVuZCBzb21lIHRpbWUgc2VlaW5nIGlmIEkgY2FuIGZpZ3VyZSBvdXQgd2hhdCB0aGUgcHJvYmxl
bSBpcy4gVGhhbmtzIQ0KDQpNaWtl
