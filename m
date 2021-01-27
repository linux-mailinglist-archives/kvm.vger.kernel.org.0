Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D853050C6
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 05:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238615AbhA0E0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbhA0DC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 22:02:57 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000ACC061756;
        Tue, 26 Jan 2021 18:08:53 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id o20so208449pfu.0;
        Tue, 26 Jan 2021 18:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YpCzMfgjbd9EhyR5dL1N/GmWwAHrDvmZHlxmEq38Oio=;
        b=PquFxkORYMlu8/+sBKicjDpcfQEvqgovRJSipjrhZakbngIK1WnjR8VN7Hyf2KgRe5
         OlU8GPQdEqzr3x8dUH6zTNIcAwM1l7ek70K2amHW056j/xRJXgzfxXzfCPxbuht36MEZ
         1D5SaNnm3bpoL//sMa6+fG73hqFw0587W5sBAqSQPVtYWg0jIgB28oFh+4gaoWKcvEBG
         bQgVeKnRF3NqxdEWR0h0kHTtRlUfLyZZYAoItvki6VH9rulVIRJMh1t0IHzunbrg3zE6
         7cSzBH8DV6u8Rc/J0RvwnpLnlaVusd5UpUW25NI8AM9VkoBrejEZbjaHdsVo/9pqzCKS
         mpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YpCzMfgjbd9EhyR5dL1N/GmWwAHrDvmZHlxmEq38Oio=;
        b=EgsU9XBIfc02P4xSgiirZlWnd+ODZaPPoKpN52nK1q9DHVjQ9p4osfFc//4oxLPnBC
         z1za0VAW3v74oAMbpaqDEMk0brkYr8nMSpEyT06+zutuGIX4NtR4K2NuGW/9vXHSTYpk
         mgFvMb+3eK3emwRhQ7oy8c4C4PUBoLS5QGne5ksGI8K0dOwvBcppf8pxqfASKybG2+nb
         +vJsur8RBfgUAiLeLTCQ8LTBvWa2nW75m5k+Tb6Zume4MoGFVFbfveSUeqz7PZHINTxV
         jyiYuYLID0WolTPvZI2ytyiBbyIdXhEkw3jmMoX9KL0K1DdubHctJJLM72ijjXLwPCc2
         U3VQ==
X-Gm-Message-State: AOAM532zKTRP1OMTM2THqMQXEdwyzRw/liqNkK0whTuw6NadEX0GoNSl
        TapSY067eLvmaxNljum/APk=
X-Google-Smtp-Source: ABdhPJzZMbtBgsFuAqjEZrQ1KhRA+9m+cvy32JRIBPLkHUaC/9Q5HVWJNHTI0FfvCeG2BKmEP/vtBA==
X-Received: by 2002:a62:1ec1:0:b029:1a8:2c01:13c0 with SMTP id e184-20020a621ec10000b02901a82c0113c0mr8093132pfe.8.1611713333595;
        Tue, 26 Jan 2021 18:08:53 -0800 (PST)
Received: from localhost.localdomain ([125.227.22.95])
        by smtp.gmail.com with ESMTPSA id j6sm327359pfg.159.2021.01.26.18.08.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Jan 2021 18:08:53 -0800 (PST)
From:   Stephen Zhang <stephenzhangzsd@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Zhang <stephenzhangzsd@gmail.com>
Subject: [PATCH] KVM: x86/mmu: Add '__func__' in rmap_printk()
Date:   Wed, 27 Jan 2021 10:08:45 +0800
Message-Id: <1611713325-3591-1-git-send-email-stephenzhangzsd@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Given the common pattern:

rmap_printk("%s:"..., __func__,...)

we could improve this by adding '__func__' in rmap_printk().

Signed-off-by: Stephen Zhang <stephenzhangzsd@gmail.com>
---
 arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++----------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481..1460705 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -844,17 +844,17 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 	int i, count = 0;
 
 	if (!rmap_head->val) {
-		rmap_printk("pte_list_add: %p %llx 0->1\n", spte, *spte);
+		rmap_printk("%p %llx 0->1\n", spte, *spte);
 		rmap_head->val = (unsigned long)spte;
 	} else if (!(rmap_head->val & 1)) {
-		rmap_printk("pte_list_add: %p %llx 1->many\n", spte, *spte);
+		rmap_printk("%p %llx 1->many\n", spte, *spte);
 		desc = mmu_alloc_pte_list_desc(vcpu);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
 		rmap_head->val = (unsigned long)desc | 1;
 		++count;
 	} else {
-		rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
+		rmap_printk("%p %llx many->many\n", spte, *spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
 		while (desc->sptes[PTE_LIST_EXT-1]) {
 			count += PTE_LIST_EXT;
@@ -906,14 +906,14 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 		pr_err("%s: %p 0->BUG\n", __func__, spte);
 		BUG();
 	} else if (!(rmap_head->val & 1)) {
-		rmap_printk("%s:  %p 1->0\n", __func__, spte);
+		rmap_printk("%p 1->0\n", spte);
 		if ((u64 *)rmap_head->val != spte) {
 			pr_err("%s:  %p 1->BUG\n", __func__, spte);
 			BUG();
 		}
 		rmap_head->val = 0;
 	} else {
-		rmap_printk("%s:  %p many->many\n", __func__, spte);
+		rmap_printk("%p many->many\n", spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
 		prev_desc = NULL;
 		while (desc) {
@@ -1115,7 +1115,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	      !(pt_protect && spte_can_locklessly_be_made_writable(spte)))
 		return false;
 
-	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
+	rmap_printk("spte %p %llx\n", sptep, *sptep);
 
 	if (pt_protect)
 		spte &= ~SPTE_MMU_WRITEABLE;
@@ -1142,7 +1142,7 @@ static bool spte_clear_dirty(u64 *sptep)
 {
 	u64 spte = *sptep;
 
-	rmap_printk("rmap_clear_dirty: spte %p %llx\n", sptep, *sptep);
+	rmap_printk("spte %p %llx\n", sptep, *sptep);
 
 	MMU_WARN_ON(!spte_ad_enabled(spte));
 	spte &= ~shadow_dirty_mask;
@@ -1184,7 +1184,7 @@ static bool spte_set_dirty(u64 *sptep)
 {
 	u64 spte = *sptep;
 
-	rmap_printk("rmap_set_dirty: spte %p %llx\n", sptep, *sptep);
+	rmap_printk("spte %p %llx\n", sptep, *sptep);
 
 	/*
 	 * Similar to the !kvm_x86_ops.slot_disable_log_dirty case,
@@ -1331,7 +1331,7 @@ static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
 	bool flush = false;
 
 	while ((sptep = rmap_get_first(rmap_head, &iter))) {
-		rmap_printk("%s: spte %p %llx.\n", __func__, sptep, *sptep);
+		rmap_printk("spte %p %llx.\n", sptep, *sptep);
 
 		pte_list_remove(rmap_head, sptep);
 		flush = true;
@@ -1363,7 +1363,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 restart:
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
-		rmap_printk("kvm_set_pte_rmapp: spte %p %llx gfn %llx (%d)\n",
+		rmap_printk("spte %p %llx gfn %llx (%d)\n",
 			    sptep, *sptep, gfn, level);
 
 		need_flush = 1;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index bfc6389..5ec15e4 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -12,7 +12,7 @@
 extern bool dbg;
 
 #define pgprintk(x...) do { if (dbg) printk(x); } while (0)
-#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
+#define rmap_printk(fmt, args...) do { if (dbg) printk("%s: " fmt, __func__, ## args); } while (0)
 #define MMU_WARN_ON(x) WARN_ON(x)
 #else
 #define pgprintk(x...) do { } while (0)
-- 
1.8.3.1

