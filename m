Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7349E89A
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 15:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbfH0NHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 09:07:15 -0400
Received: from mail-eopbgr30119.outbound.protection.outlook.com ([40.107.3.119]:35904
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726170AbfH0NHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 09:07:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1RorPvEVN04WhIjCF4kvNFbAsy6HLtgx3uW5znKE5lEQamYzUtF5+noMmIqGA+CmDkBxBpL3usscusRjC9xLgaoUXsbwHqS/s/8aoM1bcfTvkDHz/o+8HNqqoPL/KxMaEbGb38L63kYkXZNlK/cMuT0DZRsboOf+UWdwNNkcZ3rnfrurxay6cDs/QD1+LnnHM3IftAQ8HWYbpSEveiTtI7xZB1sgeSbyrFz/O0BEeOp2TyYOtIoqIMVfwLiYxEZ5A38WnPn3JR3kVTLIBAj1Uadzo0cDojHFwXahYwOd9aEYqSZHHSzNXkYLMXH472FXU8cF3tuO7MgtKhy4HovcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmdzwEsncDQ+h/NNev10+5y+72K4vz/osmUUL/hZIX4=;
 b=OzrBx/xaL06si4EdItriWgQuPk7wo5cEFDs53dbEdjOqX6MH7QTcm4mZQL5d8RmER+sZGeNtnA4MIb3Y6tqPaIfa0og5cPQZK684InClpw6RtInx8OsTKM4O/Xz4W1o5SoJbwLgMSfBEu5bfd5n6z+LsGnQXkOgMVqQNyDLFRaql1tbJmyycXPHtl6A3kq/QhUvNqMgnDxZzNQ+D2XgaGjUmuoEyjl+F1mJyHC/d+cw+YfBF1vczgQXgKbvg28PM/0XME09zzoNOH68ufRX2aUCGxux5UsAJJHtTvsu5JAj0XrD/zTEL0c0fxixj/tzUkQf4yBgd9IgRd6XlTH1MfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmdzwEsncDQ+h/NNev10+5y+72K4vz/osmUUL/hZIX4=;
 b=n3yDrGOXnSnf6aH+KY0MSjaCt+AUxkI4qeqy17usc6YjiveKlygZV3DRLgxaRfFldoNNUgyIuvME2jwX16oUeb4TSMNdXhCCiT9V/jMJQ6FoDqVUb7HwQB03x5fkFpio6s84GE7tCPSTOz0+1EUZ6N6tIfVlh7EaIE6bPA2IIlU=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3471.eurprd08.prod.outlook.com (20.177.59.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 13:07:10 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Tue, 27 Aug 2019
 13:07:10 +0000
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
Subject: [PATCH 3/3] KVM: x86: always stop emulation on page fault
Thread-Topic: [PATCH 3/3] KVM: x86: always stop emulation on page fault
Thread-Index: AQHVXNhVZAApmqxiJkatpVKQ81RyEQ==
Date:   Tue, 27 Aug 2019 13:07:09 +0000
Message-ID: <1566911210-30059-4-git-send-email-jan.dakinevich@virtuozzo.com>
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
x-ms-office365-filtering-correlation-id: 77f48807-dc3f-43c6-7a98-08d72aef7819
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB3471;
x-ms-traffictypediagnostic: VI1PR08MB3471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB3471571EB8A312404DA7C6138AA00@VI1PR08MB3471.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(396003)(376002)(366004)(346002)(136003)(199004)(189003)(25786009)(54906003)(6436002)(6512007)(5660300002)(64756008)(7736002)(26005)(66946007)(36756003)(66446008)(186003)(66556008)(102836004)(7416002)(305945005)(50226002)(2906002)(52116002)(11346002)(486006)(476003)(2616005)(14444005)(6506007)(386003)(44832011)(76176011)(446003)(256004)(66066001)(99286004)(316002)(66476007)(53936002)(14454004)(5640700003)(2501003)(81156014)(6116002)(6486002)(71200400001)(2351001)(81166006)(6916009)(4326008)(86362001)(3846002)(8676002)(71190400001)(478600001)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3471;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: frETppitIR38L0sPS/2xH3/yiPTAhg8idCNlIWVcE6SR9tkMf4gkzVBxbi1OGwhiCuPOgQVjBUTzFjRisv7LUTXApYkRUM8J86k8rY3UbgjHyqrDnV78FUyjgfnQ0okyB2CbQLJG+yGCi/xHuF05hRHh18zEbk0LxcQH+j8nJ9abZa9DFJt/Zqf6FWKbtLMwd5bhxIHeZVzUiy4h/9evVbjPvYGLg1iem+fb2uVDmTG+o7bBFQ8G5ba+L1mqTz7P+npWqhgyhAYCqYFGB77FH+tSA+QRDXaQXX6ka8+HMkgKTCVD8Dw103LbKFjAy7jzW9Xj/9ngg3zydBZacGCaebDX6M4v7Vd9Ce2Ni4iBZU+Vmo6Et09+KEd4Co1rmmOY9p6vSWwNVu/LhLZkhOupuCfg8RylPOIIssVneg+zmtQ=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f48807-dc3f-43c6-7a98-08d72aef7819
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 13:07:09.8379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hm1oYtEFjPmtMyjHiIkHQahp6cKKxdfNkMvlc1w9tHAQ8K/Bp9RGK46paAqBjHkNdBEEcZw0m8uZjjBXG+wFA+DVni1L6qojPb/a2EWZSn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3471
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

inject_emulated_exception() returns true if and only if nested page
fault happens. However, page fault can come from guest page tables
walk, either nested or not nested. In both cases we should stop an
attempt to read under RIP and give guest to step over its own page
fault handler.

Fixes: 6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")
Cc: Denis Lunev <den@virtuozzo.com>
Cc: Roman Kagan <rkagan@virtuozzo.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93b0bd4..45caa69 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6521,8 +6521,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 			if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
 						emulation_type))
 				return EMULATE_DONE;
-			if (ctxt->have_exception && inject_emulated_exception(vcpu))
+			if (ctxt->have_exception) {
+				inject_emulated_exception(vcpu);
 				return EMULATE_DONE;
+			}
 			if (emulation_type & EMULTYPE_SKIP)
 				return EMULATE_FAIL;
 			return handle_emulation_failure(vcpu, emulation_type);
--=20
2.1.4

