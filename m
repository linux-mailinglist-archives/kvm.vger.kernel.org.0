Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00837414986
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236132AbhIVMs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236086AbhIVMsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:48:50 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F0CC061764
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:20 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id b17-20020a056214135100b0037eaf39cb1fso11837662qvw.11
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CzbIlsH2Bae6d1ohUhEXXMHc1BqJcEJ9GIPtvLTyUfA=;
        b=rVHWBTr+ChOeXTeurOu+v+1CwFDR2HJVvNknRU/O8EN6WJBhCyhU1JsMDyDbYX7e2j
         gShaBT1v5OklVRbcq+ZHzBlgrnkbeNelVoK+r8WrwHJggXyrWzyjL66vv+e+rjJWzt9z
         f8JBkLd7VVi9ZgG2Y3aI0k2ArWCOWOcJHi023g1LSaCRj7J40bY2+NtZyz3awLWBP7Uu
         460hJb28W88+rdDfdlIxzuysUwIwTf8uWZz5jO7OPY1Mm7FE/e/6K5xondK38E/cI1od
         DHvkROjoqmK6czAiQm73zjKTkPITnirwf9nnPX5qs9FUSB4Z/99PAjlr8XD5tukLQkLw
         /60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CzbIlsH2Bae6d1ohUhEXXMHc1BqJcEJ9GIPtvLTyUfA=;
        b=1hRVjQ9QU7g0NVjcLrvZkGXz/4GzUYcdV2xUCNFE3HJFztr1o9IZ9TNenyjPA/4rD1
         5vETFowigHm7qNUC5S8wFRsiAJhT3XhUYrEGGTC4yo77BJ2x+zMrP71+vjLdcbVviBbm
         bxcArzeiyfzuBTBAT4lu3XoMfpVAEZ/sOXT8YBJ2CjHaZx80oKHc1Cp/gFEdJHle8kN0
         mX96bRDJzWhYjmsysWZ0hgRJoIO0yvL5p8J4+WEY7hBrqcdzEZaMF0g07skJWs6Za74y
         v6cD9uwakt1WfqdYksan3+THOUXTb2aybqN8/o1mpm3gMQmx/3G+TV0l1brRMd11Thso
         QjSg==
X-Gm-Message-State: AOAM531hkVGBpF6QUtcAvGkPsnm2SgOvYFG7Wv/n4DonpAPQgAkhNULv
        1G2uNiYDxYIYSaPveR8lG8Mdzl7ZGg==
X-Google-Smtp-Source: ABdhPJwDDPHHqyL5m+7ppFVDXADAk8bgN9FGXTlQ7s7v5LJH3sv6Jt4+umRRpSGlND+gPox8E6lKgwV4fw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:ab51:: with SMTP id i17mr12629786qvb.39.1632314839330;
 Wed, 22 Sep 2021 05:47:19 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:46:58 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-7-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 06/12] KVM: arm64: Add missing field descriptor for MDCR_EL2
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's not currently used. Added for completeness.

No functional change intended.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/kvm_arm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 327120c0089f..a39fcf318c77 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -295,6 +295,7 @@
 #define MDCR_EL2_HPMFZO		(UL(1) << 29)
 #define MDCR_EL2_MTPME		(UL(1) << 28)
 #define MDCR_EL2_TDCC		(UL(1) << 27)
+#define MDCR_EL2_HLP		(UL(1) << 26)
 #define MDCR_EL2_HCCD		(UL(1) << 23)
 #define MDCR_EL2_TTRF		(UL(1) << 19)
 #define MDCR_EL2_HPMD		(UL(1) << 17)
-- 
2.33.0.464.g1972c5931b-goog

