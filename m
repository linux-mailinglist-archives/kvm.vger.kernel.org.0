Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64777588DCD
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238544AbiHCNtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238545AbiHCNsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:48:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76B41474C2
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 06:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659534426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gv2dEODC9f2+rLN3L5pL6kP5BktIUaDPg1j5DNPtWFo=;
        b=dqf6xGvssiQBa84FX6l59U1cBm9MUAiAUefXgGFzFtr7YFDRkS2ojnWaJi7R2FZBLh00rL
        /h+HZC725yaDUooUgtQjyW1m7ugzumK15iKD9mnI/536jnrB+O3n6hN/nsL1D6iUbDTaEl
        r/yZ7K/PG5xrt1FBHlRJagOTNWwXcxY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-EY80FRMhMPWdKecGcmt3vQ-1; Wed, 03 Aug 2022 09:47:05 -0400
X-MC-Unique: EY80FRMhMPWdKecGcmt3vQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 873551C06900;
        Wed,  3 Aug 2022 13:47:04 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2A7C2166B26;
        Wed,  3 Aug 2022 13:47:01 +0000 (UTC)
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
Subject: [PATCH v9 35/40] KVM: selftests: Split off load_evmcs() from load_vmcs()
Date:   Wed,  3 Aug 2022 15:47:01 +0200
Message-Id: <20220803134701.399541-1-vkuznets@redhat.com>
In-Reply-To: <20220803134110.397885-1-vkuznets@redhat.com>
References: <20220803134110.397885-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/evmcs.h      | 10 ++++++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 33 ++++++++-----------
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  4 +--
 3 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
index d91e5cc3feb9..77b2bb8de96e 100644
--- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -245,6 +245,16 @@ static inline int evmcs_vmptrld(uint64_t vmcs_pa, void *vmcs)
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
index 80a568c439b8..f8acbc7c8d7d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -169,26 +169,19 @@ bool prepare_for_vmx_operation(struct vmx_pages *vmx)
 
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
2.35.3

