Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B211E1919A5
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 20:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgCXTDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 15:03:05 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:38772 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727715AbgCXTDF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 15:03:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585076580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G+E/8qm+BpsMI/XWwIyrWQnvAYizdXzd4OLZv384jgA=;
        b=J9/tKGHAi/VaXm8TvZb6TfldEZXT3NTiVnNVXDpYXUmviAmfjVLnPO2BXnW1Hnnx27R98T
        zM0yj7GrO6rn9cS89IaiD3/+mtTOFAeWU323DlsOy4QETaSg1hHr4OrE2LedM36R8o1E64
        3/4ir/Fbo11DOraO8+3jSIcF1gb7fHE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-fUQ9GJIjNMCPCk31SvNobA-1; Tue, 24 Mar 2020 15:02:55 -0400
X-MC-Unique: fUQ9GJIjNMCPCk31SvNobA-1
Received: by mail-wr1-f69.google.com with SMTP id l17so9275599wro.3
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 12:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=G+E/8qm+BpsMI/XWwIyrWQnvAYizdXzd4OLZv384jgA=;
        b=EctxOXQUB6NkfAQP3I6tw4WNTY3FlzxzLg5N8vLbbuI9TIcSBvBP0BpfyfZ8GjUyWv
         +eudHaAVJcLsLam88Ijl9B0FQ1qVJuU8UdoBfpuQmvR/HkdYj+dF9qt+vFmsyqVZlXhW
         04R7FyqMgMpGxYmslstAasMe6fRAm5HNXLMjpfOIsCuQkYyUNAdZwKpx4lXqTkdm4BBx
         cqoiel/ltoVeA7Tlv9baip2Ha1xl+02CYgvvXFDntD97EVrtb1D8K7gJNlWXtHpuFEUw
         LtugpiboqUBvHk+3r6EA/9dJpWkNjHz0O8qtMJWZW72k5UC2Vln+c8/pIOOO9bHfpB4H
         HLGg==
X-Gm-Message-State: ANhLgQ26c07bWABnm5JbdkglFI7R3Y8CkUTyylJL2Z91s+vhoS/dULy8
        B5J7lLM/GCZOHkIdT+PzZ/W7eyFoKzieNcq6aVRIyNQmdl47CoQLw8hw2+Bq9OVaIqwrWoA6Npq
        5j3M9l6wNgAxf
X-Received: by 2002:a1c:3586:: with SMTP id c128mr7217749wma.82.1585076572392;
        Tue, 24 Mar 2020 12:02:52 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vteRsLDg8XBvggJNy+Gq3GMQszHkFIEHhceCQhTyO6ZoMMURqFhrc8f7/qeg+sOP8FJOflY4g==
X-Received: by 2002:a1c:3586:: with SMTP id c128mr7217667wma.82.1585076571262;
        Tue, 24 Mar 2020 12:02:51 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v2sm31608655wrt.58.2020.03.24.12.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 12:02:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 2/4] KVM: SVM: Move Nested SVM Implementation to nested.c
In-Reply-To: <20200324094154.32352-3-joro@8bytes.org>
References: <20200324094154.32352-1-joro@8bytes.org> <20200324094154.32352-3-joro@8bytes.org>
Date:   Tue, 24 Mar 2020 20:02:49 +0100
Message-ID: <87d0917ezq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:

> From: Joerg Roedel <jroedel@suse.de>
>
> Split out the code for the nested SVM implementation and move it to a
> separate file.
>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kvm/Makefile     |    2 +-
>  arch/x86/kvm/svm/nested.c |  823 ++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c    | 1155 +------------------------------------
>  arch/x86/kvm/svm/svm.h    |  381 ++++++++++++
>  4 files changed, 1216 insertions(+), 1145 deletions(-)
>  create mode 100644 arch/x86/kvm/svm/nested.c
>  create mode 100644 arch/x86/kvm/svm/svm.h
>
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index c6f14e3cc5ab..63ae654f7f97 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -14,7 +14,7 @@ kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
>  			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o
>  
>  kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
> -kvm-amd-y		+= svm/svm.o svm/pmu.o
> +kvm-amd-y		+= svm/svm.o svm/pmu.o svm/nested.o
>  
>  obj-$(CONFIG_KVM)	+= kvm.o
>  obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> new file mode 100644
> index 000000000000..961f413626d0
> --- /dev/null
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -0,0 +1,823 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Kernel-based Virtual Machine driver for Linux
> + *
> + * AMD SVM support
> + *
> + * Copyright (C) 2006 Qumranet, Inc.
> + * Copyright 2010 Red Hat, Inc. and/or its affiliates.
> + *
> + * Authors:
> + *   Yaniv Kamay  <yaniv@qumranet.com>
> + *   Avi Kivity   <avi@qumranet.com>
> + */
> +
> +#define pr_fmt(fmt) "SVM: " fmt
> +
> +#include <linux/kvm_types.h>
> +#include <linux/kvm_host.h>
> +#include <linux/kernel.h>
> +
> +#include <asm/msr-index.h>
> +
> +#include "kvm_emulate.h"
> +#include "trace.h"
> +#include "mmu.h"
> +#include "x86.h"
> +#include "svm.h"
> +
> +static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
> +				       struct x86_exception *fault)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (svm->vmcb->control.exit_code != SVM_EXIT_NPF) {
> +		/*
> +		 * TODO: track the cause of the nested page fault, and
> +		 * correctly fill in the high bits of exit_info_1.
> +		 */
> +		svm->vmcb->control.exit_code = SVM_EXIT_NPF;
> +		svm->vmcb->control.exit_code_hi = 0;
> +		svm->vmcb->control.exit_info_1 = (1ULL << 32);
> +		svm->vmcb->control.exit_info_2 = fault->address;
> +	}
> +
> +	svm->vmcb->control.exit_info_1 &= ~0xffffffffULL;
> +	svm->vmcb->control.exit_info_1 |= fault->error_code;
> +
> +	/*
> +	 * The present bit is always zero for page structure faults on real
> +	 * hardware.
> +	 */
> +	if (svm->vmcb->control.exit_info_1 & (2ULL << 32))
> +		svm->vmcb->control.exit_info_1 &= ~1;
> +
> +	nested_svm_vmexit(svm);
> +}
> +
> +static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	u64 cr3 = svm->nested.nested_cr3;
> +	u64 pdpte;
> +	int ret;
> +
> +	ret = kvm_vcpu_read_guest_page(vcpu, gpa_to_gfn(__sme_clr(cr3)), &pdpte,
> +				       offset_in_page(cr3) + index * 8, 8);
> +	if (ret)
> +		return 0;
> +	return pdpte;
> +}
> +
> +static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	return svm->nested.nested_cr3;
> +}
> +
> +static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
> +{
> +	WARN_ON(mmu_is_nested(vcpu));
> +
> +	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
> +	kvm_init_shadow_mmu(vcpu);
> +	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
> +	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
> +	vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
> +	vcpu->arch.mmu->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);
> +	reset_shadow_zero_bits_mask(vcpu, vcpu->arch.mmu);
> +	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
> +}
> +
> +static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.mmu = &vcpu->arch.root_mmu;
> +	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> +}
> +
> +void recalc_intercepts(struct vcpu_svm *svm)
> +{
> +	struct vmcb_control_area *c, *h;
> +	struct nested_state *g;
> +
> +	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> +
> +	if (!is_guest_mode(&svm->vcpu))
> +		return;
> +
> +	c = &svm->vmcb->control;
> +	h = &svm->nested.hsave->control;
> +	g = &svm->nested;
> +
> +	c->intercept_cr = h->intercept_cr;
> +	c->intercept_dr = h->intercept_dr;
> +	c->intercept_exceptions = h->intercept_exceptions;
> +	c->intercept = h->intercept;
> +
> +	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
> +		/* We only want the cr8 intercept bits of L1 */
> +		c->intercept_cr &= ~(1U << INTERCEPT_CR8_READ);
> +		c->intercept_cr &= ~(1U << INTERCEPT_CR8_WRITE);
> +
> +		/*
> +		 * Once running L2 with HF_VINTR_MASK, EFLAGS.IF does not
> +		 * affect any interrupt we may want to inject; therefore,
> +		 * interrupt window vmexits are irrelevant to L0.
> +		 */
> +		c->intercept &= ~(1ULL << INTERCEPT_VINTR);
> +	}
> +
> +	/* We don't want to see VMMCALLs from a nested guest */
> +	c->intercept &= ~(1ULL << INTERCEPT_VMMCALL);
> +
> +	c->intercept_cr |= g->intercept_cr;
> +	c->intercept_dr |= g->intercept_dr;
> +	c->intercept_exceptions |= g->intercept_exceptions;
> +	c->intercept |= g->intercept;
> +}
> +
> +static void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *from_vmcb)
> +{
> +	struct vmcb_control_area *dst  = &dst_vmcb->control;
> +	struct vmcb_control_area *from = &from_vmcb->control;
> +
> +	dst->intercept_cr         = from->intercept_cr;
> +	dst->intercept_dr         = from->intercept_dr;
> +	dst->intercept_exceptions = from->intercept_exceptions;
> +	dst->intercept            = from->intercept;
> +	dst->iopm_base_pa         = from->iopm_base_pa;
> +	dst->msrpm_base_pa        = from->msrpm_base_pa;
> +	dst->tsc_offset           = from->tsc_offset;
> +	dst->asid                 = from->asid;
> +	dst->tlb_ctl              = from->tlb_ctl;
> +	dst->int_ctl              = from->int_ctl;
> +	dst->int_vector           = from->int_vector;
> +	dst->int_state            = from->int_state;
> +	dst->exit_code            = from->exit_code;
> +	dst->exit_code_hi         = from->exit_code_hi;
> +	dst->exit_info_1          = from->exit_info_1;
> +	dst->exit_info_2          = from->exit_info_2;
> +	dst->exit_int_info        = from->exit_int_info;
> +	dst->exit_int_info_err    = from->exit_int_info_err;
> +	dst->nested_ctl           = from->nested_ctl;
> +	dst->event_inj            = from->event_inj;
> +	dst->event_inj_err        = from->event_inj_err;
> +	dst->nested_cr3           = from->nested_cr3;
> +	dst->virt_ext              = from->virt_ext;
> +	dst->pause_filter_count   = from->pause_filter_count;
> +	dst->pause_filter_thresh  = from->pause_filter_thresh;
> +}
> +
> +static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
> +{
> +	/*
> +	 * This function merges the msr permission bitmaps of kvm and the
> +	 * nested vmcb. It is optimized in that it only merges the parts where
> +	 * the kvm msr permission bitmap may contain zero bits
> +	 */
> +	int i;
> +
> +	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
> +		return true;
> +
> +	for (i = 0; i < MSRPM_OFFSETS; i++) {
> +		u32 value, p;
> +		u64 offset;
> +
> +		if (msrpm_offsets[i] == 0xffffffff)
> +			break;
> +
> +		p      = msrpm_offsets[i];
> +		offset = svm->nested.vmcb_msrpm + (p * 4);
> +
> +		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4))
> +			return false;
> +
> +		svm->nested.msrpm[p] = svm->msrpm[p] | value;
> +	}
> +
> +	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm));
> +
> +	return true;
> +}
> +
> +static bool nested_vmcb_checks(struct vmcb *vmcb)
> +{
> +	if ((vmcb->save.efer & EFER_SVME) == 0)
> +		return false;
> +
> +	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
> +		return false;
> +
> +	if (vmcb->control.asid == 0)
> +		return false;
> +
> +	if ((vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
> +	    !npt_enabled)
> +		return false;
> +
> +	return true;
> +}
> +
> +void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
> +			  struct vmcb *nested_vmcb, struct kvm_host_map *map)
> +{
> +	bool evaluate_pending_interrupts =
> +		is_intercept(svm, INTERCEPT_VINTR) ||
> +		is_intercept(svm, INTERCEPT_IRET);
> +
> +	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
> +		svm->vcpu.arch.hflags |= HF_HIF_MASK;
> +	else
> +		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
> +
> +	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE) {
> +		svm->nested.nested_cr3 = nested_vmcb->control.nested_cr3;
> +		nested_svm_init_mmu_context(&svm->vcpu);
> +	}
> +
> +	/* Load the nested guest state */
> +	svm->vmcb->save.es = nested_vmcb->save.es;
> +	svm->vmcb->save.cs = nested_vmcb->save.cs;
> +	svm->vmcb->save.ss = nested_vmcb->save.ss;
> +	svm->vmcb->save.ds = nested_vmcb->save.ds;
> +	svm->vmcb->save.gdtr = nested_vmcb->save.gdtr;
> +	svm->vmcb->save.idtr = nested_vmcb->save.idtr;
> +	kvm_set_rflags(&svm->vcpu, nested_vmcb->save.rflags);
> +	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
> +	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
> +	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
> +	if (npt_enabled) {
> +		svm->vmcb->save.cr3 = nested_vmcb->save.cr3;
> +		svm->vcpu.arch.cr3 = nested_vmcb->save.cr3;
> +	} else
> +		(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
> +
> +	/* Guest paging mode is active - reset mmu */
> +	kvm_mmu_reset_context(&svm->vcpu);
> +
> +	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
> +	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
> +	kvm_rsp_write(&svm->vcpu, nested_vmcb->save.rsp);
> +	kvm_rip_write(&svm->vcpu, nested_vmcb->save.rip);
> +
> +	/* In case we don't even reach vcpu_run, the fields are not updated */
> +	svm->vmcb->save.rax = nested_vmcb->save.rax;
> +	svm->vmcb->save.rsp = nested_vmcb->save.rsp;
> +	svm->vmcb->save.rip = nested_vmcb->save.rip;
> +	svm->vmcb->save.dr7 = nested_vmcb->save.dr7;
> +	svm->vmcb->save.dr6 = nested_vmcb->save.dr6;
> +	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
> +
> +	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa & ~0x0fffULL;
> +	svm->nested.vmcb_iopm  = nested_vmcb->control.iopm_base_pa  & ~0x0fffULL;
> +
> +	/* cache intercepts */
> +	svm->nested.intercept_cr         = nested_vmcb->control.intercept_cr;
> +	svm->nested.intercept_dr         = nested_vmcb->control.intercept_dr;
> +	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
> +	svm->nested.intercept            = nested_vmcb->control.intercept;
> +
> +	svm_flush_tlb(&svm->vcpu, true);
> +	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
> +	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
> +		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
> +	else
> +		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
> +
> +	svm->vcpu.arch.tsc_offset += nested_vmcb->control.tsc_offset;
> +	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
> +
> +	svm->vmcb->control.virt_ext = nested_vmcb->control.virt_ext;
> +	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
> +	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
> +	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
> +	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
> +
> +	svm->vmcb->control.pause_filter_count =
> +		nested_vmcb->control.pause_filter_count;
> +	svm->vmcb->control.pause_filter_thresh =
> +		nested_vmcb->control.pause_filter_thresh;
> +
> +	kvm_vcpu_unmap(&svm->vcpu, map, true);
> +
> +	/* Enter Guest-Mode */
> +	enter_guest_mode(&svm->vcpu);
> +
> +	/*
> +	 * Merge guest and host intercepts - must be called  with vcpu in
> +	 * guest-mode to take affect here
> +	 */
> +	recalc_intercepts(svm);
> +
> +	svm->nested.vmcb = vmcb_gpa;
> +
> +	/*
> +	 * If L1 had a pending IRQ/NMI before executing VMRUN,
> +	 * which wasn't delivered because it was disallowed (e.g.
> +	 * interrupts disabled), L0 needs to evaluate if this pending
> +	 * event should cause an exit from L2 to L1 or be delivered
> +	 * directly to L2.
> +	 *
> +	 * Usually this would be handled by the processor noticing an
> +	 * IRQ/NMI window request.  However, VMRUN can unblock interrupts
> +	 * by implicitly setting GIF, so force L0 to perform pending event
> +	 * evaluation by requesting a KVM_REQ_EVENT.
> +	 */
> +	enable_gif(svm);
> +	if (unlikely(evaluate_pending_interrupts))
> +		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> +
> +	mark_all_dirty(svm->vmcb);
> +}
> +
> +int nested_svm_vmrun(struct vcpu_svm *svm)
> +{
> +	int ret;
> +	struct vmcb *nested_vmcb;
> +	struct vmcb *hsave = svm->nested.hsave;
> +	struct vmcb *vmcb = svm->vmcb;
> +	struct kvm_host_map map;
> +	u64 vmcb_gpa;
> +
> +	vmcb_gpa = svm->vmcb->save.rax;
> +
> +	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
> +	if (ret == -EINVAL) {
> +		kvm_inject_gp(&svm->vcpu, 0);
> +		return 1;
> +	} else if (ret) {
> +		return kvm_skip_emulated_instruction(&svm->vcpu);
> +	}
> +
> +	ret = kvm_skip_emulated_instruction(&svm->vcpu);
> +
> +	nested_vmcb = map.hva;
> +
> +	if (!nested_vmcb_checks(nested_vmcb)) {
> +		nested_vmcb->control.exit_code    = SVM_EXIT_ERR;
> +		nested_vmcb->control.exit_code_hi = 0;
> +		nested_vmcb->control.exit_info_1  = 0;
> +		nested_vmcb->control.exit_info_2  = 0;
> +
> +		kvm_vcpu_unmap(&svm->vcpu, &map, true);
> +
> +		return ret;
> +	}
> +
> +	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
> +			       nested_vmcb->save.rip,
> +			       nested_vmcb->control.int_ctl,
> +			       nested_vmcb->control.event_inj,
> +			       nested_vmcb->control.nested_ctl);
> +
> +	trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr & 0xffff,
> +				    nested_vmcb->control.intercept_cr >> 16,
> +				    nested_vmcb->control.intercept_exceptions,
> +				    nested_vmcb->control.intercept);
> +
> +	/* Clear internal status */
> +	kvm_clear_exception_queue(&svm->vcpu);
> +	kvm_clear_interrupt_queue(&svm->vcpu);
> +
> +	/*
> +	 * Save the old vmcb, so we don't need to pick what we save, but can
> +	 * restore everything when a VMEXIT occurs
> +	 */
> +	hsave->save.es     = vmcb->save.es;
> +	hsave->save.cs     = vmcb->save.cs;
> +	hsave->save.ss     = vmcb->save.ss;
> +	hsave->save.ds     = vmcb->save.ds;
> +	hsave->save.gdtr   = vmcb->save.gdtr;
> +	hsave->save.idtr   = vmcb->save.idtr;
> +	hsave->save.efer   = svm->vcpu.arch.efer;
> +	hsave->save.cr0    = kvm_read_cr0(&svm->vcpu);
> +	hsave->save.cr4    = svm->vcpu.arch.cr4;
> +	hsave->save.rflags = kvm_get_rflags(&svm->vcpu);
> +	hsave->save.rip    = kvm_rip_read(&svm->vcpu);
> +	hsave->save.rsp    = vmcb->save.rsp;
> +	hsave->save.rax    = vmcb->save.rax;
> +	if (npt_enabled)
> +		hsave->save.cr3    = vmcb->save.cr3;
> +	else
> +		hsave->save.cr3    = kvm_read_cr3(&svm->vcpu);
> +
> +	copy_vmcb_control_area(hsave, vmcb);
> +
> +	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb, &map);
> +
> +	if (!nested_svm_vmrun_msrpm(svm)) {
> +		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> +		svm->vmcb->control.exit_code_hi = 0;
> +		svm->vmcb->control.exit_info_1  = 0;
> +		svm->vmcb->control.exit_info_2  = 0;
> +
> +		nested_svm_vmexit(svm);
> +	}
> +
> +	return ret;
> +}
> +
> +void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
> +{
> +	to_vmcb->save.fs = from_vmcb->save.fs;
> +	to_vmcb->save.gs = from_vmcb->save.gs;
> +	to_vmcb->save.tr = from_vmcb->save.tr;
> +	to_vmcb->save.ldtr = from_vmcb->save.ldtr;
> +	to_vmcb->save.kernel_gs_base = from_vmcb->save.kernel_gs_base;
> +	to_vmcb->save.star = from_vmcb->save.star;
> +	to_vmcb->save.lstar = from_vmcb->save.lstar;
> +	to_vmcb->save.cstar = from_vmcb->save.cstar;
> +	to_vmcb->save.sfmask = from_vmcb->save.sfmask;
> +	to_vmcb->save.sysenter_cs = from_vmcb->save.sysenter_cs;
> +	to_vmcb->save.sysenter_esp = from_vmcb->save.sysenter_esp;
> +	to_vmcb->save.sysenter_eip = from_vmcb->save.sysenter_eip;
> +}
> +
> +int nested_svm_vmexit(struct vcpu_svm *svm)
> +{
> +	int rc;
> +	struct vmcb *nested_vmcb;
> +	struct vmcb *hsave = svm->nested.hsave;
> +	struct vmcb *vmcb = svm->vmcb;
> +	struct kvm_host_map map;
> +
> +	trace_kvm_nested_vmexit_inject(vmcb->control.exit_code,
> +				       vmcb->control.exit_info_1,
> +				       vmcb->control.exit_info_2,
> +				       vmcb->control.exit_int_info,
> +				       vmcb->control.exit_int_info_err,
> +				       KVM_ISA_SVM);
> +
> +	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb), &map);
> +	if (rc) {
> +		if (rc == -EINVAL)
> +			kvm_inject_gp(&svm->vcpu, 0);
> +		return 1;
> +	}
> +
> +	nested_vmcb = map.hva;
> +
> +	/* Exit Guest-Mode */
> +	leave_guest_mode(&svm->vcpu);
> +	svm->nested.vmcb = 0;
> +
> +	/* Give the current vmcb to the guest */
> +	disable_gif(svm);
> +
> +	nested_vmcb->save.es     = vmcb->save.es;
> +	nested_vmcb->save.cs     = vmcb->save.cs;
> +	nested_vmcb->save.ss     = vmcb->save.ss;
> +	nested_vmcb->save.ds     = vmcb->save.ds;
> +	nested_vmcb->save.gdtr   = vmcb->save.gdtr;
> +	nested_vmcb->save.idtr   = vmcb->save.idtr;
> +	nested_vmcb->save.efer   = svm->vcpu.arch.efer;
> +	nested_vmcb->save.cr0    = kvm_read_cr0(&svm->vcpu);
> +	nested_vmcb->save.cr3    = kvm_read_cr3(&svm->vcpu);
> +	nested_vmcb->save.cr2    = vmcb->save.cr2;
> +	nested_vmcb->save.cr4    = svm->vcpu.arch.cr4;
> +	nested_vmcb->save.rflags = kvm_get_rflags(&svm->vcpu);
> +	nested_vmcb->save.rip    = vmcb->save.rip;
> +	nested_vmcb->save.rsp    = vmcb->save.rsp;
> +	nested_vmcb->save.rax    = vmcb->save.rax;
> +	nested_vmcb->save.dr7    = vmcb->save.dr7;
> +	nested_vmcb->save.dr6    = vmcb->save.dr6;
> +	nested_vmcb->save.cpl    = vmcb->save.cpl;
> +
> +	nested_vmcb->control.int_ctl           = vmcb->control.int_ctl;
> +	nested_vmcb->control.int_vector        = vmcb->control.int_vector;
> +	nested_vmcb->control.int_state         = vmcb->control.int_state;
> +	nested_vmcb->control.exit_code         = vmcb->control.exit_code;
> +	nested_vmcb->control.exit_code_hi      = vmcb->control.exit_code_hi;
> +	nested_vmcb->control.exit_info_1       = vmcb->control.exit_info_1;
> +	nested_vmcb->control.exit_info_2       = vmcb->control.exit_info_2;
> +	nested_vmcb->control.exit_int_info     = vmcb->control.exit_int_info;
> +	nested_vmcb->control.exit_int_info_err = vmcb->control.exit_int_info_err;
> +
> +	if (svm->nrips_enabled)
> +		nested_vmcb->control.next_rip  = vmcb->control.next_rip;
> +
> +	/*
> +	 * If we emulate a VMRUN/#VMEXIT in the same host #vmexit cycle we have
> +	 * to make sure that we do not lose injected events. So check event_inj
> +	 * here and copy it to exit_int_info if it is valid.
> +	 * Exit_int_info and event_inj can't be both valid because the case
> +	 * below only happens on a VMRUN instruction intercept which has
> +	 * no valid exit_int_info set.
> +	 */
> +	if (vmcb->control.event_inj & SVM_EVTINJ_VALID) {
> +		struct vmcb_control_area *nc = &nested_vmcb->control;
> +
> +		nc->exit_int_info     = vmcb->control.event_inj;
> +		nc->exit_int_info_err = vmcb->control.event_inj_err;
> +	}
> +
> +	nested_vmcb->control.tlb_ctl           = 0;
> +	nested_vmcb->control.event_inj         = 0;
> +	nested_vmcb->control.event_inj_err     = 0;
> +
> +	nested_vmcb->control.pause_filter_count =
> +		svm->vmcb->control.pause_filter_count;
> +	nested_vmcb->control.pause_filter_thresh =
> +		svm->vmcb->control.pause_filter_thresh;
> +
> +	/* We always set V_INTR_MASKING and remember the old value in hflags */
> +	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
> +		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> +
> +	/* Restore the original control entries */
> +	copy_vmcb_control_area(vmcb, hsave);
> +
> +	svm->vcpu.arch.tsc_offset = svm->vmcb->control.tsc_offset;
> +	kvm_clear_exception_queue(&svm->vcpu);
> +	kvm_clear_interrupt_queue(&svm->vcpu);
> +
> +	svm->nested.nested_cr3 = 0;
> +
> +	/* Restore selected save entries */
> +	svm->vmcb->save.es = hsave->save.es;
> +	svm->vmcb->save.cs = hsave->save.cs;
> +	svm->vmcb->save.ss = hsave->save.ss;
> +	svm->vmcb->save.ds = hsave->save.ds;
> +	svm->vmcb->save.gdtr = hsave->save.gdtr;
> +	svm->vmcb->save.idtr = hsave->save.idtr;
> +	kvm_set_rflags(&svm->vcpu, hsave->save.rflags);
> +	svm_set_efer(&svm->vcpu, hsave->save.efer);
> +	svm_set_cr0(&svm->vcpu, hsave->save.cr0 | X86_CR0_PE);
> +	svm_set_cr4(&svm->vcpu, hsave->save.cr4);
> +	if (npt_enabled) {
> +		svm->vmcb->save.cr3 = hsave->save.cr3;
> +		svm->vcpu.arch.cr3 = hsave->save.cr3;
> +	} else {
> +		(void)kvm_set_cr3(&svm->vcpu, hsave->save.cr3);
> +	}
> +	kvm_rax_write(&svm->vcpu, hsave->save.rax);
> +	kvm_rsp_write(&svm->vcpu, hsave->save.rsp);
> +	kvm_rip_write(&svm->vcpu, hsave->save.rip);
> +	svm->vmcb->save.dr7 = 0;
> +	svm->vmcb->save.cpl = 0;
> +	svm->vmcb->control.exit_int_info = 0;
> +
> +	mark_all_dirty(svm->vmcb);
> +
> +	kvm_vcpu_unmap(&svm->vcpu, &map, true);
> +
> +	nested_svm_uninit_mmu_context(&svm->vcpu);
> +	kvm_mmu_reset_context(&svm->vcpu);
> +	kvm_mmu_load(&svm->vcpu);
> +
> +	/*
> +	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
> +	 * doesn't end up in L1.
> +	 */
> +	svm->vcpu.arch.nmi_injected = false;
> +	kvm_clear_exception_queue(&svm->vcpu);
> +	kvm_clear_interrupt_queue(&svm->vcpu);
> +
> +	return 0;
> +}
> +
> +static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
> +{
> +	u32 offset, msr, value;
> +	int write, mask;
> +
> +	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
> +		return NESTED_EXIT_HOST;
> +
> +	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
> +	offset = svm_msrpm_offset(msr);
> +	write  = svm->vmcb->control.exit_info_1 & 1;
> +	mask   = 1 << ((2 * (msr & 0xf)) + write);
> +
> +	if (offset == MSR_INVALID)
> +		return NESTED_EXIT_DONE;
> +
> +	/* Offset is in 32 bit units but need in 8 bit units */
> +	offset *= 4;
> +
> +	if (kvm_vcpu_read_guest(&svm->vcpu, svm->nested.vmcb_msrpm + offset, &value, 4))
> +		return NESTED_EXIT_DONE;
> +
> +	return (value & mask) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
> +}
> +
> +/* DB exceptions for our internal use must not cause vmexit */
> +static int nested_svm_intercept_db(struct vcpu_svm *svm)
> +{
> +	unsigned long dr6;
> +
> +	/* if we're not singlestepping, it's not ours */
> +	if (!svm->nmi_singlestep)
> +		return NESTED_EXIT_DONE;
> +
> +	/* if it's not a singlestep exception, it's not ours */
> +	if (kvm_get_dr(&svm->vcpu, 6, &dr6))
> +		return NESTED_EXIT_DONE;
> +	if (!(dr6 & DR6_BS))
> +		return NESTED_EXIT_DONE;
> +
> +	/* if the guest is singlestepping, it should get the vmexit */
> +	if (svm->nmi_singlestep_guest_rflags & X86_EFLAGS_TF) {
> +		disable_nmi_singlestep(svm);
> +		return NESTED_EXIT_DONE;
> +	}
> +
> +	/* it's ours, the nested hypervisor must not see this one */
> +	return NESTED_EXIT_HOST;
> +}
> +
> +static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
> +{
> +	unsigned port, size, iopm_len;
> +	u16 val, mask;
> +	u8 start_bit;
> +	u64 gpa;
> +
> +	if (!(svm->nested.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
> +		return NESTED_EXIT_HOST;
> +
> +	port = svm->vmcb->control.exit_info_1 >> 16;
> +	size = (svm->vmcb->control.exit_info_1 & SVM_IOIO_SIZE_MASK) >>
> +		SVM_IOIO_SIZE_SHIFT;
> +	gpa  = svm->nested.vmcb_iopm + (port / 8);
> +	start_bit = port % 8;
> +	iopm_len = (start_bit + size > 8) ? 2 : 1;
> +	mask = (0xf >> (4 - size)) << start_bit;
> +	val = 0;
> +
> +	if (kvm_vcpu_read_guest(&svm->vcpu, gpa, &val, iopm_len))
> +		return NESTED_EXIT_DONE;
> +
> +	return (val & mask) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
> +}
> +
> +static int nested_svm_intercept(struct vcpu_svm *svm)
> +{
> +	u32 exit_code = svm->vmcb->control.exit_code;
> +	int vmexit = NESTED_EXIT_HOST;
> +
> +	switch (exit_code) {
> +	case SVM_EXIT_MSR:
> +		vmexit = nested_svm_exit_handled_msr(svm);
> +		break;
> +	case SVM_EXIT_IOIO:
> +		vmexit = nested_svm_intercept_ioio(svm);
> +		break;
> +	case SVM_EXIT_READ_CR0 ... SVM_EXIT_WRITE_CR8: {
> +		u32 bit = 1U << (exit_code - SVM_EXIT_READ_CR0);
> +		if (svm->nested.intercept_cr & bit)
> +			vmexit = NESTED_EXIT_DONE;
> +		break;
> +	}
> +	case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
> +		u32 bit = 1U << (exit_code - SVM_EXIT_READ_DR0);
> +		if (svm->nested.intercept_dr & bit)
> +			vmexit = NESTED_EXIT_DONE;
> +		break;
> +	}
> +	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
> +		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
> +		if (svm->nested.intercept_exceptions & excp_bits) {
> +			if (exit_code == SVM_EXIT_EXCP_BASE + DB_VECTOR)
> +				vmexit = nested_svm_intercept_db(svm);
> +			else
> +				vmexit = NESTED_EXIT_DONE;
> +		}
> +		/* async page fault always cause vmexit */
> +		else if ((exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR) &&
> +			 svm->vcpu.arch.exception.nested_apf != 0)
> +			vmexit = NESTED_EXIT_DONE;
> +		break;
> +	}
> +	case SVM_EXIT_ERR: {
> +		vmexit = NESTED_EXIT_DONE;
> +		break;
> +	}
> +	default: {
> +		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
> +		if (svm->nested.intercept & exit_bits)
> +			vmexit = NESTED_EXIT_DONE;
> +	}
> +	}
> +
> +	return vmexit;
> +}
> +
> +int nested_svm_exit_handled(struct vcpu_svm *svm)
> +{
> +	int vmexit;
> +
> +	vmexit = nested_svm_intercept(svm);
> +
> +	if (vmexit == NESTED_EXIT_DONE)
> +		nested_svm_vmexit(svm);
> +
> +	return vmexit;
> +}
> +
> +int nested_svm_check_permissions(struct vcpu_svm *svm)
> +{
> +	if (!(svm->vcpu.arch.efer & EFER_SVME) ||
> +	    !is_paging(&svm->vcpu)) {
> +		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
> +		return 1;
> +	}
> +
> +	if (svm->vmcb->save.cpl) {
> +		kvm_inject_gp(&svm->vcpu, 0);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
> +			       bool has_error_code, u32 error_code)
> +{
> +	int vmexit;
> +
> +	if (!is_guest_mode(&svm->vcpu))
> +		return 0;
> +
> +	vmexit = nested_svm_intercept(svm);
> +	if (vmexit != NESTED_EXIT_DONE)
> +		return 0;
> +
> +	svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
> +	svm->vmcb->control.exit_code_hi = 0;
> +	svm->vmcb->control.exit_info_1 = error_code;
> +
> +	/*
> +	 * EXITINFO2 is undefined for all exception intercepts other
> +	 * than #PF.
> +	 */
> +	if (svm->vcpu.arch.exception.nested_apf)
> +		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.apf.nested_apf_token;
> +	else if (svm->vcpu.arch.exception.has_payload)
> +		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.exception.payload;
> +	else
> +		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
> +
> +	svm->nested.exit_required = true;
> +	return vmexit;
> +}
> +
> +static void nested_svm_intr(struct vcpu_svm *svm)
> +{
> +	svm->vmcb->control.exit_code   = SVM_EXIT_INTR;
> +	svm->vmcb->control.exit_info_1 = 0;
> +	svm->vmcb->control.exit_info_2 = 0;
> +
> +	/* nested_svm_vmexit this gets called afterwards from handle_exit */
> +	svm->nested.exit_required = true;
> +	trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
> +}
> +
> +static bool nested_exit_on_intr(struct vcpu_svm *svm)
> +{
> +	return (svm->nested.intercept & 1ULL);
> +}
> +
> +int svm_check_nested_events(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	bool block_nested_events =
> +		kvm_event_needs_reinjection(vcpu) || svm->nested.exit_required;
> +
> +	if (kvm_cpu_has_interrupt(vcpu) && nested_exit_on_intr(svm)) {
> +		if (block_nested_events)
> +			return -EBUSY;
> +		nested_svm_intr(svm);
> +		return 0;
> +	}
> +
> +	return 0;
> +}
> +
> +int nested_svm_exit_special(struct vcpu_svm *svm)
> +{
> +	u32 exit_code = svm->vmcb->control.exit_code;
> +
> +	switch (exit_code) {
> +	case SVM_EXIT_INTR:
> +	case SVM_EXIT_NMI:
> +	case SVM_EXIT_EXCP_BASE + MC_VECTOR:
> +		return NESTED_EXIT_HOST;
> +	case SVM_EXIT_NPF:
> +		/* For now we are always handling NPFs when using them */
> +		if (npt_enabled)
> +			return NESTED_EXIT_HOST;
> +		break;
> +	case SVM_EXIT_EXCP_BASE + PF_VECTOR:
> +		/* When we're shadowing, trap PFs, but not async PF */
> +		if (!npt_enabled && svm->vcpu.arch.apf.host_apf_reason == 0)
> +			return NESTED_EXIT_HOST;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return NESTED_EXIT_CONTINUE;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2125c6ae5951..b74ebc19e1f6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -52,6 +52,8 @@
>  #include <asm/virtext.h>
>  #include "trace.h"
>  
> +#include "svm.h"
> +
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>  
>  MODULE_AUTHOR("Qumranet");
> @@ -79,10 +81,6 @@ MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
>  
>  #define SVM_AVIC_DOORBELL	0xc001011b
>  
> -#define NESTED_EXIT_HOST	0	/* Exit handled on host level */
> -#define NESTED_EXIT_DONE	1	/* Exit caused nested vmexit  */
> -#define NESTED_EXIT_CONTINUE	2	/* Further checks needed      */
> -
>  #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
>  
>  #define TSC_RATIO_RSVD          0xffffff0000000000ULL
> @@ -116,68 +114,7 @@ MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
>  
>  static bool erratum_383_found __read_mostly;
>  
> -static const u32 host_save_user_msrs[] = {
> -#ifdef CONFIG_X86_64
> -	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
> -	MSR_FS_BASE,
> -#endif
> -	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
> -	MSR_TSC_AUX,
> -};
> -
> -#define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
> -
> -struct kvm_sev_info {
> -	bool active;		/* SEV enabled guest */
> -	unsigned int asid;	/* ASID used for this guest */
> -	unsigned int handle;	/* SEV firmware handle */
> -	int fd;			/* SEV device fd */
> -	unsigned long pages_locked; /* Number of pages locked */
> -	struct list_head regions_list;  /* List of registered regions */
> -};
> -
> -struct kvm_svm {
> -	struct kvm kvm;
> -
> -	/* Struct members for AVIC */
> -	u32 avic_vm_id;
> -	struct page *avic_logical_id_table_page;
> -	struct page *avic_physical_id_table_page;
> -	struct hlist_node hnode;
> -
> -	struct kvm_sev_info sev_info;
> -};
> -
> -struct kvm_vcpu;
> -
> -struct nested_state {
> -	struct vmcb *hsave;
> -	u64 hsave_msr;
> -	u64 vm_cr_msr;
> -	u64 vmcb;
> -
> -	/* These are the merged vectors */
> -	u32 *msrpm;
> -
> -	/* gpa pointers to the real vectors */
> -	u64 vmcb_msrpm;
> -	u64 vmcb_iopm;
> -
> -	/* A VMEXIT is required but not yet emulated */
> -	bool exit_required;
> -
> -	/* cache for intercepts of the guest */
> -	u32 intercept_cr;
> -	u32 intercept_dr;
> -	u32 intercept_exceptions;
> -	u64 intercept;
> -
> -	/* Nested Paging related state */
> -	u64 nested_cr3;
> -};
> -
> -#define MSRPM_OFFSETS	16
> -static u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
> +u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  
>  /*
>   * Set osvw_len to higher value when updated Revision Guides
> @@ -185,70 +122,6 @@ static u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>   */
>  static uint64_t osvw_len = 4, osvw_status;
>  
> -struct vcpu_svm {
> -	struct kvm_vcpu vcpu;
> -	struct vmcb *vmcb;
> -	unsigned long vmcb_pa;
> -	struct svm_cpu_data *svm_data;
> -	uint64_t asid_generation;
> -	uint64_t sysenter_esp;
> -	uint64_t sysenter_eip;
> -	uint64_t tsc_aux;
> -
> -	u64 msr_decfg;
> -
> -	u64 next_rip;
> -
> -	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
> -	struct {
> -		u16 fs;
> -		u16 gs;
> -		u16 ldt;
> -		u64 gs_base;
> -	} host;
> -
> -	u64 spec_ctrl;
> -	/*
> -	 * Contains guest-controlled bits of VIRT_SPEC_CTRL, which will be
> -	 * translated into the appropriate L2_CFG bits on the host to
> -	 * perform speculative control.
> -	 */
> -	u64 virt_spec_ctrl;
> -
> -	u32 *msrpm;
> -
> -	ulong nmi_iret_rip;
> -
> -	struct nested_state nested;
> -
> -	bool nmi_singlestep;
> -	u64 nmi_singlestep_guest_rflags;
> -
> -	unsigned int3_injected;
> -	unsigned long int3_rip;
> -
> -	/* cached guest cpuid flags for faster access */
> -	bool nrips_enabled	: 1;
> -
> -	u32 ldr_reg;
> -	u32 dfr_reg;
> -	struct page *avic_backing_page;
> -	u64 *avic_physical_id_cache;
> -	bool avic_is_running;
> -
> -	/*
> -	 * Per-vcpu list of struct amd_svm_iommu_ir:
> -	 * This is used mainly to store interrupt remapping information used
> -	 * when update the vcpu affinity. This avoids the need to scan for
> -	 * IRTE and try to match ga_tag in the IOMMU driver.
> -	 */
> -	struct list_head ir_list;
> -	spinlock_t ir_list_lock;
> -
> -	/* which host CPU was used for running this vcpu */
> -	unsigned int last_cpu;
> -};
> -
>  /*
>   * This is a wrapper of struct amd_iommu_ir_data.
>   */
> @@ -269,8 +142,6 @@ struct amd_svm_iommu_ir {
>  static DEFINE_PER_CPU(u64, current_tsc_ratio);
>  #define TSC_RATIO_DEFAULT	0x0100000000ULL
>  
> -#define MSR_INVALID			0xffffffffU
> -
>  static const struct svm_direct_access_msrs {
>  	u32 index;   /* Index of the MSR */
>  	bool always; /* True if intercept is always on */
> @@ -296,9 +167,9 @@ static const struct svm_direct_access_msrs {
>  
>  /* enable NPT for AMD64 and X86 with PAE */
>  #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
> -static bool npt_enabled = true;
> +bool npt_enabled = true;
>  #else
> -static bool npt_enabled;
> +bool npt_enabled;
>  #endif
>  
>  /*
> @@ -384,41 +255,10 @@ module_param(dump_invalid_vmcb, bool, 0644);
>  
>  static u8 rsm_ins_bytes[] = "\x0f\xaa";
>  
> -static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
> -static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
>  static void svm_complete_interrupts(struct vcpu_svm *svm);
>  static void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate);
>  static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
>  
> -static int nested_svm_exit_handled(struct vcpu_svm *svm);
> -static int nested_svm_intercept(struct vcpu_svm *svm);
> -static int nested_svm_vmexit(struct vcpu_svm *svm);
> -static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
> -				      bool has_error_code, u32 error_code);
> -
> -enum {
> -	VMCB_INTERCEPTS, /* Intercept vectors, TSC offset,
> -			    pause filter count */
> -	VMCB_PERM_MAP,   /* IOPM Base and MSRPM Base */
> -	VMCB_ASID,	 /* ASID */
> -	VMCB_INTR,	 /* int_ctl, int_vector */
> -	VMCB_NPT,        /* npt_en, nCR3, gPAT */
> -	VMCB_CR,	 /* CR0, CR3, CR4, EFER */
> -	VMCB_DR,         /* DR6, DR7 */
> -	VMCB_DT,         /* GDT, IDT */
> -	VMCB_SEG,        /* CS, DS, SS, ES, CPL */
> -	VMCB_CR2,        /* CR2 only */
> -	VMCB_LBR,        /* DBGCTL, BR_FROM, BR_TO, LAST_EX_FROM, LAST_EX_TO */
> -	VMCB_AVIC,       /* AVIC APIC_BAR, AVIC APIC_BACKING_PAGE,
> -			  * AVIC PHYSICAL_TABLE pointer,
> -			  * AVIC LOGICAL_TABLE pointer
> -			  */
> -	VMCB_DIRTY_MAX,
> -};
> -
> -/* TPR and CR2 are always written before VMRUN */
> -#define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
> -
>  #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
>  
>  static int sev_flush_asids(void);
> @@ -467,27 +307,6 @@ static inline int sev_get_asid(struct kvm *kvm)
>  	return sev->asid;
>  }
>  
> -static inline void mark_all_dirty(struct vmcb *vmcb)
> -{
> -	vmcb->control.clean = 0;
> -}
> -
> -static inline void mark_all_clean(struct vmcb *vmcb)
> -{
> -	vmcb->control.clean = ((1 << VMCB_DIRTY_MAX) - 1)
> -			       & ~VMCB_ALWAYS_DIRTY_MASK;
> -}
> -
> -static inline void mark_dirty(struct vmcb *vmcb, int bit)
> -{
> -	vmcb->control.clean &= ~(1 << bit);
> -}
> -
> -static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
> -{
> -	return container_of(vcpu, struct vcpu_svm, vcpu);
> -}
> -
>  static inline void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data)
>  {
>  	svm->vmcb->control.avic_vapic_bar = data & VMCB_AVIC_APIC_BAR_MASK;
> @@ -505,183 +324,6 @@ static inline bool avic_vcpu_is_running(struct kvm_vcpu *vcpu)
>  	return (READ_ONCE(*entry) & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
>  }
>  
> -static void recalc_intercepts(struct vcpu_svm *svm)
> -{
> -	struct vmcb_control_area *c, *h;
> -	struct nested_state *g;
> -
> -	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> -
> -	if (!is_guest_mode(&svm->vcpu))
> -		return;
> -
> -	c = &svm->vmcb->control;
> -	h = &svm->nested.hsave->control;
> -	g = &svm->nested;
> -
> -	c->intercept_cr = h->intercept_cr;
> -	c->intercept_dr = h->intercept_dr;
> -	c->intercept_exceptions = h->intercept_exceptions;
> -	c->intercept = h->intercept;
> -
> -	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
> -		/* We only want the cr8 intercept bits of L1 */
> -		c->intercept_cr &= ~(1U << INTERCEPT_CR8_READ);
> -		c->intercept_cr &= ~(1U << INTERCEPT_CR8_WRITE);
> -
> -		/*
> -		 * Once running L2 with HF_VINTR_MASK, EFLAGS.IF does not
> -		 * affect any interrupt we may want to inject; therefore,
> -		 * interrupt window vmexits are irrelevant to L0.
> -		 */
> -		c->intercept &= ~(1ULL << INTERCEPT_VINTR);
> -	}
> -
> -	/* We don't want to see VMMCALLs from a nested guest */
> -	c->intercept &= ~(1ULL << INTERCEPT_VMMCALL);
> -
> -	c->intercept_cr |= g->intercept_cr;
> -	c->intercept_dr |= g->intercept_dr;
> -	c->intercept_exceptions |= g->intercept_exceptions;
> -	c->intercept |= g->intercept;
> -}
> -
> -static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
> -{
> -	if (is_guest_mode(&svm->vcpu))
> -		return svm->nested.hsave;
> -	else
> -		return svm->vmcb;
> -}
> -
> -static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
> -{
> -	struct vmcb *vmcb = get_host_vmcb(svm);
> -
> -	vmcb->control.intercept_cr |= (1U << bit);
> -
> -	recalc_intercepts(svm);
> -}
> -
> -static inline void clr_cr_intercept(struct vcpu_svm *svm, int bit)
> -{
> -	struct vmcb *vmcb = get_host_vmcb(svm);
> -
> -	vmcb->control.intercept_cr &= ~(1U << bit);
> -
> -	recalc_intercepts(svm);
> -}
> -
> -static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
> -{
> -	struct vmcb *vmcb = get_host_vmcb(svm);
> -
> -	return vmcb->control.intercept_cr & (1U << bit);
> -}
> -
> -static inline void set_dr_intercepts(struct vcpu_svm *svm)
> -{
> -	struct vmcb *vmcb = get_host_vmcb(svm);
> -
> -	vmcb->control.intercept_dr = (1 << INTERCEPT_DR0_READ)
> -		| (1 << INTERCEPT_DR1_READ)
> -		| (1 << INTERCEPT_DR2_READ)
> -		| (1 << INTERCEPT_DR3_READ)
> -		| (1 << INTERCEPT_DR4_READ)
> -		| (1 << INTERCEPT_DR5_READ)
> -		| (1 << INTERCEPT_DR6_READ)
> -		| (1 << INTERCEPT_DR7_READ)
> -		| (1 << INTERCEPT_DR0_WRITE)
> -		| (1 << INTERCEPT_DR1_WRITE)
> -		| (1 << INTERCEPT_DR2_WRITE)
> -		| (1 << INTERCEPT_DR3_WRITE)
> -		| (1 << INTERCEPT_DR4_WRITE)
> -		| (1 << INTERCEPT_DR5_WRITE)
> -		| (1 << INTERCEPT_DR6_WRITE)
> -		| (1 << INTERCEPT_DR7_WRITE);
> -
> -	recalc_intercepts(svm);
> -}
> -
> -static inline void clr_dr_intercepts(struct vcpu_svm *svm)
> -{
> -	struct vmcb *vmcb = get_host_vmcb(svm);
> -
> -	vmcb->control.intercept_dr = 0;
> -
> -	recalc_intercepts(svm);
> -}
> -
> -static inline void set_exception_intercept(struct vcpu_svm *svm, int bit)
> -{
> -	struct vmcb *vmcb = get_host_vmcb(svm);
> -
> -	vmcb->control.intercept_exceptions |= (1U << bit);
> -
> -	recalc_intercepts(svm);
> -}
> -
> -static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
> -{
> -	struct vmcb *vmcb = get_host_vmcb(svm);
> -
> -	vmcb->control.intercept_exceptions &= ~(1U << bit);
> -
> -	recalc_intercepts(svm);
> -}
> -
> -static inline void set_intercept(struct vcpu_svm *svm, int bit)
> -{
> -	struct vmcb *vmcb = get_host_vmcb(svm);
> -
> -	vmcb->control.intercept |= (1ULL << bit);
> -
> -	recalc_intercepts(svm);
> -}
> -
> -static inline void clr_intercept(struct vcpu_svm *svm, int bit)
> -{
> -	struct vmcb *vmcb = get_host_vmcb(svm);
> -
> -	vmcb->control.intercept &= ~(1ULL << bit);
> -
> -	recalc_intercepts(svm);
> -}
> -
> -static inline bool is_intercept(struct vcpu_svm *svm, int bit)
> -{
> -	return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
> -}
> -
> -static inline bool vgif_enabled(struct vcpu_svm *svm)
> -{
> -	return !!(svm->vmcb->control.int_ctl & V_GIF_ENABLE_MASK);
> -}
> -
> -static inline void enable_gif(struct vcpu_svm *svm)
> -{
> -	if (vgif_enabled(svm))
> -		svm->vmcb->control.int_ctl |= V_GIF_MASK;
> -	else
> -		svm->vcpu.arch.hflags |= HF_GIF_MASK;
> -}
> -
> -static inline void disable_gif(struct vcpu_svm *svm)
> -{
> -	if (vgif_enabled(svm))
> -		svm->vmcb->control.int_ctl &= ~V_GIF_MASK;
> -	else
> -		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
> -}
> -
> -static inline bool gif_set(struct vcpu_svm *svm)
> -{
> -	if (vgif_enabled(svm))
> -		return !!(svm->vmcb->control.int_ctl & V_GIF_MASK);
> -	else
> -		return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
> -}
> -
>  static unsigned long iopm_base;
>  
>  struct kvm_ldttss_desc {
> @@ -717,7 +359,7 @@ static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
>  #define MSRS_RANGE_SIZE 2048
>  #define MSRS_IN_RANGE (MSRS_RANGE_SIZE * 8 / 2)
>  
> -static u32 svm_msrpm_offset(u32 msr)
> +u32 svm_msrpm_offset(u32 msr)
>  {
>  	u32 offset;
>  	int i;
> @@ -764,7 +406,7 @@ static int get_npt_level(struct kvm_vcpu *vcpu)
>  #endif
>  }
>  
> -static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> +void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  {
>  	vcpu->arch.efer = efer;
>  
> @@ -1195,7 +837,7 @@ static void svm_disable_lbrv(struct vcpu_svm *svm)
>  	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
>  }
>  
> -static void disable_nmi_singlestep(struct vcpu_svm *svm)
> +void disable_nmi_singlestep(struct vcpu_svm *svm)
>  {
>  	svm->nmi_singlestep = false;
>  
> @@ -2649,7 +2291,7 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
>  	}
>  }
>  
> -static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> +void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> @@ -2683,7 +2325,7 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	update_cr0_intercept(svm);
>  }
>  
> -static int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> +int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
>  	unsigned long host_cr4_mce = cr4_read_shadow() & X86_CR4_MCE;
>  	unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;
> @@ -3019,776 +2661,6 @@ static int vmmcall_interception(struct vcpu_svm *svm)
>  	return kvm_emulate_hypercall(&svm->vcpu);
>  }
>  
> -static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -
> -	return svm->nested.nested_cr3;
> -}
> -
> -static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -	u64 cr3 = svm->nested.nested_cr3;
> -	u64 pdpte;
> -	int ret;
> -
> -	ret = kvm_vcpu_read_guest_page(vcpu, gpa_to_gfn(__sme_clr(cr3)), &pdpte,
> -				       offset_in_page(cr3) + index * 8, 8);
> -	if (ret)
> -		return 0;
> -	return pdpte;
> -}
> -
> -static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
> -				       struct x86_exception *fault)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -
> -	if (svm->vmcb->control.exit_code != SVM_EXIT_NPF) {
> -		/*
> -		 * TODO: track the cause of the nested page fault, and
> -		 * correctly fill in the high bits of exit_info_1.
> -		 */
> -		svm->vmcb->control.exit_code = SVM_EXIT_NPF;
> -		svm->vmcb->control.exit_code_hi = 0;
> -		svm->vmcb->control.exit_info_1 = (1ULL << 32);
> -		svm->vmcb->control.exit_info_2 = fault->address;
> -	}
> -
> -	svm->vmcb->control.exit_info_1 &= ~0xffffffffULL;
> -	svm->vmcb->control.exit_info_1 |= fault->error_code;
> -
> -	/*
> -	 * The present bit is always zero for page structure faults on real
> -	 * hardware.
> -	 */
> -	if (svm->vmcb->control.exit_info_1 & (2ULL << 32))
> -		svm->vmcb->control.exit_info_1 &= ~1;
> -
> -	nested_svm_vmexit(svm);
> -}
> -
> -static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
> -{
> -	WARN_ON(mmu_is_nested(vcpu));
> -
> -	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
> -	kvm_init_shadow_mmu(vcpu);
> -	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
> -	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
> -	vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
> -	vcpu->arch.mmu->shadow_root_level = get_npt_level(vcpu);
> -	reset_shadow_zero_bits_mask(vcpu, vcpu->arch.mmu);
> -	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
> -}
> -
> -static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
> -{
> -	vcpu->arch.mmu = &vcpu->arch.root_mmu;
> -	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> -}
> -
> -static int nested_svm_check_permissions(struct vcpu_svm *svm)
> -{
> -	if (!(svm->vcpu.arch.efer & EFER_SVME) ||
> -	    !is_paging(&svm->vcpu)) {
> -		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
> -		return 1;
> -	}
> -
> -	if (svm->vmcb->save.cpl) {
> -		kvm_inject_gp(&svm->vcpu, 0);
> -		return 1;
> -	}
> -
> -	return 0;
> -}
> -
> -static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
> -				      bool has_error_code, u32 error_code)
> -{
> -	int vmexit;
> -
> -	if (!is_guest_mode(&svm->vcpu))
> -		return 0;
> -
> -	vmexit = nested_svm_intercept(svm);
> -	if (vmexit != NESTED_EXIT_DONE)
> -		return 0;
> -
> -	svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
> -	svm->vmcb->control.exit_code_hi = 0;
> -	svm->vmcb->control.exit_info_1 = error_code;
> -
> -	/*
> -	 * EXITINFO2 is undefined for all exception intercepts other
> -	 * than #PF.
> -	 */
> -	if (svm->vcpu.arch.exception.nested_apf)
> -		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.apf.nested_apf_token;
> -	else if (svm->vcpu.arch.exception.has_payload)
> -		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.exception.payload;
> -	else
> -		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
> -
> -	svm->nested.exit_required = true;
> -	return vmexit;
> -}
> -
> -static void nested_svm_intr(struct vcpu_svm *svm)
> -{
> -	svm->vmcb->control.exit_code   = SVM_EXIT_INTR;
> -	svm->vmcb->control.exit_info_1 = 0;
> -	svm->vmcb->control.exit_info_2 = 0;
> -
> -	/* nested_svm_vmexit this gets called afterwards from handle_exit */
> -	svm->nested.exit_required = true;
> -	trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
> -}
> -
> -static bool nested_exit_on_intr(struct vcpu_svm *svm)
> -{
> -	return (svm->nested.intercept & 1ULL);
> -}
> -
> -static int svm_check_nested_events(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -	bool block_nested_events =
> -		kvm_event_needs_reinjection(vcpu) || svm->nested.exit_required;
> -
> -	if (kvm_cpu_has_interrupt(vcpu) && nested_exit_on_intr(svm)) {
> -		if (block_nested_events)
> -			return -EBUSY;
> -		nested_svm_intr(svm);
> -		return 0;
> -	}
> -
> -	return 0;
> -}
> -
> -/* This function returns true if it is save to enable the nmi window */
> -static inline bool nested_svm_nmi(struct vcpu_svm *svm)
> -{
> -	if (!is_guest_mode(&svm->vcpu))
> -		return true;
> -
> -	if (!(svm->nested.intercept & (1ULL << INTERCEPT_NMI)))
> -		return true;
> -
> -	svm->vmcb->control.exit_code = SVM_EXIT_NMI;
> -	svm->nested.exit_required = true;
> -
> -	return false;
> -}
> -
> -static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
> -{
> -	unsigned port, size, iopm_len;
> -	u16 val, mask;
> -	u8 start_bit;
> -	u64 gpa;
> -
> -	if (!(svm->nested.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
> -		return NESTED_EXIT_HOST;
> -
> -	port = svm->vmcb->control.exit_info_1 >> 16;
> -	size = (svm->vmcb->control.exit_info_1 & SVM_IOIO_SIZE_MASK) >>
> -		SVM_IOIO_SIZE_SHIFT;
> -	gpa  = svm->nested.vmcb_iopm + (port / 8);
> -	start_bit = port % 8;
> -	iopm_len = (start_bit + size > 8) ? 2 : 1;
> -	mask = (0xf >> (4 - size)) << start_bit;
> -	val = 0;
> -
> -	if (kvm_vcpu_read_guest(&svm->vcpu, gpa, &val, iopm_len))
> -		return NESTED_EXIT_DONE;
> -
> -	return (val & mask) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
> -}
> -
> -static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
> -{
> -	u32 offset, msr, value;
> -	int write, mask;
> -
> -	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
> -		return NESTED_EXIT_HOST;
> -
> -	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
> -	offset = svm_msrpm_offset(msr);
> -	write  = svm->vmcb->control.exit_info_1 & 1;
> -	mask   = 1 << ((2 * (msr & 0xf)) + write);
> -
> -	if (offset == MSR_INVALID)
> -		return NESTED_EXIT_DONE;
> -
> -	/* Offset is in 32 bit units but need in 8 bit units */
> -	offset *= 4;
> -
> -	if (kvm_vcpu_read_guest(&svm->vcpu, svm->nested.vmcb_msrpm + offset, &value, 4))
> -		return NESTED_EXIT_DONE;
> -
> -	return (value & mask) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
> -}
> -
> -/* DB exceptions for our internal use must not cause vmexit */
> -static int nested_svm_intercept_db(struct vcpu_svm *svm)
> -{
> -	unsigned long dr6;
> -
> -	/* if we're not singlestepping, it's not ours */
> -	if (!svm->nmi_singlestep)
> -		return NESTED_EXIT_DONE;
> -
> -	/* if it's not a singlestep exception, it's not ours */
> -	if (kvm_get_dr(&svm->vcpu, 6, &dr6))
> -		return NESTED_EXIT_DONE;
> -	if (!(dr6 & DR6_BS))
> -		return NESTED_EXIT_DONE;
> -
> -	/* if the guest is singlestepping, it should get the vmexit */
> -	if (svm->nmi_singlestep_guest_rflags & X86_EFLAGS_TF) {
> -		disable_nmi_singlestep(svm);
> -		return NESTED_EXIT_DONE;
> -	}
> -
> -	/* it's ours, the nested hypervisor must not see this one */
> -	return NESTED_EXIT_HOST;
> -}
> -
> -static int nested_svm_exit_special(struct vcpu_svm *svm)
> -{
> -	u32 exit_code = svm->vmcb->control.exit_code;
> -
> -	switch (exit_code) {
> -	case SVM_EXIT_INTR:
> -	case SVM_EXIT_NMI:
> -	case SVM_EXIT_EXCP_BASE + MC_VECTOR:
> -		return NESTED_EXIT_HOST;
> -	case SVM_EXIT_NPF:
> -		/* For now we are always handling NPFs when using them */
> -		if (npt_enabled)
> -			return NESTED_EXIT_HOST;
> -		break;
> -	case SVM_EXIT_EXCP_BASE + PF_VECTOR:
> -		/* When we're shadowing, trap PFs, but not async PF */
> -		if (!npt_enabled && svm->vcpu.arch.apf.host_apf_reason == 0)
> -			return NESTED_EXIT_HOST;
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	return NESTED_EXIT_CONTINUE;
> -}
> -
> -static int nested_svm_intercept(struct vcpu_svm *svm)
> -{
> -	u32 exit_code = svm->vmcb->control.exit_code;
> -	int vmexit = NESTED_EXIT_HOST;
> -
> -	switch (exit_code) {
> -	case SVM_EXIT_MSR:
> -		vmexit = nested_svm_exit_handled_msr(svm);
> -		break;
> -	case SVM_EXIT_IOIO:
> -		vmexit = nested_svm_intercept_ioio(svm);
> -		break;
> -	case SVM_EXIT_READ_CR0 ... SVM_EXIT_WRITE_CR8: {
> -		u32 bit = 1U << (exit_code - SVM_EXIT_READ_CR0);
> -		if (svm->nested.intercept_cr & bit)
> -			vmexit = NESTED_EXIT_DONE;
> -		break;
> -	}
> -	case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
> -		u32 bit = 1U << (exit_code - SVM_EXIT_READ_DR0);
> -		if (svm->nested.intercept_dr & bit)
> -			vmexit = NESTED_EXIT_DONE;
> -		break;
> -	}
> -	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
> -		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
> -		if (svm->nested.intercept_exceptions & excp_bits) {
> -			if (exit_code == SVM_EXIT_EXCP_BASE + DB_VECTOR)
> -				vmexit = nested_svm_intercept_db(svm);
> -			else
> -				vmexit = NESTED_EXIT_DONE;
> -		}
> -		/* async page fault always cause vmexit */
> -		else if ((exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR) &&
> -			 svm->vcpu.arch.exception.nested_apf != 0)
> -			vmexit = NESTED_EXIT_DONE;
> -		break;
> -	}
> -	case SVM_EXIT_ERR: {
> -		vmexit = NESTED_EXIT_DONE;
> -		break;
> -	}
> -	default: {
> -		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
> -		if (svm->nested.intercept & exit_bits)
> -			vmexit = NESTED_EXIT_DONE;
> -	}
> -	}
> -
> -	return vmexit;
> -}
> -
> -static int nested_svm_exit_handled(struct vcpu_svm *svm)
> -{
> -	int vmexit;
> -
> -	vmexit = nested_svm_intercept(svm);
> -
> -	if (vmexit == NESTED_EXIT_DONE)
> -		nested_svm_vmexit(svm);
> -
> -	return vmexit;
> -}
> -
> -static inline void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *from_vmcb)
> -{
> -	struct vmcb_control_area *dst  = &dst_vmcb->control;
> -	struct vmcb_control_area *from = &from_vmcb->control;
> -
> -	dst->intercept_cr         = from->intercept_cr;
> -	dst->intercept_dr         = from->intercept_dr;
> -	dst->intercept_exceptions = from->intercept_exceptions;
> -	dst->intercept            = from->intercept;
> -	dst->iopm_base_pa         = from->iopm_base_pa;
> -	dst->msrpm_base_pa        = from->msrpm_base_pa;
> -	dst->tsc_offset           = from->tsc_offset;
> -	dst->asid                 = from->asid;
> -	dst->tlb_ctl              = from->tlb_ctl;
> -	dst->int_ctl              = from->int_ctl;
> -	dst->int_vector           = from->int_vector;
> -	dst->int_state            = from->int_state;
> -	dst->exit_code            = from->exit_code;
> -	dst->exit_code_hi         = from->exit_code_hi;
> -	dst->exit_info_1          = from->exit_info_1;
> -	dst->exit_info_2          = from->exit_info_2;
> -	dst->exit_int_info        = from->exit_int_info;
> -	dst->exit_int_info_err    = from->exit_int_info_err;
> -	dst->nested_ctl           = from->nested_ctl;
> -	dst->event_inj            = from->event_inj;
> -	dst->event_inj_err        = from->event_inj_err;
> -	dst->nested_cr3           = from->nested_cr3;
> -	dst->virt_ext              = from->virt_ext;
> -	dst->pause_filter_count   = from->pause_filter_count;
> -	dst->pause_filter_thresh  = from->pause_filter_thresh;
> -}
> -
> -static int nested_svm_vmexit(struct vcpu_svm *svm)
> -{
> -	int rc;
> -	struct vmcb *nested_vmcb;
> -	struct vmcb *hsave = svm->nested.hsave;
> -	struct vmcb *vmcb = svm->vmcb;
> -	struct kvm_host_map map;
> -
> -	trace_kvm_nested_vmexit_inject(vmcb->control.exit_code,
> -				       vmcb->control.exit_info_1,
> -				       vmcb->control.exit_info_2,
> -				       vmcb->control.exit_int_info,
> -				       vmcb->control.exit_int_info_err,
> -				       KVM_ISA_SVM);
> -
> -	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb), &map);
> -	if (rc) {
> -		if (rc == -EINVAL)
> -			kvm_inject_gp(&svm->vcpu, 0);
> -		return 1;
> -	}
> -
> -	nested_vmcb = map.hva;
> -
> -	/* Exit Guest-Mode */
> -	leave_guest_mode(&svm->vcpu);
> -	svm->nested.vmcb = 0;
> -
> -	/* Give the current vmcb to the guest */
> -	disable_gif(svm);
> -
> -	nested_vmcb->save.es     = vmcb->save.es;
> -	nested_vmcb->save.cs     = vmcb->save.cs;
> -	nested_vmcb->save.ss     = vmcb->save.ss;
> -	nested_vmcb->save.ds     = vmcb->save.ds;
> -	nested_vmcb->save.gdtr   = vmcb->save.gdtr;
> -	nested_vmcb->save.idtr   = vmcb->save.idtr;
> -	nested_vmcb->save.efer   = svm->vcpu.arch.efer;
> -	nested_vmcb->save.cr0    = kvm_read_cr0(&svm->vcpu);
> -	nested_vmcb->save.cr3    = kvm_read_cr3(&svm->vcpu);
> -	nested_vmcb->save.cr2    = vmcb->save.cr2;
> -	nested_vmcb->save.cr4    = svm->vcpu.arch.cr4;
> -	nested_vmcb->save.rflags = kvm_get_rflags(&svm->vcpu);
> -	nested_vmcb->save.rip    = vmcb->save.rip;
> -	nested_vmcb->save.rsp    = vmcb->save.rsp;
> -	nested_vmcb->save.rax    = vmcb->save.rax;
> -	nested_vmcb->save.dr7    = vmcb->save.dr7;
> -	nested_vmcb->save.dr6    = vmcb->save.dr6;
> -	nested_vmcb->save.cpl    = vmcb->save.cpl;
> -
> -	nested_vmcb->control.int_ctl           = vmcb->control.int_ctl;
> -	nested_vmcb->control.int_vector        = vmcb->control.int_vector;
> -	nested_vmcb->control.int_state         = vmcb->control.int_state;
> -	nested_vmcb->control.exit_code         = vmcb->control.exit_code;
> -	nested_vmcb->control.exit_code_hi      = vmcb->control.exit_code_hi;
> -	nested_vmcb->control.exit_info_1       = vmcb->control.exit_info_1;
> -	nested_vmcb->control.exit_info_2       = vmcb->control.exit_info_2;
> -	nested_vmcb->control.exit_int_info     = vmcb->control.exit_int_info;
> -	nested_vmcb->control.exit_int_info_err = vmcb->control.exit_int_info_err;
> -
> -	if (svm->nrips_enabled)
> -		nested_vmcb->control.next_rip  = vmcb->control.next_rip;
> -
> -	/*
> -	 * If we emulate a VMRUN/#VMEXIT in the same host #vmexit cycle we have
> -	 * to make sure that we do not lose injected events. So check event_inj
> -	 * here and copy it to exit_int_info if it is valid.
> -	 * Exit_int_info and event_inj can't be both valid because the case
> -	 * below only happens on a VMRUN instruction intercept which has
> -	 * no valid exit_int_info set.
> -	 */
> -	if (vmcb->control.event_inj & SVM_EVTINJ_VALID) {
> -		struct vmcb_control_area *nc = &nested_vmcb->control;
> -
> -		nc->exit_int_info     = vmcb->control.event_inj;
> -		nc->exit_int_info_err = vmcb->control.event_inj_err;
> -	}
> -
> -	nested_vmcb->control.tlb_ctl           = 0;
> -	nested_vmcb->control.event_inj         = 0;
> -	nested_vmcb->control.event_inj_err     = 0;
> -
> -	nested_vmcb->control.pause_filter_count =
> -		svm->vmcb->control.pause_filter_count;
> -	nested_vmcb->control.pause_filter_thresh =
> -		svm->vmcb->control.pause_filter_thresh;
> -
> -	/* We always set V_INTR_MASKING and remember the old value in hflags */
> -	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
> -		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> -
> -	/* Restore the original control entries */
> -	copy_vmcb_control_area(vmcb, hsave);
> -
> -	svm->vcpu.arch.tsc_offset = svm->vmcb->control.tsc_offset;
> -	kvm_clear_exception_queue(&svm->vcpu);
> -	kvm_clear_interrupt_queue(&svm->vcpu);
> -
> -	svm->nested.nested_cr3 = 0;
> -
> -	/* Restore selected save entries */
> -	svm->vmcb->save.es = hsave->save.es;
> -	svm->vmcb->save.cs = hsave->save.cs;
> -	svm->vmcb->save.ss = hsave->save.ss;
> -	svm->vmcb->save.ds = hsave->save.ds;
> -	svm->vmcb->save.gdtr = hsave->save.gdtr;
> -	svm->vmcb->save.idtr = hsave->save.idtr;
> -	kvm_set_rflags(&svm->vcpu, hsave->save.rflags);
> -	svm_set_efer(&svm->vcpu, hsave->save.efer);
> -	svm_set_cr0(&svm->vcpu, hsave->save.cr0 | X86_CR0_PE);
> -	svm_set_cr4(&svm->vcpu, hsave->save.cr4);
> -	if (npt_enabled) {
> -		svm->vmcb->save.cr3 = hsave->save.cr3;
> -		svm->vcpu.arch.cr3 = hsave->save.cr3;
> -	} else {
> -		(void)kvm_set_cr3(&svm->vcpu, hsave->save.cr3);
> -	}
> -	kvm_rax_write(&svm->vcpu, hsave->save.rax);
> -	kvm_rsp_write(&svm->vcpu, hsave->save.rsp);
> -	kvm_rip_write(&svm->vcpu, hsave->save.rip);
> -	svm->vmcb->save.dr7 = 0;
> -	svm->vmcb->save.cpl = 0;
> -	svm->vmcb->control.exit_int_info = 0;
> -
> -	mark_all_dirty(svm->vmcb);
> -
> -	kvm_vcpu_unmap(&svm->vcpu, &map, true);
> -
> -	nested_svm_uninit_mmu_context(&svm->vcpu);
> -	kvm_mmu_reset_context(&svm->vcpu);
> -	kvm_mmu_load(&svm->vcpu);
> -
> -	/*
> -	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
> -	 * doesn't end up in L1.
> -	 */
> -	svm->vcpu.arch.nmi_injected = false;
> -	kvm_clear_exception_queue(&svm->vcpu);
> -	kvm_clear_interrupt_queue(&svm->vcpu);
> -
> -	return 0;
> -}
> -
> -static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
> -{
> -	/*
> -	 * This function merges the msr permission bitmaps of kvm and the
> -	 * nested vmcb. It is optimized in that it only merges the parts where
> -	 * the kvm msr permission bitmap may contain zero bits
> -	 */
> -	int i;
> -
> -	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
> -		return true;
> -
> -	for (i = 0; i < MSRPM_OFFSETS; i++) {
> -		u32 value, p;
> -		u64 offset;
> -
> -		if (msrpm_offsets[i] == 0xffffffff)
> -			break;
> -
> -		p      = msrpm_offsets[i];
> -		offset = svm->nested.vmcb_msrpm + (p * 4);
> -
> -		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4))
> -			return false;
> -
> -		svm->nested.msrpm[p] = svm->msrpm[p] | value;
> -	}
> -
> -	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm));
> -
> -	return true;
> -}
> -
> -static bool nested_vmcb_checks(struct vmcb *vmcb)
> -{
> -	if ((vmcb->save.efer & EFER_SVME) == 0)
> -		return false;
> -
> -	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
> -		return false;
> -
> -	if (vmcb->control.asid == 0)
> -		return false;
> -
> -	if ((vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
> -	    !npt_enabled)
> -		return false;
> -
> -	return true;
> -}
> -
> -static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
> -				 struct vmcb *nested_vmcb, struct kvm_host_map *map)
> -{
> -	bool evaluate_pending_interrupts =
> -		is_intercept(svm, INTERCEPT_VINTR) ||
> -		is_intercept(svm, INTERCEPT_IRET);
> -
> -	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
> -		svm->vcpu.arch.hflags |= HF_HIF_MASK;
> -	else
> -		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
> -
> -	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE) {
> -		svm->nested.nested_cr3 = nested_vmcb->control.nested_cr3;
> -		nested_svm_init_mmu_context(&svm->vcpu);
> -	}
> -
> -	/* Load the nested guest state */
> -	svm->vmcb->save.es = nested_vmcb->save.es;
> -	svm->vmcb->save.cs = nested_vmcb->save.cs;
> -	svm->vmcb->save.ss = nested_vmcb->save.ss;
> -	svm->vmcb->save.ds = nested_vmcb->save.ds;
> -	svm->vmcb->save.gdtr = nested_vmcb->save.gdtr;
> -	svm->vmcb->save.idtr = nested_vmcb->save.idtr;
> -	kvm_set_rflags(&svm->vcpu, nested_vmcb->save.rflags);
> -	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
> -	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
> -	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
> -	if (npt_enabled) {
> -		svm->vmcb->save.cr3 = nested_vmcb->save.cr3;
> -		svm->vcpu.arch.cr3 = nested_vmcb->save.cr3;
> -	} else
> -		(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
> -
> -	/* Guest paging mode is active - reset mmu */
> -	kvm_mmu_reset_context(&svm->vcpu);
> -
> -	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
> -	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
> -	kvm_rsp_write(&svm->vcpu, nested_vmcb->save.rsp);
> -	kvm_rip_write(&svm->vcpu, nested_vmcb->save.rip);
> -
> -	/* In case we don't even reach vcpu_run, the fields are not updated */
> -	svm->vmcb->save.rax = nested_vmcb->save.rax;
> -	svm->vmcb->save.rsp = nested_vmcb->save.rsp;
> -	svm->vmcb->save.rip = nested_vmcb->save.rip;
> -	svm->vmcb->save.dr7 = nested_vmcb->save.dr7;
> -	svm->vmcb->save.dr6 = nested_vmcb->save.dr6;
> -	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
> -
> -	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa & ~0x0fffULL;
> -	svm->nested.vmcb_iopm  = nested_vmcb->control.iopm_base_pa  & ~0x0fffULL;
> -
> -	/* cache intercepts */
> -	svm->nested.intercept_cr         = nested_vmcb->control.intercept_cr;
> -	svm->nested.intercept_dr         = nested_vmcb->control.intercept_dr;
> -	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
> -	svm->nested.intercept            = nested_vmcb->control.intercept;
> -
> -	svm_flush_tlb(&svm->vcpu, true);
> -	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
> -	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
> -		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
> -	else
> -		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
> -
> -	svm->vcpu.arch.tsc_offset += nested_vmcb->control.tsc_offset;
> -	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
> -
> -	svm->vmcb->control.virt_ext = nested_vmcb->control.virt_ext;
> -	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
> -	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
> -	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
> -	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
> -
> -	svm->vmcb->control.pause_filter_count =
> -		nested_vmcb->control.pause_filter_count;
> -	svm->vmcb->control.pause_filter_thresh =
> -		nested_vmcb->control.pause_filter_thresh;
> -
> -	kvm_vcpu_unmap(&svm->vcpu, map, true);
> -
> -	/* Enter Guest-Mode */
> -	enter_guest_mode(&svm->vcpu);
> -
> -	/*
> -	 * Merge guest and host intercepts - must be called  with vcpu in
> -	 * guest-mode to take affect here
> -	 */
> -	recalc_intercepts(svm);
> -
> -	svm->nested.vmcb = vmcb_gpa;
> -
> -	/*
> -	 * If L1 had a pending IRQ/NMI before executing VMRUN,
> -	 * which wasn't delivered because it was disallowed (e.g.
> -	 * interrupts disabled), L0 needs to evaluate if this pending
> -	 * event should cause an exit from L2 to L1 or be delivered
> -	 * directly to L2.
> -	 *
> -	 * Usually this would be handled by the processor noticing an
> -	 * IRQ/NMI window request.  However, VMRUN can unblock interrupts
> -	 * by implicitly setting GIF, so force L0 to perform pending event
> -	 * evaluation by requesting a KVM_REQ_EVENT.
> -	 */
> -	enable_gif(svm);
> -	if (unlikely(evaluate_pending_interrupts))
> -		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> -
> -	mark_all_dirty(svm->vmcb);
> -}
> -
> -static int nested_svm_vmrun(struct vcpu_svm *svm)
> -{
> -	int ret;
> -	struct vmcb *nested_vmcb;
> -	struct vmcb *hsave = svm->nested.hsave;
> -	struct vmcb *vmcb = svm->vmcb;
> -	struct kvm_host_map map;
> -	u64 vmcb_gpa;
> -
> -	vmcb_gpa = svm->vmcb->save.rax;
> -
> -	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
> -	if (ret == -EINVAL) {
> -		kvm_inject_gp(&svm->vcpu, 0);
> -		return 1;
> -	} else if (ret) {
> -		return kvm_skip_emulated_instruction(&svm->vcpu);
> -	}
> -
> -	ret = kvm_skip_emulated_instruction(&svm->vcpu);
> -
> -	nested_vmcb = map.hva;
> -
> -	if (!nested_vmcb_checks(nested_vmcb)) {
> -		nested_vmcb->control.exit_code    = SVM_EXIT_ERR;
> -		nested_vmcb->control.exit_code_hi = 0;
> -		nested_vmcb->control.exit_info_1  = 0;
> -		nested_vmcb->control.exit_info_2  = 0;
> -
> -		kvm_vcpu_unmap(&svm->vcpu, &map, true);
> -
> -		return ret;
> -	}
> -
> -	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
> -			       nested_vmcb->save.rip,
> -			       nested_vmcb->control.int_ctl,
> -			       nested_vmcb->control.event_inj,
> -			       nested_vmcb->control.nested_ctl);
> -
> -	trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr & 0xffff,
> -				    nested_vmcb->control.intercept_cr >> 16,
> -				    nested_vmcb->control.intercept_exceptions,
> -				    nested_vmcb->control.intercept);
> -
> -	/* Clear internal status */
> -	kvm_clear_exception_queue(&svm->vcpu);
> -	kvm_clear_interrupt_queue(&svm->vcpu);
> -
> -	/*
> -	 * Save the old vmcb, so we don't need to pick what we save, but can
> -	 * restore everything when a VMEXIT occurs
> -	 */
> -	hsave->save.es     = vmcb->save.es;
> -	hsave->save.cs     = vmcb->save.cs;
> -	hsave->save.ss     = vmcb->save.ss;
> -	hsave->save.ds     = vmcb->save.ds;
> -	hsave->save.gdtr   = vmcb->save.gdtr;
> -	hsave->save.idtr   = vmcb->save.idtr;
> -	hsave->save.efer   = svm->vcpu.arch.efer;
> -	hsave->save.cr0    = kvm_read_cr0(&svm->vcpu);
> -	hsave->save.cr4    = svm->vcpu.arch.cr4;
> -	hsave->save.rflags = kvm_get_rflags(&svm->vcpu);
> -	hsave->save.rip    = kvm_rip_read(&svm->vcpu);
> -	hsave->save.rsp    = vmcb->save.rsp;
> -	hsave->save.rax    = vmcb->save.rax;
> -	if (npt_enabled)
> -		hsave->save.cr3    = vmcb->save.cr3;
> -	else
> -		hsave->save.cr3    = kvm_read_cr3(&svm->vcpu);
> -
> -	copy_vmcb_control_area(hsave, vmcb);
> -
> -	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb, &map);
> -
> -	if (!nested_svm_vmrun_msrpm(svm)) {
> -		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> -		svm->vmcb->control.exit_code_hi = 0;
> -		svm->vmcb->control.exit_info_1  = 0;
> -		svm->vmcb->control.exit_info_2  = 0;
> -
> -		nested_svm_vmexit(svm);
> -	}
> -
> -	return ret;
> -}
> -
> -static void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
> -{
> -	to_vmcb->save.fs = from_vmcb->save.fs;
> -	to_vmcb->save.gs = from_vmcb->save.gs;
> -	to_vmcb->save.tr = from_vmcb->save.tr;
> -	to_vmcb->save.ldtr = from_vmcb->save.ldtr;
> -	to_vmcb->save.kernel_gs_base = from_vmcb->save.kernel_gs_base;
> -	to_vmcb->save.star = from_vmcb->save.star;
> -	to_vmcb->save.lstar = from_vmcb->save.lstar;
> -	to_vmcb->save.cstar = from_vmcb->save.cstar;
> -	to_vmcb->save.sfmask = from_vmcb->save.sfmask;
> -	to_vmcb->save.sysenter_cs = from_vmcb->save.sysenter_cs;
> -	to_vmcb->save.sysenter_esp = from_vmcb->save.sysenter_esp;
> -	to_vmcb->save.sysenter_eip = from_vmcb->save.sysenter_eip;
> -}
> -
>  static int vmload_interception(struct vcpu_svm *svm)
>  {
>  	struct vmcb *nested_vmcb;
> @@ -5183,11 +4055,6 @@ static void svm_set_irq(struct kvm_vcpu *vcpu)
>  		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
>  }
>  
> -static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)
> -{
> -	return is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK);
> -}
> -
>  static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -5629,7 +4496,7 @@ static int svm_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
>  	return 0;
>  }
>  
> -static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
> +void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> new file mode 100644
> index 000000000000..f4c446d7a31e
> --- /dev/null
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -0,0 +1,381 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Kernel-based Virtual Machine driver for Linux
> + *
> + * AMD SVM support
> + *
> + * Copyright (C) 2006 Qumranet, Inc.
> + * Copyright 2010 Red Hat, Inc. and/or its affiliates.
> + *
> + * Authors:
> + *   Yaniv Kamay  <yaniv@qumranet.com>
> + *   Avi Kivity   <avi@qumranet.com>
> + */
> +
> +#ifndef __SVM_SVM_H
> +#define __SVM_SVM_H
> +
> +#include <linux/kvm_types.h>
> +#include <linux/kvm_host.h>
> +
> +#include <asm/svm.h>
> +
> +static const u32 host_save_user_msrs[] = {
> +#ifdef CONFIG_X86_64
> +	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
> +	MSR_FS_BASE,
> +#endif
> +	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
> +	MSR_TSC_AUX,
> +};
> +
> +#define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
> +
> +#define MSRPM_OFFSETS	16
> +extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
> +extern bool npt_enabled;
> +
> +enum {
> +	VMCB_INTERCEPTS, /* Intercept vectors, TSC offset,
> +			    pause filter count */
> +	VMCB_PERM_MAP,   /* IOPM Base and MSRPM Base */
> +	VMCB_ASID,	 /* ASID */
> +	VMCB_INTR,	 /* int_ctl, int_vector */
> +	VMCB_NPT,        /* npt_en, nCR3, gPAT */
> +	VMCB_CR,	 /* CR0, CR3, CR4, EFER */
> +	VMCB_DR,         /* DR6, DR7 */
> +	VMCB_DT,         /* GDT, IDT */
> +	VMCB_SEG,        /* CS, DS, SS, ES, CPL */
> +	VMCB_CR2,        /* CR2 only */
> +	VMCB_LBR,        /* DBGCTL, BR_FROM, BR_TO, LAST_EX_FROM, LAST_EX_TO */
> +	VMCB_AVIC,       /* AVIC APIC_BAR, AVIC APIC_BACKING_PAGE,
> +			  * AVIC PHYSICAL_TABLE pointer,
> +			  * AVIC LOGICAL_TABLE pointer
> +			  */
> +	VMCB_DIRTY_MAX,
> +};
> +
> +/* TPR and CR2 are always written before VMRUN */
> +#define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
> +
> +struct kvm_sev_info {
> +	bool active;		/* SEV enabled guest */
> +	unsigned int asid;	/* ASID used for this guest */
> +	unsigned int handle;	/* SEV firmware handle */
> +	int fd;			/* SEV device fd */
> +	unsigned long pages_locked; /* Number of pages locked */
> +	struct list_head regions_list;  /* List of registered regions */
> +};
> +
> +struct kvm_svm {
> +	struct kvm kvm;
> +
> +	/* Struct members for AVIC */
> +	u32 avic_vm_id;
> +	struct page *avic_logical_id_table_page;
> +	struct page *avic_physical_id_table_page;
> +	struct hlist_node hnode;
> +
> +	struct kvm_sev_info sev_info;
> +};
> +
> +struct kvm_vcpu;
> +
> +struct nested_state {

Not sure if it's worth doing in this patch (or even patch series) but
I'd suggest we name this e.g. "struct svm_nested_state" as this is not
local to svm.c anymore.

> +	struct vmcb *hsave;
> +	u64 hsave_msr;
> +	u64 vm_cr_msr;
> +	u64 vmcb;
> +
> +	/* These are the merged vectors */
> +	u32 *msrpm;
> +
> +	/* gpa pointers to the real vectors */
> +	u64 vmcb_msrpm;
> +	u64 vmcb_iopm;
> +
> +	/* A VMEXIT is required but not yet emulated */
> +	bool exit_required;
> +
> +	/* cache for intercepts of the guest */
> +	u32 intercept_cr;
> +	u32 intercept_dr;
> +	u32 intercept_exceptions;
> +	u64 intercept;
> +
> +	/* Nested Paging related state */
> +	u64 nested_cr3;
> +};
> +
> +struct vcpu_svm {
> +	struct kvm_vcpu vcpu;
> +	struct vmcb *vmcb;
> +	unsigned long vmcb_pa;
> +	struct svm_cpu_data *svm_data;
> +	uint64_t asid_generation;
> +	uint64_t sysenter_esp;
> +	uint64_t sysenter_eip;
> +	uint64_t tsc_aux;
> +
> +	u64 msr_decfg;
> +
> +	u64 next_rip;
> +
> +	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
> +	struct {
> +		u16 fs;
> +		u16 gs;
> +		u16 ldt;
> +		u64 gs_base;
> +	} host;
> +
> +	u64 spec_ctrl;
> +	/*
> +	 * Contains guest-controlled bits of VIRT_SPEC_CTRL, which will be
> +	 * translated into the appropriate L2_CFG bits on the host to
> +	 * perform speculative control.
> +	 */
> +	u64 virt_spec_ctrl;
> +
> +	u32 *msrpm;
> +
> +	ulong nmi_iret_rip;
> +
> +	struct nested_state nested;
> +
> +	bool nmi_singlestep;
> +	u64 nmi_singlestep_guest_rflags;
> +
> +	unsigned int3_injected;
> +	unsigned long int3_rip;
> +
> +	/* cached guest cpuid flags for faster access */
> +	bool nrips_enabled	: 1;
> +
> +	u32 ldr_reg;
> +	u32 dfr_reg;
> +	struct page *avic_backing_page;
> +	u64 *avic_physical_id_cache;
> +	bool avic_is_running;
> +
> +	/*
> +	 * Per-vcpu list of struct amd_svm_iommu_ir:
> +	 * This is used mainly to store interrupt remapping information used
> +	 * when update the vcpu affinity. This avoids the need to scan for
> +	 * IRTE and try to match ga_tag in the IOMMU driver.
> +	 */
> +	struct list_head ir_list;
> +	spinlock_t ir_list_lock;
> +
> +	/* which host CPU was used for running this vcpu */
> +	unsigned int last_cpu;
> +};
> +
> +void recalc_intercepts(struct vcpu_svm *svm);
> +
> +static inline void mark_all_dirty(struct vmcb *vmcb)
> +{
> +	vmcb->control.clean = 0;
> +}
> +
> +static inline void mark_all_clean(struct vmcb *vmcb)
> +{
> +	vmcb->control.clean = ((1 << VMCB_DIRTY_MAX) - 1)
> +			       & ~VMCB_ALWAYS_DIRTY_MASK;
> +}
> +
> +static inline void mark_dirty(struct vmcb *vmcb, int bit)
> +{
> +	vmcb->control.clean &= ~(1 << bit);
> +}

... same goes to the three functions above (suggestion: add 'vmcb_'
prefix to all of them).

> +
> +static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
> +{
> +	return container_of(vcpu, struct vcpu_svm, vcpu);
> +}
> +
> +static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
> +{
> +	if (is_guest_mode(&svm->vcpu))
> +		return svm->nested.hsave;
> +	else
> +		return svm->vmcb;
> +}
> +
> +static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	vmcb->control.intercept_cr |= (1U << bit);
> +
> +	recalc_intercepts(svm);
> +}
> +
> +static inline void clr_cr_intercept(struct vcpu_svm *svm, int bit)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	vmcb->control.intercept_cr &= ~(1U << bit);
> +
> +	recalc_intercepts(svm);
> +}
> +
> +static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	return vmcb->control.intercept_cr & (1U << bit);
> +}
> +
> +static inline void set_dr_intercepts(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	vmcb->control.intercept_dr = (1 << INTERCEPT_DR0_READ)
> +		| (1 << INTERCEPT_DR1_READ)
> +		| (1 << INTERCEPT_DR2_READ)
> +		| (1 << INTERCEPT_DR3_READ)
> +		| (1 << INTERCEPT_DR4_READ)
> +		| (1 << INTERCEPT_DR5_READ)
> +		| (1 << INTERCEPT_DR6_READ)
> +		| (1 << INTERCEPT_DR7_READ)
> +		| (1 << INTERCEPT_DR0_WRITE)
> +		| (1 << INTERCEPT_DR1_WRITE)
> +		| (1 << INTERCEPT_DR2_WRITE)
> +		| (1 << INTERCEPT_DR3_WRITE)
> +		| (1 << INTERCEPT_DR4_WRITE)
> +		| (1 << INTERCEPT_DR5_WRITE)
> +		| (1 << INTERCEPT_DR6_WRITE)
> +		| (1 << INTERCEPT_DR7_WRITE);
> +
> +	recalc_intercepts(svm);
> +}
> +
> +static inline void clr_dr_intercepts(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	vmcb->control.intercept_dr = 0;
> +
> +	recalc_intercepts(svm);
> +}
> +
> +static inline void set_exception_intercept(struct vcpu_svm *svm, int bit)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	vmcb->control.intercept_exceptions |= (1U << bit);
> +
> +	recalc_intercepts(svm);
> +}
> +
> +static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	vmcb->control.intercept_exceptions &= ~(1U << bit);
> +
> +	recalc_intercepts(svm);
> +}
> +
> +static inline void set_intercept(struct vcpu_svm *svm, int bit)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	vmcb->control.intercept |= (1ULL << bit);
> +
> +	recalc_intercepts(svm);
> +}
> +
> +static inline void clr_intercept(struct vcpu_svm *svm, int bit)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	vmcb->control.intercept &= ~(1ULL << bit);
> +
> +	recalc_intercepts(svm);
> +}
> +
> +static inline bool is_intercept(struct vcpu_svm *svm, int bit)
> +{
> +	return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
> +}

... and these three (suggestion: add 'svm_' prefix)

> +
> +static inline bool vgif_enabled(struct vcpu_svm *svm)
> +{
> +	return !!(svm->vmcb->control.int_ctl & V_GIF_ENABLE_MASK);
> +}
> +
> +static inline void enable_gif(struct vcpu_svm *svm)
> +{
> +	if (vgif_enabled(svm))
> +		svm->vmcb->control.int_ctl |= V_GIF_MASK;
> +	else
> +		svm->vcpu.arch.hflags |= HF_GIF_MASK;
> +}
> +
> +static inline void disable_gif(struct vcpu_svm *svm)
> +{
> +	if (vgif_enabled(svm))
> +		svm->vmcb->control.int_ctl &= ~V_GIF_MASK;
> +	else
> +		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
> +}
> +
> +static inline bool gif_set(struct vcpu_svm *svm)
> +{
> +	if (vgif_enabled(svm))
> +		return !!(svm->vmcb->control.int_ctl & V_GIF_MASK);
> +	else
> +		return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
> +}
> +
> +/* svm.c */
> +#define MSR_INVALID			0xffffffffU
> +
> +u32 svm_msrpm_offset(u32 msr);
> +void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
> +void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
> +int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
> +void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
> +void disable_nmi_singlestep(struct vcpu_svm *svm);
> +
> +/* nested.c */
> +
> +#define NESTED_EXIT_HOST	0	/* Exit handled on host level */
> +#define NESTED_EXIT_DONE	1	/* Exit caused nested vmexit  */
> +#define NESTED_EXIT_CONTINUE	2	/* Further checks needed      */
> +
> +/* This function returns true if it is save to enable the nmi window */
> +static inline bool nested_svm_nmi(struct vcpu_svm *svm)
> +{
> +	if (!is_guest_mode(&svm->vcpu))
> +		return true;
> +
> +	if (!(svm->nested.intercept & (1ULL << INTERCEPT_NMI)))
> +		return true;
> +
> +	svm->vmcb->control.exit_code = SVM_EXIT_NMI;
> +	svm->nested.exit_required = true;
> +
> +	return false;
> +}
> +
> +static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)

svm_nested_virtualize_tpr() -> nested_svm_virtualize_tpr() to match the rest.

> +{
> +	return is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK);
> +}
> +
> +void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
> +			  struct vmcb *nested_vmcb, struct kvm_host_map *map);
> +int nested_svm_vmrun(struct vcpu_svm *svm);
> +void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
> +int nested_svm_vmexit(struct vcpu_svm *svm);
> +int nested_svm_exit_handled(struct vcpu_svm *svm);
> +int nested_svm_check_permissions(struct vcpu_svm *svm);
> +int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
> +			       bool has_error_code, u32 error_code);
> +int svm_check_nested_events(struct kvm_vcpu *vcpu);
> +int nested_svm_exit_special(struct vcpu_svm *svm);
> +
> +#endif

-- 
Vitaly

