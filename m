Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A133A2700B9
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 17:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgIRPQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 11:16:32 -0400
Received: from mail-dm6nam10on2080.outbound.protection.outlook.com ([40.107.93.80]:45536
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726309AbgIRPQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 11:16:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MeJdK/oXy5wyT3sT3x2Sv+ymdMkjUkMOmtKGSUWnAYi4SeYkMsAbTs4Jie52UCz/h2z25u6YIkGwRZmIKCMcRGEcmU53bMZmT4mY6MfcBHTmSbRHqrt+h4nOe+tUh7/d2B29nSbcQLuAsuv2GuUFISPyXMGwBxE/fNPS/fpUhKmCsfcI7wx1xXDVFUeklWvI6YU+pHNBbcFR+3bE3wuWnCb99dKOJikrgt21sBDMSGFccrg+l9jvQOub3kJgn70Pe0/yloF0lM7L3zs9S8sjyFP+DcLJvPh7emAj57BWMK3+buxSAGMlQyIUuWniWoFXvxxi8Rpz01q17WzDFGrGzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKcAac6khMUsEhH0mLvXPuuc1/Y/kMvpW0H+47y7T6o=;
 b=NOgAn+hmuKHJSilUBNBc2WgQirBpVwu+pyptH9+W8+W0nwM3YLySxGalarLjjKvMmqVFygKb16jclOFH9gHeMkmWKG2/YRmC0exK6Zp1gz7ESxpl63elkS+gU5uJoiV+D1Mt1lWXqx18UHQYVqbkX55wmggStRK52lN+SQDMhRDQjOMFaHBf+DwPoK6GUWXEyHUBmQNgIhmh3OXU3iZyF6xP3Tj452wCTyl3+YYedKFEoNLKKWD9nTgt4OFht3CsNaWht9GeqE7+BLzzoeflrIGg1m6AL/rx7zi152k9XWZXZHMOpv5xYcsw1hZGilhRTdwJ8tAK8vEVTlRctjQ+0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKcAac6khMUsEhH0mLvXPuuc1/Y/kMvpW0H+47y7T6o=;
 b=DMqhiDHEPMHdodGUqWunoPv5R25y/BU8rM79OQp64LWm6DylqzrcY9EAK5DjjmVWmFKbdijwAjc/8Jh1VAq61bsKQyfD6yqx2nXSzpRy2lruKRLtiN07sXzcNUQRyXMNsO24n/rdMsMW3728rsfHbeKM6Hbc13HXwyqxbKJDNNM=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2384.namprd12.prod.outlook.com (2603:10b6:802:25::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Fri, 18 Sep
 2020 15:16:19 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 15:16:19 +0000
Subject: RE: [PATCH] KVM: SVM: Use a separate vmcb for the nested L2 guest
To:     Cathy Avery <cavery@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>
References: <20200917192306.2080-1-cavery@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <dfa82668-65eb-f5ac-56c2-87ae9d007c46@amd.com>
Date:   Fri, 18 Sep 2020 10:16:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200917192306.2080-1-cavery@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:806:d2::30) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SA0PR11CA0085.namprd11.prod.outlook.com (2603:10b6:806:d2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Fri, 18 Sep 2020 15:16:18 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fbe250a2-0688-4ac1-5d4e-08d85be5cb29
X-MS-TrafficTypeDiagnostic: SN1PR12MB2384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB238469935763BAED954E15A3953F0@SN1PR12MB2384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6D7hlY1tGKUMAYTGd6EquNgPM3+4uZMoNo2N4Jxs7yniXnbpqd9+2qhngVHpxw5dGCgyu3hVDGsayP5rNYnn+IGVeJx9cV0tC1V/e33znwJqUGarsqvyzwmPiXIKPhKsEyj5ELfmLYKeYImBGPiYUwfgsXQ6gUafH9+3x7jIPY/ropwtsDFwYn4hPOtFKnhcy21HwWlI2gcsu1+2+JVjECqCv99BoyIu29PW5Non9RJ0oQ/dnwBx2RNp7XWKZcJGaAIMsyaX//3acUK4Vqt8IVE6OjznLmLa5yuQT2mxhCAOuNrDQHzkXIPQpnktpxxReaxyTSXLJHK0ONj9z/K6aLw4Q64MUQKuGPoBiawfqJp0b1RJSqxhJa3crSwHmaAYx8KSbGUyMqXe2dEsQFxAwBcfiGXhv/QrUfG3uNWT7vIliZpTbOjl/XgRORjiknCl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(2906002)(66946007)(66476007)(66556008)(44832011)(30864003)(5660300002)(316002)(16576012)(53546011)(8676002)(110136005)(478600001)(4326008)(31696002)(54906003)(6486002)(8936002)(86362001)(2616005)(956004)(16526019)(36756003)(83380400001)(52116002)(186003)(26005)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: idga8It4UsrX5nr6IfdyFnU+O53yV+jUmADEhfMEqLozEHKJ+P7AgVMha1SiXGeQHiFgtGqRAQ9O26m/uExDOyER+B4pkEw1WIz8fYQOKkhNU4biEQuDEY8JLdaYfuGQ1E1OP3//cSgJbIcqu5EARtYkZTY8kQeHc1V+ZfXPUk2gmko3b6cTE5aT1CyWopOE4jCS8DiqCxcYTOWS/McGm+gWCL2pwd9DVUqbnBUmmS8Umi7XlHn7goFUHrKuAmoIAInHTUwpIOFVgRMoPhe+iCfs7RsVUz6+Nu4sJ5zFy5EjIKYjCtAvp5vhZgNSd0pp8BSalJ5bBqnH3fY3Jd9BOu14t37nFau9t5JeBazhQsPXU2+zNwZVuN1VZl+A4DyyX8SPtc+3Pug0B3tU1BCfOb6PH9Z9VqjunzKvp8EQS13Y74M8sHBJNppf8NaeZsmTpDggb98aAEQd0LSxf6lIn4bcQa7zhhUrbQ1ODTJGnLxNrm6deDRSE2PNkaTmgSFllEU5XyHVUgSdDGhU9HcvTPeRrQcFFsxl/ZaNhCdocHmjy4hzXXAe8w/0FsnJdfLFHi8cM5dtk8yGFR/2r0Ps/dkwmqb8CiG5tK1cnsn1aOJmqQOVNS6uMA7kyy7EYzfKKqqTQtrRBb4xTSyX/LfjPg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe250a2-0688-4ac1-5d4e-08d85be5cb29
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 15:16:19.1446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gELLR1S50RZQcmISs6tCDJ8l1tWErgWRWhsZFoS3BzAd9/TAEzffTgyzylg1QhUx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cathy,
Thanks for the patches. It cleans up the code nicely.
But there are some issues with the patch. I was able to bring the L1 guest
with your patch. But when I tried to load L2 guest it crashed. I am
thinking It is mostly due to save/restore part of vmcb. Few comments below.

> -----Original Message-----
> From: Cathy Avery <cavery@redhat.com>
> Sent: Thursday, September 17, 2020 2:23 PM
> To: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; pbonzini@redhat.com
> Cc: vkuznets@redhat.com; Huang2, Wei <Wei.Huang2@amd.com>
> Subject: [PATCH] KVM: SVM: Use a separate vmcb for the nested L2 guest
> 
> svm->vmcb will now point to either a separate vmcb L1 ( not nested ) or L2 vmcb
> ( nested ).
> 
> Issues:
> 
> 1) There is some wholesale copying of vmcb.save and vmcb.contol
>    areas which will need to be refined.
> 
> 2) There is a workaround in nested_svm_vmexit() where
> 
>    if (svm->vmcb01->control.asid == 0)
>        svm->vmcb01->control.asid = svm->nested.vmcb02->control.asid;
> 
>    This was done as a result of the kvm selftest 'state_test'. In that
>    test svm_set_nested_state() is called before svm_vcpu_run().
>    The asid is assigned by svm_vcpu_run -> pre_svm_run for the current
>    vmcb which is now vmcb02 as we are in nested mode subsequently
>    vmcb01.control.asid is never set as it should be.
> 
> Tested:
> kvm-unit-tests
> kvm self tests
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 116 ++++++++++++++++++--------------------
>  arch/x86/kvm/svm/svm.c    |  41 +++++++-------
>  arch/x86/kvm/svm/svm.h    |  10 ++--
>  3 files changed, 81 insertions(+), 86 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c index
> e90bc436f584..0a06e62010d8 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -75,12 +75,12 @@ static unsigned long nested_svm_get_tdp_cr3(struct
> kvm_vcpu *vcpu)  static void nested_svm_init_mmu_context(struct kvm_vcpu
> *vcpu)  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> -	struct vmcb *hsave = svm->nested.hsave;
> 
>  	WARN_ON(mmu_is_nested(vcpu));
> 
>  	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
> -	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, hsave->save.cr4,
> hsave->save.efer,
> +	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, svm->vmcb01-
> >save.cr4,
> +				svm->vmcb01->save.efer,
>  				svm->nested.ctl.nested_cr3);
>  	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
>  	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
> @@ -105,7 +105,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  		return;
> 
>  	c = &svm->vmcb->control;
> -	h = &svm->nested.hsave->control;
> +	h = &svm->vmcb01->control;
>  	g = &svm->nested.ctl;
> 
>  	svm->nested.host_intercept_exceptions = h->intercept_exceptions;
> @@ -403,7 +403,7 @@ static void nested_prepare_vmcb_control(struct
> vcpu_svm *svm)
> 
>  	svm->vmcb->control.int_ctl             =
>  		(svm->nested.ctl.int_ctl & ~mask) |
> -		(svm->nested.hsave->control.int_ctl & mask);
> +		(svm->vmcb01->control.int_ctl & mask);
> 
>  	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
>  	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
> @@ -432,6 +432,12 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64
> vmcb_gpa,
>  	int ret;
> 
>  	svm->nested.vmcb = vmcb_gpa;
> +
> +	WARN_ON(svm->vmcb == svm->nested.vmcb02);
> +
> +	svm->nested.vmcb02->control = svm->vmcb01->control;
> +	svm->vmcb = svm->nested.vmcb02;
> +	svm->vmcb_pa = svm->nested.vmcb02_pa;
>  	load_nested_vmcb_control(svm, &nested_vmcb->control);
>  	nested_prepare_vmcb_save(svm, nested_vmcb);
>  	nested_prepare_vmcb_control(svm);
> @@ -450,8 +456,6 @@ int nested_svm_vmrun(struct vcpu_svm *svm)  {
>  	int ret;
>  	struct vmcb *nested_vmcb;
> -	struct vmcb *hsave = svm->nested.hsave;
> -	struct vmcb *vmcb = svm->vmcb;
>  	struct kvm_host_map map;
>  	u64 vmcb_gpa;
> 
> @@ -496,29 +500,17 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>  	kvm_clear_exception_queue(&svm->vcpu);
>  	kvm_clear_interrupt_queue(&svm->vcpu);
> 
> -	/*
> -	 * Save the old vmcb, so we don't need to pick what we save, but can
> -	 * restore everything when a VMEXIT occurs
> -	 */
> -	hsave->save.es     = vmcb->save.es;
> -	hsave->save.cs     = vmcb->save.cs;
> -	hsave->save.ss     = vmcb->save.ss;
> -	hsave->save.ds     = vmcb->save.ds;
> -	hsave->save.gdtr   = vmcb->save.gdtr;
> -	hsave->save.idtr   = vmcb->save.idtr;
> -	hsave->save.efer   = svm->vcpu.arch.efer;
> -	hsave->save.cr0    = kvm_read_cr0(&svm->vcpu);
> -	hsave->save.cr4    = svm->vcpu.arch.cr4;
> -	hsave->save.rflags = kvm_get_rflags(&svm->vcpu);
> -	hsave->save.rip    = kvm_rip_read(&svm->vcpu);
> -	hsave->save.rsp    = vmcb->save.rsp;
> -	hsave->save.rax    = vmcb->save.rax;
> -	if (npt_enabled)
> -		hsave->save.cr3    = vmcb->save.cr3;
> -	else
> -		hsave->save.cr3    = kvm_read_cr3(&svm->vcpu);
> -
> -	copy_vmcb_control_area(&hsave->control, &vmcb->control);

You may have to carefully check the above cleanup.

> +
> +	/* Update vmcb0. We will restore everything when a VMEXIT occurs */
> +
> +	svm->vmcb01->save.efer   = svm->vcpu.arch.efer;
> +	svm->vmcb01->save.cr0    = kvm_read_cr0(&svm->vcpu);
> +	svm->vmcb01->save.cr4    = svm->vcpu.arch.cr4;
> +	svm->vmcb01->save.rflags = kvm_get_rflags(&svm->vcpu);
> +	svm->vmcb01->save.rip    = kvm_rip_read(&svm->vcpu);
> +
> +	if (!npt_enabled)
> +		svm->vmcb01->save.cr3 = kvm_read_cr3(&svm->vcpu);
> 
>  	svm->nested.nested_run_pending = 1;
> 
> @@ -564,7 +556,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)  {
>  	int rc;
>  	struct vmcb *nested_vmcb;
> -	struct vmcb *hsave = svm->nested.hsave;
>  	struct vmcb *vmcb = svm->vmcb;
>  	struct kvm_host_map map;
> 
> @@ -628,8 +619,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	nested_vmcb->control.pause_filter_thresh =
>  		svm->vmcb->control.pause_filter_thresh;
> 
> -	/* Restore the original control entries */
> -	copy_vmcb_control_area(&vmcb->control, &hsave->control);
> +	if (svm->vmcb01->control.asid == 0)
> +		svm->vmcb01->control.asid = svm->nested.vmcb02-
> >control.asid;
> +
> +	svm->vmcb = svm->vmcb01;
> +	svm->vmcb_pa = svm->nested.vmcb01_pa;
> 
>  	/* On vmexit the  GIF is set to false */
>  	svm_set_gif(svm, false);
> @@ -640,19 +634,13 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	svm->nested.ctl.nested_cr3 = 0;
> 
>  	/* Restore selected save entries */
> -	svm->vmcb->save.es = hsave->save.es;
> -	svm->vmcb->save.cs = hsave->save.cs;
> -	svm->vmcb->save.ss = hsave->save.ss;
> -	svm->vmcb->save.ds = hsave->save.ds;
> -	svm->vmcb->save.gdtr = hsave->save.gdtr;
> -	svm->vmcb->save.idtr = hsave->save.idtr;
> -	kvm_set_rflags(&svm->vcpu, hsave->save.rflags);
> -	svm_set_efer(&svm->vcpu, hsave->save.efer);
> -	svm_set_cr0(&svm->vcpu, hsave->save.cr0 | X86_CR0_PE);
> -	svm_set_cr4(&svm->vcpu, hsave->save.cr4);
> -	kvm_rax_write(&svm->vcpu, hsave->save.rax);
> -	kvm_rsp_write(&svm->vcpu, hsave->save.rsp);
> -	kvm_rip_write(&svm->vcpu, hsave->save.rip);
> +	kvm_set_rflags(&svm->vcpu, svm->vmcb->save.rflags);
> +	svm_set_efer(&svm->vcpu, svm->vmcb->save.efer);
> +	svm_set_cr0(&svm->vcpu, svm->vmcb->save.cr0 | X86_CR0_PE);
> +	svm_set_cr4(&svm->vcpu, svm->vmcb->save.cr4);
> +	kvm_rax_write(&svm->vcpu, svm->vmcb->save.rax);
> +	kvm_rsp_write(&svm->vcpu, svm->vmcb->save.rsp);
> +	kvm_rip_write(&svm->vcpu, svm->vmcb->save.rip);
>  	svm->vmcb->save.dr7 = 0;
>  	svm->vmcb->save.cpl = 0;
>  	svm->vmcb->control.exit_int_info = 0;
> @@ -670,12 +658,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> 
>  	nested_svm_uninit_mmu_context(&svm->vcpu);
> 
> -	rc = nested_svm_load_cr3(&svm->vcpu, hsave->save.cr3, false);
> +	rc = nested_svm_load_cr3(&svm->vcpu, svm->vmcb->save.cr3, false);
>  	if (rc)
>  		return 1;
> 
> -	if (npt_enabled)
> -		svm->vmcb->save.cr3 = hsave->save.cr3;
> +	if (!npt_enabled)
> +		svm->vmcb01->save.cr3 = kvm_read_cr3(&svm->vcpu);
> 
>  	/*
>  	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
> @@ -694,12 +682,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)  void
> svm_leave_nested(struct vcpu_svm *svm)  {
>  	if (is_guest_mode(&svm->vcpu)) {
> -		struct vmcb *hsave = svm->nested.hsave;
> -		struct vmcb *vmcb = svm->vmcb;
> -
>  		svm->nested.nested_run_pending = 0;
>  		leave_guest_mode(&svm->vcpu);
> -		copy_vmcb_control_area(&vmcb->control, &hsave->control);
> +		svm->vmcb = svm->vmcb01;
> +		svm->vmcb_pa = svm->nested.vmcb01_pa;
>  		nested_svm_uninit_mmu_context(&svm->vcpu);
>  	}
>  }
> @@ -1046,10 +1032,9 @@ static int svm_get_nested_state(struct kvm_vcpu
> *vcpu,
>  	if (copy_to_user(&user_vmcb->control, &svm->nested.ctl,
>  			 sizeof(user_vmcb->control)))
>  		return -EFAULT;
> -	if (copy_to_user(&user_vmcb->save, &svm->nested.hsave->save,
> +	if (copy_to_user(&user_vmcb->save, &svm->vmcb01->save,
>  			 sizeof(user_vmcb->save)))
>  		return -EFAULT;
> -
>  out:
>  	return kvm_state.size;
>  }
> @@ -1059,7 +1044,6 @@ static int svm_set_nested_state(struct kvm_vcpu
> *vcpu,
>  				struct kvm_nested_state *kvm_state)  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> -	struct vmcb *hsave = svm->nested.hsave;
>  	struct vmcb __user *user_vmcb = (struct vmcb __user *)
>  		&user_kvm_nested_state->data.svm[0];
>  	struct vmcb_control_area ctl;
> @@ -1121,16 +1105,24 @@ static int svm_set_nested_state(struct kvm_vcpu
> *vcpu,
>  	if (!(save.cr0 & X86_CR0_PG))
>  		return -EINVAL;
> 
> +	svm->nested.vmcb02->control = svm->vmcb01->control;
> +	svm->nested.vmcb02->save = svm->vmcb01->save;
> +	svm->vmcb01->save = save;
> +
> +	WARN_ON(svm->vmcb == svm->nested.vmcb02);
> +
> +	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
> +
> +	svm->vmcb = svm->nested.vmcb02;
> +	svm->vmcb_pa = svm->nested.vmcb02_pa;
> +
>  	/*
> -	 * All checks done, we can enter guest mode.  L1 control fields
> -	 * come from the nested save state.  Guest state is already
> -	 * in the registers, the save area of the nested state instead
> -	 * contains saved L1 state.
> +	 * All checks done, we can enter guest mode. L2 control fields will
> +	 * be the result of a combination of L1 and userspace indicated
> +	 * L12.control. The save area of L1 vmcb now contains the userspace
> +	 * indicated L1.save.
>  	 */
> -	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
> -	hsave->save = save;
> 
> -	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
>  	load_nested_vmcb_control(svm, &ctl);
>  	nested_prepare_vmcb_control(svm);
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c index
> 5764b87379cf..d8022f989ffb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -971,8 +971,8 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu
> *vcpu, u64 offset)
>  	if (is_guest_mode(vcpu)) {
>  		/* Write L1's TSC offset.  */
>  		g_tsc_offset = svm->vmcb->control.tsc_offset -
> -			       svm->nested.hsave->control.tsc_offset;
> -		svm->nested.hsave->control.tsc_offset = offset;
> +			       svm->vmcb01->control.tsc_offset;
> +		svm->vmcb01->control.tsc_offset = offset;
>  	}
> 
>  	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
> @@ -1171,9 +1171,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu,
> bool init_event)  static int svm_create_vcpu(struct kvm_vcpu *vcpu)  {
>  	struct vcpu_svm *svm;
> -	struct page *page;
> +	struct page *vmcb01_page;
> +	struct page *vmcb02_page;
>  	struct page *msrpm_pages;
> -	struct page *hsave_page;
>  	struct page *nested_msrpm_pages;
>  	int err;
> 
> @@ -1181,8 +1181,8 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  	svm = to_svm(vcpu);
> 
>  	err = -ENOMEM;
> -	page = alloc_page(GFP_KERNEL_ACCOUNT);
> -	if (!page)
> +	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT);
> +	if (!vmcb01_page)
>  		goto out;
> 
>  	msrpm_pages = alloc_pages(GFP_KERNEL_ACCOUNT,
> MSRPM_ALLOC_ORDER); @@ -1193,8 +1193,8 @@ static int
> svm_create_vcpu(struct kvm_vcpu *vcpu)
>  	if (!nested_msrpm_pages)
>  		goto free_page2;
> 
> -	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT);
> -	if (!hsave_page)
> +	vmcb02_page = alloc_page(GFP_KERNEL_ACCOUNT);
> +	if (!vmcb02_page)
>  		goto free_page3;
> 
>  	err = avic_init_vcpu(svm);
> @@ -1207,8 +1207,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  	if (irqchip_in_kernel(vcpu->kvm) && kvm_apicv_activated(vcpu->kvm))
>  		svm->avic_is_running = true;
> 
> -	svm->nested.hsave = page_address(hsave_page);
> -	clear_page(svm->nested.hsave);
> +	svm->nested.vmcb02 = page_address(vmcb02_page);
> +	clear_page(svm->nested.vmcb02);
> +	svm->nested.vmcb02_pa = __sme_set(page_to_pfn(vmcb02_page) <<
> +PAGE_SHIFT);
> 
>  	svm->msrpm = page_address(msrpm_pages);
>  	svm_vcpu_init_msrpm(svm->msrpm);
> @@ -1216,9 +1217,11 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  	svm->nested.msrpm = page_address(nested_msrpm_pages);
>  	svm_vcpu_init_msrpm(svm->nested.msrpm);
> 
> -	svm->vmcb = page_address(page);
> +	svm->vmcb = svm->vmcb01 = page_address(vmcb01_page);
>  	clear_page(svm->vmcb);
> -	svm->vmcb_pa = __sme_set(page_to_pfn(page) << PAGE_SHIFT);
> +	svm->vmcb_pa = __sme_set(page_to_pfn(vmcb01_page) <<
> PAGE_SHIFT);
> +	svm->nested.vmcb01_pa = svm->vmcb_pa;
> +
>  	svm->asid_generation = 0;
>  	init_vmcb(svm);
> 
> @@ -1228,13 +1231,13 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  	return 0;
> 
>  free_page4:
> -	__free_page(hsave_page);
> +	__free_page(vmcb02_page);
>  free_page3:
>  	__free_pages(nested_msrpm_pages, MSRPM_ALLOC_ORDER);
>  free_page2:
>  	__free_pages(msrpm_pages, MSRPM_ALLOC_ORDER);
>  free_page1:
> -	__free_page(page);
> +	__free_page(vmcb01_page);
>  out:
>  	return err;
>  }
> @@ -1256,11 +1259,11 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
>  	 * svm_vcpu_load(). So, ensure that no logical CPU has this
>  	 * vmcb page recorded as its current vmcb.
>  	 */
> -	svm_clear_current_vmcb(svm->vmcb);
> 
> -	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
> +	svm_clear_current_vmcb(svm->vmcb);
> +	__free_page(pfn_to_page(__sme_clr(svm->nested.vmcb01_pa) >>
> PAGE_SHIFT));
> +	__free_page(pfn_to_page(__sme_clr(svm->nested.vmcb02_pa) >>
> +PAGE_SHIFT));
>  	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
> -	__free_page(virt_to_page(svm->nested.hsave));
>  	__free_pages(virt_to_page(svm->nested.msrpm),
> MSRPM_ALLOC_ORDER);  }
> 
> @@ -1393,7 +1396,7 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
>  	/* Drop int_ctl fields related to VINTR injection.  */
>  	svm->vmcb->control.int_ctl &= mask;
>  	if (is_guest_mode(&svm->vcpu)) {
> -		svm->nested.hsave->control.int_ctl &= mask;
> +		svm->vmcb01->control.int_ctl &= mask;
> 
>  		WARN_ON((svm->vmcb->control.int_ctl & V_TPR_MASK) !=
>  			(svm->nested.ctl.int_ctl & V_TPR_MASK)); @@ -3127,7
> +3130,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>  	if (is_guest_mode(vcpu)) {
>  		/* As long as interrupts are being delivered...  */
>  		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
> -		    ? !(svm->nested.hsave->save.rflags & X86_EFLAGS_IF)
> +		    ? !(svm->vmcb01->save.rflags & X86_EFLAGS_IF)
>  		    : !(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
>  			return true;
> 
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h index
> a798e1731709..e908b83bfa69 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -82,7 +82,9 @@ struct kvm_svm {
>  struct kvm_vcpu;
> 
>  struct svm_nested_state {
> -	struct vmcb *hsave;
> +	struct vmcb *vmcb02;
> +	unsigned long vmcb01_pa;
> +	unsigned long vmcb02_pa;
>  	u64 hsave_msr;
>  	u64 vm_cr_msr;
>  	u64 vmcb;
> @@ -102,6 +104,7 @@ struct svm_nested_state {  struct vcpu_svm {
>  	struct kvm_vcpu vcpu;
>  	struct vmcb *vmcb;
> +	struct vmcb *vmcb01;
>  	unsigned long vmcb_pa;
>  	struct svm_cpu_data *svm_data;
>  	uint64_t asid_generation;
> @@ -208,10 +211,7 @@ static inline struct vcpu_svm *to_svm(struct kvm_vcpu
> *vcpu)
> 
>  static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)  {
> -	if (is_guest_mode(&svm->vcpu))
> -		return svm->nested.hsave;
> -	else
> -		return svm->vmcb;
> +	return svm->vmcb01;

Shouldn't it return svm->vmcb? That is what your commit message says.

>  }
> 
>  static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
> --
> 2.20.1

