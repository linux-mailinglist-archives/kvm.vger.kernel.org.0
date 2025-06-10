Return-Path: <kvm+bounces-48892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94D2AAD4639
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:59:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33D973A708C
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 22:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C3F28C2C1;
	Tue, 10 Jun 2025 22:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="llPwxt4z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD162BD5A4
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596276; cv=none; b=ggZyaxT5J2EGWbfqanXbv+/2ruo/BOlW9UOal30F1SbVcyBYpYN2IzZbkbWgIXaGe8hDkuo5EyFJNoArbOgGvKESXzkjW360Td+d/O93K6g3JBt7PJOpKAF4PL6/r/7hS0bsV8Jyp73EpfgqzkcHvrTpamT/zIDraGM4F/v5CUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596276; c=relaxed/simple;
	bh=WJ/GMU/xzF2OXuravj1ifO4vfSp1RRYL7XD1ZEUK4r8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WMhxj90/CKwaVoXZAaRqMmYLL/DRAppgKSvExrCB1deSyuBNaTwbczUIjM5CSbrL2dNt5K7789aXXVoEK5tnFpw0nYuEEQojV7d3/TGUusxhqnjUDKfMPdtSnn3gwfQIjx5AVp0gCZLfxkZZux6nbaSRkBCugt4FbAcwIuUZeow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=llPwxt4z; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-740270e168aso4844313b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596274; x=1750201074; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aPjiw0cgNLeamyirB4dOeXsfFa7tz6KDF0aXc9RAbzo=;
        b=llPwxt4zzj40mimZd8/Cky1QclkagQDGEmYsBbT/kMp0LgzSWiweMqCX32wzIPMpRn
         M1kFA66nbnCPHHfBI8Exbl1QEM7k1+1VnMqcOywxfLP0H6oPCOQVNzUxhpSsijYPWEG3
         VElhWVxV4IR4XvZ9cNrjXfimEX+ujjD6qSHRTvloN/JfydFEkcG3Pl7fpmTX257wRnLv
         clcFS+UB1o8I522FQdMmFUVI9DjQwjj0cf0rYYMpnB1Synb8Ka8vwdHXEh7jSYYksE8Z
         +9B51N39BIJVDOqObMPCcln4rODfRpLkf9sB1gEfXi8ChsyHHiI2L3y+MkfGQ7S3/B+w
         Gl/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596274; x=1750201074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aPjiw0cgNLeamyirB4dOeXsfFa7tz6KDF0aXc9RAbzo=;
        b=FLegXZ0b8RqHf20mr0+V43oCQMizJzaxD6BxbaJ8UvOjzebmcEwD9XUnh11DLzloPz
         zgDVy3gAPIRg96daYX99puZ/jCySVc9j8qzg4++8YKs+nE4x44z4ZSylBB55Bvgjr4HX
         tpnmYp5Zl4e1EBE5DIBgOKXPRcYi6fNoNEnE3IiFL5tdVBCZ7LK03KfqMudJBKgnZGAE
         53kpr5Tjsv1RJrtNWYmZ7ns7OLhtJBr9QQSvhsDCGDhLlSWZDmxu6ycC2Nb2CZLUfPmF
         9kudl0Jqb/FzJE/wY8e29uDI3WaLwT5q13ufX6Ed2WJ75ALjobeOwV870MxPVmrm6/Jk
         3QgA==
X-Gm-Message-State: AOJu0YzZkE6646QiCKiVtb5X9WJQoiYAnGYLW81TDcD2TQtDP3XUxv4U
	HmDraOS/9TWDLl69RH5HVBsS+XIN41wp977QLZoUKtBKziQXpX1r/PnmmG9SrfErndwwpC6kRNx
	Eon+n2A==
X-Google-Smtp-Source: AGHT+IHw+fYQ+JlF3Ar9HXBBbIQL6EkrfLH+q1Yr/8tHzcJ4ZaB0UZe7g+zuKBkMp6FnOc2eUNC+b4DEpMI=
X-Received: from pgmn9.prod.google.com ([2002:a63:5c49:0:b0:b2e:bfa8:7724])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6f89:b0:1f5:7ea8:a791
 with SMTP id adf61e73a8af0-21f86602592mr1755783637.10.1749596274683; Tue, 10
 Jun 2025 15:57:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:13 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-9-seanjc@google.com>
Subject: [PATCH v2 08/32] KVM: SVM: Massage name and param of helper that
 merges vmcb01 and vmcb12 MSRPMs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Rename nested_svm_vmrun_msrpm() to nested_svm_merge_msrpm() to better
capture its role, and opportunistically feed it @vcpu instead of @svm, as
grabbing "svm" only to turn around and grab svm->vcpu is rather silly.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 15 +++++++--------
 arch/x86/kvm/svm/svm.c    |  2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8427a48b8b7a..89a77f0f1cc8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -189,8 +189,9 @@ void recalc_intercepts(struct vcpu_svm *svm)
  * is optimized in that it only merges the parts where KVM MSR permission bitmap
  * may contain zero bits.
  */
-static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
+static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	int i;
 
 	/*
@@ -205,7 +206,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	if (!svm->nested.force_msr_bitmap_recalc) {
 		struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
 
-		if (kvm_hv_hypercall_enabled(&svm->vcpu) &&
+		if (kvm_hv_hypercall_enabled(vcpu) &&
 		    hve->hv_enlightenments_control.msr_bitmap &&
 		    (svm->nested.ctl.clean & BIT(HV_VMCB_NESTED_ENLIGHTENMENTS)))
 			goto set_msrpm_base_pa;
@@ -230,7 +231,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 
 		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
 
-		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4))
+		if (kvm_vcpu_read_guest(vcpu, offset, &value, 4))
 			return false;
 
 		svm->nested.msrpm[p] = svm->msrpm[p] | value;
@@ -937,7 +938,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
 		goto out_exit_err;
 
-	if (nested_svm_vmrun_msrpm(svm))
+	if (nested_svm_merge_msrpm(vcpu))
 		goto out;
 
 out_exit_err:
@@ -1819,13 +1820,11 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
 	if (WARN_ON(!is_guest_mode(vcpu)))
 		return true;
 
 	if (!vcpu->arch.pdptrs_from_userspace &&
-	    !nested_npt_enabled(svm) && is_pae_paging(vcpu))
+	    !nested_npt_enabled(to_svm(vcpu)) && is_pae_paging(vcpu))
 		/*
 		 * Reload the guest's PDPTRs since after a migration
 		 * the guest CR3 might be restored prior to setting the nested
@@ -1834,7 +1833,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 		if (CC(!load_pdptrs(vcpu, vcpu->arch.cr3)))
 			return false;
 
-	if (!nested_svm_vmrun_msrpm(svm)) {
+	if (!nested_svm_merge_msrpm(vcpu)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_EMULATION;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ec97ea1d7b38..854904a80b7e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3137,7 +3137,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 *
 		 * For nested:
 		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_svm_vmrun_msrpm.
+		 * nested_svm_merge_msrpm().
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-- 
2.50.0.rc0.642.g800a2b2222-goog


