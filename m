Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE132822A6
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 10:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgJCIsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 04:48:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgJCIst (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Oct 2020 04:48:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601714928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JSzviH95g3Cg7Ab3hoyr0QKGSSvhU8NZpt80cGzHgMc=;
        b=aIW8ak+elp3jgELZccXdxqpPrqmykXS+Vl6LrG5r98R3cG1ziY4073OSzt6/Ic8MzQSmQG
        vcXCub2kGxdYznaTdAiyQ8nhH1NSgzv1PYaj+Gc/CBE2Hug/3wOqx+W1X6tJs1IJY1WUj2
        26MWW/zXEvZApYH99LFxONzaCQOR8KM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-_qK2yB6GOomSwg1G7JME1w-1; Sat, 03 Oct 2020 04:48:44 -0400
X-MC-Unique: _qK2yB6GOomSwg1G7JME1w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8686D80364D;
        Sat,  3 Oct 2020 08:48:43 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B02C760C05;
        Sat,  3 Oct 2020 08:48:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Qian Cai <cai@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH] KVM: VMX: update PFEC_MASK/PFEC_MATCH together with PF intercept
Date:   Sat,  3 Oct 2020 04:48:35 -0400
Message-Id: <20201003084835.237833-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PFEC_MASK and PFEC_MATCH fields in the VMCS reverse the meaning of
the #PF intercept bit in the exception bitmap when they do not match.
This means that, if PFEC_MASK and/or PFEC_MATCH are set, the
hypervisor can get a vmexit for #PF exceptions even when the
corresponding bit is clear in the exception bitmap.

This is unexpected and is promptly detected by a WARN_ON_ONCE.
To fix it, reset PFEC_MASK and PFEC_MATCH when the #PF intercept
is disabled (as is common with enable_ept && !allow_smaller_maxphyaddr).

Reported-by: Qian Cai <cai@redhat.com>>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f0384e93548a..f4e9c310032a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -794,6 +794,18 @@ void update_exception_bitmap(struct kvm_vcpu *vcpu)
 	 */
 	if (is_guest_mode(vcpu))
 		eb |= get_vmcs12(vcpu)->exception_bitmap;
+        else {
+		/*
+		 * If EPT is enabled, #PF is only trapped if MAXPHYADDR is mismatched
+		 * between guest and host.  In that case we only care about present
+		 * faults.  For vmcs02, however, PFEC_MASK and PFEC_MATCH are set in
+		 * prepare_vmcs02_rare.
+		 */
+		bool selective_pf_trap = enable_ept && (eb & (1u << PF_VECTOR));
+		int mask = selective_pf_trap ? PFERR_PRESENT_MASK : 0;
+		vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, mask);
+		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, mask);
+	}
 
 	vmcs_write32(EXCEPTION_BITMAP, eb);
 }
@@ -4355,16 +4367,6 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmx->pt_desc.guest.output_mask = 0x7F;
 		vmcs_write64(GUEST_IA32_RTIT_CTL, 0);
 	}
-
-	/*
-	 * If EPT is enabled, #PF is only trapped if MAXPHYADDR is mismatched
-	 * between guest and host.  In that case we only care about present
-	 * faults.
-	 */
-	if (enable_ept) {
-		vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, PFERR_PRESENT_MASK);
-		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, PFERR_PRESENT_MASK);
-	}
 }
 
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
-- 
2.26.2

