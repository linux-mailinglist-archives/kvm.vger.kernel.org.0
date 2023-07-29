Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4077679CA
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbjG2AjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235982AbjG2Aig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:38:36 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FE84691
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:46 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bbb34b091dso18318185ad.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591042; x=1691195842;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4KUkVA9WMnyLxYGz79SDCJn7ve+A3Wf1F6DPB0+B89Y=;
        b=m1lnc4WNUUb4LhX1UCRMwTzJ/kua4mNB+cCI2zAZJDw/YuWyBNC/mjTXyBnbABdSwK
         XlTEeooUTC/+KEnZs8SdsD7KD4D5QT2j61EexSFXezqGR/jmMDfqT8QirXCkaEUchBzC
         yQnQHpQKSbauSGLL1v1IXcHYKGUzNuLGMNkFvyI4TcWFeI2ssuz9YaMH0Oei27k/Nyon
         5p7fEQS3naCoN6/hzKKe7XVSJuuPLuc5vpk+ZhrcR46/7R1M/CvlAIb/SNLlgSZcRNvd
         /rG6QtBHZYxac3GXVkkOzTpCaNB7ZTUbXG+aooqbeSQfPP1kS8AIrJeT4F/CLnedG0IS
         LNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591042; x=1691195842;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4KUkVA9WMnyLxYGz79SDCJn7ve+A3Wf1F6DPB0+B89Y=;
        b=FFgtUCgBOZyCngqB9UmqZAZJ4jwnXm6JSlYTz1JIoxyWSMSENAyKfiNuBrefulc97y
         /qVPumKhfq7YIaG8Au5H7RVk24UGsno5RDHHRnFNruXZSimlfx/p1cIhur9K9dYNHhS6
         a28NhZdfjJuevLl8a03UrSvL/gDchPx3RLRXta2gqxCWn2Osx6JfqEw0Rp2Ud5BlGYqB
         k3q4t7JMb4UZc7D5fRA6XKqAeyPlCq4ATVhpAmqEdVx79m9QhQ93nexOzcxP0EHzKVOi
         yjyu8rShKFcBfQVb3Svlz0lF8SocyBMgoz5ftbS+Z9KwBXeW/HTTkc8dQD4vGofPStRQ
         XE0g==
X-Gm-Message-State: ABy/qLbXD8M/mABIhu9jcNrSf83Ii2pbK8bYoG8xhSxyo2N6JDg3d74A
        pYsl4amrh1OyeDFVw1LQ+Te4lcxNMwY=
X-Google-Smtp-Source: APBJJlGuA7vi3U6gzhB6JqQWicL1WyEr3IUOwMBH5vFB9eArqoqzqemY3es1drglI/28nECd76urnf6xTrY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c9:b0:1bb:8c42:79f4 with SMTP id
 o9-20020a170902d4c900b001bb8c4279f4mr11146plg.2.1690591042672; Fri, 28 Jul
 2023 17:37:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:28 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-20-seanjc@google.com>
Subject: [PATCH v4 19/34] KVM: selftests: Convert steal_time test to printf
 style GUEST_ASSERT
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

Convert the steal_time test to use printf-based GUEST_ASERT.
Opportunistically use GUEST_ASSERT_EQ() and GUEST_ASSERT_NE() so that the
test spits out debug information on failure.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/steal_time.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index c87f38712073..8649c8545882 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -4,6 +4,8 @@
  *
  * Copyright (C) 2020, Red Hat, Inc.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <time.h>
@@ -31,8 +33,8 @@ static uint64_t guest_stolen_time[NR_VCPUS];
 static void check_status(struct kvm_steal_time *st)
 {
 	GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
-	GUEST_ASSERT(READ_ONCE(st->flags) == 0);
-	GUEST_ASSERT(READ_ONCE(st->preempted) == 0);
+	GUEST_ASSERT_EQ(READ_ONCE(st->flags), 0);
+	GUEST_ASSERT_EQ(READ_ONCE(st->preempted), 0);
 }
 
 static void guest_code(int cpu)
@@ -40,7 +42,7 @@ static void guest_code(int cpu)
 	struct kvm_steal_time *st = st_gva[cpu];
 	uint32_t version;
 
-	GUEST_ASSERT(rdmsr(MSR_KVM_STEAL_TIME) == ((uint64_t)st_gva[cpu] | KVM_MSR_ENABLED));
+	GUEST_ASSERT_EQ(rdmsr(MSR_KVM_STEAL_TIME), ((uint64_t)st_gva[cpu] | KVM_MSR_ENABLED));
 
 	memset(st, 0, sizeof(*st));
 	GUEST_SYNC(0);
@@ -122,8 +124,8 @@ static int64_t smccc(uint32_t func, uint64_t arg)
 
 static void check_status(struct st_time *st)
 {
-	GUEST_ASSERT(READ_ONCE(st->rev) == 0);
-	GUEST_ASSERT(READ_ONCE(st->attr) == 0);
+	GUEST_ASSERT_EQ(READ_ONCE(st->rev), 0);
+	GUEST_ASSERT_EQ(READ_ONCE(st->attr), 0);
 }
 
 static void guest_code(int cpu)
@@ -132,15 +134,15 @@ static void guest_code(int cpu)
 	int64_t status;
 
 	status = smccc(SMCCC_ARCH_FEATURES, PV_TIME_FEATURES);
-	GUEST_ASSERT(status == 0);
+	GUEST_ASSERT_EQ(status, 0);
 	status = smccc(PV_TIME_FEATURES, PV_TIME_FEATURES);
-	GUEST_ASSERT(status == 0);
+	GUEST_ASSERT_EQ(status, 0);
 	status = smccc(PV_TIME_FEATURES, PV_TIME_ST);
-	GUEST_ASSERT(status == 0);
+	GUEST_ASSERT_EQ(status, 0);
 
 	status = smccc(PV_TIME_ST, 0);
-	GUEST_ASSERT(status != -1);
-	GUEST_ASSERT(status == (ulong)st_gva[cpu]);
+	GUEST_ASSERT_NE(status, -1);
+	GUEST_ASSERT_EQ(status, (ulong)st_gva[cpu]);
 
 	st = (struct st_time *)status;
 	GUEST_SYNC(0);
-- 
2.41.0.487.g6d72f3e995-goog

