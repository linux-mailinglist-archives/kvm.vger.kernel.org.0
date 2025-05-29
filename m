Return-Path: <kvm+bounces-48042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D1CE3AC851D
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F9FA188E3A7
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E6D25D528;
	Thu, 29 May 2025 23:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m2Z8NOBk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B659225CC58
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562029; cv=none; b=ZZCVnJC3Swt6tJ6jVrtlEM1N4kGXepPv18LYnHDtlVoGtJGQZ2tHXxcNtz8m+YL0qurO6JzrglOIL/85cvzzA31GkXhJElANK5KdSGKv/xc6yz99LaY8DlkMJCSh2gNslPfncG0WKzMWolefkGvpm6MG46nKqCKDkrYiSLZZuD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562029; c=relaxed/simple;
	bh=+qYBmtWfUwDirUdRQAtfld3p05w+5yq6poVdVjXZPpQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LD8jJABG2ejMzcAkE7nP/fWMVd59OMpu5QTS5mHPqjEw2XONLCojSk+T/rYncyW2YTOyaX21dxASaorDmWONYSg8APd3bio+WiY8XQpYZWQUpYjFG6E69orwINQFEXQRcPA51bIPU9rFgNg9UyFSWSKPaPgF/JqA7jW3/uK2y2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m2Z8NOBk; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c1983c331so928859a12.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562027; x=1749166827; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+l3DllnxgLclFv27C4flOMaDND8WKfWHnpQV8Q7v+0Y=;
        b=m2Z8NOBkSoE4QZIZRRrR/ZUemRuKQLhgXPWD7pg06NOOJvXtkltuPnOPSce+e4W11j
         EAv1bc1Rko1UO1O5t4GzSa1Cv/1rp2EAQ8i/ZP2MrZ4BMnxuUdu/lSfzz/zHp5H3Vfjz
         372IbsSa0eoQf4AZBh6w2dCBAhnaJaPPRWvfbFiDy6vPMQrkxn6QGXJasjmLj22N0XX9
         eQEDmqLWoSQ4g5ohLOVYO87yx0QVio5v0onO/d5k2f8Mmxurr4lmPLRLcTNJgRmOyZvC
         R8ExGSWcS7+ewkPqsdi6eNNsrU4Lg7HPpWl2vfrdKRXhQhi71XpCg2IYlri/GdevksGQ
         iZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562027; x=1749166827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+l3DllnxgLclFv27C4flOMaDND8WKfWHnpQV8Q7v+0Y=;
        b=h75tYTjjugE7OEYpJDOLsgWD5GFtQPU0EKAbdkZJTcGLielkvZhdcQ6X0HIxuLFGpt
         1qPV9R+5C5g0DjAXGmsb90QpjVpw4B44hHW/O2177P3cg/0kVQG3/TJ7ATRpI7TjFXiJ
         xuGCNIh4NHKc98SKofY0BmkzSFvqdrYBHEH9ysGs5QzU/gO4YDPrnKCMfjvnEuZvyE0z
         +P35ZwoBHDAVyj0loXg5xCvhyq+6V+kLrRgs5Z8WZal1SOU3ToIug3iomZz+UOvtg4lf
         VRnN5M88JP+vvWXYIPHwgunC/0ItIRxHomQ5Fck526cbj06O4bZX7TF2BAIbOZvB/Ndp
         JoDg==
X-Gm-Message-State: AOJu0YwM/rP9D/PK+MxwshRG2PiPX5enTNzFb1z0/EPXurAmUQMRm4st
	AMhniakA3nTgbQCaBdgZpNaU29qdIQosTA6yejXW/vPNVLq1gF51raL+mcYPf9lRzxnPv4BIl1Z
	f0M8nRw==
X-Google-Smtp-Source: AGHT+IE8hRF9MNbz9si+cVnX3Cbcas1of5dIl9L4ynwiHwvAcsCN757reK5T37MulNWh2rqCZMWj6dnG4vI=
X-Received: from pjbee14.prod.google.com ([2002:a17:90a:fc4e:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c08:b0:311:baa0:89be
 with SMTP id 98e67ed59e1d1-31241e9c313mr1520350a91.34.1748562027004; Thu, 29
 May 2025 16:40:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:51 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-7-seanjc@google.com>
Subject: [PATCH 06/28] KVM: SVM: Massage name and param of helper that merges
 vmcb01 and vmcb12 MSRPMs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Renam nested_svm_vmrun_msrpm() to nested_svm_merge_msrpm() to better
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
index b55a60e79a73..2085259644b6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3134,7 +3134,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 *
 		 * For nested:
 		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_svm_vmrun_msrpm.
+		 * nested_svm_merge_msrpm().
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-- 
2.49.0.1204.g71687c7c1d-goog


