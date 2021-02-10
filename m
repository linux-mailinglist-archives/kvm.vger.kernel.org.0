Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65283173F2
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbhBJXIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbhBJXH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:07:58 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBC4C0617A9
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:46 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id n62so2963515qkn.7
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zexaMXro/uaxLhK2Ywnxpp0MxR9oLew721YTh9TC4c0=;
        b=m+ofpum45E0qQzUCK9BqF/eJF8IGA80dCP1QfNiACUXUp+xm2K/dUceYkdjHQUWUp/
         rvu2UecmRFWufyqARJu6NPqBuXWXKrb+yyK3P9awLxiLd5zz5xRPa4B9kon5Sv8640+L
         Nacd9BMcN2NJOck1+bVJJdZ4FroMm2Eb/Jvc3RBFRrH934AaNCziP62PTOBfEaSwJgE0
         LCoKOV67Ja+Vv0SThQnTclLLoCyNLzm3a65DNBeOwZJVFkLwGY/5n9R7n+qbJCX/uWvO
         t0DWMeaha2V5Up5a0+uLCQICoRhwyQAWpbcvM3OAVOLbx6bsacTkv7oViI/oMC3HIBLO
         nbDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zexaMXro/uaxLhK2Ywnxpp0MxR9oLew721YTh9TC4c0=;
        b=Iqw/A4I4RXWIkxiwCBWSOyxed+jW6K4mQCCyMqfT5xujUP4wR9GJgycXpBejVATQsv
         Xdji0bORjvmp3jRXqOrZ3voEd+SEVhV8gQUAfLme1RnQ1y6z03Dug2i3QCRgCxvdWNmB
         kFFybjA3W2Y+s0qgU//Ls2Nqp+lrP2IBdnnZ9QnCLqu9QYBmSuxLAogq53AxGE5n+av4
         lBllFZnDd6ldti79QIgIKYdscDyXOi5YrZ/WyPLj4HaTC8GLmpma+9tqEYl5LKGHP0ID
         e3UKipD+ztiAhf2SEsR1MDyZxy/jbnCFodd0T4tb9kcKPzBTgvfyRukpuOBlWjzbvVcd
         yQ7w==
X-Gm-Message-State: AOAM532Xioto+0TszjxgJ0YQiOH3pV9d4sVxxJeT7Fl4TqQ40MX5UqzH
        qn7BvX7KY8Lrdc6qjU3xL7K5TtdngA0=
X-Google-Smtp-Source: ABdhPJz3HTY7ugKb2RbrHdSjZDB1e7lJMI/wQt32y7nzbR5PZ7MDBvBgIEJ6/0b33NnfIvxHLcZav9vEJD4=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a05:6214:125:: with SMTP id
 w5mr5212953qvs.20.1612998405853; Wed, 10 Feb 2021 15:06:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 15:06:16 -0800
In-Reply-To: <20210210230625.550939-1-seanjc@google.com>
Message-Id: <20210210230625.550939-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 06/15] KVM: selftests: Use shorthand local var to access
 struct perf_tests_args
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use 'pta' as a local pointer to the global perf_tests_args in order to
shorten line lengths and make the code borderline readable.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/perf_test_util.c        | 36 ++++++++++---------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index f187b86f2e14..73b0fccc28b9 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -23,7 +23,8 @@ static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
  */
 static void guest_code(uint32_t vcpu_id)
 {
-	struct perf_test_vcpu_args *vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
+	struct perf_test_args *pta = &perf_test_args;
+	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_id];
 	uint64_t gva;
 	uint64_t pages;
 	int i;
@@ -36,9 +37,9 @@ static void guest_code(uint32_t vcpu_id)
 
 	while (true) {
 		for (i = 0; i < pages; i++) {
-			uint64_t addr = gva + (i * perf_test_args.guest_page_size);
+			uint64_t addr = gva + (i * pta->guest_page_size);
 
-			if (i % perf_test_args.wr_fract == 0)
+			if (i % pta->wr_fract == 0)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
 			else
 				READ_ONCE(*(uint64_t *)addr);
@@ -52,32 +53,32 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				   uint64_t vcpu_memory_bytes,
 				   enum vm_mem_backing_src_type backing_src)
 {
+	struct perf_test_args *pta = &perf_test_args;
 	struct kvm_vm *vm;
 	uint64_t guest_num_pages;
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	perf_test_args.host_page_size = getpagesize();
+	pta->host_page_size = getpagesize();
 
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
 	 * access/dirty pages at the logging granularity.
 	 */
-	perf_test_args.guest_page_size = vm_guest_mode_params[mode].page_size;
+	pta->guest_page_size = vm_guest_mode_params[mode].page_size;
 
 	guest_num_pages = vm_adjust_num_guest_pages(mode,
-				(vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size);
+				(vcpus * vcpu_memory_bytes) / pta->guest_page_size);
 
-	TEST_ASSERT(vcpu_memory_bytes % perf_test_args.host_page_size == 0,
+	TEST_ASSERT(vcpu_memory_bytes % pta->host_page_size == 0,
 		    "Guest memory size is not host page size aligned.");
-	TEST_ASSERT(vcpu_memory_bytes % perf_test_args.guest_page_size == 0,
+	TEST_ASSERT(vcpu_memory_bytes % pta->guest_page_size == 0,
 		    "Guest memory size is not guest page size aligned.");
 
 	vm = vm_create_with_vcpus(mode, vcpus,
-				  (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size,
+				  (vcpus * vcpu_memory_bytes) / pta->guest_page_size,
 				  0, guest_code, NULL);
-
-	perf_test_args.vm = vm;
+	pta->vm = vm;
 
 	/*
 	 * If there should be more memory in the guest test region than there
@@ -90,8 +91,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 		    vcpu_memory_bytes);
 
 	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
-			      perf_test_args.guest_page_size;
-	guest_test_phys_mem &= ~(perf_test_args.host_page_size - 1);
+			      pta->guest_page_size;
+	guest_test_phys_mem &= ~(pta->host_page_size - 1);
 	if (backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
 	    backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB)
 		guest_test_phys_mem &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);
@@ -125,30 +126,31 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
 			   uint64_t vcpu_memory_bytes,
 			   bool partition_vcpu_memory_access)
 {
+	struct perf_test_args *pta = &perf_test_args;
 	vm_paddr_t vcpu_gpa;
 	struct perf_test_vcpu_args *vcpu_args;
 	int vcpu_id;
 
 	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
-		vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
+		vcpu_args = &pta->vcpu_args[vcpu_id];
 
 		vcpu_args->vcpu_id = vcpu_id;
 		if (partition_vcpu_memory_access) {
 			vcpu_args->gva = guest_test_virt_mem +
 					 (vcpu_id * vcpu_memory_bytes);
 			vcpu_args->pages = vcpu_memory_bytes /
-					   perf_test_args.guest_page_size;
+					   pta->guest_page_size;
 			vcpu_gpa = guest_test_phys_mem +
 				   (vcpu_id * vcpu_memory_bytes);
 		} else {
 			vcpu_args->gva = guest_test_virt_mem;
 			vcpu_args->pages = (vcpus * vcpu_memory_bytes) /
-					   perf_test_args.guest_page_size;
+					   pta->guest_page_size;
 			vcpu_gpa = guest_test_phys_mem;
 		}
 
 		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
 			 vcpu_id, vcpu_gpa, vcpu_gpa +
-			 (vcpu_args->pages * perf_test_args.guest_page_size));
+			 (vcpu_args->pages * pta->guest_page_size));
 	}
 }
-- 
2.30.0.478.g8a0d178c01-goog

