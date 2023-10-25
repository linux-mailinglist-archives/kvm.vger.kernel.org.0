Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5EDE7D70E9
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344853AbjJYP1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344795AbjJYP0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:26:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55011A7
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A7rYVmvlTXbHka9B4LL2aRwu8lMZVlpT19ooAQbhZrk=;
        b=TUBpKTir3/OeG0GWZeu7SDTymIG2fpWg4m0eaX3bNMV/rY9DwFV9Xp6qc1K2UyrVuRWT+i
        jpd6mBNMxUduMYORJckNuNt99XaRC4FimsdotNjPjUK0UB95YyPJOcTd1bzJ7fUWn6uKRc
        nMnWtpF35ppu8QWPhhnplwNEojuRb5g=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-6XDaTmb4NumUkKzmNae3ag-1; Wed,
 25 Oct 2023 11:24:17 -0400
X-MC-Unique: 6XDaTmb4NumUkKzmNae3ag-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FD451C06350;
        Wed, 25 Oct 2023 15:24:17 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82E2D2166B26;
        Wed, 25 Oct 2023 15:24:16 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] KVM: selftests: Make all Hyper-V tests explicitly dependent on Hyper-V emulation support in KVM
Date:   Wed, 25 Oct 2023 17:24:00 +0200
Message-ID: <20231025152406.1879274-9-vkuznets@redhat.com>
In-Reply-To: <20231025152406.1879274-1-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for conditional Hyper-V emulation enablement in KVM, make
Hyper-V specific tests check skip gracefully instead of failing when the
support is not there.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c            | 2 ++
 tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c            | 5 +++--
 .../selftests/kvm/x86_64/hyperv_extended_hypercalls.c        | 2 ++
 tools/testing/selftests/kvm/x86_64/hyperv_features.c         | 2 ++
 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c              | 2 ++
 tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c         | 1 +
 tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c        | 2 ++
 7 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index f25749eaa6a8..f5e1e98f04f9 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -211,6 +211,8 @@ int main(void)
 	vm_vaddr_t tsc_page_gva;
 	int stage;
 
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_TIME));
+
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
 	vcpu_set_hv_cpuid(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
index 7bde0c4dfdbd..4c7257ecd2a6 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
@@ -240,11 +240,12 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 	int stage;
 
-	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_DIRECT_TLBFLUSH));
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	hcall_page = vm_vaddr_alloc_pages(vm, 1);
 	memset(addr_gva2hva(vm, hcall_page), 0x0,  getpagesize());
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
index e036db1f32b9..949e08e98f31 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
@@ -43,6 +43,8 @@ int main(void)
 	uint64_t *outval;
 	struct ucall uc;
 
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_CPUID));
+
 	/* Verify if extended hypercalls are supported */
 	if (!kvm_cpuid_has(kvm_get_supported_hv_cpuid(),
 			   HV_ENABLE_EXTENDED_HYPERCALLS)) {
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 9f28aa276c4e..387c605a3077 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -690,6 +690,8 @@ static void guest_test_hcalls_access(void)
 
 int main(void)
 {
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENFORCE_CPUID));
+
 	pr_info("Testing access to Hyper-V specific MSRs\n");
 	guest_test_msrs_access();
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
index 6feb5ddb031d..65e5f4c05068 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
@@ -248,6 +248,8 @@ int main(int argc, char *argv[])
 	int stage = 1, r;
 	struct ucall uc;
 
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_SEND_IPI));
+
 	vm = vm_create_with_one_vcpu(&vcpu[0], sender_guest_code);
 
 	/* Hypercall input/output */
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index 6c1278562090..c9b18707edc0 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -158,6 +158,7 @@ int main(int argc, char *argv[])
 	int stage;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_DIRECT_TLBFLUSH));
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
index 4758b6ef5618..c4443f71f8dd 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
@@ -590,6 +590,8 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 	int stage = 1, r, i;
 
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_TLBFLUSH));
+
 	vm = vm_create_with_one_vcpu(&vcpu[0], sender_guest_code);
 
 	/* Test data page */
-- 
2.41.0

