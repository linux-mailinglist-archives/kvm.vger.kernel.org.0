Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5E658CC5A
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 18:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243175AbiHHQrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 12:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243542AbiHHQrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 12:47:22 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE0113F85
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 09:47:21 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id c20-20020a6566d4000000b0041c325bd8ffso3247930pgw.4
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 09:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=N8SXFnwPPR5MQcSaOu5ZSlAqkXZlfDr7CFzr1XlTSXg=;
        b=hrLTLHi2azOSGt6pjH6RRUoHH8VJ68mOslVJmQS7IinCzd1kFZHJqzZ0lXoabCR2d7
         zQaPVOWibFDYgiaNDsvSSckbRh8wS7TtEK2obzhXkt1RDUajHAYEoDRvhum4TRBiAqdN
         ZzAKldYlqvSabE/rHm2dLNr5/3kudXGwpETr00TyoE1s7zADXkknpI72yMZFg/7FUzUU
         5b4bsRhqjcgB7Jj2wQupr5qh4tRFN1/eaaxYP2sl0GoB5YcVlvYP6NdCJyGKGgMwf9Ww
         9eAenT5GsXT8btIdL6gdzL8RsmTMMoj492lJOtRCdK/I9W6xiqPNLkCgnJZeUo+WCYrI
         Yf1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=N8SXFnwPPR5MQcSaOu5ZSlAqkXZlfDr7CFzr1XlTSXg=;
        b=yG4XsNXdxcm8+HDJgHAQn1Y5zy8eoRDLNmIhBxpXIPB5SCZXnWSgYrhRFofuvEalbP
         mLOoi0i3yOzDOJsTG6BNbyd2C/vEkWrewLjAkPIVWcCqPFSb6Fr5VfuL331Z2cCmLb/z
         KKb8y5OJvj4ub8COTPhSmRfvZTyMED5q9/3t5jLWyeFBGrpLaQp/lsAovGAWAqtyTFI5
         V5VMq/YrngzcgG1od20eOCLGv/I51u4Wg9yD9VYV2xV9T4JS3fh5GtP9eeqAYl2RCnb1
         1ELHGCVq5p/25wQhn0VeJb9XcBFQMPwLShcOBZLQP6uUzYLuD90JV+6KK56TK3x/32qf
         TS6g==
X-Gm-Message-State: ACgBeo00DSjVjhjyVYwnTfFEUPVlsH0DdYsgWuV/ttukPQp2fvtgziTo
        5H6V3W3T8WaNBjh8s5PwqEPJ4y5k2fs=
X-Google-Smtp-Source: AA6agR59eW9A76XkEZLlzg+zZXGYpA9hEHnzlWyslWupVUYl+qiwbYzKp9MQ7zrgO/UGQDYO4gSqwI5RxyI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ecc7:b0:16e:ff60:4286 with SMTP id
 a7-20020a170902ecc700b0016eff604286mr18595822plh.28.1659977239997; Mon, 08
 Aug 2022 09:47:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  8 Aug 2022 16:47:06 +0000
In-Reply-To: <20220808164707.537067-1-seanjc@google.com>
Message-Id: <20220808164707.537067-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220808164707.537067-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 6/7] x86: Test emulator's handling of LEA
 with /reg
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michal Luczaj <mhal@rbox.co>

LEA with a register-direct source operand is illegal. Verify that the
emulator raises #UD.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/emulator.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index cc20440..7d97774 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -893,6 +893,20 @@ static void test_mov_dr(uint64_t *mem)
 		report(rax == DR6_ACTIVE_LOW, "mov_dr6");
 }
 
+static void test_illegal_lea(void)
+{
+	unsigned int vector;
+
+	asm volatile (ASM_TRY_FEP("1f")
+		      ".byte 0x8d; .byte 0xc0\n\t"
+		      "1:"
+		      : : : "memory", "eax");
+
+	vector = exception_vector();
+	report(vector == UD_VECTOR,
+	       "Wanted #UD on LEA with /reg, got vector = %u", vector);
+}
+
 static void test_push16(uint64_t *mem)
 {
 	uint64_t rsp1, rsp2;
@@ -1179,6 +1193,7 @@ int main(void)
 		test_smsw_reg(mem);
 		test_nop(mem);
 		test_mov_dr(mem);
+		test_illegal_lea();
 	} else {
 		report_skip("skipping register-only tests, "
 			    "use kvm.force_emulation_prefix=1 to enable");
-- 
2.37.1.559.g78731f0fdb-goog

