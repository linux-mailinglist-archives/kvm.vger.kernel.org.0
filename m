Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8AC79B8DC
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjIKUro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236962AbjIKLpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:45:01 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E2BCEB;
        Mon, 11 Sep 2023 04:44:55 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d2e1a72fcca58-68fbd31d9ddso684209b3a.0;
        Mon, 11 Sep 2023 04:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694432695; x=1695037495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NzwDrC9CqWEQhxyZDXLh0gjaClECbcLCwxTuofhRf/4=;
        b=n1lT+hXzfuwWbJZcURZTk9LMUlVJOhl8tmevPCtpAuP90lOGvGbkoEdx8ItWUPjX7N
         NWEjFm0Ll3Im59BJNCi9yxYNeagip6NwigL1LIpsmW+2aXOIrwJLX9/qN71yUsyB9xvJ
         oPhOZOyQLaRrICtWGYmSP6tf0PkNxbGvObJjY1xAwzIQc1zL6QEL9xthFvlK9Mgn6Vlz
         Kgm153AxqWcukq3VjA7WxVwFdSuVmNyWGzLOkOdZZwqwQeUoqs8JWp+ND73oEIHPY265
         R38+IkRyJOrPccEYo+kV5jvNbk1jPhHF4tcQz7cpGsDaLvdVz/kUMXSAmrD6HTDCYVuu
         9WWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694432695; x=1695037495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NzwDrC9CqWEQhxyZDXLh0gjaClECbcLCwxTuofhRf/4=;
        b=aDS3Om+ujQTyFUxk0+QyDkpMeWXGPSTFbrkInfNUJbl4U8W/p4iWAwjsFk9bBAPWJz
         /+dvoKCLT9goKGn3YXe24x3NWZDXtntRj/cn06fDOPyWON4WuEl9mVk1au7SdAU+r3a0
         dgNYWEb9wIFd4k+kP+t1Wo6yGkJRbafn81U/DjaZiGAR2ponIfh1t92p+ISrw5TPD5Al
         IgmISgCyzjrFoywiwqpbOr7nvJr4IJDXQLM59mheIjpAhMQ7g50FkoQH9xfO2PaXZ+1X
         gVrfmBkB18VSuy9PIPtPQfV0sOz6jWebODfuQm8Evge9D5jSmTeNJ5oRr3X2Vlat2DzA
         /5Ew==
X-Gm-Message-State: AOJu0Yw2nIDLzdYaImq2bJ26USKooAjeNAg38a5MaZBlY/WPCuKeegI7
        wg/J6JEdMdYBT2HtMzdKDaU=
X-Google-Smtp-Source: AGHT+IFEO3SPutTGNgk2zP30Ni4wwUkdB0SkDoPyGNdFSriSlc2Prx/4+CJlR+QXjap8YoXjZhLY1g==
X-Received: by 2002:a05:6a21:788f:b0:148:487e:3e6 with SMTP id bf15-20020a056a21788f00b00148487e03e6mr8624600pzc.52.1694432695122;
        Mon, 11 Sep 2023 04:44:55 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a10c900b00273f65fa424sm3855390pje.8.2023.09.11.04.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 04:44:54 -0700 (PDT)
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
Subject: [PATCH v4 9/9] KVM: selftests: Test consistency of PMU MSRs with Intel PMU version
Date:   Mon, 11 Sep 2023 19:43:47 +0800
Message-Id: <20230911114347.85882-10-cloudliang@tencent.com>
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

KVM user sapce may control the Intel guest PMU version number via
CPUID.0AH:EAX[07:00]. A test is added to check if a typical PMU register
that is not available at the current version number is leaking.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 12c00bf94683..74cb3f647e97 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -17,6 +17,12 @@
 /* Guest payload for any performance counter counting */
 #define NUM_BRANCHES		10
 
+/*
+ * KVM implements the first two non-existent counters (MSR_P6_PERFCTRx)
+ * via kvm_pr_unimpl_wrmsr() instead of #GP.
+ */
+#define MSR_INTEL_ARCH_PMU_GPCTR (MSR_IA32_PERFCTR0 + 2)
+
 static const uint64_t perf_caps[] = {
 	0,
 	PMU_CAP_FW_WRITES,
@@ -354,6 +360,59 @@ static void test_fixed_counters(void)
 			__test_fixed_counters(ecx, edx);
 }
 
+static void pmu_version_guest_code(void)
+{
+	uint8_t pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
+
+	switch (pmu_version) {
+	case 0:
+		GUEST_ASSERT_EQ(wrmsr_safe(MSR_INTEL_ARCH_PMU_GPCTR, 0xffffull),
+				GP_VECTOR);
+	case 1:
+		GUEST_ASSERT_EQ(wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, 0x1ull),
+				GP_VECTOR);
+	case 2:
+		/*
+		 * AnyThread Bit is only supported in version 3
+		 *
+		 * The strange thing is that when version=0, writing ANY-Any
+		 * Thread bit (bit 21) in MSR_P6_EVNTSEL0 and MSR_P6_EVNTSEL1
+		 * will not generate #GP. While writing ANY-Any Thread bit
+		 * (bit 21) in MSR_P6_EVNTSEL0+x (MAX_GP_CTR_NUM > x > 2) to
+		 * ANY-Any Thread bit (bit 21) will generate #GP.
+		 */
+		if (pmu_version == 0)
+			break;
+
+		GUEST_ASSERT_EQ(wrmsr_safe(MSR_P6_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ANY),
+				GP_VECTOR);
+		break;
+	default:
+		/* KVM currently supports up to pmu version 2 */
+		GUEST_DONE();
+	}
+
+	GUEST_DONE();
+}
+
+static void test_intel_pmu_version(void)
+{
+	uint8_t unsupported_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION) + 1;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint8_t version;
+
+	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS) > 2);
+
+	for (version = 0; version <= unsupported_version; version++) {
+		vm = pmu_vm_create_with_one_vcpu(&vcpu, pmu_version_guest_code);
+		vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_VERSION, version);
+		run_vcpu(vcpu);
+
+		kvm_vm_free(vm);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
@@ -366,6 +425,7 @@ int main(int argc, char *argv[])
 	test_intel_arch_events();
 	test_intel_counters_num();
 	test_fixed_counters();
+	test_intel_pmu_version();
 
 	return 0;
 }
-- 
2.39.3

