Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDD871626A
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 15:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbjE3NoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 09:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbjE3Nnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 09:43:45 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DF6E46;
        Tue, 30 May 2023 06:43:33 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso3916690a12.1;
        Tue, 30 May 2023 06:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685454213; x=1688046213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gLa7v6gFNZM6dRrePNVbzNlkSvTG1vI9uSrCOIdfOvQ=;
        b=WhetJZLW4T19KOS/zzGuc6xKQ3sHo/No2hotvqavrSVcHPP58K1kaMmPWnk9+A9Hda
         gms/a/amvw1uPflnqMQHCMhwB3O2GU7EkQN8As8OWTV8+hRU/SAQLGHt3JVdRMpW7XDn
         uz/y2pfEOt81Xxnmxrx59rOhRJzSr0bVMT0oVzm/vdKQu6qKs03VD0XJpcA71+tFAJHi
         zSbqZJT9zsyBVxnpeZFt0cJcRqCBgBGEnQZp2XILtFn3fo+ORZB8yf5QG2SlLyRkIE79
         jytTJz0z2Cqs0kwm48tAO1AF0UGAtyOt6+vFgcChegKYWs0bm0yQPQv5ktAubmKSikzA
         RP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685454213; x=1688046213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gLa7v6gFNZM6dRrePNVbzNlkSvTG1vI9uSrCOIdfOvQ=;
        b=Vckosa+OkIbLLpzFk7ayoCMpXP9qkqrA5mlANxqD4mYJ9cT6p17OyL4erky659vNHg
         NrQjzXELIjCdht1bOXEYm6n2sxhoQQfgoCfIZ7i3unALsU3G3UgF9PmKvpmnv8pyD30i
         F4KJKNW5t2nOwcB6GHMHBDAD8DJSLYewgc+CJYjo+v8LenLWe37+mrMhkzz8rbA7piaR
         7IRp9wGsGshI7WyCdtbaYToUjtGJWyyQaEz1bod42oDRRSYY9g0VUWrChVvblejhrMlh
         LWedOxM2Tx5ZgjSKZRQuJdAkIMP9b8rxLbRSu7iAkEymoCIpZ7lp/sKlb8uxUUTiT2dZ
         LD5w==
X-Gm-Message-State: AC+VfDyryN/T+bk17/7lnO1KZS9rV0Ioze8A2iB8XYzAYiVJOb0FYDeN
        aMOQ3t1OVZ2lbYNOhMNGd0E=
X-Google-Smtp-Source: ACHHUZ5T+QRwqwCzSD3mljOSbM5r5aiBxPuxVWJzJjYl8JbVrI2HLeq+0YzuVOG5qnntQL6qMSS8RA==
X-Received: by 2002:a17:90b:3b8e:b0:256:51e6:3ac2 with SMTP id pc14-20020a17090b3b8e00b0025651e63ac2mr2549906pjb.12.1685454212908;
        Tue, 30 May 2023 06:43:32 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090ac24a00b00256a4d59bfasm1977186pjx.23.2023.05.30.06.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 06:43:32 -0700 (PDT)
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
Subject: [PATCH v2 7/8] KVM: selftests: Test Intel supported fixed counters bit mask
Date:   Tue, 30 May 2023 21:42:47 +0800
Message-Id: <20230530134248.23998-8-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530134248.23998-1-cloudliang@tencent.com>
References: <20230530134248.23998-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Add a test to check that fixed counters enabled via guest
CPUID.0xA.ECX (instead of EDX[04:00]) work as normal as usual.

Co-developed-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 .../kvm/x86_64/pmu_basic_functionality_test.c | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
index e19f8c2774c5..108cfe254095 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -298,10 +298,81 @@ static void intel_test_counters_num(void)
 	}
 }
 
+static void intel_guest_run_fixed_counters(uint64_t supported_bitmask,
+					   uint8_t max_fixed_num)
+{
+	unsigned int i;
+	uint64_t msr_val;
+
+	for (i = 0; i < max_fixed_num; i++) {
+		if (!(supported_bitmask & BIT_ULL(i)))
+			continue;
+
+		if (wrmsr_safe(MSR_CORE_PERF_FIXED_CTR0 + i, 0) == GP_VECTOR)
+			GUEST_SYNC(GP_VECTOR);
+
+		wrmsr_safe(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
+		wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(INTEL_PMC_IDX_FIXED + i));
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+		wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+		rdmsr_safe(MSR_CORE_PERF_FIXED_CTR0 + i, &msr_val);
+
+		GUEST_SYNC(msr_val);
+	}
+
+	GUEST_DONE();
+}
+
+static void test_fixed_counters_setup(struct kvm_vcpu *vcpu, uint8_t edx_fix_num,
+				      uint32_t fixed_bitmask, bool expected)
+{
+	struct kvm_cpuid_entry2 *entry;
+	uint8_t max_fixed_num = X86_INTEL_MAX_FIXED_CTR_NUM;
+	uint64_t supported_bitmask = 0;
+	uint64_t msr_val;
+	unsigned int i;
+
+	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
+	entry->ecx = fixed_bitmask;
+	entry->edx = (entry->edx & ~FIXED_CTR_NUM_MASK) | edx_fix_num;
+	vcpu_set_cpuid(vcpu);
+
+	for (i = 0; i < max_fixed_num; i++) {
+		if (entry->ecx & BIT_ULL(i) ||
+		    ((entry->edx & FIXED_CTR_NUM_MASK) > i))
+			supported_bitmask |= BIT_ULL(i);
+	}
+
+	vcpu_args_set(vcpu, 2, supported_bitmask, max_fixed_num);
+
+	while (run_vcpu(vcpu, &msr_val) != UCALL_DONE)
+		TEST_ASSERT(!!msr_val == expected,
+			    "Unexpected when testing fixed counter.");
+}
+
+static void intel_test_fixed_counters(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	uint32_t ecx;
+	uint8_t edx, num = X86_INTEL_MAX_FIXED_CTR_NUM;
+
+	for (edx = 0; edx <= num; edx++) {
+		/* KVM doesn't emulate more fixed counters than it can support. */
+		for (ecx = 0; ecx <= (BIT_ULL(num) - 1); ecx++) {
+			vm = pmu_vm_create_with_one_vcpu(&vcpu,
+							 intel_guest_run_fixed_counters);
+			test_fixed_counters_setup(vcpu, edx, ecx, true);
+			kvm_vm_free(vm);
+		}
+	}
+}
+
 static void intel_test_pmu_cpuid(void)
 {
 	intel_test_arch_events();
 	intel_test_counters_num();
+	intel_test_fixed_counters();
 }
 
 int main(int argc, char *argv[])
-- 
2.31.1

