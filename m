Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F47B37178D
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhECPKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:10:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229748AbhECPJ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 11:09:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620054544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEI+4Ic9HJh3gaK26jg1vQpajvtZerh1XHWV7dRvuiw=;
        b=F16A7w4hYPQ23vSPOZ6J5NE4sSkgVX9DtWhuUojZZ0V/sXjpGVe2qNkmTEvNr0BcrPpoHG
        vYHjtYq0C83bIX8qQCNwebe8y6Pa8BBMBNuQOLhgq1w93xE3A5o2uh9f2BV+dpJXJycgwI
        zCnBtbc6SnUOOeCKWPTk42CZaHjWVTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-N2C7m98fPEO26AKZEzTm1w-1; Mon, 03 May 2021 11:09:02 -0400
X-MC-Unique: N2C7m98fPEO26AKZEzTm1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E94D107ACC7;
        Mon,  3 May 2021 15:09:00 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C2D719C45;
        Mon,  3 May 2021 15:08:58 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] KVM: nVMX: Always make an attempt to map eVMCS after migration
Date:   Mon,  3 May 2021 17:08:51 +0200
Message-Id: <20210503150854.1144255-2-vkuznets@redhat.com>
In-Reply-To: <20210503150854.1144255-1-vkuznets@redhat.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When enlightened VMCS is in use and nested state is migrated with
vmx_get_nested_state()/vmx_set_nested_state() KVM can't map evmcs
page right away: evmcs gpa is not 'struct kvm_vmx_nested_state_hdr'
and we can't read it from VP assist page because userspace may decide
to restore HV_X64_MSR_VP_ASSIST_PAGE after restoring nested state
(and QEMU, for example, does exactly that). To make sure eVMCS is
mapped /vmx_set_nested_state() raises KVM_REQ_GET_NESTED_STATE_PAGES
request.

Commit f2c7ef3ba955 ("KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES
on nested vmexit") added KVM_REQ_GET_NESTED_STATE_PAGES clearing to
nested_vmx_vmexit() to make sure MSR permission bitmap is not switched
when an immediate exit from L2 to L1 happens right after migration (caused
by a pending event, for example). Unfortunately, in the exact same
situation we still need to have eVMCS mapped so
nested_sync_vmcs12_to_shadow() reflects changes in VMCS12 to eVMCS.

As a band-aid, restore nested_get_evmcs_page() when clearing
KVM_REQ_GET_NESTED_STATE_PAGES in nested_vmx_vmexit(). The 'fix' is far
from being ideal as we can't easily propagate possible failures and even if
we could, this is most likely already too late to do so. The whole
'KVM_REQ_GET_NESTED_STATE_PAGES' idea for mapping eVMCS after migration
seems to be fragile as we diverge too much from the 'native' path when
vmptr loading happens on vmx_set_nested_state().

Fixes: f2c7ef3ba955 ("KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1e069aac7410..2febb1dd68e8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3098,15 +3098,8 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
 
 		if (evmptrld_status == EVMPTRLD_VMFAIL ||
-		    evmptrld_status == EVMPTRLD_ERROR) {
-			pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
-					     __func__);
-			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			vcpu->run->internal.suberror =
-				KVM_INTERNAL_ERROR_EMULATION;
-			vcpu->run->internal.ndata = 0;
+		    evmptrld_status == EVMPTRLD_ERROR)
 			return false;
-		}
 	}
 
 	return true;
@@ -3194,8 +3187,16 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 
 static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
-	if (!nested_get_evmcs_page(vcpu))
+	if (!nested_get_evmcs_page(vcpu)) {
+		pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
+				     __func__);
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror =
+			KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->run->internal.ndata = 0;
+
 		return false;
+	}
 
 	if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
 		return false;
@@ -4422,7 +4423,15 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
+		/*
+		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
+		 * Enlightened VMCS after migration and we still need to
+		 * do that when something is forcing L2->L1 exit prior to
+		 * the first L2 run.
+		 */
+		(void)nested_get_evmcs_page(vcpu);
+	}
 
 	/* Service the TLB flush request for L2 before switching to L1. */
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
-- 
2.30.2

