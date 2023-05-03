Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8EA6F5DF0
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 20:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjECS3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 14:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjECS3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 14:29:17 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645D07DA8
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 11:29:07 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-64115e69e1eso4795293b3a.0
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 11:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683138547; x=1685730547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MYjVSO7f8c+kIFn144EZtSuJFXMcxb7hS79jWpV+usA=;
        b=uHBYwjej/DFECXibkpDHhfTivTrghGDOxsM5wpPm+2OKUgT35SLiyuAcYFfRSe3X2m
         Q3Kxx17ADvH76AXaDT3kJpvzbCkpSHft5I4S/odpDRI7L+yhK2UAparvBiSkhgjmud53
         o8S07sZWBbZfl9vP1rp1WMi4j3MXwj4+m7IHgpFe9vE9XsuCkHP2PynOCPB0N13dUrfr
         /1U+6AA0iZodAo835RTkH0TA6X2ySLHFsNdvSXdjcjI2X3CaFD1NQgrhzi+uRGKVlGAE
         hTy2IcBDTowKlnWfXEmDrPtVRklseuhmqGxUvstOhjfpSoWunaoUm/6SA7pzhbLeRiWI
         aIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683138547; x=1685730547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MYjVSO7f8c+kIFn144EZtSuJFXMcxb7hS79jWpV+usA=;
        b=BCdh0GnuNWC2P2iqK/YBxQiwSG3w9Pv2YBvO17Qo9R4iFu3lOTUv8+lu94XYHYpTZI
         Igl4532mjc4C4cKlpDE/v5nvUbar98pXThyCV1sFyr7rZJlWbzE4c2OOj6HPGCycysAL
         jYhlgUzVpa6N4auu2WlngQKqb6j/PW8PEN8A7tBFfApuE+ZYII1hLnp6R+wqfadGT0bz
         wHLaALS/qLqPHo7Kaf42qTRLc+MyTWKKWaB4EJZx+qYFMcrEBT25fVjaWIhXY0R3ythF
         8XlVYQyLNiotXza1Fywarcqy+XFlLA27mtrc8i7K+djsr5lkc7rBwk56CgMj6nkNyxE1
         tqfg==
X-Gm-Message-State: AC+VfDxg35/LT2el0NnLTRs2YGen1lbSnlRUe4Gd/JlNBDh1EBsttfM2
        GCm8GrNZ+7ofuTWlf3fux39qNJ30Q2I=
X-Google-Smtp-Source: ACHHUZ5aGf/q5xEUp0riyAAN6Net+jMN07Cmvn/fNQ/S3+kUTsXrLMg3LxQhwrZT086InrYNCPDfUT0sdTo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2292:b0:1ab:19db:f57 with SMTP id
 b18-20020a170903229200b001ab19db0f57mr271814plh.2.1683138546840; Wed, 03 May
 2023 11:29:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 May 2023 11:28:52 -0700
In-Reply-To: <20230503182852.3431281-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230503182852.3431281-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503182852.3431281-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: x86: Move PAT MSR handling out of mtrr.c
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
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

Drop handling of MSR_IA32_CR_PAT from mtrr.c now that SVM and VMX handle
writes without bouncing through kvm_set_msr_common().  PAT isn't truly an
MTRR even though it affects memory types, and more importantly isn't
factored into KVM's handling of non-coherent DMA.

The read path is and always has been trivial, i.e. burying it in the MTRR
code does more harm than good.

Inject #GP unconditionally for the PAT "handlng" in kvm_set_msr_common(),
as that code is reached if and only if KVM is buggy.  Simply deleting the
condition would provide similar functionality, but warning and explicitly
alerting userspace that KVM is buggy is desirable.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mtrr.c | 18 +++++-------------
 arch/x86/kvm/x86.c  |  4 +++-
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index d2c428f4ae42..76b132ba9df2 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -41,7 +41,6 @@ static bool msr_mtrr_valid(unsigned msr)
 	case MSR_MTRRfix4K_F0000:
 	case MSR_MTRRfix4K_F8000:
 	case MSR_MTRRdefType:
-	case MSR_IA32_CR_PAT:
 		return true;
 	}
 	return false;
@@ -60,9 +59,7 @@ bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	if (!msr_mtrr_valid(msr))
 		return false;
 
-	if (msr == MSR_IA32_CR_PAT) {
-		return kvm_pat_valid(data);
-	} else if (msr == MSR_MTRRdefType) {
+	if (msr == MSR_MTRRdefType) {
 		if (data & ~0xcff)
 			return false;
 		return valid_mtrr_type(data & 0xff);
@@ -310,8 +307,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
 	gfn_t start, end;
 	int index;
 
-	if (msr == MSR_IA32_CR_PAT || !tdp_enabled ||
-	      !kvm_arch_has_noncoherent_dma(vcpu->kvm))
+	if (!tdp_enabled || !kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return;
 
 	if (!mtrr_is_enabled(mtrr_state) && msr != MSR_MTRRdefType)
@@ -382,8 +378,6 @@ int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		*(u64 *)&vcpu->arch.mtrr_state.fixed_ranges[index] = data;
 	else if (msr == MSR_MTRRdefType)
 		vcpu->arch.mtrr_state.deftype = data;
-	else if (msr == MSR_IA32_CR_PAT)
-		vcpu->arch.pat = data;
 	else
 		set_var_mtrr_msr(vcpu, msr, data);
 
@@ -411,13 +405,11 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
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
+	} else {	/* Variable MTRRs */
 		int is_mtrr_mask;
 
 		index = (msr - 0x200) / 2;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c36256d00250..3aa93401a398 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3706,7 +3706,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * and VMX track the guest's PAT in the VMCB/VMCS.
 		 */
 		WARN_ON_ONCE(1);
-		fallthrough;
+		return 1;
 	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
 	case MSR_MTRRdefType:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
@@ -4116,6 +4116,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	}
 	case MSR_IA32_CR_PAT:
+		msr_info->data = vcpu->arch.pat;
+		break;
 	case MSR_MTRRcap:
 	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
 	case MSR_MTRRdefType:
-- 
2.40.1.495.gc816e09b53d-goog

