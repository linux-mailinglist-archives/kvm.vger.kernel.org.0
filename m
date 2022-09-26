Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D8A5EABF1
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 18:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbiIZQDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 12:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiIZQCj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 12:02:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B706E6F
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 07:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C997CB80AC7
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6D5C433B5;
        Mon, 26 Sep 2022 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664203885;
        bh=SZA3KzsHt16PF+DaIYBz7Nb49624LswRe+Ox5z2sq34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1LixNiwiplcKqe80TOHWv6ipi93flRcW96VaPramWhh3r0x5c+Mg1kjDhkX81i+T
         vOUBv99xCffx5QPhrYunu9hX6KVdCmgeG8MalLfO6LKQB96tuweCY7TQzPja+CoPeo
         7hBt9v/sfen+SOnAHKyIISA561HLooQQoBkG6VWCLm6YuYdu4u/u+UL/3DSWqhoZfr
         LdpjDJoWeD/Wr8nGBtiu6GgA7wkgGkovYNaSDrIXu+sKz8ovvBqExt1fyGVVKcYu7D
         asIo1SgwBOW45ygeQQ8LYHd1XlDyGoC+QKgKxGhdK3HCAb7wh/idCwMQyC/n3k6DhS
         f3SxdRr+PwycA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ocpS7-00Cips-KI;
        Mon, 26 Sep 2022 15:51:23 +0100
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
Subject: [PATCH v2 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option
Date:   Mon, 26 Sep 2022 15:51:16 +0100
Message-Id: <20220926145120.27974-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
References: <20220926145120.27974-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com, peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com, gshan@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to differenciate between architectures that require no extra
synchronisation when accessing the dirty ring and those who do,
add a new capability (KVM_CAP_DIRTY_LOG_RING_ACQ_REL) that identify
the latter sort. TSO architectures can obviously advertise both, while
relaxed architectures must only advertise the ACQ_REL version.

This requires some configuration symbol rejigging, with HAVE_KVM_DIRTY_RING
being only indirectly selected by two top-level config symbols:
- HAVE_KVM_DIRTY_RING_TSO for strongly ordered architectures (x86)
- HAVE_KVM_DIRTY_RING_ACQ_REL for weakly ordered architectures (arm64)

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/x86/kvm/Kconfig     |  2 +-
 include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig         | 14 ++++++++++++++
 virt/kvm/kvm_main.c      |  9 ++++++++-
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index e3cbd7706136..876748b236ff 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -28,7 +28,7 @@ config KVM
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_IRQFD
-	select HAVE_KVM_DIRTY_RING
+	select HAVE_KVM_DIRTY_RING_TSO
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_IRQ_ROUTING
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eed0315a77a6..0d5d4419139a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1177,6 +1177,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
+#define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index a8c5c9f06b3c..800f9470e36b 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -19,6 +19,20 @@ config HAVE_KVM_IRQ_ROUTING
 config HAVE_KVM_DIRTY_RING
        bool
 
+# Only strongly ordered architectures can select this, as it doesn't
+# put any explicit constraint on userspace ordering. They can also
+# select the _ACQ_REL version.
+config HAVE_KVM_DIRTY_RING_TSO
+       bool
+       select HAVE_KVM_DIRTY_RING
+       depends on X86
+
+# Weakly ordered architectures can only select this, advertising
+# to userspace the additional ordering requirements.
+config HAVE_KVM_DIRTY_RING_ACQ_REL
+       bool
+       select HAVE_KVM_DIRTY_RING
+
 config HAVE_KVM_EVENTFD
        bool
        select EVENTFD
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 584a5bab3af3..5b064dbadaf4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4475,7 +4475,13 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_NR_MEMSLOTS:
 		return KVM_USER_MEM_SLOTS;
 	case KVM_CAP_DIRTY_LOG_RING:
-#ifdef CONFIG_HAVE_KVM_DIRTY_RING
+#ifdef CONFIG_HAVE_KVM_DIRTY_RING_TSO
+		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
+#else
+		return 0;
+#endif
+	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
+#ifdef CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
 		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
 #else
 		return 0;
@@ -4580,6 +4586,7 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 		return 0;
 	}
 	case KVM_CAP_DIRTY_LOG_RING:
+	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
-- 
2.34.1

