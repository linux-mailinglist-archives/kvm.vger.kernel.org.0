Return-Path: <kvm+bounces-3739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E89008076D1
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:43:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65A1E1F215CA
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F4786AB93;
	Wed,  6 Dec 2023 17:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mI6bisCT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2044.outbound.protection.outlook.com [40.107.100.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5334E137
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 09:43:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RuEN2pKMMkQtL0XoL9+D9d2eaY3uuFkwmXxwAmss3R2XTgCH714JfHSIOvgq1IS5Qk7Vlb3/F8ZKIaOpQpkA6NkUYdx314wObieuDdWmUf/eieR9YwOIw8n9ZBanYo+fBYyKY0NJ5MD8Enr1Qlk0Bt+XqqnMtsWxmRPywfP6I4cpf5fhEtmrT/sJhxBGs2sPHyjrjX8LCceZZXp9/1RAteOPZpD+9NuMM71RHmNlclAjQShVANMewzN3KCXGyA+xk1W+bL99bcpW4YqwH2fVlYYFVPxAeLnPz1cd5rVAcs3rvJ0hOPq5yD3RZ/iGKJmP6IboECwS3s2OE5EicvGl8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hxZO/xiJjij2roiaiMfBBVHXPXh/BGOFsGEPm46RZ6E=;
 b=jgbm91Y2ocxYvGdEAy84kquEUL2lM0BTVS0rLzDoNkaR6F9ZW4z0mZhZOGucySfT0q5pV37T85ThPzjhCe8uEcBmyuCkrhQ5HOYUdP0Xr0wsjDjbMQXtO5lHI/3mX66RMciKazfeWYvUrMNGwS3m2Ek9GVmsvPl7F6YRgvm9cVawD/d76zsLiTmDVF8KV2UlqnBEWYIOpnnB6k8e5yJ1YVyBya4g8hnJzOk4A31mxUM0exdqUv6Ii4IP+26DM6uHsEe4Gg4GmQpFVnuLt+jBikjt34nW5iakSsPVdOXocSa3p+f2zcXga4qNtZ5It8ZXoNd9CmNPJUXBdVPCwR1/bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxZO/xiJjij2roiaiMfBBVHXPXh/BGOFsGEPm46RZ6E=;
 b=mI6bisCTW1q/IKde67eQRHt7hXAWeXA1m1yVggjPOmsc/LQeYHZwE7gZTVN0fsDgBnQKvgOo1ISwWtLdocTIFa0o1PU9p8jagPNiNFtvSM4TtbWB2wxN/lkMiRTDJM3HLu95X5sx5/X1OoHdNCKZB3W80byuDn6XRSK25twDuiY=
Received: from CH0PR03CA0026.namprd03.prod.outlook.com (2603:10b6:610:b0::31)
 by DS7PR12MB5816.namprd12.prod.outlook.com (2603:10b6:8:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 17:42:53 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:610:b0:cafe::f5) by CH0PR03CA0026.outlook.office365.com
 (2603:10b6:610:b0::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Wed, 6 Dec 2023 17:42:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7068.20 via Frontend Transport; Wed, 6 Dec 2023 17:42:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 6 Dec
 2023 11:42:52 -0600
Date: Wed, 6 Dec 2023 11:42:35 -0600
From: Michael Roth <michael.roth@amd.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, "Marcelo
 Tosatti" <mtosatti@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 for-8.2?] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
Message-ID: <20231206174235.b7fwrqzko27of7qz@amd.com>
References: <20231205222816.1152720-1-michael.roth@amd.com>
 <9eae0513c912faa04a11db378ea3ca176ab45f0d.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9eae0513c912faa04a11db378ea3ca176ab45f0d.camel@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|DS7PR12MB5816:EE_
X-MS-Office365-Filtering-Correlation-Id: 6662ecdc-f656-4c01-862b-08dbf682c633
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nEw84czKZIli6Iw6oTePQlhJb1vthjT6h8uPsgNA7pM1obShxu5R+1xk+AJ+QAobOHdvYRnWOcXkpy81Xi5T3vxSEzs1KCaTEmjdCTMfw6sZBepJDM+NPj2vTzpUW15/9f4NY65IusXFM5A78EGn/IsR+f6jhKqSTAy26YZqkL+3YVPV+70qOtuMwLIJEstnABKuqeX34ko5GB0stbSsG9vlla5xuMCIb6EhvTvBJOiw5exzKamHZdUhscU/iOBDcP9lcFo/LV3iGO59oaRBSUUiQABIYfBaZueJLkUfQNCfS1rXKrwWJTl1FFLVOMPg0v6LugX1pdUTgOLg315oGdh6mnv2hXrIBLiQANGzRzS8KnrBI1zcN0zZ1ptg7HqtRMbqVM2r9AqeAK1vlGxQKaf7qJfzyXfcbh8ZKX1mIZnRgQ29LfjA2m4scvuDFu7qwN62Kzh6iawIDjU0+VO6gYha7YuLeNhFvE12FYFH38YweFZz5G022wO0Is1bPCzOrSGwFEr4ouGio/NcEXFDfS6PRDkOf4ajzpShEng0UZ+tf4ZEaYphHS9rgrn/huXUUN6P1Cnb55DkTAJROKT3o/P7IRUFbU4h6A/eiGT+C0fJ7hgQs0Za8WeZdD/AVrFffBz95Z6pvK4ehNpFaer9HvwVcHb95y5SckrOI1JbLtJUrFfRkBMpiWgYLivTh+8LBzDSW6zawWN4s73VW+mSvCQCNqYEi9TOTp7/ca2PCvMwJ/hmxBUgsgm9ETbK85vI
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(39860400002)(376002)(396003)(230922051799003)(1800799012)(82310400011)(186009)(451199024)(64100799003)(40470700004)(36840700001)(46966006)(36860700001)(47076005)(44832011)(356005)(81166007)(82740400003)(5660300002)(6666004)(86362001)(36756003)(8676002)(8936002)(4326008)(41300700001)(40480700001)(2906002)(426003)(26005)(40460700003)(83380400001)(1076003)(70206006)(70586007)(2616005)(478600001)(316002)(336012)(16526019)(6916009)(54906003)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:42:53.3722
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6662ecdc-f656-4c01-862b-08dbf682c633
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5816

On Wed, Dec 06, 2023 at 07:20:14PM +0200, Maxim Levitsky wrote:
> On Tue, 2023-12-05 at 16:28 -0600, Michael Roth wrote:
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
> > 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
> > Cc: kvm@vger.kernel.org
> > Fixes: 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> > v2:
> >   - Add handling for KVM_GET_SREGS, not just KVM_GET_SREGS2
> > 
> >  target/i386/kvm/kvm.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > index 11b8177eff..8721c1bf8f 100644
> > --- a/target/i386/kvm/kvm.c
> > +++ b/target/i386/kvm/kvm.c
> > @@ -3610,6 +3610,7 @@ static int kvm_get_sregs(X86CPU *cpu)
> >  {
> >      CPUX86State *env = &cpu->env;
> >      struct kvm_sregs sregs;
> > +    target_ulong cr0_old;
> >      int ret;
> >  
> >      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS, &sregs);
> > @@ -3637,12 +3638,18 @@ static int kvm_get_sregs(X86CPU *cpu)
> >      env->gdt.limit = sregs.gdt.limit;
> >      env->gdt.base = sregs.gdt.base;
> >  
> > +    cr0_old = env->cr[0];
> >      env->cr[0] = sregs.cr0;
> >      env->cr[2] = sregs.cr2;
> >      env->cr[3] = sregs.cr3;
> >      env->cr[4] = sregs.cr4;
> >  
> >      env->efer = sregs.efer;
> > +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> > +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> > +            env->efer |= MSR_EFER_LMA;
> > +        }
> > +    }
> 
> I think that we should not check that CR0_PG has changed, and just blindly assume
> that if EFER.LME is set and CR0.PG is set, then EFER.LMA must be set as defined in x86 spec.
> 
> Otherwise, suppose qemu calls kvm_get_sregs twice: First time it will work,
> but second time CR0.PG will match one that is stored in the env, and thus the workaround
> will not be executed, and instead we will revert back to wrong EFER value 
> reported by the kernel.
> 
> How about something like that:
> 
> 
> if (sev_es_enabled() && env->efer & MSR_EFER_LME && env->cr[0] & CR0_PG_MASK) {
> 	/* 
>          * Workaround KVM bug, because of which KVM might not be aware of the 
>          * fact that EFER.LMA was toggled by the hardware 
>          */
> 	env->efer |= MSR_EFER_LMA;
> }

Hi Maxim,

I'd already sent a v3 based on a similar suggestion from Paolo:

  https://lists.gnu.org/archive/html/qemu-devel/2023-12/msg00751.html

Does that one look okay to you?

Thanks,

Mike

> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> >  
> >      /* changes to apic base and cr8/tpr are read back via kvm_arch_post_run */
> >      x86_update_hflags(env);
> > @@ -3654,6 +3661,7 @@ static int kvm_get_sregs2(X86CPU *cpu)
> >  {
> >      CPUX86State *env = &cpu->env;
> >      struct kvm_sregs2 sregs;
> > +    target_ulong cr0_old;
> >      int i, ret;
> >  
> >      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS2, &sregs);
> > @@ -3676,12 +3684,18 @@ static int kvm_get_sregs2(X86CPU *cpu)
> >      env->gdt.limit = sregs.gdt.limit;
> >      env->gdt.base = sregs.gdt.base;
> >  
> > +    cr0_old = env->cr[0];
> >      env->cr[0] = sregs.cr0;
> >      env->cr[2] = sregs.cr2;
> >      env->cr[3] = sregs.cr3;
> >      env->cr[4] = sregs.cr4;
> >  
> >      env->efer = sregs.efer;
> > +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> > +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> > +            env->efer |= MSR_EFER_LMA;
> > +        }
> > +    }
> >  
> >      env->pdptrs_valid = sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
> >  
> 
> 

