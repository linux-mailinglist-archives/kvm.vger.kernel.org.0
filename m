Return-Path: <kvm+bounces-39389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA78FA46BB4
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:02:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CE3E188CFE1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 071B425BCE2;
	Wed, 26 Feb 2025 19:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q1q9fp6O"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60947280A3A
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599775; cv=none; b=Mcp61wVUlmxKLmP3dQWIPmf+leTQejsIjjaTkmb5wHjQsEYzdZD2Apyb450m0coZ3icYXUp9WmJqwJVFaH1AqMPZTE5J9960sq+7p/pjB3pklV4jFfSYTF5MgOczVTcCK5C7RW+BEyNJX3Jy6NAMDWrKMC1vWxxTD3M/1PGPjI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599775; c=relaxed/simple;
	bh=KEhVu0MXnvjzc1qVWl89tw6jMbGzoJMjFYHerlDTWZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U/wjXrLBnAbhxuvGHQLgfyMa9VPqlwmlzJjH/xQmbw2JArhy1//tCuEJ8GveSqaDQmn7kazhKSGp+tIftV7vHQnqwQLGhUUzG42xPyNmByqie+qkuPu3uHCigMLZrH5/k/A4oqgd17pbNMhMe5XzpswzBHbTBBlDM2wqw6ERjZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q1q9fp6O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wBV10B36RcIKttTB1JsYke+OmG+SSB9zJ7GgxF04TbQ=;
	b=Q1q9fp6OcjfhfJd6lEahJZdfHheLZBscUkYLQozR4KG/NJcwXx2gbQdF0GAOgPstsfZ3WW
	zDTWMg80J+S6eYL/GDp3y3EAOnqXcIbS7IwERv15i6BtDwcnpUJNPJsTx6uUxod8ZTSvfJ
	pkcyRDIUEM0r2Yc30NC8xOKUb+1P6E4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-L7Yg1B5oMSOe1v2t0B1SBg-1; Wed,
 26 Feb 2025 14:56:10 -0500
X-MC-Unique: L7Yg1B5oMSOe1v2t0B1SBg-1
X-Mimecast-MFC-AGG-ID: L7Yg1B5oMSOe1v2t0B1SBg_1740599768
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D1A11801A23;
	Wed, 26 Feb 2025 19:56:05 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B0E0E19560AE;
	Wed, 26 Feb 2025 19:56:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 26/29] KVM: x86/mmu: Add parameter "kvm" to kvm_mmu_page_ad_need_write_protect()
Date: Wed, 26 Feb 2025 14:55:26 -0500
Message-ID: <20250226195529.2314580-27-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Yan Zhao <yan.y.zhao@intel.com>

Add a parameter "kvm" to kvm_mmu_page_ad_need_write_protect() and its
caller tdp_mmu_need_write_protect().

This is a preparation to make cpu_dirty_log_size a per-VM value rather than
a system-wide value.

No function changes expected.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu_internal.h |  3 ++-
 arch/x86/kvm/mmu/spte.c         |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 12 ++++++------
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 75f00598289d..86d6d4f82cf4 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -187,7 +187,8 @@ static inline gfn_t kvm_gfn_root_bits(const struct kvm *kvm, const struct kvm_mm
 	return kvm_gfn_direct_bits(kvm);
 }
 
-static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
+static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm *kvm,
+						      struct kvm_mmu_page *sp)
 {
 	/*
 	 * When using the EPT page-modification log, the GPAs in the CPU dirty
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index e819d16655b6..a609d5b58b69 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -168,7 +168,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	if (sp->role.ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED;
-	else if (kvm_mmu_page_ad_need_write_protect(sp))
+	else if (kvm_mmu_page_ad_need_write_protect(vcpu->kvm, sp))
 		spte |= SPTE_TDP_AD_WRPROT_ONLY;
 
 	spte |= shadow_present_mask;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 22675a5746d0..fd0a7792386b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1613,21 +1613,21 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 	}
 }
 
-static bool tdp_mmu_need_write_protect(struct kvm_mmu_page *sp)
+static bool tdp_mmu_need_write_protect(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	/*
 	 * All TDP MMU shadow pages share the same role as their root, aside
 	 * from level, so it is valid to key off any shadow page to determine if
 	 * write protection is needed for an entire tree.
 	 */
-	return kvm_mmu_page_ad_need_write_protect(sp) || !kvm_ad_enabled;
+	return kvm_mmu_page_ad_need_write_protect(kvm, sp) || !kvm_ad_enabled;
 }
 
 static void clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 				  gfn_t start, gfn_t end)
 {
-	const u64 dbit = tdp_mmu_need_write_protect(root) ? PT_WRITABLE_MASK :
-							    shadow_dirty_mask;
+	const u64 dbit = tdp_mmu_need_write_protect(kvm, root) ?
+			 PT_WRITABLE_MASK : shadow_dirty_mask;
 	struct tdp_iter iter;
 
 	rcu_read_lock();
@@ -1672,8 +1672,8 @@ void kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 				  gfn_t gfn, unsigned long mask, bool wrprot)
 {
-	const u64 dbit = (wrprot || tdp_mmu_need_write_protect(root)) ? PT_WRITABLE_MASK :
-									shadow_dirty_mask;
+	const u64 dbit = (wrprot || tdp_mmu_need_write_protect(kvm, root)) ?
+			  PT_WRITABLE_MASK : shadow_dirty_mask;
 	struct tdp_iter iter;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-- 
2.43.5



