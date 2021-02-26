Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CEF326123
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 11:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhBZKRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 05:17:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231127AbhBZKPx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Feb 2021 05:15:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614334466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Z39kMRj5F+w7GwQjo6RQskikMPrjcYP4QGKdBa2Y9ZQ=;
        b=COk74D9pqSVmR6Ib7jcHiEQcYm0cabb8o7eKyCgsuzNgcAT3bZ+Jwv2uqhkBzRQnVDTWNO
        rWLzIRbLfd5DNRxMYsPlJrywmevbM60dZT3XipKGM75gBEFJDDUEOZ+t2xOVIBR1342gl4
        bbF25uFrzhPRZesgSukvTwFB+ucVURA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-HEX_cppGMKGDue7hqzoQyg-1; Fri, 26 Feb 2021 05:14:24 -0500
X-MC-Unique: HEX_cppGMKGDue7hqzoQyg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94BC918B9ECA;
        Fri, 26 Feb 2021 10:14:22 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DB4C1001281;
        Fri, 26 Feb 2021 10:14:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH] KVM: x86: allow compiling out the Xen hypercall interface
Date:   Fri, 26 Feb 2021 05:14:21 -0500
Message-Id: <20210226101421.81535-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Xen hypercall interface adds to the attack surface of the hypervisor
and will be used quite rarely.  Allow compiling it out.

Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Kconfig  |  9 ++++++++
 arch/x86/kvm/Makefile |  3 ++-
 arch/x86/kvm/x86.c    |  2 ++
 arch/x86/kvm/xen.h    | 49 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 7ac592664c52..5a0d704581bd 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -103,6 +103,15 @@ config KVM_AMD_SEV
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
 
+config KVM_XEN
+	bool "Support for Xen hypercall interface"
+	depends on KVM && IA32_FEAT_CTL
+	help
+	  Provides KVM support for the Xen shared information page and
+	  for passing Xen hypercalls to userspace.
+
+	  If in doubt, say "N".
+
 config KVM_MMU_AUDIT
 	bool "Audit KVM MMU"
 	depends on KVM && TRACEPOINTS
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index aeab168c5711..1b4766fe1de2 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -14,11 +14,12 @@ kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/dirty_ring.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
-kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o xen.o \
+kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
 			   mmu/spte.o
 kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
+kvm-$(CONFIG_KVM_XEN)	+= xen.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bfc928495bd4..9727295b7817 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8039,8 +8039,10 @@ void kvm_arch_exit(void)
 	kvm_mmu_module_exit();
 	free_percpu(user_return_msrs);
 	kmem_cache_destroy(x86_fpu_cache);
+#ifdef CONFIG_KVM_XEN
 	static_key_deferred_flush(&kvm_xen_enabled);
 	WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
+#endif
 }
 
 static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index b66a921776f4..6abdbebb029b 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,6 +9,7 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__
 
+#ifdef CONFIG_KVM_XEN
 #include <linux/jump_label_ratelimit.h>
 
 extern struct static_key_false_deferred kvm_xen_enabled;
@@ -18,7 +19,6 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
-int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data);
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
 void kvm_xen_destroy_vm(struct kvm *kvm);
@@ -38,6 +38,53 @@ static inline int kvm_xen_has_interrupt(struct kvm_vcpu *vcpu)
 
 	return 0;
 }
+#else
+static inline int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
+{
+	return -EINVAL;
+}
+
+static inline int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
+{
+	return -EINVAL;
+}
+
+static inline int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
+{
+	return -EINVAL;
+}
+
+static inline int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
+{
+	return -EINVAL;
+}
+
+static inline int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
+{
+	return 1;
+}
+
+static inline int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
+{
+	return -EINVAL;
+}
+
+static inline void kvm_xen_destroy_vm(struct kvm *kvm)
+{
+}
+
+static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
+{
+	return false;
+}
+
+static inline int kvm_xen_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+#endif
+
+int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 
 /* 32-bit compatibility definitions, also used natively in 32-bit build */
 #include <asm/pvclock-abi.h>
-- 
2.26.2

