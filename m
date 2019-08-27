Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547689E89C
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 15:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfH0NHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 09:07:11 -0400
Received: from mail-eopbgr30119.outbound.protection.outlook.com ([40.107.3.119]:35904
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729470AbfH0NHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 09:07:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cs6xLnr48wjRoSPGaYwZqHaViSKuTJA3vhkMSIhOlhAKaMmiSXO/sD32Nei3xgN2UYVrD0Re0HzGDnV1J02toq0ox8+B/TyehkPOYQYTEdkRjR3GTzULgmgfBJc6wS6GU7LiR79D4PeI329NZc3BGCiE37p1i7NXfVugOICln5CG69J99/QlE6q7Un04QNEMdm6B5e/JmsPAJVyAhUiqrekXM8u2isnYn/RTBErhMaLq4BGytjbu7YI7NpwwWShpYZCJEnyaDqK4dJK+Trw9ewIijABjUTfcI5kSEWwPKlizd9IRv+HcdqaH1tQ9p4axx2yX8eam7qkD8iCz1xnAcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTU3RBaioQK1he+2mgZMaj08Q3uYZJPL8GyJPnwY/A0=;
 b=IRcAdffo2dKHk68ZOuoV52cwOzCZ++xXcJET8IdHqgdDW6q9UNYHpjG7GDWP9ER2IML7CXmx23oI2rkDr9Hbdcn3axsSTiPmJU/KheXcWEByk1bTikiplCGFAWdjtIv1A4y6IY3g81dpFLDBfi9vF9Fki3i0vavc/zRKUDwPulpOYlWjs+41uXrsb9ZUEkwO0+IyxOWPHAzIsh+rZIFa9k9gwCzcXwWZMjA/ZdaiQw++wdmkz2uMPVqQSe80yezIdqK1lystKS7WsGAqMhFMH3NupfFqbP02Qi9JJRiTDlZqW4fmdBtuikTr0vhz1S4r5k7SKK+QoonmKqMmEnWdWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTU3RBaioQK1he+2mgZMaj08Q3uYZJPL8GyJPnwY/A0=;
 b=VBgEikBVl66n9PYdvQYWxhoNYb0YLO5Rq6XkSpmeicP4atilFqUWAo6O23AzXBKf7CBdaDUy/NEsW6HauaAVJ6FsxA866G5AHruhxqPpo5UfVRjmIMlDV9AP5E3qBsU7mG6fgwVNhAoi8HIhEe5NQm2vvNhBgOB31NKl10YaYf0=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3471.eurprd08.prod.outlook.com (20.177.59.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 13:07:08 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Tue, 27 Aug 2019
 13:07:08 +0000
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
Subject: [PATCH 2/3] KVM: x86: set ctxt->have_exception in x86_decode_insn()
Thread-Topic: [PATCH 2/3] KVM: x86: set ctxt->have_exception in
 x86_decode_insn()
Thread-Index: AQHVXNhUGXqiO0HWykadKGZM7EVsbw==
Date:   Tue, 27 Aug 2019 13:07:08 +0000
Message-ID: <1566911210-30059-3-git-send-email-jan.dakinevich@virtuozzo.com>
References: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
In-Reply-To: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
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
x-ms-office365-filtering-correlation-id: e8eb0b6e-2afa-48a5-805f-08d72aef7711
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB3471;
x-ms-traffictypediagnostic: VI1PR08MB3471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB3471A6C482C56659A9D7F30F8AA00@VI1PR08MB3471.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(396003)(376002)(366004)(346002)(136003)(199004)(189003)(25786009)(54906003)(6436002)(6512007)(5660300002)(64756008)(7736002)(26005)(4744005)(66946007)(36756003)(66446008)(186003)(66556008)(102836004)(7416002)(305945005)(50226002)(2906002)(52116002)(11346002)(486006)(476003)(2616005)(14444005)(6506007)(386003)(44832011)(76176011)(446003)(256004)(66066001)(99286004)(316002)(66476007)(53936002)(14454004)(5640700003)(2501003)(81156014)(6116002)(6486002)(71200400001)(2351001)(81166006)(6916009)(4326008)(86362001)(3846002)(8676002)(71190400001)(478600001)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3471;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: m+TIeT/wQGxeuUMdJMwZ655CNu97Aj329r/gXq7b/Fn9cC+3WGZgZm/Vw2foYwbW1WP1M1UKXdL0GYkxhO1x/iMMnrsyhEO/fbhFvnWGcT8svADf+jJcZPGrUG15hzLVdmh5Ah+oV0rx5dukCWa9VbZaU94N/FpWPA3AoqhOhG0j/ZeQUWGKEm4+J8M+0cP30zT4b78JaISNj2eBJ+L02WqUcZrI5X0sqnmfaQSUCvpW97gd06zjC8zraDeY7Plrdy+ATOorPZA0scrCP409n2X/2TVG5Dx9dRgF2rNT2l3xplyBtNG8Mk44tC6kv10LUy06Ktpz5OX0Ni2aNiO8p378nKASQMLvaSE3Rsm3CMQcgCZ2XxLVNQ+U6D5kV6LhdNU78ioGSUt7f6/BnuOpk9e5JC0q5AO9m4KDYu93SDo=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8eb0b6e-2afa-48a5-805f-08d72aef7711
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 13:07:08.0839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZjHWoSrSdgHNJOztv2yuWB1h3pLp82jpxIUcT0sTUOwPtoRWZDixgLXfYnKXYGmdOnJt0Jp5kCtrDiBXn7BC5zQxxNGNPrlHdleamyn0j2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3471
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86_emulate_instruction() takes into account ctxt->have_exception flag
during instruction decoding, but in practice this flag is never set in
x86_decode_insn().

Fixes: 6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")
Cc: Denis Lunev <den@virtuozzo.com>
Cc: Roman Kagan <rkagan@virtuozzo.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 arch/x86/kvm/emulate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 6170ddf..f93880f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5395,6 +5395,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, vo=
id *insn, int insn_len)
 					ctxt->memopp->addr.mem.ea + ctxt->_eip);
=20
 done:
+	if (rc =3D=3D X86EMUL_PROPAGATE_FAULT)
+		ctxt->have_exception =3D true;
 	return (rc !=3D X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
 }
=20
--=20
2.1.4

