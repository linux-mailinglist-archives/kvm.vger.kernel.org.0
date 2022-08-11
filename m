Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0419E5907CB
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 23:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbiHKVG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 17:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236302AbiHKVGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 17:06:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FB787FE68
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 14:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660251970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NqSPZEkWBGI46NvTgNx/Bt3rMwg89QmQhSCnM/Tpfm4=;
        b=iCEn/fDzS9TYlcVam9spMKxVg0BMAFnZIyIy087IghguLJZM8QTrZjdr/ca/AF9jSenTex
        /+WMiJyS6kjweftrX4wV5VVhwXSCanY57PY1L2okoOAT0xXj1cXqo9NQ4ekHvQipcKgf9m
        M7Tew9KyR8dejIkFLTPJDdn+ReJBf/A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-zw33dlhwODiy7MM-FRzIlQ-1; Thu, 11 Aug 2022 17:06:07 -0400
X-MC-Unique: zw33dlhwODiy7MM-FRzIlQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D299C1C004FC;
        Thu, 11 Aug 2022 21:06:06 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABA93492C3B;
        Thu, 11 Aug 2022 21:06:06 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, mlevitsk@redhat.com, vkuznets@redhat.com
Subject: [PATCH v2 3/9] KVM: x86: make kvm_vcpu_{block,halt} return whether vCPU is runnable
Date:   Thu, 11 Aug 2022 17:05:59 -0400
Message-Id: <20220811210605.402337-4-pbonzini@redhat.com>
In-Reply-To: <20220811210605.402337-1-pbonzini@redhat.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is currently returned via KVM_REQ_UNHALT, but this is completely
unnecessary since all that the callers do is clear the request; it
is never processed via the usual request loop.  The same condition
can be returned as a positive value from the functions.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h |  4 ++--
 virt/kvm/kvm_main.c      | 23 ++++++++++++++++++-----
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e7bd48d15db8..cbd9577e5447 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1338,8 +1338,8 @@ void kvm_gfn_to_pfn_cache_destroy(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
 
-void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
-void kvm_vcpu_block(struct kvm_vcpu *vcpu);
+int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
+int kvm_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1f049c1d01b4..e827805b7b28 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3402,6 +3402,12 @@ static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)
 	trace_kvm_halt_poll_ns_shrink(vcpu->vcpu_id, val, old);
 }
 
+/*
+ * Returns zero if the vCPU should remain in a blocked state,
+ * nonzero if it has been woken up, specifically:
+ * - 1 if it is runnable
+ * - -EINTR if it is not runnable (e.g. has a signal or a timer pending)
+ */
 static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 {
 	int ret = -EINTR;
@@ -3409,6 +3415,7 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 
 	if (kvm_arch_vcpu_runnable(vcpu)) {
 		kvm_make_request(KVM_REQ_UNHALT, vcpu);
+		ret = 1;
 		goto out;
 	}
 	if (kvm_cpu_has_pending_timer(vcpu))
@@ -3429,9 +3436,10 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
  * pending.  This is mostly used when halting a vCPU, but may also be used
  * directly for other vCPU non-runnable states, e.g. x86's Wait-For-SIPI.
  */
-void kvm_vcpu_block(struct kvm_vcpu *vcpu)
+int kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
+	int r;
 
 	vcpu->stat.generic.blocking = 1;
 
@@ -3443,7 +3451,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
-		if (kvm_vcpu_check_block(vcpu) < 0)
+		r = kvm_vcpu_check_block(vcpu);
+		if (r != 0)
 			break;
 
 		schedule();
@@ -3455,6 +3464,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	preempt_enable();
 
 	vcpu->stat.generic.blocking = 0;
+	return r;
 }
 
 static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
@@ -3485,12 +3495,13 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
  * expensive block+unblock sequence if a wake event arrives soon after the vCPU
  * is halted.
  */
-void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
+int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 {
 	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
 	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
 	ktime_t start, cur, poll_end, stop;
 	bool waited = false;
+	int r;
 	u64 halt_ns;
 
 	start = cur = poll_end = ktime_get();
@@ -3501,14 +3512,15 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 		 * This sets KVM_REQ_UNHALT if an interrupt
 		 * arrives.
 		 */
-		if (kvm_vcpu_check_block(vcpu) < 0)
+		r = kvm_vcpu_check_block(vcpu);
+		if (r != 0)
 			goto out;
 		cpu_relax();
 		poll_end = cur = ktime_get();
 	} while (kvm_vcpu_can_poll(cur, stop));
 
 	waited = true;
-	kvm_vcpu_block(vcpu);
+	r = kvm_vcpu_block(vcpu);
 
 	cur = ktime_get();
 	vcpu->stat.generic.halt_wait_ns +=
@@ -3547,6 +3559,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_vcpu_wakeup(halt_ns, waited, vcpu_valid_wakeup(vcpu));
+	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
 
-- 
2.31.1


