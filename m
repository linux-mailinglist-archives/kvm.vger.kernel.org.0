Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB3B3A80EF
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhFONm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbhFONmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:37 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69AFC061154
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:06 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id z4-20020ac87f840000b02902488809b6d6so9416119qtj.9
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kL/kBHAQck4ApelGdSS7r2lP6eaQeDEKtmMiMUjhfo0=;
        b=gzqPcBKLBvsLtIpEG1aUU37g0RalZyoxkyhQar78llr2oOc96Tava3TDOCiRx/YzEm
         OAh8TvMkEWDMPRC/bmfuFicpQV2yuurSJCvzKZuu7RXLqmur44ozuMukAkMEaGUyoOEL
         775rpm73wH5/gfsIXgBzkK9rQqPrjXOk0GIoLBVxrqDy8OmH78CbVcj1TYfehMToBrGu
         vORRBMciUjIHgl6+21vGLDXma9hKclutw+MqKY79hibqJ/RttXxhJoUBjCKvW5EJbMlX
         4TRfrtYuBACaUKlWTnWTh35wbz5CtLb6XErSBJSX45vP3N3sniIGOEHGty3ZLjb7Qaiy
         Y1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kL/kBHAQck4ApelGdSS7r2lP6eaQeDEKtmMiMUjhfo0=;
        b=oyPxwoRt6lBgZkjnkLCrlnzWAAzYWU755DPuK6Qa+TK7qF8ETJAmihDj473Ccviv99
         lFdqsJ2EUUEF4/Q51LInUGfgSdx1jXDk41sIpjNitClv0Kaka6mDz9X7UrvbAC6iNgqq
         bFgzydIR8FEpb1rf15bZNHqtbbfq3W0eQIUui0kE2UoisfqDEJqhKpYjGrHNM7Gd0O+b
         i0sgd+zgu6JIPRZMEmEQVTfzO/lj+4YTG8PdGd4MmB+pR5Sp1XlnzVHxWuFYjBLMPbt7
         KyuSH83hH2okYtgNDRjsXZgyRHwrlZyl8FmqeR+azZ67A0I3lajdJhs7APxH+7iiAbyU
         gDvw==
X-Gm-Message-State: AOAM5323DF2B/v8KW0nfKFlUuDmauhdLqajL+q7NVKHwWMj6QVTSoyBG
        q/97gW4LEOVOEfyPugYC1f2ZvlVpow==
X-Google-Smtp-Source: ABdhPJzXW07KU0XghibXdRXCGLp6L5Ztu0HSUPRZ+aQpdEyoZgVmZraHgVD7kZuhI194f2WprPrdxaRdtw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:536a:: with SMTP id e10mr5022177qvv.9.1623764405756;
 Tue, 15 Jun 2021 06:40:05 -0700 (PDT)
Date:   Tue, 15 Jun 2021 14:39:43 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-7-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 06/13] KVM: arm64: Add feature register flag definitions
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add feature register flag definitions to clarify which features
might be supported.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 65d15700a168..42bcc5102d10 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -789,6 +789,10 @@
 #define ID_AA64PFR0_FP_SUPPORTED	0x0
 #define ID_AA64PFR0_ASIMD_NI		0xf
 #define ID_AA64PFR0_ASIMD_SUPPORTED	0x0
+#define ID_AA64PFR0_EL3_64BIT_ONLY	0x1
+#define ID_AA64PFR0_EL3_32BIT_64BIT	0x2
+#define ID_AA64PFR0_EL2_64BIT_ONLY	0x1
+#define ID_AA64PFR0_EL2_32BIT_64BIT	0x2
 #define ID_AA64PFR0_EL1_64BIT_ONLY	0x1
 #define ID_AA64PFR0_EL1_32BIT_64BIT	0x2
 #define ID_AA64PFR0_EL0_64BIT_ONLY	0x1
@@ -848,12 +852,16 @@
 #define ID_AA64MMFR0_ASID_SHIFT		4
 #define ID_AA64MMFR0_PARANGE_SHIFT	0
 
+#define ID_AA64MMFR0_ASID_8		0x0
+#define ID_AA64MMFR0_ASID_16		0x2
+
 #define ID_AA64MMFR0_TGRAN4_NI		0xf
 #define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN64_NI		0xf
 #define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN16_NI		0x0
 #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+#define ID_AA64MMFR0_PARANGE_40		0x2
 #define ID_AA64MMFR0_PARANGE_48		0x5
 #define ID_AA64MMFR0_PARANGE_52		0x6
 
@@ -901,6 +909,7 @@
 #define ID_AA64MMFR2_CNP_SHIFT		0
 
 /* id_aa64dfr0 */
+#define ID_AA64DFR0_MTPMU_SHIFT		48
 #define ID_AA64DFR0_TRBE_SHIFT		44
 #define ID_AA64DFR0_TRACE_FILT_SHIFT	40
 #define ID_AA64DFR0_DOUBLELOCK_SHIFT	36
-- 
2.32.0.272.g935e593368-goog

