Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83D35907CE
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 23:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbiHKVGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 17:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbiHKVGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 17:06:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 251AC7B797
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 14:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660251970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z5V1ddQbf4lZG4s001LxFtCrBf7XQOvfCeCSjnlz2Rc=;
        b=RgsBRRQxIO8QdZwppkQZnWdoQH4jURoPLeftnyGG0KpXyewz3ETahihiNQwnDQ4QfzZprU
        YGUFTDG4c0CfC/8+ANcaQzsoC7rYDbSaGFsq5xeJCZypKdjx8sLsJxG+h47OmAnVEBnXpl
        OfVUckpNVub62TxHLz+1a5A7POOpv8Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-XehIE_7tN7eZgziV-1cAKw-1; Thu, 11 Aug 2022 17:06:07 -0400
X-MC-Unique: XehIE_7tN7eZgziV-1cAKw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2C48965C24;
        Thu, 11 Aug 2022 21:06:06 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CC75492C3B;
        Thu, 11 Aug 2022 21:06:06 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, mlevitsk@redhat.com, vkuznets@redhat.com
Subject: [PATCH v2 2/9] KVM: x86: remove return value of kvm_vcpu_block
Date:   Thu, 11 Aug 2022 17:05:58 -0400
Message-Id: <20220811210605.402337-3-pbonzini@redhat.com>
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

The return value of kvm_vcpu_block will be repurposed soon to return
the state of KVM_REQ_UNHALT.  In preparation for that, get rid of the
current return value.  It is only used by kvm_vcpu_halt to decide whether
the call resulted in a wait, but the same effect can be obtained with
a single round of polling.

No functional change intended, apart from practically indistinguishable
changes to the polling behavior.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 45 +++++++++++++++++-----------------------
 2 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1c480b1821e1..e7bd48d15db8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1339,7 +1339,7 @@ void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
 
 void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
-bool kvm_vcpu_block(struct kvm_vcpu *vcpu);
+void kvm_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 515dfe9d3bcf..1f049c1d01b4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3429,10 +3429,9 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
  * pending.  This is mostly used when halting a vCPU, but may also be used
  * directly for other vCPU non-runnable states, e.g. x86's Wait-For-SIPI.
  */
-bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
+void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
-	bool waited = false;
 
 	vcpu->stat.generic.blocking = 1;
 
@@ -3447,7 +3446,6 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_check_block(vcpu) < 0)
 			break;
 
-		waited = true;
 		schedule();
 	}
 
@@ -3457,8 +3455,6 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	preempt_enable();
 
 	vcpu->stat.generic.blocking = 0;
-
-	return waited;
 }
 
 static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
@@ -3493,35 +3489,32 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 {
 	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
 	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
-	ktime_t start, cur, poll_end;
+	ktime_t start, cur, poll_end, stop;
 	bool waited = false;
 	u64 halt_ns;
 
 	start = cur = poll_end = ktime_get();
-	if (do_halt_poll) {
-		ktime_t stop = ktime_add_ns(start, vcpu->halt_poll_ns);
+	stop = do_halt_poll ? start : ktime_add_ns(start, vcpu->halt_poll_ns);
 
-		do {
-			/*
-			 * This sets KVM_REQ_UNHALT if an interrupt
-			 * arrives.
-			 */
-			if (kvm_vcpu_check_block(vcpu) < 0)
-				goto out;
-			cpu_relax();
-			poll_end = cur = ktime_get();
-		} while (kvm_vcpu_can_poll(cur, stop));
-	}
+	do {
+		/*
+		 * This sets KVM_REQ_UNHALT if an interrupt
+		 * arrives.
+		 */
+		if (kvm_vcpu_check_block(vcpu) < 0)
+			goto out;
+		cpu_relax();
+		poll_end = cur = ktime_get();
+	} while (kvm_vcpu_can_poll(cur, stop));
 
-	waited = kvm_vcpu_block(vcpu);
+	waited = true;
+	kvm_vcpu_block(vcpu);
 
 	cur = ktime_get();
-	if (waited) {
-		vcpu->stat.generic.halt_wait_ns +=
-			ktime_to_ns(cur) - ktime_to_ns(poll_end);
-		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.generic.halt_wait_hist,
-				ktime_to_ns(cur) - ktime_to_ns(poll_end));
-	}
+	vcpu->stat.generic.halt_wait_ns +=
+		ktime_to_ns(cur) - ktime_to_ns(poll_end);
+	KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.generic.halt_wait_hist,
+				  ktime_to_ns(cur) - ktime_to_ns(poll_end));
 out:
 	/* The total time the vCPU was "halted", including polling time. */
 	halt_ns = ktime_to_ns(cur) - ktime_to_ns(start);
-- 
2.31.1


