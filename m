Return-Path: <kvm+bounces-8642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 712FC853F3D
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 23:55:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 942BD1C268B0
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 22:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E9262814;
	Tue, 13 Feb 2024 22:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OkhY7/Uc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A93627EA
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 22:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707864941; cv=none; b=JkfLQCC8+omIsS1I2IEWNdAVlnKGdS8HqiUFyyRkADPRc0EzJCdQiH1AV1yV9Ps5yTxZlyVZnezE36PHQ7QoKuNY2dn5+cdqMS3M6PpsHSkHQpCc7Wjb3cFJB5T2SRuMIuC71F5x3O9GXlvUkOY205cLZB4dOVMl81XkVgioqlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707864941; c=relaxed/simple;
	bh=6bIqARQafQOI+oOtGpkDwD/hAKfwxg9IRBSpXMr1j2k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y+KMvRIyNC9c1Ro7iKtuEEEvfgHPy5aa6bbp8pvq8gPgBqe6/rAJGZHtSoai4Wy1jjz726bsDSnroKiXYxE/6a8UsshLi3iC4I+WI4WAXrpsvZgK81o3hp4WifdUZi9VS0bKdkpX4oz2Wz1UBDyLwxR+TgTJ6Ejem8Zqp9YdHRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OkhY7/Uc; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60788151153so16767217b3.3
        for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 14:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707864939; x=1708469739; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yOy1BgJS5o8h8aPqelg2Ns2PMEIFHBsWcoJeNJUIqbM=;
        b=OkhY7/Uc5pdzHaQJedn14SwNRvQ7XjC9Me7vCg/8VGV/cyeOXvHqZW1E3RAZco8Xz1
         mFYvBiIrJTmW2suBEwon8SQV41vq6nvxxLjxz70QgAclBGTZfCjPSEZS1ncLxuOn1usb
         GwB+84T5gdSO03zVf3MOBhhNxpJfiN5joAg2952rZLfCSXbg8+jwqyaCXKCsvst3QPnw
         RtDcnqK4u05GrEdG+RRZ9L7/bBxx0eXyKMNTV7z7E0MwRUxlRiqzHOzibNoaKCgSVoem
         mIdAchgarCGkbHzCcTAtXdst7II59zIsd5nqDg2jzhNEIhn3+WBydA5/fZOz2LoLYQ5Q
         Rtyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707864939; x=1708469739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yOy1BgJS5o8h8aPqelg2Ns2PMEIFHBsWcoJeNJUIqbM=;
        b=lUAwmwqqThCA+Kvo21nnQ1IUiEqNVrNiq08qg+vmwHPPhCfqZHiG069XppBNFwou+1
         ND5p90rx4rod0/8KgzoiZZSDy0qScXJFJWDfnU7TQ6vfT51W8Tc+3Y8Bncf6Yu62kqRK
         Zv0y5bZ8yYxoCd8TXMWQlQzMErbyIlO7Kbu0d77GmNhPVxtZFMdGB0ZnW9/z0gBFQu++
         JSNqIcHjgc5MMQXqqhhioh5jvPeeQoSXEIK/qw97p4lU5ev8EzSzGmwJb9KchBYbMBg+
         04gIYc37Wb8UdcIqqeDuAzLtxg/bMjCBQ8NZ+8glgEp3osfVXx2blZ9vgN/hkrIxp7cb
         pVuw==
X-Forwarded-Encrypted: i=1; AJvYcCVMHs6sAVhdOD5vdy49Dzu5NY78o88r5XOHrEVEHekBEmGhwN7J6qKwm2beWWGRMX1rDXijUR4NJtUyNbvkGzDq7zOA
X-Gm-Message-State: AOJu0Yxq16BvZsxQ0zvsY0cfKrXbsmAfTQDO7JTLD3H2cOtgcBELFhAo
	n0FlBnGnk0duqDb3jCD1tjEGijsr12mibxiebx/KsRMnBnfYbK2tP5tgnKcOFc+uK7D+pJizWWw
	igQ==
X-Google-Smtp-Source: AGHT+IHQAzS7C+vwrTRQVHpAmuOQZwuyBYtRsp3POOJXEkDoJbxX2Fsa92TFul5jA7j0r3yWScgxyMN80k8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100f:b0:dc2:5273:53f9 with SMTP id
 w15-20020a056902100f00b00dc2527353f9mr33046ybt.1.1707864939382; Tue, 13 Feb
 2024 14:55:39 -0800 (PST)
Date: Tue, 13 Feb 2024 14:55:37 -0800
In-Reply-To: <20240206182032.1596-2-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240206182032.1596-1-xin3.li@intel.com> <20240206182032.1596-2-xin3.li@intel.com>
Message-ID: <ZcvzaZBKUKsKr6BN@google.com>
Subject: Re: [PATCH v5 2/2] KVM: VMX: Cleanup VMX misc information defines and usages
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin3.li@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	weijiang.yang@intel.com, kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 06, 2024, Xin Li wrote:
> Define VMX misc information fields with BIT_ULL()/GENMASK_ULL(), and move
> VMX misc field macros to vmx.h if used in multiple files or where they are
> used only once.

Yeah, no.  This changelog doesn't even begin to cover what all is going on here,
and as with the first patch, this obviously needs to be split into multiple
patches.

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 80fea1875948..a9dfda2cbca3 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -917,6 +917,8 @@ static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +#define VMX_MISC_MSR_LIST_MULTIPLIER	512
> +
>  static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -1315,18 +1317,34 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
>  	return 0;
>  }
>  
> +#define VMX_MISC_SAVE_EFER_LMA		BIT_ULL(5)
> +#define VMX_MISC_ACTIVITY_STATE_BITMAP	GENMASK_ULL(8, 6)
> +#define VMX_MISC_ACTIVITY_HLT		BIT_ULL(6)
> +#define VMX_MISC_ACTIVITY_WAIT_SIPI	BIT_ULL(8)
> +#define VMX_MISC_RDMSR_IN_SMM		BIT_ULL(15)
> +#define VMX_MISC_VMXOFF_BLOCK_SMI	BIT_ULL(28)

Gah, my bad.  I misread a comment in v1, and gave nonsensical feedback.  I thought
the comment was saying that #defines for the *reserved* bits should be in vmx.h
but you were talking about moving existing defines from msr-index.h to vmx.h.
Defining feature bits in nested.c, and thus splitting the VMX_MISC feature bit
definitions across multiple locations, doesn't make any sense.  Sorry for the
confusion.

 : > Probably should also move VMX MSR field defs from msr-index.h to
 : > a vmx header file.
 : 
 : Why bother putting them in a header?  As above, it's extremely unlikely anything
 : besides vmx_restore_vmx_basic() will ever care about exactly which bits are
 : reserved.

> +#define VMX_MISC_FEATURES_MASK			\
> +	(VMX_MISC_SAVE_EFER_LMA |		\
> +	 VMX_MISC_ACTIVITY_STATE_BITMAP |	\
> +	 VMX_MISC_INTEL_PT |			\
> +	 VMX_MISC_RDMSR_IN_SMM |		\
> +	 VMX_MISC_VMXOFF_BLOCK_SMI |		\
> +	 VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |	\
> +	 VMX_MISC_ZERO_LEN_INS)
> +
> +#define VMX_MISC_RESERVED_BITS			\
> +	(BIT_ULL(31) | GENMASK_ULL(13, 9))
> +
>  static inline bool nested_cpu_has_zero_length_injection(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index dc163a580f98..96f0d65dea45 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2570,7 +2570,6 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	u32 _vmexit_control = 0;
>  	u32 _vmentry_control = 0;
>  	u64 basic_msr;
> -	u64 misc_msr;
>  	int i;
>  
>  	/*
> @@ -2704,8 +2703,6 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	if (vmx_basic_vmcs_mem_type(basic_msr) != MEM_TYPE_WB)
>  		return -EIO;
>  
> -	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
> -
>  	vmcs_conf->basic = basic_msr;
>  	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
>  	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
> @@ -2713,7 +2710,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
>  	vmcs_conf->vmexit_ctrl         = _vmexit_control;
>  	vmcs_conf->vmentry_ctrl        = _vmentry_control;
> -	vmcs_conf->misc	= misc_msr;
> +
> +	rdmsrl(MSR_IA32_VMX_MISC, vmcs_conf->misc);

No, keep the local variable.  It's unlikely KVM will require a feature that is
enumerated in VMX_MISC, but it's not impossible, at which point we'd have to revert
this change.

And more importantly, if we messed up and forgot to revert this change, it's
slightly more like that the compiler will fail to detect an "uninitialized" access,
e.g. if vmcs_conf->misc were read before it was filled by rdmsrl().

Uninitialized in quotes because the usage from hardware_setup() isn't truly
uninitialized, i.e. it will be zeros.  If we had a bug as above, we'd be relying
on the compiler to see that vmx_check_processor_compat()'s vmx_cap can get used
uninitialized, whereas the current code should be easily flagged if misc_msr is
used before it's written.

