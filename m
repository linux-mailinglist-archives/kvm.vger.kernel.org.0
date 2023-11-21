Return-Path: <kvm+bounces-2184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC907F2C3D
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 12:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C9071C2176E
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 11:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF9F4A9B6;
	Tue, 21 Nov 2023 11:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBczypLP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1B5123;
	Tue, 21 Nov 2023 03:55:51 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id d9443c01a7336-1cf62a3b249so13031055ad.0;
        Tue, 21 Nov 2023 03:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700567751; x=1701172551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FModTmbvq/rIeTJqrbp/ejTbdstDXjo4HWlV+9PgZ9k=;
        b=dBczypLPi+Zope3SmHlN4gkvy2+cQWTwMjwijI8vsKWrDHybX3QB5Y0lWS1zzKUtkB
         d3mlnXUFhEAm9Hf8BvBo7Ynh42LNJhNId2xqFzrTdV6QdUh2ahn3DvSXZzO7/YzDWdhE
         O37YGAo8rvMEvhgsaMtpGlQRxyWzT/gYBAyQmUwtWjA/hJZ2aELMfQm7sxRZIexh5Tlt
         /pEqcFtUncb1PDSa1ewymlDhStMhQ3cGm6a3hdhfeuq1g77gM0VItD+2Fc3bA/Y97Ix+
         Yrauqjv/pUn+FABYV0BwV1Fc8YRXm1A9ZuP2P+c09flaNtFKEtpm0nBkoz2PsJO9STRf
         zOEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700567751; x=1701172551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FModTmbvq/rIeTJqrbp/ejTbdstDXjo4HWlV+9PgZ9k=;
        b=Av5eec2cC4m4rt2Zb3OpXmckclYSbn8/zsLgaEs+TUlPekOxQD5irIzjMke8dpdfYC
         K0TFtYbsxGOSZ1LadDulWOLrH4bFJj/WjSYPcQlTfo6B46zGrZ6AROTc+Ihdesa8WGNn
         kXmITmJUpuqDai4JuOhmzBXQAh9leDgXY10Kxp0vQO8NFeZDz+7wAniskbSb5UImRq+E
         3sUAQG+HdrwkPpCTIbCSN4xh1NO7ifr1x6P95oDrEddZnyDxy6hZcka4h6NbR13Mcent
         fZ+aTgxW/yHnDEbIbdELFn0rCmRISgtG30HdiAY5SPbMUyvUjfouy5HSWSeutB+y0GNH
         S49A==
X-Gm-Message-State: AOJu0Yy3yoTCFt7Mhh8tGouL7AsPnWW9n1Wi6ekt7SEl4VuRWC9979Wg
	nbFMXq+mH5YNa55I0IePN4Vkh0el+VGmCfZHyc0=
X-Google-Smtp-Source: AGHT+IENILlMREfBj1e1iMvLSwt8Z6C4mae28rX8qBuCPqtn4P/zKbl8L9tnlLR5FwQ5k+MmEw/Ohw==
X-Received: by 2002:a17:902:e5cd:b0:1cf:51c5:d427 with SMTP id u13-20020a170902e5cd00b001cf51c5d427mr9118844plf.65.1700567750712;
        Tue, 21 Nov 2023 03:55:50 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g10-20020a170902740a00b001cc1dff5b86sm7685431pll.244.2023.11.21.03.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 03:55:50 -0800 (PST)
From: Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Like Xu <likexu@tencent.com>,
	Jim Mattson <jmattson@google.com>,
	Aaron Lewis <aaronlewis@google.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Jinrong Liang <ljr.kernel@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] KVM: selftests: Test consistency of PMU MSRs with AMD PMU version
Date: Tue, 21 Nov 2023 19:54:55 +0800
Message-Id: <20231121115457.76269-8-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231121115457.76269-1-cloudliang@tencent.com>
References: <20231121115457.76269-1-cloudliang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinrong Liang <cloudliang@tencent.com>

Add AMD test case to check that KVM accurately accesses the MSRs
supported by the AMD PMU version.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index b1502a446a55..07cb9694e225 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -819,6 +819,50 @@ static void test_amd_counters_num(void)
 	}
 }
 
+static void guest_test_amd_pmu_version(void)
+{
+	bool expect_gp = !this_cpu_has(X86_FEATURE_PERFMON_V2);
+	uint8_t vector;
+	uint64_t val;
+
+	guest_wr_rd_amd_counters(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
+				 expect_gp, 0);
+	guest_wr_rd_amd_counters(MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
+				 expect_gp, 0);
+
+	/*
+	 * Attempt to write to MSR_AMD64_PERF_CNTR_GLOBAL_STATUS register, which
+	 * will trigger a #GP exception. Because MSR_AMD64_PERF_CNTR_GLOBAL_STATUS
+	 * is read-only.
+	 */
+	vector = wrmsr_safe(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, 0);
+	GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
+				    true, vector);
+
+	vector = rdmsr_safe(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, &val);
+	GUEST_ASSERT_PMC_MSR_ACCESS(RDMSR, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
+				    expect_gp, vector);
+
+	GUEST_DONE();
+}
+
+static void test_amd_pmu_version(void)
+{
+	bool kvm_pmu_is_perfmonv2 = kvm_cpu_has(X86_FEATURE_PERFMON_V2);
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	unsigned int i;
+
+	for (i = 0; i <= kvm_pmu_is_perfmonv2; i++) {
+		vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_amd_pmu_version);
+
+		vcpu_set_or_clear_cpuid_feature(vcpu, X86_FEATURE_PERFMON_V2, i);
+
+		run_vcpu(vcpu);
+		kvm_vm_free(vm);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_is_pmu_enabled());
@@ -836,6 +880,7 @@ int main(int argc, char *argv[])
 	} else if (host_cpu_is_amd) {
 		test_amd_zen_events();
 		test_amd_counters_num();
+		test_amd_pmu_version();
 	} else {
 		TEST_FAIL("Unknown CPU vendor");
 	}
-- 
2.39.3


