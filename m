Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504A66B56F3
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjCKAq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjCKAqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:46:46 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6599D13B957
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:34 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id n22-20020a62e516000000b0062262d6ed76so35138pff.3
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zCOvRr1PWIR8jxDT0Nx3YLXl9PnvY8jog+vx0dMgysc=;
        b=nzmhl4R/Q+oaG1Se5KEs4EOP7zWfYacH54F4ladIGdZLCJkwfVINgW3AqC7RwWHz07
         EULJktOyDxN8NrCJAH5ekl12s1h8TLPfFit5PvBqARXmN0eISDSSKUpX1DL8K3OtkkD3
         Xio8a/4AtQSYUKdLPBeZz+jdOY4N7y1l8ckj+/sARBtlw1C4g6J+bGdne7F5QdRM588p
         VxlEnAMWaUx/CUNkeoOkk6r0zN3bScGmPTwnrMPpPTCiaYjVsTDpnaBlFe/knPdCTaVE
         aryFm5TwGdQiyjszeKkVWy5bdhFmWoCvrYJPIFXklhu94eNlMQbDuGYfCNBZza8/AnAV
         ywXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zCOvRr1PWIR8jxDT0Nx3YLXl9PnvY8jog+vx0dMgysc=;
        b=SBs7Csjbyx1k4mzqdnU9v6hUuFH1gUJnWp3iQfPmolV/SRissyIvMUiFWpBbXIdXT6
         5MmddsftcTr/opHJO3+Q7BzJukIbRUIlbowqeDs3/9g6R3CI6eQ0f7G70+Ug1X9b6CeH
         Sfh2NbRRkM4AFZQMa9LQlIbFpwfF0yxQsNvr/i+rtT3RzZv/JDCIcvT9bEPoR9QJqzIo
         GyoiZYIEI9XcpNz5SS8sKIw7Jc7BOe2Yq5Mfv1ZGnrbE/0/Gee+yxpD5UupMQZpd38F8
         rd1cT8WWfNYF8HHQd13lLBIzTAjN14d4X+IUrSwFauTDjzLG4AA/iLf+rq/gi2jD8Ckc
         7Qrw==
X-Gm-Message-State: AO0yUKWhJ4JBDLwVh/ErRcG73k1Irsb+rDaKvov9CzgEg5pMs8vEyysh
        RHnmukk8/lG+LXy0Uj4Caym6+9wY7AM=
X-Google-Smtp-Source: AK7set/KLC6zsFqjCD7RlVaP1yI9mtRtIsb2tqNO8iAFNZm4m7sxOPkLBS2H8RWwvreh8ie/lKJnt8T0oCg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:db45:0:b0:606:653c:f19b with SMTP id
 f66-20020a62db45000000b00606653cf19bmr11011987pfg.5.1678495593538; Fri, 10
 Mar 2023 16:46:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:46:03 -0800
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-7-seanjc@google.com>
Subject: [PATCH v3 06/21] KVM: x86: Disallow writes to immutable feature MSRs
 after KVM_RUN
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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

Disallow writes to feature MSRs after KVM_RUN to prevent userspace from
changing the vCPU model after running the vCPU.  Similar to guest CPUID,
KVM uses feature MSRs to configure intercepts, determine what operations
are/aren't allowed, etc.  Changing the capabilities while the vCPU is
active will at best yield unpredictable guest behavior, and at worst
could be dangerous to KVM.

Allow writing the current value, e.g. so that userspace can blindly set
all MSRs when emulating RESET, and unconditionally allow writes to
MSR_IA32_UCODE_REV so that userspace can emulate patch loads.

Special case the VMX MSRs to keep the generic list small, i.e. so that
KVM can do a linear walk of the generic list without incurring meaningful
overhead.

Cc: Like Xu <like.xu.linux@gmail.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7b73a0b45041..219492cd887e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1554,6 +1554,25 @@ static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_vmx) +
 			      (KVM_LAST_EMULATED_VMX_MSR - KVM_FIRST_EMULATED_VMX_MSR + 1)];
 static unsigned int num_msr_based_features;
 
+/*
+ * All feature MSRs except uCode revID, which tracks the currently loaded uCode
+ * patch, are immutable once the vCPU model is defined.
+ */
+static bool kvm_is_immutable_feature_msr(u32 msr)
+{
+	int i;
+
+	if (msr >= KVM_FIRST_EMULATED_VMX_MSR && msr <= KVM_LAST_EMULATED_VMX_MSR)
+		return true;
+
+	for (i = 0; i < ARRAY_SIZE(msr_based_features_all_except_vmx); i++) {
+		if (msr == msr_based_features_all_except_vmx[i])
+			return msr != MSR_IA32_UCODE_REV;
+	}
+
+	return false;
+}
+
 /*
  * Some IA32_ARCH_CAPABILITIES bits have dependencies on MSRs that KVM
  * does not yet virtualize. These include:
@@ -2168,6 +2187,22 @@ static int do_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
 static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
+	u64 val;
+
+	/*
+	 * Disallow writes to immutable feature MSRs after KVM_RUN.  KVM does
+	 * not support modifying the guest vCPU model on the fly, e.g. changing
+	 * the nVMX capabilities while L2 is running is nonsensical.  Ignore
+	 * writes of the same value, e.g. to allow userspace to blindly stuff
+	 * all MSRs when emulating RESET.
+	 */
+	if (kvm_vcpu_has_run(vcpu) && kvm_is_immutable_feature_msr(index)) {
+		if (do_get_msr(vcpu, index, &val) || *data != val)
+			return -EINVAL;
+
+		return 0;
+	}
+
 	return kvm_set_msr_ignored_check(vcpu, index, *data, true);
 }
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

