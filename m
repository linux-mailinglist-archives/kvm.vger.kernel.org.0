Return-Path: <kvm+bounces-3205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D353F801898
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:06:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E9EE281EBA
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBE353B7;
	Sat,  2 Dec 2023 00:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aKzhoMfH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BE1170E
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:05:01 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5cfe0b63eeeso47731587b3.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475501; x=1702080301; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LHL30gA5759oBkqLVOdiwNG9MowlKjvY2Plkf191Sjc=;
        b=aKzhoMfHutmUd00tVdlpbVRzOAgoTSSuMtgDX7p2aB/sMfMvG+XUOUBdGRqeTzZ9yQ
         qUNkrwjurQUAj4q79q+GkTeFY7f8a8714pw2l7w3RnF4h69kHHnkTrI9AdDjZnsFvDB6
         QGk6UvKb5ikv+r5g0CfWXQ7qwnWX76C/7BPNlAA+0Gb0Jl1UWIOmAD9Q8iJo/c9uAQup
         EgVYWwumWC2Lu7e0Hv92RK4WDRHXUQ23/ruwt0SjiKmGMCiyM2zEGI9Zf82sWXqrjwsT
         qT/260sngaeTFohtqjxTU/AbiX8Agp6FzzTyGUOyyzml8wagaLie7I6lG+1g1IRKaF2F
         vsgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475501; x=1702080301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LHL30gA5759oBkqLVOdiwNG9MowlKjvY2Plkf191Sjc=;
        b=bAng/8EV2zEhzgOd9TztKxb0eqm+KLFmFucoUsjRjNh9KewxsVCj2P1JrCgfSbitM4
         1n6UOmv07q/Weg/GslniqFyxBwtqtzmRdA0kM1cD7COayDojuqJ3J+o4PCU7FcNIlCky
         uKvnOtWCHtl91R8GpCong4iQ/cgmcNyT6aGFUkwSqF6o4u1BjojknxwQN5sQbY0q3Hbf
         QTmltp2BM0UW4SaH+J82ksmKSpIVJBSi04djtnoWsb8nvIkdyfEv2zhzl2GLOuPvChd2
         IexYHhmIg2S0j7PKIc5GMSUfY/0yxqsQutrEjg6Up5OEHnZZ5SWW3qfpcCoINbB9V2uX
         awog==
X-Gm-Message-State: AOJu0YzvsNv69H6yTbNX4tn6crJU4RO8HCGiOoXyIiVJcMv4fsYb3BU1
	iz2JMfzciKCagDIOPq5MIabdDC/A2FM=
X-Google-Smtp-Source: AGHT+IGNOIVMDFDd6sXnN06oX7tDusskXuJbQYhmBpvaaSvhC2Af7noKsZAHhVeG9PJOEHwkDYRcZld5NrE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:a01:0:b0:db4:7d21:8cea with SMTP id
 k1-20020a5b0a01000000b00db47d218ceamr763455ybq.5.1701475500865; Fri, 01 Dec
 2023 16:05:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:04:10 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-22-seanjc@google.com>
Subject: [PATCH v9 21/28] KVM: selftests: Add a helper to query if the PMU
 module param is enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Add a helper to probe KVM's "enable_pmu" param, open coding strings in
multiple places is just asking for false negatives and/or runtime errors
due to typos.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h     | 5 +++++
 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c     | 2 +-
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 2 +-
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c     | 2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 92d4f8ecc730..ee082ae58f40 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1217,6 +1217,11 @@ static inline uint8_t xsetbv_safe(uint32_t index, uint64_t value)
 
 bool kvm_is_tdp_enabled(void);
 
+static inline bool kvm_is_pmu_enabled(void)
+{
+	return get_kvm_param_bool("enable_pmu");
+}
+
 uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 				    int *level);
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 4c7133ddcda8..9e9dc4084c0d 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -545,7 +545,7 @@ static void test_intel_counters(void)
 
 int main(int argc, char *argv[])
 {
-	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
+	TEST_REQUIRE(kvm_is_pmu_enabled());
 
 	TEST_REQUIRE(host_cpu_is_intel);
 	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 7ec9fbed92e0..fa407e2ccb2f 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -867,7 +867,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu, *vcpu2 = NULL;
 	struct kvm_vm *vm;
 
-	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
+	TEST_REQUIRE(kvm_is_pmu_enabled());
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index ebbcb0a3f743..562b0152a122 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -237,7 +237,7 @@ int main(int argc, char *argv[])
 {
 	union perf_capabilities host_cap;
 
-	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
+	TEST_REQUIRE(kvm_is_pmu_enabled());
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
 	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
-- 
2.43.0.rc2.451.g8631bc7472-goog


