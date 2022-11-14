Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CD36279A5
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiKNJ4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236281AbiKNJ4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:56:34 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7565FD2;
        Mon, 14 Nov 2022 01:56:33 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 130so10491058pfu.8;
        Mon, 14 Nov 2022 01:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gu/vESHLT6XUoo6CrxlXuWquoLDjp7p3uStugx9OU4Y=;
        b=jybDcBc9IYDuDKUUjDN7GS6mB7fVbkc+rmbUs7kQhDSpkxuhk0Zs2enp+Y+PMzre51
         jifjnzUPfQfX4rngaD0K0iyUMFnyXYjmF03Mn5Uz7PMjgy5EvTAbQI21k6ThzumX1FUc
         L+Ke2GzEWrx9b7UHoY1vcQjAVu9HnAQXfPpS7fnZZhS8oOUYj606T/6PHa7LKeXBhs6o
         Aagr/jmhC8q2H4A6UnUSqxn0jXB9ipVOPTBwnbG9Ms2RPrTjU06YdyeZRPQWcJGKSKUM
         fde/OP37RzVBdeYsJMd6+Sp7Xi5CzhOZZwmYk/t7URXoTeKrIKGYvZVZUbLvui4Ob3Rd
         ZaRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gu/vESHLT6XUoo6CrxlXuWquoLDjp7p3uStugx9OU4Y=;
        b=iWRN3CvsdFvq0JWz1BTS/S0gZa8xjVXgMbtTlZf+AiAh/MfE2w6wAJXewU0wYj+tlu
         4+Jc54CkJcabmsN0btQ4VotgwmXGRCjwYNDO6MV0bAnRsN7tyFg7pbQMXPdqbL/ciYtw
         6NnSts5o7/Y3edWSRQFQ1h5Vzoy7rrQXwt5Ukz8ySwti+C4vKpntH57/SnQgP9wcckb+
         xbROGwYYOaxgvOpUkO1X14zvSH6iuSAWpV0tIrj241Efsq9CwWsRaDArUnbTbh/WmBtV
         T63HAv6DA09ruA1kBg7YddrE2UcgtOUeHW3R4Qg3cnuJjRMU781ZOQTmCaFe18hiabo1
         duAA==
X-Gm-Message-State: ANoB5pkjug+Txw1fJbP8/z2/9PusX29SkEPsc+6JALMIE24sNd0rsU3T
        89m9mjtiNX3Roycp4DAnpg0=
X-Google-Smtp-Source: AA0mqf66n3blePU4NdT1T45ATbdiiN9dT4Tiav8AQ08OGC1BD75KI4PpkuvB7LMcwOjdJEqDPiPc7g==
X-Received: by 2002:a63:5465:0:b0:43f:88cc:473 with SMTP id e37-20020a635465000000b0043f88cc0473mr11348875pgm.491.1668419792996;
        Mon, 14 Nov 2022 01:56:32 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:32 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] KVM: x86: Remove unnecessary export of kvm_inject_pending_timer_irqs()
Date:   Mon, 14 Nov 2022 17:55:54 +0800
Message-Id: <20221114095606.39785-3-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114095606.39785-1-likexu@tencent.com>
References: <20221114095606.39785-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Don't export x86's kvm_inject_pending_timer_irqs(), the helper isn't used
by KVM x86's vendor modules.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/irq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 04a009fbdf8a..a70952eca905 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -149,7 +149,6 @@ void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
 	if (kvm_xen_timer_enabled(vcpu))
 		kvm_xen_inject_timer_irqs(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_inject_pending_timer_irqs);
 
 void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 {
-- 
2.38.1

