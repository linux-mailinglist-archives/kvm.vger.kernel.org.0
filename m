Return-Path: <kvm+bounces-13476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 833918974BD
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 18:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FB23B2F8C1
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 15:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2123F14A621;
	Wed,  3 Apr 2024 15:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JLb8FmcA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBB014A4EC
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712159934; cv=none; b=m64nVYyGi+IrjQJLig4xxTyD5dd7UJnBx4t+92Y112Sk5egs9QQkJPrhTcXiVK7elcJ0eqA1uOKuTUk6/ja37viIjiWMcbdnfL4l6uE5tR+1pxPt0VqGq4Jjk4p1SsVcMHPH1zZJVf2Tq9C6imd+wkWqLJvmY5bWLL8v3szNg6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712159934; c=relaxed/simple;
	bh=GmWmx3DTXih0jvt+fWPUCOP3jKBAIOu/E1IcNqxUeBo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EEI524UOv/2CDJeHxPtiRHpE9naDrU8svHrRVIbRgDHBGJ4fLFz2mfR3gOVdP+JBfJ1mkvOtQeee3wbST0UkWHb5J+oqmsBF3s7wTvRqe+K5jhtwbB6Vw0KkTdKrGH/g+QAW9+YrMbpY6ubeR9K792ONfZTs5cwZUOBjry15s/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JLb8FmcA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2a2c2b0d82aso37764a91.3
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 08:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712159932; x=1712764732; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gx8NzCNHxkxUNS3bHQ2Vy0QWy11cakhMcI+4YAbd68I=;
        b=JLb8FmcARjn962baZh8h0FE/QC1HA7lq2ZFjPzLAltScuqddohwCB/cfvo1wvyuTJQ
         b98y3KhUFn3KdctYG6+0Y04KLxSHh9eWZkD5y6tcVpoWH+BnXTrMJ9Z8mfRuTNOzrA7k
         tbdm0YGsMs0k+P+ZZvenJXqvXFRnGqTLJuchEjkTu+HxL2XKI+ZDVy7qDXrZUafmmcui
         O6M9hf5O2ys5Nht7jiND7W209ZP283/kgeEuVXUVICJentqArO68jnQq1g72YGMWhU+2
         7BbWczaHfzlMTuce5vYN0Zsqrny3MHdC3BcJ+syfWF66186n702s82Ur1+94Goaw2reu
         P5Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712159932; x=1712764732;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gx8NzCNHxkxUNS3bHQ2Vy0QWy11cakhMcI+4YAbd68I=;
        b=fND8tdpaRBDk3VnS/+25dGgYwnYsAe1GGkBHrahNKPylifDa95dI1Bz+wCQYoO+2EX
         Kj8Y7iU9zzMJ3dhnQyG3WiCXxml7u/OaksmLN03/r/oX5DmJrduO4r86wpb4r10EZguN
         PYxiSnjhOiWttdvSA2XJFPsopFd/ENkz7jYRJKzYGzQdhfGtLFN+bXiHCtRFJV7rCzXE
         X96vtOaUaihuuLVMjfzMJxrYuwSxlSqgchplFrDP+tHTe7+k5Lqj2PrGFWY0cdpPEKSJ
         J47mA+tDMRwt0vAkLsWypdMM9EC15IQf74oljwPgakiDLFxBkwKVWGwlDwaIkTG7L1yU
         Uv4w==
X-Gm-Message-State: AOJu0YxyTSGGEhrXrVezbTo2QKIDUdmN20h1jHIOXmICvGLLt84CZfvS
	A+G2CKGYZbyfwfWyZhGFRAXrTbSU5qzWwq1ac8+5b+8TKBT5fZy+t/Yu7qPkrfG4ERSigAxanqc
	6Jg==
X-Google-Smtp-Source: AGHT+IGresby5uWardt3BAmcFOWkytVmq8r8GrkIPi/oOW3Iyt0cLQDY+5zKRE/2+3EdvYAJi+mP1lMEoJk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:30c5:b0:2a2:8f19:f484 with SMTP id
 hi5-20020a17090b30c500b002a28f19f484mr7608pjb.3.1712159931879; Wed, 03 Apr
 2024 08:58:51 -0700 (PDT)
Date: Wed, 3 Apr 2024 08:58:50 -0700
In-Reply-To: <b9fbb0844fc6505f8fb1e9a783615b299a5a5bb3.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com> <b9fbb0844fc6505f8fb1e9a783615b299a5a5bb3.1708933498.git.isaku.yamahata@intel.com>
Message-ID: <Zg18ul8Q4PGQMWam@google.com>
Subject: Re: [PATCH v19 106/130] KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Some of TDG.VP.VMCALL require device model, for example, qemu, to handle
> them on behalf of kvm kernel module. TDVMCALL_REPORT_FATAL_ERROR,
> TDVMCALL_MAP_GPA, TDVMCALL_SETUP_EVENT_NOTIFY_INTERRUPT, and
> TDVMCALL_GET_QUOTE requires user space VMM handling.
> 
> Introduce new kvm exit, KVM_EXIT_TDX, and functions to setup it. Device
> model should update R10 if necessary as return value.

Hard NAK.

KVM needs its own ABI, under no circumstance should KVM inherit ABI directly from
the GHCI.  Even worse, this doesn't even sanity check the "unknown" VMCALLs, KVM
just blindly punts *everything* to userspace.  And even worse than that, KVM
already has at least one user exit that overlaps, TDVMCALL_MAP_GPA => KVM_HC_MAP_GPA_RANGE.

If the userspace VMM wants to run an end-around on KVM and directly communicate
with the guest, e.g. via a synthetic device (a la virtio), that's totally fine,
because *KVM* is not definining any unique ABI, KVM is purely providing the
transport, e.g. emulated MMIO or PIO (and maybe not even that).  IIRC, this option
even came up in the context of GET_QUOTE.

But explicit exiting to userspace with KVM_EXIT_TDX is very different.  KVM is
creating a contract with userspace that says "for TDX VMCALLs [a-z], KVM will exit
to userspace with values [a-z]".  *Every* new VMCALL that's added to the GHCI will
become KVM ABI, e.g. if Intel ships a TDX module that adds a new VMALL, then KVM
will forward the exit to userspace, and userspace can then start relying on that
behavior.

And punting all register state, decoding, etc. to userspace creates a crap ABI.
KVM effectively did this for SEV and SEV-ES by copying the PSP ABI verbatim into
KVM ioctls(), and it's a gross, ugly mess.

Each VMCALL that KVM wants to forward needs a dedicated KVM_EXIT_<reason> and
associated struct in the exit union.  Yes, it's slightly more work now, but it's
one time pain.  Whereas copying all registers is endless misery for everyone
involved, e.g. *every* userspace VMM needs to decipher the registers, do sanity
checking, etc.  And *every* end user needs to do the same when a debugging
inevitable failures.

This also solves Chao's comment about XMM registers.  Except for emualting Hyper-V
hypercalls, which have very explicit handling, KVM does NOT support using XMM
registers in hypercalls.

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v14 -> v15:
> - updated struct kvm_tdx_exit with union
> - export constants for reg bitmask
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/tdx.c   | 83 ++++++++++++++++++++++++++++++++++++-
>  include/uapi/linux/kvm.h | 89 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 170 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index c8eb47591105..72dbe2ff9062 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1038,6 +1038,78 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static int tdx_complete_vp_vmcall(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx_vmcall *tdx_vmcall = &vcpu->run->tdx.u.vmcall;
> +	__u64 reg_mask = kvm_rcx_read(vcpu);
> +
> +#define COPY_REG(MASK, REG)							\
> +	do {									\
> +		if (reg_mask & TDX_VMCALL_REG_MASK_ ## MASK)			\
> +			kvm_## REG ## _write(vcpu, tdx_vmcall->out_ ## REG);	\
> +	} while (0)
> +
> +
> +	COPY_REG(R10, r10);
> +	COPY_REG(R11, r11);
> +	COPY_REG(R12, r12);
> +	COPY_REG(R13, r13);
> +	COPY_REG(R14, r14);
> +	COPY_REG(R15, r15);
> +	COPY_REG(RBX, rbx);
> +	COPY_REG(RDI, rdi);
> +	COPY_REG(RSI, rsi);
> +	COPY_REG(R8, r8);
> +	COPY_REG(R9, r9);
> +	COPY_REG(RDX, rdx);
> +
> +#undef COPY_REG
> +
> +	return 1;
> +}
> +
> +static int tdx_vp_vmcall_to_user(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx_vmcall *tdx_vmcall = &vcpu->run->tdx.u.vmcall;
> +	__u64 reg_mask;
> +
> +	vcpu->arch.complete_userspace_io = tdx_complete_vp_vmcall;
> +	memset(tdx_vmcall, 0, sizeof(*tdx_vmcall));
> +
> +	vcpu->run->exit_reason = KVM_EXIT_TDX;
> +	vcpu->run->tdx.type = KVM_EXIT_TDX_VMCALL;
> +
> +	reg_mask = kvm_rcx_read(vcpu);
> +	tdx_vmcall->reg_mask = reg_mask;
> +
> +#define COPY_REG(MASK, REG)							\
> +	do {									\
> +		if (reg_mask & TDX_VMCALL_REG_MASK_ ## MASK) {			\
> +			tdx_vmcall->in_ ## REG = kvm_ ## REG ## _read(vcpu);	\
> +			tdx_vmcall->out_ ## REG = tdx_vmcall->in_ ## REG;	\
> +		}								\
> +	} while (0)
> +
> +
> +	COPY_REG(R10, r10);
> +	COPY_REG(R11, r11);
> +	COPY_REG(R12, r12);
> +	COPY_REG(R13, r13);
> +	COPY_REG(R14, r14);
> +	COPY_REG(R15, r15);
> +	COPY_REG(RBX, rbx);
> +	COPY_REG(RDI, rdi);
> +	COPY_REG(RSI, rsi);
> +	COPY_REG(R8, r8);
> +	COPY_REG(R9, r9);
> +	COPY_REG(RDX, rdx);
> +
> +#undef COPY_REG
> +
> +	/* notify userspace to handle the request */
> +	return 0;
> +}
> +
>  static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>  {
>  	if (tdvmcall_exit_type(vcpu))
> @@ -1048,8 +1120,15 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>  		break;
>  	}
>  
> -	tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
> -	return 1;
> +	/*
> +	 * Unknown VMCALL.  Toss the request to the user space VMM, e.g. qemu,
> +	 * as it may know how to handle.
> +	 *
> +	 * Those VMCALLs require user space VMM:
> +	 * TDVMCALL_REPORT_FATAL_ERROR, TDVMCALL_MAP_GPA,
> +	 * TDVMCALL_SETUP_EVENT_NOTIFY_INTERRUPT, and TDVMCALL_GET_QUOTE.
> +	 */
> +	return tdx_vp_vmcall_to_user(vcpu);
>  }
>  
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5e2b28934aa9..a7aa804ef021 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -167,6 +167,92 @@ struct kvm_xen_exit {
>  	} u;
>  };
>  
> +/* masks for reg_mask to indicate which registers are passed. */
> +#define TDX_VMCALL_REG_MASK_RBX	BIT_ULL(2)
> +#define TDX_VMCALL_REG_MASK_RDX	BIT_ULL(3)
> +#define TDX_VMCALL_REG_MASK_RSI	BIT_ULL(6)
> +#define TDX_VMCALL_REG_MASK_RDI	BIT_ULL(7)
> +#define TDX_VMCALL_REG_MASK_R8	BIT_ULL(8)
> +#define TDX_VMCALL_REG_MASK_R9	BIT_ULL(9)
> +#define TDX_VMCALL_REG_MASK_R10	BIT_ULL(10)
> +#define TDX_VMCALL_REG_MASK_R11	BIT_ULL(11)
> +#define TDX_VMCALL_REG_MASK_R12	BIT_ULL(12)
> +#define TDX_VMCALL_REG_MASK_R13	BIT_ULL(13)
> +#define TDX_VMCALL_REG_MASK_R14	BIT_ULL(14)
> +#define TDX_VMCALL_REG_MASK_R15	BIT_ULL(15)
> +
> +struct kvm_tdx_exit {
> +#define KVM_EXIT_TDX_VMCALL	1
> +	__u32 type;
> +	__u32 pad;
> +
> +	union {
> +		struct kvm_tdx_vmcall {
> +			/*
> +			 * RAX(bit 0), RCX(bit 1) and RSP(bit 4) are reserved.
> +			 * RAX(bit 0): TDG.VP.VMCALL status code.
> +			 * RCX(bit 1): bitmap for used registers.
> +			 * RSP(bit 4): the caller stack.
> +			 */
> +			union {
> +				__u64 in_rcx;
> +				__u64 reg_mask;
> +			};
> +
> +			/*
> +			 * Guest-Host-Communication Interface for TDX spec
> +			 * defines the ABI for TDG.VP.VMCALL.
> +			 */
> +			/* Input parameters: guest -> VMM */
> +			union {
> +				__u64 in_r10;
> +				__u64 type;
> +			};
> +			union {
> +				__u64 in_r11;
> +				__u64 subfunction;
> +			};
> +			/*
> +			 * Subfunction specific.
> +			 * Registers are used in this order to pass input
> +			 * arguments.  r12=arg0, r13=arg1, etc.
> +			 */
> +			__u64 in_r12;
> +			__u64 in_r13;
> +			__u64 in_r14;
> +			__u64 in_r15;
> +			__u64 in_rbx;
> +			__u64 in_rdi;
> +			__u64 in_rsi;
> +			__u64 in_r8;
> +			__u64 in_r9;
> +			__u64 in_rdx;
> +
> +			/* Output parameters: VMM -> guest */
> +			union {
> +				__u64 out_r10;
> +				__u64 status_code;
> +			};
> +			/*
> +			 * Subfunction specific.
> +			 * Registers are used in this order to output return
> +			 * values.  r11=ret0, r12=ret1, etc.
> +			 */
> +			__u64 out_r11;
> +			__u64 out_r12;
> +			__u64 out_r13;
> +			__u64 out_r14;
> +			__u64 out_r15;
> +			__u64 out_rbx;
> +			__u64 out_rdi;
> +			__u64 out_rsi;
> +			__u64 out_r8;
> +			__u64 out_r9;
> +			__u64 out_rdx;
> +		} vmcall;
> +	} u;
> +};
> +
>  #define KVM_S390_GET_SKEYS_NONE   1
>  #define KVM_S390_SKEYS_MAX        1048576
>  
> @@ -210,6 +296,7 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_NOTIFY           37
>  #define KVM_EXIT_LOONGARCH_IOCSR  38
>  #define KVM_EXIT_MEMORY_FAULT     39
> +#define KVM_EXIT_TDX              40
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -470,6 +557,8 @@ struct kvm_run {
>  			__u64 gpa;
>  			__u64 size;
>  		} memory_fault;
> +		/* KVM_EXIT_TDX_VMCALL */
> +		struct kvm_tdx_exit tdx;
>  		/* Fix the size of the union. */
>  		char padding[256];
>  	};
> -- 
> 2.25.1
> 

