Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBFD2D896E
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 19:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388290AbgLLSwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Dec 2020 13:52:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407748AbgLLSwI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Dec 2020 13:52:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607799042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dRab5lNNMKQ4h1Cgpx6Hakf/XLGnhqOfT0II2ep+iVg=;
        b=ghD0tYUptf2OKfzRBQZkYJNS+9iJStx0b2/7dHV61961XmFsFKhKgPoSaufFsXEwQCebqH
        0IP3CJYNrSkDGQ4yFfrPOyyOKBAjcRv6hlPJgFV7H3mc9YDeRGe80lZ6XA/FxdXJ61DHPE
        MP+tJ4aeao1aAmYpUaAvMcY3uzmQzlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-t6d4hLZmPU6fcwpA_jTt0Q-1; Sat, 12 Dec 2020 13:50:40 -0500
X-MC-Unique: t6d4hLZmPU6fcwpA_jTt0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2936107ACF5;
        Sat, 12 Dec 2020 18:50:38 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-41.ams2.redhat.com [10.36.115.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA21F1F069;
        Sat, 12 Dec 2020 18:50:35 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     alexandru.elisei@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH 4/9] KVM: arm/arm64: vgic: Reset base address on kvm_vgic_dist_destroy()
Date:   Sat, 12 Dec 2020 19:50:05 +0100
Message-Id: <20201212185010.26579-5-eric.auger@redhat.com>
In-Reply-To: <20201212185010.26579-1-eric.auger@redhat.com>
References: <20201212185010.26579-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On vgic_dist_destroy(), the addresses are not reset. However for
kvm selftest purpose this would allow to continue the test execution
even after a failure when running KVM_RUN. So let's reset the
base addresses.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 32e32d67a127..6147bed56b1b 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -335,14 +335,16 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	kfree(dist->spis);
 	dist->spis = NULL;
 	dist->nr_spis = 0;
+	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
 
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
 		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list) {
 			list_del(&rdreg->list);
 			kfree(rdreg);
 		}
 		INIT_LIST_HEAD(&dist->rd_regions);
-	}
+	} else
+		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
 
 	if (vgic_has_its(kvm))
 		vgic_lpi_translation_cache_destroy(kvm);
@@ -362,6 +364,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	vgic_flush_pending_lpis(vcpu);
 
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
+	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 }
 
 /* To be called with kvm->lock held */
-- 
2.21.3

