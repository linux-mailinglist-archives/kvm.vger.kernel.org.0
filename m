Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0AD37A59C
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 13:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhEKLVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 07:21:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44761 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231502AbhEKLVd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 07:21:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620732027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+M62xJvp0rLs4StjFsMWIRrfd2lRGy018Ij8SrHeZcQ=;
        b=g9A9DCD5sfw3Raz/HljbXh+ksrqyE58oTZ/vKXdH2NR5QdRtGJxD0nr0hc5I8uztz7pd1s
        WtSKp8VnhK4H4L7ZROZgT+C83pU6M5/qKYMLfv54fU1ENUWVP1r0oPnASkyWAkCLe0WrYi
        hlZ1HPUpRD1Xt4FadkAAJqQXgiDUUlI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-oZxZ-7vRP8i9dtXjbBbWCA-1; Tue, 11 May 2021 07:20:25 -0400
X-MC-Unique: oZxZ-7vRP8i9dtXjbBbWCA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35B791922023;
        Tue, 11 May 2021 11:20:24 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31B8863746;
        Tue, 11 May 2021 11:20:22 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5/7] KVM: nVMX: Reset eVMCS clean fields data from prepare_vmcs02()
Date:   Tue, 11 May 2021 13:19:54 +0200
Message-Id: <20210511111956.1555830-6-vkuznets@redhat.com>
In-Reply-To: <20210511111956.1555830-1-vkuznets@redhat.com>
References: <20210511111956.1555830-1-vkuznets@redhat.com>
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
 arch/x86/kvm/vmx/nested.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3257a2291693..1661e2e19560 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2090,9 +2090,6 @@ void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
 
 	if (vmx->nested.hv_evmcs) {
 		copy_vmcs12_to_enlightened(vmx);
-		/* All fields are clean */
-		vmx->nested.hv_evmcs->hv_clean_fields |=
-			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 	} else {
 		copy_vmcs12_to_shadow(vmx);
 	}
@@ -2636,6 +2633,12 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
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
2.30.2

