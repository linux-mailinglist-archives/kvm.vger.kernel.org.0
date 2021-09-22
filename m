Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DC741498D
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbhIVMtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236159AbhIVMtA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:49:00 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE86CC061768
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:28 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id w17-20020ae9e511000000b00431497430b7so10057827qkf.12
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VDXP3setiKLnEkr+m8sXiGgb9NQ7LpnbUrrcIbXKtWo=;
        b=YhjUmlV5OpV1LXBTgzD8/h4cw2tRnnfej2OdpOQpSGJxMxFm+HDvY9vdNn7/RVXaxA
         lVbEnrUF58QW9sv1C6OK93B5CyDwhDWtQ4NMEpn/M8vw6kRj8RiFofXL2HGYyVZ46ghF
         oMxWjdWfsofPMRxWOOdMyIvmnVxOyner4uS2ykvqR73D33N3r/sub3jwu3PTk/Crd/c4
         y3V/DEQoTtMLQ7dGuaD7wLT3jw6R5oSx2QT8EDVkWoffehArauEXCYepe5rAYc01TdzY
         vbQSAEObj8/viDQul62w2oFY9l+j0cxFaDKLITiZVWrv7+OFhyHSy1SFp7xEU/TMu9yI
         5KqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VDXP3setiKLnEkr+m8sXiGgb9NQ7LpnbUrrcIbXKtWo=;
        b=BMRoU/UCUpADgVAWsqcoiUimWkRTiouDG3nA4Ihh33I6+EMLippausnmCFZEkVByC9
         GVIdlPqObisnz/GTSrSIdcnizuL+A+7N+Nav1vWoFSVdzXV13Kl3EmWHDiPzqJPZ0Qp4
         lMudp8FTtIAplmRd7OSa7dw6btb6hAAhNOSBy9eTFDZGlhNpB3rTHS9Xoj2owvCqS2m3
         W9iChLHsI5NXTjXUUJjBRYl6uLHPpXh+Q+Ugf3F8FNuyBmG4DouIIutvmMZ4eQ1D44B0
         Jc9ZZa+VoptrQrn0lEsS4fVT7HxZUFpzmWds6BcHuScJ+rWDSH8DK/ge/mddfyQYdXVn
         4Fcg==
X-Gm-Message-State: AOAM532iyQ9Lh3bHsiocn/aL8sTXCOR93m1iR9+QNQMojpVBjzE9MQgq
        FQh4vXZe6Dkh81fnbrCNxy3zhfBnuA==
X-Google-Smtp-Source: ABdhPJyQbCBi9wL/tzdvEaSavXwKPtQuvp/ahZuW35rtc+EuWLIOI43tUp6sSo2sedY/Dgz5GrvXBg5Ung==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:8881:: with SMTP id d1mr15958608ybl.289.1632314847844;
 Wed, 22 Sep 2021 05:47:27 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:47:02 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-11-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 10/12] KVM: arm64: Move sanitized copies of CPU features
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
index ef8456c54b18..13163be83756 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -19,6 +19,8 @@ u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 static inline void inject_undef64(struct kvm_vcpu *vcpu)
-- 
2.33.0.464.g1972c5931b-goog

