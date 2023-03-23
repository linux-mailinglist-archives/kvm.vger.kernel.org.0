Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C199D6C60B4
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjCWH16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjCWH1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:27:50 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224FE2B2A5;
        Thu, 23 Mar 2023 00:27:44 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u5so21513290plq.7;
        Thu, 23 Mar 2023 00:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679556463;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SbRs12vGNPK0rZyAMvZ0uDLE67A/AExXOEyuwHCIBHM=;
        b=I42wI5ZVsAIBIVoMKq5e7E5t4U3HvX6418eV1k0jWg3YAbxpOGMcGhTAH1o+eISdjs
         4GtK00d7JpFQtrGyWAtSjOSEzwu95VI9ndYgJX1flnRr+ipABvMtFkX3ZzV81j76FW9F
         WQTWlRpRLv571aaH8nkVaPSFAlo/D9eR82dAxMSqvbAYqq3pi+gPe0ZNrVSDNco2ZKWh
         vvPVBeeXzZYvi4PzQ8Gk+AY0vLvmaFC6u9OKh0uxLhv1fFBYuWPK+48PjQbg3ZQNNfFM
         Clhel+c7MrXC8/2WuYki07mupo/Brk2FnKBMBDlsbm8TwJybtSbrbytcuNSXOVUDtH+C
         9sGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679556463;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SbRs12vGNPK0rZyAMvZ0uDLE67A/AExXOEyuwHCIBHM=;
        b=7OJGMbTrU+QBtCpq3n0piHb2X7wL2OHG1NO4uDEIjMwJ4vkZI9e7KnU8HBrIaDyvjA
         ugxH8ECJMSf4sVOQ8bATUaZiaLquxHrgqLvRCxJzasYAs8SAF+LVUhJy7MM5cKy29i4D
         kmJjOrUBBalGV4DxHL3HOCIG/krQIhmOggOCjLZjmzX7diCl4X2Yq890a3EPWYR3A6IK
         IHOCes7UXJJDBDtCUce8jElOVUbUITry4P/lA6lyUW2eTuh+P4ZjApd4MCL9e4zmLQfx
         KAarKKnkp54FX2nD3ua0WmonLBb9W2oj8Q/v91AipdC+mm9+Yz3U1OYBT/JY5c94iaG0
         0xSA==
X-Gm-Message-State: AO0yUKWjMylTgoW9LDCkZM/n/KAsE35sue92sexvF9TNhl92OKpppa9F
        Qr64fvLX1N88eGGla30OKPk=
X-Google-Smtp-Source: AK7set81bB0bNMGMzmx7y/AuepQ7SYuGpKAmF11R/peJbh7nQPYjmmHLUe1wipxPsKfCvEfqQaYbSg==
X-Received: by 2002:a17:902:f691:b0:1a1:be45:9857 with SMTP id l17-20020a170902f69100b001a1be459857mr6896666plg.1.1679556463620;
        Thu, 23 Mar 2023 00:27:43 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017a032d7ae4sm11645447plg.104.2023.03.23.00.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 00:27:43 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 4/7] KVM: selftests: Test consistency of CPUID with num of Fixed counters
Date:   Thu, 23 Mar 2023 15:27:11 +0800
Message-Id: <20230323072714.82289-5-likexu@tencent.com>
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

From: Jinrong Liang <cloudliang@tencent.com>

Add test to check if non-existent counters can be accessed in guest after
determining the number of Intel generic performance counters by CPUID.
Per SDM, fixed-function performance counter 'i' is supported if ECX[i] ||
(EDX[4:0] > i). KVM doesn't emulate more counters than it can support.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
index 50902187d2c9..c934144be287 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
@@ -74,6 +74,22 @@ static uint8_t kvm_gp_ctrs_num(void)
 	return (kvm_entry->eax & GP_CTR_NUM_MASK) >> GP_CTR_NUM_OFS_BIT;
 }
 
+static uint8_t kvm_fixed_ctrs_num(void)
+{
+	const struct kvm_cpuid_entry2 *kvm_entry;
+
+	kvm_entry = get_cpuid_entry(kvm_get_supported_cpuid(), 0xa, 0);
+	return kvm_entry->edx & FIXED_CTR_NUM_MASK;
+}
+
+static uint32_t kvm_fixed_ctrs_bitmask(void)
+{
+	const struct kvm_cpuid_entry2 *kvm_entry;
+
+	kvm_entry = get_cpuid_entry(kvm_get_supported_cpuid(), 0xa, 0);
+	return kvm_entry->ecx;
+}
+
 static struct kvm_vcpu *new_vcpu(void *guest_code)
 {
 	struct kvm_vm *vm;
@@ -230,6 +246,39 @@ static void test_oob_gp_counter_setup(struct kvm_vcpu *vcpu, uint8_t eax_gp_num,
 	vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
 }
 
+static uint64_t test_oob_fixed_counter_setup(struct kvm_vcpu *vcpu,
+					     uint8_t edx_fix_num,
+					     uint32_t fixed_bitmask)
+{
+	struct kvm_cpuid_entry2 *entry;
+	uint32_t ctr_msr = MSR_CORE_PERF_FIXED_CTR0;
+	uint8_t idx = edx_fix_num;
+	bool is_supported = true;
+	uint64_t ret = 0xffffULL;
+
+	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
+	entry->ecx = fixed_bitmask;
+	entry->edx = (entry->edx & ~FIXED_CTR_NUM_MASK) | edx_fix_num;
+	vcpu_set_cpuid(vcpu);
+
+	/* Per Intel SDM, FixCtr[i]_is_supported := ECX[i] || (EDX[4:0] > i). */
+	is_supported = (entry->ecx & BIT_ULL(idx) ||
+			((entry->edx & FIXED_CTR_NUM_MASK) > idx));
+
+	/* KVM doesn't emulate more fixed counters than it can support. */
+	if (idx >= kvm_fixed_ctrs_num())
+		is_supported = false;
+
+	if (!is_supported) {
+		vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
+		ret = GP_VECTOR;
+	}
+
+	vcpu_args_set(vcpu, 4, ctr_msr, ret, idx, 1);
+
+	return ret;
+}
+
 static void intel_check_arch_event_is_unavl(uint8_t idx)
 {
 	const char *msg = "Unavailable arch event is counting.";
@@ -267,10 +316,23 @@ static void test_oob_gp_counter(uint8_t eax_gp_num, uint64_t perf_cap)
 	free_vcpu(vcpu);
 }
 
+static void intel_test_oob_fixed_ctr(uint8_t edx_fix_num, uint32_t fixed_bitmask)
+{
+	const char *msg = "At least one unsupported Fixed counter is visible.";
+	struct kvm_vcpu *vcpu;
+	uint64_t ret;
+
+	vcpu = new_vcpu(guest_wr_and_rd_msrs);
+	ret = test_oob_fixed_counter_setup(vcpu, edx_fix_num, fixed_bitmask);
+	run_vcpu(vcpu, msg, first_uc_arg_equals, (void *)ret);
+	free_vcpu(vcpu);
+}
+
 static void intel_test_counters_num(void)
 {
 	uint8_t kvm_gp_num = kvm_gp_ctrs_num();
 	unsigned int i;
+	uint32_t ecx;
 
 	TEST_REQUIRE(kvm_gp_num > 2);
 
@@ -289,6 +351,12 @@ static void intel_test_counters_num(void)
 		/* KVM doesn't emulate more counters than it can support. */
 		test_oob_gp_counter(kvm_gp_num + 1, perf_caps[i]);
 	}
+
+	for (ecx = 0; ecx <= kvm_fixed_ctrs_bitmask() + 1; ecx++) {
+		intel_test_oob_fixed_ctr(0, ecx);
+		intel_test_oob_fixed_ctr(kvm_fixed_ctrs_num(), ecx);
+		intel_test_oob_fixed_ctr(kvm_fixed_ctrs_num() + 1, ecx);
+	}
 }
 
 static void intel_test_arch_events(void)
-- 
2.40.0

