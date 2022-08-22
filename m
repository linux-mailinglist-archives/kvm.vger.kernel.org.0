Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E728259C4A1
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 19:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbiHVRHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 13:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237124AbiHVRHL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 13:07:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7FF41D38
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661188024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TyHada0raUNCUogve9BwWfj3PENoZbdYeleK1m5W+Z8=;
        b=HvII/ClnnCGmuJaJ4HBztLGfIJWiKi9/TfZuFF3/OQF+Gd7s+Q6h9oUXDf42CpR0PKVkBO
        cO5ryo9vO4xiZtE01qkSocJJULo9Wxc9uoUNqr/BVRmAASFVNUtdNpuskQ08FmIWmY/MV4
        GeKGRhC3kz9X2fK+VCt9XmYdZyznmg8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-5x66olPMP92rLP_GPoUwCQ-1; Mon, 22 Aug 2022 13:07:00 -0400
X-MC-Unique: 5x66olPMP92rLP_GPoUwCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 525D785829E;
        Mon, 22 Aug 2022 17:07:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 311DA945DB;
        Mon, 22 Aug 2022 17:07:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH v3 4/7] KVM: x86: lapic does not have to process INIT if it is blocked
Date:   Mon, 22 Aug 2022 13:06:56 -0400
Message-Id: <20220822170659.2527086-5-pbonzini@redhat.com>
In-Reply-To: <20220822170659.2527086-1-pbonzini@redhat.com>
References: <20220822170659.2527086-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not return true from kvm_apic_has_events, and consequently from
kvm_vcpu_has_events, if the vCPU is not going to process an INIT.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/i8259.c            | 4 ++--
 arch/x86/kvm/lapic.h            | 2 +-
 arch/x86/kvm/x86.c              | 5 +++++
 arch/x86/kvm/x86.h              | 5 -----
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f57ff10c3ae8..bf23cd9dea79 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2042,6 +2042,7 @@ void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 				     u32 size);
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu);
+bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu);
 
 bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			     struct kvm_vcpu **dest_vcpu);
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index e1bb6218bb96..619520322533 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -29,9 +29,9 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/bitops.h>
-#include "irq.h"
-
 #include <linux/kvm_host.h>
+
+#include "irq.h"
 #include "trace.h"
 
 #define pr_pic_unimpl(fmt, ...)	\
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 117a46df5cc1..12577ddccdfc 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -225,7 +225,7 @@ static inline bool kvm_vcpu_apicv_active(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_apic_has_events(struct kvm_vcpu *vcpu)
 {
-	return lapic_in_kernel(vcpu) && vcpu->arch.apic->pending_events;
+	return lapic_in_kernel(vcpu) && vcpu->arch.apic->pending_events && !kvm_vcpu_latch_init(vcpu);
 }
 
 static inline bool kvm_lowest_prio_delivery(struct kvm_lapic_irq *irq)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95035c029def..5c5341110876 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12572,6 +12572,11 @@ static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 		static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));
 }
 
+bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
+{
+	return is_smm(vcpu) || static_call(kvm_x86_apic_init_signal_blocked)(vcpu);
+}
+
 static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 {
 	if (!list_empty_careful(&vcpu->async_pf.done))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1926d2cb8e79..c333e7cf933a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -267,11 +267,6 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 	return !(kvm->arch.disabled_quirks & quirk);
 }
 
-static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
-{
-	return is_smm(vcpu) || static_call(kvm_x86_apic_init_signal_blocked)(vcpu);
-}
-
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 u64 get_kvmclock_ns(struct kvm *kvm);
-- 
2.31.1


