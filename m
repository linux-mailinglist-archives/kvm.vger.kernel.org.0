Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE42E437930
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 16:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhJVOst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 10:48:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233041AbhJVOss (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 10:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634913990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ztPsqRcoIIa+CSgH5e9hCCBkHfLlFSvImxfgvOSy78Y=;
        b=QI9K4XpjEGoGgB7tK1N0Q8DuDf67ovH6/GWof+Rq78+a/UzDFdE+hQyBj6tdKgii3EHYhU
        gSxAfCbs05TgvpqYw9qbHIV/syiahB4qXxOMhnCF5aU1oyfD+dZxBn0zmb0kgtsiD9/Ug1
        pI6yEpB8UmCTNJdXq4GsVPQYXWwprBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-SHObPM6rPgaJCYZBDK8ZCA-1; Fri, 22 Oct 2021 10:46:26 -0400
X-MC-Unique: SHObPM6rPgaJCYZBDK8ZCA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EC0581C464;
        Fri, 22 Oct 2021 14:46:24 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58D621017E28;
        Fri, 22 Oct 2021 14:46:15 +0000 (UTC)
Message-ID: <4a92e23fcdf9959d6f9bf2c8b6ef69a0c8662ee1.camel@redhat.com>
Subject: Re: [PATCH v3 2/8] nSVM: introduce smv->nested.save to cache save
 area fields
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Date:   Fri, 22 Oct 2021 17:46:14 +0300
In-Reply-To: <20211011143702.1786568-3-eesposit@redhat.com>
References: <20211011143702.1786568-1-eesposit@redhat.com>
         <20211011143702.1786568-3-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-10-11 at 10:36 -0400, Emanuele Giuseppe Esposito wrote:
> This is useful in next patch, to avoid having temporary
> copies of vmcb12 registers and passing them manually.
> 
> Right now, instead of blindly copying everything,
> we just copy EFER, CR0, CR3, CR4, DR6 and DR7. If more fields
> will need to be added, it will be more obvious to see
> that they must be added in struct vmcb_save_area_cached and
> in nested_copy_vmcb_save_to_cache().
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 18 ++++++++++++++++++
>  arch/x86/kvm/svm/svm.c    |  1 +
>  arch/x86/kvm/svm/svm.h    | 16 ++++++++++++++++
>  3 files changed, 35 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index d2fe65e2a7a4..c4959da8aec0 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -313,6 +313,22 @@ void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
>  	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
>  }
>  
> +void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
> +				    struct vmcb_save_area *save)
> +{
> +	/*
> +	 * Copy only fields that are validated, as we need them
> +	 * to avoid TOC/TOU races.
> +	 */
> +	svm->nested.save.efer = save->efer;
> +	svm->nested.save.cr0 = save->cr0;
> +	svm->nested.save.cr3 = save->cr3;
> +	svm->nested.save.cr4 = save->cr4;
> +
> +	svm->nested.save.dr6 = save->dr6;
> +	svm->nested.save.dr7 = save->dr7;
> +}
> +
>  /*
>   * Synchronize fields that are written by the processor, so that
>   * they can be copied back into the vmcb12.
> @@ -647,6 +663,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  		return -EINVAL;
>  
>  	nested_load_control_from_vmcb12(svm, &vmcb12->control);
> +	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
>  
>  	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
>  	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
> @@ -1385,6 +1402,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  
>  	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
>  	nested_load_control_from_vmcb12(svm, ctl);
> +	nested_copy_vmcb_save_to_cache(svm, save);

This is wrong (and this is due to a very non obivous way SVM restores
the nested state which I would like to rewrite.)

On SVM we migrate L2's control area, and *L1's save* area inside a single vmcb
while L2's save area is supposed to be migrated with regular KVM_SET_{S}REGS ioctls.


So I think you want something like this instead:


diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4cd53a56f3ebc..fcb38b220e706 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1409,8 +1409,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	if (is_guest_mode(vcpu))
 		svm_leave_nested(svm);
-	else
+	else {
 		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
+		nested_copy_vmcb_save_to_cache(svm, svm->nested.vmcb02.ptr->save);
+	}
 
 	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));


Note two branches here. If we are already in guest mode (qemu currently doesn't set
nested state while already in guest mode, but I added this to make this code
more robust, then we leave it for a while, to make the following code assume correctly
that we are not in guest mode, then it returns us back to the guest mode and never
touches the save area of L2, thus its cache shouldn't update either.

If we are in normal non guest mode, then as you see we just copy the whole L1
save area to L2, because the assumption is that at least some L2 state is there,
restored earlier (currently the result of KVM_SET_REGS), and after nested state
is set, qemu then restores the regular L2 registers with KVM_SET_REGS,
and other stuff like msrs.

So at the point of this copying, we need to update the cache.




>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
>  	nested_vmcb02_prepare_control(svm);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 69639f9624f5..bf171f5f6158 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4386,6 +4386,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  			vmcb12 = map.hva;
>  
>  			nested_load_control_from_vmcb12(svm, &vmcb12->control);
> +			nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);

This looks correct.

>  
>  			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
>  			kvm_vcpu_unmap(vcpu, &map, true);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index bd0fe94c2920..f0195bc263e9 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -103,6 +103,19 @@ struct kvm_vmcb_info {
>  	uint64_t asid_generation;
>  };
>  
> +/*
> + * This struct is not kept up-to-date, and it is only valid within
> + * svm_set_nested_state and nested_svm_vmrun.
> + */
> +struct vmcb_save_area_cached {
> +	u64 efer;
> +	u64 cr4;
> +	u64 cr3;
> +	u64 cr0;
> +	u64 dr7;
> +	u64 dr6;
> +};
> +
>  struct svm_nested_state {
>  	struct kvm_vmcb_info vmcb02;
>  	u64 hsave_msr;
> @@ -119,6 +132,7 @@ struct svm_nested_state {
>  
>  	/* cache for control fields of the guest */
>  	struct vmcb_control_area ctl;
> +	struct vmcb_save_area_cached save;
>  
>  	bool initialized;
>  };
> @@ -484,6 +498,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>  int nested_svm_exit_special(struct vcpu_svm *svm);
>  void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
>  				     struct vmcb_control_area *control);
> +void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
> +				  struct vmcb_save_area *save);
>  void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
>  void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
>  void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);

Note that you need to rebase this and most other patches, due to changes (mostly mine, sorry)
in the kvm/queue. Conflicts are mostly trivial though.


Best regards,
	Maxim Levitsky


