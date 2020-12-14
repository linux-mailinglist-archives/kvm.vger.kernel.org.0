Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637FF2DA334
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 23:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395526AbgLNWDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 17:03:52 -0500
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:26085
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388570AbgLNWDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 17:03:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4p/UrnEWiJ6nZ0OrGoB32MGiV6c13NVCp2CGjemD+GdkFZGyj/TC8UF3X5usCYfyS4649K5OwhEckcn+tORoAbcveR6VulLDioCe08RQYsZKT+LXJ8zu6Op3QxC/7wFFQYYEFv1we6IvwhHG5Tg3bfp4Dycb9GRanxOeIXIYgtMcP6EfTsJzv4mCqtabeyA0iI8A3u+WVT31bsbOnxae5ir49uNJ6o+Uvw0umHZp9XVIWVLeCyOvuaUPDzsk/TYosy+iY8EeazgFhX14h4QJug5FCaVwO7Kg6m5U8QOPBDRahs1McgpvNXWppeWQIttOKZJln0lQVTSkKY1d02mMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRzKk8KxefKIq1Tj/LBR/MHV8C5l5s+943kG2QpYbBE=;
 b=liRP9OiNilProQ1HSSch9LEHuSiHRfPteYuG4S9aSu0zZ1eyLa2PeecqP6uaD3Z5dDMqmPotE81FVk/6R/cEL497wIXPYV/1c926EjFS0MCMj05+0QSTlEqVsPl/KGay5sq+J9IvPhnuW2z2WpxKLUvbU8dBbE3oUncmNo4pcQQl6VsAseSGtX4C2Orp7wGndDQo4M/j8NzYZXtpLdx6VTEeu0dIi7Qki8jhVvQrLOYWY/Tu2CyF26VWQKXFIoj4vX03wI/jPygae/7JzeJxhQLP9++8LJiDgmmkh+za2nDndGX/SouVj00nduwLWJbjsBh0SGHz1qkzhynOcEtX6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRzKk8KxefKIq1Tj/LBR/MHV8C5l5s+943kG2QpYbBE=;
 b=g7Tb3igAx9H1b08G/1qaozT+QX6KjpvWEoGntjHsSUoh+UARBjavStsYfw1eFq2ibOcc/AahQWVGmK4jyss1Ii2XbWKnuqzAItzUwdASg9wi9EqBsYe632aee11Wh7eVp3ucNB1O6npTIf3eIWG30JcEP4ezz0eJF2VDA5Q3KCk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from BY5PR12MB4131.namprd12.prod.outlook.com (2603:10b6:a03:212::13)
 by BY5PR12MB4935.namprd12.prod.outlook.com (2603:10b6:a03:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Mon, 14 Dec
 2020 22:02:56 +0000
Received: from BY5PR12MB4131.namprd12.prod.outlook.com
 ([fe80::2432:5fa6:a1f:61f0]) by BY5PR12MB4131.namprd12.prod.outlook.com
 ([fe80::2432:5fa6:a1f:61f0%4]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 22:02:56 +0000
Date:   Mon, 14 Dec 2020 16:02:13 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
Message-ID: <20201214220213.np7ytcxmm6xcyllm@amd.com>
References: <20201214174127.1398114-1-michael.roth@amd.com>
 <X9e/L3YTAT/N+ljh@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9e/L3YTAT/N+ljh@google.com>
X-Originating-IP: [165.204.54.211]
X-ClientProxiedBy: YT1PR01CA0134.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::13) To BY5PR12MB4131.namprd12.prod.outlook.com
 (2603:10b6:a03:212::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.54.211) by YT1PR01CA0134.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2f::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 22:02:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d4124e9b-0faf-4ddc-c444-08d8a07c0353
X-MS-TrafficTypeDiagnostic: BY5PR12MB4935:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB49354FB21B64EA5B17DF597895C70@BY5PR12MB4935.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G5hAL/jFsXFYABS4fztp0r9OBqmFKracFqviqSlPbCYNhipyTcshRx2q8UPqAD+YvhcMdowPDO82oK4tjwdokREEnQdKEH+dc2txFZ3yXAq3nyRziFebOtmzIZ9JRFt73cmusTBMThb2Q+ibbjfkZmQpACGU2htkFwzhaqfze4B7Ft0FKYrzqHee6T3/+6PgXcZNb7latbVewCTX3aFgIMYO5yplN62vLHSpXkKrw8c5pN74PQxYMdNZXKkUTiKVxwCMlsVmCWVh6JS+dEypDPQf1EQJTB1RBz8XxXCQ0vRWoc2D/fgwddBkuySYXdD/2qv4t2Mrp0ghTu/SaQvtyVsU3LEsiyPpv5XpwmUB84YUk8S4FZblN7QlfRvLvQ/G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(44832011)(86362001)(83380400001)(6666004)(956004)(2906002)(36756003)(508600001)(4326008)(2616005)(6916009)(8936002)(5660300002)(7416002)(34490700003)(186003)(16526019)(26005)(66476007)(66946007)(66556008)(1076003)(6486002)(52116002)(54906003)(6496006)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TA/ImLUk/h+3SxmE3qgw+UpNwkLmkr89ECEn0Rf+arWQdNf0bN3csv3R0qIF?=
 =?us-ascii?Q?J0PTsvkM9qweABgpZSvYtCJfFIUvf3VRvgNYV5myKspZKvCjAe4E9qjux649?=
 =?us-ascii?Q?yya0GeVToSPLnukNOdLi7CO7fxooCBtRHjH4zbsRFh7rAmPUO1vgYRKDStON?=
 =?us-ascii?Q?f0Eo8TLvHPJYOyoQVEVTjgm+3fqFl9HgrDj9NdZO/+Vnk/jJcuZRxhRV337a?=
 =?us-ascii?Q?dNvIOdLtSu6MI3V7fywK0YievCRGZI2FzOKUMY0mpnKk0iq8KeDVET97XEl3?=
 =?us-ascii?Q?viTuFC0DGHRbPSm5wVPB7ZFnEjmnVhJx9avzLck//cMceTpfN90zzFTgzOnZ?=
 =?us-ascii?Q?Fp4EePhZ9B8bbKgs59/TxvGGhZgmTIXEyOXVW2V+UeAoUnKBmvtQSdQ2s+4I?=
 =?us-ascii?Q?O3Ws5Sbm7SSiLM81pp075+Atop4lCRRRERAs5A37zzPdyvaJMz8T8oXJr8Pq?=
 =?us-ascii?Q?7g+I7DoC8hBpzr05hbB0Mh93d/jIhzcISqGmy0bYBDfCPuUw+Y8/ooH0MMPK?=
 =?us-ascii?Q?WnXspYEVJSBlv15XP6skejFFFmDN/1YByYonbLKPOF7ig/VbHEGzYY5Aakwz?=
 =?us-ascii?Q?NegHiMPAnrn5bGFpPo/lBCQJkFxk+ZSPGFPLIJR/4Qzy+4S/W7Nh1bh9I3IP?=
 =?us-ascii?Q?JO2E70u10zWAKQf39N801MtRQxhZ5p8pkdgHAeHSTjIFHlb4StAnEZwz53yQ?=
 =?us-ascii?Q?o5kvsgh2jQzwG6LVZPXFTAcu+irsxExiAcDgC3wkoL6RWvKx2qPxsCp4cH2x?=
 =?us-ascii?Q?T+WSW3AhLceShy6wSq0MYTBjj2/yrB5Ket0r60pPMu1nk6pEHp6x8Fz1Hn78?=
 =?us-ascii?Q?ZOP98Ix8/u1BhZwdO+ha3/R28Gok3eNRbC+8rc+elueGOMJbqoTJaOeo84dg?=
 =?us-ascii?Q?P75bznfp74+cuO4kD0x/XCujop7b/BOPbxH1FgiqgNwWPYucCxqPtdhCBIuq?=
 =?us-ascii?Q?oFPuVtcSU/W/bjY9aPCuOM9bGhnui++OJTTc0bCzjP/zePFoYEcgCGq0GEDq?=
 =?us-ascii?Q?D+In?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 22:02:56.4090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: d4124e9b-0faf-4ddc-c444-08d8a07c0353
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bjugM6bz25llb7QHl2nk3SldJ+tjhXuTbzM/8m83d8yAUow1+NwqE3FjNRo/am9MJk/FmQpTrowUFABYPTes1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4935
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 14, 2020 at 11:38:23AM -0800, Sean Christopherson wrote:
> +Andy, who provided a lot of feedback on v1.
> 
> On Mon, Dec 14, 2020, Michael Roth wrote:
> 
> Cc: Andy Lutomirski <luto@kernel.org>
> 
> > Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> > v2:
> > * rebase on latest kvm/next
> > * move VMLOAD to just after vmexit so we can use it to handle all FS/GS
> >   host state restoration and rather than relying on loadsegment() and
> >   explicit write to MSR_GS_BASE (Andy)
> > * drop 'host' field from struct vcpu_svm since it is no longer needed
> >   for storing FS/GS/LDT state (Andy)
> > ---
> >  arch/x86/kvm/svm/svm.c | 44 ++++++++++++++++--------------------------
> >  arch/x86/kvm/svm/svm.h | 14 +++-----------
> >  2 files changed, 20 insertions(+), 38 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 0e52fac4f5ae..fb15b7bd461f 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1367,15 +1367,19 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  		vmcb_mark_all_dirty(svm->vmcb);
> >  	}
> >  
> > -#ifdef CONFIG_X86_64
> > -	rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
> > -#endif
> > -	savesegment(fs, svm->host.fs);
> > -	savesegment(gs, svm->host.gs);
> > -	svm->host.ldt = kvm_read_ldt();
> > -
> > -	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
> > +	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
> >  		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
> > +	}

Hi Sean,

Hopefully I've got my email situation sorted out now...

> 
> Unnecessary change that violates preferred coding style.  Checkpatch explicitly
> complains about this.
> 
> WARNING: braces {} are not necessary for single statement blocks
> #132: FILE: arch/x86/kvm/svm/svm.c:1370:
> +	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
>  		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
> +

Sorry, that was an artifact from an earlier version of the patch that I
failed to notice. I'll make sure to run everything through checkpatch
going forward.

> 
> > +
> > +	asm volatile(__ex("vmsave")
> > +		     : : "a" (page_to_pfn(sd->save_area) << PAGE_SHIFT)
> 
> I'm pretty sure this can be page_to_phys().
> 
> > +		     : "memory");
> 
> I think we can defer this until we're actually planning on running the guest,
> i.e. put this in svm_prepare_guest_switch().

One downside to that is that we'd need to do the VMSAVE on every
iteration of vcpu_run(), as opposed to just once when we enter from
userspace via KVM_RUN. It ends up being a similar situation to Andy's
earlier suggestion of moving VMLOAD just after vmexit, but in that case
we were able to remove an MSR write to MSR_GS_BASE, which cancelled out
the overhead, but in this case I think it could only cost us extra.

It looks like the SEV-ES patches might land before this one, and those
introduce similar handling of VMSAVE in svm_vcpu_load(), so I think it
might also create some churn there if we take this approach and want to
keep the SEV-ES and non-SEV-ES handling similar.

> 
> > +	/*
> > +	 * Store a pointer to the save area to we can access it after
> > +	 * vmexit for vmload. This is needed since per-cpu accesses
> > +	 * won't be available until GS is restored as part of vmload
> > +	 */
> > +	svm->host_save_area = sd->save_area;
> 
> Unless I'm missing something with how SVM loads guest state, you can avoid
> adding host_save_area by saving the PA of the save area on the stack prior to
> the vmload of guest state.

Yes, that is much nicer. Not sure what I was thinking there.

> 
> >  
> >  	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
> >  		u64 tsc_ratio = vcpu->arch.tsc_scaling_ratio;
> > @@ -1403,18 +1407,10 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
> >  	avic_vcpu_put(vcpu);
> >  
> >  	++vcpu->stat.host_state_reload;
> > -	kvm_load_ldt(svm->host.ldt);
> > -#ifdef CONFIG_X86_64
> > -	loadsegment(fs, svm->host.fs);
> > -	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gsbase);
> > -	load_gs_index(svm->host.gs);
> > -#else
> > -#ifdef CONFIG_X86_32_LAZY_GS
> > -	loadsegment(gs, svm->host.gs);
> > -#endif
> > -#endif
> > -	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
> > +
> > +	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
> >  		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
> > +	}
> 
> Same bogus change and checkpatch warning.
> 
> >  }
> >  
> >  static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
> > @@ -3507,14 +3503,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> >  
> >  	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
> 
> Tying in with avoiding svm->host_save_area, what about passing in the PA of the
> save area and doing the vmload in __svm_vcpu_run()?  One less instance of inline
> assembly to stare at...

That sounds like a nice clean-up, I'll give this a shot.

> 
> >  
> > -#ifdef CONFIG_X86_64
> > -	native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
> > -#else
> > -	loadsegment(fs, svm->host.fs);
> > -#ifndef CONFIG_X86_32_LAZY_GS
> > -	loadsegment(gs, svm->host.gs);
> > -#endif
> > -#endif
> > +	asm volatile(__ex("vmload")
> > +		     : : "a" (page_to_pfn(svm->host_save_area) << PAGE_SHIFT));
> >  
> >  	/*
> >  	 * VMEXIT disables interrupts (host state), but tracing and lockdep
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index fdff76eb6ceb..bf01a8c19ec0 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -21,11 +21,6 @@
> >  #include <asm/svm.h>
> >  
> >  static const u32 host_save_user_msrs[] = {
> > -#ifdef CONFIG_X86_64
> > -	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
> > -	MSR_FS_BASE,
> > -#endif
> > -	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
> >  	MSR_TSC_AUX,
> 
> With this being whittled down to TSC_AUX, a good follow-on series would be to
> add SVM usage of the "user return" MSRs to handle TSC_AUX.  If no one objects,
> I'll plan on doing that in the not-too-distant future as a ramp task of sorts.

No objection here. I mainly held off on removing the list since it might be
nice to have some infrastructure to handle future cases, but if it's already
there then great :)

Thanks for the suggestions. I'll work on a v3 with those applied.

-Mike

> 
> >  };
> >  
> > @@ -117,12 +112,9 @@ struct vcpu_svm {
> >  	u64 next_rip;
> >  
> >  	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
> > -	struct {
> > -		u16 fs;
> > -		u16 gs;
> > -		u16 ldt;
> > -		u64 gs_base;
> > -	} host;
> > +
> > +	/* set by vcpu_load(), for use when per-cpu accesses aren't available */
> > +	struct page *host_save_area;
> >  
> >  	u64 spec_ctrl;
> >  	/*
> > -- 
> > 2.25.1
> > 
