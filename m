Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FAA44EC64
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 19:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235429AbhKLSHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 13:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhKLSHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 13:07:32 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EF7C061767
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 10:04:41 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id p18so8975772plf.13
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 10:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=khqWKtumgtjOaGXjCkOX2yp8uJlzfXG3P2oRoM9pohQ=;
        b=YNDMVGEWCPkcFNNIhPF5BqOoDP92dqiwmJwFarGVH+5U9JDPje5/KQSQB+EduGIcT5
         gs4ESxkq+0PxvftuEmurHGj27hhB329KUNFuZy/E/COLn99we4ItMSvDDALQGUqEpsi8
         i4gbjYGaPpIps5Aqq0zt7RBR5QKKRgB/6vHnbJVaU54dWRV0J/JtaOHdesUe/OCeiURU
         5mJ7YLZTn8a9x6iSI1HVtI+lbpd6WbPZpmqm2RQ/vtiR/+2ofkUl8TtLUJ3PIwHTVkDI
         QqcRpvR7rni7jirVvHZQmUWeHZQMLmROyoQRpfrDO278WyoDL8a1QV95xrEQpX4BWPML
         yTTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=khqWKtumgtjOaGXjCkOX2yp8uJlzfXG3P2oRoM9pohQ=;
        b=FfuhIbRsxcT9P/GfDgjaUUty895eZSn6eiXKXCmuTANLBNFwZPkF7j8Rvj/y0fzYFM
         EdniQswVwXkE8V83QPg4YX9t8ZJ88QAzBQPn9kCPykpbRrVqN8Vkx6JiqEIBYcY5yu7n
         rJIn5qdKUM5XiKzpNEepDey1SB/E5Ha8nAFNs3wYmaNtBSSptzmRQZBljX53A0ycSqq8
         /vaQZnGLrfWXvFSok49fSdzLjeOuvp/uTOp9JzV6x7vAjnzfmri1majCorEGud+qo4gs
         R2Tmy9Go5Tv/HoWMhgyYomHSX/m4EHuibyGMsnZNCkNonBNse8/xHwX0hJLVKfJL5VnE
         28fA==
X-Gm-Message-State: AOAM530BdOKtEnSlclr2Hb5yJ+GKG2IrBp4Hwcr7nNerOvTaRQsZ0CZe
        zrbx3A9LEywj2WUulI4QmsAtog==
X-Google-Smtp-Source: ABdhPJw2/j+HnxGbY6Tn46Xw61qiLY7brYw/6mzUuU419CK4R4LbZMfxybgr9J1XuBV4tB9ruFsaZQ==
X-Received: by 2002:a17:902:ba85:b0:13e:c846:c92e with SMTP id k5-20020a170902ba8500b0013ec846c92emr9734035pls.57.1636740280854;
        Fri, 12 Nov 2021 10:04:40 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mi18sm6058012pjb.13.2021.11.12.10.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 10:04:40 -0800 (PST)
Date:   Fri, 12 Nov 2021 18:04:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH 07/11] KVM: x86: Disable SMM for TDX
Message-ID: <YY6stGpsmZawyRy5@google.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
 <20211112153733.2767561-8-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112153733.2767561-8-xiaoyao.li@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021, Xiaoyao Li wrote:
> SMM is not supported for TDX VM, nor can KVM emulate it for TDX VM.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/irq_comm.c | 2 ++
>  arch/x86/kvm/x86.c      | 6 ++++++
>  arch/x86/kvm/x86.h      | 5 +++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index f9f643e31893..705fc0dc0272 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -128,6 +128,8 @@ static inline bool kvm_msi_route_invalid(struct kvm *kvm,
>  			       .data = e->msi.data };
>  	return  (kvm_eoi_intercept_disallowed(kvm) &&
>  		 msg.arch_data.is_level) ||
> +		(kvm_smm_unsupported(kvm) &&
> +		 msg.arch_data.delivery_mode == APIC_DELIVERY_MODE_SMI) ||

This patch neglects to disallow SMI via IPI.  Ditto for INIT+SIPI in the next
patch.  And no small part of me thinks we shouldn't even bother handling the
delivery mode in the MSI routing.  If we reject MSI configuration, then to be
consistent we should also technically reject guest attempts to configure LVT
entries.  Sadly, KVM doesn't handle any of that stuff correctly as there are
assumptions left and right about how the guest will configure things like LVTT,
but from an architctural perspective it is legal to configure LVT0, LVT1, LVTT,
etc... to send SMI, NMI, INIT, etc...

The kvm_eoi_intercept_disallowed() part is a little different, since KVM can
deliver the interrupt, it just can handle the backend correctly.  Dropping an
event on the floor is a bit gross, but on the other hand I really don't want to
sign up for a game of whack-a-mole for all the paths that can get to
__apic_accept_irq().

E.g. I'm thinking:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76fb00921203..33364d3e4d02 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1112,6 +1112,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
                break;

        case APIC_DM_SMI:
+               if (kvm_smi_disallowed(vcpu->kvm))
+                       break;
+
                result = 1;
                kvm_make_request(KVM_REQ_SMI, vcpu);
                kvm_vcpu_kick(vcpu);
@@ -1124,6 +1127,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
                break;

        case APIC_DM_INIT:
+               if (kvm_init_disallowed(vcpu->kvm))
+                       break;
+
                if (!trig_mode || level) {
                        result = 1;
                        /* assumes that there are only KVM_APIC_INIT/SIPI */
@@ -1134,6 +1140,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
                break;

        case APIC_DM_STARTUP:
+               if (kvm_sipi_disallowed(vcpu->kvm))
+                       break;
+
                result = 1;
                apic->sipi_vector = vector;
                /* make sure sipi_vector is visible for the receiver */


>  		(kvm->arch.x2apic_format && (msg.address_hi & 0xff));
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 113ed9aa5c82..1f3cc2a2d844 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4132,6 +4132,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  			r |= KVM_X86_DISABLE_EXITS_MWAIT;
>  		break;
>  	case KVM_CAP_X86_SMM:
> +		if (kvm && kvm_smm_unsupported(kvm))
> +			break;
> +
>  		/* SMBASE is usually relocated above 1M on modern chipsets,
>  		 * and SMM handlers might indeed rely on 4G segment limits,
>  		 * so do not report SMM to be available if real mode is
> @@ -4500,6 +4503,9 @@ static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
>  
>  static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
>  {
> +	if (kvm_smm_unsupported(vcpu->kvm))
> +		return -EINVAL;
> +
>  	kvm_make_request(KVM_REQ_SMI, vcpu);
>  
>  	return 0;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 65c8c77e507b..ab7c91ca2478 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -456,6 +456,11 @@ static __always_inline bool kvm_eoi_intercept_disallowed(struct kvm *kvm)
>  	return kvm->arch.vm_type == KVM_X86_TDX_VM;
>  }
>  
> +static __always_inline bool kvm_smm_unsupported(struct kvm *kvm)

This should be "kvm_smi_disallowed" to be consistent with the other helpers.  Also,
why are these all __always_inline?  Generally speaking, __always_inline should
really only be used if there is a hard dependency on the function being inlined.
I would be extremely surprised if it actually changed anything in this case, but
it's odd and unnecessary.

> +{
> +	return kvm->arch.vm_type == KVM_X86_TDX_VM;

There really needs to be a helper for this:

static inline bool is_tdx_guest(struct kvm *kvm*)
{
	return kvm->arch.vm_type == KVM_X86_TDX_VM;
}

And I think we should bite the bullet and expose SEV-ES status in x86.  Ideally,
we would not have had to do that, but TDX and SEV diverge just enough that a single
guest_state_protected doesn't suffice :-(  Whining aside, exposing TDX in x86 but
not SEV-ES will create a weird split where some things are handled in common x86
and others are deferred to vendor code.

And I think it would make sense to tie the "smi disallowed" part to whether or
not KVM can emulate an instruction, because that's really the issue.  E.g.

static inline bool kvm_smi_disallowed(struct kvm *kvm)
{
	/* SMM requires emulation in KVM. */
	return __kvm_can_emulate_instruction(kvm);
}


And then the existing kvm_x86_ops.can_emulation_instruction() can be folded into
a helper that checks both the "can this VM emulating _anything_" as well as the
"can this specific instruction be emulated".

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21bb81710e0f..7af4393ccecd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4465,12 +4465,6 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
        bool smep, smap, is_user;
        unsigned long cr4;

-       /*
-        * When the guest is an SEV-ES guest, emulation is not possible.
-        */
-       if (sev_es_guest(vcpu->kvm))
-               return false;
-
        /*
         * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
         *
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a0440e22ede..c34f653e2546 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6717,6 +6717,18 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);

+static bool __kvm_can_emulate_instruction(struct kvm *kvm)
+{
+       return !is_sev_guest(kvm) && !is_tdx_guest(kvm);
+}
+
+static bool kvm_can_emulate_instruction(struct kvm_vcpu *vcpu,
+                                       void *insn, int insn_len)
+{
+       return __kvm_can_emulate_instruction(vcpu->kvm) &&
+              static_call(kvm_x86_can_emulate_instruction)(vcpu, NULL, 0);
+}
+
 int handle_ud(struct kvm_vcpu *vcpu)
 {
        static const char kvm_emulate_prefix[] = { __KVM_EMULATE_PREFIX };
@@ -6724,7 +6736,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
        char sig[5]; /* ud2; .ascii "kvm" */
        struct x86_exception e;

-       if (unlikely(!static_call(kvm_x86_can_emulate_instruction)(vcpu, NULL, 0)))
+       if (unlikely(!kvm_can_emulate_instruction(vcpu, NULL, 0)))
                return 1;

        if (force_emulation_prefix &&
@@ -8071,7 +8083,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
        bool writeback = true;
        bool write_fault_to_spt;

-       if (unlikely(!static_call(kvm_x86_can_emulate_instruction)(vcpu, insn, insn_len)))
+       if (unlikely(!kvm_can_emulate_instruction(vcpu, insn, insn_len)))
                return 1;

        vcpu->arch.l1tf_flush_l1d = true;
