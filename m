Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D5540CBC1
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 19:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhIORft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 13:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhIORfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 13:35:48 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A9AC061575
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 10:34:29 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h3so3430178pgb.7
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 10:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EyS/9Qsd9gUKNQPcEpSrk4F18zzLtkGCpQKngXDMwfU=;
        b=mAxPRGAK5eSu1lHet4zMaWFQ+sLuzVD06vNP3F7UzYxzX3yHGvzIKiRW89YrLGpJHj
         jEwxlfSy0KPW+flpx9wbHx2J/eKlP2MfDJD8omqUYRKH/RGR1m1CDZbqdGqg51c2/9ba
         p/nYisdscju180mDAFecfpYn2V4hsKaQ/HrLZEW72NdJWmvnoR+L9oSfLRAtwy9tVYRv
         OGlYEVPPGUbSaFPOXdo+gIT9XQ2z/vp2JEY+TL0Jk18M8I6CZvA5E4IQtX8unTdlKiW3
         vQ/Bw76NfZXNgy5OC/1xuZHQTB/H+sfNmhAfutw6FlzUWtJWBFuOxD8SMOpSB2ld9l5S
         kd6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EyS/9Qsd9gUKNQPcEpSrk4F18zzLtkGCpQKngXDMwfU=;
        b=ui6hxusvYxu+k3UJANoiL+08bEAIH79gFAWlC+vok5ADWTUQiaZ2+NEOB4aXesYVcE
         R2H1TaHJ5nzUUU18d/CRJ9bQp1TUKKjxdy/MGe2rnCwalMZ7YNHW9JDAuzzODBVeqyGj
         Mvm48Zg/2QLIU488YQKq8RZaCQVWEHzFHidx5xHXcCMKM20UaV7SlAknqojqgcpXzdts
         9MDiOP/aiwB5zpbzL8/B6ylgorS2NGSulS9lxIFofRKjT8M2uRrh2TV5z9PPSs9oZTxl
         laKuC4cSQOiCysd0MS2pce07wwxAu2yTcFzBdMoM/FyfilrTp3cZBw0vn42OD0uvm6z6
         QwUg==
X-Gm-Message-State: AOAM533YWVJiJzPLcOCr32GWGZSxG7zNKgplSVGzgnr74H4dkN3XauE1
        +l6ldHVTo+p7FRAhH94CsVIEow==
X-Google-Smtp-Source: ABdhPJwSbso//lb+HtXmuN/0GOl9ZBIGeiQJ8+kmS4rN1gMHYHR1JjEscGi8dTr2QexoQ9zdtAQVdA==
X-Received: by 2002:a63:d205:: with SMTP id a5mr868823pgg.30.1631727268205;
        Wed, 15 Sep 2021 10:34:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b20sm482105pfl.9.2021.09.15.10.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 10:34:27 -0700 (PDT)
Date:   Wed, 15 Sep 2021 17:34:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/3] KVM: VMX: Move RESET emulation to vmx_vcpu_reset()
Message-ID: <YUIunxwjea/wq3gd@google.com>
References: <20210914230840.3030620-1-seanjc@google.com>
 <20210914230840.3030620-3-seanjc@google.com>
 <875yv2167g.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yv2167g.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > +static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +
> > +	init_vmcs(vmx);
> > +
> > +	if (nested)
> > +		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
> > +
> > +	vcpu_setup_sgx_lepubkeyhash(vcpu);
> > +
> > +	vmx->nested.posted_intr_nv = -1;
> > +	vmx->nested.current_vmptr = -1ull;
> > +	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
> 
> What would happen in (hypothetical) case when enlightened VMCS is
> currently in use? If we zap 'hv_evmcs_vmptr' here, the consequent
> nested_release_evmcs() (called from
> nested_vmx_handle_enlightened_vmptrld(), for example) will not do 
> kvm_vcpu_unmap() while it should.

The short answer is that there's a lot of stuff that needs to be addressed before
KVM can expose a RESET ioctl().  My goal with these patches is to carve out the
stubs and move the few bits of RESET emulation into the "stubs".  This is the same
answer for the MSR question/comment at the end.

> This, however, got me thinking: should we free all-things-nested with
> free_nested()/nested_vmx_free_vcpu() upon vcpu reset? I can't seem to
> find us doing that... (I do remember that INIT is blocked in VMX-root
> mode and nobody else besides kvm_arch_vcpu_create()/
> kvm_apic_accept_events() seems to call kvm_vcpu_reset()) but maybe we
> should at least add a WARN_ON() guardian here?

I think that makes sense.  Maybe use CR0 as a sentinel since it has a non-zero
RESET value?  E.g. WARN if CR0 is non-zero at RESET.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..3ac074376821 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10813,6 +10813,11 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
        unsigned long new_cr0;
        u32 eax, dummy;

+       /*
+        * <comment about KVM not supporting arbitrary RESET>
+        */
+       WARN_ON_ONCE(!init_event && old_cr0);
+
        kvm_lapic_reset(vcpu, init_event);

        vcpu->arch.hflags = 0;

Huh, typing that out made me realize commit 0aa1837533e5 ("KVM: x86: Properly
reset MMU context at vCPU RESET/INIT") technically introduced a bug.  kvm_vcpu_reset()
does kvm_read_cr0() and thus reads vmcs.GUEST_CR0 because vcpu->arch.regs_avail is
(correctly) not stuffed to ALL_ONES until later in kvm_vcpu_reset().  init_vmcs()
doesn't explicitly zero vmcs.GUEST_CR0 (along with many other guest fields), and
so VMREAD(GUEST_CR0) is technically consuming garbage.  In practice, it's consuming
'0' because no known CPU or VMM inverts values in the VMCS, i.e. zero allocating
the VMCS is functionally equivalent to writing '0' to all fields via VMWRITE.

And staring more at kvm_vcpu_reset(), this code is terrifying for INIT

	memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
	vcpu->arch.regs_avail = ~0;
	vcpu->arch.regs_dirty = ~0;

because it means cr0 and cr4 are marked available+dirty without immediately writing
vcpu->arch.cr0/cr4.  And VMX subtly relies on that, as vmx_set_cr0() grabs CR0.PG
via kvm_read_cr0_bits(), i.e. zeroing vcpu->arch.cr0 would "break" the INIT flow.
Ignoring for the moment that CR0.PG is never guest-owned and thus never stale in
vcpu->arch.cr0, KVM is also technically relying on the earlier kvm_read_cr0() in
kvm_vcpu_reset() to ensure vcpu->arch.cr0 is fresh.

Stuffing regs_avail technically means vmx_set_rflags() -> vmx_get_rflags() is
consuming stale data.  It doesn't matter in practice because the old value is
only used to re-evaluate vmx->emulation_required, which is guaranteed to be up
refreshed by vmx_set_cr0() and friends.  PDPTRs and EXIT_INFO are in a similar
boat; KVM shouldn't be reading those fields (CR0.PG=0, not an exit path), but
marking them dirty without actually updating the cached values is wrong.

There's also one concrete bug: KVM doesn't set vcpu->arch.cr3=0 on RESET/INIT.
That bug has gone unnoticed because no real word BIOS/kernel is going to rely on
INIT to set CR3=0.  

I'm strongly leaning towards stuffing regs_avail/dirty in kvm_arch_vcpu_create(),
and relying on explicit kvm_register_mark_dirty() calls for the 3 or so cases where
x86 code writes a vcpu->arch register directly.  That would fix the CR0 read bug
and also prevent subtle bugs from sneaking in.  Adding new EXREGS would be slightly
more costly, but IMO that's a good thing as would force us to actually think about
how to handle each register.

E.g. implement this over 2-3 patches:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 114847253e0a..743146ac8307 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4385,6 +4385,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
        kvm_set_cr8(vcpu, 0);

        vmx_segment_cache_clear(vmx);
+       kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);

        seg_setup(VCPU_SREG_CS);
        vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..ab907a0b9eeb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10656,6 +10656,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
        int r;

        vcpu->arch.last_vmentry_cpu = -1;
+       vcpu->arch.regs_avail = ~0;
+       vcpu->arch.regs_dirty = ~0;

        if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
                vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
@@ -10874,9 +10876,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
                vcpu->arch.xcr0 = XFEATURE_MASK_FP;
        }

+       /* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
        memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
-       vcpu->arch.regs_avail = ~0;
-       vcpu->arch.regs_dirty = ~0;
+       kvm_register_mark_dirty(vcpu, VCPU_REGS_RSP);

        /*
         * Fall back to KVM's default Family/Model/Stepping of 0x600 (P6/Athlon)
@@ -10897,6 +10899,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
        kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
        kvm_rip_write(vcpu, 0xfff0);

+       vcpu->arch.cr3 = 0;
+       kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
+
        /*
         * CR0.CD/NW are set on RESET, preserved on INIT.  Note, some versions
         * of Intel's SDM list CD/NW as being set on INIT, but they contradict

> Side topic: we don't seem to reset Hyper-V specific MSRs either,
> probably relying on userspace VMM doing the right thing but this is also
> not ideal I believe.

