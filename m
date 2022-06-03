Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27E053C25E
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbiFCA5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240640AbiFCAt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:49:27 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2843237F6
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:04 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id h10-20020a170902f54a00b00166449db7f8so1562275plf.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1bl+lfBCivKh3stXZwAa+/Pwegy1T+bX0bAJQr8vw/8=;
        b=ZSSdTOuNPJdfN/ES4kW4YgJHhdnNjcQxG3zeTWkpq1CTmZhRhITnIYKhsmm/tzFeWI
         xBN0wIpH4XiSaIYgeA2MbeMebE09vNDDD4S+sXqGhhpIVmwn2RzDBZPbgU+f0Uwy76A9
         07eHeMNa6Tk9XSKZqB/mNvWYEKAw0yLFwHikaLw3EqSX1QyuPi+obDMOMPpfpQbnIqyw
         unLwPbo9zmKnFf8tbdpkzT0tN5Y4wBWuYY5aeKzyLggf+/yYDAJGIuiWDYSSh6y5cOv6
         IOAlmDVB5tQxooWzro4Cb+XG0CNxCNVV6Wu9TOMygfFIaZA9bZhLjdjpBZKUdW44Q0xy
         CZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1bl+lfBCivKh3stXZwAa+/Pwegy1T+bX0bAJQr8vw/8=;
        b=b04242avAkkRsm5ZQyjF6/A7VW6BHjOpK/nOldmVVLqP3sH0byTaqfGSSIyhiZfybv
         cNvFvfQkItXN4tpxM0cx/w5Vnjke9VMAEafA9RYCXWntWja88GJRaiFdGwAbWBlA6GIC
         sCLbLy6Jw7WW28zuDwi4KmrJewoDtEr/Zc6RFTxHg3Ey3kwbO71c5tbYBd/eIYHDix1c
         0AKRwrZhvU6S1KezFHK7nYtEdjovvhAyqYN2r8G2oFHBKXYS16GNDi/r0r/sux/Uai0m
         rQVr1C+zgyA8pOZic0zczT715i/B/cWKwm/4zge+dIIz6lPen6BSciBtG7pSV1RRqHDI
         IgKw==
X-Gm-Message-State: AOAM533gfH1Ysx9Ktwg4CZE63qa+Fm3SGVAW+YAQLT4WSw2c2YaQxXZb
        TMpHBgNwe6tbI/LkNHIjXMisY8vgdco=
X-Google-Smtp-Source: ABdhPJzJkP4XHZ+JfLUu46ZO03Y9nDPXMxobVMBA0BBFB8s7XBmPuEwqnza3BckSUGaI8O/dmio10U0yPfg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:c10:0:b0:3da:fb56:648d with SMTP id
 b16-20020a630c10000000b003dafb56648dmr6547789pgl.590.1654217223718; Thu, 02
 Jun 2022 17:47:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:02 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-116-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 115/144] KVM: selftests: Convert xapic_ipi_test away from *_VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert vm_create_with_one_vcpu to use vm_create_with_vcpus() and pass
around 'struct kvm_vcpu' objects instead of passing around vCPU IDs.
Don't bother with macros for the HALTER versus SENDER indices, the vast
majority of references don't differentiate between the vCPU roles, and
the code that does either has a comment or an explicit reference to the
role, e.g. to halter_guest_code() or sender_guest_code().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xapic_ipi_test.c     | 48 ++++++++-----------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index 8b366652be31..4484ee563b18 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -39,9 +39,6 @@
 /* Default delay between migrate_pages calls (microseconds) */
 #define DEFAULT_DELAY_USECS 500000
 
-#define HALTER_VCPU_ID 0
-#define SENDER_VCPU_ID 1
-
 /*
  * Vector for IPI from sender vCPU to halting vCPU.
  * Value is arbitrary and was chosen for the alternating bit pattern. Any
@@ -79,8 +76,7 @@ struct test_data_page {
 
 struct thread_params {
 	struct test_data_page *data;
-	struct kvm_vm *vm;
-	uint32_t vcpu_id;
+	struct kvm_vcpu *vcpu;
 	uint64_t *pipis_rcvd; /* host address of ipis_rcvd global */
 };
 
@@ -198,6 +194,7 @@ static void sender_guest_code(struct test_data_page *data)
 static void *vcpu_thread(void *arg)
 {
 	struct thread_params *params = (struct thread_params *)arg;
+	struct kvm_vcpu *vcpu = params->vcpu;
 	struct ucall uc;
 	int old;
 	int r;
@@ -206,17 +203,17 @@ static void *vcpu_thread(void *arg)
 	r = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
 	TEST_ASSERT(r == 0,
 		    "pthread_setcanceltype failed on vcpu_id=%u with errno=%d",
-		    params->vcpu_id, r);
+		    vcpu->id, r);
 
-	fprintf(stderr, "vCPU thread running vCPU %u\n", params->vcpu_id);
-	vcpu_run(params->vm, params->vcpu_id);
-	exit_reason = vcpu_state(params->vm, params->vcpu_id)->exit_reason;
+	fprintf(stderr, "vCPU thread running vCPU %u\n", vcpu->id);
+	vcpu_run(vcpu->vm, vcpu->id);
+	exit_reason = vcpu->run->exit_reason;
 
 	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
 		    "vCPU %u exited with unexpected exit reason %u-%s, expected KVM_EXIT_IO",
-		    params->vcpu_id, exit_reason, exit_reason_str(exit_reason));
+		    vcpu->id, exit_reason, exit_reason_str(exit_reason));
 
-	if (get_ucall(params->vm, params->vcpu_id, &uc) == UCALL_ABORT) {
+	if (get_ucall(vcpu->vm, vcpu->id, &uc) == UCALL_ABORT) {
 		TEST_ASSERT(false,
 			    "vCPU %u exited with error: %s.\n"
 			    "Sending vCPU sent %lu IPIs to halting vCPU\n"
@@ -224,7 +221,7 @@ static void *vcpu_thread(void *arg)
 			    "Halter TPR=%#x PPR=%#x LVR=%#x\n"
 			    "Migrations attempted: %lu\n"
 			    "Migrations completed: %lu\n",
-			    params->vcpu_id, (const char *)uc.args[0],
+			    vcpu->id, (const char *)uc.args[0],
 			    params->data->ipis_sent, params->data->hlt_count,
 			    params->data->wake_count,
 			    *params->pipis_rcvd, params->data->halter_tpr,
@@ -236,7 +233,7 @@ static void *vcpu_thread(void *arg)
 	return NULL;
 }
 
-static void cancel_join_vcpu_thread(pthread_t thread, uint32_t vcpu_id)
+static void cancel_join_vcpu_thread(pthread_t thread, struct kvm_vcpu *vcpu)
 {
 	void *retval;
 	int r;
@@ -244,12 +241,12 @@ static void cancel_join_vcpu_thread(pthread_t thread, uint32_t vcpu_id)
 	r = pthread_cancel(thread);
 	TEST_ASSERT(r == 0,
 		    "pthread_cancel on vcpu_id=%d failed with errno=%d",
-		    vcpu_id, r);
+		    vcpu->id, r);
 
 	r = pthread_join(thread, &retval);
 	TEST_ASSERT(r == 0,
 		    "pthread_join on vcpu_id=%d failed with errno=%d",
-		    vcpu_id, r);
+		    vcpu->id, r);
 	TEST_ASSERT(retval == PTHREAD_CANCELED,
 		    "expected retval=%p, got %p", PTHREAD_CANCELED,
 		    retval);
@@ -415,34 +412,30 @@ int main(int argc, char *argv[])
 	if (delay_usecs <= 0)
 		delay_usecs = DEFAULT_DELAY_USECS;
 
-	vm = vm_create_default(HALTER_VCPU_ID, 0, halter_guest_code);
-	params[0].vm = vm;
-	params[1].vm = vm;
+	vm = vm_create_with_one_vcpu(&params[0].vcpu, halter_guest_code);
 
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, HALTER_VCPU_ID);
+	vcpu_init_descriptor_tables(vm, params[0].vcpu->id);
 	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
 
-	vm_vcpu_add(vm, SENDER_VCPU_ID, sender_guest_code);
+	params[1].vcpu = vm_vcpu_add(vm, 1, sender_guest_code);
 
 	test_data_page_vaddr = vm_vaddr_alloc_page(vm);
-	data =
-	   (struct test_data_page *)addr_gva2hva(vm, test_data_page_vaddr);
+	data = addr_gva2hva(vm, test_data_page_vaddr);
 	memset(data, 0, sizeof(*data));
 	params[0].data = data;
 	params[1].data = data;
 
-	vcpu_args_set(vm, HALTER_VCPU_ID, 1, test_data_page_vaddr);
-	vcpu_args_set(vm, SENDER_VCPU_ID, 1, test_data_page_vaddr);
+	vcpu_args_set(vm, params[0].vcpu->id, 1, test_data_page_vaddr);
+	vcpu_args_set(vm, params[1].vcpu->id, 1, test_data_page_vaddr);
 
 	pipis_rcvd = (uint64_t *)addr_gva2hva(vm, (uint64_t)&ipis_rcvd);
 	params[0].pipis_rcvd = pipis_rcvd;
 	params[1].pipis_rcvd = pipis_rcvd;
 
 	/* Start halter vCPU thread and wait for it to execute first HLT. */
-	params[0].vcpu_id = HALTER_VCPU_ID;
 	r = pthread_create(&threads[0], NULL, vcpu_thread, &params[0]);
 	TEST_ASSERT(r == 0,
 		    "pthread_create halter failed errno=%d", errno);
@@ -462,7 +455,6 @@ int main(int argc, char *argv[])
 		"Halter vCPU thread reported its APIC ID: %u after %d seconds.\n",
 		data->halter_apic_id, wait_secs);
 
-	params[1].vcpu_id = SENDER_VCPU_ID;
 	r = pthread_create(&threads[1], NULL, vcpu_thread, &params[1]);
 	TEST_ASSERT(r == 0, "pthread_create sender failed errno=%d", errno);
 
@@ -478,8 +470,8 @@ int main(int argc, char *argv[])
 	/*
 	 * Cancel threads and wait for them to stop.
 	 */
-	cancel_join_vcpu_thread(threads[0], HALTER_VCPU_ID);
-	cancel_join_vcpu_thread(threads[1], SENDER_VCPU_ID);
+	cancel_join_vcpu_thread(threads[0], params[0].vcpu);
+	cancel_join_vcpu_thread(threads[1], params[1].vcpu);
 
 	fprintf(stderr,
 		"Test successful after running for %d seconds.\n"
-- 
2.36.1.255.ge46751e96f-goog

