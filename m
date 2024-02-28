Return-Path: <kvm+bounces-10178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 434BB86A64D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:04:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1DD5B2F661
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 01:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB3251CD15;
	Wed, 28 Feb 2024 01:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gBYzQSqD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668B212E61
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 01:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709085392; cv=none; b=ea/G1km7Lmn/H8+ivd7/RdXPNYe+LexRdnoGrcQyFAnWZMxDGu8BHzBnj+br5YlQSG+OG6AXubvSdRtdogvwKCVkMX/1KHk5ktCsq/glXOdlkxNfaszlmqZQXyVEsE+teC4rLMZfqiQ8qqr1D4M6IPvTAq3KysOt2qOtkILmFb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709085392; c=relaxed/simple;
	bh=mTBN/mIMAF+tMTQ+Q41YBv1U54K/+a90nLEKxBWWGc4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rOC0Ucg2i8kKs37Kxy7feRHJlugZPLue+1bRMgi6O7cCQK3sdJ/l6TeaIt0HRZsbiT012ho8e7uTJPcmlfd25+WSX5+KFsFAx2pvJ4e97kq8gXc97KFwBvRgbhfWow3uf5yfzDN7dMWrzJJhSUUuHHWkJJhCZNrFt3d+yzCsopM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gBYzQSqD; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5c5c8ef7d0dso4292983a12.2
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 17:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709085389; x=1709690189; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YlQx0n9QaqG70Z6/SQQdgrgVRhFsu+j9ICHDs9S9hig=;
        b=gBYzQSqD+33MzF492T260wQjBbnVlO3oegq0m47Y6z7yDclxmblxxWuxxu27nKCFXX
         bKV2ci+JrjeE1AOOpwqiL6rkm5yS6CQxrvr4W8pB7FP81PEySb9beYMgOGzmP07+H2lM
         /d2sdAnh6IQQS8bBp5XPjsSjuo7gQrrz2jdf/5fMK767oeHlpWZIZikgKfBz8XpBKTmq
         qV9Lh0WM5tIpLtCVW8TitrlrYBPktK2gsWmwIiTzCaFD/DXqm3oDqAHUYzU5HbaIYXkZ
         O/3gANGCepOw7SMyRc+GT7ApSB+QlSi6swaYsuenJjZDw5gaAkaj99+X9RUXnJx/FtJF
         kPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709085389; x=1709690189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YlQx0n9QaqG70Z6/SQQdgrgVRhFsu+j9ICHDs9S9hig=;
        b=oPEYkKBqiXJqugQ8eSfw6HbdcA780yarRX6FOh848sgEL4tjKGIpPiaTGYGfHdl59/
         wCN8toCUWvSg2fiApJ9QcdCO4QUXIVRVoUzC21VWGr0+0y8fdHLAwu8+I85d743Aicg3
         zxaZ0bB6UzXXguJJ3EebJdkb7q8MHSzLh1T1uVmxg2oE1XaMWZA1mpsmUGZOjHZUFzC5
         s5tce/+VUSqlzI1FQ15SBWrHeJQzjSXUynwVatzRk9ZBLzN/5Mq7Bbp3pPi69Var2OVR
         wEcaAYbdclaL9hf2AJL8jnJ2FNL1VV1JYfRLaf74zIH9zJ/kxHe6W2zStxEW8zCteO+O
         4PCA==
X-Forwarded-Encrypted: i=1; AJvYcCU2jYMa/Ab/JUkPoHfKjJzLIoTnlfmEut0xBMsoH3XL2vqzUwILJLkSRJfzjOUinFEYooMv2NJo+EChxg3XmvZw03kp
X-Gm-Message-State: AOJu0YwKWmb/KvPbkG6/Y+nvYWXeGyQfgJxQ+/mn82jy3x5QON5xWEfa
	nFSAmHaTHGrxn145Y/mhuwlvHKx+NgZGsTORRr2v0KH1YqEEVnI2+t/ywPAuBJlORTKw+ZeaUT3
	5iQ==
X-Google-Smtp-Source: AGHT+IHI2k9McyZuDO8CSOVciGtHPJc9x5EL2NdZssAyahPvwnymjbdxHMXiOyCr4R43cft+pgsFAo2gqF8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:22cd:b0:1dc:c15d:7bdb with SMTP id
 y13-20020a17090322cd00b001dcc15d7bdbmr190722plg.7.1709085388743; Tue, 27 Feb
 2024 17:56:28 -0800 (PST)
Date: Tue, 27 Feb 2024 17:56:27 -0800
In-Reply-To: <20240227232100.478238-8-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <20240227232100.478238-8-pbonzini@redhat.com>
Message-ID: <Zd6Sy_PujXJVji0n@google.com>
Subject: Re: [PATCH 07/21] KVM: VMX: Introduce test mode related to EPT
 violation VE
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 27, 2024, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> To support TDX, KVM is enhanced to operate with #VE.  For TDX, KVM uses the
> suppress #VE bit in EPT entries selectively, in order to be able to trap
> non-present conditions.  However, #VE isn't used for VMX and it's a bug
> if it happens.  To be defensive and test that VMX case isn't broken
> introduce an option ept_violation_ve_test and when it's set, BUG the vm.

This needs to be two patches:

 1. Add the architecture #defines, enums, structures, and is_ve_fault().
 2. Add the forced #VE enabling test code

> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-Id: <d6db6ba836605c0412e166359ba5c46a63c22f86.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/vmx.h | 12 +++++++
>  arch/x86/kvm/vmx/vmcs.h    |  5 +++
>  arch/x86/kvm/vmx/vmx.c     | 69 +++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.h     |  6 +++-
>  4 files changed, 90 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 76ed39541a52..f703bae0c4ac 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -70,6 +70,7 @@
>  #define SECONDARY_EXEC_ENCLS_EXITING		VMCS_CONTROL_BIT(ENCLS_EXITING)
>  #define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
>  #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
> +#define SECONDARY_EXEC_EPT_VIOLATION_VE		VMCS_CONTROL_BIT(EPT_VIOLATION_VE)
>  #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
>  #define SECONDARY_EXEC_ENABLE_XSAVES		VMCS_CONTROL_BIT(XSAVES)
>  #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
> @@ -225,6 +226,8 @@ enum vmcs_field {
>  	VMREAD_BITMAP_HIGH              = 0x00002027,
>  	VMWRITE_BITMAP                  = 0x00002028,
>  	VMWRITE_BITMAP_HIGH             = 0x00002029,
> +	VE_INFORMATION_ADDRESS		= 0x0000202A,
> +	VE_INFORMATION_ADDRESS_HIGH	= 0x0000202B,
>  	XSS_EXIT_BITMAP                 = 0x0000202C,
>  	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
>  	ENCLS_EXITING_BITMAP		= 0x0000202E,
> @@ -630,4 +633,13 @@ enum vmx_l1d_flush_state {
>  
>  extern enum vmx_l1d_flush_state l1tf_vmx_mitigation;
>  
> +struct vmx_ve_information {
> +	u32 exit_reason;
> +	u32 delivery;
> +	u64 exit_qualification;
> +	u64 guest_linear_address;
> +	u64 guest_physical_address;
> +	u16 eptp_index;
> +};

Should this be __packed since it's hardware-defined, or are we ok relying on the
compiler to not be stupid?

>  #endif
> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> index 7c1996b433e2..b25625314658 100644
> --- a/arch/x86/kvm/vmx/vmcs.h
> +++ b/arch/x86/kvm/vmx/vmcs.h
> @@ -140,6 +140,11 @@ static inline bool is_nm_fault(u32 intr_info)
>  	return is_exception_n(intr_info, NM_VECTOR);
>  }
>  
> +static inline bool is_ve_fault(u32 intr_info)
> +{
> +	return is_exception_n(intr_info, VE_VECTOR);
> +}
> +
>  /* Undocumented: icebp/int1 */
>  static inline bool is_icebp(u32 intr_info)
>  {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9239a89dea22..6468f421ba9e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -126,6 +126,9 @@ module_param(error_on_inconsistent_vmcs_config, bool, 0444);
>  static bool __read_mostly dump_invalid_vmcs = 0;
>  module_param(dump_invalid_vmcs, bool, 0644);
>  
> +static bool __read_mostly ept_violation_ve_test;
> +module_param(ept_violation_ve_test, bool, 0444);

I would much prefer to enable #VE if CONFIG_KVM_PROVE_MMU=y.  We already have
too many module params to deal with for testing, and practically speaking the
only people who will ever turn this on are the same people that run with
CONFIG_KVM_PROVE_MMU=y.

>  #define MSR_BITMAP_MODE_X2APIC		1
>  #define MSR_BITMAP_MODE_X2APIC_APICV	2
>  
> @@ -868,6 +871,12 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
>  
>  	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR) | (1u << MC_VECTOR) |
>  	     (1u << DB_VECTOR) | (1u << AC_VECTOR);
> +	/*
> +	 * #VE isn't used for VMX.  To test against unexpected changes
> +	 * related to #VE for VMX, intercept unexpected #VE and warn on it.
> +	 */
> +	if (ept_violation_ve_test)
> +		eb |= 1u << VE_VECTOR;
>  	/*
>  	 * Guest access to VMware backdoor ports could legitimately
>  	 * trigger #GP because of TSS I/O permission bitmap.
> @@ -2603,6 +2613,9 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  					&_cpu_based_2nd_exec_control))
>  			return -EIO;
>  	}
> +	if (!ept_violation_ve_test)
> +		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;

_If_ we add a module param, the param needs to be disabled if #VE isn't supported.

>  #ifndef CONFIG_X86_64
>  	if (!(_cpu_based_2nd_exec_control &
>  				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
> @@ -2627,6 +2640,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  			return -EIO;
>  
>  		vmx_cap->ept = 0;
> +		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
>  	}
>  	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_VPID) &&
>  	    vmx_cap->vpid) {
> @@ -4592,6 +4606,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>  		exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
>  	if (!enable_ept) {
>  		exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
> +		exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
>  		enable_unrestricted_guest = 0;
>  	}
>  	if (!enable_unrestricted_guest)
> @@ -4715,8 +4730,40 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  
>  	exec_controls_set(vmx, vmx_exec_control(vmx));
>  
> -	if (cpu_has_secondary_exec_ctrls())
> +	if (cpu_has_secondary_exec_ctrls()) {
>  		secondary_exec_controls_set(vmx, vmx_secondary_exec_control(vmx));
> +		if (secondary_exec_controls_get(vmx) &
> +		    SECONDARY_EXEC_EPT_VIOLATION_VE) {
> +			if (!vmx->ve_info) {
> +				/* ve_info must be page aligned. */
> +				struct page *page;
> +
> +				BUILD_BUG_ON(sizeof(*vmx->ve_info) > PAGE_SIZE);
> +				page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +				if (page)
> +					vmx->ve_info = page_to_virt(page);
> +			}
> +			if (vmx->ve_info) {
> +				/*
> +				 * Allow #VE delivery. CPU sets this field to
> +				 * 0xFFFFFFFF on #VE delivery.  Another #VE can
> +				 * occur only if software clears the field.
> +				 */
> +				vmx->ve_info->delivery = 0;

This is completely unnecessary, the entire page is zero-allocated.

> +				vmcs_write64(VE_INFORMATION_ADDRESS,
> +					     __pa(vmx->ve_info));
> +			} else {
> +				/*
> +				 * Because SECONDARY_EXEC_EPT_VIOLATION_VE is
> +				 * used only when ept_violation_ve_test is true,
> +				 * it's okay to go with the bit disabled.

No, it's not.  This is silly on multiple fronts.  (a) KVM knows if it's going to
enable #VE when the vCPU is first created, the allocation can and should be done
at that time along with all the other allocations needed for the VM.  (b) Except
for error injection from syzkaller and friends, there is basically zero chance
the VM will live on if one 4KiB allocation fails.  (c) This will never be enabled
in production; it's totally fine if the vCPU creation fails during testing, because
as a above, that will practically never happen outside of deliberate error
injection.

> +				 */
> +				pr_err("Failed to allocate ve_info. disabling EPT_VIOLATION_VE.\n");
> +				secondary_exec_controls_clearbit(vmx,
> +								 SECONDARY_EXEC_EPT_VIOLATION_VE);
> +			}
> +		}
> +	}
>  
>  	if (cpu_has_tertiary_exec_ctrls())
>  		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
> @@ -5204,6 +5251,12 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  	if (is_invalid_opcode(intr_info))
>  		return handle_ud(vcpu);
>  
> +	/*
> +	 * #VE isn't supposed to happen.  Block the VM if it does.

This is not a useful comment.  Obviously #VE isn't supposed to happen, otherwise
KVM wouldn't be bugging the VM. 

> +	 */
> +	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
> +		return -EIO;
> +
>  	error_code = 0;
>  	if (intr_info & INTR_INFO_DELIVER_CODE_MASK)
>  		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
> @@ -6393,6 +6446,18 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>  	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
>  		pr_err("Virtual processor ID = 0x%04x\n",
>  		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
> +	if (secondary_exec_control & SECONDARY_EXEC_EPT_VIOLATION_VE) {
> +		struct vmx_ve_information *ve_info;
> +
> +		pr_err("VE info address = 0x%016llx\n",
> +		       vmcs_read64(VE_INFORMATION_ADDRESS));
> +		ve_info = __va(vmcs_read64(VE_INFORMATION_ADDRESS));

Why!?!?  You have the address in vcpu_vmx, just use that.  If KVM is dumping
the VMCS, then something has gone wrong, possible in hardware or ucode.
Derefencing an address from the VMCS, which could very well be corrupted, is a
terrible idea.  This could easily escalate from a dead VM into a dead host.

> +		pr_err("ve_info: 0x%08x 0x%08x 0x%016llx 0x%016llx 0x%016llx 0x%04x\n",
> +		       ve_info->exit_reason, ve_info->delivery,
> +		       ve_info->exit_qualification,
> +		       ve_info->guest_linear_address,
> +		       ve_info->guest_physical_address, ve_info->eptp_index);
> +	}
>  }
>  
>  /*
> @@ -7433,6 +7498,8 @@ static void vmx_vcpu_free(struct kvm_vcpu *vcpu)
>  	free_vpid(vmx->vpid);
>  	nested_vmx_free_vcpu(vcpu);
>  	free_loaded_vmcs(vmx->loaded_vmcs);
> +	if (vmx->ve_info)

Unnecessary, free_page() does this for you.

> +		free_page((unsigned long)vmx->ve_info);
>  }
>  
>  static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index e3b0985bb74a..1ea1e5c8930d 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -364,6 +364,9 @@ struct vcpu_vmx {
>  		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
>  		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
>  	} shadow_msr_intercept;
> +
> +	/* ve_info must be page aligned. */

This is also not a useful comment.  Even the one at the allocation site is of
dubious value.

> +	struct vmx_ve_information *ve_info;
>  };
>  
>  struct kvm_vmx {
> @@ -576,7 +579,8 @@ static inline u8 vmx_get_rvi(void)
>  	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
>  	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
>  	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
> -	 SECONDARY_EXEC_ENCLS_EXITING)
> +	 SECONDARY_EXEC_ENCLS_EXITING |					\
> +	 SECONDARY_EXEC_EPT_VIOLATION_VE)
>  
>  #define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
>  #define KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL			\
> -- 
> 2.39.0
> 
> 

