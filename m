Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5C84E450E
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbiCVR0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239630AbiCVR0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:26:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 147BD46156
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647969913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U1H3Hqi1yPaMioKAaaHbxRBztSVtJHWS8z/3mEeiMtw=;
        b=QOyH8H6zq6n3ph4r3cVIHC8eSvaY8VdoO254R0RJVtjTjaSmo46hhASTrNTdxrhU9EvuWu
        uzoJrUH2enhr4FMkZVCFHBpk6Oq+auvbWjOQSHVpy3L9lnuKthlGaShYWOWz4xfR85fECG
        JlAm8dJ5/mgdH9ypZn+ZWAcginAh80k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-yyXdqDiBPGiqmdQ8oGGrcQ-1; Tue, 22 Mar 2022 13:25:10 -0400
X-MC-Unique: yyXdqDiBPGiqmdQ8oGGrcQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34DFA3804077;
        Tue, 22 Mar 2022 17:25:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D026C2166B2D;
        Tue, 22 Mar 2022 17:25:02 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/8] KVM: x86: SVM: use vmcb01 in avic_init_vmcb and init_vmcb
Date:   Tue, 22 Mar 2022 19:24:43 +0200
Message-Id: <20220322172449.235575-3-mlevitsk@redhat.com>
In-Reply-To: <20220322172449.235575-1-mlevitsk@redhat.com>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 arch/x86/kvm/svm/svm.c  | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index c5ef4715f3e0..b39fe614467a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -167,7 +167,7 @@ int avic_vm_init(struct kvm *kvm)
 
 void avic_init_vmcb(struct vcpu_svm *svm)
 {
-	struct vmcb *vmcb = svm->vmcb;
+	struct vmcb *vmcb = svm->vmcb01.ptr;
 	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
 	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
 	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6535adee3e9c..e9a5c1e80889 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -997,8 +997,9 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 static void init_vmcb(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb_control_area *control = &svm->vmcb->control;
-	struct vmcb_save_area *save = &svm->vmcb->save;
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+	struct vmcb_control_area *control = &vmcb->control;
+	struct vmcb_save_area *save = &vmcb->save;
 
 	svm_set_intercept(svm, INTERCEPT_CR0_READ);
 	svm_set_intercept(svm, INTERCEPT_CR3_READ);
@@ -1140,10 +1141,10 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	svm_hv_init_vmcb(svm->vmcb);
+	svm_hv_init_vmcb(vmcb);
 	init_vmcb_after_set_cpuid(vcpu);
 
-	vmcb_mark_all_dirty(svm->vmcb);
+	vmcb_mark_all_dirty(vmcb);
 
 	enable_gif(svm);
 }
-- 
2.26.3

