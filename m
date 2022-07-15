Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AE157685A
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiGOUmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiGOUmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:42:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F5787373
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n192-20020a2540c9000000b0066fca45513eso4470474yba.0
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=EPwdfsc9LMe3xaxT7rQ2AwZ4mWZYsqTIzZwyJm21GaY=;
        b=hTQIEhNtwLcDTjuYElsz5q0eL249pESLhJ8EP2qPrdhFWAWD6W4lbyapYiA0Fp+y2h
         PqHx4qe9jc0K0fC8jJRNl2z5NXcy+FXNQFYnGbYMLcDt0P1UYL/OTXvp66EWn2xIAgvk
         J9ST5jj1zPPqHCAyn35zODw0XqDdQeHBiOcHWQuW3fr9YMXrhR1BBMv6PXgoUE6n0Umu
         3X2MJwOc/DTaDbDpKm8WAMZXAeO8bVxa1PsPMxu9Ftd42dqJRNaCyslc7WQYq83VDDU+
         jFlMt6ixZtv82rPGvEISQwQkIKT5n4+34EKeVGT2x+HR1ADC7t5zzQc5BhNSE4Kcf40V
         qk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=EPwdfsc9LMe3xaxT7rQ2AwZ4mWZYsqTIzZwyJm21GaY=;
        b=hl4eljLR4uWLCgz+KInVXApav0lIO+3q75ctrRvAv0GHHizBereYX5Zta9nSViPpXq
         /hxGnRcG+VjURk8rF26UMXZ9p3Zap6TQpQH5S+L7MZeQwcTVFG5Uomj2NvkpQb4xe34t
         82mqxYw0FKuCHPGfHhAKMUsI18+BQ/Df9DuQB+Hn8GFTaJOrhvEu9EWkbT7uww3Jcfum
         mL0NRq8oX2n/L71RimUWc7pV1ANOnJCwXbo40boApbRDM7iTT1dkegL4FgLLdSP6EWYq
         TIDy64Ztrl4MWeT2lWTFBJxIQ5bLN9IFZp336zzpKSyDQrFnTo6RWpjYSWlLuxb7f9/V
         zb/Q==
X-Gm-Message-State: AJIora+s4dkxSxwin+kg54MVMdjlMnVeeSJI+vWQ+doZNL7XRvnhWxJi
        kTDhhlLljF7r8uV8JFvZMy9gGbCVFp8=
X-Google-Smtp-Source: AGRyM1u6UpHh1N6KxJP2MAnf+tpvcvYp7Qkv9jqJ8abXF3dxaUvhIvXuqu2cY9+l6GUJZ+BhsNo+O9zcFNA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ca88:0:b0:66f:f681:4c3a with SMTP id
 a130-20020a25ca88000000b0066ff6814c3amr3426982ybg.582.1657917757506; Fri, 15
 Jul 2022 13:42:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:04 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 02/24] KVM: VMX: Drop bits 31:16 when shoving exception
 error code into VMCS
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

Deliberately truncate the exception error code when shoving it into the
VMCS (VM-Entry field for vmcs01 and vmcs02, VM-Exit field for vmcs12).
Intel CPUs are incapable of handling 32-bit error codes and will never
generate an error code with bits 31:16, but userspace can provide an
arbitrary error code via KVM_SET_VCPU_EVENTS.  Failure to drop the bits
on exception injection results in failed VM-Entry, as VMX disallows
setting bits 31:16.  Setting the bits on VM-Exit would at best confuse
L1, and at worse induce a nested VM-Entry failure, e.g. if L1 decided to
reinject the exception back into L2.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/nested.c |  9 ++++++++-
 arch/x86/kvm/vmx/vmx.c    | 11 ++++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8c2c81406248..05c34a72c266 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3822,7 +3822,14 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
 	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
 	if (vcpu->arch.exception.has_error_code) {
-		vmcs12->vm_exit_intr_error_code = vcpu->arch.exception.error_code;
+		/*
+		 * Intel CPUs will never generate an error code with bits 31:16
+		 * set, and more importantly VMX disallows setting bits 31:16
+		 * in the injected error code for VM-Entry.  Drop the bits to
+		 * mimic hardware and avoid inducing failure on nested VM-Entry
+		 * if L1 chooses to inject the exception back to L2.
+		 */
+		vmcs12->vm_exit_intr_error_code = (u16)vcpu->arch.exception.error_code;
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b0cc911a8f6f..d2b3d30d6afb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1621,7 +1621,16 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	kvm_deliver_exception_payload(vcpu);
 
 	if (has_error_code) {
-		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
+		/*
+		 * Despite the error code being architecturally defined as 32
+		 * bits, and the VMCS field being 32 bits, Intel CPUs and thus
+		 * VMX don't actually supporting setting bits 31:16.  Hardware
+		 * will (should) never provide a bogus error code, but KVM's
+		 * ABI lets userspace shove in arbitrary 32-bit values.  Drop
+		 * the upper bits to avoid VM-Fail, losing information that
+		 * does't really exist is preferable to killing the VM.
+		 */
+		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, (u16)error_code);
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 
-- 
2.37.0.170.g444d1eabd0-goog

