Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A57F64319F
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiLETPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiLETO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:14:56 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3B624BEC
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 11:14:50 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x6-20020a17090a46c600b002190cdd7bcdso11602435pjg.6
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 11:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=daLxPAlj0AKgivwx7dIcxg+ckndNdpX6zDGreZFgJFw=;
        b=p6pPA/AoTDm7+9HZI9Q5ZYRXstd8T2xwmx9ZTx5bqUtQjIck7MAxYfNFCGQSweWMlk
         h+QzNgiHgJKPviOjrSfmkbSG2PHv/NM9C64QX8wmPogTfSM+Eo0aV4vhouZyZcevt3Qf
         AmGNJ5Qx7rjlcWpZZ4B6hBtCdk+1Kgglv1dyXhlQ8wRaoV4dj3G6uQPOrFnZeJscNG3v
         HVkyHNgEKykTMi5z8rSCkc6Ri2xMLsGQXS1gQwe2UqBhSr3j3Zi9krjNM4k6lY/t32HG
         qWagqMxjPcwWqGXUg/HlfhHiLsx5qIbAis63acAEhrlNiDULCOeXvUBzoF4ZjL3hc0pa
         ZMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=daLxPAlj0AKgivwx7dIcxg+ckndNdpX6zDGreZFgJFw=;
        b=iXF4DbEEmwk7+MXEV+bnBGqXxxfuUzSBCuXneHtotDI8Zj0l8EAKvhofFZk1CLponY
         p51+Se3EaDO5aYmZwRwZtR/Lnyw/Kw2dmUVq4QJebfkAWB+jy6hPfnTDm0JEPKUkMdie
         bnyvjxWH59JNqafrK0nhySrW0EtAHgyNI6vLdOL1JgySGSkToEn6dyKBCxOJjRpc5end
         CFkkJUOFalVbLBjPg8ko4IO15DxtX5DjFNU5iVv2cZV5Luy7FjmB6dFUB4CPRrCcXIxj
         zDtNihGWvMkEfKHY0EphIoGrgiXFt4cQDeI0bl6F+4NF+tkZklzZ09nZElH0eohq7rD9
         ke6A==
X-Gm-Message-State: ANoB5pkQnmQO2BCWqHH6PMf/iKoyRpWVObsl2U53CF46VFe7huJgwB5N
        RVdtdTY8gktE7wTuRug1VoHUAmBNuepy
X-Google-Smtp-Source: AA0mqf6MV6b8K6rn/Yh9WvJP+OL4A+6E8sQ8VIfww/YTjrTSp13gWrMvRBBrMhTi2jeQ6p8bkWCQdYfKqBV7
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:aa7:954d:0:b0:576:f9e2:a968 with SMTP id
 w13-20020aa7954d000000b00576f9e2a968mr5855831pfq.84.1670267689923; Mon, 05
 Dec 2022 11:14:49 -0800 (PST)
Date:   Mon,  5 Dec 2022 11:14:23 -0800
In-Reply-To: <20221205191430.2455108-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221205191430.2455108-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221205191430.2455108-7-vipinsh@google.com>
Subject: [Patch v3 06/13] KVM: selftests: Test that values written to Hyper-V
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
2.39.0.rc0.267.gcb52ba06e7-goog

