Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8464163DA5D
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 17:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiK3QQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 11:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiK3QQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 11:16:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFDE15716
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 08:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669824934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=40HjOV/+1cf7hR2QmRq37IbKU2fJ2rN7rzjecPJf15c=;
        b=C/huNC2AUMpALirfoyQbpch0DIVh5kLH79pZ8UCxTnj8US9kiNHcNJM6zKuN2y3X9VupOl
        zoGM2+X3wSKbnEcze7lcIY2NgYwLKTbfMwnTjFepwpWkY9607lJBAN4Fmk98K+p66xoURw
        wQcwOXui+PHfcbidDvApYKdGEZ7nxNA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-kSQzzrtiOX2YLynwetD_IQ-1; Wed, 30 Nov 2022 11:15:32 -0500
X-MC-Unique: kSQzzrtiOX2YLynwetD_IQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76D91299E764;
        Wed, 30 Nov 2022 16:15:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59EE81401C2D;
        Wed, 30 Nov 2022 16:15:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: x86: fix uninitialized variable use on KVM_REQ_TRIPLE_FAULT
Date:   Wed, 30 Nov 2022 11:15:31 -0500
Message-Id: <20221130161531.891135-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a triple fault was fixed by kvm_x86_ops.nested_ops->triple_fault (by
turning it into a vmexit), there is no need to leave vcpu_enter_guest().
Any vcpu->requests will be caught later before the actual vmentry,
and in fact vcpu_enter_guest() was not initializing the "r" variable.
Depending on the compiler's whims, this could cause the
x86_64/triple_fault_event_test test to fail.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Fixes: 92e7d5c83aff ("KVM: x86: allow L1 to not intercept triple fault")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 246bdc9a9154..7f850dfb4086 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10280,8 +10280,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 				vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
 				vcpu->mmio_needed = 0;
 				r = 0;
+				goto out;
 			}
-			goto out;
 		}
 		if (kvm_check_request(KVM_REQ_APF_HALT, vcpu)) {
 			/* Page is swapped out. Do synthetic halt */
-- 
2.31.1

