Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E770253C2CC
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239830AbiFCA42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241272AbiFCAuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:32 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D959340E8
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:46 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id lw3-20020a17090b180300b001e31fad7d5aso6402295pjb.6
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ppIQviKeXAjnBTE67zRSl+mz1Fz5fT88/u4zDaATcDY=;
        b=ZYMZuefqQ7VqgcGkwgIuck5ytWZ1wxhU1qBur6BmelEMmu4oOWPTH8gQG6jodbj3mx
         pc8G/so2nlpShG46ZXNBYya/WdqDMwNyrZfj/RDEVJNFt4OOlVXLho2uY/1HB3NB7cRc
         jTVFK1C5qpgL3nW+baPppZCthxus7Y7QL0t1TtWlcS59RXQwu8E6ROiJROGaFAwo8YkV
         kkqe+1kQhzfpn6GsNbwQPsS4KPeMI9F2cBS7CjLL2EnLOceph988mumRcU3z3QtepnOr
         BtfWI5ufX3VO5dnPGY9jfn2G87tCEj79dlXEPaIm8V+MDIurNCVgfxkzJLl0jH1AM6tG
         +Wpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ppIQviKeXAjnBTE67zRSl+mz1Fz5fT88/u4zDaATcDY=;
        b=X45s2zxnYFKDmI/B1sqEa1X0VA6G2LuXsJEkF1hucdmRwO7Pydy+rWAf8M3OYZFeoG
         VzDgGzpjRl686n9TZT2nZPRXGJio8zMLsBFYnYARcEGirWWeVQbyQ2WujmL/Bda0lzFW
         beqNZ/hv/h4y6U3oPHSnqB2+yegPTX7Zq6IsgNN30P/MK+27FG2J8jp0houbbUS4AmIB
         jVoqkCH6sh0PYcdDPu1CozVKFqxd997PyBaynpT7Dk4ToTTlby5vLxf/SDNugbv3INCz
         LauvUB8yzE4L0nRBk686xjeJQroLw+T3ckd4YwGBPKA++p2TN5z6CGyPYb5pDvlalnkE
         9Yog==
X-Gm-Message-State: AOAM532C753bZTqoSNIspd+FJ/XDV3oMRcRvN+Kg15mXhIdG+SLK8qyK
        jM2ghwaqe8TO4AEIqVq/o3gY5CW8uCQ=
X-Google-Smtp-Source: ABdhPJysWyQ3LxSjlqrGIKwMROjyt21nArq2Dc3ef8vyjSh29k5NpIASAf6qFvrYCLOspjtFbwgqHhnE4H8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e752:b0:165:1282:8d56 with SMTP id
 p18-20020a170902e75200b0016512828d56mr7738854plf.48.1654217263943; Thu, 02
 Jun 2022 17:47:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:24 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-138-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 137/144] KVM: selftests: Drop @num_percpu_pages from __vm_create_with_vcpus()
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop @num_percpu_pages from __vm_create_with_vcpus(), all callers pass
'0' and there's unlikely to be a test that allocates just enough memory
that it needs a per-CPU allocation, but not so much that it won't just do
its own memory management.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 4 ++--
 tools/testing/selftests/kvm/kvm_page_table_test.c   | 2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c          | 7 +++----
 tools/testing/selftests/kvm/lib/perf_test_util.c    | 2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index f84e01612c52..6143d45a02a7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -562,14 +562,14 @@ static inline struct kvm_vm *vm_create(uint64_t nr_pages)
 }
 
 struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
-				      uint64_t extra_mem_pages, uint32_t num_percpu_pages,
+				      uint64_t extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[]);
 
 static inline struct kvm_vm *vm_create_with_vcpus(uint32_t nr_vcpus,
 						  void *guest_code,
 						  struct kvm_vcpu *vcpus[])
 {
-	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, 0, 0,
+	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, 0,
 				      guest_code, vcpus);
 }
 
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index a68c57572ab4..f42c6ac6d71d 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -254,7 +254,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 
 	/* Create a VM with enough guest pages */
 	guest_num_pages = test_mem_size / guest_page_size;
-	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages, 0,
+	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages,
 				    guest_code, test_args.vcpus);
 
 	/* Align down GPA of the testing memslot */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f68234a2ee83..508a5eafe15b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -281,7 +281,6 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
  *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
  *   nr_vcpus - VCPU count
  *   extra_mem_pages - Non-slot0 physical memory total size
- *   num_percpu_pages - Per-cpu physical memory pages
  *   guest_code - Guest entry point
  *   vcpuids - VCPU IDs
  *
@@ -295,7 +294,7 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
  * no real memory allocation for non-slot0 memory in this function.
  */
 struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
-				      uint64_t extra_mem_pages, uint32_t num_percpu_pages,
+				      uint64_t extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[])
 {
 	uint64_t vcpu_pages, extra_pg_pages, pages;
@@ -310,7 +309,7 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 	 * N pages) will be: N/x+N/x^2+N/x^3+... which is definitely smaller
 	 * than N/x*2.
 	 */
-	vcpu_pages = (DEFAULT_STACK_PGS + num_percpu_pages) * nr_vcpus;
+	vcpu_pages = nr_vcpus * DEFAULT_STACK_PGS;
 	extra_pg_pages = (DEFAULT_GUEST_PHY_PAGES + extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
 	pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
 
@@ -333,7 +332,7 @@ struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 	struct kvm_vcpu *vcpus[1];
 	struct kvm_vm *vm;
 
-	vm = __vm_create_with_vcpus(VM_MODE_DEFAULT, 1, extra_mem_pages, 0,
+	vm = __vm_create_with_vcpus(VM_MODE_DEFAULT, 1, extra_mem_pages,
 				    guest_code, vcpus);
 
 	*vcpu = vcpus[0];
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 656f309584aa..1f25ed69ca98 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -144,7 +144,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	 * The memory is also added to memslot 0, but that's a benign side
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
-	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages, 0,
+	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages,
 				    guest_code, vcpus);
 
 	pta->vm = vm;
-- 
2.36.1.255.ge46751e96f-goog

