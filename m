Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79832576863
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiGOUon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbiGOUoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:44:11 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E2E8AEDD
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:22 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y10-20020a056a00180a00b0052b10093100so2821992pfa.4
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=f7C9BOS2/kNLFTWQrXL7bHngLZ8phYr/WbuTbJNfR5w=;
        b=llH3S63tSAQnIOQdGqubGv+d8GjWNxL00GbpWlBJUh5Ye3v80EjzMwgN8CpnkJp9BX
         00LOenTsP4isu9nZa2OQTB3xsO4WX+b5ALP4jPaYWE/rsqYcON7ame4f0aP5ULKxS7pj
         je5RxMjRllgjegdt+5W8+CgqxmtiaeLXekFHvFyrO2pWPeyZzCMFhfrZ4InQyCzmaONE
         MOwOB7x1kAbSKvW7MzRqBec9I3VlABIzK5+HJBiTawgWO7i1TDa3EXuKpE2uAkk39fkj
         8Lhn0wptuP5JaQegJ0elOYBor9gp4wo8F0ayjvrNebCTISZgA58eELILjPpgtTZcuVOB
         HAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=f7C9BOS2/kNLFTWQrXL7bHngLZ8phYr/WbuTbJNfR5w=;
        b=Cbaj4bWWQ7uIHDwwecqbPCOKVREzvEm8TeLn9e+nZiJdA5c8jIfSZE5taqnAMrIiHp
         CMmk+xn6/z+IHWrcCQrDKD6irOqqu79m6yMCbB/rFhZ5xE98LQcQbyQ6raEdDfMwZv8+
         /de/DjSgD6TiScbrerlTnYJ+yWWcU5hx+vWwNKbqpENXECqdtPpcE3kWvapw5smsIfQy
         p7XCWavtxJ9lVXMhSELM3l7jFnAaF4EPuQJ4Op9wtjJPc9SvqJeYhPP11traiqz55fjf
         1JECNWhBOvDzfzAI5j4F5OEdj1iyi2xt64OP6YLGzWPd1GFAry3ztFb/4NhxuzD0C4sL
         gw3A==
X-Gm-Message-State: AJIora/FVUD0MokoUzI9qE4yS4VuBI9kh44Uh/OtB7crGC3UgFXPJQs5
        xY86ujWlmtBHks7eMp5vEL9o+dqlpro=
X-Google-Smtp-Source: AGRyM1sWzrbrBxSvYJ8c/JrMM4XV+RVTOILVCQ6TPhPc4euSLLHO1WRW91TjGVkXO1LMU4rUnfD0w7nylbg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1908:b0:525:5dad:cb1c with SMTP id
 y8-20020a056a00190800b005255dadcb1cmr15832951pfi.47.1657917787781; Fri, 15
 Jul 2022 13:43:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:22 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-21-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 20/24] KVM: x86: Treat pending TRIPLE_FAULT requests as
 pending exceptions
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 3 ---
 arch/x86/kvm/x86.h | 3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9be2fdf834ad..b924afb76b72 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12644,9 +12644,6 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
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
2.37.0.170.g444d1eabd0-goog

