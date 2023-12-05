Return-Path: <kvm+bounces-3492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F347805098
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:38:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDE682817C0
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7113C5C8FD;
	Tue,  5 Dec 2023 10:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bX7JxAtF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877041FC2
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l1oDdblcDy/fETT9OUFC4ZqOo55XWa8Ns4Js01pxT0o=;
	b=bX7JxAtFPtdGRglWEb6/kJwNPG8UCDsUlXdbuzYUJJLkbfYEYkDjodcJMMF9RDHDJuU6Ie
	lFYvha+odFTzAj71ZuwLeJCPYWelOeimwzTxYV7IbhRC7CHV9aF2i/whjEjNf1drIYrHSq
	LC1SSOWyIrisf1MizJhLUbZxb67+1Oo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-TV2UBQHFNB-mFvcxitkbSg-1; Tue,
 05 Dec 2023 05:36:44 -0500
X-MC-Unique: TV2UBQHFNB-mFvcxitkbSg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F349B1C0690D;
	Tue,  5 Dec 2023 10:36:43 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 305BB20271F4;
	Tue,  5 Dec 2023 10:36:43 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 11/16] KVM: nVMX: Move guest_cpuid_has_evmcs() to hyperv.h
Date: Tue,  5 Dec 2023 11:36:25 +0100
Message-ID: <20231205103630.1391318-12-vkuznets@redhat.com>
In-Reply-To: <20231205103630.1391318-1-vkuznets@redhat.com>
References: <20231205103630.1391318-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

In preparation for making Hyper-V emulation optional, move Hyper-V specific
guest_cpuid_has_evmcs() to hyperv.h.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/hyperv.h | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.h    | 10 ----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index d4ed99008518..6e1ee951e360 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -4,6 +4,7 @@
 
 #include <linux/kvm_host.h>
 #include "vmcs12.h"
+#include "vmx.h"
 
 #define EVMPTR_INVALID (-1ULL)
 #define EVMPTR_MAP_PENDING (-2ULL)
@@ -20,6 +21,16 @@ enum nested_evmptrld_status {
 	EVMPTRLD_ERROR,
 };
 
+static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
+	 * eVMCS has been explicitly enabled by userspace.
+	 */
+	return vcpu->arch.hyperv_enabled &&
+	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
+}
+
 u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c2130d2c8e24..959c6d94287f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -745,14 +745,4 @@ static inline bool vmx_can_use_ipiv(struct kvm_vcpu *vcpu)
 	return  lapic_in_kernel(vcpu) && enable_ipiv;
 }
 
-static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
-	 * eVMCS has been explicitly enabled by userspace.
-	 */
-	return vcpu->arch.hyperv_enabled &&
-	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
-}
-
 #endif /* __KVM_X86_VMX_H */
-- 
2.43.0


