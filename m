Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8E3480DE5
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 00:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237768AbhL1XYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 18:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbhL1XYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Dec 2021 18:24:43 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFF3C061574
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 15:24:42 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b4-20020a17090a6e0400b001b179d36a57so16526876pjk.6
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 15:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=lXOCiSUjAOZ34Jj0Nyj7RQEDujOi8kdviMryNWrmPbE=;
        b=j7LsVQbBIxQMwmKpw4VwDbzIkcGAyglJn91wnZMXP6V9BNwSdIFTGp6Z6lmXbkqqfu
         DjStgYMd5pYnVxnkazRAkxlCaNLNtjnjhb5PFbVYNuwqumDQNLHbdx9YQ00JyjZeZwm4
         RRlerzdTTmw86bge5mO6GqanyiWNmNEjGmBP2evMzvVujjg/jeueq0MBp/Ux4GgS+POu
         1idEIBM1DXaCbg74c9HgPt8DGqaqMr3b2r3DyvP736Gxnj11H5F+qirxoICiWR9KyIk0
         CuxCDDSzIxciL4dFQR0aToz5e5ZaQfgFLC2ADed1FPd/tyg46Hi0JnERwcq9E5WBoRd6
         67DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=lXOCiSUjAOZ34Jj0Nyj7RQEDujOi8kdviMryNWrmPbE=;
        b=0pjsCl/xRXCHaoxp3CYxcA8JiZWeX1uCJrqPHEeKiz6Vh1PDqbiJCJCHit3lpE6B3u
         JMR59aW4q3EWb3AuuUihURIF3olxbIA5JWiesQxYxnJnCDfbMfsZQA+3USbKywevksUt
         fwGrfMDTjgp7tqBiORtEGekvMACPasdznKDwUc0uo+yOHykRxl6C2/PGzf1fjfAJV+HA
         /SzWnlg6+0ymhwCiydOv7ZI49NUW7KuTI/g7JpStbYuYbz6Wt/arTkbETBJjQ/h7mvbQ
         k9vk5fwqWmj3hd2IuLOR37xH0jjBKt7k++Vy6UaTU4orXp3igHipgqELeAD4HmKk8iy0
         nEvg==
X-Gm-Message-State: AOAM530TUoOZxqeWAnMWYWfTOnOF64Zz59FT7n7bo899pLTfcFWw8muw
        koZPpOUV050VJ2k2WC3+ZuQrQvqhUlE=
X-Google-Smtp-Source: ABdhPJzTGYVOggBqNEn2z3mXiIKBL1Nc0MyqR75hnX8dIxIeHF+nsvcAIxSD1WRiWwg0WmV1IWUGSL3eVwc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:760e:b0:149:202b:4a9 with SMTP id
 k14-20020a170902760e00b00149202b04a9mr24078254pll.16.1640733882513; Tue, 28
 Dec 2021 15:24:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 28 Dec 2021 23:24:36 +0000
In-Reply-To: <20211228232437.1875318-1-seanjc@google.com>
Message-Id: <20211228232437.1875318-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211228232437.1875318-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH 1/2] KVM: VMX: Reject KVM_RUN if emulation is required with
 pending exception
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+82112403ace4cbd780d8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reject KVM_RUN if emulation is required (because VMX is running without
unrestricted guest) and an exception is pending, as KVM doesn't support
emulating exceptions except when emulating real mode via vm86.  The vCPU
is hosed either way, but letting KVM_RUN proceed triggers a WARN due to
the impossible condition.  Alternatively, the WARN could be removed, but
then userspace and/or KVM bugs would result in the vCPU silently running
in a bad state, which isn't very friendly to users.

Originally, the bug was hit by syzkaller with a nested guest as that
doesn't require kvm_intel.unrestricted_guest=0.  That particular flavor
is likely fixed by commit cd0e615c49e5 ("KVM: nVMX: Synthesize
TRIPLE_FAULT for L2 if emulation is required"), but it's trivial to
trigger the WARN with a non-nested guest, and userspace can likely force
bad state via ioctls() for a nested guest as well.

Checking for the impossible condition needs to be deferred until KVM_RUN
because KVM can't force specific ordering between ioctls.  E.g. clearing
exception.pending in KVM_SET_SREGS doesn't prevent userspace from setting
it in KVM_SET_VCPU_EVENTS, and disallowing KVM_SET_VCPU_EVENTS with
emulation_required would prevent userspace from queuing an exception and
then stuffing sregs.  Note, if KVM were to try and detect/prevent the
condition prior to KVM_RUN, handle_invalid_guest_state() and/or
handle_emulation_failure() would need to be modified to clear the pending
exception prior to exiting to userspace.

 ------------[ cut here ]------------
 WARNING: CPU: 6 PID: 137812 at arch/x86/kvm/vmx/vmx.c:1623 vmx_queue_exception+0x14f/0x160 [kvm_intel]
 CPU: 6 PID: 137812 Comm: vmx_invalid_nes Not tainted 5.15.2-7cc36c3e14ae-pop #279
 Hardware name: ASUS Q87M-E/Q87M-E, BIOS 1102 03/03/2014
 RIP: 0010:vmx_queue_exception+0x14f/0x160 [kvm_intel]
 Code: <0f> 0b e9 fd fe ff ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
 RSP: 0018:ffffa45c83577d38 EFLAGS: 00010202
 RAX: 0000000000000003 RBX: 0000000080000006 RCX: 0000000000000006
 RDX: 0000000000000000 RSI: 0000000000010002 RDI: ffff9916af734000
 RBP: ffff9916af734000 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000006
 R13: 0000000000000000 R14: ffff9916af734038 R15: 0000000000000000
 FS:  00007f1e1a47c740(0000) GS:ffff99188fb80000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f1e1a6a8008 CR3: 000000026f83b005 CR4: 00000000001726e0
 Call Trace:
  kvm_arch_vcpu_ioctl_run+0x13a2/0x1f20 [kvm]
  kvm_vcpu_ioctl+0x279/0x690 [kvm]
  __x64_sys_ioctl+0x83/0xb0
  do_syscall_64+0x3b/0xc0
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: syzbot+82112403ace4cbd780d8@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/svm.c             |  6 ++++++
 arch/x86/kvm/vmx/vmx.c             | 22 ++++++++++++++++++++--
 arch/x86/kvm/x86.c                 | 12 +++++++++---
 5 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 37624a9e3e40..631d5040b31e 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -55,6 +55,7 @@ KVM_X86_OP_NULL(tlb_remote_flush)
 KVM_X86_OP_NULL(tlb_remote_flush_with_range)
 KVM_X86_OP(tlb_flush_gva)
 KVM_X86_OP(tlb_flush_guest)
+KVM_X86_OP(vcpu_pre_run)
 KVM_X86_OP(run)
 KVM_X86_OP_NULL(handle_exit)
 KVM_X86_OP_NULL(skip_emulated_instruction)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5d97f4adc1cb..fad555b726a9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1379,6 +1379,7 @@ struct kvm_x86_ops {
 	 */
 	void (*tlb_flush_guest)(struct kvm_vcpu *vcpu);
 
+	int (*vcpu_pre_run)(struct kvm_vcpu *vcpu);
 	enum exit_fastpath_completion (*run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6cb38044a860..bb9748d14f79 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3594,6 +3594,11 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	svm_complete_interrupts(vcpu);
 }
 
+static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
+{
+	return 1;
+}
+
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
@@ -4423,6 +4428,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.tlb_flush_gva = svm_flush_tlb_gva,
 	.tlb_flush_guest = svm_flush_tlb,
 
+	.vcpu_pre_run = svm_vcpu_pre_run,
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe06b02994e6..64d32fb728c9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5386,6 +5386,14 @@ static int handle_nmi_window(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static bool vmx_emulation_required_with_pending_exception(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return vmx->emulation_required && !vmx->rmode.vm86_active &&
+	       vcpu->arch.exception.pending;
+}
+
 static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -5405,8 +5413,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		if (!kvm_emulate_instruction(vcpu, 0))
 			return 0;
 
-		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
-		    vcpu->arch.exception.pending) {
+		if (vmx_emulation_required_with_pending_exception(vcpu)) {
 			kvm_prepare_emulation_failure_exit(vcpu);
 			return 0;
 		}
@@ -5428,6 +5435,16 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu)
+{
+	if (vmx_emulation_required_with_pending_exception(vcpu)) {
+		kvm_prepare_emulation_failure_exit(vcpu);
+		return 0;
+	}
+
+	return 1;
+}
+
 static void grow_ple_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7623,6 +7640,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.tlb_flush_gva = vmx_flush_tlb_gva,
 	.tlb_flush_guest = vmx_flush_tlb_guest,
 
+	.vcpu_pre_run = vmx_vcpu_pre_run,
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c194a8cbd25f..3b58649b7067 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10317,10 +10317,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	} else
 		WARN_ON(vcpu->arch.pio.count || vcpu->mmio_needed);
 
-	if (kvm_run->immediate_exit)
+	if (kvm_run->immediate_exit) {
 		r = -EINTR;
-	else
-		r = vcpu_run(vcpu);
+		goto out;
+	}
+
+	r = static_call(kvm_x86_vcpu_pre_run)(vcpu);
+	if (r <= 0)
+		goto out;
+
+	r = vcpu_run(vcpu);
 
 out:
 	kvm_put_guest_fpu(vcpu);
-- 
2.34.1.448.ga2b2bfdf31-goog

