Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5780B53C1AF
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbiFCArO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbiFCApK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:10 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B5B344E0
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:08 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s9-20020a634509000000b003fc7de146d4so3055225pga.3
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ImUYRPXrpM1plNN02DbUHhAlHRJfyxKRglg4HYhksiU=;
        b=rLGkzSTEiBmX8DheRgluIn9ngL9d2mPzwC/9MWUv4DXekXRYlxDyJlZUgN/OkuTwKr
         gmvs+5ewXmwGhyDswBOzeLPksYy6XM313P8IOZskIU/XgJQARdot+DNnfDN495znc/nc
         x8icSZSMF/UkjIEpaQR1+nCFOleNR7j23JL98fqX0+3ocMExHAax3rnotmDaOL7DjlCs
         GXnpQg5/mw9gJRlBgG5Gxw4CIbpZ2cE3Eu8/wtfyLuyGLFoKaiYQfktpkungUABT/wIL
         kKzW1MzsX6is/UkRQVJVVe1h8o76wwpyV7lDhAbvpBYDHb7wlYKb2dAYzQ5h8CuRnJGV
         zdGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ImUYRPXrpM1plNN02DbUHhAlHRJfyxKRglg4HYhksiU=;
        b=qo+QuUVrXaQqMPZiTrd+M9xZAOcsb32G63JTwgCBBxjgx6ZfO2RpubzBfIAi0rwFSl
         aqzeyMhn7YljK9jNU8jjRgygkXZEQyycGQOvQAa43agMYcekTlV3Jn7o7SGTr1teEWhv
         o1s7n8rSou4sASe6fYWgsYJxw4gxiXvtrzPooKUR9DVPJxs9XCGXGxv5Y2FHbDaOrxF/
         C/UVT3FIENERu4VqJmqQAIa+lO4xAyu1VIKraXEoSaxuD7frrz8xkDT9YBJ522m3bT/d
         zUmenyW3jel2bBMW2f+Yc8tji7hXto9DQqqtGfC7p96QBE5Bv2a5Bp8vgA6QhrcG4oeF
         LTxA==
X-Gm-Message-State: AOAM533Mpx2wBwk7eeAC1piqpb3RYMjhVTSc7pp1ggqO4sVXHevVmNvW
        qn3e0TXxChsNdkJKBLVYWTrJX0SBHbk=
X-Google-Smtp-Source: ABdhPJxghim9FfFS29i9ptKPF1cZ7m55pgtvMhYOM7sqLtoXhxCJA1N1zETg5dr/YKyHNlB8sB4TxD43s3w=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:f552:b0:163:f64a:6154 with SMTP id
 h18-20020a170902f55200b00163f64a6154mr7656473plf.147.1654217108218; Thu, 02
 Jun 2022 17:45:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:57 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-51-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 050/144] KVM: selftests: Convert memslot_perf_test away
 from VCPU_ID
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

Convert memslot_perf_test to use __vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.
This is the first of many, many steps towards eliminating VCPU_ID from
all KVM selftests, and towards eventually purging the VM+vcpu_id mess.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 1727f75e0c2c..009eb19b28af 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -25,8 +25,6 @@
 #include <kvm_util.h>
 #include <processor.h>
 
-#define VCPU_ID 0
-
 #define MEM_SIZE		((512U << 20) + 4096)
 #define MEM_SIZE_PAGES		(MEM_SIZE / 4096)
 #define MEM_GPA		0x10000000UL
@@ -90,6 +88,7 @@ static_assert(MEM_TEST_MOVE_SIZE <= MEM_TEST_SIZE,
 
 struct vm_data {
 	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
 	pthread_t vcpu_thread;
 	uint32_t nslots;
 	uint64_t npages;
@@ -127,29 +126,29 @@ static bool verbose;
 			pr_info(__VA_ARGS__);	\
 	} while (0)
 
-static void check_mmio_access(struct vm_data *vm, struct kvm_run *run)
+static void check_mmio_access(struct vm_data *data, struct kvm_run *run)
 {
-	TEST_ASSERT(vm->mmio_ok, "Unexpected mmio exit");
+	TEST_ASSERT(data->mmio_ok, "Unexpected mmio exit");
 	TEST_ASSERT(run->mmio.is_write, "Unexpected mmio read");
 	TEST_ASSERT(run->mmio.len == 8,
 		    "Unexpected exit mmio size = %u", run->mmio.len);
-	TEST_ASSERT(run->mmio.phys_addr >= vm->mmio_gpa_min &&
-		    run->mmio.phys_addr <= vm->mmio_gpa_max,
+	TEST_ASSERT(run->mmio.phys_addr >= data->mmio_gpa_min &&
+		    run->mmio.phys_addr <= data->mmio_gpa_max,
 		    "Unexpected exit mmio address = 0x%llx",
 		    run->mmio.phys_addr);
 }
 
-static void *vcpu_worker(void *data)
+static void *vcpu_worker(void *__data)
 {
-	struct vm_data *vm = data;
-	struct kvm_run *run;
+	struct vm_data *data = __data;
+	struct kvm_vcpu *vcpu = data->vcpu;
+	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
-	run = vcpu_state(vm->vm, VCPU_ID);
 	while (1) {
-		vcpu_run(vm->vm, VCPU_ID);
+		vcpu_run(data->vm, vcpu->id);
 
-		switch (get_ucall(vm->vm, VCPU_ID, &uc)) {
+		switch (get_ucall(data->vm, vcpu->id, &uc)) {
 		case UCALL_SYNC:
 			TEST_ASSERT(uc.args[1] == 0,
 				"Unexpected sync ucall, got %lx",
@@ -158,7 +157,7 @@ static void *vcpu_worker(void *data)
 			continue;
 		case UCALL_NONE:
 			if (run->exit_reason == KVM_EXIT_MMIO)
-				check_mmio_access(vm, run);
+				check_mmio_access(data, run);
 			else
 				goto done;
 			break;
@@ -238,6 +237,7 @@ static struct vm_data *alloc_vm(void)
 	TEST_ASSERT(data, "malloc(vmdata) failed");
 
 	data->vm = NULL;
+	data->vcpu = NULL;
 	data->hva_slots = NULL;
 
 	return data;
@@ -278,7 +278,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	data->hva_slots = malloc(sizeof(*data->hva_slots) * data->nslots);
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
-	data->vm = vm_create_default(VCPU_ID, mempages, guest_code);
+	data->vm = __vm_create_with_one_vcpu(&data->vcpu, mempages, guest_code);
 	ucall_init(data->vm, NULL);
 
 	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
-- 
2.36.1.255.ge46751e96f-goog

