Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCAD4614DAF
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 16:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiKAPC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 11:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiKAPCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 11:02:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03931CFC9
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PNvFTxM57Y73cI9t4AF88vWy8qZeNx5swgKu92YcL80=;
        b=TNzCJxflSJ+RTdbUsJbZSvE7eL1zLDcAbBLtULiRojq7SvO7ygPwWFkiDxW0ABUZWXlEk1
        dVk6WDeTTR0yR5+/+u3ZTk7TX4FtnS7gppYw/4NKJeQJYFnHlGUTPB+TqZYaQ3TvN1nx91
        jRH6KeZaUpaz1/yZHJBRufuKC2mrstA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-7SUJriguPcyMk6Bex0JHtw-1; Tue, 01 Nov 2022 10:56:45 -0400
X-MC-Unique: 7SUJriguPcyMk6Bex0JHtw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45A18857F92;
        Tue,  1 Nov 2022 14:56:45 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23687C15BA5;
        Tue,  1 Nov 2022 14:56:43 +0000 (UTC)
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
Subject: [PATCH v13 41/48] KVM: selftests: Split off load_evmcs() from load_vmcs()
Date:   Tue,  1 Nov 2022 15:54:19 +0100
Message-Id: <20221101145426.251680-42-vkuznets@redhat.com>
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to putting Hyper-V specific test pages to a dedicated
struct, move eVMCS load logic from load_vmcs(). Tests call load_vmcs()
directly and the only one which needs 'enlightened' version is
evmcs_test so there's not much gain in having this merged.

Temporary pass both GPA and HVA to load_evmcs().

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/evmcs.h      | 10 ++++++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 33 ++++++++-----------
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  4 +--
 3 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
index 2530b5aeb4ba..59b60d45b8f6 100644
--- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -256,6 +256,16 @@ static inline int evmcs_vmptrld(uint64_t vmcs_pa, void *vmcs)
 	return 0;
 }
 
+static inline bool load_evmcs(uint64_t enlightened_vmcs_gpa, void *enlightened_vmcs)
+{
+	if (evmcs_vmptrld(enlightened_vmcs_gpa, enlightened_vmcs))
+		return false;
+
+	current_evmcs->revision_id = EVMCS_VERSION;
+
+	return true;
+}
+
 static inline int evmcs_vmptrst(uint64_t *value)
 {
 	*value = current_vp_assist->current_nested_vmcs &
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index d21049c38fc5..40e4f427a3ec 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -171,26 +171,19 @@ bool prepare_for_vmx_operation(struct vmx_pages *vmx)
 
 bool load_vmcs(struct vmx_pages *vmx)
 {
-	if (!enable_evmcs) {
-		/* Load a VMCS. */
-		*(uint32_t *)(vmx->vmcs) = vmcs_revision();
-		if (vmclear(vmx->vmcs_gpa))
-			return false;
-
-		if (vmptrld(vmx->vmcs_gpa))
-			return false;
-
-		/* Setup shadow VMCS, do not load it yet. */
-		*(uint32_t *)(vmx->shadow_vmcs) =
-			vmcs_revision() | 0x80000000ul;
-		if (vmclear(vmx->shadow_vmcs_gpa))
-			return false;
-	} else {
-		if (evmcs_vmptrld(vmx->enlightened_vmcs_gpa,
-				  vmx->enlightened_vmcs))
-			return false;
-		current_evmcs->revision_id = EVMCS_VERSION;
-	}
+	/* Load a VMCS. */
+	*(uint32_t *)(vmx->vmcs) = vmcs_revision();
+	if (vmclear(vmx->vmcs_gpa))
+		return false;
+
+	if (vmptrld(vmx->vmcs_gpa))
+		return false;
+
+	/* Setup shadow VMCS, do not load it yet. */
+	*(uint32_t *)(vmx->shadow_vmcs) =
+		vmcs_revision() | 0x80000000ul;
+	if (vmclear(vmx->shadow_vmcs_gpa))
+		return false;
 
 	return true;
 }
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 9007fb04343b..5a4c8b1873aa 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -81,10 +81,10 @@ void guest_code(struct vmx_pages *vmx_pages)
 	enable_vp_assist(vmx_pages->vp_assist_gpa, vmx_pages->vp_assist);
 	evmcs_enable();
 
-	GUEST_ASSERT(vmx_pages->vmcs_gpa);
 	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
 	GUEST_SYNC(3);
-	GUEST_ASSERT(load_vmcs(vmx_pages));
+	GUEST_ASSERT(load_evmcs(vmx_pages->enlightened_vmcs_gpa,
+				vmx_pages->enlightened_vmcs));
 	GUEST_ASSERT(vmptrstz() == vmx_pages->enlightened_vmcs_gpa);
 
 	GUEST_SYNC(4);
-- 
2.37.3

