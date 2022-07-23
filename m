Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE9457EAD3
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbiGWAxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbiGWAxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:53:01 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE66C0B4F
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:52:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31e55e88567so50777367b3.15
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rUkhCIu3G6hVGxoVXeosOYZ1CHA90hebfQ0IThcWEiU=;
        b=dTZ9QzwbkjN8vSw1b4ZQ5CPuB06qdpj8gpR/RWuiDwzwolmGm5N2ePpnmceqHUUQJs
         0nvprNHcU9JI67sqPhhJ9qYMnNEg4CfTCUK6ckj2Ym7QAmsGTMhbqy3/0S20Z9ptyE6h
         dnibPvvvHJTvRqyMuC/92cRS/ORmWU8z2WBFq0cuGvUvII05DIAE0nr8zIn6gwwE9lNh
         idyu6gTKtu66P6QDBbqi6NUYlABPgUfQlT05+0xU/VjFswiz8N3hoFx7amWMziwUaTpP
         u9j4Xt4a13fHwgW8fmnG2cyeia1vvNLOhKteYh3ZLw5di772IK5Aqkil4vV2VfoWVIjL
         OIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rUkhCIu3G6hVGxoVXeosOYZ1CHA90hebfQ0IThcWEiU=;
        b=Lugsfwp6NnFXnliI0+EIkIib1ka3dUjOkcS9npUXNiT6H7AjCzsn1airU5nzFU+6uv
         BxD86jALrcQB7EpEu8Ge0Wyd3RRSj2HrbUAeMlrY1WL6XqePNDeublo4/xyP6DRSkYpz
         0IDtS6HO4EuPo48wPo545+kl7qVCmaTNVE3VGKDSKktoRmRD9l7gxoMTw49zL3PC4eaE
         59Y7cRt7dZ00BAhZvWZcUjRPI5y8LQtmjhwD6HgFMqL7C1bHS1e9S7HRcwOjac7nhbJY
         LONNlInhhMoB4m3vODTvqw7v99BsCF1DZDvWFd+k1GvwRkfiGtsbHToXWlcVzUXaBRBp
         DPOw==
X-Gm-Message-State: AJIora/fPLje5XOwaU7QFisrF+OTTdbV4yW9FjzpXIUZvb+0hkms4eAY
        KHBQTw2LCTKS1h2Vm8vZBL9WmTk1GvE=
X-Google-Smtp-Source: AGRyM1tLKMklWgQ8FNSImnL/X0u9s1C+BqiyV2k5uUxPZxT/XciQjfwMQBolnnSWQj3XA+G8cMoIrTEuWQ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b98c:0:b0:670:9213:4f8a with SMTP id
 r12-20020a25b98c000000b0067092134f8amr2136101ybg.171.1658537533909; Fri, 22
 Jul 2022 17:52:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:33 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-21-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 20/24] KVM: x86: Treat pending TRIPLE_FAULT requests as
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
index 6c77411fc570..d714f335749c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12657,9 +12657,6 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
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
2.37.1.359.gd136c6c3e2-goog

