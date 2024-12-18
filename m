Return-Path: <kvm+bounces-34077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB8859F6F0B
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 21:53:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26AF316CB91
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 20:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D311FC7C5;
	Wed, 18 Dec 2024 20:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bW8ViJH1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F24DF50F
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 20:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734555225; cv=none; b=Mmw4GBd4vol1pHe0J8PFAS3/73S6e0cfSl6nGS/7Dcahhn/ceWTOcbDjTShq4K5U4Wzj/yxR5+34sj+JWlb+2sy8RH/gpeqeNeQDkKt88DMTDk+sLIwRJBO4RuvyKMe3TsdDSWWjCJWZBNmaPJAyKlKAJXPIw1Fg7K/g+7K1AvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734555225; c=relaxed/simple;
	bh=tbndU0CH3Ux/H0STSrmi9DQAdLraZl4TTTQ4k/4eLdQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FB02ILY2AUlWI5XfWNl2ZVgsIn49QMYoTbk5dZAWLsI1Tt5SFDl9Qk0ZsONnESD8UqZclqI5Tta5qyrtVHUTfZOYMCokGyro/kRYDujeuJQ3Id/UENqDHthcPnNIyxhN9F4hQUiEPHiCgNvL0sefiOGT6jS5r5JU6HC3kS8m7V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bW8ViJH1; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fd312feb10so4242409a12.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 12:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734555223; x=1735160023; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KcmkQkX1okORg3dSLLX/PAORFgZuQBmPqHo6FpGFwd8=;
        b=bW8ViJH166nT1NEuGFQ9aMp5qaCHksQgQ+wDq8I5rzYIa7eBlxVvWJX/g8+kIOTD6w
         DxYFl8di6R0pQ0mZNnylfiVpZtmCDPxtsJBrMcmhIQ5V7iBaPzrfIh20ROZlzX5pzzNe
         98BKD+iv8MvqYO6gm9MkdILe8gshPGvW2bqCHJatDetRAV1dprBCsMOxPLZzcZLAT6c7
         NtqajVKECXNKcVN72Ftgva47oPiecX5U/Z0eCcngKIGbmUAd5JzSYR+Xt7281DR7du0B
         23tpSZkyX6tvEl2VkUbCqQBdkFw6NFGS4ia3P47Hc9OocE1Tideau/tLSHLEfFKZhkwa
         Zllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734555223; x=1735160023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KcmkQkX1okORg3dSLLX/PAORFgZuQBmPqHo6FpGFwd8=;
        b=OFgdhdqTDCpa9Eh/F0ZUDCNCGcmPhb1qjsdC9vdAJw1rI1Tp0eB+hDFMDmNI6sQDS3
         3cpr3COPaor3LaZs6njPxObInB75So5S47MkwBxB0Npq/0YihaSxupla9Va9uEjMK7ou
         LCTWxl7j+80aLDXIburVQQQ0ui34IcFGenVVX4sJpJoY69MMfGQyZUORRQZZnXsSNy4R
         IzelTxLblFNjrlV8L/jxDAXep41LzAZ0DRzRcc9wCiDJQfLHz5t0i+x+hAHWj7MxVPAj
         m2+2aIuN2P+By5NXT2bV+vSBbCcvboBd6AtweDKWMOgN3zCoEo2scLSZkgPkkwYh2/sy
         3mbQ==
X-Gm-Message-State: AOJu0Yx5Bv/G9ci1wp4JOZoufOD5M02K1DJmEeNXchpSSQM4mijeSMSZ
	Xxb2dWCb3UkxRLfW1PIoHccCjxFLLlFsvNcwCzZLAyGBxz92KnlOiYEB8ITEm6YMghqaZ20lCm8
	11w==
X-Google-Smtp-Source: AGHT+IES2CJryLVxO1WYX/kyHRJUi/p/CUU6KpSZ3N1rD9ayFOamd5/JqlXWRXNXvBZZHMRLc7Dnk6ccg1Q=
X-Received: from pji6.prod.google.com ([2002:a17:90b:3fc6:b0:2ef:abba:8bfd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b4d:b0:2ee:a127:ba96
 with SMTP id 98e67ed59e1d1-2f2e9388a3amr4990268a91.23.1734555223491; Wed, 18
 Dec 2024 12:53:43 -0800 (PST)
Date: Wed, 18 Dec 2024 12:53:42 -0800
In-Reply-To: <20240910200350.264245-2-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240910200350.264245-1-mlevitsk@redhat.com> <20240910200350.264245-2-mlevitsk@redhat.com>
Message-ID: <Z2M2VkDpAzC7bXmp@google.com>
Subject: Re: [PATCH v5 1/3] KVM: x86: add more information to the kvm_entry tracepoint
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 10, 2024, Maxim Levitsky wrote:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 52443ccda320f..8118f75a8a35d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1756,13 +1756,16 @@ struct kvm_x86_ops {
>  	void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu);
>  
>  	/*
> -	 * Retrieve somewhat arbitrary exit information.  Intended to
> +	 * Retrieve somewhat arbitrary exit/entry information.  Intended to
>  	 * be used only from within tracepoints or error paths.
>  	 */
>  	void (*get_exit_info)(struct kvm_vcpu *vcpu, u32 *reason,
>  			      u64 *info1, u64 *info2,
>  			      u32 *exit_int_info, u32 *exit_int_info_err_code);
>  
> +	void (*get_entry_info)(struct kvm_vcpu *vcpu,
> +				u32 *inj_info, u32 *inj_info_error_code);

I vote to use the same names as the kvm_exit tracepoint, i.e. intr_into and
error_code throughout.  While I agree that capturing the "injection" aspect is
nice to have, if a user doesn't know that the fields are related to event/intr
injection, I don't think "inj" is going to help them connect the dots.

On the other, for cases where an event is re-injected, using the same names as
kvm_exit provides a direct connection between the event that was being vectored
at the time of exit, and the subsequent re-injection of the same event.

>  	int (*check_intercept)(struct kvm_vcpu *vcpu,
>  			       struct x86_instruction_info *info,
>  			       enum x86_intercept_stage stage,

...

>  	TP_fast_assign(
>  		__entry->vcpu_id        = vcpu->vcpu_id;
>  		__entry->rip		= kvm_rip_read(vcpu);
> -		__entry->immediate_exit	= force_immediate_exit;
> +		__entry->immediate_exit = force_immediate_exit;
> +		__entry->guest_mode     = is_guest_mode(vcpu);
> +
> +		static_call(kvm_x86_get_entry_info)(vcpu,
> +					  &__entry->inj_info,
> +					  &__entry->inj_info_err);
>  	),
>  
> -	TP_printk("vcpu %u, rip 0x%lx%s", __entry->vcpu_id, __entry->rip,
> -		  __entry->immediate_exit ? "[immediate exit]" : "")
> +	TP_printk("vcpu %u, rip 0x%lx inj 0x%08x inj_error_code 0x%08x%s%s",
> +		  __entry->vcpu_id, __entry->rip,
> +		  __entry->inj_info, __entry->inj_info_err,
> +		  __entry->immediate_exit ? "[immediate exit]" : "",
> +		  __entry->guest_mode ? "[guest]" : "")

I 100% agree kvm_entry should capture L1 vs. L2, but looking more closely, I
think we should make the entry and exit tracepoints, and then maybe rename
trace_kvm_nested_vmexit_inject() => trace_kvm_nested_vmexit().

Currently, trace_kvm_nested_vmexit() traces all exits from L2=>L0, which is rather
silly since it's trivial to capture L1 vs. L2 in kvm_exit.  I also find it to be
quite annoying since the vast, vast majority of time I don't want to trace *just*
L2=>L0 exits.  And it's especially annoying because if I want to see both L1 and
L2 exit, the trace contains a double dose of L2 exits.

Last thought, what about always capturing where the transition is occuring?  E.g.
instead of tagging on "[guest]" at the end, something like this:

	TP_printk("vcpu %u => L%u rip 0x%lx intr_info 0x%08x error_code 0x%08x%s",
		  __entry->vcpu_id, 1 + __entry->guest_mode,
		  ...

and then in kvm_exit:

	TP_printk("vcpu %u <= L%u reason %s%s%s rip 0x%lx info1 0x%016llx "  \
		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x "      \
		  "requests 0x%016llx",					     \
		  __entry->vcpu_id, 1 + __entry->guest_mode,		     \


Or use "to" and "from" if the "=>" / "<=" is too cute and confusing.

For now, I'm going to omit the is_guest_mode() change purely to avoid churn if
we end up squashing the current trace_kvm_nested_vmexit() into trace_kvm_exit().

As I'm about to disappear for two weeks, I'm going to speculatively apply the
below so I don't delay the meat of this patch any more than I already have.
Please holler if you disagree with the intr_info+error_code terminology, I'm
definitely open to other other names, though I do feel quite strongly that entry
and exit need to be consistent.  These are sitting at the head of "misc", so I
can fixup without much fuss.

---
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Tue, 10 Sep 2024 16:03:48 -0400
Subject: [PATCH 1/2] KVM: x86: Add interrupt injection information to the
 kvm_entry tracepoint

Add VMX/SVM specific interrupt injection info the kvm_entry tracepoint.
As is done with kvm_exit, gather the information via a kvm_x86_ops hook
to avoid the moderately costly VMREADs on VMX when the tracepoint isn't
enabled.

Opportunistically rename the parameters in the get_exit_info()
declaration to match the names used by both SVM and VMX.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20240910200350.264245-2-mlevitsk@redhat.com
[sean: drop is_guest_mode() change, use intr_info/error_code for names]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  7 +++++--
 arch/x86/kvm/svm/svm.c             | 16 ++++++++++++++++
 arch/x86/kvm/trace.h               |  9 ++++++++-
 arch/x86/kvm/vmx/main.c            |  1 +
 arch/x86/kvm/vmx/vmx.c             |  9 +++++++++
 arch/x86/kvm/vmx/x86_ops.h         |  3 +++
 7 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 5aff7222e40f..8c04472829a0 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -100,6 +100,7 @@ KVM_X86_OP(get_l2_tsc_multiplier)
 KVM_X86_OP(write_tsc_offset)
 KVM_X86_OP(write_tsc_multiplier)
 KVM_X86_OP(get_exit_info)
+KVM_X86_OP(get_entry_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
 KVM_X86_OP_OPTIONAL(update_cpu_dirty_logging)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a09ac99132c..c07d8318e9d8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1770,12 +1770,15 @@ struct kvm_x86_ops {
 	void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu);
 
 	/*
-	 * Retrieve somewhat arbitrary exit information.  Intended to
+	 * Retrieve somewhat arbitrary exit/entry information.  Intended to
 	 * be used only from within tracepoints or error paths.
 	 */
 	void (*get_exit_info)(struct kvm_vcpu *vcpu, u32 *reason,
 			      u64 *info1, u64 *info2,
-			      u32 *exit_int_info, u32 *exit_int_info_err_code);
+			      u32 *intr_info, u32 *error_code);
+
+	void (*get_entry_info)(struct kvm_vcpu *vcpu,
+			       u32 *intr_info, u32 *error_code);
 
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8fc2f4a97495..d06fe41a2de0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3542,6 +3542,21 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		*error_code = 0;
 }
 
+static void svm_get_entry_info(struct kvm_vcpu *vcpu, u32 *intr_info,
+			       u32 *error_code)
+{
+	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
+
+	*intr_info = control->event_inj;
+
+	if ((*intr_info & SVM_EXITINTINFO_VALID) &&
+	    (*intr_info & SVM_EXITINTINFO_VALID_ERR))
+		*error_code = control->event_inj_err;
+	else
+		*error_code = 0;
+
+}
+
 static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -5082,6 +5097,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.required_apicv_inhibits = AVIC_REQUIRED_APICV_INHIBITS,
 
 	.get_exit_info = svm_get_exit_info,
+	.get_entry_info = svm_get_entry_info,
 
 	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index d3aeffd6ae75..c2edf4a36fad 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -22,15 +22,22 @@ TRACE_EVENT(kvm_entry,
 		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned long,	rip		)
 		__field(	bool,		immediate_exit	)
+		__field(	u32,		intr_info	)
+		__field(	u32,		error_code	)
 	),
 
 	TP_fast_assign(
 		__entry->vcpu_id        = vcpu->vcpu_id;
 		__entry->rip		= kvm_rip_read(vcpu);
 		__entry->immediate_exit	= force_immediate_exit;
+
+		kvm_x86_call(get_entry_info)(vcpu, &__entry->intr_info,
+					     &__entry->error_code);
 	),
 
-	TP_printk("vcpu %u, rip 0x%lx%s", __entry->vcpu_id, __entry->rip,
+	TP_printk("vcpu %u, rip 0x%lx intr_info 0x%08x error_code 0x%08x%s",
+		  __entry->vcpu_id, __entry->rip,
+		  __entry->intr_info, __entry->error_code,
 		  __entry->immediate_exit ? "[immediate exit]" : "")
 );
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 92d35cc6cd15..697e135ba0f3 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -111,6 +111,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_mt_mask = vmx_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
+	.get_entry_info = vmx_get_entry_info,
 
 	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e93c48ff61c5..3fd6df782492 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6194,6 +6194,15 @@ void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 	}
 }
 
+void vmx_get_entry_info(struct kvm_vcpu *vcpu, u32 *intr_info, u32 *error_code)
+{
+	*intr_info = vmcs_read32(VM_ENTRY_INTR_INFO_FIELD);
+	if (is_exception_with_error_code(*intr_info))
+		*error_code = vmcs_read32(VM_ENTRY_EXCEPTION_ERROR_CODE);
+	else
+		*error_code = 0;
+}
+
 static void vmx_destroy_pml_buffer(struct vcpu_vmx *vmx)
 {
 	if (vmx->pml_pg) {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index a55981c5216e..f7f65e81920b 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -104,8 +104,11 @@ void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
 int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr);
 u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+
 void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		       u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
+void vmx_get_entry_info(struct kvm_vcpu *vcpu, u32 *intr_info, u32 *error_code);
+
 u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 void vmx_write_tsc_offset(struct kvm_vcpu *vcpu);

base-commit: 43651b98dd23e3d2d11f14964e98801ba58feccb
-- 

