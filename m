Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847B7600E39
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiJQLxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiJQLxj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:53:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C505A151
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:53:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C3A56109E
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEDFC433C1;
        Mon, 17 Oct 2022 11:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007602;
        bh=ZLSfew7ixQDK0MJ4/GsqTNTelBXSBHLYEIoBcTsc+iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3D+8xEC4Suh5OAuAlSLjYJHM0Xx5mk8LnF9KSZCGQtRiynnSBXuCNf8CZyq7SsVI
         yQQ1oT1KeFSL6PLzvnJ27TA2iOndG2FVf15qrbRi8ADFmfjLSg/UfdZ+6yzqpJr5Wc
         839H217eITPtH7Cqq2+QmuDCh/R3PGSPJ0Kdh+OzIZ2TW38qlCnQe1rodKxBQFvazL
         tktOWSkpJdA+Hvt8Euk2BH5HK16V6ldr6xf0BvKoBgyRcgO8BpqEQiQWMxVkqXAMO2
         DMp7LfBNDdeuCf8easeHDmY46Hzfu/+lbRrMqNqgGAs7Zism6UvxK943aBL72ZYTNb
         6U+r1BBoNXXEg==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 17/25] KVM: arm64: Add generic hyp_memcache helpers
Date:   Mon, 17 Oct 2022 12:52:01 +0100
Message-Id: <20221017115209.2099-18-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221017115209.2099-1-will@kernel.org>
References: <20221017115209.2099-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

The host at EL1 and the pKVM hypervisor at EL2 will soon need to
exchange memory pages dynamically for creating and destroying VM state.

Indeed, the hypervisor will rely on the host to donate memory pages it
can use to create guest stage-2 page-tables and to store VM and vCPU
metadata. In order to ease this process, introduce a
'struct hyp_memcache' which is essentially a linked list of available
pages, indexed by physical addresses so that it can be passed
meaningfully between the different virtual address spaces configured at
EL1 and EL2.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h             | 57 +++++++++++++++++++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 33 +++++++++++
 arch/arm64/kvm/mmu.c                          | 26 +++++++++
 4 files changed, 118 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f09b422ba1fe..2ec268cc2031 100644
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
index ef31a1872c93..420b87e755a4 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -77,6 +77,8 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 int hyp_pin_shared_mem(void *from, void *to);
 void hyp_unpin_shared_mem(void *from, void *to);
 void reclaim_guest_pages(struct pkvm_hyp_vm *vm);
+int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
+		    struct kvm_hyp_memcache *host_mc);
 
 static __always_inline void __load_host_stage2(void)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index b77215630d5c..c73f87f13e29 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -330,3 +330,36 @@ int hyp_create_idmap(u32 hyp_va_bits)
 
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
index 34c5feed9dc1..8b52566d1cb9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -800,6 +800,32 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
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
2.38.0.413.g74048e4d9e-goog

