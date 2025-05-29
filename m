Return-Path: <kvm+bounces-48060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6238DAC8540
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5448B7B45B3
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74CF626A1CC;
	Thu, 29 May 2025 23:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WGaDQCPB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1906A26A087
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562060; cv=none; b=YzLfhwTDIA3lrVriOeaJYyQawTI/Z2DAleXnf2drLwvxl3rx55fk/l3kwzRndgd0rzTYQ16s5YkKyD2vI1dZXs/fQ1p+qcMo3LefXrbIiAp+qZo6c9yo+LnZqYGXYdjFKPW+XGRxAhAFlweOsPIdOvvO8vGJOlqXbqM/7hyYqko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562060; c=relaxed/simple;
	bh=WSoaNu660Zd2LHE7vtRJTDYgkU/FHIlWHCtZt9PFxFk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aTMHkSyq0sFnnNKiTbv9JFCkzNcbPbSTi9vThz7kZe0IFh4qigFXOut/HsGZOYFN7fdvoAqq+gsm+pkhNdkVJBHFhtWetSxcdy0W9vEFqIiW23KVjq8Y0EeM7sHdIPrLhsimbPKhKgdOE5MRYigEzaKWT3BmJPGDP7EnwNVdj1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WGaDQCPB; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23536f7c2d7so636895ad.2
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562058; x=1749166858; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=knshc8Ro6b23sXzG4OhMtI9xEOuGTz+THWgQsoLQKOM=;
        b=WGaDQCPBLIa6mYd0E5T8Kpd8cEZ5WCGWw8IRz4hOukf5y5GpmAOsxA+LH/mPgGGL2a
         DTua2UPz6vy6wtjJDR0yT1N4dUfabGH7ZTHFN/XouJ6KrGBEkn8Do6Oh8x4G5a2taMIg
         yIzvqr/8F8StLeKOvHMoRWkadPLrz7JWDpm9FXmbRZ7Ewu4vXey5URZZ/je/yriAtSv9
         nlLXbXzNQi2VuhHMlQhRLjVldZe8Z32xL276mmvainCNkm7NEqqnFL6mbRH5b93t4/n/
         5e4v48n7opL6DsSqx5r5slFDJL1IPM1OpQbPo+8FJI+SzsVHLhtC7nVX/JCfohfn+K3r
         pDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562058; x=1749166858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=knshc8Ro6b23sXzG4OhMtI9xEOuGTz+THWgQsoLQKOM=;
        b=mEm95iRiMmvS1sramTnb7tSxBmiADqAcwyFBAgSYYFEFSv12q7jrbLUZOo6eTEBW0O
         VTCwCKqB3+hm4yUczQlP5SIXWxe/3RsrFESG3wMpvFT4wp/SzIpogUH4ZM2WChOHQ8kq
         gH79vTtwBX1Vpa0L3Eqd/Mujp66B1kE5qFblcljA6uMsxoZyaGwA2jl4tj4rmt7bDyqI
         AqiZ3MRAIt3/8+41da/++jZTmqSReFJlC2zBy6+2o3Cfyzzx1ytrg6GZ9iflhttK49H/
         Mrky5e0c4JAE4cMRRDBFI49SruXEkEzivTbEF00SYbkTaXCBpohPKkc3T2kCo/14mLlh
         GR7w==
X-Gm-Message-State: AOJu0YzkAisbXDh4LLgjLkSVJK/pe0bX9CSq4wyOZlUW2YEAcXdZmLCT
	5WvQtJ9rarAk3uI2Ks6lOxBCUz5PoL9IMLj8MUAGCcZlhcYFi/amDLRu75cSrPQx98/dxlqBmhX
	ve0t8JQ==
X-Google-Smtp-Source: AGHT+IEKYGN3bgz9PNv8hfea1DfB0n41Fsnd40ZBScCazZ4iIJMrBbN2fDYm5QFjqceqs1filEr1ra9Jymg=
X-Received: from pjbsl12.prod.google.com ([2002:a17:90b:2e0c:b0:311:be10:7246])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea11:b0:235:1966:93a9
 with SMTP id d9443c01a7336-235291e7dcbmr16997285ad.3.1748562058357; Thu, 29
 May 2025 16:40:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:40:09 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-25-seanjc@google.com>
Subject: [PATCH 24/28] KVM: SVM: Store MSRPM pointer as "void *" instead of
 "u32 *"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Store KVM's MSRPM pointers as "void *" instead of "u32 *" to guard against
directly accessing the bitmaps outside of code that is explicitly written
to access the bitmaps with a specific type.

Opportunistically use svm_vcpu_free_msrpm() in svm_vcpu_free() instead of
open coding an equivalent.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c |  4 +++-
 arch/x86/kvm/svm/svm.c    |  8 ++++----
 arch/x86/kvm/svm/svm.h    | 13 ++++++++-----
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5d6525627681..e07e10fb52a5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -271,6 +271,8 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
 static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 *msrpm02 = svm->nested.msrpm;
+	u32 *msrpm01 = svm->msrpm;
 	int i;
 
 	/*
@@ -305,7 +307,7 @@ static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_read_guest(vcpu, offset, &value, 4))
 			return false;
 
-		svm->nested.msrpm[p] = svm->msrpm[p] | value;
+		msrpm02[p] = msrpm01[p] | value;
 	}
 
 	svm->nested.force_msr_bitmap_recalc = false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fa2df1c869db..6f99031c2926 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -731,11 +731,11 @@ void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	svm->nested.force_msr_bitmap_recalc = true;
 }
 
-u32 *svm_vcpu_alloc_msrpm(void)
+void *svm_vcpu_alloc_msrpm(void)
 {
 	unsigned int order = get_order(MSRPM_SIZE);
 	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, order);
-	u32 *msrpm;
+	void *msrpm;
 
 	if (!pages)
 		return NULL;
@@ -809,7 +809,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 	svm->x2avic_msrs_intercepted = intercept;
 }
 
-void svm_vcpu_free_msrpm(u32 *msrpm)
+void svm_vcpu_free_msrpm(void *msrpm)
 {
 	__free_pages(virt_to_page(msrpm), get_order(MSRPM_SIZE));
 }
@@ -1353,7 +1353,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 	sev_free_vcpu(vcpu);
 
 	__free_page(__sme_pa_to_page(svm->vmcb01.pa));
-	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
+	svm_vcpu_free_msrpm(svm->msrpm);
 }
 
 #ifdef CONFIG_CPU_MITIGATIONS
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d146c35b9bd2..77287c870967 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -189,8 +189,11 @@ struct svm_nested_state {
 	u64 vmcb12_gpa;
 	u64 last_vmcb12_gpa;
 
-	/* These are the merged vectors */
-	u32 *msrpm;
+	/*
+	 * The MSR permissions map used for vmcb02, which is the merge result
+	 * of vmcb01 and vmcb12
+	 */
+	void *msrpm;
 
 	/* A VMRUN has started but has not yet been performed, so
 	 * we cannot inject a nested vmexit yet.  */
@@ -271,7 +274,7 @@ struct vcpu_svm {
 	 */
 	u64 virt_spec_ctrl;
 
-	u32 *msrpm;
+	void *msrpm;
 
 	ulong nmi_iret_rip;
 
@@ -673,8 +676,8 @@ BUILD_SVM_MSR_BITMAP_HELPERS(void, set, __set)
 /* svm.c */
 extern bool dump_invalid_vmcb;
 
-u32 *svm_vcpu_alloc_msrpm(void);
-void svm_vcpu_free_msrpm(u32 *msrpm);
+void *svm_vcpu_alloc_msrpm(void);
+void svm_vcpu_free_msrpm(void *msrpm);
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
 void svm_enable_lbrv(struct kvm_vcpu *vcpu);
 void svm_update_lbrv(struct kvm_vcpu *vcpu);
-- 
2.49.0.1204.g71687c7c1d-goog


