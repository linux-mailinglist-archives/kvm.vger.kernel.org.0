Return-Path: <kvm+bounces-14982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 132788A87C2
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 17:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68534B22031
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 15:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C182515252D;
	Wed, 17 Apr 2024 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DlR41oAr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9608147C64
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 15:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713368099; cv=none; b=OX8ctah8W3MPZNUGs+2yOtaidkYK8CSTd5OQWPoPOO38eicwN7g0/qhnYWh5nxmEVtUYSTSZ6OHN4K2JgDp3lt1dchfmpC1+VG9mQ9vt2L3uMtl07NfI5z/HPQBLAOCcTcrcJ0nCmRQ/JCMCFpuYeLEA1glkjZ8Kg5wwslYzGik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713368099; c=relaxed/simple;
	bh=rlBoMCC4//sfGrQFFIwHVDxKJN5+vVzVUBJTEepXgqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WLFTc0LQdPb/OZmZDn0M1lavnOKsQV1rR2aZ4Ahn6UtibhoRO9dizIMDaoNzNqmKK/nLzAKnz4qmWBPVTOqBLW0xW6H81AwNIvi5tW3mMBgRsA8+epj/e67yCWI6AHUqI0frfNSjz5oXGciF5ZVR97qZIxvyLioEbALW3Z2UoLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DlR41oAr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713368095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E5+7UvXw2tljyq+ZcDpXUa1GgQHlyrzaHv6gQXx3TS8=;
	b=DlR41oArRnBxfM9MHRfBBGtYJ7SHvbARKxJKnXf6zciqjaDfKzLm8uVeRGRCRlMBJAjcDw
	3VOe8yIRxsY/0l2HehMY5JZ9sxEM2I8N+blmi+uap2cD2X7pVay4I0xbceKCr/wRfNwBTv
	c6lLgRh5l+/ATgZziMpRqsOIU9ypFR0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-32-JhPoMVDQPDui_ZWzoEHDaw-1; Wed,
 17 Apr 2024 11:34:52 -0400
X-MC-Unique: JhPoMVDQPDui_ZWzoEHDaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 000BA3C108C9;
	Wed, 17 Apr 2024 15:34:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C33B2581CD;
	Wed, 17 Apr 2024 15:34:51 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 3/7] KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
Date: Wed, 17 Apr 2024 11:34:46 -0400
Message-ID: <20240417153450.3608097-4-pbonzini@redhat.com>
In-Reply-To: <20240417153450.3608097-1-pbonzini@redhat.com>
References: <20240417153450.3608097-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

From: Isaku Yamahata <isaku.yamahata@intel.com>

Extract out __kvm_mmu_do_page_fault() from kvm_mmu_do_page_fault().  The
inner function is to initialize struct kvm_page_fault and to call the fault
handler, and the outer function handles updating stats and converting
return code.  KVM_MAP_MEMORY will call the KVM page fault handler.

This patch makes the emulation_type always set irrelevant to the return
code.  kvm_mmu_page_fault() is the only caller of kvm_mmu_do_page_fault(),
and references the value only when PF_RET_EMULATE is returned.  Therefore,
this adjustment doesn't affect functionality.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-ID: <ddf1d98420f562707b11e12c416cce8fdb986bb1.1712785629.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 38 +++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e68a60974cf4..9baae6c223ee 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -287,8 +287,8 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 				      fault->is_private);
 }
 
-static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u64 err, bool prefetch, int *emulation_type)
+static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+					  u64 err, bool prefetch, int *emulation_type)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
@@ -318,6 +318,27 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
+	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
+		r = kvm_tdp_page_fault(vcpu, &fault);
+	else
+		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
+
+	if (r == RET_PF_EMULATE && fault.is_private) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
+		r = -EFAULT;
+	}
+
+	if (fault.write_fault_to_shadow_pgtable && emulation_type)
+		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
+
+	return r;
+}
+
+static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+					u64 err, bool prefetch, int *emulation_type)
+{
+	int r;
+
 	/*
 	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
 	 * guest perspective and have already been counted at the time of the
@@ -326,18 +347,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (!prefetch)
 		vcpu->stat.pf_taken++;
 
-	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
-		r = kvm_tdp_page_fault(vcpu, &fault);
-	else
-		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
-
-	if (r == RET_PF_EMULATE && fault.is_private) {
-		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
-		return -EFAULT;
-	}
-
-	if (fault.write_fault_to_shadow_pgtable && emulation_type)
-		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
+	r = __kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, err, prefetch, emulation_type);
 
 	/*
 	 * Similar to above, prefetch faults aren't truly spurious, and the
-- 
2.43.0



