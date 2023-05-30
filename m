Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2CA716265
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 15:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjE3Nnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 09:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbjE3Nnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 09:43:37 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D166D100;
        Tue, 30 May 2023 06:43:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 98e67ed59e1d1-25695bb6461so1106046a91.1;
        Tue, 30 May 2023 06:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685454209; x=1688046209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NBbIGeuwqaX2zOtc4+SIBoh8l1F1qJDaap7wVCA5B+w=;
        b=rpE6/PUJLioiMlhfbubZ3zhnBkDtawXkZHdQj85ysfcHu47j+8xM6qFJBguKZnh2uy
         E84TaZEKovGYdFcHpWxXMQo6MVlYbbIHGc8jrxCaq5xvcrYSa3qeGTVMXbNX+CYSyCWw
         1y9Dz/3r3n+gttUPuZCKVMfksjailFdMlAE3npTOFhQIkWlgAxaXVRIG7KW0ka699aLY
         +iXNcPisLQSaZN+JVlaDgbfsZ3cXG13JcSp1Ym7Lq0eLHx3hjlXKdK3CwmjhT2h0i5u4
         bouzEjc3ofXfBcMh2sfzHKfIeNVrau8+McLaK3kKiqhP3Y11hbappnuyIPRFYBAauco3
         iW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685454209; x=1688046209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NBbIGeuwqaX2zOtc4+SIBoh8l1F1qJDaap7wVCA5B+w=;
        b=HLh3w0v5DbYQiOAngUX18oxN/af6kBmssr7As7lY9s5JXhGUTO54hvXI3f0ibgGOm5
         dkVf0R/wXFUWbz7nZRuMtO81WLjpdZrmuZGTd0WdWPiB+IEt82cvBWMQs1eh8IH6ZSzm
         tlALlRu3Abc33Y/ww9fkEwSi2HFM8oM+E6M4Fw57RIRBD0qLDRM3rkfGDXPztX9zbhMP
         BzEz574w4KjxG2vdZE9AJctU59tYH++HT6yL5LjAp8PKGM/KYegIiBXmj9bGixGVT7iz
         3JPL22PVTmqAkWqQk8egTPUvyyODykLnjk4PIRTyJG6cqLX6PO8NZtepR2Mhxo0SIh/z
         6BQA==
X-Gm-Message-State: AC+VfDx8MhLr0UrzfAzcUhtFDQjWEovS2tdbHay4f/lVF6aOnzVndOt1
        AMeq6BrquIThDV+4t84rL3w=
X-Google-Smtp-Source: ACHHUZ6EstOfpM606QQ2CsBqFsyzui05xSRFoPAyIEsbjvv66i3hMnkhv1mRFNzr/0CBr7j5yx9YBg==
X-Received: by 2002:a17:90b:4c06:b0:256:57e6:673b with SMTP id na6-20020a17090b4c0600b0025657e6673bmr2555239pjb.16.1685454209251;
        Tue, 30 May 2023 06:43:29 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090ac24a00b00256a4d59bfasm1977186pjx.23.2023.05.30.06.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 06:43:28 -0700 (PDT)
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
Subject: [PATCH v2 6/8] KVM: selftests: Test consistency of CPUID with num of fixed counters
Date:   Tue, 30 May 2023 21:42:46 +0800
Message-Id: <20230530134248.23998-7-cloudliang@tencent.com>
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

From: Jinrong Liang <cloudliang@tencent.com>

Add test to check if non-existent counters can be accessed in guest after
determining the number of Intel generic performance counters by CPUID.
Per SDM, fixed-function performance counter 'i' is supported if ECX[i] ||
(EDX[4:0] > i). KVM doesn't emulate more counters than it can support.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../kvm/x86_64/pmu_basic_functionality_test.c | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
index 116437ac2095..e19f8c2774c5 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -228,10 +228,46 @@ static void test_oob_gp_counter(uint8_t eax_gp_num, uint8_t offset,
 	kvm_vm_free(vm);
 }
 
+static void intel_test_oob_fixed_ctr(uint8_t edx_fix_num,
+				     uint32_t fixed_bitmask, uint64_t expected)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct kvm_cpuid_entry2 *entry;
+	uint8_t idx = edx_fix_num;
+	bool visible;
+	uint64_t msr_val;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_wr_and_rd_msrs);
+
+	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
+	entry->ecx = fixed_bitmask;
+	entry->edx = (entry->edx & ~FIXED_CTR_NUM_MASK) | edx_fix_num;
+	vcpu_set_cpuid(vcpu);
+
+	/* Per Intel SDM, FxCtr[i]_is_supported := ECX[i] || (EDX[4:0] > i). */
+	visible = (entry->ecx & BIT_ULL(idx) ||
+			((entry->edx & FIXED_CTR_NUM_MASK) > idx));
+
+	/* KVM doesn't emulate more fixed counters than it can support. */
+	if (idx >= X86_INTEL_MAX_FIXED_CTR_NUM)
+		visible = false;
+
+	vcpu_args_set(vcpu, 4, MSR_CORE_PERF_FIXED_CTR0, 0xffff, idx, 1);
+	if (!visible)
+		while (run_vcpu(vcpu, &msr_val) != UCALL_DONE)
+			TEST_ASSERT(msr_val == expected,
+				    "Unexpected when testing fixed counter num.");
+
+	kvm_vm_free(vm);
+}
+
 static void intel_test_counters_num(void)
 {
 	unsigned int i;
+	uint32_t ecx;
 	uint8_t kvm_gp_num = X86_INTEL_MAX_GP_CTR_NUM;
+	uint8_t kvm_fixed_num = X86_INTEL_MAX_FIXED_CTR_NUM;
 
 	TEST_REQUIRE(kvm_gp_num > 2);
 
@@ -254,6 +290,12 @@ static void intel_test_counters_num(void)
 		if (perf_caps[i] == 0)
 			test_oob_gp_counter(0, 2, perf_caps[i], 0);
 	}
+
+	for (ecx = 0; ecx <= X86_INTEL_FIXED_CTRS_BITMASK + 1; ecx++) {
+		intel_test_oob_fixed_ctr(0, ecx, GP_VECTOR);
+		intel_test_oob_fixed_ctr(kvm_fixed_num, ecx, GP_VECTOR);
+		intel_test_oob_fixed_ctr(kvm_fixed_num + 1, ecx, GP_VECTOR);
+	}
 }
 
 static void intel_test_pmu_cpuid(void)
-- 
2.31.1

