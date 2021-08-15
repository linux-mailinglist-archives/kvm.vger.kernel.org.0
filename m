Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7263EC667
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 03:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbhHOBCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 21:02:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235029AbhHOBCQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Aug 2021 21:02:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628989306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ey6yXOScHYh0PcQ56NM0udCScbc1zlyY/tqddfZR1RI=;
        b=IJtBWCCMSvaYCfry7rcaz+afEylKqNMOWbdwwriD8/Alyj+yIX7/LcXNG9B9zycgCZn4un
        R/Oa3494P2KfnKYn+0FFApwb/d2olhCCa2Pfkyp6at8Cs30Y0RiNvtoPyfhfYrkXjmzxjF
        4o8Nf9BNwsfKkfjgwbc3HP0qPG1Yxls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-FzoBqXizP4KRfo3u9dgdXQ-1; Sat, 14 Aug 2021 21:01:45 -0400
X-MC-Unique: FzoBqXizP4KRfo3u9dgdXQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD44A107ACF5;
        Sun, 15 Aug 2021 01:01:43 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43D3E6091B;
        Sun, 15 Aug 2021 01:01:27 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        james.morse@arm.com, mark.rutland@arm.com,
        Jonathan.Cameron@huawei.com, will@kernel.org, maz@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v4 02/15] KVM: async_pf: Add helper function to check completion queue
Date:   Sun, 15 Aug 2021 08:59:34 +0800
Message-Id: <20210815005947.83699-3-gshan@redhat.com>
In-Reply-To: <20210815005947.83699-1-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds inline helper kvm_check_async_pf_completion_queue() to
check if there are pending completion in the queue. The empty stub
is also added on !CONFIG_KVM_ASYNC_PF so that the caller needn't
consider if CONFIG_KVM_ASYNC_PF is enabled.

All checks on the completion queue is done by the newly added inline
function since list_empty() and list_empty_careful() are interchangeable.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/x86/kvm/x86.c       |  2 +-
 include/linux/kvm_host.h | 10 ++++++++++
 virt/kvm/async_pf.c      | 10 +++++-----
 virt/kvm/kvm_main.c      |  4 +---
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5d5c5ed7dd4..7f35d9324b99 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11591,7 +11591,7 @@ static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 {
-	if (!list_empty_careful(&vcpu->async_pf.done))
+	if (kvm_check_async_pf_completion_queue(vcpu))
 		return true;
 
 	if (kvm_apic_has_events(vcpu))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 85b61a456f1c..a5f990f6dc35 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -339,12 +339,22 @@ struct kvm_async_pf {
 	bool				notpresent_injected;
 };
 
+static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
+{
+	return !list_empty_careful(&vcpu->async_pf.done);
+}
+
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
 void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
 bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			unsigned long hva, struct kvm_arch_async_pf *arch);
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #else
+static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static inline void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu) { }
 #endif
 
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index dd777688d14a..d145a61a046a 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -70,7 +70,7 @@ static void async_pf_execute(struct work_struct *work)
 		kvm_arch_async_page_present(vcpu, apf);
 
 	spin_lock(&vcpu->async_pf.lock);
-	first = list_empty(&vcpu->async_pf.done);
+	first = !kvm_check_async_pf_completion_queue(vcpu);
 	list_add_tail(&apf->link, &vcpu->async_pf.done);
 	apf->vcpu = NULL;
 	spin_unlock(&vcpu->async_pf.lock);
@@ -122,7 +122,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 		spin_lock(&vcpu->async_pf.lock);
 	}
 
-	while (!list_empty(&vcpu->async_pf.done)) {
+	while (kvm_check_async_pf_completion_queue(vcpu)) {
 		struct kvm_async_pf *work =
 			list_first_entry(&vcpu->async_pf.done,
 					 typeof(*work), link);
@@ -138,7 +138,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 {
 	struct kvm_async_pf *work;
 
-	while (!list_empty_careful(&vcpu->async_pf.done) &&
+	while (kvm_check_async_pf_completion_queue(vcpu) &&
 	      kvm_arch_can_dequeue_async_page_present(vcpu)) {
 		spin_lock(&vcpu->async_pf.lock);
 		work = list_first_entry(&vcpu->async_pf.done, typeof(*work),
@@ -205,7 +205,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 	struct kvm_async_pf *work;
 	bool first;
 
-	if (!list_empty_careful(&vcpu->async_pf.done))
+	if (kvm_check_async_pf_completion_queue(vcpu))
 		return 0;
 
 	work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
@@ -216,7 +216,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
 
 	spin_lock(&vcpu->async_pf.lock);
-	first = list_empty(&vcpu->async_pf.done);
+	first = !kvm_check_async_pf_completion_queue(vcpu);
 	list_add_tail(&work->link, &vcpu->async_pf.done);
 	spin_unlock(&vcpu->async_pf.lock);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b50dbe269f4b..8795503651b1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3282,10 +3282,8 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
 	if (kvm_arch_dy_runnable(vcpu))
 		return true;
 
-#ifdef CONFIG_KVM_ASYNC_PF
-	if (!list_empty_careful(&vcpu->async_pf.done))
+	if (kvm_check_async_pf_completion_queue(vcpu))
 		return true;
-#endif
 
 	return false;
 }
-- 
2.23.0

