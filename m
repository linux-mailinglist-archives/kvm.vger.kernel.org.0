Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E1451B30F
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381635AbiEDXFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379936AbiEDW7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:59:34 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AB1562E4
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:52:37 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id s5-20020a17090aa10500b001d9a8e99e3aso1319265pjp.2
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ByVqkqLm1uGzaF3TQCPIx1HaF05dWYxVIwtTq/eI0Pc=;
        b=fKkWFw+llj+PZVaizfFuTtO8ZHBXh9rsa9GtpL2Z36G5NWIbhiUnY8c3Fz4ggKeUZ6
         BuSZbZhuvVZHCy+sU66z4oD2a1xKH8S3GT10gkODzVXiy9jXUwmB5k9bV6E9NBB7Xz5V
         okdjfW4YgtWeswet7zuyAb3IF9f/oId/jryHWqQF1TitAvJ9W86sq2mFvF8A4sU6gcvo
         /q0bw0ZChiBTAzH3NzjaHwXBH3A/CTtZ9JnC0nl+JN09J0rfwruimmT5tpeQSAmWkAon
         KUsDRAPIyXPi0cBgZvDitqdQduNq0zNpP1XX82e2TeqYLmklfsyXmvrZlOMLoL+C+0PT
         GwUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ByVqkqLm1uGzaF3TQCPIx1HaF05dWYxVIwtTq/eI0Pc=;
        b=Bau5CiLbJgehFVzJCx8etC76FZ8hNXDi57UGKgBKBUbIVfWKfGBHhJuxlmEEPwNj6h
         5stmVSaTMNp53NaSvlnvq5OWx2otyHzKsDi1LXC24fRJ9zmxR7vj34Y/ckzKz9/RQngc
         uTuYKqRNnz4/DfNosDC3/8FakJ183rzkfzEdo3H4kqNt4PNQzIZvp6ktOwsq+JqgoDwE
         eS3ZfcVS/6Ox7GYc2RuENUBTmrt9IvQlBSZA2zzrdHEWevSsCi4e0lQbrwm+N3JARsZC
         WD309I/mifQ+NpdUncNbIld0WUWQbN1alirRkmvNIDy0FFZi6iY2GiL8RGfRL6pvr3bJ
         IHsA==
X-Gm-Message-State: AOAM53176UsPMxfSdB2MI+5cZ5VCFtbMzsee+YakQD4r800JSFUcj8tz
        iK4VX4C5vSGYTobwwnDgFt201q6XlMk=
X-Google-Smtp-Source: ABdhPJyJV2ANDhm0W75sV5WKSLz5StdzAn5LRR77nsl3BGMkKtJ13qGTcyLstv6TobgUPU1APFaPLsgHLjE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:a406:b0:158:260d:1ed2 with SMTP id
 p6-20020a170902a40600b00158260d1ed2mr24096732plq.49.1651704739333; Wed, 04
 May 2022 15:52:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:44 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-99-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 098/128] KVM: selftests: Add VM creation helper that "returns" vCPUs
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

Add a VM creator that "returns" the created vCPUs by filling the provided
array.  This will allow converting multi-vCPU tests away from hardcoded
vCPU IDs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h       | 17 +++++++++++++----
 .../testing/selftests/kvm/kvm_page_table_test.c |  4 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c      | 17 ++++++++++-------
 .../testing/selftests/kvm/lib/perf_test_util.c  |  4 ++--
 4 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 02df9a794530..2ddf0854c24d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -562,10 +562,19 @@ struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_me
 					    uint32_t vcpuids[]);
 
 /* Like vm_create_default_with_vcpus, but accepts mode and slot0 memory as a parameter */
-struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
-				    uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
-				    uint32_t num_percpu_pages, void *guest_code,
-				    uint32_t vcpuids[]);
+struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+				      uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
+				      uint32_t num_percpu_pages, void *guest_code,
+				      uint32_t vcpuids[], struct kvm_vcpu *vcpus[]);
+
+static inline struct kvm_vm *vm_create_with_vcpus(uint32_t nr_vcpus,
+						  void *guest_code,
+						  struct kvm_vcpu *vcpus[])
+{
+	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus,
+				      DEFAULT_GUEST_PHY_PAGES, 0, 0,
+				      guest_code, NULL, vcpus);
+}
 
 /*
  * Create a VM with a single vCPU with reasonable defaults and @extra_mem_pages
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 2c4a7563a4f8..e91bc7f1400d 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -268,8 +268,8 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 
 	/* Create a VM with enough guest pages */
 	guest_num_pages = test_mem_size / guest_page_size;
-	vm = vm_create_with_vcpus(mode, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
-				  guest_num_pages, 0, guest_code, NULL);
+	vm = __vm_create_with_vcpus(mode, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
+				    guest_num_pages, 0, guest_code, NULL, NULL);
 
 	/* Align down GPA of the testing memslot */
 	if (!p->phys_offset)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index bd9eb23edf3b..838a3eda9381 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -300,12 +300,13 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
  * extra_mem_pages is only used to calculate the maximum page table size,
  * no real memory allocation for non-slot0 memory in this function.
  */
-struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
-				    uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
-				    uint32_t num_percpu_pages, void *guest_code,
-				    uint32_t vcpuids[])
+struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+				      uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
+				      uint32_t num_percpu_pages, void *guest_code,
+				      uint32_t vcpuids[], struct kvm_vcpu *vcpus[])
 {
 	uint64_t vcpu_pages, extra_pg_pages, pages;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int i;
 
@@ -332,7 +333,9 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 	for (i = 0; i < nr_vcpus; ++i) {
 		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
 
-		vm_vcpu_add(vm, vcpuid, guest_code);
+		vcpu = vm_vcpu_add(vm, vcpuid, guest_code);
+		if (vcpus)
+			vcpus[i] = vcpu;
 	}
 
 	return vm;
@@ -342,8 +345,8 @@ struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_me
 					    uint32_t num_percpu_pages, void *guest_code,
 					    uint32_t vcpuids[])
 {
-	return vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
-				    extra_mem_pages, num_percpu_pages, guest_code, vcpuids);
+	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
+				      extra_mem_pages, num_percpu_pages, guest_code, vcpuids, NULL);
 }
 
 struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 722df3a28791..5b80ba7f12e4 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -139,8 +139,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	 * The memory is also added to memslot 0, but that's a benign side
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
-	vm = vm_create_with_vcpus(mode, vcpus, DEFAULT_GUEST_PHY_PAGES,
-				  guest_num_pages, 0, guest_code, NULL);
+	vm = __vm_create_with_vcpus(mode, vcpus, DEFAULT_GUEST_PHY_PAGES,
+				    guest_num_pages, 0, guest_code, NULL, NULL);
 
 	pta->vm = vm;
 
-- 
2.36.0.464.gb9c8b46e94-goog

