Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1211028C9EB
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 10:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391266AbgJMIM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 04:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391063AbgJMIMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 04:12:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18374C0613D7;
        Tue, 13 Oct 2020 01:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EY8UHzC6+5/iDJsfDzabkl6LPehqG3ZtEqYxa4ewh6o=; b=Q+cMUieQWgDbWqlRk6eSdi2Goq
        w4opBNGckPwtNox/hjjkpzSKduFWkniiM62a9BNOz3omxqd7LmwuhvMMfKHhmvneRc2Y7q9Emk3IJ
        Gpq790hBMJOcSHeWvqDUp6HKrwkJkMcJT1o7eaiQDcZiqt+B82cdLbRHNpwwyVPibK/LszJfwbTKQ
        RCo0fhNtVRokIeFP3g5qGTj+LK/1pbZUHMuGcyAbofjzW7kGsyI4LiIGfsuUxJtL+/m8pJBLGeHLc
        3e/mg0uhAKUDX5nzK7YFhfi+ZDgKDC4BJPfudyanlNWmGHWWF0s1GHbq/BJDAE68MXZX36ehTaI/X
        CMZ69h8A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSFPM-0006fO-Qj; Tue, 13 Oct 2020 08:12:01 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kSFPM-006XXM-CG; Tue, 13 Oct 2020 09:11:44 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org
Subject: [PATCH 1/9] genirq/irqdomain: Implement get_name() method on irqchip fwnodes
Date:   Tue, 13 Oct 2020 09:11:31 +0100
Message-Id: <20201013081139.1558200-2-dwmw2@infradead.org>
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
 kernel/irq/irqdomain.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 76cd7ebd1178..6440f97c412e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -42,7 +42,16 @@ static inline void debugfs_add_domain_dir(struct irq_domain *d) { }
 static inline void debugfs_remove_domain_dir(struct irq_domain *d) { }
 #endif
 
-const struct fwnode_operations irqchip_fwnode_ops;
+static const char *irqchip_fwnode_get_name(const struct fwnode_handle *fwnode)
+{
+	struct irqchip_fwid *fwid = container_of(fwnode, struct irqchip_fwid, fwnode);
+
+	return fwid->name;
+}
+
+const struct fwnode_operations irqchip_fwnode_ops = {
+	.get_name = irqchip_fwnode_get_name,
+};
 EXPORT_SYMBOL_GPL(irqchip_fwnode_ops);
 
 /**
-- 
2.26.2

