Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F197263C8A3
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiK2Tla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbiK2Tki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:40:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E63B658D
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669750671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=twqdjhN58Mc4yzZpBl1NNFSCL0kf8bUxY7h7dFC7RKY=;
        b=NNzss3C7MdXcTNfTJ0NOW/WUKjratNeQVAkrhvMJTMGdPifte1kf8kkwiTwY7eJPpE2CtE
        88/I9d3sZhhOGZJI8sZi17aJYD1AmS6bVmVfq9DYrhr2rklvvrcuoyLUVK4pn/SIZHIu89
        3B1CgFpzYZNkIoJK2jxBMerKQas7CXg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-e2k6pOH2OU-WXS70I9SEuw-1; Tue, 29 Nov 2022 14:37:48 -0500
X-MC-Unique: e2k6pOH2OU-WXS70I9SEuw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E41F3817A6D;
        Tue, 29 Nov 2022 19:37:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBA682028DC1;
        Tue, 29 Nov 2022 19:37:43 +0000 (UTC)
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
Subject: [PATCH v2 06/11] KVM: SVM: add wrappers to enable/disable IRET interception
Date:   Tue, 29 Nov 2022 21:37:12 +0200
Message-Id: <20221129193717.513824-7-mlevitsk@redhat.com>
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

SEV-ES guests don't use IRET interception for the detection of
an end of a NMI.

Therefore it makes sense to create a wrapper to avoid repeating
the check for the SEV-ES.

No functional change is intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 512b2aa21137e2..cfed6ab29c839a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2468,16 +2468,29 @@ static int task_switch_interception(struct kvm_vcpu *vcpu)
 			       has_error_code, error_code);
 }
 
+static void svm_disable_iret_interception(struct vcpu_svm *svm)
+{
+	if (!sev_es_guest(svm->vcpu.kvm))
+		svm_clr_intercept(svm, INTERCEPT_IRET);
+}
+
+static void svm_enable_iret_interception(struct vcpu_svm *svm)
+{
+	if (!sev_es_guest(svm->vcpu.kvm))
+		svm_set_intercept(svm, INTERCEPT_IRET);
+}
+
 static int iret_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	++vcpu->stat.nmi_window_exits;
 	svm->awaiting_iret_completion = true;
-	if (!sev_es_guest(vcpu->kvm)) {
-		svm_clr_intercept(svm, INTERCEPT_IRET);
+
+	svm_disable_iret_interception(svm);
+	if (!sev_es_guest(vcpu->kvm))
 		svm->nmi_iret_rip = kvm_rip_read(vcpu);
-	}
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	return 1;
 }
@@ -3470,8 +3483,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 		return;
 
 	svm->nmi_masked = true;
-	if (!sev_es_guest(vcpu->kvm))
-		svm_set_intercept(svm, INTERCEPT_IRET);
+	svm_enable_iret_interception(svm);
 	++vcpu->stat.nmi_injections;
 }
 
@@ -3614,12 +3626,10 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 
 	if (masked) {
 		svm->nmi_masked = true;
-		if (!sev_es_guest(vcpu->kvm))
-			svm_set_intercept(svm, INTERCEPT_IRET);
+		svm_enable_iret_interception(svm);
 	} else {
 		svm->nmi_masked = false;
-		if (!sev_es_guest(vcpu->kvm))
-			svm_clr_intercept(svm, INTERCEPT_IRET);
+		svm_disable_iret_interception(svm);
 	}
 }
 
-- 
2.26.3

