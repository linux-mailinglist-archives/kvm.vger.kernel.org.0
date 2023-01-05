Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B00465E887
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 11:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjAEKCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 05:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjAEKC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 05:02:28 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74692559F3;
        Thu,  5 Jan 2023 02:00:51 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so1527844pjj.4;
        Thu, 05 Jan 2023 02:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M+2IhZIBR+Idxq3vIqRuDT4ymQmEMRboW9fuQZxNIh8=;
        b=Ww/NBISVOlI36DZ7kwZz6fjIEw4Anyt3l8HPqf2WYWvnvowi1N9aQrBXlZkpmWl90H
         Zbn5iqvCzbBh9dfNNZuyGTx/UF4nhCZdB78ONiG6M75lTjOVxBJ1GJd0gL+2S5dSP61V
         Rdc/gknT3XiVz4GsQ8AKkI93qbPoU6GQQkfhcmWv2Aojp2U9/KcCQu8js2YGfeQEcZnp
         tqyVW1ZcNUKTi6CpWMD0vbrAGZWduff1E6QtYj+pzURiaKtOhnleNbpcSLMn8m/fRtBI
         WxlK2kFX9MhawoNPl/PaiN1FJmw7zuL5uPSU6oXWOfFXGr0nu9AyfVFmCVRKsMsYrchs
         GhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M+2IhZIBR+Idxq3vIqRuDT4ymQmEMRboW9fuQZxNIh8=;
        b=auFKnn3TPn8sy5oaOf55MsRU/mHuK2q85kYEDqRsccSuVQCJaAN67whYVS1pr1yOmz
         bFLoyoUKUDlm5Ty2W8GGFpaVG4Poj6zZkFDWpBWUmvhpjZbjaQm18VdTKu8Rt4ttqVtN
         jIl1dTIg5xQeUZT+0mg1nomorR+G12DczMBBuzQFwygRqRWwuYa7O30Y73o2vL3/uZ3L
         NJkR515lQrm79tPUHuTS0WHUKh6Ok2JTrHZkbkIY52Rsx1mkUK4p63go+osdv/O6v3Kf
         brE/NT1OPZR1Qzqo7JG7t1ak6cewpCY17qoe9WgQ9bCD7kcbAj3ADXcDX7izCVB2amkQ
         QoVA==
X-Gm-Message-State: AFqh2krfhHClfoYMQLaFHUgNoBnEqQ99KieOKTnQ9e+PbzadeTyi6gWy
        8d+rorLVFx4LlNgtmyaG8dPZp+XaxJM=
X-Google-Smtp-Source: AMrXdXuQhMR7Eq5Mvi6U/P387guWHU6F2ykmQzDHk4WUlQxFqBwwpQ874h/T5S7KJ8ZuYYr43wMS6Q==
X-Received: by 2002:a17:90b:2314:b0:225:c2b4:8458 with SMTP id mt20-20020a17090b231400b00225c2b48458mr44757064pjb.21.1672912850281;
        Thu, 05 Jan 2023 02:00:50 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id ge3-20020a17090b0e0300b00218cd71781csm1005525pjb.51.2023.01.05.02.00.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jan 2023 02:00:49 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH] kvm: x86/mmu: Rename SPTE_TDP_AD_ENABLED_MASK to SPTE_TDP_AD_ENABLED
Date:   Thu,  5 Jan 2023 18:02:03 +0800
Message-Id: <20230105100204.6521-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

SPTE_TDP_AD_ENABLED_MASK, SPTE_TDP_AD_DISABLED_MASK and
SPTE_TDP_AD_WRPROT_ONLY_MASK are actual value, not mask.

Remove "MASK" from their names.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/spte.c |  6 +++---
 arch/x86/kvm/mmu/spte.h | 16 ++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index fce6f047399f..c15bfca3ed15 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -147,9 +147,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	WARN_ON_ONCE(!pte_access && !shadow_present_mask);
 
 	if (sp->role.ad_disabled)
-		spte |= SPTE_TDP_AD_DISABLED_MASK;
+		spte |= SPTE_TDP_AD_DISABLED;
 	else if (kvm_mmu_page_ad_need_write_protect(sp))
-		spte |= SPTE_TDP_AD_WRPROT_ONLY_MASK;
+		spte |= SPTE_TDP_AD_WRPROT_ONLY;
 
 	/*
 	 * For the EPT case, shadow_present_mask is 0 if hardware
@@ -317,7 +317,7 @@ u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 		shadow_user_mask | shadow_x_mask | shadow_me_value;
 
 	if (ad_disabled)
-		spte |= SPTE_TDP_AD_DISABLED_MASK;
+		spte |= SPTE_TDP_AD_DISABLED;
 	else
 		spte |= shadow_accessed_mask;
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 0d8deefee66c..1279db2eab44 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -28,10 +28,10 @@
  */
 #define SPTE_TDP_AD_SHIFT		52
 #define SPTE_TDP_AD_MASK		(3ULL << SPTE_TDP_AD_SHIFT)
-#define SPTE_TDP_AD_ENABLED_MASK	(0ULL << SPTE_TDP_AD_SHIFT)
-#define SPTE_TDP_AD_DISABLED_MASK	(1ULL << SPTE_TDP_AD_SHIFT)
-#define SPTE_TDP_AD_WRPROT_ONLY_MASK	(2ULL << SPTE_TDP_AD_SHIFT)
-static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
+#define SPTE_TDP_AD_ENABLED		(0ULL << SPTE_TDP_AD_SHIFT)
+#define SPTE_TDP_AD_DISABLED		(1ULL << SPTE_TDP_AD_SHIFT)
+#define SPTE_TDP_AD_WRPROT_ONLY		(2ULL << SPTE_TDP_AD_SHIFT)
+static_assert(SPTE_TDP_AD_ENABLED == 0);
 
 #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
 #define SPTE_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
@@ -164,7 +164,7 @@ extern u64 __read_mostly shadow_me_value;
 extern u64 __read_mostly shadow_me_mask;
 
 /*
- * SPTEs in MMUs without A/D bits are marked with SPTE_TDP_AD_DISABLED_MASK;
+ * SPTEs in MMUs without A/D bits are marked with SPTE_TDP_AD_DISABLED;
  * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
  * pages.
  */
@@ -266,18 +266,18 @@ static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 static inline bool spte_ad_enabled(u64 spte)
 {
 	MMU_WARN_ON(!is_shadow_present_pte(spte));
-	return (spte & SPTE_TDP_AD_MASK) != SPTE_TDP_AD_DISABLED_MASK;
+	return (spte & SPTE_TDP_AD_MASK) != SPTE_TDP_AD_DISABLED;
 }
 
 static inline bool spte_ad_need_write_protect(u64 spte)
 {
 	MMU_WARN_ON(!is_shadow_present_pte(spte));
 	/*
-	 * This is benign for non-TDP SPTEs as SPTE_TDP_AD_ENABLED_MASK is '0',
+	 * This is benign for non-TDP SPTEs as SPTE_TDP_AD_ENABLED is '0',
 	 * and non-TDP SPTEs will never set these bits.  Optimize for 64-bit
 	 * TDP and do the A/D type check unconditionally.
 	 */
-	return (spte & SPTE_TDP_AD_MASK) != SPTE_TDP_AD_ENABLED_MASK;
+	return (spte & SPTE_TDP_AD_MASK) != SPTE_TDP_AD_ENABLED;
 }
 
 static inline u64 spte_shadow_accessed_mask(u64 spte)
-- 
2.19.1.6.gb485710b

