Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C737343517E
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhJTRm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhJTRm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 13:42:57 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71323C061749
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 10:40:42 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y1so16645399plk.10
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 10:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1vzaPwSXS9hEyHWAyMsCpPKCtQbcMEqVFpEyDIJKQ0s=;
        b=JzpHbPNVtT3q+OcOvbM3EwblfzxQ/iQv3zlf4dx+Dii5WFS1VVORNkmxxA7jPJuw34
         227eyTq+nq5cB1/vHMGRyA/Lwoveye0PULpNgFwbWdGgQaWglrCNjYH3bXEwA5qM9JGN
         kdPx98uQZgPJnPCvGBnwkCczrTzrRTs/Xdit9hRTJXVmttf8g5CGHcI/73RM+0BdZuLz
         XGnufwNmcXv/3wTy1IeqFZk8hbGNlpZb3rRrDn5XTzrl9qvPkdpY4rkC9jrLOligmMmw
         3Wp5nORwEOH79c4Yge8YMa5bSE5dyCusq3xWhMqVac0nAONEFIeUvw9c9ZikCvQPXd/u
         iqkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1vzaPwSXS9hEyHWAyMsCpPKCtQbcMEqVFpEyDIJKQ0s=;
        b=qWfzMYFZ8e1+xby5rUxtm1+Ie38K+iN3aIAoTFV+ERmkz9rfaxnhgBNoes8mVCecQW
         /hsfEe5JUqQ/QSwzq8ZO2qpwnks+aJPs4HHr8dVuD6dW2d4YNI95GdT3Zyw6LkZC0H/a
         fBFfx+FqOXB1UGtZL2OHIKoc5o/QZ7Do3y/l8sToBKkf19PHqw2+pX9stMys+Yc1Z1Id
         AGg8j+6R1hpYrzdxJPlAedguflfYrS22lb5jfdND1q4W9vAyxUu3Ww/w4sM6Ensj90za
         Byxpyi96QpoCwASJMGQk4gw0SWjflH13mmQBtmD6+gA1uTdIfLwbCPE0WAFPrGl2WezA
         fI3g==
X-Gm-Message-State: AOAM531GBSIft23Abyh4lFpgzETrS57qkwWY/vIxfSVYh4qbb2zhBrcb
        j3U2RkQJ/zFZMBtFGWb6BQk9UA==
X-Google-Smtp-Source: ABdhPJzX6BajPmI4uU2rM4UyCOyUQLdhWo0WidSQzhqUdMTGUlAANAxsQrXJ+zwMi61pfHt5SyWj2g==
X-Received: by 2002:a17:90b:17cc:: with SMTP id me12mr278209pjb.147.1634751641618;
        Wed, 20 Oct 2021 10:40:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z8sm2994721pgi.45.2021.10.20.10.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 10:40:41 -0700 (PDT)
Date:   Wed, 20 Oct 2021 17:40:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v5 4/6] KVM: SVM: Add support to handle AP reset MSR
 protocol
Message-ID: <YXBUlYll8JDjH/Wd@google.com>
References: <20211020124416.24523-1-joro@8bytes.org>
 <20211020124416.24523-5-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0SdBen1GVMUEx1O4"
Content-Disposition: inline
In-Reply-To: <20211020124416.24523-5-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--0SdBen1GVMUEx1O4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 20, 2021, Joerg Roedel wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
> available in version 2 of the GHCB specification.

The changelog needs to explain how this is actually supposed to work.  Doesn't
need gory details, just a basic explanation of the sequence of events to wake a
vCPU that requested a reset hold.

I apologize in advance for the following rant(s).  There's some actionable feedback,
but a lot of it is just me complaining about the reset hold nonsense.

For the actual feedback, attached are two patches: patch 1 eliminates the
"first_sipi_received" hack, patch 2 is a (hopefully) fixed version of this patch
(but doesn't have an updated changelog).  Both are compile tested only.  There
will be a benign conflict with patch 05 of this series.

> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/svm/sev.c          | 52 ++++++++++++++++++++++++++-------
>  arch/x86/kvm/svm/svm.h          |  8 +++++
>  3 files changed, 49 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b67f550616cf..5c6b1469cc3b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -237,7 +237,6 @@ enum x86_intercept_stage;
>  	KVM_GUESTDBG_INJECT_DB | \
>  	KVM_GUESTDBG_BLOCKIRQ)
>  
> -

Spurious whitespace change.

>  #define PFERR_PRESENT_BIT 0
>  #define PFERR_WRITE_BIT 1
>  #define PFERR_USER_BIT 2
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 9afa71cb36e6..10af4ac83971 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2246,6 +2246,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm)
>  {
> +	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
> +	svm->reset_hold_type = AP_RESET_HOLD_NONE;
> +
>  	if (!svm->ghcb)
>  		return;
>  
> @@ -2405,14 +2408,21 @@ static u64 ghcb_msr_version_info(void)
>  	return msr;
>  }
>  
> -static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm)
> +static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm, enum ap_reset_hold_type type)
>  {
>  	int ret = kvm_skip_emulated_instruction(&svm->vcpu);
>  
> +	svm->reset_hold_type = type;
> +
>  	return __kvm_vcpu_halt(&svm->vcpu,
>  			       KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
>  }
>  
> +static u64 ghcb_msr_ap_rst_resp(u64 value)
> +{
> +	return (u64)GHCB_MSR_AP_RESET_HOLD_RESP | (value << GHCB_DATA_LOW);
> +}
> +
>  static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  {
>  	struct vmcb_control_area *control = &svm->vmcb->control;
> @@ -2459,6 +2469,16 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  
>  		break;
>  	}
> +	case GHCB_MSR_AP_RESET_HOLD_REQ:
> +		ret = sev_emulate_ap_reset_hold(svm, AP_RESET_HOLD_MSR_PROTO);
> +
> +		/*
> +		 * Preset the result to a non-SIPI return and then only set
> +		 * the result to non-zero when delivering a SIPI.
> +		 */
> +		svm->vmcb->control.ghcb_gpa = ghcb_msr_ap_rst_resp(0);

This can race with the SIPI and effectively corrupt svm->vmcb->control.ghcb_gpa.

        vCPU0                           vCPU1
                                        #VMGEXIT(RESET_HOLD)
                                        __kvm_vcpu_halt()
        INIT
        SIPI
        sev_vcpu_deliver_sipi_vector()
        ghcb_msr_ap_rst_resp(1);
                                        ghcb_msr_ap_rst_resp(0);

Note, the "INIT" above is mostly a guess.  I'm pretty sure it's necessary because
I don't see how KVM can possibly be correct otherwise.  The SIPI handler (below)
quite clearly expects the vCPU to have been in an AP reset hold, but the invocation
of sev_vcpu_deliver_sipi_vector is gated by the vCPU being in
KVM_MP_STATE_INIT_RECEIVED, not KVM_MP_STATE_AP_RESET_HOLD.  That implies the BSP
must INIT the AP.

                if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
                        /* evaluate pending_events before reading the vector */ 
                        smp_rmb();
                        sipi_vector = apic->sipi_vector;
                        kvm_x86_ops.vcpu_deliver_sipi_vector(vcpu, sipi_vector);
                        vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
                }

But the GHCB 2.0 spec doesn't actually say that; it instead implies that SIPI is
supposed to be able to directly wake the AP.

  * When a guest AP reaches its HLT loop (or similar method for parking the AP),
    it instead can either:
      1. Issue an AP Reset Hold NAE event.
      2. Issue the AP Reset Hold Request MSR Protocol
  * The hypervisor treats treats either request like the guest issued a HLT
                   ^^^^^^^^^^^^^                                        ^^^
                   spec typo                                            ???
    instruction and marks the vCPU as halted.
  * When the hypervisor receives a SIPI request for the vCPU, it will not update
                                   ^^^^^^^^^^^^
    any register values and, instead, it will either complete the AP Reset Hold
    NAE event or complete the AP Reset Hold MSR protocol
  * Mark the vCPU as active, allowing the VMGEXIT to complete.
  * Upon return from the VMGEXIT, the AP must transition from its current execution
    mode into real mode and begin executing at the reset vector supplied in the SIPI
    request. 

Piecing things together, my understanding is that the "hold request" really is
intended to be a HLT, but with extra semantics where the host sets sw_exit_info_2
to indicate that the vCPU was woken by INIT-SIPI. 

It's probably too late to change the spec, but I'm going to complain anyways. 
This is all ridiculously convoluted and completely unnecessary.  As pointed out
in the SNP series regarding AP "creation", this can be fully handled in the guest
via a simple mailbox between firmware and kernel.  What's really fubar is that
the guest firmware and kernel already have a mailbox!  But it's defined by the
GHCB spec instead of e.g. ACPI, and so instead of handling this fully within the
guest, the hypervisor (and PSP to some extent on SNP because of the secrets page!!!)
gets involved.

The complications to support this in the guest firmware are hilarious, e.g. the
guest hasto manually switch from 64-bit mode to Real Mode just so that the kernel
can continue to use a horribly antiquated method for gaining control of APs.

> +
> +		break;
>  	case GHCB_MSR_TERM_REQ: {
>  		u64 reason_set, reason_code;
>  
> @@ -2544,7 +2564,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
>  		break;
>  	case SVM_VMGEXIT_AP_HLT_LOOP:
> -		ret = sev_emulate_ap_reset_hold(svm);
> +		ret = sev_emulate_ap_reset_hold(svm, AP_RESET_HOLD_NAE_EVENT);
>  		break;
>  	case SVM_VMGEXIT_AP_JUMP_TABLE: {
>  		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> @@ -2679,13 +2699,23 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)

Tying into above, handling this in SIPI is flawed.  For example, if the guest
does INIT-SIPI-SIPI without a reset hold, KVM would incorrect set sw_exit_info_2
on the SIPI.  Because this mess requires an INIT, KVM has lost track of whether
the guest was in KVM_MP_STATE_AP_RESET_HOLD and thus can't know if the SIPI
arrived after a reset hold.  Looking at KVM, IIUC, this bug is why the hack
"received_first_sipi" exists.

Of course this all begs the question of why there's a "reset hold" concept in
the first place.  It's literally HLT with a flag to say "you got INIT-SIPI".
But the guest has to supply and fill a jump table!  Just put the flag in the
jump table!!!!

>  		return;
>  	}
>  
> -	/*
> -	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
> -	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
> -	 * non-zero value.
> -	 */
> -	if (!svm->ghcb)
> -		return;
> -
> -	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
> +	/* Subsequent SIPI */
> +	switch (svm->reset_hold_type) {
> +	case AP_RESET_HOLD_NAE_EVENT:
> +		/*
> +		 * Return from an AP Reset Hold VMGEXIT, where the guest will
> +		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
> +		 */
> +		ghcb_set_sw_exit_info_2(svm->ghcb, 1);

Doesn't this need to check for a null svm->ghcb?

I also suspect a boolean might make it easier to understand the implications
and also make the whole thing less error prone, e.g.

        if (svm->reset_hold_msr_protocol) {

        } else if (svm->ghcb) {

        }

> +		break;
> +	case AP_RESET_HOLD_MSR_PROTO:
> +		/*
> +		 * Return from an AP Reset Hold VMGEXIT, where the guest will
> +		 * set the CS and RIP. Set GHCB data field to a non-zero value.
> +		 */
> +		svm->vmcb->control.ghcb_gpa = ghcb_msr_ap_rst_resp(1);
> +		break;
> +	default:
> +		break;
> +	}
>  }
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 68e5f16a0554..bf9379f1cfb8 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -69,6 +69,12 @@ enum {
>  /* TPR and CR2 are always written before VMRUN */
>  #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
>  
> +enum ap_reset_hold_type {
> +	AP_RESET_HOLD_NONE,
> +	AP_RESET_HOLD_NAE_EVENT,
> +	AP_RESET_HOLD_MSR_PROTO,
> +};
> +
>  struct kvm_sev_info {
>  	bool active;		/* SEV enabled guest */
>  	bool es_active;		/* SEV-ES enabled guest */
> @@ -199,6 +205,8 @@ struct vcpu_svm {
>  	bool ghcb_sa_free;
>  
>  	bool guest_state_loaded;
> +
> +	enum ap_reset_hold_type reset_hold_type;
>  };
>  
>  struct svm_cpu_data {
> -- 
> 2.33.1
> 

--0SdBen1GVMUEx1O4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-SVM-Set-released-on-INIT-SIPI-iff-SEV-ES-vCPU-wa.patch"

From deffc8d46fed51f9ec3e77e4a9f4c61a727eb174 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 20 Oct 2021 09:46:16 -0700
Subject: [PATCH 1/2] KVM: SVM: Set "released" on INIT-SIPI iff SEV-ES vCPU was
 in AP reset hold

Set ghcb->sw_exit_info_2 when releasing a vCPU from an AP reset hold if
and only if the vCPU is actually in a reset hold.  Move the handling to
INIT (was SIPI) so that KVM can check the current MP state; when SIPI is
received, the vCPU will be in INIT_RECEIVED and will have lost track of
whether or not the vCPU was in a reset hold.

Drop the received_first_sipi flag, which was a hack to workaround the
fact that KVM lost track of whether or not the vCPU was in a reset hold.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 34 ++++++++++++----------------------
 arch/x86/kvm/svm/svm.c | 13 ++++++++-----
 arch/x86/kvm/svm/svm.h |  4 +---
 3 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9afa71cb36e6..f8dfa88993b8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2637,8 +2637,19 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 }
 
-void sev_es_vcpu_reset(struct vcpu_svm *svm)
+void sev_es_vcpu_reset(struct vcpu_svm *svm, bool init_event)
 {
+	if (init_event) {
+		/*
+		 * If the vCPU is in a "reset" hold, signal via SW_EXIT_INFO_2
+		 * that, assuming it receives a SIPI, the vCPU was "released".
+		 */
+		if (svm->vcpu.arch.mp_state == KVM_MP_STATE_AP_RESET_HOLD &&
+		    svm->ghcb)
+			ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+		return;
+	}
+
 	/*
 	 * Set the GHCB MSR value as per the GHCB specification when emulating
 	 * vCPU RESET for an SEV-ES guest.
@@ -2668,24 +2679,3 @@ void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
 	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
 	hostsa->xss = host_xss;
 }
-
-void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	/* First SIPI: Use the values as initially set by the VMM */
-	if (!svm->received_first_sipi) {
-		svm->received_first_sipi = true;
-		return;
-	}
-
-	/*
-	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
-	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
-	 * non-zero value.
-	 */
-	if (!svm->ghcb)
-		return;
-
-	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
-}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 89077160d463..0497066a91fb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1372,9 +1372,6 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
 	svm_init_osvw(vcpu);
 	vcpu->arch.microcode_version = 0x01000065;
 	svm->tsc_ratio_msr = kvm_default_tsc_scaling_ratio;
-
-	if (sev_es_guest(vcpu->kvm))
-		sev_es_vcpu_reset(svm);
 }
 
 static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -1388,6 +1385,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	if (!init_event)
 		__svm_vcpu_reset(vcpu);
+
+	if (sev_es_guest(vcpu->kvm))
+		sev_es_vcpu_reset(svm, init_event);
 }
 
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
@@ -4553,10 +4553,13 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 
 static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 {
+	/*
+	 * SEV-ES (and later derivatives) use INIT-SIPI to bring up APs, but
+	 * the guest is responsible for transitioning to Real Mode and setting
+	 * CS:RIP, GPRs, etc...  KVM just needs to make the vCPU runnable.
+	 */
 	if (!sev_es_guest(vcpu->kvm))
 		return kvm_vcpu_deliver_sipi_vector(vcpu, vector);
-
-	sev_vcpu_deliver_sipi_vector(vcpu, vector);
 }
 
 static void svm_vm_destroy(struct kvm *kvm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 68e5f16a0554..c1f3685db2e1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -190,7 +190,6 @@ struct vcpu_svm {
 	struct vmcb_save_area *vmsa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
-	bool received_first_sipi;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
@@ -562,8 +561,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
-void sev_es_vcpu_reset(struct vcpu_svm *svm);
-void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
+void sev_es_vcpu_reset(struct vcpu_svm *svm, bool init_event);
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
-- 
2.33.0.1079.g6e70778dc9-goog


--0SdBen1GVMUEx1O4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-SVM-Add-support-to-handle-AP-reset-MSR-protocol.patch"

From 7e41f58f1ce591bf5a40a94993957879a60103d6 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 20 Oct 2021 14:44:14 +0200
Subject: [PATCH 2/2] KVM: SVM: Add support to handle AP reset MSR protocol

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
available in version 2 of the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 53 +++++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f8dfa88993b8..1174270d18ee 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2405,10 +2405,36 @@ static u64 ghcb_msr_version_info(void)
 	return msr;
 }
 
-static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm)
+
+static u64 ghcb_msr_ap_rst_resp(u64 value)
+{
+	return (u64)GHCB_MSR_AP_RESET_HOLD_RESP | (value << GHCB_DATA_LOW);
+}
+
+static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm, u64 hold_type)
 {
 	int ret = kvm_skip_emulated_instruction(&svm->vcpu);
 
+	if (hold_type == GHCB_MSR_AP_RESET_HOLD_REQ) {
+		/*
+		 * Preset the result to a non-SIPI return and then only set
+		 * the result to non-zero when delivering a SIPI.
+		 */
+		svm->vmcb->control.ghcb_gpa = ghcb_msr_ap_rst_resp(0);
+		svm->reset_hold_msr_protocol = true;
+	} else {
+		WARN_ON_ONCE(hold_type != SVM_VMGEXIT_AP_HLT_LOOP);
+		svm->reset_hold_msr_protocol = false;
+	}
+
+	/*
+	 * Ensure the writes to ghcb_gpa and reset_hold_msr_protocol are visible
+	 * before the MP state change so that the INIT-SIPI doesn't misread
+	 * reset_hold_msr_protocol or write ghcb_gpa before this.  Pairs with
+	 * the smp_rmb() in sev_vcpu_reset().
+	 */
+	smp_wmb();
+
 	return __kvm_vcpu_halt(&svm->vcpu,
 			       KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
 }
@@ -2459,6 +2485,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ:
+		ret = sev_emulate_ap_reset_hold(svm, GHCB_MSR_AP_RESET_HOLD_REQ);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2544,7 +2573,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
-		ret = sev_emulate_ap_reset_hold(svm);
+		ret = sev_emulate_ap_reset_hold(svm, SVM_VMGEXIT_AP_HLT_LOOP);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
 		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
@@ -2642,11 +2671,23 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm, bool init_event)
 	if (init_event) {
 		/*
 		 * If the vCPU is in a "reset" hold, signal via SW_EXIT_INFO_2
-		 * that, assuming it receives a SIPI, the vCPU was "released".
+		 * (or the GHCB_GPA for the MSR protocol) that, assuming it
+		 * receives a SIPI, the vCPU was "released".
 		 */
-		if (svm->vcpu.arch.mp_state == KVM_MP_STATE_AP_RESET_HOLD &&
-		    svm->ghcb)
-			ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+		if (svm->vcpu.arch.mp_state == KVM_MP_STATE_AP_RESET_HOLD) {
+			/*
+			 * Ensure mp_state is read before reset_hold_msr_protocol
+			 * and before writing ghcb_gpa to ensure KVM conumes the
+			 * correct protocol.  Pairs with the smp_wmb() in
+			 * sev_emulate_ap_reset_hold().
+			 */
+			smp_rmb();
+			if (svm->reset_hold_msr_protocol)
+				svm->vmcb->control.ghcb_gpa = ghcb_msr_ap_rst_resp(1);
+			else if (svm->ghcb)
+				ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+			svm->reset_hold_msr_protocol = false;
+		}
 		return;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c1f3685db2e1..531d3258df58 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -198,6 +198,7 @@ struct vcpu_svm {
 	bool ghcb_sa_free;
 
 	bool guest_state_loaded;
+	bool reset_hold_msr_protocol;
 };
 
 struct svm_cpu_data {
-- 
2.33.0.1079.g6e70778dc9-goog


--0SdBen1GVMUEx1O4--
