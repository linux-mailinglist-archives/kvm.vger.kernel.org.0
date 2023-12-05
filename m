Return-Path: <kvm+bounces-3641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 716268061C9
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 23:37:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C22BAB21216
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 22:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F9906EB6E;
	Tue,  5 Dec 2023 22:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zSH7BAHB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFD7196
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 14:37:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4VntqbSkR8Npf6rtazG0P8wF/Y4ogHmXOrir1SxYjvaQmnh1/e76jQ2+Wd6/GAtKxtvhOczMPJCezImc40jC/oZZTNxQ9eLnHV3hCTlJaPba6jj61DtiBiILLPPLyai9PIC++Ufzqo+QrvK7JAULmPhehf0g8S1kNv4GQY2i8gS4X8QnltmkEPv54EjVPwY8fmMYqpU0Hbj88CdAQOG/uFL8WZSr8gy6oG1vhQouANxx4KV7xA1mUpZdAT4Yy680G1ib30U5hCcl7NbQbXMAtEuMQR03Lp+zI2VD+S06W75S8lwpdQTmm5lr5MS0RbrY4y3H67AS4/A+zChOAhrVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gaZ1YUcTGesqAH7YZoOQR1aPyQLq4gBP87zHRJET/iU=;
 b=GRZZvObskEb9dQfJeUYRQ5IUm6ssEM2KW2Jb47JpQhmdIQW3l7fM3u4gt4ArDBQkhlaDlhYIft8jmOuuxHgigMyGKz+dkADPkfMg5Jh5q+mNeMdKnofwD8F7OCqg02P+uza2kZfIUPxSWu3jIXsamoul/Cxwlqd8fhVKHuUPOZu+bVgMsGNqbVotT8vvHEkGSijmtJy29mUhPI2a/RYEz4+UnQjy9fDwdiQaBETycCnB5b029z2szbWKu/3c2rZ/j17NEmjYLe3tyTp6UFu5Xuw/zP7/qy23jGpzS1WWKNaLzqMvzHylNaqzp48AmqVn8LHlZLUxLytODTl48bMi7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gaZ1YUcTGesqAH7YZoOQR1aPyQLq4gBP87zHRJET/iU=;
 b=zSH7BAHBRccVQ3y2LAqejLk2nZFCTWcrVeMfVAfHZ69sHZLGOU9y3ZsDpkH+O1DUZJQIr1POn3m7V0pNyXnS8iRVzAb7sEy4ZoWhq+fEoVXixCssMyOmEetqLdB8oSZym15ykD+R5Hos/gs8wvyUS0qzCLEv/rJnYcNtOfhTELE=
Received: from CY5PR22CA0064.namprd22.prod.outlook.com (2603:10b6:930:80::8)
 by PH7PR12MB8779.namprd12.prod.outlook.com (2603:10b6:510:26b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 22:36:59 +0000
Received: from CY4PEPF0000EE33.namprd05.prod.outlook.com
 (2603:10b6:930:80:cafe::53) by CY5PR22CA0064.outlook.office365.com
 (2603:10b6:930:80::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 22:36:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE33.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 22:36:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 5 Dec
 2023 16:36:57 -0600
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJSP0QWtnDAmfM7FAyU4dizhVzUWrfagrBVzh-31MPAn9p4X4g@mail.gmail.com>
References: <20231205221219.1151930-1-michael.roth@amd.com> <CAJSP0QWtnDAmfM7FAyU4dizhVzUWrfagrBVzh-31MPAn9p4X4g@mail.gmail.com>
Subject: Re: [PATCH for-8.2?] i386/sev: Avoid SEV-ES crash due to missing MSR_EFER_LMA bit
From: Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, "Marcelo
 Tosatti" <mtosatti@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>, <kvm@vger.kernel.org>
To: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 5 Dec 2023 16:36:40 -0600
Message-ID: <170181580081.1152985.16205289171748051855@amd.com>
User-Agent: alot/0.9
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE33:EE_|PH7PR12MB8779:EE_
X-MS-Office365-Filtering-Correlation-Id: 9071019c-e9a4-460f-d88d-08dbf5e2b14d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DKeMiEdXANUjHHASXVn0cquWplJ/M0B9UoQ/STZ4zelkEEtAX//VPBvYbtfYvxbrLrza/MIdIgEQuwpkmPVG5qy9lAX9TyOj3OBVWWxObOfkLG1vSfNerssC37qrAX/r8gYKS6UCTTAQnUuQCRMUT6mxg30cfsyWqTUxVe2pScDdyd0Oex1ewLAucVgN9oxLX3T7y6vP7xrnwEgSe/3C4yb4pqGAXO59tCMDEfUjR0zEswXA0iXQ/ibYcVaU6xn1AqURYJwQPebDnNae7NvW5UjXbG+bmwapB1s9QP3c8H9a0GbVNp9aJD6hPIyjIQXe052YMHoeRjjFzsS9Y0w3Tha9tazcmEPuPpnFVAzjN03RI6tfPCA7enAcDM9VwBVjQONwq13ILyD8b3vGll/z5GY/D4EVoJWH4VKvdX051C6N3WPpcPpJP3RueGtjwnnZx8a8r7bZkffot+BkA7ewAL2bLoG/0Kl7ildIAKswLuJiLfii25zFaQBqhjv678SVxu6hOMyt2reFLKcZBgjKyjHojvl5CldvQ/R0z6DxPw7IHQZOZx2Ctd03dMP6fr5Bv2ehOxK6vxJqjJl5C3NRCOlfWA0BpY6ZWyUlnzyRsphXPA5CCA5zFztsMT3PTFV1uMk76DCVBuM2iF1QNLLxi7005cr0UaXyg4o4JUaSZSZn/1yhbpPSpny01GoYvAgaizF0W/55VuQj+af1YqGkTXgniVZOctwCB1Am6WbwFVQWkyAXP/gJbG0SYwvJspOuLzykq3NR9mBaKySCWPObCA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(346002)(136003)(396003)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(82310400011)(36840700001)(46966006)(40470700004)(40460700003)(44832011)(54906003)(8936002)(4326008)(8676002)(6916009)(316002)(86362001)(36756003)(478600001)(70586007)(70206006)(5660300002)(2906002)(41300700001)(36860700001)(356005)(47076005)(81166007)(82740400003)(26005)(2616005)(16526019)(6666004)(426003)(83380400001)(336012)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 22:36:58.1640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9071019c-e9a4-460f-d88d-08dbf5e2b14d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE33.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8779

Quoting Stefan Hajnoczi (2023-12-05 16:27:51)
> On Tue, 5 Dec 2023 at 17:12, Michael Roth <michael.roth@amd.com> wrote:
> >
> > Commit 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> > added error checking for KVM_SET_SREGS/KVM_SET_SREGS2. In doing so, it
> > exposed a long-running bug in current KVM support for SEV-ES where the
> > kernel assumes that MSR_EFER_LMA will be set explicitly by the guest
> > kernel, in which case EFER write traps would result in KVM eventually
> > seeing MSR_EFER_LMA get set and recording it in such a way that it would
> > be subsequently visible when accessing it via KVM_GET_SREGS/etc.
> >
> > However, guests kernels currently rely on MSR_EFER_LMA getting set
> > automatically when MSR_EFER_LME is set and paging is enabled via
> > CR0_PG_MASK. As a result, the EFER write traps don't actually expose the
> > MSR_EFER_LMA even though it is set internally, and when QEMU
> > subsequently tries to pass this EFER value back to KVM via
> > KVM_SET_SREGS* it will fail various sanity checks and return -EINVAL,
> > which is now considered fatal due to the aforementioned QEMU commit.
> >
> > This can be addressed by inferring the MSR_EFER_LMA bit being set when
> > paging is enabled and MSR_EFER_LME is set, and synthesizing it to ensure
> > the expected bits are all present in subsequent handling on the host
> > side.
> >
> > Ultimately, this handling will be implemented in the host kernel, but to
> > avoid breaking QEMU's SEV-ES support when using older host kernels, the
> > same handling can be done in QEMU just after fetching the register
> > values via KVM_GET_SREGS*. Implement that here.
>=20
> Hi Mike,
> I am holding off on tagging 8.2.0-rc3 for one day so agreement can be
> reached on how to proceed with this fix.

Thanks Stefan. Sorry for the late fix, but without it SEV-ES is
completely busted, so we're hoping it's simple/specific enough to justify
for hard-freeze.

Also, I just sent a v2 that adds similar handling for older kernels that
don't support KVM_SET_SREGS2.

-Mike

>=20
> Stefan
>=20
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
> > Cc: kvm@vger.kernel.org
> > Fixes: 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  target/i386/kvm/kvm.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > index 11b8177eff..0e9e4c1beb 100644
> > --- a/target/i386/kvm/kvm.c
> > +++ b/target/i386/kvm/kvm.c
> > @@ -3654,6 +3654,7 @@ static int kvm_get_sregs2(X86CPU *cpu)
> >  {
> >      CPUX86State *env =3D &cpu->env;
> >      struct kvm_sregs2 sregs;
> > +    target_ulong cr0_old;
> >      int i, ret;
> >
> >      ret =3D kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS2, &sregs);
> > @@ -3676,12 +3677,18 @@ static int kvm_get_sregs2(X86CPU *cpu)
> >      env->gdt.limit =3D sregs.gdt.limit;
> >      env->gdt.base =3D sregs.gdt.base;
> >
> > +    cr0_old =3D env->cr[0];
> >      env->cr[0] =3D sregs.cr0;
> >      env->cr[2] =3D sregs.cr2;
> >      env->cr[3] =3D sregs.cr3;
> >      env->cr[4] =3D sregs.cr4;
> >
> >      env->efer =3D sregs.efer;
> > +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> > +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> > +            env->efer |=3D MSR_EFER_LMA;
> > +        }
> > +    }
> >
> >      env->pdptrs_valid =3D sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
> >
> > --
> > 2.25.1
> >
> >

