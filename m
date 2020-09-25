Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF1727935C
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgIYVXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728410AbgIYVXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:14 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2759EC0613D6
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:14 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id z22so246240pjr.8
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=+zqEz38TI9y5rZ41moN9G5sylTl3ehc4d8gzYBHtRvo=;
        b=DLMitrGxd+/kIktjqHT6zyLWslmhc5uQjdGhdRxHf/tlY5qw7UDWWpARaY13ISatxX
         ViNAD/vejX2tUv0CRJJKP2S2RIZP0HzYs3ApWXuZP+Uqwz/AvS0X13FW474910FtVCID
         autpxYJJVw2bw46JbmKImb+QtovTu8w8mSsvVPt48ivG/IGjQ3I5pJ+tOYmT1+9k+i7+
         rZn+9WEb08VtBxQj38MXSEShsAOOSUBRsuiZWtF25p7fRnB2Ozyb0mWXlBBzS6dhpiZZ
         CbVtbMD3uX23c4fVyh2n/seMHk7siBRW0SkOnOTIzykdFqIt+gJuiGcn9hlaq4j7P6i4
         6IOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+zqEz38TI9y5rZ41moN9G5sylTl3ehc4d8gzYBHtRvo=;
        b=j4AJTZvwhJiR18eXA3moAM5s614Ijfu0JU/K9zE2duz0cWj3ySEvydG+plnou0UEqI
         rPQxaqwIrRVUu+PYYFoPRvuvNXeD4kzgJ5ei8b8CDy+IFe1OGURGGU7fF8JRhCfWRRQm
         f3TlphDkVXEzEU+bH/m9dl31A1farzo/C3KKajfBKxirrj7SOilBUj3bc4zqlgrbiwlq
         rMOWYcMGbHAOsinhhgVmnkaZ8rlYo3hqpzyJxqjv3LL7stO7s+QO6/Xn/DPeiZ2jzryw
         PVB5jh5S5I8ofmFHqMkjwbYE1TngW5bJ8lZYGbx5e02u+S0Xr0BcZdunxP7sd8mulKzz
         4rPg==
X-Gm-Message-State: AOAM531JuHat1GSVha6P8eTlh1E+yGd1DBFWavvqk/rlAJ8PfLcjGIpv
        sphuy3a72iS90o2b8zrtiwGWBcLFV0mi
X-Google-Smtp-Source: ABdhPJyKVGVL2iwOoKcXhl4kcjsxdMol/lDZa8ZsBEKztYFqo/6T8Do6hBc0w++ZkfYVdoknYyOJ7qQcdpeB
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:9697:b029:d1:e598:4001 with SMTP
 id n23-20020a1709029697b02900d1e5984001mr1269468plp.59.1601068993541; Fri, 25
 Sep 2020 14:23:13 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:43 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-4-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 03/22] kvm: mmu: Init / Uninit the TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 arch/x86/include/asm/kvm_host.h |  9 +++++++++
 arch/x86/kvm/Makefile           |  2 +-
 arch/x86/kvm/mmu/mmu.c          |  5 +++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 34 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      | 10 ++++++++++
 5 files changed, 59 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/mmu/tdp_mmu.c
 create mode 100644 arch/x86/kvm/mmu/tdp_mmu.h

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5303dbc5c9bce..35107819f48ae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -963,6 +963,15 @@ struct kvm_arch {
 
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
index cf6a9947955f7..e5b33938f86ed 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -16,7 +16,7 @@ kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
-			   mmu/tdp_iter.o
+			   mmu/tdp_iter.o mmu/tdp_mmu.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b48b00c8cde65..0cb0c26939dfc 100644
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
@@ -5865,6 +5866,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 
+	kvm_mmu_init_tdp_mmu(kvm);
+
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
@@ -5875,6 +5878,8 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 
 	kvm_page_track_unregister_notifier(kvm, node);
+
+	kvm_mmu_uninit_tdp_mmu(kvm);
 }
 
 void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
new file mode 100644
index 0000000000000..8241e18c111e6
--- /dev/null
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include "tdp_mmu.h"
+
+static bool __read_mostly tdp_mmu_enabled = true;
+module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
+
+static bool is_tdp_mmu_enabled(void)
+{
+	if (!READ_ONCE(tdp_mmu_enabled))
+		return false;
+
+	if (WARN_ONCE(!tdp_enabled,
+		      "Creating a VM with TDP MMU enabled requires TDP."))
+		return false;
+
+	return true;
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
index 0000000000000..dd3764f5a9aa3
--- /dev/null
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
2.28.0.709.gb0816b6eb0-goog

