Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CBE58AEE8
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 19:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241185AbiHER37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 13:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241100AbiHER3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 13:29:55 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB56B2C12F
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 10:29:53 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id w124-20020a627b82000000b0052d8ebfc055so1480648pfc.19
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 10:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=e3KAREkpALrV805apy/PR/815kpRUNyRkecRR9ka60I=;
        b=s7N8DoTy9J5L3pDUtmYf7WwNsc0rFgtyd//8fTsC4PsYsqL01l+itwXylbdINPpF42
         zPqY+T5YPKXBC3/JvrM3fdfnqfj/eeTcdNWnvE2iwA5uirekuCrZ+3S9oVF/pisilJ8V
         LJnz35HXY/vNeAkyWc9LeE7xQN7v1LIDjP0xhck2iHjbmhSHWtJDWRMYTkGiEu18k8tW
         2j0XG9x6d3IpbZgWahqwD8bBO6zToasLMve6pEoNb59EoXystkjZTr6HZAMiG4EppzGa
         0GOmS6f0zKmKP584mT1zChMCT4aA8jfOhHAOmOSPahOmuEAYMiDzD5/RGMCPQFcKLllQ
         aq3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=e3KAREkpALrV805apy/PR/815kpRUNyRkecRR9ka60I=;
        b=nnFoDx6vsCsgC1hU8aD0/2pKBpocKVAnxRGVHx6MT811lb46QkSdn9w7tVGMeNcGp+
         z0WGjlFHvkkQII99cgp+XmxrplWOv+K8AdQHrGzEyOyzdw9aaBb5wuxjyh9Ww2gu19TG
         anhbxPmFi4WB/46N7jvr3F/A9LqYN2k6No/NtRLafMuhDHTRDQpUfqpU86QrQlVNj3oT
         jk19RcFUUBPZqlmsS1Lbf/C8yZL9g4BBxsYaAXyUXim2BTUDcKxksAiiNXdqhOcXHWlq
         7985e/R2ObGmJxsqO2Zr1g4weYWpofHgH/c7s2/PE8oqQPnqRDD8bXC/EwBMm3svQn9b
         hiPg==
X-Gm-Message-State: ACgBeo2f91TiUZiLbbgoF9Sj689IIaSmgPmToxJdjV4zEALe8poJ9IWL
        +OCeRzsh4xO+mgE+V0i/z9khbLlbPhM=
X-Google-Smtp-Source: AA6agR7cDzyiCPI5AYha+X3FMq8JCwRkuQH5rIHqmN9FcS0gSD5AMv3QZdmmLboxNF++r74yljs+DnBr5gk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a8f:b0:1f5:ee3:a6a1 with SMTP id
 lp15-20020a17090b4a8f00b001f50ee3a6a1mr17251912pjb.149.1659720593556; Fri, 05
 Aug 2022 10:29:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Aug 2022 17:29:45 +0000
In-Reply-To: <20220805172945.35412-1-seanjc@google.com>
Message-Id: <20220805172945.35412-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220805172945.35412-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [RFC PATCH 3/3] KVM: x86: Disallow writes to immutable feature MSRs
 after KVM_RUN
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c65b77fb16..4da26a1f14c1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1541,6 +1541,26 @@ static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_vmx) +
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
+
 static u64 kvm_get_arch_capabilities(void)
 {
 	u64 data = 0;
@@ -2136,6 +2156,23 @@ static int do_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
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
+	if (vcpu->arch.last_vmentry_cpu != -1 &&
+	    kvm_is_immutable_feature_msr(index)) {
+		if (do_get_msr(vcpu, index, &val) || *data != val)
+			return -EINVAL;
+
+		return 0;
+	}
+
 	return kvm_set_msr_ignored_check(vcpu, index, *data, true);
 }
 
-- 
2.37.1.559.g78731f0fdb-goog

