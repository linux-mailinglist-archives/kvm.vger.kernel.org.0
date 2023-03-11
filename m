Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DD56B5709
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjCKAsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjCKAr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:47:56 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8166913F19B
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:47:08 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id i15-20020aa78d8f000000b005edc307b103so3627018pfr.17
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9vJeMLqZfyrbvMuuFaCmaxsMrbWr7H337rmJ5xRTXIs=;
        b=Kah5uerSLv53eTxqQbYkTMm/VSfhMH/uE576qqE1uZPXCNPv3bIF5b9zRIQVfxRcqz
         dPOzQLBIvzKMXY2ToV2LkU9soOLNbMqV3qJgrhtVChM1+o0YwcQCR6NTOUOuSu20UFRr
         uPm8SleluvchU6ezjxOKruAnPyBN7+RIAjGeej0r/7a4LfGYyEiq8gNZjNQaCZr1ofdZ
         bcoVfCnrVdZJplhht6rpTfI8NCAu4i8BA9/9QuX7VzKcMNKygv9WKsqDK7GDW7JGOhb8
         6og4apy8lwRR4ibTLicAg00A6qnQWea+U1znibqiiiyxqkpo5D/NwcEy1gJqlMR3RLZF
         nDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9vJeMLqZfyrbvMuuFaCmaxsMrbWr7H337rmJ5xRTXIs=;
        b=QbL0GmmewctkosXo66u8cA5BHVTH70Gl29z/MFJuZumFVpIpa2wcbGVqJ/pWZeBLLi
         NQfNss97LLdZijVunpjjTzTmpZJJfnt0I2Ut/XFz3MGL74Q/1O5iE51919oyYSrXnN9t
         6oqoNgnQB8CMOBJoMHT0kfTf7QsV7akO10qqTIYMOoS/+68AWxu97Tx4ZyQRv19qHEPo
         AFUQ3HkYZI9Yc9EYP6/LiUNnagalw2ANxzoGs/yC0tv0qkl0zbfc1pK59t1om7Mz62kH
         skIHeCOhnFAmtsdEkfbrnzTqsILEe3VTIKSMkxGMNjuOyvK2av982ZbL8LraGSCsh2x3
         JlMg==
X-Gm-Message-State: AO0yUKVt5EMzial/4WJ0/nYUtSJVlfRJmZg4gszesxAuWVYKabmgEk/d
        7Em51Yb9Qb8nShnfyPhbo7242ZhuahE=
X-Google-Smtp-Source: AK7set/oBFTvvesOnOYo5lCSpAdPJKwAaw6kT0Z4sBlj7pCMt7OhvriPscelw4Lvol/Ta+n0BXNT2teFBKs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:dc0d:b0:235:1fb7:393c with SMTP id
 i13-20020a17090adc0d00b002351fb7393cmr1625337pjv.1.1678495608015; Fri, 10 Mar
 2023 16:46:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:46:11 -0800
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-15-seanjc@google.com>
Subject: [PATCH v3 14/21] KVM: selftests: Test all fungible features in PERF_CAPABILITIES
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
2.40.0.rc1.284.g88254d51c5-goog

