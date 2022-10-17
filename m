Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56889600E2A
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiJQLws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiJQLwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:52:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133BF2A424
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AAF6B81630
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A840C433C1;
        Mon, 17 Oct 2022 11:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007560;
        bh=kHeroY+azM9EScaIHR1Ce0DRrtBPY5P4+YZiouhzfmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmAGrk53K9rvObuRQeomaf+bY1yqTxdOXubyWFF30dHhWV8Mnbu5hOz21+Ul/51zk
         xCEj7XYAxbNsJmIbRlRJuO1qr+pdkQiZ222ZZamg2b7ZoLq1cH04b24vBn0g+3jhZu
         olfMUKbMlQJWlZSOizjnOWg5l0VZPZ6L6AWXJWuozE0W4kuEdf6fodyW/uXaeVJ3Zz
         pD9tbkf+AP5UdovLWg1hEfPa46mLHRI1X51TW7bRhAu/o95b75/RWCB4a4RqEds4k7
         tNfXrxhEdpYvhVL7Vqe7p2YPVF81W+UfN/PrLLqOup5aPf998D1a8EQo32iURjf24f
         xNg7z5Elm9/4w==
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
Subject: [PATCH v4 05/25] KVM: arm64: Unify identifiers used to distinguish host and hypervisor
Date:   Mon, 17 Oct 2022 12:51:49 +0100
Message-Id: <20221017115209.2099-6-will@kernel.org>
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

The 'pkvm_component_id' enum type provides constants to refer to the
host and the hypervisor, yet this information is duplicated by the
'pkvm_hyp_id' constant.

Remove the definition of 'pkvm_hyp_id' and move the 'pkvm_component_id'
type definition to 'mem_protect.h' so that it can be used outside of
the memory protection code, for example when initialising the owner for
hypervisor-owned pages.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 6 +++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 8 --------
 arch/arm64/kvm/hyp/nvhe/setup.c               | 2 +-
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 80e99836eac7..f5705a1e972f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -51,7 +51,11 @@ struct host_kvm {
 };
 extern struct host_kvm host_kvm;
 
-extern const u8 pkvm_hyp_id;
+/* This corresponds to page-table locking order */
+enum pkvm_component_id {
+	PKVM_ID_HOST,
+	PKVM_ID_HYP,
+};
 
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1e78acf9662e..ff86f5bd230f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -26,8 +26,6 @@ struct host_kvm host_kvm;
 
 static struct hyp_pool host_s2_pool;
 
-const u8 pkvm_hyp_id = 1;
-
 static void host_lock_component(void)
 {
 	hyp_spin_lock(&host_kvm.lock);
@@ -380,12 +378,6 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	BUG_ON(ret && ret != -EAGAIN);
 }
 
-/* This corresponds to locking order */
-enum pkvm_component_id {
-	PKVM_ID_HOST,
-	PKVM_ID_HYP,
-};
-
 struct pkvm_mem_transition {
 	u64				nr_pages;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 8f2726d7e201..0312c9c74a5a 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -212,7 +212,7 @@ static int fix_host_ownership_walker(u64 addr, u64 end, u32 level,
 	state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
 	switch (state) {
 	case PKVM_PAGE_OWNED:
-		return host_stage2_set_owner_locked(phys, PAGE_SIZE, pkvm_hyp_id);
+		return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
 	case PKVM_PAGE_SHARED_OWNED:
 		prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_BORROWED);
 		break;
-- 
2.38.0.413.g74048e4d9e-goog

