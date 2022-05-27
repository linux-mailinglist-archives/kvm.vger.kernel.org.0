Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67AC536530
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 17:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351646AbiE0P4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 11:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353804AbiE0P43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 11:56:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F312959B
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 08:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653666976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6EbOQEM4KSVA9gLlPa9QlR/SHY818DTJV2naZEjUXSk=;
        b=FWBx1MgN6ooXUTGQt4eqctBJET5ZmuXYPbZNITe4FOZs1D+pMfreLNgC0GNNYXwkdHdHyq
        sIt9I7OdoAew1QpfCTed+cSE3cR9Kv7NhYGcCT/oJMc/nM8dCjuTV9UzjK6p2pwYI4kWzA
        4stcmGzQYChXGVlhOb22s9/RUIORyh4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-tfBIio7rNPOIMFaQSztprw-1; Fri, 27 May 2022 11:56:14 -0400
X-MC-Unique: tfBIio7rNPOIMFaQSztprw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21FBE858EFE;
        Fri, 27 May 2022 15:56:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A29782166B26;
        Fri, 27 May 2022 15:56:11 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/37] KVM: x86: hyper-v: Use HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK instead of raw '64'
Date:   Fri, 27 May 2022 17:55:18 +0200
Message-Id: <20220527155546.1528910-10-vkuznets@redhat.com>
In-Reply-To: <20220527155546.1528910-1-vkuznets@redhat.com>
References: <20220527155546.1528910-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It may not be clear from where the '64' limit for the maximum sparse
bank number comes from, use HV_MAX_SPARSE_VCPU_BANKS define instead.
Use HV_VCPUS_PER_SPARSE_BANK in KVM_HV_MAX_SPARSE_VCPU_SET_BITS's
definition. Opportunistically adjust the comment around BUILD_BUG_ON().

No functional change.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 992972e0f5de..c43355cb60bc 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -43,7 +43,7 @@
 /* "Hv#1" signature */
 #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
 
-#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
+#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, HV_VCPUS_PER_SPARSE_BANK)
 
 static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
 				bool vcpu_kick);
@@ -1799,7 +1799,7 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
 				 u64 *sparse_banks, int consumed_xmm_halves,
 				 gpa_t offset)
 {
-	if (hc->var_cnt > 64)
+	if (hc->var_cnt > HV_MAX_SPARSE_VCPU_BANKS)
 		return -EINVAL;
 
 	/* Cap var_cnt to ignore banks that cannot contain a legal VP index. */
@@ -1909,12 +1909,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	gpa_t data_offset;
 
 	/*
-	 * The Hyper-V TLFS doesn't allow more than 64 sparse banks, e.g. the
-	 * valid mask is a u64.  Fail the build if KVM's max allowed number of
-	 * vCPUs (>4096) would exceed this limit, KVM will additional changes
-	 * for Hyper-V support to avoid setting the guest up to fail.
+	 * The Hyper-V TLFS doesn't allow more than HV_MAX_SPARSE_VCPU_BANKS
+	 * sparse banks. Fail the build if KVM's max allowed number of
+	 * vCPUs (>4096) exceeds this limit.
 	 */
-	BUILD_BUG_ON(KVM_HV_MAX_SPARSE_VCPU_SET_BITS > 64);
+	BUILD_BUG_ON(KVM_HV_MAX_SPARSE_VCPU_SET_BITS > HV_MAX_SPARSE_VCPU_BANKS);
 
 	if (!hc->fast && is_guest_mode(vcpu)) {
 		hc->ingpa = translate_nested_gpa(vcpu, hc->ingpa, 0, NULL);
-- 
2.35.3

