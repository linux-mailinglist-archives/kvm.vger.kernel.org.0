Return-Path: <kvm+bounces-3494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BBEE80509D
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC5D81C20E2C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075455D4B9;
	Tue,  5 Dec 2023 10:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iBpejuhg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CA01FEF
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x9dYykW2Vhk9W/08xFfB5pOA8XzUTtrre/qfgC+2sUs=;
	b=iBpejuhg5qeQR22VXdmPox4VmgTLt8inDQrnFfpXy4nWsJABCBsEEWkSOkyK9zGTtIEjzM
	2jKwQjXaQJJHIpeXZuoT9okrrKdBcfHFsnB9/I1wiHUwKNI8uRZmAQQow/2+YPlKKzLpGQ
	OGktD0NzVWOQYX2iHiQrWmZmzQnbbLM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-WY-nWlHhNpKfzD3xPTzC7A-1; Tue,
 05 Dec 2023 05:36:48 -0500
X-MC-Unique: WY-nWlHhNpKfzD3xPTzC7A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F41E38135E6;
	Tue,  5 Dec 2023 10:36:48 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4082C2026D66;
	Tue,  5 Dec 2023 10:36:47 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 15/16] KVM: nVMX: hyper-v: Hide more stuff under CONFIG_KVM_HYPERV
Date: Tue,  5 Dec 2023 11:36:29 +0100
Message-ID: <20231205103630.1391318-16-vkuznets@redhat.com>
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

'hv_evmcs_vmptr'/'hv_evmcs_map'/'hv_evmcs' fields in 'struct nested_vmx'
should not be used when !CONFIG_KVM_HYPERV, hide them when
!CONFIG_KVM_HYPERV.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 arch/x86/kvm/vmx/vmx.c    | 3 +++
 arch/x86/kvm/vmx/vmx.h    | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4e872863a0c9..cf47b8b7f40f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6667,6 +6667,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 
 		set_current_vmptr(vmx, kvm_state->hdr.vmx.vmcs12_pa);
+#ifdef CONFIG_KVM_HYPERV
 	} else if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
 		/*
 		 * nested_vmx_handle_enlightened_vmptrld() cannot be called
@@ -6676,6 +6677,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		 */
 		vmx->nested.hv_evmcs_vmptr = EVMPTR_MAP_PENDING;
 		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+#endif
 	} else {
 		return -EINVAL;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3ff5c44dff9d..a26603ddc968 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4828,7 +4828,10 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.vmxon_ptr = INVALID_GPA;
 	vmx->nested.current_vmptr = INVALID_GPA;
+
+#ifdef CONFIG_KVM_HYPERV
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
+#endif
 
 	vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 959c6d94287f..8fe6eb2b4a34 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -241,9 +241,11 @@ struct nested_vmx {
 		bool guest_mode;
 	} smm;
 
+#ifdef CONFIG_KVM_HYPERV
 	gpa_t hv_evmcs_vmptr;
 	struct kvm_host_map hv_evmcs_map;
 	struct hv_enlightened_vmcs *hv_evmcs;
+#endif
 };
 
 struct vcpu_vmx {
-- 
2.43.0


