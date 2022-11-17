Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B1362DE42
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 15:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240438AbiKQOed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 09:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240385AbiKQOeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 09:34:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7597C004
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 06:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668695583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Frw/bhnQ/fgaTcwMRmhjoEhY2NlH0mLgodVAsiEeP10=;
        b=ZbfD0TAFdxgbXlaYbMuXVt4h9fN7ZoWK6zCGHySbHicXxozAzkN2AqyKMWRWZEaGrvT3me
        Hm29tZcqj8Unt217SKEhKFYC5lJCDdKcMlm6/IKqbgd/K1F8ChrBMcuW03bfTkvuaLUMy6
        iYXEQ6yCaQjWDDCH82vTiOBZOwdfv1I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-CYSwL3jhOAizB5te_RPptQ-1; Thu, 17 Nov 2022 09:32:59 -0500
X-MC-Unique: CYSwL3jhOAizB5te_RPptQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F9D2185A794;
        Thu, 17 Nov 2022 14:32:58 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19A852166B29;
        Thu, 17 Nov 2022 14:32:54 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 03/13] KVM: nSVM: rename nested_sync_control_from_vmcb02 to nested_sync_int_ctl_from_vmcb02
Date:   Thu, 17 Nov 2022 16:32:32 +0200
Message-Id: <20221117143242.102721-4-mlevitsk@redhat.com>
In-Reply-To: <20221117143242.102721-1-mlevitsk@redhat.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The nested_sync_control_from_vmcb02 name is misleading as there
are many fields which are modified by the CPU and need to be written back
to vmcb12.

This function only copies some int_ctl bits and thecevent_inj*
fields.

Make it copy only these int_ctl bits and rename the function.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 91a51e75717dca..54eb152e2b60b6 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -404,15 +404,13 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
 }
 
 /*
- * Synchronize fields that are written by the processor, so that
+ * Synchronize int_ctl fields that are written by the processor, so that
  * they can be copied back into the vmcb12.
  */
-static void nested_sync_control_from_vmcb02(struct vcpu_svm *svm,
+static void nested_sync_int_ctl_from_vmcb02(struct vcpu_svm *svm,
 					    struct vmcb *vmcb12)
 {
 	u32 mask;
-	vmcb12->control.event_inj      = svm->vmcb->control.event_inj;
-	vmcb12->control.event_inj_err  = svm->vmcb->control.event_inj_err;
 
 	/* Only a few fields of int_ctl are written by the processor.  */
 	mask = V_IRQ_MASK | V_TPR_MASK;
@@ -986,7 +984,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
 		nested_save_pending_event_to_vmcb12(svm, vmcb12);
 
-	nested_sync_control_from_vmcb02(svm, vmcb12);
+	nested_sync_int_ctl_from_vmcb02(svm, vmcb12);
+
+	vmcb12->control.event_inj      = svm->vmcb->control.event_inj;
+	vmcb12->control.event_inj_err  = svm->vmcb->control.event_inj_err;
 
 	if (svm->nrips_enabled)
 		vmcb12->control.next_rip  = vmcb02->control.next_rip;
-- 
2.34.3

