Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6919954BE52
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344811AbiFNXdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 19:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244176AbiFNXdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 19:33:41 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A294C7BA
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:40 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id oa9-20020a17090b1bc900b001e67bbd7f83so272400pjb.4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JiPXDiTrnxJesjnU/3429H2xKqABe3gzeHKYz405h8s=;
        b=JdZz7/xuwZ0XLM7kEyzmB5EuaV/oBzZYJK2OGUjB5zJSReAs221r7p52onvdt0Dq+F
         1O6NE0OJHSXdiyhkRtGqY73yTVzNm/nXKf0h/JbZSYOjTMymVt6nK31Fr8Us3PtMXtQG
         ndS+Yq4owTDwH/n5bH1Mtpiwqt1iw5EKf5zd0D1ZIb+mgdonTfTZAwKY79LjnlQ3raW6
         sojNCDikMBZcQqy8J65li1ba9Mlp1dzC8W8dYSbwrKHaBdE2I+GKx1BWo5YkjrqrwJGA
         kdOY8Na7n4CPKH8IR0L7Gv5GwbrYfKmAo9gAi75CUz0Mbg2rlFv38ufxNUl+mWCjy93Z
         eJ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JiPXDiTrnxJesjnU/3429H2xKqABe3gzeHKYz405h8s=;
        b=fHVIpXsGF2cwkZrdAsk6uQVMKBgqBSdCzM6us+b8LeNvLeeM8rDzXTxpsb10/pL2Mb
         9er1ot7b4ySA/FamuiDMbearnqZG4mmp6cC7X0AGZIv5Q455+5sBT/L2ljz/f2PwDKFq
         3sZRk4rm/nWVw05g8OwCIOkkE4dkwMaypyoSl9pEEtr8dg3T4ZQ/fEbVq6Mp04om5Bze
         poI8wwmGzFDVlRzzovz42tDPF2JcyeaXreQ++DlbsroZKT2TdTTgHf1hCstCfKs/DSt1
         QZ1bllj1MNwgANlrzKluXISIvgN49GEiQiLbN7m5Qm9LRI9T6hPkmaCUXYRGgu90Tq83
         pHkQ==
X-Gm-Message-State: AOAM531vtGz8kPkUeDiYtQf92pPlMDOvsZsm214qSn353Ay2vPeFnSK9
        7K4Vp3fel3bgmbn9Ezl4jopEgHZWDc8=
X-Google-Smtp-Source: ABdhPJz3jNQ6xW3aP14T9TnZrwHvAwIwmkxWFzObT+5J6NN/FftmtSAr61tJ1CtrBBYaMEvTrF5yS5+NbsQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:996:b0:505:b6d2:abc8 with SMTP id
 u22-20020a056a00099600b00505b6d2abc8mr7059915pfg.11.1655249620070; Tue, 14
 Jun 2022 16:33:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 23:33:23 +0000
In-Reply-To: <20220614233328.3896033-1-seanjc@google.com>
Message-Id: <20220614233328.3896033-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220614233328.3896033-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 3/8] KVM: x86/mmu: Bury 32-bit PSE paging helpers in paging_tmpl.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move a handful of one-off macros and helpers for 32-bit PSE paging into
paging_tmpl.h and hide them behind "PTTYPE == 32".  Under no circumstance
should anything but 32-bit shadow paging care about PSE paging.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h             |  5 -----
 arch/x86/kvm/mmu/mmu.c         |  7 -------
 arch/x86/kvm/mmu/paging_tmpl.h | 18 +++++++++++++++++-
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index f8192864b496..d1021e34ac15 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -34,11 +34,6 @@
 #define PT_DIR_PAT_SHIFT 12
 #define PT_DIR_PAT_MASK (1ULL << PT_DIR_PAT_SHIFT)
 
-#define PT32_DIR_PSE36_SIZE 4
-#define PT32_DIR_PSE36_SHIFT 13
-#define PT32_DIR_PSE36_MASK \
-	(((1ULL << PT32_DIR_PSE36_SIZE) - 1) << PT32_DIR_PSE36_SHIFT)
-
 #define PT64_ROOT_5LEVEL 5
 #define PT64_ROOT_4LEVEL 4
 #define PT32_ROOT_LEVEL 2
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f168693695bd..73497da1a99b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -324,13 +324,6 @@ static int is_cpuid_PSE36(void)
 	return 1;
 }
 
-static gfn_t pse36_gfn_delta(u32 gpte)
-{
-	int shift = 32 - PT32_DIR_PSE36_SHIFT - PAGE_SHIFT;
-
-	return (gpte & PT32_DIR_PSE36_MASK) << shift;
-}
-
 #ifdef CONFIG_X86_64
 static void __set_spte(u64 *sptep, u64 spte)
 {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f595c4b8657f..55fd35b1b227 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -50,6 +50,11 @@
 	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
 	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
+
+	#define PT32_DIR_PSE36_SIZE 4
+	#define PT32_DIR_PSE36_SHIFT 13
+	#define PT32_DIR_PSE36_MASK \
+		(((1ULL << PT32_DIR_PSE36_SIZE) - 1) << PT32_DIR_PSE36_SHIFT)
 #elif PTTYPE == PTTYPE_EPT
 	#define pt_element_t u64
 	#define guest_walker guest_walkerEPT
@@ -92,6 +97,15 @@ struct guest_walker {
 	struct x86_exception fault;
 };
 
+#if PTTYPE == 32
+static inline gfn_t pse36_gfn_delta(u32 gpte)
+{
+	int shift = 32 - PT32_DIR_PSE36_SHIFT - PAGE_SHIFT;
+
+	return (gpte & PT32_DIR_PSE36_MASK) << shift;
+}
+#endif
+
 static gfn_t gpte_to_gfn_lvl(pt_element_t gpte, int lvl)
 {
 	return (gpte & PT_LVL_ADDR_MASK(lvl)) >> PAGE_SHIFT;
@@ -416,8 +430,10 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	gfn = gpte_to_gfn_lvl(pte, walker->level);
 	gfn += (addr & PT_LVL_OFFSET_MASK(walker->level)) >> PAGE_SHIFT;
 
-	if (PTTYPE == 32 && walker->level > PG_LEVEL_4K && is_cpuid_PSE36())
+#if PTTYPE == 32
+	if (walker->level > PG_LEVEL_4K && is_cpuid_PSE36())
 		gfn += pse36_gfn_delta(pte);
+#endif
 
 	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(gfn), access, &walker->fault);
 	if (real_gpa == UNMAPPED_GVA)
-- 
2.36.1.476.g0c4daa206d-goog

