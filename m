Return-Path: <kvm+bounces-2453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F76C7F8928
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 09:19:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98C08B21319
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 08:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF58944E;
	Sat, 25 Nov 2023 08:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z1SIyNEa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AF1D7
	for <kvm@vger.kernel.org>; Sat, 25 Nov 2023 00:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700900335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7gWnKow7mmEdO4f39vqBRl04PZThOfmSepuYQVktBy4=;
	b=Z1SIyNEa90+UUPZM4CV/hqVeQl2xzWVmrTNaCjHqIPiNFoXy5JhrviXG1zVP4sZD6J4QI8
	kY+N1abgWEwlTyMHuSAqYQfFc/8G2Wwgsu4tJOBn1vktsSEQJHaQ8RkeOi1BCuetgSaynn
	HEeCk6ydNCOUM9AUenkNtm5sE8YP92U=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-292-n9Qe_U-mMWWK-hI_hA54Ug-1; Sat,
 25 Nov 2023 03:18:51 -0500
X-MC-Unique: n9Qe_U-mMWWK-hI_hA54Ug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 792C43810B33;
	Sat, 25 Nov 2023 08:18:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 603EB1C060B0;
	Sat, 25 Nov 2023 08:18:51 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] KVM: remove CONFIG_HAVE_KVM_EVENTFD
Date: Sat, 25 Nov 2023 03:18:50 -0500
Message-Id: <20231125081850.1388059-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

virt/kvm/eventfd.c is compiled unconditionally, meaning that the ioeventfds
member of struct kvm is accessed unconditionally.  CONFIG_HAVE_KVM_EVENTFD
therefore must be defined for KVM common code to compile successfully,
remove it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/Kconfig     |  1 -
 arch/loongarch/kvm/Kconfig |  1 -
 arch/mips/kvm/Kconfig      |  1 -
 arch/powerpc/kvm/Kconfig   |  1 -
 arch/riscv/kvm/Kconfig     |  1 -
 arch/s390/kvm/Kconfig      |  1 -
 arch/x86/kvm/Kconfig       |  1 -
 include/linux/kvm_host.h   | 30 +-----------------------------
 virt/kvm/Kconfig           |  5 +----
 9 files changed, 2 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 83c1e09be42e..5d9b68b5a0b3 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -29,7 +29,6 @@ menuconfig KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_XFER_TO_GUEST_WORK
 	select KVM_VFIO
-	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select NEED_KVM_DIRTY_RING_WITH_BITMAP
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index fda425babfb2..de19b9d9a444 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	depends on AS_HAS_LVZ_EXTENSION
 	depends on HAVE_KVM
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
-	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index a8cdba75f98d..c7fc176fffc3 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	select EXPORT_UASM
 	select PREEMPT_NOTIFIERS
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
-	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_MMIO
 	select MMU_NOTIFIER
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 902611954200..8a3d08559f11 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -20,7 +20,6 @@ if VIRTUALIZATION
 config KVM
 	bool
 	select PREEMPT_NOTIFIERS
-	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_VFIO
 	select IRQ_BYPASS_MANAGER
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index dfc237d7875b..642f8d95289b 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -20,7 +20,6 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support (EXPERIMENTAL)"
 	depends on RISCV_SBI && MMU
-	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_IRQ_ROUTING
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 45fdf2a9b2e3..ed567b858535 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -23,7 +23,6 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
-	select HAVE_KVM_EVENTFD
 	select KVM_ASYNC_PF
 	select KVM_ASYNC_PF_SYNC
 	select HAVE_KVM_IRQCHIP
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 950c12868d30..2efda4fc6a21 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -33,7 +33,6 @@ config KVM
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_IRQ_ROUTING
-	select HAVE_KVM_EVENTFD
 	select KVM_ASYNC_PF
 	select USER_RETURN_NOTIFIER
 	select KVM_MMIO
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4944136efaa2..b043202dd0b4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -753,7 +753,6 @@ struct kvm {
 	struct list_head vm_list;
 	struct mutex lock;
 	struct kvm_io_bus __rcu *buses[KVM_NR_BUSES];
-#ifdef CONFIG_HAVE_KVM_EVENTFD
 	struct {
 		spinlock_t        lock;
 		struct list_head  items;
@@ -762,7 +761,6 @@ struct kvm {
 		struct mutex      resampler_lock;
 	} irqfds;
 	struct list_head ioeventfds;
-#endif
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
 	refcount_t users_count;
@@ -2013,8 +2011,6 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 
 int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
 
-#ifdef CONFIG_HAVE_KVM_EVENTFD
-
 void kvm_eventfd_init(struct kvm *kvm);
 int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
 
@@ -2039,31 +2035,7 @@ static inline bool kvm_notify_irqfd_resampler(struct kvm *kvm,
 {
 	return false;
 }
-#endif
-
-#else
-
-static inline void kvm_eventfd_init(struct kvm *kvm) {}
-
-static inline int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
-{
-	return -EINVAL;
-}
-
-static inline void kvm_irqfd_release(struct kvm *kvm) {}
-
-#ifdef CONFIG_HAVE_KVM_IRQCHIP
-static inline void kvm_irq_routing_update(struct kvm *kvm)
-{
-}
-#endif
-
-static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
-{
-	return -ENOSYS;
-}
-
-#endif /* CONFIG_HAVE_KVM_EVENTFD */
+#endif /* CONFIG_HAVE_KVM_IRQFD */
 
 void kvm_arch_irq_routing_update(struct kvm *kvm);
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 484d0873061c..18b5a8fb491b 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -3,6 +3,7 @@
 
 config HAVE_KVM
        bool
+       select EVENTFD
 
 config HAVE_KVM_PFNCACHE
        bool
@@ -39,10 +40,6 @@ config NEED_KVM_DIRTY_RING_WITH_BITMAP
 	bool
 	depends on HAVE_KVM_DIRTY_RING
 
-config HAVE_KVM_EVENTFD
-       bool
-       select EVENTFD
-
 config KVM_MMIO
        bool
 
-- 
2.39.1


