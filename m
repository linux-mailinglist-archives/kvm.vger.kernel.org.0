Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA705229F0
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 04:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiEKCrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 22:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243072AbiEKCjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 22:39:25 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2532D20F4C4;
        Tue, 10 May 2022 19:39:24 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id e24so939697pjt.2;
        Tue, 10 May 2022 19:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9kjW2+BUaG5dAg75KTS2BoQJOyztH7zdTTB6sE8wkvg=;
        b=e2RpEO+Xb16iJPf82bSyFSpgb5tCllYsjaWUlqEGAyfYnwxN+CVVQGcWMfEZgeE26e
         mxQMKFb7e+m2Oa/H5PtSAVUqygiW7sx8bu4AylbOlYMVpIlL6NrlTXPmDmnMxBvouWoF
         P3rkbWtKb1JtuHSi0a3cQe40GXEQqhGXhf7riIO4CDSt1GIYkS43manuSiX63yZCG3Ia
         8venfR0zWEQ7A5KsIaFc4U6M+T8zwdqCVLLeUuOGVMKyTpKE3iT9aUzyvJbZln2EHMEK
         4h/p1K33Ifpb9EbrJiqETTNp4CqcqfJ5cQL0kFTKYhKg8xa/EHA81tE9xZwipRWf97WW
         yNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9kjW2+BUaG5dAg75KTS2BoQJOyztH7zdTTB6sE8wkvg=;
        b=lM/Dykjt64anyHxaXpdlgW4hFOmIdV1OFFEYlnmAUMtvWcbPo1vvQor93Ut2A0M21X
         EmQwGKM9BXcCuFZT0p0hiFQBzBzG6ZVkKISsk40WgEFqTgYMH0KF+6CWMcFaeYrRxBGu
         D4RNvyv2HUBIt5JCaqCfv/ee3PNvhaznoErEYcWBvFUtcLI3Upyi1aZf8KmNrztoaG8w
         FVrRZyvj0XyKDG/27joueqR0qp016KybPcqkCkWJxhM66+eV1x5zWHpB9yHVUaBCLraa
         YY8v50qt6TtPu2OBtJSmRXuIsUm59KSItN8sJmiRPswEeo53YSSyNrNUB5jNT5m8rO8O
         o2WA==
X-Gm-Message-State: AOAM530fUjRfKoZiWqnJNMk02+F501RJght3/cakLo7pS+nEODQWIjSq
        vBUEz1oQmAGEwRlyWrtIkVcOH0wiFpk=
X-Google-Smtp-Source: ABdhPJzXfRKcIKSYQxNUXDidC6u9nRCrN+fGn47n/Q+lLQ+Y3tiaUSsBNzuhz3575/vCBC3yYhkF5Q==
X-Received: by 2002:a17:902:ee93:b0:15f:186a:6a13 with SMTP id a19-20020a170902ee9300b0015f186a6a13mr9959166pld.7.1652236763422;
        Tue, 10 May 2022 19:39:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.googlemail.com with ESMTPSA id j64-20020a638b43000000b003c659b92b8fsm425610pge.32.2022.05.10.19.39.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 19:39:23 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/2] x86/kvm: handle the failure of __pv_cpu_mask allocation
Date:   Tue, 10 May 2022 19:38:30 -0700
Message-Id: <1652236710-36524-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1652236710-36524-1-git-send-email-wanpengli@tencent.com>
References: <1652236710-36524-1-git-send-email-wanpengli@tencent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Fallback to native ipis/tlb flush if fails to allocate __pv_cpu_mask.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * move orig_apic under CONFIG_SMP

 arch/x86/kernel/kvm.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8b1c45c9cda8..ce03121d038b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -457,6 +457,7 @@ static int kvm_cpu_online(unsigned int cpu)
 
 #ifdef CONFIG_SMP
 
+static struct apic orig_apic;
 static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
 
 static bool pv_tlb_flush_supported(void)
@@ -543,6 +544,11 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
 
 static void kvm_send_ipi_mask(const struct cpumask *mask, int vector)
 {
+	if (unlikely(!this_cpu_cpumask_var_ptr(__pv_cpu_mask))) {
+		orig_apic.send_IPI_mask(mask, vector);
+		return;
+	}
+
 	__send_ipi_mask(mask, vector);
 }
 
@@ -552,6 +558,11 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 	struct cpumask *new_mask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
 	const struct cpumask *local_mask;
 
+	if (unlikely(!new_mask)) {
+		orig_apic.send_IPI_mask_allbutself(mask, vector);
+		return;
+	}
+
 	cpumask_copy(new_mask, mask);
 	cpumask_clear_cpu(this_cpu, new_mask);
 	local_mask = new_mask;
@@ -612,6 +623,7 @@ late_initcall(setup_efi_kvm_sev_migration);
  */
 static void kvm_setup_pv_ipi(void)
 {
+	orig_apic = *apic;
 	apic->send_IPI_mask = kvm_send_ipi_mask;
 	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
 	pr_info("setup PV IPIs\n");
@@ -640,6 +652,11 @@ static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
 	struct kvm_steal_time *src;
 	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
 
+	if (unlikely(!flushmask)) {
+		native_flush_tlb_multi(cpumask, info);
+		return;
+	}
+
 	cpumask_copy(flushmask, cpumask);
 	/*
 	 * We have to call flush only on online vCPUs. And
@@ -672,11 +689,16 @@ static __init int kvm_alloc_cpumask(void)
 
 	if (pv_tlb_flush_supported() || pv_ipi_supported())
 		for_each_possible_cpu(cpu) {
-			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
-				GFP_KERNEL, cpu_to_node(cpu));
+			if (!zalloc_cpumask_var_node(&per_cpu(__pv_cpu_mask, cpu),
+				GFP_KERNEL, cpu_to_node(cpu)))
+				goto err_out;
 		}
 
 	return 0;
+err_out:
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
+	return -ENOMEM;
 }
 arch_initcall(kvm_alloc_cpumask);
 
-- 
2.25.1

