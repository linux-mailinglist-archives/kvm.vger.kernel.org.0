Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03B652D508
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239046AbiESNtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239117AbiESNsU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:48:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4AF4248F
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:48:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F155C617C1
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ECFC34117;
        Thu, 19 May 2022 13:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968074;
        bh=Bb16fB1SmGSKYWwrpfSZcfkvibh8rQKnfPLdNL//f+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOg5OFUjv2277j/meQP3O4SaTl6wfeWQ86gbdZeGsaiOHccCxWEfmELroBkaS0d/I
         +QKCf7moqK4aBN832WtFmuPKh/qvDFmY/+rgSNCfw8aZ14/zC9tmR49iWg450LFf3/
         z6GCDdavpRvE+CKcSQUaQVvEK/wz2/SCGU801vf2bylAjEJoAu0Pq46x2bHvW3KjpZ
         DA86pBK+RVb2wcG5XWS5V2qvuIcONAV6YwqWmNHaVywTjV8KWF830WnofrKs8mzHiM
         4w0lD7YfWAqGD3MnSCvx5zmPJeoD4S//atYCW42tMe97HhbzZGvPjCBcD6hg6dJ8Kw
         JOA3De/F/wF+w==
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
Subject: [PATCH 83/89] KVM: arm64: Avoid BBM when changing only s/w bits in Stage-2 PTE
Date:   Thu, 19 May 2022 14:41:58 +0100
Message-Id: <20220519134204.5379-84-will@kernel.org>
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

Break-before-make (BBM) can be expensive, as transitioning via an
invalid mapping (i.e. the "break" step) requires the completion of TLB
invalidation and can also cause other agents to fault concurrently on
the invalid mapping.

Since BBM is not required when changing only the software bits of a PTE,
avoid the sequence in this case and just update the PTE directly.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2069e6833831..756bbb15c1f3 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -744,6 +744,13 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		if (!stage2_pte_needs_update(old, new))
 			return -EAGAIN;
 
+		/*
+		 * If we're only changing software bits, then we don't need to
+		 * do anything else/
+		 */
+		if (!((old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW))
+			goto out_set_pte;
+
 		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
 	}
 
@@ -754,9 +761,11 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
-	smp_store_release(ptep, new);
 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ptep);
+
+out_set_pte:
+	smp_store_release(ptep, new);
 	if (kvm_phys_is_valid(phys))
 		data->phys += granule;
 	return 0;
-- 
2.36.1.124.g0e6072fb45-goog

