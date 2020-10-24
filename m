Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F249297F0D
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764914AbgJXVgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764738AbgJXVfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0457C0613E3;
        Sat, 24 Oct 2020 14:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=sMMy3wXS54uijk4JH5h3J7a4vVaW9RZ2xz4PorGmAdc=; b=V66eUBuWO4rf6hZdw+dIrvBEom
        6ghRQagZ472dGOfBPsSM+j2XG/Npz8Q5rFD6FRcIj0XP5I/rN0GS5Cc/ty2kBdbSZVLJXyCQ355Vz
        80E33MCeXrBP871hJmda8b46XjejL84Qhm3XyUAGMp6lSY3PtZqBSabd2HPdvZrM/qlNlCvXxI7jN
        867hMv150JWpcevvEWqw6dwecZpDT7HzrfaozBsG18H1Sz+GnF+OlkYoT9w4p7QvqVVJg81/VEpYa
        Npx+OZtLDkTIcf1btcw2Z2W7UfcloK0jGCOgo7xT3axgO+P1DZ8ERe/E/N+0CEZR/1Tv3GRP4un9j
        hu20adpA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0006HI-P8; Sat, 24 Oct 2020 21:35:46 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rPC-9N; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 25/35] iommu/vt-d: Implement select() method on remapping irqdomain
Date:   Sat, 24 Oct 2020 22:35:25 +0100
Message-Id: <20201024213535.443185-26-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201024213535.443185-1-dwmw2@infradead.org>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
 <20201024213535.443185-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Preparatory for removing irq_remapping_get_irq_domain()

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/intel/irq_remapping.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 96c84b19940e..b3b079c0b51e 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1431,7 +1431,20 @@ static void intel_irq_remapping_deactivate(struct irq_domain *domain,
 	modify_irte(&data->irq_2_iommu, &entry);
 }
 
+static int intel_irq_remapping_select(struct irq_domain *d,
+				      struct irq_fwspec *fwspec,
+				      enum irq_domain_bus_token bus_token)
+{
+	if (x86_fwspec_is_ioapic(fwspec))
+		return d == map_ioapic_to_ir(fwspec->param[0]);
+	else if (x86_fwspec_is_hpet(fwspec))
+		return d == map_hpet_to_ir(fwspec->param[0]);
+
+	return 0;
+}
+
 static const struct irq_domain_ops intel_ir_domain_ops = {
+	.select = intel_irq_remapping_select,
 	.alloc = intel_irq_remapping_alloc,
 	.free = intel_irq_remapping_free,
 	.activate = intel_irq_remapping_activate,
-- 
2.26.2

