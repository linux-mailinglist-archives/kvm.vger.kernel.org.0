Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FA76C60BA
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjCWH2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjCWH2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:28:18 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC02BDEA;
        Thu, 23 Mar 2023 00:27:55 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso2999323pjf.0;
        Thu, 23 Mar 2023 00:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679556474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpR+pmbBUcpBxRC4D9f6Nuj/vtE19mF8uVxyBNDq7rI=;
        b=gnWVaAicvw+VkBIP0gSVlRtXs+k1NsGetuuwDBzkE75aC0DcqwYEjyUuf2xs1ZrCVC
         XthvHXECOFTGlbf66P+CK3x10SKjr5P/JakLQV7MnS88L1irt17CKIGhveMFoKTxgRxc
         ghKH/m4HWJsd+Ue+bNkpkePqFyJFv16jSunC7pdmoFuLiyNAIG16yDZkuIVVj0ahPgs+
         GUqHlITSnMJyyrcfJ1p2qe1Jau0clDIGlfN2MhzqoJWcW8Br2SbzV+kNY+Snp/CSev5l
         gZ7yFet3Kwfqs02jvxUkK4RLmMC7Td4gS1fEQ246ImlZ+f5sAyvZ9nIsSeuVwxJgVsx6
         Qnyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679556474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpR+pmbBUcpBxRC4D9f6Nuj/vtE19mF8uVxyBNDq7rI=;
        b=CG/dGQF+gck8K3lk8XdhQ/M4p3NpHPtw9PTwqibga4JFDLHp9QsipSADD3EGHqy/Zo
         3oVME0vTPOiHDCyj40lFJJCCbmpAp1FwTsTl7pipmQiXYnM3ZCYEjSpgns4YuyGiqfuu
         OtSDFTQ9CVo52RNd6qu4S1Zytr31AzhLmX5xIdWNsCxQwi7uyln5BkKdtOGkSKjtk0AA
         KgVfgODAevw/nePwXAc/3lVhRMYx3hPn0nqHirLj5GO+zGVVPZOAHnCK0JMk/ihQOyaM
         LqyTbjVgcCpSqA/7ydr1tQak817SQyQzX63ZValTJUlaWHDVMLEf7r10oanbq2aRDpbq
         KxLg==
X-Gm-Message-State: AAQBX9dytpFGbDkB9Vbjg4/WKQi90HwkScLlnW4VOFLzYVytagNboBQf
        9IAigUxQSxf8N44lnWVQ5rjFqWfmKiixrWWD
X-Google-Smtp-Source: AKy350bD5E+H6UUYwuM5pIKh1o8qPdO2g3Oxc2RHmnGHXc5w5iNKMrcgiPiWvdD0kYeYt1/Qnb1Hkg==
X-Received: by 2002:a17:903:2291:b0:1a1:a727:a802 with SMTP id b17-20020a170903229100b001a1a727a802mr4803157plh.19.1679556474704;
        Thu, 23 Mar 2023 00:27:54 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017a032d7ae4sm11645447plg.104.2023.03.23.00.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 00:27:54 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 7/7] KVM: selftests: Test Intel counters' bit width emulation
Date:   Thu, 23 Mar 2023 15:27:14 +0800
Message-Id: <20230323072714.82289-8-likexu@tencent.com>
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

Add tests to cover Intel counters' bit-width emulation. When the VM has
FW_WRITES bit, the bitwidth of the gp and fixed counters will be specified
by the CPUID (no less than 32 bits and no greater than the host bitwidth)
and accessing bits that are not within the bitwidth will generate #GP.
However, when it does not have FW_WRITES bit, only the low 32-bits
signed data will be in effect and naturally #GP will not be generated.

Co-developed-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 105 ++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
index caf0d98079c7..e7465b01178a 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
@@ -29,6 +29,10 @@
 #define INTEL_PMC_IDX_FIXED 32
 #define RDPMC_FIXED_BASE BIT_ULL(30)
 #define FIXED_CTR_NUM_MASK GENMASK_ULL(4, 0)
+#define GP_WIDTH_OFS_BIT 16
+#define GP_WIDTH_MASK GENMASK_ULL(23, GP_WIDTH_OFS_BIT)
+#define FIXED_WIDTH_OFS_BIT 5
+#define FIXED_WIDTH_MASK GENMASK_ULL(12, FIXED_WIDTH_OFS_BIT)
 
 #define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) << 8)
 
@@ -62,6 +66,16 @@ static const uint64_t perf_caps[] = {
  */
 #define MSR_INTEL_ARCH_PMU_GPCTR (MSR_IA32_PERFCTR0 + 2)
 
+static const uint32_t msr_bases[] = {
+	MSR_INTEL_ARCH_PMU_GPCTR,
+	MSR_IA32_PMC0,
+	MSR_CORE_PERF_FIXED_CTR0,
+};
+
+static const uint64_t bit_widths[] = {
+	0, 1, 31, 32, 47, 48, 63, 64,
+};
+
 static uint64_t evt_code_for_fixed_ctr(uint8_t idx)
 {
 	return arch_events[fixed_events[idx]];
@@ -99,6 +113,22 @@ static uint32_t kvm_max_pmu_version(void)
 	return kvm_entry->eax & PMU_VERSION_MASK;
 }
 
+static uint32_t kvm_gp_ctr_bit_width(void)
+{
+	const struct kvm_cpuid_entry2 *kvm_entry;
+
+	kvm_entry = get_cpuid_entry(kvm_get_supported_cpuid(), 0xa, 0);
+	return (kvm_entry->eax & GP_WIDTH_MASK) >> GP_WIDTH_OFS_BIT;
+}
+
+static uint32_t kvm_fixed_ctr_bit_width(void)
+{
+	const struct kvm_cpuid_entry2 *kvm_entry;
+
+	kvm_entry = get_cpuid_entry(kvm_get_supported_cpuid(), 0xa, 0);
+	return (kvm_entry->edx & FIXED_WIDTH_MASK) >> FIXED_WIDTH_OFS_BIT;
+}
+
 static struct kvm_vcpu *new_vcpu(void *guest_code)
 {
 	struct kvm_vm *vm;
@@ -381,6 +411,50 @@ static void test_pmu_version_setup(struct kvm_vcpu *vcpu, uint8_t version)
 	vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
 }
 
+static uint64_t test_ctrs_bit_width_setup(struct kvm_vcpu *vcpu,
+					  uint8_t bit_width,
+					  uint64_t perf_cap,
+					  uint32_t msr_base)
+{
+	struct kvm_cpuid_entry2 *entry;
+	bool fw_wr = perf_cap & PMU_CAP_FW_WRITES;
+	uint64_t kvm_width;
+	uint64_t value;
+
+	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
+	if (msr_base != MSR_CORE_PERF_FIXED_CTR0) {
+		kvm_width = kvm_gp_ctr_bit_width();
+		entry->eax = (entry->eax & ~GP_WIDTH_MASK) |
+			(bit_width << GP_WIDTH_OFS_BIT);
+	} else {
+		kvm_width = kvm_fixed_ctr_bit_width();
+		entry->edx = (entry->edx & ~FIXED_WIDTH_MASK) |
+			(bit_width << FIXED_WIDTH_OFS_BIT);
+	}
+	TEST_REQUIRE(kvm_width > 31);
+
+	vcpu_set_cpuid(vcpu);
+	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	/* No less than 32 bits and no greater than the host bitwidth */
+	bit_width = fw_wr ? max_t(int, 32, bit_width) : 32;
+	bit_width = min_t(int, bit_width, kvm_width);
+
+	/* Unconditionally set signed bit 31 for the case w/o FW_WRITES */
+	value = BIT_ULL(bit_width) | 0x1234567ull | BIT_ULL(31);
+	vcpu_args_set(vcpu, 4, msr_base, value, 1, 1);
+
+	if (fw_wr && msr_base != MSR_INTEL_ARCH_PMU_GPCTR) {
+		vm_install_exception_handler(vcpu->vm, GP_VECTOR,
+					     guest_gp_handler);
+		return GP_VECTOR;
+	} else if (msr_base == MSR_INTEL_ARCH_PMU_GPCTR) {
+		value = (s32)(value & (BIT_ULL(32) - 1));
+	}
+
+	return value & (BIT_ULL(bit_width) - 1);
+}
+
 static void intel_check_arch_event_is_unavl(uint8_t idx)
 {
 	const char *msg = "Unavailable arch event is counting.";
@@ -497,12 +571,43 @@ static void intel_test_pmu_version(void)
 	}
 }
 
+static void vcpu_run_bit_width(uint8_t bit_width, uint64_t perf_cap,
+			       uint32_t msr_base)
+{
+	const char *msg = "Fail to emulate counters' bit width.";
+	struct kvm_vcpu *vcpu;
+	uint64_t ret;
+
+	vcpu = new_vcpu(guest_wr_and_rd_msrs);
+	ret = test_ctrs_bit_width_setup(vcpu, bit_width, perf_cap, msr_base);
+	run_vcpu(vcpu, msg, first_uc_arg_equals, (void *)ret);
+	free_vcpu(vcpu);
+}
+
+static void intel_test_counters_bit_width(void)
+{
+	uint8_t i, j, k;
+
+	for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
+		for (j = 0; j < ARRAY_SIZE(msr_bases); j++) {
+			if (!(perf_caps[i] & PMU_CAP_FW_WRITES) &&
+			    msr_bases[j] == MSR_IA32_PMC0)
+				continue;
+
+			for (k = 0; k < ARRAY_SIZE(bit_widths); k++)
+				vcpu_run_bit_width(bit_widths[k], perf_caps[i],
+						   msr_bases[j]);
+		}
+	}
+}
+
 static void intel_test_pmu_cpuid(void)
 {
 	intel_test_arch_events();
 	intel_test_counters_num();
 	intel_test_fixed_counters();
 	intel_test_pmu_version();
+	intel_test_counters_bit_width();
 }
 
 int main(int argc, char *argv[])
-- 
2.40.0

