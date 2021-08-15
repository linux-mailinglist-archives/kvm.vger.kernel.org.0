Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5997B3EC665
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 03:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbhHOBCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 21:02:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234547AbhHOBB7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Aug 2021 21:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628989290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wWP6RGsbS05Ong3eKswiduOpUs/hgQz8GgliHnHRYWU=;
        b=SRfaEMuD7ZUhDFwK1ZqY3QArxnCK9WZAt1/PU9zGDHVAJVsBNHv43QQyWwX+7CQspF2cgy
        ECgzGwALtlArkjNE0NIfijxrm1ZWVyKrcql424MrJOGT5lETXK0iqL3XekEMlZTc4vW0Ru
        IVsc9Z1fOTIaTwrot/ppr9k1I2sWtfA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-DdB0egO7MQa688jEAG9r8w-1; Sat, 14 Aug 2021 21:01:28 -0400
X-MC-Unique: DdB0egO7MQa688jEAG9r8w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34434801B3D;
        Sun, 15 Aug 2021 01:01:27 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE3606A05F;
        Sun, 15 Aug 2021 01:01:06 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        james.morse@arm.com, mark.rutland@arm.com,
        Jonathan.Cameron@huawei.com, will@kernel.org, maz@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v4 01/15] KVM: async_pf: Move struct kvm_async_pf around
Date:   Sun, 15 Aug 2021 08:59:33 +0800
Message-Id: <20210815005947.83699-2-gshan@redhat.com>
In-Reply-To: <20210815005947.83699-1-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This moves the definition of "struct kvm_async_pf" and the related
functions after "struct kvm_vcpu" so that newly added inline functions
in the subsequent patches can dereference "struct kvm_vcpu" properly.
Otherwise, the unexpected build error will be raised:

   error: dereferencing pointer to incomplete type ‘struct kvm_vcpu’
   return !list_empty_careful(&vcpu->async_pf.done);
                                   ^~
Since we're here, the sepator between type and field in "struct kvm_vcpu"
is replaced by tab. The empty stub kvm_check_async_pf_completion() is also
added on !CONFIG_KVM_ASYNC_PF, which is needed by subsequent patches to
support asynchronous page fault on ARM64.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 include/linux/kvm_host.h | 44 +++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae7735b490b4..85b61a456f1c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -199,27 +199,6 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 					 gpa_t addr);
 
-#ifdef CONFIG_KVM_ASYNC_PF
-struct kvm_async_pf {
-	struct work_struct work;
-	struct list_head link;
-	struct list_head queue;
-	struct kvm_vcpu *vcpu;
-	struct mm_struct *mm;
-	gpa_t cr2_or_gpa;
-	unsigned long addr;
-	struct kvm_arch_async_pf arch;
-	bool   wakeup_all;
-	bool notpresent_injected;
-};
-
-void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
-void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
-bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-			unsigned long hva, struct kvm_arch_async_pf *arch);
-int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
-#endif
-
 #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
 struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
@@ -346,6 +325,29 @@ struct kvm_vcpu {
 	struct kvm_dirty_ring dirty_ring;
 };
 
+#ifdef CONFIG_KVM_ASYNC_PF
+struct kvm_async_pf {
+	struct work_struct		work;
+	struct list_head		link;
+	struct list_head		queue;
+	struct kvm_vcpu			*vcpu;
+	struct mm_struct		*mm;
+	gpa_t				cr2_or_gpa;
+	unsigned long			addr;
+	struct kvm_arch_async_pf	arch;
+	bool				wakeup_all;
+	bool				notpresent_injected;
+};
+
+void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
+void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
+bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+			unsigned long hva, struct kvm_arch_async_pf *arch);
+int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
+#else
+static inline void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu) { }
+#endif
+
 /* must be called with irqs disabled */
 static __always_inline void guest_enter_irqoff(void)
 {
-- 
2.23.0

