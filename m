Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3022F72A011
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241740AbjFIQWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjFIQWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:22:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261952D44
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 09:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BF0F614C7
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 16:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0979C433EF;
        Fri,  9 Jun 2023 16:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686327730;
        bh=6wNp/EjkCubmH4jSbimzQJEPlzEQpa08AFTUAXoa3iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jye1Nk/+4Te91qjbLwqvi9ZDCPP+hc7Wlo6lpIbdBdOF1VLFeSuiH49BjbZyDH4g6
         YwW2zBcxlCsijgjA8yZ05QEkUyvSKXgaut8tC2oSFzqYPFo2Ic73bmvUWwTKXIP+Ul
         t7kpLuveL0traTpHkcO5Cz2huC2EvctjYqpMk3qYwjXSaA0YVNoOUK0L2NtKkdYTy+
         FxQ2DhBe+Kdlza5Ay4wgTST0IPbGcwdmurr5U95GewTDeChpvDeigc7+ihUz4xF5fs
         y4TFudjX8vo3v8gJjpIDJEdmLbOYGcLZONCQ7IRjLRXyRRciDYMU0BE74y7iBwpup9
         AWsYiJoVBinWw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q7esK-0048L7-KZ;
        Fri, 09 Jun 2023 17:22:08 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 01/17] KVM: arm64: Drop is_kernel_in_hyp_mode() from __invalidate_icache_guest_page()
Date:   Fri,  9 Jun 2023 17:21:44 +0100
Message-Id: <20230609162200.2024064-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
References: <20230609162200.2024064-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is pretty obvious that is_kernel_in_hyp_mode() doesn't make much
sense in the hypervisor part of KVM, and should be reserved to the
kernel side.

However, mem_protect.c::invalidate_icache_guest_page() calls into
__invalidate_icache_guest_page(), which uses is_kernel_in_hyp_mode().
Given that this is part of the pKVM side of the hypervisor, this
helper can only return true.

Nothing goes really bad, but __invalidate_icache_guest_page() could
spell out what the actual check is: we cannot invalidate the cache
if the i-cache is VPIPT and we're running at EL1.

Drop the is_kernel_in_hyp_mode() check for an explicit check against
CurrentEL being EL1 or not.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 27e63c111f78..c8113b931263 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -227,7 +227,8 @@ static inline void __invalidate_icache_guest_page(void *va, size_t size)
 	if (icache_is_aliasing()) {
 		/* any kind of VIPT cache */
 		icache_inval_all_pou();
-	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
+	} else if (read_sysreg(CurrentEL) != CurrentEL_EL1 ||
+		   !icache_is_vpipt()) {
 		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
 		icache_inval_pou((unsigned long)va, (unsigned long)va + size);
 	}
-- 
2.34.1

