Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6282260A210
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiJXLil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiJXLhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:37:55 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C2A67048;
        Mon, 24 Oct 2022 04:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611465; x=1698147465;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E0BMcyV5C3nvC2wXZ/MmiAw+7vmFX/E/IWaLJ0N1vZg=;
  b=aU7daYoWeQYawRd1J5WKd+xG4qhd2jXD6p785+ppy4AYuP6NB08qPnVf
   Wk+4IWAf79hSzMZz7FWjZucm92yWHdcF9KRvLumJX7cZXXPptsfkaj+SM
   am2HBb9uZoO3b1Gh5478bUvWpX7adYxrn5yGeEN7YY8LCEdJknd7QqHFT
   fN99x8uGxsSof9TFovmYjjGX5Sx4ATPXnLg+lVwEfq7UztffpPrOGeHZM
   KL1EvE+2HmB+jocrdhTS7kfV0rwJLnOvy570fnC1SOJrSq6FcvigdPpVr
   HNy7DaeUaBb+u8UVDG8GW85OfREa/PPuwc6DwOeGx4PVCrNhKJd/L8iBH
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462448"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462448"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773784995"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773784995"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:15 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 11/18] KVM: selftest/xapic_ipi_test: vcpu related code consolidation
Date:   Mon, 24 Oct 2022 19:34:38 +0800
Message-Id: <20221024113445.1022147-12-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221024113445.1022147-1-wei.w.wang@intel.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the unnecessary definition of the theads[] array, and change
thread_params to be the vcpu's private data. Use the helper function
to create the threads.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 .../selftests/kvm/x86_64/xapic_ipi_test.c     | 54 +++++++++----------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index 3d272d7f961e..cc2630429067 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -22,7 +22,6 @@
 
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <getopt.h>
-#include <pthread.h>
 #include <inttypes.h>
 #include <string.h>
 #include <time.h>
@@ -76,7 +75,6 @@ struct test_data_page {
 
 struct thread_params {
 	struct test_data_page *data;
-	struct kvm_vcpu *vcpu;
 	uint64_t *pipis_rcvd; /* host address of ipis_rcvd global */
 };
 
@@ -193,8 +191,9 @@ static void sender_guest_code(struct test_data_page *data)
 
 static void *vcpu_thread(void *arg)
 {
-	struct thread_params *params = (struct thread_params *)arg;
-	struct kvm_vcpu *vcpu = params->vcpu;
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)arg;
+	struct thread_params *params =
+		(struct thread_params *)vcpu->private_data;
 	struct ucall uc;
 	int old;
 	int r;
@@ -233,17 +232,17 @@ static void *vcpu_thread(void *arg)
 	return NULL;
 }
 
-static void cancel_join_vcpu_thread(pthread_t thread, struct kvm_vcpu *vcpu)
+static void cancel_join_vcpu_thread(struct kvm_vcpu *vcpu)
 {
 	void *retval;
 	int r;
 
-	r = pthread_cancel(thread);
+	r = pthread_cancel(vcpu->thread);
 	TEST_ASSERT(r == 0,
 		    "pthread_cancel on vcpu_id=%d failed with errno=%d",
 		    vcpu->id, r);
 
-	r = pthread_join(thread, &retval);
+	r = pthread_join(vcpu->thread, &retval);
 	TEST_ASSERT(r == 0,
 		    "pthread_join on vcpu_id=%d failed with errno=%d",
 		    vcpu->id, r);
@@ -393,17 +392,16 @@ void get_cmdline_args(int argc, char *argv[], int *run_secs,
 
 int main(int argc, char *argv[])
 {
-	int r;
-	int wait_secs;
+	int i, wait_secs;
 	const int max_halter_wait = 10;
 	int run_secs = 0;
 	int delay_usecs = 0;
 	struct test_data_page *data;
 	vm_vaddr_t test_data_page_vaddr;
 	bool migrate = false;
-	pthread_t threads[2];
-	struct thread_params params[2];
+	struct thread_params *params;
 	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
 	uint64_t *pipis_rcvd;
 
 	get_cmdline_args(argc, argv, &run_secs, &migrate, &delay_usecs);
@@ -412,33 +410,31 @@ int main(int argc, char *argv[])
 	if (delay_usecs <= 0)
 		delay_usecs = DEFAULT_DELAY_USECS;
 
-	vm = vm_create_with_one_vcpu(&params[0].vcpu, halter_guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, halter_guest_code);
 
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(params[0].vcpu);
+	vcpu_init_descriptor_tables(vcpu);
 	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
 
-	params[1].vcpu = vm_vcpu_add(vm, 1, sender_guest_code);
+	vcpu = vm_vcpu_add(vm, 1, sender_guest_code);
+	vm_vcpu_threads_private_data_alloc(vm, sizeof(struct thread_params));
 
 	test_data_page_vaddr = vm_vaddr_alloc_page(vm);
 	data = addr_gva2hva(vm, test_data_page_vaddr);
 	memset(data, 0, sizeof(*data));
-	params[0].data = data;
-	params[1].data = data;
-
-	vcpu_args_set(params[0].vcpu, 1, test_data_page_vaddr);
-	vcpu_args_set(params[1].vcpu, 1, test_data_page_vaddr);
-
 	pipis_rcvd = (uint64_t *)addr_gva2hva(vm, (uint64_t)&ipis_rcvd);
-	params[0].pipis_rcvd = pipis_rcvd;
-	params[1].pipis_rcvd = pipis_rcvd;
+
+	vm_iterate_over_vcpus(vm, vcpu, i) {
+		params = (struct thread_params *)vcpu->private_data;
+		params->data = data;
+		params->pipis_rcvd = pipis_rcvd;
+		vcpu_args_set(vcpu, 1, test_data_page_vaddr);
+	}
 
 	/* Start halter vCPU thread and wait for it to execute first HLT. */
-	r = pthread_create(&threads[0], NULL, vcpu_thread, &params[0]);
-	TEST_ASSERT(r == 0,
-		    "pthread_create halter failed errno=%d", errno);
+	vcpu_thread_create(vm->vcpus[0], vcpu_thread, 0);
 	fprintf(stderr, "Halter vCPU thread started\n");
 
 	wait_secs = 0;
@@ -455,9 +451,7 @@ int main(int argc, char *argv[])
 		"Halter vCPU thread reported its APIC ID: %u after %d seconds.\n",
 		data->halter_apic_id, wait_secs);
 
-	r = pthread_create(&threads[1], NULL, vcpu_thread, &params[1]);
-	TEST_ASSERT(r == 0, "pthread_create sender failed errno=%d", errno);
-
+	vcpu_thread_create(vm->vcpus[1], vcpu_thread, 0);
 	fprintf(stderr,
 		"IPI sender vCPU thread started. Letting vCPUs run for %d seconds.\n",
 		run_secs);
@@ -470,8 +464,8 @@ int main(int argc, char *argv[])
 	/*
 	 * Cancel threads and wait for them to stop.
 	 */
-	cancel_join_vcpu_thread(threads[0], params[0].vcpu);
-	cancel_join_vcpu_thread(threads[1], params[1].vcpu);
+	cancel_join_vcpu_thread(vm->vcpus[0]);
+	cancel_join_vcpu_thread(vm->vcpus[1]);
 
 	fprintf(stderr,
 		"Test successful after running for %d seconds.\n"
-- 
2.27.0

