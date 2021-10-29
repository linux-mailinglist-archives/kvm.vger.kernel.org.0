Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533684400FA
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 19:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhJ2RMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 13:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhJ2RMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 13:12:51 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65CFC061570
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 10:10:22 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so4283931pjc.4
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 10:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZoTHBfW5OpRgOrksI1YeC+dcq4mUI0wkCaNrcrIGxCI=;
        b=TYEeGgWzCrG2MaDFEDODE/GMsoplATtJTDi1fjwU84i1IWZ+odVnXxElko0POzEXPV
         Rkmj4s7xQ94MR/HfyAqbPhBcGhqYUeLo3BM4iAn25OwJeGYoGkdD4v6W0UoSB5lI7DAJ
         sBX5lVPyIxPw2VrMzZM9IxBWKWR4+uXc4/IKPGGAvRUKm/Gp0TRPqzEVjvje+Mp0zlhs
         otpCQ2w2ZqNuyF8LPGb8KxiooF/ORxlxdgeTU2pO1ribKkYh5jt7BSw+kmAkJDn37+5F
         vfc76dZ3L11zZpNz9nrmRuK+H7Lv1jf8qKOWNTBwKfxGpQTe0jpEyByUctnsZmHCJOAA
         Csjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZoTHBfW5OpRgOrksI1YeC+dcq4mUI0wkCaNrcrIGxCI=;
        b=lUJrRMe0UGOY1Hc0dBNkRsEKWjgAZtS1AFpfvd0fC75pVBGt9S3fJ+7NB28thcfGNZ
         awF6T1cSAic42naGvOAO7SzvnAPlqwDE1oPGO+9ZdTDN16t24svwALSUK4ER2FEddX4H
         7tVI/ZIQL+Vo85/UnS8hYS8tlwIEZrmNdDD+Bhc68m7xMzzFVDi2AzLUK2rUXtT0wiAc
         8Al5JMHcWh/a+TkB02K3regVk00DHUZVE+rRp/JH+UdTdKv6677Qgw9Cc6JJrckm6YED
         NEfDfQF0VdBYUM3+whcfoXgES2Z6YMOZ7EoPf+PqNg5mZ2KARjlp5qnuIXiqms+VwH5q
         DXDw==
X-Gm-Message-State: AOAM530cCfG/06s3lj+FlON1w0c9aOehmd+bAeRruDvk0loWDbn05FqW
        SjowPSreiGbcdcmiqAuFlqYs7Q==
X-Google-Smtp-Source: ABdhPJxCB23Zp26lyFdz/cP8KLFUoxUrz0EMZDBkTQD3iCIpmCdJCGhYDjeSjI8wicHsFB8H8wNWnA==
X-Received: by 2002:a17:90a:6542:: with SMTP id f2mr20622713pjs.159.1635527422006;
        Fri, 29 Oct 2021 10:10:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pj3sm11331759pjb.18.2021.10.29.10.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 10:10:21 -0700 (PDT)
Date:   Fri, 29 Oct 2021 17:10:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 23/37] KVM: nVMX: Add helper to handle TLB flushes on
 nested VM-Enter/VM-Exit
Message-ID: <YXwq+Q3+I81jwv7G@google.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-24-sean.j.christopherson@intel.com>
 <CAJhGHyD=S6pVB+OxM7zF0_6LnMUCLqyTfMK4x9GZsdRHZmgN7Q@mail.gmail.com>
 <YXrAM9MNqgLTU6+m@google.com>
 <CAJhGHyBKVUsuKdvfaART6NWF7Axk5=eFQLidhGrM=mUO2cv2vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyBKVUsuKdvfaART6NWF7Axk5=eFQLidhGrM=mUO2cv2vw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TL;DR: I'll work on a proper series next week, there are multiple things that need
to be fixed.

On Fri, Oct 29, 2021, Lai Jiangshan wrote:
> On Thu, Oct 28, 2021 at 11:22 PM Sean Christopherson <seanjc@google.com> wrote:
> > The fix should simply be:
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index eedcebf58004..574823370e7a 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -1202,17 +1202,15 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
> >          *
> >          * If a TLB flush isn't required due to any of the above, and vpid12 is
> >          * changing then the new "virtual" VPID (vpid12) will reuse the same
> > -        * "real" VPID (vpid02), and so needs to be flushed.  There's no direct
> > -        * mapping between vpid02 and vpid12, vpid02 is per-vCPU and reused for
> > -        * all nested vCPUs.  Remember, a flush on VM-Enter does not invalidate
> > -        * guest-physical mappings, so there is no need to sync the nEPT MMU.
> > +        * "real" VPID (vpid02), and so needs to be flushed.  Like the !vpid02
> > +        * case above, this is a full TLB flush from the guest's perspective.
> >          */
> >         if (!nested_has_guest_tlb_tag(vcpu)) {
> >                 kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> >         } else if (is_vmenter &&
> >                    vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
> >                 vmx->nested.last_vpid = vmcs12->virtual_processor_id;
> > -               vpid_sync_context(nested_get_vpid02(vcpu));
> > +               kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> 
> This change is neat.

Heh, yeah, but too neat to be right :-)

> But current KVM_REQ_TLB_FLUSH_GUEST flushes vpid01 only, and it doesn't flush
> vpid02.  vmx_flush_tlb_guest() might need to be changed to flush vpid02 too.

Hmm.  I think vmx_flush_tlb_guest() is straight up broken.  E.g. if EPT is enabled
but L1 doesn't use EPT for L2 and doesn't intercept INVPCID, then KVM will handle
INVPCID from L2.  That means the recent addition to kvm_invalidate_pcid() (see
below) will flush the wrong VPID.  And it's incorrect (well, more than is required
by the SDM) to flush both VPIDs because flushes from INVPCID (and flushes from the
guest's perspective in general) are scoped to the current VPID, e.g. a "full" TLB
flush in the "host" by toggling CR4.PGE flushes only the current VPID:

  Operations that architecturally invalidate entries in the TLBs or paging-structure
  caches independent of VMX operation (e.g., the INVLPG and INVPCID instructions)
  invalidate linear mappings and combined mappings.  They are required to do so only
  for the current VPID (but, for combined mappings, all EP4TAs).

static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
{
	struct kvm_mmu *mmu = vcpu->arch.mmu;
	unsigned long roots_to_free = 0;
	int i;

	/*
	 * MOV CR3 and INVPCID are usually not intercepted when using TDP, but
	 * this is reachable when running EPT=1 and unrestricted_guest=0,  and
	 * also via the emulator.  KVM's TDP page tables are not in the scope of
	 * the invalidation, but the guest's TLB entries need to be flushed as
	 * the CPU may have cached entries in its TLB for the target PCID.
	 */
	if (unlikely(tdp_enabled)) {
		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
		return;
	}

	...
}

To fix that, the "guest" flushes should always operate on the current VPID.  But
this alone is insufficient (more below).

static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
{
	if (is_guest_mode(vcpu))
		return nested_get_vpid02(vcpu);
	return to_vmx(vcpu)->vpid;
}

static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
{
	struct kvm_mmu *mmu = vcpu->arch.mmu;
	u64 root_hpa = mmu->root_hpa;

	/* No flush required if the current context is invalid. */
	if (!VALID_PAGE(root_hpa))
		return;

	if (enable_ept)
		ept_sync_context(construct_eptp(vcpu, root_hpa,
						mmu->shadow_root_level));
	else
		vpid_sync_context(vmx_get_current_vpid(vcpu));
}

static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
{
	/*
	 * vpid_sync_vcpu_addr() is a nop if vpid==0, see the comment in
	 * vmx_flush_tlb_guest() for an explanation of why this is ok.
	 */
	vpid_sync_vcpu_addr(vmx_get_current_vpid(vcpu), addr);
}

static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
{
	/*
	 * vpid_sync_context() is a nop if vpid==0, e.g. if enable_vpid==0 or a
	 * vpid couldn't be allocated for this vCPU.  VM-Enter and VM-Exit are
	 * required to flush GVA->{G,H}PA mappings from the TLB if vpid is
	 * disabled (VM-Enter with vpid enabled and vpid==0 is disallowed),
	 * i.e. no explicit INVVPID is necessary.
	 */
	vpid_sync_context(vmx_get_current_vpid(vcpu));
}



> And if so, this nested_vmx_transition_tlb_flush() can be simplified further
> since KVM_REQ_TLB_FLUSH_CURRENT(!enable_ept) can be replaced with
> KVM_REQ_TLB_FLUSH_GUEST.

And as above KVM_REQ_TLB_FLUSH_GUEST is conceptually wrong, too.  E.g. in my
dummy case of L1 and L2 using the same CR3, if L1 assigns L2 a VPID then L1's
ASID is not flushed flushed on VM-Exit, so pending PTE updates for that single
CR3 would not be flushed (sync'd in KVM) for L1 even though they were flushed
for L2.

kvm_mmu_page_role doesn't track VPID, but it does track is_guest_mode, so the
bizarre case of L1 but not L2 having stale entries for a single CR3 is "supported".

Another wrinkle that is being mishandled is if L1 doesn't intercept INVPCID and
KVM synthesizes a nested VM-Exit from L2=>L1 before servicing KVM_REQ_MMU_SYNC,
KVM will sync the wrong MMU because the nested transitions only service pending
"current" flushes.  The GUEST variant also has the same bug (which I alluded to
above).

To fix that, the nVMX code should handle all pending flushes and syncs that are
specific to the current vCPU, e.g. by replacing the open coded TLB_FLUSH_CURRENT
check with a call to a common helper as below.  Ideally enter_guest_mode() and
leave_guest_mode() would handle these calls so that SVM doesn't need to be updated
if/when SVM stops flushing on all nested transitions, but VMX switches to vmcs02
and has already modified state before getting to enter_guest_mode(), which makes
me more than a bit nervous.

@@ -3361,8 +3358,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
        };
        u32 failed_index;

-       if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
-               kvm_vcpu_flush_tlb_current(vcpu);
+       kvm_service_pending_tlb_flush_on_nested_transition(vcpu);

        evaluate_pending_interrupts = exec_controls_get(vmx) &
                (CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_NMI_WINDOW_EXITING);
@@ -4516,9 +4512,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
                (void)nested_get_evmcs_page(vcpu);
        }

-       /* Service the TLB flush request for L2 before switching to L1. */
-       if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
-               kvm_vcpu_flush_tlb_current(vcpu);
+       /* Service pending TLB flush requests for L2 before switching to L1. */
+       kvm_service_pending_tlb_flush_on_nested_transition(vcpu);

        /*
         * VCPU_EXREG_PDPTR will be clobbered in arch/x86/kvm/vmx/vmx.h between


And for nested_vmx_transition_tlb_flush(), assuming all the other things are fixed,
the "vpid12 is changing" case does indeed become KVM_REQ_TLB_FLUSH_GUEST.  It also
needs to be prioritized above nested_has_guest_tlb_tag() because a GUEST flush is
"strong" than a CURRENT flush.

static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
					    struct vmcs12 *vmcs12,
					    bool is_vmenter)
{
	struct vcpu_vmx *vmx = to_vmx(vcpu);

	/*
	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
	 * for *all* contexts to be flushed on VM-Enter/VM-Exit, i.e. it's a
	 * full TLB flush from the guest's perspective.  This is required even
	 * if VPID is disabled in the host as KVM may need to synchronize the
	 * MMU in response to the guest TLB flush.
	 *
	 * Note, using TLB_FLUSH_GUEST is correct even if nested EPT is in use.
	 * EPT is a special snowflake, as guest-physical mappings aren't
	 * flushed on VPID invalidations, including VM-Enter or VM-Exit with
	 * VPID disabled.  As a result, KVM _never_ needs to sync nEPT
	 * entries on VM-Enter because L1 can't rely on VM-Enter to flush
	 * those mappings.
	 */
	if (!nested_cpu_has_vpid(vmcs12)) {
		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
		return;
	}

	/* L2 should never have a VPID if VPID is disabled. */
	WARN_ON(!enable_vpid);

	/*
	 * VPID is enabled and in use by vmcs12.  If vpid12 is changing, then
	 * emulate a guest TLB flush as KVM does not track vpid12 history nor
	 * is the VPID incorporated into the MMU context.  I.e. KVM must assume
	 * that the new vpid12 has never been used and thus represents a new
	 * guest ASID that cannot have entries in the TLB.
	 */
	if (is_vmenter && vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
		vmx->nested.last_vpid = vmcs12->virtual_processor_id;
		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
		return;
	}

	/*
	 * If VPID is enabled, used by vmc12, and vpid12 is not changing but
	 * but does not have a unique TLB tag (ASID), i.e. EPT is disabled and
	 * KVM was unable to allocate a VPID for L2, flush the current context
	 * as the effective ASID is common to both L1 and L2.
	 */
	if (!nested_has_guest_tlb_tag(vcpu))
		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
}
