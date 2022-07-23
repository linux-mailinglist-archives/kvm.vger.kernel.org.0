Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4291057EABA
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbiGWAvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbiGWAvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:51:47 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E07D13D7A
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:46 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id r7-20020aa79627000000b00528beaf82c3so2447685pfg.8
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=v9YL/H3DzLIILzqro/Rlg3LJnOCX+QvAwinAtI7kHXg=;
        b=gn5B7l1MV1xM263PvGhMVA5vgyKZt7Z4XHAuiFrUB2VZy6YH6ra5CcrARs/Y6iHcCF
         +4ZbVN0FULqDMLk1L7xjkrBBOmDMOSEVMq2Tf7EZIE0a2ArROgE64FGBHcIUjxv8URpL
         og2unMeMb9gJjgiufyZjcpQR1HlCebKsMysIMQUZC9k/71EMFGMeYDjBs8BHze6sVh5g
         TmNh521eGopMMmnCILeCw9ImkzA3WbKPWL1OuTtomlW8FRQELkpJCRzxh5OQtITnDExJ
         doVhpmUjxBLNUoOXV9TBsWLcMFCRx6wZkWUTUyZ6e+WTZ0njZPpsm6CQMx1hQ07o0bfn
         Mtiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=v9YL/H3DzLIILzqro/Rlg3LJnOCX+QvAwinAtI7kHXg=;
        b=jf12YWO/CniepCPUBAPlfp5SjposmRxAwlMxFILOC4K/BVQBdAmeTT8XXEaMkRhyTo
         SlhIv7I3KpCKu/XDHW1XHxDj6BZqKdJeoRSxioGqtX5y3IR8BQUpCeLzB2jtODa/HXOL
         DW9eHV/EzDTjnT2XSqCW65SVsCz8/EWWjIbBzMwOdXjlnWdO1lrHvws5UVXbOnmwWet1
         SQABrBfJNpD/xs2+EpIG7IoA3aKmeXsyrJEV1X7tT8tH9vthREJcAY/+NPenwz1eRNw1
         RLaeoycugiuwwQkYf9kC3T0HjYrvqP3GkGDvWcWBMuXhMPBR+IEXUYpBHS8UeoEWml1C
         DWVQ==
X-Gm-Message-State: AJIora9yW/LFC4Ou+imiQ7lnCGowFt6vWprKSKDyZ1SPKdg/zYA9XM4h
        jj6zU2RoGViWN9hCM+IAo4IStFom1kQ=
X-Google-Smtp-Source: AGRyM1ufY/lp5RZN+O14y0qhB6GMCXxqiD46hJ43a60IaDjAFWekqmkl9BFLXJMwvOiWlMA3Rc3YzkCdtV0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2401:b0:52b:cd67:d997 with SMTP id
 z1-20020a056a00240100b0052bcd67d997mr2490318pfh.70.1658537505696; Fri, 22 Jul
 2022 17:51:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:15 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 02/24] KVM: VMX: Drop bits 31:16 when shoving exception
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 11 ++++++++++-
 arch/x86/kvm/vmx/vmx.c    | 12 +++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a980d9cbee60..c6f9fe0b6b33 100644
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
index 4fd25e1d6ec9..1c72cde600d0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1621,7 +1621,17 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
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
2.37.1.359.gd136c6c3e2-goog

