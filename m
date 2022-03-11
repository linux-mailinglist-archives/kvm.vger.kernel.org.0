Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2F64D652F
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 16:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350048AbiCKPwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 10:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349927AbiCKPwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 10:52:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8CB341C9B47
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 07:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647013859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LgKxZ+60OBmBTv0uCZcgzTAGPMwScB8wIZWfQnzZcjo=;
        b=VCh8l5ZVXySlwvMyDbTH+sUAt39S4DPF0zq2C1o2kEMNoQ22IEr6LGmyN2tZysTWkHmog0
        yU0H7QBYMQuDY5fXG5CcQl7T/5pXrRlGUl95xpmstUrwX3E2MdO3ukGp7ExTEoUtbq4s4o
        aqI42u/B9EMtnF/Cad9CYaEJ2u/WZY8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-2ueYG3m-ODO_eMOnBPB-TA-1; Fri, 11 Mar 2022 10:50:56 -0500
X-MC-Unique: 2ueYG3m-ODO_eMOnBPB-TA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C51ED1006AA6;
        Fri, 11 Mar 2022 15:50:54 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53F1A866D4;
        Fri, 11 Mar 2022 15:50:52 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 23/31] KVM: selftests: Make it possible to replace PTEs with __virt_pg_map()
Date:   Fri, 11 Mar 2022 16:49:35 +0100
Message-Id: <20220311154943.2299191-24-vkuznets@redhat.com>
In-Reply-To: <20220311154943.2299191-1-vkuznets@redhat.com>
References: <20220311154943.2299191-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__virt_pg_map() makes an assumption that leaf PTE is not present. This
is not suitable if the test wants to replace an already present
PTE. Hyper-V PV TLB flush test is going to need that.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c     | 6 +++---
 tools/testing/selftests/kvm/x86_64/mmu_role_test.c     | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 4962cd0ceacd..1a3550c99eb1 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -468,7 +468,7 @@ enum x86_page_size {
 	X86_PAGE_SIZE_1G,
 };
 void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		   enum x86_page_size page_size);
+		   enum x86_page_size page_size, bool replace);
 
 /*
  * Basic CPU control in CR0
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9f000dfb5594..20df3e84d777 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -229,7 +229,7 @@ static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
 }
 
 void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		   enum x86_page_size page_size)
+		   enum x86_page_size page_size, bool replace)
 {
 	const uint64_t pg_size = 1ull << ((page_size * 9) + 12);
 	struct pageUpperEntry *pml4e, *pdpe, *pde;
@@ -270,7 +270,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 	/* Fill in page table entry. */
 	pte = virt_get_pte(vm, pde->pfn, vaddr, 0);
-	TEST_ASSERT(!pte->present,
+	TEST_ASSERT(replace || !pte->present,
 		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
 	pte->pfn = paddr >> vm->page_shift;
 	pte->writable = true;
@@ -279,7 +279,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	__virt_pg_map(vm, vaddr, paddr, X86_PAGE_SIZE_4K);
+	__virt_pg_map(vm, vaddr, paddr, X86_PAGE_SIZE_4K, false);
 }
 
 static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
diff --git a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
index da2325fcad87..e3fdf320b9f4 100644
--- a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
@@ -35,7 +35,7 @@ static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
 	run = vcpu_state(vm, VCPU_ID);
 
 	/* Map 1gb page without a backing memlot. */
-	__virt_pg_map(vm, MMIO_GPA, MMIO_GPA, X86_PAGE_SIZE_1G);
+	__virt_pg_map(vm, MMIO_GPA, MMIO_GPA, X86_PAGE_SIZE_1G, false);
 
 	r = _vcpu_run(vm, VCPU_ID);
 
-- 
2.35.1

