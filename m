Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2AE58A82C
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 10:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbiHEIiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 04:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239846AbiHEIiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 04:38:08 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9BA39C;
        Fri,  5 Aug 2022 01:38:06 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d16so2041843pll.11;
        Fri, 05 Aug 2022 01:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=zaMmNDb1jdF1qPpjyFS/Hn5r5odnYcSLudsP/nz881U=;
        b=nLXAIWLlVLjmWEC59+CIRf48VfUjZiJ6SmdZ41VrOMP5/qVJJD+jctTPGy6las7EwZ
         Xry8qJnH66U1eGbv36JBkaNeUwGnB6ug7uL/c7/DUrPL/mONaj5cj/YvxWbJzhcHLs4y
         nIJiAXrAGh5lghaiYFLHEcVw57M0+l8wRvzDPQo8+A0TZh7gqzi1Gbj1IUITTqQGUr0T
         T6b8EzhH3Q4hJf7Ns7qrkzDeNzi0p2KFSWGQvnP4Uh0saO+PI6AicXxKXZnWfynqEkta
         bikgcW+jKvnvIsvg9jeE6+8AR9OP1vSNZzKajEZmC7DW3cuhTeoYnR4tzKcr81QGSR/Z
         swwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=zaMmNDb1jdF1qPpjyFS/Hn5r5odnYcSLudsP/nz881U=;
        b=Yb92VRgLrMkFls1FQKzHnBCJxxtDJChodVFD8MYbUYbP4CnWJUsIe/IFLdwk0on/tl
         PDsFcxAsMIqt/dhT2maxS6z1mxa+fqF9YVN3Ul8rbwNZx1uMDe3/9Z1vuVS7elq/GUCR
         vkdTcVCI4qipbMSUng9TNYjpmi7O3kt5JZzAYmIfBr/5ZUA/+VZfHI9hhUJ3sXQZcYiN
         YfNaW6+/qqoVXTVHbcTBadKw6nhTHPJFfoqijMQLcs52l+JqZWo4Pw1ZnIkzjISpMWmS
         x5HO+DwbV6bcYXAMM5jqT4NcvSrHiUSkZhlc7BfIlibTNCnq4oTeWme7XNrRcMQxjyJ8
         wU2w==
X-Gm-Message-State: ACgBeo01M9jhwRQZp1GO/EGiKocm27FEfbzP8zr2xSmzi9JKrL9IaHb4
        DLsBJ+QxSvmvo7EIztmS5ww=
X-Google-Smtp-Source: AA6agR6YgfRmnb7EDBsXBiBHltUu4Sdu9ZZKKGMXsrOogJUAATG8qaa1XgZoaGAb+Bw6+B4t+XVJzA==
X-Received: by 2002:a17:90b:4b4c:b0:1f4:da77:3f80 with SMTP id mi12-20020a17090b4b4c00b001f4da773f80mr6331000pjb.55.1659688686068;
        Fri, 05 Aug 2022 01:38:06 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c126-20020a621c84000000b005289627ae6asm2347686pfc.187.2022.08.05.01.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 01:38:05 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: selftests: Test writing PERF_CAPABILITIES after KVM_RUN is rejected
Date:   Fri,  5 Aug 2022 16:37:44 +0800
Message-Id: <20220805083744.78767-3-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220805083744.78767-1-likexu@tencent.com>
References: <20220805083744.78767-1-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

KVM should also disallow changing the feature MSR PERF_CAPABILITIES after
KVM_RUN to prevent unexpected behavior. Implement run_vcpu() in a separate
thread approach and opportunistically rearrange test cases.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 49 +++++++++++++------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 928c10e520c7..0ee00fec8c2c 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -13,13 +13,13 @@
 
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <sys/ioctl.h>
+#include <pthread.h>
 
 #include "kvm_util.h"
 #include "vmx.h"
 
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
 #define PMU_CAP_LBR_FMT		0x3f
-
 union cpuid10_eax {
 	struct {
 		unsigned int version_id:8;
@@ -46,17 +46,28 @@ union perf_capabilities {
 	u64	capabilities;
 };
 
+static struct kvm_vm *vm;
+static struct kvm_vcpu *vcpu;
+
 static void guest_code(void)
 {
 	wrmsr(MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
 }
 
+static void *run_vcpu(void *ignore)
+{
+	vcpu_run(vcpu);
+
+	TEST_ASSERT(!_vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0),
+		    "Update PERF_CAPABILITIES after VCPU_RUN didn't fail.");
+
+	return NULL;
+}
+
 int main(int argc, char *argv[])
 {
+	pthread_t cpu_thread;
 	const struct kvm_cpuid_entry2 *entry_a_0;
-	struct kvm_vm *vm;
-	struct kvm_vcpu *vcpu;
-	int ret;
 	union cpuid10_eax eax;
 	union perf_capabilities host_cap;
 	uint64_t val;
@@ -65,7 +76,8 @@ int main(int argc, char *argv[])
 	host_cap.capabilities &= (PMU_CAP_FW_WRITES | PMU_CAP_LBR_FMT);
 
 	/* Create VM */
-	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vm = vm_create(1);
+	vcpu = vm_vcpu_add(vm, 1, guest_code);
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
@@ -77,33 +89,40 @@ int main(int argc, char *argv[])
 
 	/* testcase 1, set capabilities when we have PDCM bit */
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_FW_WRITES);
-
-	/* check capabilities can be retrieved with KVM_GET_MSR */
 	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
 
-	/* check whatever we write with KVM_SET_MSR is _not_ modified */
-	vcpu_run(vcpu);
-	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
-
-	/* testcase 2, check valid LBR formats are accepted */
+	/* testcase 2, check value zero (which disables all features) is accepted */
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0);
 	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), 0);
 
+	/* testcase 3, check valid LBR formats are accepted */
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.lbr_format);
 	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), (u64)host_cap.lbr_format);
 
 	/*
-	 * Testcase 3, check that an "invalid" LBR format is rejected.  Only an
+	 * Testcase 4, check that an "invalid" LBR format is rejected.  Only an
 	 * exact match of the host's format (and 0/disabled) is allowed.
 	 */
 	for (val = 1; val <= PMU_CAP_LBR_FMT; val++) {
 		if (val == host_cap.lbr_format)
 			continue;
 
-		ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val);
-		TEST_ASSERT(!ret, "Bad LBR FMT = 0x%lx didn't fail", val);
+		TEST_ASSERT(!_vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val),
+			    "Bad LBR FMT = 0x%lx didn't fail", val);
 	}
 
+	/* Testcase 5, check whatever use space writes is _not_ modified after VCPU_RUN */
+	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
+
+	pthread_create(&cpu_thread, NULL, run_vcpu, NULL);
+	pthread_join(cpu_thread, NULL);
+
+	TEST_ASSERT(!_vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0),
+		    "Update PERF_CAPABILITIES after VCPU_RUN didn't fail.");
+
+	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), host_cap.capabilities);
+
 	printf("Completed perf capability tests.\n");
 	kvm_vm_free(vm);
+	return 0;
 }
-- 
2.37.1

