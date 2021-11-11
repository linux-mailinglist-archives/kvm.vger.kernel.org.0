Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D45344DCED
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 22:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhKKVPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 16:15:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229785AbhKKVPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 16:15:08 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97BE561037;
        Thu, 11 Nov 2021 21:12:18 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mlHMm-004tjr-OU; Thu, 11 Nov 2021 21:12:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: [PATCH 4/4] KVM: arm64: Fix host stage-2 finalization
Date:   Thu, 11 Nov 2021 21:11:35 +0000
Message-Id: <20211111211135.3991240-5-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211111211135.3991240-1-maz@kernel.org>
References: <20211111211135.3991240-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, tabba@google.com, james.morse@arm.com, mark.rutland@arm.com, qperret@google.com, rdunlap@infradead.org, suzuki.poulose@arm.com, will@kernel.org, yuehaibing@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

We currently walk the hypervisor stage-1 page-table towards the end of
hyp init in nVHE protected mode and adjust the host page ownership
attributes in its stage-2 in order to get a consistent state from both
point of views. The walk is done on the entire hyp VA space, and expects
to only ever find page-level mappings. While this expectation is
reasonable in the half of hyp VA space that maps memory with a fixed
offset (see the loop in pkvm_create_mappings_locked()), it can be
incorrect in the other half where nothing prevents the usage of block
mappings. For instance, on systems where memory is physically aligned at
an address that happens to maps to a PMD aligned VA in the hyp_vmemmap,
kvm_pgtable_hyp_map() will install block mappings when backing the
hyp_vmemmap, which will later cause finalize_host_mappings() to fail.
Furthermore, it should be noted that all pages backing the hyp_vmemmap
are also mapped in the 'fixed offset range' of the hypervisor, which
implies that finalize_host_mappings() will walk both aliases and update
the host stage-2 attributes twice. The order in which this happens is
unpredictable, though, since the hyp VA layout is highly dependent on
the position of the idmap page, hence resulting in a fragile mess at
best.

In order to fix all of this, let's restrict the finalization walk to
only cover memory regions in the 'fixed-offset range' of the hyp VA
space and nothing else. This not only fixes a correctness issue, but
will also result in a slighlty faster hyp initialization overall.

Fixes: 2c50166c62ba ("KVM: arm64: Mark host bss and rodata section as shared")
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211108154636.393384-1-qperret@google.com
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 862c7b514e20..578f71798c2e 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -178,7 +178,7 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 
 	phys = kvm_pte_to_phys(pte);
 	if (!addr_is_memory(phys))
-		return 0;
+		return -EINVAL;
 
 	/*
 	 * Adjust the host stage-2 mappings to match the ownership attributes
@@ -207,8 +207,18 @@ static int finalize_host_mappings(void)
 		.cb	= finalize_host_mappings_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
 	};
+	int i, ret;
+
+	for (i = 0; i < hyp_memblock_nr; i++) {
+		struct memblock_region *reg = &hyp_memory[i];
+		u64 start = (u64)hyp_phys_to_virt(reg->base);
+
+		ret = kvm_pgtable_walk(&pkvm_pgtable, start, reg->size, &walker);
+		if (ret)
+			return ret;
+	}
 
-	return kvm_pgtable_walk(&pkvm_pgtable, 0, BIT(pkvm_pgtable.ia_bits), &walker);
+	return 0;
 }
 
 void __noreturn __pkvm_init_finalise(void)
-- 
2.30.2

