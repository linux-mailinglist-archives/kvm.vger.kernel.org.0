Return-Path: <kvm+bounces-2454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C4877F892D
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 09:21:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EBAC1C20BF1
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 08:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B9AD944E;
	Sat, 25 Nov 2023 08:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L+X8CXTl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BC3D7
	for <kvm@vger.kernel.org>; Sat, 25 Nov 2023 00:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700900457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zFft4eSCdOMrdpLaXue5iGXf4Itn7tLvD8L9yc/5DXM=;
	b=L+X8CXTlraIwwh2FdBzIPhMnUzpkAS102xbZRH4B68eCtjQiD7EAtvap2BvRM5ioe7rSuk
	oAW8iu6JiWsSF6pzqIDqjHN1AT81xtmSFx1FAC+VLxvXPHObphwAQGZkZ86KmVjGVCqEFz
	E06/YsU2CQu3JT7lJAp9eQyd1OLoqPg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-s8aJHvZZNQuTMHrAnoz3QA-1; Sat,
 25 Nov 2023 03:20:55 -0500
X-MC-Unique: s8aJHvZZNQuTMHrAnoz3QA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 251921C05AB2;
	Sat, 25 Nov 2023 08:20:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C44AC1596F;
	Sat, 25 Nov 2023 08:20:55 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] KVM: remove CONFIG_HAVE_KVM_IRQFD
Date: Sat, 25 Nov 2023 03:20:54 -0500
Message-Id: <20231125082054.1388342-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

All platforms with a kernel irqchip have support for irqfd.  Unify the
two configuration items so that userspace can expect to use irqfd to
inject interrupts into the irqchip.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/Kconfig     | 1 -
 arch/powerpc/kvm/Kconfig   | 2 --
 arch/powerpc/kvm/powerpc.c | 2 +-
 arch/riscv/kvm/Kconfig     | 1 -
 arch/s390/kvm/Kconfig      | 1 -
 arch/x86/kvm/Kconfig       | 1 -
 include/linux/kvm_host.h   | 9 ++++-----
 include/trace/events/kvm.h | 8 ++++----
 virt/kvm/Kconfig           | 3 ---
 virt/kvm/eventfd.c         | 6 +++---
 virt/kvm/kvm_main.c        | 4 ++--
 11 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 5d9b68b5a0b3..71ebc4dadcfd 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -29,7 +29,6 @@ menuconfig KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_XFER_TO_GUEST_WORK
 	select KVM_VFIO
-	select HAVE_KVM_IRQFD
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select NEED_KVM_DIRTY_RING_WITH_BITMAP
 	select HAVE_KVM_MSI
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 8a3d08559f11..b24da1c8699b 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -224,7 +224,6 @@ config KVM_MPIC
 	bool "KVM in-kernel MPIC emulation"
 	depends on KVM && PPC_E500
 	select HAVE_KVM_IRQCHIP
-	select HAVE_KVM_IRQFD
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_MSI
 	help
@@ -237,7 +236,6 @@ config KVM_XICS
 	bool "KVM in-kernel XICS emulation"
 	depends on KVM_BOOK3S_64 && !KVM_MPIC
 	select HAVE_KVM_IRQCHIP
-	select HAVE_KVM_IRQFD
 	default y
 	help
 	  Include support for the XICS (eXternal Interrupt Controller
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index f6af752698d0..df0a90b37c17 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -578,7 +578,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 #endif
 
-#ifdef CONFIG_HAVE_KVM_IRQFD
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
 	case KVM_CAP_IRQFD_RESAMPLE:
 		r = !xive_enabled();
 		break;
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 642f8d95289b..267bbf85c7ea 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -21,7 +21,6 @@ config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support (EXPERIMENTAL)"
 	depends on RISCV_SBI && MMU
 	select HAVE_KVM_IRQCHIP
-	select HAVE_KVM_IRQFD
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_MSI
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index ed567b858535..bb6d90351119 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -26,7 +26,6 @@ config KVM
 	select KVM_ASYNC_PF
 	select KVM_ASYNC_PF_SYNC
 	select HAVE_KVM_IRQCHIP
-	select HAVE_KVM_IRQFD
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_INVALID_WAKEUPS
 	select HAVE_KVM_NO_POLL
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2efda4fc6a21..7a1280ccb525 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -27,7 +27,6 @@ config KVM
 	select MMU_NOTIFIER
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
-	select HAVE_KVM_IRQFD
 	select HAVE_KVM_DIRTY_RING_TSO
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select IRQ_BYPASS_MANAGER
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b043202dd0b4..06c57b02d54e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -776,8 +776,7 @@ struct kvm {
 	 * Update side is protected by irq_lock.
 	 */
 	struct kvm_irq_routing_table __rcu *irq_routing;
-#endif
-#ifdef CONFIG_HAVE_KVM_IRQFD
+
 	struct hlist_head irq_ack_notifier_list;
 #endif
 
@@ -963,7 +962,7 @@ static inline void kvm_arch_post_irq_routing_update(struct kvm *kvm)
 }
 #endif
 
-#ifdef CONFIG_HAVE_KVM_IRQFD
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
 int kvm_irqfd_init(void);
 void kvm_irqfd_exit(void);
 #else
@@ -2014,7 +2013,7 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
 void kvm_eventfd_init(struct kvm *kvm);
 int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
 
-#ifdef CONFIG_HAVE_KVM_IRQFD
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
 int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args);
 void kvm_irqfd_release(struct kvm *kvm);
 bool kvm_notify_irqfd_resampler(struct kvm *kvm,
@@ -2035,7 +2034,7 @@ static inline bool kvm_notify_irqfd_resampler(struct kvm *kvm,
 {
 	return false;
 }
-#endif /* CONFIG_HAVE_KVM_IRQFD */
+#endif /* CONFIG_HAVE_KVM_IRQCHIP */
 
 void kvm_arch_irq_routing_update(struct kvm *kvm);
 
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 3bd31ea23fee..011fba6b5552 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -62,7 +62,7 @@ TRACE_EVENT(kvm_vcpu_wakeup,
 		  __entry->valid ? "valid" : "invalid")
 );
 
-#if defined(CONFIG_HAVE_KVM_IRQFD)
+#if defined(CONFIG_HAVE_KVM_IRQCHIP)
 TRACE_EVENT(kvm_set_irq,
 	TP_PROTO(unsigned int gsi, int level, int irq_source_id),
 	TP_ARGS(gsi, level, irq_source_id),
@@ -82,7 +82,7 @@ TRACE_EVENT(kvm_set_irq,
 	TP_printk("gsi %u level %d source %d",
 		  __entry->gsi, __entry->level, __entry->irq_source_id)
 );
-#endif /* defined(CONFIG_HAVE_KVM_IRQFD) */
+#endif /* defined(CONFIG_HAVE_KVM_IRQCHIP) */
 
 #if defined(__KVM_HAVE_IOAPIC)
 #define kvm_deliver_mode		\
@@ -170,7 +170,7 @@ TRACE_EVENT(kvm_msi_set_irq,
 
 #endif /* defined(__KVM_HAVE_IOAPIC) */
 
-#if defined(CONFIG_HAVE_KVM_IRQFD)
+#if defined(CONFIG_HAVE_KVM_IRQCHIP)
 
 #ifdef kvm_irqchips
 #define kvm_ack_irq_string "irqchip %s pin %u"
@@ -197,7 +197,7 @@ TRACE_EVENT(kvm_ack_irq,
 	TP_printk(kvm_ack_irq_string, kvm_ack_irq_parm)
 );
 
-#endif /* defined(CONFIG_HAVE_KVM_IRQFD) */
+#endif /* defined(CONFIG_HAVE_KVM_IRQCHIP) */
 
 
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 18b5a8fb491b..5cb3654b7fd8 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -11,9 +11,6 @@ config HAVE_KVM_PFNCACHE
 config HAVE_KVM_IRQCHIP
        bool
 
-config HAVE_KVM_IRQFD
-       bool
-
 config HAVE_KVM_IRQ_ROUTING
        bool
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 89912a17f5d5..19534156d48c 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -28,7 +28,7 @@
 
 #include <kvm/iodev.h>
 
-#ifdef CONFIG_HAVE_KVM_IRQFD
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
 
 static struct workqueue_struct *irqfd_cleanup_wq;
 
@@ -531,7 +531,7 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 void
 kvm_eventfd_init(struct kvm *kvm)
 {
-#ifdef CONFIG_HAVE_KVM_IRQFD
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
 	spin_lock_init(&kvm->irqfds.lock);
 	INIT_LIST_HEAD(&kvm->irqfds.items);
 	INIT_LIST_HEAD(&kvm->irqfds.resampler_list);
@@ -540,7 +540,7 @@ kvm_eventfd_init(struct kvm *kvm)
 	INIT_LIST_HEAD(&kvm->ioeventfds);
 }
 
-#ifdef CONFIG_HAVE_KVM_IRQFD
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
 /*
  * shutdown any irqfd's that match fd+gsi
  */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..3bd98ff65945 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1227,7 +1227,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_disable;
 
-#ifdef CONFIG_HAVE_KVM_IRQFD
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
 
@@ -4539,7 +4539,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_HAVE_KVM_MSI
 	case KVM_CAP_SIGNAL_MSI:
 #endif
-#ifdef CONFIG_HAVE_KVM_IRQFD
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
 	case KVM_CAP_IRQFD:
 #endif
 	case KVM_CAP_IOEVENTFD_ANY_LENGTH:
-- 
2.39.1


