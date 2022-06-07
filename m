Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9691A54254C
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442028AbiFHBAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381308AbiFGXjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:39:02 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9865722DFBA
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:27 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 72-20020a63014b000000b003fce454aaf2so7448043pgb.6
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=kIHbaDeE5+Xu+cED69bXs6B1hwEW4reTl6ZJqla8mJM=;
        b=ddoNjco06S2NNUIkU9zlbWUj0xo8C+FljBGgAoCnXG3GPpuHeGRRJa/Hytg/tzaFog
         TPGRWsGbPaJNUE53ORYSeT+B+Ou+QNyhqzU3dCnLoaKSH47ocD7dwM8yy/l+ThzeXw0B
         0SYzBG/MpunS62oHsfCPu3GsM+48gGrN1TIHc2CbEz8+gxAHEBjk2aJZ9Atz4LW3517V
         rsjQM4khW9D2bkFm6qMHrLURJhB7GwySH2AHAxiJBImS344oLk4txlQz9NN9bFp6uKi2
         km0A3NH62ctAsu/gofq2sGRWdzuD+xJSjnj7ZT6ilVJYVNsw58eLq7HYAtLtV/eY88bY
         QG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=kIHbaDeE5+Xu+cED69bXs6B1hwEW4reTl6ZJqla8mJM=;
        b=iEeO34LA3Wio9jllxKVInS4wvKo8n6HkfrdC1PqWveqMUMYosnFzT7jmWwjKe7HXxO
         4X874TuUEcPNwh5vHhcGo3zDpvNdcxgeEY/3fChjKXy17YCing8B1tGSECW+tkIcZarr
         Jy93c9CWNNcunPf5Yp5vZ3mjePUukcDtyKG3PicBbRGfQzgwOJifhFa56tVVDcj9e2o2
         +bLy/2NuiWd2GRNRNlXVMClpmLYmM+35Ue8VntF/izMP8UPKow/kDR4YgA960nbD15GQ
         cvgiAguiGOvOCyOx1U6HS/J/N1hpBKmnRuCCX9oUwy7sOB/cHIPEH2qsXMpdjxTgl5E5
         vDkQ==
X-Gm-Message-State: AOAM533v0lmkf2tvda9od7u3SeBg958W88cbyA1WINWq21KIhA2QUPlP
        5plbmOpOEqHf10XKq5tMWTawT7KsZ8g=
X-Google-Smtp-Source: ABdhPJyzOGNGFBCl5CqBHPWYmK+RmIfbSPiaIyoa64t/YktmSSIesEUxPj1DS5IaUAxlajJYp2atKl8ttVY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr409798pja.1.1654637786593; Tue, 07 Jun
 2022 14:36:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:35:54 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 05/15] KVM: nVMX: Let userspace set nVMX MSR to any _host_
 supported value
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
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

Restrict the nVMX MSRs based on KVM's config, not based on the guest's
current config.  Using the guest's config to audit the new config
prevents userspace from restoring the original config (KVM's config) if
at any point in the past the guest's config was restricted in any way.

Fixes: 62cc6b9dc61e ("KVM: nVMX: support restore of VMX capability MSRs")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 100 ++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 00c7b00c017a..fca30e79b3a0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1223,7 +1223,7 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
 		/* reserved */
 		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
-	u64 vmx_basic = vmx->nested.msrs.basic;
+	u64 vmx_basic = vmcs_config.nested.basic;
 
 	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
 		return -EINVAL;
@@ -1246,36 +1246,42 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 	return 0;
 }
 
+static void vmx_get_control_msr(struct nested_vmx_msrs *msrs, u32 msr_index,
+				u32 **low, u32 **high)
+{
+	switch (msr_index) {
+	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
+		*low = &msrs->pinbased_ctls_low;
+		*high = &msrs->pinbased_ctls_high;
+		break;
+	case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
+		*low = &msrs->procbased_ctls_low;
+		*high = &msrs->procbased_ctls_high;
+		break;
+	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
+		*low = &msrs->exit_ctls_low;
+		*high = &msrs->exit_ctls_high;
+		break;
+	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
+		*low = &msrs->entry_ctls_low;
+		*high = &msrs->entry_ctls_high;
+		break;
+	case MSR_IA32_VMX_PROCBASED_CTLS2:
+		*low = &msrs->secondary_ctls_low;
+		*high = &msrs->secondary_ctls_high;
+		break;
+	default:
+		BUG();
+	}
+}
+
 static int
 vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 {
-	u64 supported;
 	u32 *lowp, *highp;
+	u64 supported;
 
-	switch (msr_index) {
-	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
-		lowp = &vmx->nested.msrs.pinbased_ctls_low;
-		highp = &vmx->nested.msrs.pinbased_ctls_high;
-		break;
-	case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
-		lowp = &vmx->nested.msrs.procbased_ctls_low;
-		highp = &vmx->nested.msrs.procbased_ctls_high;
-		break;
-	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		lowp = &vmx->nested.msrs.exit_ctls_low;
-		highp = &vmx->nested.msrs.exit_ctls_high;
-		break;
-	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		lowp = &vmx->nested.msrs.entry_ctls_low;
-		highp = &vmx->nested.msrs.entry_ctls_high;
-		break;
-	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		lowp = &vmx->nested.msrs.secondary_ctls_low;
-		highp = &vmx->nested.msrs.secondary_ctls_high;
-		break;
-	default:
-		BUG();
-	}
+	vmx_get_control_msr(&vmcs_config.nested, msr_index, &lowp, &highp);
 
 	supported = vmx_control_msr(*lowp, *highp);
 
@@ -1287,6 +1293,7 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 	if (!is_bitwise_subset(supported, data, GENMASK_ULL(63, 32)))
 		return -EINVAL;
 
+	vmx_get_control_msr(&vmx->nested.msrs, msr_index, &lowp, &highp);
 	*lowp = data;
 	*highp = data >> 32;
 	return 0;
@@ -1300,10 +1307,8 @@ static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
 		BIT_ULL(28) | BIT_ULL(29) | BIT_ULL(30) |
 		/* reserved */
 		GENMASK_ULL(13, 9) | BIT_ULL(31);
-	u64 vmx_misc;
-
-	vmx_misc = vmx_control_msr(vmx->nested.msrs.misc_low,
-				   vmx->nested.msrs.misc_high);
+	u64 vmx_misc = vmx_control_msr(vmcs_config.nested.misc_low,
+				       vmcs_config.nested.misc_high);
 
 	if (!is_bitwise_subset(vmx_misc, data, feature_and_reserved_bits))
 		return -EINVAL;
@@ -1331,10 +1336,8 @@ static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
 
 static int vmx_restore_vmx_ept_vpid_cap(struct vcpu_vmx *vmx, u64 data)
 {
-	u64 vmx_ept_vpid_cap;
-
-	vmx_ept_vpid_cap = vmx_control_msr(vmx->nested.msrs.ept_caps,
-					   vmx->nested.msrs.vpid_caps);
+	u64 vmx_ept_vpid_cap = vmx_control_msr(vmcs_config.nested.ept_caps,
+					       vmcs_config.nested.vpid_caps);
 
 	/* Every bit is either reserved or a feature bit. */
 	if (!is_bitwise_subset(vmx_ept_vpid_cap, data, -1ULL))
@@ -1345,20 +1348,21 @@ static int vmx_restore_vmx_ept_vpid_cap(struct vcpu_vmx *vmx, u64 data)
 	return 0;
 }
 
+static u64 *vmx_get_fixed0_msr(struct nested_vmx_msrs *msrs, u32 msr_index)
+{
+	switch (msr_index) {
+	case MSR_IA32_VMX_CR0_FIXED0:
+		return &msrs->cr0_fixed0;
+	case MSR_IA32_VMX_CR4_FIXED0:
+		return &msrs->cr4_fixed0;
+	default:
+		BUG();
+	}
+}
+
 static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 {
-	u64 *msr;
-
-	switch (msr_index) {
-	case MSR_IA32_VMX_CR0_FIXED0:
-		msr = &vmx->nested.msrs.cr0_fixed0;
-		break;
-	case MSR_IA32_VMX_CR4_FIXED0:
-		msr = &vmx->nested.msrs.cr4_fixed0;
-		break;
-	default:
-		BUG();
-	}
+	const u64 *msr = vmx_get_fixed0_msr(&vmcs_config.nested, msr_index);
 
 	/*
 	 * 1 bits (which indicates bits which "must-be-1" during VMX operation)
@@ -1367,7 +1371,7 @@ static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 	if (!is_bitwise_subset(data, *msr, -1ULL))
 		return -EINVAL;
 
-	*msr = data;
+	*vmx_get_fixed0_msr(&vmx->nested.msrs, msr_index) = data;
 	return 0;
 }
 
@@ -1428,7 +1432,7 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		vmx->nested.msrs.vmcs_enum = data;
 		return 0;
 	case MSR_IA32_VMX_VMFUNC:
-		if (data & ~vmx->nested.msrs.vmfunc_controls)
+		if (data & ~vmcs_config.nested.vmfunc_controls)
 			return -EINVAL;
 		vmx->nested.msrs.vmfunc_controls = data;
 		return 0;
-- 
2.36.1.255.ge46751e96f-goog

