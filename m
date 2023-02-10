Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5877D691594
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjBJAdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjBJAc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:32:56 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2014E55E64
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:32:23 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id f19-20020a631013000000b004e8c27fa528so1749409pgl.17
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l7cJrzLZ8eAvu1dfgk3wdtw3/0KBtZxBV1s4qDZiZW0=;
        b=UHNNfqkDjSKVJdelnrCH+Ts0wZPROnz5hQmCtIskOZaoDuIeDGReWBlhjSmjHn386d
         As37kllaRCJpQwmTp+JiTHu0h75RCOEzBhNhkxMvOLLL+JARY52FQ5o7pvUuFzeag/Id
         DlrpIIEbKR8uW9YDcVqwyueK0O1OA5H9x2EM1Si1M9tLIcuBqHA8COd9SSqsh3CGg9LJ
         NJB6EZ7I2JfuIK+KVCbRkuWDOanOk7qFrk0l53wpoerKIlhtkwkK4CcNCVntPecs++Og
         mo4hQxcILy0wuU5tqOxJibz+KkqA4ORjnNlbNZaJrYSX0wJslvYDvSVPNPPpPTUgPyU4
         C5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l7cJrzLZ8eAvu1dfgk3wdtw3/0KBtZxBV1s4qDZiZW0=;
        b=mWtS4qczMOB4y4KAlT1Tj0Mi2OZWBEYR+TPidk50tT50i4GXBYZ/ez6RRxX3pwrwCy
         eQi1LfB0togiZfNnfi5ccnxG9eDkN1ehz1hCm2rcyepNbjHN5dqDPRYhcFy6E9O9KLfO
         iqjbPdg8bB1ZSx5vuJIs6FaSGcelGmHAeYpVXhSlG6A7dXqczDp5jQQMkcKu7cAV4UEh
         /EcaELiF2YwtlN/qVfqV+IO7odsnMy6MlItILuX0mQ4kwayewYiDrOeACYDgiwafhLuL
         2WpWi91FD4WtSz/wIlwuhF2QZKm4tQ1GiOzl/afqfz9XgTI5edwyI7yPH1G2oMyTMoA6
         MZsQ==
X-Gm-Message-State: AO0yUKVo0dEXlNwB866rxsppe5/CECKrzaat/V+4V5JMi1l1OSv5lvU5
        MEDDcZ6cJ9ehtDv+8oqLFq39WzW0cqo=
X-Google-Smtp-Source: AK7set+WJwcD0AyAgypiX1zXC1KcJ3PEH8D7Vw/FC/FYsizyfIgwIaP+henyVIjJIHjVlgD4qrw3nDAKu9M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:1a8c:0:b0:592:557f:9f65 with SMTP id
 a134-20020a621a8c000000b00592557f9f65mr2914611pfa.8.1675989134617; Thu, 09
 Feb 2023 16:32:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:41 +0000
In-Reply-To: <20230210003148.2646712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-15-seanjc@google.com>
Subject: [PATCH v2 14/21] KVM: selftests: Test all fungible features in PERF_CAPABILITIES
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that userspace can set all fungible features in PERF_CAPABILITIES.
Drop the now unused #define of the "full-width writes" flag.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 29 +++++++++++++++----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index f7a27b5c949b..2647282ff380 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -14,10 +14,11 @@
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <sys/ioctl.h>
 
+#include <linux/bitmap.h>
+
 #include "kvm_util.h"
 #include "vmx.h"
 
-#define PMU_CAP_FW_WRITES	(1ULL << 13)
 #define PMU_CAP_LBR_FMT		0x3f
 
 union perf_capabilities {
@@ -36,6 +37,18 @@ union perf_capabilities {
 	u64	capabilities;
 };
 
+/*
+ * The LBR format and most PEBS features are immutable, all other features are
+ * fungible (if supported by the host and KVM).
+ */
+static const union perf_capabilities immutable_caps = {
+	.lbr_format = -1,
+	.pebs_trap  = 1,
+	.pebs_arch_reg = 1,
+	.pebs_format = -1,
+	.pebs_baseline = 1,
+};
+
 static void guest_code(void)
 {
 	wrmsr(MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
@@ -58,15 +71,22 @@ static void test_basic_perf_capabilities(union perf_capabilities host_cap)
 
 static void test_fungible_perf_capabilities(union perf_capabilities host_cap)
 {
+	const uint64_t fungible_caps = host_cap.capabilities & ~immutable_caps.capabilities;
+
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	int bit;
 
-	/* testcase 1, set capabilities when we have PDCM bit */
-	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_FW_WRITES);
+	for_each_set_bit(bit, &fungible_caps, 64) {
+		vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, BIT_ULL(bit));
+		vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES,
+			     host_cap.capabilities & ~BIT_ULL(bit));
+	}
+	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
 
 	/* check whatever we write with KVM_SET_MSR is _not_ modified */
 	vcpu_run(vcpu);
-	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
+	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), host_cap.capabilities);
 
 	kvm_vm_free(vm);
 }
@@ -102,7 +122,6 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
 
 	host_cap.capabilities = kvm_get_feature_msr(MSR_IA32_PERF_CAPABILITIES);
-	host_cap.capabilities &= (PMU_CAP_FW_WRITES | PMU_CAP_LBR_FMT);
 
 	TEST_ASSERT(host_cap.full_width_write,
 		    "Full-width writes should always be supported");
-- 
2.39.1.581.gbfd45094c4-goog

