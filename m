Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EA91E82F1
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 18:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgE2QDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 12:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbgE2QDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 12:03:41 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87B76207BC;
        Fri, 29 May 2020 16:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590768220;
        bh=VtUB9e+MVNkvMssfdgtJncDI3p3++cqidOTfdz2EyAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2vW5GoehQmY4Qn2llhRUox13L7lh0467Fj7MAPBTeiwhDpmqJxWz0Dkf7PuxoRKz
         0UwK6SkXhuqTjJ28X+Fuq0M+1O51nc5GfsgBpMEtFGVKSMxdHS3PdaNxzEQLxbfFn1
         DmPw93AUbtyqo0IdlZGE/IYW3Bx1fN+sMpHQRHeU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jehSA-00GJKc-2E; Fri, 29 May 2020 17:01:50 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Jiang Yi <giangyi@amazon.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 11/24] KVM: arm64: Clean up the checking for huge mapping
Date:   Fri, 29 May 2020 17:01:08 +0100
Message-Id: <20200529160121.899083-12-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
References: <20200529160121.899083-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, ascull@google.com, ardb@kernel.org, christoffer.dall@arm.com, dbrazdil@google.com, tabba@google.com, james.morse@arm.com, giangyi@amazon.com, zhukeqian1@huawei.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

If we are checking whether the stage2 can map PAGE_SIZE,
we don't have to do the boundary checks as both the host
VMA and the guest memslots are page aligned. Bail the case
easily.

While we're at it, fixup a typo in the comment below.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200507123546.1875-2-yuzenghui@huawei.com
---
 arch/arm64/kvm/mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 917363375e8a..ccb44e7d30d9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1610,6 +1610,10 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 	hva_t uaddr_start, uaddr_end;
 	size_t size;
 
+	/* The memslot and the VMA are guaranteed to be aligned to PAGE_SIZE */
+	if (map_size == PAGE_SIZE)
+		return true;
+
 	size = memslot->npages * PAGE_SIZE;
 
 	gpa_start = memslot->base_gfn << PAGE_SHIFT;
@@ -1629,7 +1633,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 	 *    |abcde|fgh  Stage-1 block  |    Stage-1 block tv|xyz|
 	 *    +-----+--------------------+--------------------+---+
 	 *
-	 *    memslot->base_gfn << PAGE_SIZE:
+	 *    memslot->base_gfn << PAGE_SHIFT:
 	 *      +---+--------------------+--------------------+-----+
 	 *      |abc|def  Stage-2 block  |    Stage-2 block   |tvxyz|
 	 *      +---+--------------------+--------------------+-----+
-- 
2.26.2

