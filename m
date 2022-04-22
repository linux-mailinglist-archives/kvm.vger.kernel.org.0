Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C39C50B465
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 11:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445995AbiDVJvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 05:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387288AbiDVJvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 05:51:11 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6B6101DC;
        Fri, 22 Apr 2022 02:48:18 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c12so9710694plr.6;
        Fri, 22 Apr 2022 02:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=UgfEhZ8+0guBOJEB+LTVzDck5+orSXs7YLCmPKl/+a8=;
        b=MR2tzT3jkl8yDrm9X9xI11YMz7iWT4zt50glV/lxhyzah3WfjSHGC5ke9zLIxJ+qFh
         0IrbrndYo+hMgjE9wLqnkA19AjUavzncOZrLZ1MDYUFYr/u8f5k0TltsihjLQy5/FvOH
         USatLJhB+v1VPeTyG8FA8yI/YkhzGcwQ/eeZ9w3K4VSs0GUU/j11IV4+N3aK68ghCqih
         Cbrki7S95gAJcTDGY77CXw80U/wwiZXjQHSOCDij4ESZNyVYVrELaeAOuNr5qO1wWrO9
         53cPHcwwiL+aBu0pqWnO+US9pjJSmBdszFFH2gCeHvSba6u3QJKZ/UAs0ZPinayBMnfn
         DArw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UgfEhZ8+0guBOJEB+LTVzDck5+orSXs7YLCmPKl/+a8=;
        b=NHSldvw94UlK9auvjMX/duYrwy2USx1LSLBHbNR0tiNihRI2WDG6vNRaQ7z1BleL2L
         gx6yFiHGBB1nM9W8kbBNH5xrQL4UMMLY4WsBkXaV5zUsdzHAbx8LPqQPprb/RMWyq2aM
         6QgIIrEsJZQVOxg3n3m3ADGBGn9mBb2+Ynx6VRiNhouXtinbI0wFJ+wqdCYDIDrkzZM2
         +eCQMBMIW5IMdUWzwwyamZPOCrDRokS5coYU+HIqK1kNBaFP4zuyVxr3Z9HtMvK4wuM7
         mlcpSOBaELPpiJT5t0EvopmFWje0cRZbY/wmQzszDW/0KGPxLHv1EK+G9783+zAuNsqE
         UiKQ==
X-Gm-Message-State: AOAM533NApGYjlJh2kKWR2EKaADYpAsaNY6T0ZS/k5sfn9uwqTXnMDtJ
        wfeTVZ2FT9jZDpBCl/f8eRwFCPns7fc=
X-Google-Smtp-Source: ABdhPJwCDbYkZRgiIKnvoI0V+j2m8JLvkWAhPEkF5WV6KqGvx6NqAcj6S5MMCqEuDyoA3sQ+Yf2OUg==
X-Received: by 2002:a17:90b:1d0e:b0:1c9:b74e:494 with SMTP id on14-20020a17090b1d0e00b001c9b74e0494mr4362366pjb.238.1650620898216;
        Fri, 22 Apr 2022 02:48:18 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.googlemail.com with ESMTPSA id 80-20020a630453000000b003aa6779ff5asm1702172pge.16.2022.04.22.02.48.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Apr 2022 02:48:17 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] x86/kvm: handle the failure of __pv_cpu_mask allocation
Date:   Fri, 22 Apr 2022 02:47:26 -0700
Message-Id: <1650620846-12092-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Fallback to native ipis/tlb flush if fails to allocate __pv_cpu_mask.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kernel/kvm.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a22deb58f86d..29d79d760996 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -46,6 +46,7 @@
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
+static struct apic orig_apic;
 static int kvmapf = 1;
 
 static int __init parse_no_kvmapf(char *arg)
@@ -542,6 +543,11 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
 
 static void kvm_send_ipi_mask(const struct cpumask *mask, int vector)
 {
+	if (unlikely(!this_cpu_cpumask_var_ptr(__pv_cpu_mask))) {
+		orig_apic.send_IPI_mask(mask, vector);
+		return;
+	}
+
 	__send_ipi_mask(mask, vector);
 }
 
@@ -551,6 +557,11 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
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
@@ -611,6 +622,7 @@ late_initcall(setup_efi_kvm_sev_migration);
  */
 static void kvm_setup_pv_ipi(void)
 {
+	orig_apic = *apic;
 	apic->send_IPI_mask = kvm_send_ipi_mask;
 	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
 	pr_info("setup PV IPIs\n");
@@ -639,6 +651,11 @@ static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
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
@@ -671,11 +688,16 @@ static __init int kvm_alloc_cpumask(void)
 
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

