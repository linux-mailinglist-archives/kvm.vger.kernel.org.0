Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286B85F3A2F
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 01:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJCX5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 19:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiJCX5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 19:57:37 -0400
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 773022B257;
        Mon,  3 Oct 2022 16:57:34 -0700 (PDT)
Received: from ole.1.ozlabs.ru (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 6E27A833CD;
        Mon,  3 Oct 2022 19:57:29 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     kvm@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup@brainfault.org>, kvm-ppc@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH kernel v4] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support platform dependent
Date:   Tue,  4 Oct 2022 10:57:22 +1100
Message-Id: <20221003235722.2085145-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When introduced, IRQFD resampling worked on POWER8 with XICS. However
KVM on POWER9 has never implemented it - the compatibility mode code
("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
XIVE mode does not handle INTx in KVM at all.

This moved the capability support advertising to platforms and stops
advertising it on XIVE, i.e. POWER9 and later.

This should cause no behavioural change for other architectures.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Marc Zyngier <maz@kernel.org>
---
Changes:
v4:
* removed incorrect clause about changing behavoir on MIPS and RISCV

v3:
* removed all ifdeferry
* removed the capability for MIPS and RISCV
* adjusted the commit log about MIPS and RISCV

v2:
* removed ifdef for ARM64.
---
 arch/arm64/kvm/arm.c       | 1 +
 arch/powerpc/kvm/powerpc.c | 6 ++++++
 arch/s390/kvm/kvm-s390.c   | 1 +
 arch/x86/kvm/x86.c         | 1 +
 virt/kvm/kvm_main.c        | 1 -
 5 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2ff0ef62abad..d2daa4d375b5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -218,6 +218,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+	case KVM_CAP_IRQFD_RESAMPLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index fb1490761c87..908ce8bd91c9 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -593,6 +593,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 #endif
 
+#ifdef CONFIG_HAVE_KVM_IRQFD
+	case KVM_CAP_IRQFD_RESAMPLE:
+		r = !xive_enabled();
+		break;
+#endif
+
 	case KVM_CAP_PPC_ALLOC_HTAB:
 		r = hv_enabled;
 		break;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index edfd4bbd0cba..7521adadb81b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -577,6 +577,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_S390_DIAG318:
 	case KVM_CAP_S390_MEM_OP_EXTENSION:
+	case KVM_CAP_IRQFD_RESAMPLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..2d6c5a8fdf14 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4395,6 +4395,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
+	case KVM_CAP_IRQFD_RESAMPLE:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 584a5bab3af3..05cf94013f02 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4447,7 +4447,6 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 #ifdef CONFIG_HAVE_KVM_IRQFD
 	case KVM_CAP_IRQFD:
-	case KVM_CAP_IRQFD_RESAMPLE:
 #endif
 	case KVM_CAP_IOEVENTFD_ANY_LENGTH:
 	case KVM_CAP_CHECK_EXTENSION_VM:
-- 
2.37.3

