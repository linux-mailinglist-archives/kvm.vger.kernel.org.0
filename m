Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BF828C9CE
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 10:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390978AbgJMILz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 04:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390455AbgJMILs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 04:11:48 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAADDC0613D5;
        Tue, 13 Oct 2020 01:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ggt2FIaNlav+mhwb7ExyXOpgsZLXvYYnSlMJRwHbRBo=; b=SEZtBoJndY84O8F8UaLlR0uQAd
        MnSfN4tW/KhbOKNwCBYX4t1k/NqGnC0+qdAiaXYjxfponTGMp6l+Revbbsgswd7vBrZQgaKatLq6L
        B8J+mMWd1H8v9TvJFAPueqIlAgBN3RJRVHR4C8sc1EOBUHu4fCZ/a+Xa9l6LIwUQsYyJzGbdIYrZL
        7WrJqwXPkaidAB5bDWIuzg7YnGmeGLTDQ6uGoHFGhL8D141RfIMD4yROVKLPLueJ2DmndYE13uHwl
        9Sr9LH/Bd7G9Z5RtRgpnOxieUw39UoADXaBRu8zgx686bIh78eAklj+6b+NupNTj9y9m8lwZ8yLKY
        xdqtrgEw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSFPN-0005sa-Ev; Tue, 13 Oct 2020 08:11:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kSFPM-006XXb-EN; Tue, 13 Oct 2020 09:11:44 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org
Subject: [PATCH 4/9] iommu/vt-d: Implement select() method on remapping irqdomain
Date:   Tue, 13 Oct 2020 09:11:34 +0100
Message-Id: <20201013081139.1558200-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201013081139.1558200-1-dwmw2@infradead.org>
References: <0de733f6384874d68afba2606119d0d9b1e8b34e.camel@infradead.org>
 <20201013081139.1558200-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/iommu/intel/irq_remapping.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 511dfb4884bc..40c2fec122b8 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1435,7 +1435,20 @@ static void intel_irq_remapping_deactivate(struct irq_domain *domain,
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

