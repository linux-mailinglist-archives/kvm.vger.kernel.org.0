Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769E3427648
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244643AbhJICSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244277AbhJICRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:17:39 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ACBC0617A3
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:14:01 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 81-20020a251254000000b005b6220d81efso14972311ybs.12
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=b2NFNOmcSkF8bnqGQwOgX6HnOIy2SSUQ2D5ginVhVO0=;
        b=IRLCbLMzdCb5UchOOv+Z0PtnZNSSoLW6N5YOs8Rf0ByvWkZw9fnrXDff7+K/1lsj6B
         NqqIJpk8pE4GidDTxI/LosWoSgWzx3bzDSM/n8KN7DTXuN2T17CPaZXkgIYzDMTtYTRb
         lzcpdr5xg4vfvZJBl69uVsKH5UNXjyyhFo8HAy7LJRDbUM63L3M5Gxx882mRoBUHmman
         GjJKxe2tvpIReuijhcU3M4KaZ5D41tl+LVTPtXRV7z3IcuqwUUZuaoObrBjmhydK/TA3
         cbKULKY59/B6tcCWrJFg3N/GGr3AkBsO6Nwaaye8gGjJSjaELsGsbRMT7ru8tM6UfG9M
         F3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=b2NFNOmcSkF8bnqGQwOgX6HnOIy2SSUQ2D5ginVhVO0=;
        b=5IT7DbOdkq2zZCDasiGjZefWqqDuOQL2PeJkSyQg3X5rI1UwbGpX/XJhDnEVDv3Rhr
         uV1tJZqJ2JJPJkmMP95W+XercZWSBKyMoV91ysS/zc7U+NX67Fq6N38ASB+QPSAX3LsU
         irYnEVTr3yGnclJ8SAco2nwgOnFdac4AUojCjlQDqMBpvkqoKMYFvt+VDsiedSyZkCS+
         YygitwZzoWtX2qEAmbcZTyfZgpsiTCyo9iY6qYGAC8MggHbLi0I3aOW8hIikqRpWlZxG
         KzeHM0FcIb0+pULJoW6skDK6KPe264FA+NHL/y6j5pwD2AlCLJGzmEX+v17WLHsXDB9A
         J1hQ==
X-Gm-Message-State: AOAM532rdVJHuoCxDsaJkeTU+jLKUilRIHjYSLI0i23kFyYDb21sIGjt
        wqYnboN3qN/YbqzS4VbDsRdDgGuw1PE=
X-Google-Smtp-Source: ABdhPJy92pUNk0vuThAHgG1KxnUNqELL/2Mc4x65Hyxv1JIWcnbmS+hS8GZ8i+88Ll6DtaYL/pxizDjGj2U=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:d607:: with SMTP id n7mr8053144ybg.96.1633745640889;
 Fri, 08 Oct 2021 19:14:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:25 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-33-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 32/43] KVM: VMX: Move preemption timer <=> hrtimer dance to
 common x86
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle the switch to/from the hypervisor/software timer when a vCPU is
blocking in common x86 instead of in VMX.  Even though VMX is the only
user of a hypervisor timer, the logic and all functions involved are
generic x86 (unless future CPUs do something completely different and
implement a hypervisor timer that runs regardless of mode).

Handling the switch in common x86 will allow for the elimination of the
pre/post_blocks hooks, and also lets KVM switch back to the hypervisor
timer if and only if it was in use (without additional params).  Add a
comment explaining why the switch cannot be deferred to kvm_sched_out()
or kvm_vcpu_block().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c |  6 +-----
 arch/x86/kvm/x86.c     | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b3bb2031a7ac..a24f19874716 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7464,16 +7464,12 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 
 static int vmx_pre_block(struct kvm_vcpu *vcpu)
 {
-	if (kvm_lapic_hv_timer_in_use(vcpu))
-		kvm_lapic_switch_to_sw_timer(vcpu);
-
 	return 0;
 }
 
 static void vmx_post_block(struct kvm_vcpu *vcpu)
 {
-	if (kvm_x86_ops.set_hv_timer)
-		kvm_lapic_switch_to_hv_timer(vcpu);
+
 }
 
 static void vmx_setup_mce(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0219acfd9cf..909e932a7ae7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9896,8 +9896,21 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
+	bool hv_timer;
+
 	if (!kvm_arch_vcpu_runnable(vcpu) &&
 	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
+		/*
+		 * Switch to the software timer before halt-polling/blocking as
+		 * the guest's timer may be a break event for the vCPU, and the
+		 * hypervisor timer runs only when the CPU is in guest mode.
+		 * Switch before halt-polling so that KVM recognizes an expired
+		 * timer before blocking.
+		 */
+		hv_timer = kvm_lapic_hv_timer_in_use(vcpu);
+		if (hv_timer)
+			kvm_lapic_switch_to_sw_timer(vcpu);
+
 		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 		if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
 			kvm_vcpu_halt(vcpu);
@@ -9905,6 +9918,9 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 			kvm_vcpu_block(vcpu);
 		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 
+		if (hv_timer)
+			kvm_lapic_switch_to_hv_timer(vcpu);
+
 		if (kvm_x86_ops.post_block)
 			static_call(kvm_x86_post_block)(vcpu);
 
@@ -10136,6 +10152,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			r = -EINTR;
 			goto out;
 		}
+		/*
+		 * It should be impossible for the hypervisor timer to be in
+		 * use before KVM has ever run the vCPU.
+		 */
+		WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
 		kvm_vcpu_block(vcpu);
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
-- 
2.33.0.882.g93a45727a2-goog

