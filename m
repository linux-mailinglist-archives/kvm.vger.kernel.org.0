Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359F14D4FA6
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243881AbiCJQrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243713AbiCJQrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:47:03 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDA2166E11
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:00 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d13-20020a170902b70d00b0015317d9f08bso1664107pls.1
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HE/O3qBQQfnPa9lv9g/YI8j6lgpbZMJt6yutRPg7j9Q=;
        b=gjhVEZBWgspIP5DNAIFWgNX2IvJP8JGW6Yct9xx1sK/5MdGUB4jGY92bvVLTZN1y5/
         y2qddS+NrTMk2I8fBC5P0IM0qmEkxgHyiXeSz0NjvBxa/CyY5LDaV/ixSOgel/gy242A
         fmzJqK6XATiUeGaaQNnNhn0e7vFQzhuM9l7KUcz6nkqzfB9+T1WRYr+HWeVZWD/ARc6P
         Nixg/hw6f18RKJceYFF+iha5C+WICFcj3ZTuOFJ6hwqLrNg8Fs4VIs3uoRymkWHv20H7
         5ppVl1COVwNvGfSaHO/AEKOxciOnn3wN7P2wIlsM93lmJ0z0QB0NsxyiFU9z51BHA+MF
         cb/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HE/O3qBQQfnPa9lv9g/YI8j6lgpbZMJt6yutRPg7j9Q=;
        b=HOUkuVwy2Zr5+H4uVpcbYWcPjbpOTrPYOYRJExWEFrJ25LK66/8AtKWi6rLtBwxdpH
         wJJBY3h9c9xav2wkeDxEZmi2axmXPE37bnolQCYdx+6yLBokFrVcHtR+7ziZGaW+JIGe
         HtlkPNJUQi8HB4lN2tsiy8mwdoOf3B9qy7WhjzTkUexslnVgG/BO3abmp9/S+QMhdfmF
         h4CWrS2Al7/eD9oJVuAe4rkRYOWWCPfDMTnaH3KISojStpqSmUtMoAzpTNOX0Gw6cKWE
         6u34Wy5o+n83RZr3krxkoYRxvpbmiDy6VNt0SMeWFwp+sjMumBHRFAdce3r7JFUm3n5U
         GSuw==
X-Gm-Message-State: AOAM532yraN7eUqOg7vMtPL9b/kI+RzsYh4JZsb+IMnjsnURFcCaWeXS
        P7sjnC7A+etHHEyDVX6ZlBAX087ycTO0
X-Google-Smtp-Source: ABdhPJyP2U6eXcpKoU609bxDuH9KIVdIW7MM6n5M6Llu2IiV8JWI/DEzXvpus840lRSgOzEOBsPWl1gFn32c
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:a62:5251:0:b0:4f6:ff68:50c2 with SMTP id
 g78-20020a625251000000b004f6ff6850c2mr5592924pfb.63.1646930759610; Thu, 10
 Mar 2022 08:45:59 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:24 -0800
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
Message-Id: <20220310164532.1821490-6-bgardon@google.com>
Mime-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 05/13] selftests: KVM: Add memslot parameter to elf_load
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Currently elf_load loads code into memslot 0. Add a parameter to allow
loading code into any memslot. This will be useful for backing code
pages with huge pages in future commits.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c | 2 +-
 tools/testing/selftests/kvm/dirty_log_test.c           | 2 +-
 tools/testing/selftests/kvm/hardware_disable_test.c    | 2 +-
 tools/testing/selftests/kvm/include/kvm_util_base.h    | 3 ++-
 tools/testing/selftests/kvm/lib/elf.c                  | 4 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c             | 2 +-
 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c   | 2 +-
 7 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index 4c5f6814030f..c3d5227a740e 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -77,7 +77,7 @@ int main(void)
 	struct ucall uc;
 
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
-	kvm_vm_elf_load(vm, program_invocation_name);
+	kvm_vm_elf_load(vm, program_invocation_name, MEMSLOT(0));
 	ucall_init(vm, NULL);
 
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 1241c9a2729c..fe1054897ee2 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -686,7 +686,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
-	kvm_vm_elf_load(vm, program_invocation_name);
+	kvm_vm_elf_load(vm, program_invocation_name, MEMSLOT(0));
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
 #endif
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index b21c69a56daa..4f699781e065 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -105,7 +105,7 @@ static void run_test(uint32_t run)
 		CPU_SET(i, &cpu_set);
 
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
-	kvm_vm_elf_load(vm, program_invocation_name);
+	kvm_vm_elf_load(vm, program_invocation_name, MEMSLOT(0));
 	vm_create_irqchip(vm);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index f70dfa3e1202..530b5272fae2 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -131,7 +131,8 @@ uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm);
 int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
 		       size_t len);
 
-void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
+void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename,
+		     struct kvm_memslot memslot);
 int kvm_memfd_alloc(size_t size, bool hugepages);
 
 void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 88d03cb80423..763f489492f1 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -111,7 +111,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
  * by the image and it needs to have sufficient available physical pages, to
  * back the virtual pages used to load the image.
  */
-void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
+void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename, struct kvm_memslot memslot)
 {
 	off_t offset, offset_rv;
 	Elf64_Ehdr hdr;
@@ -163,7 +163,7 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 		size_t seg_size = seg_vend - seg_vstart + 1;
 
 		vm_vaddr_t vaddr = vm_vaddr_alloc(vm, seg_size, seg_vstart,
-						  MEMSLOT(0));
+						  memslot);
 		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
 			"virtual memory for segment at requested min addr,\n"
 			"  segment idx: %u\n"
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 04abfc7e6b5c..a10bee651191 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -368,7 +368,7 @@ struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
 
 	vm = vm_create(mode, pages, O_RDWR);
 
-	kvm_vm_elf_load(vm, program_invocation_name);
+	kvm_vm_elf_load(vm, program_invocation_name, MEMSLOT(0));
 
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index ae76436af0cc..3a7783046895 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -90,7 +90,7 @@ static struct kvm_vm *create_vm(void)
 	pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, pages);
 	vm = vm_create(VM_MODE_DEFAULT, pages, O_RDWR);
 
-	kvm_vm_elf_load(vm, program_invocation_name);
+	kvm_vm_elf_load(vm, program_invocation_name, MEMSLOT(0));
 	vm_create_irqchip(vm);
 
 	return vm;
-- 
2.35.1.616.g0bdcbb4464-goog

