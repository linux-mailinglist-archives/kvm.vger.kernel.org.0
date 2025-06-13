Return-Path: <kvm+bounces-49405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3A9AD8A0A
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 13:11:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74C4E1755EB
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 11:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B30E82D5C6E;
	Fri, 13 Jun 2025 11:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUHC+ATL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3F822068B;
	Fri, 13 Jun 2025 11:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749813057; cv=none; b=nzJCdK60zCIMLPkHy+m/ySV/xSg2IPFLRLIDQO044G61xL1Q69Bk6zjFm2TboHz4ZArb7vlwt8Ky2DnOm6/7Ck/0RGXRfx7s8zoooWkI4cdWEr4CWLGjLo6xG9t0QPQjkN8lHHv9khczX1HZHX7MTk1VGBP2o9RqMqMOCClYssg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749813057; c=relaxed/simple;
	bh=nqcNfAjez4t2LCKvoq5bpoXC7iX2OBaEBtNQOCotT0U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Aj4SSGv95enpq1badqgSveQhy6ovZZ6kVqx4h0RIDHpW9D5uDj945Vkxs3kFY9BwBxZgLQ5yoTqFjWkzrbVbMcMFySlFVMIAgwQ8/MIaaEkcIJMH1u4cX+7xRTELC1wTF1kgzTBaZPIdltNE2X03FNemHdys6cRPQ9W4S7kW8LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nUHC+ATL; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3109f106867so2811265a91.1;
        Fri, 13 Jun 2025 04:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749813055; x=1750417855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pjq9+JX8WsaLdGnn1+7SfmKmSzLW5G0sJkt8ZHS3y44=;
        b=nUHC+ATLAhyW3vqmXfaFbWwEwndPinTAXtKHpHW/0hc1FNCJle+zUvvWf6y8ZeF2yb
         Ja21TnbP/6V4KB8WUAAdqSgVPtpDRrbNuXbZrT8sSQCTjwmnY8f6yqyV1i9ls/2GL7yJ
         zPG1T5mMoP69Mcq6/yTVkw4L7MDiNRAKeVrdnK+EytIWTaBRr6LC/DCiI/4gEg48q0kO
         ZoHhshsgQ1ADI2Hdw7CuBVvI1vya1+evJGgJ3HEC1W6WHugIrXHrh0n4rcu5/9XAk1hW
         zWIgfHhMZSjfJxTxnyjWza5CA4ycGMpsbKRcbEE/EYCkfsl3huEjQUwmNT2TwpSjO9qx
         yiCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749813055; x=1750417855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pjq9+JX8WsaLdGnn1+7SfmKmSzLW5G0sJkt8ZHS3y44=;
        b=Ldfq0MJc4d3MK0KZtfgTZ+Au8cF0mos9Sn2BmPoLAnzDswiwR1Bwr4yQYtVkPJ2lQL
         KO1yN54L0XalKfGTUdfLb6CCq54ifH3gcYIqTGyuz6YhjKQzQGc3g207Nu0/bnA/50CI
         c+mb+0F4x7nxiYM0r52mjN9jTeDWj3nhQ0lKtVKS/2nE4EKHonisuEa8a6+R7qniWSG1
         NQGxKWP4y0R76Gdn3Ah4/QnIkrto7j3TBFg8KestfJ0UplPGFL0Fg+tzsYJIXp4vAw6Y
         nHvzMYeV/I6kFSPBuB9z75ORV5Rh5PeZv7SuZ1JP2Ody3Fk3TDkwelu59zeNAmM0yg0R
         wUyg==
X-Gm-Message-State: AOJu0YzrvNjFRuXJsGqKIKig1trWBFk7ypiv4/4ro5Oo4bcmA60Tildk
	0GW3DtwGrGfBHmENG0t3r8EESv91Fx/hXrlDJ55Qgue2DRWn2GPOWJFaR02Tpivy
X-Gm-Gg: ASbGncuvRl1FT5J+CKVGoHRVRZhj0Jzfm21kk6K8YflC3OE26FhDs73QBVdvPraIsP7
	Zieo0gL8Ld2obLFbryScRETg5etLXkZJDrVkTL27RCkTUBdZR/Y0ZegLwMurFh0xKEBIyNMbS+q
	1+vjyNtgiYKL2qexxZQ+/21m7dBRH76ZesbYvt0a2skHJxKW13h7SbdsWKF6YUUFpPBSW0mhSCk
	bCDLHFLaJMHkWvTZE+QUsLtMVezYzbxoFqSPP04oT5q4YqMXVe+tdC2dU/EKxWQYAkbORr0Xitg
	Hk7j7jGyMhGDCLg+Cn3d7B7DUni3E0yGA4S1sOBNZvpZSrhZy0+daHos//JPn+6YqC4U6ifv1KY
	gxWM+BpI3cQFY1Q71wlDSuOeW
X-Google-Smtp-Source: AGHT+IHfRwox69GaH8QDbY14sRwksh/UEvMXYrDxlZ65hWPRfJClaBjLNOS90tBS4bM/aA0UQVLpPw==
X-Received: by 2002:a17:90b:2e48:b0:311:ff18:b83e with SMTP id 98e67ed59e1d1-313d9c2eefamr4680540a91.9.1749813043460;
        Fri, 13 Jun 2025 04:10:43 -0700 (PDT)
Received: from avinash-INBOOK-Y2-PLUS.. ([27.63.22.176])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365de77610sm11809105ad.135.2025.06.13.04.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 04:10:43 -0700 (PDT)
From: avinashlalotra <abinashlalotra@gmail.com>
X-Google-Original-From: avinashlalotra <abinashsinghlalotra@gmail.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	vkuznets@redhat.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	avinashlalotra <abinashsinghlalotra@gmail.com>
Subject: [RFC PATCH] KVM: x86: Dynamically allocate bitmap to fix -Wframe-larger-than error
Date: Fri, 13 Jun 2025 16:40:23 +0530
Message-ID: <20250613111023.786265-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Building the kernel with LLVM fails due to
a stack frame size overflow in `kvm_hv_flush_tlb()`:

    arch/x86/kvm/hyperv.c:2001:12: error: stack frame size (1336) exceeds limit (1024) in 'kvm_hv_flush_tlb' [-Werror,-Wframe-larger-than]

The issue is caused by a large bitmap allocated on the stack. To resolve
this, dynamically allocate the bitmap using `bitmap_zalloc()` and free it with
`bitmap_free()` after use. This reduces the function's stack usage and avoids
the compiler error when `-Werror` is set.

New variable 'ret' is introduced to return after freeing the allocated memory.
"HV_STATUS_INSUFFICIENT_MEMORY" is returned when memory allocation fails .
I checked the functions calling this functions and It seems this error code
will not affect the existing system.

Please provide me feedback about this patch . There were more warnings like that,
So If this is the correct way to fic such issues then I will submit patches for
them.

This follows similar prior fixes, such as:
https://lore.kernel.org/all/ab75a444-22a1-47f5-b3c0-253660395b5a@arm.com/
where a large on-stack `struct device` was moved to heap memory in
`arm_lpae_do_selftests()` for the same reason.

Signed-off-by: avinashlalotra <abinashsinghlalotra@gmail.com>
---
 arch/x86/kvm/hyperv.c | 48 ++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 24f0318c50d7..78bb8d58fe94 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2005,7 +2005,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
-	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
+	unsigned long *vcpu_mask;
 	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
 	/*
 	 * Normally, there can be no more than 'KVM_HV_TLB_FLUSH_FIFO_SIZE'
@@ -2019,6 +2019,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	struct kvm_vcpu *v;
 	unsigned long i;
 	bool all_cpus;
+	u64 ret;
+
+	vcpu_mask = bitmap_zalloc(KVM_MAX_VCPUS, GFP_KERNEL);
+	if (!vcpu_mask)
+		return HV_STATUS_INSUFFICIENT_MEMORY;
 
 	/*
 	 * The Hyper-V TLFS doesn't allow more than HV_MAX_SPARSE_VCPU_BANKS
@@ -2036,8 +2041,10 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	 */
 	if (!hc->fast && is_guest_mode(vcpu)) {
 		hc->ingpa = translate_nested_gpa(vcpu, hc->ingpa, 0, NULL);
-		if (unlikely(hc->ingpa == INVALID_GPA))
-			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		if (unlikely(hc->ingpa == INVALID_GPA)){
+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			goto out_free;
+		}
 	}
 
 	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST ||
@@ -2049,8 +2056,10 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			hc->consumed_xmm_halves = 1;
 		} else {
 			if (unlikely(kvm_read_guest(kvm, hc->ingpa,
-						    &flush, sizeof(flush))))
-				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+						    &flush, sizeof(flush)))) {
+				ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+				goto out_free;
+							}
 			hc->data_offset = sizeof(flush);
 		}
 
@@ -2079,8 +2088,10 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			hc->consumed_xmm_halves = 2;
 		} else {
 			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
-						    sizeof(flush_ex))))
-				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+						    sizeof(flush_ex)))){
+				ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+				goto out_free;
+							}
 			hc->data_offset = sizeof(flush_ex);
 		}
 
@@ -2093,15 +2104,19 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		all_cpus = flush_ex.hv_vp_set.format !=
 			HV_GENERIC_SET_SPARSE_4K;
 
-		if (hc->var_cnt != hweight64(valid_bank_mask))
-			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		if (hc->var_cnt != hweight64(valid_bank_mask)){
+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			goto out_free;
+		}
 
 		if (!all_cpus) {
 			if (!hc->var_cnt)
 				goto ret_success;
 
-			if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks))
-				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+			if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks)){
+				ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+				goto out_free;
+			}
 		}
 
 		/*
@@ -2122,8 +2137,10 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	    hc->rep_cnt > ARRAY_SIZE(__tlb_flush_entries)) {
 		tlb_flush_entries = NULL;
 	} else {
-		if (kvm_hv_get_tlb_flush_entries(kvm, hc, __tlb_flush_entries))
-			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		if (kvm_hv_get_tlb_flush_entries(kvm, hc, __tlb_flush_entries)){
+				ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+				goto out_free;
+		}
 		tlb_flush_entries = __tlb_flush_entries;
 	}
 
@@ -2189,8 +2206,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 
 ret_success:
 	/* We always do full TLB flush, set 'Reps completed' = 'Rep Count' */
-	return (u64)HV_STATUS_SUCCESS |
+	ret = (u64)HV_STATUS_SUCCESS |
 		((u64)hc->rep_cnt << HV_HYPERCALL_REP_COMP_OFFSET);
+out_free:
+	bitmap_free(vcpu_mask);
+	return ret;
 }
 
 static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
-- 
2.43.0


