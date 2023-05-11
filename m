Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8154B6FFD5C
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 01:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239643AbjEKXeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 19:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239610AbjEKXeI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:34:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971126EB5
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:34:05 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-559d36a91a9so102710387b3.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683848044; x=1686440044;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RHS7AeIFZovBrRj7A9l+HBtCSJJvNOkTQRZrmphRUI0=;
        b=0tx8Ind3vnPelqhWS3UozQxmgv/3gx2xhExsOSrMCvy8bPHRDHPtRNxqFI1LB+2mi3
         pTnJkrK/FNE/JTFksxeHfpfCuQs0kmhmqFVV6MSRUOHa3gyJjRJ/io08JGy6oSUkhQHE
         WhkGygcckRQomRrhEwQ1Wu1VEU5VOKehDRv6UElAJKU6w/Ji7K4L+ROhhhXmFFC+EBPs
         RlaphzxWk2POeTxmCS7rvtk/8SqOv8Ha1EqyuJbR+E7va1LjsTcBvsZ7xI1nRflCin6F
         jirnjWy22JKhM5ebenjTvnhYKFIKfV3jTpf7/UvAWvYYD925l2M+JzZgBeTEBwxowdDH
         nsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683848044; x=1686440044;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RHS7AeIFZovBrRj7A9l+HBtCSJJvNOkTQRZrmphRUI0=;
        b=OGBG5uzQ0WUp5BrjA3lFrCVKFxnQhOilutelgU6ngchJzJoz6SvkbT2Ub9r6VxcyIi
         1aVRpdFlLb36r6wJSZcoNx2ahp/qwnlcO+CRB3WEzd36sonzcXl9A3tHI7Ct3wX+9DTL
         3iVW8y+B14J9BmOH9J1lOL65BwYYR8Cj8j6bCbgdvQ5ANhXSaYbS8ojB9g/n5RUbMqAm
         2vBR9GWOmWsVIU1aw9iDDs0XMAp5mVym1vMvLYjnlze7m1owxw44tiJ1KOZ16Ac2u/7w
         MLii8lClybMVjHljcMui1ajDonyuNMIziOz7SczCF06EERaEM4d5pjuTRrhRNBHXcjV+
         JEdA==
X-Gm-Message-State: AC+VfDyHBsg14UoGIKyhljlK8wBKZhljidpgQdZxjmyZpxrltCz4lt6I
        pYY2K8mr75uNeUUWLEHKT5wWLWx/z68=
X-Google-Smtp-Source: ACHHUZ4Tw3qQWt4aPQhdL1qwFNUD1uUQCRhsojdHHGcDN1irLKK/nVyXmvMfrX0UTNZqS4BQTfhLsjQY97s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dc43:0:b0:ba1:6f1b:8905 with SMTP id
 y64-20020a25dc43000000b00ba16f1b8905mr14135026ybe.4.1683848044752; Thu, 11
 May 2023 16:34:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 May 2023 16:33:49 -0700
In-Reply-To: <20230511233351.635053-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511233351.635053-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230511233351.635053-7-seanjc@google.com>
Subject: [PATCH v2 6/8] KVM: x86: Move PAT MSR handling out of mtrr.c
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
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

Drop handling of MSR_IA32_CR_PAT from mtrr.c now that SVM and VMX handle
writes without bouncing through kvm_set_msr_common().  PAT isn't truly an
MTRR even though it affects memory types, and more importantly KVM enables
hardware virtualization of guest PAT (by NOT setting "ignore guest PAT")
when a guest has non-coherent DMA, i.e. KVM doesn't need to zap SPTEs when
the guest PAT changes.

The read path is and always has been trivial, i.e. burying it in the MTRR
code does more harm than good.

WARN and continue for the PAT case in kvm_set_msr_common(), as that code
is _currently_ reached if and only if KVM is buggy.  Defer cleaning up the
lack of symmetry between the read and write paths to a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mtrr.c | 19 ++++++-------------
 arch/x86/kvm/x86.c  | 13 +++++++++++++
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index dc213b940141..cdbbb511f940 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -55,7 +55,6 @@ static bool msr_mtrr_valid(unsigned msr)
 	case MSR_MTRRfix4K_F0000:
 	case MSR_MTRRfix4K_F8000:
 	case MSR_MTRRdefType:
-	case MSR_IA32_CR_PAT:
 		return true;
 	}
 	return false;
@@ -74,9 +73,7 @@ bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	if (!msr_mtrr_valid(msr))
 		return false;
 
-	if (msr == MSR_IA32_CR_PAT) {
-		return kvm_pat_valid(data);
-	} else if (msr == MSR_MTRRdefType) {
+	if (msr == MSR_MTRRdefType) {
 		if (data & ~0xcff)
 			return false;
 		return valid_mtrr_type(data & 0xff);
@@ -324,8 +321,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
 	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
 	gfn_t start, end;
 
-	if (msr == MSR_IA32_CR_PAT || !tdp_enabled ||
-	      !kvm_arch_has_noncoherent_dma(vcpu->kvm))
+	if (!tdp_enabled || !kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return;
 
 	if (!mtrr_is_enabled(mtrr_state) && msr != MSR_MTRRdefType)
@@ -392,8 +388,6 @@ int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		*(u64 *)&vcpu->arch.mtrr_state.fixed_ranges[index] = data;
 	else if (msr == MSR_MTRRdefType)
 		vcpu->arch.mtrr_state.deftype = data;
-	else if (msr == MSR_IA32_CR_PAT)
-		vcpu->arch.pat = data;
 	else
 		set_var_mtrr_msr(vcpu, msr, data);
 
@@ -421,13 +415,12 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		return 1;
 
 	index = fixed_msr_to_range_index(msr);
-	if (index >= 0)
+	if (index >= 0) {
 		*pdata = *(u64 *)&vcpu->arch.mtrr_state.fixed_ranges[index];
-	else if (msr == MSR_MTRRdefType)
+	} else if (msr == MSR_MTRRdefType) {
 		*pdata = vcpu->arch.mtrr_state.deftype;
-	else if (msr == MSR_IA32_CR_PAT)
-		*pdata = vcpu->arch.pat;
-	else {	/* Variable MTRRs */
+	} else {
+		/* Variable MTRRs */
 		if (is_mtrr_base_msr(msr))
 			*pdata = var_mtrr_msr_to_range(vcpu, msr)->base;
 		else
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8b356c9d8a81..d71cf924cd8f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3701,6 +3701,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_CR_PAT:
+		/*
+		 * Writes to PAT should be handled by vendor code as both SVM
+		 * and VMX track the guest's PAT in the VMCB/VMCS.
+		 */
+		WARN_ON_ONCE(1);
+
+		if (!kvm_pat_valid(data))
+			return 1;
+
+		vcpu->arch.pat = data;
+		break;
 	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
 	case MSR_MTRRdefType:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
@@ -4110,6 +4121,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	}
 	case MSR_IA32_CR_PAT:
+		msr_info->data = vcpu->arch.pat;
+		break;
 	case MSR_MTRRcap:
 	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
 	case MSR_MTRRdefType:
-- 
2.40.1.606.ga4b1b128d6-goog

