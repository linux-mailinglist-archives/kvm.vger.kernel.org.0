Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30B47679E2
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbjG2Ak1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbjG2Ajx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:39:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C1E4EFD
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:25 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d1ebc896bd7so2489862276.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591062; x=1691195862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uqgzEcKwgDl6AmVuFP39+si1T3Ya5yGv/aLgXdHyXDE=;
        b=fvI3egsPRdl7x5TIjH2EOrD2f/T/HclIL2aPO34GGiSzGBfdKdwjZp9XOdOAfFV8De
         GaIg88nJGpbUijVUqQfVh711UtHGpq+25x5CvLvNnNO3IoPjD9jcqBPgKr2KOMAHNnur
         sd5TKdQxtbsVsfSJGVH+CfR8faEfr/z3bWeqvcqfnC8AtS4FqO2XnqnvANwkVYlTPXaK
         tqt1jtFPvLLM7FXra00twXW1xp6756sf8zJNZuMVsgXomcI0pvusFdGrQ4cq54QQn85s
         YcZ0QQ4IH7klbQ/xFgqvH//siGtJktYv2CFC7ukfKe6FPmsnWvYDyMp3atHnSZ/wqL4V
         BRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591062; x=1691195862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uqgzEcKwgDl6AmVuFP39+si1T3Ya5yGv/aLgXdHyXDE=;
        b=RB9bKQK1ZBCCg/+iq7v9qNGU7WvhviTXOTx6jG0MaYFV+27PnIIhpAUnB0NfE15x9u
         OvB2s87mZt/+XRNveFD1kTxS5UbH084zKPhj5jyt6L7cW7/EwMWQh1wWPfWsxwbwRVNe
         XGTuwFsUm2iB9pUyeqQ9hUN1jzn4Gu9XM8TY863rexhrVeeeDb83XwPdziwXb7OSyr7e
         fPhs83wdIJTP1E4ZmR69Y2ro1E3BXh4xCkDpuzMjhX2HVzjC0zi2xeYiGT5Mr7aP5vno
         q8C8CJ4mU7b8Gr3l4Zio2X4C0kpUx1CmfSSSlhQnUNJ42g2mi7lz2CfF3jQVOjkX7C9z
         Fb2A==
X-Gm-Message-State: ABy/qLY3No9K2XKj1bBJBe//oYLcVu2MsTIsNJcfNw4lems6vYk/zmcr
        sOYVRFudEzoX1do1hRx/GmvOFRhwZtQ=
X-Google-Smtp-Source: APBJJlFp9nYWKpggRzizNGYb14R0ndrG6M0izrvCDXNzuc4knf79MqpcnRtOW+PdyQ9R6qKjQkDx4s+6iCg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dc94:0:b0:c10:8d28:d3ae with SMTP id
 y142-20020a25dc94000000b00c108d28d3aemr17101ybe.8.1690591062181; Fri, 28 Jul
 2023 17:37:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:38 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-30-seanjc@google.com>
Subject: [PATCH v4 29/34] KVM: selftests: Convert the x86 userspace I/O test
 to printf guest assert
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
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

Convert x86's userspace I/O test to use printf-based guest asserts.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/userspace_io_test.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
index 0cb51fa42773..2c5d2a18d184 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -20,8 +22,8 @@ static void guest_ins_port80(uint8_t *buffer, unsigned int count)
 		end = (unsigned long)buffer + 8192;
 
 	asm volatile("cld; rep; insb" : "+D"(buffer), "+c"(count) : "d"(0x80) : "memory");
-	GUEST_ASSERT_1(count == 0, count);
-	GUEST_ASSERT_2((unsigned long)buffer == end, buffer, end);
+	GUEST_ASSERT_EQ(count, 0);
+	GUEST_ASSERT_EQ((unsigned long)buffer, end);
 }
 
 static void guest_code(void)
@@ -43,7 +45,9 @@ static void guest_code(void)
 	memset(buffer, 0, sizeof(buffer));
 	guest_ins_port80(buffer, 8192);
 	for (i = 0; i < 8192; i++)
-		GUEST_ASSERT_2(buffer[i] == 0xaa, i, buffer[i]);
+		__GUEST_ASSERT(buffer[i] == 0xaa,
+			       "Expected '0xaa', got '0x%x' at buffer[%u]",
+			       buffer[i], i);
 
 	GUEST_DONE();
 }
@@ -91,7 +95,7 @@ int main(int argc, char *argv[])
 	case UCALL_DONE:
 		break;
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "argN+1 = 0x%lx, argN+2 = 0x%lx");
+		REPORT_GUEST_ASSERT(uc);
 	default:
 		TEST_FAIL("Unknown ucall %lu", uc.cmd);
 	}
-- 
2.41.0.487.g6d72f3e995-goog

