Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A5F76383B
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 16:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbjGZOBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 10:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbjGZOBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 10:01:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDDC2688
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 07:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690380022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3ArnVy5ynfW5TPp7Ho0vkusYDFjjSaHrT1uTnmW5QUE=;
        b=ijCzmdRHdaq61Xa41Yi9aJULKO/JGIzzjyBhYgD3NRclLKqZogpvsWupM+LqExCpKibA5K
        sJcnR613INBhMg40D+NjCNGU2S9P5NqkbAbkwbeFeKVF2FQTNV+YTJvL7NZI4g2XmuRE/j
        JHgtDicWaSYQYZQ3Mq8NVOy4xSG4ztg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-V_st_u7pN5SV1v_VwPI4fQ-1; Wed, 26 Jul 2023 10:00:16 -0400
X-MC-Unique: V_st_u7pN5SV1v_VwPI4fQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C8A0800CAC;
        Wed, 26 Jul 2023 14:00:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B1A240C2063;
        Wed, 26 Jul 2023 13:59:55 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 1/3] KVM: x86: VMX: __kvm_apic_update_irr must update the IRR atomically
Date:   Wed, 26 Jul 2023 16:59:43 +0300
Message-Id: <20230726135945.260841-2-mlevitsk@redhat.com>
In-Reply-To: <20230726135945.260841-1-mlevitsk@redhat.com>
References: <20230726135945.260841-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
 arch/x86/kvm/lapic.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 113ca9661ab21d..b17b37e4d4fcd1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -637,16 +637,22 @@ bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr)
 	*max_irr = -1;
 
 	for (i = vec = 0; i <= 7; i++, vec += 32) {
+		u32 *p_irr = (u32 *)(regs + APIC_IRR + i * 0x10);
+
+		irr_val = *p_irr;
 		pir_val = READ_ONCE(pir[i]);
-		irr_val = *((u32 *)(regs + APIC_IRR + i * 0x10));
+
 		if (pir_val) {
+			pir_val = xchg(&pir[i], 0);
+
 			prev_irr_val = irr_val;
-			irr_val |= xchg(&pir[i], 0);
-			*((u32 *)(regs + APIC_IRR + i * 0x10)) = irr_val;
-			if (prev_irr_val != irr_val) {
-				max_updated_irr =
-					__fls(irr_val ^ prev_irr_val) + vec;
-			}
+			do {
+				irr_val = prev_irr_val | pir_val;
+			} while (prev_irr_val != irr_val &&
+				 !try_cmpxchg(p_irr, &prev_irr_val, irr_val));
+
+			if (prev_irr_val != irr_val)
+				max_updated_irr = __fls(irr_val ^ prev_irr_val) + vec;
 		}
 		if (irr_val)
 			*max_irr = __fls(irr_val) + vec;
-- 
2.26.3

