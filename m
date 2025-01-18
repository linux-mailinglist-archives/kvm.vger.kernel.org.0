Return-Path: <kvm+bounces-35910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F25E0A15AB4
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:58:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25BE73A2C24
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD41618A6D2;
	Sat, 18 Jan 2025 00:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UBVy+9Ps"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D901850B5
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737161772; cv=none; b=i9bRjmSRDXyzlPbl9Gwg9dT9a4iOAWVOnW8gPrHLGtOxY8XGXXLCBeyQX84E/p4T1DNwUB2aTxzbCPc0Myhrmn+085PY9QrZBaNdkEJILRI4rus+cn2rn+KZV3tW5mYe+9qIN1zVj8rxOF0QbHHsRhyyRZNT+vSBjyWLIXitPoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737161772; c=relaxed/simple;
	bh=MlMCaN4C4GVV0w3D6Tva9o5mp4aTS3X/nOMX8xQEZzw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dWo1KuV6qDFeZbWrdRDJGyk76zSkQ7anb2sfN4a0oPZ+ac6NmMunsTH0NGGUzrHgjSpZ2hGQCDqCHfHvSq3lfPqpfnmHmMB8POGdtz/w+wpmKkv4aXlZ8O8+Y/msGeSsR71aEdwa8XGi3Dbz0EdNHpm0C00FkGmgd15NnURmoMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UBVy+9Ps; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21a7cbe3b56so38013885ad.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737161769; x=1737766569; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Xe76inQQED+VDi+GOM1bZpRo/JAeJ3yY7og1Pn73/dU=;
        b=UBVy+9Ps2M5R+xEiXeKdfcOMLAarv0KF69bYAKJxCx36PzgudtsDma+uXfrXtRCDDk
         YQBvouZcn7mqbTxdznfVmHK/gtGTdfhhlvxhhLiAcEtEsI9e1U9m6H7HHGpLdr1HEyKv
         pCeCcZqIaJObAchCvxlF5qrePz8M2LnAZULXJFsZPcnU/W7yiU4GIPUMlM0y8yu3Hzfl
         yXcu4JHwFKruTer4f3lkrHKBH8bmvRiIlqZji6ZtHfw19VLxiIQIX0ePqj9zlsfRqq/P
         e922EgMI0/7C/lqB4l2aO8ABD4iYu0J381zXcnvIakMpvShM9K951DIZfB6qsO3hvU+v
         bq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737161769; x=1737766569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xe76inQQED+VDi+GOM1bZpRo/JAeJ3yY7og1Pn73/dU=;
        b=uvw2wDcFD7Ns/fmv6WXoX+oyMUyUI9r6aGfgCI6iGrs66xM/CGO5vngM4k5MY1X5MS
         Y57nF1bYQ7c+4vmFqkCEQdFH+oDZ+hI3d+rUriYxBntKhlfuOSe0+xFiCew3GT0YlhOg
         fpJvC9NRYUyZJ9jhBQRR0t4+9NIph7byfMLfbBlS6mZ5n014piGkwcL3Mrp7+Oyn77ha
         qreIkA1SerDgaq1hiPKtGPP4NBEDZ/a/xn0P0IpnONktGzb+Azfnfu9iCy3ljMGWk0JJ
         nGmhmX9ZScC2VozCJNnv+mHnEZct3NkEgpa5JWqQVGnbp3H1ehHAP+x7KK0SgoY2yy0Q
         MXiw==
X-Gm-Message-State: AOJu0YyNgPUdFwSjvx+3R9u8dVjHvdaLGulGpaEBpdpHda5ACPVlMCA6
	nDtY4gI+8sGrP/KzsBuA+nWSt/rHOzgSHNJWYu28C+/12fPJohCHMBjAbf5/KIl0J/5hDFrGx3D
	Ykg==
X-Google-Smtp-Source: AGHT+IEwP7oMktyaCLjiLHcanbI8N9janBfFwvH46GF7ZKFwrHrokmvqDB/j3xfVz2pJ9k+Y3S5lFTl0l78=
X-Received: from pjbsf7.prod.google.com ([2002:a17:90b:51c7:b0:2ef:71b9:f22f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da88:b0:216:69ca:773b
 with SMTP id d9443c01a7336-21c352c7b99mr77384315ad.5.1737161768921; Fri, 17
 Jan 2025 16:56:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:55:50 -0800
In-Reply-To: <20250118005552.2626804-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118005552.2626804-9-seanjc@google.com>
Subject: [PATCH 08/10] KVM: x86: Remove per-vCPU "cache" of its reference pvclock
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Remove the per-vCPU "cache" of the reference pvclock and instead cache
only the TSC shift+multiplier.  All other fields in pvclock are fully
recomputed by kvm_guest_time_update(), i.e. aren't actually persisted.

In addition to shaving a few bytes, explicitly tracking the TSC shift/mul
fields makes it easier to see that those fields are tied to hw_tsc_khz
(they exist to avoid having to do expensive math in the common case).
And conversely, not tracking the other fields makes it easier to see that
things like the version number are pulled from the guest's copy, not from
KVM's reference.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/x86.c              | 27 +++++++++++++++------------
 arch/x86/kvm/xen.c              |  8 ++++----
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5193c3dfbce1..f26105654ec4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -900,7 +900,8 @@ struct kvm_vcpu_arch {
 	int (*complete_userspace_io)(struct kvm_vcpu *vcpu);
 
 	gpa_t time;
-	struct pvclock_vcpu_time_info hv_clock;
+	u8  pvclock_tsc_shift;
+	u32 pvclock_tsc_mul;
 	unsigned int hw_tsc_khz;
 	struct gfn_to_pfn_cache pv_time;
 	/* set guest stopped flag in pvclock flags field */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 06d27b3cc207..9eabd70891dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3170,6 +3170,7 @@ static void kvm_setup_guest_pvclock(struct pvclock_vcpu_time_info *ref_hv_clock,
 
 static int kvm_guest_time_update(struct kvm_vcpu *v)
 {
+	struct pvclock_vcpu_time_info hv_clock = {};
 	unsigned long flags, tgt_tsc_khz;
 	unsigned seq;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
@@ -3247,20 +3248,22 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
 		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
-				   &vcpu->hv_clock.tsc_shift,
-				   &vcpu->hv_clock.tsc_to_system_mul);
+				   &vcpu->pvclock_tsc_shift,
+				   &vcpu->pvclock_tsc_mul);
 		vcpu->hw_tsc_khz = tgt_tsc_khz;
 		kvm_xen_update_tsc_info(v);
 	}
 
-	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
-	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
+	hv_clock.tsc_shift = vcpu->pvclock_tsc_shift;
+	hv_clock.tsc_to_system_mul = vcpu->pvclock_tsc_mul;
+	hv_clock.tsc_timestamp = tsc_timestamp;
+	hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
 	vcpu->last_guest_tsc = tsc_timestamp;
 
 	/* If the host uses TSC clocksource, then it is stable */
-	vcpu->hv_clock.flags = 0;
+	hv_clock.flags = 0;
 	if (use_master_clock)
-		vcpu->hv_clock.flags |= PVCLOCK_TSC_STABLE_BIT;
+		hv_clock.flags |= PVCLOCK_TSC_STABLE_BIT;
 
 	if (vcpu->pv_time.active) {
 		/*
@@ -3269,24 +3272,24 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 		 * is active/enabled.
 		 */
 		if (vcpu->pvclock_set_guest_stopped_request) {
-			vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
+			hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
 			vcpu->pvclock_set_guest_stopped_request = false;
 		}
-		kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->pv_time, 0, false);
+		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->pv_time, 0, false);
 
-		vcpu->hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
+		hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
 	}
 
 #ifdef CONFIG_KVM_XEN
 	if (vcpu->xen.vcpu_info_cache.active)
-		kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->xen.vcpu_info_cache,
+		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_info_cache,
 					offsetof(struct compat_vcpu_info, time),
 					xen_pvclock_tsc_unstable);
 	if (vcpu->xen.vcpu_time_info_cache.active)
-		kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->xen.vcpu_time_info_cache, 0,
+		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_time_info_cache, 0,
 					xen_pvclock_tsc_unstable);
 #endif
-	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
+	kvm_hv_setup_tsc_page(v->kvm, &hv_clock);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index b82c28223585..7c6e4172527a 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -177,8 +177,8 @@ static int xen_get_guest_pvclock(struct kvm_vcpu *vcpu,
 	 * Sanity check TSC shift+multiplier to verify the guest's view of time
 	 * is more or less consistent.
 	 */
-	if (hv_clock->tsc_shift != vcpu->arch.hv_clock.tsc_shift ||
-	    hv_clock->tsc_to_system_mul != vcpu->arch.hv_clock.tsc_to_system_mul)
+	if (hv_clock->tsc_shift != vcpu->arch.pvclock_tsc_shift ||
+	    hv_clock->tsc_to_system_mul != vcpu->arch.pvclock_tsc_mul)
 		return -EINVAL;
 	return 0;
 }
@@ -2309,8 +2309,8 @@ void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
 
 	entry = kvm_find_cpuid_entry_index(vcpu, function, 1);
 	if (entry) {
-		entry->ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
-		entry->edx = vcpu->arch.hv_clock.tsc_shift;
+		entry->ecx = vcpu->arch.pvclock_tsc_mul;
+		entry->edx = vcpu->arch.pvclock_tsc_shift;
 	}
 
 	entry = kvm_find_cpuid_entry_index(vcpu, function, 2);
-- 
2.48.0.rc2.279.g1de40edade-goog


