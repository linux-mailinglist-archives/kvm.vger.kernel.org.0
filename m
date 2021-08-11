Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270C13E99C4
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 22:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhHKUh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 16:37:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60835 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230089AbhHKUhz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 16:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628714250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=waWt9ts8XNMlHm2hKoue8Sz4ZcOpAbzZWVYeUZT8iRQ=;
        b=OxamtJegQO8s3gcoys5BUB0kRGpoS4qkCKezdX/H2nLf92jDpOqri0Bws5Jt5FjaawOFWJ
        CpRSCjkC6O7ruZV10M63R/1cvZSvu2wjujzQ5Lu6z9U14XKH4Etyjn9SeSwBBvwgMoKiew
        Lw3QF/Mc+wIHWwyM0iYwCP5yXzT9Tiw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-LgiGpFh6M8ST1k9k6w7naw-1; Wed, 11 Aug 2021 16:37:29 -0400
X-MC-Unique: LgiGpFh6M8ST1k9k6w7naw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D05AA18C89C4;
        Wed, 11 Aug 2021 20:37:26 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5C975D9C6;
        Wed, 11 Aug 2021 20:37:22 +0000 (UTC)
Message-ID: <21b14e5711dff386ced705a385f85301761b50a5.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: nSVM: temporarly save vmcb12's efer, cr0 and
 cr4 to avoid TOC/TOU races
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Date:   Wed, 11 Aug 2021 23:37:21 +0300
In-Reply-To: <20210809145343.97685-3-eesposit@redhat.com>
References: <20210809145343.97685-1-eesposit@redhat.com>
         <20210809145343.97685-3-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-08-09 at 16:53 +0200, Emanuele Giuseppe Esposito wrote:
> Move the checks done by nested_vmcb_valid_sregs and nested_vmcb_check_controls
> directly in enter_svm_guest_mode, and save the values of vmcb12's
> efer, cr0 and cr4 in local variable that are then passed to
> nested_vmcb02_prepare_save. This prevents from creating TOC/TOU races.
> 
> This also avoids the need of force-setting EFER_SVME in
> nested_vmcb02_prepare_save.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 72 +++++++++++++++++++--------------------
>  1 file changed, 36 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 0ac2d14add15..04e9e947deb9 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -259,20 +259,14 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>  
>  /* Common checks that apply to both L1 and L2 state.  */
>  static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
> -				    struct vmcb_save_area *save)
> +				    struct vmcb_save_area *save,
> +				    u64 efer, u64 cr0, u64 cr4)
>  {
> -	/*
> -	 * FIXME: these should be done after copying the fields,
> -	 * to avoid TOC/TOU races.  For these save area checks
> -	 * the possible damage is limited since kvm_set_cr0 and
> -	 * kvm_set_cr4 handle failure; EFER_SVME is an exception
> -	 * so it is force-set later in nested_prepare_vmcb_save.
> -	 */
> -	if (CC(!(save->efer & EFER_SVME)))
> +	if (CC(!(efer & EFER_SVME)))
>  		return false;
>  
> -	if (CC((save->cr0 & X86_CR0_CD) == 0 && (save->cr0 & X86_CR0_NW)) ||
> -	    CC(save->cr0 & ~0xffffffffULL))
> +	if (CC((cr0 & X86_CR0_CD) == 0 && (cr0 & X86_CR0_NW)) ||
> +	    CC(cr0 & ~0xffffffffULL))
>  		return false;
>  
>  	if (CC(!kvm_dr6_valid(save->dr6)) || CC(!kvm_dr7_valid(save->dr7)))
> @@ -283,17 +277,16 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
>  	 * except that EFER.LMA is not checked by SVM against
>  	 * CR0.PG && EFER.LME.
>  	 */
> -	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
> -		if (CC(!(save->cr4 & X86_CR4_PAE)) ||
> -		    CC(!(save->cr0 & X86_CR0_PE)) ||
> +	if ((efer & EFER_LME) && (cr0 & X86_CR0_PG)) {
> +		if (CC(!(cr4 & X86_CR4_PAE)) || CC(!(cr0 & X86_CR0_PE)) ||
>  		    CC(kvm_vcpu_is_illegal_gpa(vcpu, save->cr3)))
>  			return false;
>  	}
>  
> -	if (CC(!kvm_is_valid_cr4(vcpu, save->cr4)))
> +	if (CC(!kvm_is_valid_cr4(vcpu, cr4)))
>  		return false;
>  
> -	if (CC(!kvm_valid_efer(vcpu, save->efer)))
> +	if (CC(!kvm_valid_efer(vcpu, efer)))
>  		return false;
>  
>  	return true;
> @@ -434,7 +427,9 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
>  	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
>  }
>  
> -static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
> +static void nested_vmcb02_prepare_save(struct vcpu_svm *svm,
> +				       struct vmcb *vmcb12,
> +				       u64 efer, u64 cr0, u64 cr4)
>  {
>  	bool new_vmcb12 = false;
>  
> @@ -463,15 +458,10 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>  
>  	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
>  
> -	/*
> -	 * Force-set EFER_SVME even though it is checked earlier on the
> -	 * VMCB12, because the guest can flip the bit between the check
> -	 * and now.  Clearing EFER_SVME would call svm_free_nested.
> -	 */
> -	svm_set_efer(&svm->vcpu, vmcb12->save.efer | EFER_SVME);
> +	svm_set_efer(&svm->vcpu, efer);
>  
> -	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
> -	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
> +	svm_set_cr0(&svm->vcpu, cr0);
> +	svm_set_cr4(&svm->vcpu, cr4);
>  
>  	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
>  
> @@ -567,6 +557,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	int ret;
> +	u64 vmcb12_efer, vmcb12_cr0, vmcb12_cr4;
>  
>  	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb12_gpa,
>  			       vmcb12->save.rip,
> @@ -589,8 +580,25 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>  	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> +
> +	/* Save vmcb12's EFER, CR0 and CR4 to avoid TOC/TOU races. */
> +	vmcb12_efer = vmcb12->save.efer;
> +	vmcb12_cr0 = vmcb12->save.cr0;
> +	vmcb12_cr4 = vmcb12->save.cr4;
> +
> +	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save, vmcb12_efer,
> +				     vmcb12_cr0, vmcb12_cr4) ||
> +	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
> +		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> +		vmcb12->control.exit_code_hi = 0;
> +		vmcb12->control.exit_info_1  = 0;
> +		vmcb12->control.exit_info_2  = 0;
> +		return 1;
> +	}
> +
>  	nested_vmcb02_prepare_control(svm);
> -	nested_vmcb02_prepare_save(svm, vmcb12);
> +	nested_vmcb02_prepare_save(svm, vmcb12, vmcb12_efer, vmcb12_cr0,
> +				   vmcb12_cr4);
>  
>  	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
>  				  nested_npt_enabled(svm), true);
> @@ -641,15 +649,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  
>  	nested_load_control_from_vmcb12(svm, &vmcb12->control);
>  
> -	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
> -	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
> -		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> -		vmcb12->control.exit_code_hi = 0;
> -		vmcb12->control.exit_info_1  = 0;
> -		vmcb12->control.exit_info_2  = 0;
> -		goto out;
> -	}
> -
>  	/*
>  	 * Since vmcb01 is not in use, we can use it to store some of the L1
>  	 * state.
> @@ -1336,7 +1335,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	if (!(save->cr0 & X86_CR0_PG) ||
>  	    !(save->cr0 & X86_CR0_PE) ||
>  	    (save->rflags & X86_EFLAGS_VM) ||
> -	    !nested_vmcb_valid_sregs(vcpu, save))
> +	    !nested_vmcb_valid_sregs(vcpu, save, save->efer, save->cr0,
> +				     save->cr4))
>  		goto out_free;
>  
>  	/*


This is a very interesting approach.

Your approach is to copy only some fields and still pass pointer to the guest controlled save area to relevant functions, 
thus in the future this pointer can still be used again to trigger TOC/TOI
races.

My approach was to copy all the vmcb12 (save and control) to a page (we currently only copy the control area),
and then just use the copy everywhere.
 
The disadvantage of my approach is that fields are copied twice, once from vmcb12 to its local copy,
and then from the local copy to vmcb02, however this approach is generic in such a way that TOC/TOI races become impossible.

The disadvantage of your approach is that only some fields are copied and there is still a chance of TOC/TOI race in the future.


I have a suggestion:
Maybe we should just blindly copy all registers as is to vmcb02 (even before we switch to it),

and then check the registers, and for registers for which the user visible value differs
from the value that CPU sees  (CR0/CR3/CR4/EFER/RFLAGS/), 
replace the guest CR value temporarily stored in VMCB02 with
filtered value, similar to a slight abuse we do as I explained in Note 1 below?
 
Best regards,
	Maxim Levitsky

 
PS:
 
This is a bit of documentation I had just written and I would like to share, about a few things that might be useful
in the context of this work.

I might not understand everything correctly, and so there might be mistakes, so feel free to correct me.
There also are probably corner cases I didn’t paid much attention to.
 
Also the below is mostly true for SVM, on VMX there is a bit more caching to avoid vmreads/vmwrites).
 
 
*** Note 1: Explanantion of some state changes that nested SVM entry/exit does: ***
 
  In nested_svm_vmrun we have this code which has a slightly misleading comment:
	/*
	 * Since vmcb01 is not in use, we can use it to store some of the L1
	 * state.
	 */
	svm->vmcb01.ptr->save.efer   = vcpu->arch.efer;
	svm->vmcb01.ptr->save.cr0    = kvm_read_cr0(vcpu);
	svm->vmcb01.ptr->save.cr4    = vcpu->arch.cr4;
	svm->vmcb01.ptr->save.rflags = kvm_get_rflags(vcpu);
	svm->vmcb01.ptr->save.rip    = kvm_rip_read(vcpu);
 
	if (!npt_enabled)
		svm->vmcb01.ptr->save.cr3 = kvm_read_cr3(vcpu);
 
  But the VMCB01 already contains the L1 state, and what is actually happening here is slightly different:
 
  First we have: 
  	svm->vmcb01.ptr->save.rip    = kvm_rip_read(vcpu);
 
  This writes back the RIP promotion that is in KVM register cache back to vmb01, 
  that was done by kvm_skip_emulated_instruction
  
  Normally this happens on guest entry (see svm_vcpu_run), 
  but has to be done now as we will not enter vmcb01 but vmcb02.
 
  Then we have:
 
	svm->vmcb01.ptr->save.efer   = vcpu->arch.efer;
	svm->vmcb01.ptr->save.cr0    = kvm_read_cr0(vcpu);
	svm->vmcb01.ptr->save.cr4    = vcpu->arch.cr4;
	svm->vmcb01.ptr->save.rflags = kvm_get_rflags(vcpu);
 
 	if (!npt_enabled)
		svm->vmcb01.ptr->save.cr3 = kvm_read_cr3(vcpu);
 
  The purpose of these writes is to replace the CPU visible values of these registers which are already stored in vmcb01, 
  with guest visible values which we store in vcpu->arch.* and return to the guest in case it reads them,
  for all registers that differ in CPU and guest visible value.

  This is a slight abuse of vmb01 but maybe it is the best way to do it. I don't know.
 
  Those registers (efer, cr0, cr4, rflags, and cr3), roughly speaking are the only registers that
  can have different values in regard to what the guest thinks the register value is and what the real value that the
  CPU sees.
 
  In particular:
 
  -> EFER as you see in svm_set_efer is modified with a few things when shadow paging is enabled, and the SVME bit is force enabled, 
     since AMD forces us to have EFER.SVME enabled when a guest is running, while the guest might not enable the SVM at all.
 
  -> CR0 also has some slight tweaks in svm_set_cr0 mostly for !npt_enabled case as well.

  -> CR4 - same story, see the svm_set_cr4

  -> RFLAGS - we try (only partially) to hide the host set RFLAGS.TF when the KVM_GUESTDBG_SINGLESTEP guest debug feature is active.

  -> CR3 - when using shadowing paging, it contains the shadow paging root
 
  We also have some code for overriding the debug registers like that but it is handled
  differently and I haven’t dug deep into it.
 
  Later on nested VMexit, we do the opposite
 
	kvm_set_rflags(vcpu, svm->vmcb->save.rflags);
	svm_set_efer(vcpu, svm->vmcb->save.efer);
	svm_set_cr0(vcpu, svm->vmcb->save.cr0 | X86_CR0_PE);
	svm_set_cr4(vcpu, svm->vmcb->save.cr4);
 
  This code achieves two things at the same time
     -> It updates the KVM register cache back with the L1 values
     -> It updates the vmcb01 register values back to CPU visible values,
        since we call the functions that are called when the guest modifies those registers,
        and so all the 'modifications' are done again prior to loading the value into the vmcb.
 
  We also have this on nested VMexit: 
	kvm_rax_write(vcpu, svm->vmcb->save.rax);
	kvm_rsp_write(vcpu, svm->vmcb->save.rsp);
	kvm_rip_write(vcpu, svm->vmcb->save.rip);
 
  This only updates the KVM register cache with the previous L1 values, while VMCB01 values are already up to date
  (unchanged)
  
  (but to be honest, on next VM entry we will still write these registers 
  from KVM register cache back to vmcb01 pointlessly to be honest)
 
  Note that RSP/RAX is not needed to be written back to vmcb01 on nested entry as the L1 RSP/RAX is up to date 
  (skipping the VMRUN instruction doesn’t change those, 
  although otherwise we do write those back to current vmcb).


*** Note 2: Note on management and synchronization of the KVM’s internal guest register state: ***
 
  I am talking about (vcpu->arch.regs and vcpu->arch.cr*, and such)
 
  This state is supposed to be the master copy of the guest register state, and usually it is, 
  and keeping it up to date vs vmcb state is done differently for different registers.
 
  -> For general purpose registers which VMCS/VMCB don’t contain, there is nothing to synchronize,
     and these registers are saved/loaded on each guest entry/exit.
 
  -> For general purpose registers which SVM does load/store from/to vmcb we update them manually in the cache 
     (in svm_vcpu_run), in both directions. That includes RIP as well.
 
  -> Most of the control registers are intercepted, and thus the register cache is updated when the guest
     tries to change them.

     Those that aren’t intercepted (CR3 with NPT for example), their cached value is
     also updated on each guest entry/exit.
 
  -> Some more rare used registers (e.g segment registers on SVM) are not cached in vcpu->arch.* at all, 
     but rather have functions to read them (.get_segment, .get_msr, .get_rflags and such) which read them
     from the vmcb thus for those registers, the vmcb is the master copy holding them.
 
  There is also a notion of available and dirty registers which I didn't mention here, but those aren't used much for SVM.
  PDPTRs, ahem, ahem.... 
 
*** Note 3: A note about nested VMX ***
 
  Note that on nested VMX TOC/TOU races are not an issue. 
 
  On VMX, all VMCS manipulation are done by:

  1. Loading a VMCS (using vmptrld instruction), at that point the CPU is free to load the whole VMCS into internal memory

  2. Changing the VMCS by using vmread/vmwrite instruction and/or by running a VM, all of them are free to change the internal copy
     and not write anything back to the memory image.

  3. Finally, "clearing" the VMCS by running vmclear instruction in it,
     which finally have to write back the cpu cache to the vmcs in the memory.
 
  For nested VMX, this means that we read the whole vmcb12 into a kernel copy 
  (vmx->nested.cached_vmcs12), and from there
  only the kernel copy is updated when the nested guest uses vmread/vmwrite.
 
  Only when the guest does vmclear we flush back our kernel copy back to the vmcs12 in the memory.

  On nested guest entry thus, even if a malicious L1 tries to update the vmcs12 memory we won’t access it.
 
  There is also the notion of shadow vmcs and evmcs but for our sanity I don't want to talk about them yet.



