Return-Path: <kvm+bounces-58263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A60B8B8B85F
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF2A77C62E1
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:42:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636AB304972;
	Fri, 19 Sep 2025 22:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1b9lyFgP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AAD2D8DA3
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321250; cv=none; b=IIgHG0hpPL6Vu4d9+80IVv8Hpe6br7eKQx6IAjqQcOUc/bO+zaN9yc8HX1aQhVLUR3OFZz0eS9BFsmIyX95fCr5+ER0lLJ8HGZcnVJV/jqtrZ86JC5LAqCpSg1F8fwJygWp785vWCNNESCNBUD/91ijRSOhT3MjkmlBTX440qbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321250; c=relaxed/simple;
	bh=eJ+NviPvC2VBo1/TEeh/98QA5FeRA5OI+g9CJyGgcSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U4Gw5Lh1zYr/Z9iu11PKr5aOKF3XFuSHu09xk4r1t0Fan6ERBJQRP53PpRRxz6+dLvhxgsgu8j260afEY/BJ1ACG8FDSjBbNMVM0ast9QfwdtqSmw9RE6L45oS/UFidtut5A+7VKINzGdHFLz1YuMW0HUsIL68GZ3xqlr7Isv/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1b9lyFgP; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b550fab38e9so1452687a12.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321248; x=1758926048; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FxW3kEs0BxMIazulZzSPAAAeyEbA3rY5jTtxTNm7lSc=;
        b=1b9lyFgPIZZH5XCmAmCGVzqmjQYWhhXM4gkDsfmVP/lY0ToB996VHw/oUsaO2occUE
         y8otvmtGOb3Nye7HD+HqhRKDOGGkdjPVT+4uFYfZUWCZwFjyo7U2YmaV7wy6fXSpD7RU
         zf1rmvSNg09p4XrncdEMCYoN4iD34YyysXrr2lFpo2mt2p5lTMd5QT7NJEcmyqvJHDSE
         X3hxZqYJ30idmH05J6u5hszChrw112CKa5sypQDHSn4jskMPw2MI9DzP91FxjKTWbx9Y
         gtaIGyWAvzTNrXyYLrR3IUFRGCAVyQxx6gx7/V9ZnGDF1XfvdJAr9P0MNYLjwRxaxPvL
         JuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321248; x=1758926048;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FxW3kEs0BxMIazulZzSPAAAeyEbA3rY5jTtxTNm7lSc=;
        b=VcZE3R4n9ksYvuluYUoQzT0matoB7AXCtltQOlAfo0U20brhmLlEjN29KAOuSqgtwD
         RfLHyFsHadHo6OT3zYyDgm86G/nhYIl+iE4/BvmzeHCzstGDuQWyjoM90iKVaBWuP6H3
         AHAFUGqcssyW/n4/Q9kZzjoi5Y/pd/7A+abwHtxRCAUIz2RU7CA3cMXhW1fN2Lnz1RSL
         S/y5AMRAtfb+UphJrRxo6LByh8RP2BEvdT0+Oj5EwVAhsOv+SE4+7BLVIg8bCmmYJNzg
         tGYc8O04w03h41K1m1OgU19crl9QnAzORgzTUPSEkSk6OKBMv7mtcq0RWGhMhzjItuXD
         40Eg==
X-Gm-Message-State: AOJu0Yz6ziR4ApdQr8/FryiIK3WjZWHi0BGzDnqZ0w5n1szC+BpJcwBn
	ngFtzgE5DGzb4ZdCUeUhJXysHYziPk3J5oeVlWdy77hentSxZ4IYDyUD9L3pFTAVso5gA16MqlA
	b/vR/hA==
X-Google-Smtp-Source: AGHT+IE+kzZm2wI3wJsqhe11/v8urBpa1o0V7eLKMUUsTS/TrGpHSZsJlDfAudcOW7JuaCa/sws36i0ssXE=
X-Received: from pjbsv5.prod.google.com ([2002:a17:90b:5385:b0:32d:a0b1:2b14])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:19a3:b0:24c:c33e:8df0
 with SMTP id adf61e73a8af0-292727771abmr5548077637.45.1758321248405; Fri, 19
 Sep 2025 15:34:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:42 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-36-seanjc@google.com>
Subject: [PATCH v16 35/51] KVM: SVM: Emulate reads and writes to shadow stack MSRs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: John Allen <john.allen@amd.com>

Emulate shadow stack MSR access by reading and writing to the
corresponding fields in the VMCB.

Signed-off-by: John Allen <john.allen@amd.com>
[sean: mark VMCB_CET dirty/clean as appropriate]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 21 +++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  3 ++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 73dde1645e46..52d2241d8188 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2767,6 +2767,15 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (guest_cpuid_is_intel_compatible(vcpu))
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
+	case MSR_IA32_S_CET:
+		msr_info->data = svm->vmcb->save.s_cet;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		msr_info->data = svm->vmcb->save.isst_addr;
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		msr_info->data = svm->vmcb->save.ssp;
+		break;
 	case MSR_TSC_AUX:
 		msr_info->data = svm->tsc_aux;
 		break;
@@ -2999,6 +3008,18 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
 		svm->sysenter_esp_hi = guest_cpuid_is_intel_compatible(vcpu) ? (data >> 32) : 0;
 		break;
+	case MSR_IA32_S_CET:
+		svm->vmcb->save.s_cet = data;
+		vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_CET);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		svm->vmcb->save.isst_addr = data;
+		vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_CET);
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		svm->vmcb->save.ssp = data;
+		vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_CET);
+		break;
 	case MSR_TSC_AUX:
 		/*
 		 * TSC_AUX is always virtualized for SEV-ES guests when the
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5365984e82e5..e072f91045b5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -74,6 +74,7 @@ enum {
 			  * AVIC PHYSICAL_TABLE pointer,
 			  * AVIC LOGICAL_TABLE pointer
 			  */
+	VMCB_CET,	 /* S_CET, SSP, ISST_ADDR */
 	VMCB_SW = 31,    /* Reserved for hypervisor/software use */
 };
 
@@ -82,7 +83,7 @@ enum {
 	(1U << VMCB_ASID) | (1U << VMCB_INTR) |			\
 	(1U << VMCB_NPT) | (1U << VMCB_CR) | (1U << VMCB_DR) |	\
 	(1U << VMCB_DT) | (1U << VMCB_SEG) | (1U << VMCB_CR2) |	\
-	(1U << VMCB_LBR) | (1U << VMCB_AVIC) |			\
+	(1U << VMCB_LBR) | (1U << VMCB_AVIC) | (1U << VMCB_CET) | \
 	(1U << VMCB_SW))
 
 /* TPR and CR2 are always written before VMRUN */
-- 
2.51.0.470.ga7dc726c21-goog


