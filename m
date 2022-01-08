Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD22487FDE
	for <lists+kvm@lfdr.de>; Sat,  8 Jan 2022 01:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiAHARJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 19:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiAHARI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 19:17:08 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3563EC061574
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 16:17:08 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id c3so6258153pls.5
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 16:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8YdYvsY4lCeVA+Gp/EBIybdpKH1XTBffjFU4qvK9NaU=;
        b=hETj+4UOwIYMFBq+UQHCYYs/Nwi0fOTAixvBX5OmEdAOBbEHg62l/nyfyFZTRjQTR1
         z0ppodeZFqjezDneI02xzbF7o9DpleGRIwDVbgx/ejQlXi3HuhJQlg7inJNBPUta0Qfw
         8yQsspz6bbkVwRz4UpplInWAPui5BFWP8vsMWfwDVIt8CS2ijI7brkc3ZoVBqXDeZFGo
         kBgjytFnz4xXyN5c4frI5raBmXNU6scmCHyc59W0Zt20/415b14KDyp/H2CtVhiLAjbQ
         VxKg7DtGAlg6GQqIeRDaQXq85quk7MvJU/EsymnPRFUffBQzopco+yR0Tghm+7HyuEh7
         nB2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8YdYvsY4lCeVA+Gp/EBIybdpKH1XTBffjFU4qvK9NaU=;
        b=2Ohg2/0dp1r5HwYjxGD6k0ENckCoIbhT2LSS8AMFkgk5vkpw1GPEmiRC5nVlBbGRxR
         9rhq73MMQOuT9Fkv4s/gFKkZDYSxZXmUI/v6wldYGh+P+SPpg3D+IyS5DJH8Qx5u9NIA
         WgGRzDesmM2xE8P0VMatWBWOZuJZAsSp9OpR3YUZ5men8QCpun2KYKwJVPFQcuLC0coL
         mVTUxI9wlCqQS2O1JZStpyjNuxH6febh/JU45cL7+LpllTsHsXJqaVGuiI5hPygWl6JD
         sbEuSsqBycUaOvmCnL2h+X5zzNrimfsEfGWWxMveCQjgzGg82c3Xv/2YALSmie7x17ER
         CFTw==
X-Gm-Message-State: AOAM532giULnf5SInxJldbdQSFaOLmZYSrjRAfy2bPhOvg5UeImCrjGA
        3DY1KOe3UhYBmzwI8DR5NavgOQ==
X-Google-Smtp-Source: ABdhPJw16/37KDT9FJvcQkWKT0mpM8WtDHh1qlOLrRksMZ5DUpZ8pFfcaf1tETTxaeKfVko7T6iEsw==
X-Received: by 2002:a17:90b:4ad0:: with SMTP id mh16mr18421890pjb.114.1641601027376;
        Fri, 07 Jan 2022 16:17:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k6sm81642pfu.96.2022.01.07.16.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 16:17:06 -0800 (PST)
Date:   Sat, 8 Jan 2022 00:17:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: VMX: Dont' deliver posted IRQ if vCPU == this vCPU
 and vCPU is IN_GUEST_MODE
Message-ID: <YdjX//gxZtP/ZMME@google.com>
References: <1641471171-34232-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1641471171-34232-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, s/deliver/send, "deliver" reads as though KVM is ignoring an event that was
sent by something else.

On Thu, Jan 06, 2022, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Commit fdba608f15e2 (KVM: VMX: Wake vCPU when delivering posted IRQ even 
> if vCPU == this vCPU) fixes wakeup event is missing when it is not from 
> synchronous kvm context by dropping vcpu == running_vcpu checking completely.
> However, it will break the original goal to optimise timer fastpath, let's 
> move the checking under vCPU is IN_GUEST_MODE to restore the performance.

Please (a) explain why this is safe and (b) provide context for exactly what
fastpath this helpers.  Lack of context is partly what led to the optimization
being reverted instead of being fixed as below, and forcing readers to jump through
multiple changelogs to understand what's going on is unnecessarily mean.

E.g.

  When delivering a virtual interrupt, don't actually send a posted interrupt
  if the target vCPU is also the currently running vCPU and is IN_GUEST_MODE,
  in which case the interrupt is being sent from a VM-Exit fastpath and the
  core run loop in vcpu_enter_guest() will manually move the interrupt from
  the PIR to vmcs.GUEST_RVI.  IRQs are disabled while IN_GUEST_MODE, thus
  there's no possibility of the virtual interrupt being sent from anything
  other than KVM, i.e. KVM won't suppress a wake event from an IRQ handler
  (see commit fdba608f15e2, "KVM: VMX: Wake vCPU when delivering posted IRQ
  even if vCPU == this vCPU").

  Eliding the posted interrupt restores the performance provided by the
  combination of commits 379a3c8ee444 ("KVM: VMX: Optimize posted-interrupt
  delivery for timer fastpath") and 26efe2fd92e5 ("KVM: VMX: Handle
  preemption timer fastpath").

The comment above send_IPI_mask() also needs to be updated.  There are a few
existing grammar and style nits that can be opportunistically cleaned up, too.

Paolo, if Wanpeng doesn't object, can you use the above changelog and the below
comment?

With that,

Reviewed-by: Sean Christopherson <seanjc@google.com>

---
 arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe06b02994e6..730df0e183d6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3908,31 +3908,32 @@ static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
 #ifdef CONFIG_SMP
 	if (vcpu->mode == IN_GUEST_MODE) {
 		/*
-		 * The vector of interrupt to be delivered to vcpu had
-		 * been set in PIR before this function.
+		 * The vector of the virtual has already been set in the PIR.
+		 * Send a notification event to deliver the virtual interrupt
+		 * unless the vCPU is the currently running vCPU, i.e. the
+		 * event is being sent from a fastpath VM-Exit handler, in
+		 * which case the PIR will be synced to the vIRR before
+		 * re-entering the guest.
 		 *
-		 * Following cases will be reached in this block, and
-		 * we always send a notification event in all cases as
-		 * explained below.
+		 * When the target is not the running vCPU, the following
+		 * possibilities emerge:
 		 *
-		 * Case 1: vcpu keeps in non-root mode. Sending a
-		 * notification event posts the interrupt to vcpu.
+		 * Case 1: vCPU stays in non-root mode. Sending a notification
+		 * event posts the interrupt to the vCPU.
 		 *
-		 * Case 2: vcpu exits to root mode and is still
-		 * runnable. PIR will be synced to vIRR before the
-		 * next vcpu entry. Sending a notification event in
-		 * this case has no effect, as vcpu is not in root
-		 * mode.
+		 * Case 2: vCPU exits to root mode and is still runnable. The
+		 * PIR will be synced to the vIRR before re-entering the guest.
+		 * Sending a notification event is ok as the host IRQ handler
+		 * will ignore the spurious event.
 		 *
-		 * Case 3: vcpu exits to root mode and is blocked.
-		 * vcpu_block() has already synced PIR to vIRR and
-		 * never blocks vcpu if vIRR is not cleared. Therefore,
-		 * a blocked vcpu here does not wait for any requested
-		 * interrupts in PIR, and sending a notification event
-		 * which has no effect is safe here.
+		 * Case 3: vCPU exits to root mode and is blocked. vcpu_block()
+		 * has already synced PIR to vIRR and never blocks the vCPU if
+		 * the vIRR is not empty. Therefore, a blocked vCPU here does
+		 * not wait for any requested interrupts in PIR, and sending a
+		 * notification event also results in a benign, spurious event.
 		 */
-
-		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
+		if (vcpu != kvm_get_running_vcpu())
+			apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
 		return;
 	}
 #endif

