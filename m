Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2901A43B481
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 16:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbhJZOoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 10:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbhJZOod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 10:44:33 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AD8C061243
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 07:42:09 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x66so14507681pfx.13
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 07:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=15ypjFUpEZR6j1f2lct8JIBlISDABGh8xT/edVB0GWk=;
        b=XUED9cjOhv6KEtIoMQpCiNdsQoV6dg3e/7lW2+FHPnhaQds6h3BWc8tFP6L5SuK3TY
         yvJzYA1i0DQtwKFitv0MDcoUNKySCeZO68ZPIhrcWMkkMQyQznxEzn/Ul3V0F+F446Ju
         1uK4jfVuv28ayDaXn6lJWG+Z2UBWIubmCGbG5mKLDu+5/nstf0NRuWgBgyds16PAY49R
         giU3jccm4ppgbqcoaRjjc3Olhba4B0nT8+dbQZ9IGdwLoJK7SswCLBzZuBMF7Ss/qRiO
         h5+M1VpqRXEnYYk42eDZvsGn7R8qwdYO0yd8MDGrG8nL+uoSyKJNbPeO8tdRXq3lF4PT
         BT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=15ypjFUpEZR6j1f2lct8JIBlISDABGh8xT/edVB0GWk=;
        b=fVbtsIL9BKm8kUHgNiH85BcCSqdq5nMuF8o4i13TzXd8bd1SIANvnyKfksRnlgLZrh
         xscmmuBKe9b7coFxwv+ePRCUkXmuXyK6pdR8rCEx72KdOgZfFPIlS1JyA1CChMp48bpr
         iQ6xnQX0UtCQbKJN0xuPNLGkDv4HEJPMt1ZLis1xMagS6fKx6UrMX+BqGw/5IAX88sbc
         IbTxaqQYpyOwp6RcSGsQxy8fBLAoN1IUOAa5gTqdNptXNZVYvtQA7nn4CM0ZnTV4D4cb
         1aIRTO2cwTnorXWG6QRZSorMSOuB6RnUZCv/q7/tFY1VLSN8Ul6aCHlnh4QvsySSBZO0
         9RzQ==
X-Gm-Message-State: AOAM5305vaqo4riVktmgqmuUanechtc6YMP3ArarDU8+4HZjhVIQMd6H
        eL6ms5JS7OVRxecSyWA4ubmK6g==
X-Google-Smtp-Source: ABdhPJyaXzK/n6vYjSctZudbm5fQ/5PMOVLMP7wCvjywBUqne0BVpn05yyRelu/zWqpraE7IByymcw==
X-Received: by 2002:aa7:9212:0:b0:47b:aefd:2cc4 with SMTP id 18-20020aa79212000000b0047baefd2cc4mr26275184pfo.47.1635259327183;
        Tue, 26 Oct 2021 07:42:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b8sm24482555pfv.56.2021.10.26.07.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 07:42:06 -0700 (PDT)
Date:   Tue, 26 Oct 2021 14:42:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, mtosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] KVM: x86: Take srcu lock in post_kvm_run_save()
Message-ID: <YXgTugzJgJYUu01A@google.com>
References: <606aaaf29fca3850a63aa4499826104e77a72346.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <606aaaf29fca3850a63aa4499826104e77a72346.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 26, 2021, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The Xen interrupt injection for event channels relies on accessing the
> guest's vcpu_info structure in __kvm_xen_has_interrupt(), through a
> gfn_to_hva_cache.
> 
> This requires the srcu lock to be held, which is mostly the case except
> for this code path:
> 
> [   11.822877] WARNING: suspicious RCU usage
> [   11.822965] -----------------------------
> [   11.823013] include/linux/kvm_host.h:664 suspicious rcu_dereference_check() usage!
> [   11.823131]
> [   11.823131] other info that might help us debug this:
> [   11.823131]
> [   11.823196]
> [   11.823196] rcu_scheduler_active = 2, debug_locks = 1
> [   11.823253] 1 lock held by dom:0/90:
> [   11.823292]  #0: ffff998956ec8118 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x85/0x680
> [   11.823379]
> [   11.823379] stack backtrace:
> [   11.823428] CPU: 2 PID: 90 Comm: dom:0 Kdump: loaded Not tainted 5.4.34+ #5
> [   11.823496] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
> [   11.823612] Call Trace:
> [   11.823645]  dump_stack+0x7a/0xa5
> [   11.823681]  lockdep_rcu_suspicious+0xc5/0x100
> [   11.823726]  __kvm_xen_has_interrupt+0x179/0x190
> [   11.823773]  kvm_cpu_has_extint+0x6d/0x90
> [   11.823813]  kvm_cpu_accept_dm_intr+0xd/0x40
> [   11.823853]  kvm_vcpu_ready_for_interrupt_injection+0x20/0x30
>               < post_kvm_run_save() inlined here >
> [   11.823906]  kvm_arch_vcpu_ioctl_run+0x135/0x6a0
> [   11.823947]  kvm_vcpu_ioctl+0x263/0x680
> 
> Fixes: 40da8ccd724f ("KVM: x86/xen: Add event channel interrupt vector upcall")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> 
> There are potentially other ways of doing this, by shuffling the tail
> of kvm_arch_vcpu_ioctl_run() around a little and holding the lock once
> there instead of taking it within vcpu_run(). But the call to
> post_kvm_run_save() occurs even on the error paths, and it gets complex
> to untangle. This is the simple approach.

What about taking the lock well early on so that the tail doesn't need to juggle
errors?  Dropping the lock for the KVM_MP_STATE_UNINITIALIZED case is a little
unfortunate, but that at least pairs with similar logic in x86's other call to
kvm_vcpu_block().  Relocking if xfer_to_guest_mode_handle_work() triggers an exit
to userspace is also unfortunate but it's not the end of the world.

On the plus side, the complete_userspace_io() callback doesn't need to worry
about taking the lock.

---
 arch/x86/kvm/x86.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..90751a080447 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10039,7 +10039,6 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	int r;
 	struct kvm *kvm = vcpu->kvm;

-	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 	vcpu->arch.l1tf_flush_l1d = true;

 	for (;;) {
@@ -10067,25 +10066,18 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 		if (__xfer_to_guest_mode_work_pending()) {
 			srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 			r = xfer_to_guest_mode_handle_work(vcpu);
+			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 			if (r)
 				return r;
-			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 		}
 	}

-	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
-
 	return r;
 }

 static inline int complete_emulated_io(struct kvm_vcpu *vcpu)
 {
-	int r;
-
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-	r = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
-	return r;
+	return kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
 }

 static int complete_emulated_pio(struct kvm_vcpu *vcpu)
@@ -10224,12 +10216,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	kvm_run->flags = 0;
 	kvm_load_guest_fpu(vcpu);

+	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
 		if (kvm_run->immediate_exit) {
 			r = -EINTR;
 			goto out;
 		}
+		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 		kvm_vcpu_block(vcpu);
+		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
+
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
 			goto out;
@@ -10279,10 +10275,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		r = vcpu_run(vcpu);

 out:
-	kvm_put_guest_fpu(vcpu);
 	if (kvm_run->kvm_valid_regs)
 		store_regs(vcpu);
 	post_kvm_run_save(vcpu);
+
+	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
+
+	kvm_put_guest_fpu(vcpu);
 	kvm_sigset_deactivate(vcpu);

 	vcpu_put(vcpu);
--
