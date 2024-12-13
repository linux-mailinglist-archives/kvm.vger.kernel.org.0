Return-Path: <kvm+bounces-33770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF8039F16F1
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 21:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F7121888B7A
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4021F12FB;
	Fri, 13 Dec 2024 19:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XKZ0w+WJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF51419006B
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119847; cv=none; b=J4aX4xGyJv/ANAzqYMQsN7Q6Gm9aTv5rczy9aNiUGoFCsDUQoW/Dv/778gXSnC/C/HfW32ovEsAXCiEZRhCfMeSb7TKPAUcabFfKgaWPWXKPGXkvZ/OThcLOO5t1aRvOhRGCFqqRZrEbcIaDZ1iy2cx4e+2OUllkuwwEhtCyM1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119847; c=relaxed/simple;
	bh=KwyoWLg1RWlEOBWO5XWRdKbJLstg/BpPqZ0AsFwBm4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UxlxbyZLPNLZctceJ+f3iy1XQBNT66c/Pp43W/uk9JqARH7jddoaZc389xi/NwnsVBc75fmm9T0cJvdRXIw67acJJ4RtQ1W7assemLSpYYEtIzowlSrp2Tu49UBRt+qlOX8DWCsgZJ35P/py1vbS9ToFyTQ3TfZoeYiqs6XEGUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XKZ0w+WJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734119844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y/k+MmjcrqZbMldppPf+KGY6ObW1YY9/+0aancvF1Ig=;
	b=XKZ0w+WJ1gnvVLfdSY6ArgobFeIgUNNcHGsGWlXpUruplO5gMA189Y3cjRHKxck+ktEhkk
	RoHQGZkKNaQTRGdJZaP1vpwZa9nxkSor2zMrXRkQgYUa1mPXYseVOxHXK26F+YjK5K7710
	mHKpVRuW8cnCtApWoN818Jh7HCsVWOw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-501-IuhxMTt2MW-CZnBjMhR30g-1; Fri,
 13 Dec 2024 14:57:21 -0500
X-MC-Unique: IuhxMTt2MW-CZnBjMhR30g-1
X-Mimecast-MFC-AGG-ID: IuhxMTt2MW-CZnBjMhR30g
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8C5A19560AF;
	Fri, 13 Dec 2024 19:57:19 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E59C4195605A;
	Fri, 13 Dec 2024 19:57:18 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 05/18] KVM: x86/mmu: Add an is_mirror member for union kvm_mmu_page_role
Date: Fri, 13 Dec 2024 14:56:58 -0500
Message-ID: <20241213195711.316050-6-pbonzini@redhat.com>
In-Reply-To: <20241213195711.316050-1-pbonzini@redhat.com>
References: <20241213195711.316050-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce a "is_mirror" member to the kvm_mmu_page_role union to identify
SPTEs associated with the mirrored EPT.

The TDX module maintains the private half of the EPT mapped in the TD in
its protected memory. KVM keeps a copy of the private GPAs in a mirrored
EPT tree within host memory. This "is_mirror" attribute enables vCPUs to
find and get the root page of mirrored EPT from the MMU root list for a
guest TD. This also allows KVM MMU code to detect changes in mirrored EPT
according to the "is_mirror" mmu page role and propagate the changes to
the private EPT managed by TDX module.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-6-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/mmu/mmu_internal.h | 5 +++++
 arch/x86/kvm/mmu/spte.h         | 5 +++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5f020b097922..cae88f023caf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -349,7 +349,8 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned passthrough:1;
-		unsigned :5;
+		unsigned is_mirror:1;
+		unsigned :4;
 
 		/*
 		 * This is left at the top of the word so that
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d9425064ecc5..ff00341f26a2 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -157,6 +157,11 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return kvm_mmu_role_as_id(sp->role);
 }
 
+static inline bool is_mirror_sp(const struct kvm_mmu_page *sp)
+{
+	return sp->role.is_mirror;
+}
+
 static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index f332b33bc817..49070122f60b 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -276,6 +276,11 @@ static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
 	return spte_to_child_sp(root);
 }
 
+static inline bool is_mirror_sptep(u64 *sptep)
+{
+	return is_mirror_sp(sptep_to_sp(sptep));
+}
+
 static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
 	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
-- 
2.43.5



