Return-Path: <kvm+bounces-33648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DB0F9EFB48
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 19:41:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4DA528B405
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 18:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793AC223E89;
	Thu, 12 Dec 2024 18:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EnIveoeX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF99A223328
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 18:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734028860; cv=none; b=UcOUlhPX+hecIEVD0NyqR2Ay9eaeO8nTc38uljuy74kWOEAX55XW6kSu2h2pw83IdBaSbs3MrBTpG3Im3HbBzJg1JzaGwtTuRJDyd5+qaUWQX3kzqzc2OgCXGDSTefA8GsPB3nG9DK/20BkSHB0OO0YZ+KsJ6gBpHyIJP0hIT2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734028860; c=relaxed/simple;
	bh=USnHUaF1NtdPtPvb/P+1woPyLED55Mfx4VR60pgtZNg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fAQEriJpByOLBSpro+D5bPEAo9UVPm268Ds7/29jvmvsW8cG/D1w/3FrHm1SZf1eiwc4hiCbYX1D07+l62XrZRWPoxlRU+R9qfq1DyK43gasqlK6krhMBXt9c3lqDJ7PbiovrN5xX3snfInRwQw56Y9ehZrsBBrpiEewVex77Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EnIveoeX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e38b0cfso861225a91.0
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 10:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734028857; x=1734633657; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aItRJJFzt86YSJadSI9N+BPtJOajwLlnUzfB8MOC4zo=;
        b=EnIveoeXcvGQyPH4AwbxJWISUdtcUw+o26Mpw5n3dxz+x9AG30TTivbr7QRJWp08ok
         BqLN2exbC1ONSa8/gO3IdMnm4ZxI1myo6bZrnE2hbAHVg2/tXSPQBHJc0xb4altVf+da
         JboRtJzYG0CYvmhwJU773L7XfMY1kpq7kzLaygs651mvLh4vhmXskO3rJTmCiGS0pTK7
         BsAsZl2dm0YDymAEujRHWMPuWjkuV9N3NfAPiR2G2Ux6MFlvcGeVr7lM3LLdaluIgKax
         4eg3iCdnsifzAFc43RpiAKwOSYYaPG5TbgjpYcwjuKJkYMTNcDIFyjvfhvN4KG9Mv1bd
         jN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734028857; x=1734633657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aItRJJFzt86YSJadSI9N+BPtJOajwLlnUzfB8MOC4zo=;
        b=lC9My+AQ0595q0r87RXE0n8F8S3OcisHl/bkxJmKoRTk0Pfj5kKC9rDzoHyGrOhKub
         3TGsVQuP4+/6DQRnSiNNwxWGxuMsUiDW5eEkl0ohLnIUbGIytxT1GIno48b4Ej8fpYno
         B7iNWlfNvJQX2dXQVMIdr47l8R8qB/SHHlQ8bAY/RtGmMlMxYq2Y0cOxwpvOlMjW84Ou
         Pghk8mKEeuFFkTq2Kbg2gLmLbK/InEb7qDivIboVY/HxJf10eQw1NbeFxyDL2YmZrZVr
         EYB5IJi4ITUG5DhNqiw9uCJylPUdmIPGpJCI6YE+9tIUL2fRkzl0fD3hNfwsPCsZQRSs
         mE1A==
X-Forwarded-Encrypted: i=1; AJvYcCXNV563pjBFGR4dhh30qxiw1dGFccBxSjS0E6q4LyMSYp+FraDtjD4ZsjaU5CCYeWWYwBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS6MD+C0XCVJYBtviuhx1c1NzkHvAvrmKCU7Wa6F9z2VBItZgS
	jvgBtG5kDL2ExQxD6uQj9KcsUxrpODe21WgQo9otyGbmHyUq49jvXA6nOMy2VAdtJcoRGRuD4iD
	Rbg==
X-Google-Smtp-Source: AGHT+IEbfLOjk2DN1lImARv8oodjzBjodr/wGe6M0arvWMNJKutv8OXSnYzoGeGsuuPoNk8fKQZMGc4Cz4A=
X-Received: from pjbsd4.prod.google.com ([2002:a17:90b:5144:b0:2ee:4a90:3d06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b41:b0:2ee:f653:9f8e
 with SMTP id 98e67ed59e1d1-2f1280586admr12131374a91.35.1734028857245; Thu, 12
 Dec 2024 10:40:57 -0800 (PST)
Date: Thu, 12 Dec 2024 10:40:55 -0800
In-Reply-To: <0751a7b8-f8d3-4e27-b710-0a2bd7d06f7e@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128004344.4072099-1-seanjc@google.com> <20241128004344.4072099-7-seanjc@google.com>
 <90577aad-552a-4cf8-a4a3-a4efcf997455@intel.com> <6423ec9d-46a2-43a3-ae9a-8e074337cd84@redhat.com>
 <Z1ier7QAy9qj7x4V@google.com> <0751a7b8-f8d3-4e27-b710-0a2bd7d06f7e@intel.com>
Message-ID: <Z1suNzg2Or743a7e@google.com>
Subject: Re: [PATCH v4 6/6] KVM: x86: Refactor __kvm_emulate_hypercall() into
 a macro
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: multipart/mixed; charset="UTF-8"; boundary="1yoo3KhbUOvehEvV"


--1yoo3KhbUOvehEvV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 12, 2024, Adrian Hunter wrote:
> On 10/12/24 22:03, Sean Christopherson wrote:
> > On Tue, Dec 10, 2024, Paolo Bonzini wrote:
> >> On 11/28/24 09:38, Adrian Hunter wrote:
> >>>
> >>> For TDX, there is an RFC relating to using descriptively
> >>> named parameters instead of register names for tdh_vp_enter():
> >>>
> >>> 	https://lore.kernel.org/all/fa817f29-e3ba-4c54-8600-e28cf6ab1953@intel.com/
> >>>
> >>> Please do give some feedback on that approach.  Note we
> >>> need both KVM and x86 maintainer approval for SEAMCALL
> >>> wrappers like tdh_vp_enter().
> >>>
> >>> As proposed, that ends up with putting the values back into
> >>> vcpu->arch.regs[] for __kvm_emulate_hypercall() which is not
> >>> pretty:
> >>
> >> If needed we can revert this patch, it's not a big problem.
> > 
> > I don't care terribly about the SEAMCALL interfaces.  I have opinions on what
> > would I think would be ideal, but I can live with whatever.
> > 
> > What I do deeply care about though is consistency within KVM, across vendors and
> > VM flavors.  And that means that guest registers absolutely need to be captured in
> > vcpu->arch.regs[].
> 
> In general, TDX host VMM does not know what guest register values are.
> 
> This case, where some GPRs are passed to the host VMM via arguments of the
> TDG.VP.VMCALL TDCALL, is really just a side effect of the choice of argument
> passing rather than any attempt to share guest registers with the host VMM.
> 
> It could be regarded as more consistent to never use vcpu->arch.regs[] for
> confidential guests.

SEV-ES+ marshalls data to/from the GHCB to KVM's register array, because the GHCB
spec was intentionally crafted to allow hypervisors to reuse exit-handling code.
Granted, that's only for R{A,B,C,D}X and RSI, but the other GPRs should never be
used and thus their data is irrelevant.

Which applies to TDX as well.  For regs[], it's really only TDVMCALL that I care
about, i.e. cases where GPRs hold guest values, versus things like EXIT_QUALIFICATION
where the GPR is simply TDX's way of communicating information to the hypervisor.

Argh.  The reason I care about putting vCPU state into regs[] is because it helps
share code between vendors.  Looking at kvm-coco-queue, TDX support wandered in
the opposite direction.  E.g. TDX rolls its own RDMSR, WRMSR, CPUID, and HYPERCALL
implementations, which is quite frustrating.  Ditto for things like EXIT_REASON,
EXIT_QUALIFICATION, EXIT_INTR_INFO, etc.

For EXIT_REASON in particular, I think maintaining the guest-requested exit reason
(via TDMVCALL) in a separate field is a mistake.  Readers shouldn't have to care
that a HLT exit technically was requested via TDVMCALL.  If KVM instead immediately
morphs the requested exit reason to KVM's tracked exit_reason, then there's no need
to deal with the TDVMCALL layer in flows that don't care.  The only danger is a
collision with a EXIT_REASON_EPT_MISCONFIG from the TDX module, but that's easy
enough to handle.
 
And even where TDX and VMX have shared some code, IMO it doesn't go far enough.
E.g. having vcpu_tdx and vcpu_vmx open code their own version of the posted
interrupt fields, just to avoid minimal churn in the VMX code, is beyond gross.

Even concepts like guest_state_loaded are unnecessarily different for TDX.  Yes,
I get that that host state doesn't need to be reloaded if KVM doesn't actually
enter the guest.  But holy moly, we're talking about avoid _one_ WRMSR in an
extremely rare path (late abort of entry), at the cost of making TDX frustratingly
different from VMX.

Making TDX look more like everything else isn't just about code sharing.  It's also
about providing a familiar setting so that readers who know almost nothing about
TDX can find their way around without having to effectively learn an entirely new
"architecture" *and* code base.

Hacking around, I think the attached half-baked diff will provide a middle ground
for the regs[] vs. struct/union issue.  The basic gist is to essentially treat
TDX's register ABI as a faster version of VMREAD/VMWRITE, e.g. marshall state
to/from the appropriate x86 registers as needed.  That way, regs[] holds the correct
state and so TDX can reuse much of KVM's existing code verbatim, while allowing
the kernel's VP_ENTER API to evolve independently.

--1yoo3KhbUOvehEvV
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-Make-TDX-look-more-like-VMX.patch"

From 0319082fc23089f516618e193d94da18c837e35a Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 12 Dec 2024 10:22:25 -0800
Subject: [PATCH] Make TDX look more like VMX

---
 arch/x86/kvm/vmx/common.h      |  64 +++++-
 arch/x86/kvm/vmx/nested.c      |   7 +-
 arch/x86/kvm/vmx/posted_intr.h |  11 -
 arch/x86/kvm/vmx/tdx.c         | 375 +++++++++++----------------------
 arch/x86/kvm/vmx/tdx.h         |  11 +-
 arch/x86/kvm/vmx/vmx.c         |  26 +--
 arch/x86/kvm/vmx/vmx.h         |  42 +---
 7 files changed, 201 insertions(+), 335 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 809ced4c6cd8..f1679e53cb4b 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -12,6 +12,61 @@
 #include "vmcs.h"
 #include "x86.h"
 
+struct vcpu_vt {
+	/* Posted interrupt descriptor */
+	struct pi_desc pi_desc;
+
+	/* Used if this vCPU is waiting for PI notification wakeup. */
+	struct list_head pi_wakeup_list;
+
+	union vmx_exit_reason exit_reason;
+
+	unsigned long	exit_qualification;
+	u64		ext_qualification;
+	gpa_t		exit_gpa;
+	u32		exit_intr_info;
+	u32		idt_vectoring_info;
+
+
+	/*
+	 * If true, guest state has been loaded into hardware, and host state
+	 * saved into vcpu_{vt,vmx,tdx}.  If false, host state is loaded into
+	 * hardware.
+	 */
+	bool		guest_state_loaded;
+
+#ifdef CONFIG_X86_64
+	u64		msr_host_kernel_gs_base;
+#endif
+};
+
+static __always_inline unsigned long vmx_get_exit_reason(struct kvm_vcpu *vcpu)
+{
+	return to_vt(vcpu)->exit_reason;
+}
+
+static __always_inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vt *vt = to_vcpu_vt(vcpu);
+
+	if (!kvm_register_test_and_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1) &&
+	    !WARN_ON_ONCE(is_td_vcpu(vcpu))))
+		vt->exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+
+	return vt->exit_qualification;
+}
+
+static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vt *vt = to_vcpu_vt(vcpu);
+
+	if (!kvm_register_test_and_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2) &&
+	    !WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		vt->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+
+	return vt->exit_intr_info;
+}
+
 extern unsigned long vmx_host_idt_base;
 void vmx_do_interrupt_irqoff(unsigned long entry);
 void vmx_do_nmi_irqoff(void);
@@ -36,9 +91,10 @@ static inline void vmx_handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 }
 
-static inline void vmx_handle_exception_irqoff(struct kvm_vcpu *vcpu,
-					       u32 intr_info)
+static inline void vmx_handle_exception_irqoff(struct kvm_vcpu *vcpu)
 {
+	u32 intr_info = vmx_get_intr_info(vcpu);
+
 	/* if exit due to PF check for async PF */
 	if (is_page_fault(intr_info))
 		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
@@ -50,9 +106,9 @@ static inline void vmx_handle_exception_irqoff(struct kvm_vcpu *vcpu,
 		kvm_machine_check();
 }
 
-static inline void vmx_handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
-							u32 intr_info)
+static inline void vmx_handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
+	u32 intr_info = vmx_get_intr_info(vcpu);
 	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
 
 	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index aa78b6f38dfe..056b6ff1503e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -410,6 +410,7 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 	unsigned long exit_qualification;
 	u32 vm_exit_reason;
 
@@ -425,7 +426,7 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 		 * tables also changed, but KVM should not treat EPT Misconfig
 		 * VM-Exits as writes.
 		 */
-		WARN_ON_ONCE(vmx->exit_reason.basic != EXIT_REASON_EPT_VIOLATION);
+		WARN_ON_ONCE(vt->exit_reason.basic != EXIT_REASON_EPT_VIOLATION);
 
 		/*
 		 * PML Full and EPT Violation VM-Exits both use bit 12 to report
@@ -6099,7 +6100,7 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	 * nested VM-Exit.  Pass the original exit reason, i.e. don't hardcode
 	 * EXIT_REASON_VMFUNC as the exit reason.
 	 */
-	nested_vmx_vmexit(vcpu, vmx->exit_reason.full,
+	nested_vmx_vmexit(vcpu, vmx_get_exit_reason(vcpu).full,
 			  vmx_get_intr_info(vcpu),
 			  vmx_get_exit_qual(vcpu));
 	return 1;
@@ -6544,7 +6545,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
 bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	union vmx_exit_reason exit_reason = vmx->exit_reason;
+	union vmx_exit_reason exit_reason = vmx_get_exit_reason(vcpu);
 	unsigned long exit_qual;
 	u32 exit_intr_info;
 
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 8b1dccfe4885..9ac4f6eafac5 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -5,17 +5,6 @@
 #include <linux/find.h>
 #include <asm/posted_intr.h>
 
-struct vcpu_pi {
-	struct kvm_vcpu	vcpu;
-
-	/* Posted interrupt descriptor */
-	struct pi_desc pi_desc;
-
-	/* Used if this vCPU is waiting for PI notification wakeup. */
-	struct list_head pi_wakeup_list;
-	/* Until here common layout between vcpu_vmx and vcpu_tdx. */
-};
-
 struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu);
 
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 69ef9c967fbf..7eff717c9d0d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -182,49 +182,6 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
 }
 
-static __always_inline union vmx_exit_reason tdexit_exit_reason(struct kvm_vcpu *vcpu)
-{
-	return (union vmx_exit_reason)(u32)(to_tdx(vcpu)->vp_enter_ret);
-}
-
-/*
- * There is no simple way to check some bit(s) to decide whether the return
- * value of TDH.VP.ENTER has a VMX exit reason or not.  E.g.,
- * TDX_NON_RECOVERABLE_TD_WRONG_APIC_MODE has exit reason but with error bit
- * (bit 63) set, TDX_NON_RECOVERABLE_TD_CORRUPTED_MD has no exit reason but with
- * error bit cleared.
- */
-static __always_inline bool tdx_has_exit_reason(struct kvm_vcpu *vcpu)
-{
-	u64 status = to_tdx(vcpu)->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK;
-
-	return status == TDX_SUCCESS || status == TDX_NON_RECOVERABLE_VCPU ||
-	       status == TDX_NON_RECOVERABLE_TD ||
-	       status == TDX_NON_RECOVERABLE_TD_NON_ACCESSIBLE ||
-	       status == TDX_NON_RECOVERABLE_TD_WRONG_APIC_MODE;
-}
-
-static __always_inline bool tdx_check_exit_reason(struct kvm_vcpu *vcpu, u16 reason)
-{
-	return tdx_has_exit_reason(vcpu) &&
-	       (u16)tdexit_exit_reason(vcpu).basic == reason;
-}
-
-static __always_inline unsigned long tdexit_exit_qual(struct kvm_vcpu *vcpu)
-{
-	return kvm_rcx_read(vcpu);
-}
-
-static __always_inline unsigned long tdexit_ext_exit_qual(struct kvm_vcpu *vcpu)
-{
-	return kvm_rdx_read(vcpu);
-}
-
-static __always_inline unsigned long tdexit_gpa(struct kvm_vcpu *vcpu)
-{
-	return kvm_r8_read(vcpu);
-}
-
 static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
 {
 	return kvm_r9_read(vcpu);
@@ -246,23 +203,15 @@ BUILD_TDVMCALL_ACCESSORS(a1, r13);
 BUILD_TDVMCALL_ACCESSORS(a2, r14);
 BUILD_TDVMCALL_ACCESSORS(a3, r15);
 
-static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
-{
-	return kvm_r10_read(vcpu);
-}
-static __always_inline unsigned long tdvmcall_leaf(struct kvm_vcpu *vcpu)
-{
-	return kvm_r11_read(vcpu);
-}
 static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
 						     long val)
 {
-	kvm_r10_write(vcpu, val);
+	??? = val;
 }
 static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
 						    unsigned long val)
 {
-	kvm_r11_write(vcpu, val);
+	??? = val;
 }
 
 static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
@@ -742,11 +691,8 @@ bool tdx_interrupt_allowed(struct kvm_vcpu *vcpu)
 	 * interrupt is always allowed unless TDX guest calls TDVMCALL with HLT,
 	 * which passes the interrupt blocked flag.
 	 */
-	if (!tdx_check_exit_reason(vcpu, EXIT_REASON_TDCALL) ||
-	    tdvmcall_exit_type(vcpu) || tdvmcall_leaf(vcpu) != EXIT_REASON_HLT)
-	    return true;
-
-	return !tdvmcall_a0_read(vcpu);
+	return vmx_get_exit_reason(vcpu).basic != EXIT_REASON_HLT ||
+	       <don't care where this resides>;
 }
 
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
@@ -768,31 +714,30 @@ bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
  */
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 
-	if (!tdx->host_state_need_save)
+	if (vt->guest_state_loaded)
 		return;
 
 	if (likely(is_64bit_mm(current->mm)))
-		tdx->msr_host_kernel_gs_base = current->thread.gsbase;
+		vt->msr_host_kernel_gs_base = current->thread.gsbase;
 	else
-		tdx->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
+		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
 
-	tdx->host_state_need_save = false;
+	vt->guest_state_loaded = true;
 }
 
 static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
-	tdx->host_state_need_save = true;
-	if (!tdx->host_state_need_restore)
+	if (!vt->guest_state_loaded)
 		return;
 
 	++vcpu->stat.host_state_reload;
 
-	wrmsrl(MSR_KERNEL_GS_BASE, tdx->msr_host_kernel_gs_base);
-	tdx->host_state_need_restore = false;
+	wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
+	vt->guest_state_loaded = false;
 }
 
 void tdx_vcpu_put(struct kvm_vcpu *vcpu)
@@ -897,57 +842,60 @@ static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
 		write_pkru(vcpu->arch.host_pkru);
 }
 
+static union vmx_exit_reason tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u32 exit_reason;
+
+	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
+	case TDX_SUCCESS:
+	case TDX_NON_RECOVERABLE_VCPU:
+	case TDX_NON_RECOVERABLE_TD;
+	case TDX_NON_RECOVERABLE_TD_NON_ACCESSIBLE:
+	case TDX_NON_RECOVERABLE_TD_WRONG_APIC_MODE:
+		break;
+	default:
+		return -1u;
+	}
+
+	exit_reason = tdx->vp_enter_ret;
+	switch (exit_reason)
+	case EXIT_REASON_TDCALL:
+		if (tdx->blah.tdvmcall_exit_type)
+			return EXIT_REASON_VMCALL;
+
+		if (tdx->blah.tdvmcall_leaf < 0x10000)
+			return tdx->blah.tdvmcall_leaf;
+		break;
+	case EXIT_REASON_EPT_MISCONFIG:
+		KVM_BUG_ON(1, vcpu->kvm);
+		return -1;
+	default:
+		break;	
+	}
+	return exit_reason;
+}
+
 static void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 	struct tdx_module_args args;
+	u64 status;
 
 	guest_state_enter_irqoff();
 
-	/*
-	 * TODO: optimization:
-	 * - Eliminate copy between args and vcpu->arch.regs.
-	 * - copyin/copyout registers only if (tdx->tdvmvall.regs_mask != 0)
-	 *   which means TDG.VP.VMCALL.
-	 */
-	args = (struct tdx_module_args) {
-		.rcx = tdx->tdvpr_pa,
-#define REG(reg, REG)	.reg = vcpu->arch.regs[VCPU_REGS_ ## REG]
-		REG(rdx, RDX),
-		REG(r8,  R8),
-		REG(r9,  R9),
-		REG(r10, R10),
-		REG(r11, R11),
-		REG(r12, R12),
-		REG(r13, R13),
-		REG(r14, R14),
-		REG(r15, R15),
-		REG(rbx, RBX),
-		REG(rdi, RDI),
-		REG(rsi, RSI),
-#undef REG
-	};
-
 	tdx->vp_enter_ret = tdh_vp_enter(tdx->tdvpr_pa, &args);
 
-#define REG(reg, REG)	vcpu->arch.regs[VCPU_REGS_ ## REG] = args.reg
-	REG(rcx, RCX);
-	REG(rdx, RDX);
-	REG(r8,  R8);
-	REG(r9,  R9);
-	REG(r10, R10);
-	REG(r11, R11);
-	REG(r12, R12);
-	REG(r13, R13);
-	REG(r14, R14);
-	REG(r15, R15);
-	REG(rbx, RBX);
-	REG(rdi, RDI);
-	REG(rsi, RSI);
-#undef REG
+	vt->exit_reason.full = tdx_to_vmx_exit_reason(vcpu);
 
-	if (tdx_check_exit_reason(vcpu, EXIT_REASON_EXCEPTION_NMI) &&
-	    is_nmi(tdexit_intr_info(vcpu)))
+	tdx->exit.qualification = args.rcx;
+	tdx->exit.extended_qualification = args.rdx;
+	tdx->exit.intr_info = args.r9;
+	tdx->exit.guest_physical_address = args.r8;
+
+	if (vt->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI) &&
+	    is_nmi(vmx_get_intr_info(vcpu)))
 		__vmx_handle_nmi(vcpu);
 
 	guest_state_exit_irqoff();
@@ -971,11 +919,12 @@ static fastpath_t tdx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct vcpu_vt *vt = to_tdx(vcpu);
 
 	/* TDX exit handle takes care of this error case. */
 	if (unlikely(tdx->state != VCPU_TD_STATE_INITIALIZED)) {
-		/* Set to avoid collision with EXIT_REASON_EXCEPTION_NMI. */
 		tdx->vp_enter_ret = TDX_SW_ERROR;
+		vt->exit_reason.full = -1ul;
 		return EXIT_FASTPATH_NONE;
 	}
 
@@ -1005,7 +954,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
-	if (unlikely(tdx_has_exit_reason(vcpu) && tdexit_exit_reason(vcpu).failed_vmentry))
+	if (unlikely(vmx_get_exit_reason(vcpu).failed_vmentry))
 		return EXIT_FASTPATH_NONE;
 
 	tdx_complete_interrupts(vcpu);
@@ -1032,15 +981,14 @@ void tdx_inject_nmi(struct kvm_vcpu *vcpu)
 void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	if (tdx_check_exit_reason(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT))
-		vmx_handle_external_interrupt_irqoff(vcpu,
-						     tdexit_intr_info(vcpu));
+		vmx_handle_external_interrupt_irqoff(vcpu);
 	else if (tdx_check_exit_reason(vcpu, EXIT_REASON_EXCEPTION_NMI))
-		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
+		vmx_handle_exception_irqoff(vcpu);
 }
 
 static int tdx_handle_exception_nmi(struct kvm_vcpu *vcpu)
 {
-	u32 intr_info = tdexit_intr_info(vcpu);
+	u32 intr_info = vmx_get_intr_info(vcpu);
 
 	/*
 	 * Machine checks are handled by vmx_handle_exception_irqoff(), or by
@@ -1051,8 +999,7 @@ static int tdx_handle_exception_nmi(struct kvm_vcpu *vcpu)
 		return 1;
 
 	kvm_pr_unimpl("unexpected exception 0x%x(exit_reason 0x%llx qual 0x%lx)\n",
-		intr_info,
-		to_tdx(vcpu)->vp_enter_ret, tdexit_exit_qual(vcpu));
+		      intr_info, to_tdx(vcpu)->vp_enter_ret, vmx_get_exit_qual(vcpu));
 
 	vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
 	vcpu->run->ex.exception = intr_info & INTR_INFO_VECTOR_MASK;
@@ -1063,21 +1010,12 @@ static int tdx_handle_exception_nmi(struct kvm_vcpu *vcpu)
 
 static int tdx_handle_external_interrupt(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.irq_exits;
 	return 1;
 }
 
-static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
-{
-	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
-	vcpu->mmio_needed = 0;
-	return 0;
-}
-
-
 static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 {
-	kvm_r10_write(vcpu, vcpu->run->hypercall.ret);
+	<tdx thingie> = kvm_rax_read(vcpu);
 	return 1;
 }
 
@@ -1085,21 +1023,13 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	/*
-	 * ABI for KVM tdvmcall argument:
-	 * In Guest-Hypervisor Communication Interface(GHCI) specification,
-	 * Non-zero leaf number (R10 != 0) is defined to indicate
-	 * vendor-specific.  KVM uses this for KVM hypercall.  NOTE: KVM
-	 * hypercall number starts from one.  Zero isn't used for KVM hypercall
-	 * number.
-	 *
-	 * R10: KVM hypercall number
-	 * arguments: R11, R12, R13, R14.
-	 */
-	r = __kvm_emulate_hypercall(vcpu, r10, r11, r12, r13, r14, true, 0,
-				    complete_hypercall_exit);
+	kvm_rax_write(vcpu, blah);
+	kvm_rbx_write(vcpu, blah);
+	kvm_rcx_write(vcpu, blah);
+	kvm_rdx_write(vcpu, blah);
+	kvm_rsi_write(vcpu, blah);
 
-	return r > 0;
+	return kvm_emulate_hypercall(vcpu, complete_hypercall_exit);
 }
 
 /*
@@ -1258,36 +1188,9 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
-{
-	u32 eax, ebx, ecx, edx;
-
-	/* EAX and ECX for cpuid is stored in R12 and R13. */
-	eax = tdvmcall_a0_read(vcpu);
-	ecx = tdvmcall_a1_read(vcpu);
-
-	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);
-
-	tdvmcall_a0_write(vcpu, eax);
-	tdvmcall_a1_write(vcpu, ebx);
-	tdvmcall_a2_write(vcpu, ecx);
-	tdvmcall_a3_write(vcpu, edx);
-
-	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
-
-	return 1;
-}
-
-static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
-{
-	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
-	return kvm_emulate_halt_noskip(vcpu);
-}
-
 static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.pio.count = 0;
-	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
 	return 1;
 }
 
@@ -1301,10 +1204,7 @@ static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
 					 vcpu->arch.pio.port, &val, 1);
 
 	WARN_ON_ONCE(!ret);
-
-	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
 	tdvmcall_set_return_val(vcpu, val);
-
 	return 1;
 }
 
@@ -1337,7 +1237,6 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
 	if (ret) {
 		if (!write)
 			tdvmcall_set_return_val(vcpu, val);
-		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
 	} else {
 		if (write)
 			vcpu->arch.complete_userspace_io = tdx_complete_pio_out;
@@ -1348,22 +1247,18 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static int tdx_complete_mmio(struct kvm_vcpu *vcpu)
+static int tdx_complete_mmio_read(struct kvm_vcpu *vcpu)
 {
 	unsigned long val = 0;
 	gpa_t gpa;
 	int size;
 
-	if (!vcpu->mmio_is_write) {
-		gpa = vcpu->mmio_fragments[0].gpa;
-		size = vcpu->mmio_fragments[0].len;
+	gpa = vcpu->mmio_fragments[0].gpa;
+	size = vcpu->mmio_fragments[0].len;
 
-		memcpy(&val, vcpu->run->mmio.data, size);
-		tdvmcall_set_return_val(vcpu, val);
-		trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
-	}
-
-	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
+	memcpy(&val, vcpu->run->mmio.data, size);
+	tdvmcall_set_return_val(vcpu, val);
+	trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
 	return 1;
 }
 
@@ -1434,7 +1329,8 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
 
 	/* Request the device emulation to userspace device model. */
 	vcpu->mmio_is_write = write;
-	vcpu->arch.complete_userspace_io = tdx_complete_mmio;
+	if (!write)
+		vcpu->arch.complete_userspace_io = tdx_complete_mmio_read;
 
 	vcpu->run->mmio.phys_addr = gpa;
 	vcpu->run->mmio.len = size;
@@ -1455,39 +1351,15 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int tdx_emulate_rdmsr(struct kvm_vcpu *vcpu)
+int tdx_complete_emulated_msr(struct kvm_vcpu *vcpu)
 {
-	u32 index = tdvmcall_a0_read(vcpu);
-	u64 data;
-
-	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ) ||
-	    kvm_get_msr(vcpu, index, &data)) {
-		trace_kvm_msr_read_ex(index);
-		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
-		return 1;
-	}
-	trace_kvm_msr_read(index, data);
-
-	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
-	tdvmcall_set_return_val(vcpu, data);
-	return 1;
-}
-
-static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
-{
-	u32 index = tdvmcall_a0_read(vcpu);
-	u64 data = tdvmcall_a1_read(vcpu);
-
-	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE) ||
-	    kvm_set_msr(vcpu, index, data)) {
-		trace_kvm_msr_write_ex(index, data);
+	if (err) {
 		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
 		return 1;
 	}
 
-	trace_kvm_msr_write(index, data);
-	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
-	return 1;
+	if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MSR_READ)
+		tdvmcall_set_return_val(vcpu, kvm_read_edx_eax(vcpu));
 }
 
 static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
@@ -1506,26 +1378,11 @@ static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
 
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
-	if (tdvmcall_exit_type(vcpu))
-		return tdx_emulate_vmcall(vcpu);
-
-	switch (tdvmcall_leaf(vcpu)) {
+	switch (to_tdx(vcpu)->blah.tdvmcall_leaf) {
 	case TDVMCALL_MAP_GPA:
 		return tdx_map_gpa(vcpu);
 	case TDVMCALL_REPORT_FATAL_ERROR:
 		return tdx_report_fatal_error(vcpu);
-	case EXIT_REASON_CPUID:
-		return tdx_emulate_cpuid(vcpu);
-	case EXIT_REASON_HLT:
-		return tdx_emulate_hlt(vcpu);
-	case EXIT_REASON_IO_INSTRUCTION:
-		return tdx_emulate_io(vcpu);
-	case EXIT_REASON_EPT_VIOLATION:
-		return tdx_emulate_mmio(vcpu);
-	case EXIT_REASON_MSR_READ:
-		return tdx_emulate_rdmsr(vcpu);
-	case EXIT_REASON_MSR_WRITE:
-		return tdx_emulate_wrmsr(vcpu);
 	case TDVMCALL_GET_TD_VM_CALL_INFO:
 		return tdx_get_td_vm_call_info(vcpu);
 	default:
@@ -1841,8 +1698,8 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 
 static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcpu)
 {
-	u64 eeq_type = tdexit_ext_exit_qual(vcpu) & TDX_EXT_EXIT_QUAL_TYPE_MASK;
-	u64 eq = tdexit_exit_qual(vcpu);
+	u64 eeq_type = vmx_get_ext_exit_qual(vcpu) & TDX_EXT_EXIT_QUAL_TYPE_MASK;
+	u64 eq = vmx_get_exit_qual(vcpu);
 
 	if (eeq_type != TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION)
 		return false;
@@ -1852,7 +1709,7 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
 
 static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
-	gpa_t gpa = tdexit_gpa(vcpu);
+	gpa_t gpa = vmx_get_exit_gpa(vcpu);
 	unsigned long exit_qual;
 
 	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
@@ -1873,7 +1730,7 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 		 */
 		exit_qual = EPT_VIOLATION_ACC_WRITE;
 	} else {
-		exit_qual = tdexit_exit_qual(vcpu);
+		exit_qual = vmx_get_exit_qual(vcpu);
 		/*
 		 * EPT violation due to instruction fetch should never be
 		 * triggered from shared memory in TDX guest.  If such EPT
@@ -1889,18 +1746,14 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 
 int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 {
+	union vmx_exit_reason exit_reason = vmx_get_exit_reason(vcpu);
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	u64 vp_enter_ret = tdx->vp_enter_ret;
-	union vmx_exit_reason exit_reason;
 
 	if (fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 
-	/*
-	 * Handle TDX SW errors, including TDX_SEAMCALL_UD, TDX_SEAMCALL_GP and
-	 * TDX_SEAMCALL_VMFAILINVALID.
-	 */
-	if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
+	if (unlikely(exit_reason.full == -1u) {
 		KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
 		goto unhandled_exit;
 	}
@@ -1909,33 +1762,47 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	 * Without off-TD debug enabled, failed_vmentry case must have
 	 * TDX_NON_RECOVERABLE set.
 	 */
-	if (unlikely(vp_enter_ret & (TDX_ERROR | TDX_NON_RECOVERABLE))) {
-		/* Triple fault is non-recoverable. */
-		if (unlikely(tdx_check_exit_reason(vcpu, EXIT_REASON_TRIPLE_FAULT)))
-			return tdx_handle_triple_fault(vcpu);
-
+	if (unlikely(vp_enter_ret & (TDX_ERROR | TDX_NON_RECOVERABLE)) &&
+	    exit_reason.basic != EXIT_REASON_TRIPLE_FAULT) {
 		kvm_pr_unimpl("TD vp_enter_ret 0x%llx, hkid 0x%x hkid pa 0x%llx\n",
 			      vp_enter_ret, to_kvm_tdx(vcpu->kvm)->hkid,
 			      set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
 		goto unhandled_exit;
 	}
 
-	/* From now, the seamcall status should be TDX_SUCCESS. */
-	WARN_ON_ONCE((vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) != TDX_SUCCESS);
-	exit_reason = tdexit_exit_reason(vcpu);
+	WARN_ON_ONCE(exit_reason.basic != EXIT_REASON_TRIPLE_FAULT &&
+		     (vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) != TDX_SUCCESS);
 
 	switch (exit_reason.basic) {
 	case EXIT_REASON_EXCEPTION_NMI:
 		return tdx_handle_exception_nmi(vcpu);
 	case EXIT_REASON_EXTERNAL_INTERRUPT:
-		return tdx_handle_external_interrupt(vcpu);
+		++vcpu->stat.irq_exits;
+		return 1;
+	case EXIT_REASON_CPUID:
+		return tdx_emulate_cpuid(vcpu);
+	case EXIT_REASON_HLT:
+		return kvm_emulate_halt_noskip(vcpu);
+	case EXIT_REASON_VMCALL:
+		return tdx_emulate_vmcall(vcpu);
+	case EXIT_REASON_IO_INSTRUCTION:
+		return tdx_emulate_io(vcpu);
+	case EXIT_REASON_MSR_READ:
+		kvm_rcx_write(vcpu, <don't care where this comes from>);
+		return kvm_emulate_rdmsr(vcpu);
+	case EXIT_REASON_MSR_WRITE:
+		kvm_rcx_write(vcpu, <don't care where this comes from>);
+		return kvm_emulate_wrmsr(vcpu);
+	case EXIT_REASON_EPT_MISCONFIG:
+		return tdx_emulate_mmio(vcpu);
 	case EXIT_REASON_TDCALL:
 		return handle_tdvmcall(vcpu);
 	case EXIT_REASON_EPT_VIOLATION:
 		return tdx_handle_ept_violation(vcpu);
-	case EXIT_REASON_EPT_MISCONFIG:
-		KVM_BUG_ON(1, vcpu->kvm);
-		return -EIO;
+	case EXIT_REASON_TRIPLE_FAULT:
+		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+		vcpu->mmio_needed = 0;
+		return 0;
 	case EXIT_REASON_OTHER_SMI:
 		/*
 		 * Unlike VMX, SMI in SEAM non-root mode (i.e. when
@@ -1970,20 +1837,20 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	return 0;
 }
 
-void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
-		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
+		       u64 *info2, u32 *intr_info, u32 *error_code)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
-	if (tdx_has_exit_reason(vcpu)) {
+	if (tdx_get_exit_reason(vcpu).full != -1ul) {
 		/*
 		 * Encode some useful info from the the 64 bit return code
 		 * into the 32 bit exit 'reason'. If the VMX exit reason is
 		 * valid, just set it to those bits.
 		 */
 		*reason = (u32)tdx->vp_enter_ret;
-		*info1 = tdexit_exit_qual(vcpu);
-		*info2 = tdexit_ext_exit_qual(vcpu);
+		*info1 = vmx_get_exit_qual(vcpu);
+		*info2 = vmx_get_ext_exit_qual(vcpu);
 	} else {
 		/*
 		 * When the VMX exit reason in vp_enter_ret is not valid,
@@ -1997,7 +1864,7 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		*info2 = 0;
 	}
 
-	*intr_info = tdexit_intr_info(vcpu);
+	*intr_info = vmx_get_intr_info(vcpu);
 	*error_code = 0;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 0833d1084331..33d316e81a7e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -59,12 +59,7 @@ enum vcpu_tdx_state {
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 
-	/* Posted interrupt descriptor */
-	struct pi_desc pi_desc;
-
-	/* Used if this vCPU is waiting for PI notification wakeup. */
-	struct list_head pi_wakeup_list;
-	/* Until here same layout to struct vcpu_pi. */
+	struct vcpu_vt vt;
 
 	unsigned long tdvpr_pa;
 	unsigned long *tdcx_pa;
@@ -75,10 +70,6 @@ struct vcpu_tdx {
 
 	enum vcpu_tdx_state state;
 
-	bool host_state_need_save;
-	bool host_state_need_restore;
-	u64 msr_host_kernel_gs_base;
-
 	u64 map_gpa_next;
 	u64 map_gpa_end;
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 832387bea753..8302e429c82a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6099,9 +6099,9 @@ void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	*reason = vmx->exit_reason.full;
+	*reason = vmx_get_exit_reason(vcpu).full;
 	*info1 = vmx_get_exit_qual(vcpu);
-	if (!(vmx->exit_reason.failed_vmentry)) {
+	if (!(vmx_get_exit_reason(vcpu).failed_vmentry)) {
 		*info2 = vmx->idt_vectoring_info;
 		*intr_info = vmx_get_intr_info(vcpu);
 		if (is_exception_with_error_code(*intr_info))
@@ -6380,7 +6380,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	union vmx_exit_reason exit_reason = vmx->exit_reason;
+	union vmx_exit_reason exit_reason = vmx_get_exit_reason(vcpu);
 	u32 vectoring_info = vmx->idt_vectoring_info;
 	u16 exit_handler_index;
 
@@ -6901,11 +6901,10 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 	if (vmx->emulation_required)
 		return;
 
-	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
-		vmx_handle_external_interrupt_irqoff(vcpu,
-						     vmx_get_intr_info(vcpu));
-	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
-		vmx_handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
+	if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXTERNAL_INTERRUPT)
+		vmx_handle_external_interrupt_irqoff(vcpu);
+	else if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXCEPTION_NMI)
+		vmx_handle_exception_irqoff(vcpu);
 }
 
 /*
@@ -7154,6 +7153,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					unsigned int flags)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 
 	guest_state_enter_irqoff();
 
@@ -7185,15 +7185,15 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	vmx_enable_fb_clear(vmx);
 
 	if (unlikely(vmx->fail)) {
-		vmx->exit_reason.full = 0xdead;
+		vt->exit_reason.full = 0xdead;
 		goto out;
 	}
 
-	vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
-	if (likely(!vmx->exit_reason.failed_vmentry))
+	vt->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
+	if (likely(!vt->exit_reason.failed_vmentry))
 		vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
-	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
+	if ((u16)vt->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
 	    is_nmi(vmx_get_intr_info(vcpu)))
 		__vmx_handle_nmi(vcpu);
 
@@ -7331,7 +7331,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 		 * checking.
 		 */
 		if (vmx->nested.nested_run_pending &&
-		    !vmx->exit_reason.failed_vmentry)
+		    !vmx_get_exit_reason(vcpu).failed_vmentry)
 			++vcpu->stat.nested_run;
 
 		vmx->nested.nested_run_pending = 0;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a91e1610b0b7..7a385dcdb2d5 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -231,28 +231,11 @@ struct nested_vmx {
 struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
 
-	/* Posted interrupt descriptor */
-	struct pi_desc pi_desc;
-
-	/* Used if this vCPU is waiting for PI notification wakeup. */
-	struct list_head pi_wakeup_list;
-	/* Until here same layout to struct vcpu_pi. */
+	struct vcpu_vt	      vt;
 
 	u8                    fail;
 	u8		      x2apic_msr_bitmap_mode;
 
-	/*
-	 * If true, host state has been stored in vmx->loaded_vmcs for
-	 * the CPU registers that only need to be switched when transitioning
-	 * to/from the kernel, and the registers have been loaded with guest
-	 * values.  If false, host state is loaded in the CPU registers
-	 * and vmx->loaded_vmcs->host_state is invalid.
-	 */
-	bool		      guest_state_loaded;
-
-	unsigned long         exit_qualification;
-	u32                   exit_intr_info;
-	u32                   idt_vectoring_info;
 	ulong                 rflags;
 
 	/*
@@ -263,11 +246,10 @@ struct vcpu_vmx {
 	 */
 	struct vmx_uret_msr   guest_uret_msrs[MAX_NR_USER_RETURN_MSRS];
 	bool                  guest_uret_msrs_loaded;
+
 #ifdef CONFIG_X86_64
-	u64		      msr_host_kernel_gs_base;
 	u64		      msr_guest_kernel_gs_base;
 #endif
-
 	u64		      spec_ctrl;
 	u32		      msr_ia32_umwait_control;
 
@@ -649,26 +631,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
 
-static __always_inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	if (!kvm_register_test_and_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1))
-		vmx->exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
-
-	return vmx->exit_qualification;
-}
-
-static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	if (!kvm_register_test_and_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2))
-		vmx->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
-
-	return vmx->exit_intr_info;
-}
-
 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
 void free_vmcs(struct vmcs *vmcs);
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);

base-commit: 14cfaed7621d53af608fd96aa36188064937ca44
-- 
2.47.1.613.gc27f4b7a9f-goog


--1yoo3KhbUOvehEvV--

