Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5BD655D3C
	for <lists+kvm@lfdr.de>; Sun, 25 Dec 2022 13:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiLYMs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Dec 2022 07:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLYMs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Dec 2022 07:48:26 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2F8F60;
        Sun, 25 Dec 2022 04:48:25 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d4so287419wrw.6;
        Sun, 25 Dec 2022 04:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wk1BYg8FM+pEOgDUvLnl6H2w5OLbpMOtJjAehLPuXXg=;
        b=YHiNy0AmTytHP/zM9DGOTXAdMVIWPHQKGN7JAJo6k+uIomMU75y8IHyPEW+ES0OPdr
         M/+FA3SefMb7j5210TxukQhIYcpJOzlHYzq/dJ2mbqVM7OC90BvO2+tNBU7RXjHfGHpA
         8MV3QQhFxANj+r9fYGZjR7hR5SF1/LOP+/OBVJeKHB5EJnkLIhpe99srhnuDwIRFpGeb
         58S19os2iTMy2PrOAXYL2nYfWnx2ZFrdxSRgodtYPV8ddBtikcqUxqbxLlemcUJR0j1y
         PBOtRSXMPqsp9BWYKw/nq8l9UedKeXsYf8ZR/tt+OzA9ebBGfVYHL6n3RSznSiQy+J/3
         WXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wk1BYg8FM+pEOgDUvLnl6H2w5OLbpMOtJjAehLPuXXg=;
        b=omIRn/X/YBL7n6QTteyVXhX6Rck9IqlJHaLTL+hfcJiybfw7+LROX5A7ueC+i4YlfS
         92KGhFNtT/Zr8HgnLF3FyHQEBDLWx8h8VIgfJc6cEaQmZiW+YfLvlJseyE0JCAqqTJyP
         YSm9PJL+1c/lOouOVAjmq6ENK2FQMB7Yqs/AwL/Pc6n4cJHlyxzHGEu3PK13za/brsql
         AkOPKmUoBj7BdAi4cWip1F+1w8J7pd36/O6OO7GOroKaDUsgYeUrPkcgLCdtwvpGik0O
         APQpY/sWkiimbJ7GbDNVImvG1wNtWgpwEouSFMf20Owz4tZJjrEIsGTq4opBqFVlzugJ
         M3Qg==
X-Gm-Message-State: AFqh2kqQbBb4A04RbsN31miqBYNu79V1D7RnEjn0ByhGeJGGgPrgr++1
        vN24qCEftud4dq3uh644MZqGYF7QxPPEa5VBePU=
X-Google-Smtp-Source: AMrXdXsx0pPjFgu/n8lPaCTSb+6KPZ4hC0xDpuJIX+7IWbqDf6CjFGfegRUnmN1X3F1HeoBXqGZHY8pfUUl/X7KgcQ0=
X-Received: by 2002:a5d:4e4b:0:b0:242:4ab7:5a19 with SMTP id
 r11-20020a5d4e4b000000b002424ab75a19mr275499wrt.389.1671972503776; Sun, 25
 Dec 2022 04:48:23 -0800 (PST)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Sun, 25 Dec 2022 20:48:26 +0800
Message-ID: <CAPm50aKYh-qXt_MmQvbSH6Tye=yxrwAp_x_jcJHh=8ZoA=1P_A@mail.gmail.com>
Subject: [PATCH v2] KVM: use unified srcu interface function
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

kvm->irq_routing is protected by kvm->irq_srcu.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 virt/kvm/irqchip.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 1e567d1f6d3d..d3ccfe922880 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -18,6 +18,10 @@
 #include <linux/export.h>
 #include <trace/events/kvm.h>

+#define kvm_get_irq_routing(kvm) \
+       srcu_dereference_check((kvm)->irq_routing, &(kvm)->irq_srcu,    \
+                               lockdep_is_held(&(kvm)->irq_lock))
+
 int kvm_irq_map_gsi(struct kvm *kvm,
                    struct kvm_kernel_irq_routing_entry *entries, int gsi)
 {
@@ -25,8 +29,7 @@ int kvm_irq_map_gsi(struct kvm *kvm,
        struct kvm_kernel_irq_routing_entry *e;
        int n = 0;

-       irq_rt = srcu_dereference_check(kvm->irq_routing, &kvm->irq_srcu,
-                                       lockdep_is_held(&kvm->irq_lock));
+       irq_rt = kvm_get_irq_routing(kvm);
        if (irq_rt && gsi < irq_rt->nr_rt_entries) {
                hlist_for_each_entry(e, &irq_rt->map[gsi], link) {
                        entries[n] = *e;
@@ -216,7 +219,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
        }

        mutex_lock(&kvm->irq_lock);
-       old = rcu_dereference_protected(kvm->irq_routing, 1);
+       old = kvm_get_irq_routing(kvm);
        rcu_assign_pointer(kvm->irq_routing, new);
        kvm_irq_routing_update(kvm);
        kvm_arch_irq_routing_update(kvm);
--
2.27.0
