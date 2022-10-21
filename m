Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8FA607B5B
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiJUPka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiJUPjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:39:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3499026C44F
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666366635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tb21lXhzgRX9MHFjr+LwZeM+AE4z+ukO80KSKbm0cYE=;
        b=S04a98nD8Tju7QJG2NYzTpazMW91+1nVCFZ0v7axGrKDJhKxOJ5bMir5Fvoys09Ah8H0Vu
        9NF0RXvA93IpH5OC7M4yfjd2bdnypef9W3gmGF21SY/fe1iKKkpG0s+AWHx3tQBWAKAHAy
        fFgdFSbqVBOf0lygQGXPX/sgzzoPCFk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-UmRB-F4DOn2U1TJ59auVwQ-1; Fri, 21 Oct 2022 11:37:09 -0400
X-MC-Unique: UmRB-F4DOn2U1TJ59auVwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A2AB1C0755E;
        Fri, 21 Oct 2022 15:37:08 +0000 (UTC)
Received: from ovpn-192-65.brq.redhat.com (ovpn-192-65.brq.redhat.com [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E31E640CA41F;
        Fri, 21 Oct 2022 15:37:05 +0000 (UTC)
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
Subject: [PATCH v12 41/46] KVM: selftests: Split off load_evmcs() from load_vmcs()
Date:   Fri, 21 Oct 2022 17:35:16 +0200
Message-Id: <20221021153521.1216911-42-vkuznets@redhat.com>
In-Reply-To: <20221021153521.1216911-1-vkuznets@redhat.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

