Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5AF6C60B0
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjCWH1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjCWH1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:27:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB572A6F5;
        Thu, 23 Mar 2023 00:27:42 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso2998983pjf.0;
        Thu, 23 Mar 2023 00:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679556461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GQ7Q1+dYjZORNI5EX6aTkzr9RtDccrkdusVCk0aMZNk=;
        b=EenW2HrrN7/CvriFrFeCwp3rtBQHL2uE90oV4zAxBQKJBrtQhjDmnx30UK7w4vUSop
         BETA/lDqELDAFnFiF37STmkKEzw6WBFoFMaFw8vt6Kly5Rc+6qywd9fiNYpbflyrRbsK
         t86GBiMFPsgWsqQUHcHXC32coiL+ZGEgQn0hpseLTCjj6oQi2rIzHxaPKaIU6ZvC7sQY
         aMeU/A5TkRgeArIGXEgsGX3AXSjZigLRfQw5yF35eEMUyjKx6iT+qcAM11W2cS1z3gE/
         TdzFhtUpvRKAdV0YxzmRHD2EWhTaSqFDhF5f0yvAkedy1zd83lblZa+MdZQyUCar9Q06
         3y5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679556461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GQ7Q1+dYjZORNI5EX6aTkzr9RtDccrkdusVCk0aMZNk=;
        b=pTQmw0lUAZIHSp1ZpcopFoAPANxq83/EqI+9x71oCCdY/aG0X4swGAAZTV8dsuj0DY
         KO6J4MASRCa9Bd454HEU/i2hENb6wAU8yl8DzTR7Fu1ilyNHIDZYs45vA+D0Sypz+rJC
         UEMA1UKnTJdJ9/YAl3yd9ZFa0QR6Dd6gOA9pKsR8d9QybDw4sX6ZB5eplAZ8ue8W0UFo
         6eEeGKq99xGGV2rArH2x7Eo6bjMQUU5F9rNdYeftuS3wn7AwO7TaLdeO1TdvOgIlgmQN
         dCQMYP2xO6a7/QXqfwdmeOAinJVw1ugDbef7LDryBFD4y293v6nfL7YBMjrDWECP4KaM
         nrPA==
X-Gm-Message-State: AO0yUKWSD0czfeKjIA6jhMo6dqLZpBivo7OeZ1fAfr+ALL6fInqhpAb7
        5DVAyMH6Q0v+Ojr6nwfAYmg=
X-Google-Smtp-Source: AK7set8q6fGcwEOsvlBY2CcKSsv2CrnEtg4An1vuNvqujF7i2rjQXvIDqDECg4h24Io8rSLyU+iULw==
X-Received: by 2002:a17:902:e883:b0:1a1:ee8c:eef7 with SMTP id w3-20020a170902e88300b001a1ee8ceef7mr6525093plg.48.1679556461516;
        Thu, 23 Mar 2023 00:27:41 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017a032d7ae4sm11645447plg.104.2023.03.23.00.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 00:27:41 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 3/7] KVM: selftests: Test consistency of CPUID with num of GP counters
Date:   Thu, 23 Mar 2023 15:27:10 +0800
Message-Id: <20230323072714.82289-4-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230323072714.82289-1-likexu@tencent.com>
References: <20230323072714.82289-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Add test to check if non-existent counters can be accessed in guest after
determining the number of Intel generic performance counters by CPUID.
When the num of counters is less than 3, KVM does not emulate #GP if
a counter isn't present due to compatibility MSR_P6_PERFCTRx handling.
Nor will the KVM emulate more counters than it can support.

Co-developed-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 102 ++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
index 75434aa2a0ec..50902187d2c9 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
@@ -49,11 +49,31 @@ static const uint64_t arch_events[] = {
 /* Association of Fixed Counters with Architectural Performance Events */
 static int fixed_events[] = {1, 0, 7};
 
+static const uint64_t perf_caps[] = {
+	0,
+	PMU_CAP_FW_WRITES,
+};
+
+/*
+ * KVM implements the first two non-existent counters (MSR_P6_PERFCTRx)
+ * via kvm_pr_unimpl_wrmsr() instead of #GP. It is acceptable here to test
+ * the third counter as there are usually more than 3 available gp counters.
+ */
+#define MSR_INTEL_ARCH_PMU_GPCTR (MSR_IA32_PERFCTR0 + 2)
+
 static uint64_t evt_code_for_fixed_ctr(uint8_t idx)
 {
 	return arch_events[fixed_events[idx]];
 }
 
+static uint8_t kvm_gp_ctrs_num(void)
+{
+	const struct kvm_cpuid_entry2 *kvm_entry;
+
+	kvm_entry = get_cpuid_entry(kvm_get_supported_cpuid(), 0xa, 0);
+	return (kvm_entry->eax & GP_CTR_NUM_MASK) >> GP_CTR_NUM_OFS_BIT;
+}
+
 static struct kvm_vcpu *new_vcpu(void *guest_code)
 {
 	struct kvm_vm *vm;
@@ -98,6 +118,30 @@ static bool first_uc_arg_non_zero(struct ucall *uc, void *data)
 	return uc->args[1];
 }
 
+static bool first_uc_arg_equals(struct ucall *uc, void *data)
+{
+	return uc->args[1] == (uint64_t)data;
+}
+
+static void guest_gp_handler(struct ex_regs *regs)
+{
+	GUEST_SYNC(GP_VECTOR);
+	GUEST_DONE();
+}
+
+static void guest_wr_and_rd_msrs(uint32_t base, uint64_t value,
+				 uint8_t begin, uint8_t offset)
+{
+	unsigned int i;
+
+	for (i = begin; i < begin + offset; i++) {
+		wrmsr(base + i, value);
+		GUEST_SYNC(rdmsr(base + i));
+	}
+
+	GUEST_DONE();
+}
+
 static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp_num,
 				       uint8_t max_fixed_num, bool supported,
 				       uint32_t ctr_base_msr, uint64_t evt_code)
@@ -165,6 +209,27 @@ static void test_arch_events_setup(struct kvm_vcpu *vcpu, uint8_t evt_vector,
 		      ctr_msr, arch_events[idx]);
 }
 
+static void test_oob_gp_counter_setup(struct kvm_vcpu *vcpu, uint8_t eax_gp_num,
+				      uint64_t perf_cap)
+{
+	struct kvm_cpuid_entry2 *entry;
+	uint32_t ctr_msr = MSR_IA32_PERFCTR0;
+
+	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
+	entry->eax = (entry->eax & ~GP_CTR_NUM_MASK) |
+		(eax_gp_num << GP_CTR_NUM_OFS_BIT);
+	vcpu_set_cpuid(vcpu);
+
+	if (perf_cap & PMU_CAP_FW_WRITES)
+		ctr_msr = MSR_IA32_PMC0;
+
+	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, perf_cap);
+	vcpu_args_set(vcpu, 4, ctr_msr, 0xffff,
+		      min(eax_gp_num, kvm_gp_ctrs_num()), 1);
+
+	vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
+}
+
 static void intel_check_arch_event_is_unavl(uint8_t idx)
 {
 	const char *msg = "Unavailable arch event is counting.";
@@ -190,6 +255,42 @@ static void intel_check_arch_event_is_unavl(uint8_t idx)
 	}
 }
 
+/* Access the first out-of-range counter register to trigger #GP */
+static void test_oob_gp_counter(uint8_t eax_gp_num, uint64_t perf_cap)
+{
+	const char *msg = "At least one unsupported GP counter is visible.";
+	struct kvm_vcpu *vcpu;
+
+	vcpu = new_vcpu(guest_wr_and_rd_msrs);
+	test_oob_gp_counter_setup(vcpu, eax_gp_num, perf_cap);
+	run_vcpu(vcpu, msg, first_uc_arg_equals, (void *)GP_VECTOR);
+	free_vcpu(vcpu);
+}
+
+static void intel_test_counters_num(void)
+{
+	uint8_t kvm_gp_num = kvm_gp_ctrs_num();
+	unsigned int i;
+
+	TEST_REQUIRE(kvm_gp_num > 2);
+
+	for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
+		/*
+		 * For compatibility reasons, KVM does not emulate #GP
+		 * when MSR_P6_PERFCTR[0|1] is not present, but it doesn't
+		 * affect checking the presence of MSR_IA32_PMCx with #GP.
+		 */
+		if (perf_caps[i] & PMU_CAP_FW_WRITES)
+			test_oob_gp_counter(0, perf_caps[i]);
+
+		test_oob_gp_counter(2, perf_caps[i]);
+		test_oob_gp_counter(kvm_gp_num, perf_caps[i]);
+
+		/* KVM doesn't emulate more counters than it can support. */
+		test_oob_gp_counter(kvm_gp_num + 1, perf_caps[i]);
+	}
+}
+
 static void intel_test_arch_events(void)
 {
 	uint8_t idx;
@@ -213,6 +314,7 @@ static void intel_test_arch_events(void)
 static void intel_test_pmu_cpuid(void)
 {
 	intel_test_arch_events();
+	intel_test_counters_num();
 }
 
 int main(int argc, char *argv[])
-- 
2.40.0

