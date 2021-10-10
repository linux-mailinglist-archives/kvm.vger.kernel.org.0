Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33926428214
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 16:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhJJO67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 10:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbhJJO66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 10:58:58 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C4FC061745
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:59 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id c4-20020a5d6cc4000000b00160edc8bb28so5387317wrc.9
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NjmzICmgs/1/SRU9S1PIoFoU/QO2NcwvWdQNYWVlfS8=;
        b=qJXoTWLIck34aUq2vWI+yRaH1p2dPNKc5RilSQ2TjF15hJYVdQuO5LFwBiwz2+s7qL
         qxbP45kiEkCMKWlfQnu0m2Ry0UozRA/bQwdyQBMnYT2sR9IB7G/hdRavPrAKAzpQ1wLk
         mCYRuz3EEmXPvrUPcSUfqr4t9T97djcmNdiProPKbbscCqxiiSgwL7Ov9itNNYvmbuVy
         RaLpTyex5ZZ8iJc6mYhQaB8nfl44lpN2GSxh5GKhsI9iQtd9zOI1xXGC7Oh7EimAOYif
         AdVJAh6lq2JOqJuQW0F5Gx9eKRg76zaPBFYIdO9frERP5eKgKLoEgc7b36X5DA1/8/Gl
         nFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NjmzICmgs/1/SRU9S1PIoFoU/QO2NcwvWdQNYWVlfS8=;
        b=0s9Ud7L0oSOMRKKdvs1A8JrwRikrQLM7EXl/sR1UxwfKbxtxXDfdHPiy3c1aywDZ8s
         gLtgunnJamj4elDl0gCWOT7A23oLLoFqUPDwKvq0KQgeGFvRBnlALJFc7i3PCjiyB0Z/
         WEPSutKTZP2BdoxBebaLABFNhTQ320JMloSGqHnNPURGMyuo7d79h0kvzrPlZSMzHBqe
         PM4DpC72DLijIliREB+aFS3cuqHhAfkrKI6oLro516liF1I6Wq/z6VsocZD7Uz45zJ6c
         fqfsqVSMX7zFUQhTKdujvMiyV9UEYxdSCvBuGgA5HWu1jeTmh2x0tFGveOzLD3A5EDNe
         XldA==
X-Gm-Message-State: AOAM532FlVMCetyjspAxgvInu19qZEzuBFgYhvRxOcX65NNLh40YFOfx
        A5btKkHuEEw3q5oWr7krTuX35RNwVQ==
X-Google-Smtp-Source: ABdhPJyaRIw2i8Vmfc3FxfbM4wwoieTXOLpMnD+P+7LcGqnctSEbohnVUEjCI/49CwnkqLd//Ok/pbYkGw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:19c4:: with SMTP id 187mr15371722wmz.149.1633877817910;
 Sun, 10 Oct 2021 07:56:57 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:56:34 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-10-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 09/11] KVM: arm64: Move sanitized copies of CPU features
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
index 6e3ea49af302..6bde2dc5205c 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -21,6 +21,8 @@ u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 /*
-- 
2.33.0.882.g93a45727a2-goog

