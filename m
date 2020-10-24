Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37077297F2F
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764749AbgJXViL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764706AbgJXVfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:48 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A86C0613D6;
        Sat, 24 Oct 2020 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xw8zaOeRQ0PU1xVwW5DvZdQHD7uzCjkfoD1bMKNPBpw=; b=Nf+PHswmeNBSVP2YBC76Apqd+l
        gT7BFpXNM4GYFCjeEkSQ7NBhCZLNa1ipyvPdXVYLaQWzaDRGjQ5HlV26dFb9Rg36hzmcmgNiGrUMi
        Z8RqbROdeStx4MJ5jG2VtXnJ9dkNIWtqfYExAVNTzodCIAP8J0fMnM9mA532lZt6UtLJfqcJKAJp+
        2OcCR7qZ4jrUcGMkddeVij01kIX/v0w69MN0rgu00qDYhypW+K2yvpgfaK8dPyYyuKRI8cgC0ykdw
        FxLmmp8DWDct0OXcWtJMsSYTAaVHTrBUeNXmqjT6gKRjT2WEot7lv0+eZmAICyeXIGix9zSc1wTHr
        z1Qh1jBA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCT-0008BZ-1u; Sat, 24 Oct 2020 21:35:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rOb-0e; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 16/35] x86/kvm: Use msi_msg shadow structs
Date:   Sat, 24 Oct 2020 22:35:16 +0100
Message-Id: <20201024213535.443185-17-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201024213535.443185-1-dwmw2@infradead.org>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
 <20201024213535.443185-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Use the bitfields in the x86 shadow structs instead of decomposing the
32bit value with macros.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/irq_comm.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 4aa1c2e00e2a..8a4de3f12820 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -16,8 +16,6 @@
 
 #include <trace/events/kvm.h>
 
-#include <asm/msidef.h>
-
 #include "irq.h"
 
 #include "ioapic.h"
@@ -104,22 +102,19 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 		     struct kvm_lapic_irq *irq)
 {
-	trace_kvm_msi_set_irq(e->msi.address_lo | (kvm->arch.x2apic_format ?
-	                                     (u64)e->msi.address_hi << 32 : 0),
-	                      e->msi.data);
-
-	irq->dest_id = (e->msi.address_lo &
-			MSI_ADDR_DEST_ID_MASK) >> MSI_ADDR_DEST_ID_SHIFT;
-	if (kvm->arch.x2apic_format)
-		irq->dest_id |= MSI_ADDR_EXT_DEST_ID(e->msi.address_hi);
-	irq->vector = (e->msi.data &
-			MSI_DATA_VECTOR_MASK) >> MSI_DATA_VECTOR_SHIFT;
-	irq->dest_mode = kvm_lapic_irq_dest_mode(
-	    !!((1 << MSI_ADDR_DEST_MODE_SHIFT) & e->msi.address_lo));
-	irq->trig_mode = (1 << MSI_DATA_TRIGGER_SHIFT) & e->msi.data;
-	irq->delivery_mode = e->msi.data & 0x700;
-	irq->msi_redir_hint = ((e->msi.address_lo
-		& MSI_ADDR_REDIRECTION_LOWPRI) > 0);
+	struct msi_msg msg = { .address_lo = e->msi.address_lo,
+			       .address_hi = e->msi.address_hi,
+			       .data = e->msi.data };
+
+	trace_kvm_msi_set_irq(msg.address_lo | (kvm->arch.x2apic_format ?
+			      (u64)msg.address_hi << 32 : 0), msg.data);
+
+	irq->dest_id = x86_msi_msg_get_destid(&msg, kvm->arch.x2apic_format);
+	irq->vector = msg.arch_data.vector;
+	irq->dest_mode = kvm_lapic_irq_dest_mode(msg.arch_addr_lo.dest_mode_logical);
+	irq->trig_mode = msg.arch_data.is_level;
+	irq->delivery_mode = msg.arch_data.delivery_mode << 8;
+	irq->msi_redir_hint = msg.arch_addr_lo.redirect_hint;
 	irq->level = 1;
 	irq->shorthand = APIC_DEST_NOSHORT;
 }
-- 
2.26.2

