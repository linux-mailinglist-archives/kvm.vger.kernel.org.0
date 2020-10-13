Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDDE28C9ED
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 10:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391289AbgJMIM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 04:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390509AbgJMIMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 04:12:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122A7C0613D2;
        Tue, 13 Oct 2020 01:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hmh+cWjAWCvT+LUvteBTFWpQOXVAFRbvzGJv+WEOTU0=; b=hN5jmwwhHs+nfEGh5M8fiwRhX6
        bykwjHtzZTXO1qZK1Yf2aIdhaeO5dAvwPVLz6wHZbhiDCPU+KJksaxXS9OqCEOgWknikRR6xlwkcD
        sM8p/JawRoaLMz4Zp0mC7k5VBCdUYHsG5E//EEr7SWPCCwq6qxYmXaJ6SuQ0Yq0VcbR8UXPi8w4gw
        y4FTcBc1fMLuvYYOgklFYRhabEfk6PjC8tMQiI2wf4NdabFJXOnfiDqwnJ9mi+Hgf37P2NV5/BBrD
        GLuR9iOJDmdGANjkji/OX3ckr7Wgyo7OPY/nLGK/MhnkYyZSqOtZ5IrZC7eXo3ewWKDg2siq7XR6m
        w1y1LfRg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSFPM-0006fQ-T4; Tue, 13 Oct 2020 08:12:01 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kSFPM-006XXg-F4; Tue, 13 Oct 2020 09:11:44 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org
Subject: [PATCH 5/9] iommu/hyper-v: Implement select() method on remapping irqdomain
Date:   Tue, 13 Oct 2020 09:11:35 +0100
Message-Id: <20201013081139.1558200-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201013081139.1558200-1-dwmw2@infradead.org>
References: <0de733f6384874d68afba2606119d0d9b1e8b34e.camel@infradead.org>
 <20201013081139.1558200-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/iommu/hyperv-iommu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index 37dd485a5640..6a8966fbc3bd 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -61,6 +61,14 @@ static struct irq_chip hyperv_ir_chip = {
 	.irq_set_affinity	= hyperv_ir_set_affinity,
 };
 
+static int hyperv_irq_remapping_select(struct irq_domain *d,
+				       struct irq_fwspec *fwspec,
+				       enum irq_domain_bus_token bus_token)
+{
+	/* Claim only the first (and only) I/OAPIC */
+	return x86_fwspec_is_ioapic(fwspec) && fwspec->param[0] == 0;
+}
+
 static int hyperv_irq_remapping_alloc(struct irq_domain *domain,
 				     unsigned int virq, unsigned int nr_irqs,
 				     void *arg)
@@ -102,6 +110,7 @@ static void hyperv_irq_remapping_free(struct irq_domain *domain,
 }
 
 static const struct irq_domain_ops hyperv_ir_domain_ops = {
+	.select = hyperv_irq_remapping_select,
 	.alloc = hyperv_irq_remapping_alloc,
 	.free = hyperv_irq_remapping_free,
 };
-- 
2.26.2

