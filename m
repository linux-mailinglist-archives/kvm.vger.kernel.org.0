Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC40D28C9DD
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 10:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391145AbgJMIMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 04:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391025AbgJMIMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 04:12:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B77C0613D5;
        Tue, 13 Oct 2020 01:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=68BAPD1PqgE+zWChu0rPe1NytmXmMNFtrjhEwr73rSg=; b=Z2G+tq/JpEjQSc/077xTiv4w/S
        UU/5T+1pqxMI2TQq45OzDjeuj1ch5n9OlSLRKz2EwlNVxQDAJYgYolehpB44oCgU0BItuiiw8AtUb
        /e00n70kcZPYiCNV6J1hyeBkt3LAWCiqQjQ211lwBA3jLxs/HxwaoSG3GhIVDI+cZ+Mv0xjxB38+H
        KJjzS/qXyHevSCC1iFZwBr/rUgTjwUhtufKfhlMwigh4vdTJ9bY7h2qEyguLjpDp3QaImro6zBNGL
        qa+KsRnim7zetTSd+AYzOxrIKh/g1JRFfQaAJn+frZ216WZv+2Mgteb9HDU4CRU53S0cdVUsgHxtB
        h19DsAXg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSFPM-0006fR-TN; Tue, 13 Oct 2020 08:12:01 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kSFPM-006XXl-Fj; Tue, 13 Oct 2020 09:11:44 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org
Subject: [PATCH 6/9] x86/hpet: Use irq_find_matching_fwspec() to find remapping irqdomain
Date:   Tue, 13 Oct 2020 09:11:36 +0100
Message-Id: <20201013081139.1558200-7-dwmw2@infradead.org>
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
 arch/x86/kernel/hpet.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 3b8b12769f3b..fb7736ca7b5b 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -543,8 +543,8 @@ static struct irq_domain *hpet_create_irq_domain(int hpet_id)
 {
 	struct msi_domain_info *domain_info;
 	struct irq_domain *parent, *d;
-	struct irq_alloc_info info;
 	struct fwnode_handle *fn;
+	struct irq_fwspec fwspec;
 
 	if (x86_vector_domain == NULL)
 		return NULL;
@@ -556,15 +556,6 @@ static struct irq_domain *hpet_create_irq_domain(int hpet_id)
 	*domain_info = hpet_msi_domain_info;
 	domain_info->data = (void *)(long)hpet_id;
 
-	init_irq_alloc_info(&info, NULL);
-	info.type = X86_IRQ_ALLOC_TYPE_HPET_GET_PARENT;
-	info.devid = hpet_id;
-	parent = irq_remapping_get_irq_domain(&info);
-	if (parent == NULL)
-		parent = x86_vector_domain;
-	else
-		hpet_msi_controller.name = "IR-HPET-MSI";
-
 	fn = irq_domain_alloc_named_id_fwnode(hpet_msi_controller.name,
 					      hpet_id);
 	if (!fn) {
@@ -572,6 +563,18 @@ static struct irq_domain *hpet_create_irq_domain(int hpet_id)
 		return NULL;
 	}
 
+	fwspec.fwnode = fn;
+	fwspec.param_count = 1;
+	fwspec.param[0] = hpet_id;
+	parent = irq_find_matching_fwspec(&fwspec, DOMAIN_BUS_ANY);
+	if (!parent) {
+		irq_domain_free_fwnode(fn);
+		kfree(domain_info);
+		return NULL;
+	}
+	if (parent != x86_vector_domain)
+		hpet_msi_controller.name = "IR-HPET-MSI";
+
 	d = msi_create_irq_domain(fn, domain_info, parent);
 	if (!d) {
 		irq_domain_free_fwnode(fn);
-- 
2.26.2

