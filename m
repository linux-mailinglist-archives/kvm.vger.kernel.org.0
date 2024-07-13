Return-Path: <kvm+bounces-21592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 962EA930311
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 03:39:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 274CAB2347D
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 01:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CADD618C08;
	Sat, 13 Jul 2024 01:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FyVvtPTU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8548717BA7
	for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 01:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720834751; cv=none; b=NhmelFHLV+agBNUdYS+LrJwp2QX4cN2bHu8FKgMS/WeIYcU17x5kGOMIOAemf38QRiHLqhmg2dyPUfkRxCY+GjefvkG1G45ZwNNm3mr1euXUF/3Mh/6A/t7ElzTRb9gJuvRoJrqlIJSzjZopLCZL35te/+GiDGIa0NKmnqk8PXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720834751; c=relaxed/simple;
	bh=Efhe9urfMft9oi0jZu7f2pCSZUo+qOd30iufUI8lVAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UKVhNdy8aBRBmFTDK4icwTtd/WBRFwosibpXFyM54ph2UDXM0G6JkpEeKXdnisihKtkLuOhQAy2Cx/4VpnglDZkhI4P2d74fK9XYVy8EsCpGzraNARadfvKnXA4slQ5k9tccIrfYPhhLcS1P1g6a9dvWbV56j9bN4AoRq4lj76k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FyVvtPTU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720834748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=of9I7xvSvBaWtba7lyO/bYSyy6ehuMmJgdbcS7kyTbw=;
	b=FyVvtPTUW9M3e85aLDA2hKqNqsTaFmAqfELyU5a5Ht4fcTm8CP0KgUQcNZAx+2TOmgtNgh
	CSs76go2rIpGUvecXvdi95KpdIzp783Hy9JM5+GJrAdX2pBULgVxef4ZcKjKSBwRnOqHz3
	hlzdSN+oDl8gZ113+mg6UrDMyp4poGI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-48-AlzYxQsDMFeZCv6ePvENcA-1; Fri,
 12 Jul 2024 21:39:03 -0400
X-MC-Unique: AlzYxQsDMFeZCv6ePvENcA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 974311955F3B;
	Sat, 13 Jul 2024 01:39:01 +0000 (UTC)
Received: from starship.lan (unknown [10.22.18.76])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A374A3000184;
	Sat, 13 Jul 2024 01:38:59 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/2] KVM: nVMX: use vmx_segment_cache_clear
Date: Fri, 12 Jul 2024 21:38:55 -0400
Message-Id: <20240713013856.1568501-2-mlevitsk@redhat.com>
In-Reply-To: <20240713013856.1568501-1-mlevitsk@redhat.com>
References: <20240713013856.1568501-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In prepare_vmcs02_rare, call vmx_segment_cache_clear, instead
of setting the segment_cache.bitmask directly.

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +++--
 arch/x86/kvm/vmx/vmx.c    | 4 ----
 arch/x86/kvm/vmx/vmx.h    | 5 +++++
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 643935a0f70ab..d3ca1a772ae67 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2469,6 +2469,9 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
 			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2)) {
+
+		vmx_segment_cache_clear(vmx);
+
 		vmcs_write16(GUEST_ES_SELECTOR, vmcs12->guest_es_selector);
 		vmcs_write16(GUEST_CS_SELECTOR, vmcs12->guest_cs_selector);
 		vmcs_write16(GUEST_SS_SELECTOR, vmcs12->guest_ss_selector);
@@ -2505,8 +2508,6 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_writel(GUEST_TR_BASE, vmcs12->guest_tr_base);
 		vmcs_writel(GUEST_GDTR_BASE, vmcs12->guest_gdtr_base);
 		vmcs_writel(GUEST_IDTR_BASE, vmcs12->guest_idtr_base);
-
-		vmx->segment_cache.bitmask = 0;
 	}
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b3c83c06f8265..fa9f307d9b18b 100644
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
index 7b64e271a9319..1689f0d59f435 100644
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


