Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E24F6C60B8
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjCWH2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjCWH2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:28:06 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130BE2A9A0;
        Thu, 23 Mar 2023 00:27:50 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso2999185pjf.0;
        Thu, 23 Mar 2023 00:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679556470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PaVBTRG8cSbZezD1tCmSqI5sDhrh3YVPGLoSBE21PFI=;
        b=JGFiy5fEqJhG69JHsen3RTM5SkCRpbEunoTL9OuMMVl6FblnyX3zpCUnfsZmpdEKW9
         xatsH+iQGoH9EbHMcdszJDdT0N5W8NGE9N6LOnOCpeWqbO6S5l3y4IpTox/ceKiz9iUZ
         8+rz0C1/WUMkgxh+QYOZoHjPMFxN6iFb7NH8KDJnh6y+3P8WOoL2JNSMUp484nINfnlX
         viFuM6ShEy+pTphrMi9GLKOrFKy94g1I9ofU+RXZoW/VY9x3Y2w7TnsGPp9mI1CRHqHy
         w3SddKtnP0YQGRY01mEB7n0hpb3J/VgIuizrw8WV6t3FToXC6tIwhQG8GkUQGvah5Dns
         pCjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679556470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PaVBTRG8cSbZezD1tCmSqI5sDhrh3YVPGLoSBE21PFI=;
        b=KVU7NeI+PDMluvr9vNPDdPiT4RhWbsnL/ocfgX2RH6iPCR9352C3JW9WNED2V3J3IS
         tFQf8lePl2CLTlhBmKbPEaf1bvusAnvR0QxnLvojU331YFxiudMoZ8nUSNGtj54Tmr2U
         SruLtWuL16/QVRacArf76Uss73+fPWo1qOD/AoN4sSwFHPdfzHrlKRmqaEnXEhDaL6N4
         s7hmU9snxTY/9okYtU0TPmtLqqc2GStLXxv4EjtnhUWfnsmIoI/v9mPAN0DriqwbKHAi
         VOoHdPtGc6Zh/ge9rcfI6WC0GQdemdBPM8HZVEegUIp6wAbBgTVP75x3wJvQPKbBiC0n
         jopg==
X-Gm-Message-State: AO0yUKUK3XwQE2+1CpQc+AeFW+zSyylOhcA8vWJIeBgG2aSwg1OHHSnY
        86kvfM9zCKJpfzxXfu7AXqg=
X-Google-Smtp-Source: AK7set+e8mOkZED81SLcsDT//0D2Ox0a3o/MoRixIJ/OEekNMd4BMbgJmIpG3s9axJrzMg9Tt1/ANg==
X-Received: by 2002:a17:902:d4c6:b0:1a1:e33f:d567 with SMTP id o6-20020a170902d4c600b001a1e33fd567mr6684192plg.52.1679556470516;
        Thu, 23 Mar 2023 00:27:50 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017a032d7ae4sm11645447plg.104.2023.03.23.00.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 00:27:50 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 6/7] KVM: selftests: Test consistency of PMU MSRs with Intel PMU version
Date:   Thu, 23 Mar 2023 15:27:13 +0800
Message-Id: <20230323072714.82289-7-likexu@tencent.com>
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

KVM user sapce may control the Intel guest PMU version number via
CPUID.0AH:EAX[07:00]. A test is added to check if a typical PMU register
that is not available at the current version number is leaking.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
index 79f2e144c6c6..caf0d98079c7 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
@@ -17,6 +17,7 @@
 #define NUM_BRANCHES 10
 
 #define EVENTSEL_OS BIT_ULL(17)
+#define EVENTSEL_ANY BIT_ULL(21)
 #define EVENTSEL_EN BIT_ULL(22)
 #define PMU_CAP_FW_WRITES BIT_ULL(13)
 #define EVENTS_MASK GENMASK_ULL(7, 0)
@@ -90,6 +91,14 @@ static uint32_t kvm_fixed_ctrs_bitmask(void)
 	return kvm_entry->ecx;
 }
 
+static uint32_t kvm_max_pmu_version(void)
+{
+	const struct kvm_cpuid_entry2 *kvm_entry;
+
+	kvm_entry = get_cpuid_entry(kvm_get_supported_cpuid(), 0xa, 0);
+	return kvm_entry->eax & PMU_VERSION_MASK;
+}
+
 static struct kvm_vcpu *new_vcpu(void *guest_code)
 {
 	struct kvm_vm *vm;
@@ -220,6 +229,25 @@ static void intel_guest_run_fixed_counters(uint64_t supported_bitmask,
 	GUEST_DONE();
 }
 
+static void intel_guest_check_pmu_version(uint8_t version)
+{
+	switch (version) {
+	case 0:
+		wrmsr(MSR_INTEL_ARCH_PMU_GPCTR, 0xffffull);
+	case 1:
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0x1ull);
+	case 2:
+		/* AnyThread Bit is only supported in version 3 */
+		wrmsr(MSR_P6_EVNTSEL0, EVENTSEL_ANY);
+		break;
+	default:
+		/* KVM currently supports up to pmu version 2 */
+		GUEST_SYNC(GP_VECTOR);
+	}
+
+	GUEST_DONE();
+}
+
 static void test_arch_events_setup(struct kvm_vcpu *vcpu, uint8_t evt_vector,
 				   uint8_t unavl_mask, uint8_t idx)
 {
@@ -341,6 +369,18 @@ static void intel_test_fixed_counters(void)
 	}
 }
 
+static void test_pmu_version_setup(struct kvm_vcpu *vcpu, uint8_t version)
+{
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
+	entry->eax = (entry->eax & ~PMU_VERSION_MASK) | version;
+	vcpu_set_cpuid(vcpu);
+
+	vcpu_args_set(vcpu, 1, version);
+	vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
+}
+
 static void intel_check_arch_event_is_unavl(uint8_t idx)
 {
 	const char *msg = "Unavailable arch event is counting.";
@@ -441,11 +481,28 @@ static void intel_test_arch_events(void)
 	}
 }
 
+static void intel_test_pmu_version(void)
+{
+	const char *msg = "Something beyond this PMU version is leaked.";
+	uint8_t version, unsupported_version = kvm_max_pmu_version() + 1;
+	struct kvm_vcpu *vcpu;
+
+	TEST_REQUIRE(kvm_gp_ctrs_num() > 2);
+
+	for (version = 0; version <= unsupported_version; version++) {
+		vcpu = new_vcpu(intel_guest_check_pmu_version);
+		test_pmu_version_setup(vcpu, version);
+		run_vcpu(vcpu, msg, first_uc_arg_equals, (void *)GP_VECTOR);
+		free_vcpu(vcpu);
+	}
+}
+
 static void intel_test_pmu_cpuid(void)
 {
 	intel_test_arch_events();
 	intel_test_counters_num();
 	intel_test_fixed_counters();
+	intel_test_pmu_version();
 }
 
 int main(int argc, char *argv[])
-- 
2.40.0

