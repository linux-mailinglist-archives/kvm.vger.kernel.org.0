Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E976079BFE0
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbjIKUtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbjIKLos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:44:48 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11985CDD;
        Mon, 11 Sep 2023 04:44:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d2e1a72fcca58-68c576d35feso4165686b3a.2;
        Mon, 11 Sep 2023 04:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694432683; x=1695037483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0fwr4Gu17g9ADCB8gJWJDT6I2+edw5s6r6q0JdVTMs4=;
        b=jvswYQ9GCICxW9fbhZucPhDt/gZBK3xoCfqtCD5KvPMy/vEJyG4PKYGKqyi1GMKIlC
         5YOJn5DJS5Qa79LqTRVxPaPbgENptoUGrV0EYm5AGGnV25SHKnyrJaWfGcDEIQs4cud9
         lByUNHi9Pgn0MEmVMfrBDsW8L/IBfuPX5ia1zikFISS+IR3bhykt7cmJMwAEz1DSO3la
         LSqOwF91WSWv9rqEvEjtOvRsi7FdjJ0u9mZUxOhxUcUs2gaP34U/paF5dUCyFZ9zZYdr
         +hlZObHkapCwepzKQ3LvJ5U2PaTMjaQUgnFh1c6O3VYjs5PHglqFHTHBOt9I5Wa1rHDp
         3wxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694432683; x=1695037483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0fwr4Gu17g9ADCB8gJWJDT6I2+edw5s6r6q0JdVTMs4=;
        b=u4WA3tTQPO4SVVDUCGhardu0ABtFn/TfXMdom+DuL0MwzvSwf9FOZYYxG2eSNVuOlO
         kn22qcKU8588C4UZ/NemJmvqDKVsjvI3wbQXGd5WJVAcMXxls+NLfeImTFyRDuAc9Wlj
         UGWVUCmijNaKiHslh9PRHbQm6fJi8s4fneKKedeKqMqncJp1SaAp6aWi/o2idyaCd3bj
         FZAdJJx3KrFZsh7lYkSt9AsaxfWgdlv6dCFT16qXGgIfryp9TUj3zZHqmnybu0po7GmH
         lKd0mI+9tP2Z+KOu99rXi/Tmo4yQo5pjOuVhVfYYwHloW3f/iZ+OgELY5SP9VINSoCy9
         3VfA==
X-Gm-Message-State: AOJu0Yypfho5u7ADaPkJpYSezXktw8CHo0x5OBbNJASGyRgEJ9dZEyHx
        07FMcpYh8alGa26/9bERvwQ=
X-Google-Smtp-Source: AGHT+IF7SHmoEZOHvo4dVs8Y9/kNCMPA9eA5VnCYGCq+QJ2vH4HqvGUAs4YCte0NDOV7NH8ZWlHLkQ==
X-Received: by 2002:a05:6a21:3e07:b0:14b:8056:1d29 with SMTP id bk7-20020a056a213e0700b0014b80561d29mr9467637pzc.30.1694432683489;
        Mon, 11 Sep 2023 04:44:43 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a10c900b00273f65fa424sm3855390pje.8.2023.09.11.04.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 04:44:43 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/9] KVM: selftests: Test Intel PMU architectural events on fixed counters
Date:   Mon, 11 Sep 2023 19:43:43 +0800
Message-Id: <20230911114347.85882-6-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911114347.85882-1-cloudliang@tencent.com>
References: <20230911114347.85882-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

Update test to cover Intel PMU architectural events on fixed counters.
Per Intel SDM, PMU users can also count architecture performance events
on fixed counters (specifically, FIXED_CTR0 for the retired instructions
and FIXED_CTR1 for cpu core cycles event). Therefore, if guest's CPUID
indicates that an architecture event is not available, the corresponding
fixed counter will also not count that event.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index f47853f3ab84..fe9f38a3557e 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -106,6 +106,28 @@ static void guest_measure_loop(uint8_t idx)
 		GUEST_ASSERT_EQ(expect, !!_rdpmc(i));
 	}
 
+	if (this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS) < 1)
+		goto done;
+
+	if (idx == INTEL_ARCH_INSTRUCTIONS_RETIRED)
+		i = 0;
+	else if (idx == INTEL_ARCH_CPU_CYCLES)
+		i = 1;
+	else if (idx == PSEUDO_ARCH_REFERENCE_CYCLES)
+		i = 2;
+	else
+		goto done;
+
+	wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
+	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(PMC_IDX_FIXED + i));
+	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+	GUEST_ASSERT_EQ(expect, !!_rdpmc(PMC_FIXED_RDPMC_BASE | i));
+
+done:
 	GUEST_DONE();
 }
 
-- 
2.39.3

