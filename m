Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64453173FE
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhBJXKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbhBJXJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:09:26 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B30C06121D
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:53 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id y79so2937391qka.23
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=EX0PcjeGA1FsVa28u0L0T+UtxADEQ+txdahAw79zYWo=;
        b=UKm1BEI9jXw+I1BnyzPMzQCujLZ4ITkUyafcuFrAoF4+L1abIJyW+DlGvBY401OdJo
         F0+KmFI++onCL0GKu95/izIEetzp0XAPkv1X1B01zCddyy9n3ViZtYmPPw7PEQtuASAz
         K2xCdsCegHHlS40eyHejY87TFOdRip9sSoBwyewJxmWyPhXFGA1CIMuIx0KXhDuw5J2C
         O3SSUzIZuu+gGO2rkv7LpEPINYxBsAWMthPmY1g/UbjgwZVrQoUlmF8mLSa7J77EySwg
         RcuiuLqdh0CIGaJ6DpmyptV/Xw7tILsg3MrV5NSb5sApXMxejW9HDf9HVZO+71hrrrX2
         KR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=EX0PcjeGA1FsVa28u0L0T+UtxADEQ+txdahAw79zYWo=;
        b=hZa+M8Cuar41H10vSFlYJFtFxoHgBLbAt0ixPFGmN3V5QYD5F/afOJM0iJvicr1lv1
         mBQZ4PsH/Ou8O/n9UdYa2yJWRcirjwy2+CG9s0dY1HUXKBrBfknFtlKZbD8SoPr2WE6C
         MNQQr0IMeGPAzA75nQxndLV8+D9DW/vBXRCykmPO39PIB3Pw5DCfieqauTWemJhIHWkB
         hzEoMCyBSUo/zni0xGHlByyF7/hRTVcWDaH/Z2Ddr0WJSXcoplz2G0MAxYDj+1QrwSCK
         naZyvEzFpFs7Lex9Aec+1ZHIHTHoztdNpQhWanMnyu5awuyfJ8oXLgGD0+S9mQqR0JIA
         3Crw==
X-Gm-Message-State: AOAM533JpuTf5CUUd5DZAfiUkanJ8bjtQqybM3dNHEyZF+J3dH3vDZDU
        Dkrhfj8lXXhn9ak0gxyiLm18HX5+qN0=
X-Google-Smtp-Source: ABdhPJyfpzEFpqLZmwAHBb2LIFQ+yN2kQnTf/TVIyr11JUeAkX01P+1NbnI93ejk1X9/peXZirQ6S7e5psY=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:ad4:5be9:: with SMTP id k9mr5291729qvc.18.1612998412556;
 Wed, 10 Feb 2021 15:06:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 15:06:19 -0800
In-Reply-To: <20210210230625.550939-1-seanjc@google.com>
Message-Id: <20210210230625.550939-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 09/15] KVM: selftests: Move per-VM GPA into perf_test_args
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

Move the per-VM GPA into perf_test_args instead of storing it as a
separate global variable.  It's not obvious that guest_test_phys_mem
holds a GPA, nor that it's connected/coupled with per_vcpu->gpa.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/perf_test_util.h    |  8 +-----
 .../selftests/kvm/lib/perf_test_util.c        | 28 ++++++++-----------
 .../kvm/memslot_modification_stress_test.c    |  2 +-
 3 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 4d53238b139f..cccf1c44bddb 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -29,6 +29,7 @@ struct perf_test_vcpu_args {
 struct perf_test_args {
 	struct kvm_vm *vm;
 	uint64_t host_page_size;
+	uint64_t gpa;
 	uint64_t guest_page_size;
 	int wr_fract;
 
@@ -37,13 +38,6 @@ struct perf_test_args {
 
 extern struct perf_test_args perf_test_args;
 
-/*
- * Guest physical memory offset of the testing memory slot.
- * This will be set to the topmost valid physical address minus
- * the test memory size.
- */
-extern uint64_t guest_test_phys_mem;
-
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				   uint64_t vcpu_memory_bytes,
 				   enum vm_mem_backing_src_type backing_src);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index f22ce1836547..03f125236021 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -9,8 +9,6 @@
 
 struct perf_test_args perf_test_args;
 
-uint64_t guest_test_phys_mem;
-
 /*
  * Guest virtual memory offset of the testing memory slot.
  * Must not conflict with identity mapped test code.
@@ -87,29 +85,25 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
 		    "Requested more guest memory than address space allows.\n"
 		    "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
-		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
-		    vcpu_memory_bytes);
+		    guest_num_pages, vm_get_max_gfn(vm), vcpus, vcpu_memory_bytes);
 
-	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
-			      pta->guest_page_size;
-	guest_test_phys_mem &= ~(pta->host_page_size - 1);
+	pta->gpa = (vm_get_max_gfn(vm) - guest_num_pages) * pta->guest_page_size;
+	pta->gpa &= ~(pta->host_page_size - 1);
 	if (backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
 	    backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB)
-		guest_test_phys_mem &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);
-
+		pta->gpa &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
-	guest_test_phys_mem &= ~((1 << 20) - 1);
+	pta->gpa &= ~((1 << 20) - 1);
 #endif
-	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
+	pr_info("guest physical test memory offset: 0x%lx\n", pta->gpa);
 
 	/* Add an extra memory slot for testing */
-	vm_userspace_mem_region_add(vm, backing_src, guest_test_phys_mem,
-				    PERF_TEST_MEM_SLOT_INDEX,
-				    guest_num_pages, 0);
+	vm_userspace_mem_region_add(vm, backing_src, pta->gpa,
+				    PERF_TEST_MEM_SLOT_INDEX, guest_num_pages, 0);
 
 	/* Do mapping for the demand paging memory slot */
-	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages, 0);
+	virt_map(vm, guest_test_virt_mem, pta->gpa, guest_num_pages, 0);
 
 	ucall_init(vm, NULL);
 
@@ -139,13 +133,13 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
 					 (vcpu_id * vcpu_memory_bytes);
 			vcpu_args->pages = vcpu_memory_bytes /
 					   pta->guest_page_size;
-			vcpu_args->gpa = guest_test_phys_mem +
+			vcpu_args->gpa = pta->gpa +
 					 (vcpu_id * vcpu_memory_bytes);
 		} else {
 			vcpu_args->gva = guest_test_virt_mem;
 			vcpu_args->pages = (vcpus * vcpu_memory_bytes) /
 					   pta->guest_page_size;
-			vcpu_args->gpa = guest_test_phys_mem;
+			vcpu_args->gpa = pta->gpa;
 		}
 
 		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 6096bf0a5b34..569bb1f55bdf 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -121,7 +121,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	add_remove_memslot(vm, p->memslot_modification_delay,
 			   p->nr_memslot_modifications,
-			   guest_test_phys_mem +
+			   perf_test_args.gpa +
 			   (guest_percpu_mem_size * nr_vcpus) +
 			   perf_test_args.host_page_size +
 			   perf_test_args.guest_page_size);
-- 
2.30.0.478.g8a0d178c01-goog

