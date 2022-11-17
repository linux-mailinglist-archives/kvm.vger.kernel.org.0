Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC53E62DE47
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 15:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240452AbiKQOei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 09:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240421AbiKQOeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 09:34:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420BF5F92
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 06:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668695605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nE6kIG2lOyCUTV0632EqZY8Sms9KZYxObW/NdTbq8mw=;
        b=dGeB3JuNAxRiVorKkkBCGWdAHtP1qO3nZC1z4+YoXBPs9IpwL42zT3E+tRXFApd1GmtP4v
        JqhE30j6aASLIvSPkhylDjEpYeCMckJyC3xDubNXu6L5TmcnKiHGkUYPI1GCTQQhNAuHFC
        3IZcwLkwdvSbINBK6VTeT7jgedgcYqA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-aDa9ab7dNnihyLfs71VXhQ-1; Thu, 17 Nov 2022 09:33:21 -0500
X-MC-Unique: aDa9ab7dNnihyLfs71VXhQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D69B2811E75;
        Thu, 17 Nov 2022 14:33:20 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F8022166B29;
        Thu, 17 Nov 2022 14:33:17 +0000 (UTC)
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
Subject: [PATCH 09/13] KVM: SVM: allow NMI window with vNMI
Date:   Thu, 17 Nov 2022 16:32:38 +0200
Message-Id: <20221117143242.102721-10-mlevitsk@redhat.com>
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

When the vNMI is enabled, the only case when the KVM will use an NMI
window is when the vNMI injection is pending.

In this case on next IRET/RSM/STGI, the injection has to be complete
and a new NMI can be injected.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cfec4c98bb589b..eaa30f8ace518d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2477,7 +2477,10 @@ static int iret_interception(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	++vcpu->stat.nmi_window_exits;
-	vcpu->arch.hflags |= HF_IRET_MASK;
+
+	if (!is_vnmi_enabled(svm))
+		vcpu->arch.hflags |= HF_IRET_MASK;
+
 	if (!sev_es_guest(vcpu->kvm)) {
 		svm_clr_intercept(svm, INTERCEPT_IRET);
 		svm->nmi_iret_rip = kvm_rip_read(vcpu);
@@ -3735,9 +3738,6 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (is_vnmi_enabled(svm))
-		return;
-
 	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
 		return; /* IRET will cause a vm exit */
 
@@ -3751,9 +3751,14 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	 * Something prevents NMI from been injected. Single step over possible
 	 * problem (IRET or exception injection or interrupt shadow)
 	 */
-	svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
-	svm->nmi_singlestep = true;
-	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
+
+	if (is_vnmi_enabled(svm)) {
+		svm_set_intercept(svm, INTERCEPT_IRET);
+	} else {
+		svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
+		svm->nmi_singlestep = true;
+		svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
+	}
 }
 
 static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
-- 
2.34.3

