Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0FB29135D
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 19:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438714AbgJQRyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 13:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438689AbgJQRyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 13:54:44 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2906EC061755;
        Sat, 17 Oct 2020 10:54:44 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id hk7so3243215pjb.2;
        Sat, 17 Oct 2020 10:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ywf91qFk4g7sz+DlmxxY8d4Lv3wU4S3rRm5J3fQEk4I=;
        b=UZMxJgpw2+g0COQ0LZ330jX8puaeXgFg86Yfbu4RbU2DBTTg61lxtelBciP6dNan4K
         UmV5FoIhzK7ibnO9G4ii5EDKh+HWCsi/8+eVxGxEXcfOlfsoPHFlQtT0k2AV3QOLVu+1
         hny/0fnCMOeS8dsZYnwWypgG56VNHBgALMCJz2mazB5ia2xo8EfX4q3QaNqv23qcxw/f
         Ou7X+Aab1THgbP9vdSrkyxJv2Cuo/5gwXIanzJ/UrkrxvJxX3Edc8yXReN3FI98DLDNb
         sPfjeqEgDsNMzEu+28ZHFJRJ/4yim5X2H/xv/0RPHSAu5p/SFtwvcblfr28DbnKO+/sh
         h+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ywf91qFk4g7sz+DlmxxY8d4Lv3wU4S3rRm5J3fQEk4I=;
        b=WWDJ0cgOKzT7gsW6KUgK7dhrOfmTvQLEW+sCFBPYCEioNs3Tmdy/pP3kP/HWbZV7v6
         1W0C4VnuL1bR2GRKMSfYslISTDJbuvxTXefn6aZs+XeK1w7nk+7sBkCwgSyH9yn4QR6j
         l3jP8117sZCqgm4ok7j/vjnG8Zkmhlx2B34tzhjres/GFAzZ/axdIVG+8baw6IQ4jykC
         q2vSuphUlkZeWKXHyjzUOiiFreSQQGtFFDiYoqPr5UplTR4lNG7PGzJLGIHrb2cnRoRH
         lnAkCE+QVYB/zAuOlXBqUxTDPNlm1RX2Unflt6zoCC9KkLjn2aNWZMz0/HEvbeEMPWJx
         +PPw==
X-Gm-Message-State: AOAM531HQWwsMGmTxDpv5PVINzamsiEGm4ijpTgRDoFV1+x3Lr3GXAtr
        pw0wFq78311oRb00E/T6E2inYzP2Tdmp
X-Google-Smtp-Source: ABdhPJzWAzu9OVUFxwRwXzu0nwufS/0UacK/dYlj/pcYUHlETMRaHkFvdxPLGJ4p+Q9uF4gGoYpj2A==
X-Received: by 2002:a17:902:8508:b029:d5:af79:8b40 with SMTP id bj8-20020a1709028508b02900d5af798b40mr9886951plb.28.1602957283250;
        Sat, 17 Oct 2020 10:54:43 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id b3sm6309041pfd.66.2020.10.17.10.54.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Oct 2020 10:54:42 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v4] KVM: Check the allocation of pv cpu mask
Date:   Sun, 18 Oct 2020 01:54:36 +0800
Message-Id: <20201017175436.17116-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

check the allocation of per-cpu __pv_cpu_mask. Init
'send_IPI_mask_allbutself' only when successful and check the allocation
of __pv_cpu_mask in 'kvm_flush_tlb_others'.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
v1 -> v2:
 * add CONFIG_SMP for kvm_send_ipi_mask_allbutself to prevent build error
v2 -> v3:
 * always check the allocation of __pv_cpu_mask in kvm_flush_tlb_others
v3 -> v4:
 * mov kvm_setup_pv_ipi to kvm_alloc_cpumask and get rid of kvm_apic_init

 arch/x86/kernel/kvm.c | 53 +++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 42c6e0deff9e..be28203cc098 100644
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
@@ -619,6 +609,11 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
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
@@ -732,10 +727,6 @@ static uint32_t __init kvm_detect(void)
 
 static void __init kvm_apic_init(void)
 {
-#if defined(CONFIG_SMP)
-	if (pv_ipi_supported())
-		kvm_setup_pv_ipi();
-#endif
 }
 
 static void __init kvm_init_platform(void)
@@ -765,10 +756,18 @@ static __init int activate_jump_labels(void)
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
+	bool alloc = false, alloced = true;
 
 	if (!kvm_para_available() || nopv)
 		return 0;
@@ -783,10 +782,30 @@ static __init int kvm_alloc_cpumask(void)
 
 	if (alloc)
 		for_each_possible_cpu(cpu) {
-			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
-				GFP_KERNEL, cpu_to_node(cpu));
+			if (!zalloc_cpumask_var_node(
+				per_cpu_ptr(&__pv_cpu_mask, cpu),
+				GFP_KERNEL, cpu_to_node(cpu))) {
+				alloced = false;
+				break;
+			}
 		}
 
+#if defined(CONFIG_SMP)
+	/* Set the IPI entry points */
+	if (pv_ipi_supported()) {
+		apic->send_IPI_mask = kvm_send_ipi_mask;
+		if (alloced)
+			apic->send_IPI_mask_allbutself =
+				kvm_send_ipi_mask_allbutself;
+		pr_info("setup PV IPIs\n");
+	}
+#endif
+
+	if (!alloced) {
+		kvm_free_cpumask();
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 arch_initcall(kvm_alloc_cpumask);
-- 
2.18.4

