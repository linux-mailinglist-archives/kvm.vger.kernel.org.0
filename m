Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCB371626E
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 15:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjE3NoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 09:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbjE3Nn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 09:43:57 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2B2E60;
        Tue, 30 May 2023 06:43:36 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 41be03b00d2f7-52cbd7d0c37so2802679a12.3;
        Tue, 30 May 2023 06:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685454216; x=1688046216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=exIXNtJMaAOiUqTB9dbgkYvlgfORS1/be4FuI+e0E5A=;
        b=cGXivQe0v4wc6+Qopz1n62+79epmXh3BCfYpqC0WcQUU36cLkdzyxgtr+A8Z4E98Uy
         GuT3/biMQAR+rePXKu3geM1yZ/8Vmam8PB5xrtgItQ8wqeFJYpgRiL1BksJxn5mq37WE
         mpBUMzyus/yJ64t2qzbFhY8dS2RDcxq+jpYJDeTHjdCWJgdaFF7p9OVTccmfW4SrdIIK
         dcExmsIQcsSXGpMgErQ+cj5QYN9Y9VJkq7UmDk+ZyDOEyZndxN0txVOUmNhPLyyGWElG
         en68yjOwQpvyFksAynrU4er4efOIjIAzKPpa4fGzSDgFW9Iztj7E+DnRtZCgKY8/A9dS
         OFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685454216; x=1688046216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=exIXNtJMaAOiUqTB9dbgkYvlgfORS1/be4FuI+e0E5A=;
        b=XEntuL1lZ4jYsuFoVGnkDJygpGjzNGLGE9kyadEaXceKOivqK6X904TyqukgAds+IZ
         vtyyBY4ixZWFh3Bz/cz8dvq9Vp0jCGFqWY7HQv1oT2kYLeJ20T/PuFurbwBGF/3oD2B+
         /LV9le6jTRbvhIcl3momV2/6PWVHbepKfTIc2NDEYRcWbOpYMEyQphdpbGHRwBUKpTBl
         wJIjdkAwhlxq5iL1d1Hm/ZKIAW1aLFwOXMtp7gdaBq5SgPdRAZNFFI8RK0jiql8/k0Jj
         F1mt2VyE32ycwDTOxxKsyWKfgCXuGTTkiDiJFtMrLNwwg+HpdXvA9CYDJUAkJdQweO/6
         l/rg==
X-Gm-Message-State: AC+VfDzCgZdX0FubkmXF27Iw/BfOI+YeA7u5YLbg2MM6w0RpIkvplKVJ
        VMKdZFIKIEH+u5HyDsdxCuRiCrgSUi0zb4EV
X-Google-Smtp-Source: ACHHUZ5KmfpNIkyis/uYiSdVMHN7UoOVmpJKLjpTnqeTb7D9OsRC0/fxG4upuxyzP6YTtvVjfDrE5w==
X-Received: by 2002:a17:90b:1a85:b0:256:38d8:13c5 with SMTP id ng5-20020a17090b1a8500b0025638d813c5mr2744818pjb.2.1685454216074;
        Tue, 30 May 2023 06:43:36 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090ac24a00b00256a4d59bfasm1977186pjx.23.2023.05.30.06.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 06:43:35 -0700 (PDT)
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
Subject: [PATCH v2 8/8] KVM: selftests: Test consistency of PMU MSRs with Intel PMU version
Date:   Tue, 30 May 2023 21:42:48 +0800
Message-Id: <20230530134248.23998-9-cloudliang@tencent.com>
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

KVM user sapce may control the Intel guest PMU version number via
CPUID.0AH:EAX[07:00]. A test is added to check if a typical PMU register
that is not available at the current version number is leaking.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../kvm/x86_64/pmu_basic_functionality_test.c | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
index 108cfe254095..7da3eaf9ab5a 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -368,11 +368,75 @@ static void intel_test_fixed_counters(void)
 	}
 }
 
+static void intel_guest_check_pmu_version(uint8_t version)
+{
+	switch (version) {
+	case 0:
+		GUEST_SYNC(wrmsr_safe(MSR_INTEL_ARCH_PMU_GPCTR, 0xffffull));
+	case 1:
+		GUEST_SYNC(wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, 0x1ull));
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
+		if (version == 0)
+			break;
+
+		GUEST_SYNC(wrmsr_safe(MSR_P6_EVNTSEL0, EVENTSEL_ANY));
+		break;
+	default:
+		/* KVM currently supports up to pmu version 2 */
+		GUEST_SYNC(GP_VECTOR);
+	}
+
+	GUEST_DONE();
+}
+
+static void test_pmu_version_setup(struct kvm_vcpu *vcpu, uint8_t version,
+				   uint64_t expected)
+{
+	struct kvm_cpuid_entry2 *entry;
+	uint64_t msr_val;
+
+	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
+	entry->eax = (entry->eax & ~PMU_VERSION_MASK) | version;
+	vcpu_set_cpuid(vcpu);
+
+	vcpu_args_set(vcpu, 1, version);
+	while (run_vcpu(vcpu, &msr_val) != UCALL_DONE) {
+		TEST_ASSERT(msr_val == expected,
+			    "Something beyond this PMU version is leaked.");
+	}
+}
+
+static void intel_test_pmu_version(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	uint8_t version, unsupported_version = X86_INTEL_PMU_VERSION + 1;
+
+	TEST_REQUIRE(X86_INTEL_MAX_FIXED_CTR_NUM > 2);
+
+	for (version = 0; version <= unsupported_version; version++) {
+		vm = pmu_vm_create_with_one_vcpu(&vcpu,
+						 intel_guest_check_pmu_version);
+		test_pmu_version_setup(vcpu, version, GP_VECTOR);
+		kvm_vm_free(vm);
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
2.31.1

