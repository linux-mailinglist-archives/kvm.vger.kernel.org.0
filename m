Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEAD4A77B8
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 19:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240435AbiBBSST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 13:18:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233691AbiBBSSS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 13:18:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643825897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xt9mcVUpdJQpnjeJRK6diyxmq8i9URv9SvRl8wszf7c=;
        b=Nk3dqLCf/h0KTjfzhJnKw40c5sBsIbB2WHXKf8VnmlmjFzo5h3/FdR/lVqvhnIM87c/hoH
        rnyRMsprKQZssl+J8+SzmhHPX297R2qt/V5xGOryqiUc6J+IHD8B+lVEXdf6VktMREoIAO
        IQX8n0rAkUNf8Chk7Pe306sBVEokpUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-kF07KXLyNimRWKg7kCHZxA-1; Wed, 02 Feb 2022 13:18:16 -0500
X-MC-Unique: kF07KXLyNimRWKg7kCHZxA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 220C71006AA3;
        Wed,  2 Feb 2022 18:18:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C05747744F;
        Wed,  2 Feb 2022 18:18:14 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 1/5] KVM: x86: use static_call_cond for optional callbacks
Date:   Wed,  2 Feb 2022 13:18:09 -0500
Message-Id: <20220202181813.1103496-2-pbonzini@redhat.com>
In-Reply-To: <20220202181813.1103496-1-pbonzini@redhat.com>
References: <20220202181813.1103496-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index 862d654caedf..a527cffd0a2b 100644
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
 
@@ -9838,10 +9837,7 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
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


