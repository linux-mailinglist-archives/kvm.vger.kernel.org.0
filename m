Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1202707E8
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 23:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgIRVNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 17:13:55 -0400
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:24736
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726154AbgIRVNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 17:13:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0Z9+2tNCy0azivORUKwBBmPbtslqYNBcGbqAZ1voAkgqV2xdOk6xGIJJdTmB3jiyn4KTvss6P/HqlZ7+ZlXtKZguxs4ag+JBXG7ICYWs8XUQ1CHOmlsLqZ125vUz0fhtZ//3s0bkg+yFPiIYqEl7iElKT+sBAGe9ASVWJO1JidBoX/GmfWOZeK+WQ0XdUC+4yvSTj0lC40ps9ytEaM6xkZq1CfHC0KC4pTGf2+J9cOUJscziXX47xQvOVZRhCLXLOxPb1qtSYJeXq/nkFB3yfbXtfxbygpzki4++gcmPpWMZzJe32T5Dvgmt3fHuzjmPzi0VsM5L3zaKsve8CoNUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAYwoIM8/5nyebQEAYhSLw+P3uw34AdW/f4XOMIlYQA=;
 b=Icy2aCFVHzlbqJmmf0djWSOFLvkSJhBkR7YtMW/8vqKdP/t0FJbxmouxZrrhFTx1Bs83K7ELUgJwvrJYcBtbWDuLKaMB0dNUPXZEElxZBRMCrTaxJtj4BUNtyHD8dZioAKuRc2XccT4dMY8JNcHtBYDuSRV7l66FJB5RNnf5WWnSIInWiUa1DdkmhyCRpSxIFAyvS34PTT2rRdfST0ZIvxpRwUi8Oj9WUrBX1XIGkuxiliqaPvA+heOh1uVa77lQqv4sO72bJbNwbDGUtytB2/JgBJfecgKIRbi1B0W+QXXCn4nXJDVX074OS7xWq22zuM4S7LwHyIf6n1Gkh/sEFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAYwoIM8/5nyebQEAYhSLw+P3uw34AdW/f4XOMIlYQA=;
 b=A6yMcWKD/lHM8ASITIzhH5QBTcZidCiYDh1rvDTdPxHUAudv3mAGkDf1iATQz4rlLBncHAjVYRN79LhN4RzZCwnSn6hLx4Y9IfLJhNrRC6AfSaXtDYpNWnIZevYIqBdCh9kEvCIbJVawirz9ldDIDxCnBlKNnvUyhJg/9ddbzNw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR12MB1605.namprd12.prod.outlook.com (2603:10b6:910:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 18 Sep
 2020 21:11:12 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::9067:e60d:5698:51d8]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::9067:e60d:5698:51d8%12]) with mapi id 15.20.3391.011; Fri, 18 Sep
 2020 21:11:11 +0000
Date:   Fri, 18 Sep 2020 16:11:09 -0500
From:   Wei Huang <wei.huang2@amd.com>
To:     Cathy Avery <cavery@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH] KVM: SVM: Use a separate vmcb for the nested L2 guest
Message-ID: <20200918211109.GA803484@weilap>
References: <20200917192306.2080-1-cavery@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917192306.2080-1-cavery@redhat.com>
X-ClientProxiedBy: DM5PR13CA0058.namprd13.prod.outlook.com
 (2603:10b6:3:117::20) To CY4PR12MB1494.namprd12.prod.outlook.com
 (2603:10b6:910:f::22)
Importance: high
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.11) by DM5PR13CA0058.namprd13.prod.outlook.com (2603:10b6:3:117::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.4 via Frontend Transport; Fri, 18 Sep 2020 21:11:11 +0000
X-Priority: 1 (Highest)
X-MSMail-Priority: High
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 84a00860-4c93-4779-3703-08d85c175e8a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1605:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1605F14D2B41741BBA1F3A1CCF3F0@CY4PR12MB1605.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EbZMmVri+bEm5QSQq/97U/8og1EZF+HT/OADLUf9GHGRHThCq7UmwtpWJXK7qlQaeEan0v6+1tZQudUAS2nDlrxzGfx76Rfd/IaGRPMRPs24cBKeJRFqlSaUfSgTeeJxhRz7CG3ApmmauP3D8WccxbByI+bkwXrOGNHqhsHL04WzmpeH/3lCqp9u94YtHpkp/LZAfn5QllacECHUWlrJ5OkACwGYHPbwfMnEqNYZz8qIA/pQnWmhU/kPBc8UQbN461BV9BrC1wWWmSB7kRN016rSyevcH9AnkO8QOx1G5OXadzK/PdOogzOP5MV+uRR0Oe7UOIEGaw0ip/GQg29/qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(52116002)(9686003)(4326008)(33716001)(26005)(66556008)(66946007)(86362001)(956004)(83380400001)(66476007)(478600001)(1076003)(6486002)(30864003)(5660300002)(16526019)(316002)(8936002)(8676002)(186003)(33656002)(6496006)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UExNcKSEAvPUAvJn8ZlwD/aiFgBwnqV0fBiPrWaVC/c4LrW6j7xk8Tk+q1FMcpLNeun/dNs7G3HST3BLNwfHtRDluREvMhBgVLThDi646IF76Ixa76YmtQtP0VanXZoHvbCoNoXR1PPtBCGtV+JVvCLTOQc4Vp4rAThLXji//2rs+iWtqJuPT3U5KL9YIl+/NEHWXMNWMh0TBymm16cQP7ssaZk31rd0zXg7sLDigM71b0X+gimRsD+JtYsCZjSa90lJZMGsu6fuOzIkpwAz2BszVUjQffa7Xj/AA42c3Bzh5ixWwvw5csTlO2n/IHKoaUYtD5ww+i8a6X4zomsXXNBzbwEpQ3JvUOappHxY6QLMrkpArZEpQpPg5B4RzqUnqbwMGFZ3NNFR9qCVoIDP+ofFzaDlvB8zsXHmd5PPJ0h9f8duPV2WJsJY+cWP61vysF5XEXBROIFC+Rzc8S/fq9cQlItlEWOZOhaC8nPBcNGQbeaBU28oIJOE+IZ/mVpoUC65cyoLlCW9cO2xU37+/MfxWL7Vg6qJnEYTcWtGIQ7iD8hc9FXjbXkT+s4rgBH8vis8ZfZDhgNuWBMBhpSQLHY9t7N2ZEoOA6ygheJ8kMstsYy+rin4AXyA3bqDKO6Ak5+f11Gpj/UT/H3vTm2FcA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a00860-4c93-4779-3703-08d85c175e8a
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 21:11:11.6693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JmSqBoxvUVPmSyJE7lRM74x4ExCXKUJWqLBGw6NQkC7v3RxwfKS2rBWpGa7mGkiH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1605
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/17 03:23, Cathy Avery wrote:
> svm->vmcb will now point to either a separate vmcb L1 ( not nested ) or L2 vmcb ( nested ).
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

I was able to run some basic nested SVM tests using this patch. Full L2 VM
(Fedora) had some problem to boot after grub loading kernel.

Comments below.

> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 116 ++++++++++++++++++--------------------
>  arch/x86/kvm/svm/svm.c    |  41 +++++++-------
>  arch/x86/kvm/svm/svm.h    |  10 ++--
>  3 files changed, 81 insertions(+), 86 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index e90bc436f584..0a06e62010d8 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -75,12 +75,12 @@ static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
>  static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> -	struct vmcb *hsave = svm->nested.hsave;
>  
>  	WARN_ON(mmu_is_nested(vcpu));
>  
>  	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
> -	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, hsave->save.cr4, hsave->save.efer,
> +	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, svm->vmcb01->save.cr4,
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
> @@ -403,7 +403,7 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
>  
>  	svm->vmcb->control.int_ctl             =
>  		(svm->nested.ctl.int_ctl & ~mask) |
> -		(svm->nested.hsave->control.int_ctl & mask);
> +		(svm->vmcb01->control.int_ctl & mask);
>  
>  	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
>  	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
> @@ -432,6 +432,12 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>  	int ret;
>  
>  	svm->nested.vmcb = vmcb_gpa;
> +
> +	WARN_ON(svm->vmcb == svm->nested.vmcb02);
> +
> +	svm->nested.vmcb02->control = svm->vmcb01->control;

This part is a bit confusing. svm->vmcb01->control contains the control
info from L0 hypervisor to L1 VM. Shouldn't vmcb02->control use the info
from the control info contained in nested_vmcb?

> +	svm->vmcb = svm->nested.vmcb02;
> +	svm->vmcb_pa = svm->nested.vmcb02_pa;
>  	load_nested_vmcb_control(svm, &nested_vmcb->control);
>  	nested_prepare_vmcb_save(svm, nested_vmcb);
>  	nested_prepare_vmcb_control(svm);
> @@ -450,8 +456,6 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>  {
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

We do save some copying time here, which is always a good thing especially
for nested virt.

>
>  	svm->nested.nested_run_pending = 1;
>  
> @@ -564,7 +556,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  {
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
> +		svm->vmcb01->control.asid = svm->nested.vmcb02->control.asid;
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

Does this mean the original code is missing the following?

        else
		svm->vmcb01->save.cr3 = kvm_read_cr3(&svm->vcpu);

>  
>  	/*
>  	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
> @@ -694,12 +682,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  void svm_leave_nested(struct vcpu_svm *svm)
>  {
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
> @@ -1046,10 +1032,9 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
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
> @@ -1059,7 +1044,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  				struct kvm_nested_state *kvm_state)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> -	struct vmcb *hsave = svm->nested.hsave;
>  	struct vmcb __user *user_vmcb = (struct vmcb __user *)
>  		&user_kvm_nested_state->data.svm[0];
>  	struct vmcb_control_area ctl;
> @@ -1121,16 +1105,24 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
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
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5764b87379cf..d8022f989ffb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -971,8 +971,8 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
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
> @@ -1171,9 +1171,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  {
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
>  	msrpm_pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
> @@ -1193,8 +1193,8 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
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
> +	svm->nested.vmcb02_pa = __sme_set(page_to_pfn(vmcb02_page) << PAGE_SHIFT);
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
> +	svm->vmcb_pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
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
> +	__free_page(pfn_to_page(__sme_clr(svm->nested.vmcb01_pa) >> PAGE_SHIFT));
> +	__free_page(pfn_to_page(__sme_clr(svm->nested.vmcb02_pa) >> PAGE_SHIFT));
>  	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
> -	__free_page(virt_to_page(svm->nested.hsave));
>  	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
>  }
>  
> @@ -1393,7 +1396,7 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
>  	/* Drop int_ctl fields related to VINTR injection.  */
>  	svm->vmcb->control.int_ctl &= mask;
>  	if (is_guest_mode(&svm->vcpu)) {
> -		svm->nested.hsave->control.int_ctl &= mask;
> +		svm->vmcb01->control.int_ctl &= mask;
>  
>  		WARN_ON((svm->vmcb->control.int_ctl & V_TPR_MASK) !=
>  			(svm->nested.ctl.int_ctl & V_TPR_MASK));
> @@ -3127,7 +3130,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>  	if (is_guest_mode(vcpu)) {
>  		/* As long as interrupts are being delivered...  */
>  		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
> -		    ? !(svm->nested.hsave->save.rflags & X86_EFLAGS_IF)
> +		    ? !(svm->vmcb01->save.rflags & X86_EFLAGS_IF)
>  		    : !(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
>  			return true;
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index a798e1731709..e908b83bfa69 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -82,7 +82,9 @@ struct kvm_svm {
>  struct kvm_vcpu;
>  
>  struct svm_nested_state {
> -	struct vmcb *hsave;
> +	struct vmcb *vmcb02;
> +	unsigned long vmcb01_pa;

Any reason that vmcb01_pa can't be placed in "struct vcpu_svm" below, along
with vmcb01?

> +	unsigned long vmcb02_pa;
>  	u64 hsave_msr;
>  	u64 vm_cr_msr;
>  	u64 vmcb;
> @@ -102,6 +104,7 @@ struct svm_nested_state {
>  struct vcpu_svm {
>  	struct kvm_vcpu vcpu;
>  	struct vmcb *vmcb;
> +	struct vmcb *vmcb01;
>  	unsigned long vmcb_pa;
>  	struct svm_cpu_data *svm_data;
>  	uint64_t asid_generation;
> @@ -208,10 +211,7 @@ static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
>  
>  static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
>  {
> -	if (is_guest_mode(&svm->vcpu))
> -		return svm->nested.hsave;
> -	else
> -		return svm->vmcb;
> +	return svm->vmcb01;
>  }
>  
>  static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
> -- 
> 2.20.1
> 
