Return-Path: <kvm+bounces-58258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D6FBBB8B841
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:41:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1892AA82311
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD742D878C;
	Fri, 19 Sep 2025 22:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jUqeZECN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E2E2FC879
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321240; cv=none; b=jABMC2/di5WGipl1Pa6SW22KRnB9i5HJna9loYznq5cgZyP1fSOnLTrxtqkQzfGhZjT4OUwN+nyLIDnaA1YrTO1CHpDHYQ3UgV3WYd7BK6Q5PL35wYzs+YMuMgBHZhph8J279Mpi21Uk+7mplD6Ck9Nkr8DwS+LPy+u/1tpWadU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321240; c=relaxed/simple;
	bh=WR4i1/hdD/UAQYUG4b+D0r37b5OVC230JQ21pAZcWyk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VmTP64DbPQh2Xa3lSxaa/LKnonRBVbJEkbRisy76C0XzkHeirIi8By2ec9CDCC0hTodAEKrK/M3is0zlRKKCgVzmxuZcrrNinLE1+/oFctDojJ/17gE4LVPymNDlp+tKXN3Zs3+M+kPFs9QQWOxbpg3P6sJgdNHokAmYmvInXNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jUqeZECN; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b55283ff3fcso584564a12.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321238; x=1758926038; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mCZj1AprmeC+Fo0fgebUJJjVh7kTElMFVQRkgXXYJBc=;
        b=jUqeZECN7+FGCKK57puJdziSWrcYnyaQEIdI3PT6LnHzROaGDQOwdimwoxHrvk8vdp
         mLtOFWF2pDtYk1bq365bEwLMo9EBFsHQo9ZEKXAbFm6bbO0Lw6v0dA/Fe+V6yNgC/amq
         2bUPcOR+NkOxZs/xs8zAJGlNEr7G76zd/Kaa9LQL7HFHURKdqg8TqWZntxjplcQouU0/
         qnyCrlxdrxw5PZVUOxhDTfwGkmRJpo1h99Chh7VpxUxMa1xiplORRL+zKCr7h+RfLP9J
         Lll2MDjnFJLUggOGIuazEcIAZfDxMfXE6W3Z1nEVIe08+MKwLJDZytmM5favt/u984JH
         YYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321238; x=1758926038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mCZj1AprmeC+Fo0fgebUJJjVh7kTElMFVQRkgXXYJBc=;
        b=LZeLA1rhNcjv624AEiljtnmmOhbaaDLR0r94Nb1qAQhMJh0fsGd78heVkXCHpf3aeF
         x174zk/4+kf5UnciNBWtOiU9T747nE4B2JU7Xn3ulV9e57pevkP0Fvp13NlAUu0mkGV3
         u7lVWaPPnzw5LeZX6A+UFJt0VusqSZ/H4bnoPkuTZBPGG++clIMeGT5FH9ZWWH/qkrV3
         zWim3kLgvY82GwDgVGjNPz0mPluwte+FWL80D6CsCg9T43Tw+riQP2NWrZUpfDPVqf4n
         6G06IYF9SJcLlV6gDwe/OtjXGOr1cfJx0zouKYAdm2JhE/08K/P6oRCnQ6J8mPWyd3+0
         NADQ==
X-Gm-Message-State: AOJu0YwarRAt2Zy9onDcjFchwdze0hhflxjGQLsNCVHKH4qm+lSKF+o7
	J49HjY+964cQQLOXPF3pSg5d7q5QytS9eFPpqV3mdPjJ1VW1ehTO54aPmiOq8G/S2UrImGNsJvx
	bRzV9Eg==
X-Google-Smtp-Source: AGHT+IE08Knot0aER/MkKkj+clVf2474u3XY/LuEAkLxWcUdGc2j5TSeDcijAGM3iVwTU0f6XUf1HFNdKhE=
X-Received: from pjuw14.prod.google.com ([2002:a17:90a:d60e:b0:32e:ddac:6ea5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:939f:b0:262:9461:2e59
 with SMTP id adf61e73a8af0-2926dcb867emr7398660637.39.1758321238233; Fri, 19
 Sep 2025 15:33:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:37 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-31-seanjc@google.com>
Subject: [PATCH v16 30/51] KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for L1
 event injection to L2
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Per SDM description(Vol.3D, Appendix A.1):
"If bit 56 is read as 1, software can use VM entry to deliver a hardware
exception with or without an error code, regardless of vector"

Modify has_error_code check before inject events to nested guest. Only
enforce the check when guest is in real mode, the exception is not hard
exception and the platform doesn't enumerate bit56 in VMX_BASIC, in all
other case ignore the check to make the logic consistent with SDM.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 27 ++++++++++++++++++---------
 arch/x86/kvm/vmx/nested.h |  5 +++++
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 846c07380eac..b644f4599f70 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1272,9 +1272,10 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 {
 	const u64 feature_bits = VMX_BASIC_DUAL_MONITOR_TREATMENT |
 				 VMX_BASIC_INOUT |
-				 VMX_BASIC_TRUE_CTLS;
+				 VMX_BASIC_TRUE_CTLS |
+				 VMX_BASIC_NO_HW_ERROR_CODE_CC;
 
-	const u64 reserved_bits = GENMASK_ULL(63, 56) |
+	const u64 reserved_bits = GENMASK_ULL(63, 57) |
 				  GENMASK_ULL(47, 45) |
 				  BIT_ULL(31);
 
@@ -2949,7 +2950,6 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		u8 vector = intr_info & INTR_INFO_VECTOR_MASK;
 		u32 intr_type = intr_info & INTR_INFO_INTR_TYPE_MASK;
 		bool has_error_code = intr_info & INTR_INFO_DELIVER_CODE_MASK;
-		bool should_have_error_code;
 		bool urg = nested_cpu_has2(vmcs12,
 					   SECONDARY_EXEC_UNRESTRICTED_GUEST);
 		bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
@@ -2966,12 +2966,19 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
 			return -EINVAL;
 
-		/* VM-entry interruption-info field: deliver error code */
-		should_have_error_code =
-			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
-			x86_exception_has_error_code(vector);
-		if (CC(has_error_code != should_have_error_code))
-			return -EINVAL;
+		/*
+		 * Cannot deliver error code in real mode or if the interrupt
+		 * type is not hardware exception. For other cases, do the
+		 * consistency check only if the vCPU doesn't enumerate
+		 * VMX_BASIC_NO_HW_ERROR_CODE_CC.
+		 */
+		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION) {
+			if (CC(has_error_code))
+				return -EINVAL;
+		} else if (!nested_cpu_has_no_hw_errcode_cc(vcpu)) {
+			if (CC(has_error_code != x86_exception_has_error_code(vector)))
+				return -EINVAL;
+		}
 
 		/* VM-entry exception error code */
 		if (CC(has_error_code &&
@@ -7217,6 +7224,8 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
 	msrs->basic |= VMX_BASIC_TRUE_CTLS;
 	if (cpu_has_vmx_basic_inout())
 		msrs->basic |= VMX_BASIC_INOUT;
+	if (cpu_has_vmx_basic_no_hw_errcode_cc())
+		msrs->basic |= VMX_BASIC_NO_HW_ERROR_CODE_CC;
 }
 
 static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 6eedcfc91070..983484d42ebf 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -309,6 +309,11 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
 	       __kvm_is_valid_cr4(vcpu, val);
 }
 
+static inline bool nested_cpu_has_no_hw_errcode_cc(struct kvm_vcpu *vcpu)
+{
+	return to_vmx(vcpu)->nested.msrs.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
+}
+
 /* No difference in the restrictions on guest and host CR4 in VMX operation. */
 #define nested_guest_cr4_valid	nested_cr4_valid
 #define nested_host_cr4_valid	nested_cr4_valid
-- 
2.51.0.470.ga7dc726c21-goog


