Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C142973C0
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751563AbgJWQai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751526AbgJWQaf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lsLhAdly5U2eWUcP2dCo+xi2v1YCTz+iQrZ0M6kEMk8=;
        b=U+5ygtaokpu+uiK9/x8u57SxD2cq6dMtaNNOTtYiiFx/J7Fa1RKQic7YpyR+E02EDJcP1B
        /Hkno3MS3/6rwoJrRuS7F2LzgVnHSv+hth3Rwehhnkl2Ix1+JN5jW3n03DktCDDLL3RT9c
        8RwATzPVUmxA1h4pwl9F2L1u4YBFjCU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-6CrHKrZbMu-y6OCyWBreEw-1; Fri, 23 Oct 2020 12:30:29 -0400
X-MC-Unique: 6CrHKrZbMu-y6OCyWBreEw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 359231891E83;
        Fri, 23 Oct 2020 16:30:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA06B5D9E2;
        Fri, 23 Oct 2020 16:30:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 06/22] kvm: x86/mmu: Init / Uninit the TDP MMU
Date:   Fri, 23 Oct 2020 12:30:08 -0400
Message-Id: <20201023163024.2765558-7-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

The TDP MMU offers an alternative mode of operation to the x86 shadow
paging based MMU, optimized for running an L1 guest with TDP. The TDP MMU
will require new fields that need to be initialized and torn down. Add
hooks into the existing KVM MMU initialization process to do that
initialization / cleanup. Currently the initialization and cleanup
fucntions do not do very much, however more operations will be added in
future patches.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-4-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  9 +++++++++
 arch/x86/kvm/Makefile           |  2 +-
 arch/x86/kvm/mmu/mmu.c          |  5 +++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      | 10 ++++++++++
 5 files changed, 55 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/mmu/tdp_mmu.c
 create mode 100644 arch/x86/kvm/mmu/tdp_mmu.h

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8233991386a3..f6d47ac74a52 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -995,6 +995,15 @@ struct kvm_arch {
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
+
+	/*
+	 * Whether the TDP MMU is enabled for this VM. This contains a
+	 * snapshot of the TDP MMU module parameter from when the VM was
+	 * created and remains unchanged for the life of the VM. If this is
+	 * true, TDP MMU handler functions will run for various MMU
+	 * operations.
+	 */
+	bool tdp_mmu_enabled;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index a5dd4e5970f8..b804444e16d4 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -16,7 +16,7 @@ kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
-			   mmu/spte.o mmu/tdp_iter.o
+			   mmu/spte.o mmu/tdp_iter.o mmu/tdp_mmu.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02af304c168a..2afaf17284bb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -19,6 +19,7 @@
 #include "ioapic.h"
 #include "mmu.h"
 #include "mmu_internal.h"
+#include "tdp_mmu.h"
 #include "x86.h"
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
@@ -5377,6 +5378,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 
+	kvm_mmu_init_tdp_mmu(kvm);
+
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
@@ -5387,6 +5390,8 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 
 	kvm_page_track_unregister_notifier(kvm, node);
+
+	kvm_mmu_uninit_tdp_mmu(kvm);
 }
 
 void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
new file mode 100644
index 000000000000..e567e8aa61a1
--- /dev/null
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "tdp_mmu.h"
+
+static bool __read_mostly tdp_mmu_enabled = false;
+
+static bool is_tdp_mmu_enabled(void)
+{
+#ifdef CONFIG_X86_64
+	return tdp_enabled && READ_ONCE(tdp_mmu_enabled);
+#else
+	return false;
+#endif /* CONFIG_X86_64 */
+}
+
+/* Initializes the TDP MMU for the VM, if enabled. */
+void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
+{
+	if (!is_tdp_mmu_enabled())
+		return;
+
+	/* This should not be changed for the lifetime of the VM. */
+	kvm->arch.tdp_mmu_enabled = true;
+}
+
+void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
+{
+	if (!kvm->arch.tdp_mmu_enabled)
+		return;
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
new file mode 100644
index 000000000000..cd4a562a70e9
--- /dev/null
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#ifndef __KVM_X86_MMU_TDP_MMU_H
+#define __KVM_X86_MMU_TDP_MMU_H
+
+#include <linux/kvm_host.h>
+
+void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
+void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
+#endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.26.2


