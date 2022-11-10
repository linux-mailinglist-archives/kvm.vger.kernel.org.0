Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E56A624A36
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 20:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiKJTFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 14:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiKJTEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 14:04:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB69745EE0
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 11:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BB4061E12
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 19:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECFDC433C1;
        Thu, 10 Nov 2022 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668107080;
        bh=1KJO8iA6xVHfnIq1ZFiL1RKJbbbrtLlsLB0pcQj4/Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCKAIv8kfapc/4oI1qg4JSMH5Tcj8oRkVLHN7Euh5YzyrbRnSUFi0l1afqx2weURZ
         XAjXaedJjmC0SsrwVibCLAQepYzCTdbbLzHw6o9JWrtSquxV1Ej30A6FNpHOdfPQFo
         D6dghI9YLR8axfJV8dVlTG8wIjLGR21cvIWKmAHNbHR+MxiG/buz+HsyFDRnZZAdzB
         d4vkltFL+wTjGraAxRPeHdEl3cFiEnMR4CYhScyEGdCMK0DgAz0Ba/7IUJGoY+QmyR
         1pXGuicM9R+JpR2Aiu+BjuwYzAPhVkVu1Wm/Yij2N7FRDvNHJjEp8H5tCZDRBEZ7Fl
         k8oxN92B54a7w==
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
Subject: [PATCH v6 25/26] KVM: arm64: Clean out the odd handling of completer_addr
Date:   Thu, 10 Nov 2022 19:02:58 +0000
Message-Id: <20221110190259.26861-26-will@kernel.org>
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

From: Oliver Upton <oliver.upton@linux.dev>

The layout of struct pkvm_mem_transition is a bit weird; the destination
address for the transition is actually stashed in the initiator address
context. Even weirder so, that address is thrown inside a union and
return from helpers by use of an out pointer.

Rip out the whole mess and move the destination address into the
destination context sub-struct. No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
[will: Extended to include host/hyp donation paths]
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 130 ++++++++++----------------
 1 file changed, 48 insertions(+), 82 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 94cd48f7850e..dfeddaf2a462 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -534,20 +534,12 @@ struct pkvm_mem_transition {
 		enum pkvm_component_id	id;
 		/* Address in the initiator's address space */
 		u64			addr;
-
-		union {
-			struct {
-				/* Address in the completer's address space */
-				u64	completer_addr;
-			} host;
-			struct {
-				u64	completer_addr;
-			} hyp;
-		};
 	} initiator;
 
 	struct {
 		enum pkvm_component_id	id;
+		/* Address in the completer's address space */
+		u64			addr;
 	} completer;
 };
 
@@ -619,53 +611,43 @@ static int __host_set_page_state_range(u64 addr, u64 size,
 	return host_stage2_idmap_locked(addr, size, prot);
 }
 
-static int host_request_owned_transition(u64 *completer_addr,
-					 const struct pkvm_mem_transition *tx)
+static int host_request_owned_transition(const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
 	u64 addr = tx->initiator.addr;
 
-	*completer_addr = tx->initiator.host.completer_addr;
 	return __host_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
 }
 
-static int host_request_unshare(u64 *completer_addr,
-				const struct pkvm_mem_transition *tx)
+static int host_request_unshare(const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
 	u64 addr = tx->initiator.addr;
 
-	*completer_addr = tx->initiator.host.completer_addr;
 	return __host_check_page_state_range(addr, size, PKVM_PAGE_SHARED_OWNED);
 }
 
-static int host_initiate_share(u64 *completer_addr,
-			       const struct pkvm_mem_transition *tx)
+static int host_initiate_share(const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
 	u64 addr = tx->initiator.addr;
 
-	*completer_addr = tx->initiator.host.completer_addr;
 	return __host_set_page_state_range(addr, size, PKVM_PAGE_SHARED_OWNED);
 }
 
-static int host_initiate_unshare(u64 *completer_addr,
-				 const struct pkvm_mem_transition *tx)
+static int host_initiate_unshare(const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
 	u64 addr = tx->initiator.addr;
 
-	*completer_addr = tx->initiator.host.completer_addr;
 	return __host_set_page_state_range(addr, size, PKVM_PAGE_OWNED);
 }
 
-static int host_initiate_donation(u64 *completer_addr,
-				  const struct pkvm_mem_transition *tx)
+static int host_initiate_donation(const struct pkvm_mem_transition *tx)
 {
 	u8 owner_id = tx->completer.id;
 	u64 size = tx->nr_pages * PAGE_SIZE;
 
-	*completer_addr = tx->initiator.host.completer_addr;
 	return host_stage2_set_owner_locked(tx->initiator.addr, size, owner_id);
 }
 
@@ -686,17 +668,17 @@ static int __host_ack_transition(u64 addr, const struct pkvm_mem_transition *tx,
 	return __host_check_page_state_range(addr, size, state);
 }
 
-static int host_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
+static int host_ack_donation(const struct pkvm_mem_transition *tx)
 {
-	return __host_ack_transition(addr, tx, PKVM_NOPAGE);
+	return __host_ack_transition(tx->completer.addr, tx, PKVM_NOPAGE);
 }
 
-static int host_complete_donation(u64 addr, const struct pkvm_mem_transition *tx)
+static int host_complete_donation(const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
 	u8 host_id = tx->completer.id;
 
-	return host_stage2_set_owner_locked(addr, size, host_id);
+	return host_stage2_set_owner_locked(tx->completer.addr, size, host_id);
 }
 
 static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte)
@@ -719,23 +701,19 @@ static int __hyp_check_page_state_range(u64 addr, u64 size,
 	return check_page_state_range(&pkvm_pgtable, addr, size, &d);
 }
 
-static int hyp_request_donation(u64 *completer_addr,
-				const struct pkvm_mem_transition *tx)
+static int hyp_request_donation(const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
 	u64 addr = tx->initiator.addr;
 
-	*completer_addr = tx->initiator.hyp.completer_addr;
 	return __hyp_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
 }
 
-static int hyp_initiate_donation(u64 *completer_addr,
-				 const struct pkvm_mem_transition *tx)
+static int hyp_initiate_donation(const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
 	int ret;
 
-	*completer_addr = tx->initiator.hyp.completer_addr;
 	ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, tx->initiator.addr, size);
 	return (ret != size) ? -EFAULT : 0;
 }
@@ -746,7 +724,7 @@ static bool __hyp_ack_skip_pgtable_check(const struct pkvm_mem_transition *tx)
 		 tx->initiator.id != PKVM_ID_HOST);
 }
 
-static int hyp_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
+static int hyp_ack_share(const struct pkvm_mem_transition *tx,
 			 enum kvm_pgtable_prot perms)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
@@ -757,12 +735,12 @@ static int hyp_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
 	if (__hyp_ack_skip_pgtable_check(tx))
 		return 0;
 
-	return __hyp_check_page_state_range(addr, size, PKVM_NOPAGE);
+	return __hyp_check_page_state_range(tx->completer.addr, size, PKVM_NOPAGE);
 }
 
-static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
+static int hyp_ack_unshare(const struct pkvm_mem_transition *tx)
 {
-	u64 size = tx->nr_pages * PAGE_SIZE;
+	u64 size = tx->nr_pages * PAGE_SIZE, addr = tx->completer.addr;
 
 	if (tx->initiator.id == PKVM_ID_HOST && hyp_page_count((void *)addr))
 		return -EBUSY;
@@ -774,38 +752,40 @@ static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
 					    PKVM_PAGE_SHARED_BORROWED);
 }
 
-static int hyp_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
+static int hyp_ack_donation(const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
 
 	if (__hyp_ack_skip_pgtable_check(tx))
 		return 0;
 
-	return __hyp_check_page_state_range(addr, size, PKVM_NOPAGE);
+	return __hyp_check_page_state_range(tx->completer.addr, size,
+					    PKVM_NOPAGE);
 }
 
-static int hyp_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
+static int hyp_complete_share(const struct pkvm_mem_transition *tx,
 			      enum kvm_pgtable_prot perms)
 {
-	void *start = (void *)addr, *end = start + (tx->nr_pages * PAGE_SIZE);
+	void *start = (void *)tx->completer.addr;
+	void *end = start + (tx->nr_pages * PAGE_SIZE);
 	enum kvm_pgtable_prot prot;
 
 	prot = pkvm_mkstate(perms, PKVM_PAGE_SHARED_BORROWED);
 	return pkvm_create_mappings_locked(start, end, prot);
 }
 
-static int hyp_complete_unshare(u64 addr, const struct pkvm_mem_transition *tx)
+static int hyp_complete_unshare(const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
-	int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, addr, size);
+	int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, tx->completer.addr, size);
 
 	return (ret != size) ? -EFAULT : 0;
 }
 
-static int hyp_complete_donation(u64 addr,
-				 const struct pkvm_mem_transition *tx)
+static int hyp_complete_donation(const struct pkvm_mem_transition *tx)
 {
-	void *start = (void *)addr, *end = start + (tx->nr_pages * PAGE_SIZE);
+	void *start = (void *)tx->completer.addr;
+	void *end = start + (tx->nr_pages * PAGE_SIZE);
 	enum kvm_pgtable_prot prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_OWNED);
 
 	return pkvm_create_mappings_locked(start, end, prot);
@@ -814,12 +794,11 @@ static int hyp_complete_donation(u64 addr,
 static int check_share(struct pkvm_mem_share *share)
 {
 	const struct pkvm_mem_transition *tx = &share->tx;
-	u64 completer_addr;
 	int ret;
 
 	switch (tx->initiator.id) {
 	case PKVM_ID_HOST:
-		ret = host_request_owned_transition(&completer_addr, tx);
+		ret = host_request_owned_transition(tx);
 		break;
 	default:
 		ret = -EINVAL;
@@ -830,7 +809,7 @@ static int check_share(struct pkvm_mem_share *share)
 
 	switch (tx->completer.id) {
 	case PKVM_ID_HYP:
-		ret = hyp_ack_share(completer_addr, tx, share->completer_prot);
+		ret = hyp_ack_share(tx, share->completer_prot);
 		break;
 	default:
 		ret = -EINVAL;
@@ -842,12 +821,11 @@ static int check_share(struct pkvm_mem_share *share)
 static int __do_share(struct pkvm_mem_share *share)
 {
 	const struct pkvm_mem_transition *tx = &share->tx;
-	u64 completer_addr;
 	int ret;
 
 	switch (tx->initiator.id) {
 	case PKVM_ID_HOST:
-		ret = host_initiate_share(&completer_addr, tx);
+		ret = host_initiate_share(tx);
 		break;
 	default:
 		ret = -EINVAL;
@@ -858,7 +836,7 @@ static int __do_share(struct pkvm_mem_share *share)
 
 	switch (tx->completer.id) {
 	case PKVM_ID_HYP:
-		ret = hyp_complete_share(completer_addr, tx, share->completer_prot);
+		ret = hyp_complete_share(tx, share->completer_prot);
 		break;
 	default:
 		ret = -EINVAL;
@@ -890,12 +868,11 @@ static int do_share(struct pkvm_mem_share *share)
 static int check_unshare(struct pkvm_mem_share *share)
 {
 	const struct pkvm_mem_transition *tx = &share->tx;
-	u64 completer_addr;
 	int ret;
 
 	switch (tx->initiator.id) {
 	case PKVM_ID_HOST:
-		ret = host_request_unshare(&completer_addr, tx);
+		ret = host_request_unshare(tx);
 		break;
 	default:
 		ret = -EINVAL;
@@ -906,7 +883,7 @@ static int check_unshare(struct pkvm_mem_share *share)
 
 	switch (tx->completer.id) {
 	case PKVM_ID_HYP:
-		ret = hyp_ack_unshare(completer_addr, tx);
+		ret = hyp_ack_unshare(tx);
 		break;
 	default:
 		ret = -EINVAL;
@@ -918,12 +895,11 @@ static int check_unshare(struct pkvm_mem_share *share)
 static int __do_unshare(struct pkvm_mem_share *share)
 {
 	const struct pkvm_mem_transition *tx = &share->tx;
-	u64 completer_addr;
 	int ret;
 
 	switch (tx->initiator.id) {
 	case PKVM_ID_HOST:
-		ret = host_initiate_unshare(&completer_addr, tx);
+		ret = host_initiate_unshare(tx);
 		break;
 	default:
 		ret = -EINVAL;
@@ -934,7 +910,7 @@ static int __do_unshare(struct pkvm_mem_share *share)
 
 	switch (tx->completer.id) {
 	case PKVM_ID_HYP:
-		ret = hyp_complete_unshare(completer_addr, tx);
+		ret = hyp_complete_unshare(tx);
 		break;
 	default:
 		ret = -EINVAL;
@@ -966,15 +942,14 @@ static int do_unshare(struct pkvm_mem_share *share)
 static int check_donation(struct pkvm_mem_donation *donation)
 {
 	const struct pkvm_mem_transition *tx = &donation->tx;
-	u64 completer_addr;
 	int ret;
 
 	switch (tx->initiator.id) {
 	case PKVM_ID_HOST:
-		ret = host_request_owned_transition(&completer_addr, tx);
+		ret = host_request_owned_transition(tx);
 		break;
 	case PKVM_ID_HYP:
-		ret = hyp_request_donation(&completer_addr, tx);
+		ret = hyp_request_donation(tx);
 		break;
 	default:
 		ret = -EINVAL;
@@ -985,10 +960,10 @@ static int check_donation(struct pkvm_mem_donation *donation)
 
 	switch (tx->completer.id) {
 	case PKVM_ID_HOST:
-		ret = host_ack_donation(completer_addr, tx);
+		ret = host_ack_donation(tx);
 		break;
 	case PKVM_ID_HYP:
-		ret = hyp_ack_donation(completer_addr, tx);
+		ret = hyp_ack_donation(tx);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1000,15 +975,14 @@ static int check_donation(struct pkvm_mem_donation *donation)
 static int __do_donate(struct pkvm_mem_donation *donation)
 {
 	const struct pkvm_mem_transition *tx = &donation->tx;
-	u64 completer_addr;
 	int ret;
 
 	switch (tx->initiator.id) {
 	case PKVM_ID_HOST:
-		ret = host_initiate_donation(&completer_addr, tx);
+		ret = host_initiate_donation(tx);
 		break;
 	case PKVM_ID_HYP:
-		ret = hyp_initiate_donation(&completer_addr, tx);
+		ret = hyp_initiate_donation(tx);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1019,10 +993,10 @@ static int __do_donate(struct pkvm_mem_donation *donation)
 
 	switch (tx->completer.id) {
 	case PKVM_ID_HOST:
-		ret = host_complete_donation(completer_addr, tx);
+		ret = host_complete_donation(tx);
 		break;
 	case PKVM_ID_HYP:
-		ret = hyp_complete_donation(completer_addr, tx);
+		ret = hyp_complete_donation(tx);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1062,12 +1036,10 @@ int __pkvm_host_share_hyp(u64 pfn)
 			.initiator	= {
 				.id	= PKVM_ID_HOST,
 				.addr	= host_addr,
-				.host	= {
-					.completer_addr = hyp_addr,
-				},
 			},
 			.completer	= {
 				.id	= PKVM_ID_HYP,
+				.addr	= hyp_addr,
 			},
 		},
 		.completer_prot	= PAGE_HYP,
@@ -1095,12 +1067,10 @@ int __pkvm_host_unshare_hyp(u64 pfn)
 			.initiator	= {
 				.id	= PKVM_ID_HOST,
 				.addr	= host_addr,
-				.host	= {
-					.completer_addr = hyp_addr,
-				},
 			},
 			.completer	= {
 				.id	= PKVM_ID_HYP,
+				.addr	= hyp_addr,
 			},
 		},
 		.completer_prot	= PAGE_HYP,
@@ -1128,12 +1098,10 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 			.initiator	= {
 				.id	= PKVM_ID_HOST,
 				.addr	= host_addr,
-				.host	= {
-					.completer_addr = hyp_addr,
-				},
 			},
 			.completer	= {
 				.id	= PKVM_ID_HYP,
+				.addr	= hyp_addr,
 			},
 		},
 	};
@@ -1160,12 +1128,10 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 			.initiator	= {
 				.id	= PKVM_ID_HYP,
 				.addr	= hyp_addr,
-				.hyp	= {
-					.completer_addr = host_addr,
-				},
 			},
 			.completer	= {
 				.id	= PKVM_ID_HOST,
+				.addr	= host_addr,
 			},
 		},
 	};
-- 
2.38.1.431.g37b22c650d-goog

