Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDC663C89C
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237106AbiK2Tkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237083AbiK2TkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:40:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E793710E9
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669750657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IsK6SeDRcKB0ngx9XBGmKXR4JOxNBat2MjmDlSq9EM0=;
        b=gMxKjVEFh0IXe4i7DkFGVdOK0+hgof2fMK3QRG9bpA0/hKaHFZ0eXrK3INwB6KQlrIdXta
        7eFYR6yrTh1ulGrM/85SVCuY9vaFFNIP4w18s+kb4gQhJlXGsmB5Primhlxizz9xDkA8ed
        20wiwp8JxpCTldiMaBLWfR51zzFaLIs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-m87UuQubOz2LL_yd13l6nA-1; Tue, 29 Nov 2022 14:37:32 -0500
X-MC-Unique: m87UuQubOz2LL_yd13l6nA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03F3D86EB22;
        Tue, 29 Nov 2022 19:37:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43C6A2027061;
        Tue, 29 Nov 2022 19:37:27 +0000 (UTC)
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
Subject: [PATCH v2 02/11] KVM: nSVM: clean up the copying of V_INTR bits from vmcb02 to vmcb12
Date:   Tue, 29 Nov 2022 21:37:08 +0200
Message-Id: <20221129193717.513824-3-mlevitsk@redhat.com>
In-Reply-To: <20221129193717.513824-1-mlevitsk@redhat.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

the V_IRQ and v_TPR bits don't exist when virtual interrupt
masking is not enabled, therefore the KVM should not copy these
bits regardless of V_IRQ intercept.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 37af0338da7c32..aad3145b2f62fe 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -412,24 +412,17 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
  */
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 {
-	u32 mask;
+	u32 mask = 0;
 	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
 	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
 
-	/* Only a few fields of int_ctl are written by the processor.  */
-	mask = V_IRQ_MASK | V_TPR_MASK;
-	if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
-	    svm_is_intercept(svm, INTERCEPT_VINTR)) {
-		/*
-		 * In order to request an interrupt window, L0 is usurping
-		 * svm->vmcb->control.int_ctl and possibly setting V_IRQ
-		 * even if it was clear in L1's VMCB.  Restoring it would be
-		 * wrong.  However, in this case V_IRQ will remain true until
-		 * interrupt_window_interception calls svm_clear_vintr and
-		 * restores int_ctl.  We can just leave it aside.
-		 */
-		mask &= ~V_IRQ_MASK;
-	}
+	/*
+	 * Only a few fields of int_ctl are written by the processor.
+	 * Copy back only the bits that are passed through to the L2.
+	 */
+
+	if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
+		mask = V_IRQ_MASK | V_TPR_MASK;
 
 	if (nested_vgif_enabled(svm))
 		mask |= V_GIF_MASK;
-- 
2.26.3

