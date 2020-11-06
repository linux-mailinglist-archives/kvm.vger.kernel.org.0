Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98D22A99B2
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 17:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgKFQoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 11:44:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgKFQoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 11:44:38 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFEF821556;
        Fri,  6 Nov 2020 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604681078;
        bh=T36IPLbT9cJ/XPnSJhoaXKK5mtHaqKLZC6nvg9TC1Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ola4f9kKMahL1JQDf/UuLWtvgFviVPCONE9o/bIL9H3q8cKIg6gYkQ29h7DoGfk0A
         wT+LXaTpsF6jSgvlZ+29oDAbVIsJVUmo2D6MqUKgTwd1I6R/SdTGPqsiz6RsRNWP6J
         sGDWKgyrpAFGVN0VWI3FqJ4Hs3vIs+jORoCJfLqU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kb4qq-008FYW-3X; Fri, 06 Nov 2020 16:44:36 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?q?=E5=BC=A0=E4=B8=9C=E6=97=AD?= <xu910121@sina.com>,
        dave.martin@arm.com, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/5] KVM: arm64: Fix build error in user_mem_abort()
Date:   Fri,  6 Nov 2020 16:44:12 +0000
Message-Id: <20201106164416.326787-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201106164416.326787-1-maz@kernel.org>
References: <20201106164416.326787-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, eric.auger@redhat.com, gshan@redhat.com, xu910121@sina.com, dave.martin@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>

The PUD and PMD are folded into PGD when the following options are
enabled. In that case, PUD_SHIFT is equal to PMD_SHIFT and we fail
to build with the indicated errors:

   CONFIG_ARM64_VA_BITS_42=y
   CONFIG_ARM64_PAGE_SHIFT=16
   CONFIG_PGTABLE_LEVELS=3

   arch/arm64/kvm/mmu.c: In function ‘user_mem_abort’:
   arch/arm64/kvm/mmu.c:798:2: error: duplicate case value
     case PMD_SHIFT:
     ^~~~
   arch/arm64/kvm/mmu.c:791:2: note: previously used here
     case PUD_SHIFT:
     ^~~~

This fixes the issue by skipping the check on PUD huge page when PUD
and PMD are folded into PGD.

Fixes: 2f40c46021bbb ("KVM: arm64: Use fallback mapping sizes for contiguous huge page sizes")
Reported-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201103003009.32955-1-gshan@redhat.com
---
 arch/arm64/kvm/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c7c6df6309d5..a109c5001827 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -788,10 +788,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	switch (vma_shift) {
+#ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
 		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
 			break;
 		fallthrough;
+#endif
 	case CONT_PMD_SHIFT:
 		vma_shift = PMD_SHIFT;
 		fallthrough;
-- 
2.28.0

