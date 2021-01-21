Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCD32FECA6
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbhAUOIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:08:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730020AbhAUOFp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 09:05:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611237858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sp6rLbwiHZzd3veiVsN2ORKZEPLAFluLK58UL3HjX8M=;
        b=ACVJJSRzPsoeczcAnW2IEBtY1yTK92AFLELaBTlPh1CtDQaFHWP0qLn5odzh/0fgLbsFUZ
        H/2jnEWCqtLr8PedN3bJLLcrfKDMCw+ajFUI896k1s/vkp+SAATXb+0ma4/WkXCXZjTvXG
        ITSCI/EkXFPBrzBBKJLGoX3Z4l1Wv+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-I18_8X0iPTWVDQFiq42UuA-1; Thu, 21 Jan 2021 09:04:16 -0500
X-MC-Unique: I18_8X0iPTWVDQFiq42UuA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7983E767;
        Thu, 21 Jan 2021 14:04:05 +0000 (UTC)
Received: from starship (unknown [10.35.206.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52F8D1971A;
        Thu, 21 Jan 2021 14:04:01 +0000 (UTC)
Message-ID: <82a82abaab276fd75f0cb47f1a32d5a44fa3bec5.camel@redhat.com>
Subject: Re: [PATCH v2 1/4] KVM: x86: Factor out x86 instruction emulation
 with decoding
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
Date:   Thu, 21 Jan 2021 16:04:00 +0200
In-Reply-To: <20210121065508.1169585-2-wei.huang2@amd.com>
References: <20210121065508.1169585-1-wei.huang2@amd.com>
         <20210121065508.1169585-2-wei.huang2@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-01-21 at 01:55 -0500, Wei Huang wrote:
> Move the instruction decode part out of x86_emulate_instruction() for it
> to be used in other places. Also kvm_clear_exception_queue() is moved
> inside the if-statement as it doesn't apply when KVM are coming back from
> userspace.
> 
> Co-developed-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> ---
>  arch/x86/kvm/x86.c | 63 +++++++++++++++++++++++++++++-----------------
>  arch/x86/kvm/x86.h |  2 ++
>  2 files changed, 42 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a8969a6dd06..580883cee493 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7298,6 +7298,43 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
>  	return false;
>  }
>  
> +/*
> + * Decode and emulate instruction. Return EMULATION_OK if success.
> + */
> +int x86_emulate_decoded_instruction(struct kvm_vcpu *vcpu, int emulation_type,
> +				    void *insn, int insn_len)

Isn't the name of this function wrong? This function decodes the instruction.
So I would expect something like x86_decode_instruction.

> +{
> +	int r = EMULATION_OK;
> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +
> +	init_emulate_ctxt(vcpu);
> +
> +	/*
> +	 * We will reenter on the same instruction since
> +	 * we do not set complete_userspace_io.  This does not
> +	 * handle watchpoints yet, those would be handled in
> +	 * the emulate_ops.
> +	 */
> +	if (!(emulation_type & EMULTYPE_SKIP) &&
> +	    kvm_vcpu_check_breakpoint(vcpu, &r))
> +		return r;
> +
> +	ctxt->interruptibility = 0;
> +	ctxt->have_exception = false;
> +	ctxt->exception.vector = -1;
> +	ctxt->perm_ok = false;
> +
> +	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
> +
> +	r = x86_decode_insn(ctxt, insn, insn_len);
> +
> +	trace_kvm_emulate_insn_start(vcpu);
> +	++vcpu->stat.insn_emulation;
> +
> +	return r;
> +}
> +EXPORT_SYMBOL_GPL(x86_emulate_decoded_instruction);
> +
>  int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			    int emulation_type, void *insn, int insn_len)
>  {
> @@ -7317,32 +7354,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	 */
>  	write_fault_to_spt = vcpu->arch.write_fault_to_shadow_pgtable;
>  	vcpu->arch.write_fault_to_shadow_pgtable = false;
> -	kvm_clear_exception_queue(vcpu);

I think that this change is OK, but I can't be 100% sure about this.

Best regards,
	Maxim Levitsky


>  
>  	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
> -		init_emulate_ctxt(vcpu);
> -
> -		/*
> -		 * We will reenter on the same instruction since
> -		 * we do not set complete_userspace_io.  This does not
> -		 * handle watchpoints yet, those would be handled in
> -		 * the emulate_ops.
> -		 */
> -		if (!(emulation_type & EMULTYPE_SKIP) &&
> -		    kvm_vcpu_check_breakpoint(vcpu, &r))
> -			return r;
> -
> -		ctxt->interruptibility = 0;
> -		ctxt->have_exception = false;
> -		ctxt->exception.vector = -1;
> -		ctxt->perm_ok = false;
> -
> -		ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
> -
> -		r = x86_decode_insn(ctxt, insn, insn_len);
> +		kvm_clear_exception_queue(vcpu);
>  
> -		trace_kvm_emulate_insn_start(vcpu);
> -		++vcpu->stat.insn_emulation;
> +		r = x86_emulate_decoded_instruction(vcpu, emulation_type,
> +						    insn, insn_len);
>  		if (r != EMULATION_OK)  {
>  			if ((emulation_type & EMULTYPE_TRAP_UD) ||
>  			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) {
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index c5ee0f5ce0f1..fc42454a4c27 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -273,6 +273,8 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
>  					  int page_num);
>  bool kvm_vector_hashing_enabled(void);
>  void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
> +int x86_emulate_decoded_instruction(struct kvm_vcpu *vcpu, int emulation_type,
> +				    void *insn, int insn_len);
>  int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			    int emulation_type, void *insn, int insn_len);
>  fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);





