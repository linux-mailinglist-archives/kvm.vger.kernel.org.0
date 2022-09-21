Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDE65C012E
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiIUPZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiIUPZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:25:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553BD4D82D
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663773907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gu0PDDy6CLsusLGfMrOD4KMOxfMA0zIjf0K4+DD5BxY=;
        b=OlFpq5J0/6k87nsf+nkqUolQN/SEP7xLnCfAJwShIweOUlKRUbLXOVn7NXdbMl90jujqpf
        01d83El0we5JQYXZai5KWhEwsRLfEBubDssEPrFOZoUh4CIWt6+OUBvu4m1uTXPvDhNIVR
        SHl3cIwQXNP0LTajy0vk0caJwyE/hXk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-fmiqbS8OOaKhw20SnWy0MQ-1; Wed, 21 Sep 2022 11:25:03 -0400
X-MC-Unique: fmiqbS8OOaKhw20SnWy0MQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B7B5101E148;
        Wed, 21 Sep 2022 15:25:03 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A6F02166B26;
        Wed, 21 Sep 2022 15:25:00 +0000 (UTC)
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
Subject: [PATCH v10 08/39] x86/hyperv: Introduce HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK constants
Date:   Wed, 21 Sep 2022 17:24:05 +0200
Message-Id: <20220921152436.3673454-9-vkuznets@redhat.com>
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

It may not come clear from where the magical '64' value used in
__cpumask_to_vpset() come from. Moreover, '64' means both the maximum
sparse bank number as well as the number of vCPUs per bank. Add defines
to make things clear. These defines are also going to be used by KVM.

No functional change.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 include/asm-generic/hyperv-tlfs.h |  5 +++++
 include/asm-generic/mshyperv.h    | 11 ++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index fdce7a4cfc6f..020ca9bdbb79 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -399,6 +399,11 @@ struct hv_vpset {
 	u64 bank_contents[];
 } __packed;
 
+/* The maximum number of sparse vCPU banks which can be encoded by 'struct hv_vpset' */
+#define HV_MAX_SPARSE_VCPU_BANKS (64)
+/* The number of vCPUs in one sparse bank */
+#define HV_VCPUS_PER_SPARSE_BANK (64)
+
 /* HvCallSendSyntheticClusterIpi hypercall */
 struct hv_send_ipi {
 	u32 vector;
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index c05d2ce9b6cd..89a529093042 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -214,9 +214,10 @@ static inline int __cpumask_to_vpset(struct hv_vpset *vpset,
 {
 	int cpu, vcpu, vcpu_bank, vcpu_offset, nr_bank = 1;
 	int this_cpu = smp_processor_id();
+	int max_vcpu_bank = hv_max_vp_index / HV_VCPUS_PER_SPARSE_BANK;
 
-	/* valid_bank_mask can represent up to 64 banks */
-	if (hv_max_vp_index / 64 >= 64)
+	/* vpset.valid_bank_mask can represent up to HV_MAX_SPARSE_VCPU_BANKS banks */
+	if (max_vcpu_bank >= HV_MAX_SPARSE_VCPU_BANKS)
 		return 0;
 
 	/*
@@ -224,7 +225,7 @@ static inline int __cpumask_to_vpset(struct hv_vpset *vpset,
 	 * structs are not cleared between calls, we risk flushing unneeded
 	 * vCPUs otherwise.
 	 */
-	for (vcpu_bank = 0; vcpu_bank <= hv_max_vp_index / 64; vcpu_bank++)
+	for (vcpu_bank = 0; vcpu_bank <= max_vcpu_bank; vcpu_bank++)
 		vpset->bank_contents[vcpu_bank] = 0;
 
 	/*
@@ -236,8 +237,8 @@ static inline int __cpumask_to_vpset(struct hv_vpset *vpset,
 		vcpu = hv_cpu_number_to_vp_number(cpu);
 		if (vcpu == VP_INVAL)
 			return -1;
-		vcpu_bank = vcpu / 64;
-		vcpu_offset = vcpu % 64;
+		vcpu_bank = vcpu / HV_VCPUS_PER_SPARSE_BANK;
+		vcpu_offset = vcpu % HV_VCPUS_PER_SPARSE_BANK;
 		__set_bit(vcpu_offset, (unsigned long *)
 			  &vpset->bank_contents[vcpu_bank]);
 		if (vcpu_bank >= nr_bank)
-- 
2.37.3

