Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10251AE807
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 00:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgDQWPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 18:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728459AbgDQWPI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 18:15:08 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C85C061A0F
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 15:15:08 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id w16so3043970plq.1
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 15:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fUd4e7ib6miSI3t5irBL1ImGs5/WYOOO3j+GPX3G4w8=;
        b=lRcq3dUuEu5g2QMOkNKjKJkQrMD5KPtroJhHUhI1PIxhhGT/r5NRAqCueq6tDc/XTt
         aJ9rUaaUcg7abTz44b7JUfupMPrSgqg3bcCov2XaPBLBiLUuhYIsqLUbzTg7KwmXoqmX
         9tFdWZj4VetAfDGu3VVsbEQkIBHYfvBt5MppI6CVmE3eSgJ6RxqLlwUi45BWMaFG0u9M
         8hHVAUC9u/1Dj/BRlwe08QkG35bZtA0RoTbmyQCROtsBjWqEwjsHrR91dcil48pQ6BaA
         F9yFoCrgzLY0ttvkyN5WXkZTDlzq8ATCXbilIW951vO/4fPcSB96TkWVJxUFYSUdYsez
         XKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fUd4e7ib6miSI3t5irBL1ImGs5/WYOOO3j+GPX3G4w8=;
        b=pFreq1QP3SlISCDpiApIzurm1NG7t60z6C12PRc8/bjWXBHPwwEgMdCogSuhWA63/0
         HFSe7hBGRaXtwYvjwxfZN2GAfmjmTRn5sfHSMHwWIJNuniA03I6ytcUN1OHwAy2ctR8D
         WZD5sD4fg7RRZ+6gfpLdu63fzCBHRDHiD2IVzVdkGUxM5VH3mwDaH3CJQ+mwwMACs2Ca
         QATgroRWAkOt9jkNyLr2KRDUGdHu/JyeygqYkPr8ZFGQyL8YR2PF9g84Cwip5EjffAbK
         Lpqo1wpR+C0ePuajaeudcSrkkqEKEokHOyOLEBq/ielK2euLcaaPphM61vmGEJ3HHtOi
         Mafg==
X-Gm-Message-State: AGi0PuYQ3J6sJqkACyJpJCDQidblazjhclyK5MANwD8rAgcXsIRwLoEj
        O0UrKowdtnazEA/Hkndy300PXjQwE+vvPg==
X-Google-Smtp-Source: APiQypLSLh6jSBxbBtX2SkrqDIEjfwxQnKC5GoW9CO6XBLKWtU7T2gax2Vry4WQug150Tqnv8SHx8yFoe3ffkA==
X-Received: by 2002:a17:90a:210b:: with SMTP id a11mr7283677pje.31.1587161708131;
 Fri, 17 Apr 2020 15:15:08 -0700 (PDT)
Date:   Fri, 17 Apr 2020 15:14:46 -0700
Message-Id: <20200417221446.108733-1-jcargill@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH] kvm: add capability for halt polling
From:   Jon Cargille <jcargill@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     David Matlack <dmatlack@google.com>,
        Jon Cargille <jcargill@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

KVM_CAP_HALT_POLL is a per-VM capability that lets userspace
control the halt-polling time, allowing halt-polling to be tuned or
disabled on particular VMs.

With dynamic halt-polling, a VM's VCPUs can poll from anywhere from
[0, halt_poll_ns] on each halt. KVM_CAP_HALT_POLL sets the
upper limit on the poll time.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jon Cargille <jcargill@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
 include/linux/kvm_host.h       |  1 +
 include/uapi/linux/kvm.h       |  1 +
 virt/kvm/kvm_main.c            | 19 +++++++++++++++----
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index efbbe570aa9b7b..d871dacb984e98 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5802,6 +5802,23 @@ If present, this capability can be enabled for a VM, meaning that KVM
 will allow the transition to secure guest mode.  Otherwise KVM will
 veto the transition.
 
+7.20 KVM_CAP_HALT_POLL
+----------------------
+
+:Architectures: all
+:Target: VM
+:Parameters: args[0] is the maximum poll time in nanoseconds
+:Returns: 0 on success; -1 on error
+
+This capability overrides the kvm module parameter halt_poll_ns for the
+target VM.
+
+VCPU polling allows a VCPU to poll for wakeup events instead of immediately
+scheduling during guest halts. The maximum time a VCPU can spend polling is
+controlled by the kvm module parameter halt_poll_ns. This capability allows
+the maximum halt time to specified on a per-VM basis, effectively overriding
+the module parameter for the target VM.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6d58beb65454f7..922b24ce5e7297 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -503,6 +503,7 @@ struct kvm {
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
+	unsigned int max_halt_poll_ns;
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 428c7dde6b4b37..ac9eba0289d1b6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_HALT_POLL 182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 74bdb7bf32952e..ec038a9e60a275 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -710,6 +710,8 @@ static struct kvm *kvm_create_vm(unsigned long type)
 			goto out_err_no_arch_destroy_vm;
 	}
 
+	kvm->max_halt_poll_ns = halt_poll_ns;
+
 	r = kvm_arch_init_vm(kvm, type);
 	if (r)
 		goto out_err_no_arch_destroy_vm;
@@ -2716,15 +2718,16 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	if (!kvm_arch_no_poll(vcpu)) {
 		if (!vcpu_valid_wakeup(vcpu)) {
 			shrink_halt_poll_ns(vcpu);
-		} else if (halt_poll_ns) {
+		} else if (vcpu->kvm->max_halt_poll_ns) {
 			if (block_ns <= vcpu->halt_poll_ns)
 				;
 			/* we had a long block, shrink polling */
-			else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
+			else if (vcpu->halt_poll_ns &&
+					block_ns > vcpu->kvm->max_halt_poll_ns)
 				shrink_halt_poll_ns(vcpu);
 			/* we had a short halt and our poll time is too small */
-			else if (vcpu->halt_poll_ns < halt_poll_ns &&
-				block_ns < halt_poll_ns)
+			else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
+					block_ns < vcpu->kvm->max_halt_poll_ns)
 				grow_halt_poll_ns(vcpu);
 		} else {
 			vcpu->halt_poll_ns = 0;
@@ -3516,6 +3519,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_IOEVENTFD_ANY_LENGTH:
 	case KVM_CAP_CHECK_EXTENSION_VM:
 	case KVM_CAP_ENABLE_CAP_VM:
+	case KVM_CAP_HALT_POLL:
 		return 1;
 #ifdef CONFIG_KVM_MMIO
 	case KVM_CAP_COALESCED_MMIO:
@@ -3566,6 +3570,13 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 		return 0;
 	}
 #endif
+	case KVM_CAP_HALT_POLL: {
+		if (cap->flags || cap->args[0] != (unsigned int)cap->args[0])
+			return -EINVAL;
+
+		kvm->max_halt_poll_ns = cap->args[0];
+		return 0;
+	}
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
-- 
2.26.1.301.g55bc3eb7cb9-goog

