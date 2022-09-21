Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD535C0157
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbiIUP1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiIUP0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:26:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10201956BF
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663773933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9TLCE75OnrlfwpzFjlsSUpf/T2sTV00V8cjn+fZmlq0=;
        b=bC+Nbfz+KPUOJOiZKRmyWtCi/gLQCq1DKvn9VGbcoQrJv6aHvNGUcSKcZctafinHsZKumy
        h9X6PDVwq012plSTktze+4kA5e6zsxxoE3DvBQATiMJ3iUCJjvC4CYBIX/dcmloHL6SLMl
        GuF4tgi71wspYpTUHXySFIfUMh6MneE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-NAPWeqaEOcKkvut8KQXJVw-1; Wed, 21 Sep 2022 11:25:29 -0400
X-MC-Unique: NAPWeqaEOcKkvut8KQXJVw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83471811E81;
        Wed, 21 Sep 2022 15:25:28 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EB052166B29;
        Wed, 21 Sep 2022 15:25:26 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 18/39] KVM: x86: hyper-v: Introduce fast guest_hv_cpuid_has_l2_tlb_flush() check
Date:   Wed, 21 Sep 2022 17:24:15 +0200
Message-Id: <20220921152436.3673454-19-vkuznets@redhat.com>
In-Reply-To: <20220921152436.3673454-1-vkuznets@redhat.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/hyperv.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 1b53dd4cff4d..3fff3a6f4bb9 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -174,6 +174,13 @@ static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
 	kfifo_reset_out(&tlb_flush_fifo->entries);
 }
 
+static inline bool guest_hv_cpuid_has_l2_tlb_flush(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	return hv_vcpu && (hv_vcpu->cpuid_cache.nested_eax & HV_X64_NESTED_DIRECT_FLUSH);
+}
+
 static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
-- 
2.37.3

