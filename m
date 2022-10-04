Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4365F435D
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 14:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJDMoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 08:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiJDMnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 08:43:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3495EDCC
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 05:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664887293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DfCbut931nsMwO9exlDYECuwu4P0AtTCrDWGz03UX9o=;
        b=TudU3dWlZ5hYwBsPm3Is3FBmKOvxPpnZ38+6sW4zxgHtQNWqyok8BcohaybiPX3Gvjj39l
        91FwzaNy+xMFzU5eFDz+UqHoVx0txL+fgsmIjzYnAeC2xqpnxejr99/uiVezvCSfSTFz2W
        WnDvYHb+MkpmW0rb/OOXdHOmgDTCELs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-n2lQx1TkP2mrwdAITL5R_g-1; Tue, 04 Oct 2022 08:41:29 -0400
X-MC-Unique: n2lQx1TkP2mrwdAITL5R_g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16A4A1C08967;
        Tue,  4 Oct 2022 12:41:29 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8499A23177;
        Tue,  4 Oct 2022 12:41:26 +0000 (UTC)
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
Subject: [PATCH v11 36/46] KVM: selftests: Drop helpers to read/write page table entries
Date:   Tue,  4 Oct 2022 14:39:46 +0200
Message-Id: <20221004123956.188909-37-vkuznets@redhat.com>
In-Reply-To: <20221004123956.188909-1-vkuznets@redhat.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
---
 .../selftests/kvm/include/x86_64/processor.h  |  6 ++----
 .../selftests/kvm/lib/x86_64/processor.c      | 21 ++-----------------
 .../kvm/x86_64/emulator_error_test.c          |  6 ++++--
 3 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 1c7805de8c27..248e14d1dd6b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -827,10 +827,8 @@ static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
 }
 
-uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-				 uint64_t vaddr);
-void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-			     uint64_t vaddr, uint64_t pte);
+uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+				  uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 2e6e61bbe81b..5e4bbe71dbff 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -214,9 +214,8 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
 }
 
-static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm,
-					  struct kvm_vcpu *vcpu,
-					  uint64_t vaddr)
+uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+				  uint64_t vaddr)
 {
 	uint16_t index[4];
 	uint64_t *pml4e, *pdpe, *pde;
@@ -286,22 +285,6 @@ static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm,
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

