Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A7777D446
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238416AbjHOUhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238652AbjHOUhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:37:36 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE12210B
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:03 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-68876bbed07so792964b3a.2
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131821; x=1692736621;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=o5Fw8iHbcV8xK4DrDbdpdFHBEPCT+wzf42bdYUnsFwM=;
        b=QqYZTngZalMttEh18rnC4PLxQefF07rtAGLtY6TXMgEH5QDZ289O7UXT4u1Ujkwclo
         9oLd+5MeuHlx3XfhoH+reDRGW8NM2wVSV6DTFEvO2Ad8BZBeY++BTiclLN/VLRgySn2O
         xN0/fty+SJ6WTlTTl5p7cQ2HsUR/yaPIidYp38zwNmfPqPSWlsvVr9sAa40dv7517GxB
         OxTrqJu0AjmAzGxdBvV2cyBSmiqRgGrpUr4Gh3I+xeBxzYth56V+Q1J3M5Wf72YZLbDd
         zf7LTpbcwizvQLy0Hwzx2fy/KdK9wqvZKfiKVnC+EwLMHH2W/FogYww1Q+KjVLjA+CFD
         B5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131821; x=1692736621;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o5Fw8iHbcV8xK4DrDbdpdFHBEPCT+wzf42bdYUnsFwM=;
        b=ePbbNerR7vo+GSjzZN+M0zvxd4sMcTHjUFdcr1yrL7qRBHrnjNHWTtok6pYPWbQNxf
         E34vzmcxmnhHKZ8XREVCff/tuhpvP/bOTcbaeS0YTeTAZ6O7RUKWVZc37Bti/Kekhibq
         BjiefHjIqK199HN8uqvPQK58+M7oCId5Xw/Kl30QEflrfkYCMRex4fcrWOZ2yBnnRP5a
         fnfmfcLPi64fKxN5NUuBGhPQ/8JsNzwOa7orCGH0as0xS+uHEPcmgvNoMNyZkSqkuA/E
         Qn3jiVVUzFMQUdcTE04ry2lGqZ4UxCHnMkljfGeU9+IJuLL1/tj8LWIYWqnv6rvgH+Wv
         VzYg==
X-Gm-Message-State: AOJu0YykEYY9F8luXMKgocxZoeTXcZok74mBuCD3UnFkaAKuhOi+pkrI
        ujnswyDIHiCxFl8lMSLfPY4JneDxP3s=
X-Google-Smtp-Source: AGHT+IFe12jxTHjrc7c6wUko5dd5R5Y8ZCoG71Ke9T+D+UtA3k/jZBXLzkxawfZKTlJHI3Ts++fg66QePJI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1ad3:b0:687:3f7a:aea7 with SMTP id
 f19-20020a056a001ad300b006873f7aaea7mr6546953pfv.0.1692131821648; Tue, 15 Aug
 2023 13:37:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:41 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-4-seanjc@google.com>
Subject: [PATCH v3 03/15] KVM: VMX: Recompute "XSAVES enabled" only after
 CPUID update
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
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

Recompute whether or not XSAVES is enabled for the guest only if the
guest's CPUID model changes instead of redoing the computation every time
KVM generates vmcs01's secondary execution controls.  The boot_cpu_has()
and cpu_has_vmx_xsaves() checks should never change after KVM is loaded,
and if they do the kernel/KVM is hosed.

Opportunistically add a comment explaining _why_ XSAVES is effectively
exposed to the guest if and only if XSAVE is also exposed to the guest.

Practically speaking, no functional change intended (KVM will do fewer
computations, but should still see the same xsaves_enabled value whenever
KVM looks at it).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 434bf524e712..1bf85bd53416 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4612,19 +4612,10 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
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
@@ -7749,8 +7740,15 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
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
2.41.0.694.ge786442a9b-goog

