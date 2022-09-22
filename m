Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D465E690C
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 19:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiIVRCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 13:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiIVRB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 13:01:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EB1F85B5
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07B5E636B3
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5311AC4347C;
        Thu, 22 Sep 2022 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663866115;
        bh=wMvNENW6f5nK/iO1hpFEs/1OY3scyEbFHH9QYgtMDNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7PN7PklhBFJmd5sd8qMYqN8++7B0BeiO6VDWoV2UkGxDuXeGFODuVgxvUbDuOmcj
         N/fCgHBOSrceS9NICQhLmq0kdO5kGvUg6fh00yuQeCCsex9Sewpu58ECc1F4isAUxN
         hrXs04Dxr/0mO1I7ynC+90Jp4KkFcB7GtcYsq9rnba/MG/S4h9CNSBXD7RuXEfwche
         iEUxjlv4VAXf2SWWoxmIm0x+nvG6MrLv0G/LL5oabP1F2uJHGPwojzqov275hGnta6
         MmV+5jT7FDaqkITIdqp7Po+stlMxa9hkc95jpOjpfpGzPwievnj01bPS8IApOrs0yu
         QlyBTpEIiMAOA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1obPaD-00Bxdo-G2;
        Thu, 22 Sep 2022 18:01:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, gshan@redhat.com,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability and config option
Date:   Thu, 22 Sep 2022 18:01:29 +0100
Message-Id: <20220922170133.2617189-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922170133.2617189-1-maz@kernel.org>
References: <20220922170133.2617189-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com, peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com, gshan@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to differenciate between architectures that require no extra
synchronisation when accessing the dirty ring and those who do,
add a new capability (KVM_CAP_DIRTY_LOG_RING_ORDERED) that identify
the latter sort. TSO architectures can obviously advertise both, while
relaxed architectures most only advertise the ORDERED version.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/kvm_dirty_ring.h |  6 +++---
 include/uapi/linux/kvm.h       |  1 +
 virt/kvm/Kconfig               | 14 ++++++++++++++
 virt/kvm/Makefile.kvm          |  2 +-
 virt/kvm/kvm_main.c            | 11 +++++++++--
 5 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index 906f899813dc..7a0c90ae9a3f 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -27,7 +27,7 @@ struct kvm_dirty_ring {
 	int index;
 };
 
-#ifndef CONFIG_HAVE_KVM_DIRTY_RING
+#ifndef CONFIG_HAVE_KVM_DIRTY_LOG
 /*
  * If CONFIG_HAVE_HVM_DIRTY_RING not defined, kvm_dirty_ring.o should
  * not be included as well, so define these nop functions for the arch.
@@ -69,7 +69,7 @@ static inline bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
 	return true;
 }
 
-#else /* CONFIG_HAVE_KVM_DIRTY_RING */
+#else /* CONFIG_HAVE_KVM_DIRTY_LOG */
 
 u32 kvm_dirty_ring_get_rsvd_entries(void);
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
@@ -92,6 +92,6 @@ struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset);
 void kvm_dirty_ring_free(struct kvm_dirty_ring *ring);
 bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring);
 
-#endif /* CONFIG_HAVE_KVM_DIRTY_RING */
+#endif /* CONFIG_HAVE_KVM_DIRTY_LOG */
 
 #endif	/* KVM_DIRTY_RING_H */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eed0315a77a6..c1c9c0c8be5c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1177,6 +1177,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
+#define KVM_CAP_DIRTY_LOG_RING_ORDERED 223
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index a8c5c9f06b3c..1023426bf7dd 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -16,8 +16,22 @@ config HAVE_KVM_IRQFD
 config HAVE_KVM_IRQ_ROUTING
        bool
 
+config HAVE_KVM_DIRTY_LOG
+       bool
+
+# Only strongly ordered architectures can select this, as it doesn't
+# put any constraint on userspace ordering. They also can select the
+# _ORDERED version.
 config HAVE_KVM_DIRTY_RING
        bool
+       select HAVE_KVM_DIRTY_LOG
+       depends on X86
+
+# Weakly ordered architectures can only select this, advertising
+# to userspace the additional ordering requirements.
+config HAVE_KVM_DIRTY_RING_ORDERED
+       bool
+       select HAVE_KVM_DIRTY_LOG
 
 config HAVE_KVM_EVENTFD
        bool
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 2c27d5d0c367..2bc6d0bb5e5c 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -10,5 +10,5 @@ kvm-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
 kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
 kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
-kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
+kvm-$(CONFIG_HAVE_KVM_DIRTY_LOG) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 584a5bab3af3..cb1c103e2018 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3304,7 +3304,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
-#ifdef CONFIG_HAVE_KVM_DIRTY_RING
+#ifdef CONFIG_HAVE_KVM_DIRTY_LOG
 	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
 		return;
 #endif
@@ -3758,7 +3758,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
 
 static bool kvm_page_in_dirty_ring(struct kvm *kvm, unsigned long pgoff)
 {
-#ifdef CONFIG_HAVE_KVM_DIRTY_RING
+#ifdef CONFIG_HAVE_KVM_DIRTY_LOG
 	return (pgoff >= KVM_DIRTY_LOG_PAGE_OFFSET) &&
 	    (pgoff < KVM_DIRTY_LOG_PAGE_OFFSET +
 	     kvm->dirty_ring_size / PAGE_SIZE);
@@ -4479,6 +4479,12 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
 #else
 		return 0;
+#endif
+	case KVM_CAP_DIRTY_LOG_RING_ORDERED:
+#ifdef CONFIG_HAVE_KVM_DIRTY_RING_ORDERED
+		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
+#else
+		return 0;
 #endif
 	case KVM_CAP_BINARY_STATS_FD:
 	case KVM_CAP_SYSTEM_EVENT_DATA:
@@ -4580,6 +4586,7 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 		return 0;
 	}
 	case KVM_CAP_DIRTY_LOG_RING:
+	case KVM_CAP_DIRTY_LOG_RING_ORDERED:
 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
-- 
2.34.1

