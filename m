Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEEA561D7F
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbiF3OOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237522AbiF3ONZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:13:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38222101C1
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:59:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C97FF6218F
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 13:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA91DC385A5;
        Thu, 30 Jun 2022 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656597542;
        bh=pcmjIDAYhC3j85a1sosctIpzdHXKCx23xW4Iwyna4lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNStHpGxhbCiBe9q0unSuYyjAgJ9EdDlSzImuICtLVKlsUaOzmoqVNj91dJfJC8kZ
         +CK8rEij3ILiiMNW6FgIsM/fzVX7IFlhMYsgomU8DKTnBcC8rSL3nRgRsTot1xFFcE
         lYL+6oLw0hX+v0vBsqqACHI23oGBp+KV0FmlLhJsvkRqRMXxVvDs2ms7oV3wycbk9g
         +mv83yYkX8LueW5m0QwyviqiosbJUe0FyV+Up0fCfsOaZqh361jBi7qpSyLFAoeWVi
         usHBWt6FMRXO085G7dUSBLjfug5BEq+uyE9gM0dCjopgN1mzeg7LgC6M+1mDUtIxg4
         yLaCMeAECE5Og==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 17/24] KVM: arm64: Add generic hyp_memcache helpers
Date:   Thu, 30 Jun 2022 14:57:40 +0100
Message-Id: <20220630135747.26983-18-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

The host and hypervisor will need to dynamically exchange memory pages
soon. Indeed, the hypervisor will rely on the host to donate memory
pages it can use to create guest stage-2 page-table and to store
metadata. In order to ease this process, introduce a struct hyp_memcache
which is essentially a linked list of available pages, indexed by
physical addresses.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h             | 57 +++++++++++++++++++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 33 +++++++++++
 arch/arm64/kvm/mmu.c                          | 26 +++++++++
 4 files changed, 118 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e91456f63161..70a2db91665d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -73,6 +73,63 @@ u32 __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
+struct kvm_hyp_memcache {
+	phys_addr_t head;
+	unsigned long nr_pages;
+};
+
+static inline void push_hyp_memcache(struct kvm_hyp_memcache *mc,
+				     phys_addr_t *p,
+				     phys_addr_t (*to_pa)(void *virt))
+{
+	*p = mc->head;
+	mc->head = to_pa(p);
+	mc->nr_pages++;
+}
+
+static inline void *pop_hyp_memcache(struct kvm_hyp_memcache *mc,
+				     void *(*to_va)(phys_addr_t phys))
+{
+	phys_addr_t *p = to_va(mc->head);
+
+	if (!mc->nr_pages)
+		return NULL;
+
+	mc->head = *p;
+	mc->nr_pages--;
+
+	return p;
+}
+
+static inline int __topup_hyp_memcache(struct kvm_hyp_memcache *mc,
+				       unsigned long min_pages,
+				       void *(*alloc_fn)(void *arg),
+				       phys_addr_t (*to_pa)(void *virt),
+				       void *arg)
+{
+	while (mc->nr_pages < min_pages) {
+		phys_addr_t *p = alloc_fn(arg);
+
+		if (!p)
+			return -ENOMEM;
+		push_hyp_memcache(mc, p, to_pa);
+	}
+
+	return 0;
+}
+
+static inline void __free_hyp_memcache(struct kvm_hyp_memcache *mc,
+				       void (*free_fn)(void *virt, void *arg),
+				       void *(*to_va)(phys_addr_t phys),
+				       void *arg)
+{
+	while (mc->nr_pages)
+		free_fn(pop_hyp_memcache(mc, to_va), arg);
+}
+
+void free_hyp_memcache(struct kvm_hyp_memcache *mc);
+int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages);
+
 struct kvm_vmid {
 	atomic64_t id;
 };
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index d11d9d68a680..36eea31a1c5f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -77,6 +77,8 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 int hyp_pin_shared_mem(void *from, void *to);
 void hyp_unpin_shared_mem(void *from, void *to);
 void reclaim_guest_pages(struct kvm_shadow_vm *vm);
+int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
+		    struct kvm_hyp_memcache *host_mc);
 
 static __always_inline void __load_host_stage2(void)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 17d689483ec4..74730376b992 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -308,3 +308,36 @@ int hyp_create_idmap(u32 hyp_va_bits)
 
 	return __pkvm_create_mappings(start, end - start, start, PAGE_HYP_EXEC);
 }
+
+static void *admit_host_page(void *arg)
+{
+	struct kvm_hyp_memcache *host_mc = arg;
+
+	if (!host_mc->nr_pages)
+		return NULL;
+
+	/*
+	 * The host still owns the pages in its memcache, so we need to go
+	 * through a full host-to-hyp donation cycle to change it. Fortunately,
+	 * __pkvm_host_donate_hyp() takes care of races for us, so if it
+	 * succeeds we're good to go.
+	 */
+	if (__pkvm_host_donate_hyp(hyp_phys_to_pfn(host_mc->head), 1))
+		return NULL;
+
+	return pop_hyp_memcache(host_mc, hyp_phys_to_virt);
+}
+
+/* Refill our local memcache by poping pages from the one provided by the host. */
+int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
+		    struct kvm_hyp_memcache *host_mc)
+{
+	struct kvm_hyp_memcache tmp = *host_mc;
+	int ret;
+
+	ret =  __topup_hyp_memcache(mc, min_pages, admit_host_page,
+				    hyp_virt_to_phys, &tmp);
+	*host_mc = tmp;
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f5651a05b6a8..5ff0eaffc60f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -772,6 +772,32 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	}
 }
 
+static void hyp_mc_free_fn(void *addr, void *unused)
+{
+	free_page((unsigned long)addr);
+}
+
+static void *hyp_mc_alloc_fn(void *unused)
+{
+	return (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+}
+
+void free_hyp_memcache(struct kvm_hyp_memcache *mc)
+{
+	if (is_protected_kvm_enabled())
+		__free_hyp_memcache(mc, hyp_mc_free_fn,
+				    kvm_host_va, NULL);
+}
+
+int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
+{
+	if (!is_protected_kvm_enabled())
+		return 0;
+
+	return __topup_hyp_memcache(mc, min_pages, hyp_mc_alloc_fn,
+				    kvm_host_pa, NULL);
+}
+
 /**
  * kvm_phys_addr_ioremap - map a device range to guest IPA
  *
-- 
2.37.0.rc0.161.g10f37bed90-goog

