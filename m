Return-Path: <kvm+bounces-58100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 367D1B878DB
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 03:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2F99581774
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C698259CA1;
	Fri, 19 Sep 2025 01:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="chiraHq+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C92244693
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 01:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758243606; cv=none; b=o6l+CI5ttTJ1/M44exLOnWUc6S0cP5h6lqHrmC1HcYKBRcFFtO9N6fnxKmCdVeLyGZrmH+Xx2U8xbMiqDQvjoZo7txk5/tlWBX18j0yJha0l52uR+LN1SFJQAQVEULVgRk9cBshybrqfSDJATN2lEqHm6qGE4XPzhM3dNlTkZJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758243606; c=relaxed/simple;
	bh=YJ2VFrZhM4qIUjqB49CAb9i42QiiedUh7facuEGSF6I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rp308IZbZqMIMUn4s73fZZJlDWYZ8/0lnAFWHFI1cmUfpNe9p8Iet/rpKJGaposc0ExSR15/zt6vbjo6QoDb1MDc4jbPFuk7bfZ3OVanNWoPWBcJNisgC0a7UTdy7sW/g0w109EX4gq1SDLdD7WhERWwBwqq6FHnKpFjme04tpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=chiraHq+; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b54b37ba2d9so2058599a12.0
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 18:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758243604; x=1758848404; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aSaDH6qLLomdBTa7b9zuhz08i6UmGSxbGqu+z1jTuOI=;
        b=chiraHq+z+5LT9T+kas3pnpFj0mBRKB5sO74/b77jfM1YbF9YlramoXwbUImiibxdF
         2d9xPMBQLe1Sk0K0S116300b42XmfKayiAmR2UEvRgfiOtzJPQbb8bgUQG6hDpRytz69
         p8FfHpIFMBTVNLtgFAzcCN1QlbEjt6ZW6uxj5GrV8msxoowazPUmh0mRwMjb+Q6k13KU
         Ttsu4RqnZ5qzoUy4yUKmMMLORX7gRaENL8RQTCk+b1IeAzG7540ZYM+G0zxkNxODqTPy
         ShfMc8pEbUrbCGxvgjwOzINDc1LjTFBaLL5xGQYfaD2lgjm/3B62+rQ1SaNwTjzZL6ad
         EG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758243604; x=1758848404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aSaDH6qLLomdBTa7b9zuhz08i6UmGSxbGqu+z1jTuOI=;
        b=m6mMGEBYQK1sEw6ioWJxJr8cQhCR9/FXXYfPtXtP9Wp5oO3r+pxYaiMFfQGnnXitQz
         AN79sLMn/GciiIyWaRYAXlVv6sYgtsXGSxAXTrAZU6nFnPzYwQIzZKoRZEUPZa7gf27I
         /NItDw5Mte2jCoh3agAwjR06OoNMR3k8Lj9Fa6s3PFh5uSvXOl7iaMtllwPM0vRsMDqT
         osmHjmdF2ih7nT2oX5QkvkR1jqZ1Y+fmdg/I5H9J+nADuf8YIeBVF1q+aE+a+CQ2z17Y
         MzG7MGCFsU7IYy0uReB3F1oRsUv4ISejDarth6G5a14V2JWQdbqSW5M0fVj8Mv2ioJeD
         Fu2A==
X-Gm-Message-State: AOJu0Yz7tjeC1+6moUgQlMAWOjNiHNRoHuXarR1KFC+3UPgKdNS4HHCO
	SiyCEOITo9k3QMSyTpyd2c9Y19nymT+OIbDQ2DsBf/Yv1JFkNrk4JE7EwD0C501pyfEwt3LarW1
	Lm/UCkw==
X-Google-Smtp-Source: AGHT+IHkbfANFhJs0yTpbydDEuN4sXTG76yXOnVp4T9Fql8goBq4reBhUHVOl+kAMRkA9URfcpUB44v/ZHg=
X-Received: from plae4.prod.google.com ([2002:a17:902:e0c4:b0:267:fa7d:b637])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc8f:b0:267:fa8d:29a6
 with SMTP id d9443c01a7336-269b9cc7179mr19973895ad.25.1758243603881; Thu, 18
 Sep 2025 18:00:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:59:50 -0700
In-Reply-To: <20250919005955.1366256-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919005955.1366256-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919005955.1366256-5-seanjc@google.com>
Subject: [PATCH 4/9] KVM: VMX: Use kvm_mmu_page role to construct EPTP, not
 current vCPU state
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Use the role for the to-be-loaded/invalidated EPT root to compute the
root's level and A/D enablement instead of pulling the information from
the vCPU (e.g. by passing in the root level and querying vmcs12).  Not
making unnecessary assumptions about the root will allow invalidating
arbitrary EPT roots (which sadly requires a full EPTP) at any given time.

No functional change intended (the end result should be the same).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 74dba9f1d098..cf2d44044da5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3201,20 +3201,40 @@ static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->vpid;
 }
 
-static u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
+static u64 construct_eptp(hpa_t root_hpa)
 {
-	u64 eptp = VMX_EPTP_MT_WB;
+	u64 eptp = root_hpa | VMX_EPTP_MT_WB;
+	struct kvm_mmu_page *root;
 
-	eptp |= (root_level == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
+	if (kvm_mmu_is_dummy_root(root_hpa))
+		return eptp | VMX_EPTP_PWL_4;
 
-	if (enable_ept_ad_bits &&
-	    (!is_guest_mode(vcpu) || nested_ept_ad_enabled(vcpu)))
+	/*
+	 * EPT roots should always have an associated MMU page.  Return a "bad"
+	 * EPTP to induce VM-Fail instead of continuing on in a unknown state.
+	 */
+	root = root_to_sp(root_hpa);
+	if (WARN_ON_ONCE(!root))
+		return INVALID_PAGE;
+
+	eptp |= (root->role.level == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
+
+	if (enable_ept_ad_bits && !root->role.ad_disabled)
 		eptp |= VMX_EPTP_AD_ENABLE_BIT;
-	eptp |= root_hpa;
 
 	return eptp;
 }
 
+static void vmx_flush_tlb_ept_root(hpa_t root_hpa)
+{
+	u64 eptp = construct_eptp(root_hpa);
+
+	if (VALID_PAGE(eptp))
+		ept_sync_context(eptp);
+	else
+		ept_sync_global();
+}
+
 void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -3225,8 +3245,7 @@ void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 		return;
 
 	if (enable_ept)
-		ept_sync_context(construct_eptp(vcpu, root_hpa,
-						mmu->root_role.level));
+		vmx_flush_tlb_ept_root(root_hpa);
 	else
 		vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
@@ -3397,11 +3416,11 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 	struct kvm *kvm = vcpu->kvm;
 	bool update_guest_cr3 = true;
 	unsigned long guest_cr3;
-	u64 eptp;
 
 	if (enable_ept) {
-		eptp = construct_eptp(vcpu, root_hpa, root_level);
-		vmcs_write64(EPT_POINTER, eptp);
+		KVM_MMU_WARN_ON(root_to_sp(root_hpa) &&
+				root_level != root_to_sp(root_hpa)->role.level);
+		vmcs_write64(EPT_POINTER, construct_eptp(root_hpa));
 
 		hv_track_root_tdp(vcpu, root_hpa);
 
-- 
2.51.0.470.ga7dc726c21-goog


