Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDAD2ADA4E
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 15:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbfIINtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 09:49:09 -0400
Received: from foss.arm.com ([217.140.110.172]:50626 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731318AbfIINtJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 09:49:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF3E1168F;
        Mon,  9 Sep 2019 06:49:08 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88A023F59C;
        Mon,  9 Sep 2019 06:49:06 -0700 (PDT)
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
Subject: [PATCH 07/17] KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on vgic teardown
Date:   Mon,  9 Sep 2019 14:47:57 +0100
Message-Id: <20190909134807.27978-8-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
References: <20190909134807.27978-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to avoid leaking vgic_irq structures on teardown, we need to
drop all references to LPIs before deallocating the cache itself.

This is done by invalidating the cache on vgic teardown.

Tested-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
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

