Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9E662DE56
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 15:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240532AbiKQOfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 09:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240367AbiKQOef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 09:34:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C01717433
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 06:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668695613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TaydI4I4+Qlz5zavVfjLBmIIDcUhBXwzZ2N6s+mdb+g=;
        b=c08Ss+gBfkz5KXqxrzPgMow9O1mAuQFhMioGNBV4b8Tt/3A0ZW+zMyuLghElDpuJKvM2PT
        8J6txAL2fMD0/8R2o72dKksuACCfFcRpNZYWi5An0jZx+Z86XcHR4Rr+SIkBiXpr2PzK9G
        EzmjQ1IY+H5/TUu9yJatvO/pPrj1Mvs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-BQIktnTiOPaOrejF1IjLKA-1; Thu, 17 Nov 2022 09:33:25 -0500
X-MC-Unique: BQIktnTiOPaOrejF1IjLKA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A86A994AB03;
        Thu, 17 Nov 2022 14:33:24 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CD852166B29;
        Thu, 17 Nov 2022 14:33:21 +0000 (UTC)
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
        Maxim Levitsky <mlevitsk@redhat.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: [PATCH 10/13] KVM: SVM: Add VNMI support in inject_nmi
Date:   Thu, 17 Nov 2022 16:32:39 +0200
Message-Id: <20221117143242.102721-11-mlevitsk@redhat.com>
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

From: Santosh Shukla <santosh.shukla@amd.com>

Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
will clear V_NMI to acknowledge processing has started and will keep the
V_NMI_MASK set until the processor is done with processing the NMI event.

Also, handle the nmi_l1_to_l2 case such that when it is true then
NMI to be injected originally comes from L1's VMCB12 EVENTINJ field.
So adding a check for that case.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eaa30f8ace518d..9ebfbd0d4b467e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
 static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = NULL;
 
+	if (is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2) {
+		vmcb = get_vnmi_vmcb(svm);
+		vmcb->control.int_ctl |= V_NMI_PENDING;
+		++vcpu->stat.nmi_injections;
+		return;
+	}
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 
 	if (svm->nmi_l1_to_l2)
-- 
2.34.3

