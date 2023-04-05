Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F846D71BD
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbjDEA7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235877AbjDEA7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:59:16 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1283B1BEF
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:59:14 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ip12-20020a17090b314c00b0023f7dfb7d7fso10757401pjb.6
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680656353;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=70lfVUlPCPagCg2ooY5jKLsFFHMwyHFCsk0vJZsjv0w=;
        b=GvMVOugbuvpF4VfxRxRH7BMy94jlsQ+YY0B6NSUUHC7IFIQ/53vI9PYVDjTCZyh1q1
         3sHBs3rsR9wGxGtXy+apPYMQ4szt2vNTnt2K7BfG75EYDFqM9nyU2laiZHMBtXppgcYs
         K3sB6YTFGQ2luOmBgLzg5BYZ13voh6docPl91c/YsGeqnX9Yd6wWa+UlJh5LU4htVyAf
         XgQysxaXIzJIQasx0EcTAtVbKmiQlIiStA5Ue3Ewkg1d20kXI7WXYKreSR9PkKYLWFyb
         bjbb9p5B61yXvKaJ5rCWXwC6lSBO3GTdETNa/yhSsNmj5CukCL3VTgwgXjHvDI3MSIPV
         rqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680656353;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=70lfVUlPCPagCg2ooY5jKLsFFHMwyHFCsk0vJZsjv0w=;
        b=CqlD0wn5hxWhQHGkD5Df+MC2h0XUnCQOodeJMR+EyIwRglOa2pXRYtYNhFSgNTCAKm
         X7Qp19d8dHj714EALv2axPMeObWMJvvZP/F/6KtkzWmE8EYvTLslqYEq8SYKR+Y4jq9R
         1nogCI7Oyw22l1N2m1Y9YVObqdAkMGwfgGa/mat/0ZRCj3tEqtIOpBHZwencFAKxTC5V
         cgzGKQPNr91TLHFkzVgIl4DxWlB05KJua1YpSgL89z56JzZJR67zBFjpUi68pNW+YeKU
         Kf8of2blnz0fGwVV3d9T47z43uNQ2OW6GA4XXVbX98naaWRDK/QOFeRzrL+gX8qGICLZ
         w7EA==
X-Gm-Message-State: AAQBX9cEBwbHZ72mfeN6ihIxkf7tborXOTAMZ9PRN4f2B3wRMN269UI9
        9+PVaXgBW7FJ075aNcZIffet4yJoz8g=
X-Google-Smtp-Source: AKy350ZsO76qd+cP/ybsPPLRdCSD15b6+ej6Yd077JwrtNsf1k6KpfrN/H+3n9CAyVnWDRAtcbAIcitozy4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f307:0:b0:50c:bd0:eb8c with SMTP id
 l7-20020a63f307000000b0050c0bd0eb8cmr1369620pgh.6.1680656353539; Tue, 04 Apr
 2023 17:59:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 17:59:08 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405005911.423699-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

*** WARNING *** ABI breakage.

Stop adjusting the guest's CPUID info for the allowed XFRM (a.k.a. XCR0)
for SGX enclaves.  Past me didn't understand the roles and responsibilities
between userspace and KVM with respect to CPUID leafs, i.e. I thought I was
being helpful by having KVM adjust the entries.

This is clearly an ABI breakage, but QEMU (tries to) do the right thing,
and AFAIK no other VMMs support SGX (yet), so I'm hoping we can excise the
ugly before userspace starts depending on the bad behavior.

Compile tested only (don't have an SGX system these days).

Note, QEMU commit 301e90675c ("target/i386: Enable support for XSAVES
based features") completely broke SGX by using allowed XSS instead of
XCR0, and no one has complained.  That gives me hope that this one will
go through as well.

I belive the QEMU fix is below.  I'll post a patch at some point unless
someone wants to do the dirty work and claim the patch as their own.

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6576287e5b..f083ff4335 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5718,8 +5718,8 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         } else {
             *eax &= env->features[FEAT_SGX_12_1_EAX];
             *ebx &= 0; /* ebx reserve */
-            *ecx &= env->features[FEAT_XSAVE_XSS_LO];
-            *edx &= env->features[FEAT_XSAVE_XSS_HI];
+            *ecx &= env->features[FEAT_XSAVE_XCR0_LO];
+            *edx &= env->features[FEAT_XSAVE_XCR0_HI];
 
             /* FP and SSE are always allowed regardless of XSAVE/XCR0. */
             *ecx |= XSTATE_FP_MASK | XSTATE_SSE_MASK;

Sean Christopherson (3):
  KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0 restrictions for
    ECREATE
  KVM: x86: Don't adjust guest's CPUID.0x12.1 (allowed SGX enclave XFRM)
  KVM: x86: Open code supported XCR0 calculation in
    kvm_vcpu_after_set_cpuid()

 arch/x86/kvm/cpuid.c   | 43 ++++++++++--------------------------------
 arch/x86/kvm/vmx/sgx.c |  3 ++-
 2 files changed, 12 insertions(+), 34 deletions(-)


base-commit: 27d6845d258b67f4eb3debe062b7dacc67e0c393
-- 
2.40.0.348.gf938b09366-goog

