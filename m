Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07F23B0E21
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhFVUIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbhFVUIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:08:04 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F332AC061787
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:05:46 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id es19-20020a0562141933b029023930e98a57so281644qvb.18
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HwBdUUVg5WRnYr7OujrI2dWOX65CgeoL74ctthgCXyg=;
        b=NB86bWddH4OVd9bMiabq5NDS83S7Gb8j81S/sOlnH7ryVjeLv1rjcHBp38b/AVgbUk
         4SMRxb2+fO9n730ULh6FsSwvsWh0mkiM/KpaZeSIPu+X36Lvp32KGSzAD8TKyyJjUcVh
         hDtZBOz1O30OFZgTtcsSsv/6wCPwUaArONPMAh/vBmVmB8r/159HdegLfKTUg8vlaT9D
         xu7Mvkwudxmz6e7mfzcGzPbQXS4uvuJS8bB4DEbvCBnKJVOcKo4ldNKF2WZnUEq/PG7h
         RkJDCEEP/YBZKzFbslY7B7FaxsjpFsNQ94Z2op87EI2U7LKH6nsexMy5HXxqBIzJXX0g
         vGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HwBdUUVg5WRnYr7OujrI2dWOX65CgeoL74ctthgCXyg=;
        b=UbsvKlMN4MxzfSvxwrP04qOf9ptwS/hGO2v6K5z/Hoe7zJSS3SYFofubizvrdORJMg
         aYwGhCt4Docix0Gs8BqN32vu6bDM4rk7TRxjTe+6ECkgrF54mShhVghLsc5zoDyk67YQ
         zaQa4JBW1cdHdKfe4ttqStkuolw2QyDQB/v8L3NtS82HUVkqy6xdf82NDw0WvC2I/9v3
         cio16zuykbxPECF4vFOHbNyd6pjcse9cwDf4mDhwdtq0zIh06G/RD7TQE4hTaRC49Nm+
         t4lHJjWn4czpCW5RfkBZXYzgXLaoB8mUwpGy1iWb5kBvtLupDjpl57hK2HW4L+WXuJjQ
         3D5g==
X-Gm-Message-State: AOAM533bTUM+M5v97/rOqaynpQ1zgdRSMs+c1Zs85CMHJ+i620gX8Hcq
        PNCpRxYkkAH0rBoXf2WolMR0Mp8zYOw=
X-Google-Smtp-Source: ABdhPJyh9PpE4m9CB0fSIpX5c6dcS8UDcAK2KugWDJLD+nypbizKW+lGCqmDtYydxQ9TNoCMN0Y1/2yxLL4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:ad4:48d1:: with SMTP id v17mr590486qvx.16.1624392346045;
 Tue, 22 Jun 2021 13:05:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:13 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 03/19] KVM: selftests: Unconditionally use memslot 0 when
 loading elf binary
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use memslot '0' for all vm_vaddr_alloc() calls when loading the test
binary.  This is the first step toward adding a helper to handle page
allocations with a default value for the target memslot.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c         | 2 +-
 tools/testing/selftests/kvm/hardware_disable_test.c  | 2 +-
 tools/testing/selftests/kvm/include/kvm_util.h       | 3 +--
 tools/testing/selftests/kvm/lib/elf.c                | 6 ++----
 tools/testing/selftests/kvm/lib/kvm_util.c           | 2 +-
 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c | 2 +-
 6 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index b4d24f50aca6..9026fa4ea133 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -680,7 +680,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
-	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
+	kvm_vm_elf_load(vm, program_invocation_name);
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
 #endif
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 4b8db3bce610..b21c69a56daa 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -105,7 +105,7 @@ static void run_test(uint32_t run)
 		CPU_SET(i, &cpu_set);
 
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
-	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
+	kvm_vm_elf_load(vm, program_invocation_name);
 	vm_create_irqchip(vm);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 35739567189e..59608b17707d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -98,8 +98,7 @@ uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm);
 int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
 		       size_t len);
 
-void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename,
-		     uint32_t data_memslot, uint32_t pgd_memslot);
+void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
 
 void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
 
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index bc75a91e00a6..edeeaf73d3b1 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -111,8 +111,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
  * by the image and it needs to have sufficient available physical pages, to
  * back the virtual pages used to load the image.
  */
-void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename,
-	uint32_t data_memslot, uint32_t pgd_memslot)
+void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 {
 	off_t offset, offset_rv;
 	Elf64_Ehdr hdr;
@@ -164,8 +163,7 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename,
 		seg_vend |= vm->page_size - 1;
 		size_t seg_size = seg_vend - seg_vstart + 1;
 
-		vm_vaddr_t vaddr = vm_vaddr_alloc(vm, seg_size, seg_vstart,
-			data_memslot, pgd_memslot);
+		vm_vaddr_t vaddr = vm_vaddr_alloc(vm, seg_size, seg_vstart, 0, 0);
 		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
 			"virtual memory for segment at requested min addr,\n"
 			"  segment idx: %u\n"
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a2b732cf96ea..15a8527b15db 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -365,7 +365,7 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 	pages = vm_adjust_num_guest_pages(mode, pages);
 	vm = vm_create(mode, pages, O_RDWR);
 
-	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
+	kvm_vm_elf_load(vm, program_invocation_name);
 
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index 5f8dd74d415f..e5535a0c8a35 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -90,7 +90,7 @@ static struct kvm_vm *create_vm(void)
 	pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, pages);
 	vm = vm_create(VM_MODE_DEFAULT, pages, O_RDWR);
 
-	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
+	kvm_vm_elf_load(vm, program_invocation_name);
 	vm_create_irqchip(vm);
 
 	return vm;
-- 
2.32.0.288.g62a8d224e6-goog

