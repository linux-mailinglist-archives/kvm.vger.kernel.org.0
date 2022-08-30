Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113005A71B2
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiH3XTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiH3XS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:18:28 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7780A2DBC
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:54 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k3-20020a170902c40300b001743aafd6c6so8876650plk.20
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=apaMWeewgN9SCKsQ/b/x81peVp5WzIJeQ3d9tZS54uU=;
        b=J+/GqW68OWNVKsMUQ+Lm/NRPGm758Ko4Ru4CXb6/G3anRjQUb6/vNI3tnjNs9oXpX4
         bM1dqEIh6orkqQ3z+LgS+V1uvGpmznQU5UCg80EYopA/Zm6ag1cTYRit8WAGa9c4wOZ0
         jRsFwwMq8yPLQXI+cqyXHezofIqCk/Z3omr+dQrZNIW9oDZOIjQQ5ryghXZruFKM+EqF
         YepkUY+wC+rPsuqGJzqltlx4G9a13zBIMj77oGRvpwInWgH3PbXezmcDyHxJuX6msqn1
         U4i4diAfENCHPHSvnvoPer8kXM1O2vnkOEbg0/j979DVDO+OL/VnX6sRnqDamEuh+283
         v+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=apaMWeewgN9SCKsQ/b/x81peVp5WzIJeQ3d9tZS54uU=;
        b=6Xn3/1YXBd04K0NzDIyHAsV4aW9mjNleQNOiV2uszmJPWfNK94EuZGSXDZV7QVvvjj
         gE9VFfY4AD7Unolg3sg5KxlI9Ci4j3qfYOisBW3o57HpMZBnfsFzIe9kBXw7dWPDPLiv
         C81uqyErfiGnxRLLik20rrn0yw7/PzaeXKBA704bE7SOhnXY70gyp5tBu/dJXRemMvtk
         6gAgN6oyFZq4mXIbgtMsqrvqZXdA0V17C5FfWtRlZK9F3y535Ag/reCMiHM6zaLtXy0d
         ppg6pVnNyMyuXI+cPhOvmJ9c4lPKXwebGrT3QeLoAy44aYcujjCw3kk8WL/gDn+wUt5X
         D1cw==
X-Gm-Message-State: ACgBeo1NEi08KarVxgjLGBhZgRVKy8pQYdUJ2IpWaoS9EO6ug9lXfQmh
        HL9HFPJTrBt0Gh6uxrmXiHlEvCbRa50=
X-Google-Smtp-Source: AA6agR4alFe/DlTkXRLpDZwZxXKY0c/bfpZS/WVRRuTfpQiWlJZ0s/3NKDpT/OTDRZjA4VcP+2ZSnFSHGAw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr11325pje.0.1661901413850; Tue, 30 Aug
 2022 16:16:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:16:09 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-23-seanjc@google.com>
Subject: [PATCH v5 22/27] KVM: x86: Treat pending TRIPLE_FAULT requests as
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index 17cf43ca42c3..d004e18c7cdb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12742,9 +12742,6 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (kvm_xen_has_pending_events(vcpu))
 		return true;
 
-	if (kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu))
-		return true;
-
 	return false;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 256745d1a2c3..a784ff90740b 100644
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
2.37.2.672.g94769d06f0-goog

