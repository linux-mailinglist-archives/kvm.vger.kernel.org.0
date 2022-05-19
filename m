Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF3152D453
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiESNni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiESNnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:43:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3577145794
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:43:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECC50B824A6
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F89C34116;
        Thu, 19 May 2022 13:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967788;
        bh=oi7nWzoEc9504XVLiQbs3WOiWyACarQzLX8Qdeo+Dpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ai111Mz0yHXfWZMGyOqaSqwA9EjJszWyeipWxoXH4bKfwJiONtB6AokrT5YO6fxXy
         9u6ezzZPGE4TeufbhdNMQF/ZQ12AY4knHRhVLZTDuKlUkXc5DQIyv55G5TRcdaELC9
         rM0UsX8PBisyFeOpGQHneOoOtLkNOfmZ/r7tamviaFfjxKWW+RtYgEIxlIS5np+A2D
         rLM/stmgcRcPBPaBWg80PvCimoaZG+MkEZ4a9lUdNuWV8XVarZpqr4Z+8tSJZvtHn7
         0ZUH9opzUbAo1QFK9461OePcWNuWp2JcLZPAoROtYECwKWOfRfTYGkzbPsvotb8l71
         9wltMwOLSDvOw==
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
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/89] KVM: arm64: Prevent the donation of no-map pages
Date:   Thu, 19 May 2022 14:40:46 +0100
Message-Id: <20220519134204.5379-12-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

Memory regions marked as no-map in DT routinely include TrustZone
carevouts and such. Although donating such pages to the hypervisor may
not breach confidentiality, it may be used to corrupt its state in
uncontrollable ways. To prevent this, let's block host-initiated memory
transitions targeting no-map pages altogether in nVHE protected mode as
there should be no valid reason to do this currently.

Thankfully, the pKVM EL2 hypervisor has a full copy of the host's list
of memblock regions, hence allowing to check for the presence of the
MEMBLOCK_NOMAP flag on any given region at EL2 easily.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index c30402737548..a7156fd13bc8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -193,7 +193,7 @@ struct kvm_mem_range {
 	u64 end;
 };
 
-static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
+static struct memblock_region *find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 {
 	int cur, left = 0, right = hyp_memblock_nr;
 	struct memblock_region *reg;
@@ -216,18 +216,28 @@ static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 		} else {
 			range->start = reg->base;
 			range->end = end;
-			return true;
+			return reg;
 		}
 	}
 
-	return false;
+	return NULL;
 }
 
 bool addr_is_memory(phys_addr_t phys)
 {
 	struct kvm_mem_range range;
 
-	return find_mem_range(phys, &range);
+	return !!find_mem_range(phys, &range);
+}
+
+static bool addr_is_allowed_memory(phys_addr_t phys)
+{
+	struct memblock_region *reg;
+	struct kvm_mem_range range;
+
+	reg = find_mem_range(phys, &range);
+
+	return reg && !(reg->flags & MEMBLOCK_NOMAP);
 }
 
 static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
@@ -346,7 +356,7 @@ static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot pr
 static int host_stage2_idmap(u64 addr)
 {
 	struct kvm_mem_range range;
-	bool is_memory = find_mem_range(addr, &range);
+	bool is_memory = !!find_mem_range(addr, &range);
 	enum kvm_pgtable_prot prot;
 	int ret;
 
@@ -424,7 +434,7 @@ static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
 	struct check_walk_data *d = arg;
 	kvm_pte_t pte = *ptep;
 
-	if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
+	if (kvm_pte_valid(pte) && !addr_is_allowed_memory(kvm_pte_to_phys(pte)))
 		return -EINVAL;
 
 	return d->get_page_state(pte) == d->desired ? 0 : -EPERM;
-- 
2.36.1.124.g0e6072fb45-goog

