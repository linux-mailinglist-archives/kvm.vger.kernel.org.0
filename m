Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F116D71C1
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236713AbjDEA7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236688AbjDEA7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:59:23 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6A21BEF
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:59:18 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n13-20020a170902d2cd00b001a22d27406bso18494071plc.13
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680656357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/LlxEKk640KODqyIXhxgneIbkJJUkcc+ai741c33zE8=;
        b=UNFKuAHYj2mFuBI2Q/+O3KVQ0ZS5y6NNYC6EoMkQXyoAlpDwwWmh2xswrRJLTcF4UE
         PRwO0hnL5DSc/bdyWhXa6RL/tPpQt+UB35gEI4DkaXbxVfgJ4mlG8aaJWu4gDWPLCHLz
         itsfBduIOCypfCPOQH2koafLF+sRhreYKTpUG1hX30XD7PZ6p2lmUTHm20GXbYeHKsx8
         tnxKAdPd04iLrkr/7U4ClEfEd7JjpaB1qp2B8Bo8gz6mLr48TebLwBdw/6L0G30SHCGN
         L0yHlPucDMThI8erO/qRmpf9icQ7gdhJrLnOjhfJ+WZ5f+SXF9QJi3SKFydYeinyshkT
         dZtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680656357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/LlxEKk640KODqyIXhxgneIbkJJUkcc+ai741c33zE8=;
        b=QlCWGPN8t/1WwdRL4U7hv2LCWBZI4GAMCTdrLmcJsEH6pZRC/Qh1PSdlnhwJVdygwu
         8iN/PMiheYbP55m8PM3Kt7zYR2/vQKBu3TNgvoCZxOA3ovCuvcbreJG5DyIimn7/M6tx
         adMN3E13DUN4GhYwEJOQxL0iDd1KqNgLyuS1cW5h9owj4WbKGAq1OqAeeoFeWF7NonKl
         LH3pL+aVFcMthQ93Ia43ZbJgufkhaNGN0L5oHiWM8xK1YYes2VkoI2Y1nSHSCBhvqUKE
         H22l134jC2MZks0cJfoIHdi7DUBkZSo60p5YAgqO+Pkh6lTQhFnVUG09ts/FPsVoc3a1
         OjEg==
X-Gm-Message-State: AAQBX9fiZc2zSkX833KIaXD3p8iX6sv6BT4OWpgYWDezrZbD0/nRJohv
        bM0wZFP+Q1QkAzC5VlTiQ3IpViJiUis=
X-Google-Smtp-Source: AKy350YCSwsgMepLpJrPs+q3saso46a65PtfgrMxb+8i3hWXKcMkCMsmZ0/aYcPqs9Ysfb0RhdiJyCq0/ps=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:4c88:0:b0:513:92e7:4555 with SMTP id
 m8-20020a654c88000000b0051392e74555mr420188pgt.4.1680656357670; Tue, 04 Apr
 2023 17:59:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 17:59:10 -0700
In-Reply-To: <20230405005911.423699-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405005911.423699-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405005911.423699-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: x86: Don't adjust guest's CPUID.0x12.1 (allowed SGX
 enclave XFRM)
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

Drop KVM's manipulation of guest's CPUID.0x12.1 ECX and EDX, i.e. the
allowed XFRM of SGX enclaves, now that KVM explicitly checks the guest's
allowed XCR0 when emulating ECREATE.

Note, this could theoretically break a setup where userspace advertises
a "bad" XFRM and relies on KVM to provide a sane CPUID model, but QEMU
is the only known user of KVM SGX, and QEMU explicitly sets the SGX CPUID
XFRM subleaf based on the guest's XCR0.

Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6972e0be60fa..d28c4fb14d43 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -253,7 +253,6 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 				       int nent)
 {
 	struct kvm_cpuid_entry2 *best;
-	u64 guest_supported_xcr0 = cpuid_get_supported_xcr0(entries, nent);
 
 	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 	if (best) {
@@ -292,21 +291,6 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 					   vcpu->arch.ia32_misc_enable_msr &
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
-
-	/*
-	 * Bits 127:0 of the allowed SECS.ATTRIBUTES (CPUID.0x12.0x1) enumerate
-	 * the supported XSAVE Feature Request Mask (XFRM), i.e. the enclave's
-	 * requested XCR0 value.  The enclave's XFRM must be a subset of XCRO
-	 * at the time of EENTER, thus adjust the allowed XFRM by the guest's
-	 * supported XCR0.  Similar to XCR0 handling, FP and SSE are forced to
-	 * '1' even on CPUs that don't support XSAVE.
-	 */
-	best = cpuid_entry2_find(entries, nent, 0x12, 0x1);
-	if (best) {
-		best->ecx &= guest_supported_xcr0 & 0xffffffff;
-		best->edx &= guest_supported_xcr0 >> 32;
-		best->ecx |= XFEATURE_MASK_FPSSE;
-	}
 }
 
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
-- 
2.40.0.348.gf938b09366-goog

