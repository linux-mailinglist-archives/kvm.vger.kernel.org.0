Return-Path: <kvm+bounces-48923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB14AD46A0
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CDFC17C36D
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B042286D77;
	Tue, 10 Jun 2025 23:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4JqQAo08"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41DA29AAFA
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 23:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749597625; cv=none; b=ETTtisy43rLgEW0f78wWYjyhMsftZ+zHw5EjxJPW+wMrFco2RqXeOPFQhOtzfKR0CIb3yp+193RHIAmT1yd47Vo7ondOG9mowptPGwDpnTOmm7Ddu+VPry29G68nl1BeOgrBwsMQn2/7ZG+OsBw+jWHGOXUPAQMAFiTU0EHdjG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749597625; c=relaxed/simple;
	bh=blKNi5/eVsDYzPDTuqtVcEpW6PWWX74NKc4L5DVUPJY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nZoOjyb3eRR/Ey7rERgE3ylN7k5PgGdtUlEpsmqWVx8oTWIPgo6vjuJRaGZvtmSvZE52IJvjSpdcRS7vMLYQ4BdoMtASTw+KkXLJwvu5Rl9KRhaZuNkFNy6g6CwyCHP5exorTDnougSJDA6ZNdLwOQK42pq/WqH8RZSPg/WkAl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4JqQAo08; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311e7337f26so4404248a91.3
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 16:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749597623; x=1750202423; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wZCT8jtEOBxZLskW7DzyAfTB5wFIiDwQQWq62UPKKVg=;
        b=4JqQAo08u2hGRcks6/x6B/sQVj9InjeEo5HPxxFuvOxhgiifG1EXoWlomv9wa4Znex
         c7ui/WqWvhGP0eRvMDWYhETKUbyh8EokMfEzqk8dLHBjkOvJzfWw7YXwheUhOX6vRvXh
         uW77tBl//24PB0VVtuEKcu2kYZmWHTMxVpgRocjjni9OR32QY6ts73OiPqbucc6ty/Tq
         NgurfzcWM94dCN/pAKOV5FwS4mNNnQaR1pnFUreyZYL2KTUD7VamlDMzuZmdwU0zuiCh
         YdtfaabzywpxOhNZYOZEbxzsLTp45rVtaWpaqOwvhWfLTbgAZrnIi58yOWwvLTEkA2EI
         rJQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749597623; x=1750202423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wZCT8jtEOBxZLskW7DzyAfTB5wFIiDwQQWq62UPKKVg=;
        b=u7kDyAz86hp5D6YygI/2ay5lKhbMPBnpP0VAVJUECRmWKwMAhXXywYH/j+bDuw/EAF
         pHyWpVQLnXFV+eZXq40vzwjJlQTisc1b47p/nAr/nh6dAYSJ//VhQIuUf1keWKTp+O4u
         zh17qswVlTwU2iONlDm02aqk1KIsb0SEf5ymZMVYCuLrpqaW75ThXWUZMWQKY+G/wDjT
         5JBR4/S+aD4wQhYB8pxGct9G3Wlm6etDMDbuTfiisdC6La2Hfujp6JzpKKF82CSHdqKH
         yMRFYLKapG97WY6Ar0F/bRqqUGia93QjkOFq3FWAr9LuR3B8pMp69yQ5PmSHBkVVb2kB
         yyZA==
X-Gm-Message-State: AOJu0YxK4aKKqBXufRzBJGYYY4O6JmNyP4n48DUVE/DK37kXoQEver9G
	QrX9a29m6CHvGgc0xV7LQb0JQVSB7kp+7yJ9XOLkBNEb0762Upjv9jAjvnm7nxFzhh5NDHGNeMJ
	z/tzQrQ==
X-Google-Smtp-Source: AGHT+IEL/2DWvsmanYGnlyH/VBJzsS50gjIHQSz73qDhYyQ6YVFD4WjKbq6DoY3OuDN2ZWC6VE6hOcH0qFI=
X-Received: from pjbpx2.prod.google.com ([2002:a17:90b:2702:b0:313:230:89ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d07:b0:311:c970:c9bc
 with SMTP id 98e67ed59e1d1-313af21d9bfmr1797129a91.30.1749597623152; Tue, 10
 Jun 2025 16:20:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 16:20:08 -0700
In-Reply-To: <20250610232010.162191-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610232010.162191-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610232010.162191-7-seanjc@google.com>
Subject: [PATCH v6 6/8] KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

Add a consistency check for L2's guest_ia32_debugctl, as KVM only supports
a subset of hardware functionality, i.e. KVM can't rely on hardware to
detect illegal/unsupported values.  Failure to check the vmcs12 value
would allow the guest to load any harware-supported value while running L2.

Take care to exempt BTF and LBR from the validity check in order to match
KVM's behavior for writes via WRMSR, but without clobbering vmcs12.  Even
if VM_EXIT_SAVE_DEBUG_CONTROLS is set in vmcs12, L1 can reasonably expect
that vmcs12->guest_ia32_debugctl will not be modified if writes to the MSR
are being intercepted.

Arguably, KVM _should_ update vmcs12 if VM_EXIT_SAVE_DEBUG_CONTROLS is set
*and* writes to MSR_IA32_DEBUGCTLMSR are not being intercepted by L1, but
that would incur non-trivial complexity and wouldn't change the fact that
KVM's handling of DEBUGCTL is blatantly broken.  I.e. the extra complexity
is not worth carrying.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 12 ++++++++++--
 arch/x86/kvm/vmx/vmx.c    |  5 ++---
 arch/x86/kvm/vmx/vmx.h    |  3 +++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b50f9c894ab8..5a6c636954eb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2662,7 +2662,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (vmx->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
 		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
-		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
+		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl &
+						  vmx_get_supported_debugctl(vcpu, false));
 	} else {
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);
@@ -3155,7 +3156,8 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
-	    CC(!kvm_dr7_valid(vmcs12->guest_dr7)))
+	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
+	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))
 		return -EINVAL;
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
@@ -4607,6 +4609,12 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		(vmcs12->vm_entry_controls & ~VM_ENTRY_IA32E_MODE) |
 		(vm_entry_controls_get(to_vmx(vcpu)) & VM_ENTRY_IA32E_MODE);
 
+	/*
+	 * Note!  Save DR7, but intentionally don't grab DEBUGCTL from vmcs02.
+	 * Writes to DEBUGCTL that aren't intercepted by L1 are immediately
+	 * propagated to vmcs12 (see vmx_set_msr()), as the value loaded into
+	 * vmcs02 doesn't strictly track vmcs12.
+	 */
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_DEBUG_CONTROLS)
 		vmcs12->guest_dr7 = vcpu->arch.dr7;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 358c7036272a..b685e43de4e9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2172,7 +2172,7 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
 	return (unsigned long)data;
 }
 
-static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
+u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
 {
 	u64 debugctl = 0;
 
@@ -2191,8 +2191,7 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	return debugctl;
 }
 
-static bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data,
-				  bool host_initiated)
+bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
 {
 	u64 invalid;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index b5758c33c60f..392e66c7e5fe 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -414,6 +414,9 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
+u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
+bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated);
+
 /*
  * Note, early Intel manuals have the write-low and read-high bitmap offsets
  * the wrong way round.  The bitmaps control MSRs 0x00000000-0x00001fff and
-- 
2.50.0.rc0.642.g800a2b2222-goog


