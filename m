Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A8753E3A3
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 10:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiFFIjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 04:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiFFIi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 04:38:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42BDF32077
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 01:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654504705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0KF+8ImE87X/jRor6TysxHRJbU1o17Pa9uwwIhivVEs=;
        b=hoqct/KTbO5JjuS7ZIQpUhtxZSU2J7EfpOxVrUBg0XitApxrbWQH0XCdPvTrO66hyfb+Qy
        ayNITx0w5gZ0extvaiKfbhQKLomvvkEPsLrhF9K2k25B4UUwQUURQ7YuE/KHSaFfpav/kD
        lOVCZK87ll65OHUL/NEFeklWXMEjKlo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-edu4CYwdO5WYVqYam7JHQg-1; Mon, 06 Jun 2022 04:38:19 -0400
X-MC-Unique: edu4CYwdO5WYVqYam7JHQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F01C23C19021;
        Mon,  6 Jun 2022 08:38:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C86D31121314;
        Mon,  6 Jun 2022 08:38:16 +0000 (UTC)
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
Subject: [PATCH v6 34/38] KVM: selftests: nSVM: Allocate Hyper-V partition assist and VP assist pages
Date:   Mon,  6 Jun 2022 10:36:51 +0200
Message-Id: <20220606083655.2014609-35-vkuznets@redhat.com>
In-Reply-To: <20220606083655.2014609-1-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to testing Hyper-V L2 TLB flush hypercalls, allocate VP
assist and Partition assist pages and link them to 'struct svm_test_data'.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/svm_util.h | 10 ++++++++++
 tools/testing/selftests/kvm/lib/x86_64/svm.c          | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index 136ba6a5d027..3922e4842c68 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -36,6 +36,16 @@ struct svm_test_data {
 	void *msr; /* gva */
 	void *msr_hva;
 	uint64_t msr_gpa;
+
+	/* Hyper-V VP assist page */
+	void *vp_assist; /* gva */
+	void *vp_assist_hva;
+	uint64_t vp_assist_gpa;
+
+	/* Hyper-V Partition assist page */
+	void *partition_assist; /* gva */
+	void *partition_assist_hva;
+	uint64_t partition_assist_gpa;
 };
 
 #define stgi()			\
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 736ee4a23df6..c284e8f87f5c 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -48,6 +48,16 @@ vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
 	svm->msr_gpa = addr_gva2gpa(vm, (uintptr_t)svm->msr);
 	memset(svm->msr_hva, 0, getpagesize());
 
+	svm->vp_assist = (void *)vm_vaddr_alloc_page(vm);
+	svm->vp_assist_hva = addr_gva2hva(vm, (uintptr_t)svm->vp_assist);
+	svm->vp_assist_gpa = addr_gva2gpa(vm, (uintptr_t)svm->vp_assist);
+	memset(svm->vp_assist_hva, 0, getpagesize());
+
+	svm->partition_assist = (void *)vm_vaddr_alloc_page(vm);
+	svm->partition_assist_hva = addr_gva2hva(vm, (uintptr_t)svm->partition_assist);
+	svm->partition_assist_gpa = addr_gva2gpa(vm, (uintptr_t)svm->partition_assist);
+	memset(svm->partition_assist_hva, 0, getpagesize());
+
 	*p_svm_gva = svm_gva;
 	return svm;
 }
-- 
2.35.3

