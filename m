Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE27D4004
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 21:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbjJWTPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 15:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjJWTPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 15:15:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24CDA1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 12:15:41 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9a541b720aso4572099276.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 12:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698088541; x=1698693341; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l32i13KcogKJQmerzZJpCfXVsXKJyNALXo7FvnlM4Uc=;
        b=ERgrCEMBpKe68DyX3DohbCPwr3jF6VlzXxTabQIhuY/dfvAmPYbO2SMMpjxwARcJYI
         FQ7D93D5mv4TcQMFlNpvw8sAFE2ZtjjlH2BXbWkgJfz/vd2u2HxgrHeegJDLhuetE7dW
         derthwJITwauhvGq7eN2RepX/G60Yrf4FX+PeTcUeVBatVGl4By9x8aWCfOAoPzOxWXY
         L/9ueKGj42k/lFb7u2+SiR7qDzqnl41X9jkR7Sdyaia0G7hc4wiB2615lWJ8i5gmzJAY
         OF5CLeCXPx5QQMDPWJi2+BI//ZEYITsK/uqHF38JEf/QaR0f+FYcZuNvRoyoB5OHNQWI
         35Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698088541; x=1698693341;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l32i13KcogKJQmerzZJpCfXVsXKJyNALXo7FvnlM4Uc=;
        b=OuP4PXXfC4i4dyDNEmGXpgnW59hN0yZE2OVflf1sKmYio0IZ9zKpdbBxuOCQd3Em9P
         /XeRVrJVKJrSeVEgOTtiQ1O0wxTBO8cQWRL7sh6Q2rbiOfeuacyyHnCGmBoNBSPGCPnS
         DtKT8CZOP0cJ3ap3ykovpCzpqI4hs4pb5PHr9Pw1b2msqHNjtJ9WtTDyxWKogVuGWU7J
         8eR8PM/lo3ls+49UWTWZ5lOW1SvVqc6RLmumRAGUo4DQBAlxAQ6NaK0Vrh+63d30ykk8
         aL1AKwo4yBOHmA1SdMOb0+yP4iAV9xg0+sdXKhJRo9dJ1n4kcYs1RoAlQVhmt6MZKegV
         5JdA==
X-Gm-Message-State: AOJu0YzXPzvRlYrVzDGfQIHvpMpp9X4hTc4htJL1T41ZH+/HRxBShOvR
        qBHQ66cht1pRFQFUkUfOq1JiQVgo7S4=
X-Google-Smtp-Source: AGHT+IEQcCsMq3tPPe7PSzyt3r8+n1h3f3utWlxgcaG+hWrHTq9qJU45bmze9KHC5eWQQHiBs0MeF2KWKD4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad8e:0:b0:d90:e580:88e5 with SMTP id
 z14-20020a25ad8e000000b00d90e58088e5mr175588ybi.10.1698088541059; Mon, 23 Oct
 2023 12:15:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 12:15:30 -0700
In-Reply-To: <20231023191532.2405326-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231023191532.2405326-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023191532.2405326-4-seanjc@google.com>
Subject: [PATCH gmem 3/5] KVM: selftests: Let user specify nr of memslots in
 private mem conversion
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let the user specify the number of memslots in the private mem conversion
test, i.e. don't require the number of memslots to be '1' or "nr_vcpus".
Creating more memslots than vCPUs is particularly interesting, e.g. it can
result in a single KVM_SET_MEMORY_ATTRIBUTES spanning multiple memslots.

This also fixes an issue where the test will crash when running with
multiple vCPUs but only a single memslot.

To keep the math reasonable, align each vCPU's chunk to at least 2MiB (the
size is 2MiB+4KiB), and require the total size to be cleanly divisible by
the number of memslots.  The goal is to be able to validate that KVM plays
nice with multiple memslots, being able to create a truly arbitrary number
of memslots doesn't add meaningful value, i.e. isn't worth the cost.

Reported-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/private_mem_conversions_test.c | 36 +++++++++++--------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
index c3992a295b5a..3f6d8d4dbc53 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
@@ -371,8 +371,10 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 	 * Allocate enough memory so that each vCPU's chunk of memory can be
 	 * naturally aligned with respect to the size of the backing store.
 	 */
-	const size_t size = align_up(PER_CPU_DATA_SIZE, get_backing_src_pagesz(src_type));
-	const size_t memfd_size = size * nr_vcpus;
+	const size_t alignment = max_t(size_t, SZ_2M, get_backing_src_pagesz(src_type));
+	const size_t per_cpu_size = align_up(PER_CPU_DATA_SIZE, alignment);
+	const size_t memfd_size = per_cpu_size * nr_vcpus;
+	const size_t slot_size = memfd_size / nr_memslots;
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	pthread_t threads[KVM_MAX_VCPUS];
 	uint64_t gmem_flags;
@@ -384,6 +386,9 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 		.type = KVM_X86_SW_PROTECTED_VM,
 	};
 
+	TEST_ASSERT(slot_size * nr_memslots == memfd_size,
+		    "The memfd size (0x%lx) needs to be cleanly divisible by the number of memslots (%u)",
+		    memfd_size, nr_memslots);
 	vm = __vm_create_with_vcpus(shape, nr_vcpus, 0, guest_code, vcpus);
 
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));
@@ -395,16 +400,20 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 	memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
 
 	for (i = 0; i < nr_memslots; i++)
-		vm_mem_add(vm, src_type, BASE_DATA_GPA + size * i,
-			   BASE_DATA_SLOT + i, size / vm->page_size,
-			   KVM_MEM_PRIVATE, memfd, size * i);
+		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
+			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
+			   KVM_MEM_PRIVATE, memfd, slot_size * i);
 
 	for (i = 0; i < nr_vcpus; i++) {
-		uint64_t gpa =  BASE_DATA_GPA + i * size;
+		uint64_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
 
 		vcpu_args_set(vcpus[i], 1, gpa);
 
-		virt_map(vm, gpa, gpa, size / vm->page_size);
+		/*
+		 * Map only what is needed so that an out-of-bounds access
+		 * results #PF => SHUTDOWN instead of data corruption.
+		 */
+		virt_map(vm, gpa, gpa, PER_CPU_DATA_SIZE / vm->page_size);
 
 		pthread_create(&threads[i], NULL, __test_mem_conversions, vcpus[i]);
 	}
@@ -432,29 +441,28 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 static void usage(const char *cmd)
 {
 	puts("");
-	printf("usage: %s [-h] [-m] [-s mem_type] [-n nr_vcpus]\n", cmd);
+	printf("usage: %s [-h] [-m nr_memslots] [-s mem_type] [-n nr_vcpus]\n", cmd);
 	puts("");
 	backing_src_help("-s");
 	puts("");
 	puts(" -n: specify the number of vcpus (default: 1)");
 	puts("");
-	puts(" -m: use multiple memslots (default: 1)");
+	puts(" -m: specify the number of memslots (default: 1)");
 	puts("");
 }
 
 int main(int argc, char *argv[])
 {
 	enum vm_mem_backing_src_type src_type = DEFAULT_VM_MEM_SRC;
-	bool use_multiple_memslots = false;
+	uint32_t nr_memslots = 1;
 	uint32_t nr_vcpus = 1;
-	uint32_t nr_memslots;
 	int opt;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_EXIT_HYPERCALL));
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
 
-	while ((opt = getopt(argc, argv, "hms:n:")) != -1) {
+	while ((opt = getopt(argc, argv, "hm:s:n:")) != -1) {
 		switch (opt) {
 		case 's':
 			src_type = parse_backing_src_type(optarg);
@@ -463,7 +471,7 @@ int main(int argc, char *argv[])
 			nr_vcpus = atoi_positive("nr_vcpus", optarg);
 			break;
 		case 'm':
-			use_multiple_memslots = true;
+			nr_memslots = atoi_positive("nr_memslots", optarg);
 			break;
 		case 'h':
 		default:
@@ -472,8 +480,6 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	nr_memslots = use_multiple_memslots ? nr_vcpus : 1;
-
 	test_mem_conversions(src_type, nr_vcpus, nr_memslots);
 
 	return 0;
-- 
2.42.0.758.gaed0368e0e-goog

