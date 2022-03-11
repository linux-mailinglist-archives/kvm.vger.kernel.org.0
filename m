Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474A24D6555
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 16:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbiCKPyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 10:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350332AbiCKPxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 10:53:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB1161CDDC4
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 07:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647013898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=126nTNRXhHFrXixY2xtOW/3ENn+8ieWmJUoTJhv6R28=;
        b=QT2J5mj5wRoD1GbwJ1cZKilFI5hEtQhPSvZxRKZjqQvlXPVNiP3oKEsRFtCU7ONRT0KBia
        SZWGFpSmFHb9n/wk/+896/IiK1su5HqEaU2guHBw1+pxdrs6sL26jXEqtIS7v/EIb2ebpA
        cGqcHcJC1xclBIVJZ+XMlXson824+X0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-XdTkIyCrMIeIFwJYcyFaUA-1; Fri, 11 Mar 2022 10:51:35 -0500
X-MC-Unique: XdTkIyCrMIeIFwJYcyFaUA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6ADE6801AFE;
        Fri, 11 Mar 2022 15:51:34 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA657785FD;
        Fri, 11 Mar 2022 15:51:31 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 27/31] KVM: selftests: nSVM: Allocate Hyper-V partition assist and VP assist pages
Date:   Fri, 11 Mar 2022 16:49:39 +0100
Message-Id: <20220311154943.2299191-28-vkuznets@redhat.com>
In-Reply-To: <20220311154943.2299191-1-vkuznets@redhat.com>
References: <20220311154943.2299191-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to testing Hyper-V Direct TLB flush hypercalls,
allocate VP assist and Partition assist pages and link them to 'struct
svm_test_data'.

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
2.35.1

