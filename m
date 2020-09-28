Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F14827AD39
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 13:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgI1Lvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 07:51:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726547AbgI1Lvu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 07:51:50 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601293908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQBWknBGOINoO/rGGYREqBjY4abn68VKx7wYmghxbFA=;
        b=XpFCSNYo+vwH4iAegwJ+QC/R5UDvD5YTvhgjcp4R0xNgwkho7vb6igQcBxy6YAi4eBCGao
        czTL5FzLanhlstVhggwIkEDQSpyKT4eY/2OBoI5bRQY8jVKk0ZjxJqrWB2QxQbAPlaJVCv
        sh/B8Zz7gjqfXyPXXc2gc8pMB6l4/Lk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-IwetUFYiMbWv6YKaCZARxQ-1; Mon, 28 Sep 2020 07:51:46 -0400
X-MC-Unique: IwetUFYiMbWv6YKaCZARxQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B93B610050F6;
        Mon, 28 Sep 2020 11:51:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64E8149F7;
        Mon, 28 Sep 2020 11:51:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH 1/2] KVM: x86: rename KVM_REQ_GET_VMCS12_PAGES
Date:   Mon, 28 Sep 2020 07:51:43 -0400
Message-Id: <20200928115144.2446240-2-pbonzini@redhat.com>
In-Reply-To: <20200928115144.2446240-1-pbonzini@redhat.com>
References: <20200928115144.2446240-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are going to use it for SVM too, so use a more generic name.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/vmx/nested.c       | 8 ++++----
 arch/x86/kvm/x86.c              | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5303dbc5c9bc..c12babf6377c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -80,7 +80,7 @@
 #define KVM_REQ_HV_EXIT			KVM_ARCH_REQ(21)
 #define KVM_REQ_HV_STIMER		KVM_ARCH_REQ(22)
 #define KVM_REQ_LOAD_EOI_EXITMAP	KVM_ARCH_REQ(23)
-#define KVM_REQ_GET_VMCS12_PAGES	KVM_ARCH_REQ(24)
+#define KVM_REQ_GET_NESTED_STATE_PAGES	KVM_ARCH_REQ(24)
 #define KVM_REQ_APICV_UPDATE \
 	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_TLB_FLUSH_CURRENT	KVM_ARCH_REQ(26)
@@ -1238,7 +1238,7 @@ struct kvm_x86_nested_ops {
 	int (*set_state)(struct kvm_vcpu *vcpu,
 			 struct kvm_nested_state __user *user_kvm_nested_state,
 			 struct kvm_nested_state *kvm_state);
-	bool (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
+	bool (*get_nested_state_pages)(struct kvm_vcpu *vcpu);
 	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1bb6b31eb646..7a4dc5abd7e2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -244,7 +244,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
 		return;
 
-	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
+	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
 	vmx->nested.vmxon = false;
 	vmx->nested.smm.vmxon = false;
@@ -3387,7 +3387,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		 * to nested_get_vmcs12_pages before the next VM-entry.  The MSRs
 		 * have already been set at vmentry time and should not be reset.
 		 */
-		kvm_make_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
+		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	}
 
 	/*
@@ -6182,7 +6182,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		 * restored yet. EVMCS will be mapped from
 		 * nested_get_vmcs12_pages().
 		 */
-		kvm_make_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
+		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	} else {
 		return -EINVAL;
 	}
@@ -6561,7 +6561,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.get_state = vmx_get_nested_state,
 	.set_state = vmx_set_nested_state,
-	.get_vmcs12_pages = nested_get_vmcs12_pages,
+	.get_nested_state_pages = nested_get_vmcs12_pages,
 	.write_log_dirty = nested_vmx_write_pml_buffer,
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1994602a0851..92ead1782d57 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8365,8 +8365,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	bool req_immediate_exit = false;
 
 	if (kvm_request_pending(vcpu)) {
-		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
-			if (unlikely(!kvm_x86_ops.nested_ops->get_vmcs12_pages(vcpu))) {
+		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
+			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
 				r = 0;
 				goto out;
 			}
-- 
2.26.2


