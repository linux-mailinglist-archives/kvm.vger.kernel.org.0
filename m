Return-Path: <kvm+bounces-40445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38675A57392
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:24:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8E511898A67
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23382580F3;
	Fri,  7 Mar 2025 21:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="czHqe6HC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAA72580DD
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741382482; cv=none; b=jxBXYoDApMzW+7axdNQ7l//gWtpvXZHTERGxhto/6WcQ5U76KQGzUIrbZ3k7jUcErfCSLpss6TkyJIEX5Swaaec+RICpnqUjETpiSX1hjL1P95HmZN3sWHJSwk3lOyeOBEtaNOfNEnIGgx8HHvNJ3RnmafXq9++YLc6Iz75XkZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741382482; c=relaxed/simple;
	bh=MLdsCC5RyxJbHvgU+e81v3+kTqD0tFblbLaSYe8uNb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oXc/JGDAEvklGIJslJLseZ/Jzo6Wd8hhTbh+AyjW/mDRePE8NyN+WbtGJHe+Uml64zuryp74gevwG7FDpjJq7ol7tAGjrQ+chQGvuYig+mwQKverpYDTrXbzbc+nHH3lqryP3a/Upfx8CX+yLBy5rcdKEzHwt1R3O5NtwV0Zdbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=czHqe6HC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741382479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iave23OiDzUrFOkMV5D2Fk14EZP3jUAp/eU9gnykf5I=;
	b=czHqe6HC6FlFy9VTVVL0gEv2N2Hq0p6M8m+WXuS4vDFkHIKia9BBvq47a4RhY5gBk+Q3u2
	u0cnKf/oR7y1dEO6G8gKugqurHlcxQDMol9Gwz4uKIBu/Jp5O6Oy63i8uHoEbwmuHcSP59
	5CUh7eIC07bjLRjWgMK5Lk2KqHfEX38=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-292-ZEGRbGf2Nh-hPSSCvWRWOg-1; Fri,
 07 Mar 2025 16:21:14 -0500
X-MC-Unique: ZEGRbGf2Nh-hPSSCvWRWOg-1
X-Mimecast-MFC-AGG-ID: ZEGRbGf2Nh-hPSSCvWRWOg_1741382472
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84F7E18004A9;
	Fri,  7 Mar 2025 21:21:12 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8DD0E1955DDE;
	Fri,  7 Mar 2025 21:21:11 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	adrian.hunter@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v3 11/10] [NOT TO COMMIT] KVM: TDX: put somewhat sensible values in vCPU for encrypted registers
Date: Fri,  7 Mar 2025 16:20:53 -0500
Message-ID: <20250307212053.2948340-12-pbonzini@redhat.com>
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

This shows the hunks that were *removed* from v2 without a replacement;
it's not in kvm-coco-queue.

Originally from a patch by Isaku Yamahata and Adrian Hunter.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c0fcd0508264..904f8f656394 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2005,9 +2005,23 @@ static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 	return r;
 }
 
+static u64 tdx_guest_cr0(struct kvm_vcpu *vcpu, u64 cr4)
+{
+	u64 cr0 = ~CR0_RESERVED_BITS;
+
+	if (cr4 & X86_CR4_CET)
+		cr0 |= X86_CR0_WP;
+
+	cr0 |= X86_CR0_PE | X86_CR0_NE;
+	cr0 &= ~(X86_CR0_NW | X86_CR0_CD);
+
+	return cr0;
+}
+
 static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 {
 	u64 apic_base;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	int ret;
 
@@ -2030,6 +2044,18 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 	if (ret)
 		return ret;
 
+	/*
+	 * Just stuff something sensible in vcpu->arch.  Note that all runtime
+	 * access to CRn and XCR0 is blocked by guest_state_protected.
+	 */
+	vcpu->arch.cr4 = ~vcpu->arch.cr4_guest_rsvd_bits;
+	vcpu->arch.cr0 = tdx_guest_cr0(vcpu, vcpu->arch.cr4);
+	vcpu->arch.ia32_xss = kvm_tdx->xfam & kvm_caps.supported_xss;
+	vcpu->arch.xcr0 = kvm_tdx->xfam & kvm_caps.supported_xcr0;
+
+	/* TODO: freeze vCPU model before kvm_update_cpuid_runtime() */
+	kvm_update_cpuid_runtime(vcpu);
+
 	tdx->state = VCPU_TD_STATE_INITIALIZED;
 
 	return 0;
-- 
2.43.5


