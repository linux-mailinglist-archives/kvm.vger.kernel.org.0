Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D31C3CE526
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347393AbhGSPry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350269AbhGSPpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:47 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA37C0ABCAC
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:30 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id z1-20020a0cfec10000b02902dbb4e0a8f2so939065qvs.6
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AJdpXDjb5aqrnyWXTohbslhSMhG4QVJMKzdIEyMUQpc=;
        b=Lwsz6htTsTWfi7NrN+36zuCZsSkjE9PZhnpdh3+672pcVHhLdTHphSHEHVUhe8wDhl
         7J3Xk8TAOfZ5iSvTkWeRqsk9kbNKyezC11ubg0T7vKXHeMoZypUm5MD10dFoNf+LFn8Y
         HIrDaF8b1EWtG514FOl8z3rUi6HjMb7rDasSWjFGXbngMsi0eE1/jk0qbpTTwN9kJt7b
         kL4fP0N0g5o1OFBXV/EIZcTpOOIx0AVoqX4L7bZgQKOD5s6FHWKY2+GdtJP4wux4AZTT
         tQ+qmqYKXZbH7mqZ8qYQIxpp5zGgL685HlOF9JSq1WN/DUKZBSPZ7ycql8Q3c9gEPou0
         rjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AJdpXDjb5aqrnyWXTohbslhSMhG4QVJMKzdIEyMUQpc=;
        b=THkYWtdBDPlt+xKtx/iiK980fkxqIleK4krd8NKED1g7BMQWjFAZz40d/DBE2IS1FN
         lgSc2axvY30A8sgDTCm7B2cv7Bb1YpNcMTiGWBa4dx5TpxObq/Q3z2zTqFz/FuWYhH8v
         AiKtiWBA1AyUiXXa/70mV+PyrfYc8TEQFqH+JB4UIKxwCpEshuwjw4e/3Z9kyoB9xxxm
         LvZQINLR11spCd4e+U7SkSDEwVdfpBjTOsqbF0vrgXJ56kiuTu+vIY+ynHNkKER8xHrP
         mX6tRbJ6tOF+QHweU2AvQqqxbd1JGrb1/z9p+hXOhkHbk4/IF9dNEZ4FAoieolvjaoBa
         xHEw==
X-Gm-Message-State: AOAM533Dp2wYFXgqasvfd415Fs+Ffhkw/xtGhT0KTo6B35/lL1sbrioG
        uxY+FrHwBfsvDcqsIav/yjsoBsN1ig==
X-Google-Smtp-Source: ABdhPJw3tryWXJT3EFvXJKKt9agcIqsoHY0evVKNv/qv6pjB5RoCSQQ/BO2TYjmoqow8vwgbItMGRJsLYA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:529:: with SMTP id
 x9mr15850705qvw.0.1626710653088; Mon, 19 Jul 2021 09:04:13 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:43 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-13-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 12/15] KVM: arm64: Move sanitized copies of CPU features
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
index 6c7230aa70e9..e928567430c1 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -20,6 +20,8 @@
  */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 /*
-- 
2.32.0.402.g57bb445576-goog

