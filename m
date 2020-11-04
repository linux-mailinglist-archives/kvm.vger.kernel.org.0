Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FAB2A6F96
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 22:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732042AbgKDVYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 16:24:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732076AbgKDVYa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 16:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604525068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2gt6DrDqyEC5VkTJAHuZhAlw1/VxIuFRHXPaI0zIdDU=;
        b=f7d+/TFPFXBwIQP7/g6jKLEa/wPwoMaLbkQY6a1X6Qo+k/y+aaHCyqU7PjII1GLjvxlTI3
        9fu2Hl8BTQ4n+8C6A5EnYY4RI+8t8RZeEAP8UkVHtBampg13n+q0cMqo6EmewumD/sOKfn
        4jgR3EFe9+2Cy56lUR0UbqmdqcjmOaI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-9cE_77zPPEG2c9jTE7Qb8Q-1; Wed, 04 Nov 2020 16:24:27 -0500
X-MC-Unique: 9cE_77zPPEG2c9jTE7Qb8Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEE4D100F77B;
        Wed,  4 Nov 2020 21:24:25 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C3485DA33;
        Wed,  4 Nov 2020 21:24:23 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 07/11] KVM: selftests: Make the number of vcpus global
Date:   Wed,  4 Nov 2020 22:23:53 +0100
Message-Id: <20201104212357.171559-8-drjones@redhat.com>
In-Reply-To: <20201104212357.171559-1-drjones@redhat.com>
References: <20201104212357.171559-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We also check the input number of vcpus against the maximum supported.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/demand_paging_test.c        | 40 +++++++++----------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 89699652c34d..27c613f06ade 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -73,6 +73,9 @@ static uint64_t guest_test_phys_mem;
 static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
 static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 
+/* Number of VCPUs for the test */
+static int nr_vcpus = 1;
+
 struct vcpu_args {
 	uint64_t gva;
 	uint64_t pages;
@@ -351,7 +354,7 @@ static int setup_demand_paging(struct kvm_vm *vm,
 }
 
 static void run_test(enum vm_guest_mode mode, bool use_uffd,
-		     useconds_t uffd_delay, int vcpus)
+		     useconds_t uffd_delay)
 {
 	pthread_t *vcpu_threads;
 	pthread_t *uffd_handler_threads = NULL;
@@ -363,14 +366,14 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 	int vcpu_id;
 	int r;
 
-	vm = create_vm(mode, vcpus, guest_percpu_mem_size);
+	vm = create_vm(mode, nr_vcpus, guest_percpu_mem_size);
 
 	guest_page_size = vm_get_page_size(vm);
 
 	TEST_ASSERT(guest_percpu_mem_size % guest_page_size == 0,
 		    "Guest memory size is not guest page size aligned.");
 
-	guest_num_pages = (vcpus * guest_percpu_mem_size) / guest_page_size;
+	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) / guest_page_size;
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
 
 	/*
@@ -380,7 +383,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
 		    "Requested more guest memory than address space allows.\n"
 		    "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
-		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
+		    guest_num_pages, vm_get_max_gfn(vm), nr_vcpus,
 		    guest_percpu_mem_size);
 
 	host_page_size = getpagesize();
@@ -414,22 +417,22 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 		    "Failed to allocate buffer for guest data pattern");
 	memset(guest_data_prototype, 0xAB, host_page_size);
 
-	vcpu_threads = malloc(vcpus * sizeof(*vcpu_threads));
+	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
 	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
 
 	if (use_uffd) {
 		uffd_handler_threads =
-			malloc(vcpus * sizeof(*uffd_handler_threads));
+			malloc(nr_vcpus * sizeof(*uffd_handler_threads));
 		TEST_ASSERT(uffd_handler_threads, "Memory allocation failed");
 
-		uffd_args = malloc(vcpus * sizeof(*uffd_args));
+		uffd_args = malloc(nr_vcpus * sizeof(*uffd_args));
 		TEST_ASSERT(uffd_args, "Memory allocation failed");
 
-		pipefds = malloc(sizeof(int) * vcpus * 2);
+		pipefds = malloc(sizeof(int) * nr_vcpus * 2);
 		TEST_ASSERT(pipefds, "Unable to allocate memory for pipefd");
 	}
 
-	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
+	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
 		vm_paddr_t vcpu_gpa;
 		void *vcpu_hva;
 
@@ -480,7 +483,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
 
-	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
+	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
 		pthread_create(&vcpu_threads[vcpu_id], NULL, vcpu_worker,
 			       &vcpu_args[vcpu_id]);
 	}
@@ -488,7 +491,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 	pr_info("Started all vCPUs\n");
 
 	/* Wait for the vcpu threads to quit */
-	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
+	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
 		pthread_join(vcpu_threads[vcpu_id], NULL);
 		PER_VCPU_DEBUG("Joined thread for vCPU %d\n", vcpu_id);
 	}
@@ -501,7 +504,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 		char c;
 
 		/* Tell the user fault fd handler threads to quit */
-		for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
+		for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
 			r = write(pipefds[vcpu_id * 2 + 1], &c, 1);
 			TEST_ASSERT(r == 1, "Unable to write to pipefd");
 
@@ -567,8 +570,8 @@ static void help(char *name)
 
 int main(int argc, char *argv[])
 {
+	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
 	bool mode_selected = false;
-	int vcpus = 1;
 	unsigned int mode;
 	int opt, i;
 	bool use_uffd = false;
@@ -620,12 +623,9 @@ int main(int argc, char *argv[])
 			guest_percpu_mem_size = parse_size(optarg);
 			break;
 		case 'v':
-			vcpus = atoi(optarg);
-			TEST_ASSERT(vcpus > 0,
-				    "Must have a positive number of vCPUs");
-			TEST_ASSERT(vcpus <= MAX_VCPUS,
-				    "This test does not currently support\n"
-				    "more than %d vCPUs.", MAX_VCPUS);
+			nr_vcpus = atoi(optarg);
+			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
+				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
 		case 'h':
 		default:
@@ -640,7 +640,7 @@ int main(int argc, char *argv[])
 		TEST_ASSERT(guest_modes[i].supported,
 			    "Guest mode ID %d (%s) not supported.",
 			    i, vm_guest_mode_string(i));
-		run_test(i, use_uffd, uffd_delay, vcpus);
+		run_test(i, use_uffd, uffd_delay);
 	}
 
 	return 0;
-- 
2.26.2

