Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85B7614D92
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 15:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiKAO7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 10:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiKAO6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 10:58:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414191CFFF
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qQcK4l9u4I2Idc0ITAw2pfMb8xlkAKdpiWoA98ORrTk=;
        b=NYPjdDxPSslatlni0fWJne/9WHFDHjmZtbaUuweHB/61zJ39nBv+zaNU3USjLqqosCoslC
        HxYtVv1qp12PsS2ljskle1X4OYVEs8qncfUGyrcpZ3RcT95ycp3Wtd2GCmOdQaMSClk3RL
        tSjihOkW+x0dOF7UooeKJ4YcDWtecXw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-O7tw50eVOlC97IovxvtRXQ-1; Tue, 01 Nov 2022 10:56:07 -0400
X-MC-Unique: O7tw50eVOlC97IovxvtRXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DD961C004F5;
        Tue,  1 Nov 2022 14:56:06 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CF08C15BA5;
        Tue,  1 Nov 2022 14:56:04 +0000 (UTC)
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
Subject: [PATCH v13 32/48] KVM: selftests: Move the function doing Hyper-V hypercall to a common header
Date:   Tue,  1 Nov 2022 15:54:10 +0100
Message-Id: <20221101145426.251680-33-vkuznets@redhat.com>
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All Hyper-V specific tests issuing hypercalls need this.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/hyperv.h     | 18 ++++++++++++++++++
 .../selftests/kvm/x86_64/hyperv_features.c    | 19 +------------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index f0a8a93694b2..40f8b1b423fc 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -185,6 +185,24 @@
 /* hypercall options */
 #define HV_HYPERCALL_FAST_BIT		BIT(16)
 
+static inline uint8_t hyperv_hypercall(u64 control, vm_vaddr_t input_address,
+				       vm_vaddr_t output_address,
+				       uint64_t *hv_status)
+{
+	uint8_t vector;
+
+	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
+	asm volatile("mov %[output_address], %%r8\n\t"
+		     KVM_ASM_SAFE("vmcall")
+		     : "=a" (*hv_status),
+		       "+c" (control), "+d" (input_address),
+		       KVM_ASM_SAFE_OUTPUTS(vector)
+		     : [output_address] "r"(output_address),
+		       "a" (-EFAULT)
+		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
+	return vector;
+}
+
 /* Proper HV_X64_MSR_GUEST_OS_ID value */
 #define HYPERV_LINUX_OS_ID ((u64)0x8100 << 48)
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 71bb91602a7f..5ff4ff2365bb 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -13,23 +13,6 @@
 #include "processor.h"
 #include "hyperv.h"
 
-static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
-				vm_vaddr_t output_address, uint64_t *hv_status)
-{
-	uint8_t vector;
-
-	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
-	asm volatile("mov %[output_address], %%r8\n\t"
-		     KVM_ASM_SAFE("vmcall")
-		     : "=a" (*hv_status),
-		       "+c" (control), "+d" (input_address),
-		       KVM_ASM_SAFE_OUTPUTS(vector)
-		     : [output_address] "r"(output_address),
-		       "a" (-EFAULT)
-		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
-	return vector;
-}
-
 struct msr_data {
 	uint32_t idx;
 	bool available;
@@ -79,7 +62,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 		input = output = 0;
 	}
 
-	vector = hypercall(hcall->control, input, output, &res);
+	vector = hyperv_hypercall(hcall->control, input, output, &res);
 	if (hcall->ud_expected) {
 		GUEST_ASSERT_2(vector == UD_VECTOR, hcall->control, vector);
 	} else {
-- 
2.37.3

