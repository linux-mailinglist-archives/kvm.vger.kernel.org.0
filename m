Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8C14F843C
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345331AbiDGP7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345334AbiDGP7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:59:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64771CD64D
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649347038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c7ur2jhm1CbAvmCE2zq5ASE03ZEeiT3sbkr6ioIGwDo=;
        b=G/MI/7/1CHd/B7vKLz+iaTuJcZzh+1JASsYs4WeU0XMLt4kXaiYskr1tc2VPVHYI01pZYA
        3IasH+vYqYtjw8en6LD6l+1Giyz+IXRCQSJbzXAgJkNtpDWg44QT5Sk/r020ZmgH3O9qeh
        AkNO9jPzaoj78YLvdDmYdqV3L1n3OIg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-3ZG-Xf-eO-G7vuNS5HppuQ-1; Thu, 07 Apr 2022 11:57:15 -0400
X-MC-Unique: 3ZG-Xf-eO-G7vuNS5HppuQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11CA61C04B4A;
        Thu,  7 Apr 2022 15:57:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 669F254AC84;
        Thu,  7 Apr 2022 15:57:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/31] KVM: x86: hyper-v: Introduce kvm_hv_is_tlb_flush_hcall()
Date:   Thu,  7 Apr 2022 17:56:26 +0200
Message-Id: <20220407155645.940890-13-vkuznets@redhat.com>
In-Reply-To: <20220407155645.940890-1-vkuznets@redhat.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The newly introduced helper checks whether vCPU is performing a
Hyper-V TLB flush hypercall. This is required to filter out Direct TLB
flush hypercalls from L2 for processing.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 448877b478ef..3687e1e61e0d 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -168,6 +168,30 @@ static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
 	tlb_flush_ring = kvm_hv_get_tlb_flush_ring(vcpu);
 	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
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
+#ifdef CONFIG_X86_64
+	if (is_64_bit_hypercall(vcpu)) {
+		code = kvm_rcx_read(vcpu) & 0xffff;
+	} else
+#endif
+	{
+		code = kvm_rax_read(vcpu) & 0xffff;
+	}
+
+	return (code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
+		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST ||
+		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX ||
+		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX);
+}
+
 void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
 
 
-- 
2.35.1

