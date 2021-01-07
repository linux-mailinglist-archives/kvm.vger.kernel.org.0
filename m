Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4EA2ED3A8
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 16:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbhAGPku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 10:40:50 -0500
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:32384
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725835AbhAGPku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 10:40:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQR/hn5WrON4JeZmm/ihqn8JhcuHcZp48MlMoVrFnLgZrvJrGOomIEx3H95rcsxNAXSl7truipVOr3DUbdF2UtuevsV8yhHagNPwnr1B79c4gBgdhbqih9y+e0Qq/Dxz2ukV0IE00TyBntWDr4hcSGI75Y7Bnz6WhafYCnloMZIMB0jCV0A4xStu7mzAOWNtUk7DgSrJdjDtyXVI2tWOmzaJkrAXtBJbFCdjJuC6EXsHVV1pSVO7Qkk09yEzm4HYCKn5ulOvX8oSCLjp5KcGcueKehli9dUWNPskDKU9g9KV5IYPUyPQ41jF5sTyx8J/sUbh8nUgMIaSxV8ZY4nxBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQjyXTjwqp/cTSaJxcr+I+8lHbK1BRfYWmcJ71ahc08=;
 b=SQ7voPg9EKKUfUTzET2lBvySwkHIXwCpY2AVsnxOmhPYKMwtVN5fR4k5dQGsxeQLoku4/5oe0yFHoiO0QRMZ82Zn4FufGdQjAMagHQpNqiAcs5TLhlaPGvBlIY8Xl8lzA4a58bURy++uK7B4t7trAJ+uYpicVSVvk0V0JA41u4GwL1YhNHS71Kd51h9+MMAWdiEHQS24f4AyRMbtMrSmPLdrw8SW7EfEUaVth6l7pk0tVqUR5ElhiN3nIiEX7XLnVwl7V5Zj3++S/85pVw7uPEbIrGFaev4vPKRmn0qasgCGT8KrDVd/e0kcTuP0whbSzC3A74DsmmqTo54VKZiSrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQjyXTjwqp/cTSaJxcr+I+8lHbK1BRfYWmcJ71ahc08=;
 b=rnK2Yhq6n5dVzA2m/HNC27gYr7Ftjj1oCrMjS4ryxVJFn/eXwHDMlGmv03QhZmqLIyAH/IKpt8mwNFE35WaRMA9ixBG5Dize1GAuuAAFOLc+Z9Z7i6hb16DNcOaTYtp7fRIISAIOY8eBMDbZBniPNKmzIUD3udem6+6FcXey2JE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3721.23; Thu, 7 Jan 2021 15:39:57 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3721.024; Thu, 7 Jan 2021
 15:39:57 +0000
Subject: Re: [PATCH v3 1/3] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20210105143749.557054-1-michael.roth@amd.com>
 <20210105143749.557054-2-michael.roth@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <ec0a6376-9879-2277-9943-0d73339aadbb@amd.com>
Date:   Thu, 7 Jan 2021 09:39:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210105143749.557054-2-michael.roth@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0501CA0050.namprd05.prod.outlook.com
 (2603:10b6:803:41::27) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0501CA0050.namprd05.prod.outlook.com (2603:10b6:803:41::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2 via Frontend Transport; Thu, 7 Jan 2021 15:39:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3b6b1b12-d93a-412e-0c7c-08d8b3227c66
X-MS-TrafficTypeDiagnostic: DM5PR12MB1355:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB13555A187D42CD150DA838F8ECAF0@DM5PR12MB1355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o7lbDvJflpgfW5qZ/38LDU/LTBgYbnAYlFFi6xhLv9MZ7zzBNI4D7o+oJDe4VBInnWNbo/xHKKrx8mER/FyCBGmWr7Fy8abqnZG64LFowBRxk3H+b2L9shxZWfxl6CXF+CVI0mpT/4J9qLTmlcvBJ20rsruvR4GaqK0C4e7L4+nAArlCQFBhoetyc+gOrxXyNLpu0sWfbdFAnTXQNwoTpPLYprdfQ2D+0Rbk5FBJCOWJGkNSwvVCruAxAVZcyZUlzerzLIP/Yh/JAhfhDxa4tF2Ld3j7Hbx+v5jNRvicVXwCmMfYfc9V6BU4+t2gMgG2sLBTaWdLyWSAeuLMRDO6G7FljzJopaEEE9ewgLfhv0z3nwNWfbsr1gib1EbPBY6i6R+Izvar/3qV+H1pwBOWU9AfomF3BLvwbzUs7xWrErJH3LwKgPahWMt9fywPeL9+ORf+MWZ70vf6QNcAecKCL+R9k+fSMjfEpncMKmCBPs0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(36756003)(86362001)(6506007)(186003)(66476007)(7416002)(16526019)(53546011)(31696002)(31686004)(83380400001)(2906002)(26005)(66556008)(66946007)(54906003)(52116002)(8936002)(478600001)(5660300002)(6486002)(956004)(2616005)(4326008)(8676002)(316002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SE81RWtjYjQ3Y1B4VFZKSVUzZ3VEM2J5dmgySlpCS1VKbGJibHFoTk10NHlt?=
 =?utf-8?B?WkEzQ0VTdkY3RlMvUUgzR1pxR2laVTk5TUxXYUNWc1A0MklGSDhNUll1NTNF?=
 =?utf-8?B?eVNuT0FTNjFnMThBM2svN3Nsc3JLV09pMzlxdlBMZWdtaytDQVNRVEVRUHFC?=
 =?utf-8?B?bXZjdGE0RHIxbHk2WjY4bG4vOFcvejVXeFlKRURTc2xvWmhsSDVqUEFaM1Bi?=
 =?utf-8?B?RSt2Mm5ieHJhSGx6SmVGUmhxM3I2aE9jbzVmeW4zK21oSmlXdU0vSkxsNVdF?=
 =?utf-8?B?bldwTTVOanF2NnVyRHhTeklzREpZYXVmSTVYRnFuYmxVbW1kRHlIK2x6c08r?=
 =?utf-8?B?VS9xMStqTW94aUlFaG5NdngyM2FUM0hxQjB2ZEorQWt6elZjOXdHV1RaSUNS?=
 =?utf-8?B?ZjB3YmxDWmxPaDRhMXlOOG5aNy9PaWdWbFVUKzFFRTl1UkcxSDFTbWg4b24z?=
 =?utf-8?B?NlVERzJPWWJYdG52clAxUll2S25aYlZ3NEJmd0hhY3hlcTM5WFVPdlJORkNS?=
 =?utf-8?B?Rm5KS0tpbHk4Kzh1eUpkeDNtWGVYMmdGK1BBV2Q4TlNxR2pSN05HNDVoTUs2?=
 =?utf-8?B?M1Z4azZMWXZRRE1lZUhpc0J5a3N3a1pHSHVUb1Z1TFZmZ2VzdGoyR0lSN2lO?=
 =?utf-8?B?NFZqa0dTTW1IL0xXc1d2K01ObnlxS01CZGQxcmRZd0QzMjZKeHVjV292eGNt?=
 =?utf-8?B?TkZuZkFQdVFacmwxZkNJdC9YTldvRHdpTUV1d1NXYm5jMjlYK1Q5R2Z0RHJC?=
 =?utf-8?B?VE1UWlNOM2ZmNC9RbXZiUi9SYkRVT0hPVjlQK2g4VVVNMndDcVY1U0xvOXkx?=
 =?utf-8?B?ZUVCN0VsMU4rVng4YlREbmxVNWRBd0R6MTAxdHZ2VlYwSi95SEo0ZTZOSkNE?=
 =?utf-8?B?Q2hDbVBTVExsZFVoVUVqdU1QcTRsdU9sYmdSSzg2Sy8vcGRCWlpRTTVlNmhZ?=
 =?utf-8?B?ZnBVOHlqSFcyQk5qZnFzUGE5RmFPZ3JYMVl1SzZWdncwVFJaNkpnelRNUkdh?=
 =?utf-8?B?NFdyeThtK21oc0FKaEszelFFNTFDTWYxR3cvYW5TRERFZjZib0hNUFU5ZXls?=
 =?utf-8?B?Szc5dWJZN2xhVXhyRkdiRUhtL01qWFZTcFlqcjgwOTlpamdxSU1MTGZtNG9x?=
 =?utf-8?B?NHQ1eWxrWXJSd2dFdDNyeFVHUStTLytCU1lPSHZpc3c5ZHNxZjdycGVSci9j?=
 =?utf-8?B?dHc0dDZ1Q0tkZVVIWWdjaVdsV1Vld2IzRkx5d1BZV1gxY3ZRNDlUNVZCS0R6?=
 =?utf-8?B?aEJJMDhMazFhaVNpVUpRMHF2SmdKd0s3VUcxSDJ3UDcyZnJoYXlmakZWMDBL?=
 =?utf-8?Q?LS2cKKzeXgFgCSTqsQR1gagdF52QV2fch+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 15:39:56.8638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6b1b12-d93a-412e-0c7c-08d8b3227c66
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5+RBQNiI8n0RY+UqRSbbefrhQqiFirZ2yawFFuJjCUEje2Mx2bFOCN6g1eeIIMHGGtEpgA+DK3JA2ownNcDzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1355
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/21 8:37 AM, Michael Roth wrote:
> Using a guest workload which simply issues 'hlt' in a tight loop to
> generate VMEXITs, it was observed (on a recent EPYC processor) that a
> significant amount of the VMEXIT overhead measured on the host was the
> result of MSR reads/writes in svm_vcpu_load/svm_vcpu_put according to
> perf:
> 
>    67.49%--kvm_arch_vcpu_ioctl_run
>            |
>            |--23.13%--vcpu_put
>            |          kvm_arch_vcpu_put
>            |          |
>            |          |--21.31%--native_write_msr
>            |          |
>            |           --1.27%--svm_set_cr4
>            |
>            |--16.11%--vcpu_load
>            |          |
>            |           --15.58%--kvm_arch_vcpu_load
>            |                     |
>            |                     |--13.97%--svm_set_cr4
>            |                     |          |
>            |                     |          |--12.64%--native_read_msr
> 
> Most of these MSRs relate to 'syscall'/'sysenter' and segment bases, and
> can be saved/restored using 'vmsave'/'vmload' instructions rather than
> explicit MSR reads/writes. In doing so there is a significant reduction
> in the svm_vcpu_load/svm_vcpu_put overhead measured for the above
> workload:
> 
>    50.92%--kvm_arch_vcpu_ioctl_run
>            |
>            |--19.28%--disable_nmi_singlestep
>            |
>            |--13.68%--vcpu_load
>            |          kvm_arch_vcpu_load
>            |          |
>            |          |--9.19%--svm_set_cr4
>            |          |          |
>            |          |           --6.44%--native_read_msr
>            |          |
>            |           --3.55%--native_write_msr
>            |
>            |--6.05%--kvm_inject_nmi
>            |--2.80%--kvm_sev_es_mmio_read
>            |--2.19%--vcpu_put
>            |          |
>            |           --1.25%--kvm_arch_vcpu_put
>            |                     native_write_msr
> 
> Quantifying this further, if we look at the raw cycle counts for a
> normal iteration of the above workload (according to 'rdtscp'),
> kvm_arch_vcpu_ioctl_run() takes ~4600 cycles from start to finish with
> the current behavior. Using 'vmsave'/'vmload', this is reduced to
> ~2800 cycles, a savings of 39%.
> 
> While this approach doesn't seem to manifest in any noticeable
> improvement for more realistic workloads like UnixBench, netperf, and
> kernel builds, likely due to their exit paths generally involving IO
> with comparatively high latencies, it does improve overall overhead
> of KVM_RUN significantly, which may still be noticeable for certain
> situations. It also simplifies some aspects of the code.
> 
> With this change, explicit save/restore is no longer needed for the
> following host MSRs, since they are documented[1] as being part of the
> VMCB State Save Area:
> 
>    MSR_STAR, MSR_LSTAR, MSR_CSTAR,
>    MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
>    MSR_IA32_SYSENTER_CS,
>    MSR_IA32_SYSENTER_ESP,
>    MSR_IA32_SYSENTER_EIP,
>    MSR_FS_BASE, MSR_GS_BASE
> 
> and only the following MSR needs individual handling in
> svm_vcpu_put/svm_vcpu_load:
> 
>    MSR_TSC_AUX
> 
> We could drop the host_save_user_msrs array/loop and instead handle
> MSR read/write of MSR_TSC_AUX directly, but we leave that for now as
> a potential follow-up.
> 
> Since 'vmsave'/'vmload' also handles the LDTR and FS/GS segment
> registers (and associated hidden state)[2], some of the code
> previously used to handle this is no longer needed, so we drop it
> as well.
> 
> The first public release of the SVM spec[3] also documents the same
> handling for the host state in question, so we make these changes
> unconditionally.
> 
> Also worth noting is that we 'vmsave' to the same page that is
> subsequently used by 'vmrun' to record some host additional state. This
> is okay, since, in accordance with the spec[2], the additional state
> written to the page by 'vmrun' does not overwrite any fields written by
> 'vmsave'. This has also been confirmed through testing (for the above
> CPU, at least).
> 
> [1] AMD64 Architecture Programmer's Manual, Rev 3.33, Volume 2, Appendix B, Table B-2
> [2] AMD64 Architecture Programmer's Manual, Rev 3.31, Volume 3, Chapter 4, VMSAVE/VMLOAD
> [3] Secure Virtual Machine Architecture Reference Manual, Rev 3.01
> 
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/kvm/svm/svm.c     | 36 +++++++-----------------------------
>   arch/x86/kvm/svm/svm.h     | 19 +------------------
>   arch/x86/kvm/svm/vmenter.S | 10 ++++++++++
>   3 files changed, 18 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 941e5251e13f..7a7e9b7d47a7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1420,16 +1420,12 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	if (sev_es_guest(svm->vcpu.kvm)) {
>   		sev_es_vcpu_load(svm, cpu);
>   	} else {
> -#ifdef CONFIG_X86_64
> -		rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
> -#endif
> -		savesegment(fs, svm->host.fs);
> -		savesegment(gs, svm->host.gs);
> -		svm->host.ldt = kvm_read_ldt();
> -
>   		for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
>   			rdmsrl(host_save_user_msrs[i].index,
>   			       svm->host_user_msrs[i]);
> +
> +		asm volatile(__ex("vmsave %%"_ASM_AX)
> +			     : : "a" (page_to_phys(sd->save_area)) : "memory");
>   	}
>   
>   	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
> @@ -1461,17 +1457,6 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
>   	if (sev_es_guest(svm->vcpu.kvm)) {
>   		sev_es_vcpu_put(svm);
>   	} else {
> -		kvm_load_ldt(svm->host.ldt);
> -#ifdef CONFIG_X86_64
> -		loadsegment(fs, svm->host.fs);
> -		wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gsbase);
> -		load_gs_index(svm->host.gs);
> -#else
> -#ifdef CONFIG_X86_32_LAZY_GS
> -		loadsegment(gs, svm->host.gs);
> -#endif
> -#endif
> -
>   		for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
>   			wrmsrl(host_save_user_msrs[i].index,
>   			       svm->host_user_msrs[i]);
> @@ -3675,7 +3660,7 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>   	return EXIT_FASTPATH_NONE;
>   }
>   
> -void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
> +void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs, unsigned long hostsa_pa);

There was a follow on fix patch to remove this forward declaration since, 
for SEV-ES, I had moved it into svm.h without deleting it here. I'm not 
sure when it will hit Paolo's tree.

Thanks,
Tom

>   
>   static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>   					struct vcpu_svm *svm)
> @@ -3703,16 +3688,9 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>   	if (sev_es_guest(svm->vcpu.kvm)) {
>   		__svm_sev_es_vcpu_run(svm->vmcb_pa);
>   	} else {
> -		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
> -
> -#ifdef CONFIG_X86_64
> -		native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
> -#else
> -		loadsegment(fs, svm->host.fs);
> -#ifndef CONFIG_X86_32_LAZY_GS
> -		loadsegment(gs, svm->host.gs);
> -#endif
> -#endif
> +		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs,
> +			       page_to_phys(per_cpu(svm_data,
> +						    vcpu->cpu)->save_area));
>   	}
>   
>   	/*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5431e6335e2e..1f4460508036 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -27,17 +27,6 @@ static const struct svm_host_save_msrs {
>   	u32 index;		/* Index of the MSR */
>   	bool sev_es_restored;	/* True if MSR is restored on SEV-ES VMEXIT */
>   } host_save_user_msrs[] = {
> -#ifdef CONFIG_X86_64
> -	{ .index = MSR_STAR,			.sev_es_restored = true },
> -	{ .index = MSR_LSTAR,			.sev_es_restored = true },
> -	{ .index = MSR_CSTAR,			.sev_es_restored = true },
> -	{ .index = MSR_SYSCALL_MASK,		.sev_es_restored = true },
> -	{ .index = MSR_KERNEL_GS_BASE,		.sev_es_restored = true },
> -	{ .index = MSR_FS_BASE,			.sev_es_restored = true },
> -#endif
> -	{ .index = MSR_IA32_SYSENTER_CS,	.sev_es_restored = true },
> -	{ .index = MSR_IA32_SYSENTER_ESP,	.sev_es_restored = true },
> -	{ .index = MSR_IA32_SYSENTER_EIP,	.sev_es_restored = true },
>   	{ .index = MSR_TSC_AUX,			.sev_es_restored = false },
>   };
>   #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
> @@ -130,12 +119,6 @@ struct vcpu_svm {
>   	u64 next_rip;
>   
>   	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
> -	struct {
> -		u16 fs;
> -		u16 gs;
> -		u16 ldt;
> -		u64 gs_base;
> -	} host;
>   
>   	u64 spec_ctrl;
>   	/*
> @@ -595,6 +578,6 @@ void sev_es_vcpu_put(struct vcpu_svm *svm);
>   /* vmenter.S */
>   
>   void __svm_sev_es_vcpu_run(unsigned long vmcb_pa);
> -void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
> +void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs, unsigned long hostsa_pa);
>   
>   #endif
> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index 6feb8c08f45a..89f4e8e7bf0e 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -33,6 +33,7 @@
>    * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
>    * @vmcb_pa:	unsigned long
>    * @regs:	unsigned long * (to guest registers)
> + * @hostsa_pa:	unsigned long
>    */
>   SYM_FUNC_START(__svm_vcpu_run)
>   	push %_ASM_BP
> @@ -47,6 +48,9 @@ SYM_FUNC_START(__svm_vcpu_run)
>   #endif
>   	push %_ASM_BX
>   
> +	/* Save @hostsa_pa */
> +	push %_ASM_ARG3
> +
>   	/* Save @regs. */
>   	push %_ASM_ARG2
>   
> @@ -154,6 +158,12 @@ SYM_FUNC_START(__svm_vcpu_run)
>   	xor %r15d, %r15d
>   #endif
>   
> +	/* "POP" @hostsa_pa to RAX. */
> +	pop %_ASM_AX
> +
> +	/* Restore host user state and FS/GS base */
> +	vmload %_ASM_AX
> +
>   	pop %_ASM_BX
>   
>   #ifdef CONFIG_X86_64
> 
