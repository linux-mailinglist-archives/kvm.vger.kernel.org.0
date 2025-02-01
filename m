Return-Path: <kvm+bounces-37030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0BD6A2464D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:41:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34DEA1883A49
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E0C165F13;
	Sat,  1 Feb 2025 01:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NHwhjkDg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1DC1547DC
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738373928; cv=none; b=gWc3hTzfB3PmUsS1e7PsB4zX8Amw/t2VMwq0GpPYqDdBhuYVXZCkMBJFW3CqZqzndMisvAV57t2cZbc1qRbG0AxMFwwkyrRmM5dZxD/ciJ4p+TtIDFhNYwF6Aq7YNBd7SQBeUOTkCpYWzDrMLPdtw8LqfrsNoPF2kDORFnjRI1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738373928; c=relaxed/simple;
	bh=j8Js95XQEzrpga5pnx540RrGXnEndIOKuhZHKerCpxs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JfV0mr8lh/h9dtbvW8J5kCqw86vUistyFv9pJks3oXy2jMqjBJoS8rvE7rIqOrLF7mmrMBqfuzhwNfbr9qPK2wuBqKkqy+3fjCSrIKTrOSEwz2pxraMPXrTIUDVvVMMO8Ih8EhpYbKUhRNjhbpAWG+QPkpUD7VI+CysZmEmd8A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NHwhjkDg; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-216387ddda8so54956365ad.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738373926; x=1738978726; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Fbz8COXaILE+Zu9vgExhJVrHHfmOCqlJc8Vvcis5s3s=;
        b=NHwhjkDg6n5Ju2/G7HLOQPs2i10IwIuE3x/w1bvABbxOUYbAXSuEP6ERU88cXEBNZN
         Q2eA3RdXoQMOfFQ/1A3avuWvLWuYyJZBvf786rlCX6GCrVhGjPwrYpoEiF0XVCMZFeZz
         plxF6e+Wz3tPgFPH8BDmMvZFq13iKC2/07LQiO5TtzMoPEBK/4wcJ555jebd7OVfnRdg
         O0n2bqeKoslL/aFQhLm9kHvYdBPcpuw/dslbTs3ZYNvYz+yB0uKA1HT0wVbmFo1jznG+
         ZHceBroIPrjYGFOagrB1LO6mcBJ3usk2XIV59reWoe9N6+SMEnd9Q7f3nI3JL3IQ8N8l
         IMLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738373926; x=1738978726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fbz8COXaILE+Zu9vgExhJVrHHfmOCqlJc8Vvcis5s3s=;
        b=qj7HLc5wZ9ZEYeib8TbSs7Lv4OgWwK26gN5gFCV067oPay9CPimEOJ9Yz5sOwfe6Sf
         WwtXA1ty/uVBSLqhZCLhWBDObw0NAc6+GKneyaD2oX8SFsiPlhe1sTs3pMNHQ4jkQ0Fh
         vg59svx8bKnTEfj09ncFaAO3Udoo4+b6hKwmMYgzEBq97yJt9QAddckoKrJyr3c5uJBB
         LpyIP0OkE+A26244an3pzUOJcOYC8u6/MkRFaA1XxiWvYyhkq3wwNqosdq3lCulqw4MD
         kh0tw7xKXliKxR+GQpFASMg3ATfSmnT6xSd5+ipOaTXibheqE/nimfAWxGmvTjx2MNu+
         k1Iw==
X-Gm-Message-State: AOJu0YwDuGA5595+cXSMwv0wUfzfMyKLDnmwKbmpZq7KHsNl8XVymoeF
	b4juwUI4d6VZvCAIrlEoCxNFEuudKW89yRbMCqtaFBmFoyg3XvdmnwXFqY0LmYAePcJuk1VQWce
	u4A==
X-Google-Smtp-Source: AGHT+IHyOOvgOUd5ePqbx3wTCArkQB9CqfpCQFadR4WVsKJKE5kfN8eBoKsb5IwVtZLwZD0aa8eEyPtUgPA=
X-Received: from pgey24.prod.google.com ([2002:a63:b518:0:b0:7fd:483d:9d10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d48d:b0:1d9:c615:d1e6
 with SMTP id adf61e73a8af0-1ed7a4095a8mr21239963637.0.1738373926016; Fri, 31
 Jan 2025 17:38:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:38:25 -0800
In-Reply-To: <20250201013827.680235-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201013827.680235-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201013827.680235-10-seanjc@google.com>
Subject: [PATCH v2 09/11] KVM: x86: Remove per-vCPU "cache" of its reference pvclock
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

Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/x86.c              | 27 +++++++++++++++------------
 arch/x86/kvm/xen.c              |  8 ++++----
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5193c3dfbce1..80ce1fc9fcb7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -900,7 +900,8 @@ struct kvm_vcpu_arch {
 	int (*complete_userspace_io)(struct kvm_vcpu *vcpu);
 
 	gpa_t time;
-	struct pvclock_vcpu_time_info hv_clock;
+	s8  pvclock_tsc_shift;
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
index 300a79f1fae5..2801c7bcc2ef 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -176,8 +176,8 @@ static int xen_get_guest_pvclock(struct kvm_vcpu *vcpu,
 	 * Sanity check TSC shift+multiplier to verify the guest's view of time
 	 * is more or less consistent.
 	 */
-	if (hv_clock->tsc_shift != vcpu->arch.hv_clock.tsc_shift ||
-	    hv_clock->tsc_to_system_mul != vcpu->arch.hv_clock.tsc_to_system_mul)
+	if (hv_clock->tsc_shift != vcpu->arch.pvclock_tsc_shift ||
+	    hv_clock->tsc_to_system_mul != vcpu->arch.pvclock_tsc_mul)
 		return -EINVAL;
 
 	return 0;
@@ -2316,8 +2316,8 @@ void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
 
 	entry = kvm_find_cpuid_entry_index(vcpu, function, 1);
 	if (entry) {
-		entry->ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
-		entry->edx = vcpu->arch.hv_clock.tsc_shift;
+		entry->ecx = vcpu->arch.pvclock_tsc_mul;
+		entry->edx = vcpu->arch.pvclock_tsc_shift;
 	}
 
 	entry = kvm_find_cpuid_entry_index(vcpu, function, 2);
-- 
2.48.1.362.g079036d154-goog


