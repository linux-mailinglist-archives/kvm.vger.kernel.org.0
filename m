Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFDA9E897
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 15:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbfH0NHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 09:07:05 -0400
Received: from mail-eopbgr30119.outbound.protection.outlook.com ([40.107.3.119]:35904
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbfH0NHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 09:07:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jaxrAeu/92hH+I9ljpJBFUrFshz4LtBLqPwbWU2I4FuZ590iX+lkyWRSvYm3bC/EKAXpohjOj9YRCpR/BVYouMWbkP5LMRyHxRKrY3VF+2p9m6W0F2nYkqhgJQNjZ4y8PMjov6ECnhl2lfy3Kx2/odBko7Pagye1b/X4ocWvHLevsvdYjhdocbOOGZg47hg9+0q+wH2v5Vqtu8nMzMbkRQuVkfQ77nO0S0HtgG5s+EVXePEMOYgueBxEZzc4BD1OzbFuhNZqCNgnhwSvNwMa6JXhuof0v8dfEQl/2OuC/cnrRmdlzjgoapZPWXN42PIUqA+1cXzkHRiI1h9EWE51Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzUMO09cKYplP4IdSQB+IMq/dBJWErbTK/AcBdGhAbk=;
 b=bO8hhM5MFhRLDW/Tjfx16UgI1ajckICMfTKv2ZiDISrMQA5TLUt2fZmzLeLnAp0NoaopNHqMHCa53aSNElZr0x0avfp454v4RBy95nXtChW0q2VH+q9KtwQkrb3QkS7mpVtJbgnq5Gt7hD1uVHjx+FVY8g2tqwMa4nDcKPlKGrRNw760u2H9n/klCoqnCAvRoF+PKwQxUgUIpuxg1dO2R6CaQy6Cwmbhmg/cQKY8ieZ7C4v4bXaetq8xh8vXr1lwWyikeL63yvAYV278UHEaV+TZSYTqjq8tWccFmbtMfzia1p9Flr06NjNVayLrJOsroGiS0Yt2+QR9R+CvXsdlcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzUMO09cKYplP4IdSQB+IMq/dBJWErbTK/AcBdGhAbk=;
 b=BCFXjOq9axO7P/mR1P7gHjwrf7lptRLsu3cnvF5sJsO93M5tKgwpPqCLNYv5MqqV3Icyh7jcO/AX/H8YC87VKogRL6e7XKSTJylfvEXfcOnTGjfIvFS6MLhHltqybI6V5htrM0wvPdtgndCqNxcQloZ9AdyURWiVaSQSP9q+xSM=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3471.eurprd08.prod.outlook.com (20.177.59.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 13:07:01 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Tue, 27 Aug 2019
 13:07:01 +0000
From:   Jan Dakinevich <jan.dakinevich@virtuozzo.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Jan Dakinevich <jan.dakinevich@virtuozzo.com>,
        Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH 0/3] fix emulation error on Windows bootup
Thread-Topic: [PATCH 0/3] fix emulation error on Windows bootup
Thread-Index: AQHVXNhQlPTN3PT6WEuOH2XmT3iwQg==
Date:   Tue, 27 Aug 2019 13:07:00 +0000
Message-ID: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0802CA0004.eurprd08.prod.outlook.com
 (2603:10a6:3:bd::14) To VI1PR08MB2782.eurprd08.prod.outlook.com
 (2603:10a6:802:19::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jan.dakinevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.4
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04175519-7c1e-494f-f058-08d72aef72d2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB3471;
x-ms-traffictypediagnostic: VI1PR08MB3471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB34717DE33508136B250D9F2C8AA00@VI1PR08MB3471.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(396003)(376002)(366004)(346002)(136003)(199004)(189003)(25786009)(54906003)(6436002)(6512007)(5660300002)(64756008)(7736002)(26005)(4744005)(66946007)(36756003)(66446008)(186003)(66556008)(102836004)(7416002)(305945005)(50226002)(2906002)(52116002)(486006)(476003)(2616005)(6506007)(386003)(44832011)(256004)(66066001)(99286004)(316002)(66476007)(53936002)(14454004)(5640700003)(2501003)(81156014)(6116002)(6486002)(71200400001)(2351001)(81166006)(6916009)(4326008)(86362001)(3846002)(8676002)(71190400001)(478600001)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3471;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /qrFORhe4WnyjEpah2+wjJshltj9p7PEf6pqDU38YXXyZoIzyx1eKU38HAv2he9b+0qrsU7HbgRKzNpiVv6g4zKse+nR01oSxcZyjH322nVRsqj85vIBN1U/J3BCTmyFGk1F84l+bTYd4DPTFPySAckBMUmaLvxutENWZ7oXHBPOmEt4xdbTwps7slz5aDlXqP7zzvSgR4uPrXG9PFk6rhKNozz+hyuEVgnBvNsJVXpFCaPH4f5+sZ81H4vFrNvzPJK0vsvg7hcSk8/AonA281j1fNNE3JnHe6e5G3vjEgL9jlLZMzJLm5KTz76ityNBUoOjszhwkzfToq6E6wRpLX8Ep+CNVm+sDjkmxhwDAAOOASPnq+IZPWqR+KshiYZ/XsWRf5RXMpZKadHB7NufV9VVqbJ6keLLzaV4khZ/qq0=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04175519-7c1e-494f-f058-08d72aef72d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 13:07:01.0870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LWC8ng8kkDo/0oYWTtxBfjVtTxanGEaQUSXPZm/JI5PAdpvCrGEJrZmLpgPDFAPM15ifux2jQwyqkE3tbEyhBS4tDHzE5cv7VReX354H6Wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3471
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series intended to fix (again) a bug that was a subject of the=20
following change:

  6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")

Suddenly, that fix had a couple mistakes. First, ctxt->have_exception was=20
not set if fault happened during instruction decoding. Second, returning=20
value of inject_emulated_instruction was used to make the decision to=20
reenter guest, but this could happen iff on nested page fault, that is not=
=20
the scope where this bug could occur.

However, I have still deep doubts about 3rd commit in the series. Could
you please, make me an advise if it is the correct handling of guest page=20
fault?

Jan Dakinevich (3):
  KVM: x86: fix wrong return code
  KVM: x86: set ctxt->have_exception in x86_decode_insn()
  KVM: x86: always stop emulation on page fault

 arch/x86/kvm/emulate.c | 4 +++-
 arch/x86/kvm/x86.c     | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--=20
2.1.4

