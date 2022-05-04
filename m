Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E24A51B2D6
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379995AbiEDXBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380302AbiEDW7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:59:54 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7A556FA9
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:09 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id i188-20020a636dc5000000b003c143f97bc2so1343944pgc.11
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MLU+SS8ptc3VdisiTyqeNIDg5kJwfCfbwvY9mVCwAYM=;
        b=CMDLv3g6q4N6WtnyZI3YdiPx1LaEBB3IYvxP+cLWRkDcGda+5r6u2osjIIoPQmmt9Y
         cNRTBL1fnIrvYKr1CF9TLk4akb/obPsKvkROWLAWzxi+GbybyaeGamwXDRr7uja8vq1u
         C9008+8GHLHWlwECb81QE1jaK58oKwA2wY86mPRxjPJ4AW1q4tn7gWr0VmM82TXMLjLx
         1Veozc764GxEbgqA3HE2ru846tFdi2iFlJQ4azDA7Arv/9xNPCb2zCeGtj3u++E7OD74
         HJoZbnptboBQmmpJcku2olCOKswdYH87vD7cD0oIWEc4rfb+SeaPwB6+bd/fEWrp2Mp6
         qtgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MLU+SS8ptc3VdisiTyqeNIDg5kJwfCfbwvY9mVCwAYM=;
        b=yPzTjWWAF2wnn7IRdMvyk8n9z5RMWZZzQA0i76Co/johTR+3L8E5JC/9E3bUZq25dh
         10bqjmzUTGsdGteBEXGzeD4SKYz46z86yRA6TgKtUZ1+KtDN03r66/zirYnrI8eESq7Z
         6FVv+hDmBMmI3e8G6VA7h6VxRK8buZEDzH0uwrS2oRdIC7tStx0NEtcmL6B9FfBIShIw
         tb/CZP6J79AcURUq4HljCbQpfnfqjht6oSeVDUIXqTZM4p9q+RyeXZZjEoScLNguRgwA
         etsSqRH8u17NBfn9qm9trK+Qj7SuszQYASXNzZYd3miCTDm40W7xFL9zsvT2pOvhJrvS
         /Zug==
X-Gm-Message-State: AOAM53336w7bvvi41+XlmVfJjpdfBbJ0VhLyK1VFZMNAOygN8a2nVulm
        +J840Xy3Sczr5fIWEeJfDdKYlp5oC14=
X-Google-Smtp-Source: ABdhPJzayaVoqUhknmAbSK8yZDeZZZVA0r60UISplvxnshReSjYvLFZSouYhwKXT2teTNKPPtzt3+xjSF8I=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:891:b0:4fe:1262:9b4e with SMTP id
 q17-20020a056a00089100b004fe12629b4emr23112238pfj.21.1651704760854; Wed, 04
 May 2022 15:52:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:56 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-111-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 110/128] KVM: selftests: Use vm_create_with_vcpus() in max_guest_memory_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vm_create_with_vcpus() in max_guest_memory_test and reference vCPUs
by their 'struct kvm_vcpu' object instead of their ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/max_guest_memory_test.c     | 26 ++++++++++++-------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 3875c4b23a04..956fc56b8c68 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -28,8 +28,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 }
 
 struct vcpu_info {
-	struct kvm_vm *vm;
-	uint32_t id;
+	struct kvm_vcpu *vcpu;
 	uint64_t start_gpa;
 	uint64_t end_gpa;
 };
@@ -60,12 +59,13 @@ static void run_vcpu(struct kvm_vm *vm, uint32_t vcpu_id)
 
 static void *vcpu_worker(void *data)
 {
-	struct vcpu_info *vcpu = data;
+	struct vcpu_info *info = data;
+	struct kvm_vcpu *vcpu = info->vcpu;
 	struct kvm_vm *vm = vcpu->vm;
 	struct kvm_sregs sregs;
 	struct kvm_regs regs;
 
-	vcpu_args_set(vm, vcpu->id, 3, vcpu->start_gpa, vcpu->end_gpa,
+	vcpu_args_set(vm, vcpu->id, 3, info->start_gpa, info->end_gpa,
 		      vm_get_page_size(vm));
 
 	/* Snapshot regs before the first run. */
@@ -89,8 +89,8 @@ static void *vcpu_worker(void *data)
 	return NULL;
 }
 
-static pthread_t *spawn_workers(struct kvm_vm *vm, uint64_t start_gpa,
-				uint64_t end_gpa)
+static pthread_t *spawn_workers(struct kvm_vm *vm, struct kvm_vcpu **vcpus,
+				uint64_t start_gpa, uint64_t end_gpa)
 {
 	struct vcpu_info *info;
 	uint64_t gpa, nr_bytes;
@@ -108,8 +108,7 @@ static pthread_t *spawn_workers(struct kvm_vm *vm, uint64_t start_gpa,
 	TEST_ASSERT(nr_bytes, "C'mon, no way you have %d CPUs", nr_vcpus);
 
 	for (i = 0, gpa = start_gpa; i < nr_vcpus; i++, gpa += nr_bytes) {
-		info[i].vm = vm;
-		info[i].id = i;
+		info[i].vcpu = vcpus[i];
 		info[i].start_gpa = gpa;
 		info[i].end_gpa = gpa + nr_bytes;
 		pthread_create(&threads[i], NULL, vcpu_worker, &info[i]);
@@ -172,6 +171,7 @@ int main(int argc, char *argv[])
 	uint64_t max_gpa, gpa, slot_size, max_mem, i;
 	int max_slots, slot, opt, fd;
 	bool hugepages = false;
+	struct kvm_vcpu **vcpus;
 	pthread_t *threads;
 	struct kvm_vm *vm;
 	void *mem;
@@ -215,7 +215,10 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
+	vcpus = malloc(nr_vcpus * sizeof(*vcpus));
+	TEST_ASSERT(vcpus, "Failed to allocate vCPU array");
+
+	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
 
 	max_gpa = vm_get_max_gfn(vm) << vm_get_page_shift(vm);
 	TEST_ASSERT(max_gpa > (4 * slot_size), "MAXPHYADDR <4gb ");
@@ -252,7 +255,10 @@ int main(int argc, char *argv[])
 	}
 
 	atomic_set(&rendezvous, nr_vcpus + 1);
-	threads = spawn_workers(vm, start_gpa, gpa);
+	threads = spawn_workers(vm, vcpus, start_gpa, gpa);
+
+	free(vcpus);
+	vcpus = NULL;
 
 	pr_info("Running with %lugb of guest memory and %u vCPUs\n",
 		(gpa - start_gpa) / size_1gb, nr_vcpus);
-- 
2.36.0.464.gb9c8b46e94-goog

