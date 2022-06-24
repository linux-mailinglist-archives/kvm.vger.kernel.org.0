Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45651559D97
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 17:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbiFXPp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 11:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbiFXPpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 11:45:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38C1A4993C
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 08:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656085554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jzMkt6pTKTwupvZ8hAxK1N71JsLruh2c0ORBYbmQYqY=;
        b=agULh/KXP96KA2NR74Ov0n/wXLYF/r1OosKc+aVP1P3pX6HZDDfQRXhKf+YS4TIa8inyon
        FqjUiaSMbGqZkClAzUYmXZlqnuB9jyRe8QCSoP++WuMgo3QKdO5o7FHU4NU1culb75dU/t
        REhSKIPBB9wHkaxWBntriok6zVTlnro=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-s4Ma258tNHmlmJhz7cYpaA-1; Fri, 24 Jun 2022 11:45:53 -0400
X-MC-Unique: s4Ma258tNHmlmJhz7cYpaA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D62A8802D1F;
        Fri, 24 Jun 2022 15:45:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9063C15D40;
        Fri, 24 Jun 2022 15:45:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     ubizjak@gmail.com
Subject: [PATCH] KVM: nVMX: clean up posted interrupt descriptor try_cmpxchg
Date:   Fri, 24 Jun 2022 11:45:52 -0400
Message-Id: <20220624154552.2736417-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rely on try_cmpxchg64 for re-reading the PID on failure, using READ_ONCE
only right before the first iteration.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 73f60aa480fe..1b56c5e5c9fb 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -34,7 +34,7 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
-static int pi_try_set_control(struct pi_desc *pi_desc, u64 old, u64 new)
+static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
 {
 	/*
 	 * PID.ON can be set at any time by a different vCPU or by hardware,
@@ -42,7 +42,7 @@ static int pi_try_set_control(struct pi_desc *pi_desc, u64 old, u64 new)
 	 * update must be retried with a fresh snapshot an ON change causes
 	 * the cmpxchg to fail.
 	 */
-	if (!try_cmpxchg64(&pi_desc->control, &old, new))
+	if (!try_cmpxchg64(&pi_desc->control, pold, new))
 		return -EBUSY;
 
 	return 0;
@@ -96,8 +96,9 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	if (!x2apic_mode)
 		dest = (dest << 8) & 0xFF00;
 
+	old.control = READ_ONCE(pi_desc->control);
 	do {
-		old.control = new.control = READ_ONCE(pi_desc->control);
+		new.control = old.control;
 
 		/*
 		 * Clear SN (as above) and refresh the destination APIC ID to
@@ -111,7 +112,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		 * descriptor was modified on "put" to use the wakeup vector.
 		 */
 		new.nv = POSTED_INTR_VECTOR;
-	} while (pi_try_set_control(pi_desc, old.control, new.control));
+	} while (pi_try_set_control(pi_desc, &old.control, new.control));
 
 	local_irq_restore(flags);
 
@@ -156,12 +157,12 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 
 	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
 
+	old.control = READ_ONCE(pi_desc->control);
 	do {
-		old.control = new.control = READ_ONCE(pi_desc->control);
-
 		/* set 'NV' to 'wakeup vector' */
+		new.control = old.control;
 		new.nv = POSTED_INTR_WAKEUP_VECTOR;
-	} while (pi_try_set_control(pi_desc, old.control, new.control));
+	} while (pi_try_set_control(pi_desc, &old.control, new.control));
 
 	/*
 	 * Send a wakeup IPI to this CPU if an interrupt may have been posted
-- 
2.31.1

