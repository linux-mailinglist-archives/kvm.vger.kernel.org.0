Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207A4233C19
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 01:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbgG3XXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 19:23:55 -0400
Received: from mail-dm6nam10on2040.outbound.protection.outlook.com ([40.107.93.40]:62528
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729896AbgG3XXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 19:23:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X21h6IAuyt9A3ZA23QfnueLu2nQEc8y3t0QKZKzxWzTRfGVqSvv/1aN86jMnymJVxACgiZdkcOlEpGz630PLSRBTu3+C1qWtkGAgUOvYscX7V4Rz3YV8Xb5YVP0FACHwrCJOr4jEYRZooYYbb+rYytZFQ6L6A0JeVfwsHZvPPt+MQtG+DiVrJR9+MSYN29FhukenVbpb6MGGBnGxrYOdkwve3RMi99iPAjdwy4a43LsGZREzWjnmZRm2t2QDjeALPl2tt3we2YgD+NfhZkLnrZhM2324OMFJDnlBCcOsj1/DBg2h0zMChWcQndN673CExHMHNyFJAWbi1rU5aSl96g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sq43j3wqZ4ECnGfaxDy46jxh/VV3SpweV5lxmlSqh9Q=;
 b=odango641HgSkMa4qLLlQEMVM76tF56fU0WqSmyXDG8bxyRlcj9ltch7ch12SGmTOvWhYN6Nh9Mhq85CO/L5NzA8Np0wUHrDjzwK5tkhHxoW7/yZP3xaruuA4gkTjQF2Xobqn8R7/01Qa1/TcTRlPOf0ZuNaEk+WmkHnElb/XQoUD3bnFE6ZhdB2iXZdbjMFv62KGLhBnbD/KHbPLYtaCsdSS7tb4SLUNvYCRGUw6djoOAdNMuV6R8elzmJQ4in9hQV9teSATkcCYH8/HcsO8v7UYF3C/rXHIQJVBbXozAP3T8V3pTYM63SFEqRjqvUpO9uM/aKW+SbIfEGHAQf5MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sq43j3wqZ4ECnGfaxDy46jxh/VV3SpweV5lxmlSqh9Q=;
 b=CwyVquJaZ1v6cv09md70/++qAhptHGxz8bbHemqnOEWqoK+XsjFoeuqwjSuEgc/km9YsRNmAFZ8Je/iXg+H/2/xJhax/W8+qP1isfJrTgWmTnGhdnvF7z7ydn5w1IrUCspKwsQAXq3LsffWVxckuS1vbwUkzLV32CHDwiC+Qdb0=
Received: from BY5PR05MB7191.namprd05.prod.outlook.com (2603:10b6:a03:1d9::14)
 by BYAPR05MB4072.namprd05.prod.outlook.com (2603:10b6:a02:8f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9; Thu, 30 Jul
 2020 23:23:51 +0000
Received: from BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::7d2f:b4c0:5bd9:f6af]) by BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::7d2f:b4c0:5bd9:f6af%9]) with mapi id 15.20.3239.018; Thu, 30 Jul 2020
 23:23:51 +0000
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
Thread-Index: AQHWYdQMsnCBwIAXv0SX/F24aOvyxqkfXZuAgAC4HICAALeWgA==
Date:   Thu, 30 Jul 2020 23:23:50 +0000
Message-ID: <F5603CBB-31FB-4EE8-B67A-A1F2DBEE28D8@vmware.com>
References: <20200724160336.5435-1-joro@8bytes.org>
 <B65392F4-FD42-4AA3-8AA8-6C0C0D1FF007@vmware.com>
 <20200730122645.GA3257@8bytes.org>
In-Reply-To: <20200730122645.GA3257@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:600:9e7f:eac1:a1fc:dc3f:7ae6:f7af]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0a18b2d-b790-4be7-87bb-08d834df9e69
x-ms-traffictypediagnostic: BYAPR05MB4072:
x-microsoft-antispam-prvs: <BYAPR05MB4072EDC13B1A906652AEE16AC8710@BYAPR05MB4072.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e/zGsRaBVfKASbrhM8xwDNQ/xiFq+wS/AqSiqlY1b7+zQgeCfgYYV9YNs2tHPOHelKiVJP7ptnDkxmf50ykbYbN8i4tohc+UEWnpQpp4Wct03TzdISmBcoRjJUsKfn7/Ya/dJoa+u29je5sskbcPPsAwad2f39pnbYm4D2yr0K32RYi01yUqC4sWe109KcUKwSu1ybIxU+8leYoVYR6Un8g/FVK7ymaWKgsDnHbD4I+wMp9y8q62Uq/DR0NaJKRmB80uGH0ooXl/kguLQbU2mDa2jD053Z2s2Ai80Cr+ST8V+3mdfIl6dLipV+JrAzO2915SZ11EK3ts0cXa8fMyRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR05MB7191.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(6506007)(478600001)(2616005)(5660300002)(53546011)(33656002)(36756003)(186003)(8936002)(6486002)(6916009)(4326008)(8676002)(66476007)(71200400001)(316002)(2906002)(66556008)(54906003)(83380400001)(86362001)(66946007)(64756008)(66446008)(76116006)(7416002)(6512007)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QckdBubKc+XmnBd18s6P2nfirRDQKD0pUCqT1RiFykvZ24E/cqTle59yENU9Y4ze0INdSz9rnQjw27PFZhcRpwZJuhV8n1roG53QPgkqgqtdi5hMUcl1JGmzsMvBxHktzBnI9WUomUiPJDP7L0CPbPEEqeDLPjJJdoqqNYqIKNqLIUW3G4QqsOdVdrFItLD2gDkZm697YSigiyY4JE/7YXZNqrO9Lhy5SImmhJcSs6WXd/0ohacgyv02IOBjO6+5YQ6Pr0nHNULKg7bTqI1n+ErGRB0etI7iIpQ9VxlUZmAg04XZ5aYtQ2ViA/N5t6udh6lJXnBHS5rbIwadVRR3OyW1Y+PsNE4cnsg+nUGpvKHWF0WpPJU4HaS7eNsF0xLurPW9qEfd0fVzj32Xe4ZI6c6vNf3Vre22pwx+SnZJN8leOLGHEV7FNWvicDPLNUFXOanKiRyCyws2Vuq85NtQopqopSRiwmazm/SnsEiL2mx+VBnKmfO6bxlVlx73/0mziYKtBFOyoVPnfs/Owr0N5p8W5gFNArMJ7DcLrrFrsb026aJtRkHCxFNwtZCCS98X+ZXMTbYjdfRXJ7dR5D+ePu22Au/fctXCLrlbi/m1Xos/YcD/W94ZDqzap0K+XqTr/N7Gi73kINk/O9XjEvQvjnOeFYmGjMc4wVA6W4MydxxDiOMZpL811nR/rpB9Y39Dhyml3AxxIChMexzpb6rakg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B511F6DFDFCED24FA7FF71ACBD10F11C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR05MB7191.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a18b2d-b790-4be7-87bb-08d834df9e69
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 23:23:50.9995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xxy9TBfoYvq36K67L27u00vMvVP3F+q2k8eQ4UOYO4YYminrbuXjwW7551zG7nvWmG8a5OY0ASVvSrp/gIL3VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgSm9lcmcsDQoNCj4gT24gSnVsIDMwLCAyMDIwLCBhdCA1OjI2IEFNLCBKb2VyZyBSb2VkZWwg
PGpvcm9AOGJ5dGVzLm9yZz4gd3JvdGU6DQo+IA0KPiBIaSBNaWtlLA0KPiANCj4gT24gVGh1LCBK
dWwgMzAsIDIwMjAgYXQgMDE6Mjc6NDhBTSArMDAwMCwgTWlrZSBTdHVuZXMgd3JvdGU6DQo+PiBU
aGFua3MgZm9yIHRoZSB1cGRhdGVkIHBhdGNoZXMhIEkgYXBwbGllZCB0aGlzIHBhdGNoLXNldCBv
bnRvIGNvbW1pdA0KPj4gMDE2MzRmMmJkNDJlICgiTWVyZ2UgYnJhbmNoICd4ODYvdXJnZW504oCZ
4oCdKSBmcm9tIHlvdXIgdHJlZS4gSXQgYm9vdHMsDQo+PiBidXQgQ1BVIDEgKG9uIGEgdHdvLUNQ
VSBWTSkgaXMgb2ZmbGluZSBhdCBib290LCBhbmQgYGNoY3B1IC1lIDFgIHJldHVybnM6DQo+PiAN
Cj4+IGNoY3B1OiBDUFUgMSBlbmFibGUgZmFpbGVkOiBJbnB1dC9vdXRwdXQgZXJyb3INCj4+IA0K
Pj4gd2l0aCBub3RoaW5nIGluIGRtZXNnIHRvIGluZGljYXRlIHdoeSBpdCBmYWlsZWQuIFRoZSBm
aXJzdCB0aGluZyBJIHRob3VnaHQNCj4+IG9mIHdhcyBhbnl0aGluZyByZWxhdGluZyB0byB0aGUg
QVAganVtcCB0YWJsZSwgYnV0IEkgaGF2ZW7igJl0IGNoYW5nZWQNCj4+IGFueXRoaW5nIHRoZXJl
IG9uIHRoZSBoeXBlcnZpc29yIHNpZGUuIExldCBtZSBrbm93IHdoYXQgb3RoZXIgZGF0YSBJIGNh
bg0KPj4gcHJvdmlkZSBmb3IgeW91Lg0KPiANCj4gSGFyZCB0byB0ZWxsLCBoYXZlIHlvdSBlbmFi
bGVkIEZTR1NCQVNFIGluIHRoZSBndWVzdD8gSWYgeWVzLCBjYW4geW91DQo+IHRyeSB0byBkaXNh
YmxlIGl0Pw0KDQpZZXMsIEZTR1NCQVNFIHdhcyBlbmFibGVkLiBJZiBJIGRpc2FibGUgaXQqLCB0
aGlzIGtlcm5lbCBib290cyBmaW5lLCB3aXRoDQpib3RoIENQVXMgb25saW5lLg0KDQoqVGhhdCBp
cywgYnkgZm9yY2luZyBndWVzdC1DUFVJRFs3XS5FQlggYml0IDAgdG8gMC4NCg0KVGhhbmtzIQ0K
TWlrZQ==
