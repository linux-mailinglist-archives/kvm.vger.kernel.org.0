Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318F43C74F6
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbhGMQiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbhGMQik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:38:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352D1C0612FC
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:35:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h7-20020a5b0a870000b029054c59edf217so27720902ybq.3
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wiSZeaOJz6E5eaSw6IcwZw34ds4nUby2LO6OctxjAfc=;
        b=JlLgNaatfTImrlLKDteCXIQCOvCb7D/zd/Eu4BP8cEmHg7r7VjKchWZkJwwyg08wAe
         aCHxM1JMig6P15Ukgg4qRI7XmC0/FhSLV8og8HvomKXEpPzVYK7x7byEbdHBk0cjwrMy
         BhSwQF2jP7TF/4PczCGUhGmF+ICPxtxma149TzwxP8LwjQ/5/UpPeSZIYCBExWDGAKxH
         gg7yF4UJOwYieLGaWNNPWQzqOqraVbPqBexeoeQlBg3WqgQ/pMjMIxmc3veB8GR7Twx/
         +SOXWsMXyaRaLIQRiEZWiF+lTDWhzNx4F0M9LHtA8itikEIR1y1klXAV8e4S2pYVZ9cQ
         Uc+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wiSZeaOJz6E5eaSw6IcwZw34ds4nUby2LO6OctxjAfc=;
        b=Fi+7S1SQKLixRNndoipXi/JYKyy7xMso3Kucz7WJAjZJte3yWlxqp+nLzrKNKp6njM
         6UK+BL8fbmgZaNb+v5CNlnN+cgpzRZEnlLxpfecbTJcZ5OvRTGXKDDYPs9z3S0LfQJBy
         J6+xZ/m/4bTBSGApnFNZaP0ix1sCwGwptONBg7ra7dhGoPl3qDZNLghFbYEc1eIl2Xs4
         pS5L5mA96wsKt1C1iPriso/tDUe+my7D+jHogHO/ZaSRz2rf1dBhiqs3rA6ad53ebRD8
         0QXgkzxhlhmihaPzZBIHcIDMiZ2Bpe5vn0MqHdw3R/CSG9cx3cwXfA0KHjcru1TxFRxs
         SegA==
X-Gm-Message-State: AOAM530FHKm6yi0sov6YiYQzavFG7WYuYdIPWO25nak38Kf4PPo+y+TU
        xrE1jAMy3Q9Kv5slsXfpKOaMnKoZLzU=
X-Google-Smtp-Source: ABdhPJyBvicK0PC23syQ0zjJevsQ+gDXEZvCcjh5Ouah2do0HAGsJSUY+5MMhTO6SaMMg+0yinBYAWXikpA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:afcd:: with SMTP id d13mr6691400ybj.504.1626194099437;
 Tue, 13 Jul 2021 09:34:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:22 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-45-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 44/46] KVM: SVM: Emulate #INIT in response to triple fault shutdown
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Emulate a full #INIT instead of simply initializing the VMCB if the
guest hits a shutdown.  Initializing the VMCB but not other vCPU state,
much of which is mirrored by the VMCB, results in incoherent and broken
vCPU state.

Ideally, KVM would not automatically init anything on shutdown, and
instead put the vCPU into e.g. KVM_MP_STATE_UNINITIALIZED and force
userspace to explicitly INIT or RESET the vCPU.  Even better would be to
add KVM_MP_STATE_SHUTDOWN, since technically NMI can break shutdown
(and SMI on Intel CPUs).

But, that ship has sailed, and emulating #INIT is the next best thing as
that has at least some connection with reality since there exist bare
metal platforms that automatically INIT the CPU if it hits shutdown.

Fixes: 46fe4ddd9dbb ("[PATCH] KVM: SVM: Propagate cpu shutdown events to userspace")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 10 +++++++---
 arch/x86/kvm/x86.c     |  1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ea4bea428078..285587a7fe80 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2058,11 +2058,15 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	/*
-	 * VMCB is undefined after a SHUTDOWN intercept
-	 * so reinitialize it.
+	 * VMCB is undefined after a SHUTDOWN intercept.  INIT the vCPU to put
+	 * the VMCB in a known good state.  Unfortuately, KVM doesn't have
+	 * KVM_MP_STATE_SHUTDOWN and can't add it without potentially breaking
+	 * userspace.  At a platform view, INIT is acceptable behavior as
+	 * there exist bare metal platforms that automatically INIT the CPU
+	 * in response to shutdown.
 	 */
 	clear_page(svm->vmcb);
-	init_vmcb(vcpu);
+	kvm_vcpu_reset(vcpu, true);
 
 	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3aa952edd5f4..f35dd8192c32 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10901,6 +10901,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (init_event)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_reset);
 
 void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 {
-- 
2.32.0.93.g670b81a890-goog

