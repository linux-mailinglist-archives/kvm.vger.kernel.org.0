Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1470063C89E
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbiK2Tkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235900AbiK2TkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:40:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAD12626
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669750659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ax33lO2rYC4qdqXK9hN6118xGd7ZlQSFY6CuNF4UBj0=;
        b=D/XCJxQkCiCal9eFqeLX2zrMXejXyn1/QuVuU4Kw5waYNDYiZ+3lacAD4szuNGEgMnXuKN
        3yhkbkLdJPqK3TT+yOXGoPo4sDryssu42As4WK9RHsFRvNO724eYQds/S6tayqMzUMT6ro
        7rCbsiEO7aRKbvd5zO6qHMZxtlqXsuA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-KxT3T5GlMzGGlJO3dCad6A-1; Tue, 29 Nov 2022 14:37:36 -0500
X-MC-Unique: KxT3T5GlMzGGlJO3dCad6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00FB81C06EDF;
        Tue, 29 Nov 2022 19:37:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D0B82024CB7;
        Tue, 29 Nov 2022 19:37:31 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 03/11] KVM: nSVM: explicitly raise KVM_REQ_EVENT on nested VM exit if L1 doesn't intercept interrupts
Date:   Tue, 29 Nov 2022 21:37:09 +0200
Message-Id: <20221129193717.513824-4-mlevitsk@redhat.com>
In-Reply-To: <20221129193717.513824-1-mlevitsk@redhat.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the L2 doesn't intercept interrupts, then the KVM will use vmcb02's
V_IRQ for L1 (to detect the interrupt window)

In this case on the nested VM exit KVM might need to copy the V_IRQ bit
from the vmcb02 to the vmcb01, to continue waiting for the
interrupt window.

To make it simple, just raise the KVM_REQ_EVENT request, which
execution will lead to the reenabling of the interrupt
window if needed.

Note that this is a theoretical bug because the KVM already does raise
the KVM_REQ_EVENT request one each nested VM exit because the nested
VM exit resets RFLAGS and the kvm_set_rflags() raises the
KVM_REQ_EVENT request in the response.

However raising this request explicitly, together with
documenting why this is needed, is still preferred.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index aad3145b2f62fe..e891318595113e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1016,6 +1016,31 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
+	/* Note about synchronizing some of int_ctl bits from vmcb02 to vmcb01:
+	 *
+	 * - V_IRQ, V_IRQ_VECTOR, V_INTR_PRIO_MASK, V_IGN_TPR:
+	 * If the L2 doesn't intercept interrupts, then
+	 * (even if the L2 does use virtual interrupt masking),
+	 * KVM will use the vmcb02's V_INTR to detect interrupt window.
+	 *
+	 * In this case, the KVM raises the KVM_REQ_EVENT to ensure that interrupt window
+	 * is not lost and this implicitly copies these bits from vmcb02 to vmcb01
+	 *
+	 * V_TPR:
+	 * If the L2 doesn't use virtual interrupt masking, then the L1's vTPR
+	 * is stored in the vmcb02 but its value doesn't need to be copied from/to
+	 * vmcb01 because it is copied from/to the TPR APIC's register on
+	 * each VM entry/exit.
+	 *
+	 * V_GIF:
+	 * - If the nested vGIF is not used, KVM uses vmcb02's V_GIF for L1's V_GIF,
+	 * however, the L1 vGIF is reset to false on each VM exit, thus
+	 * there is no need to copy it from vmcb02 to vmcb01.
+	 */
+
+	if (!nested_exit_on_intr(svm))
+		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+
 	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
 		svm_copy_lbrs(vmcb12, vmcb02);
 		svm_update_lbrv(vcpu);
-- 
2.26.3

