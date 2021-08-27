Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430E43F97FB
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244888AbhH0KRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244880AbhH0KRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 06:17:14 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075ABC061757
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:26 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id q11-20020a5d61cb0000b02901550c3fccb5so1702065wrv.14
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SsrZd6Jo8kMJWJSsMSYjDPdCpx5Fc9MexzuaW/MoFqQ=;
        b=BZjdr5KZHMgOcU8VqWpDgH7zY3wkoT523uqqlrhERo+iSn3xJNI7QA99yOuh3YPeJp
         FyQtyRATL2t1bNZHbVQkHh7wLDV5ccKYZOvazhTUhoy3xlvN3VaVDht8M5E6THT4hM3X
         E5jVaQSFz2QDvtZSibkFM6iDf1WrkKx0RhVXWkaoEEWTEEdaYbZm28tYkUwmaw42TDaN
         bw9MFKL/VF1tMSMZ+oqhfAOEDeTl7WkJUiq1aIoSt1dKRy8L4q/3q4UEDahyjFGKcvfM
         Q1R/qu1ncxIqZRBrq7wurO71aHVhbrQcZpEX4W3A/UaczTEfOaLhqqIscKCgI8sO1Fi+
         4Y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SsrZd6Jo8kMJWJSsMSYjDPdCpx5Fc9MexzuaW/MoFqQ=;
        b=K3D/VLjWrAbLDHXxisBi9fWMsMp1M10jsh9PLrGNfhqAwx8WiLHryPlvnK2rkMcmaZ
         LtJsJiYK7XnHbZM7GF5mBMPDtCuHipS0CconS3o2iIx8+i9jCIJaE4LQvr/Wakthi5+w
         gLw1fnA3yjSvtHj7jBLo6Ac87Zp8joi7AcqLMtxKr6O9HyK2SkUCDBXaXRPYxUhzdCJF
         B1sI9XfMbdUPUdMZ2WhPDZLkJz4xLFDIAmi+4vdZ4fEdOj1wXThzh6rVB45d7RyXAvPw
         6rghMxvO8s85ALDOAS5kO7CMptxo9iyPEwm/AItkwdmcudcCzd9qsKmnAUUvVIyb1C61
         YjXA==
X-Gm-Message-State: AOAM532KtKUrr4yaUro9j/tWCF3kxmsamBPTWfCGXHlpTaceSiG+vzSt
        d5K+ThXCWJ3mVlRtbSc4rd24m0tEjg==
X-Google-Smtp-Source: ABdhPJztEz1988L0qtSVWiS7gD05LAwEOXiOtb7SpQw0H3ZxaU+gyIMNUefXyCTKQspH2GaRYyM9Slru3w==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:98d2:: with SMTP id a201mr8090262wme.89.1630059384567;
 Fri, 27 Aug 2021 03:16:24 -0700 (PDT)
Date:   Fri, 27 Aug 2021 11:16:07 +0100
In-Reply-To: <20210827101609.2808181-1-tabba@google.com>
Message-Id: <20210827101609.2808181-7-tabba@google.com>
Mime-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v5 6/8] KVM: arm64: Move sanitized copies of CPU features
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

Move the sanitized copies of the CPU feature registers to the
recently created sys_regs.c. This consolidates all copies in a
more relevant file.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 6 ------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c    | 2 ++
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2a07d63b8498..f6d96e60b323 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -25,12 +25,6 @@ struct host_kvm host_kvm;
 
 static struct hyp_pool host_s2_pool;
 
-/*
- * Copies of the host's CPU features registers holding sanitized values.
- */
-u64 id_aa64mmfr0_el1_sys_val;
-u64 id_aa64mmfr1_el1_sys_val;
-
 const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index a7e836537154..4a9868ec1f0f 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -23,6 +23,8 @@ u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 static inline void inject_undef(struct kvm_vcpu *vcpu)
-- 
2.33.0.259.gc128427fd7-goog

