Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEBB53393A
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbiEYJEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241349AbiEYJDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:03:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8529A98086
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V1WILEWqg0+562QNDZjape19jnCOEngqZqCfqefM0qg=;
        b=UJS+ihkKiDKCzX0QeCOTIPILWE/+cfHaMNZvT1PvRdBUCyHKY2xub/PQUEU+3xiNMetRPT
        RU0ba8xevrvFuQaoMysTELxhrftLceGr/QcHB0vjfLZ2ywIbUTYnhRoGLsCEq7T4+I6jAR
        qjUYpoVeBohbdU29qEHaApglZGuvx0s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-Dk0R-fkwPPWVOhMl6fQtPw-1; Wed, 25 May 2022 05:02:11 -0400
X-MC-Unique: Dk0R-fkwPPWVOhMl6fQtPw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45826858284;
        Wed, 25 May 2022 09:02:11 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E209A40CFD0A;
        Wed, 25 May 2022 09:02:08 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 16/37] KVM: x86: hyper-v: Introduce kvm_hv_is_tlb_flush_hcall()
Date:   Wed, 25 May 2022 11:01:12 +0200
Message-Id: <20220525090133.1264239-17-vkuznets@redhat.com>
In-Reply-To: <20220525090133.1264239-1-vkuznets@redhat.com>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
index aaced3768954..10c5aaa99f9f 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -171,6 +171,24 @@ static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
 
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

