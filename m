Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B0E2A6F99
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 22:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732120AbgKDVYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 16:24:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732119AbgKDVYp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 16:24:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604525083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yQZyV+A7HQ6cYcps8BXDL+qw/N+ztnZZ7dHMG8PXBv0=;
        b=ULPGG1e2XYbLkd/BNaXgBFoTMkt3aVfvmd9gI4/FnOEjQEl1lnHp2n7R4/gr3DUx3Y4E+K
        LJpRbCUYo4fjWBLprSxHulbCwhhh+DqQQ+JevgildEOYxRVf6E/Tu2ZJKbBdJ5VovOdHMX
        x60/OzReABSl2LWSZV5g/I8Ip5xtOAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-GKm4jEg9MF2smK2eFu9R5g-1; Wed, 04 Nov 2020 16:24:40 -0500
X-MC-Unique: GKm4jEg9MF2smK2eFu9R5g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D89FC100F781;
        Wed,  4 Nov 2020 21:24:38 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 258691002C16;
        Wed,  4 Nov 2020 21:24:33 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 10/11] KVM: selftests: Introduce vm_create_[default_]vcpus
Date:   Wed,  4 Nov 2020 22:23:56 +0100
Message-Id: <20201104212357.171559-11-drjones@redhat.com>
In-Reply-To: <20201104212357.171559-1-drjones@redhat.com>
References: <20201104212357.171559-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce new vm_create variants that also takes a number of vcpus,
an amount of per-vcpu pages, and optionally a list of vcpuids. These
variants will create default VMs with enough additional pages to
cover the vcpu stacks, per-vcpu pages, and pagetable pages for all.
The new 'default' variant uses VM_MODE_DEFAULT, whereas the other
new variant accepts the mode as a parameter.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 10 ++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 36 ++++++++++++++++---
 2 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index ebf7f87d72df..0d652de57e6e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -242,6 +242,16 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
 				 void *guest_code);
 
+/* Same as vm_create_default, but can be used for more than one vcpu */
+struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_mem_pages,
+					    uint32_t num_percpu_pages, void *guest_code,
+					    uint32_t vcpuids[]);
+
+/* Like vm_create_default_with_vcpus, but accepts mode as a parameter */
+struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+				    uint64_t extra_mem_pages, uint32_t num_percpu_pages,
+				    void *guest_code, uint32_t vcpuids[]);
+
 /*
  * Adds a vCPU with reasonable defaults (e.g. a stack)
  *
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0d9d2242af2e..e56ed247b71e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -244,8 +244,9 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	return vm;
 }
 
-struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
-				 void *guest_code)
+struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+				    uint64_t extra_mem_pages, uint32_t num_percpu_pages,
+				    void *guest_code, uint32_t vcpuids[])
 {
 	/* The maximum page table size for a memory region will be when the
 	 * smallest pages are used. Considering each page contains x page
@@ -253,10 +254,19 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
 	 * N pages) will be: N/x+N/x^2+N/x^3+... which is definitely smaller
 	 * than N/x*2.
 	 */
-	uint64_t extra_pg_pages = (extra_mem_pages / PTRS_PER_PAGE(min_page_size())) * 2;
+	uint64_t vcpu_pages = (DEFAULT_STACK_PGS + num_percpu_pages) * nr_vcpus;
+	uint64_t extra_pg_pages = (extra_mem_pages + vcpu_pages) /
+				  PTRS_PER_PAGE(min_page_size()) * 2;
+	uint64_t pages = vm_adjust_num_guest_pages(mode,
+				DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages);
 	struct kvm_vm *vm;
+	int i;
+
+	TEST_ASSERT(nr_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
+		    "nr_vcpus = %d too large for host, max-vcpus = %d",
+		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
+	vm = vm_create(mode, pages, O_RDWR);
 
 	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
 
@@ -264,11 +274,27 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
 	vm_create_irqchip(vm);
 #endif
 
-	vm_vcpu_add_default(vm, vcpuid, guest_code);
+	for (i = 0; i < nr_vcpus; ++i)
+		vm_vcpu_add_default(vm, vcpuids ? vcpuids[i] : i, guest_code);
 
 	return vm;
 }
 
+struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_mem_pages,
+					    uint32_t num_percpu_pages, void *guest_code,
+					    uint32_t vcpuids[])
+{
+	return vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, extra_mem_pages,
+				    num_percpu_pages, guest_code, vcpuids);
+}
+
+struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
+				 void *guest_code)
+{
+	return vm_create_default_with_vcpus(1, extra_mem_pages, 0, guest_code,
+					    (uint32_t []){ vcpuid });
+}
+
 /*
  * VM Restart
  *
-- 
2.26.2

