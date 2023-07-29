Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6727F7679C6
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbjG2Ai4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236493AbjG2AiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:38:24 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832764498
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:34 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb98659f3cso18211995ad.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591035; x=1691195835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mSgovIDzsK9OZPmvcIO6PrlG0pGNiSzPLHn93Xk6PxY=;
        b=BbFY48Qmp8nvEYwQyB9GRdCa2QWFGF8GOSvEDsRT2X6u6sk5ecNEIIw5pDClILhRPd
         gRvtNuN3ImdWbXCF4zdd8FaLMJMM1yfDzxm9ActT6o7IL2r/JrzTNkCKHtf9wNe1Gmo3
         Tl4rruj0O7W3W3HeWguPLoJRGSnt0u0v1aQ66LzDC8u8FZwW1oWvwxTpJdtFONqeoOxr
         MyE1evET6xf2Bn4Wij2M2+qzHfPaZBTPWBCljf2z8npAEX9hv3TY+e+9VlxpgDDP4OAh
         +QNyW6006w+aWT6DBLJmvaDiES4sOf5Luaq+3RtJ/lFNzLcfQ5p0vXcaTRPdDU31coc0
         fKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591035; x=1691195835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mSgovIDzsK9OZPmvcIO6PrlG0pGNiSzPLHn93Xk6PxY=;
        b=NHy/2vcjMNIxoSNzzpoMioHuU2qhxBQIzBwpbiQya/dr/TGFN4n/aJ4JkbruJcppNL
         x+GQ/gogTvrHFGfBKjhJuQHHevB/2/+dVLjAncRleAJIuRVFvcpYFI/CmTk0InrqZiKK
         /5k0ys0ngD2de0Gzb/rIl63v8BpQ+9fulxkl2Psw8Z2HlmgQDSsX+ZKN4lObR/PD4gfU
         nlKgK1r3JSt88DKQ6dnoTMpKlVxHgV7MVZIVE2UX0el1jFhuCGLjTkG0xDwR1z4OsjlV
         ijdKmcGLMIR5veMO3YvbKNX+w1sl/iqyU+J9ke9VAXvRwp1CR1j+ugXTfrPlUjo4gtg1
         bfwQ==
X-Gm-Message-State: ABy/qLZqQv18plsJzKTbbuDr6EvvjfxFj/QjAqaAPcUu0U0J048eJWj9
        qN+zt66D8A8H4VIllhuz0c0pyWqysss=
X-Google-Smtp-Source: APBJJlGy+PARBjAnPL16yx26LNMKVev7tEI0rNgcySfjPv3eElz6XZ45aPg2i/DxTsp7qsC24ybgru6dHtc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e748:b0:1b5:61d3:dae5 with SMTP id
 p8-20020a170902e74800b001b561d3dae5mr14204plf.1.1690591035217; Fri, 28 Jul
 2023 17:37:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:24 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-16-seanjc@google.com>
Subject: [PATCH v4 15/34] KVM: selftests: Convert the memslot performance test
 to printf guest asserts
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

Use the printf-based GUEST_ASSERT_EQ() in the memslot perf test instead of
an half-baked open code version.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 4210cd21d159..55f1bc70e571 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -6,6 +6,8 @@
  *
  * Basic guest setup / host vCPU thread code lifted from set_memory_region_test.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <pthread.h>
 #include <sched.h>
 #include <semaphore.h>
@@ -157,7 +159,7 @@ static void *vcpu_worker(void *__data)
 				goto done;
 			break;
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_1(uc, "val = %lu");
+			REPORT_GUEST_ASSERT(uc);
 			break;
 		case UCALL_DONE:
 			goto done;
@@ -560,7 +562,7 @@ static void guest_code_test_memslot_rw(void)
 		     ptr < MEM_TEST_GPA + MEM_TEST_SIZE; ptr += page_size) {
 			uint64_t val = *(uint64_t *)ptr;
 
-			GUEST_ASSERT_1(val == MEM_TEST_VAL_2, val);
+			GUEST_ASSERT_EQ(val, MEM_TEST_VAL_2);
 			*(uint64_t *)ptr = 0;
 		}
 
-- 
2.41.0.487.g6d72f3e995-goog

