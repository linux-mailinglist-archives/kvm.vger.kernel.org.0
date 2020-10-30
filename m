Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638AA2A0B5A
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 17:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgJ3Qk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 12:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgJ3Qk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 12:40:26 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F2922075E;
        Fri, 30 Oct 2020 16:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076025;
        bh=FdAucMQjtKAFDFTUjWlGgj+oR3wWcmsUGvauZ/aCLXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNUiX9jU9UztYq5wLUe6zn2MN5nLk0yeP/8ipFoFw1zVxMOrygf15l2IOMLWaVI4L
         fBFj13z2VYBAxprsTDd+1S2k3kvbKQ3RjeelPPathZusPRrA2BgT2FmDipr+SDzkfO
         ww+Pzj/t2jJtf0WWc49XNnaiUiop/E+m723XE/l4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kYXRv-005noK-QG; Fri, 30 Oct 2020 16:40:23 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Brazdil <dbrazdil@google.com>, Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Quentin Perret <qperret@google.com>,
        Santosh Shukla <sashukla@nvidia.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/12] KVM: arm64: Remove leftover kern_hyp_va() in nVHE TLB invalidation
Date:   Fri, 30 Oct 2020 16:40:07 +0000
Message-Id: <20201030164017.244287-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com, qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new calling convention says that pointers coming from the SMCCC
interface are turned into their HYP version in the host HVC handler.
However, there is still a stray kern_hyp_va() in the TLB invalidation
code, which could result in a corrupted pointer.

Drop the spurious conversion.

Fixes: a071261d9318 ("KVM: arm64: nVHE: Fix pointers during SMCCC convertion")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201026095116.72051-3-maz@kernel.org
---
 arch/arm64/kvm/hyp/nvhe/tlb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 544bca3072b7..ad212d8fa417 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -121,7 +121,6 @@ void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	mmu = kern_hyp_va(mmu);
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalle1);
-- 
2.28.0

