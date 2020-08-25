Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12ADC250CDE
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 02:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHYAVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 20:21:12 -0400
Received: from mail-dm6nam10on2061.outbound.protection.outlook.com ([40.107.93.61]:62305
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgHYAVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 20:21:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsB0wF/5p5RCHqM00ntNUsard77LX3wcL0lr7zNMKigj1JdiB+vyCOrQu3UC3F/guO796xGT7SiHmmvGWaocEGWyDch6fTdvn7F4B2pPQ2qH8KgPCw0dThbd6AaN/niPlorXENb46+Fy301d7J42nhKZsvB4BJFYpiZ8VKU/qAu+/mPj9QsabuPseBf65ncfbWZLPQtRLeTbqtdAP7JzD+s5Elg62WHm0qrZ32TXg0lT6DzeJ6g7iDqyDlr/nCTjm96xdKXxreZ9SO2xxEYBbttqbct36rDAQNWgwmAg7EdTjQzXknac+VjBqGQtEHmY8CAVD5nko7oLI+BmzJ7FzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKd+xzBX6SOhNTc6FWoyiZPNPpBPdTHQ46wlGczVaP0=;
 b=ghJNzLDk1o+9AU60dIKgQCDvo56MftPqgexTBlSKj7UI3Ze3VPs0yuhgr+IDJs0F4ikv6mn3ByXo0UHIJHSviXyAaYwmirH3iIssSg4HhWBN2FOPX6miEDrjAwu5d5sdxCp3xC3XuRMo6t8+7apF7JC+WvWWBN/TFdS/wUwi5amBU5VgmlNy40OCd7YAE6qmLWosepmSM7ep8l3hoPFS5BuAgvPA2Kr3aOf4UyDa0VxVC9fywUmv5Z/bvUvzkvEj/deaYVGAjUzJGvDRe3nbEUBFnBnh8Z7lwdHNn6RLq2uf83m1NzaprgatP0OJJt9VLFGUSiKljUPq7m4mlnHYgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKd+xzBX6SOhNTc6FWoyiZPNPpBPdTHQ46wlGczVaP0=;
 b=M73F78ebpjwJCUga8fn1qSYl++JUfgNshUK2y1kkWk/3vZWIbVsFyMmGpcSsQyjCOGeSjASTNrjQxCTBKYXM/LdWOivw/n3EoW7wRMxIsSgE8TuCjzztYvFv7PNm4k7jZ+ZXLPhn1xm98U0Hovx8ZgcUm+8UG7rhFp1g9pRyC1g=
Received: from BL0PR05MB7186.namprd05.prod.outlook.com (2603:10b6:208:1ca::14)
 by MN2PR05MB6461.namprd05.prod.outlook.com (2603:10b6:208:e4::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10; Tue, 25 Aug
 2020 00:21:04 +0000
Received: from BL0PR05MB7186.namprd05.prod.outlook.com
 ([fe80::7c79:760b:e61c:4826]) by BL0PR05MB7186.namprd05.prod.outlook.com
 ([fe80::7c79:760b:e61c:4826%6]) with mapi id 15.20.3326.018; Tue, 25 Aug 2020
 00:21:04 +0000
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
Subject: Re: [PATCH v6 00/76] x86: SEV-ES Guest Support
Thread-Topic: [PATCH v6 00/76] x86: SEV-ES Guest Support
Thread-Index: AQHWefRhA2tCcEBlS0C+PblTL56xV6lH91KA
Date:   Tue, 25 Aug 2020 00:21:03 +0000
Message-ID: <D0B35ACA-7220-45DD-B524-0AFD6BE7BA3D@vmware.com>
References: <20200824085511.7553-1-joro@8bytes.org>
In-Reply-To: <20200824085511.7553-1-joro@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:600:9e7f:eac1:b550:3534:3630:380]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abd5cf96-66d7-489e-9e2d-08d8488cc0e0
x-ms-traffictypediagnostic: MN2PR05MB6461:
x-microsoft-antispam-prvs: <MN2PR05MB646162F6D4A8E84E8203B4F6C8570@MN2PR05MB6461.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 12EuYNHOhySCb+wvOvUK8U2uQrKdBCnn+UihZwHD7KVDVEP0DHFUxaNuhe5kKnF2xqIkYa82cZnFSQ1SjNaWckBlOKLPfZleGlWOWz4GZjV/OmQceQ6w11afw7g5myBe4Up3oesppDKoepfV2jPgL6KANAA2rcAGSvguNhGH2e7waawUpAyNwehnojfmOhWWb57FKRb8zZ9b0O09r3kkt7jFtrnqgj8pI0PVVos+FZ6HY732jsUBrfD8jvJKg2NnlaApn4q2EMQX31MosuPzNaQ1/fBRN9xqIVP0uo76L820L23k/ye3uvH3uSxbLtAUa3kO11anGumasCnU/7nNlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB7186.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(54906003)(4744005)(186003)(5660300002)(86362001)(2616005)(478600001)(53546011)(33656002)(8676002)(6506007)(6916009)(6486002)(6512007)(64756008)(66476007)(7416002)(76116006)(91956017)(66446008)(71200400001)(316002)(66556008)(66946007)(8936002)(36756003)(2906002)(83380400001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YlaVypkiW1bQCfG1zVR44lhbl6HPSb5neMFIFhnyub5dR3KQ2rjRsbrJqZNhyyzh4qdeURqRM6XnEhLKiZrBQrGRXv9kzGTYCSz7ySAG2moBOik/ilCtfsEkZspq6ooTIWrMHGTlAiuoJ1fWQlTomShDWfM2kRE/SJL845mp07/a/y0r2Ehpy5FJZhfVqKBeXUUqG09+6wmvBU2MDNGI9ZNQcqJ48xXsUyygNBr9IBz129PLZ73pKqf0kBCB2AnHKP1KrcMWz2GQ1tpvbisZrVZULfebqHmxbznRUlLmt2h4XXn+ZTyjwDCVobZNGj75Qbr+JWcyJsp80pwguxejjz0hLPFaH7IZbQTU+jn/BtrMJ5+QqqobNSy6aDdb+RDi1wYxKNEoiwFTCUKKumlZBAQOlhfbM0Ei8Q6XxVtwntSkW+ff089qZXGdIFmmbdr5BaRmtHOvmSj7XYS/YONTcsDRrrPtoQDkkQadZ6oMAoimVi3GWvk0s+JlvmpEwBbLkltUE+cvwf6orlji54ovRu4xXajD9+tO3e3z7OBUV2AWfXm9KdlPTcoLZDqaCOyDv4jS37xvuwTaMoIoc6gVbSYZLAvJpKlzODzVWaIqiSqOR/bf4V/f5ReLqkvgpXaFhszMahizczOlNBxUBE7eusiw4LqHFCpYsoLrdwsQ5RPjWzlmcl/JPN3JbpCGpITmhCLdBWmUwoqDNP6+flu/7w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <00000448F682994D80F1FA721C9631FB@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB7186.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abd5cf96-66d7-489e-9e2d-08d8488cc0e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2020 00:21:03.8495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jJWNGS66h9UH/KQ/EZzec9G2yy2gHzmPtOWd4Q4egFyKTmvp9ijzn4wZfPYfMouQCJDYWE1JD6P20V+JFpiMqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6461
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgSm9lcmcsDQoNCj4gT24gQXVnIDI0LCAyMDIwLCBhdCAxOjUzIEFNLCBKb2VyZyBSb2VkZWwg
PGpvcm9AOGJ5dGVzLm9yZz4gd3JvdGU6DQo+IA0KPiBGcm9tOiBKb2VyZyBSb2VkZWwgPGpyb2Vk
ZWxAc3VzZS5kZT4NCj4gDQo+IEhpLA0KPiANCj4gaGVyZSBpcyB0aGUgbmV3IHZlcnNpb24gb2Yg
dGhlIFNFVi1FUyBjbGllbnQgZW5hYmxpbmcgcGF0Y2gtc2V0LiBJdCBpcw0KPiBiYXNlZCBvbiB0
aGUgbGF0ZXN0IHRpcC9tYXN0ZXIgYnJhbmNoIGFuZCBjb250YWlucyB0aGUgbmVjZXNzYXJ5DQo+
IGNoYW5nZXMuIEluIHBhcnRpY3VsYXIgdGhvc2UgYXI6DQo+IA0KPiAJLSBFbmFibGluZyBDUjQu
RlNHU0JBU0UgZWFybHkgb24gc3VwcG9ydGVkIHByb2Nlc3NvcnMgc28gdGhhdA0KPiAJICBlYXJs
eSAjVkMgZXhjZXB0aW9ucyBvbiBBUHMgY2FuIGJlIGhhbmRsZWQuDQoNClRoYW5rcyBmb3IgdGhl
IG5ldyB1cGRhdGUhIEkgc3RpbGwgc2VlIHRoZSBzYW1lIEZTR1NCQVNFIGJlaGF2aW9yIG9uIG91
ciBwbGF0Zm9ybS4NCg0KVGhhdCBpcywgQVBzIGNvbWUgdXAgb2ZmbGluZTsgbWFza2luZyBvdXQg
ZWl0aGVyIEZTR1NCQVNFIG9yIFJEUElEIGZyb20gdGhlDQpndWVzdCdzIENQVUlEIHJlc3VsdHMg
aW4gYWxsIENQVXMgb25saW5lLg0KDQpJcyB0aGF0IHN0aWxsIGV4cGVjdGVkIHdpdGggdGhpcyBw
YXRjaCBzZXQ/IChBcyB5b3UgbWVudGlvbmVkIGluIGFuIGVhcmxpZXIgcmVwbHksDQpJ4oCZbSB0
ZXN0aW5nIG9uIGEgUm9tZSBzeXN0ZW0uKQ0KDQpUaGFua3MhDQpNaWtl
