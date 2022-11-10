Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1354624A1C
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 20:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiKJTDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 14:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiKJTDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 14:03:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F5B3C6F8
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 11:03:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ACAC61E13
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 19:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5767C43144;
        Thu, 10 Nov 2022 19:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668107018;
        bh=OPo/mj320HqdZsyoQ2ccnEvq8qG7W/wr/wwsirNU3ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7hefLA2ecjyPlD41ExQJ+7R0XI1kk8Svm0urMAf0dtpUmUzDtEH+QsBMv6/Jyolq
         E6GBv+vWernfyXQXfuy29ZQCyCo8kcT6yVXNbUtTd0MUAkApU85oN+GtDCSmQ8k2Bj
         kB/mtAOdSpKsIu9UeDDpyJ8StJV8YPt57pZCyAVguQa95L1lLn+euaF2KabBa8R0+m
         ZYXRFMw38lZ1qILnHU4LNei+E/hQByZaVQIjAv4w0BsQfHW6sbJ/lGsUFKavmPWqgK
         VPOsDVIiGlgaF7wZHGOhCYlsQCqVYQbQTwaz9t9vwLq7YRmHHiN3jw+nXWkekhk+69
         gjcZL5uxAXbkA==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 08/26] KVM: arm64: Add helpers to pin memory shared with the hypervisor at EL2
Date:   Thu, 10 Nov 2022 19:02:41 +0000
Message-Id: <20221110190259.26861-9-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221110190259.26861-1-will@kernel.org>
References: <20221110190259.26861-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Tested-by: Vincent Donnefort <vdonnefort@google.com>
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
index 9422900e5c6a..ab205c4d6774 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -55,10 +55,15 @@ static inline void hyp_page_ref_inc(struct hyp_page *p)
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
index f7e3afaf9f11..83c2f67e1b58 100644
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
2.38.1.431.g37b22c650d-goog

