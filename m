Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8DE2A3F54
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 09:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbgKCIwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 03:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgKCIwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 03:52:42 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD001C0613D1;
        Tue,  3 Nov 2020 00:52:41 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id i7so11214671pgh.6;
        Tue, 03 Nov 2020 00:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x0V9Eqsw0P/c1uqnmbZIL7sQkwkXO9ZRETLMblzJ8gw=;
        b=mmHGeeOfpKkGy9BXLSA5CXBvj1YkjRIcKTdmituqmoxcsQkc/MaSlOf2gMGlU/PADh
         z0P4HpgvC3s9CIiP3T8sJuahEWTNB3j9eogiQo+kqAMCK58eQDF80XcGc0o3vY3Jj3y+
         cuBt8QUScSQu1vfWOef6m8SDoDvgfh7WbsKKIY01sRy56WhFWXMHqMjtIPeV88DCUHiU
         ky5y36SyCraqGgjwSfb+c4mhqWQPOJsGNLzV30NYpqON3PeK9eSuDZKPkoWK+4bXmFUF
         sF4GIKawTEPZ/wik8JHK/wxWqBJGVGa5SnHu0D7MzPKtJJVU4rj4O76awq5f5ZxTB0wG
         6o2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x0V9Eqsw0P/c1uqnmbZIL7sQkwkXO9ZRETLMblzJ8gw=;
        b=eBRFSecLlF0uA8qKiuRvuBjed0gcev6/bnb62WQuR7jWHWIcAJbHaDbK9ey8fxAQ8r
         OF5IcYcLrarvZ1B5M+H9f44CDMn2MeAL6mAxKCkqqEYvjjnv5XqX7JZllBXSMOeiYgpY
         o7HfTIotObCaxudTjJPtm3+XJY2RYiHDPNELC1n9m3+oCfnkyX5gkLkqIUurZ/K2a6qk
         Z/5bAVgWJYW63IFRATqQAHdlUiyTvJQ7ba+b7ODzns2XyDIGqqDMWP1rGV8zrMYYxs5i
         pAdne5sYkZHfo4RMxE3O68TZwBsE83/gg5PnqBQ5xDN3zVx9MYOQs6KynOeFZJkEZUhT
         ahvQ==
X-Gm-Message-State: AOAM533bEsYdmlL8gA+bV002B8IE+L+jgXoYZV1ZvPM3MnqwxahjVl1O
        LIbzRRsbERvkn6iF6FWj8gHDQlKHsanFN8s=
X-Google-Smtp-Source: ABdhPJxcq5b+6l9ITRsWB1Ya1KrxYn9ZW+9/FYoZ0RkoB4msCHH1juevPLTgR45sRW2PGWSk75YCkg==
X-Received: by 2002:a17:90b:384b:: with SMTP id nl11mr2799496pjb.126.1604393560956;
        Tue, 03 Nov 2020 00:52:40 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id q13sm15978340pfg.3.2020.11.03.00.52.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2020 00:52:40 -0800 (PST)
From:   lihaiwei.kernel@gmail.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v5] KVM: Check the allocation of pv cpu mask
Date:   Tue,  3 Nov 2020 16:52:27 +0800
Message-Id: <20201103085227.25098-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

Both 'kvm_send_ipi_mask_allbutself' and 'kvm_flush_tlb_others' are using
per-cpu __pv_cpu_mask. Init pv ipi ops only if the allocation succeeds and
check the cpumask in 'kvm_flush_tlb_others'.

Thanks to Vitaly Kuznetsov's tireless advice.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
v1 -> v2:
 * add CONFIG_SMP for kvm_send_ipi_mask_allbutself to prevent build error
v2 -> v3:
 * always check the allocation of __pv_cpu_mask in kvm_flush_tlb_others
v3 -> v4:
 * mov kvm_setup_pv_ipi to kvm_alloc_cpumask and get rid of kvm_apic_init
v4 -> v5:
 * remove kvm_apic_init as an empty function
 * define pv_ipi_supported() in !CONFIG_SMP case as 'false' to get rid of
 'alloc' variable
 * move kvm_setup_pv_ipi and define the implementation in CONFIG_SMP

 arch/x86/kernel/kvm.c | 75 +++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 42c6e0deff9e..2f2cc25d5078 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -547,16 +547,6 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 	__send_ipi_mask(local_mask, vector);
 }
 
-/*
- * Set the IPI entry points
- */
-static void kvm_setup_pv_ipi(void)
-{
-	apic->send_IPI_mask = kvm_send_ipi_mask;
-	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
-	pr_info("setup PV IPIs\n");
-}
-
 static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
 {
 	int cpu;
@@ -609,7 +599,24 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 	local_irq_enable();
 	return 0;
 }
+#else
+static bool pv_ipi_supported(void)
+{
+	return false;
+}
+#endif
+
+/*
+ * Set the IPI entry points
+ */
+static void kvm_setup_pv_ipi(void)
+{
+#if defined(CONFIG_SMP)
+	apic->send_IPI_mask = kvm_send_ipi_mask;
+	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
+	pr_info("setup PV IPIs\n");
 #endif
+}
 
 static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 			const struct flush_tlb_info *info)
@@ -619,6 +626,11 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 	struct kvm_steal_time *src;
 	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
 
+	if (unlikely(!flushmask)) {
+		native_flush_tlb_others(cpumask, info);
+		return;
+	}
+
 	cpumask_copy(flushmask, cpumask);
 	/*
 	 * We have to call flush only on online vCPUs. And
@@ -730,18 +742,9 @@ static uint32_t __init kvm_detect(void)
 	return kvm_cpuid_base();
 }
 
-static void __init kvm_apic_init(void)
-{
-#if defined(CONFIG_SMP)
-	if (pv_ipi_supported())
-		kvm_setup_pv_ipi();
-#endif
-}
-
 static void __init kvm_init_platform(void)
 {
 	kvmclock_init();
-	x86_platform.apic_post_init = kvm_apic_init;
 }
 
 const __initconst struct hypervisor_x86 x86_hyper_kvm = {
@@ -765,29 +768,39 @@ static __init int activate_jump_labels(void)
 }
 arch_initcall(activate_jump_labels);
 
+static void kvm_free_cpumask(void)
+{
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
+}
+
 static __init int kvm_alloc_cpumask(void)
 {
 	int cpu;
-	bool alloc = false;
 
 	if (!kvm_para_available() || nopv)
 		return 0;
 
-	if (pv_tlb_flush_supported())
-		alloc = true;
-
-#if defined(CONFIG_SMP)
-	if (pv_ipi_supported())
-		alloc = true;
-#endif
-
-	if (alloc)
+	if (pv_tlb_flush_supported() || pv_ipi_supported()) {
 		for_each_possible_cpu(cpu) {
-			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
-				GFP_KERNEL, cpu_to_node(cpu));
+			if (!zalloc_cpumask_var_node(
+				per_cpu_ptr(&__pv_cpu_mask, cpu),
+				GFP_KERNEL, cpu_to_node(cpu))) {
+				goto zalloc_cpumask_fail;
+			}
 		}
+	}
+
+	if (pv_ipi_supported())
+		kvm_setup_pv_ipi();
 
 	return 0;
+
+zalloc_cpumask_fail:
+	kvm_free_cpumask();
+	return -ENOMEM;
 }
 arch_initcall(kvm_alloc_cpumask);
 
-- 
2.18.4

