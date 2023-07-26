Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832CF76383C
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 16:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbjGZOBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 10:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbjGZOBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 10:01:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE682696
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 07:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690380039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tbgdp6vazrgBiQOoNU+XwHpUdW8J49pFS7u9g5v72P0=;
        b=J3OG1tFS+MwiF2GlxBJIDTPlNka3R/w4pAy7PX6LV1yPT3swluCCc9XocerYv4mdsKXfAu
        9A2zWwGrOju84gzIucuVlCcY9VWlipv8pzOzJnT1inCHUeMzSAMIxODM8m6CpqyIHRQTnU
        dRI0vWPqKzCyvZ64YSREzrOumoAFH8w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-nLfhup3aMnSU8fi3piZYvA-1; Wed, 26 Jul 2023 10:00:33 -0400
X-MC-Unique: nLfhup3aMnSU8fi3piZYvA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDF24830DB5;
        Wed, 26 Jul 2023 14:00:05 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C25B40C2063;
        Wed, 26 Jul 2023 14:00:02 +0000 (UTC)
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
Subject: [PATCH v2 2/3] KVM: x86: VMX: set irr_pending in kvm_apic_update_irr
Date:   Wed, 26 Jul 2023 16:59:44 +0300
Message-Id: <20230726135945.260841-3-mlevitsk@redhat.com>
In-Reply-To: <20230726135945.260841-1-mlevitsk@redhat.com>
References: <20230726135945.260841-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index b17b37e4d4fcd1..a983a16163b137 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -666,8 +666,11 @@ EXPORT_SYMBOL_GPL(__kvm_apic_update_irr);
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

