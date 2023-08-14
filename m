Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C02577B7D3
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 13:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbjHNLwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 07:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjHNLvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 07:51:45 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B482EA;
        Mon, 14 Aug 2023 04:51:44 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d2e1a72fcca58-6874d1c8610so2626888b3a.0;
        Mon, 14 Aug 2023 04:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013904; x=1692618704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ytuuOxw54VYORwOpx8ggpahMngdV8+dWvhoVEndQ8GY=;
        b=A34XgtRpNzMJjlY8SRN9i3HaXizQ6Ylqk5W/Fm+EZSIM4Dyn1SH36ou8ADRzQ84Z6c
         uFI4RvyQ10qkPjMkAok679CPu4t8gScYKOoy5EktHxMrD3Gm6/Lgq832bkcW0PbPMyFd
         HBuhRwVF1etCbxbG4wn0Xu1b9paEIOlAI6z6qsNROGw75pIu7K/iuUOny2sPXuLzqCVh
         2l6yd6KOJC7LGd9yhpI5LN1uHPvYaciPhCIytcli6po+zUvsCc2HAg/Oc+o+FqHa9x+p
         8QZ86hgZpIh2x56R31U4FIcpK05qtOez8EV0M7FKuGGnvGWLKeCqNkWjRkV2ZHnnVyoy
         7/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013904; x=1692618704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ytuuOxw54VYORwOpx8ggpahMngdV8+dWvhoVEndQ8GY=;
        b=URjbWAQJ2JvxvVmvK23w336OSrl+W3JtfnH3JQ+JeGGW29jmmyybIr29epP9iBcecZ
         7vo02mo6uZhfL2jjwPaabeeBLxN+fDbXqEbsZ6CS2P23ahjSCkzbwslx/91YTT2pofeZ
         UxesxWP7bp6w2kghGzJd0KuYzPi4actZY9mFr63+xQz49ukM4BGgZh0RGir/3mXtckTe
         Hyuac7auRllVI+FStsstAlxs8Fq8EveBPitPpDTqLdyybbY8C+vzjp3UzoTmMQ1z7br/
         tABiR5eC0zsC4UmmjD8BoGDsq87AOJBUMx8fpjZoCLYuKPARFocR4vWTrXai+JMWNn9N
         vmCA==
X-Gm-Message-State: AOJu0YyY4mnhFSRG5nubEHoE7at9xs/eEGSeHe/WEJUq3O8yUWVtq3o/
        erlKkE6vSslryBnseRn8niw=
X-Google-Smtp-Source: AGHT+IHNkoOPgqMtbwLHAeN+iXn+o8Rd9gTlbv5k3D/2B5wF9pey6LBmaEcPHS7jVHOkf+4TojhoqQ==
X-Received: by 2002:a05:6a20:3d95:b0:137:bc72:9c08 with SMTP id s21-20020a056a203d9500b00137bc729c08mr8718771pzi.16.1692013903883;
        Mon, 14 Aug 2023 04:51:43 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x7-20020a63b207000000b0055386b1415dsm8407848pge.51.2023.08.14.04.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 04:51:43 -0700 (PDT)
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
Subject: [PATCH v3 07/11] KVM: selftests: Test Intel supported fixed counters bit mask
Date:   Mon, 14 Aug 2023 19:51:04 +0800
Message-Id: <20230814115108.45741-8-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814115108.45741-1-cloudliang@tencent.com>
References: <20230814115108.45741-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
 .../kvm/x86_64/pmu_basic_functionality_test.c | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
index db1c1230700a..3bbf3bd2846b 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -282,6 +282,65 @@ static void intel_test_counters_num(void)
 	}
 }
 
+static void intel_guest_run_fixed_counters(void)
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
+		wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(INTEL_PMC_IDX_FIXED + i));
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+		wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+		rdmsr_safe(MSR_CORE_PERF_FIXED_CTR0 + i, &msr_val);
+
+		GUEST_ASSERT(expected == !!msr_val);
+	}
+
+	GUEST_DONE();
+}
+
+static void test_fixed_counters_setup(struct kvm_vcpu *vcpu,
+				      uint32_t fixed_bitmask,
+				      uint8_t edx_fixed_num)
+{
+	int ret;
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK,
+				fixed_bitmask);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_FIXED_COUNTERS,
+				edx_fixed_num);
+
+	do {
+		ret = run_vcpu(vcpu, NULL);
+	} while (ret != UCALL_DONE);
+}
+
+static void intel_test_fixed_counters(void)
+{
+	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint32_t ecx;
+	uint8_t edx;
+
+	for (edx = 0; edx <= nr_fixed_counters; edx++) {
+		/* KVM doesn't emulate more fixed counters than it can support. */
+		for (ecx = 0; ecx <= (BIT_ULL(nr_fixed_counters) - 1); ecx++) {
+			vm = pmu_vm_create_with_one_vcpu(&vcpu,
+							 intel_guest_run_fixed_counters);
+			test_fixed_counters_setup(vcpu, ecx, edx);
+			kvm_vm_free(vm);
+		}
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
@@ -293,6 +352,7 @@ int main(int argc, char *argv[])
 
 	intel_test_arch_events();
 	intel_test_counters_num();
+	intel_test_fixed_counters();
 
 	return 0;
 }
-- 
2.39.3

