Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AEB610C4E
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 10:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiJ1IfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 04:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJ1IfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 04:35:17 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2310157E2A
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 01:35:14 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666946112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v7nGyF+ceJAPPHWcftx0juhP6HRqQm3ngJatvgO9sUI=;
        b=Gae7eGv2LwLyo+LbbLw0k0Ox6RF3/w4UaJkt2l0kvYN26ajznzk10KCzsxxwHkGO4DMkEb
        qgZpFVZXPkZvqlBRAtq//88V5LCuptcF0avbLXtWOyk7tMWSGQu+k+ZLKaGsp4HQNMYuzw
        Kuvvq+Mcysj4qMcYuZ8T7egAp4KqMYM=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Quentin Perret <qperret@google.com>,
        kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
        Fuad Tabba <tabba@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] KVM: arm64: Clean out the odd handling of completer_addr
Date:   Fri, 28 Oct 2022 08:34:47 +0000
Message-Id: <20221028083448.1998389-2-oliver.upton@linux.dev>
In-Reply-To: <20221028083448.1998389-1-oliver.upton@linux.dev>
References: <20221028083448.1998389-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The layout of struct pkvm_mem_transition is a bit weird; the destination
address for the transition is actually stashed in the initiator address
context. Even weirder so, that address is thrown inside a union and
return from helpers by use of an out pointer.

Rip out the whole mess and move the destination address into the
destination context sub-struct. No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 70 ++++++++++-----------------
 1 file changed, 25 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1e78acf9662e..3636a24e1b34 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -393,17 +393,12 @@ struct pkvm_mem_transition {
 		enum pkvm_component_id	id;
 		/* Address in the initiator's address space */
 		u64			addr;
-
-		union {
-			struct {
-				/* Address in the completer's address space */
-				u64	completer_addr;
-			} host;
-		};
 	} initiator;
 
 	struct {
 		enum pkvm_component_id	id;
+		/* Address in the completer's address space */
+		u64			addr;
 	} completer;
 };
 
@@ -471,43 +466,35 @@ static int __host_set_page_state_range(u64 addr, u64 size,
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
 
@@ -537,7 +524,7 @@ static bool __hyp_ack_skip_pgtable_check(const struct pkvm_mem_transition *tx)
 		 tx->initiator.id != PKVM_ID_HOST);
 }
 
-static int hyp_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
+static int hyp_ack_share(const struct pkvm_mem_transition *tx,
 			 enum kvm_pgtable_prot perms)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
@@ -548,34 +535,35 @@ static int hyp_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
 	if (__hyp_ack_skip_pgtable_check(tx))
 		return 0;
 
-	return __hyp_check_page_state_range(addr, size, PKVM_NOPAGE);
+	return __hyp_check_page_state_range(tx->completer.addr, size, PKVM_NOPAGE);
 }
 
-static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
+static int hyp_ack_unshare(const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
 
 	if (__hyp_ack_skip_pgtable_check(tx))
 		return 0;
 
-	return __hyp_check_page_state_range(addr, size,
+	return __hyp_check_page_state_range(tx->completer.addr, size,
 					    PKVM_PAGE_SHARED_BORROWED);
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
@@ -583,12 +571,11 @@ static int hyp_complete_unshare(u64 addr, const struct pkvm_mem_transition *tx)
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
@@ -599,7 +586,7 @@ static int check_share(struct pkvm_mem_share *share)
 
 	switch (tx->completer.id) {
 	case PKVM_ID_HYP:
-		ret = hyp_ack_share(completer_addr, tx, share->completer_prot);
+		ret = hyp_ack_share(tx, share->completer_prot);
 		break;
 	default:
 		ret = -EINVAL;
@@ -611,12 +598,11 @@ static int check_share(struct pkvm_mem_share *share)
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
@@ -627,7 +613,7 @@ static int __do_share(struct pkvm_mem_share *share)
 
 	switch (tx->completer.id) {
 	case PKVM_ID_HYP:
-		ret = hyp_complete_share(completer_addr, tx, share->completer_prot);
+		ret = hyp_complete_share(tx, share->completer_prot);
 		break;
 	default:
 		ret = -EINVAL;
@@ -659,12 +645,11 @@ static int do_share(struct pkvm_mem_share *share)
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
@@ -675,7 +660,7 @@ static int check_unshare(struct pkvm_mem_share *share)
 
 	switch (tx->completer.id) {
 	case PKVM_ID_HYP:
-		ret = hyp_ack_unshare(completer_addr, tx);
+		ret = hyp_ack_unshare(tx);
 		break;
 	default:
 		ret = -EINVAL;
@@ -687,12 +672,11 @@ static int check_unshare(struct pkvm_mem_share *share)
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
@@ -703,7 +687,7 @@ static int __do_unshare(struct pkvm_mem_share *share)
 
 	switch (tx->completer.id) {
 	case PKVM_ID_HYP:
-		ret = hyp_complete_unshare(completer_addr, tx);
+		ret = hyp_complete_unshare(tx);
 		break;
 	default:
 		ret = -EINVAL;
@@ -743,12 +727,10 @@ int __pkvm_host_share_hyp(u64 pfn)
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
@@ -776,12 +758,10 @@ int __pkvm_host_unshare_hyp(u64 pfn)
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
-- 
2.38.1.273.g43a17bfeac-goog

