Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410345012A1
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 17:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiDNNfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 09:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244610AbiDNN1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 09:27:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1073EA1469
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 06:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649942432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=guPhHfLWQaBPsCmuIyaAa+212gzE/QcUkyjWekHqQX4=;
        b=ZOYTelyqu6SvhNPPu6ixvY7z3GYtF/UO/xvCdFIBF6Zs22+FxhP3aKCDvKbnKCWoqzlk1Q
        fuf+9dY2R7Fe0nLc7C29f69DgDonDt359NBqKU72P+p2z+Mf61tLt8REsOG4/M60eKKo+s
        ukUun06LclitZUKL0BdG5SSWNVluaB4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-3jbKgnbbPeSaioWPbhlXGA-1; Thu, 14 Apr 2022 09:20:29 -0400
X-MC-Unique: 3jbKgnbbPeSaioWPbhlXGA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62071100BABE;
        Thu, 14 Apr 2022 13:20:28 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD4A07C28;
        Thu, 14 Apr 2022 13:20:26 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/34] KVM: x86: Prepare kvm_hv_flush_tlb() to handle L2's GPAs
Date:   Thu, 14 Apr 2022 15:19:45 +0200
Message-Id: <20220414132013.1588929-7-vkuznets@redhat.com>
In-Reply-To: <20220414132013.1588929-1-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To handle L2 TLB flush requests, KVM needs to translate the specified
L2 GPA to L1 GPA to read hypercall arguments from there.

No fucntional change as KVM doesn't handle VMCALL/VMMCALL from L2 yet.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 1a6f9628cee9..fc4bb0ead9fa 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -23,6 +23,7 @@
 #include "ioapic.h"
 #include "cpuid.h"
 #include "hyperv.h"
+#include "mmu.h"
 #include "xen.h"
 
 #include <linux/cpu.h>
@@ -1975,6 +1976,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	 */
 	BUILD_BUG_ON(KVM_HV_MAX_SPARSE_VCPU_SET_BITS > 64);
 
+	if (!hc->fast && is_guest_mode(vcpu)) {
+		hc->ingpa = translate_nested_gpa(vcpu, hc->ingpa, 0, NULL);
+		if (unlikely(hc->ingpa == UNMAPPED_GVA))
+			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+	}
+
 	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST ||
 	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE) {
 		if (hc->fast) {
-- 
2.35.1

