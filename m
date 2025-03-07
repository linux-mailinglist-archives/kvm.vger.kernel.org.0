Return-Path: <kvm+bounces-40444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C7C6A5738A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:23:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41BDD3B264C
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFBC325D20B;
	Fri,  7 Mar 2025 21:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LmwAv9b0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F5B2580C7
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741382478; cv=none; b=qXUzcJuNuMbsnUi2OnBm3V70iCJ+i5DE2nss+RgfYVEniUQzwLBXahtTtiwrRV1mbKNPfnqS1oVlx8LhpIvBGK1gbkdRwIRp13m8hZpKBSl2NXvpU/24lvfguIzU5ezZC4R46pvgM0HeCZlQwqzLmjIl+zgrHaHY4xeNPuPjZYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741382478; c=relaxed/simple;
	bh=oVhy6J8zYPzN85BBLmpqithfJ/6XMYFmUsnxF4mdUEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sbmMkjnFwA8vv7S6pkkG3/oDuHIEIMhi69wODhkb6tsLp9IlhTZjDXgGMwqeMUP/w3JLrGwdKdFqG/CjzkFNklSEeKK2+YNYEZzvFKMNcMY7ZDy/1g0mbD89wRvhv+UZs2ETQB9kC6HwmSZQGlmTb2fySplgIiSdOT+BwnTRBa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LmwAv9b0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741382474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=712u4YFQkdoe20JD/1s3NmLCvZcHOnlrNs1mmmfBAes=;
	b=LmwAv9b0nRMA4LYFiaptw4+azF9wmTKrIA1rf5NQZQUOWwmP14WN4pNlyBJF2MyjLPjSBU
	HAKezaPB0OqRKIOsP11sAN2msDlWDqYe4tvpIy4ZWwD7ryZ13IGrHm2vkH0/pq/WKG9Wiv
	hKgzgyUtUh11+9Jvaiks96pIKgHPNIM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-prsPjaf_OQ-ZzD2yTKlHVw-1; Fri,
 07 Mar 2025 16:21:10 -0500
X-MC-Unique: prsPjaf_OQ-ZzD2yTKlHVw-1
X-Mimecast-MFC-AGG-ID: prsPjaf_OQ-ZzD2yTKlHVw_1741382469
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3FB3180AB16;
	Fri,  7 Mar 2025 21:21:08 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 028531956095;
	Fri,  7 Mar 2025 21:21:07 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	adrian.hunter@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v3 09/10] KVM: TDX: Save and restore IA32_DEBUGCTL
Date: Fri,  7 Mar 2025 16:20:51 -0500
Message-ID: <20250307212053.2948340-10-pbonzini@redhat.com>
In-Reply-To: <20250307212053.2948340-1-pbonzini@redhat.com>
References: <20250307212053.2948340-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Adrian Hunter <adrian.hunter@intel.com>

Save the IA32_DEBUGCTL MSR before entering a TDX VCPU and restore it
afterwards.  The TDX Module preserves bits 1, 12, and 14, so if no
other bits are set, no restore is done.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Message-ID: <20250129095902.16391-12-adrian.hunter@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5625b0801ce8..25972e12504b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -683,6 +683,8 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	else
 		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
 
+	vt->host_debugctlmsr = get_debugctlmsr();
+
 	vt->guest_state_loaded = true;
 }
 
@@ -826,11 +828,15 @@ static void tdx_load_host_xsave_state(struct kvm_vcpu *vcpu)
 	if (kvm_host.xss != (kvm_tdx->xfam & kvm_caps.supported_xss))
 		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
 }
-EXPORT_SYMBOL_GPL(kvm_load_host_xsave_state);
+
+#define TDX_DEBUGCTL_PRESERVED (DEBUGCTLMSR_BTF | \
+				DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI | \
+				DEBUGCTLMSR_FREEZE_IN_SMM)
 
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 
 	/*
 	 * force_immediate_exit requires vCPU entering for events injection with
@@ -846,6 +852,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	tdx_vcpu_enter_exit(vcpu);
 
+	if (vt->host_debugctlmsr & ~TDX_DEBUGCTL_PRESERVED)
+		update_debugctlmsr(vt->host_debugctlmsr);
+
 	tdx_load_host_xsave_state(vcpu);
 	tdx->guest_entered = true;
 
-- 
2.43.5



