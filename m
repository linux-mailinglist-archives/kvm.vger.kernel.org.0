Return-Path: <kvm+bounces-5883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FDC98287CA
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 15:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EA701F24E71
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 14:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB3D639FC7;
	Tue,  9 Jan 2024 14:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XqiXlHgk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C59839AC9
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 14:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704809488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3z7Ios2RLTqNDhiGxMSBIYzmjVKHnGKYSDng29XTGO8=;
	b=XqiXlHgkkowXd7x032FS3ygQDN5iycvZ2vv5a3sR45YyXNRaok5CGCZmNDgxC7rBOu7Gd4
	vNKpFAePmieGAYrFoTgIo+F9dwtAmJmydR3sMXtKmFAPesYSR7Y21P3+ErRjCviiAjJTAI
	y62ecPOVcC0VIfn2kHX3WlpBoZsKHZs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-5AxgFswUMSqJXA5Cfp2EuQ-1; Tue, 09 Jan 2024 09:11:27 -0500
X-MC-Unique: 5AxgFswUMSqJXA5Cfp2EuQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF588185A781;
	Tue,  9 Jan 2024 14:11:26 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.90])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C376A5012;
	Tue,  9 Jan 2024 14:11:25 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oupton@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] KVM: selftests: Run clocksource dependent tests with hyperv_clocksource_tsc_page too
Date: Tue,  9 Jan 2024 15:11:19 +0100
Message-ID: <20240109141121.1619463-4-vkuznets@redhat.com>
In-Reply-To: <20240109141121.1619463-1-vkuznets@redhat.com>
References: <20240109141121.1619463-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

KVM's 'gtod_is_based_on_tsc()' recognizes two clocksources: 'tsc' and
'hyperv_clocksource_tsc_page' and enables kvmclock in 'masterclock'
mode when either is in use. Transform 'sys_clocksource_is_tsc()' into
'sys_clocksource_is_based_on_tsc()' to support the later. This affects
two tests: kvm_clock_test and vmx_nested_tsc_scaling_test, both seem
to work well when system clocksource is 'hyperv_clocksource_tsc_page'.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h        | 2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c            | 4 +++-
 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c           | 2 +-
 .../selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c        | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 01eec72e0d3e..5bca8c947c82 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1271,6 +1271,6 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
 
-bool sys_clocksource_is_tsc(void);
+bool sys_clocksource_is_based_on_tsc(void);
 
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index b0c64667803d..70969d374e5b 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1300,13 +1300,15 @@ void kvm_selftest_arch_init(void)
 	host_cpu_is_amd = this_cpu_is_amd();
 }
 
-bool sys_clocksource_is_tsc(void)
+bool sys_clocksource_is_based_on_tsc(void)
 {
 	char *clk_name = sys_get_cur_clocksource();
 	bool ret = false;
 
 	if (!strcmp(clk_name, "tsc\n"))
 		ret = true;
+	else if (!strcmp(clk_name, "hyperv_clocksource_tsc_page\n"))
+		ret = true;
 
 	free(clk_name);
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
index 9deee8556b5c..eb1c12fb7656 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
@@ -143,7 +143,7 @@ int main(void)
 	flags = kvm_check_cap(KVM_CAP_ADJUST_CLOCK);
 	TEST_REQUIRE(flags & KVM_CLOCK_REALTIME);
 
-	TEST_REQUIRE(sys_clocksource_is_tsc());
+	TEST_REQUIRE(sys_clocksource_is_based_on_tsc());
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
index 93b0a850a240..1759fa5cb3f2 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
@@ -131,7 +131,7 @@ int main(int argc, char *argv[])
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_TSC_CONTROL));
-	TEST_REQUIRE(sys_clocksource_is_tsc());
+	TEST_REQUIRE(sys_clocksource_is_based_on_tsc());
 
 	/*
 	 * We set L1's scale factor to be a random number from 2 to 10.
-- 
2.43.0


