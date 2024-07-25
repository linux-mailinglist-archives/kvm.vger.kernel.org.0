Return-Path: <kvm+bounces-22260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B995A93C7D7
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 19:53:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7937E28291A
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 17:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3493219E82B;
	Thu, 25 Jul 2024 17:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y7tufkBM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF27919E7E8
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 17:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721929965; cv=none; b=ZFYTUuuI84PgexzIz0ni7k69KScLiJeofiy3i32+7TPmoIKFvWekLYnCwGbMD404d+uRJPbt/LQXmQUyy70uQSUnxZ7N5tC+zKZC6a8ebsJIIOWldotdO5ox6oY5c70xJfJI4PPyFTAGlCIjUXvHS7OtfaTBJc17lNDFXFoVO0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721929965; c=relaxed/simple;
	bh=bF/RmDC1muiFR8b68LnasEDMNOGIh57mHfNhH/TZ9IA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NFNyvWfvrr+gJXOXVF3I1jjyG2CbGdfiBbS8kPQZkLn/QGMN3iIbEHQ/WrpI2c9faTmtG1APny8210h9LWniBnEpPokNnixmkP6P+S04sZjznE5OFPfSsW/4dmCgPEJFzkm26oPUD2DM+2rYlKvM5cn+oKrtHYmT1oV7eCUM0+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y7tufkBM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721929962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G0JDlgx4JpEKNjMRaudEG0UhuNLw5CjvqTILvNGGv58=;
	b=Y7tufkBM8hJb8a2+24Mb8hSh9700O8NVvaG2e0S2gMX71oaav8Kts82/8b89pLdMNOE0wv
	mXZoe52EuVaNRGRUQ+ElCoTGYlArlL11fAEQCfjMnPPMkdSDxSyJEu5Y3R6cmbZXWXNAo3
	jVWZGCcdZl1ET9dqEuWuLE1NYI1t0Ng=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-Wz2a5VeHOWeFiTS8-v5N9A-1; Thu,
 25 Jul 2024 13:52:39 -0400
X-MC-Unique: Wz2a5VeHOWeFiTS8-v5N9A-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 014D61944B2E;
	Thu, 25 Jul 2024 17:52:38 +0000 (UTC)
Received: from starship.lan (unknown [10.22.8.132])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 927383000194;
	Thu, 25 Jul 2024 17:52:35 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 1/2] KVM: nVMX: use vmx_segment_cache_clear
Date: Thu, 25 Jul 2024 13:52:31 -0400
Message-Id: <20240725175232.337266-2-mlevitsk@redhat.com>
In-Reply-To: <20240725175232.337266-1-mlevitsk@redhat.com>
References: <20240725175232.337266-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

in prepare_vmcs02_rare, call vmx_segment_cache_clear instead
of setting segment_cache.bitmask directly.

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 arch/x86/kvm/vmx/vmx.c    | 4 ----
 arch/x86/kvm/vmx/vmx.h    | 5 +++++
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 643935a0f70a..b0e5d80da941 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2469,6 +2469,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
 			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2)) {
+
 		vmcs_write16(GUEST_ES_SELECTOR, vmcs12->guest_es_selector);
 		vmcs_write16(GUEST_CS_SELECTOR, vmcs12->guest_cs_selector);
 		vmcs_write16(GUEST_SS_SELECTOR, vmcs12->guest_ss_selector);
@@ -2506,7 +2507,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_writel(GUEST_GDTR_BASE, vmcs12->guest_gdtr_base);
 		vmcs_writel(GUEST_IDTR_BASE, vmcs12->guest_idtr_base);
 
-		vmx->segment_cache.bitmask = 0;
+		vmx_segment_cache_clear(vmx);
 	}
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b3c83c06f826..fa9f307d9b18 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -524,10 +524,6 @@ static const struct kvm_vmx_segment_field {
 	VMX_SEGMENT_FIELD(LDTR),
 };
 
-static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
-{
-	vmx->segment_cache.bitmask = 0;
-}
 
 static unsigned long host_idt_base;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7b64e271a931..1689f0d59f43 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -755,4 +755,9 @@ static inline bool vmx_can_use_ipiv(struct kvm_vcpu *vcpu)
 	return  lapic_in_kernel(vcpu) && enable_ipiv;
 }
 
+static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
+{
+	vmx->segment_cache.bitmask = 0;
+}
+
 #endif /* __KVM_X86_VMX_H */
-- 
2.26.3


