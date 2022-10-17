Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB19B600E27
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiJQLwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiJQLwb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:52:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EA622BF8
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:52:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18DDB610A0
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764C5C433C1;
        Mon, 17 Oct 2022 11:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007549;
        bh=yEAREzQrE4OzDm8tjXcid5kmoNA03bQzioyQnganDwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqExlozjMaYbuK8eyaZW+XPhKqnpqREY2VKOWn5Y7y8NkBhIHcu7mzLy+kUbuE/39
         yWhwDISRKO4M3IQoySONehxdAQXplYhseMpq8GIgn6tPYfRdErLqa1PUnOqsFsmHyf
         XgS2IlPNYcaWQhJwlaGzaAdXGfEKloct3YPVDK3UuOrpeQvHqo+wJZfxvnGpGUeSFg
         yNVZVmbQIy26CpIl+BlVEyehAuVobLtnDhmKp70gSUAjQdTGpRRilTZHEUfiZoFbb6
         1Raq5IddRJ6+sWWR8CrzIJyEk7oUwYuV79OCA7Pt2FXCQ++nB7cX78Af3h8GDR+Gd3
         RCeRiWgxJBMuw==
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
Subject: [PATCH v4 02/25] KVM: arm64: Allow attaching of non-coalescable pages to a hyp pool
Date:   Mon, 17 Oct 2022 12:51:46 +0100
Message-Id: <20221017115209.2099-3-will@kernel.org>
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

All the contiguous pages used to initialize a 'struct hyp_pool' are
considered coalescable, which means that the hyp page allocator will
actively try to merge them with their buddies on the hyp_put_page() path.
However, using hyp_put_page() on a page that is not part of the inital
memory range given to a hyp_pool() is currently unsupported.

In order to allow dynamically extending hyp pools at run-time, add a
check to __hyp_attach_page() to allow inserting 'external' pages into
the free-list of order 0. This will be necessary to allow lazy donation
of pages from the host to the hypervisor when allocating guest stage-2
page-table pages at EL2.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/page_alloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 1ded09fc9b10..0d15227aced8 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -93,11 +93,15 @@ static inline struct hyp_page *node_to_page(struct list_head *node)
 static void __hyp_attach_page(struct hyp_pool *pool,
 			      struct hyp_page *p)
 {
+	phys_addr_t phys = hyp_page_to_phys(p);
 	unsigned short order = p->order;
 	struct hyp_page *buddy;
 
 	memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
 
+	if (phys < pool->range_start || phys >= pool->range_end)
+		goto insert;
+
 	/*
 	 * Only the first struct hyp_page of a high-order page (otherwise known
 	 * as the 'head') should have p->order set. The non-head pages should
@@ -116,6 +120,7 @@ static void __hyp_attach_page(struct hyp_pool *pool,
 		p = min(p, buddy);
 	}
 
+insert:
 	/* Mark the new head, and insert it */
 	p->order = order;
 	page_add_to_list(p, &pool->free_area[order]);
-- 
2.38.0.413.g74048e4d9e-goog

