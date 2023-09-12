Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3E979DCEC
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 02:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbjIMACY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 20:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjIMACY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 20:02:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1B31705
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 17:02:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d80db590b1cso773943276.0
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 17:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694563339; x=1695168139; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=B8O84M8nqeVG0BSKRDFPvsNkITeT3KIGbDhN0gQ/CcA=;
        b=z3A/JYrUH6aUjaVFObA3A48277ymlDZMje7jhmuTmvsvav8LEzusi2eid4en/p1I+B
         1jfla3LGDc2CM6iHWJH0biY+abhCFMApSWvh/Bqu0CxM/ACj3mVF4bRMweS4nvQtU1Mr
         WoJ4mhvbLuLXsvdz7QTnjSVW04NQLJ1H29p7kzXQQjNFqokdY091MfAfWlZbygkwTex2
         0eNPyY21/nTU/87Yi6vTwvPNF8b5bMELPbcWsOBtHqhsxJvxIM/6Oej3e9GdNJS624dZ
         LTyWLkWkSEjWN3VAMtHxgNNVFDlG8kTQXodR2pIgTNuYozEQoc9Fye8a3v8ZMc0zgyou
         uQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694563339; x=1695168139;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B8O84M8nqeVG0BSKRDFPvsNkITeT3KIGbDhN0gQ/CcA=;
        b=WRzC9fQyCnwop0+FqgusJKk2uFxHZIbmPoDVJENeUBzu3iyQN8LKOZ+aQrTWimLl8c
         xfzL0RYjAgeKNQ+KjuqPCoWuxtfxeqtXxfD7fVASeXSvtJq8EAxc+hxagehAuffAj+Bv
         RilmUfRBO1rcbZ9ZlxQkbHHcQkoklW5gQHViVJyFmNtD6q+AjBaHKinnmEYRlGNVfGjB
         dJFYI/CDg7rFtGbbNe9AsrXbcEUZS0Pvp03drIdf9GMSKI0C9Cuszo2im7oGMCTA6Lgb
         XZ98H07LS/bzM6uK3GPzfuApnIpLMNAQQ/ArvJ8N8D0hyHT3OmXrJFdZ7WVYMiaWGSBf
         fX1Q==
X-Gm-Message-State: AOJu0Yy5/oJRxZ/IMcg8942ITg6/yEcKkig8CnX4yXQIxnhs9hPYk/Se
        sm8gJgp+j+zolNSTWG8E9ntUQAdBGg==
X-Google-Smtp-Source: AGHT+IGBoQiQuWTki2UGlib6khGZDCCRNfaIToyv6J5RX2gRNwbvmdUBIqgi7S5AFfYW/udiKrZd/4LqYA==
X-Received: from hshan17.roam.corp.google.com ([2620:15c:211:201:2a7f:c6c4:6e3:ac5c])
 (user=hshan job=sendgmr) by 2002:a05:6902:1022:b0:ca3:3341:6315 with SMTP id
 x2-20020a056902102200b00ca333416315mr46020ybt.0.1694563339330; Tue, 12 Sep
 2023 17:02:19 -0700 (PDT)
Date:   Tue, 12 Sep 2023 16:55:45 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230913000215.478387-1-hshan@google.com>
Subject: [PATCH v3] KVM: x86: Fix lapic timer interrupt lost after loading a snapshot.
From:   Haitao Shan <hshan@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Haitao Shan <hshan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running android emulator (which is based on QEMU 2.12) on
certain Intel hosts with kernel version 6.3-rc1 or above, guest
will freeze after loading a snapshot. This is almost 100%
reproducible. By default, the android emulator will use snapshot
to speed up the next launching of the same android guest. So
this breaks the android emulator badly.

I tested QEMU 8.0.4 from Debian 12 with an Ubuntu 22.04 guest by
running command "loadvm" after "savevm". The same issue is
observed. At the same time, none of our AMD platforms is impacted.
More experiments show that loading the KVM module with
"enable_apicv=false" can workaround it.

The issue started to show up after commit 8e6ed96cdd50 ("KVM: x86:
fire timer when it is migrated and expired, and in oneshot mode").
However, as is pointed out by Sean Christopherson, it is introduced
by commit 967235d32032 ("KVM: vmx: clear pending interrupts on
KVM_SET_LAPIC"). commit 8e6ed96cdd50 ("KVM: x86: fire timer when
it is migrated and expired, and in oneshot mode") just makes it
easier to hit the issue.

Having both commits, the oneshot lapic timer gets fired immediately
inside the KVM_SET_LAPIC call when loading the snapshot. On Intel
platforms with APIC virtualization and posted interrupt processing,
this eventually leads to setting the corresponding PIR bit. However,
the whole PIR bits get cleared later in the same KVM_SET_LAPIC call
by apicv_post_state_restore. This leads to timer interrupt lost.

The fix is to move vmx_apicv_post_state_restore to the beginning of
the KVM_SET_LAPIC call and rename to vmx_apicv_pre_state_restore.
What vmx_apicv_post_state_restore does is actually clearing any
former apicv state and this behavior is more suitable to carry out
in the beginning.

Fixes: 967235d32032 ("KVM: vmx: clear pending interrupts on KVM_SET_LAPIC")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Haitao Shan <hshan@google.com>
---
v1 ---> v2:
	Rewrite the fix following Sean's suggestion.

v2 ---> v3:
	Rename and move apicv_post_state_restore in both
	kvm_lapic_reset and kvm_apic_set_state
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/lapic.c               | 4 ++++
 arch/x86/kvm/vmx/vmx.c             | 4 ++--
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e3054e3e46d5..9b419f0de713 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -108,6 +108,7 @@ KVM_X86_OP_OPTIONAL(vcpu_blocking)
 KVM_X86_OP_OPTIONAL(vcpu_unblocking)
 KVM_X86_OP_OPTIONAL(pi_update_irte)
 KVM_X86_OP_OPTIONAL(pi_start_assignment)
+KVM_X86_OP_OPTIONAL(apicv_pre_state_restore)
 KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
 KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
 KVM_X86_OP_OPTIONAL(set_hv_timer)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bc146dfd38d..af33fdc7377f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1691,6 +1691,7 @@ struct kvm_x86_ops {
 	int (*pi_update_irte)(struct kvm *kvm, unsigned int host_irq,
 			      uint32_t guest_irq, bool set);
 	void (*pi_start_assignment)(struct kvm *kvm);
+	void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
 	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a983a16163b1..c4ae3ce15f4e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2649,6 +2649,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	u64 msr_val;
 	int i;
 
+	static_call_cond(kvm_x86_apicv_pre_state_restore)(vcpu);
+
 	if (!init_event) {
 		msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
 		if (kvm_vcpu_is_reset_bsp(vcpu))
@@ -2956,6 +2958,8 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	int r;
 
+	static_call_cond(kvm_x86_apicv_pre_state_restore)(vcpu);
+
 	kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
 	/* set SPIV separately to get count of SW disabled APICs right */
 	apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV)));
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index df461f387e20..4fcf2448762c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6911,7 +6911,7 @@ static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	vmcs_write64(EOI_EXIT_BITMAP3, eoi_exit_bitmap[3]);
 }
 
-static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
+static void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -8276,7 +8276,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
-	.apicv_post_state_restore = vmx_apicv_post_state_restore,
+	.apicv_pre_state_restore = vmx_apicv_pre_state_restore,
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
 	.hwapic_isr_update = vmx_hwapic_isr_update,
-- 
2.42.0.283.g2d96d420d3-goog

