Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683E64559C4
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343848AbhKRLOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343781AbhKRLMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:12:44 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4DDC061224;
        Thu, 18 Nov 2021 03:08:52 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id i12so5620559pfd.6;
        Thu, 18 Nov 2021 03:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ISbDnAZvCkNnZWiq8wIewWzuFvAywFkypxPVxiTn/no=;
        b=fDk3vkgnsu9ix+Uq/GpfSjAaUah/0sJLYC6VSPogC3NB0IzF6jCVq88murhVg7bGQE
         Kc2iHsg++txtFkCUiyNpP2OkF3YDr6hGnSSxP7p4Yuui5oPUwzLbIxerPvaoneAvLClt
         029owMEhEwki8Kn7JzuiSKAiSHF5+uueIwlS6D4ynRgSDrbE6M/VR7CLKkdTWgAdzGwk
         sKfl9yUkpPUCPobdAOX5bEgDpGf4byWAII0981YW/NgJqMv4QsYB3GDSfHTM1/df8lYJ
         428lZKssJ5ur3zRfuP8hXq3AjW9dW7Y2CQRnl4COV70L9/wApLp7AMyJRqZ5glB5XR4G
         8LqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ISbDnAZvCkNnZWiq8wIewWzuFvAywFkypxPVxiTn/no=;
        b=qQTEpToz4IHx5fVtw1s8Xx95yYQsQQPkr2YIiAIClZcz2z4nkeMrHn9aKSld2gjdoJ
         YKpkBJXwbYvqkj9KXQn+MnOPQDyp5D5vDT3hCRicq3DT415VLdl1h1ZrZ7Rtlt4gFk/y
         Ks/9KJO58a1Tgq2Nc5JXLMflHVCaJP82axQaLnBlDZ8l3pxq3Ge+rsuj7BU5hlukgond
         CBPWreNGLx4PnqDqgklcvISJm0AyT7qfswShZbwu35wTRg5ogjgWYYhul2VeaeQXWMRQ
         tIlIl8uv3S3KO/22Lf9NqjVHMBK6Uukh+pAgupwzVzTYaglgpKHg8gtBZnwtwmlJ7fwm
         SGLw==
X-Gm-Message-State: AOAM533uZQuBd5HN7XVxhOcDSB8zz8HCQsrSr+xLstiDEa9Xesbvbc8G
        Pqooh/XvV/mMO2z3Bf+VeCaU8p1p/UQ=
X-Google-Smtp-Source: ABdhPJwtgAUJ8m882oG9AhS6YDRSLpX01XVkzwMuyNN2UhUdK4Lwij+vxgol7sq1FAVxN17bzXP/+g==
X-Received: by 2002:a05:6a00:24cd:b0:49f:a4d8:3d43 with SMTP id d13-20020a056a0024cd00b0049fa4d83d43mr14300238pfv.49.1637233732315;
        Thu, 18 Nov 2021 03:08:52 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id u32sm3152846pfg.220.2021.11.18.03.08.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:08:52 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 08/15] KVM: SVM: Rename get_max_npt_level() to get_npt_level()
Date:   Thu, 18 Nov 2021 19:08:07 +0800
Message-Id: <20211118110814.2568-9-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

It returns the only proper NPT level, so the "max" in the name
is not appropriate.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/svm/svm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 943da8a7d850..33b434fd5d9b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -265,7 +265,7 @@ u32 svm_msrpm_offset(u32 msr)
 
 #define MAX_INST_SIZE 15
 
-static int get_max_npt_level(void)
+static int get_npt_level(void)
 {
 #ifdef CONFIG_X86_64
 	return pgtable_l5_enabled() ? PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
@@ -1029,9 +1029,9 @@ static __init int svm_hardware_setup(void)
 	if (!boot_cpu_has(X86_FEATURE_NPT))
 		npt_enabled = false;
 
-	/* Force VM NPT level equal to the host's max NPT level */
-	kvm_configure_mmu(npt_enabled, get_max_npt_level(),
-			  get_max_npt_level(), PG_LEVEL_1G);
+	/* Force VM NPT level equal to the host's paging level */
+	kvm_configure_mmu(npt_enabled, get_npt_level(),
+			  get_npt_level(), PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
 	/* Note, SEV setup consumes npt_enabled. */
-- 
2.19.1.6.gb485710b

