Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E681B1E2693
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 18:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388477AbgEZQLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 12:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388412AbgEZQLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 12:11:43 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FA9520787;
        Tue, 26 May 2020 16:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590509502;
        bh=OfzjQ6qwUkq4xj9uEs3icHSWi5yhPJTMuRBRnHcDMOc=;
        h=From:To:Cc:Subject:Date:From;
        b=fwYJhxyhXbpAP1azX/w1PSR3utcinTPR1su9+GiO8MIfNEDZExGMTSpjkcG/4N41M
         /yrkF+/edaOXHMp3wdst4J7xljimX5w3liEMGCjoprGhsFbuQ/ERJ8N+VfnQ+koC+X
         82uEgf5J5x9qWjUn9U5RjhVVOdhOtZt4v4DFZREc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jdcB2-00FQrL-JD; Tue, 26 May 2020 17:11:40 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH] KVM: arm64: Allow in-atomic injection of SPIs
Date:   Tue, 26 May 2020 17:11:36 +0100
Message-Id: <20200526161136.451312-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a system that uses SPIs to implement MSIs (as it would be
the case on a GICv2 system exposing a GICv2m to its guests),
we deny the possibility of injecting SPIs on the in-atomic
fast-path.

This results in a very large amount of context-switches
(roughly equivalent to twice the interrupt rate) on the host,
and suboptimal performance for the guest (as measured with
a test workload involving a virtio interface backed by vhost-net).
Given that GICv2 systems are usually on the low-end of the spectrum
performance wise, they could do without the aggravation.

We solved this for GICv3+ITS by having a translation cache. But
SPIs do not need any extra infrastructure, and can be immediately
injected in the virtual distributor as the locking is already
heavy enough that we don't need to worry about anything.

This halves the number of context switches for the same workload.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-irqfd.c | 20 ++++++++++++++++----
 arch/arm64/kvm/vgic/vgic-its.c   |  3 +--
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index d8cdfea5cc96..11a9f81115ab 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -107,15 +107,27 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 			      struct kvm *kvm, int irq_source_id, int level,
 			      bool line_status)
 {
-	if (e->type == KVM_IRQ_ROUTING_MSI && vgic_has_its(kvm) && level) {
+	if (!level)
+		return -EWOULDBLOCK;
+
+	switch (e->type) {
+	case KVM_IRQ_ROUTING_MSI: {
 		struct kvm_msi msi;
 
+		if (!vgic_has_its(kvm))
+			return -EINVAL;
+
 		kvm_populate_msi(e, &msi);
-		if (!vgic_its_inject_cached_translation(kvm, &msi))
-			return 0;
+		return vgic_its_inject_cached_translation(kvm, &msi);
 	}
 
-	return -EWOULDBLOCK;
+	case KVM_IRQ_ROUTING_IRQCHIP:
+		/* Injecting SPIs is always possible in atomic context */
+		return vgic_irqfd_set_irq(e, kvm, irq_source_id, 1, line_status);
+
+	default:
+		return -EWOULDBLOCK;
+	}
 }
 
 int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index c012a52b19f5..40cbaca81333 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -757,9 +757,8 @@ int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
 
 	db = (u64)msi->address_hi << 32 | msi->address_lo;
 	irq = vgic_its_check_cache(kvm, db, msi->devid, msi->data);
-
 	if (!irq)
-		return -1;
+		return -EWOULDBLOCK;
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->pending_latch = true;
-- 
2.26.2

