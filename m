Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B990D382DF7
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 15:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237636AbhEQNwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 09:52:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33301 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237591AbhEQNwa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 09:52:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621259473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4hCn4cpIBLWGaz5Y1x7GgTlm3z8Sib8mfzknSZW48BY=;
        b=Df71fNe9rud8etXb/kwFYdQ6nDKSgaL0G6BbzO5dXy+Wqqj0FJQQBJmSigqBFZy2x31sCZ
        HdwWsiGPjok11tVR4HC0nW8oHRGoh9o3+F5254zYJU4XXQZlnE1A7EgN0E5hqsjtN/ZHEP
        iJc6QDyfEelZsp2irKENYEFjSQBe2X0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-Dq-wcpNqPkOZNHjB4Z3r7g-1; Mon, 17 May 2021 09:51:11 -0400
X-MC-Unique: Dq-wcpNqPkOZNHjB4Z3r7g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5693C19611A1;
        Mon, 17 May 2021 13:51:10 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08B975C1A1;
        Mon, 17 May 2021 13:51:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] KVM: nVMX: Reset eVMCS clean fields data from prepare_vmcs02()
Date:   Mon, 17 May 2021 15:50:52 +0200
Message-Id: <20210517135054.1914802-6-vkuznets@redhat.com>
In-Reply-To: <20210517135054.1914802-1-vkuznets@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When nested state migration happens during L1's execution, it
is incorrect to modify eVMCS as it is L1 who 'owns' it at the moment.
At lease genuine Hyper-v seems to not be very happy when 'clean fields'
data changes underneath it.

'Clean fields' data is used in KVM twice: by copy_enlightened_to_vmcs12()
and prepare_vmcs02_rare() so we can reset it from prepare_vmcs02() instead.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index eb2d25a93356..3bfbf991bf45 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2081,14 +2081,10 @@ void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vmx->nested.hv_evmcs) {
+	if (vmx->nested.hv_evmcs)
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
@@ -2629,6 +2625,12 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
 	kvm_rip_write(vcpu, vmcs12->guest_rip);
+
+	/* Mark all fields as clean so L1 hypervisor can set what's dirty */
+	if (hv_evmcs)
+		vmx->nested.hv_evmcs->hv_clean_fields |=
+			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
+
 	return 0;
 }
 
-- 
2.31.1

