Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EA6613CC7
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiJaSBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJaSBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:01:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C29213D6A
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:00:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 204-20020a2510d5000000b006be7970889cso11046892ybq.21
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3fJGVLvuux7ZjXhWn/U9v5+1PBfr8qV0mPVrMinacoE=;
        b=QsGsn2644Bp5TjLD8vDYbI7iPVlGktd20e/ImVP6YpUYAD6GrGDr0W0vYX4aitUEfp
         lsmQTSa59i5E5w2vT28Qn+F8+PruqdVPa3mLgDvP0XEublpTu7Yx3Y65mC5EQahFUvhV
         RumQqIaYBcDF3gf1OZ1fZQOO8yyuJ5XGsUJ7rqDLusrvRNeSXNUW+pwtJxOVItDWZail
         Vv8VzpCo93yKZ6yrC89Lh5bzS9BIh2+qHneRJkIFsWbdpzgcxdzx5g363UqQUADOPxRz
         zKwO4Zj9g7kenE/wnUYq0i8ua/hgLAXMBhuIrNJ1dnMg495SoIv/1ii9OQNmjMpmo2PN
         bvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3fJGVLvuux7ZjXhWn/U9v5+1PBfr8qV0mPVrMinacoE=;
        b=jaClFOcVE66nXuldU/6RQ0vYrpZb/EOhLqNAsXhuCA+fhLdURGpEo3gVkZJfBc+1FR
         GazbAHUJ4jDgc3MZ8MGZOfRL2WJ39vJIaDVzyixc0Y67Dx22mpri83EbE9Hm2Ni4A1bS
         SYK9KmD8O2MuFmCZ635etYpLcqZld5yvzai+utr1LAxqdFYzAXZK8XgQ/A3Q9bLlcizd
         TfLM4abJ2OAAGwsAJXXY9sk14vfBPwOUMghNYNseeW58ST+PoCRnTFjB9cdIfdwrGZWN
         mfN5x3P6znPqG2nlgkOtLXgFRxDedFvLxQVoGfDCPI5px35jAU8psFwtErQ65mCEDoEH
         cbKA==
X-Gm-Message-State: ACrzQf0v4tUqJq1c+m/VR67ugkNrr29O7B5UdepdDEw8v1Q0gxPKP8P3
        FeZAlAtUeNxWhrK4S5mnL/MMLKtKSX4zrg==
X-Google-Smtp-Source: AMsMyM65v90lchpLHHoOfhHMNUr/rETHiYez1WVC2eisRS+eVtshyGyjiSpooY8nzoEvtUA5lxdiFlz9Djdc4g==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:1367:b0:6ca:517b:700b with SMTP
 id bt7-20020a056902136700b006ca517b700bmr4ybb.49.1667239258715; Mon, 31 Oct
 2022 11:00:58 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:00:40 -0700
In-Reply-To: <20221031180045.3581757-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221031180045.3581757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031180045.3581757-6-dmatlack@google.com>
Subject: [PATCH v3 05/10] KVM: x86/mmu: Use BIT{,_ULL}() for PFERR masks
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the preferred BIT() and BIT_ULL() to construct the PFERR masks
rather than open-coding the bit shifting.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 415113dea951..716f165cfa10 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -256,16 +256,16 @@ enum x86_intercept_stage;
 #define PFERR_GUEST_PAGE_BIT 33
 #define PFERR_IMPLICIT_ACCESS_BIT 48
 
-#define PFERR_PRESENT_MASK (1U << PFERR_PRESENT_BIT)
-#define PFERR_WRITE_MASK (1U << PFERR_WRITE_BIT)
-#define PFERR_USER_MASK (1U << PFERR_USER_BIT)
-#define PFERR_RSVD_MASK (1U << PFERR_RSVD_BIT)
-#define PFERR_FETCH_MASK (1U << PFERR_FETCH_BIT)
-#define PFERR_PK_MASK (1U << PFERR_PK_BIT)
-#define PFERR_SGX_MASK (1U << PFERR_SGX_BIT)
-#define PFERR_GUEST_FINAL_MASK (1ULL << PFERR_GUEST_FINAL_BIT)
-#define PFERR_GUEST_PAGE_MASK (1ULL << PFERR_GUEST_PAGE_BIT)
-#define PFERR_IMPLICIT_ACCESS (1ULL << PFERR_IMPLICIT_ACCESS_BIT)
+#define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
+#define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
+#define PFERR_USER_MASK		BIT(PFERR_USER_BIT)
+#define PFERR_RSVD_MASK		BIT(PFERR_RSVD_BIT)
+#define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
+#define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
+#define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
+#define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
+#define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
+#define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
-- 
2.38.1.273.g43a17bfeac-goog

