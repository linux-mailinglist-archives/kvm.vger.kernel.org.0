Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737DD64A748
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbiLLShk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbiLLShf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:37:35 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C6D65F3
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:34 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id z8-20020aa79588000000b00576e8050ec9so397055pfj.5
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2bbURCdqofOFDrUiFP7Zf5wqNKFvpWI0apMY/Oj4ukw=;
        b=gbS17rhkHoVXb0OpoVPAKWtl7yRPxK8Vc09PU1KLXZzDv9md5UC9pko3x6/m67drC1
         Y5XO4OWBJhYfcE2vRyVi+DtiFgeX4INeIRFIDhCcDoLWJOIQPBv8HZ0Y/eYx5HZQ6Cxx
         PrDlPxfCR+SRe0efthnkNM7HSMl7hFLDAc4A7gO/mjWn0IoBlnLW5fISGAtoDjCb+0US
         ShQ5q09UQ40NoDxurmINEcRz625soBdZk1btWdM5Fr0GsYMSOfEFTjnYyi+cztCDH+2f
         39YXnzzMtOtRObU6ZwG6WHkSBCVV/pTe05FlvurfaiMnCU4GWUNfsocPPBJA9UjJqJym
         CwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2bbURCdqofOFDrUiFP7Zf5wqNKFvpWI0apMY/Oj4ukw=;
        b=s4n2dVOQoHYnHN3nWKzbyCG7NAIpdMnp8pj2toG6e3DV8YT9C3EJNyzXCWHLTf8WS+
         cmHAFB366hsPW9CO8oY9Rq2qZl7rN7QTea71XIyfFQwwqOMHBYAY2OVNLM/JkhpGjren
         tGbM214Xso8bylvbpNOTnhnW3cp22fMIBMu5pYnB3WN9zopytMjt0p8/6nyo/zfGvEWC
         A2ca9glat/uG2joArC4RY+6Y8DicEWsM8aW2Qq04K05MODtwxF2LwpVAZDtZXNnNmOKU
         nCrE5Y4SHzuRNmtY/dc2xxr05A2FijcfmkoFPKDNJ0qG8sUYouLtKMqTDN8qlQSNm2CM
         LbNg==
X-Gm-Message-State: ANoB5pnS97QrmGoXOm75zUgtBkAPly9rXJzXyprqh9JuS7dy843/GF+8
        n5iQXUP5rMGsKOKkGDAYrHLw04Ie9IyZ
X-Google-Smtp-Source: AA0mqf7eQRS0b3QO7o6w6MhBLfw+WBAM9g7CwpHpipQNZ5OHcoxaAPLZu7SR6EyF1XotxyTLfET4fU0wti2d
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:aa7:8487:0:b0:56c:3bb4:28a8 with SMTP id
 u7-20020aa78487000000b0056c3bb428a8mr79335494pfn.83.1670870254097; Mon, 12
 Dec 2022 10:37:34 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:37:13 -0800
In-Reply-To: <20221212183720.4062037-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221212183720.4062037-7-vipinsh@google.com>
Subject: [Patch v4 06/13] KVM: selftests: Test that values written to Hyper-V
 MSRs are preserved
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Enhance 'hyperv_features' selftest by adding a check that KVM
preserves values written to PV MSRs. Two MSRs are, however, 'special':
- HV_X64_MSR_EOI as it is a 'write-only' MSR,
- HV_X64_MSR_RESET as it always reads as '0'.
The later doesn't require any special handling right now because the
test never writes anything besides '0' to the MSR, leave a TODO node
about the fact.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/hyperv_features.c    | 36 ++++++++++++++-----
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index daad3e3cc7bb..b00240963974 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -34,22 +34,36 @@ struct hcall_data {
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
 
@@ -239,6 +253,12 @@ static void guest_test_msrs_access(void)
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
@@ -433,7 +453,7 @@ static void guest_test_msrs_access(void)
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_2(uc, "MSR = %lx, vector = %lx");
+			REPORT_GUEST_ASSERT_3(uc, "MSR = %lx, arg1 = %lx, arg2 = %lx");
 			return;
 		case UCALL_DONE:
 			break;
-- 
2.39.0.rc1.256.g54fd8350bd-goog

