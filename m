Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A28ADA57
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 15:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404748AbfIINtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 09:49:19 -0400
Received: from foss.arm.com ([217.140.110.172]:50702 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729775AbfIINtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 09:49:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F126319F6;
        Mon,  9 Sep 2019 06:49:18 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2A6F3F59C;
        Mon,  9 Sep 2019 06:49:16 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/17] arm64/kvm: Remove VMID rollover I-cache maintenance
Date:   Mon,  9 Sep 2019 14:48:01 +0100
Message-Id: <20190909134807.27978-12-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
References: <20190909134807.27978-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

For VPIPT I-caches, we need I-cache maintenance on VMID rollover to
avoid an ABA problem. Consider a single vCPU VM, with a pinned stage-2,
running with an idmap VA->IPA and idmap IPA->PA. If we don't do
maintenance on rollover:

        // VMID A
        Writes insn X to PA 0xF
        Invalidates PA 0xF (for VMID A)

        I$ contains [{A,F}->X]

        [VMID ROLLOVER]

        // VMID B
        Writes insn Y to PA 0xF
        Invalidates PA 0xF (for VMID B)

        I$ contains [{A,F}->X, {B,F}->Y]

        [VMID ROLLOVER]

        // VMID A
        I$ contains [{A,F}->X, {B,F}->Y]

        Unexpectedly hits stale I$ line {A,F}->X.

However, for PIPT and VIPT I-caches, the VMID doesn't affect lookup or
constrain maintenance. Given the VMID doesn't affect PIPT and VIPT
I-caches, and given VMID rollover is independent of changes to stage-2
mappings, I-cache maintenance cannot be necessary on VMID rollover for
PIPT or VIPT I-caches.

This patch removes the maintenance on rollover for VIPT and PIPT
I-caches. At the same time, the unnecessary colons are removed from the
asm statement to make it more legible.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/tlb.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index d49a14497715..c466060b76d6 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -193,6 +193,18 @@ void __hyp_text __kvm_flush_vm_context(void)
 {
 	dsb(ishst);
 	__tlbi(alle1is);
-	asm volatile("ic ialluis" : : );
+
+	/*
+	 * VIPT and PIPT caches are not affected by VMID, so no maintenance
+	 * is necessary across a VMID rollover.
+	 *
+	 * VPIPT caches constrain lookup and maintenance to the active VMID,
+	 * so we need to invalidate lines with a stale VMID to avoid an ABA
+	 * race after multiple rollovers.
+	 *
+	 */
+	if (icache_is_vpipt())
+		asm volatile("ic ialluis");
+
 	dsb(ish);
 }
-- 
2.20.1

