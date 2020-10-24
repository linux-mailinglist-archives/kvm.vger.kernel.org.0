Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366FF297F3E
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1765064AbgJXVii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764652AbgJXVfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:46 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA32C0613CE;
        Sat, 24 Oct 2020 14:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=S1lvl/DC/gyjaWPsgXg2h0mDGLQP5glXEoxBO6BZaJY=; b=mBxWyRIY35nZLEt2obNxgVRpuS
        iZwkZJsQhBYgKuOXTUeqUCNCYMg5LxrEy9feRdC6M/kZMGnoIv4lGhjuLsbLToiwlZ7M28opkRqoE
        C1H9YELtVkBjLe3PQGpvHEJDGn0tVI4aH3U8oXQbz3zlSDxBIITY+9Q8NSxeXJFgad01lUai2okah
        xwhR+Rsd77rje6c/JlvU8I611eNhrd3s9bcvWDUZ0CPPfiNQr/lcnhFq24IBTNpLnMsF4LAJoAx7E
        pybixXVkSFG/b2HXScQJsp7JOPiTZUmXQhfCNJTvZ/yuuLoBQY7rhnnzIffFCVFM9abSXV8cCIk8/
        tt5WMiig==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0008BS-OV; Sat, 24 Oct 2020 21:35:44 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCM-001rNw-NW; Sat, 24 Oct 2020 22:35:38 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 06/35] x86/apic: Replace pointless apic::dest_logical usage
Date:   Sat, 24 Oct 2020 22:35:06 +0100
Message-Id: <20201024213535.443185-7-dwmw2@infradead.org>
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

All these functions are only used for logical destination mode. So reading
the destination mode mask from the apic structure is a pointless
exercise. Just hand in the proper constant: APIC_DEST_LOGICAL.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/apic/apic_flat_64.c   | 2 +-
 arch/x86/kernel/apic/ipi.c            | 6 +++---
 arch/x86/kernel/apic/x2apic_cluster.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index fdd38a17f835..6df837fd5081 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -53,7 +53,7 @@ static void _flat_send_IPI_mask(unsigned long mask, int vector)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__default_send_IPI_dest_field(mask, vector, apic->dest_logical);
+	__default_send_IPI_dest_field(mask, vector, APIC_DEST_LOGICAL);
 	local_irq_restore(flags);
 }
 
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index 387154e39e08..d1fb874fbe64 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -260,7 +260,7 @@ void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
 	for_each_cpu(query_cpu, mask)
 		__default_send_IPI_dest_field(
 			early_per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-			vector, apic->dest_logical);
+			vector, APIC_DEST_LOGICAL);
 	local_irq_restore(flags);
 }
 
@@ -279,7 +279,7 @@ void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
 			continue;
 		__default_send_IPI_dest_field(
 			early_per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-			vector, apic->dest_logical);
+			vector, APIC_DEST_LOGICAL);
 		}
 	local_irq_restore(flags);
 }
@@ -297,7 +297,7 @@ void default_send_IPI_mask_logical(const struct cpumask *cpumask, int vector)
 
 	local_irq_save(flags);
 	WARN_ON(mask & ~cpumask_bits(cpu_online_mask)[0]);
-	__default_send_IPI_dest_field(mask, vector, apic->dest_logical);
+	__default_send_IPI_dest_field(mask, vector, APIC_DEST_LOGICAL);
 	local_irq_restore(flags);
 }
 
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 82fb43d807f7..f77e9fb7aac1 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -61,7 +61,7 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 		if (!dest)
 			continue;
 
-		__x2apic_send_IPI_dest(dest, vector, apic->dest_logical);
+		__x2apic_send_IPI_dest(dest, vector, APIC_DEST_LOGICAL);
 		/* Remove cluster CPUs from tmpmask */
 		cpumask_andnot(tmpmsk, tmpmsk, &cmsk->mask);
 	}
-- 
2.26.2

