Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D230E5B8301
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 10:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiINIfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 04:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiINIfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 04:35:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923C35E656
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 01:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 181A6B811C5
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 08:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46BFC433D6;
        Wed, 14 Sep 2022 08:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663144537;
        bh=2R/8W3lO/FOlP6dT5uj9sDzkn/L3Ltx8C6DCSYraMtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tiOkTN1wKM/IWGe5e+6rf7lvNNhxRTLB4XFBE6F3Ko1xN5KVILHrKGodg9lkyKFro
         kyQraYsOVBXoMj+KZQhIyD7VHpns4DocXqisrHk1Jaq3d75dtR7Mr0HdlF793MBPFy
         QFXTa7eQ6AMZ4nVDkckHYuwj8/7B+4m8So/2QVObDko0DOCL9MlgR1R/SuwH8/1zgB
         YnO4D+yY/FFTWjg31ADoxXgjtD7PXgRmoeJBYdgTgH40qYbVHmWfBgYOqpemJz2hX2
         zIXOcQHWRhMtQrHupCC0awd0lGGk2qOWJkmXiChUAUotTFOVoCMWwLHQ8IbWMQf7RK
         cM8TAWdR+e20w==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
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
Subject: [PATCH v3 08/25] KVM: arm64: Add helpers to pin memory shared with the hypervisor at EL2
Date:   Wed, 14 Sep 2022 09:34:43 +0100
Message-Id: <20220914083500.5118-9-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

Add helpers allowing the hypervisor to check whether a range of pages
are currently shared by the host, and 'pin' them if so by blocking host
unshare operations until the memory has been unpinned.

This will allow the hypervisor to take references on host-provided
data-structures (e.g. 'struct kvm') with the guarantee that these pages
will remain in a stable state until the hypervisor decides to release
them, for example during guest teardown.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  3 ++
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  7 ++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 48 +++++++++++++++++++
 3 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index c87b19b2d468..998bf165af71 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -69,6 +69,9 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
+int hyp_pin_shared_mem(void *from, void *to);
+void hyp_unpin_shared_mem(void *from, void *to);
+
 static __always_inline void __load_host_stage2(void)
 {
 	if (static_branch_likely(&kvm_protected_mode_initialized))
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 418b66a82a50..e8a78b72aabf 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -51,10 +51,15 @@ static inline void hyp_page_ref_inc(struct hyp_page *p)
 	p->refcount++;
 }
 
-static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
+static inline void hyp_page_ref_dec(struct hyp_page *p)
 {
 	BUG_ON(!p->refcount);
 	p->refcount--;
+}
+
+static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
+{
+	hyp_page_ref_dec(p);
 	return (p->refcount == 0);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index a7156fd13bc8..1262dbae7f06 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -625,6 +625,9 @@ static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
 
+	if (tx->initiator.id == PKVM_ID_HOST && hyp_page_count((void *)addr))
+		return -EBUSY;
+
 	if (__hyp_ack_skip_pgtable_check(tx))
 		return 0;
 
@@ -1038,3 +1041,48 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 
 	return ret;
 }
+
+int hyp_pin_shared_mem(void *from, void *to)
+{
+	u64 cur, start = ALIGN_DOWN((u64)from, PAGE_SIZE);
+	u64 end = PAGE_ALIGN((u64)to);
+	u64 size = end - start;
+	int ret;
+
+	host_lock_component();
+	hyp_lock_component();
+
+	ret = __host_check_page_state_range(__hyp_pa(start), size,
+					    PKVM_PAGE_SHARED_OWNED);
+	if (ret)
+		goto unlock;
+
+	ret = __hyp_check_page_state_range(start, size,
+					   PKVM_PAGE_SHARED_BORROWED);
+	if (ret)
+		goto unlock;
+
+	for (cur = start; cur < end; cur += PAGE_SIZE)
+		hyp_page_ref_inc(hyp_virt_to_page(cur));
+
+unlock:
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return ret;
+}
+
+void hyp_unpin_shared_mem(void *from, void *to)
+{
+	u64 cur, start = ALIGN_DOWN((u64)from, PAGE_SIZE);
+	u64 end = PAGE_ALIGN((u64)to);
+
+	host_lock_component();
+	hyp_lock_component();
+
+	for (cur = start; cur < end; cur += PAGE_SIZE)
+		hyp_page_ref_dec(hyp_virt_to_page(cur));
+
+	hyp_unlock_component();
+	host_unlock_component();
+}
-- 
2.37.2.789.g6183377224-goog

