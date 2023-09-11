Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAD279B662
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbjIKUts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236960AbjIKLo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:44:57 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A48CEB;
        Mon, 11 Sep 2023 04:44:52 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d2e1a72fcca58-68fb46f38f9so1009477b3a.1;
        Mon, 11 Sep 2023 04:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694432692; x=1695037492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gIQJdLO3gLPWqKi62UuRePcDFvtFEiNK+o3+FM0nU1M=;
        b=WcXb/JBzhTLUra6jnQNkBBizqQPtKpLpWguKjWGZ+LGiEz6mr5F6jUW3sGVOQsI7RT
         jrvH9LfopgfsHVVSQsbIvm/YbA8nDm4Uxen3ii4vZiug1mcw4ewHFloDgZUPFqFypta2
         6kPxkXTovmkskydNcIguqL+qGb840IC5z1TeCMaWYhkMoSl9bripCUsu9HR+o5pJTqNI
         Z3JpDv9JNHufIyI9lc5jKltySzYp1fn/+bUs0zyRpWH1plFenOZwF/YfMa9SdWaMzSBs
         5kmFT53gWCh4XdNINihvfDi8GRzA6HWlg0JgUcorUboKTONnjrEgai6Q2kqp7Ubtph1k
         DUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694432692; x=1695037492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gIQJdLO3gLPWqKi62UuRePcDFvtFEiNK+o3+FM0nU1M=;
        b=LK5KUoHwJspiuDV6sRdZ592S0SeXpy5JBzBvreR/BN3YgcF1yTfptluwg70HWC09qU
         ayPHmFjUMrlW448LvuHxfidOgArrE9ASXtDVs6wv8tuftdv1mrfI3SZev86Bij08tLxY
         GurOlJFmsR/klXRBE8vy48AeUj+NUwYnGcc+t8wxShUkWJUXgWfzvAxklEIlkHvi9IS/
         psHXMJQ139xHsoy8iMlD6QlYwiUT/LpJDkWwWb+wxifLsdrZC2JXK5jKjcfg+v32XWbL
         6kUfQn2tsn11DCNvUPdk/Puy8dufnm4JBA0FIcigPNmzMvIacCFLRRZxvfWQ03FdUC5Q
         JRsA==
X-Gm-Message-State: AOJu0YwNnVQMH4kzcskiQcgmEWOezZLTtqSSWJcCLURsmDwmUKW0GSTm
        2S3Yt+bv8PTFM94sGT4E+KctlxlTsdlX0FIF
X-Google-Smtp-Source: AGHT+IHUzfCZ/PYSru8y4IpQ7/3NYLEOF9NFJGxS+Qg394BWRZza4VVExpM5AB91FiiXwv9yn9Jbbw==
X-Received: by 2002:a05:6a20:1613:b0:157:54fd:5c26 with SMTP id l19-20020a056a20161300b0015754fd5c26mr362736pzj.38.1694432692204;
        Mon, 11 Sep 2023 04:44:52 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a10c900b00273f65fa424sm3855390pje.8.2023.09.11.04.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 04:44:51 -0700 (PDT)
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
Subject: [PATCH v4 8/9] KVM: selftests: Test Intel supported fixed counters bit mask
Date:   Mon, 11 Sep 2023 19:43:46 +0800
Message-Id: <20230911114347.85882-9-cloudliang@tencent.com>
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

Add a test to check that fixed counters enabled via guest
CPUID.0xA.ECX (instead of EDX[04:00]) work as normal as usual.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index df76f0f2bfd0..12c00bf94683 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -301,6 +301,59 @@ static void test_intel_counters_num(void)
 	test_oob_fixed_ctr(nr_fixed_counters + 1);
 }
 
+static void fixed_counters_guest_code(void)
+{
+	uint64_t supported_bitmask = this_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK);
+	uint32_t nr_fixed_counter = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+	uint64_t msr_val;
+	unsigned int i;
+	bool expected;
+
+	for (i = 0; i < nr_fixed_counter; i++) {
+		expected = supported_bitmask & BIT_ULL(i) || i < nr_fixed_counter;
+
+		wrmsr_safe(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
+		wrmsr_safe(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
+		wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(PMC_IDX_FIXED + i));
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+		wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+		rdmsr_safe(MSR_CORE_PERF_FIXED_CTR0 + i, &msr_val);
+
+		GUEST_ASSERT_EQ(expected, !!msr_val);
+	}
+
+	GUEST_DONE();
+}
+
+static void __test_fixed_counters(uint32_t fixed_bitmask, uint8_t edx_fixed_num)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, fixed_counters_guest_code);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK,
+				fixed_bitmask);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_FIXED_COUNTERS,
+				edx_fixed_num);
+
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+static void test_fixed_counters(void)
+{
+	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+	uint32_t ecx;
+	uint8_t edx;
+
+	for (edx = 0; edx <= nr_fixed_counters; edx++)
+		/* KVM doesn't emulate more fixed counters than it can support. */
+		for (ecx = 0; ecx <= (BIT_ULL(nr_fixed_counters) - 1); ecx++)
+			__test_fixed_counters(ecx, edx);
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
@@ -312,6 +365,7 @@ int main(int argc, char *argv[])
 
 	test_intel_arch_events();
 	test_intel_counters_num();
+	test_fixed_counters();
 
 	return 0;
 }
-- 
2.39.3

