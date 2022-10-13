Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E0E5FD784
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 11:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJMJ7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 05:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiJMJ7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 05:59:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D146F9849
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 02:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665655153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jibZwnAPGYF4BXJJw2n3ac+vRoAfB2/OkyI/dleeeGU=;
        b=dr0Hp/1cTM10ta+EMeDR3lkeJv0rQ4zIHnWaSk4mMtI6WLmSpvj4mV+ZCeu2vUHo/kiMjN
        gBNbzQ2VFxcvS1rmU9VSInHgvxdd4ao9Xka8JwPGCIJuvp9EYUJV8qsTvwnSB9ozsEQTqE
        UAYPCC5XD8UsWXbStJuro/1/u2poTrs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-h9YogHpHMG27WvO4JVCVmA-1; Thu, 13 Oct 2022 05:59:08 -0400
X-MC-Unique: h9YogHpHMG27WvO4JVCVmA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32E361C07834;
        Thu, 13 Oct 2022 09:59:08 +0000 (UTC)
Received: from ovpn-194-196.brq.redhat.com (ovpn-194-196.brq.redhat.com [10.40.194.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11AFD4B400F;
        Thu, 13 Oct 2022 09:59:05 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 6/7] KVM: selftests: Test that values written to Hyper-V MSRs are preserved
Date:   Thu, 13 Oct 2022 11:58:48 +0200
Message-Id: <20221013095849.705943-7-vkuznets@redhat.com>
In-Reply-To: <20221013095849.705943-1-vkuznets@redhat.com>
References: <20221013095849.705943-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enhance 'hyperv_features' selftest by adding a check that KVM
preserves values written to PV MSRs. Two MSRs are, however, 'special':
- HV_X64_MSR_EOI as it is a 'write-only' MSR,
- HV_X64_MSR_RESET as it always reads as '0'.
The later doesn't require any special handling right now because the
test never writes anything besides '0' to the MSR, leave a TODO node
about the fact.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/hyperv_features.c    | 36 ++++++++++++++-----
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index d4549830c9d6..0cfab315eb22 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -53,22 +53,36 @@ struct hcall_data {
 	bool ud_expected;
 };
 
+static bool is_write_only_msr(uint32_t msr)
+{
+	return msr == HV_X64_MSR_EOI;
+}
+
 static void guest_msr(struct msr_data *msr)
 {
-	uint64_t ignored;
-	uint8_t vector;
+	uint8_t vector = 0;
+	uint64_t msr_val = 0;
 
 	GUEST_ASSERT(msr->idx);
 
-	if (!msr->write)
-		vector = rdmsr_safe(msr->idx, &ignored);
-	else
+	if (msr->write)
 		vector = wrmsr_safe(msr->idx, msr->write_val);
 
+	if (!vector && (!msr->write || !is_write_only_msr(msr->idx)))
+		vector = rdmsr_safe(msr->idx, &msr_val);
+
 	if (msr->fault_expected)
-		GUEST_ASSERT_2(vector == GP_VECTOR, msr->idx, vector);
+		GUEST_ASSERT_3(vector == GP_VECTOR, msr->idx, vector, GP_VECTOR);
 	else
-		GUEST_ASSERT_2(!vector, msr->idx, vector);
+		GUEST_ASSERT_3(!vector, msr->idx, vector, 0);
+
+	if (vector || is_write_only_msr(msr->idx))
+		goto done;
+
+	if (msr->write)
+		GUEST_ASSERT_3(msr_val == msr->write_val, msr->idx,
+			       msr_val, msr->write_val);
+done:
 	GUEST_DONE();
 }
 
@@ -258,6 +272,12 @@ static void guest_test_msrs_access(void)
 		case 16:
 			msr->idx = HV_X64_MSR_RESET;
 			msr->write = true;
+			/*
+			 * TODO: the test only writes '0' to HV_X64_MSR_RESET
+			 * at the moment, writing some other value there will
+			 * trigger real vCPU reset and the code is not prepared
+			 * to handle it yet.
+			 */
 			msr->write_val = 0;
 			msr->fault_expected = false;
 			break;
@@ -452,7 +472,7 @@ static void guest_test_msrs_access(void)
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_2(uc, "MSR = %lx, vector = %lx");
+			REPORT_GUEST_ASSERT_3(uc, "MSR = %lx, arg1 = %lx, arg2 = %lx");
 			return;
 		case UCALL_DONE:
 			break;
-- 
2.37.3

