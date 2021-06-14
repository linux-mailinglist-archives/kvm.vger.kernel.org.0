Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F943A65CF
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 13:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbhFNLmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 07:42:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38218 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237160AbhFNLlA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 07:41:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623670737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=378pv6+fxeQjRBQ8K5DRbQNLEGzoXl08sJIODjY7tFA=;
        b=H+aJeYuu+uRUN8Wl9+6pQPqKsVTSlw28K3o4No9MznMVrcxu2ChzgXjFcs9hSd8URdy++F
        eHVaQZ1kWGVnNgD/Qgwyn1U8VGseg2tJ/05v1MxjVe/deI2bt4+pGwUUGeMv+n9v7PPyCH
        z7rjOQhn9IlLdnSRJAz2a3dzhW17Plw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-_CAQen3sP8mkXm0_n4wCUQ-1; Mon, 14 Jun 2021 07:38:56 -0400
X-MC-Unique: _CAQen3sP8mkXm0_n4wCUQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C744D818400;
        Mon, 14 Jun 2021 11:38:54 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CDB060C0F;
        Mon, 14 Jun 2021 11:38:52 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vineeth Pillai <viremana@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: svm: Avoid NULL pointer dereference in svm_hv_update_vp_id()
Date:   Mon, 14 Jun 2021 13:38:51 +0200
Message-Id: <20210614113851.1667567-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V context is allocated dynamically when Hyper-V features are enabled
on a vCPU but svm_hv_update_vp_id() is called unconditionally from
svm_vcpu_run(), this leads to dereferencing to_hv_vcpu(vcpu) which can
be NULL. Use kvm_hv_get_vpindex() wrapper to avoid the problem.

Fixes: 4ba0d72aaa32 ("KVM: SVM: hyper-v: Direct Virtual Flush support")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
- The patch introducing the issue is currently in kvm/queue.
---
 arch/x86/kvm/svm/svm_onhyperv.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index ce23149670ea..9b9a55abc29f 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -99,9 +99,10 @@ static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
 {
 	struct hv_enlightenments *hve =
 		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	u32 vp_index = kvm_hv_get_vpindex(vcpu);
 
-	if (hve->hv_vp_id != to_hv_vcpu(vcpu)->vp_index) {
-		hve->hv_vp_id = to_hv_vcpu(vcpu)->vp_index;
+	if (hve->hv_vp_id != vp_index) {
+		hve->hv_vp_id = vp_index;
 		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
 	}
 }
-- 
2.31.1

