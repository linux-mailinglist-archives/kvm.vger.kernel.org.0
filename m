Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC923BE65F
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 12:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhGGKfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 06:35:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231272AbhGGKfG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 06:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625653945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Jj9k03Q5kpl6uublXBBvngXeK847ppd84J1asQG+3k=;
        b=H/97gGgBuQGXqzeXfPFDbEBfrAYODFvLpdIlnNdVvjmSjq7xGunLG3D9p5Lr9cpRvAkPV1
        J1Rw8Q2qSXUBUCarFffoScFSV2lMafPyuuro2d2QSbXeW3YsT75PSuCkipuU0kAMDzYC1f
        4aOODYHnFzk6bpXWGAx26d3vNT1/+Rc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-iHLjJ3mlP_ioiSYjzPX2dA-1; Wed, 07 Jul 2021 06:32:24 -0400
X-MC-Unique: iHLjJ3mlP_ioiSYjzPX2dA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02F3B800C78;
        Wed,  7 Jul 2021 10:32:23 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C62E119C44;
        Wed,  7 Jul 2021 10:32:19 +0000 (UTC)
Message-ID: <db569845400963d057eedf063bba1599cb9ed77a.camel@redhat.com>
Subject: Re: [PATCH 4/6] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date:   Wed, 07 Jul 2021 13:32:18 +0300
In-Reply-To: <20210628104425.391276-5-vkuznets@redhat.com>
References: <20210628104425.391276-1-vkuznets@redhat.com>
         <20210628104425.391276-5-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-06-28 at 12:44 +0200, Vitaly Kuznetsov wrote:
> VMCB split commit 4995a3685f1b ("KVM: SVM: Use a separate vmcb for the
> nested L2 guest") broke return from SMM when we entered there from guest
> (L2) mode. Gen2 WS2016/Hyper-V is known to do this on boot. The problem
> manifests itself like this:
> 
>   kvm_exit:             reason EXIT_RSM rip 0x7ffbb280 info 0 0
>   kvm_emulate_insn:     0:7ffbb280: 0f aa
>   kvm_smm_transition:   vcpu 0: leaving SMM, smbase 0x7ffb3000
>   kvm_nested_vmrun:     rip: 0x000000007ffbb280 vmcb: 0x0000000008224000
>     nrip: 0xffffffffffbbe119 int_ctl: 0x01020000 event_inj: 0x00000000
>     npt: on
>   kvm_nested_intercepts: cr_read: 0000 cr_write: 0010 excp: 40060002
>     intercepts: fd44bfeb 0000217f 00000000
>   kvm_entry:            vcpu 0, rip 0xffffffffffbbe119
>   kvm_exit:             reason EXIT_NPF rip 0xffffffffffbbe119 info
>     200000006 1ab000
>   kvm_nested_vmexit:    vcpu 0 reason npf rip 0xffffffffffbbe119 info1
>     0x0000000200000006 info2 0x00000000001ab000 intr_info 0x00000000
>     error_code 0x00000000
>   kvm_page_fault:       address 1ab000 error_code 6
>   kvm_nested_vmexit_inject: reason EXIT_NPF info1 200000006 info2 1ab000
>     int_info 0 int_info_err 0
>   kvm_entry:            vcpu 0, rip 0x7ffbb280
>   kvm_exit:             reason EXIT_EXCP_GP rip 0x7ffbb280 info 0 0
>   kvm_emulate_insn:     0:7ffbb280: 0f aa
>   kvm_inj_exception:    #GP (0x0)
> 
> Note: return to L2 succeeded but upon first exit to L1 its RIP points to
> 'RSM' instruction but we're not in SMM.
> 
> The problem appears to be that VMCB01 gets irreversibly destroyed during
> SMM execution. Previously, we used to have 'hsave' VMCB where regular
> (pre-SMM) L1's state was saved upon nested_svm_vmexit() but now we just
> switch to VMCB01 from VMCB02.
> 
> Pre-split (working) flow looked like:
> - SMM is triggered during L2's execution
> - L2's state is pushed to SMRAM
> - nested_svm_vmexit() restores L1's state from 'hsave'
> - SMM -> RSM
> - enter_svm_guest_mode() switches to L2 but keeps 'hsave' intact so we have
>   pre-SMM (and pre L2 VMRUN) L1's state there
> - L2's state is restored from SMRAM
> - upon first exit L1's state is restored from L1.
> 
> This was always broken with regards to svm_get_nested_state()/
> svm_set_nested_state(): 'hsave' was never a part of what's being
> save and restored so migration happening during SMM triggered from L2 would
> never restore L1's state correctly.
> 
> Post-split flow (broken) looks like:
> - SMM is triggered during L2's execution
> - L2's state is pushed to SMRAM
> - nested_svm_vmexit() switches to VMCB01 from VMCB02
> - SMM -> RSM
> - enter_svm_guest_mode() switches from VMCB01 to VMCB02 but pre-SMM VMCB01
>   is already lost.
> - L2's state is restored from SMRAM
> - upon first exit L1's state is restored from VMCB01 but it is corrupted
>  (reflects the state during 'RSM' execution).
> 
> VMX doesn't have this problem because unlike VMCB, VMCS keeps both guest
> and host state so when we switch back to VMCS02 L1's state is intact there.
> 
> To resolve the issue we need to save L1's state somewhere. We could've
> created a third VMCB for SMM but that would require us to modify saved
> state format. L1's architectural HSAVE area (pointed by MSR_VM_HSAVE_PA)
> seems appropriate: L0 is free to save any (or none) of L1's state there.
> Currently, KVM does 'none'.
> 
> Note, for nested state migration to succeed, both source and destination
> hypervisors must have the fix. We, however, don't need to create a new
> flag indicating the fact that HSAVE area is now populated as migration
> during SMM triggered from L2 was always broken.
> 
> Fixes: 4995a3685f1b ("KVM: SVM: Use a separate vmcb for the nested L2 guest")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> - RFC: I'm not 100% sure my 'smart' idea to use currently-unused HSAVE area
> is that smart. Also, we don't even seem to check that L1 set it up upon
> nested VMRUN so hypervisors which don't do that may remain broken. A very
> much needed selftest is also missing.
> ---
>  arch/x86/kvm/svm/svm.c | 39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b6f85fd19f96..fbf1b352a9bb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4291,6 +4291,7 @@ static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>  static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct kvm_host_map map_save;
>  	int ret;
>  
>  	if (is_guest_mode(vcpu)) {
> @@ -4306,6 +4307,29 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>  		ret = nested_svm_vmexit(svm);
>  		if (ret)
>  			return ret;
> +
> +		/*
> +		 * KVM uses VMCB01 to cache L1 host state while L2 runs but
> +		 * VMCB01 is going to be used during SMM and thus the state will
> +		 * be lost. Temporary save non-VMLOAD/VMSAVE state to host save
> +		 * area pointed to by MSR_VM_HSAVE_PA. APM guarantees that the
> +		 * format of the area is identical to guest save area offsetted
> +		 * by 0x400 (matches the offset of 'struct vmcb_save_area'
> +		 * within 'struct vmcb'). Note: HSAVE area may also be used by
> +		 * L1 hypervisor to save additional host context (e.g. KVM does
> +		 * that, see svm_prepare_guest_switch()) which must be
> +		 * preserved.
> +		 */

Minor nitpick: I woudn't say that KVM "caches" L1 host state as this implies
that there is a master copy somewhere.
I would write something like that instead:

"KVM stores L1 host state in VMCB01 because the CPU naturally stores it there."

Other than that the comment looks very good.



> +		if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.hsave_msr),
> +				 &map_save) == -EINVAL)
> +			return 1;

Looks like the return value of vendor specific 'enter_smm' isn't checked
in the common 'enter_smm' handler which itself returns 'void', and doesn't
check anything it does either.

enter_smm is called from inject_pending_event which is allowed to return
a negative value which is assumed to be -EBUSY and doesn't lead
to exit with negative value to userspace.
I vote to fix this and only hide -EBUSY from the userspace,
and let all other errors from this function end up in userspace 
so that userspace could kill the guest.

This isn't this patch fault though, and I think I'll send a patch
to do the above.


> +
> +		BUILD_BUG_ON(offsetof(struct vmcb, save) != 0x400);
I doubt that this will ever change, but let it be.
> +
> +		svm_copy_nonvmloadsave_state(&svm->vmcb01.ptr->save,
> +					     map_save.hva + 0x400);
> +
> +		kvm_vcpu_unmap(vcpu, &map_save, true);
>  	}
>  	return 0;
>  }
> @@ -4313,7 +4337,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>  static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> -	struct kvm_host_map map;
> +	struct kvm_host_map map, map_save;
>  	int ret = 0;
>  
>  	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
> @@ -4337,6 +4361,19 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  
>  			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, map.hva);
>  			kvm_vcpu_unmap(vcpu, &map, true);
> +
> +			/*
> +			 * Restore L1 host state from L1 HSAVE area as VMCB01 was
> +			 * used during SMM (see svm_enter_smm())
> +			 */
Looks fine as well.

> +			if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.hsave_msr),
> +					 &map_save) == -EINVAL)
> +				return 1;
> +
> +			svm_copy_nonvmloadsave_state(map_save.hva + 0x400,
> +						     &svm->vmcb01.ptr->save);
> +
> +			kvm_vcpu_unmap(vcpu, &map_save, true);
>  		}
>  	}
>  

So besides the nitpick of the comment,
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

