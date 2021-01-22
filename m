Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B38630015C
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 12:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbhAVLV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 06:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727932AbhAVLUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 06:20:02 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73634C06174A;
        Fri, 22 Jan 2021 03:19:00 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id n25so3507577pgb.0;
        Fri, 22 Jan 2021 03:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JGKZWLmZIaXZ0doM/i8zUq2DXA6jM2XCESou+2RqdlA=;
        b=U9yV8Yulx/4LOhdsH7ynYOJKlnHwgwg2gMNl2QmmOTdT2tXgaaTXyhz8Tsml3tOEI5
         NqIdEY5+dNecnL9gupHRda8nYiv+OW4nvNKnLT6Dq+X3ZkLGC8/E+0VZYGhY1dbkhYEN
         VOsxBgysdG2KezeTn7tT6XkKT0lIR7UGv+iJaLJUzp0ndVsuKPFtp/5rucVWHFJIqMBG
         lCJZhDO2/4aGnckrimgPqZqRgz4+ApEwe+G0Pc/n+0YXPtsinnrnRi9iiummaI1pV/s1
         AUT0pvOzYe7nCUBVWVV9nBoPqpWoxqK0oZN3V53Nba+h/xg4a9H0inJ1LY1LNddb1SlQ
         HU7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JGKZWLmZIaXZ0doM/i8zUq2DXA6jM2XCESou+2RqdlA=;
        b=Uy+OiqCguEqGGA6OmoSPB8by08QGMss3ylT5bAEmJYUj5+5PT+WO6B/PUG8CYhaLtq
         //mtkyef0vAgCvd1Zh4798EYdIhGM2CjLu2iza0XxVpx221YGhw4oBftRRYp6YdPX/I7
         8kcUDNNPkkosKukmUEWG8bPssiF94GN2oX95eH2217E0RSc+nxJvZ7uTVTnlepPyMmZ5
         Z5MyEe7K+zLoV50PSh5JCDER6lC35wd9qEgaG+Xy2t6pNJ+8ZZRET8ZJGATbM1/5iSNb
         IH+0eq8ftEOKX5mWon6KMrg+Wt0YI15fY50f+HB4+5zerdoS8l+ZlrW4jB3RWCeEbFE1
         F0Pg==
X-Gm-Message-State: AOAM5320ebavQrORY7BrGU43Ohcat2DPslHBvV3GZXxWBL5E2StEoMbK
        +HRWPvDDAAY1J1Z6S1zIGaM=
X-Google-Smtp-Source: ABdhPJxt5WMLt8cj+0AiYX17C2BZ/R9+T6CBaCic2Kf+mk6e10AqboFT0NLkQr2VDIJKC+o4k9vfog==
X-Received: by 2002:a63:794a:: with SMTP id u71mr4170608pgc.91.1611314340094;
        Fri, 22 Jan 2021 03:19:00 -0800 (PST)
Received: from localhost.localdomain ([125.227.22.95])
        by smtp.gmail.com with ESMTPSA id b11sm9521965pjg.27.2021.01.22.03.18.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Jan 2021 03:18:59 -0800 (PST)
From:   Stephen Zhang <stephenzhangzsd@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Zhang <stephenzhangzsd@gmail.com>
Subject: [PATCH] KVM: x86/mmu: improve robustness of some functions
Date:   Fri, 22 Jan 2021 19:18:43 +0800
Message-Id: <1611314323-2770-1-git-send-email-stephenzhangzsd@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the name of this function changes, you can easily
forget to modify the code in the corresponding place.
In fact, such errors already exist in spte_write_protect
 and spte_clear_dirty.

Signed-off-by: Stephen Zhang <stephenzhangzsd@gmail.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481..09462c3d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -844,17 +844,17 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 	int i, count = 0;
 
 	if (!rmap_head->val) {
-		rmap_printk("pte_list_add: %p %llx 0->1\n", spte, *spte);
+		rmap_printk("%s: %p %llx 0->1\n", __func__, spte, *spte);
 		rmap_head->val = (unsigned long)spte;
 	} else if (!(rmap_head->val & 1)) {
-		rmap_printk("pte_list_add: %p %llx 1->many\n", spte, *spte);
+		rmap_printk("%s: %p %llx 1->many\n", __func__, spte, *spte);
 		desc = mmu_alloc_pte_list_desc(vcpu);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
 		rmap_head->val = (unsigned long)desc | 1;
 		++count;
 	} else {
-		rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
+		rmap_printk("%s: %p %llx many->many\n",	__func__, spte, *spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
 		while (desc->sptes[PTE_LIST_EXT-1]) {
 			count += PTE_LIST_EXT;
@@ -1115,7 +1115,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	      !(pt_protect && spte_can_locklessly_be_made_writable(spte)))
 		return false;
 
-	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
+	rmap_printk("%s: spte %p %llx\n", __func__, sptep, *sptep);
 
 	if (pt_protect)
 		spte &= ~SPTE_MMU_WRITEABLE;
@@ -1142,7 +1142,7 @@ static bool spte_clear_dirty(u64 *sptep)
 {
 	u64 spte = *sptep;
 
-	rmap_printk("rmap_clear_dirty: spte %p %llx\n", sptep, *sptep);
+	rmap_printk("%s: spte %p %llx\n", __func__, sptep, *sptep);
 
 	MMU_WARN_ON(!spte_ad_enabled(spte));
 	spte &= ~shadow_dirty_mask;
@@ -1184,7 +1184,7 @@ static bool spte_set_dirty(u64 *sptep)
 {
 	u64 spte = *sptep;
 
-	rmap_printk("rmap_set_dirty: spte %p %llx\n", sptep, *sptep);
+	rmap_printk("%s: spte %p %llx\n", __func__, sptep, *sptep);
 
 	/*
 	 * Similar to the !kvm_x86_ops.slot_disable_log_dirty case,
@@ -1363,8 +1363,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 restart:
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
-		rmap_printk("kvm_set_pte_rmapp: spte %p %llx gfn %llx (%d)\n",
-			    sptep, *sptep, gfn, level);
+		rmap_printk("%s: spte %p %llx gfn %llx (%d)\n",
+			      __func__, sptep, *sptep, gfn, level);
 
 		need_flush = 1;
 
-- 
1.8.3.1

