Return-Path: <kvm+bounces-54719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73E21B27392
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FC891CE0F60
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D18C2222C2;
	Fri, 15 Aug 2025 00:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V5GnQYN5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52C42AF1D
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755216766; cv=none; b=i7SknXyZH/peN6Is9C+BvkhhQOF585u5/kU8+GKNOCtjR4DXrhBB9uAyz+uavhJ1Bpgt0jqt60n0S7ZgzQRIG2rjsPfPo/RCwqQDPAc7N+qzYvZRxVNa5RDnqewOgM4RxZhlRs/DjkSgwVAj3ff7sKiLP6kg26LnwZSG1eX/b+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755216766; c=relaxed/simple;
	bh=d4VZkPw4RAyHIWRZJDzABU/cEq7qkdsgmjzT5CLiyGI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fHXjLegA1YzBY1MMGN5huMWJhsN2tUIMYIF9e9LSnGyCNM6qrpOdS2LSy1+PtpGOpHjk2hIOvnyR+4N+xmxcOdpEUvQGdim+J8sFSP5MRSOeYhFeBDTv6dPuOA1hSLec3/VldD4fym7Bt2oR1KcEUsqX/lJtd7zU72nuFO3xedA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V5GnQYN5; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244582c20e7so16659055ad.3
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755216764; x=1755821564; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eQfmi+GnDIrdp8ejQz7KjH8qWzqOpQFlk46cwdVc498=;
        b=V5GnQYN53x+sZZPDcYocLWwx8Jaa9cxT8zEbXf+PiDqEAAJuHOetTvS5Yb3PO03l4+
         gsULL0/Tv2uQ5eAYgDQ1e9oyWboJlb3kYM9dBBxiiDAcC1iPYp+Y4wJUkABpZLReCC2B
         pOxOPRm2Ue8+hUxs8i/stjZ90l+HAjZQWFGHch3fmUtO6DCQxzNdADkaS8MuS6ucV03k
         iRDwjby7Bmk1q+gROtO33562B/NUZoj5RTBdA+9RdzXndOwOSpvlD+esgwSa7bv3rPqr
         w+w0DXqHIYwHP57Q3n+S5rVqWOGAKz7DMNSW7czJclEm4nccENGApCryp5PPNgeF9R1C
         8NKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755216764; x=1755821564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eQfmi+GnDIrdp8ejQz7KjH8qWzqOpQFlk46cwdVc498=;
        b=pwB9rFwuSjnDQM/9UylOWdwjDWTGRhcCk625t2lkeBMlZ56kK9MqL+nIPP0u8uKObs
         zzYn266uDuQ4ZBU5uYLPgSjFBT72IG/zX+4kDuQDspz3CnwQHxCXPJAxZTbhpdoEW3cn
         mmjZ+dP4iE/IdVmaYyP3hzp1ZSpaQt+jW4IL8UUaIJD5c0V6uPNW6+2IAz2QJs4srhUq
         c974YZbLh6s9ObKUGojh6eAe91j7DXHAj66A/pu01fW2+HgmC1Mq4LdMPx57GeINtzcC
         8KVaYBQAerRZxnff2F+DneW/jyWdPlhZGd8yGWhqN5jup4vnNLUzwRA7wqHq8O4DRkLu
         aLeA==
X-Gm-Message-State: AOJu0YyeQNTGmGQ60YDmP+oxWRIkaHcH0SHwTIYlAg3wZcbCUg88oPeu
	l2Bu579W0PAuDo3KMrqSJ5GNvd7k2oWfQZVjH+2IO04i1f4ht96NkKTmi6yYyxo05td/e8fexrp
	eGCwpQg==
X-Google-Smtp-Source: AGHT+IFtuPHuUUf2dGJRUA8RXNywCif+lc9d/kdwZ3rsFPF10o+G2qnMZNWB7mcc8Bbok7Ll5v8EWWQ9YSk=
X-Received: from pjbqn6.prod.google.com ([2002:a17:90b:3d46:b0:31f:1a3e:fe3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cccb:b0:235:7c6:ebdb
 with SMTP id d9443c01a7336-2446d6dc1bemr1642285ad.10.1755216764117; Thu, 14
 Aug 2025 17:12:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:12:02 -0700
In-Reply-To: <20250815001205.2370711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815001205.2370711-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815001205.2370711-19-seanjc@google.com>
Subject: [PATCH 6.1.y 18/21] KVM: VMX: Extract checking of guest's DEBUGCTL
 into helper
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit 8a4351ac302cd8c19729ba2636acfd0467c22ae8 ]

Move VMX's logic to check DEBUGCTL values into a standalone helper so that
the code can be used by nested VM-Enter to apply the same logic to the
value being loaded from vmcs12.

KVM needs to explicitly check vmcs12->guest_ia32_debugctl on nested
VM-Enter, as hardware may support features that KVM does not, i.e. relying
on hardware to detect invalid guest state will result in false negatives.
Unfortunately, that means applying KVM's funky suppression of BTF and LBR
to vmcs12 so as not to break existing guests.

No functional change intended.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://lore.kernel.org/r/20250610232010.162191-6-seanjc@google.com
Stable-dep-of: 7d0cce6cbe71 ("KVM: VMX: Wrap all accesses to IA32_DEBUGCTL with getter/setter APIs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9445def2b3d2..6517b9d929bf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2071,6 +2071,19 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	return debugctl;
 }
 
+static bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data,
+				  bool host_initiated)
+{
+	u64 invalid;
+
+	invalid = data & ~vmx_get_supported_debugctl(vcpu, host_initiated);
+	if (invalid & (DEBUGCTLMSR_BTF | DEBUGCTLMSR_LBR)) {
+		kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
+		invalid &= ~(DEBUGCTLMSR_BTF | DEBUGCTLMSR_LBR);
+	}
+	return !invalid;
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2139,19 +2152,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
-	case MSR_IA32_DEBUGCTLMSR: {
-		u64 invalid;
-
-		invalid = data & ~vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
-		if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
-			kvm_pr_unimpl_wrmsr(vcpu, msr_index, data);
-			data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
-			invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
-		}
-
-		if (invalid)
+	case MSR_IA32_DEBUGCTLMSR:
+		if (!vmx_is_valid_debugctl(vcpu, data, msr_info->host_initiated))
 			return 1;
 
+		data &= vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
+
 		if (is_guest_mode(vcpu) && get_vmcs12(vcpu)->vm_exit_controls &
 						VM_EXIT_SAVE_DEBUG_CONTROLS)
 			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
@@ -2161,7 +2167,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    (data & DEBUGCTLMSR_LBR))
 			intel_pmu_create_guest_lbr_event(vcpu);
 		return 0;
-	}
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
-- 
2.51.0.rc1.163.g2494970778-goog


