Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07CE542302
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444102AbiFHBB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835817AbiFGX5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:57:02 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71CF819B4
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 16:23:58 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id n6-20020a654886000000b003fda8768883so4161037pgs.14
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 16:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7BEMJCReDvWYRKLhlInIZ1OFpFjx1quNIbfK5hEhej4=;
        b=NkgordnQuuAVc31UeJpYQYToToDAsNS1qL4WUn+TkIFlIEfUpGIbU4rTmpOmS9Rkyn
         H5jZdL7P9KCG+61Cs3FRM1mEWhyKhkOl4hKqQqA29qa8+hs3jVTGALzrQ9QQyG68gjhA
         5XesWEK1k1vi3J+iWPZxg0MeELXLa1RIFxMSuN0EIKPP/HSD1MPBVoaTwhMA6pKBeRGp
         pTz+Js9Q3laKX18zRENswO6LLmTOnQ5zETw82uIktLilDZ8f0IUqk4g2pFMJj+cG2a9o
         04PIUH/iUhjVIiSCaL1lxwaLD4PWvykFJHrbLN3ZtTJAs4neY5ahOTpKYXsO0a+FaKzn
         AdHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7BEMJCReDvWYRKLhlInIZ1OFpFjx1quNIbfK5hEhej4=;
        b=DvusDQgN0mKDucJUsU/py4WxoljbHSUogQy9oPDL1DtsDto7n2BXty2vfOCxDVVy/D
         9OHnvIY81b7uZ3oT0JcrDlmDuYn6xHWDpZQ0sOm8PueNIf33xaqm3fcK3Szsda56n+/W
         sX/ag5rPYJGkB12e8yu7Z19MaexhPVro+o9JPc0DXqICKGasDNmBHVOE3qbym6Mm9E0+
         isXU/BP7JdJy9W9j8ozPChTdRU5l1sJ2xzm69FFmpQ2Ts/FjRUUP1tMoJaY9unvN6Dtk
         fegN/zHxYvd4XwCNMctV339ebHQF0+Qe5JNJyzEuwFY8nZZQMzcjHlFShKXA7u/APeJO
         tfDA==
X-Gm-Message-State: AOAM532L5IRtvrae6kMLlHGTou9kpVs88jchBYpKnwX7hkg6dH1EZqYk
        V4ANSFXAZy7pMMJizVph7D4YeSCsmKY=
X-Google-Smtp-Source: ABdhPJwKUS2rXe4ZMRGjiGGfUOn8NT8M/vx1ChFdkFHaTIAOt6gmH867C8Af6ZFHbfa0UQNuE8DP+0nAHVo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:234b:b0:166:4459:c43a with SMTP id
 c11-20020a170903234b00b001664459c43amr28857631plh.35.1654644238156; Tue, 07
 Jun 2022 16:23:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 23:23:51 +0000
In-Reply-To: <20220607232353.3375324-1-seanjc@google.com>
Message-Id: <20220607232353.3375324-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220607232353.3375324-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 1/3] KVM: VMX: Allow userspace to set all supported
 FEATURE_CONTROL bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Allow userspace to set all supported bits in MSR IA32_FEATURE_CONTROL
irrespective of the guest CPUID model, e.g. via KVM_SET_MSRS.  KVM's ABI
is that userspace is allowed to set MSRs before CPUID, i.e. can set MSRs
to values that would fault according to the guest CPUID model.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fd2e707faf2b..8e83e12373c5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1741,12 +1741,38 @@ bool nested_vmx_allowed(struct kvm_vcpu *vcpu)
 	return nested && guest_cpuid_has(vcpu, X86_FEATURE_VMX);
 }
 
-static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
-						 uint64_t val)
+/*
+ * Userspace is allowed to set any supported IA32_FEATURE_CONTROL regardless of
+ * guest CPUID.  Note, KVM allows userspace to set "VMX in SMX" to maintain
+ * backwards compatibility even though KVM doesn't support emulating SMX.  And
+ * because userspace set "VMX in SMX", the guest must also be allowed to set it,
+ * e.g. if the MSR is left unlocked and the guest does a RMW operation.
+ */
+#define KVM_SUPPORTED_FEATURE_CONTROL  (FEAT_CTL_LOCKED			 | \
+					FEAT_CTL_VMX_ENABLED_INSIDE_SMX	 | \
+					FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX | \
+					FEAT_CTL_SGX_LC_ENABLED		 | \
+					FEAT_CTL_SGX_ENABLED		 | \
+					FEAT_CTL_LMCE_ENABLED)
+
+static inline bool vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
+						 struct msr_data *msr)
 {
-	uint64_t valid_bits = to_vmx(vcpu)->msr_ia32_feature_control_valid_bits;
+	uint64_t valid_bits;
 
-	return !(val & ~valid_bits);
+	/*
+	 * Ensure KVM_SUPPORTED_FEATURE_CONTROL is updated when new bits are
+	 * exposed to the guest.
+	 */
+	WARN_ON_ONCE(vmx->msr_ia32_feature_control_valid_bits &
+		     ~KVM_SUPPORTED_FEATURE_CONTROL);
+
+	if (msr->host_initiated)
+		valid_bits = KVM_SUPPORTED_FEATURE_CONTROL;
+	else
+		valid_bits = vmx->msr_ia32_feature_control_valid_bits;
+
+	return !(msr->data & ~valid_bits);
 }
 
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
@@ -2139,7 +2165,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.mcg_ext_ctl = data;
 		break;
 	case MSR_IA32_FEAT_CTL:
-		if (!vmx_feature_control_msr_valid(vcpu, data) ||
+		if (!vmx_feature_control_msr_valid(vmx, msr_info) ||
 		    (to_vmx(vcpu)->msr_ia32_feature_control &
 		     FEAT_CTL_LOCKED && !msr_info->host_initiated))
 			return 1;
-- 
2.36.1.255.ge46751e96f-goog

