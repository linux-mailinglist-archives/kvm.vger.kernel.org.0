Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE42574FFD
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 15:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240310AbiGNNwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 09:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240039AbiGNNve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 09:51:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ACEDF62A58
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 06:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657806649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5BFPbyIVPmSAEWrA1rlVTMYvQevHVvz/gcJpVhxpkEE=;
        b=Cfau0fJetcph95Ns8cG7wK36hsyYJuOv/lScJY43/G6khPPGszbVh9qC25Iq3/+R6Zw+LT
        xbHIyEumvHbnqz54zaTqUOvlFFJJnXe9fJxHyXHr34OrCOSeobDngVjfRAxFG2MS6DK77J
        7pN+IqwZgqsG9u3WTfg9vDfoKuXTk54=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-OugeQcMUN4Oe5Vs-gZh0-A-1; Thu, 14 Jul 2022 09:50:44 -0400
X-MC-Unique: OugeQcMUN4Oe5Vs-gZh0-A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D961729DD98F;
        Thu, 14 Jul 2022 13:50:43 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9B742166B2B;
        Thu, 14 Jul 2022 13:50:41 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 30/39] KVM: selftests: Export _vm_get_page_table_entry()
Date:   Thu, 14 Jul 2022 15:49:20 +0200
Message-Id: <20220714134929.1125828-31-vkuznets@redhat.com>
In-Reply-To: <20220714134929.1125828-1-vkuznets@redhat.com>
References: <20220714134929.1125828-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 ++
 tools/testing/selftests/kvm/lib/x86_64/processor.c     | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index a68439d660eb..0bf5c2d92296 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -617,6 +617,8 @@ static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 	return kvm_asm_safe("wrmsr", "A"(val), "c"(msr));
 }
 
+uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+				   uint64_t vaddr);
 uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 				 uint64_t vaddr);
 void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 1a32b1c75e9a..3b4e89913fc1 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -212,9 +212,8 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
 }
 
-static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm,
-					  struct kvm_vcpu *vcpu,
-					  uint64_t vaddr)
+uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+				   uint64_t vaddr)
 {
 	uint16_t index[4];
 	uint64_t *pml4e, *pdpe, *pde;
-- 
2.35.3

