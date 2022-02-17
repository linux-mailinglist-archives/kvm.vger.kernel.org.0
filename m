Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983994BA7B3
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 19:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244006AbiBQSIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 13:08:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238101AbiBQSIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 13:08:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB67515DB39
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 10:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645121316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ley/Akl1OJJZYaGhdqPbRrhWU8VGa3K0XFs+iArPTAo=;
        b=BvmZL27Lc+UOPcdSs5WZTl1tqaCLK3BGdPdgUixbM5rJIHp5ZjULrCZgDc8lm4MwOoONAd
        JWHJ1Ykp26NMRuiVRnCG+K2iUcQ0XQFgODAsPLw8o3Rqw3bo50yN0jYmJXe1EbOzWabWZJ
        kx89OK6WdQjuT1p9dqnL3/xu8cspU9A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-TDwA8Km5M9aBDkGFv-XICA-1; Thu, 17 Feb 2022 13:08:34 -0500
X-MC-Unique: TDwA8Km5M9aBDkGFv-XICA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B0B61006AA6;
        Thu, 17 Feb 2022 18:08:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03A868379A;
        Thu, 17 Feb 2022 18:08:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v3 2/6] KVM: x86: use static_call_cond for optional callbacks
Date:   Thu, 17 Feb 2022 13:08:27 -0500
Message-Id: <20220217180831.288210-3-pbonzini@redhat.com>
In-Reply-To: <20220217180831.288210-1-pbonzini@redhat.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SVM implements neither update_emulated_instruction nor
set_apic_access_page_addr.  Remove an "if" by calling them
with static_call_cond().

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 746f72ae2c95..8a7f32563590 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8421,8 +8421,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			kvm_rip_write(vcpu, ctxt->eip);
 			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
 				r = kvm_vcpu_do_singlestep(vcpu);
-			if (kvm_x86_ops.update_emulated_instruction)
-				static_call(kvm_x86_update_emulated_instruction)(vcpu);
+			static_call_cond(kvm_x86_update_emulated_instruction)(vcpu);
 			__kvm_set_rflags(vcpu, ctxt->eflags);
 		}
 
@@ -9791,10 +9790,7 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 	if (!lapic_in_kernel(vcpu))
 		return;
 
-	if (!kvm_x86_ops.set_apic_access_page_addr)
-		return;
-
-	static_call(kvm_x86_set_apic_access_page_addr)(vcpu);
+	static_call_cond(kvm_x86_set_apic_access_page_addr)(vcpu);
 }
 
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
-- 
2.31.1


