Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400A7653AAA
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 03:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbiLVCgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 21:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbiLVCfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 21:35:39 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AC726AC3
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:16 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id h6-20020a17090aa88600b00223fccff2efso2287575pjq.6
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b9yKHiaQzq9mZ3IJWGzrPWbD3+83EkY9xWMVBG05dNQ=;
        b=XlyER0aXwnjO8q6dTDihNfSIfjWn8dSVJ8IiBcSHE7yuANREvStJV3g9XDl8A/5Vwr
         OaNHoUYM9Z3wM78fZ/XqZqc2ZUebk2Up0L9xXgXL4U3gFGGz6w6NBfJtgfGPwYUC+B8s
         lG8Y2mimnBPeTLnpwg2Gmem25P6HBJfKl/2T+uaujz8TJVx2GozbpVFZB4OD+HpbyDdX
         FHdfVOyX6+BPp8Ht/TdNLUscgGNFc8b5S04IVXGZFWLXt3JasjvhdrpNTDIHgFTTxdhl
         C2eu1PX9i9Z3SW518upry6mS+ShsSl8pxZNEoSPq4X6DQp773Xn1V/u5SNKVXrbP8X0c
         vtUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b9yKHiaQzq9mZ3IJWGzrPWbD3+83EkY9xWMVBG05dNQ=;
        b=AEKmCBs7lgVoRLjj9MWbw7GwQYSJMRbxS0xh7Fl9xOxf822lAump3QQuwxhtl0s7zL
         ArjhziD6Et2udJNfO5TkIC0ljIN/2ZMAML5UBqk0OjltRandBPRLSozCnRdcoDrEQmiG
         16rfWVdf3g6S7Tz/03d/o7kbNQelGU1hEyYp7k32+exBcLHMmfLAWRkZHEArslcHydze
         uIUtQOjV3TFN8BbLlTfVqgcSX6GoN7u3hhxdXPuZsvu0YiSiSjHNyQHhPz7FwslWYFMv
         f7rhGWRAqsDxubRlDv6FRqMmeyyVkTxw2AF1DHfXMi7CQv0Y0RsdiVcv3jJSY09jAfWa
         7I5g==
X-Gm-Message-State: AFqh2kqJ2iHCmJpxIqyInq9airu8FSs0YY2XSc9I1hoEMXCSUQu2xwyF
        3u0oPcl6xIl8Fy9wJ9bB1OKM0noqM2lK
X-Google-Smtp-Source: AMrXdXuzNj9EuXh7z055yKJ7hUYnL0IVln/7MJaAb+bM/jJJ7BibhMJSEr7enuNFlr9FF9cWepYFeciD79VX
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90b:701:b0:219:1d0a:34a6 with SMTP id
 s1-20020a17090b070100b002191d0a34a6mr128835pjz.1.1671676515179; Wed, 21 Dec
 2022 18:35:15 -0800 (PST)
Date:   Wed, 21 Dec 2022 18:34:57 -0800
In-Reply-To: <20221222023457.1764-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221222023457.1764-10-vipinsh@google.com>
Subject: [Patch v3 9/9] KVM: x86/mmu: Reduce default cache size in KVM from 40
 to PT64_ROOT_MAX_LEVEL
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE is set to 40 without any specific
reason. Reduce default size to PT64_ROOT_MAX_LEVEL, which is currently
5.

Change mmu_pte_list_desc_cache size to what is needed as it is more than
5 but way less than 40.

Tested by running dirty_log_perf_test on both tdp and shadow MMU with 48
vcpu and 2GB/vcpu size on a 2 NUMA node machine. No impact on
performance noticed.

Ran perf on dirty_log_perf_test and found kvm_mmu_get_free_page() calls
reduced by ~3300 which is near to 48 (vcpus) * 2 (nodes) * 35 (cache
size).

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/kvm_types.h | 2 +-
 arch/x86/kvm/mmu/mmu.c           | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_types.h b/arch/x86/include/asm/kvm_types.h
index 08f1b57d3b62..752dab218a62 100644
--- a/arch/x86/include/asm/kvm_types.h
+++ b/arch/x86/include/asm/kvm_types.h
@@ -2,6 +2,6 @@
 #ifndef _ASM_X86_KVM_TYPES_H
 #define _ASM_X86_KVM_TYPES_H
 
-#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
+#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE PT64_ROOT_MAX_LEVEL
 
 #endif /* _ASM_X86_KVM_TYPES_H */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7454bfc49a51..f89d933ff380 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -677,11 +677,12 @@ static int mmu_topup_sp_memory_cache(struct kvm_mmu_memory_cache *cache,
 
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
-	int r, nid;
+	int r, nid, desc_capacity;
 
 	/* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
-	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
-				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
+	desc_capacity = 1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM;
+	r = __kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
+					 desc_capacity, desc_capacity);
 	if (r)
 		return r;
 
-- 
2.39.0.314.g84b9a713c41-goog

