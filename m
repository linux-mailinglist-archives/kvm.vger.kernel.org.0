Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D435C018F
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiIUP3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiIUP2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:28:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FDA9A9F9
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663773976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2R8YnhofhIu0cC84V4tjqr13/7ooiXFtljFlEkHzNAQ=;
        b=R2RNzpTgUQaMM6nMNwNU2zHnXJfNt+qzcWyn58IX+hJ6X43kzSqhPEgb1lXd4cFq8rXpET
        Tf1i+vxDIQZ4BJe7lTpYjcBTr0KYmlm1fhemVHAdbieN/w58/lsKIVGAqKqDaKz2GxhExp
        klcDPiAI6Oidx987hHhFHWarYaxDiPY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-HowGuEbjMvyFaYboZBRbtw-1; Wed, 21 Sep 2022 11:26:13 -0400
X-MC-Unique: HowGuEbjMvyFaYboZBRbtw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6B97185A7A9;
        Wed, 21 Sep 2022 15:26:12 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9916B2166B29;
        Wed, 21 Sep 2022 15:26:10 +0000 (UTC)
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
Subject: [PATCH v10 36/39] KVM: selftests: Allocate Hyper-V partition assist page
Date:   Wed, 21 Sep 2022 17:24:33 +0200
Message-Id: <20220921152436.3673454-37-vkuznets@redhat.com>
In-Reply-To: <20220921152436.3673454-1-vkuznets@redhat.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to testing Hyper-V L2 TLB flush hypercalls, allocate
so-called Partition assist page.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/hyperv.h | 5 +++++
 tools/testing/selftests/kvm/lib/x86_64/hyperv.c     | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index e00ce9e122f4..e0c0dc4b3d5c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -271,6 +271,11 @@ struct hyperv_test_pages {
 	uint64_t vp_assist_gpa;
 	void *vp_assist;
 
+	/* Partition assist page */
+	void *partition_assist_hva;
+	uint64_t partition_assist_gpa;
+	void *partition_assist;
+
 	/* Enlightened VMCS */
 	void *enlightened_vmcs_hva;
 	uint64_t enlightened_vmcs_gpa;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/hyperv.c b/tools/testing/selftests/kvm/lib/x86_64/hyperv.c
index e44bb5cc8566..e222db65a188 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/hyperv.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/hyperv.c
@@ -19,6 +19,11 @@ vcpu_alloc_hyperv_test_pages(struct kvm_vm *vm, vm_vaddr_t *p_hv_pages_gva)
 	hv->vp_assist_hva = addr_gva2hva(vm, (uintptr_t)hv->vp_assist);
 	hv->vp_assist_gpa = addr_gva2gpa(vm, (uintptr_t)hv->vp_assist);
 
+	/* Setup of a region of guest memory for the partition assist page. */
+	hv->partition_assist = (void *)vm_vaddr_alloc_page(vm);
+	hv->partition_assist_hva = addr_gva2hva(vm, (uintptr_t)hv->partition_assist);
+	hv->partition_assist_gpa = addr_gva2gpa(vm, (uintptr_t)hv->partition_assist);
+
 	/* Setup of a region of guest memory for the enlightened VMCS. */
 	hv->enlightened_vmcs = (void *)vm_vaddr_alloc_page(vm);
 	hv->enlightened_vmcs_hva = addr_gva2hva(vm, (uintptr_t)hv->enlightened_vmcs);
-- 
2.37.3

