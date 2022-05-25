Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746FD53395C
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbiEYJG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242333AbiEYJFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:05:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DCAB8BD2C
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=da7nS1EdTAInnQ5mYClBlXrsAp+Wl4jzAQ2Ex+71s1o=;
        b=jMRX6pPDWj643yEW9VITBFZCq6hU3P7PTlDyWoaThACt+2ORbgFyxkaOn8RQI5FqaAsQA1
        7buBBTZojW9dPSKt+PZDuFMbFzMA7HdBCI+sy+ldTFQZAIaOH4lxSNdWykdqpIebz0aiKa
        QxMg7FmJL8PzLs6kDKUUwBU2iPqDgMk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-Z9YWCNDCNQWky5B8JW6jHw-1; Wed, 25 May 2022 05:02:43 -0400
X-MC-Unique: Z9YWCNDCNQWky5B8JW6jHw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1FE83C01D9C;
        Wed, 25 May 2022 09:02:42 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26CDE40CFD0A;
        Wed, 25 May 2022 09:02:41 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 32/37] KVM: selftests: nVMX: Allocate Hyper-V partition assist page
Date:   Wed, 25 May 2022 11:01:28 +0200
Message-Id: <20220525090133.1264239-33-vkuznets@redhat.com>
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

In preparation to testing Hyper-V L2 TLB flush hypercalls, allocate
so-called Partition assist page and link it to 'struct vmx_pages'.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/vmx.h | 4 ++++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c     | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 583ceb0d1457..f99922ca8259 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -567,6 +567,10 @@ struct vmx_pages {
 	uint64_t enlightened_vmcs_gpa;
 	void *enlightened_vmcs;
 
+	void *partition_assist_hva;
+	uint64_t partition_assist_gpa;
+	void *partition_assist;
+
 	void *eptp_hva;
 	uint64_t eptp_gpa;
 	void *eptp;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index d089d8b850b5..3db21e0e1a8f 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -124,6 +124,13 @@ vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva)
 	vmx->enlightened_vmcs_gpa =
 		addr_gva2gpa(vm, (uintptr_t)vmx->enlightened_vmcs);
 
+	/* Setup of a region of guest memory for the partition assist page. */
+	vmx->partition_assist = (void *)vm_vaddr_alloc_page(vm);
+	vmx->partition_assist_hva =
+		addr_gva2hva(vm, (uintptr_t)vmx->partition_assist);
+	vmx->partition_assist_gpa =
+		addr_gva2gpa(vm, (uintptr_t)vmx->partition_assist);
+
 	*p_vmx_gva = vmx_gva;
 	return vmx;
 }
-- 
2.35.3

