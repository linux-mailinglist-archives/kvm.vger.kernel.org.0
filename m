Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C40561CFF
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiF3OOF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237509AbiF3ONY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:13:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2380A37A90
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6B03B82AF3
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 13:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330B1C36AE2;
        Thu, 30 Jun 2022 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656597511;
        bh=V/L/0x+OKaLzrUxstXASpxXa331O8AEl8jt8xmSkGQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9/7jZzOmwgkz88fObBL8dl4MgH2ZTknKClhvobiXJYIg/gjUOKE4MEVREqXKRx/p
         RqJG9QBUzxHUiEIOdtrLb/iuH7MwwrPnd70t17h2R2Tb4Y4xfwm3F048O/v6MWXRDG
         zaoEK0q4FHu/A8TFegMoAk1tOCnrno7Tj3wn6P7pM5SogiKIg+QfNMrp5uA4Qw2VPs
         1nj3+PXXU2b46aHQBaxmmrrPHa3c998h6zBwhVJgauo+jeDZXzwt57leeJuWnbcVpe
         SLSp/V9SXG+JGi81gUeyIgMXL1y9OmijfYBbcZm0BS4lEyRTHK434M38RzfD/T2KPH
         CMp6/Lsu+o55g==
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
Subject: [PATCH v2 09/24] KVM: arm64: Add helpers to pin memory shared with hyp
Date:   Thu, 30 Jun 2022 14:57:32 +0100
Message-Id: <20220630135747.26983-10-will@kernel.org>
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

Add helpers allowing the hypervisor to check whether a range of pages
are currently shared by the host, and 'pin' them if so by blocking host
unshare operations until the memory has been unpinned. This will allow
the hypervisor to take references on host-provided data-structures
(struct kvm and such) and be guaranteed these pages will remain in a
stable state until it decides to release them, e.g. during guest
teardown.

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
index 2681f632e1c1..29f2ebe306bc 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -52,10 +52,15 @@ static inline void hyp_page_ref_inc(struct hyp_page *p)
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
index e7015bbefbea..e2e3b30b072e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -629,6 +629,9 @@ static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
 
+	if (tx->initiator.id == PKVM_ID_HOST && hyp_page_count((void *)addr))
+		return -EBUSY;
+
 	if (__hyp_ack_skip_pgtable_check(tx))
 		return 0;
 
@@ -1042,3 +1045,48 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 
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
2.37.0.rc0.161.g10f37bed90-goog

