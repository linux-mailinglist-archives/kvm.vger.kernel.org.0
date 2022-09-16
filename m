Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AD45BAE97
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 15:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiIPNwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 09:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiIPNwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 09:52:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E9DA5C59
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 06:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663336343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ve/huY6tMOO/1NJ7193kRvdKRjvZnBnaxznDIHAMLys=;
        b=GNICv/pt6JB4JTNmVoD0faF36TryGg0PsbETG2OS8SofAnwPQYPJpq08SmlMLGl+09xdAC
        dVfXfyX3n5mnK5fMogE291VFMurHbVMF5fRk4HXb/4qBEa0YzpXVkZlpQ8WfEa3YavE2KJ
        ZOXoXUecmES+v4TeGG/m23889FuvL2s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-O3hopZVlO--C1KZ9ZARd3w-1; Fri, 16 Sep 2022 09:52:20 -0400
X-MC-Unique: O3hopZVlO--C1KZ9ZARd3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC04F38041DB;
        Fri, 16 Sep 2022 13:52:19 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 629CE2166B26;
        Fri, 16 Sep 2022 13:52:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] KVM: selftests: Rename 'msr->availble' to 'msr->fault_exepected' in hyperv_features test
Date:   Fri, 16 Sep 2022 15:52:03 +0200
Message-Id: <20220916135205.3185973-5-vkuznets@redhat.com>
In-Reply-To: <20220916135205.3185973-1-vkuznets@redhat.com>
References: <20220916135205.3185973-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It may not be clear what 'msr->availble' means. The test actually
checks that accessing the particular MSR doesn't cause #GP, rename
the varialble accordingly.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/hyperv_features.c    | 96 +++++++++----------
 1 file changed, 48 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 79ab0152d281..1383b979e90b 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -33,7 +33,7 @@ static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
 
 struct msr_data {
 	uint32_t idx;
-	bool available;
+	bool fault_expected;
 	bool write;
 	u64 write_val;
 };
@@ -56,10 +56,10 @@ static void guest_msr(struct msr_data *msr)
 	else
 		vector = wrmsr_safe(msr->idx, msr->write_val);
 
-	if (msr->available)
-		GUEST_ASSERT_2(!vector, msr->idx, vector);
-	else
+	if (msr->fault_expected)
 		GUEST_ASSERT_2(vector == GP_VECTOR, msr->idx, vector);
+	else
+		GUEST_ASSERT_2(!vector, msr->idx, vector);
 	GUEST_DONE();
 }
 
@@ -153,12 +153,12 @@ static void guest_test_msrs_access(void)
 			 */
 			msr->idx = HV_X64_MSR_GUEST_OS_ID;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 1:
 			msr->idx = HV_X64_MSR_HYPERCALL;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 2:
 			feat->eax |= HV_MSR_HYPERCALL_AVAILABLE;
@@ -169,116 +169,116 @@ static void guest_test_msrs_access(void)
 			msr->idx = HV_X64_MSR_GUEST_OS_ID;
 			msr->write = 1;
 			msr->write_val = LINUX_OS_ID;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 3:
 			msr->idx = HV_X64_MSR_GUEST_OS_ID;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 4:
 			msr->idx = HV_X64_MSR_HYPERCALL;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 
 		case 5:
 			msr->idx = HV_X64_MSR_VP_RUNTIME;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 6:
 			feat->eax |= HV_MSR_VP_RUNTIME_AVAILABLE;
 			msr->idx = HV_X64_MSR_VP_RUNTIME;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 7:
 			/* Read only */
 			msr->idx = HV_X64_MSR_VP_RUNTIME;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 
 		case 8:
 			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 9:
 			feat->eax |= HV_MSR_TIME_REF_COUNT_AVAILABLE;
 			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 10:
 			/* Read only */
 			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 
 		case 11:
 			msr->idx = HV_X64_MSR_VP_INDEX;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 12:
 			feat->eax |= HV_MSR_VP_INDEX_AVAILABLE;
 			msr->idx = HV_X64_MSR_VP_INDEX;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 13:
 			/* Read only */
 			msr->idx = HV_X64_MSR_VP_INDEX;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 
 		case 14:
 			msr->idx = HV_X64_MSR_RESET;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 15:
 			feat->eax |= HV_MSR_RESET_AVAILABLE;
 			msr->idx = HV_X64_MSR_RESET;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 16:
 			msr->idx = HV_X64_MSR_RESET;
 			msr->write = 1;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 
 		case 17:
 			msr->idx = HV_X64_MSR_REFERENCE_TSC;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 18:
 			feat->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
 			msr->idx = HV_X64_MSR_REFERENCE_TSC;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 19:
 			msr->idx = HV_X64_MSR_REFERENCE_TSC;
 			msr->write = 1;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 
 		case 20:
 			msr->idx = HV_X64_MSR_EOM;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 21:
 			/*
@@ -287,145 +287,145 @@ static void guest_test_msrs_access(void)
 			 */
 			msr->idx = HV_X64_MSR_EOM;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 22:
 			feat->eax |= HV_MSR_SYNIC_AVAILABLE;
 			msr->idx = HV_X64_MSR_EOM;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 23:
 			msr->idx = HV_X64_MSR_EOM;
 			msr->write = 1;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 
 		case 24:
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 25:
 			feat->eax |= HV_MSR_SYNTIMER_AVAILABLE;
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 26:
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 1;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 27:
 			/* Direct mode test */
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 1;
 			msr->write_val = 1 << 12;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 28:
 			feat->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 1;
 			msr->write_val = 1 << 12;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 
 		case 29:
 			msr->idx = HV_X64_MSR_EOI;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 30:
 			feat->eax |= HV_MSR_APIC_ACCESS_AVAILABLE;
 			msr->idx = HV_X64_MSR_EOI;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 
 		case 31:
 			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 32:
 			feat->eax |= HV_ACCESS_FREQUENCY_MSRS;
 			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 33:
 			/* Read only */
 			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 
 		case 34:
 			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 35:
 			feat->eax |= HV_ACCESS_REENLIGHTENMENT;
 			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 36:
 			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 37:
 			/* Can only write '0' */
 			msr->idx = HV_X64_MSR_TSC_EMULATION_STATUS;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 
 		case 38:
 			msr->idx = HV_X64_MSR_CRASH_P0;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 39:
 			feat->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
 			msr->idx = HV_X64_MSR_CRASH_P0;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 40:
 			msr->idx = HV_X64_MSR_CRASH_P0;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 
 		case 41:
 			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
 			msr->write = 0;
-			msr->available = 0;
+			msr->fault_expected = 1;
 			break;
 		case 42:
 			feat->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
 			dbg->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
 			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
 			msr->write = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 		case 43:
 			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
 			msr->write = 1;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->fault_expected = 0;
 			break;
 
 		case 44:
-- 
2.37.2

