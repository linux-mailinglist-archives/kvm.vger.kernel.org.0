Return-Path: <kvm+bounces-48910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E5A7DAD465F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39BE77AC86B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C057C1D88D0;
	Tue, 10 Jun 2025 22:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pJvmIVlT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E80226E6F8
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596306; cv=none; b=RSAHbrPEMwc2jpm/zx49hhHGXdzPdZ25yZ4PCDDW6qRdycQUC+JBUOnwiDLUTrc8Vd6hw0OU4bQ6QFryC3vg0XiV5xu1dLX2IVyhiUUxFkeEYRHlvbKHtZsbaHepDP54n3jc/1sHPjTcihk+IUKGOdkNNMIBB9pBBiFnJT9B9Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596306; c=relaxed/simple;
	bh=ZMrkmpCRHBNEmqTXy2uAR5fh6WPPiHvvzXeNcQCC0eI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UWu0+j1G+o/haeq/bDLYOnQLex1gLR64xrkaM+N4UxKS3XLRSU/gqjNa3/NbhOeM1lqBEVCedXoN2g6jzT+ORW5ZuxEiQIKWPp2+o5VFmHs7/LbJ90rtTjZCnacszJJrbWKu+4FEjNhIcFJt4b/FnQr3lfzl7kW1hXsmvFOSsKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pJvmIVlT; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747adea6ddbso3907336b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596305; x=1750201105; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iMsn/XCpk3SvMnv5TdPAcg1wTJ8i5wLPr3bJ43LVwSc=;
        b=pJvmIVlTFa5tVZm0GNyiMHxDSyqHoFCmkK4jNJ6VIK9fVuGbuy7mszd0p6ToK04fzc
         dp5L44H0p2K/0Xx8UrYQQxWXhyKiXv0hE92FCAE8X2iWWPfams78Sm0fLxLGwEDskHLo
         Ve8iw0TJRdoL6gyh/vVfSnO03M7aX0YfltRqUM4HvaXlGhPmn/X29ddXSBpEMBBtTvPh
         lZPiyCGdRkmVMceTFC4fw2WDZ3SoQWiEsLrSEH+CQn6VQYrIK/XnxpJL32lEs7ni4HrN
         9aC3JSHHcZLYlWOtXm+p1yzMrnspKmkJPv3ddihIMudqKIhzF1TGIwfI1lfTncmtAO7Y
         XvUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596305; x=1750201105;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iMsn/XCpk3SvMnv5TdPAcg1wTJ8i5wLPr3bJ43LVwSc=;
        b=UPBKTJjO1LhNDRoV5EJdnUXx1yB7ql9ZTPbVHFjwJ09iqi03g+83vvBoDt5jSsmJf6
         YNJYu76MgpXXuOMvux8yvWwW2RynjRfQn4F4EDFTBe4KtqZYtxf06uO4vgM63vVrEyIy
         zQeznGdmZ3VvO4oktUH1gij1KNkzbHrDTjMMJTSJH6KrGc3Pqf/fux0sV3UHs4gM8dzs
         FtWbVWPTFoWtC6TrbQjbpIKcHy+65D46hNF4Ll6lBBqiluQbusWU+rPql3Qc38ZtOYmk
         VY1da0aORtfrctRg+JIUmfPQxu5OWGjaVCXlBlf/YW0rg0Z1CfEOLK4QoRPc4VQKCo65
         i3Bg==
X-Gm-Message-State: AOJu0YzQgzOSBlkVnFczyUiyZOeIRTd+JfuNZgZYS6tOyn33brBhD/+U
	8OetuECXgDINHahpGJnvXQov5/NDKWewdXP83hxWCLSpTQQ/B1IkgN8X6ooIAjIQEHwJAa3COOF
	TVLuIjw==
X-Google-Smtp-Source: AGHT+IE0kK/JdurOn2YSGpKLeGkBXQuZuXlLOBNcSKRwobgbYBfija/k/FnwePHxSxLV3CrEwUySJM0qVwE=
X-Received: from pgbda4.prod.google.com ([2002:a05:6a02:2384:b0:b2f:1e09:528b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7a46:b0:218:bcd3:6d2e
 with SMTP id adf61e73a8af0-21f867474e5mr1981438637.36.1749596304697; Tue, 10
 Jun 2025 15:58:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:31 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-27-seanjc@google.com>
Subject: [PATCH v2 26/32] KVM: SVM: Store MSRPM pointer as "void *" instead of
 "u32 *"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
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
index 13de4f63a9c2..f9bda148273e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -277,6 +277,8 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
 static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 *msrpm02 = svm->nested.msrpm;
+	u32 *msrpm01 = svm->msrpm;
 	int i;
 
 	/*
@@ -311,7 +313,7 @@ static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_read_guest(vcpu, offset, &value, 4))
 			return false;
 
-		svm->nested.msrpm[p] = svm->msrpm[p] | value;
+		msrpm02[p] = msrpm01[p] | value;
 	}
 
 	svm->nested.force_msr_bitmap_recalc = false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5008e929b1a5..fc41ec70b6de 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -728,11 +728,11 @@ void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
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
@@ -805,7 +805,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
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
index a0c14256cc56..e078df15f1d8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -186,8 +186,11 @@ struct svm_nested_state {
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
@@ -268,7 +271,7 @@ struct vcpu_svm {
 	 */
 	u64 virt_spec_ctrl;
 
-	u32 *msrpm;
+	void *msrpm;
 
 	ulong nmi_iret_rip;
 
@@ -666,8 +669,8 @@ BUILD_SVM_MSR_BITMAP_HELPERS(void, set, __set)
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
2.50.0.rc0.642.g800a2b2222-goog


