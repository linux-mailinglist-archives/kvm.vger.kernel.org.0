Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC76A536552
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 17:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354105AbiE0P6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 11:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354021AbiE0P5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 11:57:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DE7CC03A6
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 08:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653667029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RZJZWfsaByLj0ij8xQqPbsK2IaQ+e2uUS77uqtBhMFM=;
        b=OwMtOyV1xtr+CsD204LD+kAki7uxhIUq67Y906/X6bmslUX1Vt2dI/uWlIAytqz86uvytb
        EmKkKEu11Ns7uwoQwoqw5Qr14OATqYWrGGxtDeDilX77FCI2xgC6aumvq6gq26fqijJmI3
        XdVgku05RNNdrVSiQIWYSInxaA1b8eU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-tHEDPbcbPs6HXRL3C8C4EQ-1; Fri, 27 May 2022 11:57:08 -0400
X-MC-Unique: tHEDPbcbPs6HXRL3C8C4EQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3F64101A54E;
        Fri, 27 May 2022 15:57:07 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B50372166B26;
        Fri, 27 May 2022 15:57:05 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 29/37] KVM: selftests: Export _vm_get_page_table_entry()
Date:   Fri, 27 May 2022 17:55:38 +0200
Message-Id: <20220527155546.1528910-30-vkuznets@redhat.com>
In-Reply-To: <20220527155546.1528910-1-vkuznets@redhat.com>
References: <20220527155546.1528910-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make it possible for tests to mangle guest's page table entries in
addition to just getting them (available with vm_get_page_table_entry()).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 1 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c     | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 9ac244fdce73..76cfd7f70add 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -475,6 +475,7 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
+uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr);
 uint64_t vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr);
 void vm_set_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr,
 			     uint64_t pte);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 33ea5e9955d9..dfe54a970410 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -246,8 +246,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	__virt_pg_map(vm, vaddr, paddr, X86_PAGE_SIZE_4K);
 }
 
-static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
-						       uint64_t vaddr)
+uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr)
 {
 	uint16_t index[4];
 	uint64_t *pml4e, *pdpe, *pde;
-- 
2.35.3

