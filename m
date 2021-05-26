Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7493918B6
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhEZNYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:24:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233482AbhEZNYW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622035371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eWDv2QmEYdD5Ix6Td12M0zNYIINHr8ZZI45AmVPayMs=;
        b=VSCQfhmMMh+vBh/6R5U988jI1JhHXamkQvcfz95NGP9e8+D9OeGEGlccpKdhAf8vSXWXiV
        +ynwQbbbU++eflZjt+eMv/2te3NN3Jwd0m4J6PXKstBZcCipK5x1aP7M7hZw74myWT8VhB
        0BSHzoOQCq+9+2foQt0TZWiZh7PFOMs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-Y5VShte2OfSHxWLWxWVA4g-1; Wed, 26 May 2021 09:22:49 -0400
X-MC-Unique: Y5VShte2OfSHxWLWxWVA4g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB7D91034AFC;
        Wed, 26 May 2021 13:22:48 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D6AE5D9C6;
        Wed, 26 May 2021 13:22:38 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/11] KVM: nVMX: Reset eVMCS clean fields data from prepare_vmcs02()
Date:   Wed, 26 May 2021 15:20:24 +0200
Message-Id: <20210526132026.270394-10-vkuznets@redhat.com>
In-Reply-To: <20210526132026.270394-1-vkuznets@redhat.com>
References: <20210526132026.270394-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When nested state migration happens during L1's execution, it
is incorrect to modify eVMCS as it is L1 who 'owns' it at the moment.
At least genuine Hyper-V seems to not be very happy when 'clean fields'
data changes underneath it.

'Clean fields' data is used in KVM twice: by copy_enlightened_to_vmcs12()
and prepare_vmcs02_rare() so we can reset it from prepare_vmcs02() instead.

While at it, update a comment stating why exactly we need to reset
'hv_clean_fields' data from L0.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 34b8e2471a5b..0f2e8eea2110 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2060,14 +2060,10 @@ void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
+	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
 		copy_vmcs12_to_enlightened(vmx);
-		/* All fields are clean */
-		vmx->nested.hv_evmcs->hv_clean_fields |=
-			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
-	} else {
+	else
 		copy_vmcs12_to_shadow(vmx);
-	}
 
 	vmx->nested.need_vmcs12_to_shadow_sync = false;
 }
@@ -2607,6 +2603,17 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
 	kvm_rip_write(vcpu, vmcs12->guest_rip);
+
+	/*
+	 * It was observed that genuine Hyper-V running in L1 doesn't reset
+	 * 'hv_clean_fields' by itself, it only sets the corresponding dirty
+	 * bits when it changes a field in eVMCS. Mark all fields as clean
+	 * here.
+	 */
+	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+		vmx->nested.hv_evmcs->hv_clean_fields |=
+			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
+
 	return 0;
 }
 
-- 
2.31.1

