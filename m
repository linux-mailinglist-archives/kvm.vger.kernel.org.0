Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14AE614DA0
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 16:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiKAPBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 11:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiKAPBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 11:01:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148571DDF4
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iVYjUYFhl/qhwDL5l7si59w32fV51OGyzGqIljVaKlo=;
        b=dF9U2p/hlaxCCk32fHJ5RG8+RkHmdLGgMhHzbr613a9AH+zT0P75MhuiWdTsL+BoLl6BKm
        qLcAwhPmIUe459RmmfRqKgTzl+ynfreBa0DJQHNvX7tQIpELL4tf3UMQrmIA2QpmLyDIYZ
        qoRQGJ2xxGQsrjvhSfdo8vAvr6xhJRo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-z9Zwk__qMQ6qgnSmA2LD7w-1; Tue, 01 Nov 2022 10:56:40 -0400
X-MC-Unique: z9Zwk__qMQ6qgnSmA2LD7w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C83B1C00504;
        Tue,  1 Nov 2022 14:56:34 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22DEEC2DF60;
        Tue,  1 Nov 2022 14:56:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 36/48] KVM: selftests: Drop helpers to read/write page table entries
Date:   Tue,  1 Nov 2022 15:54:14 +0100
Message-Id: <20221101145426.251680-37-vkuznets@redhat.com>
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Drop vm_{g,s}et_page_table_entry() and instead expose the "inner"
helper (was _vm_get_page_table_entry()) that returns a _pointer_ to the
PTE, i.e. let tests directly modify PTEs instead of bouncing through
helpers that just make life difficult.

Opportunsitically use BIT_ULL() in emulator_error_test, and use the
MAXPHYADDR define to set the "rogue" GPA bit instead of open coding the
same value.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  6 ++----
 .../selftests/kvm/lib/x86_64/processor.c      | 21 ++-----------------
 .../kvm/x86_64/emulator_error_test.c          |  6 ++++--
 3 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index dbd75717dc3b..f21d933a2663 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -829,10 +829,8 @@ static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 
 bool kvm_is_tdp_enabled(void);
 
-uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-				 uint64_t vaddr);
-void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-			     uint64_t vaddr, uint64_t pte);
+uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+				  uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 39c4409ef56a..90b35998b0f3 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -241,9 +241,8 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 }
 
-static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm,
-					  struct kvm_vcpu *vcpu,
-					  uint64_t vaddr)
+uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+				  uint64_t vaddr)
 {
 	uint16_t index[4];
 	uint64_t *pml4e, *pdpe, *pde;
@@ -313,22 +312,6 @@ static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm,
 	return &pte[index[0]];
 }
 
-uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-				 uint64_t vaddr)
-{
-	uint64_t *pte = _vm_get_page_table_entry(vm, vcpu, vaddr);
-
-	return *(uint64_t *)pte;
-}
-
-void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-			     uint64_t vaddr, uint64_t pte)
-{
-	uint64_t *new_pte = _vm_get_page_table_entry(vm, vcpu, vaddr);
-
-	*(uint64_t *)new_pte = pte;
-}
-
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	uint64_t *pml4e, *pml4e_start;
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index 236e11755ba6..bde247f3c8a1 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -152,8 +152,9 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	uint64_t gpa, pte;
+	uint64_t *pte;
 	uint64_t *hva;
+	uint64_t gpa;
 	int rc;
 
 	/* Tell stdout not to buffer its content */
@@ -178,8 +179,9 @@ int main(int argc, char *argv[])
 	virt_map(vm, MEM_REGION_GVA, MEM_REGION_GPA, 1);
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 	memset(hva, 0, PAGE_SIZE);
+
 	pte = vm_get_page_table_entry(vm, vcpu, MEM_REGION_GVA);
-	vm_set_page_table_entry(vm, vcpu, MEM_REGION_GVA, pte | (1ull << 36));
+	*pte |= BIT_ULL(MAXPHYADDR);
 
 	vcpu_run(vcpu);
 	process_exit_on_emulation_error(vcpu);
-- 
2.37.3

