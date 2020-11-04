Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC8A2A6F95
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 22:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732088AbgKDVY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 16:24:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56210 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732051AbgKDVY2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 16:24:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604525066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/zQcAjdgkf4IEQysdzBouYOC9kTCzZOsCvFMYKIzKM=;
        b=MW2x7rrLzCeoKwFI7VkfvtPpe1QfH9k784GpLjOshieRlNTaZ+9YN7+4XiTPR1TZOkVqNr
        7hmzPcCuy5bKrZoH6Xh0XS4+dsx4kD6X47opNTFf/B5gnvyaOVNZTdV70+n6T956322YOJ
        estKmBbgRg9rmrhhSRBqj/xG6x2KuDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-B6-_4wXYNNuUEUJg--JVgw-1; Wed, 04 Nov 2020 16:24:25 -0500
X-MC-Unique: B6-_4wXYNNuUEUJg--JVgw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A26228049C3;
        Wed,  4 Nov 2020 21:24:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8F945D98F;
        Wed,  4 Nov 2020 21:24:18 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 06/11] KVM: selftests: Make the per vcpu memory size global
Date:   Wed,  4 Nov 2020 22:23:52 +0100
Message-Id: <20201104212357.171559-7-drjones@redhat.com>
In-Reply-To: <20201104212357.171559-1-drjones@redhat.com>
References: <20201104212357.171559-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename vcpu_memory_bytes to something with "percpu" in it
in order to be less ambiguous. Also make it global to
simplify things.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/demand_paging_test.c        | 36 +++++++++----------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index d1fe6c8e595b..89699652c34d 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -32,8 +32,7 @@
 
 /* Default guest test virtual memory offset */
 #define DEFAULT_GUEST_TEST_MEM		0xc0000000
-
-#define DEFAULT_GUEST_TEST_MEM_SIZE (1 << 30) /* 1G */
+#define DEFAULT_PER_VCPU_MEM_SIZE	(1 << 30) /* 1G */
 
 #ifdef PRINT_PER_PAGE_UPDATES
 #define PER_PAGE_DEBUG(...) printf(__VA_ARGS__)
@@ -72,6 +71,7 @@ static uint64_t guest_test_phys_mem;
  * Must not conflict with identity mapped test code.
  */
 static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
+static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 
 struct vcpu_args {
 	uint64_t gva;
@@ -145,7 +145,7 @@ static void *vcpu_worker(void *data)
 #define PTES_PER_4K_PT 512
 
 static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
-				uint64_t vcpu_memory_bytes)
+				uint64_t guest_percpu_mem_size)
 {
 	struct kvm_vm *vm;
 	uint64_t pages = DEFAULT_GUEST_PHY_PAGES;
@@ -160,7 +160,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
 	 * page size guest will need even less memory for page tables).
 	 */
 	pages += (2 * pages) / PTES_PER_4K_PT;
-	pages += ((2 * vcpus * vcpu_memory_bytes) >> PAGE_SHIFT_4K) /
+	pages += ((2 * vcpus * guest_percpu_mem_size) >> PAGE_SHIFT_4K) /
 		 PTES_PER_4K_PT;
 	pages = vm_adjust_num_guest_pages(mode, pages);
 
@@ -351,8 +351,7 @@ static int setup_demand_paging(struct kvm_vm *vm,
 }
 
 static void run_test(enum vm_guest_mode mode, bool use_uffd,
-		     useconds_t uffd_delay, int vcpus,
-		     uint64_t vcpu_memory_bytes)
+		     useconds_t uffd_delay, int vcpus)
 {
 	pthread_t *vcpu_threads;
 	pthread_t *uffd_handler_threads = NULL;
@@ -364,14 +363,14 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 	int vcpu_id;
 	int r;
 
-	vm = create_vm(mode, vcpus, vcpu_memory_bytes);
+	vm = create_vm(mode, vcpus, guest_percpu_mem_size);
 
 	guest_page_size = vm_get_page_size(vm);
 
-	TEST_ASSERT(vcpu_memory_bytes % guest_page_size == 0,
+	TEST_ASSERT(guest_percpu_mem_size % guest_page_size == 0,
 		    "Guest memory size is not guest page size aligned.");
 
-	guest_num_pages = (vcpus * vcpu_memory_bytes) / guest_page_size;
+	guest_num_pages = (vcpus * guest_percpu_mem_size) / guest_page_size;
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
 
 	/*
@@ -382,10 +381,10 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 		    "Requested more guest memory than address space allows.\n"
 		    "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
 		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
-		    vcpu_memory_bytes);
+		    guest_percpu_mem_size);
 
 	host_page_size = getpagesize();
-	TEST_ASSERT(vcpu_memory_bytes % host_page_size == 0,
+	TEST_ASSERT(guest_percpu_mem_size % host_page_size == 0,
 		    "Guest memory size is not host page size aligned.");
 
 	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
@@ -436,9 +435,9 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 
 		vm_vcpu_add_default(vm, vcpu_id, guest_code);
 
-		vcpu_gpa = guest_test_phys_mem + (vcpu_id * vcpu_memory_bytes);
+		vcpu_gpa = guest_test_phys_mem + (vcpu_id * guest_percpu_mem_size);
 		PER_VCPU_DEBUG("Added VCPU %d with test mem gpa [%lx, %lx)\n",
-			       vcpu_id, vcpu_gpa, vcpu_gpa + vcpu_memory_bytes);
+			       vcpu_id, vcpu_gpa, vcpu_gpa + guest_percpu_mem_size);
 
 		/* Cache the HVA pointer of the region */
 		vcpu_hva = addr_gpa2hva(vm, vcpu_gpa);
@@ -456,7 +455,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 						&uffd_handler_threads[vcpu_id],
 						pipefds[vcpu_id * 2],
 						uffd_delay, &uffd_args[vcpu_id],
-						vcpu_hva, vcpu_memory_bytes);
+						vcpu_hva, guest_percpu_mem_size);
 			if (r < 0)
 				exit(-r);
 		}
@@ -468,8 +467,8 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 		vcpu_args[vcpu_id].vm = vm;
 		vcpu_args[vcpu_id].vcpu_id = vcpu_id;
 		vcpu_args[vcpu_id].gva = guest_test_virt_mem +
-					 (vcpu_id * vcpu_memory_bytes);
-		vcpu_args[vcpu_id].pages = vcpu_memory_bytes / guest_page_size;
+					 (vcpu_id * guest_percpu_mem_size);
+		vcpu_args[vcpu_id].pages = guest_percpu_mem_size / guest_page_size;
 	}
 
 	/* Export the shared variables to the guest */
@@ -569,7 +568,6 @@ static void help(char *name)
 int main(int argc, char *argv[])
 {
 	bool mode_selected = false;
-	uint64_t vcpu_memory_bytes = DEFAULT_GUEST_TEST_MEM_SIZE;
 	int vcpus = 1;
 	unsigned int mode;
 	int opt, i;
@@ -619,7 +617,7 @@ int main(int argc, char *argv[])
 				    "A negative UFFD delay is not supported.");
 			break;
 		case 'b':
-			vcpu_memory_bytes = parse_size(optarg);
+			guest_percpu_mem_size = parse_size(optarg);
 			break;
 		case 'v':
 			vcpus = atoi(optarg);
@@ -642,7 +640,7 @@ int main(int argc, char *argv[])
 		TEST_ASSERT(guest_modes[i].supported,
 			    "Guest mode ID %d (%s) not supported.",
 			    i, vm_guest_mode_string(i));
-		run_test(i, use_uffd, uffd_delay, vcpus, vcpu_memory_bytes);
+		run_test(i, use_uffd, uffd_delay, vcpus);
 	}
 
 	return 0;
-- 
2.26.2

