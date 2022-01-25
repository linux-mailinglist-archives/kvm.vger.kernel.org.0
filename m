Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7E449BE2A
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 23:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiAYWEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 17:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbiAYWEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 17:04:00 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB375C061744
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 14:04:00 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id o9-20020a170903210900b0014b36bee5b9so3398073ple.0
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 14:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=iGLX1nMTdQXwKCljS0xZ9EDrg9qdOcQaXDmOY0TVKEc=;
        b=RvgXeQqUhymXWW+mcLDi7Xa3qJjEV44K/VQZz/B0wiFZjNJXJIK8GuMtuu4wl1PIS1
         w10EyioiJgKsyA9yFcTaBMsVH5ASrdwp8iANijZ95lmSpiuj8ktaD5DjTs5UM6bEQOEI
         aFQgXFBCdQB9XDBv+i5CK3aHVmnu67tmFAHgBWg6usJ3OWVNOtH+O+Uw9Z/7j9dsofGo
         EhBu07m7Dm8J/BGeQSGxGoShxinsp3spXh41qScQ05o/GE34LKVZ/tUKCyR4tvr+TlNk
         CffZW7+iikI8A7cwcCdg0EKA+cRWjIoC0oBGnZQl4EKG/rLFw7OrsvtC51F4ozS8h72V
         jnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=iGLX1nMTdQXwKCljS0xZ9EDrg9qdOcQaXDmOY0TVKEc=;
        b=UjXwL6y9GLdXrz5iACNlI5qwt1nywM6nEOHYbcSi0DAeb5kFhweVaG9w46ZwYSYFQ5
         azr2zqTK1SCDgAh4g9jVieubxbMQ39eMgPv5E2TobUVODovCxTGmGXIVQvY1jvgB4B8Q
         FF5hzTd1iUEdGoBadWJlK8HWqI/WZjd4Ciax3gd6Ttl56CEZdYiGGxDBxcIvXQIeup88
         9/nsmFdgDKuD9TuAG+8/RpWEiM9/1ipC8xKv1VBipvdPJH29GxdESZ0yRtq+q28MjJTo
         jwCESjMJcaTpGg7cmZxD5TCC7ZmRHxH3svGnN0a48cZMT0fzKz0fSXCt8AAuAnVtlMob
         i1cw==
X-Gm-Message-State: AOAM533LcClJuBZwn9hqjDvmGCWSRNk7ljTrxjzJqjgDYVc/2g8MT5mK
        aGPlm7YBGtvIKkgwMqjrlhoJTYSPmhI=
X-Google-Smtp-Source: ABdhPJwe8knRJEMoWdP667Wv4h9swXHBTSVyTQxeD8SnbjpThw9hmIMUfX/XUphfz/NAsyLFqpXjGWhY3t4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:234d:: with SMTP id
 ms13mr5596133pjb.44.1643148240297; Tue, 25 Jan 2022 14:04:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 25 Jan 2022 22:03:58 +0000
Message-Id: <20220125220358.2091737-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH] KVM: x86: Forcibly leave nested virt when SMM state is toggled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Forcibly leave nested virtualization operation if userspace toggles SMM
state via KVM_SET_VCPU_EVENTS or KVM_SYNC_X86_EVENTS.  If userspace
forces the vCPU out of SMM while it's post-VMXON and then injects an SMI,
vmx_enter_smm() will overwrite vmx->nested.smm.vmxon and end up with both
vmxon=false and smm.vmxon=false, but all other nVMX state allocated.

Don't attempt to gracefully handle the transition as (a) most transitions
are nonsencial, e.g. forcing SMM while L2 is running, (b) there isn't
sufficient information to handle all transitions, e.g. SVM wants access
to the SMRAM save state, and (c) KVM_SET_VCPU_EVENTS must precede
KVM_SET_NESTED_STATE during state restore as the latter disallows putting
the vCPU into L2 if SMM is active, and disallows tagging the vCPU as
being post-VMXON in SMM if SMM is not active.

Abuse of KVM_SET_VCPU_EVENTS manifests as a WARN and memory leak in nVMX
due to failure to free vmcs01's shadow VMCS, but the bug goes far beyond
just a memory leak, e.g. toggling SMM on while L2 is active puts the vCPU
in an architecturally impossible state.

  WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
  WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
  Modules linked in:
  CPU: 1 PID: 3606 Comm: syz-executor725 Not tainted 5.17.0-rc1-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
  RIP: 0010:free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
  Code: <0f> 0b eb b3 e8 8f 4d 9f 00 e9 f7 fe ff ff 48 89 df e8 92 4d 9f 00
  Call Trace:
   <TASK>
   kvm_arch_vcpu_destroy+0x72/0x2f0 arch/x86/kvm/x86.c:11123
   kvm_vcpu_destroy arch/x86/kvm/../../../virt/kvm/kvm_main.c:441 [inline]
   kvm_destroy_vcpus+0x11f/0x290 arch/x86/kvm/../../../virt/kvm/kvm_main.c:460
   kvm_free_vcpus arch/x86/kvm/x86.c:11564 [inline]
   kvm_arch_destroy_vm+0x2e8/0x470 arch/x86/kvm/x86.c:11676
   kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1217 [inline]
   kvm_put_kvm+0x4fa/0xb00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1250
   kvm_vm_release+0x3f/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1273
   __fput+0x286/0x9f0 fs/file_table.c:311
   task_work_run+0xdd/0x1a0 kernel/task_work.c:164
   exit_task_work include/linux/task_work.h:32 [inline]
   do_exit+0xb29/0x2a30 kernel/exit.c:806
   do_group_exit+0xd2/0x2f0 kernel/exit.c:935
   get_signal+0x4b0/0x28c0 kernel/signal.c:2862
   arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
   handle_signal_work kernel/entry/common.c:148 [inline]
   exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
   exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
   __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
   syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
   do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>

Cc: stable@vger.kernel.org
Reported-by: syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Peeking at QEMU source, AFAICT QEMU restores nested state before events,
but I don't see how that can possibly work.  I assume QEMU does something
where it restores the "run" state first and then does a full restore?

 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/nested.c       | 9 +++++----
 arch/x86/kvm/svm/svm.c          | 2 +-
 arch/x86/kvm/svm/svm.h          | 2 +-
 arch/x86/kvm/vmx/nested.c       | 1 +
 arch/x86/kvm/x86.c              | 4 +++-
 6 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 682ad02a4e58..df22b04b11c3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1495,6 +1495,7 @@ struct kvm_x86_ops {
 };
 
 struct kvm_x86_nested_ops {
+	void (*leave_nested)(struct kvm_vcpu *vcpu);
 	int (*check_events)(struct kvm_vcpu *vcpu);
 	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
 	void (*triple_fault)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cf206855ebf0..1218b5a342fc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -983,9 +983,9 @@ void svm_free_nested(struct vcpu_svm *svm)
 /*
  * Forcibly leave nested mode in order to be able to reset the VCPU later on.
  */
-void svm_leave_nested(struct vcpu_svm *svm)
+void svm_leave_nested(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (is_guest_mode(vcpu)) {
 		svm->nested.nested_run_pending = 0;
@@ -1411,7 +1411,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
-		svm_leave_nested(svm);
+		svm_leave_nested(vcpu);
 		svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
 		return 0;
 	}
@@ -1478,7 +1478,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 */
 
 	if (is_guest_mode(vcpu))
-		svm_leave_nested(svm);
+		svm_leave_nested(vcpu);
 	else
 		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
 
@@ -1532,6 +1532,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_x86_nested_ops svm_nested_ops = {
+	.leave_nested = svm_leave_nested,
 	.check_events = svm_check_nested_events,
 	.triple_fault = nested_svm_triple_fault,
 	.get_nested_state_pages = svm_get_nested_state_pages,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6d31d357a83b..78123ed3906f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -290,7 +290,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
 		if (!(efer & EFER_SVME)) {
-			svm_leave_nested(svm);
+			svm_leave_nested(vcpu);
 			svm_set_gif(svm, true);
 			/* #GP intercept is still needed for vmware backdoor */
 			if (!enable_vmware_backdoor)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 47ef8f4a9358..c55d9936bb8b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -525,7 +525,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 
 int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
 			 u64 vmcb_gpa, struct vmcb *vmcb12, bool from_vmrun);
-void svm_leave_nested(struct vcpu_svm *svm);
+void svm_leave_nested(struct kvm_vcpu *vcpu);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f235f77cbc03..7eebfdf7204f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6771,6 +6771,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 }
 
 struct kvm_x86_nested_ops vmx_nested_ops = {
+	.leave_nested = vmx_leave_nested,
 	.check_events = vmx_check_nested_events,
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.triple_fault = nested_vmx_triple_fault,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55518b7d3b96..22040c682d4a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4860,8 +4860,10 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		vcpu->arch.apic->sipi_vector = events->sipi_vector;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
-		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm)
+		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
+			kvm_x86_ops.nested_ops->leave_nested(vcpu);
 			kvm_smm_changed(vcpu, events->smi.smm);
+		}
 
 		vcpu->arch.smi_pending = events->smi.pending;
 

base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4
-- 
2.35.0.rc0.227.g00780c9af4-goog

