Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564B5279010
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 20:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbgIYSHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 14:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgIYSHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 14:07:55 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA1AC0613CE;
        Fri, 25 Sep 2020 11:07:55 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id x16so2465669pgj.3;
        Fri, 25 Sep 2020 11:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JsCppV/bmsXZUBRfSaY9SL27S9Ub2HG1i6C0hRa6EVE=;
        b=tZdsuSUsj0ng7HTsKzxvOHVBb5mFFSSEzLq0L+JGhTu918YqYGnycwGT26nyT7SiTj
         wM275tJEa40Upp3J35MGnNt1tpE6uev0CFw2oSdL3vJAHiTkgqKfNoPur1JQ+Pf+8B0z
         Y9igeHsm83sQuWywKLlC/VCKMi4ov7baF9YjQfmUclyLlZ9i6dWYTNrv4gWdCY7/pdhb
         dJ3WYvo8tbjydhobEbtVgFNVA5lWKW8YWRzXbKMgsJsJ8xWEXZiv3CH1+58/wHIa2ocz
         Sa8SjIv2Y4gmRrJPVbRqWQhi23rMDf9zHqBg7FhN46rFg8EHXqpwHLFnLxsGnOu9hlMv
         XMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JsCppV/bmsXZUBRfSaY9SL27S9Ub2HG1i6C0hRa6EVE=;
        b=gO73vZnWpyCweDNlUJeI1oxlC4q0mr0ppCjYI0qXmIBo8rINSvKwm2LYSrbQdcRqdN
         2gvWoauYXxH5oLS4SG0XWy1xQOEnc8o02KcKXYbTypXsU6kCMQCP1AQTtf5/m7QrRuIY
         pSYiMmSgfgajsD+0vBbu0M+Vs5jUPyG9SKVNVw/j4s5CxkxXSQ4R1K+WolEO71qs+21m
         QqLWW6LlIXNuR1gSZLahpSmjoIJ9vHyJB0rkg4golbCXsJ/241/37Ois4WFtnwraf+VD
         TCafPMllHm870XBHp6QR6/1qaBY6FBZFYvA7c3JcOjxrC5rlYfA4kpe0K7GEkzgbb9Uv
         jouA==
X-Gm-Message-State: AOAM531vxWyVl1+43CqpeqeZ3kCb0lQl4bbm+Ab7VQtLUGwjh0tFx0zs
        GMOX6LCHtdvAQA2dzTxTA3eYHiv0x5/V
X-Google-Smtp-Source: ABdhPJy1/0rKu+54wFhxJYw5dahCMg3cJvq7kuvb+TbDH6a/hXEP5JwMHA2BI2v7o2jCmtEpz5KiHg==
X-Received: by 2002:a63:5102:: with SMTP id f2mr151366pgb.15.1601057265909;
        Fri, 25 Sep 2020 11:07:45 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id ie13sm2700535pjb.5.2020.09.25.11.07.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Sep 2020 11:07:45 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v3] KVM: Check the allocation of pv cpu mask
Date:   Sat, 26 Sep 2020 02:07:38 +0800
Message-Id: <20200925180738.4426-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

check the allocation of per-cpu __pv_cpu_mask.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
v1 -> v2:
 * add CONFIG_SMP for kvm_send_ipi_mask_allbutself to prevent build error
v2 -> v3:
 * always check the allocation of __pv_cpu_mask in kvm_flush_tlb_others

 arch/x86/kernel/kvm.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 9663ba31347c..1e5da6db519c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -553,7 +553,6 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 static void kvm_setup_pv_ipi(void)
 {
 	apic->send_IPI_mask = kvm_send_ipi_mask;
-	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
 	pr_info("setup PV IPIs\n");
 }
 
@@ -619,6 +618,11 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
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
@@ -765,6 +769,14 @@ static __init int activate_jump_labels(void)
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
@@ -783,11 +795,20 @@ static __init int kvm_alloc_cpumask(void)
 
 	if (alloc)
 		for_each_possible_cpu(cpu) {
-			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
-				GFP_KERNEL, cpu_to_node(cpu));
+			if (!zalloc_cpumask_var_node(
+				per_cpu_ptr(&__pv_cpu_mask, cpu),
+				GFP_KERNEL, cpu_to_node(cpu)))
+				goto zalloc_cpumask_fail;
 		}
 
+#if defined(CONFIG_SMP)
+	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
+#endif
 	return 0;
+
+zalloc_cpumask_fail:
+	kvm_free_cpumask();
+	return -ENOMEM;
 }
 arch_initcall(kvm_alloc_cpumask);
 
-- 
2.18.4

