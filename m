Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF911B8559
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 11:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgDYJoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 05:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbgDYJoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 05:44:54 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFF832064C;
        Sat, 25 Apr 2020 09:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587807894;
        bh=hbcviEx626chZm3MDI73tTRFC1Bak0yE4bT+LlrKlz8=;
        h=From:To:Cc:Subject:Date:From;
        b=f1zbBBC9R3jLlcrk8D+MtVDc/EpaeLHY61g/LIf0YQmldc02dH17V87ccKJQhqXZ4
         SJF/NsTajZ+xmjI8CHw9bHInwhuObC6SDfV+JpT2aBEoJpxQ8YMK2UkwHxNRtJaZnR
         FDyi2WUg89eS13Wlf4YniGNCqfk45wpDlHtrQh84=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jSHMi-006HBD-Ce; Sat, 25 Apr 2020 10:44:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH] KVM: arm64: vgic-v4: Initialize GICv4.1 even in the absence of a virtual ITS
Date:   Sat, 25 Apr 2020 10:44:26 +0100
Message-Id: <20200425094426.162962-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM now expects to be able to use HW-accelerated delivery of vSGIs
as soon as the guest has enabled thm. Unfortunately, we only
initialize the GICv4 context if we have a virtual ITS exposed to
the guest.

Fix it by always initializing the GICv4.1 context if it is
available on the host.

Fixes: 2291ff2f2a56 ("KVM: arm64: GICv4.1: Plumb SGI implementation selection in the distributor")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-init.c    | 9 ++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index a963b9d766b73..8e6f350c3bcd1 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -294,8 +294,15 @@ int vgic_init(struct kvm *kvm)
 		}
 	}
 
-	if (vgic_has_its(kvm)) {
+	if (vgic_has_its(kvm))
 		vgic_lpi_translation_cache_init(kvm);
+
+	/*
+	 * If we have GICv4.1 enabled, unconditionnaly request enable the
+	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
+	 * enable it if we present a virtual ITS to the guest.
+	 */
+	if (vgic_supports_direct_msis(kvm)) {
 		ret = vgic_v4_init(kvm);
 		if (ret)
 			goto out;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index e72dcc4542475..26b11dcd45524 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -50,7 +50,8 @@ bool vgic_has_its(struct kvm *kvm)
 
 bool vgic_supports_direct_msis(struct kvm *kvm)
 {
-	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
+	return (kvm_vgic_global_state.has_gicv4_1 ||
+		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
 }
 
 /*
-- 
2.26.2

