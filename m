Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF174533943
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240030AbiEYJF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241457AbiEYJEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:04:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71532A0D23
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t4Hrsu9vaLNBzegX0s8dWoRk8Rsa/7rUxISFdwQHSFk=;
        b=K79kKcu6noJzCfEQYltd8l3NQTuBpmJ5mdarxwSl5VLbEw3dokfxQDIQ5+sDIfv6Oo1ZEu
        M7ZrNn+jqNodhKuYlp3dijpTfaFeuUAzgRFuUs9RIhCdSCH4KbWGuFON6BwnUiSlTh7sSj
        O2FDUc3cNZJpaU5nUaWaGu74BQ/7iU8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-pCunkXMePrKHkUX-t0802A-1; Wed, 25 May 2022 05:02:37 -0400
X-MC-Unique: pCunkXMePrKHkUX-t0802A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB016811E76;
        Wed, 25 May 2022 09:02:36 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FB02405D4BF;
        Wed, 25 May 2022 09:02:34 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 29/37] KVM: selftests: Export _vm_get_page_table_entry() and struct pageTableEntry/pageUpperEntry definitions
Date:   Wed, 25 May 2022 11:01:25 +0200
Message-Id: <20220525090133.1264239-30-vkuznets@redhat.com>
In-Reply-To: <20220525090133.1264239-1-vkuznets@redhat.com>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make it possible for tests to mangle guest's page table entries.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 34 ++++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 36 ++-----------------
 2 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 9ad7602a257b..046807b8ea4f 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -441,6 +441,40 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
+/* Virtual translation table structure declarations */
+struct pageUpperEntry {
+	uint64_t present:1;
+	uint64_t writable:1;
+	uint64_t user:1;
+	uint64_t write_through:1;
+	uint64_t cache_disable:1;
+	uint64_t accessed:1;
+	uint64_t ignored_06:1;
+	uint64_t page_size:1;
+	uint64_t ignored_11_08:4;
+	uint64_t pfn:40;
+	uint64_t ignored_62_52:11;
+	uint64_t execute_disable:1;
+};
+
+struct pageTableEntry {
+	uint64_t present:1;
+	uint64_t writable:1;
+	uint64_t user:1;
+	uint64_t write_through:1;
+	uint64_t cache_disable:1;
+	uint64_t accessed:1;
+	uint64_t dirty:1;
+	uint64_t reserved_07:1;
+	uint64_t global:1;
+	uint64_t ignored_11_09:3;
+	uint64_t pfn:40;
+	uint64_t ignored_62_52:11;
+	uint64_t execute_disable:1;
+};
+
+struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
+						uint64_t vaddr);
 uint64_t vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr);
 void vm_set_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr,
 			     uint64_t pte);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9f000dfb5594..f8090b521357 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -19,38 +19,6 @@
 
 vm_vaddr_t exception_handlers;
 
-/* Virtual translation table structure declarations */
-struct pageUpperEntry {
-	uint64_t present:1;
-	uint64_t writable:1;
-	uint64_t user:1;
-	uint64_t write_through:1;
-	uint64_t cache_disable:1;
-	uint64_t accessed:1;
-	uint64_t ignored_06:1;
-	uint64_t page_size:1;
-	uint64_t ignored_11_08:4;
-	uint64_t pfn:40;
-	uint64_t ignored_62_52:11;
-	uint64_t execute_disable:1;
-};
-
-struct pageTableEntry {
-	uint64_t present:1;
-	uint64_t writable:1;
-	uint64_t user:1;
-	uint64_t write_through:1;
-	uint64_t cache_disable:1;
-	uint64_t accessed:1;
-	uint64_t dirty:1;
-	uint64_t reserved_07:1;
-	uint64_t global:1;
-	uint64_t ignored_11_09:3;
-	uint64_t pfn:40;
-	uint64_t ignored_62_52:11;
-	uint64_t execute_disable:1;
-};
-
 void regs_dump(FILE *stream, struct kvm_regs *regs,
 	       uint8_t indent)
 {
@@ -282,8 +250,8 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	__virt_pg_map(vm, vaddr, paddr, X86_PAGE_SIZE_4K);
 }
 
-static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
-						       uint64_t vaddr)
+struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
+						uint64_t vaddr)
 {
 	uint16_t index[4];
 	struct pageUpperEntry *pml4e, *pdpe, *pde;
-- 
2.35.3

