Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36595A718B
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiH3XRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiH3XQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:16:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EC6558E7
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k126-20020a253d84000000b0068bb342010dso847063yba.1
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=/leTTfx+tYGUV20b38Vn3CO6vARPbHwJ64uO0txcnTA=;
        b=WLC90H12sf6WqFQfaKUgHPqCVgt+zRiHUQdeDttwimVBeBarQp+yBSLUEaGiUFUR//
         +KsUCEknT8rhNqesVvp8PeQgjvnh8C3OpaQvnbqRwY/NqXNkB/u8iy+u4dDM9/4/e8Il
         fGNTiWDY/+dlovqp96EsGC/xZtDcGzDNQXckiYyMFSL14y1SAVm6iriu1N8+dC9f9ZLv
         ohbKHDDh9+vIjKBq3Vd7ebfFogGRFoUuExgre4AymuPvAF2VQEnjTqn9kZUXrKAv2+EB
         TqcRPgz/CsyDpxZYSQ8qkf3nuH/cRWImDtsuEPiypEwceQsWcBI7IReVBMWKjilI4UCI
         mTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=/leTTfx+tYGUV20b38Vn3CO6vARPbHwJ64uO0txcnTA=;
        b=NEw9YH6cfEfrhkIK06BsIVZBsMMzmpSnvP0Vat4mKBt/PO4af/LN+UMmilaWlAE9fq
         8CUKKMVbacC6jPmYf4kJjkbHOPwBrBg6I5dz0MwSbagzyrBJVSNw4p+WrV1+yFZfeBSM
         2cJJOcv2UslowGOPgKqr6fGYGbq9+vrVsnIaiI5x4HYaRQ4Hr6qm5VzVR9Zm9ajxoJ2y
         zgsJ1EemJ/2orJvIrqg0ci4Yar15MHUaeOHlN4Ub52auKwRMQiVD/eDrqK3Ya5kRLk4a
         zHwVWkrarOwPFNtrg+zPYD+bvdRXfhMOFdQ5KXo7zmHXB+UcxQo17wBjzUbz6vugPGWO
         HDuA==
X-Gm-Message-State: ACgBeo2+JPVacCAx8kJkQVJ1zIyQHwy8kY6Mv6hApKAwwTNVSLYkmS1n
        +nX/Ke+4a6/e9x9icK0zvJlfEt868pc=
X-Google-Smtp-Source: AA6agR7wTFF2kwxnrSHkfUK9uKFIyJtRm5OhD26Vk649tRzd9fsQh0QhSqCS0giw3BAfZUUAxB9jIt9pfp8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b71f:0:b0:340:eb70:54c2 with SMTP id
 v31-20020a81b71f000000b00340eb7054c2mr11812408ywh.404.1661901380159; Tue, 30
 Aug 2022 16:16:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:15:49 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-3-seanjc@google.com>
Subject: [PATCH v5 02/27] KVM: VMX: Drop bits 31:16 when shoving exception
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 11 ++++++++++-
 arch/x86/kvm/vmx/vmx.c    | 12 +++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ca07d4ce4383..2ca8f1ad9c59 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3827,7 +3827,16 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
 	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
 	if (vcpu->arch.exception.has_error_code) {
-		vmcs12->vm_exit_intr_error_code = vcpu->arch.exception.error_code;
+		/*
+		 * Intel CPUs do not generate error codes with bits 31:16 set,
+		 * and more importantly VMX disallows setting bits 31:16 in the
+		 * injected error code for VM-Entry.  Drop the bits to mimic
+		 * hardware and avoid inducing failure on nested VM-Entry if L1
+		 * chooses to inject the exception back to L2.  AMD CPUs _do_
+		 * generate "full" 32-bit error codes, so KVM allows userspace
+		 * to inject exception error codes with bits 31:16 set.
+		 */
+		vmcs12->vm_exit_intr_error_code = (u16)vcpu->arch.exception.error_code;
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9b49a09e6b5..7f3581960eb5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1695,7 +1695,17 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	kvm_deliver_exception_payload(vcpu);
 
 	if (has_error_code) {
-		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
+		/*
+		 * Despite the error code being architecturally defined as 32
+		 * bits, and the VMCS field being 32 bits, Intel CPUs and thus
+		 * VMX don't actually supporting setting bits 31:16.  Hardware
+		 * will (should) never provide a bogus error code, but AMD CPUs
+		 * do generate error codes with bits 31:16 set, and so KVM's
+		 * ABI lets userspace shove in arbitrary 32-bit values.  Drop
+		 * the upper bits to avoid VM-Fail, losing information that
+		 * does't really exist is preferable to killing the VM.
+		 */
+		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, (u16)error_code);
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 
-- 
2.37.2.672.g94769d06f0-goog

