Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C04303C23
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 12:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405421AbhAZLw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 06:52:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405458AbhAZLwG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 06:52:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611661840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SILO0IvFQEm5YDmK2vltUgaI/9xMJ74zaX6JPESGWag=;
        b=aL5bFUn5vOKTFMKq5AHfIC6LeX/JPI6Bn+wvyOt2l9jFr+NS9ZfEENewWVhJUk/ctiDJcu
        T5xVd1Jk1FDJ8Fsq7Rc3nA+7K40KaPx2OdkvbhdUVvHaK0QSiD0hGAy5kjGMkyF0Byk96b
        mwzarGPz8Be75UUsc+r5lB+rGGCzxg0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-xWJC4Uq6MQeerYUQxr-2Ig-1; Tue, 26 Jan 2021 06:50:38 -0500
X-MC-Unique: xWJC4Uq6MQeerYUQxr-2Ig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E086C100E33A;
        Tue, 26 Jan 2021 11:50:33 +0000 (UTC)
Received: from starship (unknown [10.35.206.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7565F5BBAD;
        Tue, 26 Jan 2021 11:50:29 +0000 (UTC)
Message-ID: <bae0e578fbf00db7b61465c240679bad8e672105.camel@redhat.com>
Subject: Re: [PATCH v3 2/4] KVM: SVM: Add emulation support for #GP
 triggered by SVM instructions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
Date:   Tue, 26 Jan 2021 13:50:28 +0200
In-Reply-To: <20210126081831.570253-3-wei.huang2@amd.com>
References: <20210126081831.570253-1-wei.huang2@amd.com>
         <20210126081831.570253-3-wei.huang2@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-26 at 03:18 -0500, Wei Huang wrote:
> From: Bandan Das <bsd@redhat.com>
> 
> While running SVM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
> CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
> before checking VMCB's instruction intercept. If EAX falls into such
> memory areas, #GP is triggered before VMEXIT. This causes problem under
> nested virtualization. To solve this problem, KVM needs to trap #GP and
> check the instructions triggering #GP. For VM execution instructions,
> KVM emulates these instructions.
> 
> Co-developed-by: Wei Huang <wei.huang2@amd.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 109 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 91 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7ef171790d02..e5ca01e25e89 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -200,6 +200,8 @@ module_param(sev_es, int, 0444);
>  bool __read_mostly dump_invalid_vmcb;
>  module_param(dump_invalid_vmcb, bool, 0644);
>  
> +bool svm_gp_erratum_intercept = true;
I'll expect this to be a module parm, so that user
could override it, just like enable_vmware_backdoor

> +
>  static u8 rsm_ins_bytes[] = "\x0f\xaa";
>  
>  static void svm_complete_interrupts(struct vcpu_svm *svm);
> @@ -288,6 +290,9 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  		if (!(efer & EFER_SVME)) {
>  			svm_leave_nested(svm);
>  			svm_set_gif(svm, true);
> +			/* #GP intercept is still needed in vmware_backdoor */
> +			if (!enable_vmware_backdoor)
I would use if (svm_gp_erratum_intercept && !enable_vmware_backdoor) to document
this.

> +				clr_exception_intercept(svm, GP_VECTOR);
>  
>  			/*
>  			 * Free the nested guest state, unless we are in SMM.
> @@ -309,6 +314,10 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  
>  	svm->vmcb->save.efer = efer | EFER_SVME;
>  	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
> +	/* Enable #GP interception for SVM instructions */
> +	if (svm_gp_erratum_intercept)
> +		set_exception_intercept(svm, GP_VECTOR);
> +
>  	return 0;
>  }
>  
> @@ -1957,24 +1966,6 @@ static int ac_interception(struct vcpu_svm *svm)
>  	return 1;
>  }
>  
> -static int gp_interception(struct vcpu_svm *svm)
> -{
> -	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	u32 error_code = svm->vmcb->control.exit_info_1;
> -
> -	WARN_ON_ONCE(!enable_vmware_backdoor);	
> -
> -	/*
> -	 * VMware backdoor emulation on #GP interception only handles IN{S},
> -	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
> -	 */
> -	if (error_code) {
> -		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> -		return 1;
> -	}
> -	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
> -}
> -
>  static bool is_erratum_383(void)
>  {
>  	int err, i;
> @@ -2173,6 +2164,88 @@ static int vmrun_interception(struct vcpu_svm *svm)
>  	return nested_svm_vmrun(svm);
>  }
>  
> +enum {
> +	NONE_SVM_INSTR,
> +	SVM_INSTR_VMRUN,
> +	SVM_INSTR_VMLOAD,
> +	SVM_INSTR_VMSAVE,
> +};
> +
> +/* Return NONE_SVM_INSTR if not SVM instrs, otherwise return decode result */
> +static int svm_instr_opcode(struct kvm_vcpu *vcpu)
> +{
> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +
> +	if (ctxt->b != 0x1 || ctxt->opcode_len != 2)
> +		return NONE_SVM_INSTR;
> +
> +	switch (ctxt->modrm) {
> +	case 0xd8: /* VMRUN */
> +		return SVM_INSTR_VMRUN;
> +	case 0xda: /* VMLOAD */
> +		return SVM_INSTR_VMLOAD;
> +	case 0xdb: /* VMSAVE */
> +		return SVM_INSTR_VMSAVE;
> +	default:
> +		break;
> +	}
> +
> +	return NONE_SVM_INSTR;
> +}
> +
> +static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
> +{
> +	int (*const svm_instr_handlers[])(struct vcpu_svm *svm) = {
> +		[SVM_INSTR_VMRUN] = vmrun_interception,
> +		[SVM_INSTR_VMLOAD] = vmload_interception,
> +		[SVM_INSTR_VMSAVE] = vmsave_interception,
> +	};
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	return svm_instr_handlers[opcode](svm);
> +}
> +
> +/*
> + * #GP handling code. Note that #GP can be triggered under the following two
> + * cases:
> + *   1) SVM VM-related instructions (VMRUN/VMSAVE/VMLOAD) that trigger #GP on
> + *      some AMD CPUs when EAX of these instructions are in the reserved memory
> + *      regions (e.g. SMM memory on host).
> + *   2) VMware backdoor
> + */
> +static int gp_interception(struct vcpu_svm *svm)
> +{
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	u32 error_code = svm->vmcb->control.exit_info_1;
> +	int opcode;
> +
> +	/* Both #GP cases have zero error_code */
> +	if (error_code)
> +		goto reinject;
> +
> +	/* Decode the instruction for usage later */
> +	if (x86_decode_emulated_instruction(vcpu, 0, NULL, 0) != EMULATION_OK)
> +		goto reinject;
> +
> +	opcode = svm_instr_opcode(vcpu);
> +
> +	if (opcode == NONE_SVM_INSTR) {
> +		WARN_ON_ONCE(!enable_vmware_backdoor);
> +
> +		/*
> +		 * VMware backdoor emulation on #GP interception only handles
> +		 * IN{S}, OUT{S}, and RDPMC.
> +		 */
> +		return kvm_emulate_instruction(vcpu,
> +				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
> +	} else

I would check svm_gp_erratum_intercept here, not do any emulation
if not set, and print a warning.

> +		return emulate_svm_instr(vcpu, opcode);
> +
> +reinject:
> +	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> +	return 1;
> +}
> +
>  void svm_set_gif(struct vcpu_svm *svm, bool value)
>  {
>  	if (value) {


Best regards,
	Maxim Levitsky

