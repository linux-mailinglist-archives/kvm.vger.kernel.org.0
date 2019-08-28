Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894C09FF96
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 12:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfH1KT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 06:19:58 -0400
Received: from mail-eopbgr20132.outbound.protection.outlook.com ([40.107.2.132]:40610
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726706AbfH1KT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 06:19:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEhlbWiIOOubJrrfFj4YhD1h8Z9vCsjVDHkm3z6kT58jAdGdTAM2svdCuVixh89uN7mX+YA4bDVjFmsJ2or6qpqloA2nLH9HUxM1HUjnHdPeoCXFOwI5qMyp+8QqDBNAcLVnatLYHZx0hAuCRmbrosEQd6Y+iCOwc37q0HIYMPubaseEWcIptD/DGwOnIN4a/OAtpJ4JBxvfKytEhiGfEDlLWJCAc6r5oqDLOxPNnz6mgSwYkuEjNGGCQedjnI4ykc8IKWcPdKcB82UXaAa+Js3/IWbK3at/DVb7virxDqyoJVP8+d75JdFsprYKekOy/LQiXlps+WiF87tbVvKmiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QlC8HFqHpH/TH0Bz9A2zgF6lEBMi/cWYTIuTGqshz8=;
 b=mg/KGf6xTHaHjnWyJYTINT8wjXaCYCpuBVqU7he+PTvvNnaIM2a1n6kt956vIjorAGP931Gj9DD5vNZeNGNYWphhhkMKaOtwwcNxZJ8HTzOjsYfOmyYt8sH0hGQ8sn36+m3wTPP219DE1nLtA5KU7vkeKS89+Rf1YBjdVkl/eZgmTRJAEbNw2JXCFnxmVUJPLAnKWM6VK79b7Q1W3aschz4f+TUXtUubpalyFeTprMMABovFX0cv7Vx+CiTA/MYazj8A39fTcHLF6ZyZ+Pc+eYFmlwgbUEUDKQoRqpfrouBgS122CN57vmBgNyPhbCFEmu221oi2sCcxj0ZCk0j/MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QlC8HFqHpH/TH0Bz9A2zgF6lEBMi/cWYTIuTGqshz8=;
 b=mzhCy0uKhr1wRZLYOfCEluqLQ4vE81ZShfr9xsJJihvOWQByVpGF1rmLdn+7T/O30EhJd2w4yGTRh4kvu4R1tTh2Defz+0EIkhfzkXy24Ket6x5mozgIILignzA6Q5xIcsn0UkIg3KAxXpqKgsVQKg5yCaVklP1Go21psEK1i0k=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3760.eurprd08.prod.outlook.com (20.178.14.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.19; Wed, 28 Aug 2019 10:19:51 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Wed, 28 Aug 2019
 10:19:51 +0000
From:   Jan Dakinevich <jan.dakinevich@virtuozzo.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Wang <wang.yi59@zte.com.cn>, Peng Hao <peng.hao2@zte.com.cn>
Subject: Re: [PATCH 3/3] KVM: x86: always stop emulation on page fault
Thread-Topic: [PATCH 3/3] KVM: x86: always stop emulation on page fault
Thread-Index: AQHVXNhVZAApmqxiJkatpVKQ81RyEacPE9kAgAFGswA=
Date:   Wed, 28 Aug 2019 10:19:51 +0000
Message-ID: <20190828131948.cb67f97cab502b9f5f63b1b8@virtuozzo.com>
References: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
        <1566911210-30059-4-git-send-email-jan.dakinevich@virtuozzo.com>
        <20190827145030.GC27459@linux.intel.com>
In-Reply-To: <20190827145030.GC27459@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0329.eurprd05.prod.outlook.com
 (2603:10a6:7:92::24) To VI1PR08MB2782.eurprd08.prod.outlook.com
 (2603:10a6:802:19::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jan.dakinevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Sylpheed 3.6.0 (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1d772c5-50cd-4a3f-e3e0-08d72ba142d7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB3760;
x-ms-traffictypediagnostic: VI1PR08MB3760:
x-ms-exchange-purlcount: 4
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB3760B88880AC97A9DEB8233A8AA30@VI1PR08MB3760.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(376002)(39840400004)(396003)(136003)(189003)(199004)(5660300002)(66446008)(64756008)(66556008)(66476007)(86362001)(305945005)(14454004)(7736002)(66946007)(7416002)(3846002)(1076003)(6116002)(966005)(6916009)(478600001)(54906003)(4326008)(11346002)(2616005)(25786009)(476003)(486006)(446003)(66066001)(44832011)(2906002)(53936002)(316002)(71190400001)(71200400001)(6246003)(6436002)(99286004)(6486002)(76176011)(256004)(14444005)(52116002)(6512007)(8936002)(81166006)(81156014)(6306002)(102836004)(229853002)(26005)(386003)(50226002)(186003)(6506007)(36756003)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3760;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ezLjuIjLLdH0fbfX3f2tnPnuWChbpXuPT8SBnWkU+6ErYVhM35Mo48V11HZeCXWZDc9hx3A0WtoxHhFJu3lj+bVST9IxrkxxYf3+KNX2/4wNyJzxGZjBi1zlk7Iv8cZiMZI0An4pu/xx5R3wDllYavNmhaL78rGazy97Erv5DsK//vzKTQAqc5VYAbGkqR6jBm0o6jnlkNZTmYUNjzqLrDdzXv5QeTUvXdyh5tT3PckYZcvg3thX+0ZIvND4LoLhuIXRT+z12MGK6JpIrErwfg38P/52TcydmBbBdTuTO/Cpv9nGNFhObd9IRvNpf4E60Um7wrnYNSwu/ZNHk1LdtwUdFDOvTYnfUg9F0zyUYaMj1/tVEYDhmxxzcrmQyNG6Iu7Ky5HZMBL/ol9T4N3HtyASvmAhipJ9bz8WNovktcg=
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <1DCAE66B3DFBD2448CD311BA47D3DB35@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1d772c5-50cd-4a3f-e3e0-08d72ba142d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 10:19:51.0996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ofAJYkxUXYtqFoVjr6TemkAfMNAiYRDuKzyYOWBprDRUKVzjRQvNx+1B2xMjE6+Mcwwlu347pqZLhSlR7rr0IRfEeZurN6kU/IM/gPHYjnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3760
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Aug 2019 07:50:30 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> +Cc Peng Hao and Yi Wang
>=20
> On Tue, Aug 27, 2019 at 01:07:09PM +0000, Jan Dakinevich wrote:
> > inject_emulated_exception() returns true if and only if nested page
> > fault happens. However, page fault can come from guest page tables
> > walk, either nested or not nested. In both cases we should stop an
> > attempt to read under RIP and give guest to step over its own page
> > fault handler.
> >=20
> > Fixes: 6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_ins=
n")
> > Cc: Denis Lunev <den@virtuozzo.com>
> > Cc: Roman Kagan <rkagan@virtuozzo.com>
> > Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
> > Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
> > ---
> >  arch/x86/kvm/x86.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 93b0bd4..45caa69 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -6521,8 +6521,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcp=
u,
> >  			if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
> >  						emulation_type))
> >  				return EMULATE_DONE;
> > -			if (ctxt->have_exception && inject_emulated_exception(vcpu))
> > +			if (ctxt->have_exception) {
> > +				inject_emulated_exception(vcpu);
> >  				return EMULATE_DONE;
> > +			}
>=20
>=20
> Yikes, this patch and the previous have quite the sordid history.
>=20
>=20
> The non-void return from inject_emulated_exception() was added by commit
>=20
>   ef54bcfeea6c ("KVM: x86: skip writeback on injection of nested exceptio=
n")
>=20
> for the purpose of skipping writeback.  At the time, the above blob in th=
e
> decode flow didn't exist.
>=20
>=20
> Decode exception handling was added by commit
>=20
>   6ea6e84309ca ("KVM: x86: inject exceptions produced by x86_decode_insn"=
)
>=20
> but it was dead code even then.  The patch discussion[1] even point out t=
hat
> it was dead code, i.e. the change probably should have been reverted.
>=20
>=20
> Peng Hao and Yi Wang later ran into what appears to be the same bug you'r=
e
> hitting[2][3], and even had patches temporarily queued[4][5], but the
> patches never made it to mainline as they broke kvm-unit-tests.  Fun side
> note, Radim even pointed out[4] the bug fixed by patch 1/3.
>=20
> So, the patches look correct, but there's the open question of why the
> hypercall test was failing for Paolo. =20

Sorry, I'm little confused. Could you please, point me which test or tests=
=20
were broken? I've just run kvm-unit-test and I see same results with and=20
without my changes.

> I've tried to reproduce the #DF to
> no avail.
>=20
> [1] https://lore.kernel.org/patchwork/patch/850077/
> [2] https://lkml.kernel.org/r/1537311828-4547-1-git-send-email-penghao122=
@sina.com.cn
> [3] https://lkml.kernel.org/r/20190111133002.GA14852@flask
> [4] https://lkml.kernel.org/r/20190111133002.GA14852@flask
> [5] https://lkml.kernel.org/r/9835d255-dd9a-222b-f4a2-93611175b326@redhat=
.com
>=20
> >  			if (emulation_type & EMULTYPE_SKIP)
> >  				return EMULATE_FAIL;
> >  			return handle_emulation_failure(vcpu, emulation_type);
> > --=20
> > 2.1.4
> >=20


--=20
Best regards
Jan Dakinevich
