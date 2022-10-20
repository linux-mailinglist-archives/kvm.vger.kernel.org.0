Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8886061D6
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 15:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiJTNjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 09:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiJTNi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 09:38:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523451A650C
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 917F861B94
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7120C433C1;
        Thu, 20 Oct 2022 13:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666273136;
        bh=V2pyKMeZFmlh4KlmPfLIhmI5FqC3LJ2FfBL99fKAjw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cA0jZ9ftozFRU1353+1RqCTqCZLfhC2nrk1U1ZbHuamTeBsDZDG6JCyDotdISJTXt
         /f7a+cDHPb9kWd8705ChLkmmt5BLwof3HvuIEmOQ9lgFChGcNPSbdd8f4xjqCJ0rej
         DdxejGxSaItMhvIzASLZd8KDJ46vpZKpyW6d4eSut2oXVxI8dbhUH29ecpu0F2bMiz
         oLeQx6wKoLPfQiivArL6vdxRze2EPWlJ8TA9AbLkaBdaxn34vN1sT0OrmJCVjGErQS
         XYtraHMNWOtTvWVY5rzthQQZf3QFoEY7bgzt0HzXazXG9DkYr4fB60NWrZJZgQ58tN
         KyXQUH/UgVXTA==
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
Subject: [PATCH v5 05/25] KVM: arm64: Unify identifiers used to distinguish host and hypervisor
Date:   Thu, 20 Oct 2022 14:38:07 +0100
Message-Id: <20221020133827.5541-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221020133827.5541-1-will@kernel.org>
References: <20221020133827.5541-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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

