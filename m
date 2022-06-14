Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D52854BC0A
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353110AbiFNUta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353197AbiFNUsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:48:30 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452E950001
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:48:20 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id y1-20020a17090a390100b001e66bb0fcefso83037pjb.0
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qsUEai7S+ognYlpER+KbwHJRY/EwopF0AVDuG/EQcDQ=;
        b=KT9Rcxc8Qt3yuV+LvNyoHYLpsf4j++TIneI2+reREdh93ArAwh5ZGHNTJHrhPVwU1o
         nyvoQ07boYHGbaGa6CdwoGfGJ5+YoNeOUEVSdpCGgn33mEoUN9itg3n6ph+b+8ZvBdjg
         DkgjGC3RKby0xf2wghCkmwzh6vdQzchj4cMiITak5ztJOsG2a0scvEhZqgjw0YI9rRZL
         lVv8L4qUfqbePyYPLzK0iAkoe2H62ECJK8N0fozVUtGLfvpEm8oc5SUV1U+DJ39ehaCQ
         +IpYe35aS/ovhxCML5dsHOxslj06XT/6qAcK92dEifR3/mjxZ3trTSZLsLXQC+n4JZef
         RGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qsUEai7S+ognYlpER+KbwHJRY/EwopF0AVDuG/EQcDQ=;
        b=29D+mdOV3xqjVuvBbUavEzLgSrxXEdU1iaYuBtpi1JfmJ4/nXMtLbaFuXH9TShzM/T
         roTRge2jTfkOYqqTUhCwvTBwdOIyQJJEcr4cbOfIcH9p31SYoSmAfMhr+ptMBsNdK+ws
         oatdPGOfhBu8SjQdEpFAkDAz/hfHZ855/0jfZN1+mxPVc3P27PY40lboH13+1WcWGbZA
         J+4gBEJNk4sDGEm1hnQXynjKkj/fq36GjiUHsB3iSviOzYIm5J9QjPPhkPuSw6OTl9FP
         aknGkaO0+XhRHwry9vqrhr8OlGwhfsjNZv/31ym0oOAIRYbb7ciHqqvnxGGy3YPy9mYh
         HEUA==
X-Gm-Message-State: AJIora/zBBFSOrmM3e4Y7uwdDPnRHl8xZ1TKouujs/PEcQCo1gHd3sXC
        V6VPlDeAulllBnBTkBt43aPq8lahO+Q=
X-Google-Smtp-Source: AGRyM1sOR6OpSgIunQA2gYbpxZuaMZv7NVdH16moXPiHrIlxosI4EeZc2C+LZIdCOk4TW1RJuwaVGOa2S74=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:33d2:b0:1ea:b599:9e89 with SMTP id
 lk18-20020a17090b33d200b001eab5999e89mr6427412pjb.88.1655239689874; Tue, 14
 Jun 2022 13:48:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:27 +0000
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
Message-Id: <20220614204730.3359543-19-seanjc@google.com>
Mime-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 18/21] KVM: x86: Treat pending TRIPLE_FAULT requests as
 pending exceptions
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Treat pending TRIPLE_FAULTS as pending exceptions.  A triple fault is an
exception for all intents and purposes, it's just not tracked as such
because there's no vector associated the exception.  E.g. if userspace
were to set vcpu->request_interrupt_window while running L2 and L2 hit a
triple fault, a triple fault nested VM-Exit should be synthesized to L1
before exiting to userspace with KVM_EXIT_IRQ_WINDOW_OPEN.

Link: https://lore.kernel.org/all/YoVHAIGcFgJit1qp@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ---
 arch/x86/kvm/x86.h | 3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 63ee79da50df..8e54a074b7ff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12477,9 +12477,6 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (kvm_xen_has_pending_events(vcpu))
 		return true;
 
-	if (kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu))
-		return true;
-
 	return false;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index eee259e387d3..078765287ec6 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -85,7 +85,8 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu);
 static inline bool kvm_is_exception_pending(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.exception.pending ||
-	       vcpu->arch.exception_vmexit.pending;
+	       vcpu->arch.exception_vmexit.pending ||
+	       kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 }
 
 static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
-- 
2.36.1.476.g0c4daa206d-goog

