Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B04B31A907
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 01:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhBMAw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 19:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbhBMAwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 19:52:03 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED095C06121D
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:40 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id x4so1505142ybj.22
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Ieh3m7EQmvHAenB/lO365hnHz2Mjo7nHpxo7FvHHoBw=;
        b=mNuXGR4d6txwMt3SlFenFMnZv3aIX6yvtjONUJnLPMPhv1wOi6LCn4DDstnc+BgAfR
         zcoEDg6VUgK7a6RWWMDSJgC1CH/BdKj7XF+q57uWZPURSrqJpdkKCwtDX6Q7vO7MpwkW
         FUne44zNf0ElX+1aXYr4XBGIkfi3emdxvP/3THped4mZElx6G7cKm3+JIFrnYUp8IOlU
         6ZP785nI6R2m4TCfFvKdFw76c/bD3d7ZDtJb2d8qy3Mns/EGPOtI2ZKM0O5N4P2iWp6q
         mC/ZnEMcEqXG7Bitfwp0mIf875iMUA4yyjATr5fzqlcMwVY8DUsXalYYfhcIVzu0xvD/
         jR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Ieh3m7EQmvHAenB/lO365hnHz2Mjo7nHpxo7FvHHoBw=;
        b=P3yKp7AjsUJJqG25AjFvM7MPVQubzWbDNL63iejVoGQQetZuhGV2XwNY4yX/4oASLA
         AdtkcCUYLh18b0u71iavnL0sis/Twvl7D1d4kAyn/wdb0M5cOiRf8ihQ2n0NfbWka8V/
         BV+pxJ0hsPHJFNgwz6ogBWyTumsvLZ0zb4hZXvdlFt8Enq9QHBugq2un7vj0tWycTQPY
         w7istRNSUril/xb1npgBJJHpAr9LDFA/C4/s6B+UsMy7RosrS1UMoBbikPJj8P0Wic1H
         +aajEAeiHzIG9Kb3ZgNlfYD0gMvJ+2xR+pG8Bu4iqhs1XbLRIymm/rlvIh0PkoydKGuw
         Osyg==
X-Gm-Message-State: AOAM532+hJindXrsBQPFnNALufC9A0cW+4Hyze/JUHLjKj6wOW3h8f3M
        HZ+s4d9qqP8OVmy1kHbdSXrv3+OKyCM=
X-Google-Smtp-Source: ABdhPJwTkYoQFr39i7NoXmnOU+dg9Dn93Bld3ArJYdgab0PwxQiWSWu+mp0scIpzemMdicfiwZLRRV4zHEc=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a25:db48:: with SMTP id g69mr7712789ybf.109.1613177440250;
 Fri, 12 Feb 2021 16:50:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 16:50:09 -0800
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Message-Id: <20210213005015.1651772-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210213005015.1651772-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 08/14] KVM: x86/mmu: Make dirty log size hook (PML) a value,
 not a function
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Store the vendor-specific dirty log size in a variable, there's no need
to wrap it in a function since the value is constant after
hardware_setup() runs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 -
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/mmu/mmu.c             | 5 +----
 arch/x86/kvm/vmx/vmx.c             | 9 ++-------
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 355a2ab8fc09..28c07cc01474 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -97,7 +97,6 @@ KVM_X86_OP_NULL(slot_enable_log_dirty)
 KVM_X86_OP_NULL(slot_disable_log_dirty)
 KVM_X86_OP_NULL(flush_log_dirty)
 KVM_X86_OP_NULL(enable_log_dirty_pt_masked)
-KVM_X86_OP_NULL(cpu_dirty_log_size)
 KVM_X86_OP_NULL(pre_block)
 KVM_X86_OP_NULL(post_block)
 KVM_X86_OP_NULL(vcpu_blocking)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 84499aad01a4..fb59933610d9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1294,7 +1294,7 @@ struct kvm_x86_ops {
 	void (*enable_log_dirty_pt_masked)(struct kvm *kvm,
 					   struct kvm_memory_slot *slot,
 					   gfn_t offset, unsigned long mask);
-	int (*cpu_dirty_log_size)(void);
+	int cpu_dirty_log_size;
 
 	/* pmu operations of sub-arch */
 	const struct kvm_pmu_ops *pmu_ops;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d5849a0e3de1..6c32e8e0f720 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1294,10 +1294,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 
 int kvm_cpu_dirty_log_size(void)
 {
-	if (kvm_x86_ops.cpu_dirty_log_size)
-		return static_call(kvm_x86_cpu_dirty_log_size)();
-
-	return 0;
+	return kvm_x86_ops.cpu_dirty_log_size;
 }
 
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b47ed3f412ef..f843707dd7df 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7650,11 +7650,6 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
-static int vmx_cpu_dirty_log_size(void)
-{
-	return enable_pml ? PML_ENTITY_NUM : 0;
-}
-
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -7758,6 +7753,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.slot_disable_log_dirty = vmx_slot_disable_log_dirty,
 	.flush_log_dirty = vmx_flush_log_dirty,
 	.enable_log_dirty_pt_masked = vmx_enable_log_dirty_pt_masked,
+	.cpu_dirty_log_size = PML_ENTITY_NUM,
 
 	.pre_block = vmx_pre_block,
 	.post_block = vmx_post_block,
@@ -7785,7 +7781,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
-	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 };
@@ -7907,7 +7902,7 @@ static __init int hardware_setup(void)
 		vmx_x86_ops.slot_disable_log_dirty = NULL;
 		vmx_x86_ops.flush_log_dirty = NULL;
 		vmx_x86_ops.enable_log_dirty_pt_masked = NULL;
-		vmx_x86_ops.cpu_dirty_log_size = NULL;
+		vmx_x86_ops.cpu_dirty_log_size = 0;
 	}
 
 	if (!cpu_has_vmx_preemption_timer())
-- 
2.30.0.478.g8a0d178c01-goog

