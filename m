Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A119752D4
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 17:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbfGYPgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 11:36:39 -0400
Received: from foss.arm.com ([217.140.110.172]:59572 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbfGYPgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 11:36:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5A1616A3;
        Thu, 25 Jul 2019 08:36:38 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 315F23F71A;
        Thu, 25 Jul 2019 08:36:37 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Saidi, Ali" <alisaidi@amazon.com>
Subject: [PATCH v3 07/10] KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on vgic teardown
Date:   Thu, 25 Jul 2019 16:35:40 +0100
Message-Id: <20190725153543.24386-8-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725153543.24386-1-maz@kernel.org>
References: <20190725153543.24386-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

In order to avoid leaking vgic_irq structures on teardown, we need to
drop all references to LPIs before deallocating the cache itself.

This is done by invalidating the cache on vgic teardown.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 05406bd92ce9..d3e90a9d0a7a 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1731,6 +1731,8 @@ void vgic_lpi_translation_cache_destroy(struct kvm *kvm)
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte, *tmp;
 
+	vgic_its_invalidate_cache(kvm);
+
 	list_for_each_entry_safe(cte, tmp,
 				 &dist->lpi_translation_cache, entry) {
 		list_del(&cte->entry);
-- 
2.20.1

