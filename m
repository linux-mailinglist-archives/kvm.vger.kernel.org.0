Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066E3607B16
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiJUPhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiJUPgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:36:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777CC247E1D
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666366593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hf23owwXyl4mzv8DXKFj7XQPTlriWIPQsbBxFbBqkTQ=;
        b=hy45KArIzyhNMfUuQjZetd8/V3wJgheKNT+nOpHYY3RDlSLWzMYqmV3rywf1v/WlxkFiGf
        cSSAeryoAHZ3kQVHUil733aQ6kN+dYvBzuH38TpgZaMEfRU5Hz1e8Vx7VMBwXadsQpv50Y
        V1ZH5KNfKGiYjX9aXRZTagCyjXFaQhM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-Zh2UNZhJN-mZMORCqRT5gg-1; Fri, 21 Oct 2022 11:36:27 -0400
X-MC-Unique: Zh2UNZhJN-mZMORCqRT5gg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EB71800B23;
        Fri, 21 Oct 2022 15:36:25 +0000 (UTC)
Received: from ovpn-192-65.brq.redhat.com (ovpn-192-65.brq.redhat.com [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF2B940CA41F;
        Fri, 21 Oct 2022 15:36:22 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 24/46] KVM: x86: hyper-v: Introduce fast guest_hv_cpuid_has_l2_tlb_flush() check
Date:   Fri, 21 Oct 2022 17:34:59 +0200
Message-Id: <20221021153521.1216911-25-vkuznets@redhat.com>
In-Reply-To: <20221021153521.1216911-1-vkuznets@redhat.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a helper to quickly check if KVM needs to handle VMCALL/VMMCALL
from L2 in L0 to process L2 TLB flush requests.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 7706e203ff43..bd698eb2bda1 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -174,6 +174,14 @@ static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu)
 	kfifo_reset_out(&tlb_flush_fifo->entries);
 }
 
+static inline bool guest_hv_cpuid_has_l2_tlb_flush(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	return hv_vcpu &&
+		(hv_vcpu->cpuid_cache.nested_eax & HV_X64_NESTED_DIRECT_FLUSH);
+}
+
 static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
-- 
2.37.3

