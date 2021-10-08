Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4C1426E45
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243253AbhJHQAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 12:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243273AbhJHQAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 12:00:51 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB3CC061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:58:55 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id l9-20020adfc789000000b00160111fd4e8so7698831wrg.17
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rwYC2sE6wVOnGoN5vSGqYSfz4869siK4qW09U7txiBc=;
        b=c8ru3Qe1oXnPhtzT72VnFYCpAjo0RvFHMHZ080BzM5rLRiOjwEsYh2ClAFhCjYGfvG
         nLpo2bQPu7D531jc1Ec6uAziZD6qP5LbF249RkQBq2dqljC1jz6/7QvddfoLeEMALa28
         qZlD514iC2Z82FelXxaLD8MYSMyV0qB96wo+3ouHrFVENKxDnhnoaZPoq+lTw87I9uEQ
         ic0EQssLYoeM/ZVbSxuwdoKuWhAKrqgklMpbhcACsvMi4eQ6FWZ8xmUea4xv11y+zCU7
         xMYZUh0FYX1ri/vpv7r54fD6UAGR6UVBz5KhhTs8tSTUYsiUD3qnE0uyiI3NdmgiLAsI
         kwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rwYC2sE6wVOnGoN5vSGqYSfz4869siK4qW09U7txiBc=;
        b=lxLGXBO2EvzbDEIAhExbWRa9k1zBOXF2BV9YdAJRseRyTPYDFoCW122XAyQje2s92k
         MEHIeFieAVyt+3zcXbtEt443T7Y94JfMq0khUa2UP3NDqnpgz3hQoQPqS1nxFw2ZrQyC
         GBuOQO5XdACYfXr32XZy9VawV5C2LYcp3quO2yAJwxTu4sZmkwGYpasQM7S4qnR6yhup
         LAV5zNFuBR5Vl9twDRsyeEXCEZfoFA5N8vWEgEZKf+z4ji5SA8K4h+LnAd9pAN2MNHr/
         SS8aD2ZCLEcAoZkxNBi1cqODfPLf9LzKsRPnxI4dBQa0mqthjiGPvbfH2yy3e8lmRO7k
         37uA==
X-Gm-Message-State: AOAM532twdoszTbjRmdRlMqrHaomzRbFID3jNufZ3512dPigFFlZqn3v
        BxZj6KjfEJL8CI1UeihZclG5SHiTaA==
X-Google-Smtp-Source: ABdhPJx7pb/1hcdGzJbeBZmEf+wJ6+Z2ZGHYJY+BCNomT7RALtBu2vWEN8kxXGiXRydZws0FAlsJUZqHrw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:240a:: with SMTP id
 10mr4334650wmp.170.1633708733981; Fri, 08 Oct 2021 08:58:53 -0700 (PDT)
Date:   Fri,  8 Oct 2021 16:58:30 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-10-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 09/11] KVM: arm64: Move sanitized copies of CPU features
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
index c4ed32521b7c..f5354233d03e 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -19,6 +19,8 @@ u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 /*
-- 
2.33.0.882.g93a45727a2-goog

