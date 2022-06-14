Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951C154BC0B
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240108AbiFNUrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbiFNUrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:47:41 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C32D1E3FC
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:40 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u71-20020a63854a000000b004019c5cac3aso5482756pgd.19
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=u8bzNiBps6E2wSU5SkQtzvlTmzoTVHSDY5lFfXr39Zk=;
        b=NW/smZkiDd1uJ4BP5Z2HhFtWDNoo8oNHVv9ysPZG6omGQQshynXbpsBgtihy5M542x
         mwXglKnK2f2nwTv5CH3kFCD1UDuWlOElGHVpVE2G/8JtD3YQkgKB6lgReLoR8GfVa0/v
         6Y/HdUGgTvmwTUqcQeC1HOermxW17NFfypftkD+cMAQmCGOINwFC0iDLwJ0UOZpdvy0B
         LDrBdZnaRP5NsJHvfcxmdaDRZ6P7L5jcOVSl67ru+mE0T3H0x6OGKkDk4JlXlpX15oXK
         Xfc2ixz71VShPaTQPjHvTtzJaJzuxLBIhPttmyV/aWVswn9Po2Xwh8lcdPQFChj2SJA1
         K25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=u8bzNiBps6E2wSU5SkQtzvlTmzoTVHSDY5lFfXr39Zk=;
        b=nyoOtc1P/j3cbw/JNiGc/KaZSYnZkFzkZZ2E6rmsdmL/+Qvs4XbbIlEW7/Ut+4QX9G
         qAp1Z46qJv8kyzRV7DrlbMMDyJrkt3NVFr6xn4infXP+ORQgsLmr18D9wzq5Z56ZXyeG
         GOd1zKPhT1AkPQYXo1yzAVKFk8ecV1wgRUKdao0lUTEeOD8BhRTUOMonqP+tKnRsQ2ND
         pIwKWDcqN8fJSd+tH05WiDee4gbIPdYa4Tcv7IY7XaXj8BiTD8VNEqaTMQAQrVz7eDIn
         ZTbZRxMVMZQgbXTd7S4IHxyRBx6rjIhrCv+CUHLh281G3b1vGNxMLiKUtTBzpBq2jWrE
         Vrag==
X-Gm-Message-State: AJIora9iiNGeVh5kg9ojucsHm9N3gueHmhaRJt5kybGFvQLJ8TM722kw
        eOz+1xyb8XIycEJqDPvFMUWoazkPuHw=
X-Google-Smtp-Source: AGRyM1s8gN0PKCp0jJCS0uvJtwSOItDg7kIV0FDoXpWE2v10ECCFQz0vbVQnfNj5eB+DcUqLbReRrwPTRB0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:930c:b0:167:8960:2c39 with SMTP id
 bc12-20020a170902930c00b0016789602c39mr6024164plb.33.1655239659566; Tue, 14
 Jun 2022 13:47:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:11 +0000
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
Message-Id: <20220614204730.3359543-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 02/21] KVM: VMX: Drop bits 31:16 when shoving exception
 error code into VMCS
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
---
 arch/x86/kvm/vmx/nested.c |  9 ++++++++-
 arch/x86/kvm/vmx/vmx.c    | 11 ++++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ee6f27dffdba..33ffc8bcf9cd 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3833,7 +3833,14 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
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
index 5e14e4c40007..ec98992024e2 100644
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
2.36.1.476.g0c4daa206d-goog

