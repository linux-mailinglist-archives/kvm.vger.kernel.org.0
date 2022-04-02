Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4644EFD9F
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 03:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353618AbiDBBLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 21:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353423AbiDBBLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 21:11:01 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AE98FE73
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 18:09:11 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id bv2-20020a17090af18200b001c63c69a774so1908460pjb.0
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 18:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Czzn9i/2i6B1OBdabyWFgGFqRWslyQJuAsyXE6/7mj0=;
        b=I/sR5Eyp0KnE20qAVSatSC9Qd8LA6B9L+YQcL1RO6LZoG+nQbxj7gR8VC+pSt159MB
         naW8IqzSxUtZ1tkcXuzCgT7fC4s7FNy2JBiqGuFCUJMOnwXaad4wfxO+RSJlGt2nKvta
         x8Lqh+z04e0vhr5s2mHUvv8LFCb7ORgxG0nTuZlyOWuMpkrGsYZOh+d9zG7eljfwEmpg
         lois9n6XSdpXL+FfqvQIWupDiB7tQCpF6alcGuoKdBg/DJVmUNxbOxLfSqj8ntciaMlV
         8uVjEXlWKdmoAfv9fKjNkGOjM2f5M55lgONHC2aG3W0wwH5Z8xplGambc5G8kWZWdUA3
         GhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Czzn9i/2i6B1OBdabyWFgGFqRWslyQJuAsyXE6/7mj0=;
        b=uV0vbowtFwf78mIq2SiwrfON997rjaKyjiQ+hnGvjXGt3xqXi0DMwVtDuiytFn/b6r
         lBTMuXgtC4nkb+DTw1mtypSozn6GcIH1YvxNplaisSyg5Xb8coZXKGvl+ks/qMV9JWIN
         EQCJJe8ccqiof8O3eCe28QM3a3a64JBK5Mmt/cr0Iba7B2JPzalXcepkUFCjeGiuKT3p
         7TSvy2l7SGXXAPXxUYGJ/0PAoQvcBBX6IRZBeGkedUfp+9RPng8uCW25YxX2RpanFn6C
         8fLoVHdo4AE33/jFsC5KGFCT38gdY17ZTR0Of6vWfC/40yiXNHUtzIHk0TZM0i6ooBwz
         mHyQ==
X-Gm-Message-State: AOAM531kgzht1Zv+sJtNfz/UHOeiLe1yVeTfc5CuMXsGkCz0Z1Tox8Ch
        kzlhQ1KzaPbtuU63i+Uc6tvb+/fmxRQ=
X-Google-Smtp-Source: ABdhPJxUeBeLfnRYVU4NNoaIAkOp173uUFizIUjEgmhgVSqVzzTW/5EspfQz0Niq83TzQz2SLpLto22aL1Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8c81:b0:156:7fee:643b with SMTP id
 t1-20020a1709028c8100b001567fee643bmr203850plo.59.1648861750610; Fri, 01 Apr
 2022 18:09:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  2 Apr 2022 01:08:58 +0000
In-Reply-To: <20220402010903.727604-1-seanjc@google.com>
Message-Id: <20220402010903.727604-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220402010903.727604-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 3/8] KVM: SVM: Unwind "speculative" RIP advancement if INTn
 injection "fails"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
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

Unwind the RIP advancement done by svm_queue_exception() when injecting
an INT3 ultimately "fails" due to the CPU encountering a VM-Exit while
vectoring the injected event, even if the exception reported by the CPU
isn't the same event that was injected.  If vectoring INT3 encounters an
exception, e.g. #NP, and vectoring the #NP encounters an intercepted
exception, e.g. #PF when KVM is using shadow paging, then the #NP will
be reported as the event that was in-progress.

Note, this is still imperfect, as it will get a false positive if the
INT3 is cleanly injected, no VM-Exit occurs before the IRET from the INT3
handler in the guest, the instruction following the INT3 generates an
exception (directly or indirectly), _and_ vectoring that exception
encounters an exception that is intercepted by KVM.  The false positives
could theoretically be solved by further analyzing the vectoring event,
e.g. by comparing the error code against the expected error code were an
exception to occur when vectoring the original injected exception, but
SVM without NRIPS is a complete disaster, trying to make it 100% correct
is a waste of time.

Fixes: 66b7138f9136 ("KVM: SVM: Emulate nRIP feature when reinjecting INT3")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2c86bd9176c6..30cef3b10838 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3699,6 +3699,18 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
 	type = exitintinfo & SVM_EXITINTINFO_TYPE_MASK;
 
+	/*
+	 * If NextRIP isn't enabled, KVM must manually advance RIP prior to
+	 * injecting the soft exception/interrupt.  That advancement needs to
+	 * be unwound if vectoring didn't complete.  Note, the _new_ event may
+	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
+	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
+	 * be the reported vectored event, but RIP still needs to be unwound.
+	 */
+	if (int3_injected && type == SVM_EXITINTINFO_TYPE_EXEPT &&
+	   kvm_is_linear_rip(vcpu, svm->int3_rip))
+		kvm_rip_write(vcpu, kvm_rip_read(vcpu) - int3_injected);
+
 	switch (type) {
 	case SVM_EXITINTINFO_TYPE_NMI:
 		vcpu->arch.nmi_injected = true;
@@ -3715,13 +3727,9 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 		 * but re-execute the instruction instead. Rewind RIP first
 		 * if we emulated INT3 before.
 		 */
-		if (kvm_exception_is_soft(vector)) {
-			if (vector == BP_VECTOR && int3_injected &&
-			    kvm_is_linear_rip(vcpu, svm->int3_rip))
-				kvm_rip_write(vcpu,
-					      kvm_rip_read(vcpu) - int3_injected);
+		if (kvm_exception_is_soft(vector))
 			break;
-		}
+
 		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
 			u32 err = svm->vmcb->control.exit_int_info_err;
 			kvm_requeue_exception_e(vcpu, vector, err);
-- 
2.35.1.1094.g7c7d902a7c-goog

