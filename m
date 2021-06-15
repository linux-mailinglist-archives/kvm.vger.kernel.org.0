Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE013A80F9
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhFONnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhFONmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:42 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5C0C0613A4
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:15 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id z13-20020adfec8d0000b0290114cc6b21c4so8595440wrn.22
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fyVnhosKjO9mJxnhSqbPrj1l9sRivPJB1/WXZpuNCbg=;
        b=CsYREq5TCGC3GlLAFzzpvOuZn77mbxFuT1HeSaoBYGBPIUqCCXllBpCItlg2k4J9dr
         wSW4SwkdS5tGyldgGcoUy59zWlwHp5ZAH3ecc8LlNxDUSiB9YfVxKGW/sxxQL4FmD/b+
         lKPpn/FO4Y8fhUufgBFz7+lNLUmV6L2V8rYBSuWAoF1UDcH5oKdF5OqRVwRBXg3N/1MZ
         ps27wzJM8b/nId19bb+KylGK8pGm8BGsaNY7gWq+3vNMhgVOP8xMrrcUwNzPNlBB+a+l
         +rYJ2mHuF+N2eSlDBlDFeTrII+2b/fjA+h4K7yJpfGmMjHrPMBcermkHOTaJZe94nhTY
         0D3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fyVnhosKjO9mJxnhSqbPrj1l9sRivPJB1/WXZpuNCbg=;
        b=ukbVKkdcHJMZQGBR7Z0ljobN40/P89DXbZUpcd+oPlGyAIjw3tk5QlOo3Bms8xp/US
         zTUFq9ww5zXGNdw6T2/coJInn5JyH1JWmE2VVSMS+b2T5GjkZ6oVqF5U1Y+oB2p8ir2c
         DagM2KPxdYl709lpulAwtMulj42lqogAiRGQmL8qP61rJOlIW4rN+vkpL++iTXt40bmn
         9qnk/TZLwCtT92DyMGDgmgNvMsXcIWUXPobW60WqohSFTzHYguzVuzfvoH5paQ+Oajn5
         57gzCFUxnjq8gmKZzTa61AzgxYgL5rkE0tlivBvdi3ambSOwSLlaYgKDPx2e1Vf9WpYt
         FhYQ==
X-Gm-Message-State: AOAM531C2W3H93WtHkHGYr6dnhzSCPiPaHxZXiHS9MdU58HEs56/8cEh
        d/kjXWqt4Ym9i8jWElptQLNMveH/Kw==
X-Google-Smtp-Source: ABdhPJz7Ytktcyo9Dae8s0uQ8IHI2dhbPT3mA+LLAcl6XXLCYMUnLkF73AEFzonsZW/I662sARQOr6aDHg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c304:: with SMTP id k4mr5384103wmj.68.1623764414046;
 Tue, 15 Jun 2021 06:40:14 -0700 (PDT)
Date:   Tue, 15 Jun 2021 14:39:47 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-11-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 10/13] KVM: arm64: Move sanitized copies of CPU features
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

Move the sanitized copies of the CPU feature registers to the
recently created sys_regs.c. This consolidates all copies in a
more relevant file.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 6 ------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c    | 2 ++
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d938ce95d3bd..925c7db7fa34 100644
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
 static const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index ab09ccc64fea..de995a8a5eb5 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -19,6 +19,8 @@
  */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 /*
-- 
2.32.0.272.g935e593368-goog

