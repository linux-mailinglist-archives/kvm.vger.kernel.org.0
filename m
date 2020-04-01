Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACA419B4CB
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 19:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732583AbgDARkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 13:40:08 -0400
Received: from mail-dm6nam10on2051.outbound.protection.outlook.com ([40.107.93.51]:6258
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732196AbgDARkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 13:40:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DURm36is+2TC7ZtH3dElPsA6DTrkPfUUHpmIewyuK6N4iMQia1p6gt1rcyCyJkFsoXhsXYXXbSNgnAwCQ6Nyk2F4EwsdLpJ/sb94t1b9zaY5U1KbxBjpX88GURgtvOmHm+2CSjKpj4m1i4xulxXYPpg+iCyRytfLIoAQQ8K1yehFeZr+yn/iMKGtwIPAvV7VqE1iO2Rwv78EnhFBvDijmtiDiD7lLHU8CpUZgbSSoZckDDN4qccvYGmDn+2t9WZ+c1qYRQ62mPHfgI4jc9WIkiAN20t/Sg+xKOzl+HYSbi3Uod6Xt6fJUZxKhkS/LR32IPX/nYKsCglgvrGwXZPlZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDYAm6jc1dFCcRrsvJRJ7Jy52PoDFHrZOT9z2Ed/tbM=;
 b=PrZO3TP6wdHo8+GqpjP65FGsjVOfeFGxG2WKkvUp3SQg8vmyd8EtnzMbJ8XE2s7plwsF/F/r0ippxcEggSJ59dsDL0byvuvXad43TOnCziPJvL6RAP7o8Ggpugpudl/zUpqZWrIz2rhZAFUVuaLz6/yVp47uDbir9l8FiN5yAaRiSzpIprSnlcLOURzHJoZCzGv4Z+58IuEoLNoFqcQAEzr3dhK27PLVuMrHUGDLOAXr8WkgsoBthLklJgLtc0WdYbJEODXBBG4Q57UCQGZcqjwsery9MCHPPWSn7V/uj+x/u0rM36dzJ7fUmopJnHceT3NeIBLrKrTq2i0MoRTUIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDYAm6jc1dFCcRrsvJRJ7Jy52PoDFHrZOT9z2Ed/tbM=;
 b=SXQzFB2+dx0+69JwnCdFv/EoWYGF9OOGU3SS5OhFYAGnbAntOYNvLNQHWMLmkeWmOgy11nyYQvRN6CWX8b86/HroiB+Uwj3FpUoH+NLdlDFsQ327kWAm9oNWxa75SehTnIV65qUO/FpreW113s+hNj4MMdIgb3qaNPeaiLT1mb0=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB4997.namprd05.prod.outlook.com (2603:10b6:a03:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.13; Wed, 1 Apr
 2020 17:40:03 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::7c65:25af:faf7:5331]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::7c65:25af:faf7:5331%2]) with mapi id 15.20.2878.014; Wed, 1 Apr 2020
 17:40:03 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Wanpeng Li <kernellwp@gmail.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 2/2] KVM: LAPIC: Don't need to clear IPI delivery
 status in x2apic mode
Thread-Topic: [PATCH v2 2/2] KVM: LAPIC: Don't need to clear IPI delivery
 status in x2apic mode
Thread-Index: AQHWB/FWdzgWY4YnU0q2HQ5H9CdmBahkiUOA
Date:   Wed, 1 Apr 2020 17:40:03 +0000
Message-ID: <CE34AD16-64A7-4AA0-9928-507C6F3FF6CD@vmware.com>
References: <1585700362-11892-1-git-send-email-wanpengli@tencent.com>
 <1585700362-11892-2-git-send-email-wanpengli@tencent.com>
 <6de1a454-60fc-2bda-841d-f9ceb606d4c6@redhat.com>
 <CANRm+CzB3dWatF7qOO_WajXM_ZBn1U6Z8+uq4NxCuLG3TgwY1Q@mail.gmail.com>
In-Reply-To: <CANRm+CzB3dWatF7qOO_WajXM_ZBn1U6Z8+uq4NxCuLG3TgwY1Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [2601:647:4700:9b2:4568:145a:b450:27e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7dcce41-d5e0-4363-5d60-08d7d663b5f6
x-ms-traffictypediagnostic: BYAPR05MB4997:
x-microsoft-antispam-prvs: <BYAPR05MB4997FE8B1C2D17072321BA5ED0C90@BYAPR05MB4997.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(4744005)(36756003)(478600001)(33656002)(6486002)(8676002)(2616005)(6512007)(8936002)(2906002)(81156014)(81166006)(86362001)(6506007)(53546011)(66446008)(66556008)(76116006)(5660300002)(316002)(71200400001)(186003)(4326008)(6916009)(66476007)(64756008)(66946007)(54906003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2wzi9A0P+GSFuHAuTiLPH5le6RTAxO2QRTsMgIpvrrWBbbqFrGwuKbi/7krpwICpjmHyoD8vHEvWZkbOywUHKdjU534si+NOm6cz9fEwbxFYqLlm5RIhLL1enJZuvIjuhm9xZ4PhNmIj8ixR/SB0oBLs1f7LzpccNBOI9nwXhm4v3TSua5ciwgaBO4IXCiG/Iy9Aif/3dOWCo0+Iyr1lRqKJ+Kvqp4qyyn/sy7lvpmvkpL2W+yCD5Sxzksd+Otyhr6y+2/L/DbStDvhJBD8xnZk3Fw9wCYvZ6Kye70VkNfBr0vY3EDClxYVdjooLIVc6/W95DH5W5AT4rcs/CS4g6TkrrI72qkj3A1Y5+CkE987l97J/x2RszaoJKPn9WxROYfieOK+rhnv9zH36lkzfrYe4sMSwh7kAr3Vx5PPAsR2MIAGcynHo1xtuo2t1Ontg
x-ms-exchange-antispam-messagedata: E6EY15vsF0NK5qbQ29HVqSuCC0YLxcAcK8QZvDTa+DMlHY7R6377ocZ7RSyZebpPHEqSJ9dHB2TOdvhjOgI7hHR40uFlaZhl1yDpixHtEc5y98NkB9w/HZlfw9ozk70iV0VHXRIk1BJVt1/ZYCK+4iznba3s8H8Gkc972SqkTIMMycXtqPmbWfEfWGU/3MozIxG8gHHAy0DA9VwWYhweYg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9F187A50EFA04A4B8361CED49AD3EAD8@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7dcce41-d5e0-4363-5d60-08d7d663b5f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 17:40:03.7953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aNIyci8QvJj1KaMJpM+0AARB5myi0o2U1v6s1gYpFH8YV3o5q2Hc6SFJajNdvEEmfPqcx+qJ/RlaJputQla/gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4997
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Mar 31, 2020, at 11:46 PM, Wanpeng Li <kernellwp@gmail.com> wrote:
>=20
> Cc more people,
> On Wed, 1 Apr 2020 at 08:35, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> On 01/04/20 02:19, Wanpeng Li wrote:
>>> -             /* No delay here, so we always clear the pending bit */
>>> -             val &=3D ~(1 << 12);
>>> +             /* Immediately clear Delivery Status in xAPIC mode */
>>> +             if (!apic_x2apic_mode(apic))
>>> +                     val &=3D ~(1 << 12);
>>=20
>> This adds a conditional, and the old behavior was valid according to the
>> SDM: "software should not assume the value returned by reading the ICR
>> is the last written value".
>=20
> Nadav, Sean, what do you think?

I do not know. But if you write a KVM unit-test, I can run it on bare-metal
and give you feedback about how it behaves.

