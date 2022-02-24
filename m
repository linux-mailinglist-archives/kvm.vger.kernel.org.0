Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40EF14C35B6
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 20:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbiBXTUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 14:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbiBXTTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 14:19:55 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB8317289C
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 11:19:24 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id m15-20020a63580f000000b00370dc6cafe9so1550380pgb.5
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 11:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=77vvkSuzcDk7zhAWEb8twucG4UQRTj6P/P2a2+pyH2Q=;
        b=FiiEBYW65gPsOiKThbC8fvL5RuX2I3jgc28a+qA3vXDZjOq6Gw+PoEKzredP7K3ID0
         CfU/gq3AZ9OvMjiOECa8n/dIyFGaufwgpWSfrn0HF2OLE2WmOOwmh4VjsHSNQqarF4ad
         29/0LAg5KcmP1v+S0fR7GipN/sLtuPiUeZs1XU4Fgc2n3ZqdUJtpFg3kBU67VWG9LsEl
         8zjjYl8RmhQ20JwgzeMKVN0ANQ/D9j+KucOGSIqPAOhZRZRYUhRa1E96kJwnYGDtvQln
         kAJHT1F62k0S5cDraR7KfeUMJ7UxAvwRIcWcPEAuJQsx/zhkln78xNi2+twyV+Jc8Q4U
         rcWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=77vvkSuzcDk7zhAWEb8twucG4UQRTj6P/P2a2+pyH2Q=;
        b=AXy9mgWcP3EHKnDRJlUO79yHOFQiWpZmza/vv5l8RaZVAWmwE22IOXFik4VgaIJ71J
         sRXf8wGRZOFptje04/JBLUCz+wI+H84DayLMlUd2T8kk3oKB1+KBGUWHz7+ZPtxYTbRf
         s1XF0l1LMxV8OnDsrhJlP4TRtcHo9IB6uGAMLOQUeL9x3xgm7L2HdDcXQAxnxOPZUQn8
         edTSE18RYCSnaEB4G90rp2Ksa/nUveszKiYiUuWlCbzB3JJ9lB9EAw9CLqCr8i4jGQL/
         uI4kkCmEXHg9zrpP1NHdPqr12qFskSF4+q3Xv1GAI4ccoj+F1JCsAmhwzP6SXd+Ygt+V
         pjMA==
X-Gm-Message-State: AOAM533k9s/LsiNWPExupANAKdEJRCMqd0AHMmbbKgUcg9zOJmUyqR61
        AJbi0xtg3vntKY6OyWCUYTDjwbnBMpw=
X-Google-Smtp-Source: ABdhPJxLW6lOsAb3h8pc0hPSWq/uCMIdF/OvVb4876vbICb9U7jEj1oHgwhGbvsZ2qHOsJSTgSGtCbgKk8Y=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:8495:0:b0:4e1:6419:3d3c with SMTP id
 u21-20020aa78495000000b004e164193d3cmr4003515pfn.57.1645730364112; Thu, 24
 Feb 2022 11:19:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Feb 2022 19:19:17 +0000
In-Reply-To: <20220224191917.3508476-1-seanjc@google.com>
Message-Id: <20220224191917.3508476-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220224191917.3508476-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 2/2] Revert "KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <kernellwp@gmail.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert back to refreshing vmcs.HOST_CR3 immediately prior to VM-Enter.
The PCID (ASID) part of CR3 can be bumped without KVM being scheduled
out, as the kernel will switch CR3 during __text_poke(), e.g. in response
to a static key toggling.  If switch_mm_irqs_off() chooses a new ASID for
the mm associate with KVM, KVM will do VM-Enter => VM-Exit with a stale
vmcs.HOST_CR3.

Add a comment to explain why KVM must wait until VM-Enter is imminent to
refresh vmcs.HOST_CR3.

The following splat was captured by stashing vmcs.HOST_CR3 in kvm_vcpu
and adding a WARN in load_new_mm_cr3() to fire if a new ASID is being
loaded for the KVM-associated mm while KVM has a "running" vCPU:

  static void load_new_mm_cr3(pgd_t *pgdir, u16 new_asid, bool need_flush)
  {
	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();

	...

	WARN(vcpu && (vcpu->cr3 & GENMASK(11, 0)) != (new_mm_cr3 & GENMASK(11, 0)) &&
	     (vcpu->cr3 & PHYSICAL_PAGE_MASK) == (new_mm_cr3 & PHYSICAL_PAGE_MASK),
	     "KVM is hosed, loading CR3 = %lx, vmcs.HOST_CR3 = %lx", new_mm_cr3, vcpu->cr3);
  }

  ------------[ cut here ]------------
  KVM is hosed, loading CR3 = 8000000105393004, vmcs.HOST_CR3 = 105393003
  WARNING: CPU: 4 PID: 20717 at arch/x86/mm/tlb.c:291 load_new_mm_cr3+0x82/0xe0
  Modules linked in: vhost_net vhost vhost_iotlb tap kvm_intel
  CPU: 4 PID: 20717 Comm: stable Tainted: G        W         5.17.0-rc3+ #747
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:load_new_mm_cr3+0x82/0xe0
  RSP: 0018:ffffc9000489fa98 EFLAGS: 00010082
  RAX: 0000000000000000 RBX: 8000000105393004 RCX: 0000000000000027
  RDX: 0000000000000027 RSI: 00000000ffffdfff RDI: ffff888277d1b788
  RBP: 0000000000000004 R08: ffff888277d1b780 R09: ffffc9000489f8b8
  R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
  R13: ffff88810678a800 R14: 0000000000000004 R15: 0000000000000c33
  FS:  00007fa9f0e72700(0000) GS:ffff888277d00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 00000001001b5003 CR4: 0000000000172ea0
  Call Trace:
   <TASK>
   switch_mm_irqs_off+0x1cb/0x460
   __text_poke+0x308/0x3e0
   text_poke_bp_batch+0x168/0x220
   text_poke_finish+0x1b/0x30
   arch_jump_label_transform_apply+0x18/0x30
   static_key_slow_inc_cpuslocked+0x7c/0x90
   static_key_slow_inc+0x16/0x20
   kvm_lapic_set_base+0x116/0x190
   kvm_set_apic_base+0xa5/0xe0
   kvm_set_msr_common+0x2f4/0xf60
   vmx_set_msr+0x355/0xe70 [kvm_intel]
   kvm_set_msr_ignored_check+0x91/0x230
   kvm_emulate_wrmsr+0x36/0x120
   vmx_handle_exit+0x609/0x6c0 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0x146f/0x1b80
   kvm_vcpu_ioctl+0x279/0x690
   __x64_sys_ioctl+0x83/0xb0
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>
  ---[ end trace 0000000000000000 ]---

This reverts commit 15ad9762d69fd8e40a4a51828c1d6b0c1b8fbea0.

Fixes: 15ad9762d69f ("KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()")
Reported-by: Wanpeng Li <kernellwp@gmail.com>
Cc: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c |  8 +++++++-
 arch/x86/kvm/vmx/vmx.c    | 24 ++++++++++++++----------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c12f95004a72..dc822a1d403d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3055,7 +3055,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long cr4;
+	unsigned long cr3, cr4;
 	bool vm_fail;
 
 	if (!nested_early_check)
@@ -3078,6 +3078,12 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	 */
 	vmcs_writel(GUEST_RFLAGS, 0);
 
+	cr3 = __get_current_cr3_fast();
+	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
+		vmcs_writel(HOST_CR3, cr3);
+		vmx->loaded_vmcs->host_state.cr3 = cr3;
+	}
+
 	cr4 = cr4_read_shadow();
 	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
 		vmcs_writel(HOST_CR4, cr4);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index beb68cd28aca..b730d799c26e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1114,7 +1114,6 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_X86_64
 	int cpu = raw_smp_processor_id();
 #endif
-	unsigned long cr3;
 	unsigned long fs_base, gs_base;
 	u16 fs_sel, gs_sel;
 	int i;
@@ -1179,14 +1178,6 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #endif
 
 	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
-
-	/* Host CR3 including its PCID is stable when guest state is loaded. */
-	cr3 = __get_current_cr3_fast();
-	if (unlikely(cr3 != host_state->cr3)) {
-		vmcs_writel(HOST_CR3, cr3);
-		host_state->cr3 = cr3;
-	}
-
 	vmx->guest_state_loaded = true;
 }
 
@@ -6793,7 +6784,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long cr4;
+	unsigned long cr3, cr4;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
@@ -6836,6 +6827,19 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 	vcpu->arch.regs_dirty = 0;
 
+	/*
+	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
+	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
+	 * it switches back to the current->mm, which can occur in KVM context
+	 * when switching to a temporary mm to patch kernel code, e.g. if KVM
+	 * toggles a static key while handling a VM-Exit.
+	 */
+	cr3 = __get_current_cr3_fast();
+	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
+		vmcs_writel(HOST_CR3, cr3);
+		vmx->loaded_vmcs->host_state.cr3 = cr3;
+	}
+
 	cr4 = cr4_read_shadow();
 	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
 		vmcs_writel(HOST_CR4, cr4);
-- 
2.35.1.574.g5d30c73bfb-goog

