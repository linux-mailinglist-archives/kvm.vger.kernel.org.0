Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5721C3EE829
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbhHQIMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239073AbhHQIMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:37 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DACC0613CF
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:12:04 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id u6-20020ad448660000b02903500bf28866so14804577qvy.23
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CiI5OAhgkZ42MHJT2zFxCH5sP5MyitED8/DF2mknSW8=;
        b=N2qruQnB57J1upAsUBNREhuAR3StiZe2QzZ5sJCUFNr7a3zSqoFVSMrJWMj6bHPTUK
         sVdDMSI+dJ/2JRgJ8G7NYagBFHT+BsSJASB/c9Y9FZjN/j1EhQL8ZYFI4QrA0gDqs0jC
         2elLEehk23jjYdR5Hx9ZvwyBJA3KuoaOl8qY7/L784YKX0c0FHWN+05BCelz8E5rfgYS
         9OXpPNBscLSGqXjwGNMw8ANyt8vZVJGLDn81YtH5QtnkigIIlnlB/oZD6JA5no2Yliw9
         UaUriYgFKVvMl273Yj5Z1x3GVVDTMO/Ctqzlkz4vX+gat3oxvr4o7/kY7fAK+aF7UkLF
         u4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CiI5OAhgkZ42MHJT2zFxCH5sP5MyitED8/DF2mknSW8=;
        b=Utz/P9Zpi9SqjUxPwQoQsdIYR1FfnbthW1m3DPKpSukLRmht/o4JPmCN3DS+XBklk+
         A43EGYXt54nLV3apfxa+ppaJgC0B1lrlM38e0+xd5lzvuvwuCQJv+ZCqzGhxpyLGiglV
         GI+JncOV1PzUsp9n/yUYF3uovfNz8VxIqmHwLoc9rd4wZwptAAbIZUxjwYUQncOclht3
         UQAF761p/mD0SpdhUTw68Is0WhQpOAneT4/fGYGqI84YnNTGkvdQco6niiw6DOK8rybZ
         P+cJH7wJ2iF+1hv1ZpHhUaYc+UAr1iLxaExxb1mA/VCfzreGs5Fo+KzM3fUA98rpEzLl
         5Drg==
X-Gm-Message-State: AOAM530pFon43iCSfRjKXDjk/O3pwlmlVDdvbYwMzt/ThtyZOOprXc27
        3exqR9bEu0pLi/4vjr4lbBfYzqjiZw==
X-Google-Smtp-Source: ABdhPJx3EYuucuTVJB6wfR0mR5/W7Jcy3V7XAywnfoLLIN/YNpK/SPf6PSNDn9Ub/h9uKoQlJkPSo44QGg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:10c4:: with SMTP id
 r4mr2134781qvs.58.1629187923801; Tue, 17 Aug 2021 01:12:03 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:32 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-14-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 13/15] KVM: arm64: Move sanitized copies of CPU features
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
index cd126d45cbcc..d641bae0467d 100644
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
2.33.0.rc1.237.g0d66db33f3-goog

