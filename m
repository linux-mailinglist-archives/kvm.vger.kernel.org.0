Return-Path: <kvm+bounces-57466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C945B55A2C
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:30:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C18D85C1D9A
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7806E2DCF55;
	Fri, 12 Sep 2025 23:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bmp1dC+P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79DB2DC330
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719448; cv=none; b=dYDTt/DRJp73NjxBoxWaNovsdgnt53cB942ZpWhfVio2PecALsBFOupKqkKjEQKsUz6BbdvozbQiBNGTG4MdkeBlzTUPkuWUbQF2vyv/1FPMHMc820CmCGXrJVPriebOPgYvwJHpIUZp4hviElTVaAdL4gpVYOUELvQR/Wkjgrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719448; c=relaxed/simple;
	bh=MPZBvYn5dIhEZftsLXy+k1gliAtB05haepqZLfWlI+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EjA1QptbgPLqy5vWhpHmaYnByRMuTKFaQFqxp8nyJFGmDDYW4w744lgN3fls9JaXPYq0fafgecn77xh+c1IXiA9IbbVPsgRLsjkdiEXcrwLVkacWWkOe14IcDOeWCXFNjS5lQhqVLLsyTJVwGZDgGgtYlGmu6jYyb+GXLdXQ69w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bmp1dC+P; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329745d6b89so4103651a91.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719446; x=1758324246; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=04uvHjxAqDu/hC/6pYykcUt3v/Ox1tG5Jh6i2BGlxXk=;
        b=bmp1dC+P+WNg5NtZp3TICmvJyu5leYSOWk2XEBrLvdRWnL8cArxcsC1VDDNPkBit2U
         dx7hDVO7GVJAed4HfnHCNJiTkFSM1fzcVt2yEAV+6H8+St8eaMb1nvkhfBwlCBBerac7
         1kmvi6xHfxn1Q7hT5Xp18SDaSrgAdGPIPhPmgOvYq5fdMnpnDR3MUbTcWcp0rca9YRnm
         dJ6ZLy8JB8gt8impI+odA8d5CiuGsLGF2wl+S91c6Ag3upWYxSkNJg08TxhZj70FNTe7
         i1vCPeyXeFiasaf2v69FgVeovfM0Y+biLJXKGtLKn34uBBpVypoVnVsp7OISOzyhdQgw
         T5VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719446; x=1758324246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=04uvHjxAqDu/hC/6pYykcUt3v/Ox1tG5Jh6i2BGlxXk=;
        b=AXoQejY1vqBUoyj0NGv3Po305vtGZDjDvTpLCXyqu6t1l3nA6yFdjlAQ03Q1s4+KJI
         9tTvo3dGLw0Y8CpW3ZeHYQKvaZtwUdlqQleegD/iNp/wYqzhQmmUb08TkCc1jvSRLs4q
         xICB2MyL2Dp5/dIaMhaGeBMAqa9ZiWovMid97yCgQQ0/P1KO6dzmc5FWuVGk7ut9UWD/
         n7LCelxRMya2ez4W/1YbvLMCVZNGfV0nfWxE38FhzB/2ov0JjImptzqSGdHSZNhxW1XU
         Mw+1XZFH0AFP54HRqXK7B1A9VUxpv3HtDwpoTV7FMyINOkfOyU72u6FS3r07OQWynu/b
         IamQ==
X-Gm-Message-State: AOJu0Yzhdg1pbuYi0vf2r1fDt7ky7urM9diPdFlcHAvUWiCNnRo4rVHk
	DvuACB0Kfacjc5FRm1jlni4AMoP8XSEEPJNFns3b+nLoRjVdvAybpCKpNqtoDGygEKD1IqZLFJ6
	Ja/CjVg==
X-Google-Smtp-Source: AGHT+IEzQt6auq3+8YRv+SuIK8SxREofv/BnooxdLXGs0d7AyO5RocHDIBzoU5UiRRPS8qyHEi9SECBARug=
X-Received: from pjtu6.prod.google.com ([2002:a17:90a:c886:b0:32d:a0b1:2b14])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:fc4d:b0:329:e729:b2a1
 with SMTP id 98e67ed59e1d1-32de4fa1c8bmr5081666a91.35.1757719446146; Fri, 12
 Sep 2025 16:24:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:01 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-24-seanjc@google.com>
Subject: [PATCH v15 23/41] KVM: nVMX: Add consistency checks for CET states
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
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
index a73f38d7eea1..edb3b877a0f6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3101,6 +3101,17 @@ static bool is_l1_noncanonical_address_on_vmexit(u64 la, struct vmcs12 *vmcs12)
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
@@ -3170,6 +3181,26 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
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
 
@@ -3280,6 +3311,22 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
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
2.51.0.384.g4c02a37b29-goog


