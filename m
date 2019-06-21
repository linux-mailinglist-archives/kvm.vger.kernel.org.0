Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6B54E455
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfFUJl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:41:59 -0400
Received: from foss.arm.com ([217.140.110.172]:54214 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbfFUJkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:40:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D4701509;
        Fri, 21 Jun 2019 02:40:15 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE0CD3F246;
        Fri, 21 Jun 2019 02:40:13 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 40/59] KVM: arm64: nv: Don't always start an S2 MMU search from the beginning
Date:   Fri, 21 Jun 2019 10:38:24 +0100
Message-Id: <20190621093843.220980-41-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Starting a S2 MMU search from the beginning all the time means that
we're potentially nuking a useful context (like we'd potentially
have on a !VHE KVM guest).

Instead, let's always start the search from the point *after* the
last allocated context. This should ensure that alternating between
two EL1 contexts will not result in nuking the whole S2 each time.

lookup_s2_mmu now has a chance to provide a hit.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/nested.c           | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b71a7a237f95..b7c44adcdbf3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -123,6 +123,7 @@ struct kvm_arch {
 	 */
 	struct kvm_s2_mmu *nested_mmus;
 	size_t nested_mmus_size;
+	int nested_mmus_next;
 
 	/* VTCR_EL2 value for this VM */
 	u64    vtcr;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 09afafbdc8fe..214d59019935 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -363,14 +363,24 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	if (s2_mmu)
 		goto out;
 
-	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		s2_mmu = &kvm->arch.nested_mmus[i];
+	/*
+	 * Make sure we don't always search from the same point, or we
+	 * will always reuse a potentially active context, leaving
+	 * free contexts unused.
+	 */
+	for (i = kvm->arch.nested_mmus_next;
+	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
+	     i++) {
+		s2_mmu = &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
 
 		if (atomic_read(&s2_mmu->refcnt) == 0)
 			break;
 	}
 	BUG_ON(atomic_read(&s2_mmu->refcnt)); /* We have struct MMUs to spare */
 
+	/* Set the scene for the next search */
+	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
+
 	if (kvm_s2_mmu_valid(s2_mmu)) {
 		/* Clear the old state */
 		kvm_unmap_stage2_range(s2_mmu, 0, kvm_phys_size(kvm));
-- 
2.20.1

