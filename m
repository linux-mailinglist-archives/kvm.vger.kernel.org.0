Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E207F286AC0
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 00:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgJGWOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 18:14:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728339AbgJGWOS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 18:14:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602108855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OZXDKD8ywdnokI7xAKR/UrN1i01KHeVoZzLw6/X5SvE=;
        b=YCZVsIjFFPSh9ske6It1+MRASit0COlE4WWtqXaSsvAJ9htSzcHtZ6WRAkKeVfeF9oChwU
        DvrfZxmqMtQ0Nx3+8AqLCEg03A/Ul/ZsRhLhA6kp0GDRiAl5XyCSeWJx9+WoXLDDuYl5dR
        cC4JQ6TguottwYKajSvR3P4F7doQFno=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-KaszYkeqOIySbFPjW6cd3g-1; Wed, 07 Oct 2020 18:14:13 -0400
X-MC-Unique: KaszYkeqOIySbFPjW6cd3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 049A7835B47;
        Wed,  7 Oct 2020 22:14:12 +0000 (UTC)
Received: from starship (unknown [10.35.206.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E72FF6EF49;
        Wed,  7 Oct 2020 22:14:09 +0000 (UTC)
Message-ID: <587d1da1a037dd3ab7844c5cacc50bfda5ce6021.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Use a separate vmcb for the nested L2 guest
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
Date:   Thu, 08 Oct 2020 01:14:08 +0300
In-Reply-To: <20200917192306.2080-1-cavery@redhat.com>
References: <20200917192306.2080-1-cavery@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-09-17 at 15:23 -0400, Cathy Avery wrote:
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
I think that the above comment is wrong.

What is happening here is that we writeback some stuff to the vmcb01 that had
changed during the skipping of the vmrun instruction, something that we normally 
(for non nested run) do in next svm_vcpu_run. I am not sure that we need even to 
update here anything but rip, because it is written by kvm_rip_write which writes 
only the vcpu->arch.regs and marks the register as dirty which we don't seem to
notice in svm code. Instead svm_vcpu_run just always syncs rax/rsp/rip to current vmcb.

Best would be to check the arch register dirty bits and update if set - no need to do this now
of course.


> +
> +	svm->vmcb01->save.efer   = svm->vcpu.arch.efer;
> +	svm->vmcb01->save.cr0    = kvm_read_cr0(&svm->vcpu);
> +	svm->vmcb01->save.cr4    = svm->vcpu.arch.cr4;
> +	svm->vmcb01->save.rflags = kvm_get_rflags(&svm->vcpu);
> +	svm->vmcb01->save.rip    = kvm_rip_read(&svm->vcpu);

In addition to this, I *think* I would refer to svm->vmcb instead of svm->vmcb01,
to mark the fact that we work on current vmcb (the switch to vmdb02 didn't happen yet)
But this is purely cosmetic thing.
Note thought that besides the comment, the code is not wrong here (e.g there is no bug).

> +
> +	if (!npt_enabled)
> +		svm->vmcb01->save.cr3 = kvm_read_cr3(&svm->vcpu);
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

I think that the above should be done always. The asid field is currently host
controlled only (that is L2 value is ignored, selective ASID tlb flush is not
advertized to the guest and lnvlpga is emulated as invlpg). 

So if we have a tlb flush, the asid in vmcb02 will change, and that change
should propogate to vmcb01 (this can also be done when it is changed in 'new_asid')



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
Probably should be vmcb instead (also only cosmetic change since vmcb should be vmcb01 at
at that point)

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

Honestly can't find anything seriosly wrong with this patch. I tried it,
and actually I was able to boot a fedora guest. The L2 guest is just SLOW.
I mean as slow as drawing a single character while moving in grub menu,
and later you have to wait like few minutes to just start seeing output
from the kernel on the serial line. Its is so slow that systemd timeouts
on most services, so I wasn't able to get to the GUI. Interstingly the L1
continues to work as if nothing happened. Nothing on the kernel dmesg in both
L1 and L2


I must say I never had such a puzzling issue.
I debugged it a bit but without any luck. I guess this can be brute-force
debugged by comparing the traces, etc but this probably is out of scope for
me for now.


My guesses on why this could happen:

1. Something wrong with memory types - like guest is using UC memory for everything.
    I can't completely rule that out yet

2. Something wrong with TLB/MMU - I played a bit with asid related things, but don't see
anything significantly wrong.

3. Dirty bits of vmcb - a test to always set them without this patch and see if that
tanks performance can be done (didn't do this)

4. Something with interrupts/int_ctl. I tested that NMI single setep code is not involved,
vgif=0 doesn't help. avic=0 doesn't help either (tested just in case)

I applied this patch on Linus's mainline branch (it doesn't apply to kvm/queue)

Best regards,
	Maxim Levitsky

