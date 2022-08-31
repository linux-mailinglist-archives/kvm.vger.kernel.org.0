Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923435A7970
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiHaIub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbiHaIu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:50:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520F6A6C3F
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 01:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661935822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=anEFIXZZ1opJoJFwtKImqTmVkj7AwPcnsMyF66FQ7u0=;
        b=hsxdDluYbO00BsXeQfj7sbRg8WRqvN1L9cDqRjTDo/d2ViDsArqg2YsYkrzwJvs1lHrSgY
        KXjEeZg4+lT3CPEh5xaiD7D5wtZSJQ0yj46KPi0BgMyc4NE41pkWa7yQI31jCMVdGx69gA
        orwRLkBDyuvXkrOyjjQOoGOSDLBb2hI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-S84vX5L7NOmoIxfBY-_KGQ-1; Wed, 31 Aug 2022 04:50:17 -0400
X-MC-Unique: S84vX5L7NOmoIxfBY-_KGQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 601D0101A54E;
        Wed, 31 Aug 2022 08:50:17 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6328C15BB3;
        Wed, 31 Aug 2022 08:50:15 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: selftests: Rename 'msr->availble' to 'msr->should_not_gp' in hyperv_features test
Date:   Wed, 31 Aug 2022 10:50:08 +0200
Message-Id: <20220831085009.1627523-3-vkuznets@redhat.com>
In-Reply-To: <20220831085009.1627523-1-vkuznets@redhat.com>
References: <20220831085009.1627523-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It may not be clear what 'msr->availble' means. The test actually
checks that accessing the particular MSR doesn't cause #GP, rename
the varialble accordingly.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/hyperv_features.c    | 92 +++++++++----------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 79ab0152d281..4ec4776662a4 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -33,7 +33,7 @@ static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
 
 struct msr_data {
 	uint32_t idx;
-	bool available;
+	bool should_not_gp;
 	bool write;
 	u64 write_val;
 };
@@ -56,7 +56,7 @@ static void guest_msr(struct msr_data *msr)
 	else
 		vector = wrmsr_safe(msr->idx, msr->write_val);
 
-	if (msr->available)
+	if (msr->should_not_gp)
 		GUEST_ASSERT_2(!vector, msr->idx, vector);
 	else
 		GUEST_ASSERT_2(vector == GP_VECTOR, msr->idx, vector);
@@ -153,12 +153,12 @@ static void guest_test_msrs_access(void)
 			 */
 			msr->idx = HV_X64_MSR_GUEST_OS_ID;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 1:
 			msr->idx = HV_X64_MSR_HYPERCALL;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 2:
 			feat->eax |= HV_MSR_HYPERCALL_AVAILABLE;
@@ -169,116 +169,116 @@ static void guest_test_msrs_access(void)
 			msr->idx = HV_X64_MSR_GUEST_OS_ID;
 			msr->write = 1;
 			msr->write_val = LINUX_OS_ID;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 3:
 			msr->idx = HV_X64_MSR_GUEST_OS_ID;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 4:
 			msr->idx = HV_X64_MSR_HYPERCALL;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 
 		case 5:
 			msr->idx = HV_X64_MSR_VP_RUNTIME;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 6:
 			feat->eax |= HV_MSR_VP_RUNTIME_AVAILABLE;
 			msr->idx = HV_X64_MSR_VP_RUNTIME;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 7:
 			/* Read only */
 			msr->idx = HV_X64_MSR_VP_RUNTIME;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 
 		case 8:
 			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 9:
 			feat->eax |= HV_MSR_TIME_REF_COUNT_AVAILABLE;
 			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 10:
 			/* Read only */
 			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 
 		case 11:
 			msr->idx = HV_X64_MSR_VP_INDEX;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 12:
 			feat->eax |= HV_MSR_VP_INDEX_AVAILABLE;
 			msr->idx = HV_X64_MSR_VP_INDEX;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 13:
 			/* Read only */
 			msr->idx = HV_X64_MSR_VP_INDEX;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 
 		case 14:
 			msr->idx = HV_X64_MSR_RESET;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 15:
 			feat->eax |= HV_MSR_RESET_AVAILABLE;
 			msr->idx = HV_X64_MSR_RESET;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 16:
 			msr->idx = HV_X64_MSR_RESET;
 			msr->write = 1;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 
 		case 17:
 			msr->idx = HV_X64_MSR_REFERENCE_TSC;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 18:
 			feat->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
 			msr->idx = HV_X64_MSR_REFERENCE_TSC;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 19:
 			msr->idx = HV_X64_MSR_REFERENCE_TSC;
 			msr->write = 1;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 
 		case 20:
 			msr->idx = HV_X64_MSR_EOM;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 21:
 			/*
@@ -287,145 +287,145 @@ static void guest_test_msrs_access(void)
 			 */
 			msr->idx = HV_X64_MSR_EOM;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 22:
 			feat->eax |= HV_MSR_SYNIC_AVAILABLE;
 			msr->idx = HV_X64_MSR_EOM;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 23:
 			msr->idx = HV_X64_MSR_EOM;
 			msr->write = 1;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 
 		case 24:
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 25:
 			feat->eax |= HV_MSR_SYNTIMER_AVAILABLE;
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 26:
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 1;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 27:
 			/* Direct mode test */
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 1;
 			msr->write_val = 1 << 12;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 28:
 			feat->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 1;
 			msr->write_val = 1 << 12;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 
 		case 29:
 			msr->idx = HV_X64_MSR_EOI;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 30:
 			feat->eax |= HV_MSR_APIC_ACCESS_AVAILABLE;
 			msr->idx = HV_X64_MSR_EOI;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 
 		case 31:
 			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 32:
 			feat->eax |= HV_ACCESS_FREQUENCY_MSRS;
 			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 33:
 			/* Read only */
 			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 
 		case 34:
 			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 35:
 			feat->eax |= HV_ACCESS_REENLIGHTENMENT;
 			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 36:
 			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 37:
 			/* Can only write '0' */
 			msr->idx = HV_X64_MSR_TSC_EMULATION_STATUS;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 
 		case 38:
 			msr->idx = HV_X64_MSR_CRASH_P0;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 39:
 			feat->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
 			msr->idx = HV_X64_MSR_CRASH_P0;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 40:
 			msr->idx = HV_X64_MSR_CRASH_P0;
 			msr->write = 1;
 			msr->write_val = 1;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 
 		case 41:
 			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
 			msr->write = 0;
-			msr->available = 0;
+			msr->should_not_gp = 0;
 			break;
 		case 42:
 			feat->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
 			dbg->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
 			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
 			msr->write = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 		case 43:
 			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
 			msr->write = 1;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->should_not_gp = 1;
 			break;
 
 		case 44:
-- 
2.37.2

