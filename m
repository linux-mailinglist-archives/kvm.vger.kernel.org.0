Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9EE69B63D
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 00:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjBQXKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 18:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjBQXKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 18:10:39 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44EB692BE
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 15:10:32 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id y33-20020a25ad21000000b00953ffdfbe1aso2047614ybi.23
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 15:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kJiU495PRP5A5yKfuE+SWyHAevKRlJJJV0/9mgyLCwE=;
        b=gGRP8xLIV88x5+pesHlVSzH3eaURYkYcw9vwHWwO8otNJ8uT8UFPqg/GOY5panNWVn
         kEGeFIyz5hBE74qRNMuhJA2YZcEyKw5HhR40IEfFVJ4HTvJl44BCvkzPRoPslCZ5v9FP
         i97P7A81huZghUvo0ONVhCtFQbCKNfVmmM5gxglAxn67NPCcV8uQ/2eXhMgJ1gRGRmNw
         XpuDim0RFlBUosrevfxb+JUDXdtgrk8gobMn7ujgLNpTw9we+jT9m+OikOKQOpl9Auix
         op9EYj7vbSG3oMCuvGHNuRM7gbVKBqp7bTGgvZwEqv8quf47MYGRFfprbJalGiMKUTBL
         1yaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kJiU495PRP5A5yKfuE+SWyHAevKRlJJJV0/9mgyLCwE=;
        b=G5piPcu2uZCVuovMi3UgGIRvqJsWOC4uKc9+kwQyVVd95JPi/UAtpHjBqUuUDdH6Bz
         mj/R2PiWGO0wlTjAuWRToqhVIM16mGa6P5rTCkILAVID5XJ8cKzPFC1iqG1LDHWq937A
         2VyO+DrKcE1Io2M6PtRTFSf4vLiJWmtj1G1vfCiz5JcBx4xjFr19gyKB6hdpekHDd8gY
         CEi6fCS88h0V4CYKnmmltUGV6lLtRn7z5kQh073WVurMEwaVGhClhkLTn420reNPEjlQ
         7Kg2u4jm3/kLCMBQqmz0WQE3qCXWMKTXu3opMSR3CL5OdfaELCsnRE7v+bFQZ7GzZYzb
         W1rg==
X-Gm-Message-State: AO0yUKUZYJc3EOw4IGX+74gl/OubhPxCNXrICuKGsHkH3rzKeaK4Imea
        x/d3ESirjaMayeNmfDxOXjroeW1F61I=
X-Google-Smtp-Source: AK7set/6P/RBz9ydyNWe0LYN3vZl7Y1NK7LeQ8O5kyHRcxXD9i9uSGZ7Dxx1aMgRFxSd6+WP7y4o0y5F4y4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:7b02:0:b0:52e:d589:c893 with SMTP id
 w2-20020a817b02000000b0052ed589c893mr1365013ywc.457.1676675431997; Fri, 17
 Feb 2023 15:10:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 17 Feb 2023 15:10:13 -0800
In-Reply-To: <20230217231022.816138-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230217231022.816138-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217231022.816138-4-seanjc@google.com>
Subject: [PATCH 03/12] KVM: VMX: Recompute "XSAVES enabled" only after CPUID update
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Recompute whether or not XSAVES is enabled for the guest only if the
guest's CPUID model changes instead of redoing the computation every time
KVM generates vmcs01's secondary execution controls.  The boot_cpu_has()
and cpu_has_vmx_xsaves() checks should never change after KVM is loaded,
and if they do the kernel/KVM is hosed.

Opportunistically add a comment explaining _why_ XSAVES is effectively
exposed to the guest if and only if XSAVE is also exposed to the guest.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47abd9101e68..b6fdb311a7d8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4620,19 +4620,10 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (!enable_pml || !atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
 		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
-	if (cpu_has_vmx_xsaves()) {
-		/* Exposing XSAVES only when XSAVE is exposed */
-		bool xsaves_enabled =
-			boot_cpu_has(X86_FEATURE_XSAVE) &&
-			guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
-			guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
-
-		vcpu->arch.xsaves_enabled = xsaves_enabled;
-
+	if (cpu_has_vmx_xsaves())
 		vmx_adjust_secondary_exec_control(vmx, &exec_control,
 						  SECONDARY_EXEC_XSAVES,
-						  xsaves_enabled, false);
-	}
+						  vcpu->arch.xsaves_enabled, false);
 
 	/*
 	 * RDPID is also gated by ENABLE_RDTSCP, turn on the control if either
@@ -7709,8 +7700,15 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	/* xsaves_enabled is recomputed in vmx_compute_secondary_exec_control(). */
-	vcpu->arch.xsaves_enabled = false;
+	/*
+	 * XSAVES is effectively enabled if and only if XSAVE is also exposed
+	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
+	 * set if and only if XSAVE is supported.
+	 */
+	vcpu->arch.xsaves_enabled = cpu_has_vmx_xsaves() &&
+				    boot_cpu_has(X86_FEATURE_XSAVE) &&
+				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
+				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
 
 	vmx_setup_uret_msrs(vmx);
 
-- 
2.39.2.637.g21b0678d19-goog

