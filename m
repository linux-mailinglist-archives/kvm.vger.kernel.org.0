Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30386588D93
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238320AbiHCNqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238254AbiHCNqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:46:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 567A81EADA
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 06:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659534360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czVSfgeJdT0ENI1O87zKlSMPq/hlgeK5s27AHY9iFeg=;
        b=PWnrlm8FIQfO+0cZucGxSHX+M02shcm/vCKwq1t4hsnqWSBD+SYc9CUAOr+yWMvaBz7zo1
        7EoFxdmo8fbWf4QlqV62A0zoruyz0YLSwsvZPcxOdH7H557ePrbRj73lwlY4JbwUPSRbQ3
        Pkja9cTqXNXq4K3cWhsR/m5Wz/MfziA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-X-Zt0wjnPreaLsEv7C-wtA-1; Wed, 03 Aug 2022 09:45:57 -0400
X-MC-Unique: X-Zt0wjnPreaLsEv7C-wtA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AB1483DE57;
        Wed,  3 Aug 2022 13:45:57 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A878DC27D95;
        Wed,  3 Aug 2022 13:45:54 +0000 (UTC)
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
Subject: [PATCH v9 16/40] KVM: x86: hyper-v: Introduce kvm_hv_is_tlb_flush_hcall()
Date:   Wed,  3 Aug 2022 15:45:54 +0200
Message-Id: <20220803134554.399275-1-vkuznets@redhat.com>
In-Reply-To: <20220803134110.397885-1-vkuznets@redhat.com>
References: <20220803134110.397885-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The newly introduced helper checks whether vCPU is performing a
Hyper-V TLB flush hypercall. This is required to filter out L2 TLB
flush hypercalls for processing.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 8a902b59aa46..239946ea483b 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -172,6 +172,24 @@ static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
 
 	kfifo_reset_out(&tlb_flush_fifo->entries);
 }
+
+static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	u16 code;
+
+	if (!hv_vcpu)
+		return false;
+
+	code = is_64_bit_hypercall(vcpu) ? kvm_rcx_read(vcpu) :
+					   kvm_rax_read(vcpu);
+
+	return (code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
+		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST ||
+		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX ||
+		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX);
+}
+
 void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
 
 
-- 
2.35.3

