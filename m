Return-Path: <kvm+bounces-9576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C977861D7F
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:23:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BF891C23BD2
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 20:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FE4514DFC2;
	Fri, 23 Feb 2024 20:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wk+bWj8T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3399B14CAB4
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 20:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708719674; cv=none; b=IuvUk/CvIP1uby1j4p3DqxIbQi4AMfSP01F+BcK+wtVKpaivqg+ztR4dHlvok4r39sf9cvIrx4OM4Yzm3VvdyV5kL3Y6TwN0wk4VCFqJ2Lh5QW8EBIBB1OGbeZR02VtwCEj25I89J0swLqgbDjLGeFIsHY7O//zoQl1EXa6Zo4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708719674; c=relaxed/simple;
	bh=+lJk5AK8dlVL05cps/qThtV9mpJgp251EZLu0QB3UtM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iy4i8nFGow/ESP3VwB3FK2PEzVzklyN4wRpi6vcD0Yp+TLX2Maem49+nHDkE9t4QIO19n7vpC8rXVyN8g5SvRDOedc8UeWKtyK5mAsMASxWkojRf8IYSplJyc82iJ3a3zBIETex0ehqBAuHJZ2KL7YD004BaoVg9VyBYSpTBItc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wk+bWj8T; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2993efc802dso337184a91.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 12:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708719672; x=1709324472; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4AhBqaFKsEgrMMKsPnTb4KDGMvhddDO4DQwV/SsUl6M=;
        b=wk+bWj8T05NuASRY4t99y3sPoOQodcX+XY5Y/efVhoDnzqIR/gZsEv/FDad1IUMNdw
         TqZFbnNwa5YOi2aVNeWL/Nly6lvl8U2+QMHAyotSt6cRhSRe0HSzIWyz6GPEmCw2sqPg
         5LPOUmooA8UHT5pa0Lq3csjGLkSSZocnMFOlbm3ZK3wkalpEJCo158N2xoiQcB17ChXu
         utjpYd4SOdO4I+TTJCCQdG4WJNPHOgxHitNsbIMv+AAjk9Kdo1GXlkK8w+JQMmQZaivR
         nGIj+UD5DhwNbAjMp1w72XoZLDKWudIHnhkF5qNYKEVogbsFaMiRtPivNLEltiHN6DdO
         Idsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708719672; x=1709324472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4AhBqaFKsEgrMMKsPnTb4KDGMvhddDO4DQwV/SsUl6M=;
        b=XJouwUqU4Qy+gc+QTPeMzhiVwkZHg1WdqmxSmGTp6qJZD7fM9l0bcOylJX5So+ALqr
         Ai75SvTCa5ZLY3DU2/6sjarehPAzIJxzWi616GOg9VfDVFKtjVA+DF+DFKuoTPeEAi33
         VzQ2Tm0nmOqne2aHIMBRHMoGnnNy0ze5qwAyeIr21lWX24z0UUkI6pEAaWznoRCM6Ztg
         PqQPGuDn+zn+/NHVEds9tWOmQU/zsPVkaJjJ45mjTa98h+UlR3jMInyeoRTaMoP+KSKI
         Uh2S+lJ/bmxoxCqRSbxzPbMDo37fB/mHZvsLA2TzCZa45B49ioIT/e2SndFasu3uuIm/
         Cktg==
X-Gm-Message-State: AOJu0YwwY/m6U92gDcq+7quSZxz7ElYc9buqJ1U074l4iTZL8HWuFOQt
	0EJFYhvDK+x5We4JGWi7LxpGZigc7nTLdGLO8YH1/goCncoWHhPLUKQMovk0DHTnSCnIvYLR6Ue
	eag==
X-Google-Smtp-Source: AGHT+IGpWKvmDN9UJOkoRROg6YO/V3Lnx0DBSYyghLMqb2TYzKIvdjMkbunbt1ZlwLgd5KXFqE87krbBLRc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2d89:b0:299:4395:a21c with SMTP id
 sj9-20020a17090b2d8900b002994395a21cmr2519pjb.7.1708719672505; Fri, 23 Feb
 2024 12:21:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 12:21:04 -0800
In-Reply-To: <20240223202104.3330974-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223202104.3330974-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223202104.3330974-4-seanjc@google.com>
Subject: [PATCH v2 3/3] KVM: VMX: Combine "check" and "get" APIs for
 passthrough MSR lookups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Combine possible_passthrough_msr_slot() and is_valid_passthrough_msr()
into a single function, vmx_get_passthrough_msr_slot(), and have the
combined helper return the slot on success, using a negative value to
indicate "failure".

Combining the operations avoids iterating over the array of passthrough
MSRs twice for relevant MSRs.

Suggested-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 63 +++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 014cf47dc66b..969fd3aa0da3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -658,25 +658,14 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
 	return flexpriority_enabled && lapic_in_kernel(vcpu);
 }
 
-static int possible_passthrough_msr_slot(u32 msr)
+static int vmx_get_passthrough_msr_slot(u32 msr)
 {
-	u32 i;
-
-	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++)
-		if (vmx_possible_passthrough_msrs[i] == msr)
-			return i;
-
-	return -ENOENT;
-}
-
-static bool is_valid_passthrough_msr(u32 msr)
-{
-	bool r;
+	int i;
 
 	switch (msr) {
 	case 0x800 ... 0x8ff:
 		/* x2APIC MSRs. These are handled in vmx_update_msr_bitmap_x2apic() */
-		return true;
+		return -ENOENT;
 	case MSR_IA32_RTIT_STATUS:
 	case MSR_IA32_RTIT_OUTPUT_BASE:
 	case MSR_IA32_RTIT_OUTPUT_MASK:
@@ -691,14 +680,16 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
-		return true;
+		return -ENOENT;
 	}
 
-	r = possible_passthrough_msr_slot(msr) != -ENOENT;
-
-	WARN(!r, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
+	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
+		if (vmx_possible_passthrough_msrs[i] == msr)
+			return i;
+	}
 
-	return r;
+	WARN(1, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
+	return -ENOENT;
 }
 
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
@@ -3954,6 +3945,7 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+	int idx;
 
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
@@ -3963,16 +3955,13 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
 	 * for resync when the MSR filters change.
-	*/
-	if (is_valid_passthrough_msr(msr)) {
-		int idx = possible_passthrough_msr_slot(msr);
-
-		if (idx != -ENOENT) {
-			if (type & MSR_TYPE_R)
-				clear_bit(idx, vmx->shadow_msr_intercept.read);
-			if (type & MSR_TYPE_W)
-				clear_bit(idx, vmx->shadow_msr_intercept.write);
-		}
+	 */
+	idx = vmx_get_passthrough_msr_slot(msr);
+	if (idx >= 0) {
+		if (type & MSR_TYPE_R)
+			clear_bit(idx, vmx->shadow_msr_intercept.read);
+		if (type & MSR_TYPE_W)
+			clear_bit(idx, vmx->shadow_msr_intercept.write);
 	}
 
 	if ((type & MSR_TYPE_R) &&
@@ -3998,6 +3987,7 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+	int idx;
 
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
@@ -4008,15 +3998,12 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	 * Mark the desired intercept state in shadow bitmap, this is needed
 	 * for resync when the MSR filter changes.
 	*/
-	if (is_valid_passthrough_msr(msr)) {
-		int idx = possible_passthrough_msr_slot(msr);
-
-		if (idx != -ENOENT) {
-			if (type & MSR_TYPE_R)
-				set_bit(idx, vmx->shadow_msr_intercept.read);
-			if (type & MSR_TYPE_W)
-				set_bit(idx, vmx->shadow_msr_intercept.write);
-		}
+	idx = vmx_get_passthrough_msr_slot(msr);
+	if (idx >= 0) {
+		if (type & MSR_TYPE_R)
+			set_bit(idx, vmx->shadow_msr_intercept.read);
+		if (type & MSR_TYPE_W)
+			set_bit(idx, vmx->shadow_msr_intercept.write);
 	}
 
 	if (type & MSR_TYPE_R)
-- 
2.44.0.rc0.258.g7320e95886-goog


