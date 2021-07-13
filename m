Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9DE3C6FF2
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 13:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbhGMLvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 07:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235797AbhGMLvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 07:51:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D76BB6128B;
        Tue, 13 Jul 2021 11:48:21 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m3Gtf-00D4c1-QL; Tue, 13 Jul 2021 12:48:19 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] KVM: arm64: Fix detection of shared VMAs on guest fault
Date:   Tue, 13 Jul 2021 12:48:04 +0100
Message-Id: <20210713114804.594993-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, will@kernel.org, kernel-team@android.com, steven.price@arm.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When merging the KVM MTE support, the blob that was interposed between
the chair and the keyboard experienced a neuronal accident (also known
as a brain fart), turning a check for VM_SHARED into VM_PFNMAP as it
was reshuffling some of the code.

The blob having now come back to its senses, let's restore the
initial check that the original author got right the first place.

Fixes: ea7fc1bb1cd1 ("KVM: arm64: Introduce MTE VM feature")
Cc: Steven Price <steven.price@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3155c9e778f0..0625bf2353c2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -947,7 +947,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
 
-	shared = (vma->vm_flags & VM_PFNMAP);
+	shared = (vma->vm_flags & VM_SHARED);
 
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
-- 
2.30.2

