Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D64757786
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 11:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjGRJON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 05:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjGRJOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 05:14:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F8310C2
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 02:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689671605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4C0D24d2FC1TYs50FyhHTmpHwv4hCv9vozKRBzYFkPk=;
        b=UwJ/38koG/XjnlPzIYTGcjLcmuqZkHWffD0fR1IheDPe7qKDTGo7ib3Zizg6DR9ABBpMv2
        C94dD44chJiMV0Wniv1F9OO2+RKZPfUyPry9WzmKN1Y7YwCUqYVl41kAZfXUF2DK0DMan3
        bSKVkUz+7h9jSM7QlJmu5PKuhCWLtfE=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-Hs3Upf_oN22Bel_I6Zw-CQ-1; Tue, 18 Jul 2023 05:13:21 -0400
X-MC-Unique: Hs3Upf_oN22Bel_I6Zw-CQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D0082A59542;
        Tue, 18 Jul 2023 09:13:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C14791454142;
        Tue, 18 Jul 2023 09:13:18 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/3] KVM: x86: VMX: set irr_pending in kvm_apic_update_irr
Date:   Tue, 18 Jul 2023 12:13:09 +0300
Message-Id: <20230718091310.119672-3-mlevitsk@redhat.com>
In-Reply-To: <20230718091310.119672-1-mlevitsk@redhat.com>
References: <20230718091310.119672-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the APICv is inhibited, the irr_pending optimization is used.

Therefore, when kvm_apic_update_irr sets bits in the IRR,
it must set irr_pending to true as well.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/lapic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b3f57e0f0d64ae..613830ba2d8cef 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -653,8 +653,11 @@ EXPORT_SYMBOL_GPL(__kvm_apic_update_irr);
 bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
+	bool irr_updated = __kvm_apic_update_irr(pir, apic->regs, max_irr);
 
-	return __kvm_apic_update_irr(pir, apic->regs, max_irr);
+	if (unlikely(!apic->apicv_active && irr_updated))
+		apic->irr_pending = true;
+	return irr_updated;
 }
 EXPORT_SYMBOL_GPL(kvm_apic_update_irr);
 
-- 
2.26.3

