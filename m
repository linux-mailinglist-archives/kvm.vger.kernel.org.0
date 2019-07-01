Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D2F13E88
	for <lists+kvm@lfdr.de>; Sun,  5 May 2019 10:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfEEI4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 May 2019 04:56:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52850 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbfEEI4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 May 2019 04:56:50 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C0381309265C
        for <kvm@vger.kernel.org>; Sun,  5 May 2019 08:56:49 +0000 (UTC)
Received: from xz-x1.nay.redhat.com (dhcp-14-116.nay.redhat.com [10.66.14.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83DF15C231;
        Sun,  5 May 2019 08:56:43 +0000 (UTC)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH] kvm: Check irqchip mode before assign irqfd
Date:   Sun,  5 May 2019 16:56:42 +0800
Message-Id: <20190505085642.6773-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Sun, 05 May 2019 08:56:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When assigning kvm irqfd we didn't check the irqchip mode but we allow
KVM_IRQFD to succeed with all the irqchip modes.  However it does not
make much sense to create irqfd even without the kernel chips.  Let's
provide a arch-dependent helper to check whether a specific irqfd is
allowed by the arch.  At least for x86, it should make sense to check:

- when irqchip mode is NONE, all irqfds should be disallowed, and,

- when irqchip mode is SPLIT, irqfds that are with resamplefd should
  be disallowed.

For either of the case, previously we'll silently ignore the irq or
the irq ack event if the irqchip mode is incorrect.  However that can
cause misterious guest behaviors and it can be hard to triage.  Let's
fail KVM_IRQFD even earlier to detect these incorrect configurations.

CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Radim Krčmář <rkrcmar@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>
CC: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/irq.c | 7 +++++++
 arch/x86/kvm/irq.h | 1 +
 virt/kvm/eventfd.c | 9 +++++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index faa264822cee..007bc654f928 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -172,3 +172,10 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 	__kvm_migrate_apic_timer(vcpu);
 	__kvm_migrate_pit_timer(vcpu);
 }
+
+bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
+{
+	bool resample = args->flags & KVM_IRQFD_FLAG_RESAMPLE;
+
+	return resample ? irqchip_kernel(kvm) : irqchip_in_kernel(kvm);
+}
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index d5005cc26521..fd210cdd4983 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -114,6 +114,7 @@ static inline int irqchip_in_kernel(struct kvm *kvm)
 	return mode != KVM_IRQCHIP_NONE;
 }
 
+bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 001aeda4c154..3972a9564c76 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -44,6 +44,12 @@
 
 static struct workqueue_struct *irqfd_cleanup_wq;
 
+bool __attribute__((weak))
+kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
+{
+	return true;
+}
+
 static void
 irqfd_inject(struct work_struct *work)
 {
@@ -297,6 +303,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	if (!kvm_arch_intc_initialized(kvm))
 		return -EAGAIN;
 
+	if (!kvm_arch_irqfd_allowed(kvm, args))
+		return -EINVAL;
+
 	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL_ACCOUNT);
 	if (!irqfd)
 		return -ENOMEM;
-- 
2.17.1

