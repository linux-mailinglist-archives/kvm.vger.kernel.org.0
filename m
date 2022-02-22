Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5A24BFD6C
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 16:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbiBVPsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 10:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiBVPr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 10:47:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A1844505A
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 07:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645544848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L1nWB2ndNveDr5qjG/ERQTuXI64n7dwV4B5yib+Iqec=;
        b=Xc1gXkkmtqQMC78Oqz/vHA01OeoU8cuCB1NOKD9f0zyd34vs391hvBDkv20KamHmG5Qr99
        P7cTMEoY6DOBeJI8sG121bqf3mUIuu6hm0bgjhtfnbhprO6KQjIkf51+nwh3Y2v291Ph8U
        oWBiGbVlZJ3dJGyP802sOxS1VjEcABY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-MWbYDG-RNLSwfD2FyOa9OA-1; Tue, 22 Feb 2022 10:47:25 -0500
X-MC-Unique: MWbYDG-RNLSwfD2FyOa9OA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C97E5FC81;
        Tue, 22 Feb 2022 15:47:23 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E00951086486;
        Tue, 22 Feb 2022 15:47:21 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall
Date:   Tue, 22 Feb 2022 16:46:42 +0100
Message-Id: <20220222154642.684285-5-vkuznets@redhat.com>
In-Reply-To: <20220222154642.684285-1-vkuznets@redhat.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It has been proven on practice that at least Windows Server 2019 tries
using HVCALL_SEND_IPI_EX in 'XMM fast' mode when it has more than 64 vCPUs
and it needs to send an IPI to a vCPU > 63. Similarly to other XMM Fast
hypercalls (HVCALL_FLUSH_VIRTUAL_ADDRESS_{LIST,SPACE}{,_EX}), this
information is missing in TLFS as of 6.0b. Currently, KVM returns an error
(HV_STATUS_INVALID_HYPERCALL_INPUT) and Windows crashes.

Note, HVCALL_SEND_IPI is a 'standard' fast hypercall (not 'XMM fast') as
all its parameters fit into RDX:R8 and this is handled by KVM correctly.

Fixes: d8f5537a8816 ("KVM: hyper-v: Advertise support for fast XMM hypercalls")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 52 ++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 6dda93bf98ae..3060057bdfd4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1890,6 +1890,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	int sparse_banks_len;
 	u32 vector;
 	bool all_cpus;
+	int i;
 
 	if (hc->code == HVCALL_SEND_IPI) {
 		if (!hc->fast) {
@@ -1910,9 +1911,15 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 
 		trace_kvm_hv_send_ipi(vector, sparse_banks[0]);
 	} else {
-		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
-					    sizeof(send_ipi_ex))))
-			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		if (!hc->fast) {
+			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
+						    sizeof(send_ipi_ex))))
+				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		} else {
+			send_ipi_ex.vector = (u32)hc->ingpa;
+			send_ipi_ex.vp_set.format = hc->outgpa;
+			send_ipi_ex.vp_set.valid_bank_mask = sse128_lo(hc->xmm[0]);
+		}
 
 		trace_kvm_hv_send_ipi_ex(send_ipi_ex.vector,
 					 send_ipi_ex.vp_set.format,
@@ -1920,8 +1927,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 
 		vector = send_ipi_ex.vector;
 		valid_bank_mask = send_ipi_ex.vp_set.valid_bank_mask;
-		sparse_banks_len = bitmap_weight(&valid_bank_mask, 64) *
-			sizeof(sparse_banks[0]);
+		sparse_banks_len = bitmap_weight(&valid_bank_mask, 64);
 
 		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
 
@@ -1931,12 +1937,27 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		if (!sparse_banks_len)
 			goto ret_success;
 
-		if (kvm_read_guest(kvm,
-				   hc->ingpa + offsetof(struct hv_send_ipi_ex,
-							vp_set.bank_contents),
-				   sparse_banks,
-				   sparse_banks_len))
-			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		if (!hc->fast) {
+			if (kvm_read_guest(kvm,
+					   hc->ingpa + offsetof(struct hv_send_ipi_ex,
+								vp_set.bank_contents),
+					   sparse_banks,
+					   sparse_banks_len * sizeof(sparse_banks[0])))
+				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		} else {
+			/*
+			 * The lower half of XMM0 is already consumed, each XMM holds
+			 * two sparse banks.
+			 */
+			if (sparse_banks_len > (2 * HV_HYPERCALL_MAX_XMM_REGISTERS - 1))
+				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+			for (i = 0; i < sparse_banks_len; i++) {
+				if (i % 2)
+					sparse_banks[i] = sse128_lo(hc->xmm[(i + 1) / 2]);
+				else
+					sparse_banks[i] = sse128_hi(hc->xmm[i / 2]);
+			}
+		}
 	}
 
 check_and_send_ipi:
@@ -2098,6 +2119,7 @@ static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
+	case HVCALL_SEND_IPI_EX:
 		return true;
 	}
 
@@ -2265,14 +2287,8 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_hv_flush_tlb(vcpu, &hc);
 		break;
 	case HVCALL_SEND_IPI:
-		if (unlikely(hc.rep)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_send_ipi(vcpu, &hc);
-		break;
 	case HVCALL_SEND_IPI_EX:
-		if (unlikely(hc.fast || hc.rep)) {
+		if (unlikely(hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-- 
2.35.1

