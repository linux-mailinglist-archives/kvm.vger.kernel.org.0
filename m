Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378744BFD67
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 16:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbiBVPrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 10:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbiBVPrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 10:47:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30D6C41318
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 07:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645544839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WazeK2egvNnqB8B3e0XibEz/A5P59Dt4xy/6Svjfz6I=;
        b=SqI+ObTyZ3qce5Ld8rZd+qJofiqFguRP31nG9Czsm6+MXt6LQHX+HK7j60xgmJPrJfEoQC
        fSXsNmsdCciwQwkkaYxt+3ed4wlv9Eb2KVPGF+Ipa1KQ4PJdgt5PR0nGp34jEOGGzMKgNd
        iI2XQyXl6y6RA00mYcCi3ckg60lC5uM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-HkfWSD5ePmmqzsmvlzuHXA-1; Tue, 22 Feb 2022 10:47:15 -0500
X-MC-Unique: HkfWSD5ePmmqzsmvlzuHXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CC17FC83;
        Tue, 22 Feb 2022 15:47:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6406B1086475;
        Tue, 22 Feb 2022 15:47:12 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] KVM: x86: hyper-v: Drop redundant 'ex' parameter from kvm_hv_flush_tlb()
Date:   Tue, 22 Feb 2022 16:46:40 +0100
Message-Id: <20220222154642.684285-3-vkuznets@redhat.com>
In-Reply-To: <20220222154642.684285-1-vkuznets@redhat.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'struct kvm_hv_hcall' has all the required information already,
there's no need to pass 'ex' additionally.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 15b6a7bd2346..714af3b94f31 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1750,7 +1750,7 @@ struct kvm_hv_hcall {
 	sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];
 };
 
-static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
+static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
 	int i;
 	gpa_t gpa;
@@ -1765,7 +1765,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	int sparse_banks_len;
 	bool all_cpus;
 
-	if (!ex) {
+	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST ||
+	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE) {
 		if (hc->fast) {
 			flush.address_space = hc->ingpa;
 			flush.flags = hc->outgpa;
@@ -2247,32 +2248,20 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 				kvm_hv_hypercall_complete_userspace;
 		return 0;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
-		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
-		break;
-	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
-		if (unlikely(hc.rep)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
-		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
 		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
+		ret = kvm_hv_flush_tlb(vcpu, &hc);
 		break;
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
 		if (unlikely(hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
+		ret = kvm_hv_flush_tlb(vcpu, &hc);
 		break;
 	case HVCALL_SEND_IPI:
 		if (unlikely(hc.rep)) {
-- 
2.35.1

