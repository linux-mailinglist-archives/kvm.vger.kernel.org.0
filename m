Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71A9297F07
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764745AbgJXVgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764743AbgJXVfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29A7C0613E8;
        Sat, 24 Oct 2020 14:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6P1gD3McCWLKUcPiphzF+N95ogeT6kA1l9xHdYtAzL0=; b=FV/MKaIfnNXwdfiHABneg7LCOK
        omQdF5Q9WzrGJpb7RZrw2x8VLMMexc8EKTK6meXdVhoi/3uXo76LQj5UNua62ZqzyBvEbykhsuzfr
        ew1+HYGrKD/Fv+8DZbahucFtwlLHPS7v3cl4bkS0fkWNWRN6EVK0Sc9UqmxR+bmtS01PSe4eN3jyw
        HCPWqzAWpMUMYQda9+i5YzxufcZW/Yjr9jqxOxJlz3s3fWM3tScP+dnK69kzn7gcKyx+xCXNHZCA7
        MS46NIfRmVeEQdcfsfKN8NUeyXBZi/K69D6Vlwp1cmm2+raZ/4yOPijk6mhy0upXmoFgetGiTi712
        9A7voY1A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0006HJ-Pa; Sat, 24 Oct 2020 21:35:47 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rPG-AF; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 26/35] iommu/hyper-v: Implement select() method on remapping irqdomain
Date:   Sat, 24 Oct 2020 22:35:26 +0100
Message-Id: <20201024213535.443185-27-dwmw2@infradead.org>
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
 drivers/iommu/hyperv-iommu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index 37dd485a5640..78a264ad9405 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -101,7 +101,16 @@ static void hyperv_irq_remapping_free(struct irq_domain *domain,
 	irq_domain_free_irqs_common(domain, virq, nr_irqs);
 }
 
+static int hyperv_irq_remapping_select(struct irq_domain *d,
+				       struct irq_fwspec *fwspec,
+				       enum irq_domain_bus_token bus_token)
+{
+	/* Claim only the first (and only) I/OAPIC */
+	return x86_fwspec_is_ioapic(fwspec) && fwspec->param[0] == 0;
+}
+
 static const struct irq_domain_ops hyperv_ir_domain_ops = {
+	.select = hyperv_irq_remapping_select,
 	.alloc = hyperv_irq_remapping_alloc,
 	.free = hyperv_irq_remapping_free,
 };
-- 
2.26.2

