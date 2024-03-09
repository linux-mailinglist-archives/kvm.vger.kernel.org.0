Return-Path: <kvm+bounces-11425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC4FB876E6B
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:11:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40959281DD9
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 715182D052;
	Sat,  9 Mar 2024 01:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DcDIPhkH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FDB249EB
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709946592; cv=none; b=h+4H0Qv0wFVYPESJXtVSZJYVdDQvobG7roFyIbQtgPkOpM28JIO5tzPf10hvabcUUfytyA6e93zlZnp+isL0FsKFNFqG503Tq5ivqFP9UF/ZlXmS72EfvvYmrML0kWJPTvo6DhJreE2Pth8ubjp1srZOxPZP8CncMm4a4VggVKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709946592; c=relaxed/simple;
	bh=pFTfX6iZ1Av6zueA4bsWCN2aQ5NYvSaaP8k39tdO/qM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZTCw9mdqHqRODLkaSCxZ/ZQCVyRE5TPMQLumBA8pAPRFlnyWj+EANbs/i3MulaP+Ve/xya1jTO8mpSbUjLDqi1Yg/57G9a3oBbBexV5Y8uX94JpY+HS2nB6KjBHoJNIiWU6sRUO7SvoMJXVA2M1ulJigwCfdm4i8nmRhTA+8vAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DcDIPhkH; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26ce0bbso5637182276.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709946590; x=1710551390; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KHsK4PsKTic4mEiyDeXzOn255RqCA20uAznQ1bSFzaA=;
        b=DcDIPhkHUmysH3Y0TXJ6f42reNgGPRYwJ7d5pAArEpKw95XynkYbg3nX1HQDZnVJkT
         MGUgkxpwSuRUez2tbDwENhrcl7iF6q39Rcg9wEW+GVMhLNBtbmyr5I1xA9deXRkt+Yn8
         xKO5MZNOIy+O+zYQJWLD226t7dajg96OTSRLYNUvBqa7HSkzKEBCHqgLU69UGLhM+Ra+
         z/wp4+DFk5h+7ETohk0ad/Fmm9FvHuLvYDqhPUIrtX0HniBUvwpSGr0yiO/Z2aobPufv
         ZEueSir1eMJUljPUluh64QhcrpywZ8qAPg7JKiID/vQLEGiIaAlT25Nku5E4KBeiRIJL
         Qf2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709946590; x=1710551390;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KHsK4PsKTic4mEiyDeXzOn255RqCA20uAznQ1bSFzaA=;
        b=balG7qY41bpALszrxf1fhPRxKAuuGjiiZ9r95T9eht0Bhgy43yC7cETHu5PKoUItrP
         fVhasO8lhdWJ0hav2n51sSDmA+ue0y3BBHP6S8w2P23qXxVeyMbunMuHc7VXf/56ZMEZ
         g7kf6V6hmkTHUB1tF/TPEMIps22pndC0sy3o5xP1as7n9ivzm8fdusI3yfqQI8Aq57ha
         hIo0FsUA6lL6FibayZF2XvQ9la+gRIU5DEaoVERgPR/1R6gkOqrMIH7oVtSsIIDEeQIE
         4GHGE+OBOZwezNrQok2qTKjimWQKl/wMzXNW08CQ/cROPqmt7LwTEtbgjgX6lgZEz3cO
         ZQ8A==
X-Gm-Message-State: AOJu0Yxs63JJmOSBrR0L5ZIx+QAx4F+jkHwPmYJHVu4fiBdrjjUSwlEd
	WUdzVw1RCpqZbJ8SeKZXQ6ybrJYNEKI9Xl8S0V6WXXSYS7DhrEdK+OkoX1sjlb4Z8qMekMC3xMc
	wZw==
X-Google-Smtp-Source: AGHT+IEIADztO63eqskrAmaEw3BTM/48kCGy4bKJDHmHBL7GXVDELSGrNLXpQbHi4xW5mpRDDxSqNyy9B8c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1886:b0:dcd:3172:7279 with SMTP id
 cj6-20020a056902188600b00dcd31727279mr118649ybb.8.1709946589958; Fri, 08 Mar
 2024 17:09:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:09:29 -0800
In-Reply-To: <20240309010929.1403984-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309010929.1403984-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309010929.1403984-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that support self-snoop
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>
Cc: kvm@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Yiwei Zhang <zzyiwei@google.com>
Content-Type: text/plain; charset="UTF-8"

Unconditionally honor guest PAT on CPUs that support self-snoop, as
Intel has confirmed that CPUs that support self-snoop always snoop caches
and store buffers.  I.e. CPUs with self-snoop maintain cache coherency
even in the presence of aliased memtypes, thus there is no need to trust
the guest behaves and only honor PAT as a last resort, as KVM does today.

Honoring guest PAT is desirable for use cases where the guest has access
to non-coherent DMA _without_ bouncing through VFIO, e.g. when a virtual
(mediated, for all intents and purposes) GPU is exposed to the guest, along
with buffers that are consumed directly by the physical GPU, i.e. which
can't be proxied by the host to ensure writes from the guest are performed
with the correct memory type for the GPU.

Cc: Yiwei Zhang <zzyiwei@google.com>
Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c |  8 +++++---
 arch/x86/kvm/vmx/vmx.c | 10 ++++++----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 403cd8f914cd..7fa514830628 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4622,14 +4622,16 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 bool kvm_mmu_may_ignore_guest_pat(void)
 {
 	/*
-	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
+	 * When EPT is enabled (shadow_memtype_mask is non-zero), the CPU does
+	 * not support self-snoop (or is affected by an erratum), and the VM
 	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
 	 * honor the memtype from the guest's PAT so that guest accesses to
 	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
 	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
-	 * KVM _always_ ignores guest PAT (when EPT is enabled).
+	 * KVM _always_ ignores or honors guest PAT, i.e. doesn't toggle SPTE
+	 * bits in response to non-coherent device (un)registration.
 	 */
-	return shadow_memtype_mask;
+	return !static_cpu_has(X86_FEATURE_SELFSNOOP) && shadow_memtype_mask;
 }
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 17a8e4fdf9c4..5dc4c24ae203 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7605,11 +7605,13 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
 	/*
 	 * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
-	 * device attached.  Letting the guest control memory types on Intel
-	 * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
-	 * the guest to behave only as a last resort.
+	 * device attached and the CPU doesn't support self-snoop.  Letting the
+	 * guest control memory types on Intel CPUs without self-snoop may
+	 * result in unexpected behavior, and so KVM's (historical) ABI is to
+	 * trust the guest to behave only as a last resort.
 	 */
-	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
+	if (!static_cpu_has(X86_FEATURE_SELFSNOOP) &&
+	    !kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
 	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);
-- 
2.44.0.278.ge034bb2e1d-goog


