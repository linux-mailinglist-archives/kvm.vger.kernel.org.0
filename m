Return-Path: <kvm+bounces-2443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BF597F7895
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 17:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A784281345
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 16:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93AF133CE9;
	Fri, 24 Nov 2023 16:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zz534stY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F931998
	for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 08:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700842112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cmsrkiY67tdSL4I4FDP974bqK0BocuUfUMFhGGwoOH0=;
	b=Zz534stYnlfhPYKGEf+Y0/zYMe3Ontdri2HIRSVDGhjfXXBDK2NashIiEty7dT1eRoo3wW
	CwqZNaGNQiW69tpM0dClD52hNK0twltr+mvhcgFOGmvxdaPzhlNeBRoEaa3VH0Viz/koBU
	+XeTriLFwRbr3hw2I5UJ1PbE17PuO9k=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-KtEr3TJQMzGqd3wOLtgn4g-1; Fri, 24 Nov 2023 11:08:31 -0500
X-MC-Unique: KtEr3TJQMzGqd3wOLtgn4g-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-677fc5fa42aso26879506d6.2
        for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 08:08:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700842110; x=1701446910;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cmsrkiY67tdSL4I4FDP974bqK0BocuUfUMFhGGwoOH0=;
        b=xPdV8PZjw8wU1/qJ8dHG11zu8axet0FIuxC7f9CYVl5OXs+9wE7Mpj6jpacLXmhf2O
         LGlxnOaCYigy50hR77nDZFwXXCMkgMlXBUxLjChvdrpZj2j5aGlLzScbr1HyMDXcFz1a
         TzVV2uZrSqrIUYRj5zuLfWb/NS+afioWQ9jWfYD3g0bJfu6MA8NhWNN6L5FxKDlX+3DO
         bpCJ856RnNR+Ou/hiMytDv2xPxmeS8dMoSSc99d9FQtksNCQZpjts5i7iYsmBjNJAhtW
         /9JG5Fta6fDy7z7DwC2TKpgECh3K0EwzQIt32ASHOzcAV69PLayF1qzhX2uYMcE+M/JN
         t6gA==
X-Gm-Message-State: AOJu0YztjCzK9CMAx+DU6OE+hz0nbaCrwXMzRO0Ik2sD0jhzHgLINAoZ
	GWgBWl+0W/p7DqzaphM+FVgDhk+9gBi9vhiTya/lpbrf1tXrZbxY9AD3nCuLkVggJUIWgFGgnBv
	7dBYw2EBV3iti
X-Received: by 2002:a0c:efc8:0:b0:66f:bc3f:bd7 with SMTP id a8-20020a0cefc8000000b0066fbc3f0bd7mr3703821qvt.27.1700842110521;
        Fri, 24 Nov 2023 08:08:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGXQy7rC3OFnwpDFz32XJyMJXH3K21FMQ2Wp7skKcym3brbTwQY0ByVOhsgcc9sEZN9TK9xqQ==
X-Received: by 2002:a0c:efc8:0:b0:66f:bc3f:bd7 with SMTP id a8-20020a0cefc8000000b0066fbc3f0bd7mr3703805qvt.27.1700842110328;
        Fri, 24 Nov 2023 08:08:30 -0800 (PST)
Received: from [10.32.181.74] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id p15-20020ad451cf000000b0067a1cf7737bsm333015qvq.130.2023.11.24.08.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Nov 2023 08:08:29 -0800 (PST)
Message-ID: <da4b9e89-00c7-4067-b962-e86805a345c6@redhat.com>
Date: Fri, 24 Nov 2023 17:08:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] KVM: x86: add more information to the kvm_entry
 tracepoint
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>
References: <20230928103640.78453-1-mlevitsk@redhat.com>
 <20230928103640.78453-3-mlevitsk@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20230928103640.78453-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/28/23 12:36, Maxim Levitsky wrote:
> Add VMX/SVM specific interrupt injection info to vm entry tracepoint.
> Also add a flag showing that immediate vm exit is set to happen after
> the entry.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>   arch/x86/include/asm/kvm_host.h    |  5 ++++-
>   arch/x86/kvm/svm/svm.c             | 17 +++++++++++++++++
>   arch/x86/kvm/trace.h               | 15 +++++++++++++--
>   arch/x86/kvm/vmx/vmx.c             | 12 ++++++++++++
>   5 files changed, 47 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index f654a7f4cc8c0c..346fed6e3c33aa 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -99,6 +99,7 @@ KVM_X86_OP(get_l2_tsc_multiplier)
>   KVM_X86_OP(write_tsc_offset)
>   KVM_X86_OP(write_tsc_multiplier)
>   KVM_X86_OP(get_exit_info)
> +KVM_X86_OP(get_entry_info)
>   KVM_X86_OP(check_intercept)
>   KVM_X86_OP(handle_exit_irqoff)
>   KVM_X86_OP(sched_in)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 383a1d0cc0743b..321721813474f7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1679,13 +1679,16 @@ struct kvm_x86_ops {
>   	void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu);
>   
>   	/*
> -	 * Retrieve somewhat arbitrary exit information.  Intended to
> +	 * Retrieve somewhat arbitrary exit/entry information.  Intended to
>   	 * be used only from within tracepoints or error paths.
>   	 */
>   	void (*get_exit_info)(struct kvm_vcpu *vcpu, u32 *reason,
>   			      u64 *info1, u64 *info2,
>   			      u32 *exit_int_info, u32 *exit_int_info_err_code);
>   
> +	void (*get_entry_info)(struct kvm_vcpu *vcpu,
> +				u32 *inj_info, u32 *inj_info_error_code);
> +
>   	int (*check_intercept)(struct kvm_vcpu *vcpu,
>   			       struct x86_instruction_info *info,
>   			       enum x86_intercept_stage stage,
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 60b130b7f9d510..cd65c04be3d0e2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3504,6 +3504,22 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>   		*error_code = 0;
>   }
>   
> +static void svm_get_entry_info(struct kvm_vcpu *vcpu,
> +			u32 *inj_info,
> +			u32 *inj_info_error_code)
> +{
> +	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
> +
> +	*inj_info = control->event_inj;
> +
> +	if ((*inj_info & SVM_EXITINTINFO_VALID) &&
> +	    (*inj_info & SVM_EXITINTINFO_VALID_ERR))
> +		*inj_info_error_code = control->event_inj_err;
> +	else
> +		*inj_info_error_code = 0;
> +
> +}
> +
>   static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4992,6 +5008,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.required_apicv_inhibits = AVIC_REQUIRED_APICV_INHIBITS,
>   
>   	.get_exit_info = svm_get_exit_info,
> +	.get_entry_info = svm_get_entry_info,
>   
>   	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
>   
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 83843379813ee3..28e8a63368cc02 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -21,14 +21,25 @@ TRACE_EVENT(kvm_entry,
>   	TP_STRUCT__entry(
>   		__field(	unsigned int,	vcpu_id		)
>   		__field(	unsigned long,	rip		)
> -	),
> +		__field(	u32,		inj_info	)
> +		__field(	u32,		inj_info_err	)
> +		__field(	bool,		req_imm_exit	)
> +		),
>   
>   	TP_fast_assign(
>   		__entry->vcpu_id        = vcpu->vcpu_id;
>   		__entry->rip		= kvm_rip_read(vcpu);
> +		__entry->req_imm_exit	= vcpu->arch.req_immediate_exit;
> +
> +		static_call(kvm_x86_get_entry_info)(vcpu,
> +					  &__entry->inj_info,
> +					  &__entry->inj_info_err);
>   	),
>   
> -	TP_printk("vcpu %u, rip 0x%lx", __entry->vcpu_id, __entry->rip)
> +	TP_printk("vcpu %u, rip 0x%lx inj 0x%08x inj_error_code 0x%08x%s",
> +			__entry->vcpu_id, __entry->rip,
> +			__entry->inj_info, __entry->inj_info_err,
> +			__entry->req_imm_exit ? " [req_imm_exit]" : "")
>   );
>   
>   /*
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index eb7e42235e8811..9dd13f52d4999c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6156,6 +6156,17 @@ static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>   	}
>   }
>   
> +static void vmx_get_entry_info(struct kvm_vcpu *vcpu,
> +			      u32 *inj_info,
> +			      u32 *inj_info_error_code)
> +{
> +	*inj_info = vmcs_read32(VM_ENTRY_INTR_INFO_FIELD);
> +	if (is_exception_with_error_code(*inj_info))
> +		*inj_info_error_code = vmcs_read32(VM_ENTRY_EXCEPTION_ERROR_CODE);
> +	else
> +		*inj_info_error_code = 0;
> +}
> +
>   static void vmx_destroy_pml_buffer(struct vcpu_vmx *vmx)
>   {
>   	if (vmx->pml_pg) {
> @@ -8297,6 +8308,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>   	.get_mt_mask = vmx_get_mt_mask,
>   
>   	.get_exit_info = vmx_get_exit_info,
> +	.get_entry_info = vmx_get_entry_info,
>   
>   	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
>   

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>


