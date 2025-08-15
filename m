Return-Path: <kvm+bounces-54750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2A2B2745C
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:59:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3A371CC0502
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530751E1E0B;
	Fri, 15 Aug 2025 00:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="drO4Nayo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C015A1547E7
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755219460; cv=none; b=hVL0yj58tmC5jEp62/Cg1SY62VkCRqJeuXyNL9xtJt+uXRkbMMKAVHVtmgKFfJoeNcuGjKJZGDbDiHfYQPqL3Di4W2aGrW+DHbjFr/nGpyU0dW0mPeyYt9XC/iq7ikYODD4jLrGoNrr0+kxkX81hkhNnSwUYQoNVg1vPn0Jvys0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755219460; c=relaxed/simple;
	bh=j/1Lr+UronIgRZzRhuMgqCzyJ+s+Y1BrEcIfq0eFCQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YvRmBfJdWClRF1jwFkMMcrUdLtQ0H7btYSDlp9phTq9dm5yuTSkMPkCO6p17IJ2QdtUM08cqbH9nrKQzXiMrmxg0xRFc+gsrHD8/sRLLjFr/uGr+DvmKSUZdxsmlLunLpycagzIA8n7sRnVap0jCnlm708jGgVzCCiDhSEYhfCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=drO4Nayo; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47174b1ae5so1076160a12.2
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755219456; x=1755824256; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yn2/hQHtLRcblfHHYK8i9PorExs5KUNMzDzB5HQI7e0=;
        b=drO4Nayo3eiKFeBnW8i0c8OW9xBwxe4t8szIpNQuoSj7DpPIU8qjwOM/Smy6uHXqTa
         T9UBBgu3s6du9Wqt8QMwZtP2NeeiFEX9ha8XfwBIHPSOab1wjyUg+2jZ9fBlxuEHcjsj
         +tqdS3ng1Fjw64I8HHmCJLjMJcYVfqjy6+vRvFugt6RXT2dYoaRFno+j0WVdCL1ffNDI
         fb9iqq8szs36vemosCAQp6nWwiYtqxmPG1YXcaBknDort/c0gFV7PIbyRkf+Fm4RKJHR
         HcUKIZR6qXITFBk/izxKjOdh6/5CjHtRxVy+ONZIW1XVws6DGumgN3PYD94jxbPkv4dr
         C7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755219456; x=1755824256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yn2/hQHtLRcblfHHYK8i9PorExs5KUNMzDzB5HQI7e0=;
        b=Rz1dgPwkr8PhsHxCXXIdg6rwkrS2EKQcAouc0AXCdT77yXKSUyKqZccngIgDRUwB5q
         vFVUhIazRoPQb5bJMLspklsQ+8V770r/kO6XoJG1HnB+o4zqZEwtwdTAsdT4Of8V7NUV
         9Fo/4j0dZrJxFXaS6m1CfPX50JIASFjjedbJWMTP89MXkvjo9KGJEldYg/YHgUy3VTmp
         iZQiraS4mc2b/046x+hVTPvQPFaszfHN1h6j20otyB9HOMxDWpz1DV78QfpyE1SHkFpC
         EetUub27laFjUFsib1sLOd+1xzLhQPa/Yg7EgJj4dYj65ZcZyeid2e0bmTHOzV4Bw2TU
         +FAA==
X-Gm-Message-State: AOJu0YxiMIbSaVtrvyciUMq6c0f++CerfES9JDbNn5FfS0bqwm36bejz
	f4uQ1Ko+jz4BzOEhmi3B2ciHdRblLXnIEeWoWoMwvb2v6tD+RpP8PBzBUWtdNmiw+//mVGZQiYL
	5zVSaqg==
X-Google-Smtp-Source: AGHT+IFZL2tPxvArwSPUwK98zfaa8xkAH1W3s5f0rydb+BXhSEJ8YZvFix+N5zVp7GN4wzi4lQHdrQKHjGY=
X-Received: from pglv6.prod.google.com ([2002:a63:1506:0:b0:b47:4ef:fcee])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d85:b0:23d:c4c6:f406
 with SMTP id adf61e73a8af0-240d2f43f2emr449311637.43.1755219455963; Thu, 14
 Aug 2025 17:57:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:57:22 -0700
In-Reply-To: <20250815005725.2386187-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815005725.2386187-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815005725.2386187-5-seanjc@google.com>
Subject: [PATCH 6.12.y 4/7] KVM: VMX: Extract checking of guest's DEBUGCTL
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
index 529a10bba056..ff61093e9af7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2192,6 +2192,19 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
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
@@ -2260,19 +2273,12 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -2282,7 +2288,6 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    (data & DEBUGCTLMSR_LBR))
 			intel_pmu_create_guest_lbr_event(vcpu);
 		return 0;
-	}
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
-- 
2.51.0.rc1.163.g2494970778-goog


