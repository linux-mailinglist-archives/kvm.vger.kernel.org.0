Return-Path: <kvm+bounces-43380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0791A8ACAA
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 02:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1340179910
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 00:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408C01AF0BC;
	Wed, 16 Apr 2025 00:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DPzHmQgI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCE318E377
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 00:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744763163; cv=none; b=rlrqkr2JNbNKfS1VGTc4XZV0fIk/33GHl/GVA2djpGkSqWY/ScGPhjDP7ksWQj8dQqDMmGOvzZdaXpR7TwV0zm0doY2eLKG82P1954OYhtDhI8ePXAyFskapR4w2zTwukG3wPLGM1p1rJUwCJtDun6olBilVE0WtCZs+EJ1OS2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744763163; c=relaxed/simple;
	bh=PDSbK+vS923MRXXa+nubLiSnOrhEBnEINCV6EE6D9+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UodT9F2YkMIOgiBqcXkrHwxn0SbkFN7ThP9R/K1JwOHVQyd3a60t1t5cMB6N1iPfkpXUA0X8PnD4InFl48SFqjTKJaDpe5N91aLe3YPiHVDC/rgBwltY8FW1atg6SXFkQpg6uDal6EM3AJQqYrvuOlyPCLgSpiMzUUXkLXqtw3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DPzHmQgI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744763160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WJednPm+FRsnEYgZnhJMyn5/YlqHf05q9Efu9E43Y8g=;
	b=DPzHmQgI5KnI0MKhQ9/nIoQBPkpmYaDYM/48IFy47szDr5WKScjQUAME8ZXPlTM15SED41
	4HtJYAtP0IRWR+LHbgUKbNlU64P62LgKAb9syWOFxGm0ze3dllSiMMM6kr8ziw6jNJi+8s
	9/toVnqEk/MEbacVoWpuW0yU2UjbDlA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-ogM52G2PP9ebwYix8x8SWg-1; Tue,
 15 Apr 2025 20:25:57 -0400
X-MC-Unique: ogM52G2PP9ebwYix8x8SWg-1
X-Mimecast-MFC-AGG-ID: ogM52G2PP9ebwYix8x8SWg_1744763155
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F39A31800EC5;
	Wed, 16 Apr 2025 00:25:54 +0000 (UTC)
Received: from starship.lan (unknown [10.22.82.37])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DECF11828A99;
	Wed, 16 Apr 2025 00:25:52 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/3] x86: KVM: VMX: cache guest written value of MSR_IA32_DEBUGCTL
Date: Tue, 15 Apr 2025 20:25:45 -0400
Message-Id: <20250416002546.3300893-3-mlevitsk@redhat.com>
In-Reply-To: <20250416002546.3300893-1-mlevitsk@redhat.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Store the guest's written value of MSR_IA32_DEBUGCTL in a software field,
insted of always reading/writing the GUEST_IA32_DEBUGCTL vmcs field.

This will allow in the future to have a different value in the
actual GUEST_IA32_DEBUGCTL from the value that the guest has set.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 ++++-
 arch/x86/kvm/vmx/vmx.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4237422dc4ed..c9208a4acda4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2196,11 +2196,14 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 
 u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
 {
-	return vmcs_read64(GUEST_IA32_DEBUGCTL);
+	return to_vmx(vcpu)->msr_ia32_debugctl;
 }
 
 static void __vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	vmx->msr_ia32_debugctl = data;
 	vmcs_write64(GUEST_IA32_DEBUGCTL, data);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 8ac46fb47abd..699da6d2bc66 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -291,6 +291,7 @@ struct vcpu_vmx {
 	/* SGX Launch Control public key hash */
 	u64 msr_ia32_sgxlepubkeyhash[4];
 	u64 msr_ia32_mcu_opt_ctrl;
+	u64 msr_ia32_debugctl;
 	bool disable_fb_clear;
 
 	struct pt_desc pt_desc;
-- 
2.26.3


