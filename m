Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D3F4EFD9C
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 03:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353590AbiDBBLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 21:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352893AbiDBBLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 21:11:00 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837CC8CD96
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 18:09:09 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id l6-20020a17090a150600b001c95a6ab60cso4927718pja.5
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 18:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8RHA9aUNJxFpM8yTJhP4ef1t/aKUFmzX6SMgtUXeSlU=;
        b=mu6m/a5O3VjsafgbIgGavNyaMXeK5i+9etdubuU+TMNUVKvHADJfk8RbYW9jX8JI6L
         fGcg3as7WwEUTD6BKHO8x+X8rl/KoQ0vXmuQKH+tbFQNlDrVvXZfTE7zAoIuYPNuYoyG
         4rF6f4FEvRvKghKoT+T7LWlsqJkTfx+WAiA7dIFsjZBYLQK5i2aQ5Q3aDkknDP5IkLuK
         8PZqwQKJXWZbP5fXXW8tZzVRpDTNYrHK2DY3GJtJN+1PdWtwqmiueLkl/nNduvbKONov
         n1k+OwCK0aN+DiRconoQP9ZKaQXkMGXCPrWjncL4jUH0SPVC14/yi5H2rq2jZXbaJ8IA
         nYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8RHA9aUNJxFpM8yTJhP4ef1t/aKUFmzX6SMgtUXeSlU=;
        b=VdG8OqTM8z1LbGpsxTXJ70ruzd4qsb64U5/O/1NNtQb+Zmuf1+HwUSDrSuhvVvouuh
         jta4xYeqt2CNmONyTXFO6ahEliBaPbt2Y5VmQ6k5JWou/jozjtdqNgiJEbZPSaseuAB0
         3PO+/ssd+D7w1QSpF5PyC0ers/qhdjhpz/zIzGOOZWrZVN0mUgl/ZgJm/eOQSzNBNeSs
         6vo1kyTJfyPw6c+yoVMK1MhAzvB/W0ty9hRu3FZ5QF8qYolcQH/Jb7mYX8WDFANoPyKS
         sly8CMXzQpAjmEofFnlTHGIiFIQ2UvwxOpdAugfPIW/Rw5csowwBYEQb3TD6RrLWg4u8
         pcoA==
X-Gm-Message-State: AOAM533Y1ghYp2O4qsCLiVSwNmMrvtaBWv2QFocvbtDWmzoJz3j6HtrM
        VdpBP6K71NHJQKeCYExU8r01p1olfEg=
X-Google-Smtp-Source: ABdhPJz6eEt/o/RMT6jRF4o5mIUgYCP3Lxw3z5+HYs6xIhuayeX7wPusWKnd7JasHteXF2zCH0UcWHuQWv8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:114e:b0:4c8:55f7:faad with SMTP id
 b14-20020a056a00114e00b004c855f7faadmr13709370pfm.86.1648861749019; Fri, 01
 Apr 2022 18:09:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  2 Apr 2022 01:08:57 +0000
In-Reply-To: <20220402010903.727604-1-seanjc@google.com>
Message-Id: <20220402010903.727604-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220402010903.727604-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 2/8] KVM: SVM: Downgrade BUG_ON() to WARN_ON() in svm_inject_irq()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

There is no need to bring down the whole host just because there might be
some issue with respect to guest GIF handling in KVM.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 95b26dbfd561..2c86bd9176c6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3383,7 +3383,7 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	BUG_ON(!(gif_set(svm)));
+	WARN_ON(!gif_set(svm));
 
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
 	++vcpu->stat.irq_injections;
-- 
2.35.1.1094.g7c7d902a7c-goog

