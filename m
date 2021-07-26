Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB383D5D20
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 17:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbhGZOzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 10:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235041AbhGZOza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 10:55:30 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E40DB60E08;
        Mon, 26 Jul 2021 15:35:58 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m82e5-001511-7e; Mon, 26 Jul 2021 16:35:57 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 5/6] KVM: arm64: Use get_page() instead of kvm_get_pfn()
Date:   Mon, 26 Jul 2021 16:35:51 +0100
Message-Id: <20210726153552.1535838-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726153552.1535838-1-maz@kernel.org>
References: <20210726153552.1535838-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org, seanjc@google.com, willy@infradead.org, pbonzini@redhat.com, will@kernel.org, qperret@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When mapping a THP, we are guaranteed that the page isn't reserved,
and we can safely avoid the kvm_is_reserved_pfn() call.

Replace kvm_get_pfn() with get_page(pfn_to_page()).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ebb28dd4f2c9..b303aa143592 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -840,7 +840,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		*ipap &= PMD_MASK;
 		kvm_release_pfn_clean(pfn);
 		pfn &= ~(PTRS_PER_PMD - 1);
-		kvm_get_pfn(pfn);
+		get_page(pfn_to_page(pfn));
 		*pfnp = pfn;
 
 		return PMD_SIZE;
-- 
2.30.2

