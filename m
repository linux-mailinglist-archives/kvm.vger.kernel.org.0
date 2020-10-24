Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956FF297F32
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1765068AbgJXViY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764701AbgJXVfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:47 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F697C0613D2;
        Sat, 24 Oct 2020 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=oRyakceIP/TFXvK76fbdXS3FFH/9LgbMQ1HbuHTy96Y=; b=d5b57apRweNghhk9ezifYmHEda
        JPVqba1KtUlqcAJ5GQALllLQyxydLXGW6P/qinNaYpJNzecpjnogG9J6Delg0cg7ouZuqAejJkAvg
        i8ni2pGb6L6JuvIZeahlDvl2hsqcX+6ML36O0bHmQo3Pl3QZqOLFV6CMo1I99VEKoT8SK3ZX7u5Kx
        3zMO0fAb3cX8o08K1SABBK4r4OZ3YrP+WpYfLswpiDkVQ7z0HCGg+KjYQrqm+JV2wMMKvODlo5dSG
        7St5aUW07NHnRje9KZribPJGjrN93wzPJGx7CQ3gKOZX8L1LLsmtlpogVCMee6TpZOfTVjwYrdpq9
        s+bCa8IQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0008BW-Tj; Sat, 24 Oct 2020 21:35:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCM-001rOH-S9; Sat, 24 Oct 2020 22:35:38 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 11/35] genirq/msi: Allow shadow declarations of msi_msg::$member
Date:   Sat, 24 Oct 2020 22:35:11 +0100
Message-Id: <20201024213535.443185-12-dwmw2@infradead.org>
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

Architectures like x86 have their MSI messages in various bits of the data,
address_lo and address_hi field. Composing or decomposing these messages
with bitmasks and shifts is possible, but unreadable gunk.

Allow architectures to provide an architecture specific representation for
each member of msi_msg. Provide empty defaults for each and stick them into
an union.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/asm-generic/msi.h |  4 ++++
 include/linux/msi.h       | 46 +++++++++++++++++++++++++++++++++++----
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/msi.h b/include/asm-generic/msi.h
index e6795f088bdd..25344de0e8f9 100644
--- a/include/asm-generic/msi.h
+++ b/include/asm-generic/msi.h
@@ -4,6 +4,8 @@
 
 #include <linux/types.h>
 
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+
 #ifndef NUM_MSI_ALLOC_SCRATCHPAD_REGS
 # define NUM_MSI_ALLOC_SCRATCHPAD_REGS	2
 #endif
@@ -30,4 +32,6 @@ typedef struct msi_alloc_info {
 
 #define GENERIC_MSI_DOMAIN_OPS		1
 
+#endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
+
 #endif
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 6b584cc4757c..360a0a7e7341 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -4,11 +4,50 @@
 
 #include <linux/kobject.h>
 #include <linux/list.h>
+#include <asm/msi.h>
+
+/* Dummy shadow structures if an architecture does not define them */
+#ifndef arch_msi_msg_addr_lo
+typedef struct arch_msi_msg_addr_lo {
+	u32	address_lo;
+} __attribute__ ((packed)) arch_msi_msg_addr_lo_t;
+#endif
+
+#ifndef arch_msi_msg_addr_hi
+typedef struct arch_msi_msg_addr_hi {
+	u32	address_hi;
+} __attribute__ ((packed)) arch_msi_msg_addr_hi_t;
+#endif
+
+#ifndef arch_msi_msg_data
+typedef struct arch_msi_msg_data {
+	u32	data;
+} __attribute__ ((packed)) arch_msi_msg_data_t;
+#endif
 
+/**
+ * msi_msg - Representation of a MSI message
+ * @address_lo:		Low 32 bits of msi message address
+ * @arch_addrlo:	Architecture specific shadow of @address_lo
+ * @address_hi:		High 32 bits of msi message address
+ *			(only used when device supports it)
+ * @arch_addrhi:	Architecture specific shadow of @address_hi
+ * @data:		MSI message data (usually 16 bits)
+ * @arch_data:		Architecture specific shadow of @data
+ */
 struct msi_msg {
-	u32	address_lo;	/* low 32 bits of msi message address */
-	u32	address_hi;	/* high 32 bits of msi message address */
-	u32	data;		/* 16 bits of msi message data */
+	union {
+		u32			address_lo;
+		arch_msi_msg_addr_lo_t	arch_addr_lo;
+	};
+	union {
+		u32			address_hi;
+		arch_msi_msg_addr_hi_t	arch_addr_hi;
+	};
+	union {
+		u32			data;
+		arch_msi_msg_data_t	arch_data;
+	};
 };
 
 extern int pci_msi_ignore_mask;
@@ -243,7 +282,6 @@ struct msi_controller {
 #ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
 
 #include <linux/irqhandler.h>
-#include <asm/msi.h>
 
 struct irq_domain;
 struct irq_domain_ops;
-- 
2.26.2

