Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664EF533978
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbiEYJFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiEYJFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:05:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 427588DDEA
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yw6Y/YJaz6MWDgAzhUNIURhMRuLfI7K2vVFM83d4yck=;
        b=H8H/j5a0Bt5ZxXqrOPC8XgcDCxo0sAtSF+l/pJszOH9PREx8mToFknbM77WLAPkIuVhz4C
        WB4Rt67xAY5stQUvg6dNHh2IrnNzHGsuFW2xnNQia4I5wQGeRU9+i9sQdRT4U9yxqqRu7e
        6kIV1PXNTAEZuZV6asJUjmZYL0MoWfs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-MOFx0w6nNjuppNV8fMaVIQ-1; Wed, 25 May 2022 05:02:45 -0400
X-MC-Unique: MOFx0w6nNjuppNV8fMaVIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3B78101A54E;
        Wed, 25 May 2022 09:02:44 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CD68400DB3A;
        Wed, 25 May 2022 09:02:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 33/37] KVM: selftests: nSVM: Allocate Hyper-V partition assist and VP assist pages
Date:   Wed, 25 May 2022 11:01:29 +0200
Message-Id: <20220525090133.1264239-34-vkuznets@redhat.com>
In-Reply-To: <20220525090133.1264239-1-vkuznets@redhat.com>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index a25aabd8f5e7..640859b58fd6 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -34,6 +34,16 @@ struct svm_test_data {
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
 
 struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
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

