Return-Path: <kvm+bounces-39975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D40A4D36A
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F4231897867
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9BD1F5849;
	Tue,  4 Mar 2025 06:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dqhm52/G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FEB1F5433
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 06:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068422; cv=none; b=OVXRyBNVyz9FbE63SXkYVM3KxX346bnSndioE5S2fCdpQ882EaKlG1Zs75LN4sRgV3asvu538y2kzE5fenoxJXz2i34vG7muVT+hdySvF4yc0I1vMUiP8DpFnj+WMG7ZcKaudxA/QXfDXE8gYLePZMPRnG7IoS4P6Jdh4JfHw/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068422; c=relaxed/simple;
	bh=iOSAiW4WpF4v5d0VAGs15/GBrFx+OAAYgRlcaQOyWj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XHwh+1Gloc5vS0uqheuSf3YBjMfBUupCFXFRW1Q8cqLOuyTTtDsguIUTvgqD5poy5E2X5tnu1W7drjB7n8YXpc53Tm7z+D0eMJBVn6KNZakhZTCw/O5cu1BgXzz8cd3iD6+swTSMYOu+2UgQ+g1zpJSBz0G+zvo0d7LVq6HGHUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dqhm52/G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741068419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X4h8VUytVj+mjefQ2Pu4Vx1Jjo3WiDVNeFWyLU2rt10=;
	b=dqhm52/GhTMREyaAY9Ih/vdmhghyKtzo4UeB500TemhoutmrukYSOiLECnXWFfS0q95vuX
	rEDhBYkjMBFtGzoOsSwvwQ2K/RhwFT6l6MTnBenGsw6G/Txh9tvZp0zxEmhIZHSiPoyj5U
	1oIap5bMx/GIFJkVoLtNxc4582vzvRg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-377-arSJYdM9OKq1ppyBIUqCRA-1; Tue,
 04 Mar 2025 01:06:56 -0500
X-MC-Unique: arSJYdM9OKq1ppyBIUqCRA-1
X-Mimecast-MFC-AGG-ID: arSJYdM9OKq1ppyBIUqCRA_1741068415
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29BC61954B1A;
	Tue,  4 Mar 2025 06:06:55 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 29FE819560A3;
	Tue,  4 Mar 2025 06:06:54 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	seanjc@google.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 5/6] KVM: x86: remove shadow_memtype_mask
Date: Tue,  4 Mar 2025 01:06:46 -0500
Message-ID: <20250304060647.2903469-6-pbonzini@redhat.com>
In-Reply-To: <20250304060647.2903469-1-pbonzini@redhat.com>
References: <20250304060647.2903469-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The IGNORE_GUEST_PAT quirk is inapplicable, and thus always-disabled,
if shadow_memtype_mask is zero.  As long as vmx_get_mt_mask is not
called for the shadow paging case, there is no need to consult
shadow_memtype_mask and it can be removed altogether.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c  | 15 ---------------
 arch/x86/kvm/mmu/spte.c | 19 ++-----------------
 arch/x86/kvm/mmu/spte.h |  1 -
 arch/x86/kvm/vmx/vmx.c  |  2 ++
 arch/x86/kvm/x86.c      |  4 +++-
 5 files changed, 7 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9d6294f76d19..33c6d1d7e3e5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4663,21 +4663,6 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 }
 #endif
 
-bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm)
-{
-	/*
-	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
-	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
-	 * honor the memtype from the guest's PAT so that guest accesses to
-	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
-	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA.
-	 * KVM _always_ ignores guest PAT, when EPT is enabled and when quirk
-	 * KVM_X86_QUIRK_IGNORE_GUEST_PAT is enabled or the CPU lacks the
-	 * ability to safely honor guest PAT.
-	 */
-	return kvm_check_has_quirk(kvm, KVM_X86_QUIRK_IGNORE_GUEST_PAT);
-}
-
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index a609d5b58b69..f279153a1588 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -37,7 +37,6 @@ u64 __read_mostly shadow_mmio_value;
 u64 __read_mostly shadow_mmio_mask;
 u64 __read_mostly shadow_mmio_access_mask;
 u64 __read_mostly shadow_present_mask;
-u64 __read_mostly shadow_memtype_mask;
 u64 __read_mostly shadow_me_value;
 u64 __read_mostly shadow_me_mask;
 u64 __read_mostly shadow_acc_track_mask;
@@ -203,9 +202,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
 
-	if (shadow_memtype_mask)
-		spte |= kvm_x86_call(get_mt_mask)(vcpu, gfn,
-						  kvm_is_mmio_pfn(pfn));
+	spte |= kvm_x86_call(get_mt_mask)(vcpu, gfn, kvm_is_mmio_pfn(pfn));
 	if (host_writable)
 		spte |= shadow_host_writable_mask;
 	else
@@ -460,13 +457,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
 	shadow_present_mask	=
 		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_BIT;
-	/*
-	 * EPT overrides the host MTRRs, and so KVM must program the desired
-	 * memtype directly into the SPTEs.  Note, this mask is just the mask
-	 * of all bits that factor into the memtype, the actual memtype must be
-	 * dynamically calculated, e.g. to ensure host MMIO is mapped UC.
-	 */
-	shadow_memtype_mask	= VMX_EPT_MT_MASK | VMX_EPT_IPAT_BIT;
+
 	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
 	shadow_host_writable_mask = EPT_SPTE_HOST_WRITABLE;
 	shadow_mmu_writable_mask  = EPT_SPTE_MMU_WRITABLE;
@@ -518,12 +509,6 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_x_mask		= 0;
 	shadow_present_mask	= PT_PRESENT_MASK;
 
-	/*
-	 * For shadow paging and NPT, KVM uses PAT entry '0' to encode WB
-	 * memtype in the SPTEs, i.e. relies on host MTRRs to provide the
-	 * correct memtype (WB is the "weakest" memtype).
-	 */
-	shadow_memtype_mask	= 0;
 	shadow_acc_track_mask	= 0;
 	shadow_me_mask		= 0;
 	shadow_me_value		= 0;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 59746854c0af..249027efff0c 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -187,7 +187,6 @@ extern u64 __read_mostly shadow_mmio_value;
 extern u64 __read_mostly shadow_mmio_mask;
 extern u64 __read_mostly shadow_mmio_access_mask;
 extern u64 __read_mostly shadow_present_mask;
-extern u64 __read_mostly shadow_memtype_mask;
 extern u64 __read_mostly shadow_me_value;
 extern u64 __read_mostly shadow_me_mask;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 719e79712339..b119dd8a66f1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8438,6 +8438,8 @@ __init int vmx_hardware_setup(void)
 	if (enable_ept)
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
 				      cpu_has_vmx_ept_execute_only());
+	else
+		vt_x86_ops.get_mt_mask = NULL;
 
 	/*
 	 * Setup shadow_me_value/shadow_me_mask to include MKTME KeyID
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5b45fca3ddfa..8bf50cecc75c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13544,8 +13544,10 @@ static void kvm_noncoherent_dma_assignment_start_or_stop(struct kvm *kvm)
 	 * due to toggling the "ignore PAT" bit.  Zap all SPTEs when the first
 	 * (or last) non-coherent device is (un)registered to so that new SPTEs
 	 * with the correct "ignore guest PAT" setting are created.
+	 *
+	 * If KVM always honors guest PAT, however, there is nothing to do.
 	 */
-	if (kvm_mmu_may_ignore_guest_pat(kvm))
+	if (kvm_check_has_quirk(kvm, KVM_X86_QUIRK_IGNORE_GUEST_PAT))
 		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
 }
 
-- 
2.43.5



