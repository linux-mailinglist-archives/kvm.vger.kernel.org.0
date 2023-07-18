Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DECE757785
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 11:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjGRJOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 05:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjGRJOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 05:14:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA12EE55
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 02:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689671600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4WlIkr5Df/8dGsk772CbAon6bnUBTqjKXV9qoX9zRiI=;
        b=UrXO1J0d/C0L9J7/HHwr2Agf8bcj7drQnEqRJrt955NF7p4539XnVO6k5IJGhGnd5WZS8o
        xMqXIZUN9z6ng/Yr26V7Z7v0czEhbVOasr9QTr1QKxE4yh6lskiR24+CRsCMfakcZ0T/NK
        UGLll2WnmqIxGQmjQZSCQf9+JudBA04=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-dSfb6Q6kOYqqc21jhdQidA-1; Tue, 18 Jul 2023 05:13:18 -0400
X-MC-Unique: dSfb6Q6kOYqqc21jhdQidA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 685113803916;
        Tue, 18 Jul 2023 09:13:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECCAC1454143;
        Tue, 18 Jul 2023 09:13:15 +0000 (UTC)
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
Subject: [PATCH 1/3] KVM: x86: VMX: __kvm_apic_update_irr must update the IRR atomically
Date:   Tue, 18 Jul 2023 12:13:08 +0300
Message-Id: <20230718091310.119672-2-mlevitsk@redhat.com>
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

If APICv is inhibited, then IPIs from peer vCPUs are done by
atomically setting bits in IRR.

This means, that when __kvm_apic_update_irr copies PIR to IRR,
it has to modify IRR atomically as well.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/lapic.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e542cf285b5184..b3f57e0f0d64ae 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -627,15 +627,19 @@ bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr)
 
 	for (i = vec = 0; i <= 7; i++, vec += 32) {
 		pir_val = READ_ONCE(pir[i]);
-		irr_val = *((u32 *)(regs + APIC_IRR + i * 0x10));
+		irr_val = READ_ONCE(*((u32 *)(regs + APIC_IRR + i * 0x10)));
+
 		if (pir_val) {
+			pir_val = xchg(&pir[i], 0);
+
+			while (!try_cmpxchg(((u32 *)(regs + APIC_IRR + i * 0x10)),
+			       &irr_val, irr_val | pir_val));
+
 			prev_irr_val = irr_val;
-			irr_val |= xchg(&pir[i], 0);
-			*((u32 *)(regs + APIC_IRR + i * 0x10)) = irr_val;
-			if (prev_irr_val != irr_val) {
-				max_updated_irr =
-					__fls(irr_val ^ prev_irr_val) + vec;
-			}
+			irr_val |= pir_val;
+
+			if (prev_irr_val != irr_val)
+				max_updated_irr = __fls(irr_val ^ prev_irr_val) + vec;
 		}
 		if (irr_val)
 			*max_irr = __fls(irr_val) + vec;
-- 
2.26.3

