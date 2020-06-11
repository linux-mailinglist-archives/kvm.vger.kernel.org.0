Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33051F644D
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 11:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgFKJKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 05:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgFKJKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 05:10:09 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 334332078D;
        Thu, 11 Jun 2020 09:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591866609;
        bh=/aiYNNuE8VR6SQq4tRJxdPUL75hAzzLtTkxxhFEWVGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXVcqnkc2Hsyezw/WUEVPOraHUNfya8IIXpIMQdimEt1UVH3Mva3IbmkEIisHYi8s
         H1rAgXozuu6G1lkARw52RadTYpAepHNrVeGhX/EL9Azu8pXWRv/2cuIfX+z8gNhe5W
         y8hxnRJPgD5ujNJZB95/Vmf40DSYjYphpRJ6LPBo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jjJDr-0022ZT-Op; Thu, 11 Jun 2020 10:10:07 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/11] KVM: arm64: Flush the instruction cache if not unmapping the VM on reboot
Date:   Thu, 11 Jun 2020 10:09:46 +0100
Message-Id: <20200611090956.1537104-2-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611090956.1537104-1-maz@kernel.org>
References: <20200611090956.1537104-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, ascull@google.com, james.morse@arm.com, mark.rutland@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a system with FWB, we don't need to unmap Stage-2 on reboot,
as even if userspace takes this opportunity to repaint the whole
of memory, FWB ensures that the data side stays consistent even
if the guest uses non-cacheable mappings.

However, the I-side is not necessarily coherent with the D-side
if CTR_EL0.DIC is 0. In this case, invalidate the i-cache to
preserve coherency.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Fixes: 892713e97ca1 ("KVM: arm64: Sidestep stage2_unmap_vm() on vcpu reset when S2FWB is supported")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b0b569f2cdd0..d6988401c22a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -989,11 +989,17 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * Ensure a rebooted VM will fault in RAM pages and detect if the
 	 * guest MMU is turned off and flush the caches as needed.
 	 *
-	 * S2FWB enforces all memory accesses to RAM being cacheable, we
-	 * ensure that the cache is always coherent.
+	 * S2FWB enforces all memory accesses to RAM being cacheable,
+	 * ensuring that the data side is always coherent. We still
+	 * need to invalidate the I-cache though, as FWB does *not*
+	 * imply CTR_EL0.DIC.
 	 */
-	if (vcpu->arch.has_run_once && !cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
-		stage2_unmap_vm(vcpu->kvm);
+	if (vcpu->arch.has_run_once) {
+		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+			stage2_unmap_vm(vcpu->kvm);
+		else
+			__flush_icache_all();
+	}
 
 	vcpu_reset_hcr(vcpu);
 
-- 
2.26.2

