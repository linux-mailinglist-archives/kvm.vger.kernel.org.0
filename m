Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0098DA0807
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 19:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfH1RDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 13:03:04 -0400
Received: from mail-eopbgr140095.outbound.protection.outlook.com ([40.107.14.95]:48192
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726415AbfH1RDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 13:03:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIF6HGIP8GH+jxrahZhXWnA5ybvp4En3ui6t+QWwc5Nh6D6J17Dg0TayB15AQcDHThtkmhi/5kK0ddwe3UDbX4nUmfFED4xM0VqNGYqUJHoR1PGLMCHQbp/uLaQnEBmHYLciihCe37XfcyHKJYEyGvryF9YEhe0oWh/n/CK4Wshb7H/ut7rId332c1N1jfdp8CMjhbkKqIWbOTB1OqS+MsQo4fWupzMNqIXA7puUFHvqoKqxXpjGzX4Kyj2dz2g43f2x0BT3CyakXE1T5/o8MqaLk3GfBI/OMHYvrlQ4pT0DnQIhy2L2x1rb6xz63IUK4c1Tl0JizYf+SaWYT11Jaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QIm7U946QZFxCz9FGcoeYr/NXQH9LC9JmK7WnYfIDCg=;
 b=g4MCycWeYQKLAmedOzwuuyLSS5Cz1N0yZeMZTvsa/cZHedgdytKNE0JSBrXUUmsryuu+VVWqfzRqsZIYKiV8W6zADADqKn/ZgaDuyxp694tm+LgaelnKgHM0CX0PNgxpok5GAeEP042zx/MF0yeAr0N0rkWbmPngwBV+oYVBGIVg7vhjSm0iNARkkcK3LWw3z3+phu9ydtN4n00uDCGh/LsKScuxxbuoZ/qcpIMiSFbzH4vPS6lEQ6/dZsMXIprW1xJVlogMnbRaqvYpfO9PfAc2m+n/ps+QqtWszff2/mj66zDjj7eb7bvrvF0cGsREQ7x/YPZemmo7ZBrEZf4mjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QIm7U946QZFxCz9FGcoeYr/NXQH9LC9JmK7WnYfIDCg=;
 b=Cak57R9mRqDAPVmdt62QKTmyTqfqQkkacXYQotR0TyznYivL0o6y3ozSVoOxOrLFfl+/dG5dbW/e4dfJjMTr4k95H9tQgbe4VctAlL8jEklnwLvSFMBds4TuhgDD7yA5+t8cm2HOKaj0ehjE0aLgz9rzxuc0wXR9xh1qCezO2s0=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3181.eurprd08.prod.outlook.com (52.133.15.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Wed, 28 Aug 2019 17:02:57 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Wed, 28 Aug 2019
 17:02:57 +0000
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
Subject: [PATCH v2 2/3] KVM: x86: make exception_class() and exception_type()
 globally visible
Thread-Topic: [PATCH v2 2/3] KVM: x86: make exception_class() and
 exception_type() globally visible
Thread-Index: AQHVXcJwZ8H/6OmPEECkMYgQWBHwtg==
Date:   Wed, 28 Aug 2019 17:02:57 +0000
Message-ID: <1567011759-9969-3-git-send-email-jan.dakinevich@virtuozzo.com>
References: <1567011759-9969-1-git-send-email-jan.dakinevich@virtuozzo.com>
In-Reply-To: <1567011759-9969-1-git-send-email-jan.dakinevich@virtuozzo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0154.eurprd05.prod.outlook.com
 (2603:10a6:7:28::41) To VI1PR08MB2782.eurprd08.prod.outlook.com
 (2603:10a6:802:19::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jan.dakinevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.4
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f0e28ce-82ee-4ea6-d7b4-08d72bd99317
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB3181;
x-ms-traffictypediagnostic: VI1PR08MB3181:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB3181217EF23CFF0E7A3C5C9D8AA30@VI1PR08MB3181.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(39850400004)(136003)(396003)(189003)(199004)(478600001)(26005)(4326008)(8936002)(186003)(102836004)(3846002)(256004)(476003)(44832011)(6486002)(66066001)(6512007)(305945005)(2906002)(2501003)(446003)(86362001)(6436002)(6116002)(66446008)(8676002)(66946007)(64756008)(66556008)(76176011)(66476007)(316002)(7736002)(81156014)(52116002)(25786009)(81166006)(71190400001)(71200400001)(6506007)(486006)(386003)(14454004)(53936002)(99286004)(2616005)(5660300002)(6916009)(2351001)(54906003)(5640700003)(36756003)(50226002)(11346002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3181;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4HqlzTY/k8eD1XZTzzeUCt10LcolWzUiCbl5NDQd6sUON84aOW4lYiaMe6PQQmGnwlWOg/WNaRz0/6Lp6D8yXGuw80jauPwrYpLoWwFUoXO6WO6QNAGUPdbw9eX7StGLHmyEcySNFV84enxCPvhg6lyXL0YSrhPx2y6Gxdceu4x8RTvpI/pjj/FIQPx1HAvXReBI3cKkubXEwQzAJa51sRgRQ9zbNi3k9GKcTJI7/InGtq0fwUi1/mTFqnjOCI0XcQzheveZl58JpnuEdwGaZbvjn/UECKeXV57q5M5zGQxc0R0AknoUQaXqezp5WWdd3W4MXGz8RrWM6cB0dh8VfRXuRWt3Rz3pOiZquOeO0tWdlWy9Q1fV9hp/IDhUPPPrg23kyB8Q2mL1kdYXP/zlz+Pn0zHXJkeGID+0BJfM3U0=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0e28ce-82ee-4ea6-d7b4-08d72bd99317
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 17:02:57.4423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 38SDz5KyO+Jv3UMRXJJ43KtbOu5vHVkL1WQNl98u30Fb2ilqbqNp7zamB85bt58Dnf4z12RVaBFD++/kKFNn8gV2T0LLbs2o221F/0psFDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3181
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

exception_type() function was moved for upcoming sanity check in
emulation code. exceptions_class() function is not supposed to be used
right now, but it was moved as well to keep things together.

Cc: Denis Lunev <den@virtuozzo.com>
Cc: Roman Kagan <rkagan@virtuozzo.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 arch/x86/kvm/x86.c | 46 ----------------------------------------------
 arch/x86/kvm/x86.h | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 903fb7c..2b69ae0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -364,52 +364,6 @@ asmlinkage __visible void kvm_spurious_fault(void)
 }
 EXPORT_SYMBOL_GPL(kvm_spurious_fault);
=20
-#define EXCPT_BENIGN		0
-#define EXCPT_CONTRIBUTORY	1
-#define EXCPT_PF		2
-
-static int exception_class(int vector)
-{
-	switch (vector) {
-	case PF_VECTOR:
-		return EXCPT_PF;
-	case DE_VECTOR:
-	case TS_VECTOR:
-	case NP_VECTOR:
-	case SS_VECTOR:
-	case GP_VECTOR:
-		return EXCPT_CONTRIBUTORY;
-	default:
-		break;
-	}
-	return EXCPT_BENIGN;
-}
-
-#define EXCPT_FAULT		0
-#define EXCPT_TRAP		1
-#define EXCPT_ABORT		2
-#define EXCPT_INTERRUPT		3
-
-static int exception_type(int vector)
-{
-	unsigned int mask;
-
-	if (WARN_ON(vector > 31 || vector =3D=3D NMI_VECTOR))
-		return EXCPT_INTERRUPT;
-
-	mask =3D 1 << vector;
-
-	/* #DB is trap, as instruction watchpoints are handled elsewhere */
-	if (mask & ((1 << DB_VECTOR) | (1 << BP_VECTOR) | (1 << OF_VECTOR)))
-		return EXCPT_TRAP;
-
-	if (mask & ((1 << DF_VECTOR) | (1 << MC_VECTOR)))
-		return EXCPT_ABORT;
-
-	/* Reserved exceptions will result in fault */
-	return EXCPT_FAULT;
-}
-
 void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 {
 	unsigned nr =3D vcpu->arch.exception.nr;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b5274e2..2b66347 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -369,4 +369,50 @@ static inline bool kvm_pat_valid(u64 data)
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
=20
+#define EXCPT_BENIGN		0
+#define EXCPT_CONTRIBUTORY	1
+#define EXCPT_PF		2
+
+static inline int exception_class(int vector)
+{
+	switch (vector) {
+	case PF_VECTOR:
+		return EXCPT_PF;
+	case DE_VECTOR:
+	case TS_VECTOR:
+	case NP_VECTOR:
+	case SS_VECTOR:
+	case GP_VECTOR:
+		return EXCPT_CONTRIBUTORY;
+	default:
+		break;
+	}
+	return EXCPT_BENIGN;
+}
+
+#define EXCPT_FAULT		0
+#define EXCPT_TRAP		1
+#define EXCPT_ABORT		2
+#define EXCPT_INTERRUPT		3
+
+static inline int exception_type(int vector)
+{
+	unsigned int mask;
+
+	if (WARN_ON(vector > 31 || vector =3D=3D NMI_VECTOR))
+		return EXCPT_INTERRUPT;
+
+	mask =3D 1 << vector;
+
+	/* #DB is trap, as instruction watchpoints are handled elsewhere */
+	if (mask & ((1 << DB_VECTOR) | (1 << BP_VECTOR) | (1 << OF_VECTOR)))
+		return EXCPT_TRAP;
+
+	if (mask & ((1 << DF_VECTOR) | (1 << MC_VECTOR)))
+		return EXCPT_ABORT;
+
+	/* Reserved exceptions will result in fault */
+	return EXCPT_FAULT;
+}
+
 #endif
--=20
2.1.4

