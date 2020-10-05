Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6ED283B3B
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 17:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgJEPkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 11:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727524AbgJEP3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669A2C0613AF;
        Mon,  5 Oct 2020 08:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Mgg6kezGCxQyZfR1XtRZQfzcS8/IMb4UEOhailZTsT0=; b=Q1YCVnUcbTrToEFiUSc8yVe3Xt
        wKg0pnossS2LjB5wwGHpFWzLo4jSYSAjkk6QDriWfuWSNeF8oeggeSJwUh8yyAJS8k3HfEgBAHalH
        ZBDCb5jQj1aiV26yX7fWS50MuGEYf3wH6PrkwqSNcOchTGKWsp++MLXOupaH/N/3cmex3WClhMy/R
        SvWjr+B/aCLDxukGqyfDI4v1HdcfnLUGTk7iJc/cr82lQTjCHeD9XYR7XsADrJ113mcvMxQMQFxY7
        +U0Mi9vEhg09HU1sbGUKq1wCpOLaujbruCaYSgvQOO7wbe5tPtXJIOsbMEBviRChW7ChT2gUzBRMU
        zQlRgeZw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPSQ4-0001mN-SV; Mon, 05 Oct 2020 15:28:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kPSQ4-0045Qp-Dq; Mon, 05 Oct 2020 16:28:56 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 09/13] x86/irq: Add x86_non_ir_cpumask
Date:   Mon,  5 Oct 2020 16:28:52 +0100
Message-Id: <20201005152856.974112-9-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005152856.974112-1-dwmw2@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org>
 <20201005152856.974112-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This is the mask of CPUs to which IRQs can be delivered without interrupt
remapping.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/mpspec.h  |  1 +
 arch/x86/kernel/apic/apic.c    | 12 ++++++++++++
 arch/x86/kernel/apic/io_apic.c |  2 ++
 3 files changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 25ee8ca0a1f2..b2090be5b444 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -141,5 +141,6 @@ static inline void physid_set_mask_of_physid(int physid, physid_mask_t *map)
 #define PHYSID_MASK_NONE	{ {[0 ... PHYSID_ARRAY_SIZE-1] = 0UL} }
 
 extern physid_mask_t phys_cpu_present_map;
+extern cpumask_t x86_non_ir_cpumask;
 
 #endif /* _ASM_X86_MPSPEC_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 459c78558f36..069f5e9f1d28 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -103,6 +103,9 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_acpiid);
 
+/* Mask of CPUs which can be targeted by non-remapped interrupts. */
+cpumask_t x86_non_ir_cpumask = { CPU_BITS_ALL };
+
 #ifdef CONFIG_X86_32
 
 /*
@@ -1838,6 +1841,7 @@ static __init void x2apic_enable(void)
 static __init void try_to_enable_x2apic(int remap_mode)
 {
 	u32 apic_limit = 0;
+	int i;
 
 	if (x2apic_state == X2APIC_DISABLED)
 		return;
@@ -1880,6 +1884,14 @@ static __init void try_to_enable_x2apic(int remap_mode)
 	if (apic_limit)
 		x2apic_set_max_apicid(apic_limit);
 
+	/* Build the affinity mask for interrupts that can't be remapped. */
+	cpumask_clear(&x86_non_ir_cpumask);
+	i = min_t(unsigned int, num_possible_cpus() - 1, apic_limit);
+	for ( ; i >= 0; i--) {
+		if (cpu_physical_id(i) <= apic_limit)
+			cpumask_set_cpu(i, &x86_non_ir_cpumask);
+	}
+
 	x2apic_enable();
 }
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index aa9a3b54a96c..4d0ef46fedb9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2098,6 +2098,8 @@ static int mp_alloc_timer_irq(int ioapic, int pin)
 		struct irq_alloc_info info;
 
 		ioapic_set_alloc_attr(&info, NUMA_NO_NODE, 0, 0);
+		if (domain->parent == x86_vector_domain)
+			info.mask = &x86_non_ir_cpumask;
 		info.devid = mpc_ioapic_id(ioapic);
 		info.ioapic.pin = pin;
 		mutex_lock(&ioapic_mutex);
-- 
2.26.2

