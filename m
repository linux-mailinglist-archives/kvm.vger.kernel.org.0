Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07C239F892
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhFHON6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbhFHON5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:13:57 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A6EC061787
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 07:12:04 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id z93-20020a0ca5e60000b02901ec19d8ff47so15643206qvz.8
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 07:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/Mt8MqtrF+0ijPrbzI2Iua+6aoYU0GqD+XJoEIBz4Ww=;
        b=RFQw40Od12GityDnZo7Kd/94h6wYJrr5TxRqbfenOuViXa1LbDJ5HBSpEzf3MaEc6r
         xVJWDV0RGF2FuaZ4q/eel/c+IsNzhEazQQUUgHrAmLn9mPMZnrUH0CAxhGFIVKckjjR7
         TU5ovJ3z8hUNmg58EW+DZe3QIGkXohuJGa9B3abxBrZWiydDI73wFvCJMUUvrLwtDCkt
         gH63E9BKHYEH1IvpcXEekuA2/G3JlfA+k2eN3Vg5GZ3ZKMFE8kQ1WTrN6vBxYFE4cgik
         08dUTzFaOg/LgfM7ZiKWI8JvNOsM2AJ5/3D09dW//e2huy5HxBH9HhFiY9CGNVazOag2
         Vp6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/Mt8MqtrF+0ijPrbzI2Iua+6aoYU0GqD+XJoEIBz4Ww=;
        b=h9mhotl8a8qh8aFeGXuvwqkIALOx41QPsELSF6rLiWOIQ99pkpI9BvS77KzqK61zYh
         IbdyNEx4UBDK+Xdsef88egymXWDHjX2F4lDti+PQPScEvQo3yhGNfxodtwnj1b2qvtg3
         HCrFypCXcnJY/dj+TiuQPn/hLXwHviT7NjjuNMiLVEroFa16gZVPwaUnPOltJ3h2xRbg
         AgeKaIZKmXJSvtOqOQYG6RIYN/saYpjvhQpzCuCahJYqlZW9Vz1QRd8eVL3FWTIlZBwu
         clgCBq03Y4rPIxHln0JxipjdasGg9xg5HBGxOw1r/xZiJTkCbJaIWEL8K8nQ1L80tQBu
         RJ3g==
X-Gm-Message-State: AOAM5323MwrSa89y5Hi2LYrzuX3i2rnG+dT+KezHpqVMOCRy5jdqiUnK
        FDpusmWcURcjtzOFmeMzeoWW9R9RbQ==
X-Google-Smtp-Source: ABdhPJxe0XAsOIoUJkVFC3croItftPKyjg8mxh5Z0V9YqYts9/X6Kv08kRsA9WOzWOgAaN4iTUgVVjEXiw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:ff48:: with SMTP id y8mr182068qvt.29.1623161523559;
 Tue, 08 Jun 2021 07:12:03 -0700 (PDT)
Date:   Tue,  8 Jun 2021 15:11:38 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-11-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 10/13] KVM: arm64: Move sanitized copies of CPU features
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, qperret@google.com, kvm@vger.kernel.org,
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

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 6 ------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c    | 5 +++++
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 4b60c0056c04..de734d29e938 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -26,12 +26,6 @@ struct host_kvm host_kvm;
 static struct hyp_pool host_s2_mem;
 static struct hyp_pool host_s2_dev;
 
-/*
- * Copies of the host's CPU features registers holding sanitized values.
- */
-u64 id_aa64mmfr0_el1_sys_val;
-u64 id_aa64mmfr1_el1_sys_val;
-
 static const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 890c96315e55..998b1b48b089 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -14,9 +14,14 @@
 
 #include "../../sys_regs.h"
 
+/*
+ * Copies of the host's CPU features registers holding sanitized values.
+ */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
 u64 id_aa64dfr0_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 /*
-- 
2.32.0.rc1.229.g3e70b5a671-goog

