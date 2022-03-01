Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1581F4C8D0E
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 14:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbiCAN4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 08:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbiCAN4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 08:56:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FB5C8D684
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 05:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646142951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gSFeH1i77V/KkgawIUDjeRhR+3rBrHanlQxBcU1qMVM=;
        b=Ine0H6mLRRJIunOLC5xQPKj0zC1BGIOeivfv136pwGjar3giejxjwzoWqtAJCG4mi0PY0L
        o5ogfaR7kPcbFoOaCUTmo4U3JSJ6qWgA//uSR/dD6fPRk7jihCAamzCMg3iQj2J1tt6iqA
        AdyAMN0blqo2A7gSGiqdpCMreTrD7vA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-JLkAO0TqMSyP51vTULynBA-1; Tue, 01 Mar 2022 08:55:48 -0500
X-MC-Unique: JLkAO0TqMSyP51vTULynBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39B8C800422;
        Tue,  1 Mar 2022 13:55:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98BF41057F7C;
        Tue,  1 Mar 2022 13:55:42 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/4] KVM: x86: SVM: disable preemption in avic_refresh_apicv_exec_ctrl
Date:   Tue,  1 Mar 2022 15:55:24 +0200
Message-Id: <20220301135526.136554-3-mlevitsk@redhat.com>
In-Reply-To: <20220301135526.136554-1-mlevitsk@redhat.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

avic_refresh_apicv_exec_ctrl is called from vcpu_enter_guest,
without preemption disabled, however avic_vcpu_load, and
avic_vcpu_put expect preemption to be disabled.

This issue was found by lockdep.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index aea0b13773fd3..e23159f3a62ba 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -640,12 +640,16 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	}
 	vmcb_mark_dirty(vmcb, VMCB_AVIC);
 
+	preempt_disable();
+
 	if (activated)
 		avic_vcpu_load(vcpu, vcpu->cpu);
 	else
 		avic_vcpu_put(vcpu);
 
 	avic_set_pi_irte_mode(vcpu, activated);
+
+	preempt_enable();
 }
 
 static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
-- 
2.26.3

