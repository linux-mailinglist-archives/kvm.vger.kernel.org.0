Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13C052D45F
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbiESNnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiESNmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:42:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6843EF03
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:42:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6AA72CE2463
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389CEC34117;
        Thu, 19 May 2022 13:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967752;
        bh=mMTpj6Xf/moTi8ciNje9mfw0SiHtqrhrJpD/i+TIPXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3l6TybAXqwnFz+PuQUJNPYnXdGaGAa/sINGfllzMjmJ9fmoxX60ta2V6T8T5wAXS
         r0TxsBQbV/p1EQXXAMwz5JHFLvJYywVGR3B/6xd92EYJGRjKAbmxvUu8EWey52622A
         IEKimIrbD9LJaQjtsazUZvwfYw5xCi6+cGqJK2dABHIo57bynSetnVWHVsoB41W8Du
         LiWHiXR1/MtGUum1ISCJbEMgkYDtLsJJHcYP7vk4UyY1Vavri18c1+18acC8dq1DWh
         /3wLJExnd7ks7/gDNefTSpFTXJf1T4IRTHys6br0PyC983WymUXbK8x6WulJ7gKyxq
         LsN8wRpQQrx1A==
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
Subject: [PATCH 02/89] KVM: arm64: Remove redundant hyp_assert_lock_held() assertions
Date:   Thu, 19 May 2022 14:40:37 +0100
Message-Id: <20220519134204.5379-3-will@kernel.org>
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

host_stage2_try() asserts that the KVM host lock is held, so there's no
need to duplicate the assertion in its wrappers.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 78edf077fa3b..1e78acf9662e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -314,15 +314,11 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
 			     enum kvm_pgtable_prot prot)
 {
-	hyp_assert_lock_held(&host_kvm.lock);
-
 	return host_stage2_try(__host_stage2_idmap, addr, addr + size, prot);
 }
 
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 {
-	hyp_assert_lock_held(&host_kvm.lock);
-
 	return host_stage2_try(kvm_pgtable_stage2_set_owner, &host_kvm.pgt,
 			       addr, size, &host_s2_pool, owner_id);
 }
-- 
2.36.1.124.g0e6072fb45-goog

