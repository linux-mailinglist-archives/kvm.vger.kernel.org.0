Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F7659A43B
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354780AbiHSRjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 13:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354696AbiHSRii (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 13:38:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A391A2AE
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 09:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660928211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CN6W9SC8T0+Gz699A5aiqgYNky4W4GX4nc9X+Iadk4Q=;
        b=jLRoOcQtmUT4fBE6jxPKJ3ZO18afkehWgzeWRny9HdlNuFUHhxpbNM9IJ3SINLRsKc1Li9
        ngJjDKhDD4MfMJy8ZqY0F8e72UpnmMZ0yBtDUk+qs9G1Gv1Py2XBcLLMRHyOOvk9xLdxPt
        93IptsvxsDGrmr6q449v31gtKiRYcA0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-dKdzcjIjMUmdESMU2YaNyQ-1; Fri, 19 Aug 2022 12:56:44 -0400
X-MC-Unique: dKdzcjIjMUmdESMU2YaNyQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D72E13801140;
        Fri, 19 Aug 2022 16:56:43 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB5BD14152E1;
        Fri, 19 Aug 2022 16:56:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: SVM: remove unnecessary check on INIT intercept
Date:   Fri, 19 Aug 2022 12:56:43 -0400
Message-Id: <20220819165643.83692-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since svm_check_nested_events() is now handling INIT signals, there is
no need to latch it until the VMEXIT is injected.  The only condition
under which INIT signals are latched is GIF=0.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f3813dbacb9f..26a348389ece 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4697,15 +4697,7 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	/*
-	 * TODO: Last condition latch INIT signals on vCPU when
-	 * vCPU is in guest-mode and vmcb12 defines intercept on INIT.
-	 * To properly emulate the INIT intercept,
-	 * svm_check_nested_events() should call nested_svm_vmexit()
-	 * if an INIT signal is pending.
-	 */
-	return !gif_set(svm) ||
-		   (vmcb_is_intercept(&svm->vmcb->control, INTERCEPT_INIT));
+	return !gif_set(svm);
 }
 
 static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
-- 
2.31.1

