Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0604D458391
	for <lists+kvm@lfdr.de>; Sun, 21 Nov 2021 13:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbhKUM6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Nov 2021 07:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238201AbhKUM6S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Nov 2021 07:58:18 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E37FC06173E;
        Sun, 21 Nov 2021 04:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qgYU5vzDBKxIUC/iB5UVJS4/0uLVrDIq5zuDRSYxPkA=; b=fRCnuTLe0cq87iNUBx5gtjOTYC
        5qh48tZzUp1B5r9r23yWLMzczE5oOIdRUtMiMyrjt1pOrpHeeUKpvWqch3071FDnX5mKox5fRN3kA
        sO9aiMiPOvLHIlsR1GBwO++A8qnH54U5bBxCtx51m4cyNlwiM9NyyXt6LUi6DyQREiewTZcolB5O/
        /FYzNcFm8dusGqRQZN3fcRd5rLd5kXOG46fULB6pOpZq72ku+pkDFzjnXrbmd7o9nnK836Jmekdha
        yAWD8NQDq3IRgN5K+jO1GHbd0miPs8zoHs0O6LwbhIKWFOV5REmqehTF3lErL46HtpsTqy8aC9twf
        9TUuF2Ow==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1momMw-00HIg9-A2; Sun, 21 Nov 2021 12:54:54 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1momMv-0002Vy-Ub; Sun, 21 Nov 2021 12:54:53 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH v5 01/12] KVM: Introduce CONFIG_HAVE_KVM_DIRTY_RING
Date:   Sun, 21 Nov 2021 12:54:40 +0000
Message-Id: <20211121125451.9489-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211121125451.9489-1-dwmw2@infradead.org>
References: <20211121125451.9489-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

I'd like to make the build include dirty_ring.c based on whether the
arch wants it or not. That's a whole lot simpler if there's a config
symbol instead of doing it implicitly on KVM_DIRTY_LOG_PAGE_OFFSET
being set to something non-zero.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/Kconfig           | 1 +
 include/linux/kvm_dirty_ring.h | 8 ++++----
 virt/kvm/Kconfig               | 3 +++
 virt/kvm/kvm_main.c            | 4 ++--
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 619186138176..d7fa0a42ac25 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -27,6 +27,7 @@ config KVM
 	select MMU_NOTIFIER
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQFD
+	select HAVE_KVM_DIRTY_RING
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_IRQ_ROUTING
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index fb0fa18878e2..906f899813dc 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -27,9 +27,9 @@ struct kvm_dirty_ring {
 	int index;
 };
 
-#if (KVM_DIRTY_LOG_PAGE_OFFSET == 0)
+#ifndef CONFIG_HAVE_KVM_DIRTY_RING
 /*
- * If KVM_DIRTY_LOG_PAGE_OFFSET not defined, kvm_dirty_ring.o should
+ * If CONFIG_HAVE_HVM_DIRTY_RING not defined, kvm_dirty_ring.o should
  * not be included as well, so define these nop functions for the arch.
  */
 static inline u32 kvm_dirty_ring_get_rsvd_entries(void)
@@ -69,7 +69,7 @@ static inline bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
 	return true;
 }
 
-#else /* KVM_DIRTY_LOG_PAGE_OFFSET == 0 */
+#else /* CONFIG_HAVE_KVM_DIRTY_RING */
 
 u32 kvm_dirty_ring_get_rsvd_entries(void);
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
@@ -92,6 +92,6 @@ struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset);
 void kvm_dirty_ring_free(struct kvm_dirty_ring *ring);
 bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring);
 
-#endif /* KVM_DIRTY_LOG_PAGE_OFFSET == 0 */
+#endif /* CONFIG_HAVE_KVM_DIRTY_RING */
 
 #endif	/* KVM_DIRTY_RING_H */
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 62b39149b8c8..97cf5413ac25 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -13,6 +13,9 @@ config HAVE_KVM_IRQFD
 config HAVE_KVM_IRQ_ROUTING
        bool
 
+config HAVE_KVM_DIRTY_RING
+       bool
+
 config HAVE_KVM_EVENTFD
        bool
        select EVENTFD
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 72c6453bcef4..8eb8c962838d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3432,7 +3432,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
 
 static bool kvm_page_in_dirty_ring(struct kvm *kvm, unsigned long pgoff)
 {
-#if KVM_DIRTY_LOG_PAGE_OFFSET > 0
+#ifdef CONFIG_HAVE_KVM_DIRTY_RING
 	return (pgoff >= KVM_DIRTY_LOG_PAGE_OFFSET) &&
 	    (pgoff < KVM_DIRTY_LOG_PAGE_OFFSET +
 	     kvm->dirty_ring_size / PAGE_SIZE);
@@ -4135,7 +4135,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_NR_MEMSLOTS:
 		return KVM_USER_MEM_SLOTS;
 	case KVM_CAP_DIRTY_LOG_RING:
-#if KVM_DIRTY_LOG_PAGE_OFFSET > 0
+#ifdef CONFIG_HAVE_KVM_DIRTY_RING
 		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
 #else
 		return 0;
-- 
2.31.1

