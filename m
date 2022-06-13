Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8D654A265
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 01:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244424AbiFMW6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 18:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbiFMW5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 18:57:36 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D9BF46
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:31 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id n8-20020a635908000000b00401a7b6235bso4023579pgb.5
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=v4qCXjacc6DdzOgMgc8SdnwLNJ9D7HWzM5sk7a+r0QU=;
        b=tKbylohEMB3Jl6tpTMwQ6d8evAHk5Dz/0QN9wd9DmbHW4KeZ6M8jdnKU50lHcBNgDO
         z2GGrj64iIF78JHH1W4PJGeb1jnfnzpCv077HHYlpbJAxdUslC67ezPo0J76TrNk5NNA
         St3KeWrfmvgSpjMUGHivfOtU2H8Yjn53K//iZgUMaBp5OmnIZKbnZUzZccXhoWAN8GPq
         +XQsqANyvpke9U67fkPrTV+aRULg1yZHcHjcQKdzWNqcdQek4u+1yxVBqk98rx73dbYq
         0x3oL4RGTiUCD6foo02yQOQqggQXNuhl4KfdidThn7+p6PBv/T5/pRZa0GHDO396q7j1
         S3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=v4qCXjacc6DdzOgMgc8SdnwLNJ9D7HWzM5sk7a+r0QU=;
        b=UqbBL5IiArfpQL8Ug/Av+abJqhHCpp1DYp7nzIieX3rhjDEi5LQeWneyJ8XzIOC/xd
         4O0MWJHuLE0g9BzqWxyAETajyFCLAkTomV5wku1k/33cFkzi4qgbbm938d01/vJqChpb
         ijSEAfDYPp7Dj1FYmIMxdMj9Kg/ziHcr22fbNhxgJR2/ACcetF5SU8522q+m5TGRXphQ
         YbtLTOm6UFruishWPDuS3QbN1YwGTxFkkQiagHsUU9HtE5iXhSAZR4ZQS92R+4tCM025
         aB/wIhRcWaNO8QDhTSoeRt3QEKNY0mokUSbXJ6MpYaq9/2rWK6JNcMOdgla8RossFajV
         Nx9Q==
X-Gm-Message-State: AOAM532GCE/qfY8kPJyz7htzJYXZFDn916Sl3LlIgn6eh/fGxAEVEbWk
        lqGFJ2qU9ovwFQ9j9gAw6kbIMketALM=
X-Google-Smtp-Source: ABdhPJzmxrTOiQI7sxpaSIbvdsIoS7RfkibMVQwFP2P08oMwufrTOwRKrpZkn+gUpDEhaIBvYQ0wu2dxWCc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:164c:b0:50a:472a:6b0a with SMTP id
 m12-20020a056a00164c00b0050a472a6b0amr1466395pfc.77.1655161051343; Mon, 13
 Jun 2022 15:57:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 22:57:18 +0000
In-Reply-To: <20220613225723.2734132-1-seanjc@google.com>
Message-Id: <20220613225723.2734132-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220613225723.2734132-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 3/8] KVM: x86/mmu: Bury 32-bit PSE paging helpers in paging_tmpl.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
 arch/x86/kvm/mmu/mmu.c         | 12 ------------
 arch/x86/kvm/mmu/paging_tmpl.h | 19 ++++++++++++++++++-
 3 files changed, 18 insertions(+), 18 deletions(-)

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
index 17252f39bd7c..f1961fe3fe67 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -321,18 +321,6 @@ static bool check_mmio_spte(struct kvm_vcpu *vcpu, u64 spte)
 	return likely(kvm_gen == spte_gen);
 }
 
-static int is_cpuid_PSE36(void)
-{
-	return 1;
-}
-
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
index f595c4b8657f..ef02e6bb0bcb 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -50,6 +50,12 @@
 	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
 	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
+
+	#define is_cpuid_PSE36() true
+	#define PT32_DIR_PSE36_SIZE 4
+	#define PT32_DIR_PSE36_SHIFT 13
+	#define PT32_DIR_PSE36_MASK \
+		(((1ULL << PT32_DIR_PSE36_SIZE) - 1) << PT32_DIR_PSE36_SHIFT)
 #elif PTTYPE == PTTYPE_EPT
 	#define pt_element_t u64
 	#define guest_walker guest_walkerEPT
@@ -92,6 +98,15 @@ struct guest_walker {
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
@@ -416,8 +431,10 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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

