Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F741333A78
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 11:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhCJKm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 05:42:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232632AbhCJKmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 05:42:25 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 250D264F77;
        Wed, 10 Mar 2021 10:42:25 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lJwIJ-000jdD-5G; Wed, 10 Mar 2021 10:42:23 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 2/2] KVM: arm64: Fix exclusive limit for IPA size
Date:   Wed, 10 Mar 2021 10:42:08 +0000
Message-Id: <20210310104208.3819061-3-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310104208.3819061-1-maz@kernel.org>
References: <20210310104208.3819061-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When registering a memslot, we check the size and location of that
memslot against the IPA size to ensure that we can provide guest
access to the whole of the memory.

Unfortunately, this check rejects memslot that end-up at the exact
limit of the addressing capability for a given IPA size. For example,
it refuses the creatrion of a 2GB memslot at 0x8000000 with a 32bit
IPA space.

Fix it by relaxing the check to accept a memslot reaching the
limit of the IPA space.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 77cb2d28f2a4..8711894db8c2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1312,8 +1312,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 * Prevent userspace from creating a memory region outside of the IPA
 	 * space addressable by the KVM guest IPA space.
 	 */
-	if (memslot->base_gfn + memslot->npages >=
-	    (kvm_phys_size(kvm) >> PAGE_SHIFT))
+	if ((memslot->base_gfn + memslot->npages) > (kvm_phys_size(kvm) >> PAGE_SHIFT))
 		return -EFAULT;
 
 	mmap_read_lock(current->mm);
-- 
2.29.2

