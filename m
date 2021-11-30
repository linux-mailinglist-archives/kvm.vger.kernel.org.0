Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEC646348E
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 13:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241730AbhK3Ml0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 07:41:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241709AbhK3MlK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 07:41:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638275869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=b9RUc1KenMVYPgulRiVkI4pBlYROLXc+pKQPY3IUtvg=;
        b=DS5/HNAxPgTOP8UwhBpNS/OnhJtNpNSZEa2jFDtMS0wMaH+WTqWkUp5qiJHc63YGIbox88
        gvp502NdUbd9NBae0T9Gp/XVJ28q/0UZRgcBSSgv2EKEv0AzLKEatktAEKhT1w+cK3GegP
        zTT8zt6XO+Gpy8+eVwxT+RNfzIogT8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-VdZpJQ-IN02mMf2p80spig-1; Tue, 30 Nov 2021 07:37:48 -0500
X-MC-Unique: VdZpJQ-IN02mMf2p80spig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E9581018723;
        Tue, 30 Nov 2021 12:37:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E31ED10013D6;
        Tue, 30 Nov 2021 12:37:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Ignat Korchagin <ignat@cloudflare.com>
Subject: [PATCH] KVM: ensure APICv is considered inactive if there is no APIC
Date:   Tue, 30 Nov 2021 07:37:45 -0500
Message-Id: <20211130123746.293379-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vcpu_apicv_active() returns false if a virtual machine has no in-kernel
local APIC, however kvm_apicv_activated might still be true if there are
no reasons to disable APICv; in fact it is quite likely that there is none
because APICv is inhibited by specific configurations of the local APIC
and those configurations cannot be programmed.  This triggers a WARN:

   WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));

To avoid this, introduce another cause for APICv inhibition, namely the
absence of an in-kernel local APIC.  This cause is enabled by default,
and is dropped by either KVM_CREATE_IRQCHIP or the enabling of
KVM_CAP_IRQCHIP_SPLIT.

Reported-by: Ignat Korchagin <ignat@cloudflare.com>
Fixes: ee49a8932971 ("KVM: x86: Move SVM's APICv sanity check to common x86", 2021-10-22)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/avic.c         | 1 +
 arch/x86/kvm/vmx/vmx.c          | 1 +
 arch/x86/kvm/x86.c              | 9 +++++----
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6ac61f85e07b..860ed500580c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1036,6 +1036,7 @@ struct kvm_x86_msr_filter {
 #define APICV_INHIBIT_REASON_PIT_REINJ  4
 #define APICV_INHIBIT_REASON_X2APIC	5
 #define APICV_INHIBIT_REASON_BLOCKIRQ	6
+#define APICV_INHIBIT_REASON_ABSENT	7
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index affc0ea98d30..5a55a78e2f50 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -900,6 +900,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 bool svm_check_apicv_inhibit_reasons(ulong bit)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
+			  BIT(APICV_INHIBIT_REASON_ABSENT) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
 			  BIT(APICV_INHIBIT_REASON_NESTED) |
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1fadec8cbf96..ca1fd93c1dc9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7525,6 +7525,7 @@ static void hardware_unsetup(void)
 static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
+			  BIT(APICV_INHIBIT_REASON_ABSENT) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ee1a039b490..e0aa4dd53c7f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5740,6 +5740,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		smp_wmb();
 		kvm->arch.irqchip_mode = KVM_IRQCHIP_SPLIT;
 		kvm->arch.nr_reserved_ioapic_pins = cap->args[0];
+		kvm_request_apicv_update(kvm, true, APICV_INHIBIT_REASON_ABSENT);
 		r = 0;
 split_irqchip_unlock:
 		mutex_unlock(&kvm->lock);
@@ -6120,6 +6121,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		/* Write kvm->irq_routing before enabling irqchip_in_kernel. */
 		smp_wmb();
 		kvm->arch.irqchip_mode = KVM_IRQCHIP_KERNEL;
+		kvm_request_apicv_update(kvm, true, APICV_INHIBIT_REASON_ABSENT);
 	create_irqchip_unlock:
 		mutex_unlock(&kvm->lock);
 		break;
@@ -8818,10 +8820,9 @@ static void kvm_apicv_init(struct kvm *kvm)
 {
 	init_rwsem(&kvm->arch.apicv_update_lock);
 
-	if (enable_apicv)
-		clear_bit(APICV_INHIBIT_REASON_DISABLE,
-			  &kvm->arch.apicv_inhibit_reasons);
-	else
+	set_bit(APICV_INHIBIT_REASON_ABSENT,
+		&kvm->arch.apicv_inhibit_reasons);
+	if (!enable_apicv)
 		set_bit(APICV_INHIBIT_REASON_DISABLE,
 			&kvm->arch.apicv_inhibit_reasons);
 }
-- 
2.31.1

