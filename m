Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8635600E2B
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiJQLw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiJQLwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:52:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043C321269
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0399EB812A1
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4B1C433D7;
        Mon, 17 Oct 2022 11:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007563;
        bh=wHXJvKczYaZBPZiAQZnXAnjt2K3HIwXbQYMdzt9dcY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAbTgA5rwEvECI46G5+IEo8SWUJnY7wmAz2G+hrdJh/M4zZMOHrkzcfIRjYE+wcmC
         2q4qoPpQjy932/cFwYl2d06efrqDhaEd+WCgM1hIfpuLx/YAbYcgIfyRRhbAkx7Os9
         TEy+EtgdsZzI82XLB6fmNlkVPOjhl21yxSye/yEDD4a1krmm+VBKG99KZrvzoSAExp
         XhdBMjGHaBhDLl3z6PCctozD5OSkQ2GmXxYoWKOzDy+2CYTUQYQPr98R89W3XJonRs
         t2C/aYmy1BI2XQajEufm23BkWyMwVQlzFKDlm3THzw5Xuhg5p8MU+/i8KHlDE/pUjb
         5g9+mJBIbEoww==
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
Subject: [PATCH v4 06/25] KVM: arm64: Implement do_donate() helper for donating memory
Date:   Mon, 17 Oct 2022 12:51:50 +0100
Message-Id: <20221017115209.2099-7-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221017115209.2099-1-will@kernel.org>
References: <20221017115209.2099-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

Transferring ownership information of a memory region from one component
to another can be achieved using a "donate" operation, which results
in the previous owner losing access to the underlying pages entirely
and the new owner having exclusive access to the page.

Implement a do_donate() helper, along the same lines as do_{un,}share,
and provide this functionality for the host-{to,from}-hyp cases as this
will later be used to donate/reclaim memory pages to store VM metadata
at EL2.

In a similar manner to the sharing transitions, permission checks are
performed by the hypervisor to ensure that the component initiating the
transition really is the owner of the page and also that the completer
does not currently have a page mapped at the target address.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 239 ++++++++++++++++++
 2 files changed, 241 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index f5705a1e972f..c87b19b2d468 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -60,6 +60,8 @@ enum pkvm_component_id {
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
+int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
+int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index ff86f5bd230f..c30402737548 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -391,6 +391,9 @@ struct pkvm_mem_transition {
 				/* Address in the completer's address space */
 				u64	completer_addr;
 			} host;
+			struct {
+				u64	completer_addr;
+			} hyp;
 		};
 	} initiator;
 
@@ -404,6 +407,10 @@ struct pkvm_mem_share {
 	const enum kvm_pgtable_prot		completer_prot;
 };
 
+struct pkvm_mem_donation {
+	const struct pkvm_mem_transition	tx;
+};
+
 struct check_walk_data {
 	enum pkvm_page_state	desired;
 	enum pkvm_page_state	(*get_page_state)(kvm_pte_t pte);
@@ -503,6 +510,46 @@ static int host_initiate_unshare(u64 *completer_addr,
 	return __host_set_page_state_range(addr, size, PKVM_PAGE_OWNED);
 }
 
+static int host_initiate_donation(u64 *completer_addr,
+				  const struct pkvm_mem_transition *tx)
+{
+	u8 owner_id = tx->completer.id;
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	*completer_addr = tx->initiator.host.completer_addr;
+	return host_stage2_set_owner_locked(tx->initiator.addr, size, owner_id);
+}
+
+static bool __host_ack_skip_pgtable_check(const struct pkvm_mem_transition *tx)
+{
+	return !(IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) ||
+		 tx->initiator.id != PKVM_ID_HYP);
+}
+
+static int __host_ack_transition(u64 addr, const struct pkvm_mem_transition *tx,
+				 enum pkvm_page_state state)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	if (__host_ack_skip_pgtable_check(tx))
+		return 0;
+
+	return __host_check_page_state_range(addr, size, state);
+}
+
+static int host_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	return __host_ack_transition(addr, tx, PKVM_NOPAGE);
+}
+
+static int host_complete_donation(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	u8 host_id = tx->completer.id;
+
+	return host_stage2_set_owner_locked(addr, size, host_id);
+}
+
 static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte)
 {
 	if (!kvm_pte_valid(pte))
@@ -523,6 +570,27 @@ static int __hyp_check_page_state_range(u64 addr, u64 size,
 	return check_page_state_range(&pkvm_pgtable, addr, size, &d);
 }
 
+static int hyp_request_donation(u64 *completer_addr,
+				const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	u64 addr = tx->initiator.addr;
+
+	*completer_addr = tx->initiator.hyp.completer_addr;
+	return __hyp_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
+}
+
+static int hyp_initiate_donation(u64 *completer_addr,
+				 const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	int ret;
+
+	*completer_addr = tx->initiator.hyp.completer_addr;
+	ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, tx->initiator.addr, size);
+	return (ret != size) ? -EFAULT : 0;
+}
+
 static bool __hyp_ack_skip_pgtable_check(const struct pkvm_mem_transition *tx)
 {
 	return !(IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) ||
@@ -554,6 +622,16 @@ static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
 					    PKVM_PAGE_SHARED_BORROWED);
 }
 
+static int hyp_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	if (__hyp_ack_skip_pgtable_check(tx))
+		return 0;
+
+	return __hyp_check_page_state_range(addr, size, PKVM_NOPAGE);
+}
+
 static int hyp_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
 			      enum kvm_pgtable_prot perms)
 {
@@ -572,6 +650,15 @@ static int hyp_complete_unshare(u64 addr, const struct pkvm_mem_transition *tx)
 	return (ret != size) ? -EFAULT : 0;
 }
 
+static int hyp_complete_donation(u64 addr,
+				 const struct pkvm_mem_transition *tx)
+{
+	void *start = (void *)addr, *end = start + (tx->nr_pages * PAGE_SIZE);
+	enum kvm_pgtable_prot prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_OWNED);
+
+	return pkvm_create_mappings_locked(start, end, prot);
+}
+
 static int check_share(struct pkvm_mem_share *share)
 {
 	const struct pkvm_mem_transition *tx = &share->tx;
@@ -724,6 +811,94 @@ static int do_unshare(struct pkvm_mem_share *share)
 	return WARN_ON(__do_unshare(share));
 }
 
+static int check_donation(struct pkvm_mem_donation *donation)
+{
+	const struct pkvm_mem_transition *tx = &donation->tx;
+	u64 completer_addr;
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_request_owned_transition(&completer_addr, tx);
+		break;
+	case PKVM_ID_HYP:
+		ret = hyp_request_donation(&completer_addr, tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+
+	switch (tx->completer.id){
+	case PKVM_ID_HOST:
+		ret = host_ack_donation(completer_addr, tx);
+		break;
+	case PKVM_ID_HYP:
+		ret = hyp_ack_donation(completer_addr, tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int __do_donate(struct pkvm_mem_donation *donation)
+{
+	const struct pkvm_mem_transition *tx = &donation->tx;
+	u64 completer_addr;
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_initiate_donation(&completer_addr, tx);
+		break;
+	case PKVM_ID_HYP:
+		ret = hyp_initiate_donation(&completer_addr, tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+
+	switch (tx->completer.id){
+	case PKVM_ID_HOST:
+		ret = host_complete_donation(completer_addr, tx);
+		break;
+	case PKVM_ID_HYP:
+		ret = hyp_complete_donation(completer_addr, tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/*
+ * do_donate():
+ *
+ * The page owner transfers ownership to another component, losing access
+ * as a consequence.
+ *
+ * Initiator: OWNED	=> NOPAGE
+ * Completer: NOPAGE	=> OWNED
+ */
+static int do_donate(struct pkvm_mem_donation *donation)
+{
+	int ret;
+
+	ret = check_donation(donation);
+	if (ret)
+		return ret;
+
+	return WARN_ON(__do_donate(donation));
+}
+
 int __pkvm_host_share_hyp(u64 pfn)
 {
 	int ret;
@@ -789,3 +964,67 @@ int __pkvm_host_unshare_hyp(u64 pfn)
 
 	return ret;
 }
+
+int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
+{
+	int ret;
+	u64 host_addr = hyp_pfn_to_phys(pfn);
+	u64 hyp_addr = (u64)__hyp_va(host_addr);
+	struct pkvm_mem_donation donation = {
+		.tx	= {
+			.nr_pages	= nr_pages,
+			.initiator	= {
+				.id	= PKVM_ID_HOST,
+				.addr	= host_addr,
+				.host	= {
+					.completer_addr = hyp_addr,
+				},
+			},
+			.completer	= {
+				.id	= PKVM_ID_HYP,
+			},
+		},
+	};
+
+	host_lock_component();
+	hyp_lock_component();
+
+	ret = do_donate(&donation);
+
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return ret;
+}
+
+int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
+{
+	int ret;
+	u64 host_addr = hyp_pfn_to_phys(pfn);
+	u64 hyp_addr = (u64)__hyp_va(host_addr);
+	struct pkvm_mem_donation donation = {
+		.tx	= {
+			.nr_pages	= nr_pages,
+			.initiator	= {
+				.id	= PKVM_ID_HYP,
+				.addr	= hyp_addr,
+				.hyp	= {
+					.completer_addr = host_addr,
+				},
+			},
+			.completer	= {
+				.id	= PKVM_ID_HOST,
+			},
+		},
+	};
+
+	host_lock_component();
+	hyp_lock_component();
+
+	ret = do_donate(&donation);
+
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.38.0.413.g74048e4d9e-goog

