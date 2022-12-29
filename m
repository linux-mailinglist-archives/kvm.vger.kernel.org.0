Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6526591E7
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 22:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiL2VAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 16:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234053AbiL2VAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 16:00:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931BA15F00
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 12:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672347590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=oveyZKRFVQVj32wP0L+KhIamsge517dBdnS11SNoodQ=;
        b=M+91A91T3Fx8/GRGXfwiR6dN+3GFrgw03Y3PG6xA6oB5MHmW4amyxoTVY/XcENwfsqXPlc
        q9tN6Y4gWJKRLtU0o2E+pPXvHHRlNsTbH6ZBAsxWF3eAmyOM9Tgri0jTVU4rEpv9gNiLo8
        Xprjz79gE5nrSgcjWbizRTvuK57Xsz4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-pwk1Y4LQN9uz_ud6nSwXLA-1; Thu, 29 Dec 2022 15:59:47 -0500
X-MC-Unique: pwk1Y4LQN9uz_ud6nSwXLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D5583C0CD47;
        Thu, 29 Dec 2022 20:59:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA77D53A3;
        Thu, 29 Dec 2022 20:59:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: nSVM: clarify recalc_intercepts() wrt CR8
Date:   Thu, 29 Dec 2022 15:59:46 -0500
Message-Id: <20221229205946.1826595-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mysterious comment "We only want the cr8 intercept bits of L1"
dates back to basically the introduction of nested SVM, back when
the handling of "less typical" hypervisors was very haphazard.
With the development of kvm-unit-tests for interrupt handling,
the same code grew another vmcb_clr_intercept for the interrupt
window (VINTR) vmexit, this time with a comment that is at least
decent.

It turns out however that the same comment applies to the CR8 write
intercept, which is also a "recheck if an interrupt should be
injected" intercept.  The CR8 read intercept instead has not
been used by KVM for 14 years (commit 649d68643ebf, "KVM: SVM:
sync TPR value to V_TPR field in the VMCB"), so do not bother
clearing it and let one comment describe both CR8 write and VINTR
handling.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bc9cd7086fa9..add65dd59756 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -138,15 +138,13 @@ void recalc_intercepts(struct vcpu_svm *svm)
 		c->intercepts[i] = h->intercepts[i];
 
 	if (g->int_ctl & V_INTR_MASKING_MASK) {
-		/* We only want the cr8 intercept bits of L1 */
-		vmcb_clr_intercept(c, INTERCEPT_CR8_READ);
-		vmcb_clr_intercept(c, INTERCEPT_CR8_WRITE);
-
 		/*
-		 * Once running L2 with HF_VINTR_MASK, EFLAGS.IF does not
-		 * affect any interrupt we may want to inject; therefore,
-		 * interrupt window vmexits are irrelevant to L0.
+		 * Once running L2 with HF_VINTR_MASK, EFLAGS.IF and CR8
+		 * does not affect any interrupt we may want to inject;
+		 * therefore, writes to CR8 are irrelevant to L0, as are
+		 * interrupt window vmexits.
 		 */
+		vmcb_clr_intercept(c, INTERCEPT_CR8_WRITE);
 		vmcb_clr_intercept(c, INTERCEPT_VINTR);
 	}
 
-- 
2.31.1

