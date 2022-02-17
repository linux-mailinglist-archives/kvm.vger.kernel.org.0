Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0974BAB64
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 22:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbiBQVEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 16:04:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234111AbiBQVEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 16:04:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F23BA85643
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=siCrqXZl1+wKhm4ojkQILAxFN3Tkl6EhHzMI4WXy5Ao=;
        b=ICkkGg5YFx0DoHi8hAlfiCmsV2qqO5WRJ74568DKzdO6U6YPpVUvY3iuHGSDA6rwTen+w8
        +zENoP3fcOQHJguuCiZYFzhryR1ZqeGV9cHeBF2uHgpASwo1ZiMo1cXZfQoMqZUYSps475
        QBrxAFnMQgtXhbeEtKg3pUozk3WiKR4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-acOMUbJOPP-_E1kmjwNxvw-1; Thu, 17 Feb 2022 16:03:43 -0500
X-MC-Unique: acOMUbJOPP-_E1kmjwNxvw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7204B2F47;
        Thu, 17 Feb 2022 21:03:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23B1546982;
        Thu, 17 Feb 2022 21:03:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 02/18] KVM: x86: do not deliver asynchronous page faults if CR0.PG=0
Date:   Thu, 17 Feb 2022 16:03:24 -0500
Message-Id: <20220217210340.312449-3-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-1-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enabling async page faults is nonsensical if paging is disabled, but
it is allowed because CR0.PG=0 does not clear the async page fault
MSR.  Just ignore them and only use the artificial halt state,
similar to what happens in guest mode if async #PF vmexits are disabled.

Given the increasingly complex logic, and the nicer code if the new
"if" is placed last, opportunistically change the "||" into a chain
of "if (...) return false" statements.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 99a58c25f5c2..b912eef5dc1a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12270,14 +12270,28 @@ static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
 
 static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
+
+	if (!kvm_pv_async_pf_enabled(vcpu))
 		return false;
 
-	if (!kvm_pv_async_pf_enabled(vcpu) ||
-	    (vcpu->arch.apf.send_user_only && static_call(kvm_x86_get_cpl)(vcpu) == 0))
+	if (vcpu->arch.apf.send_user_only &&
+	    static_call(kvm_x86_get_cpl)(vcpu) == 0)
 		return false;
 
-	return true;
+	if (is_guest_mode(vcpu)) {
+		/*
+		 * L1 needs to opt into the special #PF vmexits that are
+		 * used to deliver async page faults.
+		 */
+		return vcpu->arch.apf.delivery_as_pf_vmexit;
+	} else {
+		/*
+		 * Play it safe in case the guest does a quick real mode
+		 * foray.  The real mode IDT is unlikely to have a #PF
+		 * exception setup.
+		 */
+		return is_paging(vcpu);
+	}
 }
 
 bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
-- 
2.31.1


