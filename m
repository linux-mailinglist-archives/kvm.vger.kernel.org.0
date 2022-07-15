Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC22157685F
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbiGOUnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbiGOUnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:43:03 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBE788F1B
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:48 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id g2-20020a17090a128200b001ef7dea7928so3492215pja.1
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=liAaUig9e0Cr1DOkUSsRBP3sqraN0c1NE6Fb89OWpOk=;
        b=ZA3GLiG8vAIb5vtxA72D+lcqlm5AUpAo2aNjZhXjwP2fh4bAQHo/0h43sZmI3KFzAr
         4xSYMwBO+O6+y65tQfQt/TfgMiIOfy0LZnuMsRhLYH33Ox/8hH0cv5qf3sRvhY19tvNS
         azyrethwyQOg8jD1Dea1lPlo4zQ07KeOP3LAwrFAJ5fbq/DsaAMwsVixX/jtWZ+9VsJX
         Za+lqOkppCejZwxD3sV50kG93XvEct5IW7GNUKZBDzgyY2uEF0afDXND7PbUwAh3sM/Z
         EQFyv/2wuP+fOtDKNaFWSrViMXNk+NUYq4G7NlxWZsx4Mkg/dRDv7dM48VejxCIiPDkz
         VYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=liAaUig9e0Cr1DOkUSsRBP3sqraN0c1NE6Fb89OWpOk=;
        b=IIJ777nEr2/Zdq6TGbFU/8sLye0kw95QqZYcJTOQAImTsqrJwbtUiKWJSyzsZvigmf
         xtpmQAMgHvNi3HR8uxff0rNnkg49MBv/eyhjjvaeUh2pVXu5HRR6X8nNR/XvPcfunjGt
         5mBsbiT/dB3I34rA6jnpXLLaMzQ2V+hIvIqLqB5+/jiGpZs/aT1sqaFk+IVFCtB08vga
         H3mLBxoH+B919lUQ71hZKyeMdYskHsI6aW5P0fpBlAjJ6sUG6HjYaMKgR3F+jaMERBgu
         yerGjVFAeRx8WB+1Q/ew7MOw4MtX4Xdc+4bs/2WUsqGn1YYoJ3n0QBEsyOl4LfOQSDSH
         IFMA==
X-Gm-Message-State: AJIora+4JAI2xaaZ9GLNNaSgYNhjCKPFYw4yvWKJ5HdUjgD5DyWZd8YA
        aaVlwK5Wj25SxWvMMczmFvboUWEYRHQ=
X-Google-Smtp-Source: AGRyM1vFsr5VZGLYhoBiX3ZAXQYUYYRCOwRBRjGhs34dr796HCyIH34dh0X0i+a/wRdA36tGfPT3pNjjWsw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr911667pje.0.1657917767504; Fri, 15 Jul
 2022 13:42:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:10 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 08/24] KVM: nVMX: Ignore SIPI that arrives in L2 when vCPU
 is not in WFS
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

Fall through to handling other pending exception/events for L2 if SIPI
is pending while the CPU is not in Wait-for-SIPI.  KVM correctly ignores
the event, but incorrectly returns immediately, e.g. a SIPI coincident
with another event could lead to KVM incorrectly routing the event to L1
instead of L2.

Fixes: bf0cd88ce363 ("KVM: x86: emulate wait-for-SIPI and SIPI-VMExit")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc5759f82a3f..104f233ddd5d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3925,10 +3925,12 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 			return -EBUSY;
 
 		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
-		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED)
+		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
 			nested_vmx_vmexit(vcpu, EXIT_REASON_SIPI_SIGNAL, 0,
 						apic->sipi_vector & 0xFFUL);
-		return 0;
+			return 0;
+		}
+		/* Fallthrough, the SIPI is completely ignored. */
 	}
 
 	/*
-- 
2.37.0.170.g444d1eabd0-goog

