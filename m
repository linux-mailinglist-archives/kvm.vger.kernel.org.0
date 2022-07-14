Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11859575004
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 15:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240346AbiGNNwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 09:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240173AbiGNNvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 09:51:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA8F162A6F
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 06:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657806656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PcXj7rF+YNeWDy75jVAivm7WbSpMYmPCUqIi3ZpKFPs=;
        b=Vto+7pWjchd2laXxJloFqSUeCwDrVTcRETWZT+8rk5Ksp93mDjKtOhHiEFfve7CYhxzktO
        bQd16pOlGPIA8Xax8F6FvSQE4rFhKYZosGUvbDN4PB9eIz5OBOX5BacPMPBenDmA5mskXn
        XCHVgJJmHN9ynl+ThGvpFrK8METUEfg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-pOrfX_VfMl--0DEhCcmt0g-1; Thu, 14 Jul 2022 09:50:54 -0400
X-MC-Unique: pOrfX_VfMl--0DEhCcmt0g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D83B803301;
        Thu, 14 Jul 2022 13:50:53 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56BB12166B26;
        Thu, 14 Jul 2022 13:50:51 +0000 (UTC)
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
Subject: [PATCH v8 34/39] KVM: selftests: nSVM: Allocate Hyper-V partition assist and VP assist pages
Date:   Thu, 14 Jul 2022 15:49:24 +0200
Message-Id: <20220714134929.1125828-35-vkuznets@redhat.com>
In-Reply-To: <20220714134929.1125828-1-vkuznets@redhat.com>
References: <20220714134929.1125828-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 37e9c0a923e0..98a47bf4cb2f 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -47,6 +47,16 @@ vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
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

