Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5007A5907CC
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 23:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbiHKVG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 17:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbiHKVGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 17:06:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 486B098586
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 14:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660251979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zssSnyjhXO8Y+VaC40NbtnI4nznRbo22yC14BgkmKUU=;
        b=Qe/nC1V1cuyhbLjQxmnNBKWZKIWlKJDghpqfCdNoZthNZ210dPh/6da76QI5c32M8kKYBA
        GJofDHwM91tvsjm7b2/6Zfr0XtptafWMRsS014pvnfXS9TkxD51KsOgV9ivrRF0jNDngXX
        I1QY6UEhL3ydEwHRoIzzB7eW9bZBSc8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-n-MfIhBBM4uPTIlgrGS62Q-1; Thu, 11 Aug 2022 17:06:07 -0400
X-MC-Unique: n-MfIhBBM4uPTIlgrGS62Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D55A85A59A;
        Thu, 11 Aug 2022 21:06:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB67B492C3B;
        Thu, 11 Aug 2022 21:06:06 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, mlevitsk@redhat.com, vkuznets@redhat.com
Subject: [PATCH v2 4/9] KVM: mips, x86: do not rely on KVM_REQ_UNHALT
Date:   Thu, 11 Aug 2022 17:06:00 -0400
Message-Id: <20220811210605.402337-5-pbonzini@redhat.com>
In-Reply-To: <20220811210605.402337-1-pbonzini@redhat.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_REQ_UNHALT is now available as the return value from kvm_vcpu_halt
or kvm_vcpu_block, so the request can be simply cleared just like all
other architectures do.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/mips/kvm/emulate.c | 8 ++++----
 arch/x86/kvm/x86.c      | 8 +++++---
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
index b494d8d39290..77d760d45c48 100644
--- a/arch/mips/kvm/emulate.c
+++ b/arch/mips/kvm/emulate.c
@@ -944,6 +944,7 @@ enum hrtimer_restart kvm_mips_count_timeout(struct kvm_vcpu *vcpu)
 
 enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu)
 {
+	int r;
 	kvm_debug("[%#lx] !!!WAIT!!! (%#lx)\n", vcpu->arch.pc,
 		  vcpu->arch.pending_exceptions);
 
@@ -952,16 +953,15 @@ enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.pending_exceptions) {
 		kvm_vz_lose_htimer(vcpu);
 		vcpu->arch.wait = 1;
-		kvm_vcpu_halt(vcpu);
+		r = kvm_vcpu_halt(vcpu);
 
 		/*
 		 * We we are runnable, then definitely go off to user space to
 		 * check if any I/O interrupts are pending.
 		 */
-		if (kvm_check_request(KVM_REQ_UNHALT, vcpu)) {
-			kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+		if (r > 0)
 			vcpu->run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
-		}
 	}
 
 	return EMULATE_DONE;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c44348bb6ef2..416df0fc7fda 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10611,6 +10611,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 static inline int vcpu_block(struct kvm_vcpu *vcpu)
 {
 	bool hv_timer;
+	int r;
 
 	if (!kvm_arch_vcpu_runnable(vcpu)) {
 		/*
@@ -10626,15 +10627,16 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 
 		kvm_vcpu_srcu_read_unlock(vcpu);
 		if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
-			kvm_vcpu_halt(vcpu);
+			r = kvm_vcpu_halt(vcpu);
 		else
-			kvm_vcpu_block(vcpu);
+			r = kvm_vcpu_block(vcpu);
 		kvm_vcpu_srcu_read_lock(vcpu);
 
 		if (hv_timer)
 			kvm_lapic_switch_to_hv_timer(vcpu);
 
-		if (!kvm_check_request(KVM_REQ_UNHALT, vcpu))
+		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+		if (r <= 0)
 			return 1;
 	}
 
-- 
2.31.1


