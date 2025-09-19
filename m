Return-Path: <kvm+bounces-58261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A8ABB8B893
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:44:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E15D9B64599
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECC3426C3A8;
	Fri, 19 Sep 2025 22:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wDh+FfMy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE0930147D
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321247; cv=none; b=W/Zm7x1yPYX0KvJr0IFLgvlz4dPZTFlgNPj52byRFgBKxNPzsSBVUzSPoSEW15ZiBcq7dhPXJ35zZNBDMmPupxmFskNypu9Xv4J5cRSIeKR5tNvwGCZ48VM67BIUXjCCEuAphJnpz7nOsoTA9sAOfYc3V2hKeM4qW6pTQ6mO7o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321247; c=relaxed/simple;
	bh=t14sguRWljpbl7x4nvgbWsnJaQOC/jqzlJugxV5H0AE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mz7ratT8ptl/HWEEGcW2Nh7BJ2uM+YtotwVhkiLeplzJOGLwPLLsz98qjAlpAyyCtOQDpKZhjdhsxAowfxRM4nES+dDqglxQup9IKpHk0f48bgBmF5rgiV/KPD+qAnw01IOAcvo3VNjhZ0/KONJXLErdtC58ZsktR94m0x2zWL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wDh+FfMy; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-324e41e946eso3910516a91.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321245; x=1758926045; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=38k12Bd4Ltq5t6WJvitV23HrIZaBz9pCtNZ8LdkHjgw=;
        b=wDh+FfMylG5pg663/rc/BA7rbgH17VADKdJMcHM+Tgrdo2kTsOB6Cw2eQTo+yxo1xY
         tbwwNyn0xBpsZgmBIQObXxZI5IA1No7I9Gsqh5/oXSxnWYDwg3sexMKeHk2dAzHWfdq5
         A6ckT43CTSQ/4rKokQlV6+dJOXWwlFHdcoFPzZ0WR9DvF7bpTYaVdCZ/mJh4BuTu/EbN
         zqaRLk9N/BnpFCUfpRNHE86VPNLOlf8caKIiuqeA73jNaY1qt1YtaSDEXr61FvGTWq72
         tutJbBAMS2KxPH0OG16Ca2Kn4R5FUN8sTMvRnFIcfu0ayQ+jGvfkqfSD3ok80ChT5cHL
         973Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321245; x=1758926045;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=38k12Bd4Ltq5t6WJvitV23HrIZaBz9pCtNZ8LdkHjgw=;
        b=Q78sO879PLCJ6UYX8jOG/F7gRR5qrnXkVkz4Zw8qtIltAIGX8FaKpuslKghkSq297t
         gg3zJCGR34ZKbSnKT3iCGAI2x2nxrt0rUGJgkjBajmP8Bpm0FIqovQRxo78fdv7kwDs9
         gniGxujDOISNcMldrfB1GLzF9FEBHHM57B9/Er7ewRqvWWhtqEVLIgY18oX4wRUgOiuf
         PKpxCmtbRc4u4xDGvwZ/7AAYe69qkotVaw968KjIOw4y8iiERmzwjiKRkQIrxBHxHIRu
         J8PuRhypGo6D9r+E9/nbzjr/G3wrQPgLWM5upAPo2mERvTSQZHbpj2y74uP5JfnGUwQm
         Aj7Q==
X-Gm-Message-State: AOJu0YxjiwRCaBlor3orktdVYY8jJYkgseeHHQIF70t6GNperBrUP2i9
	hERlZG0Xg9Qos8oyL1ks8/sLWUQu+QRDwWYyB4g4DywAG1yRJ+eVZTS4jpLjwEJqc+T67gq/LB/
	YQjIZww==
X-Google-Smtp-Source: AGHT+IEHgK1RX3CwRx4iZWkfe3lI1+6XS8c26tUS4D9me1aiyAiWrL58aS/PovAB1NZkX/+qh9S5p+eBL7s=
X-Received: from pjbmf6.prod.google.com ([2002:a17:90b:1846:b0:32e:bd90:3e11])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b11:b0:32f:98da:c38c
 with SMTP id 98e67ed59e1d1-3309835fe90mr5750041a91.26.1758321244658; Fri, 19
 Sep 2025 15:34:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:40 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-34-seanjc@google.com>
Subject: [PATCH v16 33/51] KVM: nVMX: Add consistency checks for CET states
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

Introduce consistency checks for CET states during nested VM-entry.

A VMCS contains both guest and host CET states, each comprising the
IA32_S_CET MSR, SSP, and IA32_INTERRUPT_SSP_TABLE_ADDR MSR. Various
checks are applied to CET states during VM-entry as documented in SDM
Vol3 Chapter "VM ENTRIES". Implement all these checks during nested
VM-entry to emulate the architectural behavior.

In summary, there are three kinds of checks on guest/host CET states
during VM-entry:

A. Checks applied to both guest states and host states:

 * The IA32_S_CET field must not set any reserved bits; bits 10 (SUPPRESS)
   and 11 (TRACKER) cannot both be set.
 * SSP should not have bits 1:0 set.
 * The IA32_INTERRUPT_SSP_TABLE_ADDR field must be canonical.

B. Checks applied to host states only

 * IA32_S_CET MSR and SSP must be canonical if the CPU enters 64-bit mode
   after VM-exit. Otherwise, IA32_S_CET and SSP must have their higher 32
   bits cleared.

C. Checks applied to guest states only:

 * IA32_S_CET MSR and SSP are not required to be canonical (i.e., 63:N-1
   are identical, where N is the CPU's maximum linear-address width). But,
   bits 63:N of SSP must be identical.

Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 47 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 51c50ce9e011..024bfb4d3a72 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3100,6 +3100,17 @@ static bool is_l1_noncanonical_address_on_vmexit(u64 la, struct vmcs12 *vmcs12)
 	return !__is_canonical_address(la, l1_address_bits_on_exit);
 }
 
+static bool is_valid_cet_state(struct kvm_vcpu *vcpu, u64 s_cet, u64 ssp, u64 ssp_tbl)
+{
+	if (!kvm_is_valid_u_s_cet(vcpu, s_cet) || !IS_ALIGNED(ssp, 4))
+		return false;
+
+	if (is_noncanonical_msr_address(ssp_tbl, vcpu))
+		return false;
+
+	return true;
+}
+
 static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 				       struct vmcs12 *vmcs12)
 {
@@ -3169,6 +3180,26 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 	}
 
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE) {
+		if (CC(!is_valid_cet_state(vcpu, vmcs12->host_s_cet, vmcs12->host_ssp,
+					   vmcs12->host_ssp_tbl)))
+			return -EINVAL;
+
+		/*
+		 * IA32_S_CET and SSP must be canonical if the host will
+		 * enter 64-bit mode after VM-exit; otherwise, higher
+		 * 32-bits must be all 0s.
+		 */
+		if (ia32e) {
+			if (CC(is_noncanonical_msr_address(vmcs12->host_s_cet, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->host_ssp, vcpu)))
+				return -EINVAL;
+		} else {
+			if (CC(vmcs12->host_s_cet >> 32) || CC(vmcs12->host_ssp >> 32))
+				return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
@@ -3279,6 +3310,22 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	     CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD))))
 		return -EINVAL;
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
+		if (CC(!is_valid_cet_state(vcpu, vmcs12->guest_s_cet, vmcs12->guest_ssp,
+					   vmcs12->guest_ssp_tbl)))
+			return -EINVAL;
+
+		/*
+		 * Guest SSP must have 63:N bits identical, rather than
+		 * be canonical (i.e., 63:N-1 bits identical), where N is
+		 * the CPU's maximum linear-address width. Similar to
+		 * is_noncanonical_msr_address(), use the host's
+		 * linear-address width.
+		 */
+		if (CC(!__is_canonical_address(vmcs12->guest_ssp, max_host_virt_addr_bits() + 1)))
+			return -EINVAL;
+	}
+
 	if (nested_check_guest_non_reg_state(vmcs12))
 		return -EINVAL;
 
-- 
2.51.0.470.ga7dc726c21-goog


